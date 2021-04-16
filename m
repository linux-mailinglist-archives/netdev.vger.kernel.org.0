Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D723A3627E3
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244991AbhDPSpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:45:02 -0400
Received: from mail-mw2nam10on2105.outbound.protection.outlook.com ([40.107.94.105]:40289
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244969AbhDPSo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:44:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4cYGpe9jGR7V56U3lyGMO6+7rTt7lWaTpoY+hpBlWBmy8SBAYuJygLW1GwFYw43Lnzvpvuo+g6ckYAh5DSdqFOwayENlU8EOMAUN/+uHmktL1cmQmb8xvd/MBhS1KwqX/Alh1cLvnZzS3mGoG8mocnfxUognHsLhdmEJEVCaqSkTP+hnzWueF/He3mI/x+LIJ3Mfo7BJ88H+z6P1BpGwz2k154mOrpOkpQ7zH12brPJzmTPntZi4UKgpZXONZWLBpf1Ou0tNAoX48HXpAg2Rj4DKnyCIZ58JV6iJ5QAbNAichZnI2ze6s53bIk2vezLxvut5Z6O6pKfImpNsnM/xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knc8I0LqTgCA0SVrxScKB6BRHQdffrPHhtovQXujoaA=;
 b=DikHIkb4AQtT8eNBiTFT8AwOy0npf1AYm/RtlBMAHwFnehwNlbh+fhBzEmVtLLF/WmeQPE7miOlzwctb5cP6yHOhETxBCSfJrtA4mx98oFvHItRVzfDOk+HGrSQ3sAx9nEfboMysma+FUu97nBlOlkR9MAFWJmU3PY6YRrPBsm4ejeemZdovXD+7fl+sKT76gSXy6M5obhrMNBw6CHbpWwuZck7HnCmIKZNRtaR9uDpKd/KKGlPMOeXsbVwuV/PPw82bCFJ9TvGwQ2pfzUWVVdZD5EV16N1qPpl9/litER1NnT+qeYQVWYE1ogG+MwEn9DDGzvnaXY2yG/cakaF6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knc8I0LqTgCA0SVrxScKB6BRHQdffrPHhtovQXujoaA=;
 b=LUm8JuSNiiPDZeprdIvcF1fqw1SE02FDtQaAwcpnQeq0Oi6FPJqxh5vCNHqCvEzTtVZOWI51Qm0YExP+PL7p//vXKdlo4cZlRxB0xheacmDUUMEV0tzeSpF7ylgXFloTb5N80nnhQKXe0vfEVsYa08yQZ329PmHVpvl+DGDLuqg=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0174.namprd21.prod.outlook.com
 (2603:10b6:300:78::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Fri, 16 Apr
 2021 18:44:32 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Fri, 16 Apr 2021
 18:44:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMuNz15KfoBlrkkekxhRrL9s2dqq3ZoJQgAAKwQCAAAmAsA==
Date:   Fri, 16 Apr 2021 18:44:31 +0000
Message-ID: <MW2PR2101MB089264E445CE0F4E08BC913DBF4C9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210416060705.21998-1-decui@microsoft.com>
        <20210416094006.70661f47@hermes.local>
        <MN2PR21MB12957D66D4DB4B3B7BAEFCA5CA4C9@MN2PR21MB1295.namprd21.prod.outlook.com>
        <MW2PR2101MB0892EE955B75C2442E266DB9BF4C9@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210416110836.67a4a88e@hermes.local>
In-Reply-To: <20210416110836.67a4a88e@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d1da987e-5bfa-48ae-a8a7-5ad468a321e4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-16T18:42:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:d56c:64b4:268d:aceb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e08139c6-a179-489c-9b94-08d90107ac87
x-ms-traffictypediagnostic: MWHPR21MB0174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0174627AC404FD6A42172358BF4C9@MWHPR21MB0174.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDcl3ZCZuGcaaCkcKfANU6vDVJCO1l7e8xcQ6BEAjoXrxFpK4CfNVNVPLfJsD3rwg6/XUweTqgCV+h5qk/HOgrCyZTULMFVUz6Bj/wQRBbVkl7fBc7vpFeo4RHEiEy7gr06bA9YOecSnyJoqclf4kkRpkmMXy7ScJ7BpIsyCPP+cqk3fUwPNQRYreU/GnpghK0X3FgjQ6EuukvQiUOpWOqz/uquEB1OWx6DeuILBemQsmTercdZSt3ua7pQfv1XmEb3NVCFVW2VzQuKntgTSAC4Mga4DF5/bteF3R0DSNdWVCTktlQQL2VyoqDJd6EL623OP5GfQLeEklTJMjdIJJ3nbvOoowdIXUbuPvFp4XwQdsMjy1u2h8P9WkeGt3dO3zrfobTTC3gnUE90e/HvwCho4vlhtMDD8V/BSVIMmJ7SnXx9kfP4towDY0iv3bIWs//GSfaL4ktCGe37Q9dVnx+uS6qlJVDGEQWfO+SPIR/aoc24CWHZ9f/8Uq4vrL40lEUwI+CHyEs3Gn2lEHIT0kipZ1D81YYyAOpMFPFbAM0BjWFb2FVUH9g0bCkxyxL9tauHVLLTpY2HwJ6/vftp9hLwEksJdpSxe6AOk1kK9kP0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(47530400004)(9686003)(7696005)(55016002)(86362001)(66476007)(66556008)(64756008)(66946007)(66446008)(8676002)(7416002)(76116006)(122000001)(82950400001)(6506007)(8936002)(8990500004)(6916009)(10290500003)(2906002)(5660300002)(186003)(316002)(52536014)(38100700002)(54906003)(4326008)(478600001)(82960400001)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HuDFxBLNWdXyIS84buUCwuxmkQID6w5Bwfq4WJXfB9GtGlJj2kagtoNo6dYd?=
 =?us-ascii?Q?5eR/TEeXSZTBi4cSFTHvK70VDfO/frjBM1FBCAfgqooTNrzh6wt6ItF4NPQw?=
 =?us-ascii?Q?MR1nMGpfmU9/gL8KfKOsl8m2vEF9hAtsZN/8rIyLl94AUVvUTIJxoOKh4bfs?=
 =?us-ascii?Q?gsmrzW+rENf8UewgjDadt2GD/ALhR3JZyMRQtZLPWW8MPU9HF1TLErTsFIHe?=
 =?us-ascii?Q?LfLHqTjWaNHRoekYQuY4dL9gkxrfpXFbOkzUlICzRxpVi/qDjYb+CJ8FRx0F?=
 =?us-ascii?Q?cR/LBvq0lIZ1MYvrNd3LKHy5nAHuyODCTh1wDN5y2lSHNHGY7+SKbieO6orU?=
 =?us-ascii?Q?vbrxrMOKYUx0uGHvTCE8a1X20v3+2u+pmL5IsMirB/CS8hYvk5IAJlXI9r9G?=
 =?us-ascii?Q?TudzIGkARLWJVOF+1b7OwRuCuLjhgRtQjUrZPn3NE672wU4XyADSlv3jkH8f?=
 =?us-ascii?Q?rmmyL3r2pUwkjz2ZzeZxtJjxsi8CO3u1UCReQNWB2+cF4Wm+rQd/gWHT6G77?=
 =?us-ascii?Q?LiAHEnrIuIewYirFHaS5LOAkBUES9nZTKkd4pV2yCNC1o/a1582I/GcgTVI+?=
 =?us-ascii?Q?iPyyIqDRwpaJX5aPN1pmy/crFP0wp6uY5xTw/kkRsowWTzjndOF5WR15VxAQ?=
 =?us-ascii?Q?TrE1f7aqdzla4Icc0+OcjWxxKGtYPezlV9oG7OTlCNeKVlKBSH/ZbDOQWaF3?=
 =?us-ascii?Q?8ZlV/4yuFwLyP2G/TftpdxAdnCuygYhUejjjegkIW+meFCxCrj6odTM4t5KG?=
 =?us-ascii?Q?Ugm00YXW4REzXKN1JVbUvVMkttdMFLHCR3lk9eFU+DABchsFydeh9Nuz1/Ve?=
 =?us-ascii?Q?CiYq6wt3RQJf757sZ1NVhY26r8LZqpOf/A5lCnVrawrcG6QaVDtixxLiXFDZ?=
 =?us-ascii?Q?X2fZEAUdty5KGfNknj08K+ZQjjm9UTtD97pCnYzV4KnBHvAQbdpe6wlurmy6?=
 =?us-ascii?Q?2O1tGNTR4EuaH3Tax7drgFb2rLThNWNkwT7NeqEhHQewBNjKg46DXo7dKveu?=
 =?us-ascii?Q?mMNLDAEnyQjoCL3P96/NwFQ0Oco/cI1q6ElBaztdp3kSg3GSH2E68Xk/XYLB?=
 =?us-ascii?Q?4G8Z9Ykh27V1coIZq9UW79NiYaPbZT9c5zrXVwjSrx6mQ4lw2tYFohcD8tUF?=
 =?us-ascii?Q?mLW3jrd0GLfRC+JYmLAhJL4VZEAMs7XYe4qP8UUPkK3Qi7hH9nyH1dbZScdp?=
 =?us-ascii?Q?tJJzFLJKmP/nvTb5/WgDBQdqbCNNcmggRRm/xBAfbuVxu94ifMUBaCt/8vXm?=
 =?us-ascii?Q?khUlOypN85UyPQ39hHueSHcTZ4/j6eIenTpNGJA41hja2avHCqS01FFIsr/i?=
 =?us-ascii?Q?lJxi/dAx/t/FZ3sUjzqCEKdvTsZ7jZ9XShDtr5SiodHFIUaLM9rwRbybweRm?=
 =?us-ascii?Q?3aGbCWU87+Snu97y1Uwv95uN+RbL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e08139c6-a179-489c-9b94-08d90107ac87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 18:44:31.8843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LgXYAxVGEsu+kSANVuAkgLMnj81uVEntEq/Bxocmn8wmDLfbk1/cGa8U7e6mnRlCHkLPUB10XGnqlCJ+n0ApQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, April 16, 2021 11:09 AM
>  ...
> On Fri, 16 Apr 2021 17:58:45 +0000
> Dexuan Cui <decui@microsoft.com> wrote:
>=20
> > > >
> > > > This probably should be a separate patch.
> > > > I think it is trying to address the case of VF discovery in Hyper-V=
/Azure
> where
> > > > the reported
> > > > VF from Hypervisor is bogus or confused.
> > >
> > > This is for the Multi vPorts feature of MANA driver, which allows one=
 VF to
> > > create multiple vPorts (NICs). They have the same PCI device and same=
 VF
> > > serial number, but different MACs.
> > >
> > > So we put the change in one patch to avoid distro vendors missing thi=
s
> > > change when backporting the MANA driver.
> > >
> > > Thanks,
> > > - Haiyang
> >
> > The netvsc change should come together in the same patch with this VF
> > driver, otherwise the multi-vPorts functionality doesn't work properly.
> >
> > The netvsc change should not break any other existing VF drivers, becau=
se
> > Hyper-V NIC SR-IOV implementation requires the the NetVSC network
> > interface and the VF network interface should have the same MAC address=
,
> > otherwise things won't work.
> >
> > Thanks,
> > Dexuan
>=20
> Distro vendors should be able to handle a patch series.
> Don't see why this could not be two patch series.

Ok. Will split this into 2 patches (the first one is the netvsc change, and=
 the
second is the Linux VF driver) and post v8 shortly.
