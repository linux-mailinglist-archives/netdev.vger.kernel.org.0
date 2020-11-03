Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33E2A4CCE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgKCR1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCR1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:27:44 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42D3C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:27:44 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so23505505ejb.7
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=goJyBGc/9lpstUUyzYhttl/flQVCi9q27C8UA+cdDYo=;
        b=lB+4RK8zftqkngCODPpZEt0wRGqOBKvA3MfMM/vtcLUKPgHEK0nGiQtexLlNcmlaSN
         Sz4rtVisd0cBN8OklMqn8sewXZpveIkdMqm66+KvVfpgwvKupmetNANrn7Pb3fTYkYUo
         2aniPs0tZOaYHBsYQvC+cAmGEFxlxjV2inkpKQJ/aGdaj3HTKTYzoljv/202H5z8vwd9
         7lM9nGV4lsSvUuTWxaNzEFgqF5+NjjiDcltyJ3KwbXuPXHbwrBiYSMrw0pmGtutBkvZc
         9oBtoIeWNQl+ReehJMcaYzp71GFT3mjHLhPt5zJNGCIJp2p0Ot7tUlLfm9gkpMtFhjmj
         28Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=goJyBGc/9lpstUUyzYhttl/flQVCi9q27C8UA+cdDYo=;
        b=iEj1ryHxSnCgbCz2Rc/dhdsMapbRx30szf/tX3yqIL+miHWcaZk3RzErSeQEze95xL
         fZouyhzFp/w1BRJdb8PjFR9ZyT3Nhb4nEfIpxgAcjsRsTdFZEDQuvCquh8RRhAlNlnMf
         Kk0cpehDA027ExHHmYf8cDBGmxYp9pS0dtVQVz7BOIRzejDMpLTXvcetl3Wrn4427mu4
         2zkJ2/ulPvoP+4kfzxgtRnnuOv08A6zC2qmI6zRo5YXq/kjACclj4Gv4YeLuyvKCg4+X
         yM+B1BPbIEb+5lVZuTq4F5Fb0hOCJShakWPNQSBmy2zIv0fZAZkDCfUJ/vztU7TbChZE
         LcAw==
X-Gm-Message-State: AOAM531gkD8SsGGScr3Nh0ID0kk3bWyzCXUxVlpLlv2dOnaWw6ShBeeE
        FutD22Ay9j4aeHzcOzWn1zLCmECsfDs=
X-Google-Smtp-Source: ABdhPJx1jJnyqU4oj4SUj31PvkBZkCNlSf4OQQ+2kghJrrdE/01nzKMg1XwunyRiL1M7qmeBanjECQ==
X-Received: by 2002:a17:906:134e:: with SMTP id x14mr21521095ejb.173.1604424463188;
        Tue, 03 Nov 2020 09:27:43 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id nd5sm10889803ejb.37.2020.11.03.09.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:27:42 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:27:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103172741.iia5joaxeww6c454@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
 <20201103171849.vthpu7beenzeayrs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103171849.vthpu7beenzeayrs@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 07:18:49PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 06:36:30PM +0200, Julian Wiedmann wrote:
> > Given the various skb modifications in its xmit path, I wonder why
> > gianfar doesn't clear IFF_TX_SKB_SHARING.
> 
> Thanks for the hint Julian :) I'll try to see if it makes any
> difference.

And unsurprisingly given what Jakub said, it crashed again, even with
this change.

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 41dd3d0f3452..7cc8986910f8 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3337,6 +3337,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	dev->mtu = 1500;
 	dev->min_mtu = 50;
 	dev->max_mtu = GFAR_JUMBO_FRAME_SIZE - ETH_HLEN;
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops = &gfar_netdev_ops;
 	dev->ethtool_ops = &gfar_ethtool_ops;
 
