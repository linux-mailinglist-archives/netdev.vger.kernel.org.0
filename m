Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102B695B00
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHTJaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:30:11 -0400
Received: from mail-eopbgr40063.outbound.protection.outlook.com ([40.107.4.63]:42439
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728545AbfHTJaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:30:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQzlni6Rx7bG2kg/XpecX3iu0KocrykJoV8+wlSMWsD8cXFmaShg9f7PjD+m14K1dfv9fS1pIhgqGtQu05BqkcmfnCrAJ0bQAmze/KYpJb3YRG5LRzqevrza8dMGCLoJG9oYvg9Lt9dDFfPqT2FQA3qveXwGSwMqnKCXIjVWD3GznNx6e4ghu/zvF6WqE1lHU0HlNjilphXZLaFUK2wUWmePlF+uQeZOdHDzzgNmevc2dqYO/LLk2SgogSPs9fSBvFSgMBF4Rw/uPIv55bno+SebypjoJXjlALrvqyIOioj+GyKcy9HI1WRS8CBlpfBrj9RwVR4t0SZMutcq9ftS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aqe00TsG8AeA/83HUouyJ/qlWIQ5aDNCRbFJxp0X1VA=;
 b=mWWdqcxX3dtAt4QjwDr7nBhxR8ds/GCSVS2aFpVRrdKQ4iEFx/e/gU2JDsp61a/ISd1kwhggVkHpzGoMsy8kuH8/OZIYE126WQ9Wygu1wiiBExOU7p+lsh3kGbeMRn+p5Bl9fz1nKtCbmdPyLkn44IoSuMDnoeaxMWmMCcx/fQMmr1mM5UVH1tTy+a2T7jc6u2KEE2G7Sc0RrXgtoUJGRpXSOMU3qcKhDjZV8o+6hU2PlpR164pot+mOcbI2r+Hy5sPayoFb6mgxk1A+Qb1pjrDITNbL9Ed86EQEOV6h2YmwNYaA44BbHCp2rVD7lEuY1qM1ZnfLxWMiTtr5ciUBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aqe00TsG8AeA/83HUouyJ/qlWIQ5aDNCRbFJxp0X1VA=;
 b=Jlfb5u2OJsPDmvhW49v7K1g/FMzqCnoTo+JlSVu5hZ1trNrWKazG+ALsiqjx7ZchyeM+HQGPMIUeNjKCIF1BUaYhFIh4BQ8MBzw0/uYc73XnE18TJfO4jcJXRpxa3dD6nsyQ8gzXlnblUbpCrZ8B09c2f/Z1qQhfGPQw4SuEllc=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4012.eurprd04.prod.outlook.com (52.134.108.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 09:30:08 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 09:30:08 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQAAAxioA=
Date:   Tue, 20 Aug 2019 09:30:07 +0000
Message-ID: <DB7PR04MB4620D6F317369C2237AEDC968BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a049e319-e7bb-4ea2-4823-08d72550fdb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4012;
x-ms-traffictypediagnostic: DB7PR04MB4012:
x-microsoft-antispam-prvs: <DB7PR04MB4012BD59D488EA249C89AE2B8BAB0@DB7PR04MB4012.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(13464003)(189003)(199004)(6436002)(71200400001)(9686003)(66066001)(55016002)(25786009)(6246003)(8936002)(4326008)(14454004)(3846002)(6116002)(74316002)(44832011)(186003)(71190400001)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(256004)(11346002)(7736002)(446003)(486006)(86362001)(476003)(305945005)(2906002)(76176011)(6506007)(53546011)(102836004)(26005)(99286004)(7696005)(478600001)(229853002)(8676002)(53936002)(81156014)(2940100002)(6916009)(5660300002)(33656002)(316002)(81166006)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4012;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jIqyQwvDdN4IiEcwmUtDl/fiQpZb7Est792GuBGNDWdvIBzoy72OfjIaY1f7agndA9qJSxuv0SYVrAJw/d2440+vWv0s4Hkt8s1LPnwVHp4JMUrJuIDsSM4mDZ12bVKbfjCCFr/EcBOjCnF6vdiBj5fe8EOUTa+hNXVnwkWQ8XcMtoJhyMunyj7aAB63FAu0hedjnCQOB+3fbnT8Tj/5GjGHkEW1QInd8QIY+7WKwivuzFBTe/5RE3Q8mOpS551Y0SqDRpU95E834JasSdCOw+PZ1vt/isD9U0k29Chw+LXUHsyh5ROb6Arbfnxs9nDKbbdKpnvSqrCOaKbzk6jSprRSzbt8o9umDNLSQcWeVlQN282+tD5C6sK50kSZNTMo2hqi7rWf9MeXHUrNN1qCJc6lRcl4ZuVNO98hm5zE3FM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a049e319-e7bb-4ea2-4823-08d72550fdb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 09:30:07.9779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /jvjrbC8ZEw6SWaoGt0w/zpbS+5LeZRU8kZYYB65kAzEque0heiwSL2gZzavSl/J8mWJGNoj/w/J2Cep9cCZbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> > -----Original Message-----
> > From: Florian Westphal <fw@strlen.de>
> > Sent: Tuesday, August 20, 2019 2:53 PM
> > To: Vakul Garg <vakul.garg@nxp.com>
> > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > Subject: Re: Help needed - Kernel lockup while running ipsec
> >
> > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > > With kernel 4.14.122, I am getting a kernel softlockup while
> > > > > running single
> > > > static ipsec tunnel.
> > > > > The problem reproduces mostly after running 8-10 hours of ipsec
> > > > > encap
> > > > test (on my dual core arm board).
> > > > >
> > > > > I found that in function xfrm_policy_lookup_bytype(), the policy
> > > > > in variable
> > > > 'ret' shows refcnt=3D0 under problem situation.
> > > > > This creates an infinite loop in  xfrm_policy_lookup_bytype() and
> > > > > hence the
> > > > lockup.
> > > > >
> > > > > Can some body please provide me pointers about 'refcnt'?
> > > > > Is it legitimate for 'refcnt' to become '0'? Under what condition
> > > > > can it
> > > > become '0'?
> > > >
> > > > Yes, when policy is destroyed and the last user calls
> > > > xfrm_pol_put() which will invoke call_rcu to free the structure.
> > >
> > > It seems that policy reference count never gets decremented during
> packet
> > ipsec encap.
> > > It is getting incremented for every frame that hits the policy.
> > > In setkey -DP output, I see refcnt to be wrapping around after '0'.
> >
> > Thats a bug.  Does this affect 4.14 only or does this happen on current=
 tree
> > as well?
>=20
> I am yet to try it on 4.19.

Correction: I am yet to try it on current tree.

> Can you help me with the right fix? Which part of code should it get
> decremented?
> I am not conversant with xfrm code.

