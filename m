Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D1CF6DC7
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 06:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKKFTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 00:19:43 -0500
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:48755
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfKKFTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 00:19:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDLSpkGhuf8LeQwr2mWD3Ktsn9o++NTQmD9kdp10VOrA3CPqclw2JugUwsPXsJsjQ0lfB8J8l2fLnIeVR0ELo4spLtvFyMarhhx0IZHa0ETfkSN0fzYtP2EOEGCjJXGdzH9RRgbMGTC0LFAghgWhnnMiM3tqR/pzX1KcfIIPpY/UdS+A/NkfVx3UnwSg/kNraBDNQeG2KPODwYwoTSURFUz6ilXbOMLYyixogy8OcBEow7ke5Tpb4vuFdgKd7NFWnNaEVuyB3fBc6m8Yvw8uxtBKucy2Ij6gGn5r7bcPQZ4MqTvB2tPvViJuxzIefVj9jisEafsisHeyPdjHksCq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SyIajGS12HV+NllRtfSqg1osLj0YsoumuKnMN8eFHk=;
 b=h0zUUIlNYegm1H2ffA7SDI/hW9zjCPukMoQpk6yx/llmxeNssaVuLFGjs8SxwBgJ9twAfE4hNxTljlnHnzJ6zkEhPtoy+lM93Krugdmzjmba0tfZI2wEhKettPg21G+vIAWMpU3tIlDqyC7I9CBt2QMaSYeu9uzsRlf7ITAJ8K9qte3GoNNjn3RTpGMkNgVjHPGvVvXir4PetqhoIW9XY/AMMjo7caYrbsytRp8No1O4ywUyOiMzNRJlBpHPLL1BNQxU4CAKdYf5Hhe7HIDZbfQ/YWnCaKLMmG3AfjdDfUfTm80NE0wQTO2SQVu/lhj8TVX8iZ8ZexuVveRnX7yMdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SyIajGS12HV+NllRtfSqg1osLj0YsoumuKnMN8eFHk=;
 b=j3GkzlLWvarPeBGnlgSYlfEx0Q8d5UNOf0MzxjWbjfVXCuQNDLp2S+wxAejUyHrYzz5UYfohbVtWkOs6DnpGHFJ1TQ1dcPoro23EqKr5sfVDVFZ671YBjp84NWZBPd2izP8qkOGbcKBSH4oPcaU8Z4UhBmhCwG6HNpZMpNPAfwQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6148.eurprd05.prod.outlook.com (20.178.115.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Mon, 11 Nov 2019 05:18:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 05:18:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAAGgOAgAAx3ACAARhVgIABCb6AgAE1UoCAABjPkA==
Date:   Mon, 11 Nov 2019 05:18:57 +0000
Message-ID: <AM0PR05MB48661B4BA4906D90F7969BA5D1740@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
        <20191109092747.26a1a37e@cakuba>
        <20191110091855.GE1435668@kroah.com> <20191110194601.0d6ed1a0@cakuba>
In-Reply-To: <20191110194601.0d6ed1a0@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:61ca:c318:74fc:4df4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83df0e5f-0424-43bd-e3a1-08d76666a790
x-ms-traffictypediagnostic: AM0PR05MB6148:|AM0PR05MB6148:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6148860488EA4A17C90B87CFD1740@AM0PR05MB6148.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(199004)(13464003)(189003)(14454004)(478600001)(25786009)(2906002)(6116002)(81156014)(81166006)(76116006)(86362001)(64756008)(66946007)(561944003)(33656002)(66556008)(14444005)(66476007)(66446008)(8676002)(256004)(8936002)(7736002)(52536014)(6246003)(9686003)(6436002)(55016002)(2501003)(229853002)(11346002)(446003)(46003)(74316002)(305945005)(7416002)(476003)(486006)(71200400001)(54906003)(110136005)(4326008)(316002)(99286004)(102836004)(5660300002)(71190400001)(76176011)(7696005)(6506007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6148;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgxN1e0dZ9gFNVUnPs7YLpIOfi+7sibczaSCpMnFhlcIpd3/K+yWVa+txJfzAxc822We0x+x/oQzOgo4cng8bEVaTBcsZFznIMU8LLqXvcv8G1HpFT+LNyh/inEUbcmT42rD8XPbOJCCp9bOX2rcLXg3BAqzYzc5aEQzz+tB0ZQ0zFWEuIdZbGZrv5OGe8IOtg3MVJ0GxpdNMvZkrGbsyat5L4V1uxlh3sTeZ9VU3wXuT9QxUlxt65aN4d0QHAv7R6ziWjdrjx/iuankusGAuQ1UvJBTeFWJ8k8vxFGWbmvhau7KfLbTzM/kjq7VsA4cbF2DA1oy0D7HGJzktjAEedAlIlod9t7ipReYgON5a6CsSdOr5DWpxfHOZt+690K7XSM1ltFz9K714CJ0NAhsW+SRfa6WDzxvCbcAZKo11Gu2o+3rjJQeRrVFntulKrHh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83df0e5f-0424-43bd-e3a1-08d76666a790
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 05:18:57.8953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5s6K9nWPHA5GszhMspx4HCB2mEq/nczksQ55zOwnZkPrHgXmjugy2vDPyXS8tUjDBDf+kAsBZQfv4q9Fekurng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jakub Kicinski
> Sent: Sunday, November 10, 2019 9:46 PM
> On Sun, 10 Nov 2019 10:18:55 +0100, gregkh@linuxfoundation.org wrote:

[..]
> The nice thing about having a fake bus is you can load out-of-tree driver=
s to
> operate extra protocols quite cleanly.
>=20
This series does NOT intent to do any out of tree driver.
Please do not think in that direction for this series.

> I'm not saying that's what the code in question is doing, I'm saying I'd
> personally like to understand the motivation more clearly before every
> networking driver out there starts spawning buses. The only argument I've
> heard so far for the separate devices is reloading subset of the drivers,=
 which
> I'd rate as moderately convincing.

Primary objectives behind using a bus in this series is:

1. get same level of device view as PF/VF/SF by devlink instance
2. to not re-invent already matured pm (suspend/resume) in devlink and/or v=
endor driver
3. ability to bind a sub-function to different drivers depending on use cas=
e based on 'in-kernel' defined class-id
(mdev/virtio/kernel) - just like vfio-pci and regular PF driver, by followi=
ng standard driver model
(Ofcourse, It can be done using 3 or more buses as one virtual mdev bus app=
ears an abuse)
4. create->configure->bind process of an sub function (just like a VF)
5. persistent naming of sf's netdev and rdmadev (again like PF and VF)

I will wait for Jason's and Jiri's view on the alternative proposal I sent =
few hours back to omit bus for in-kernel use of sf; and see how far can we =
run without a bus :-)
