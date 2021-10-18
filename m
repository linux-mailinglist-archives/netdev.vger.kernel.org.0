Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC6430DDC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 04:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbhJRCgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 22:36:43 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:34066 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhJRCgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 22:36:43 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 0F3A692009C; Mon, 18 Oct 2021 04:34:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 0885992009B;
        Mon, 18 Oct 2021 04:34:29 +0200 (CEST)
Date:   Mon, 18 Oct 2021 04:34:28 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/11] fddi: use eth_hw_addr_set()
In-Reply-To: <20211001213228.1735079-11-kuba@kernel.org>
Message-ID: <alpine.DEB.2.21.2110180427110.31442@angie.orcam.me.uk>
References: <20211001213228.1735079-1-kuba@kernel.org> <20211001213228.1735079-11-kuba@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021, Jakub Kicinski wrote:

> diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
> index cc5126ea7ef5..652cb174302e 100644
> --- a/drivers/net/fddi/skfp/skfddi.c
> +++ b/drivers/net/fddi/skfp/skfddi.c
> @@ -433,7 +434,7 @@ static  int skfp_driver_init(struct net_device *dev)
>  	}
>  	read_address(smc, NULL);
>  	pr_debug("HW-Addr: %pMF\n", smc->hw.fddi_canon_addr.a);
> -	memcpy(dev->dev_addr, smc->hw.fddi_canon_addr.a, ETH_ALEN);
> +	eth_hw_addr_set(dev, smc->hw.fddi_canon_addr.a);

 Hmm, it looks to me like this ought to be abstracted somehow even if it 
ultimately expanded to exactly the same code; note that FDDI_K_ALEN should 
have been used in original code.  Not functionally incorrect however, so I 
guess no need to rush cleaning up.

  Maciej
