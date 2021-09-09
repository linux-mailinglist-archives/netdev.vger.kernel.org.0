Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BA404957
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbhIILfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:35:13 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:47742 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhIILfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 07:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631187243; x=1662723243;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6kHXPr3jXWQZ7U6rZhQEMVT1FkrfZP+wEhLdKi27Duo=;
  b=kYsbrMH8bTuaGCz43EG45u0d1i3PboqwigPJbp64M7r/AygApMO+TTxl
   0P/NrupRp4H31S9uVPxgJSRjbR2HrCOPzEpJr0dVuaXe+yY6Oo4sPWyjA
   mdjHpPMNsMLEi3WbEikleEZmtjJbSkrow6S26EK9a4HCUNIo9oaiMZeAS
   OaClKXQPJOtZTCqZPI2ddGcoSNVOOOnl5S/yAuommcTC+3lHWUgAmwzxZ
   QlcV/yqYRZdA053AEIm52xLgYwUVA7wtL73vsKyGwWiaCF22vIxylIQf8
   PgJTWZvetoFFVf8BYvW/jaMr2oW2DYBcpL9xrHugGd0imobyE1qyadQbK
   A==;
IronPort-SDR: PiW5o3Pf4gAQGg5PKXqE6I4m1vA1VEqLfe5HawOWnz7CSEv0zHdUrsfFHQG5vumOQ784k8XTmd
 KMV09r1P3I6fsMQn/NBs5WtHNmfZnbMC43Rebs+9WDWZ3O6902A4h2eKL507QxOdZtMLIrkq3I
 YfMeheo1zp/K9sgjQhYuTEj6a3LLgIzA6zcPppNnmXtZh1VjpDbydQW0rptoayJ+Pq2ljF1dfg
 hEk6ibYxrz5oUqEJmzPrheVT9Wd0iUw+Gg7KWTSG496eXoDUUBj38GXr5468hIq6mOY1L0gJ/C
 EhqCitgRXE7Gu24dzmmq0ebt
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="128743937"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2021 04:34:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Sep 2021 04:34:01 -0700
Received: from soft-dev16.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Sep 2021 04:33:58 -0700
Message-ID: <9619848400baaa0d0d12cc6a2d799934323e2657.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Date:   Thu, 9 Sep 2021 13:33:57 +0200
In-Reply-To: <20210831104913.g3n6dov6gwflc3pm@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
         <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
         <20210831075450.u7smg5bibz3vvw4q@skbuf>
         <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
         <20210831084610.gadyyrkm4fwzf6hp@skbuf>
         <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
         <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
         <20210831091759.dacg377d7jsiuylp@skbuf>
         <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
         <20210831104913.g3n6dov6gwflc3pm@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-31 at 10:49 +0000, Vladimir Oltean wrote:
> On Tue, Aug 31, 2021 at 09:59:11AM +0000, Xiaoliang Yang wrote:
> > On Tue, Aug 31, 2021 at 17:18:00PM +0300, Vladimir Oltean wrote:
> > > > > > I think in previous versions you were automatically
> > > > > > installing a
> > > > > > static MAC table entry when one was not present (either it
> > > > > > was
> > > > > > absent, or the entry was dynamically learned). Why did that
> > > > > > change?
> > > > > 
> > > > > The PSFP gate and police action are set on ingress port, and
> > > > > "
> > > > > tc-filter" has no parameter to set the forward port for the
> > > > > filtered
> > > > > stream. And I also think that adding a FDB mac entry in tc-
> > > > > filter
> > > > > command is not good.
> > > > 
> > > > Fair enough, but if that's what you want, we'll need to think a
> > > > lot
> > > > harder about how this needs to be modeled.
> > > > 
> > > > Would you not have to protect against a 'bridge fdb del'
> > > > erasing your
> > > > MAC table entry after you've set up the TSN stream on it?
> > > > 
> > > > Right now, DSA does not even call the driver's .port_fdb_del
> > > > method
> > > > from atomic context, just from deferred work context. So even
> > > > if you
> > > > wanted to complain and say "cannot remove FDB entry until SFID
> > > > stops
> > > > pointing at it", that would not be possible with today's code
> > > > structure.
> > > > 
> > > > And what would you do if the bridge wants to delete the FDB
> > > > entry
> > > > irrevocably, like when the user wants to delete the bridge in
> > > > its
> > > > entirety? You would still remain with filters in tc which are
> > > > not
> > > > backed by any MAC table entry.
> > > > 
> > > > Hmm..
> > > > Either the TSN standards for PSFP and FRER are meant to be
> > > > implemented
> > > > within the bridge driver itself, and not as part of tc, or the
> > > > Microchip implementation is very weird for wiring them into the
> > > > bridge MAC
> > > table.
> > > > Microchip people, any comments?
> > > 
> > > In sja1105's implementation of PSFP (which is not standard-
> > > compliant as it is
> > > based on TTEthernet, but makes more sense anyway), the Virtual
> > > Links (SFIDs
> > > here) are not based on the FDB table, but match only on the given
> > > source port.
> > > They behave much more like ACL entries.
> > > The way I've modeled them in Linux was to force the user to
> > > offload multiple
> > > actions for the same tc-filter, both a redirect action and a
> > > police/gate action.
> > > https://www.kernel.org/doc/html/latest/networking/dsa/sja1105.html#time-b
> > > ased-ingress-policing
> > > 
> > > I'm not saying this helps you, I'm just saying maybe the
> > > Microchip
> > > implementation is strange, but then again, I might be looking the
> > > wrong way
> > > at it.
> > 
> > Yes, Using redirect action can give PSFP filter a forward port to
> > add
> > MAC table entry. But it also has the issue that when using "bridge
> > fdb
> > del" to delete the MAC entry will cause the tc-filter rule not
> > working.
> 
> We need to define the expected behavior.
> 
> As far as the 802.1Q-2018 spec is concerned, there is no logical
> dependency between the FDB lookup and the PSFP streams. But there
> seems
> to be no explicit text that forbids it either, though.
> 
> If you install a tc-redirect rule and offload it as a bridge FDB
> entry,
> it needs to behave like a tc-redirect rule and not a bridge FDB
> entry.
> So it only needs to match on the intended source port. I don't
> believe
> that is possible. If it is, let's do that.
> 
> To me, putting PSFP inside the bridge driver is completely outside of
> the question. There is no evidence that it belongs there, and there
> are
> switch implementations from other vendors where the FDB lookup
> process
> is completely independent from the Qci stream identification process.
> Anyway, this strategy of combining the two could only work for the
> NULL
> stream identifiers in the first place (MAC DA + VLAN ID), not for the
> others (IP Stream identification etc etc).
> 
> So what remains, if nothing else is possible, is to require the user
> to
> manage the bridge FDB entries, and make sure that the kernel side is
> sane, and does not remain with broken data structures. That is going
> to
> be a PITA both for the user and for the kernel side, because we are
> going to make the tc-flower filters effectively depend upon the
> bridge
> state.
> 
> Let's wait for some feedback from Microchip engineers, how they
> envisioned this to be integrated with operating systems.

We at Microchip agrees that it is a difficult task to map the PSFP
implementation in Felix to the “tc flower” filter command, but please
remember that Ocelot and its derivatives were designed long before
the 802.1Qci standard was ratified and also before anyone has
considered how to control it in Linux.

We think that the best approach is to require the user to manage
bridge FDB entries manually as suggested by Xiaoliang.

Our newer PSFP designs uses the TCAM instead of the MAC table
which maps a lot better to the “tc flower” filter command.

