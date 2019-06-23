Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59EFE4FCB0
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 18:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfFWQeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 12:34:50 -0400
Received: from mail-eopbgr00077.outbound.protection.outlook.com ([40.107.0.77]:38625
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbfFWQeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 12:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMYRRO8c36LYruCTeDQkPyYU92gn5xawZ4IGom4Va1E=;
 b=p3JTuZ39ibwr+oZukqeYyDF0ykrEG5AWdtL+GDJPBw77p1yMuLA5585Cy5gvP079m6Sy4TF2eQkoJV+J7/ri5agy+hlsSwbEtbu4D6xvd1QTZPc/e1g8WtD4ZR0BMCpgZL9prbFCoYZxAoVhlZRxL+cAMI9wjx44e2+GTGLMS9s=
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com (20.177.196.210) by
 AM6PR05MB6102.eurprd05.prod.outlook.com (20.179.3.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sun, 23 Jun 2019 16:34:46 +0000
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594]) by AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594%4]) with mapi id 15.20.2008.007; Sun, 23 Jun 2019
 16:34:46 +0000
From:   Vadim Pasternak <vadimp@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: RE: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Thread-Topic: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Thread-Index: AQHVKcM2m6uv7yWu1EeOXJKYv1f1W6apYXWAgAABsPCAAAnogIAAAKpA
Date:   Sun, 23 Jun 2019 16:34:46 +0000
Message-ID: <AM6PR05MB52242201CFF6AF2D037ABDABA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
References: <20190623125645.2663-1-idosch@idosch.org>
 <20190623125645.2663-4-idosch@idosch.org> <20190623154407.GE28942@lunn.ch>
 <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
 <20190623162537.GF28942@lunn.ch>
In-Reply-To: <20190623162537.GF28942@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadimp@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bd2188d-b69b-451e-d4e9-08d6f7f8b447
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6102;
x-ms-traffictypediagnostic: AM6PR05MB6102:
x-microsoft-antispam-prvs: <AM6PR05MB61026C88EFFFB2503683B9D6A2E10@AM6PR05MB6102.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(39860400002)(376002)(366004)(13464003)(189003)(199004)(229853002)(66066001)(6436002)(55016002)(256004)(9686003)(476003)(6916009)(11346002)(8936002)(4326008)(7736002)(33656002)(26005)(53546011)(107886003)(6246003)(81166006)(81156014)(53936002)(3846002)(99286004)(102836004)(6116002)(478600001)(8676002)(6506007)(316002)(186003)(54906003)(76176011)(7696005)(2906002)(14454004)(71190400001)(74316002)(64756008)(305945005)(25786009)(52536014)(66556008)(446003)(486006)(73956011)(76116006)(71200400001)(68736007)(86362001)(5660300002)(66476007)(66946007)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6102;H:AM6PR05MB5224.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Cp1zNSmYqVM388MDS0aVURjjBpxn2G+VGKG3p9Vp4IwLp+A2PfzrJJ2a5Iuy2dzBDBJAfpC7GApSMTf2JMIktIjZvWyRs61mZ4/V8T6W1UNwuz3lPM7IduQyys+rm/ThQvxKL45mwnHP6JRMjXeNa45rKnG1LU093auIdoBReoCbIFUq9hVeBapT2FBLQeRfXO3y4SJjc8cMUyTaE1FDa++28xmXOrZFGaSnFJXEARG0dujymlW1u7R6hxyfPUIyP05RumBCZmGO3qZ9C2Y7RpqJiDulazLRYowLm4jKMcriRBi/ZVNpbiOTKElhpZOc+B3bDXuTUf2ybY9eEMfKSlwt0fp5SaeionMuzU1NvckXlpOKkAHkaWV7OOpUaZlFnLMX2riijBvE6wAxhOQDsbhG26fc3wXX6ffTtHwrHc8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd2188d-b69b-451e-d4e9-08d6f7f8b447
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 16:34:46.7550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vadimp@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, June 23, 2019 7:26 PM
> To: Vadim Pasternak <vadimp@mellanox.com>
> Cc: Ido Schimmel <idosch@idosch.org>; netdev@vger.kernel.org;
> davem@davemloft.net; Jiri Pirko <jiri@mellanox.com>; mlxsw
> <mlxsw@mellanox.com>; Ido Schimmel <idosch@mellanox.com>
> Subject: Re: [PATCH net-next 3/3] mlxsw: core: Add support for negative
> temperature readout
>=20
> > > Why the > 0?
> >
> > We don't consider negative temperature for thermal control.
>=20
> Is this because the thermal control is also broken and does not support n=
egative
> values? This is just a workaround papering over the cracks?

We just have system hardware requirements for minimal speed for system
PWM. It could not be less than 20%.
So for temperature ~40C or below it PWM will set to this speed.

>=20
> I've worked on some systems where the thermal subsystem has controller a
> heater. Mostly industrial systems, extended temperature range, and you ha=
ve to
> make sure the hardware is kept above -25C, otherwise the DRAM timing goes=
 to
> pot and the system crashed and froze.

Interesting input. I didn't know about such feature.
We don't have heaters within our systems.
Maybe we should think about it for the next generatin systems.

>=20
> 	Andrew
