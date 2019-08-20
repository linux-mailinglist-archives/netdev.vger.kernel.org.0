Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9B95C61
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfHTKiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:38:24 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:51691
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728842AbfHTKiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:38:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiJvC5Yq4vHuz2x0DTYrkFB4neogr11tpkGDFm6JFmi7SOwxU4WsFqgWDUHz6d/j7pmtPAvD9QUQmR1y26INwVSXRC4nEBK2YdjQOfzN9eYMpYAkzEzRRBsHQQNjCTRn/lyq0xlLNgEEX2vya+Zk6Jx+XGwtdKJNUDmOtTahG0KbhKUQDHZ88qFm14rD8agw+G2IMsUXuSgLdzvMd47oKxZT1QMFNq58yTzigL6wNnPhkmjms/+WtzZi+mmNRq+PH9tOBz1yUHvNQxB7XiHuX/BCGeEOkwOHkUytB3ihBSREuWF122+hOiYoQiDD6LVQS/CmHxI5hu2+mWE9ojCW1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVFKsoEjTLsv3y11dRRENFWgIs056IJio7Fj70CyUUI=;
 b=mlzV6z/dLGibgkFvePL4iWhNmg3qzuc79u+9f6k68Xq1tsnf6A5DyYkLN8lUr1ORkNNHnjb1r7mfCEFWdoALSeZ3F2NAv5goZVx8aNZusieqNl/3sazLSfyZpq/5FVr2dC4OekXbmgpQh8i0Xiepu8wU9Un1kAJGvbmFjQ0WRsgf96VyUrFwLzGSZygwrjrfjV2Q+unlxY4mBh5XL6a2cwsvGN4HAnV3Oh0bwPo+3C1GGOnNyoAyG2Q6H9bsnqP59WLCOsFQ/2rnHZwvLMzg5jXvLq2UDQ2bGk2XPyVHcGXxQtFIn9HfSCFOOmAddB/5BlBRLOZGUJ56FkkWdVQz6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVFKsoEjTLsv3y11dRRENFWgIs056IJio7Fj70CyUUI=;
 b=CnJRBCVD8wt5P54YZDXLt6k9pQ2mSx3uyrgbHoe8DrLa6DcWfJay2WU2AWoCj/ncwpSmxXtQNTbSCFmeiabqWR4Hc4H2nk3rGyd35kK/J7mIBxFeL51wE9IE3eKG2VJDVaf7H7gtLX1tc7rLZngQ4c+oU6ASkhzFzDt3ftdzmPA=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4362.eurprd04.prod.outlook.com (52.134.111.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 10:38:18 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 10:38:18 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQAAB+dAAAAHQ0QAABmv2A
Date:   Tue, 20 Aug 2019 10:38:18 +0000
Message-ID: <DB7PR04MB4620B6ACB01BFA338ADAED048BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820093800.GN2588@breakpoint.cc>
 <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21d9a2c3-b76e-44e0-5cd0-08d7255a83e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4362;
x-ms-traffictypediagnostic: DB7PR04MB4362:
x-microsoft-antispam-prvs: <DB7PR04MB4362DC4A93EDC38D70C25BDB8BAB0@DB7PR04MB4362.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(189003)(199004)(13464003)(7696005)(66446008)(2940100002)(71200400001)(71190400001)(5660300002)(446003)(66476007)(11346002)(76116006)(66946007)(64756008)(66556008)(8936002)(14454004)(256004)(14444005)(26005)(44832011)(7736002)(102836004)(186003)(52536014)(316002)(53546011)(6506007)(25786009)(486006)(2906002)(74316002)(305945005)(4326008)(476003)(86362001)(66066001)(6246003)(6916009)(6436002)(9686003)(55016002)(229853002)(478600001)(6116002)(99286004)(3846002)(8676002)(81166006)(81156014)(76176011)(53936002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4362;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Naer/4/OQLdhD69wvLrNB6o6/oTfslQxRUOW20Q8pHUvrKkHPT+9nos5SwCZSKCTUAlJ3y0II2Ku4q1WxDic+BEKf1P1lTX4wKyLPy7nfjm0U+F+yCR1EhYcPWjevobbTjwlcfUcwyWeSRdQE3EQ4PY38UNnZcIG2vOjPumZWGnuD5Pe3K+GNhLgPlC5Cw5YSMgaq59fqw7xiHDJwFb7ON1nGT74aoxZ2Kb8DOgRpVgxT9QCGSVHoY2oG0kRwK+IGpGUEKRLp8WeuZbVYD77gCGaZ3tulVIve7iSTfkK89Au5a4iXKEzxuNbY/pgTdqyelFTwTbm3w2GQIuOD31+i18s4VjufAWcupdtipOJ+PVe9Zr2flpEXhQjxyF80nTHQmH5JJbq068jO7xwErFWf5wtIUrdvi4c8nfNZCDbJHg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d9a2c3-b76e-44e0-5cd0-08d7255a83e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 10:38:18.5008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n51qJjADeFjdtgeQuKfOYM4B4Jt7PFXVzNsD0OSLLqkECtTyKZKKj2hcrc9/VF+tVSMlwEfhddm7sSWvE7VNzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4362
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>=20
> > -----Original Message-----
> > From: Florian Westphal <fw@strlen.de>
> > Sent: Tuesday, August 20, 2019 3:08 PM
> > To: Vakul Garg <vakul.garg@nxp.com>
> > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > Subject: Re: Help needed - Kernel lockup while running ipsec
> >
> > Vakul Garg <vakul.garg@nxp.com> wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Florian Westphal <fw@strlen.de>
> > > > Sent: Tuesday, August 20, 2019 2:53 PM
> > > > To: Vakul Garg <vakul.garg@nxp.com>
> > > > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > > > Subject: Re: Help needed - Kernel lockup while running ipsec
> > > >
> > > > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > > > > With kernel 4.14.122, I am getting a kernel softlockup while
> > > > > > > running single
> > > > > > static ipsec tunnel.
> > > > > > > The problem reproduces mostly after running 8-10 hours of
> > > > > > > ipsec encap
> > > > > > test (on my dual core arm board).
> > > > > > >
> > > > > > > I found that in function xfrm_policy_lookup_bytype(), the
> > > > > > > policy in variable
> > > > > > 'ret' shows refcnt=3D0 under problem situation.
> > > > > > > This creates an infinite loop in  xfrm_policy_lookup_bytype()
> > > > > > > and hence the
> > > > > > lockup.
> > > > > > >
> > > > > > > Can some body please provide me pointers about 'refcnt'?
> > > > > > > Is it legitimate for 'refcnt' to become '0'? Under what
> > > > > > > condition can it
> > > > > > become '0'?
> > > > > >
> > > > > > Yes, when policy is destroyed and the last user calls
> > > > > > xfrm_pol_put() which will invoke call_rcu to free the structure=
.
> > > > >
> > > > > It seems that policy reference count never gets decremented durin=
g
> > > > > packet
> > > > ipsec encap.
> > > > > It is getting incremented for every frame that hits the policy.
> > > > > In setkey -DP output, I see refcnt to be wrapping around after '0=
'.
> > > >
> > > > Thats a bug.  Does this affect 4.14 only or does this happen on
> > > > current tree as well?
> > >
> > > I am yet to try it on 4.19.
> > > Can you help me with the right fix? Which part of code should it get
> > decremented?
> > > I am not conversant with xfrm code.
> >
> > Normally policy reference counts get decremented when the skb is free'd=
,
> via
> > dst destruction (xfrm_dst_destroy()).
> >
> > Do you see a dst leak as well?
>=20
> Can you please guide me how to detect it?
>=20
> (I am checking refcount on recent kernel and will let you know.)

Policy refcount is decreasing properly on 4.19.
Same should be on the latest kernel too.


