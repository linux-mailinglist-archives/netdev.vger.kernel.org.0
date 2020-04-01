Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C781419A645
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 09:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgDAHcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 03:32:54 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:6069
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731725AbgDAHcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 03:32:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEronZKBinc1e+oTZ8QTGfaERw1PZuyL3ixQ97w05cGAq8Z5kvIYLsOqiqDIe1O73ByWjbYS7ncDgjH8AMzhelPs3kBbb2GSbzPePL6RkoI26D2YRyAL2EqFgmsbHWL/U5ojjyk4652YGfkN9UKFP/Nn7OhWYgGvla9MXJ2FC9so4Pxa3j8mDhln1uFgOIMKijDSSFww6T7KhITguhPx8QETS755hYtCcaL4ZHbNM/uALuFVCzdlVJ4MKGPyxJ/ZOJKjn2/bGHnLeIVOJm4nGcX5RPbLreZSjKofo9r7rdxlUjQSUg89KgFALigtG+SYnr6Q7d8pDh5VagQ3f/am3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k42S+lAxEU5lo9CoKw9+8A/BfDQTFR7D5rZhMDARMq8=;
 b=XjOk2Rd5XqhsQodVHxc9aVyxw75y8lIMZhy1vme9sB1UtpgLuqFzvJ4P5Mujmvi6JmAvrFskBonfTN5ouhYokZhVGMKayH1LMw4EqAg6Gy4FbMJFVdWlOLJCZtXMfwZbIIWpUAUtsgGGm74wRw+pPzAONeE/LPPT0bfM0PjBXcyBP3FD7Mnuv8bX9uF6D8DqDVMDg4sC6++zceZPeZVCBruM/43TtWcEQpkvBQ8OPDsl2Tia1mw0b6mwJTTyAuh4+7jPy8AQ+s8K/QAUv6CKXTDPO3YUAUmtgpsO4SS5dLTX7xjVLlctoiVlW8CjH53VOFI92lyua58/RWMkxDx+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k42S+lAxEU5lo9CoKw9+8A/BfDQTFR7D5rZhMDARMq8=;
 b=EULBLLH7IwEIvg2PYnojF3jwZPUS+xbsSRjOC9MmTuWHnF0fWCJzF62XQWT+WR3SHbpW6ZTcHq5/0Q7G7LlJRNLzBwdyZPYQwyExjfArqWw5IdI0NoED5vUK/3GCogXQVAZSw7lARAWo9Hdq6zQ62YvaqXwkNv8JqK32+4n11Fg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0SPR01MB0078.eurprd05.prod.outlook.com (20.179.39.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.15; Wed, 1 Apr 2020 07:32:46 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 07:32:46 +0000
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
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84AgACkCICAAOhGEA==
Date:   Wed, 1 Apr 2020 07:32:46 +0000
Message-ID: <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
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
In-Reply-To: <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.60.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3a9bb25-0927-4c1f-18cb-08d7d60edf7a
x-ms-traffictypediagnostic: AM0SPR01MB0078:|AM0SPR01MB0078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0SPR01MB0078B2ED81DF28E71A33D243D1C90@AM0SPR01MB0078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(8936002)(6916009)(66476007)(66556008)(5660300002)(66946007)(64756008)(55016002)(7416002)(4326008)(76116006)(33656002)(9686003)(86362001)(66446008)(26005)(478600001)(316002)(52536014)(8676002)(81156014)(81166006)(2906002)(7696005)(6506007)(186003)(71200400001)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 220J07s15kPlXYuuqSNmopJRgOJvZTU29SdjfULhAHnld7b1UUsORYVNWaCHs0Vfm/rVxN60PjsEODdUj03Sn3lbAMM/iuYavK/sNmcoswpxr7G1+GkIeW6d98KWWYSm7KflfeN8Hfk2MKTb4ERXorIE4WNQdPMTsDkKAihsMYNpTJWNmnIbhWeWNPGwBQmOYw4Pi9DFYE1yj0STfdRhsqtK25lom2hURbcRBM0bZIpazC/Z1flfa68BRKt06C/dIvuLo+AqPtJK7FqWGng2RZbEnwPpOQpCi6jYh4JR7mkspHbeOgvlhe39lyvAjyYNBLoqmrnjgw1ZL7FGJ/rK1dea7jiNzUFS4zyDhAP3sz55mrO4atPA0wn2Yz1KjipyVcATJc0qwZfxwoQCERQO9v2aCy4l8ZOeRY6yAFnW/jtgsMQVqpiT6LgVNpOVe1/R
x-ms-exchange-antispam-messagedata: a6V3okxLuCfNHKS4cS+M7mtgldduXVgjqchW3EqRD4vZgoaYWtRyewaJvaDstxBAY9Z7f4mTSNu46Qlv4zwsSB7SSSJoXOi2mcNSgvOOHXVSKHCEzfFIqzAsRKW8XjW6HqrblFdbVH/jtGNBMr7MOA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a9bb25-0927-4c1f-18cb-08d7d60edf7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 07:32:46.1842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zqmHuhKvLCliHUAiP3Ows0Q8HOIchsIJ4cP9D4g1vM6WnJw6QRiXeg80Y5y/pUOdzmx01KDvCN118lQRnDkTMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0SPR01MB0078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, March 31, 2020 11:03 PM
>=20
> On Tue, 31 Mar 2020 07:45:51 +0000 Parav Pandit wrote:
> > > In fact very little belongs to the port in that model. So why have
> > > PCI ports in the first place?
> > >
> > for few reasons.
> > 1. PCI ports are establishing the relationship between eswitch port
> > and its representor netdevice.
> > Relying on plain netdev name doesn't work in certain pci topology
> > where netdev name exceeds 15 characters.
> > 2. health reporters can be at port level.
>=20
> Why? The health reporters we have not AFAIK are for FW and for queues
> hanging. Aren't queues on the slice and FW on the device?
There are multiple heath reporters per object.
There are per q health reporters on the representor queues (and representor=
s are attached to devlink port).
Can someone can have representor netdev for an eswitch port without devlink=
 port?
No, net/core/devlink.c cross verify this and do WARN_ON.
So devlink port for eswitch are linked to representors and are needed.
Their existence is not a replacement for representing 'portion of the devic=
e'.

>=20
> > 3. In future at eswitch pci port, I will be adding dpipe support for
> > the internal flow tables done by the driver.
> > 4. There were inconsistency among vendor drivers in using/abusing
> > phys_port_name of the eswitch ports. This is consolidated via devlink
> > port in core. This provides consistent view among all vendor drivers.
> >
> > So PCI eswitch side ports are useful regardless of slice.
> >
> > >> Additionally devlink port object doesn't go through the same state
> > >> machine as that what slice has to go through.
> > >> So its weird that some devlink port has state machine and some doesn=
't.
> > >
> > > You mean for VFs? I think you can add the states to the API.
> > >
> > As we agreed above that eswitch side objects (devlink port and
> > representor netdev) should not be used for 'portion of device',
>=20
> We haven't agreed, I just explained how we differ.

You mentioned that " Right, in my mental model representor _is_ a port of t=
he eswitch, so repr would not make sense to me."

With that I infer that 'any object that is directly and _always_ linked to =
eswitch and represents an eswitch port is out of question, this includes de=
vlink port of eswitch and netdev representor.
Hence, the comment 'we agree conceptually' to not involve devlink port of e=
switch and representor netdev to represent 'portion of the device'.
