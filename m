Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A434643D0D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiLFGQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiLFGQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:16:18 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F61A275D4;
        Mon,  5 Dec 2022 22:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670307377; x=1701843377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F3iVR1JKaoTgXLtkX2Mixb3MKbMl1CXpDuFVhXJAPHg=;
  b=EdLCW/dRnstNbISJBX3qFUZ2PGpTYvItciqIOP1bZve8QRRSRu38qeQg
   URtHZM9/SYQjTeHXdQVUmRa1lTujr+jJK6z3zhCmXPLJHLCO/AKgl6k5o
   ahhXZA8FS5sDgg18qODenhhDJRWcXKz62hgwatXVpi8DFAtxRkrrd2KTE
   ch36F+eqamjhXNMLEOQQ711PeAmDpRlrWgH0tYJapdWyC1Px/HnYh050Z
   jKk4mOysZe/11UbwgSB96SgoWDrbSZa6Pk+t2W0yOfHOdnP+YEUQ9yzbm
   s0RptB/5Ln3bYTmhI75iGkDYP16uO6iMyWsQWDQ3lrJp+h6Jt1WUkYyT9
   w==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665439200"; 
   d="scan'208";a="27769770"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 06 Dec 2022 07:16:15 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 06 Dec 2022 07:16:15 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 06 Dec 2022 07:16:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670307375; x=1701843375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F3iVR1JKaoTgXLtkX2Mixb3MKbMl1CXpDuFVhXJAPHg=;
  b=oeBCqYsFYDBRLBEqFAyc2zDdFlKZYJuLGKBcFB6vWi5CyQg1f2b7AvZ+
   8bCPx3MlSToDpbQSFNWyVs+fYRnNtdJuJ8R5UFD2NuO31PCyrGyFWooeF
   w9TvSA+U5Er90WcRaaG9kEspJxfMFpmUw5FY7cLkVwDLdOy3+QOb70cxS
   u7fXbN8JAzFrSryW5jQiMGsbewOrQj+APoG1GCpZZPeDKtBs62bOeVxqP
   qENT1msGHc3kqt0ejNYIwPU6WRkbLWl411DH6yprz7KoP8+4NRHBUc/MP
   HFCO82Eo9VHa60WalLKpCqmZYLFvdBIM5daNxAAv5eNcU5zcCbbS1C5nh
   g==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665439200"; 
   d="scan'208";a="27769769"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 06 Dec 2022 07:16:15 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 41117280071;
        Tue,  6 Dec 2022 07:16:15 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Ungerer <gregungerer@westnet.com.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: properly guard irq coalesce setup
Date:   Tue, 06 Dec 2022 07:16:10 +0100
Message-ID: <2661485.mvXUDI8C0e@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
References: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, 5. Dezember 2022, 21:46:04 CET schrieb Rasmus Villemoes:
> Prior to the Fixes: commit, the initialization code went through the
> same fec_enet_set_coalesce() function as used by ethtool, and that
> function correctly checks whether the current variant has support for
> irq coalescing.
> 
> Now that the initialization code instead calls fec_enet_itr_coal_set()
> directly, that call needs to be guarded by a check for the
> FEC_QUIRK_HAS_COALESCE bit.
> 
> Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to defaults
> on "ip link up") Reported-by: Greg Ungerer <gregungerer@westnet.com.au>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c index
> 2ca2b61b451f..23e1a94b9ce4 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1220,7 +1220,8 @@ fec_restart(struct net_device *ndev)
>  		writel(0, fep->hwp + FEC_IMASK);
> 
>  	/* Init the interrupt coalescing */
> -	fec_enet_itr_coal_set(ndev);
> +	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
> +		fec_enet_itr_coal_set(ndev);
>  }
> 
>  static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)

I'm wondering if this check should be added to fec_enet_itr_coal_set() 
instead. Right now any additional caller has to do it's own check for 
FEC_QUIRK_HAS_COALESCE, so why not do check in fec_enet_itr_coal_set?
But I'm okay with this change as well.

Best regards,
Alexander


