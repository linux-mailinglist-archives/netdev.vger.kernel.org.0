Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC7B3D4F7A
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 20:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhGYRoI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Jul 2021 13:44:08 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:27397 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhGYRoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 13:44:08 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GXs0P1tWPzBCTT;
        Sun, 25 Jul 2021 20:24:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jkng_VejQV9Y; Sun, 25 Jul 2021 20:24:37 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GXs0P0xWCzBCTJ;
        Sun, 25 Jul 2021 20:24:37 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 69C8D3B5; Sun, 25 Jul 2021 20:29:54 +0200 (CEST)
Received: from 37-165-12-41.coucou-networks.fr
 (37-165-12-41.coucou-networks.fr [37.165.12.41]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 25 Jul 2021 20:29:54 +0200
Date:   Sun, 25 Jul 2021 20:29:54 +0200
Message-ID: <20210725202954.Horde.bRFhkpxqK_S2oN3y1Mj0pA1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 09/10] net/ps3_gelic: Add new routine
 gelic_work_to_card
References: <cover.1627068552.git.geoff@infradead.org>
 <5634f7c76a67345c9735e05b68228ea899a8bf9d.1627068552.git.geoff@infradead.org>
In-Reply-To: <5634f7c76a67345c9735e05b68228ea899a8bf9d.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> Add new helper routine gelic_work_to_card that converts a work_struct
> to a gelic_card.

Adding a function is it really needed as it is used only once ?

Christophe

>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 60fcca5d20dd..42f4de9ad5fe 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -1420,6 +1420,11 @@ static const struct ethtool_ops  
> gelic_ether_ethtool_ops = {
>  	.set_link_ksettings = gelic_ether_set_link_ksettings,
>  };
>
> +static struct gelic_card *gelic_work_to_card(struct work_struct *work)
> +{
> +	return container_of(work, struct gelic_card, tx_timeout_task);
> +}
> +
>  /**
>   * gelic_net_tx_timeout_task - task scheduled by the watchdog timeout
>   * function (to be called not under interrupt status)
> @@ -1429,8 +1434,7 @@ static const struct ethtool_ops  
> gelic_ether_ethtool_ops = {
>   */
>  static void gelic_net_tx_timeout_task(struct work_struct *work)
>  {
> -	struct gelic_card *card =
> -		container_of(work, struct gelic_card, tx_timeout_task);
> +	struct gelic_card *card = gelic_work_to_card(work);
>  	struct net_device *netdev = card->netdev[GELIC_PORT_ETHERNET_0];
>  	struct device *dev = ctodev(card);
>
> --
> 2.25.1


