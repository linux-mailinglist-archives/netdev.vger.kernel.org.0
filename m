Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA46368D5F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 08:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhDWGyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 02:54:11 -0400
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:6631
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhDWGyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 02:54:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni5QECqJgnFdc0C9qJLl12iHwyJ5UT5vFSw2yu4I616Ee5CIPXip3AmxL8y9JWldLvu8dG80LKMIojHFxbFxrpXwC3vY36V9FCSou6ff5Qn1fONejgsgCIvyDpkhXUCT0rV89LKRcScxgllpZQM9KB/CMB09q/J+bi5hH5Taek6cP7jGtGbI1Hk6/qY5jE1BVpxlZWAGoHFS922YBmnGKFRLRsU6Q41b034lq94/e1MH7TRlHqFkJnlllebOqSbARDMOMRtEPU5qZQd9fm6E4yyrp6NvM0YqX0YERamginDqEKZG9ediCfvxG1JvmeOdc/7x1obwPjsgZdOv3pgPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nWJvhes2XDUL0L9ac+Qt9OZIAyZ+QPa542c1EPnLHM=;
 b=Y5nCuOHp2GKmymhgaXCYZqUxFslNdmJoxK+ArsqYzFWHpObAPzYLkyWEXryNcYUzWThVDUQVLY8+8YYmmjdPqhU+9d5fvegFzS37seHNUmq+ys2a2LwJKb4zcdeRRgEbcrojG0PqIrKBahTZL+Td0RlvmCakOty9vGow2fDXdFX18REsOlZylrjvEsj/cHn/Yf6cjMyOjZH3cFVL+mmgcECp+zlx9+3bK0puayGxiHjrkGvGWEPyQhpyk/sZXspIV+NcBH3bYs0oji4vFADJZwu4IiG35LE8l+nxaupa/kFFn8asQFx4AoEpafSwg6jF686f8i3AEWHU2jJ6fVySyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nWJvhes2XDUL0L9ac+Qt9OZIAyZ+QPa542c1EPnLHM=;
 b=d8MEitXF8XBVj2xnG3OmRNQBQ5dpXN0vFjXaO91UoDt53uG+BdlJbqPwr9YKI3MwYnv1f22UEFqgNDl9XaU1FRO51zpS5bNSmH2Enck9qYETgnMSB/Ce2zxImJAjk7c2jvPEid9uQQheZyjbARj8BgecTTgckQOr0vIvfmPVc2JxZOP0tmK6+ui9XIuX3L7XcsrWPIKO8vOrugGY2uK1zLVnTpIWBBZmvQMoZLakHq7sujvgZoBdUa3qRqu7uk/GmRq7GKw20TR0UOiMGwJbOzENpZuG9P0vsTFJtGs+SSrz328vkPY0hr00DGcqD6fvRDzCVIArD4hM+FJ2PTRAKg==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 06:53:30 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4065.024; Fri, 23 Apr 2021
 06:53:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Thread-Topic: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Thread-Index: AQHXNtZtTFdrJ8Neg0uMUAwPgg5Dvqq/WQEAgACOQQCAANZqAIAA7NrA
Date:   Fri, 23 Apr 2021 06:53:29 +0000
Message-ID: <BY5PR12MB432267E19D8EB0F0760E1D76DC459@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210421174723.159428-1-saeed@kernel.org>
        <20210421174723.159428-7-saeed@kernel.org>
        <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0D056D310687E3CEA58DC469@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210422093642.20c9e89e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210422093642.20c9e89e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c596cf1-c16c-4c27-76da-08d9062480e0
