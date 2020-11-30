Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84C2C84DA
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgK3NOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:14:43 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:52844 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgK3NOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606742081; x=1638278081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gzPV8tS0jLOa1sC+OKcqQObrLxVyNiXi7+ZLpq11HXI=;
  b=cPHYZXY0AvKHXwY5mUsSYQVt9nAdVjv4i4Odhkazbt9Dk9o25cqXBSKx
   mlCoaB/Kc/PDCgsiPsYDhc0lms7qJXKgIQPtxuXlgL5SOndX92SXQqQrt
   qi/7+vbaTl/cw5F+kZrXHVzgmpU5urJJFP4BMz33kpCxCFz7kEeBVvcrv
   GNUNK4FcVoirJsJhjnS/zG6dyYf+7aJsAN+XH3c6RPY0cQYiNOUD3yBc9
   VPxorEfvTDk52GLpNpyagmbNW6kpCRKD9Edy3ZgPQHFkJgo4qiSFqACQU
   Ole0Ky2//ytdQFX/Upc+vHvvsn0k2II3575CRvZrpXqz39BvrV5V+SVxu
   Q==;
IronPort-SDR: azxthInd0R8YW/A5KcTWEf1PKuHklRAsbrzr1kd9ToN4aFc+AaRrJRrhDuzJ/7PhCcmmRhZSSd
 yNrDWqErp7HyUATRMkVdxvQNgfACjttCeBknEOucbqJcfMrLnj5ax46NqlkXNNrBw97/Vvxi70
 Rqeu5nf8+QCf4aFzRUJ9PKUdH7ldfisaY3BNh13OmNFspe1LDPvhXPWxrgoBCS9GbopCgAC+TE
 rIrQmZqcsLumAdNDwCGO4uY/E+hs/YpaULYJLnE0sd+DKV42IqVcCdLZRvxkxRJv70nJMLgzcR
 Ty4=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="35427842"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:13:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:13:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:13:35 -0700
Date:   Mon, 30 Nov 2020 14:13:35 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130131335.afasdxbf5ilhsxue@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201127171506.GW2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201127171506.GW2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.11.2020 18:15, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>This is a very large driver, which is going to make it slow to review.
Hi Andrew,

Yes I am aware of that, but I think that what is available with this
series, makes for a nice package that can be tested by us, and used by
our customers.

>
>> +static int sparx5_probe_port(struct sparx5 *sparx5,
>> +                          struct device_node *portnp,
>> +                          struct phy *serdes,
>> +                          u32 portno,
>> +                          struct sparx5_port_config *conf)
>> +{
>> +     phy_interface_t phy_mode = conf->phy_mode;
>> +     struct sparx5_port *spx5_port;
>> +     struct net_device *ndev;
>> +     struct phylink *phylink;
>> +     int err;
>> +
>> +     err = sparx5_create_targets(sparx5);
>> +     if (err)
>> +             return err;
>> +     ndev = sparx5_create_netdev(sparx5, portno);
>> +     if (IS_ERR(ndev)) {
>> +             dev_err(sparx5->dev, "Could not create net device: %02u\n", portno);
>> +             return PTR_ERR(ndev);
>> +     }
>> +     spx5_port = netdev_priv(ndev);
>> +     spx5_port->of_node = portnp;
>> +     spx5_port->serdes = serdes;
>> +     spx5_port->pvid = NULL_VID;
>> +     spx5_port->signd_internal = true;
>> +     spx5_port->signd_active_high = true;
>> +     spx5_port->signd_enable = true;
>> +     spx5_port->flow_control = false;
>> +     spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
>> +     spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
>> +     spx5_port->custom_etype = 0x8880; /* Vitesse */
>> +     conf->portmode = conf->phy_mode;
>> +     spx5_port->conf.speed = SPEED_UNKNOWN;
>> +     spx5_port->conf.power_down = true;
>> +     sparx5->ports[portno] = spx5_port;
>
>
>> +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
>> +{
>> +     struct net_device *ndev;
>> +     struct sparx5_port *spx5_port;
>> +     int err;
>> +
>> +     ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
>> +     if (!ndev)
>> +             return ERR_PTR(-ENOMEM);
>> +
>
>...
>
>> +     err = register_netdev(ndev);
>> +     if (err) {
>> +             dev_err(sparx5->dev, "netdev registration failed\n");
>> +             return ERR_PTR(err);
>> +     }
>
>This is one of the classic bugs in network drivers. As soon as you
>call register_netdev() the interface is live. The network stack can
>start using it. But you have not finished initialzing spx5_port. So
>bad things are going to happen.

Oops.  I will fix that.

Thanks for the comments.
Steen
>
>    Andrew

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
