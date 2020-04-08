Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714441A1B68
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 07:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgDHFHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 01:07:11 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:2277
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726905AbgDHFHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 01:07:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBfDrOC6S0PTkxOI91LnHJzj6N9oWAfwIZ/RFNT7UnF8NjfjYopVx1soRhrB+k64hbYAk1UJk6RtsxN8AlBCQwJcbRRQSB4SA0E6a0PZ0OAZsVexi5glCQ/uUbndAQhuB5UqYiXSaaq8+A38+gCQLaeatBfryH95NaCcgxpqgNQVceLOXOkmt3cWy0ubCfy5Biui3vrIe3suVHC+PHn+5ehh4wweIRtPb9PV2/CfvAFwABHy8sHQnx8x0QU2o0KJ9Co1yAbd1wsmm8ls8C8Q57aju3Fy0n7ilbNB/YR+GHrE59omyrJO+XnNMrZU3UNU38WAANBL6ltDsYagoZgdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f01KSXOMycOmRIajRUmI4EykVzqIliz+BjzPmQcUEU=;
 b=f6vtcqg4IdkpZX/TAr0jrZk2kwFQ1G2H9mAuoffyz+Vz7kbbAnBbjpt3QxqHmudVVhYEpSamTHxHGQyWMIyHeHgloC2kjIWtMZfFQPD/q04hrai9i3z7tmwRqJxas5LGUgoMlrrt23VR84KVc8uR1FV3Wpai3BxPIOtFvW/Hm34yHCxHWHeVl9xTTaNb5LBKbREpQZjAnp0Gm9WlxhmICmqK9OHlt6R4B8vFQbnXntEDQdqqxiwTsi2E0rs8tMfAAhj4FjdT8vwdkMg2YE58Muiu0QymeT0+mcXpHVMDAiZNCaFiigZstebHT1IAtBbxu27E3Vbi3AaYc06O9yLm1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f01KSXOMycOmRIajRUmI4EykVzqIliz+BjzPmQcUEU=;
 b=KYjYK6QLsAkgiImD/ZLBABAEpZBbmHHZLLmGlFNIzMg6XQVwp3t3bUD61zuXz8ASlA13nPMLFCUwNw1xnIUuRNrIqID1srnM4xC5oBADrZwnBbpm5v/6oh1xPGb0VkblPfVLAg3pqaJa/D45ova+0iE8qEnz03BNSiwKF/2Aotc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4787.eurprd05.prod.outlook.com (2603:10a6:208:b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 05:07:05 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 05:07:05 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: RE: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84AgACkCICAAOhGEIAA1qaAgAoCRuA=
Date:   Wed, 8 Apr 2020 05:07:04 +0000
Message-ID: <AM0PR05MB4866B13FF6B672469BDF4A3FD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
        <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
        <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14ac5a77-3a7d-407b-1a9d-08d7db7aae31
x-ms-traffictypediagnostic: AM0PR05MB4787:|AM0PR05MB4787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4787AAA07D7D357F5C8D462DD1C00@AM0PR05MB4787.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(33656002)(316002)(4326008)(66476007)(8936002)(76116006)(81156014)(8676002)(71200400001)(86362001)(66446008)(81166007)(7416002)(66946007)(64756008)(7696005)(186003)(66556008)(478600001)(6916009)(2906002)(52536014)(55236004)(55016002)(6506007)(9686003)(26005)(54906003)(5660300002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LeK+fJjJmzHuTponCUAg4KkRsxqWDJxhYc9vF9H1M/CxeanNyge3m1JiL5Bt3d90ZyO5tt5o2jHt+E9fYf/pQWjc4f4iHyZHAfoPqr3MDiuOzzehzxtsQeam8XgUPtJBoHeywTJeESTnR+Fd/rld7d+mKmrUKIFiyiA+9qdj+0cQr/9/K8PCkhuBF0Y667cKXrK9QBj3DQ8TAPSzMF9pFh9iL7wdNcVCz8hHqNBzzfLnrokgyqazzYgzwFDkpibWrWbx4RXts1ffyRjx1Vnqh4GB/RahncBkMB/KwT7R14Hmp8vkJmI/0F0DEGS4+Pdhx5xkHewdn8zihuGQXd3B1htN5Gt52I0DOmPtMth7BvnlKfyAdL1EXIzQDRszct4KYVQGZw/0ySXaPYYliCCo3u2+w+ufzRt3T22B7qRh5RZ4Ql0OyhPYHTJYnXof5tuz
x-ms-exchange-antispam-messagedata: sLSAQy3Rzl9p7tWs2RZ+2zBZM4q2i+tqZANtOvrbJwSkIdC7DLLVzbMk9+OSty84uTo0lGYroZA9If0/cLIe12Z+Jh9sqd2GCpcMj3MXiD4pDroNFIRxz2ZVvn8Wg22SR9I5w7qd19DxiD1EG79+ww==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ac5a77-3a7d-407b-1a9d-08d7db7aae31
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 05:07:04.8872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UyxVpyrRoBQ5Jv+RkStDfr+IsxkxklOzjYMfqggZZJIWtNXUuMpxE8UOrX5DU1DsnNJ8DgTnFuW++w3NAWqGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4787
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
>=20
> On Wed, 1 Apr 2020 07:32:46 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Tuesday, March 31, 2020 11:03 PM
> > >
> > > On Tue, 31 Mar 2020 07:45:51 +0000 Parav Pandit wrote:
> > > > > In fact very little belongs to the port in that model. So why
> > > > > have PCI ports in the first place?
> > > > >
> > > > for few reasons.
> > > > 1. PCI ports are establishing the relationship between eswitch
> > > > port and its representor netdevice.
> > > > Relying on plain netdev name doesn't work in certain pci topology
> > > > where netdev name exceeds 15 characters.
> > > > 2. health reporters can be at port level.
> > >
> > > Why? The health reporters we have not AFAIK are for FW and for
> > > queues hanging. Aren't queues on the slice and FW on the device?
> > There are multiple heath reporters per object.
> > There are per q health reporters on the representor queues (and
> > representors are attached to devlink port). Can someone can have
> > representor netdev for an eswitch port without devlink port? No,
> > net/core/devlink.c cross verify this and do WARN_ON. So devlink port
> > for eswitch are linked to representors and are needed. Their existence
> > is not a replacement for representing 'portion of the device'.
>=20
> I don't understand what you're trying to say. My question was why are
> queues not on the "slice"? If PCIe resources are on the slice, then so sh=
ould
> be the health reporters.
>=20

> > > > 3. In future at eswitch pci port, I will be adding dpipe support
> > > > for the internal flow tables done by the driver.
> > > > 4. There were inconsistency among vendor drivers in using/abusing
> > > > phys_port_name of the eswitch ports. This is consolidated via
> > > > devlink port in core. This provides consistent view among all
> > > > vendor drivers.
> > > >
> > > > So PCI eswitch side ports are useful regardless of slice.
> > > >
> > > > >> Additionally devlink port object doesn't go through the same
> > > > >> state machine as that what slice has to go through.
> > > > >> So its weird that some devlink port has state machine and some
> > > > >> doesn't.
> > > > >
> > > > > You mean for VFs? I think you can add the states to the API.
> > > > >
> > > > As we agreed above that eswitch side objects (devlink port and
> > > > representor netdev) should not be used for 'portion of device',
> > >
> > > We haven't agreed, I just explained how we differ.
> >
> > You mentioned that " Right, in my mental model representor _is_ a port
> > of the eswitch, so repr would not make sense to me."
> >
> > With that I infer that 'any object that is directly and _always_
> > linked to eswitch and represents an eswitch port is out of question,
> > this includes devlink port of eswitch and netdev representor. Hence,
> > the comment 'we agree conceptually' to not involve devlink port of
> > eswitch and representor netdev to represent 'portion of the device'.
>=20
> I disagree, repr is one to one with eswitch port. Just because repr is
> associated with a devlink port doesn't mean devlink port must be associat=
ed
> with a repr or a netdev.
Devlink port which is on eswitch side is registered with switch_id and also=
 linked to the rep netdev.
From this port phys_port_name is derived.
This eswitch port shouldn't represent 'portion of the device'.
