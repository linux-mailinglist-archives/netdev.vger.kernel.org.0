Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA374C8C01
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiCAMvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiCAMvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:51:55 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7149986CB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:51:14 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o8so14325790pgf.9
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 04:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qkvrn2WObBzOZmmoswkTMdd18VdHq4sCFKdBiDnUsWw=;
        b=dQnyaoTCvgDcDMRAEj24m/V5PArv6khgwccBQjXSHcHlU7etPL1YmpO/K8SxmHXMrq
         c9XC1/E88GEho1Wb6TvIXdT7uMHay/Wp3yXY5yBWryf5odRpEPsO6B4qgyac8n11rK3N
         w2w9lIS1YiUEQYd5J5seaEEa+lpPKVQvco4DC0eDrgpccNdqgPbUROwfcvlwY0DIpfCJ
         tyr/HQWEVYGPohDTTcuUXl7+WO2e0wbmb0tKpzS3EgBxBP6sH5I6yoMSEk8OOLqf2ka8
         chFpn7dGJuS6JoL1E13hk7Bxi5VwF95I0VcNkZ9hSYmHletsrSbOPXmmrttsum9YkA9s
         2PoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qkvrn2WObBzOZmmoswkTMdd18VdHq4sCFKdBiDnUsWw=;
        b=GH0/slrA6psYwTqkhJi4oMYtCFOCUZMjVTZa0wtnE09/qbc21PrTV5eTiNeFUC+S1Z
         pW6M3TMUdNNI3lR99BjAGx4MIAk9cLcbRaNvZK+AfX1fH6Fz2/dKc4bW14Mv3iyi/J4R
         3SaTxuqFzl/hJqdEuV6f7dKu4m8IxBp9x/R1/qRhn+j1aPihBsgdTF+Aifg3wcAlX+WE
         9lT7cEVddBaBIAJ/zEniYnUk2fZhxljBRyKRuCF3GpzvA4bwahnIzi/0El7r6G1z+RhZ
         CfQ+rUVmuBg0vAxwbcvbjv77kSwoLCTmgeCbgGXqXL+/nJqxbULt7daxNqSMLmt3LEDw
         ZzAA==
X-Gm-Message-State: AOAM532zVqW768kFKqQDea8QDh3R8N1r3zaGzoAQO5v/w5w6TZ/Kt4yN
        ZQNiCyymQ6217K8N/9uNglU=
X-Google-Smtp-Source: ABdhPJxhq7ZqKJBl17l71dtxf8soJKxESmplI2lWRcQXEWEJI6nKxN79fdt0dGULz3uuykLGFowMNw==
X-Received: by 2002:a63:2fc1:0:b0:374:9f30:9559 with SMTP id v184-20020a632fc1000000b003749f309559mr21654441pgv.278.1646139074183;
        Tue, 01 Mar 2022 04:51:14 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm16448443pfh.46.2022.03.01.04.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:51:13 -0800 (PST)
Date:   Tue, 1 Mar 2022 04:51:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
Message-ID: <20220301125111.GB14297@hoboy.vegasvil.org>
References: <20220228203957.367371-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228203957.367371-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:39:57PM -0800, Jonathan Lemon wrote:
> In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
> ns adjustment was written to the FPGA register, so the clock could
> accurately perform adjustments.
> 
> However, the adjtime() call passes in a s64, while the clock adjustment
> registers use a s32.  When trying to perform adjustments with a large
> value (37 sec), things fail.
> 
> Examine the incoming delta, and if larger than 1 sec, use the original
> (coarse) adjustment method.  If smaller than 1 sec, then allow the
> FPGA to fold in the changes over a 1 second window.
> 
> Fixes: 6d59d4fa1789 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
