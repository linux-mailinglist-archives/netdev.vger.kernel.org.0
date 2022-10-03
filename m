Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AB5F34A7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJCRiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJCRhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:37:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1A6332
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:37:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so10540394pjr.5
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 10:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=EtsGcYQ2hYsnLGIRLDK8RHNpJBn3J7IjnhcJ8rXtZ88=;
        b=QdO1w6zNxRtupb0V/8gy4wA6vSn2cwCQGQt0GvHae2vHo3/e3ewsf9I2tU8Rfn//oc
         vr/2byjPKIFjR2n5f0B5ZFJEM7JDtzEXCya35ckHH9iGPozys/V2iM/1NfH76s9wQnSP
         PFGsorB3ppmSrnDfP8473FgyCBEtHkVGpQaPhrhCM3fzhSqadzLQWkol+ZLPTDM6c09l
         T32Aod2gj+YFhXcFS1mfBiGBmbqqmM7UNx6/R4ZZK3LAi5F9CwpWRSBCJfShG5xhaDPC
         STYRNaJxr/ygcbp2zVfoe/WDdgqYahymUgsAs0tbGk1qSYjwSMrEBBxpySkyyuhNqBwn
         bUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EtsGcYQ2hYsnLGIRLDK8RHNpJBn3J7IjnhcJ8rXtZ88=;
        b=PItAiL/i7EA2F8U/qTMzKjeH+i8umGGcNOnOlSBi5jSh7SVSGkBt/J1lnlWh1PDF2X
         oVpIwms9ZrX0KqMQBp3ybXQQ3u5rUb1JdhBLMteWGeyeYsUO+Jg6YEHGNE7y/XZp963h
         LO3r62RMVBsLgXsj8kkCX/M8/DJYYjJKbShCHHz4INrv1yLgkV5huzwB73e0bcfPMnNX
         nybXhnJfCK9jlTzUTWW3KlyE4l6s+02qAyXZeDja/xjYPkXyWSli1q02CxVandmZI9bJ
         OnSGU5/TqnCgK29zHaRiY2XbP29OzCQavpJvDNI9aFrQIdYH7/Y1dhmlfdQkUodTTmZE
         vh5A==
X-Gm-Message-State: ACrzQf1Lp+LJ8dDVCQaRckNzDBUchvLnn3hjbsIg6vg59KLP5DUhRRpK
        dRqy+2ovWDi4g5zFF5WhIwAh8jG6LHma2A==
X-Google-Smtp-Source: AMsMyM4v8C2IR8UhJeqnPeiBnfSDFZRWag6UQWyE6f/pmY4ayrYjrXJKrEbJbeP9O5xtdqWiHwHHXw==
X-Received: by 2002:a17:902:8548:b0:179:e4db:42e0 with SMTP id d8-20020a170902854800b00179e4db42e0mr23217888plo.0.1664818631192;
        Mon, 03 Oct 2022 10:37:11 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903244800b00176683cde9bsm5059947pls.294.2022.10.03.10.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:37:10 -0700 (PDT)
Date:   Mon, 3 Oct 2022 10:37:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v2 0/9] ptp: convert drivers to .adjfine
Message-ID: <Yzsdwo+LGuW/t6HA@hoboy.vegasvil.org>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930204851.1910059-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 01:48:42PM -0700, Jacob Keller wrote:
> Many drivers implementing PTP have not yet migrated to the new .adjfine
> frequency adjustment implementation.
> 
> A handful of these drivers use hardware with a simple increment value which
> is adjusted by multiplying by the adjustment factor and then dividing by
> 1 billion. This calculation is very easy to convert to .adjfine, by simply
> updating the divisor.
> 
> Introduce new helper functions, diff_by_scaled_ppm and adjust_by_scaled_ppm
> which perform the most common calculations used by drivers for this purpose.

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
