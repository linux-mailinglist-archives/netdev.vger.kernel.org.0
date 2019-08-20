Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87C95AEF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfHTJ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:26:10 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:50680
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728414AbfHTJ0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:26:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pfn4XBZbSPrjCIP+2R5D4tVTsh5Apfh807yZAZ02Y7/USRjmcb2E7BfUSSgSDP9MM30tsaMo2U+yrLVUaxBCA5yxLHfuYbUYsArY98dXuTn0M1IewqiHTIDPFkaNc4BPKUhD2AJorI7S0XBS/C/fU301BXDTN5n8t6Q3GvkmeLSne7C85Bx17hsfAO3dcm5O4VH/qPZeTaJHD6ROlIY0lynPfkF9n6Ibb0hIeIz+kVThCAbbj7k6C//USUslO45o0cdGTotQ6uJhiJZqehBPK/SBRoAKEAz9QuKlYvX8a2gpXR/LL5ulmcFj4BXvHQoVBgKaKJA13Ta2EveWZa+1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKBXRONeJvdbqTn1uh9TDUQoTB9KQdoavxwfrjHDCz0=;
 b=ChQeOmH5aO7mU2kA+ubGbrr+lNJPjHHe0Be1Tlv0FNGjsXEYfE8zI0yCo9u6LBCdPQ2jFuJX48Zd2lmb2Nsclu2iT225LleEQRT0ANU3l8gAXOH2kJ2pShVLN3tK0/Lj/pJHt2YZh3Zw5GVjq4wcKWPdrIV91w9mMPTgqKJVfwqn/csxnPwj8bQ4F8+dI3XXvl6LuZkOCzRvcV8NPKk8nnLruceKRiKxmM0g84MNitsRrTKPtI4qq47IfWnFUMiIvszdySZbXrUKfPBOzkTDM6JjA2IWMjYozLUak6ydrBkjy+LO/OrEM+eLpSPmDrdvJJ9bCPRhLviG6rsbK4/0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKBXRONeJvdbqTn1uh9TDUQoTB9KQdoavxwfrjHDCz0=;
 b=Dy5soY5Hoyco/tpaJi1sZn2HOG/Vjw1QhCrenK+ucOewqyg6q0xehibPJNbY+/yH9sgNJuYqoHmVSj6RTBlxz88QMYscQilCAXsQtJQ+hnUgc5tBWYINKzI1bT8/sh/0hcpct1M5lMpdYRY3T1lAflhPkH2cupsoWaDnYtvVC1g=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4058.eurprd04.prod.outlook.com (52.134.109.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 09:26:07 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 09:26:07 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQ
Date:   Tue, 20 Aug 2019 09:26:06 +0000
Message-ID: <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
In-Reply-To: <20190820092303.GM2588@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24bed9a2-6764-423f-638a-08d725506e10
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4058;
x-ms-traffictypediagnostic: DB7PR04MB4058:
x-microsoft-antispam-prvs: <DB7PR04MB4058ABE6105891C116492F0F8BAB0@DB7PR04MB4058.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(189003)(199004)(13464003)(44832011)(316002)(486006)(446003)(11346002)(3846002)(25786009)(6116002)(7696005)(8676002)(33656002)(66946007)(66476007)(86362001)(76116006)(66556008)(64756008)(66446008)(4326008)(478600001)(14454004)(476003)(6916009)(7736002)(305945005)(53546011)(6506007)(102836004)(26005)(5660300002)(229853002)(66066001)(52536014)(186003)(99286004)(81156014)(74316002)(81166006)(256004)(53936002)(2906002)(55016002)(6436002)(76176011)(71190400001)(71200400001)(8936002)(6246003)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4058;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JJmnSM2Ri4x+wEjJr0fgk+u0rbpPQPgNu5uaSubwDGZ8rpoprZGuh5QIcb7+y982e+2Xt0oQpx+M8jxbb9AojKZR2Ua0p73uKGjssMhhn3LHbJ05Njz145Zi/bZVHx8VgUybnqNqXRfMV4xodMiZReNxxNrM7eBCejIpuAKZeOHytxpAtf5yBhslCKwR0kDBGyi0JKcjBamR2H2krFYTnxRidQFt/8RPCRc5CyiPOUritwzMeOqecZeAcUrgWFAqjxdjg9Vhto9MvGttFhw6igmS3Aqyg/qf6msKCubH94PpIBByfSgTtornapxinQOPCSt2p7HmwzmRRQCfeTx+/3q4aHI3K3BOSXLQmY+RVZRsa0Kyy4N6QdRKh9iBdKsQBHWJU+dK8Wqan+bGdUmlP+4rWDVL/4gXc9fNOEefZwk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bed9a2-6764-423f-638a-08d725506e10
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 09:26:06.9014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FyU8XXZqRuAq3eeuH5NXpd48DQpmk7pj5gAds0wWRwyn5s55iAKlCMfw7GsSCBx2Gg/bXpk5+dv5/0JeX4DiBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Tuesday, August 20, 2019 2:53 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> Subject: Re: Help needed - Kernel lockup while running ipsec
>=20
> Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > With kernel 4.14.122, I am getting a kernel softlockup while
> > > > running single
> > > static ipsec tunnel.
> > > > The problem reproduces mostly after running 8-10 hours of ipsec
> > > > encap
> > > test (on my dual core arm board).
> > > >
> > > > I found that in function xfrm_policy_lookup_bytype(), the policy
> > > > in variable
> > > 'ret' shows refcnt=3D0 under problem situation.
> > > > This creates an infinite loop in  xfrm_policy_lookup_bytype() and
> > > > hence the
> > > lockup.
> > > >
> > > > Can some body please provide me pointers about 'refcnt'?
> > > > Is it legitimate for 'refcnt' to become '0'? Under what condition
> > > > can it
> > > become '0'?
> > >
> > > Yes, when policy is destroyed and the last user calls
> > > xfrm_pol_put() which will invoke call_rcu to free the structure.
> >
> > It seems that policy reference count never gets decremented during pack=
et
> ipsec encap.
> > It is getting incremented for every frame that hits the policy.
> > In setkey -DP output, I see refcnt to be wrapping around after '0'.
>=20
> Thats a bug.  Does this affect 4.14 only or does this happen on current t=
ree
> as well?
=20
I am yet to try it on 4.19.
Can you help me with the right fix? Which part of code should it get decrem=
ented?
I am not conversant with xfrm code.

