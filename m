Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC22EC2FE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbhAFSLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:11:45 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50703 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbhAFSLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 13:11:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 18D5D580659;
        Wed,  6 Jan 2021 13:10:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 13:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JgBPFn
        6+I1DS6lctzlSVx7dJzScz0EO1ksQI4/wmg+w=; b=BZ3+tqPrwO6VVk/LSO5bBc
        yLk2QuVwHUceZwJ1pLiEsr3yYeiEEQJXgZp+WSLEr1u7L6U+jsyqxVlMZeCg3nDM
        VC+kD9DwdX66bxUTo2IUHBRCZf45eQKCzccCfXmEO8g+ZOOEKrX9uDO+w1CG3Ep8
        gul/pRJZRt35I1x6brGBfKH5Q04sgMeqKnLweG/EwQG2WBq1Q+FMdg0RikgwLMUq
        6TRl4n7Aeuoo8mGIK/j277bPv9pwn17SOLmS6LrBherOCa3vaAxS05JHcC2LANQI
        rHpZ8CGDtBKAWqK2RAOEELRZ3XuyKzkoeR1H1Z0Qtk5K4EH9DqaNVrBy1v18PtVA
        ==
X-ME-Sender: <xms:Gv31X4ARnVkbnSI2NuL2kxa5oIKp8X6_dPkHrZmq-0yJWF_eD7G-BA>
    <xme:Gv31X6iPj68e6KbmeRDU-xWvISeIerYBE8sN10Y87Jk9RrHqUydB93CaAgsfOQuvL
    VUjYg7yhTF3wyU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Gv31X7lycdGcSi4SIQH1kN4aaDev3HXRIM9JgJfVD-6KPgd5FwpccA>
    <xmx:Gv31X-x6z48J1O8ZblO--CbwUvXfAZmnIH0vZ0kIlap6bQKYpHY2_g>
    <xmx:Gv31X9Qim9nMs4nNeA0L6ZiCHWQF1nGVaksnKFohXsZFQO3B2_18jg>
    <xmx:Hv31X_mi0X2aIS_Qsf3qJ-WG6_4NWqxjhu6olI3Q-QL3iZAD5qchhA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76C05108005C;
        Wed,  6 Jan 2021 13:10:33 -0500 (EST)
Date:   Wed, 6 Jan 2021 20:10:30 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 09/10] mlxsw: spectrum_switchdev: remove
 transactional logic for VLAN objects
Message-ID: <20210106181030.GD1082997@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-10-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:10:05PM +0200, Vladimir Oltean wrote:
> @@ -1764,29 +1759,20 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
>  {
>  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
>  	const struct switchdev_obj_port_vlan *vlan;
> -	struct switchdev_trans trans;
>  	int err = 0;
>  
>  	switch (obj->id) {
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
>  
> -		trans.ph_prepare = true;
> -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
> -					      extack);
> +		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, extack);
>  		if (err)
>  			break;
>  
> -		/* The event is emitted before the changes are actually
> -		 * applied to the bridge. Therefore schedule the respin
> -		 * call for later, so that the respin logic sees the
> +		/* Schedule the respin call, so that the respin logic sees the
>  		 * updated bridge state.
>  		 */

I would keep this comment as-is. Other than that this patch looks good
to me:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
