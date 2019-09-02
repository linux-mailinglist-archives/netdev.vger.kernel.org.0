Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29715A5BF9
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 19:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfIBRz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 13:55:29 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:65501 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfIBRz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 13:55:29 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: MAKZapXI/brCzKTAggHur1oxx5MEehc5gkNmGo6a/bkD8t2WLAyz5cuvNV2XjWv1zYJc4C3H40
 5Us4QwCDeBylBXs295NjtRhpiKUgeXmx1kBUBhjva12/zPNDlaTSuBy/Z7pR9b77KyMwhBellT
 1uNEoyTA2KdlzIwoHHplLqfOBdH4S7ktTVr8M8s4wgxSiHR8c8YTH0j8oQ9Wo583YPkaL4DEEK
 cLb+DbvgBzqd4+OKk+EUP9bivbmEPu7PfrthHruMae/Z7WgcJ/jQ2jbz9X/d2GtKPJePix6G0X
 zsE=
X-IronPort-AV: E=Sophos;i="5.64,460,1559545200"; 
   d="scan'208";a="44600008"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2019 10:55:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 2 Sep 2019 10:55:28 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 2 Sep 2019 10:55:27 -0700
Date:   Mon, 2 Sep 2019 19:55:27 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>, <jiri@resnulli.us>,
        <horatiu.vultur@microchip.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <ivecera@redhat.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190902175526.72gsb4c4hoswd4ds@lx-anielsen.microsemi.net>
References: <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
 <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830094319.GA31789@splinter>
 <20190831193556.GB2647@lunn.ch>
 <20190831204705.GA28380@splinter>
 <20190901184819.GA24673@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190901184819.GA24673@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/01/2019 20:48, Andrew Lunn wrote:
> > Look, this again boils down to what promisc mode means with regards to
> > hardware offload. You want it to mean punt all traffic to the CPU? Fine.
> > Does not seem like anyone will be switching sides anyway, so lets move
> > forward. But the current approach is not good. Each driver needs to have
> > this special case logic and the semantics of promisc mode change not
> > only with regards to the value of the promisc counter, but also with
> > regards to the interface's uppers. This is highly fragile and confusing.
> Yes, i agree. We want one function, in the core, which handles all the
> different uppers. Maybe 2, if we need to consider L2 and L3 switches
> differently.
Are you suggesting that we continue the path in v3, but add a utility function
to determinate if the interface needs to go into promisc mode (taking the
bridge stats, the promisc counter, and the upper devices into account).

Or are you suggest that we like Ido go back to v2?

/Allan

