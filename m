Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5063C87DB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhGNPmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:42:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhGNPmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 11:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iXlJK4yq9w48JGg+FZEsnZ7jfqJ1YcqG77mZJHNmuCo=; b=eHZ9V+lHdRtukaVg8f9GJvaxTC
        4JPmndMdZMkxsy9wD9k0YB1Sx2vxihKkLmDFCUOjuUxTcDPckb2q6h85SnaTRZGJ3BhAMpx2LlSxi
        6Wz1nezy7AgvcA8y/UTdbu2B+6lfbklp9UOnWLiILCOG/masPzBu3f9UWqm1QCIuHftg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3gyZ-00DMz3-C6; Wed, 14 Jul 2021 17:39:07 +0200
Date:   Wed, 14 Jul 2021 17:39:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit
 Ethernet driver
Message-ID: <YO8FG0zJoG3GI9S9@lunn.ch>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-2-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714145408.4382-2-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 03:54:07PM +0100, Biju Das wrote:
> The DMAC and EMAC blocks of Gigabit Ethernet IP is almost
> similar to Ethernet AVB. With few canges in driver we can

changes

> support both the IP. This patch is in preparation for
> supporting the same.

Please break this up a bit, it is hard to review. You can put all the
refactoring into helpers into one patch. But changes like

> -			if (priv->chip_id == RCAR_GEN2) {
> +			if (priv->chip_id != RCAR_GEN3) {

should be in a seperate patch with an explanation.

You are aiming for lots of very simple patches which are obviously
correct.

> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 86a1eb0634e8..80e62ca2e3d3 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -864,7 +864,7 @@ enum GECMR_BIT {
>  
>  /* The Ethernet AVB descriptor definitions. */
>  struct ravb_desc {
> -	__le16 ds;		/* Descriptor size */
> +	__le16 ds;	/* Descriptor size */
>  	u8 cc;		/* Content control MSBs (reserved) */
>  	u8 die_dt;	/* Descriptor interrupt enable and type */
>  	__le32 dptr;	/* Descriptor pointer */

Please put white spaces changes in a patch of its own.

       Andrew
