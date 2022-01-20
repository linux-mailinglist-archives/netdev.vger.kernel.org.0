Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3449473D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiATGTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:19:23 -0500
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:46400
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229774AbiATGTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 01:19:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7+r9QfACaUgOuqIA9chBRBD6FzDAg78pYCrAY8Pm7Cu7lRytjmBkJDqXy2fc+kwKg/8xW+WCeZy5XCZUKRWfBNYDhh4eWlpta6nhU7Wgw5rZPJWYiu4QDoJNh7HK2L15QrvJrXIKvcZ4HYNvi9NNOCS/4tADQe7A+wcSZ2aXxIoUTMZYhXK8oc31Gt/3+fLGl1HMPo7/gn4PehAms5tGUFNzPIpfXL+L484kwDVQoeTDKB9W3MJqApPnKAy2wggGa1x2d7wprWBhb5eipm853UB1Z26lg148dgr0taYCrrLs2HbiuMEJuSfPqw7X5eLJ8Buuhi4vxrdbc2q1Ey8Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwwM7PQrwsvLkEFxKMKeqk7rsj8Yf6JgabCpGlqvAMI=;
 b=DUYseFPx8nH1ssbV4DlONDgjZyWR+uOEk/X25nuLXa2OfgWvAKLqNPn/lUG8vY46RdEI9ZlI1uU9WTkYwBVwaAYE4gann9fEI7eDf5xAfAw+vey8sgLuyxgmqUdbpps/izjyyjl3bm/zA3NylmRe+P5d2P+2ZKGy2dpmxaOV6YdD1FTtZjDZZHYuMUrlUBWSfXjGD2q4Uy8kd5xyV9bL43MdWsGKAwxMs3kSXoK1py2jUo4glVXHqEiKabvX3lifKr47zjimAPPQtFzMUWaxo3ivc2Vrg/xWTCj0Y2wrixuak/1Oyg3PSRiyKyFr2bmyRsLYXqdwhYFU74kEjQjLlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwwM7PQrwsvLkEFxKMKeqk7rsj8Yf6JgabCpGlqvAMI=;
 b=apSL/IwswQ1wBgCw5Qv5v4/NpqF4kCVbF47CjPxrAxmYgrzm8GYe7iuR0q8++YhkxfPa6ccMcYeCjxlGq3VJVIPcFOc5q8nnlLo7jqoiqA+fjfr5xm67wRDpeKLVj4TuMJzFUW6wv9kfAyOaq2XVsgozDOIWzFZGVoN58WT8Yh3FmpJod1Z8UdQp4JhKjJbzG2uBMS1lyJBh+CTP1iKommg4RvGF6AjHedHfWJtQmWP7aVlWMvNYgplTkknwAUB1sXi6P7+mEoOiFjmtd/QnMuWKIp9FWqQqX1SoivQ7PX3zJeU78U2AeUuKWeuOMH4xDezAcNvBL7AtojeEgEL2qg==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM6PR12MB3354.namprd12.prod.outlook.com (2603:10b6:5:11f::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Thu, 20 Jan 2022 06:19:21 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::a0ba:d1b1:5679:8ad6]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::a0ba:d1b1:5679:8ad6%5]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 06:19:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPAgAE+YoCAAENcIIAAFuIAgAAELEA=
Date:   Thu, 20 Jan 2022 06:19:20 +0000
Message-ID: <DM8PR12MB548045DA5FE443656466CE6CDC5A9@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
 <PH0PR12MB5481F2B2B98BF7F76220F03DDC5A9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120060338.itphn5yq4x62nxzk@sx1>
