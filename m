Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0518F7DDC0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbfHAOXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:23:07 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39453 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfHAOXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:23:06 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: qCQXWl0rF2TIuwU6rbtaA9K+cKeas9+r9q3FdUTb3SSRIKiCemqChIfNR/7wklaOPSvlQlZikL
 tuqP1+P29ChGmjdJHZVfaILoOLr1wb/ZlvpdErjbvq95T4F9+UJ3v8yCIxf8PyRr9xHXvohQah
 Z9hOyZp7KK7uTGxvbT4WZWMJKanykIAJsja4SSTGN6ChizfULt3LUP3pP64Ogi0OfHaPxnv0vr
 uBH/7KoEsXMPvZq8/eT04XEiOREQovMb27iNBKupNRc8xSZpCnzPBiurT7370iBenbXc+pWVgO
 f0w=
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="43579779"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2019 07:23:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Aug 2019 07:22:54 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 1 Aug 2019 07:22:54 -0700
Date:   Thu, 1 Aug 2019 16:22:53 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190801142252.pdzd6knl2ytuty7h@lx-anielsen.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/26/2019 15:31, Nikolay Aleksandrov wrote:
...

> You know that in order to not run in promisc mode you'll have to disable
> port flooding and port learning, right ? Otherwise they're always put in promisc.
Yes, we have spend some time looking at nbp_update_port_count and trying to
understand the reasoning behind it.

Our understanding is that this is to make it work with a pure SW bridge
implementation, and this is actually an optimization to allow disable promisc
mode if all forwarding is static (no flooding and no learning).

We also noticed that the Ocelot and the Rocker drivers avoids this "issue" by
not implementing promisc mode.

But promisc mode is a really nice feature for debugging, and we would actually
like to have it, and when HW that can do learning/flooding it does not seem to
be necessary.

I tried to understand how this is handled in the Mellanox drivers, but gave up.
Too big, and we lack the insight in their design.

Do you know if there are better ways to prevent switchdev-offloaded-slave
interfaces to go to promisc mode?

/Allan

