Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF4CB28D1
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 01:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403913AbfIMXUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 19:20:00 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:9703
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390519AbfIMXUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 19:20:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlGPRIxXYtv+bnqMvG3RLzDuMXshktsofulLvE0wau/k25mMg4l0K7tlDXGvfm5sa38t5m2wAqAOdWl35Fyfvr1OY608yVky4V1dFS/ktFcgCZbLYjWHM4lxEYb5jrlIJv2fmxco/FI04euozR/82s1rTQCQcCP5Ew1SB4VkfF/1FhDfXQ7JyxmtosXw1jodlsulL2kjVY0HXdnzEFNLNqHa/71G03kjcqlsUJGNuteTo3BEB6K/f5deYElLJvT7XE8mVzImisGIAKF8U6FX9HrIFQebtK1jV0JTO9ugF2dPSwn5HDj2Tx7QEnXoZ4Ymo3X7B4oK5WlA7NmsoYg3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWEqHmA3xGYeUnRl8EdIElUxK0ERAMDlH/Lc9HCfT/w=;
 b=Aq/pizBtscijmPY71ypeEcILqKLqpdRxZIgd9XvgTGhVDv54gzmDEkEIQolraitP4kWSFvKsZFT2kdVgFUnRNh3Kt8YDv79eaeyA+To0sKSfl82YMVDCtJZJFlg3rwkQXGYSlqB8+iIdnPAMtxxTGxjOVoqqjMylmS3I/zjBrWIIjLD6UysjzCdKLfOVSkM07iGC/aK84wfKICBhGd7H9v2bcc5+xwCKvCVJgXnjge5CupESLyqv2jK/5FxCYbKPmIIDX4Z44Qc2vZDSBWaL3P2hUmNbtryVsYCLBY3Y7b4LkfQ+0FzcNftw2npWzOxNBC+1bqIjwCiJHMYSMbigeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWEqHmA3xGYeUnRl8EdIElUxK0ERAMDlH/Lc9HCfT/w=;
 b=mWw5I1ZHwwu2Qyqcq7BhaF6iPgrvAlv6EMudi1gFow3EvSmFZ3H0KsPMQsRs01gnSkBQrkbSDAoAnCMnuu6QW6Z11goyiISoYg6vSlXl4S/2LcrghK9zWVRA7gcbahncjAZ52N0kauSum4hxb99jkqcVi+0RXGWEmXjrsKyg3yA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4468.eurprd05.prod.outlook.com (52.134.93.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 23:19:54 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2263.018; Fri, 13 Sep 2019
 23:19:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Topic: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Index: AQHVYUZdAS6KYIr8SUO1vQ8myuXcNacjy68wgALDGQCAABfpQIAAEvsAgAN5WYCAABvpAA==
Date:   Fri, 13 Sep 2019 23:19:54 +0000
Message-ID: <AM0PR05MB4866C8AA4383F264DB0C75DBD1B30@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190911145610.453b32ec@x1.home>
        <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48667E374853D485788D8159D1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190913153247.0309d016@x1.home>
In-Reply-To: <20190913153247.0309d016@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1a6dd76-e19d-46b2-66dc-08d738a0e2ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4468;
x-ms-traffictypediagnostic: AM0PR05MB4468:|AM0PR05MB4468:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4468D3BC67118C53B4F6B13CD1B30@AM0PR05MB4468.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(13464003)(54534003)(3846002)(26005)(14444005)(53936002)(186003)(99286004)(53546011)(7696005)(102836004)(76176011)(478600001)(6506007)(53376002)(81156014)(966005)(25786009)(52536014)(476003)(8676002)(11346002)(81166006)(33656002)(66446008)(446003)(54906003)(4326008)(64756008)(66556008)(66476007)(8936002)(14454004)(316002)(86362001)(66946007)(76116006)(66066001)(305945005)(7736002)(486006)(74316002)(5660300002)(6116002)(71200400001)(6246003)(6916009)(2906002)(229853002)(6306002)(6436002)(9686003)(71190400001)(55016002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4468;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: or+PQ/Gu5LNEWvru4wRD0H1CyIkdpojZGDmz8OOlwM3C49PU2PA3wRdGNjShsCsfONFKBf5TqcD/cLnHff1rSLasgBsWAns2GfBLFNUA0MrsYR/jPnz2KuV0VSGqVtfwH6rD/1ImvTrNZEfGKpCsQdEoavuukQMWALyO8tYm5vLhbnyujrc5HPvkuB+RYiBzMPtmXjFMkuCtYAD4utbZoRMZkGq7SSNJCj8odtT6wLT7VPs77DXPIRVjNGUf9/LVmzshM2d4hFslw7ri3RtP7VCnPrr2nJGEgaeeo17ds5AlwPi/Wcf5wS5uQYZ5l1gSD33/9yFNWIYm/JP/nV7KW5lvuVHdjTloy0GPN9+7lW9TrRsehHoSmDrrDLeuhMjADN+SefpJdHv3UueQ1iXfLT/aMtJ/smOKYuhjMnPlRao=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a6dd76-e19d-46b2-66dc-08d738a0e2ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 23:19:54.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gl8wZJ6u8iy6D6aYZ08a+w88No2vvFzm7wm6HWZBoOqnMA7ObMJ+iG6TZ7WmuemV9J/1D4cxB9CZUSZGHmmmlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, September 13, 2019 4:33 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
>=20
> On Wed, 11 Sep 2019 16:38:49 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> > > owner@vger.kernel.org> On Behalf Of Parav Pandit
> > > Sent: Wednesday, September 11, 2019 10:31 AM
> > > To: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
> > >
> > > Hi Alex,
> > >
> > > > -----Original Message-----
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, September 11, 2019 8:56 AM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > > > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
> > > >
> > > > On Mon, 9 Sep 2019 20:42:32 +0000
> > > > Parav Pandit <parav@mellanox.com> wrote:
> > > >
> > > > > Hi Alex,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Parav Pandit <parav@mellanox.com>
> > > > > > Sent: Sunday, September 1, 2019 11:25 PM
> > > > > > To: alex.williamson@redhat.com; Jiri Pirko
> > > > > > <jiri@mellanox.com>; kwankhede@nvidia.com; cohuck@redhat.com;
> > > > > > davem@davemloft.net
> > > > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > > > > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > > > > >
> > > > > > To have consistent naming for the netdevice of a mdev and to
> > > > > > have consistent naming of the devlink port [1] of a mdev,
> > > > > > which is formed using phys_port_name of the devlink port,
> > > > > > current UUID is not usable because UUID is too long.
> > > > > >
> > > > > > UUID in string format is 36-characters long and in binary 128-b=
it.
> > > > > > Both formats are not able to fit within 15 characters limit of
> > > > > > netdev
> > > > name.
> > > > > >
> > > > > > It is desired to have mdev device naming consistent using UUID.
> > > > > > So that widely used user space framework such as ovs [2] can
> > > > > > make use of mdev representor in similar way as PCIe SR-IOV VF
> > > > > > and PF
> > > > representors.
> > > > > >
> > > > > > Hence,
> > > > > > (a) mdev alias is created which is derived using sha1 from the
> > > > > > mdev
> > > > name.
> > > > > > (b) Vendor driver describes how long an alias should be for
> > > > > > the child mdev created for a given parent.
> > > > > > (c) Mdev aliases are unique at system level.
> > > > > > (d) alias is created optionally whenever parent requested.
> > > > > > This ensures that non networking mdev parents can function
> > > > > > without alias creation overhead.
> > > > > >
> > > > > > This design is discussed at [3].
> > > > > >
> > > > > > An example systemd/udev extension will have,
> > > > > >
> > > > > > 1. netdev name created using mdev alias available in sysfs.
> > > > > >
> > > > > > mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > > > > mdev 12 character alias=3Dcd5b146a80a5
> > > > > >
> > > > > > netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethern=
et
> > > > > > link m =3D mediated device
> > > > > >
> > > > > > 2. devlink port phys_port_name created using mdev alias.
> > > > > > devlink phys_port_name=3Dpcd5b146a80a5
> > > > > >
> > > > > > This patchset enables mdev core to maintain unique alias for a =
mdev.
> > > > > >
> > > > > > Patch-1 Introduces mdev alias using sha1.
> > > > > > Patch-2 Ensures that mdev alias is unique in a system.
> > > > > > Patch-3 Exposes mdev alias in a sysfs hirerchy, update
> > > > > > Documentation
> > > > > > Patch-4 Introduces mdev_alias() API.
> > > > > > Patch-5 Extends mtty driver to optionally provide alias generat=
ion.
> > > > > > This also enables to test UUID based sha1 collision and
> > > > > > trigger error handling for duplicate sha1 results.
> > > > > >
> > > > > > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > > > [2]
> > > > > > https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > > > > > [3] https://patchwork.kernel.org/cover/11084231/
> > > > > >
> > > > > > ---
> > > > > > Changelog:
> > > > > > v2->v3:
> > > > > >  - Addressed comment from Yunsheng Lin
> > > > > >  - Changed strcmp() =3D=3D0 to !strcmp()
> > > > > >  - Addressed comment from Cornelia Hunk
> > > > > >  - Merged sysfs Documentation patch with syfs patch
> > > > > >  - Added more description for alias return value
> > > > >
> > > > > Did you get a chance review this updated series?
> > > > > I addressed Cornelia's and yours comment.
> > > > > I do not think allocating alias memory twice, once for
> > > > > comparison and once for storing is good idea or moving alias
> > > > > generation logic inside the mdev_list_lock(). So I didn't
> > > > > address that suggestion of
> > > Cornelia.
> > > >
> > > > Sorry, I'm at LPC this week.  I agree, I don't think the double
> > > > allocation is necessary, I thought the comment was sufficient to
> > > > clarify null'ing the variable.  It's awkward, but seems correct.
> > > >
> > > > I'm not sure what we do with this patch series though, has the real
> > > > consumer of this even been proposed?
> >
> > Jiri already acked to use mdev_alias() to generate phys_port_name sever=
al
> days back in the discussion we had in [1].
> > After concluding in the thread [1], I proceed with mdev_alias().
> > mlx5_core patches are not yet present on netdev mailing list, but we
> > all agree to use it in mdev_alias() in devlink phys_port_name
> > generation. So we have collective agreement on how to proceed forward.
> > I wasn't probably clear enough in previous email reply about it, so
> > adding link here.
> >
> > [1] https://patchwork.kernel.org/cover/11084231/#22838955
>=20
> Jiri may have agreed to the concept, but without patches on the list prov=
ing an
> end to end solution, I think it's too early for us to commit to this by
> preemptively adding it to our API.  "Acked" and "collective agreement" se=
em
> like they overstate something that seems not to have seen the light of da=
y yet.
> Instead I'll say, it looks reasonable, come back when the real consumer h=
as
> actually been proposed upstream and has more buy-in from the community
> and we'll see if it still looks like the right approach from an mdev pers=
pective
> then.  Thanks,
>=20
Ok. I will combine these patches with the actual consumer patches of mdev_a=
lias().
Thanks.

> Alex
