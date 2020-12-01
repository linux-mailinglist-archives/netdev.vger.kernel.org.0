Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D82A2CA0F8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgLALMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:12:30 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:13750 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbgLALMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606821149; x=1638357149;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=MY9r6utLTlvqf3J/LbeLMJwl9yBw+6A7gDGJDGUYg2c=;
  b=jDAz04z9PQC5sjWk4qRtcJZMQ0HGzFbrQlpdhuE2GNGqeLNs9AKqT3tY
   f7SHrcj3XDIn+OMpr3b/qYSFnGNRYVWpxXYuKubllhSBtRK0jkynz2icL
   zinw9t+Eah4rnYFO6z9D8MLThEi75/cEF20IkAY5BT/H6/DOk7Xyh7JlE
   VRyQewKzR4XqVxY8UxLyXAclg1/wAXJEMbBk5UYgrmow87+SvYevztmx3
   fkHIGJ96oQtJT/0jLhaDB4DF+vl9+spwOf4JSLti2BuhgYggSCT1789t9
   o/L21RAiw+1jusgh/SqeXqVtfh5Ed8sAB1FVJXAK2g/dseIAs8XxwpXjm
   A==;
IronPort-SDR: pyyP6SCcRFqQ47ABFhPxbbeTdi9xo5TRFb/GDOapTehgqfnvhdIrWSZvsu4GByFLU11+atosZk
 oBLdna9ba9sHBQA1SZLozhg/vB1koTzNhbJxklmhdzzE4kdOTsDyyy9gzgoSOY1Fn3qnbYld8X
 FCtOHjocCMv/f2i3s6NfopGdCVXHWy/SyFkjM3UjtKpNAp1a5mSiHZ1+YT/7PvfPnSckQA5i3L
 ZVypJx09VWatjkFasAY7OSBoq5qFhxk58AcSkKxnppTUy++wOSpsNLmwYo1iCIAWtRF5piVu2q
 nfs=
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="95391162"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2020 04:11:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 04:11:24 -0700
Received: from soft-dev10.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 1 Dec 2020 04:11:21 -0700
References: <20201127133307.2969817-1-steen.hegelund@microchip.com> <20201127133307.2969817-3-steen.hegelund@microchip.com> <20201128192410.GG2191767@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Lars Povlsen <lars.povlsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        "Bjarni Jonasson" <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
In-Reply-To: <20201128192410.GG2191767@lunn.ch>
Date:   Tue, 1 Dec 2020 12:11:14 +0100
Message-ID: <87h7p5pyr1.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn writes:

>> +static void sparx5_attr_stp_state_set(struct sparx5_port *port,
>> +                                   struct switchdev_trans *trans,
>> +                                   u8 state)
>> +{
>> +     struct sparx5 *sparx5 = port->sparx5;
>> +
>> +     if (!test_bit(port->portno, sparx5->bridge_mask)) {
>> +             netdev_err(port->ndev,
>> +                        "Controlling non-bridged port %d?\n", port->portno);
>> +             return;
>> +     }
>> +
>> +     switch (state) {
>> +     case BR_STATE_FORWARDING:
>> +             set_bit(port->portno, sparx5->bridge_fwd_mask);
>> +             break;
>> +     default:
>> +             clear_bit(port->portno, sparx5->bridge_fwd_mask);
>> +             break;
>> +     }
>
> That is pretty odd. What about listening, learning, blocking?
>

This only handles simple forward/block. We'll add the learning state as
well.

>> +static int sparx5_port_bridge_join(struct sparx5_port *port,
>> +                                struct net_device *bridge)
>> +{
>> +     struct sparx5 *sparx5 = port->sparx5;
>> +
>> +     if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
>> +             /* First bridged port */
>> +             sparx5->hw_bridge_dev = bridge;
>> +     else
>> +             if (sparx5->hw_bridge_dev != bridge)
>> +                     /* This is adding the port to a second bridge, this is
>> +                      * unsupported
>> +                      */
>> +                     return -ENODEV;
>> +
>> +     set_bit(port->portno, sparx5->bridge_mask);
>> +
>> +     /* Port enters in bridge mode therefor don't need to copy to CPU
>> +      * frames for multicast in case the bridge is not requesting them
>> +      */
>> +     __dev_mc_unsync(port->ndev, sparx5_mc_unsync);
>> +
>> +     return 0;
>> +}
>
> This looks suspiciously empty? Don't you need to tell the hardware
> which ports this port is bridges to? Normally you see some code which
> walks all the ports and finds those in the same bridge, and sets a bit
> which allows these ports to talk to each other. Is that code somewhere
> else?
>

This is applied when the STP state is handled - sparx5_update_fwd().

This is pretty much as in the ocelot driver, which can a somewhat
similar switch - and driver - architecture.

>         Andrew

Thank you for your comments,

---Lars

--
Lars Povlsen,
Microchip
