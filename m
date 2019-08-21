Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D130297235
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfHUGX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:23:29 -0400
Received: from mail-eopbgr20067.outbound.protection.outlook.com ([40.107.2.67]:12416
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbfHUGX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 02:23:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1E9viyvrwV3QTSrU4SWWhK4ldcBBbLTkGbsTv70HCVSrcYBQIa8+29JARbaeMzDCNC51RMkruOLX18Ko7dDSs8pbeelmYfYAcRj33WNiXV5l9RT92XsWBWMgTQ6qdesUhvJjIjdteq/GiOZRyQ7NO2n0hlTVY0blpNIlPerNjbbCgqDWHk6IV3w7//MjoMdynUluivAsIqYEVReMTstHhntMfCnvk3rlj8nP/iBvOSMYB5Ydh7tctDxqJn0y94wEJq0L5RW9Bg90ZFmzkL6Un15eRpHuYBB0HjUAmX16N+K6vE7zL+ld+HUTsXLoUeeJ7Fq5w1kKN4wO0XlQezNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLrtGzAFZwx+rlwDtYtjSIJRKtccY3VJ5xXi2w/h4eI=;
 b=gZyt6ALW6VUCfXr23JAXPDN+YDVkOsvT8Vvmz0sjBbL2OdOiulYkn643gFpI4w3zEFDtOhFWMwdDn8O2Zeuv/kIG0WXkzbzMsNGvNDmV9ymjfqAKlkrUy2f7IBm6H6YZSCHVT3ZK2tD6DJOayda/GZE2jyP6PzZRhAy5w2nOmXWAu/xepOSkaCUs/QY3o0sPfdUDS0ngTLV+vK3te2fy5FW+dWVD2f+lLBP2YOAe9QzxhHvB1ZvuzxKaWGmngpy+a4/pwfgACfTkavj8jG3I9hbPyKekFY6TF8juWl8PVXNPOmn2Q6oICvM3pmySofE9vcS9TNP/5CBhOGf+SGKuQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLrtGzAFZwx+rlwDtYtjSIJRKtccY3VJ5xXi2w/h4eI=;
 b=gKstLjQkoASHFEE9qPBThGSDUeAQy86310vfjUuSB3R+OVCitC2IOqs50hHv6vWgLvLzevsilfB2OA2lr3063RTr94wT9NHdYwdZLPik9VS0HZdBiI8misBmEpHk99Tn/04EaxD8xQCcXTX7YW0h0Q6StduiEBUSSXH+rUb22VA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6690.eurprd05.prod.outlook.com (10.186.172.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 06:23:17 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 06:23:17 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCg
Date:   Wed, 21 Aug 2019 06:23:17 +0000
Message-ID: <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814150911.296da78c.cohuck@redhat.com>
        <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814085746.26b5f2a3@x1.home>
        <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820111904.75515f58@x1.home>
        <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820222051.7aeafb69@x1.home>
        <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
In-Reply-To: <20190820232622.164962d3@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3099db11-e4ac-4e1e-483d-08d726000e26
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6690;
x-ms-traffictypediagnostic: AM0PR05MB6690:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6690C6D7C6A34EDB04FC4BE8D1AA0@AM0PR05MB6690.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(13464003)(199004)(189003)(66476007)(66556008)(66946007)(81156014)(64756008)(9456002)(76116006)(7696005)(66446008)(81166006)(76176011)(6506007)(53546011)(229853002)(14444005)(99286004)(14454004)(256004)(478600001)(71190400001)(71200400001)(561944003)(316002)(6436002)(11346002)(476003)(8676002)(486006)(446003)(8936002)(186003)(33656002)(26005)(9686003)(102836004)(55236004)(55016002)(54906003)(5660300002)(7736002)(4326008)(25786009)(305945005)(74316002)(66066001)(6246003)(86362001)(52536014)(53936002)(3846002)(6916009)(2906002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6690;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ChAaDy/kL9vlBChvaFvW58emvjk2CPXwxtu4IQ0nU3ADPuyoZqZ2UW4qHcRcFO9t82NVCxhJbYGq3qJwC1ovtR5aCTZ0kYyLPeQSTzkzcmXBCCnDLeFZgvJGFGrSg1Ox3pgNHSdqp6BFDvVdMQA0uQZcb9SoawoW3dSTbaN2+jntKCa+qkNG6I/5OsydWoTYY1MQVM2bRlLbBgkyYPLGxPKbLfl1A5oA5NJ9qF7o5HpIfgHhSwbqwbxOgG8O5X8ePpL6v0sDn1NANn7ZBwq2Kb4FraLEv/zDtNIS5NMVeTdpuzGjzuyeZO2sTGhCb45/RAFq+jzOYLbBs0Ma3pqfL5WuJ4HxsbCVu5SKPcXlHBxWs0H+aoJQ1UUembk4cwpdyOM3pidHb+i/APzxochn4kuqYAAzBGTYAk2e5inwA1Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3099db11-e4ac-4e1e-483d-08d726000e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 06:23:17.4090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ap/TsbHcF6CEpSwNxzkkJmCpMoaC8ArrvzL6Diyup5aOrKJzSLYYMuC6HRdNnWOesoJ5JOYzCwG11aRH5CJBkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 21, 2019 10:56 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller <davem@davemloft.net=
>;
> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> <cohuck@redhat.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> > > > > Just an example of the alias, not proposing how it's set.  In
> > > > > fact, proposing that the user does not set it, mdev-core
> > > > > provides one
> > > automatically.
> > > > >
> > > > > > > Since there seems to be some prefix overhead, as I ask about
> > > > > > > above in how many characters we actually have to work with
> > > > > > > in IFNAMESZ, maybe we start with 8 characters (matching your
> > > > > > > "index" namespace) and expand as necessary for disambiguation=
.
> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with 12=
.
> > > > > > > Thanks,
> > > > > > >
> > > > > > If user is going to choose the alias, why does it have to be li=
mited to
> sha1?
> > > > > > Or you just told it as an example?
> > > > > >
> > > > > > It can be an alpha-numeric string.
> > > > >
> > > > > No, I'm proposing a different solution where mdev-core creates
> > > > > an alias based on an abbreviated sha1.  The user does not provide=
 the
> alias.
> > > > >
> > > > > > Instead of mdev imposing number of characters on the alias, it
> > > > > > should be best
> > > > > left to the user.
> > > > > > Because in future if netdev improves on the naming scheme,
> > > > > > mdev will be
> > > > > limiting it, which is not right.
> > > > > > So not restricting alias size seems right to me.
> > > > > > User configuring mdev for networking devices in a given kernel
> > > > > > knows what
> > > > > user is doing.
> > > > > > So user can choose alias name size as it finds suitable.
> > > > >
> > > > > That's not what I'm proposing, please read again.  Thanks,
> > > >
> > > > I understood your point. But mdev doesn't know how user is going
> > > > to use
> > > udev/systemd to name the netdev.
> > > > So even if mdev chose to pick 12 characters, it could result in col=
lision.
> > > > Hence the proposal to provide the alias by the user, as user know
> > > > the best
> > > policy for its use case in the environment its using.
> > > > So 12 character sha1 method will still work by user.
> > >
> > > Haven't you already provided examples where certain drivers or
> > > subsystems have unique netdev prefixes?  If mdev provides a unique
> > > alias within the subsystem, couldn't we simply define a netdev
> > > prefix for the mdev subsystem and avoid all other collisions?  I'm
> > > not in favor of the user providing both a uuid and an
> > > alias/instance.  Thanks,
> > >
> > For a given prefix, say ens2f0, can two UUID->sha1 first 9 characters h=
ave
> collision?
>=20
> I think it would be a mistake to waste so many chars on a prefix, but 9
> characters of sha1 likely wouldn't have a collision before we have 10s of
> thousands of devices.  Thanks,
>=20
> Alex

Jiri, Dave,
Are you ok with it for devlink/netdev part?
Mdev core will create an alias from a UUID.

This will be supplied during devlink port attr set such as,

devlink_port_attrs_mdev_set(struct devlink_port *port, const char *mdev_ali=
as);

This alias is used to generate representor netdev's phys_port_name.
This alias from the mdev device's sysfs will be used by the udev/systemd to=
 generate predicable netdev's name.
Example: enm<mdev_alias_first_12_chars>
I took Ethernet mdev as an example.
New prefix 'm' stands for mediated device.
Remaining 12 characters are first 12 chars of the mdev alias.
