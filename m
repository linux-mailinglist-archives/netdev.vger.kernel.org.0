Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D728A569B2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfFZMst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:48:49 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:43366
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726965AbfFZMss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2L+sWsv3kTT2vg2UROCBYk/avkYCdb55Ttmy3WUhtNg=;
 b=rQL4jP5bdNWgo3fvGOMplPHtjxWnt2i6Bpy/W7Urj3EyM9ALdstVvqk7h+XN+E2dEAQeQ1b6mmq+fyH8p0EqHjqWLZmEdkZsM3GwAFLzk0DsNrv4t+WzV1alMoYiZGro0UnSzRDmaabCrATEt0we+3Dd1HsmHX7cjN2qHGIBFmA=
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com (10.172.222.15) by
 AM4PR0501MB2852.eurprd05.prod.outlook.com (10.172.216.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 12:48:44 +0000
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::d9da:d3c2:1bc0:6a8b]) by AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::d9da:d3c2:1bc0:6a8b%3]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 12:48:44 +0000
From:   Ran Rozenstein <ranro@mellanox.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Topic: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Index: AQHVJRbrLKNg9SQxm0O9HRFaFY7gmqagBcGAgAwZnFCAAASEgIAByxLw
Date:   Wed, 26 Jun 2019 12:48:44 +0000
Message-ID: <AM4PR0501MB2769CE8DC11EE4A076B62CCCC5E20@AM4PR0501MB2769.eurprd05.prod.outlook.com>
References: <20190617140228.12523-1-fw@strlen.de>
 <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
 <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
 <20190625091903.gepfjgpiksslnyqy@breakpoint.cc>
In-Reply-To: <20190625091903.gepfjgpiksslnyqy@breakpoint.cc>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ranro@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b74b1592-5f9b-4175-65be-08d6fa349fc7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2852;
x-ms-traffictypediagnostic: AM4PR0501MB2852:
x-microsoft-antispam-prvs: <AM4PR0501MB2852459E4B4946E58A000575C5E20@AM4PR0501MB2852.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(13464003)(199004)(189003)(76176011)(3846002)(33656002)(99286004)(55016002)(486006)(53546011)(86362001)(102836004)(7736002)(6916009)(26005)(54906003)(229853002)(316002)(7696005)(53936002)(68736007)(6506007)(8676002)(9686003)(6116002)(25786009)(6436002)(74316002)(508600001)(2906002)(305945005)(6246003)(71200400001)(81156014)(4326008)(8936002)(476003)(66066001)(81166006)(446003)(14454004)(5660300002)(52536014)(76116006)(256004)(66476007)(186003)(71190400001)(66556008)(66446008)(73956011)(66946007)(64756008)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2852;H:AM4PR0501MB2769.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0vjJ8XLOMDLJ9A/inz/07r9TfAKz+f4CxN4JgKMltXvqCTgWthyR5Mly/bQpF7h9/s/hBQuh6G6s0g35eJSEmxTkiqP7RHUlHsunM+uVz+2WqcQv1yungJJ59emEDnF53QPL+YCAB1mWEUsOUHfGL1DWW8uGyg7EFbZCaq+LE9SruJR6YcDascbNmw860agToyuTbup5ho1Jc89hxj3ljoci7xi7fLOijgtA3IUw7GBw3NNdTaM3zlsAiVozmd3zywaiH6d5EYMv8HFI2gdI6esb4PfXDpeLP1qK1Sy0U0fabVE+K8aBHuZ6U/q8JVZwvQLYTYAU02UC0gHBLA8pGTRR3KhvYgMfUnBbRv8GY7TVz7lipM/yyrFzD2K/NQp7IlYy9YNOPDLuLn3r3Pmy+aDumA/QgmtHAq3g2xY17To=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74b1592-5f9b-4175-65be-08d6fa349fc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:48:44.3490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ranro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2852
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Florian Westphal [mailto:fw@strlen.de]
> Sent: Tuesday, June 25, 2019 12:19
> To: Ran Rozenstein <ranro@mellanox.com>
> Cc: Tariq Toukan <tariqt@mellanox.com>; Florian Westphal <fw@strlen.de>;
> netdev@vger.kernel.org; Maor Gottlieb <maorg@mellanox.com>;
> edumazet@google.com
> Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous
> advancement of list pointer
>=20
> Ran Rozenstein <ranro@mellanox.com> wrote:
> > > On 6/17/2019 5:02 PM, Florian Westphal wrote:
> > > > Tariq reported a soft lockup on net-next that Mellanox was able to
> > > > bisect to 2638eb8b50cf ("net: ipv4: provide __rcu annotation for
> ifa_list").
> > > >
> > > > While reviewing above patch I found a regression when addresses
> > > > have a lifetime specified.
> > > >
> > > > Second patch extends rtnetlink.sh to trigger crash (without first
> > > > patch applied).
> > > >
> > >
> > > Thanks Florian.
> > >
> > > Ran, can you please test?
> >
> > Tested, still reproduce.
>=20
> Can you be a little more specific? Is there any reproducer?

The test dose stress on the interface by running this 2 commands in loop:

command is: /sbin/ip -f inet addr add $IP/16 brd + dev ens8f1
command is: ifconfig ens8f1 $IP netmask 255.255.0.0

when $IP change every iteration.

It execute every second when we see the reproduce somewhere between 40 to 2=
00 seconds of execution.

Thanks,
Ran