In-Reply-To: <20220120060338.itphn5yq4x62nxzk@sx1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccfcf75b-b939-4679-2576-08d9dbdccbed
x-ms-traffictypediagnostic: DM6PR12MB3354:EE_
x-microsoft-antispam-prvs: <DM6PR12MB3354964F26F7563ECF61681BDC5A9@DM6PR12MB3354.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSTQEdDc/vXtmqi09h02ruF7yrHwdcgvcXWoTYeQOtPhB5RkkArfCrOre2bLh7VPlwWYhoL4H/nlWgfOfQ7hNKfObBB9mh8UoZ/UPKxJvWiSIVlqdHaZLeyZCU1Eg2/9qxCjiuAaUpLk/I5w5HY2duBbV6tTTZupW73q26P0M+16Fecd4liKCpoWqr6Yys04NvHfzRhn+sTkbKbugQMF+Ml8/Z0U0iUYYyyOrePyv6xSt3/+EGOmyvZ6NcWjg5sNn94My9Wh50xqvbkuGjPCE8y88twf9x/qaT3aUf/M1yvyhTh2uUc5sQxiXZj3A0310NUilisgBNjhgSSgaLyi33MAA3rwYpeVnAx0GSX6cu++NA2qFDnouU7cvXlvuB1bkKs87W6HLVXjOqu/6scpkQB18p5pcGpdjZTYMm8e8X4zoxnGPM3CKDhxQkrkBIKKj0wyVKvTDe2rgRfTr3JbWys1IP3lWQEW3ZAWP+v2GiSQEszBvKjlW6uQW0IJ7B3ss3Kb3KbPz7RNpg+ZaaTuqqRfe1g4jQTK4ZvTBYkRY10thF5J4CrjQEpbd4PLkk7c6eRt9CqLoZvx3qWdWESrk82Qx2RJ5moXSrXvEcaHQnSvygB0n76+dFj5Q7q99/MydCIbczqUKQMdBfQmdTUeqLY0rs+eac9pLWJsXUYvq+t7GLDyMvmsLb0dD6fZ0KCvzTuBpF0IBiYYf1k5PW5CgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(9686003)(6506007)(55236004)(5660300002)(71200400001)(38070700005)(86362001)(4326008)(7696005)(55016003)(6862004)(186003)(33656002)(26005)(2906002)(54906003)(52536014)(38100700002)(66476007)(76116006)(6636002)(8936002)(107886003)(122000001)(316002)(8676002)(66446008)(66556008)(66946007)(64756008)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tpPihJ6CJksot4A8Dd9Lc4bBsg4eWnmurVVYjMwLF4TCLTaLcpcACyay1AKA?=
 =?us-ascii?Q?xHevTkj/1JyRBAvveplKF7VsyxNzar3Gye9/aJIEGa9EK/XnQTt1j3YSlyCI?=
 =?us-ascii?Q?lCeSaLJzP/XldZdhmCvl0p0rZCxpW9HhpAZZypThtKyaVrwCNAsoXn1zOOVJ?=
 =?us-ascii?Q?X0ad5Yd9mQIz2++XCXo1A1hw81ziM5wufu2bLbVYvsBKzFArhq5R9H4qIeQa?=
 =?us-ascii?Q?s1FEqcMjnvWHWG4J6iNJKLOyZH/o9hnLJ1yvILhyummUoPTpKDZK/FkqeH2c?=
 =?us-ascii?Q?83fFu6YD7tO/lnwTTTKCXb4URvM/9jwf8/3OAUAPEdvu6a0y7jmLt90rKh77?=
 =?us-ascii?Q?hdEsAUrJ5RPO+RiFFRyRf/KzIl+NirUrmkOMjrZwwJ+2Q7MBps78mm1SL8NF?=
 =?us-ascii?Q?LuFLAqzg2K++qTLLiGXJftxVY6gYHM2j5j4nqCVe+KWwhWmiNy95xxXcFX7W?=
 =?us-ascii?Q?pMt/Xooq8e5rClz8bu/pEG9Ok7BJXX8Bj3q2MYjlYCHos/9L1mF+6qglYcCp?=
 =?us-ascii?Q?1S/0EEsVzxXyYHA7vNz5ZtKOvDOovLxhCtAHdRkAER8fKEhEzsX1MGJawY/7?=
 =?us-ascii?Q?TM059GyvRpAttfv6REFY/D2nljOEPr2s/O5N/nb87S7HU+CJNp9v5QIOH/BC?=
 =?us-ascii?Q?hclQ19ruUd5QGhQPdvDdmlacEtVvSIEO9AUyriuSZCIXO8e/Mn7JJ/JIR7jz?=
 =?us-ascii?Q?/vtjE3bNKUzLfqxN8mzYutUsLp5dauLio9I/luakMqPLsoQeLK5i2ZuKXDna?=
 =?us-ascii?Q?jBtnsIQqp+pbRaIyVbML3ZtDosyNWrTYsCQP+jE4nGCgcZgtTbcdww2oik5w?=
 =?us-ascii?Q?dVeSWlI4zR0e9Ft180uw+8I4eb/ve7HVH064xXd4jUhlVmVL0nj97PwC+zX9?=
 =?us-ascii?Q?/VB5Hgn7t+aoultim1SgUqssJKpnOmn6+zLshGLCdpwjZKzr/DkvjxkPbLuw?=
 =?us-ascii?Q?ua+Ba6rt07k96URTTDiWgU+rn8TCpN3g0dr7x5//c7nCzGM5GabXqTmQTdIl?=
 =?us-ascii?Q?H3QgIpUzYV5pn4ZFlBD39dIb/qzWSurewBJm+lk9PdEBMchJcNa7LxEaHjD3?=
 =?us-ascii?Q?u95GnENyTKzSDW4oOSHYSBEBTbShSQjFokQOR9zq5i7B+ZkKPU3HJxleUnxs?=
 =?us-ascii?Q?pQhuWQ6D0ZzM3woIh8HXkpRtXxZRknPrj3pCz3B0T9ot3HIVofbfqBKg8Yqs?=
 =?us-ascii?Q?5KouYwccJv9lgArszYi3EQxFP2D2vIGNR7ul4Rw9J2Wj8kvjxmey6RjScGK6?=
 =?us-ascii?Q?H018bPi1SZ6hG61VZ8wsAi1dvTxlPJ4ZwhCnAS5/AUzqC/QRRH5oRGWkdlIN?=
 =?us-ascii?Q?eqD1jVRgGdfkbVDpwfeQC0/IhGWkRNDqLGrGSFI2qm6/hbYvl1K6GSRnanqe?=
 =?us-ascii?Q?SpQ4+Ka6+k0bvlQHhZ3/HVQkaIzG99xb47TAK3gtCo/HkDnTetYez2MCJEc+?=
 =?us-ascii?Q?MAXMSzTL0LnkJn4OJlTATmdCDBvNLOQVlhSj+5fgc692THcbPurj5hAjj/iK?=
 =?us-ascii?Q?NSXsxQ2S0TRce6gl20cY9govjfeRavaXy2c1V2hHzPT43Hubjrsba0hL0yse?=
 =?us-ascii?Q?AtsNIDygvulvTf3ZNd9wXlPHRsy4VpPEmyOr2pGlEqBg0D1Edj988oK+usja?=
 =?us-ascii?Q?PEhUdcCeb3Jkv491XHI5pc8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfcf75b-b939-4679-2576-08d9dbdccbed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 06:19:20.8834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHxRM2YO7NlE+tDepBCbJEAp7oaN0s+jeq9C8WGZ4LcV97HLlmniRNQpQ7GE+KLCF1dR0UKzLChCNuvNDdbv0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saeed Mahameed <saeedm@nvidia.com>
