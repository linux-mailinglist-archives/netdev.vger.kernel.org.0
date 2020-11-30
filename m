Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710082C8529
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgK3N3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:29:45 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:54333 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgK3N3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606742984; x=1638278984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Sk1vGpxLNcx4Sjlhcb2DMc4WhRUPc0M7/K3bL2IJhCY=;
  b=fE10GCGy5MRy0HrpNNxHpjb4wGKG8PsBPEh3UGYfWCxime6WGGKCopWM
   EU1Dj6rhkvImzHRSZ/fnkJIPiQ38CjS4A65ZZ8W9l0duVCuG5fKJEaEQl
   2OrdZWySaZIxBXvvHDwnSUTmBWxxxftEU4/YfE/sYMhhGh0Ipi9tC4afD
   UiA+RQFuZ+fdA9Y2ppIL53vtJx86FKba5/w6PCxcipBFNgqBSUH1liDfD
   ixBEdIvc9b21oFudLvknHaSHa05o+BS5DPjpJqSg6wWcE1loWE6TG89on
   URdsT3NUzhfqPo1oUuuEyJyDY2HoK6yWXDI6uU9uBCKKyuY1bfYqdzPim
   g==;
IronPort-SDR: Gs9KCZjI3i0w25BHVdKpBd15fdMmBdxq8K/eNXo2kVgaZ04WHuOGml2wwyOJXRwcFblG71oUZv
 GQBaLfIUXf7queq0/ZnzD8m+6+q4lNP6UUi1vPzQhw1RPErF+WIsDiLY1MbLnjxUwjkiivhiUY
 t0zUkEapj4eAmk2No9EEWMdMT50+KrP8u+TDZ712Yjg5uva8WvPwHB7cj6DosxUCA1QlLQ8KnZ
 GE/ghOLetSkOFNl6juVAftBTHx/urwjeQ8+mh7u+yHk7k4btW/HRmbBBHAN9yAO/paVObLoibu
 NLY=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="35429563"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:28:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:28:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:28:36 -0700
Date:   Mon, 30 Nov 2020 14:28:35 +0100
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
Message-ID: <20201130132835.7ln72bbdr36spuwm@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190334.GE2191767@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201128190334.GE2191767@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.2020 20:03, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +static int sparx5_port_open(struct net_device *ndev)
>> +{
>> +     struct sparx5_port *port = netdev_priv(ndev);
>> +     int err = 0;
>> +
>> +     sparx5_port_enable(port, true);
>> +     if (port->conf.phy_mode != PHY_INTERFACE_MODE_NA) {
>> +             err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
>> +             if (err) {
>> +                     netdev_err(ndev, "Could not attach to PHY\n");
>> +                     return err;
>> +             }
>> +     }
>
>This looks a bit odd. PHY_INTERFACE_MODE_NA means don't touch,
>something else has already configured the MAC-PHY mode in the PHY.
>You should not not connect the PHY because of this.

Hmm.  I will have to revisit this again.  The intent was to be able to
destinguish between regular PHYs and SFPs (as read from the DT).
But maybe the phylink_of_phy_connect function handles this
automatically...
>
>> +void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port)
>> +{
>> +     if (port->phylink) {
>> +             /* Disconnect the phy */
>> +             if (rtnl_trylock()) {
>
>Why do you use rtnl_trylock()?

The sparx5_port_stop() in turn calls phylink_stop() that expects the lock
to be taken.  Should I rather just call rtnl_lock()?

Thanks for your comments

/Steen


>
>    Andrew

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
