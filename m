Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC9E599642
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346948AbiHSHjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346839AbiHSHjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:39:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C41D0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:39:11 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z16so4187414wrh.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mpsHvL2qXGb0RmLNdPbPO9broMYHEUq5n/e00tNUUkA=;
        b=DBYeN1bqoDuZSFEy24nBSZ7hryTLJ8LGxFQwpn+FA+5WYUgZa+e09bPCCbdK7lm2Zx
         1/EVKlYbMihxIGPpYZX7AHkxKFRcL4kgYNS/lQJI5fAXBGmBlJjThTRgpoLnG85tkFro
         ZLiJLEivpfj4gZ4T37aPwm8AYaf9kzUc6bPCMwBAbsHuM92V7w9VIJl1MF9jYc/acPC8
         zD75Z2b1I4OXml6Mj7defYh4bY8a9X4zs1up7IGAHcUmjqXLLuRK1Bd2P27TofhMQR9E
         k6gFooQp7IdMJ8nk+srKpV66s5gDbd07OQujWSzSThJpp2cBeCkOIHigqMlcBdRCS0m6
         QrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mpsHvL2qXGb0RmLNdPbPO9broMYHEUq5n/e00tNUUkA=;
        b=LYFM4scpjaQ6MubWhtXJKM8fopNiqzwNy/tMjrGduqQiOpeV0CsNnhIo2MlAaUJDsr
         k30k6MLr+UCUO1tYVZbD6iv4hzpIa5Zs3eZT/ZlGa8Jv1wCni5zP9CI1R75vtir27unq
         7n1BuYwl/P3qxZwpJ7/HPiIKbYBrWk8gYm09ImRkw/708IzaSRZMRfpyvHNUJNR2EexD
         Xjcu+8AMx0ValWNnBRBXrHbq3lmtsTTRiiHydxCejGpvliEFDHjFKQ45DjNANiuzOS9c
         jFXDGnCW9irw5UcdZHCJvmrSqakd7E2s/xm2G5rbpKcwlm8CvcLZHjC+HO1JkXJep7nl
         5umQ==
X-Gm-Message-State: ACgBeo0TCaAbrm42I7QgaELxfmcSAC2FAmDbjtsyonHKkGG8YdIoT/Xs
        OVeJ1s0WMdysRSxEN126Jdg=
X-Google-Smtp-Source: AA6agR58xtDTV4JRdRCqRZMt29HJLeb2ynudzkyOf5R84OqHdSSasW7+OBo1QkqT+qsY4HAvC/I+ow==
X-Received: by 2002:a05:6000:186e:b0:222:3d1b:29d1 with SMTP id d14-20020a056000186e00b002223d1b29d1mr3327112wri.108.1660894749853;
        Fri, 19 Aug 2022 00:39:09 -0700 (PDT)
Received: from hoboy.vegasvil.org ([185.228.40.98])
        by smtp.gmail.com with ESMTPSA id bg24-20020a05600c3c9800b003a38606385esm2988036wmb.3.2022.08.19.00.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 00:39:09 -0700 (PDT)
Date:   Fri, 19 Aug 2022 00:39:05 -0700
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
Subject: Re: [net-next 00/14] ptp: convert drivers to .adjfine
Message-ID: <Yv8+GdoEEIPpSYJB@hoboy.vegasvil.org>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818222742.1070935-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 03:27:28PM -0700, Jacob Keller wrote:
> Many drivers implementing PTP have not yet migrated to the new .adjfine
> frequency adjustment implementation.

The re-factoring looks like it will remove much duplicated code.
I guess you tested the Intel drivers yourself?

The other drivers want sanity testing to make sure nothing broke.

I'm on vacation until Monday, but I can test cpts on BBB then.

Thanks,
Richard