> Sent: Thursday, January 20, 2022 11:34 AM
>=20
> On 20 Jan 04:52, Parav Pandit wrote:
> >
> >> From: Saeed Mahameed <saeedm@nvidia.com>
> >> Sent: Thursday, January 20, 2022 6:11 AM
> >
> >[..]
> >> >
> >> >I do agree you and Saeed that instead of port function param, port
> >> >function
> >> resource is more suitable here even though its bool.
> >> >
> >>
> >> I believe flexibility can be achieved with some FW message? Parav can
> >> you investigate ? To be clear here the knob must be specific to
> >> sw_steering exposed as memory resource.
> >>
> >Sure.
> >I currently think of user interface something like below, I will get
> >back with more plumbing of netlink and enum/string.
> >
> ># to enable
> >devlink port function resource set pci/0000:03:00.0/port_index
> >device_memory/sw_steering 1
> >
>=20
> this looks like an abuse of the interface, I literally meant to control t=
he amount
> of ICM pages dedicated for SW steering per function, this requires some F=
W
> support, but i think this is the correct direction.
Ok. I will evaluate and update.

>=20
> ># to disable
> >devlink port function resource set pci/0000:03:00.0/port_index
> >device_memory/sw_steering 0 (current default)
> >
> >Thanks Jakub, Saeed for the inputs and direction.
