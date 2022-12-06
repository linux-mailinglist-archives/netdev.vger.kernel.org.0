Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA6643FF2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiLFJiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiLFJiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:38:13 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F6FF5BE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:38:11 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id r7-20020a1c4407000000b003d1e906ca23so260913wma.3
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJdQN0Q8e0RJELdH1l8XWZ/6wp/D1WGstyslfHn30Fg=;
        b=mpOkzYjwPVOOCTXcH4xOGa5HFMg73XBVZhKcq0hBPq2K+A2u3BALQYFMI55LlPr+Nc
         J1r0PwjBznpMK+P0w7UR1dMZ65M5yBXlp+M5kTjz8w6CkRrt7o/DQ37KoEA4qaFUkOYe
         8h57wQPIdGv0betdp8rw16JjhBdc39owK76syltoHhi7CSLgBVDkwgs2NwtXA8bpHMOY
         1izoLdtunzijKRwCADDDV/JMKRrWZyuLwMYZqsGeg5ga3YndZxkLt3UnnkKHP0mxpu4/
         yicTB+5umq5jPsBWMJ83IwEyEv/JSbGwmIWSV8D/MMx7YfBdIODDqM7WINiw/6R38V6h
         sQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJdQN0Q8e0RJELdH1l8XWZ/6wp/D1WGstyslfHn30Fg=;
        b=I2B4VTcS8xbHNsE0NDiDQtY9iWRevhwfthsLU4rawKN4PsbC9QvTVK2YIlM6oB7N1S
         aDdtbgHxZF1EATiA8VpsqV7aQ8UJReSbxUT99RYSJzXtEkoG1N3BwSHzaavPZIsiSBMb
         W+9EzALJMk6Fzn6X9Vsdu4E30AN+VzOaknsZHYCh1Mz7/5evg9nzDns9AdltuZ+bL5V8
         4yFZEff46g38vPc3CrquIj9muZkkvefQYKA26vyuqAw9Oh8ZLOq0V0st/mTybHPHaz7b
         6/0Kr8aep6GI3SzHeL+MSuLE4kvLxB1TuX3jAjDrx7HbuBvw4elpShhcMY5ariyrBKMv
         9EqA==
X-Gm-Message-State: ANoB5pnnnLob4/lvTKlWWziWT6yCh/PETzpCYCB/1rLgk3aruioN/rC6
        diDW5+lIMLJPbTlH2k7V+m8ujQ==
X-Google-Smtp-Source: AA0mqf7QrtxRVj2Lv/adlCJ56htGlDGqwKrbQ8suOcINSckAYeAXGEuL7dn5lo31WoBgPwB7QFwtXg==
X-Received: by 2002:a05:600c:3514:b0:3cf:e0ef:1f6c with SMTP id h20-20020a05600c351400b003cfe0ef1f6cmr54664412wmq.75.1670319489790;
        Tue, 06 Dec 2022 01:38:09 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c3b8900b003d1e1f421bfsm5022207wms.10.2022.12.06.01.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:38:09 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:38:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, michael.jamet@intel.com,
        mika.westerberg@linux.intel.com, YehezkelShB@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net v2] net: thunderbolt: fix memory leak in tbnet_open()
Message-ID: <Y48Nf4OkBbaVgw4C@nanopsycho>
References: <20221206010646.3552313-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206010646.3552313-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 02:06:46AM CET, shaozhengchao@huawei.com wrote:
>When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.

You should be imperative to the codebase in your patch descriptions.

The code fix looks okay.

>
>Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
>Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>---
>v2: move release ida before free tx_ring
>---
> drivers/net/thunderbolt.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
>index a52ee2bf5575..6312f67f260e 100644
>--- a/drivers/net/thunderbolt.c
>+++ b/drivers/net/thunderbolt.c
>@@ -914,6 +914,7 @@ static int tbnet_open(struct net_device *dev)
> 				eof_mask, tbnet_start_poll, net);
> 	if (!ring) {
> 		netdev_err(dev, "failed to allocate Rx ring\n");
>+		tb_xdomain_release_out_hopid(xd, hopid);
> 		tb_ring_free(net->tx_ring.ring);
> 		net->tx_ring.ring = NULL;
> 		return -ENOMEM;
>-- 
>2.34.1
>
