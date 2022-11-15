Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ED4629507
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbiKOJ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbiKOJ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:58:38 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF56D13EB8;
        Tue, 15 Nov 2022 01:58:36 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 07FA45C0144;
        Tue, 15 Nov 2022 04:58:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 15 Nov 2022 04:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668506316; x=1668592716; bh=3tijywnIt8DjqXlqSE+d/pZazgCQ
        TAqlPz3s4yOaOPk=; b=IBtUw+9GW+uYbVFd9CAmT6T8jEh3xrxTTwDJ5uDZExQT
        t+NBPoPdOlQOgxrSwcBuIkYprlhTmxPr2pshmxw2FQXR+sqK/6qdHI95tF/9KekF
        E8q285I6jUjhkIRkN0xTKJkzgf+Jev2jHEesr2+z2WA9YxSvB+en7ZFXImNrK797
        ihJDBwTCFovKWPuqYVwW6IjrLmO1zlhprQ1YfpHCSMFQ76FxnJzG+zW3eOlfr4Kd
        x6HQ9KJoSrCFDJJO07Zee2k4kr29m/YG4I3btUB8BuQo5OB655qkI4qA71LharJr
        ayMiYOZxIfzPwyFzccRP6bv0O8oBKWuj1AthDhrizQ==
X-ME-Sender: <xms:y2JzY9WqigDE1qoDlm9EHRblY_ib5JMk1GEq0p4Ek9-Caehr-Y145Q>
    <xme:y2JzY9k22Eo9j7hgk9mCMpdOH76JCt_2VcAcwZYUnpo8IeKwctDc_9el-i3EmwYam
    uvEYQdapiuMYyQ>
X-ME-Received: <xmr:y2JzY5aowtQTN8gB0Q2w7LveZnumu4yjkbMbW8XbM8FrjEMx_5sG6K5w9BqjETCSBT8EX45WBROvlKsAp9L9Ch_Iodg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeggddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:y2JzYwX4gz13WJlitr4HtOlMVuG5mvNar94Ahd5TsttziLpCEcAqfQ>
    <xmx:y2JzY3nc5PijVkMNMSb48XW73IEUurikbYq4KA285Ax4ZDM4Jy17KQ>
    <xmx:y2JzY9cx-UXqjreJOnqZZY3mZ3edCJfAZoFjqR0oS-FNutNYhZdQ_A>
    <xmx:zGJzY1UpEd5jYd4lRSd-hdVK0t9kD0IwU0Nf-Pudf74krOo-I9ahVw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Nov 2022 04:58:34 -0500 (EST)
Date:   Tue, 15 Nov 2022 11:58:30 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <Y3NixroyU4XGL5j6@shredder>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112203748.68995-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 09:37:48PM +0100, Hans J. Schultz wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> index 8a874b6fc8e1..0a57f4e7dd46 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -12,6 +12,7 @@
>  
>  #include "chip.h"
>  #include "global1.h"
> +#include "switchdev.h"
>  
>  /* Offset 0x01: ATU FID Register */
>  
> @@ -426,6 +427,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  	if (err)
>  		goto out;
>  
> +	mv88e6xxx_reg_unlock(chip);

Why? At minimum such a change needs to be explained in the commit
message and probably split to a separate preparatory patch, assuming the
change is actually required.

> +
>  	spid = entry.state;
>  
>  	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
> @@ -446,6 +449,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>  				    entry.mac, entry.portvec, spid);
>  		chip->ports[spid].atu_miss_violation++;
> +
> +		if (fid && chip->ports[spid].mab)
> +			err = mv88e6xxx_handle_violation(chip, spid, &entry,
> +							 fid, MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
> +		if (err)
> +			goto out;

On error the kernel will try to unlock a mutex that is already unlocked.


>  	}
>  
>  	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
> @@ -454,7 +463,6 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  				    entry.mac, entry.portvec, spid);
>  		chip->ports[spid].atu_full_violation++;
>  	}
> -	mv88e6xxx_reg_unlock(chip);
>  
>  	return IRQ_HANDLED;