x-ms-traffictypediagnostic: BY5PR12MB4084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40848CD3DADF2F833AF416F7DC459@BY5PR12MB4084.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DIhudN/6Ma5Jlls9534628HraGy0Ch5d3hbOOkmXl4JMoPqZBgLeloVQtcAoAPpc0Ww8zYFqjsc7za1hkPuzqA2IKqAgdSP6kb5GiTejVdDu7gjNlWUC+g/UFEv2w8rhMFGZ0/3Ajo2pW+U6HLVWXpbrhlXmF44UOlcOV3KkVozwrpmUC4sZgCZq3h9SAZSbv66jn0jNh09SmjsbU1pd+htvc3naykriNUVMQd8QjBO/QimPeTQ812xl2RYNhCbtLJ1UU7lHRqplXVmv9qu1TSy6KWwU1t6j61wFTSXjyd3+Cfwo29qkwwLqZf/V/aIMHKO9w1Jjk7f6T1f4OX55Xw3TOE9LKkjz+D3vaMrbZvDKBAOXUYFhBiZlsmRWZ+yOHBuUBNMPyNxvyg5ttPXnG7a2aJdVV5c7JgCjqiRPFHxvY2/ZkPf7UovVRgbUEu2UXJjnh2Bg0WCkXi1Aowm2XOkPDZwhmyB1PYUDQagDuHBZVM0cmn/aWdCwm1OO0Qaulu5foPF0A+5Qpk/gp62FXZrqU0rQIu/O7MT55RxrleI996FY1acofegJSHCxYDzgUSsUDgBAkibs6Mu4tnjZPEEjJQY5SBF7HP4sMwGnpAdgtmDwAK+cKWmOaGbpBj/geHR0k4yo3xtXBdQDiakl+pyd9z2gloyazvZq3BO7/mYOozqMpCl8lCZctA8bwUYW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(316002)(66946007)(55016002)(9686003)(83380400001)(52536014)(66446008)(66556008)(66476007)(64756008)(107886003)(71200400001)(5660300002)(4326008)(54906003)(86362001)(186003)(6916009)(8676002)(8936002)(26005)(33656002)(38100700002)(478600001)(6506007)(966005)(7696005)(76116006)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9nkqU4H7ussA6cvxxv3WLtipBPK6oAuWDpkF3d6PcpxmiOmFAEN4tsYspkch?=
 =?us-ascii?Q?ITHwwIR55DcnryA2aWpgbhF6upqMESzXEh/lj6rdUW9rZtL6lgTKtS6GXOul?=
 =?us-ascii?Q?U5D9LplL3ZqXn6WzPpEXfQJx7m64NGs/5hxftZowQWbO7/p6us9TG7DVuohn?=
 =?us-ascii?Q?X0R5Hou2yhspJM+qP3lSEOxuLb2HWjnfjurCCIaFFWdDH3tsUDsZeQHAuCfB?=
 =?us-ascii?Q?FoEKe2h08AilNyYurPR19XonXuffkMFNWWDJTHW3Hho7T+Cuscu1OviRTY5H?=
 =?us-ascii?Q?5FIvNW6MuPv+R0xJWmxMTAVAVqTH/UE4zaJnIvzeSbuifgsfdcZcwFw+8qhK?=
 =?us-ascii?Q?z89ytvLdGnW5estF55pa+/wyi62YLxDPYij57AOMf11IgYL99rMtFR1Tmktg?=
 =?us-ascii?Q?igAm3lsZyB6NJWFIbMzQELBqR3RZMzJNwSDUVCwQzW2NyiCDnrtrM+6psa0V?=
 =?us-ascii?Q?WhiTjq03VXUpbLkoLQKBttYD/+AtoWQrT6gXkhmfe3YuTHR6l3vqqdfbo7TZ?=
 =?us-ascii?Q?7p7lLT0vZDQpO2MI0b70KGqtiPXAhOVnbFHJphVBxSj6A2MNWzJToKeFS0qu?=
 =?us-ascii?Q?0bjfZ/8Y3PEctWWrGgqvCaLhCjAZkLnAaimOBzBdSCxj6eNDLIXwNE1B07F/?=
 =?us-ascii?Q?Qh2WQnSOyf7jH3uyOcktBfBQst48jZfkaD6SLYkkLuGHFUstxa990AdntOC0?=
 =?us-ascii?Q?KpcXmpSkKsfRHaL+Jv++FA06Q9x5TqzI24/0RP7DZtx64N3PGEAOXXe5kdhO?=
 =?us-ascii?Q?En17rR0KWf+hfUj6i2LTlejRXbZT62yzfxXDEFPt/NTeWpRPwh5rQBzzWkpf?=
 =?us-ascii?Q?+S0y/lIptS7n1dinvMYwh4TeAfxhllV+Xv61aeFHDE/i8OXEHh+FhLbXqqeJ?=
 =?us-ascii?Q?zszhnxsQZg4x+l8dWx/1j+6LP6DjvXPUmAgmRAGpQsSDkUxpSi/qvtiMU1J7?=
 =?us-ascii?Q?NxTndILS+Tz1dqGNYVyIzfHyDi9cZPH4uDyuxl2aPNZhMM8MyRbifg+ElCiJ?=
 =?us-ascii?Q?UsO5ezxCEmohbP/CkYPmMwsoWrlIJZCq3UF9UZsfXHEC28IYcFYfOhiAaTEB?=
 =?us-ascii?Q?PJwXleGubbwVABPe7WkgsPnsUVBig3fEgSjIO21DCSWzC1bNzFpSL+lUSSJV?=
 =?us-ascii?Q?/wsDgB1h4Sd6Qi3jeUROeHjI5bqC8GlrCI3J0+rHshmnKOHIT1wL+xi6vkTR?=
 =?us-ascii?Q?v72f//8FtLKwZvAGRFtkmY5KsvDAMDMZjhp0TppcbXwP5ckocP7K3e4TiioW?=
 =?us-ascii?Q?O26up0pkAtN9cl2gcKu/uMzplGoIF0RUkykm2TUh/bflebn2Linf2cSAKgWN?=
 =?us-ascii?Q?57GebeNhNYZNK8SdEDWo32Rz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c596cf1-c16c-4c27-76da-08d9062480e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 06:53:29.8527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/yzU2sPKr98ze7bI74eIeLUma4/vaJQUXipjoSSN7rEclwb0zmo0/tmzpHK1ZK9mmRfwQwLS7veFJsi5SFVJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 22, 2021 10:07 PM
