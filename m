Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB60F60D5
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 19:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfKISNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 13:13:36 -0500
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:14917
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfKISNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 13:13:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSJr5YSxnDr72Jd66DBIaLo3cUEzJlx4MVDdLzvwYlxY5A5G4WEQoMLfBQ2hNKZ9os6dCyD4oTn5xBKI7MWGux3Xa/KH+hKNpNo1/3PUmRODw2xEuTprFiRxPiPwPclBRT0e3avgzMXEXwnhqEiKcU5JwsU1A9ZblPDtda0NcKLlV6Q+9sorX9hios3qZzLn/97D0JDUixIoFhNrKx9c0lf8Qlops1PAw3dDEqIr3I1PjUI5TadfiUkQYwrjbObLFffXGYuaXNrgk3qBH9FeeWzcfYIagnQSQDY5dWlIcMh117+/0D5RW9JtXnX0VZVeeaX8pXNafws+m9Z2wfntgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQyZsSeU6HonI/uzMW9P5WPzCut9s4DEXR33UClvhRE=;
 b=N/hFeZzWDOs/ZP+mHuJ6K/bI7Ii99dOF8m5bvr0LoRx3Frh4HpX1S/sSoi6au/ZX2ZgHNrTQ9sAb2u3hSS6W/eKqE/2gd/+ss9CO72vQB8VPS6dPScpcNiLRB64cl1HZLZZwpt0kMTYnbQi2x7IY67HQHnFadf17ngvjruDST34X9wMqastB0XhHQc4myVU91tUauCwIlySfTLiDrP+w2Uy199v3nE2lsiAFX0dFuzXbJgJyKUuuKyh7WQv+qyqhx3tsUowZc0FCLL1VFNYiknNr9KBvHO6rpDSkwkDFbOxg+I7rF6A16N4A9HM5VWoGHt9GVjmToZhkBfijdP4SxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQyZsSeU6HonI/uzMW9P5WPzCut9s4DEXR33UClvhRE=;
 b=tNAQyDzDaCgcrx1tH+XTpiyDEzl4pp9E68cE9vcTp8+JBkIAJG1TM3vikFGlACXF0XaSNlNzMlMhmAcf0Esawz3pPVL58Cu1cGktQ+qTrWxdtqmRBLNWnYR3ajQujpT6N0hW+q1w/a8eOfmNzkzQxsUKf9j9NU1gel/4RN8ComY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5185.eurprd05.prod.outlook.com (20.178.18.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sat, 9 Nov 2019 18:13:31 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 18:13:31 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Yuval Avnery <yuvalav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Topic: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Index: AQHVllBB2/zEJqwON0qPJYQ0F3Add6eBj3XQgAGOuwCAAAbMkA==
Date:   Sat, 9 Nov 2019 18:13:30 +0000
Message-ID: <AM0PR05MB48669E4E79976591D8728D0AD17A0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
 <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
 <AM0PR05MB48663DAB2C9B5359DB15BB89D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM6PR05MB5142FEFE41F0B06B7E61FEC5C57A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
In-Reply-To: <AM6PR05MB5142FEFE41F0B06B7E61FEC5C57A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18f11956-c42f-4329-7c81-08d7654086d6
x-ms-traffictypediagnostic: AM0PR05MB5185:|AM0PR05MB5185:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5185D3D1CAA25C21BB50EA37D17A0@AM0PR05MB5185.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39850400004)(366004)(376002)(136003)(189003)(199004)(5660300002)(2501003)(11346002)(446003)(486006)(66066001)(476003)(186003)(26005)(86362001)(102836004)(7696005)(33656002)(2906002)(4326008)(74316002)(25786009)(6246003)(76176011)(6436002)(6116002)(229853002)(3846002)(7736002)(305945005)(9686003)(55016002)(256004)(6506007)(8936002)(71190400001)(71200400001)(316002)(8676002)(478600001)(99286004)(81156014)(81166006)(52536014)(66476007)(66446008)(64756008)(66556008)(14454004)(54906003)(76116006)(110136005)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5185;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXeXRVGvpS266l612yhcVojVRHVcDtrLxpF36EX96hRIJIVwBi7+ap62Ha3vEY2yCEMdXvkdSJ1FohBMRHMAdgF88EL4NvOC3crUBoXVaJ5RJ120jlkGgkFgwg+1A+eqYpVsdi5sB9AqcQmyiN1UYC0V6cFHMiqIbTSYEMslWbVYw/DGRkA/raELngxT3ckp6rZRUYneCjNe2OmLr0Dyqg+mJi4YcrpvCFAVuiz30ND5xyJ31NdLhmgdQGJdrlEo3WuS7JbbpQ3/fnxmXcbzo7fqHFjfcsaARGvLpegDq94dXrAw32x5g1xneIluDE737ssnfu0fu1H+7xOjgr8/dpW+/6McUOT/SIVQNtvdJ/5EIQPSoPcxxPsm4f/4u09oLDdtEW++1KP29LLgZLIxHMrVWewz1rtggov3FTChYUqTJvHrqS920chZI2a+rwfB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f11956-c42f-4329-7c81-08d7654086d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 18:13:30.9221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cTzLK/PA0HKzWHbQuALdv/YFjGeC0tfmBJTqpXwngMGyTuNdZGl9W4iW3IDh7rR97n2D622c1yi6oQKm9SCQFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Yuval Avnery <yuvalav@mellanox.com>
> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> > > Avnery <yuvalav@mellanox.com>
> > > Subject: [PATCH net-next v2 04/10] devlink: Support subdev HW
> > > address get
> > >
> > > Allow privileged user to get the HW address of a subdev.
> > >
> > > Example:
> > >
> > > $ devlink subdev show pci/0000:03:00.0/1
> > > pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr
> > > 00:23:35:af:35:34
> > >
> > > $ devlink subdev show pci/0000:03:00.0/1 -pj {
> > >     "subdev": {
> > >         "pci/0000:03:00.0/1": {
> > >             "flavour": "pcivf",
> > >             "pf": 0,
> > >             "vf": 0,
> > >             "port_index": 1,
> > >             "hw_addr": "00:23:35:af:35:34"
> > I prefer this to be 'address' to match to 'ip link set address LLADDR'.
> > That will make it consistent with rest of the iproute2/ip tool.
> > So that users don't have to remember one mor keyword for the 'address'.
> I think hw_addr is more accurate, and consistency doesn't exist here anyw=
ay.
> We already have "ip link set vf set mac"
> Address is not specific enough and can also mean IP address, while hw_add=
r
> covers both ETH and IB
Ok.

Jiri,
Do you want to wait to conclude the SF discussion, as we are discussing sub=
dev there in confused state currently?
