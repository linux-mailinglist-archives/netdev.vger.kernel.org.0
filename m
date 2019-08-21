Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A2973AF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfHUHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:37:31 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:1878
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727210AbfHUHhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 03:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwzxKLLyVOGXcFbszd2vvhGuKTdQVrvQNJEJLP/TTJAbm0zbh9aXXj0mV9O8QtvWkU74d23Ew+VC3uj1Jz0Xgn2peEEl3sVVeC4vzQWTf/7QQBVZptS46gBClsRRbctdR5t6L2HedjpSXZp4/xRMCWJyWB5IYjj4j/040cFVtG5ydrufLrWo60ENjpN1iRaJELUZO25+bMIPe9aMn3y2R9KBmLjZfUH+As5Jh+cL1uQqYB1KwAvytmwDQ/eXxwBGV8ha2lJbiNijSfHmIRn6U9I8iIl08r2uVfmiLn+Ss94335grSu6ohbZIAJOLEQAIX7Lf7IG4h7CXCt7BYyouWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNVovdRE1LLbD3B2URl3OptEH9GJ8q2qU/B2uRGcRLk=;
 b=ODcAyFq5vHghwmKNfN6quCLZafiw8DXbsWDfME9Ts1EHp5lC6OmYYmryiBEsbW8KWtqJNwSScyAAW5djlk0yLQRkLotGR2PONZUonl7uVE1+MZz/sLd799VO5MSiZGMVuSVBba5Aq8OGTMAsviBw0L7Ae5WgrSgQEak3t9msPUEgvkOHmuIsbQUAHaLj2SNHIEaQuS1blF7ngXSLp+YTPSle68qNaPE9B+c6C3LDZitmmO/BlNg0zIBtnw5pQjD27yvidoQ2sOBztfJJXYi93lgOIyDbYo9rf1QF0yCk22XQJApSjVwFIvTblyGp7WCAG/yz/havrdOn9TCxp2dgPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNVovdRE1LLbD3B2URl3OptEH9GJ8q2qU/B2uRGcRLk=;
 b=I9uNOutIiedHUIEQnBeu7g2qN984Vf+uuFgAlR0UScx6Ht+BIP6cWk9/mEjYJSSGx8UA7VBnQhBRntsGVYhvfuNRksVxau2SyS2EkjpflIdvCp1+pODIL2NQhP55F8CwAcbHshqWAv3pSHrFCb/M9JblmJ37eUNmieI10nNw9Mo=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4985.eurprd04.prod.outlook.com (20.176.234.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 07:37:25 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 07:37:25 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQAAB+dAAAAHQ0QAABmv2AACvZoLA=
Date:   Wed, 21 Aug 2019 07:37:25 +0000
Message-ID: <DB7PR04MB46204E4A3EBD5DD665F492D38BAA0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820093800.GN2588@breakpoint.cc>
 <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <DB7PR04MB4620B6ACB01BFA338ADAED048BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB4620B6ACB01BFA338ADAED048BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c431f8de-5c2c-4cdf-2dec-08d7260a6949
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4985;
x-ms-traffictypediagnostic: DB7PR04MB4985:
x-microsoft-antispam-prvs: <DB7PR04MB498537789A1445824FFB18538BAA0@DB7PR04MB4985.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(13464003)(189003)(199004)(53546011)(6506007)(86362001)(6436002)(9686003)(14454004)(55016002)(446003)(7736002)(305945005)(74316002)(6916009)(52536014)(33656002)(476003)(11346002)(26005)(486006)(5660300002)(44832011)(186003)(102836004)(2906002)(6246003)(229853002)(3846002)(6116002)(8936002)(76116006)(81166006)(81156014)(316002)(71190400001)(256004)(66556008)(64756008)(66446008)(66476007)(8676002)(14444005)(25786009)(4326008)(66946007)(99286004)(53936002)(478600001)(7696005)(76176011)(71200400001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4985;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RCwSOOrmgQnuTBSP/OrxjD4MVliO85IoxV7qRtonfTLpZZODj7D+2R0U3xVtAjFsK9iogD8HzHmJTIb6/2szPwEzDGFxgCEYJu6ZYz38CxMYdq/q3JkXw5x6cipgmyhD+yOHDK0WbpV2mrdDAoM5BWYWbT4Ny3oIuZkIZdsFPUiT2wWvsLVpVVKcyQlEdieNNldoVuhyC11MNzgj3oOcZO5naYxxLhGJqBlpjBH9onB4Rji5GS1QSnTLhGokKdHI+w2oTzMYgs5HBy6T4k2lipbQ8sWQqo32bZqoF5GTzXbt4C7rjkuNGHHTUiX9z/YR/XyGr8sxKAjczh9p5OHM7jQWjbHTj/dpXkqSa1h6r2h/ELT9rVKcr2mW6Nx0x5MnTEmqfkvp4iC5yJGITnLoGxNxuC2MUZV/PwqSllIaris=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c431f8de-5c2c-4cdf-2dec-08d7260a6949
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 07:37:25.3257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZS0/pNMb3jH/XfP44S1u4zle/doPnZ7QP9aetuJyi1fJahOcm7UvJRxlFvAcwO74KmjrnqcLm2cxU4pl/owog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4985
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vakul Garg
> Sent: Tuesday, August 20, 2019 4:08 PM
> To: Florian Westphal <fw@strlen.de>
> Cc: netdev@vger.kernel.org
> Subject: RE: Help needed - Kernel lockup while running ipsec
>=20
>=20
>=20
> >
> > > -----Original Message-----
> > > From: Florian Westphal <fw@strlen.de>
> > > Sent: Tuesday, August 20, 2019 3:08 PM
> > > To: Vakul Garg <vakul.garg@nxp.com>
> > > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > > Subject: Re: Help needed - Kernel lockup while running ipsec
> > >
> > > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Florian Westphal <fw@strlen.de>
> > > > > Sent: Tuesday, August 20, 2019 2:53 PM
> > > > > To: Vakul Garg <vakul.garg@nxp.com>
> > > > > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > > > > Subject: Re: Help needed - Kernel lockup while running ipsec
> > > > >
> > > > > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > > > > > With kernel 4.14.122, I am getting a kernel softlockup whil=
e
> > > > > > > > running single
> > > > > > > static ipsec tunnel.
> > > > > > > > The problem reproduces mostly after running 8-10 hours of
> > > > > > > > ipsec encap
> > > > > > > test (on my dual core arm board).
> > > > > > > >
> > > > > > > > I found that in function xfrm_policy_lookup_bytype(), the
> > > > > > > > policy in variable
> > > > > > > 'ret' shows refcnt=3D0 under problem situation.
> > > > > > > > This creates an infinite loop in  xfrm_policy_lookup_bytype=
()
> > > > > > > > and hence the
> > > > > > > lockup.
> > > > > > > >
> > > > > > > > Can some body please provide me pointers about 'refcnt'?
> > > > > > > > Is it legitimate for 'refcnt' to become '0'? Under what
> > > > > > > > condition can it
> > > > > > > become '0'?
> > > > > > >
> > > > > > > Yes, when policy is destroyed and the last user calls
> > > > > > > xfrm_pol_put() which will invoke call_rcu to free the structu=
re.
> > > > > >
> > > > > > It seems that policy reference count never gets decremented dur=
ing
> > > > > > packet
> > > > > ipsec encap.
> > > > > > It is getting incremented for every frame that hits the policy.
> > > > > > In setkey -DP output, I see refcnt to be wrapping around after =
'0'.
> > > > >
> > > > > Thats a bug.  Does this affect 4.14 only or does this happen on
> > > > > current tree as well?
> > > >
> > > > I am yet to try it on 4.19.
> > > > Can you help me with the right fix? Which part of code should it ge=
t
> > > decremented?
> > > > I am not conversant with xfrm code.
> > >
> > > Normally policy reference counts get decremented when the skb is
> free'd,
> > via
> > > dst destruction (xfrm_dst_destroy()).
> > >
> > > Do you see a dst leak as well?
> >
> > Can you please guide me how to detect it?
> >
> > (I am checking refcount on recent kernel and will let you know.)
>=20
> Policy refcount is decreasing properly on 4.19.
> Same should be on the latest kernel too.

On kernel-4.14, I find dst_release() is getting called through xfrm_output_=
one().
However since dst->__refcnt gets decremented to '1',=20
the call_rcu(&dst->rcu_head, dst_destroy_rcu) is not invoked.=20

On kernel-4.19, dst->__refcnt gets decremented to '0', hence things fall in=
 place and=20
dst_destroy_rcu() eventually executes.

Any further help/pointers for kernel-4.14 would be deeply appreciated.



