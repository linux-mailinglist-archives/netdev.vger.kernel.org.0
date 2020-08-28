Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9EF2553C1
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 06:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgH1E1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 00:27:23 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2589 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgH1E1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 00:27:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f48879c0000>; Thu, 27 Aug 2020 21:27:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 21:27:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 21:27:22 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 04:27:22 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 28 Aug 2020 04:27:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGN/2iouugo9Yzu7KenaInlTKoqjQHQBebGdRLKV4pPG/jhsmLT8KQtJ9qytovoqqMEFpamT3P0bexpmrJqf39obH91mHAz39uN+xB3y8alQGwm1ryq2zpcINXcnxALNzDV4+87IcGy9MNBscI+PkCAAAFSSdr0LsKdXzr7FbUj6cRu+74V36YzPgLRlboS3qq1IT5sQYDcDsfo2eXO5UzFfAmGAp1B8vH9x2/sCTqldTtJwBWwKTKGvSrWJLmLFr7swHp1RIfFzyDXcdnpBxotwkbfxPZf2v0aYLkuj60J7Ym0jDUP7NY6O/zGiDp0k9FVTwDlfGBXSF3muTvJApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iV94h0NfR3shq17y9wSsaBn9vs2dUzYZZDKIUUnTNLI=;
 b=muCcExAdpPhRTm6vhoMaLN6FYBL7ruFs6S11dcczf4aXZ+MxrGlwek3FqNXegIFuKm4GjdO4TltWUspKlLFi3rA7udVbBMcNb/IutSvI/8FXvkz3iAK/q5W/oaBjvBLyaJUuQVysC0k/dj4NZQDfyQRGV/w3P//M5+aHH79FIcmMweOv0Ns+rv3h9J3RSRECi2AYaWRWJGqQXTDV5SPX+Whb0Fbw5BgpMld7DppEfuZYltVxEuc8P33LK9AadMAMX2fHwV1e9q8UjkpiQQVluO5Y4Hx8k84mTsdScU2ZiDXA21o8ADdKTxjtzlUS0+gh3DXF74qrdADLgQEd2SQPWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3111.namprd12.prod.outlook.com (2603:10b6:a03:dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Fri, 28 Aug
 2020 04:27:19 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3326.023; Fri, 28 Aug 2020
 04:27:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzEA=
