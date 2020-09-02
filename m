Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212C525A4B5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 06:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIBEol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 00:44:41 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3031 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgIBEog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 00:44:36 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4f23050000>; Tue, 01 Sep 2020 21:43:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 21:44:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 21:44:36 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 04:44:35 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Sep 2020 04:44:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9p4Um9M4ANEN22+dcy16BF7TB2Twd5SgvtUFGXxfYDWMT3KRIbY/7l4hmd3HBR/ncr3QwtQEqwFmwH3O4v0Ta/KFDoxo+AMJZQ2Z6q/fOdBfyvvkAxO8cMVvP0J081jJtyCekY6pE/YjHEEyk87p9XR73O5CyaGqz8BZSHdsq2I416ajRlFzf9YCMWmpxMaQg03e1+Yge7uCVWNdVrYkvjzAN3aJ0uvci253booKe6Ng09wz6jAQA3EiMnVPHtUzrV2e6eHlMMtBAafW3KXUXTVrTdepgTfuIM2b23Fyde3FsyapU7ZYTi5KtcL/MIe3TrN7LSLk18ImaXbZmzTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYCiaPfuxKkO366q5ea9Ij/VNCp5xKF7mCF4/53U590=;
 b=aW25XVJLTR9+BjzoL4OUD4Hwj64f7kGh4Qi3AUFmtkrf/DfQPa5YahLjpqzzeCqzrS1zWdhOZ4Hltu4RdSMDnEd76zDzKpP2u2uZ4H9KTiK7EooZ/TapcUr9wej66pjga08Byhor9AT4pa+JGdPOdQU69OpwJBdk93wR3diNkPD9s2FT76rKlkIWoXi0JaNzdkl98BKP6PaQ+zsM1dRfjrU7i117TAAIaKw+ejdeTv/pCJ+hZfqsAeLnrKQFgJR4gYey0Q0wC/8/CIO5MnlpwtJECQYpTl6DkbLEysr1t2rIrgDa49U1N02ZpGhfr/HwPGaQp0LHeoJ6G1nnPiLe1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Wed, 2 Sep
 2020 04:44:34 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 04:44:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@resnulli.us>
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
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMIAACfwAgADMOwCAAHEaAIAABlYA
Date:   Wed, 2 Sep 2020 04:44:34 +0000
Message-ID: <BY5PR12MB4322E7EEA018ECA1FECC40A1DC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 486723d5-1eb7-4e88-1c61-08d84efae3d6
x-ms-traffictypediagnostic: BYAPR12MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2759FCCA0FF3BD9E9FB834FCDC2F0@BYAPR12MB2759.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ft52EXQ9TJz5tS1RTIfJ9ZrHb6ELp6DalxYkifTVKVZLNrI9be6TxF3Vu7wmDmQNlHUNx9IaAyXugeMWW3bOddTpv12qxVgjrUiWpLhhNpElmX5nW7FvIa8xcfvlLSsJToHqPGIrPzLl+ES8atuCR5wZqUBu/RYLHJ/cs3kXYji8Iii1y5m5QZKV9hikGYymfYJb9hg8cA4heQ43CQ7XcmDw+grToczMOy3uz42BWZxJOvSI08w8ea9yezhNq93CEX3w5l6AwnS5PXDTgZVjwPKpr6MoJ+ZFvwnmlzm026sdga9ZU81hvcI6HnYY+/GAyuE4rkgP9T3fKCiCk3Jhyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(8936002)(26005)(316002)(2906002)(33656002)(107886003)(66476007)(66446008)(66946007)(5660300002)(9686003)(64756008)(76116006)(66556008)(52536014)(86362001)(6506007)(55236004)(186003)(4326008)(110136005)(55016002)(54906003)(478600001)(2940100002)(7696005)(71200400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P+EOFkyKuNj5M7rBPCwM+kmmbhk3IL4HJEQj4SCgh9Yq6MKmEGb9CHFXbN6OutojKGhQhkDri9kIJ1Gjf1f2BYNuHFxRDu9ahU93AFb9a+wvJ6o9ZENMxmVcVkEZTRBAxPvnVIx+tycHM0YW4IjncX2GTJ6vTHPyGkaeHlYdoQL/rZgBi92FfA1DLqeXaJwEADORM4rt9JSKBPBOiqwYOn5J8IE2jvyYBi7mCziYzYG5fA3M1b2uKekbGDX/YafMR6KcV90gMUwbUFRPHuwd+wzEteWvNbaRZEVPi8QryRPNGrVSE3/y+kxiqq4Tr4K+rhSkeFIQK5hc1f9RvPbwiTA9YZ/aEg+mDO45zHp+5gqj5wgv5EApBSiKsHlr5RfAgOMLejckPWxEJsYJQMCFiF+Ke5o5sG/vcnVbdBsXItNAfLrrCWgXYgpmHUO0SiGufv+/HlnzBwG8m1u+ghOLwXqeT5sETMAfGO1lcgWe0YChj/cKZjEB8JGyqLvttkFtYG/8pPVNRPHMULPIOnzi+D04FiwfIIgXdMo5+WZDTCi/D6rC1iJnivEYRNTSh/pI1EjtXcWOtScJo2n+dewyxCV9WoJb7QqwlFIxopqorpDxswCFoFRuiG5hgVK/XpWuF1TwYe1swLhiCQb5Oh1HzA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486723d5-1eb7-4e88-1c61-08d84efae3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 04:44:34.2239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwE0FC4svpAhuEuf8gGIhpFvva1AxsZi95GlaQCmeY0/7cbbNTUl0DkpVUA6GR1j4byGAQepuRMB9v3QAkF6uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2759
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599021829; bh=MYCiaPfuxKkO366q5ea9Ij/VNCp5xKF7mCF4/53U590=;
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
        b=TXR8gwlKNEHAeUKmCfRu8jvuM5pf0uVIsdvb693GHgnMHIwceuL8M/rwS3iMt/Y/8
         5De8KkM0XrxftcRGbYDqv5Y4MDPuJi7JBt4gP0EJO85UNARjakeMgTFx0peJNYG/T2
         g/sw1MpTKJEH3XAg1JxEkLb3zfHeu/4Z0MMaI0a6bW9p0YjNgVvs13SnUbP3N4g0Cf
         Ffow+tBuGSFu834fMqcKB0hMNtHezAXopglQlqYUA47KAmtJ85CQBuTDztAxOsHsIY
         rWMGWnsyOuPyzsZnmWNUm7I4a3Rtgo/JmqPT9E/t0hzlRCx+B9bmbFJ4hT550jiORi
         hhII9uiilFcXg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Parav Pandit
>=20
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, September 2, 2020 2:59 AM
> >
> > On Tue, 1 Sep 2020 11:17:42 +0200 Jiri Pirko wrote:
> > > >> The external PFs need to have an extra attribute with "external
> > > >> enumeration" what would be used for the representor netdev name as
> well.
> > > >>
> > > >> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
> > > >> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf
> > > >> pfnum 0
> > > >> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf
> > > >> extnum 0 pfnum 0
> > > >
> > > >How about a prefix of "ec" instead of "e", like?
> > > >pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf
> > > >ecnum 0 pfnum 0
> > >
> > > Yeah, looks fine to me. Jakub?
> >
> > I don't like that local port doesn't have the controller ID.
> >
> Adding controller ID to local port will change name for all non smartnic
> deployments that affects current vast user base :-(
>=20
> > Whether PCI port is external or not is best described by a the peer rel=
ation.
>=20
> How about adding an attribute something like below in addition to control=
ler id.
>=20
> $ devlink port show
> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 ec=
num
> 0 external true splitable false
>=20
> ^^^^^^^^^^^
>=20
I am sorry for messing up the example in previous email.
Please find below examples with controller number and external attribute fl=
ag.

$ devlink port show
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 exte=
rnal false splittable false
pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf pfnum 0 e=
cnum 0 external true splittable false

> > Failing that, at the very least "external" should be a separate
> > attribute/flag from the controller ID.
> >
> Ok. Looks fine to me.
>=20
> Jiri?
>=20
> > I didn't quite get the fact that you want to not show controller ID on
> > the local port, initially.
> Mainly to not_break current users.
