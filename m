Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067C546E6F6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhLIKti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:49:38 -0500
Received: from mail-eopbgr50136.outbound.protection.outlook.com ([40.107.5.136]:29214
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232702AbhLIKti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:49:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYPMafbVe+q1lwwr1TempCpJxctMLSGQzt0Xsu2HcagTGm4yq4qOPVBD6NPTLtr2KpX1QZjqYTcMkZju14Zftm04uL3M42+0IXfLk94ExHqEATwdn/H/V2MGNPfn0zcGv+kiM7vpYDQ8Rq0vpvjG85Qnb1Dn+JlCOAvCfyWGTpDpbVAvVpZar7K7hpxyY7NWp4f+ZbIVVTmisBc+bseR8PEAlwMrDb97Hr5qb9p2xFilXgvntGFdAsPwS81hlVBu5K6nMRN/WXBkPfgTWLt8vsP2f2ciQh2apmnrS7RZGZlXF5wKfRpVC5CumtRDN4xnhoyCUbdD3Uq2uuq+tv7F4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7B1pXv4zYfi8NEuZOVuAdKw7MwxpoFLEKxrDAHhfHw=;
 b=UOH/QM0YTWn509l9zGLq+ekHdoVqZaUa0Rha4VzKtOaIyV3zcV865beyCqABlnJGB2bsL5lRM5LWWuW6NY8kWTw5qZ9QYHrTLOlpoJgdcs0QV9Z8fbXyKRHYs01JqbeeB9rxs7GQPgNx7r0098ds1xblExIeqSEPI39og5kNu1EOeRpYqzMupV9Z5rGFUfJnOrm2ImId1c6E4jYO0CHBjd1JO2y2uzsU1KwcP85UsgFS8EsG6K21l5BanMRMphiRWXC9zHyVLiuf9qYMYBdnNxDDd+5Qo4kGrGRZUwOe0r4r4i/FhMCQ5gkp2a/SFQRrJM+1G7nPYsrIabf5XRB34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7B1pXv4zYfi8NEuZOVuAdKw7MwxpoFLEKxrDAHhfHw=;
 b=QoxTqb11nzehktDj4zg0I5RS7k3bJfXydWKihceckEutK7SoH8Su5/Hnv+e1eFMobVtORZeIoLDkHZQ0C9vkqvQ2FHBDzzKeRYnm4aborkSB04kf9eRmUKpgoODAZvKOp2TEBPkanSPCAzQQbgvbjgc4JV2DoIsZm1EqZKUMsrk=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0990.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 9 Dec
 2021 10:46:02 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 10:46:02 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: prestera: flower template support
Thread-Topic: [PATCH net-next] net: prestera: flower template support
Thread-Index: AQHX55R72e0BLdbnYk+svnQj9X0JyKwfdDOAgAAAvSCAAAmxgIAKdbyW
Date:   Thu, 9 Dec 2021 10:46:02 +0000
Message-ID: <VI1P190MB073490ED820B9BF0356059398F709@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <1e86c2c7-eb84-4170-00f2-007bed67f93a@mojatatu.com>
 <VI1P190MB0734C11D7BCDA57437264E698F699@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
 <c8379f78-01da-cd2f-f4e2-99874a01f995@mojatatu.com>
In-Reply-To: <c8379f78-01da-cd2f-f4e2-99874a01f995@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c7373b07-e5b0-bdd3-310c-abb07a6626e6
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9601898-a995-46de-b8e8-08d9bb011860
x-ms-traffictypediagnostic: VE1P190MB0990:EE_
x-microsoft-antispam-prvs: <VE1P190MB09900993DB5DCD62017940958F709@VE1P190MB0990.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cX7DxSf4X2WHzcBAEz/oWQih7BemGqP0d+p3546UcFllYKrTVuoEQoIRwY7mKpkZz3Q6Bc86PlQyEDgxuy4kORRVAoRXYMRBpNmdvU08Kdvkvcy5iX7FQNKewuTBHrCC4QLrHrvmR2ROQ9Kua928LL9nmShJPggU23chxKHfAnmdQC1qUIIWe2t+TcNPsrQVq6Uvcj8zUAPOCb49KYBFBvzhzEyH/yymENUOlHHnprAiyECD8o+R9cecJaluCmmVLWXqae+jxM98dv0ciceG7+VSx6oU6vSPOB+DJGn+/GAGlOfVV8IgNToKVdaXK5MPql8RhybpLio2ieX42Or/Kw1G8bjXbugBJpbkuAgtoqovWczzvp53kMRuR/WzCNPcLouyMc45I1CVeC1tkYrncOWZ4CBysSLr2iLSW2akbOBMdgWdco0jmj03S+P62loF9h7ts90MSo529kaKM0L8/Wyfg9FvlIdiCZEFKDhPEc/LYwZcO7RA01YPkO2Lczn+V/xh0GfFQAgedCG4BsvFWzCv1MCLhG3DtzGkMUl4454vT8zWb1Oc3DU4Q67kj0Zx27f4b8Ube0AdOLSxchkRFL8HhAfn2dl/8+dvFjJ1N6xEpEAqhXdSfncDL8lWRYtdjRHDcVE9xypnGLTE1G1KS6A/JYzvrYlf2p/TH93LNG/doen4khu2DAiIBUOxN9KMs3O53A/0VV5coc/voih8oQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39830400003)(376002)(136003)(396003)(71200400001)(38070700005)(33656002)(7696005)(316002)(110136005)(54906003)(91956017)(2906002)(76116006)(4326008)(186003)(8676002)(66446008)(44832011)(83380400001)(66946007)(508600001)(64756008)(66476007)(66556008)(8936002)(122000001)(38100700002)(5660300002)(55016003)(52536014)(6506007)(26005)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Jzf1HFHVwiJb91UyLK7ddqHoehJklPtVa0HqjDFIowuV1wrT/XXc5VM28l?=
 =?iso-8859-1?Q?PITKxarFcLF2ieQtoNIRIql4bUywoRs8HAMR8Pf9zYhyETV9q5lSKVgA6h?=
 =?iso-8859-1?Q?+ME759YntqgKYYDLLP2qMa5cZSv2zqM68B205KHCSX5OYXtQ4s5aFAml3t?=
 =?iso-8859-1?Q?6WiRTU/sKhHLDJotZERx/9+X1XqMwyNPFC9Xdb3IkopTFhTkLEjjEX6DMg?=
 =?iso-8859-1?Q?QZP+pQXND2c/iJufAK+fenkY4YqfeLbfKL18J0Zuz/igx7ymnqIzQp0q4x?=
 =?iso-8859-1?Q?lTyNflCcOu2wkAiBsX6nMCH27pUWfnxPA/RhTB9i6lgwBgAQ+VAwaeOANt?=
 =?iso-8859-1?Q?AM9vYwdwFLDavhpcWZGPd3o01X75YAAVvf3OjpzyAOvjz85GA7gIWkGS4W?=
 =?iso-8859-1?Q?K+awIuXMPe7+Wl7uPVTuMPovnjECCV3KYo7CKu2bCi78jzFlSwLoE9bBkm?=
 =?iso-8859-1?Q?Y2EfsjkGLjHEET5uURE03fAIW1sU/f8YHmXrj6m3G8gF56jCVBAZhZ+JyF?=
 =?iso-8859-1?Q?9MSPwQKQPL0kgWnec/CKvGciPavoXaaJq1Irwqp4F+Hb8oFvOur7anpLsC?=
 =?iso-8859-1?Q?3RwTjSlpEsSR4pMj2xbk5F0ZocfOH+csbYWJQeVNU2CedfqrOoadboDybK?=
 =?iso-8859-1?Q?ZlHAGcLyf9poKtXR1nR90VFsKprgaq9sG1PrZ9ZIkIbO1uKZbDyX1nmfeO?=
 =?iso-8859-1?Q?WD/lyv6WHHUD0lMLkq1z0KiWFQKAp8ZQ8cYjI+o5uZf8LsrUxB+oVc6P5W?=
 =?iso-8859-1?Q?CFLHsFNXp17sjlNNN1F9TA0WbKP1C7P9syElOLXvzOijEXHInixdIG7jpB?=
 =?iso-8859-1?Q?eS0sgX5HOGpRCJnZwLr09iSvzOBLCRtwqRa8Af4cd6N+oyBwv0mja8pjAp?=
 =?iso-8859-1?Q?r5+nH0pehbzrDG32Q1fgB9nsgf/G7yIihMlKqDKfRScJmqNmb3BUBXzRhR?=
 =?iso-8859-1?Q?KXGRx5T0tp2wQBqyPQmZXU+uEn9eZdJYw1L3QYwQGlgDgdkDbfq2HN3l8G?=
 =?iso-8859-1?Q?DNC2ER3OCih2ZDOmaXlUE060/ufoW56Y/HsArAx3YXHeHzSZ+1RVXmDNJ+?=
 =?iso-8859-1?Q?rMTbgTni9Eq+YEM9h9hGEKaN2QyZJpXJkRXu61hSbR0UR6guQ2BivdCrLc?=
 =?iso-8859-1?Q?xS9MD1fKgj9U3F22snFMEdBDDGT8WxsiBGX2l5odZ8AA470IZqXi7LETm/?=
 =?iso-8859-1?Q?H497Y94yCRoJ1Asd7/NIeIrqOiGTZqquYQ0Kcohv0RBsue+lg7XwlmlhCe?=
 =?iso-8859-1?Q?FWByEJP5n94/0Fm86z8pxVAhzSazlOLBUATjlJ3u9VRwpT3YXLWnT+WjsS?=
 =?iso-8859-1?Q?t/Egbu8nICbv5vAM4T/YBxuAqi4RZlmWanssCfWAWuS6khZ5/TbVuaXaJn?=
 =?iso-8859-1?Q?Ms9S7MGnaafiN3YIlbsPu6AelLXuBb/xYcXW+Pv8A4+J6sxKseAyWoXFph?=
 =?iso-8859-1?Q?SqunhPsUPs4UeuFugg2Ji0rwG6s4QQz86q4Wy3qFkCy/AWsnx8QfoM583N?=
 =?iso-8859-1?Q?wPa4j3iCgMqUZp+gc3N/paEFCTlLG9N1ZeNWe6higRzoYhR4Hm0MjR/96R?=
 =?iso-8859-1?Q?d563PgmCbEs4Ok/qb3mbI5Ag53/hLd0G9P2UJ6GFrXMCR2OpvZtSL/4kOr?=
 =?iso-8859-1?Q?chR859NXp6R9a8P59NGoGuXYLUz77mVHW2wcViPE7WjYCcOtWihjG148se?=
 =?iso-8859-1?Q?UyvHxu2Tne6FtQQVhv6tj/EwROTvksHHa7W98wOTyLMFuE3JyqDF4mZuEN?=
 =?iso-8859-1?Q?fzIQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f9601898-a995-46de-b8e8-08d9bb011860
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 10:46:02.6963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CuZaxvMRWbpu0MU53tQ/3z05h+gzrHywgS3QAKQWXGHgdPUQISAGTiD2DtkqGHZeOdyHr6siGyQ2feJe4rTuGKId5G4nDhMZXoJlOkYXl9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0990
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,=0A=
=0A=
>=0A=
> > Hi Jamal,=0A=
> > =0A=
> >>=0A=
> >>> From: Volodymyr Mytnyk<vmytnyk@marvell.com>=0A=
> >>>=0A=
> >>> Add user template explicit support. At this moment, max TCAM rule siz=
e=0A=
> >>> is utilized for all rules, doesn't matter which and how much flower=
=0A=
> >>> matches are provided by user. It means that some of TCAM space is=0A=
> >>> wasted, which impacts the number of filters that can be offloaded.=0A=
> >>>=0A=
> >>> Introducing the template, allows to have more HW offloaded filters.=
=0A=
> >>>=0A=
> >>> Example:=0A=
> >>>     tc qd add dev PORT clsact=0A=
> >>>     tc chain add dev PORT ingress protocol ip \=0A=
> >>>       flower dst_ip 0.0.0.0/16=0A=
> >>=0A=
> >> "chain" or "filter"?=0A=
> > =0A=
> > tc chain add ... flower [tempalte] is the command to add explicitly cha=
in with a given template=0A=
> > =0A=
> =0A=
> I guess you are enforcing the template on chain 0. My brain=0A=
> was  expecting chain id to be called out.=0A=
> =0A=
=0A=
chain 0 is the default chain id for "tc chain" & "tc filter" command,=0A=
so, that's why I did not mention it in the command line. Please note,=0A=
this patch adds only template support. Chains are not supported yet,=0A=
and will be added later.=0A=
=0A=
> =0A=
> > tc filter ... is the command to add a filter itself in that chain=0A=
> > =0A=
> =0A=
> Got it.=0A=
> =0A=
> =0A=
> >> You are not using tc priority? Above will result in two priorities (th=
e 0.0.0.0 entry will be more important) and in classical flower approach tw=
o  different tables.=0A=
> >> I am wondering how you map the table to the TCAM.=0A=
> >> Is the priority sorting entirely based on masks in hardware?=0A=
> > =0A=
> > Kernel tc filter priority is used as a priority for HW rule (see flower=
 implementation).=0A=
> =0A=
> The TCAM however should be able to accept many masks - is the idea=0A=
> here to enforce some mask per chain and then have priority being the=0A=
> priorities handle conflict? What happens when you explicitly specify=0A=
> priority. If you dont specify it the kernel provides it and essentially=
=0A=
> resolution is based on the order in which the rules are entered..=0A=
=0A=
The HW rule insert/delete into TCAM is done by the FW itself. It means,=0A=
that the FW will take care about prio and (re)order the rule based on the=
=0A=
priority provided by user/kernel. So, kernel driver just need to provide=0A=
prio to the FW when adding the rule into the HW.=0A=
=0A=
> =0A=
> cheers,=0A=
> jamal=0A=
=0A=
Thanks and Regards,=0A=
  Volodymyr=