Date:   Fri, 28 Aug 2020 04:27:19 +0000
Message-ID: <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78541bd0-8f35-4c42-05be-08d84b0aa71e
x-ms-traffictypediagnostic: BYAPR12MB3111:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3111084FAB2217770BECE265DC520@BYAPR12MB3111.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7sDzmU449zc5MPiZp/ANu6C5H1dW6WeM1cThlPlKsmJruHvPITu1mdPEZYwD9knin7ZdGAlrgXeaBkkdOHRf3Pt0R+2nDOY/u26Deutbwp8mvEIMStXNwN4rculpvOLpNmA7UiwbXLxHcyS9qgsfxEhuCiriWoeZnOzrGetFoMTYelVi0jkRKCSPKjuIt/9FiU3ZvtCyRodp84NwYDyznxPyZ4eN+obAnWIx4TMurxvG7L8jc/9hW0tR/9vD7CroH4haKo9IVmaATJu2csn6tSf+vSQXe5LtGoeHPSvjd4ukDab5ned6JhUVjV9u1jLPIBNvx6P8IXUloLO3gsLULA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(8936002)(64756008)(66446008)(66476007)(66556008)(6506007)(66946007)(186003)(6916009)(26005)(52536014)(107886003)(9686003)(76116006)(5660300002)(2906002)(4326008)(33656002)(71200400001)(55016002)(83380400001)(86362001)(55236004)(478600001)(316002)(54906003)(7696005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bw3BE4Ir7TuAD0dX1fF4x6GbcnnaQxn2NaQXvi1mGCgnVfkQE9fD7VqorYZv3f7VN/GpYoV4sJZXVdfEMEXgj9LNrjMIoXZoYgJ89aUQ8K0HnBS1icZusNcJsqIOKQJlQ/Urc8ByXLyjGD9PEGt40HtOlxWAZZ8L7Q+N+mGOtZ+RXl6AbbCknsK03mwMINKrIoyHObl+5TapWQwOJOX7Jm4dgB/o2VpDb7Fs45mO5QpHUHkPzgDi4I+LCgfRNeUXgIzHezbPB+gCBHeU5nd2g5vCgrRz1s74mVvHMpevDAj7nwSNrifHez+rndXx9OgdMNdNc54Yin7WrXXWYvyUbBZJWDcrkXeEgtaHcmuHJTNAEi2Xkfm56W+zBAa6Mk9MJRvAuXV2fmpXXw1tcD7q1e6g5qkSqMdn+EM8hxeRKb8OKAG70n7EvlOnImDkZGr4habfN7x5cKKAYt0SHNLH33QaY5yE68AMoXUbAk9mtQjRnLRbLzmWHe+yb2EEHv2C66pFGlS9CkXD1Fp0vQi2sguuwtb7DUqmTHv9XFMXkOu8xipWq6Ly/QKdgSLpNxBdhAaGjXVhKjTSSiYji6nBSUhqe4vHVgOH6rBbXsAJis0eovOvZqBAst4nLnB81Q9xCx7l/ciyE5hATlkX39TSCw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78541bd0-8f35-4c42-05be-08d84b0aa71e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 04:27:19.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ipZmlZ89bE52MLuxDJvwF3Dgq52GKhZ7emLkGHzVB5FRLoshKCc0Nww1RQHkOVEqjFShjGCGHzo1ITtUzJCow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3111
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598588828; bh=iV94h0NfR3shq17y9wSsaBn9vs2dUzYZZDKIUUnTNLI=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=kUXwR+suRV03/B1wAWFUAox40nP2/NJheTXAUUb6u4mn7FlnHw1RmS/Xp/IhITEv+
         jwoatnyaNn1rplRvv+Bj8muqEI1y0yj5AmotAKwxinH0RfvVlRYh/ygp9H3DeQukXU
         6AH9YQitk80mzMvzoCxw1PGyH/RZJlNAYh+GaW+pIiiExBWM8Gm+4qyNaoFXJQe+Ci
         M2U7c/Vfg2AwgNZ3JRoJDg7ExiuSjclt+0OPCNihPz+DOBErPPBjIwkEJNsGNWCzi/
         p0E21jXNVgNXHrGsVaVo4rzjpsVqZk8MZwHhU1W8Vn57e2aOjhtVYcdw7njodCM1xl
         R86Wu42fOnyyw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 28, 2020 3:12 AM
>=20
> On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > >
> > > I find it strange that you have pfnum 0 everywhere but then
> > > different controllers.
> > There are multiple PFs, connected to different PCI RC. So device has
> > same pfnum for both the PFs.
> >
> > > For MultiHost at Netronome we've used pfnum to distinguish between
> > > the hosts. ASIC must have some unique identifiers for each PF.
> > Yes. there is. It is identified by a unique controller number;
> > internally it is called host_number. But internal host_number is
> > misleading term as multiple cables of same physical card can be
> > plugged into single host. So identifying based on a unique
> > (controller) number and matching that up on external cable is desired.
> >
> > > I'm not aware of any practical reason for creating PFs on one RC
> > > without reinitializing all the others.
> > I may be misunderstanding, but how is initialization is related
> > multiple PFs?
>=20
> If the number of PFs is static it should be possible to understand which =
one is on
> which system.
>
How? How do we tell that pfnum A means external system.
Want to avoid such 'implicit' notion.
=20
> > > I can see how having multiple controllers may make things clearer,
> > > but adding another layer of IDs while the one under it is unused
> > > (pfnum=3D0) feels very unnecessary.
> > pfnum=3D0 is used today. not sure I understand your comment about being
> > unused. Can you please explain?
>=20
> You examples only ever have pfnum 0:
>=20
Because both controllers have pfnum 0.

> From patch 2:
>=20
> $ devlink port show pci/0000:00:08.0/2
> pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf pfnum=
 0
> vfnum 1 splittable false
>   function:
>     hw_addr 00:00:00:00:00:00
>=20
> $ devlink port show -jp pci/0000:00:08.0/2 {
>     "port": {
>         "pci/0000:00:08.0/1": {
>             "type": "eth",
>             "netdev": "eth7",
>             "controller": 0,
>             "flavour": "pcivf",
>             "pfnum": 0,
>             "vfnum": 1,
>             "splittable": false,
>             "function": {
>                 "hw_addr": "00:00:00:00:00:00"
>             }
>         }
>     }
> }
>=20
> From earlier email:
>=20
> pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
>=20
> If you never use pfnum, you can just put the controller ID there, like Ne=
tronome.
>
It likely not going to work for us. Because pfnum is not some randomly gene=
rated number.
It is linked to the underlying PCI pf number. {pf0, pf1...}
Orchestration sw uses this to identify representor of a PF-VF pair.

Replacing pfnum with controller number breaks this; and it still doesn't te=
ll user that it's the pf on other_host.

So it is used, and would like to continue to use even if there are multiple=
 PFs port (that has same pfnum) under the same eswitch.

In an alternative,
Currently we have pcipf, pcivf (and pcisf) flavours. May be if we introduce=
 new flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
There can be better name than epcipf. I just put epcipf to differentiate it=
.
However these ports have same attributes as pcipf, pcivf, pcisf flavours.

> > Hierarchical naming kind of make sense, but if you have other ideas to
> > annotate the controller, without changing the hardware pfnum, lets
> > discuss.
