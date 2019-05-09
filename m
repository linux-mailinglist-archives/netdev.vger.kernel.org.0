Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B118CB6
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfEIPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:11:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:33288 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbfEIPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 11:11:27 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BB66CC00FF;
        Thu,  9 May 2019 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557414680; bh=vpUIv441zlcvFgvrtY0dSx3wjmUWdmvurzo1+Epk2SQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=UzyDl4RvEO4K6HowYgZcREjyOIZxJ1Lb9yp6+ABs8ZbabQvXV/Lg+5/2C4Y+RZRgt
         VVsEzaK6kq4yOH/lFKDNutoLHpix7dSZRvQ0vnVesYfd9JDdLZrz3xUo+qHk/VREci
         KWpnRqW6QrUwYHO7D9JnfFr72y46gmnWtKfRYMemlkr7i06Z5IqMLacOwJ0b4TSu1+
         8UKQV1+zF4glrWSf6tpMBMvXqiXFjp7pwc14MKYKhr72lsMLlKOWZNwID+72B62WHS
         1vte6TlGU43PpjvcErF8haphttbAf+Ag64DdVXsBs6B/bEtq9eRPqWWPeH7pxugHV6
         7A5YfsgXeZA4g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A1403A0072;
        Thu,  9 May 2019 15:11:25 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 May 2019 08:11:25 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 9 May 2019 17:11:21 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Thread-Topic: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Thread-Index: AQHVBXLbzVq8jQ4wOEqKi4j/REzHDqZh7/UAgACEXjCAACKoAIAAUKrw
Date:   Thu, 9 May 2019 15:11:21 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B47B3A7@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
 <20190509022330.GA23758@lunn.ch>
 <78EB27739596EE489E55E81C33FEC33A0B47AB21@DE02WEMBXB.internal.synopsys.com>
 <20190509122118.GA4889@lunn.ch>
In-Reply-To: <20190509122118.GA4889@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, May 09, 2019 at 13:21:18

> > > You also seem to be missing a test for adding a unicast address via
> > > dev_uc_add() and receiving packets for that address, but not receivin=
g
> > > multicast packets.
> >=20
> > Hmm, what if interface was already configured to receive Multicast befo=
re=20
> > running the tests ?
>=20
> The kernel keeps a list of unicast and multicast addresses, which have
> been added to the filters. You could remove them all, do the test, and
> then add them back. __dev_mc_unsync(), __dev_mc_sync() etc.

Thanks! I've implemented the "MC Filter" and "UC Filter" tests and due to=20
that I found another bug in the driver :D

Thanks,
Jose Miguel Abreu
