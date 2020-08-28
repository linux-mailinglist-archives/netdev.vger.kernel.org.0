Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10DA2553F3
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 07:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgH1FIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 01:08:55 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:21200 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgH1FIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 01:08:54 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f48915f0000>; Fri, 28 Aug 2020 13:08:47 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 22:08:47 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Thu, 27 Aug 2020 22:08:47 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 05:08:46 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 28 Aug 2020 05:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do7nrd3eciyn/idBTUwLa7ExKH7bHWtKvzSwx9nkAFI43x9ounK8MzUT9RqD2rY+rM+FyG1ZuG9c5ytEJFEYbXGUKDp3wl3bh9Y008XYGqE8GVD0/QaJUrjzx2sfFqlBLYGEvbmvFpWhUMO7OReoG46UXFz5IaWica9kM/I3GEeqf8FRwnopNf51M1Itl+PrFxB7fQdkFy2271SSfoyttfC/YJIieYVfe95FFw4AgcWb6GnzC34pubRU24V0wSVlSLeeRHPhpEw2GGmMFlumviEfFLVfpGEgOQ9qg6BQzZy1Q8U3e/1K2ZZSDo+ClnDr6L1dnuKn5ckbdopV9JEuRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oN3C+TdDp+cV5Y39HYV+JBLZ/CqTwK3HZBu1SS1ZW8c=;
 b=YuVWC+KlyIcWxhLHjX4LoDP3BhfSUyVRX6qotqUD6AF2NNb/+9Zluyn/X4ArZs+nsgLjtX5UkSG7C4/kizmWeTnxZt6O/mCRkCs5qMzt6LLalHmyryy1udt+1u6vgw4XGVartZeoIpdrqb9i6D9Ic88YX6coRauZ9gO4VWqb1jEkQhuQC7ZWfHXB0wKcROvfTbrKHSq252JPxbVumOT+qo5CZ8v7ZT/DtFQDiA+IsKDGSkYZImPkx5ZlCtDrsythrXyUaMeGr246EFHvVotQGGSljq7mDzGL+MBv47TS8R1JlqaspFyE7DRFYuXvTY6Hl9HV8q8MFnsSkL7n4p+rrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3077.namprd12.prod.outlook.com (2603:10b6:a03:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 28 Aug
 2020 05:08:43 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3326.023; Fri, 28 Aug 2020
 05:08:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
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
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAABAqQA==
Date:   Fri, 28 Aug 2020 05:08:43 +0000
Message-ID: <BY5PR12MB43223FD2295F9773F253FD58DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b16c9090-e88b-42f9-3f11-08d84b106fab
x-ms-traffictypediagnostic: BYAPR12MB3077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3077DDC97159DDC880C79F62DC520@BYAPR12MB3077.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 833VYz2kos/rfBa7tTZf3m8fVNcASaERgReCKC4yyDBGtL+r6YKGSOc0yJlRzIjkVWf/pYGdTFa3pr+tTdoV6JKvHSBHBKCAl6uHLcyDZtslaTJKWtXlxBqCZY27hrtcC8dCIQyy/0Rj2jP+C3RrNfkIscQ90CbMaaktPvcp35EawrVtzlW+Yy7pa7LDwEPgYFNP2qrZZxJzxggBjG2IzTXeZ/C1+3WdhESx0bBjU0B19hx3k+6QNC998mGkG4pxtICexaRok4/vS86YxG626/UiO6S/vUGPjZcsF52lBCBS2KDVWB8hMea440KlTIuQP0MTfZHMXbS1UTQmYX8ITg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(7696005)(2940100002)(83380400001)(5660300002)(6506007)(55236004)(54906003)(110136005)(52536014)(186003)(26005)(66946007)(316002)(107886003)(4326008)(66476007)(64756008)(66446008)(9686003)(33656002)(8676002)(66556008)(71200400001)(76116006)(478600001)(55016002)(86362001)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: upRrV16dk7L4GmKCzS6k18NPkuj306r6XEzf2DxcmHCzvM8daPIHnN0TTfnXl+KpzN9sKZKkf9OQ/SKiLj3zdzNi/eYCuGmW92zWfkoR7mLNKO7uq46CK5v89yBZb7EygtghXTx4jH0exEhdDgfgfrucgjNPoj9XluM5B0s6I3Ap1kU2Ja6MQN1euLfoJ3t2CySQAG4e8291esGBrYv6ZAx9nn7oOyIw9ZkXxjmpw4R14+y5l+LPHjAKXX8gMm+JUnjjRsK3mR3is2JdVyr5ptVtsrbWeXxS/jHkO6Iw7FCrz4u7PEIrh8QHFBNHrfxABUeoqGsUqmuiJb+gpsAiJWVJ6ZeD5bw3mIwhZsKhkBIPbh06EGdq0B7T6xp3EoFqQLBJs5vAs578NgGkyUcyvbD0gZLn0IXJIUGM9lRm496H1i4EpA8dQOxoDwhlpCja3xzuJiI3hBvXjPol7dvPDrYQY88r1Wp9U8XhY13Qd2Ecsfr0zlWdZFswkCOSRQWMAnbtaI4aYYHrFutRZ5nvA/82gKsVXylUl1x8LHA/TSn4HAe3dBvBUQh06p2W7udQ9ecEHqtxCKQ23CkCEbo7b3uaAmQTjLfmNDbeM23w3Vr5WfLVmMc27uwKoKZNbbfio0ik989djhwcj0XZxikF+w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16c9090-e88b-42f9-3f11-08d84b106fab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 05:08:43.7346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AfSq3ZG6nZIfLwSKHcjQqBGwgnSlWLbPTTsLXWnH5CPbGEJmK0ta1xqa9hVljOXwe+gp7zbM5S3KQgKHpIdCCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3077
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598591327; bh=oN3C+TdDp+cV5Y39HYV+JBLZ/CqTwK3HZBu1SS1ZW8c=;
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
        b=J/AkWVL0maHCw2K6BdO+jhhalxG4H7gG4d05fgQbvrYnZkrVbwZsirVfw51LiwdAX
         pmmBcpu9rmaSUbpKg7zVDSeGu8bTWE3G0WC99A0ggRg3TBxa3qKPRheTL73HNXZWeU
         7chRbqlKSCgLkv7mkDiZbSaHbwl0pytpjAGY/4I4+NBJpgQgW9EqCBU/I7sozfMnss
         ALDx6VIdQ9jbP7pLVMMlZGB5uyibeucICgWt7RLvwDpYcBAXSxGKBxLGUEsRI0zoVr
         mXrsVzjcOMSNLvXE7KUaevGqgZPimtKZJfk1ZhQj6Wdv7bdWZrFvHuj3HI0NfrlaV9
         TsljUBWRh00hw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Parav Pandit
> Sent: Friday, August 28, 2020 9:57 AM
>=20
>=20
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, August 28, 2020 3:12 AM
> >
> > On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > >
> > > > I find it strange that you have pfnum 0 everywhere but then
> > > > different controllers.
> > > There are multiple PFs, connected to different PCI RC. So device has
> > > same pfnum for both the PFs.
> > >
> > > > For MultiHost at Netronome we've used pfnum to distinguish between
> > > > the hosts. ASIC must have some unique identifiers for each PF.
> > > Yes. there is. It is identified by a unique controller number;
> > > internally it is called host_number. But internal host_number is
> > > misleading term as multiple cables of same physical card can be
> > > plugged into single host. So identifying based on a unique
> > > (controller) number and matching that up on external cable is desired=
.
> > >
> > > > I'm not aware of any practical reason for creating PFs on one RC
> > > > without reinitializing all the others.
> > > I may be misunderstanding, but how is initialization is related
> > > multiple PFs?
> >
> > If the number of PFs is static it should be possible to understand
> > which one is on which system.
> >
> How? How do we tell that pfnum A means external system.
> Want to avoid such 'implicit' notion.
>=20
> > > > I can see how having multiple controllers may make things clearer,
> > > > but adding another layer of IDs while the one under it is unused
> > > > (pfnum=3D0) feels very unnecessary.
> > > pfnum=3D0 is used today. not sure I understand your comment about
> > > being unused. Can you please explain?
> >
> > You examples only ever have pfnum 0:
> >
> Because both controllers have pfnum 0.
>=20
> > From patch 2:
> >
> > $ devlink port show pci/0000:00:08.0/2
> > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf
> > pfnum 0 vfnum 1 splittable false
> >   function:
> >     hw_addr 00:00:00:00:00:00
> >
> > $ devlink port show -jp pci/0000:00:08.0/2 {
> >     "port": {
> >         "pci/0000:00:08.0/1": {
> >             "type": "eth",
> >             "netdev": "eth7",
> >             "controller": 0,
> >             "flavour": "pcivf",
> >             "pfnum": 0,
> >             "vfnum": 1,
> >             "splittable": false,
> >             "function": {
> >                 "hw_addr": "00:00:00:00:00:00"
> >             }
> >         }
> >     }
> > }
> >
> > From earlier email:
> >
> > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
> >
> > If you never use pfnum, you can just put the controller ID there, like
> Netronome.
> >
> It likely not going to work for us. Because pfnum is not some randomly
> generated number.
> It is linked to the underlying PCI pf number. {pf0, pf1...} Orchestration=
 sw uses
> this to identify representor of a PF-VF pair.
>=20
> Replacing pfnum with controller number breaks this; and it still doesn't =
tell user
> that it's the pf on other_host.
>=20
> So it is used, and would like to continue to use even if there are multip=
le PFs port
> (that has same pfnum) under the same eswitch.
>=20
> In an alternative,
> Currently we have pcipf, pcivf (and pcisf) flavours. May be if we introdu=
ce new
> flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
> There can be better name than epcipf. I just put epcipf to differentiate =
it.
> However these ports have same attributes as pcipf, pcivf, pcisf flavours.
>=20
I pressed the send button without an example of an alternative.
Changed eth dev name to be more readable as phys_port_name.

$ devlink port show
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev enp0s8f0_epf0 flavour epcipf pfnum 0

This naming only go far as long as each multi-host controller is in differe=
nt eswitch.
When user prefers them under same eswitch, we will again have collision.
Hence, I suggest to use controller number that addressed both the use cases=
.

I do not know when Mellanox plan to support this mode, but I was told that =
this is likely.
What about Netronome? Is each host in different eswitch?

$ devlink port show
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev enp0s8f0_c0pf0 flavour epcipf pfnum 0

This combines the idea of building phys_port_name of pcipf and external_pci=
pf ports in same way.
At the same time it has the ability to use the controller number.

Secondly,=20
I forgot to mention previously that each controller (in multi host) setup c=
onsist of 2 PFs on same cable.
So pfnum!=3Dhost_number either.

Hence using controller number covering both use cases looks better to me.

> > > Hierarchical naming kind of make sense, but if you have other ideas
> > > to annotate the controller, without changing the hardware pfnum,
> > > lets discuss.
