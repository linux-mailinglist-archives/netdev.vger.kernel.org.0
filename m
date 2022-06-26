Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ACD55B173
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiFZLIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 07:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiFZLIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 07:08:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8648E0F3;
        Sun, 26 Jun 2022 04:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vKlqoyPKnKslJ3wEQV5XgtBsGKT7Vr7TM/ONNoU26hs=; b=EP4bnODZX7LCzr5lCEmixTYieF
        l5C7rTx7H45kcVY+a0ztUc+QVg9w21CGmdESZvJfkJhJD6Dulky2d5wGGDP//NEziZmwqSabEEaRl
        wskpkWRfQ0/fTaQIXyVlWEAToM0FWs7ycXPXIZh+wmHJbiRzya0ub39zRKbMyq011EL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o5Q85-008Hrf-7X; Sun, 26 Jun 2022 13:08:37 +0200
Date:   Sun, 26 Jun 2022 13:08:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Praghadeesh T K S <praghadeeshthevendria@gmail.com>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        praghadeeshtks@zohomail.in,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: ethernet/nvidia: fix possible condition with no
 effect
Message-ID: <Yrg+NZHBNcu3KFXn@lunn.ch>
References: <20220626103539.80283-1-praghadeeshthevendria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220626103539.80283-1-praghadeeshthevendria@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 10:35:39AM +0000, Praghadeesh T K S wrote:
> Fix Coccinelle bug, removed condition with no effect.

This is not a coccinelle bug. If it was, you would be patching
coccinelle, not the kernel.

> Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 5116bad..8e49cfa 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -3471,9 +3471,6 @@ static int nv_update_linkspeed(struct net_device *dev)
>  	} else if (adv_lpa & LPA_10FULL) {
>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 1;
> -	} else if (adv_lpa & LPA_10HALF) {
> -		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
> -		newdup = 0;
>  	} else {
>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 0;

Please google this, see the past discussion about why this code is
there.

	Andrew
