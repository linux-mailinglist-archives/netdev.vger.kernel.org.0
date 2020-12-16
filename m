Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48A2DBA9C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgLPF2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:28:46 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4796 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgLPF2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 00:28:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd99ae50000>; Tue, 15 Dec 2020 21:28:05 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:28:04 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaPX67qg/rx2Nz6+69sW+YcCN1I3WS79qGDzdky/KXd5j7DMrLDujGF6ws4Enn5O8gwpUAUFlf0ssi9/mdX2ZnzMWEcP+ETBj6qHunI/jlzxqWCsmnwxHg2P4KfDGckdaZHi88+c/Q1DaaW2lh+cGsf+3B9KGW9ULdb1TTyLT15jo26uHitgS8UDJI+xOsog+VZOe2juPexoohVc2HD5f4xiqWWVvoKgz9c3vbL2QrxEbTlfX2tDs3nfjt18w3DOmFgxj0iNOShpK/BhcNsIJJOmJbP3IGhk97midlf7bkYSGODSOOsdHwb4VGbGPXGOuwH+AIGnj4L6l7pV2DGdGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVjZjhtznhTn+XJHrvUeGBOnWMJThCPH6a7YHuE+q/0=;
 b=nmpI2qAxaDdAvHfNU2RLP/DOVAPEQ9nn1y2zMg7/PnN98mfUgJqqxJwRSjcgRozKfepLj9y+o483yB7rfp+IWYsNF25Tzro13ewDLeuxAKech4jBVAHXwhq1vG0e7QE1YLMOkLYcKletoW8GgxbF3HbP9dC1tjmcAfN8ECH6Sh3qAg3d+YvN88Dhw5emSSRZnq4C+9eMih5sqPrcixuWaU4P5HPJ0/w17GUXqGZ+VvOQ+T6LifuBG8xIhTlrLymzdN0oDHPQ/k8TxP2DTWIM1zguV6JLZ092QyZNPiEwi2KvVc/6kL1AvXT516cZXtxCzkkkIKZgZE/FuI4PxnUnwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3029.namprd12.prod.outlook.com (2603:10b6:a03:ab::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Wed, 16 Dec
 2020 05:28:03 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:28:03 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Vu Pham <vuhuong@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 09/15] net/mlx5: E-switch, Prepare eswitch to handle
 SF vport
Thread-Topic: [net-next v5 09/15] net/mlx5: E-switch, Prepare eswitch to
 handle SF vport
Thread-Index: AQHW0sFH7aq8l87LBk+VVPt3kQOnb6n45KmAgABNYYA=
Date:   Wed, 16 Dec 2020 05:28:02 +0000
Message-ID: <BY5PR12MB432203C5567CF1D4F3A1913BDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-10-saeed@kernel.org>
 <20201215164753.4f6c4c9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215164753.4f6c4c9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5708f871-249c-4632-2102-08d8a1835c11