>=20
> On Thu, 22 Apr 2021 03:55:50 +0000 Parav Pandit wrote:
> > > On Wed, 21 Apr 2021 10:47:18 -0700 Saeed Mahameed wrote:
> > > > From: Parav Pandit <parav@nvidia.com>
> > > >
> > > > Extended SF port attributes to have optional external flag similar
> > > > to PCI PF and VF port attributes.
> > > >
> > > > External atttibute is required to generate unique phys_port_name
> > > > when PF number and SF number are overlapping between two
> > > > controllers similar to SR-IOV VFs.
> > > >
> > > > When a SF is for external controller an example view of external
> > > > SF port and config sequence.
> > > >
> > > > On eswitch system:
> > > > $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> > > >
> > > > $ devlink port show
> > > > pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour
> > > > physical port 0 splittable false
> > > > pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf
> > > > controller 1
> > > pfnum 0 external true splittable false
> > > >   function:
> > > >     hw_addr 00:00:00:00:00:00
> > > >
> > > > $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77
> > > > controller 1
> > > > pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf
> > > > controller 1
> > > pfnum 0 sfnum 77 splittable false
> > > >   function:
> > > >     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> > > >
> > > > phys_port_name construction:
> > > > $ cat /sys/class/net/eth1/phys_port_name
> > > > c1pf0sf77
> > > >
> > > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> > > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > >
> > > I have a feeling I nacked this in the past, but can't find the thread=
.
> > > Was something similar previously posted?
> > Your memory is correct.
> > In past external flag was present but it was always set to false.
> > So you asked to move out until we set it to true, which we did.
> > This series uses it as true similar to existing PF and VF eswitch ports=
 of an
> external controller.
> > Hence, it was removed from past series and done in this series that act=
ually
> uses it.
>=20
> Right. I still think it's a weird model to instantiate an SF from the con=
troller
> side, but if your HW is too limited to support nested switching that's fi=
ne.

I can't locate the old email thread, but we discussed the use cases.
Nested switch may be solution to some use case but not for the current one.
In the use case of interest, multiple tenant applications are running in a =
bare-metal host.
Such host should not have access to switching rate, policy, filter rules, e=
ncryption keys.
Each such tenant is assigned one VF or SF running on the host system.

Also, this model doesn't prevent nested switch implementation for mlx5 and =
other vendors.
Each such nested switch in that case will do its own programming at its own=
 level.
Such model is already described by Jiri in the RFCv3 [1].

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/#r
