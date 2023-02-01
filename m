Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE59686DAF
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjBASKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBASKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:10:24 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369221CF44;
        Wed,  1 Feb 2023 10:10:23 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 3073532009A4;
        Wed,  1 Feb 2023 13:10:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Feb 2023 13:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675275016; x=1675361416; bh=wZVarq9wJ5kZO9X2EgYSaB6n3mMF
        V5UjT+9T/Nr3jsU=; b=Td6xyFKYYh4elevf9+Mw/pA8go+44leCjtjeWZklrO1+
        4BrZXCstdlGJDdZu/SAeJh3nbzrXAnBKx0YT39lLJj2+L6yc5xAGQPpk+9idNTiv
        5Qw7hx1DILUzjA1W8Ei0jI3Ckam/V4Vua82q+qedXNCvYKRnKSMqLiaZmD+PkRp6
        5pCpGZJ55AzYnrCvwBdZsla4sekjsutMsCgCbpp97fXzImo9trUHzk2nHW8ejqjR
        XIiqWxpIFWSwhsjwi/a7XoOi3GItxG7x30lq8WRXm1sOeu//YH5nZOpzHmjm+ZTS
        EeNYIQ/3dvjqmEDln+fmhLFu+lpYH4nINVYayVzl4Q==
X-ME-Sender: <xms:B6vaYxSD-nV-pt_zeRp-FTtw9kuMRvlre1p3m0P37WyaOr5sbyI15g>
    <xme:B6vaY6zj08MRF5BSmYEgChj3EXEMMSnknzzbgSeC1dFiaKbIGuunY0Tj8NgUmSuuR
    XATRxHvgqKCsJU>
X-ME-Received: <xmr:B6vaY23QtMFusVrpOn0sNr8gvJMDxocCt6BKZPifO2v_-X0cgOAWQUN3C1t3_7eUubIwaIppiXF7iQDYWZ6p_uNKy8E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefiedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:B6vaY5AYntxM3JbCGrkiTY-SP8l93nuMf2GkowdIYRdNUlwvWOaVJA>
    <xmx:B6vaY6iZZbp7lwPGG_VorYF8uWUp7WlbS9x3Rw2EITUz0rCL-6PWXQ>
    <xmx:B6vaY9r4FX1IU69Yon0ybTRpxOauT8yDm_Jmr_Zhw-Ch40rI1JG2nQ>
    <xmx:CKvaY4PX6Rn369eXdfF4yXYFbMjpjA7tUeNmXPlgeYMduC9ybtiV1Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Feb 2023 13:10:14 -0500 (EST)
Date:   Wed, 1 Feb 2023 20:10:10 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev
 notifier
Message-ID: <Y9qrAup9Xt/ZDEG0@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173429.3577450-2-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 06:34:25PM +0100, Hans J. Schultz wrote:
> To be able to add dynamic FDB entries to drivers from userspace, the
> dynamic flag must be added when sending RTM_NEWNEIGH events down.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  include/net/switchdev.h   | 1 +
>  net/bridge/br_switchdev.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index ca0312b78294..aaf918d4ba67 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -249,6 +249,7 @@ struct switchdev_notifier_fdb_info {
>  	u8 added_by_user:1,
>  	   is_local:1,
>  	   locked:1,
> +	   is_dyn:1,
>  	   offloaded:1;
>  };
>  
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 7eb6fd5bb917..4420fcbbfdb2 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -136,6 +136,8 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
>  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags) &&

Why not 'is_static' and be consistent with the bridge flag like all the
other fields?

Regardless of how you name this field, it is irrelevant for
'SWITCHDEV_FDB_ADD_TO_BRIDGE' notifications that all add FDB entries
with the 'BR_FDB_ADDED_BY_EXT_LEARN' flag set, which makes
'BR_FDB_STATIC' irrelevant.

> +		item->added_by_user;

Unclear why this is needed...

>  	item->locked = false;
>  	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
>  	item->info.ctx = ctx;
> -- 
> 2.34.1
> 
