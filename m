Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925BE484291
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiADNe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:34:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53486 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiADNem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641303282; x=1672839282;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dFfeySson+DcY9L2qqyi99YbeNz8/S8kE5nTdweljcA=;
  b=qB+WecfuVDkTETgGZo28UN3GyVd1CYe+6tT3FuglVIKJqDUMembgRaYs
   ESTR11V0zc3ryHcscUSTPkXXbP923wwU3wTp4coqSc6rETTKBuqDnZ/lq
   +XlpuDmSOUxJnaN12jkcvzJAbMzhoH0zbHim9ZsPMV2U16sUQkVyoiwsX
   9awr4zw7MQm05Wh4n8xFfMAy81bY0Juc6C1MSe7mTXmSvaH5qFCwipPw1
   yqdTQa/7Lqty4lcS7IxLfcAIMroA3+BVfnPGXWDDsfjaPMh7O97HRX5c9
   9FniMXoisR5XK2e8lGG7Jg2c+nwZW17e+Vjj/k7gxU5VPgWf9xlwy6/wc
   Q==;
IronPort-SDR: Zm9ryX6ThUQ435XZWTQeM8NY6E4nqwJXf43jLv9bWD0CZMCWIvVEHxsXglb05H3MKmd8tjKiIp
 1zhf8ceh7WlSN3+Y93y0Qum5Gfq31RqDnj0yAK9E6aAWh8LUwgRdt/XnQUDzE9D003Gt0WcglO
 syrZ/NtfS0nZjksycxcGhy8cNDPe1B2hiX42MUk2fq6bLrmhJHuAXHXwOVqmyACTFDCewkig59
 7lgUmITeSHUnnJ3EmxMEaIxbKgg/YAg8+BfsDxzkwzw9UzrtpV/CO6iHzBkkMdjU/Cj3w8L7Cu
 oKZNEfDEdFT5LV6yWAduZwja
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="144275914"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 06:34:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 06:34:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 4 Jan 2022 06:34:40 -0700
Date:   Tue, 4 Jan 2022 14:36:54 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/3] net: lan966x: Extend switchdev with mdb
 support
Message-ID: <20220104133654.oaqtrnee6bxfs6fe@soft-dev3-1.localhost>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-4-horatiu.vultur@microchip.com>
 <20220104111209.2ky2n5gdqaxzf5fh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220104111209.2ky2n5gdqaxzf5fh@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/04/2022 11:12, Vladimir Oltean wrote:
> 
> On Tue, Jan 04, 2022 at 11:18:49AM +0100, Horatiu Vultur wrote:
> > +static int lan966x_mdb_ip_del(struct lan966x_port *port,
> > +                           const struct switchdev_obj_port_mdb *mdb,
> > +                           enum macaccess_entry_type type)
> > +{
> > +     bool cpu_port = netif_is_bridge_master(mdb->obj.orig_dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct lan966x_mdb_entry *mdb_entry;
> > +     unsigned char mac[ETH_ALEN];
> > +
> > +     mdb_entry = lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> > +     if (!mdb_entry)
> > +             return -ENOENT;
> > +
> > +     lan966x_mdb_encode_mac(mac, mdb_entry, type);
> > +     lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> > +
> > +     if (cpu_port)
> > +             mdb_entry->cpu_copy--;
> 
> Can you code this in such a way that you don't forget and then re-learn
> the entry if you only do a cpu_copy-- which doesn't reach zero?

I think it is possible to do this. I will do that.

> 
> > +     else
> > +             mdb_entry->ports &= ~BIT(port->chip_port);
> > +
> > +     if (!mdb_entry->ports && !mdb_entry->cpu_copy) {
> > +             list_del(&mdb_entry->list);
> > +             kfree(mdb_entry);
> > +             return 0;
> > +     }
> > +
> > +     lan966x_mdb_encode_mac(mac, mdb_entry, type);
> > +     return lan966x_mac_ip_learn(lan966x, mdb_entry->cpu_copy,
> > +                                 mac, mdb_entry->vid, type);
> > +}

-- 
/Horatiu