x-ms-traffictypediagnostic: BYAPR12MB3029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3029B7DF3E499182F0D8DD36DCC50@BYAPR12MB3029.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: inc7979l6ixfRWkqeDPk4BmTXth/gxKAXiNvu4ewGKj6mbzbqfhD4VRAdzxRm9FLuqyL3BvfGIrmX1Zbx3LzCsQ5JDPGQNM0fD7s+Nh3L737GwpYLWyVL7EGJh9t+PKbJBDLpc3vHexKZ5QJwJqaCye26i8bnlh0nPxyYPm8Wz1yxSxAxIEV4fe4kK80GG8HOAYtt0uIWIbb8AMsjR/9t6bsNoeYdf0eIIGZ+HGNURQMix+ZVMad2FV6VB95BrQ3MJBFlnGhE7rNvaCiA+I+ZvydZHt8k6G9yj6IiTzvrOxYEMFletNkBv7nkZ/Q25BmAAU63Oo97/XEn878jO7Ztg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39850400004)(376002)(66446008)(55236004)(66946007)(64756008)(478600001)(26005)(83380400001)(66556008)(55016002)(7696005)(71200400001)(8936002)(4326008)(8676002)(33656002)(5660300002)(107886003)(52536014)(186003)(86362001)(9686003)(76116006)(316002)(54906003)(7416002)(2906002)(110136005)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CJUnNsQLgznygaUBWakvf8ukYYVrtkT/DPYp2GFFH7SRTtXBvLVixeBjpPbU?=
 =?us-ascii?Q?L/Mq8ZqArAc5HpBUHEJFLrQ2XjVrplTTcH2eX0YEBEo6cnNzxgX50CBBxLor?=
 =?us-ascii?Q?2+T0tDfinPJ9hsvhij3D/KmxMY/UBA97DxmW3foioF1Dt2IIZCwPv4T2QeWA?=
 =?us-ascii?Q?iXT9ynwwxAHsM2n0uJCWG21Sxh0zPRv7y3pKAsJ5p1H9bWlRWsWy1rZJWnxY?=
 =?us-ascii?Q?994PYE5s/PZdt9ImvpG9s8n2QomZxAJs3LsImxFdGZoeSWIfS7iim+ih6xiv?=
 =?us-ascii?Q?Z1I9SuY4/3N4SbMolkcv5qjcbmgeSlJwCQbozojQbs6LfO5R1FGE9kHEUo3J?=
 =?us-ascii?Q?n2/KTJshfw5YmZyYz8UiMHsG6QgES01w8ZJaODW/GQbC4xegVY+oETpcTqbj?=
 =?us-ascii?Q?8Di4mPQSKD53unbgZ6x8XzUXFRQfNqzh3LetRWSqOJV6IEkQ9yS3lsSAtICf?=
 =?us-ascii?Q?lO7qEzeV30/B0wSj4RKsPvLeTlYFtQMPG1C+Y0rvmhjaSFZNjKvH2gBd/g35?=
 =?us-ascii?Q?dIqZuTYAQPrT38brfAKB9tkZo2Bqw/hXMe8n8tljArqiJcAxIh8PtDK/FYSM?=
 =?us-ascii?Q?Gfym4iZVfzTDW9K4RUSqm+51VTc4z0V6Gxn0dJePzzHaIxiklp1PEz12EW1Z?=
 =?us-ascii?Q?iinvHVsNUEGCvuI43CFLTw+HqUrX2puGyOq0/tK7i8dbnj5LOZmWDG8HoTo0?=
 =?us-ascii?Q?OSai+itmKH9OtUn7Fgpo2qD8QZMvlb9hTCryt5+UpBS7GuewUflG9RO7YGX+?=
 =?us-ascii?Q?LLeJBJgH000lpb4qonvpYF5ic0ufqIrmywxyA622Ea11h5yk0VrJA/Y7sEs6?=
 =?us-ascii?Q?aQilRfEB61eyfgLowkhLLGFEkEqsEdxgFM3JGf7i31BKnI5fJ+gVWQPMjQvL?=
 =?us-ascii?Q?R4Mbr/Bnb+Xbxph3kpzuM+BGDAUnAdlMWprFY7A1mfwddJkzugVZiJlwybTQ?=
 =?us-ascii?Q?WFSEedQmpQxDZ9VapgW/X/W0NeQLqETsnhMgwtgpSuY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5708f871-249c-4632-2102-08d8a1835c11
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:28:02.8377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZGTSDVMA9EC1lk+MrQ05uMQs5XQAbr9NyQcXON9yNV92wdklmGWVg0Vsw4t3u1HVsMIMEA/Usz4he+rmBc+kgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3029
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608096485; bh=DVjZjhtznhTn+XJHrvUeGBOnWMJThCPH6a7YHuE+q/0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
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
        b=ZYnCOS9EgmHUUfNCIKcdI3sKrwLhZRQ5bTF8NMHUWOQTmtDcPdKhi4fjH1aW3P6hm
         /BFckXfMyNPgZnBtszf4PprTqxDi8L8AvE2w0SwTvBwvtOp6sCyH7XJtSNQPjiilrM
         2arN+jPGQTIdX7TS67pvJEwZxHbdqRczu2W5OzbLMMTSiCaE1Lx/5Tt0yWMuPJySIt
         LC4N1Kaj1RjKUttwWwLe/oCKUkzL9HEfKD40l/XZ79qzb5JE22PGSLgtH4kYyvTWow
         ROfUZAYseHXZ7EAOQ2m6czpgWzagy8iKzrSKuTwFIas4EHj3YYMtWS03HY3LNj2rhi
         D6jSju1RJTGMQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:18 AM
>=20
> On Tue, 15 Dec 2020 01:03:52 -0800 Saeed Mahameed wrote:
> > From: Vu Pham <vuhuong@nvidia.com>
> >
> > Prepare eswitch to handle SF vport during
> > (a) querying eswitch functions
> > (b) egress ACL creation
> > (c) account for SF vports in total vports calculation
> >
> > Assign a dedicated placeholder for SFs vports and their representors.
> > They are placed after VFs vports and before ECPF vports as below:
> > [PF,VF0,...,VFn,SF0,...SFm,ECPF,UPLINK].
> >
> > Change functions to map SF's vport numbers to indices when accessing
> > the vports or representors arrays, and vice versa.
> >
> > Signed-off-by: Vu Pham <vuhuong@nvidia.com>
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > index d6c48582e7a8..ad45d20f9d44 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > @@ -212,3 +212,13 @@ config MLX5_SF
> >  	Build support for subfuction device in the NIC. A Mellanox
> subfunction
> >  	device can support RDMA, netdevice and vdpa device.
> >  	It is similar to a SRIOV VF but it doesn't require SRIOV support.
> > +
> > +config MLX5_SF_MANAGER
> > +	bool
> > +	depends on MLX5_SF && MLX5_ESWITCH
> > +	default y
> > +	help
> > +	Build support for subfuction port in the NIC. A Mellanox subfunction
> > +	port is managed through devlink.  A subfunction supports RDMA,
> netdevice
> > +	and vdpa device. It is similar to a SRIOV VF but it doesn't require
> > +	SRIOV support.
>=20
> Why is this a separate knob?
>=20
> And it's not used anywhere AFAICS.
SF device and SF manager are two different sides. SF manager is only suppor=
ted when eswitch is enabled.
It is used in subsequent of sf/devlink.c to disable port add/del callbacks.
I should possibly move this hunk to devlink patch 11.
