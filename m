Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77170139E78
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 01:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgANAnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 19:43:31 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39363 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728641AbgANAna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 19:43:30 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 927D44F1;
        Mon, 13 Jan 2020 19:43:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 13 Jan 2020 19:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=6etDPgWlryGvYGlPpSZPyzq7P7
        lk1NK9CB5lkNHHVAQ=; b=JMwSzFLZfwxDtciiJAg2SXrr9JbjFywZ/QhfmP3B0e
        b7vYZ78O730RDsQooxrcWQNNswV7wogCeltDuQ7F2j1SKIS7nKYoooJzuR5e0H8q
        Ub3GgBR5l+E256tqMua5jfIhB44m370wfdeXs0sE1MzFT00KH8nhn4RM6qYXKjsX
        n+Lu63A3fuRu4FbE0Pr6JpK4k2zcTHcLxd+luzngYRdaXbg+LaUY089YulKmaoiU
        M4idDBWN+D92exZaLULzfU2PMOn8j2WJ3tqxS8k7vQcaiuxvbI/PYxHoJy2KDM5/
        YvaHtfb+Imyo7w5lfvXYHOCeXz80khiA9NylDMVMIETA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=6etDPgWlryGvYGlPpSZPyzq7P7lk1NK9CB5lkNHHV
        AQ=; b=FpTO6YtBfivj7DTtr6tAwdrY1KDnPXfh4/ht0NQ8JRFamE4Z6zAfTCdMC
        DbP4PY6c+eL6FwRqYUmxlbyQNBQSOgMkvjB3nEkrmNqd20eC78ie2oeqdxi92r7B
        LRDow3Wg7lv6xheZyUuKuOSXoL+SC8g4xluQ/POxlJ2FUv6fi0tlQucyuMqesGxi
        gn+WzcbsNsAz7nEU1WK+5ferqjYfp2L55ic+zSXdRuKUCbfukMleYKPb1r7NEWBm
        NY9zt/2GN1vnGsHrqRWtmjQfxjrBT2YegISm8cEtT8Am/yCNU/Xhns/clg4TLiMI
        nYH9ThlWqOyJwhbSd/3vHcoCcRW5Q==
X-ME-Sender: <xms:sA4dXlB4MDPiCQPUm_2B18gq8u3LkeU2BXJt-zfQXzJWNggq4K51cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtofgggfesthejredtredtjeenucfhrhhomhepshgrmhhj
    ohhnrghsuceoshgrmhesmhgvnhguohiirghjohhnrghsrdgtohhmqeenucffohhmrghinh
    epohhpvghrrghtihhnghdrtggrthenucfkphepheegrddvgedtrdduleefrddunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehsrghmsehmvghnughoiigrjhhonhgrshdrtghomhenuc
    evlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:sA4dXpAQ2kk6qxN8oiv4g91izYNIsJ29lcgTKSZUUU_fT90d122jFg>
    <xmx:sA4dXjTX_Jsaa4uRX0UlFnKMPTy81pZ4-HWxTkbgC90GFTPienGdYg>
    <xmx:sA4dXtLYHhBwGGQhCYEm5MkLWCiAmVxGG4TsG1o_Vc1HLcNlVdzO4w>
    <xmx:sQ4dXo8qkhi-jYZdEUefVki0tLlTF_2LyYWqwLtLZK7di02wLidlSw>
Received: from cdg1-dhcp-7-191.amazon.fr (unknown [54.240.193.1])
        by mail.messagingengine.com (Postfix) with ESMTPA id F146A80060;
        Mon, 13 Jan 2020 19:43:21 -0500 (EST)
Message-ID: <20b75baf4fa6781278614162b05918dcdedd2e29.camel@mendozajonas.com>
Subject: Re: [PATCH] Propagate NCSI channel carrier loss/gain events to the
 kernel
From:   samjonas <sam@mendozajonas.com>
To:     Johnathan Mantey <johnathanx.mantey@intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net
Date:   Mon, 13 Jan 2020 16:43:13 -0800
In-Reply-To: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
References: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-01-10 at 14:02 -0800, Johnathan Mantey wrote:
> From 76d99782ec897b010ba507895d60d27dca8dca44 Mon Sep 17 00:00:00
> 2001
> From: Johnathan Mantey <johnathanx.mantey@intel.com>
> Date: Fri, 10 Jan 2020 12:46:17 -0800
> Subject: [PATCH] Propagate NCSI channel carrier loss/gain events to
> the
> kernel
> 
> Problem statement:
> Insertion or removal of a network cable attached to a NCSI controlled
> network channel does not notify the kernel of the loss/gain of the
> network link.
> 
> The expectation is that /sys/class/net/eth(x)/carrier will change
> state after a pull/insertion event. In addition the carrier_up_count
> and carrier_down_count files should increment.
> 
> Change statement:
> Use the NCSI Asynchronous Event Notification handler to detect a
> change in a NCSI link.
> Add code to propagate carrier on/off state to the network interface.
> The on/off state is only modified after the existing code identifies
> if the network device HAD or HAS a link state change.

If we set the carrier state off until we successfully configured a
channel could we avoid this limitation?

Cheers,
Sam

> 
> Test procedure:
> Connected a L2 switch with only two ports connected.
> One port was a DHCP corporate net, the other port attached to the
> NCSI
> controlled NIC.
> 
> Starting with the L2 switch with DC on, check to make sure the NCSI
> link is operating.
> cat /sys/class/net/eth1/carrier
> 1
> cat /sys/class/net/eth1/carrier_up_count
> 0
> cat /sys/class/net/eth1/carrier_down_count
> 0
> 
> Remove DC from the L2 switch, and check link state
> cat /sys/class/net/eth1/carrier
> 0
> cat /sys/class/net/eth1/carrier_up_count
> 0
> cat /sys/class/net/eth1/carrier_down_count
> 1
> 
> Restore DC to the L2 switch, and check link state
> cat /sys/class/net/eth1/carrier
> 1
> cat /sys/class/net/eth1/carrier_up_count
> 1
> cat /sys/class/net/eth1/carrier_down_count
> 1
> 
> Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
> ---
>  net/ncsi/ncsi-aen.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
> index b635c194f0a8..274c415dcead 100644
> --- a/net/ncsi/ncsi-aen.c
> +++ b/net/ncsi/ncsi-aen.c
> @@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct
> ncsi_dev_priv
> *ndp,
>      if ((had_link == has_link) || chained)
>          return 0;
>  
> +    if (had_link) {
> +        netif_carrier_off(ndp->ndev.dev);
> +    } else {
> +        netif_carrier_on(ndp->ndev.dev);
> +    }
> +
>      if (!ndp->multi_package && !nc->package->multi_channel) {
>          if (had_link) {
>              ndp->flags |= NCSI_DEV_RESHUFFLE;

