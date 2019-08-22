Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C140999050
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbfHVKEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:04:09 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:1507
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729122AbfHVKEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:04:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9jJ9Vsk2qVTYPKndxJQ/yLAnGbHOFEAmYFFZEmga6s5SFR5spOzctWxcGd+A4xWGG3gZ/InCjkogJ7sQFAKZrKYfsD29tDM4D/W4oPOmSWAIgGt4riYIQS/8/Yn7SFl6cSRcXiq7Ulyi7mdhcmrnPizTki9cW7Vymggsl9nyUfn4nk25lWZcL2PqLcma1+SEL+j3yA3XBw7jdkgQaRHWm3dU2COHiKAxnRIi39rgx1t04+HkQ/L0FQAFZ7CtgkMy/sv2kDpDlVYzVm/1mqGYI8pHKMyhnCxpocLLLxpWRtnlFz7mGYRUVKHn2APqml902pLxHaUQumJY58v7tEqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO983N14VxN/MNmUTSQzc6l3f5abuH8tG1ZnKUKB3k8=;
 b=EnJjzAIizN0KekPKBGRJfcNej5pPVuMBwlX/Dc19JYADXXM7/mCU+/g31jcJE31jDS7gyhZXr6oJ/Fec4+5BaoLkq7UnFyc1RV2GUgx2CeerFz1/5pMj7voceTUxlCFHrKYgmeUDnLC5DUZAtTuFkDIV5rxZgijecNzAvZURqYdQfM0e8oght1IgazhQNqetNxoONn2VbyoWJc1YHIfSu3LlCzsrThsI6wKUiI6/UyZgPq8+ruo+el8y2BSOnTssgUXp2zumY6aBz3N1EGDVfihbvO+yHXGN+zpECG0yZYAHv/KOvpYCJiZM4vLNnmDBq8nyyGZeGna5Y+5oGW3IBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO983N14VxN/MNmUTSQzc6l3f5abuH8tG1ZnKUKB3k8=;
 b=lo8bdRQfY/BTewyDGqXppNiF8uMlv8JUCYqmivSjAvbwpPaHPFHVc6OTS/M5ybAo4OgO7hS5eepiUpNXBUi6PkQmCZJrmfKDv4lQWXgSr2gGwzOUb2yY9E4i7UDNPSmCKtt7GVJKyGZmJCRfT4p2wfHXS4KyKVu/hE0lWqe/GJU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4450.eurprd05.prod.outlook.com (52.134.95.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 10:04:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:04:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2AA=
Date:   Thu, 22 Aug 2019 10:04:02 +0000
Message-ID: <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820111904.75515f58@x1.home>
 <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820222051.7aeafb69@x1.home>
 <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822092903.GA2276@nanopsycho.orion>
 <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822095823.GB2276@nanopsycho.orion>
In-Reply-To: <20190822095823.GB2276@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9129dc78-6493-483f-5d4c-08d726e80f35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB4450;
x-ms-traffictypediagnostic: AM0PR05MB4450:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB44502AAF7751410670707371D1A50@AM0PR05MB4450.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39840400004)(199004)(189003)(13464003)(305945005)(478600001)(6506007)(486006)(476003)(14454004)(55236004)(26005)(53546011)(186003)(99286004)(81166006)(11346002)(446003)(7696005)(102836004)(8936002)(53936002)(6246003)(8676002)(81156014)(561944003)(76176011)(9456002)(55016002)(229853002)(71200400001)(86362001)(71190400001)(52536014)(4326008)(256004)(14444005)(25786009)(6116002)(3846002)(2906002)(66066001)(7736002)(33656002)(76116006)(74316002)(66446008)(6436002)(66556008)(316002)(66476007)(9686003)(5660300002)(54906003)(66946007)(6916009)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4450;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QbFq/iWxm8nmAA+IGNMz/Get3rS1PruEkMCH3MF6S0pflS1MGb+ZrzEVNCPNLcJ9VtOqfzPUFLy6iVcvUOHMInY7fF+fdaN5Po80dZWOcfezdA3p8WpQj69owLTMZL7wXE4yGVoxQ0FSz06YeoMC37rUYac6/wsXqxuw3JX9lw2joEFmJ4g6XqRFa8Oiu8k4B05eKd0XoVwrYjUHHnLKDztHF+XEtfVKnrQo9MAJmrizemQTlRMpFfdaLcYEFP76g/mrc1PU91R0LV7dlb909grxAc6ULeGhCRm6dhYjdTOWkStyL9ckS4XWkhiTbqDYpvhxhoYsvrje6hZ84LfUV1JuBcc9lQPydCop4nBA/XzJks7qvylwbo0qoEYsPO2gt/nDIaFP4u47moigILnzY26uOLPvwaOqDtwtv1ABMYg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9129dc78-6493-483f-5d4c-08d726e80f35
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:04:02.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTPNdDMfNtkRcjPjis6BJnNmKRsIc6ZziiztTwhTi7JY4mo63PZyVkZX9OFBXPVuIGapZGeNcMh/eLG5kWyO8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, August 22, 2019 3:28 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
> Wankhede <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>=
;
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Thursday, August 22, 2019 2:59 PM
> >> To: Parav Pandit <parav@mellanox.com>
> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
> >> Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> <cohuck@redhat.com>;
> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> >>
> >> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
> >> >
> >> >
> >> >> -----Original Message-----
> >> >> From: Alex Williamson <alex.williamson@redhat.com>
> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
> >> >> To: Parav Pandit <parav@mellanox.com>
> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> >> >> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> >> >> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
> >> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> >> >> netdev@vger.kernel.org
> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> >> >>
> >> >> > > > > Just an example of the alias, not proposing how it's set.
> >> >> > > > > In fact, proposing that the user does not set it,
> >> >> > > > > mdev-core provides one
> >> >> > > automatically.
> >> >> > > > >
> >> >> > > > > > > Since there seems to be some prefix overhead, as I ask
> >> >> > > > > > > about above in how many characters we actually have to
> >> >> > > > > > > work with in IFNAMESZ, maybe we start with 8
> >> >> > > > > > > characters (matching your "index" namespace) and
> >> >> > > > > > > expand as necessary for
> >> disambiguation.
> >> >> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start w=
ith 12.
> >> >> > > > > > > Thanks,
> >> >> > > > > > >
> >> >> > > > > > If user is going to choose the alias, why does it have
> >> >> > > > > > to be limited to
> >> >> sha1?
> >> >> > > > > > Or you just told it as an example?
> >> >> > > > > >
> >> >> > > > > > It can be an alpha-numeric string.
> >> >> > > > >
> >> >> > > > > No, I'm proposing a different solution where mdev-core
> >> >> > > > > creates an alias based on an abbreviated sha1.  The user
> >> >> > > > > does not provide the
> >> >> alias.
> >> >> > > > >
> >> >> > > > > > Instead of mdev imposing number of characters on the
> >> >> > > > > > alias, it should be best
> >> >> > > > > left to the user.
> >> >> > > > > > Because in future if netdev improves on the naming
> >> >> > > > > > scheme, mdev will be
> >> >> > > > > limiting it, which is not right.
> >> >> > > > > > So not restricting alias size seems right to me.
> >> >> > > > > > User configuring mdev for networking devices in a given
> >> >> > > > > > kernel knows what
> >> >> > > > > user is doing.
> >> >> > > > > > So user can choose alias name size as it finds suitable.
> >> >> > > > >
> >> >> > > > > That's not what I'm proposing, please read again.  Thanks,
> >> >> > > >
> >> >> > > > I understood your point. But mdev doesn't know how user is
> >> >> > > > going to use
> >> >> > > udev/systemd to name the netdev.
> >> >> > > > So even if mdev chose to pick 12 characters, it could result =
in
> collision.
> >> >> > > > Hence the proposal to provide the alias by the user, as user
> >> >> > > > know the best
> >> >> > > policy for its use case in the environment its using.
> >> >> > > > So 12 character sha1 method will still work by user.
> >> >> > >
> >> >> > > Haven't you already provided examples where certain drivers or
> >> >> > > subsystems have unique netdev prefixes?  If mdev provides a
> >> >> > > unique alias within the subsystem, couldn't we simply define a
> >> >> > > netdev prefix for the mdev subsystem and avoid all other
> >> >> > > collisions?  I'm not in favor of the user providing both a
> >> >> > > uuid and an alias/instance.  Thanks,
> >> >> > >
> >> >> > For a given prefix, say ens2f0, can two UUID->sha1 first 9
> >> >> > characters have
> >> >> collision?
> >> >>
> >> >> I think it would be a mistake to waste so many chars on a prefix,
> >> >> but
> >> >> 9 characters of sha1 likely wouldn't have a collision before we
> >> >> have 10s of thousands of devices.  Thanks,
> >> >>
> >> >> Alex
> >> >
> >> >Jiri, Dave,
> >> >Are you ok with it for devlink/netdev part?
> >> >Mdev core will create an alias from a UUID.
> >> >
> >> >This will be supplied during devlink port attr set such as,
> >> >
> >> >devlink_port_attrs_mdev_set(struct devlink_port *port, const char
> >> >*mdev_alias);
> >> >
> >> >This alias is used to generate representor netdev's phys_port_name.
> >> >This alias from the mdev device's sysfs will be used by the
> >> >udev/systemd to
> >> generate predicable netdev's name.
> >> >Example: enm<mdev_alias_first_12_chars>
> >>
> >> What happens in unlikely case of 2 UUIDs collide?
> >>
> >Since users sees two devices with same phys_port_name, user should destr=
oy
> recently created mdev and recreate mdev with different UUID?
>=20
> Driver should make sure phys port name wont collide,=20
So when mdev creation is initiated, mdev core calculates the alias and if t=
here is any other mdev with same alias exist, it returns -EEXIST error befo=
re progressing further.
This way user will get to know upfront in event of collision before the mde=
v device gets created.
How about that?


> in this case that it does
> not provide 2 same attrs for 2 different ports.
> Hmm, so the order of creation matters. That is not good.
>=20
> >>
> >> >I took Ethernet mdev as an example.
> >> >New prefix 'm' stands for mediated device.
> >> >Remaining 12 characters are first 12 chars of the mdev alias.
> >>
> >> Does this resolve the identification of devlink port representor?
> >Not sure if I understood your question correctly, attemping to answer be=
low.
> >phys_port_name of devlink port is defined by the first 12 characters of =
mdev
> alias.
> >> I assume you want to use the same 12(or so) chars, don't you?
> >Mdev's netdev will also use the same mdev alias from the sysfs to rename
> netdev name from ethX to enm<mdev_alias>, where en=3DEtherenet, m=3Dmdev.
> >
> >So yes, same 12 characters are use for mdev's netdev and mdev devlink po=
rt's
> phys_port_name.
> >
> >Is that what are you asking?
>=20
> Yes. Then you have 3 chars to handle the rest of the name (pci, pf)...
