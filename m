Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518932B58B2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 05:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKQEJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 23:09:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19256 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQEJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 23:09:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb34cd30000>; Mon, 16 Nov 2020 20:08:51 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 04:08:59 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 04:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jew/GB8ByImnb0BqxqWJ4FAGs7qpiAroBWRFSz51Si1hYHjMDsrooDPxnVsRiKz24vOvL0wC07EdVy47aTTkAab3gpPWYYGwrIeT/j2mxWL24bmZ0DEbs8sha+XGRQ6nlC4U1+AjJW7exdMznh0tfwnFdPbH17AW7i9jM9gDj1HCWUt4IGxLGr+lqeIa6K0e0oSCPIpfu7BsQ0FST8wAC3HJZIny93rBCxzBze/Rn3so6woTVMM91/viQOli6cwF9ciBoLBPw4JoRYlX/IhSZFGdYIZd/b0t4noXKHxwQDdY1l+U/cxoa6IivUAUs+iq1hzw3fHh6v7ETqcDHEKYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krSCZSu5sxw4gbRTuvuIEpuYp6Tf7jG5Uyt/9mCpHgM=;
 b=c/5AyZUfDmENGlh8g8jZk1af2dM6NSFYmWlGXSTQ2AgUNQXa1MSPVjY5hVyRwYvanJZs46ijarsBw8FmF2QoInMPDZ3YRuJp87Vsb43NOvRo3bREhw9+I+m3/ENLXbb/6iM5/uDqNemhGIYncLJVCHwZ24jRYfHwpiz+3tKU0dOUjcs8DouFRimxyof8YWUKpscPS0EKeG1K12dmO6sEK0FhgFraeYFrEnqmFXhveIIZwy0E3ahr/CV3WyVJtKS1iE18ZitRla6cpw6WEj37PfII40fRp5NdmWZ24SQtU1mbYIXrzFVCjIq9Vn8IC90gl0AdptYzQIOtwMe4SFbOag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3110.namprd12.prod.outlook.com (2603:10b6:a03:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 04:08:58 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 04:08:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQ
Date:   Tue, 17 Nov 2020 04:08:57 +0000
Message-ID: <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f145d29-9ed0-4f58-eb86-08d88aae81da
x-ms-traffictypediagnostic: BYAPR12MB3110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB311091941D03EF2205E4CA7FDCE20@BYAPR12MB3110.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgDz3RRJsZr7P488mJ79M5dqpbq+PAYN+sQkOZs+1zT8gzyYtyctPasTRL8wdJ+neZqGJ27Nl33DRh4mNcbTEE1zxIj69X7Awsd3K2LxKJNtcCcCBTjtKnWVwu5s41ZRKOAdB8GMD3/hee0oTb6AuwjA6F/Wvt/jMjOfVRaxU36/7b0RK4tzAxedzfDx+bLnC9g+iwpRW/3b7l6nXGKK7BjK4VQdZMgSYQxi/aeRaDNz58HH906ri5BEiRcmaxJGNN8dBhZpwsnv57vIVBsuTnMoWrEl5hMhihZqKN+1RWE6qtic1aczuKoAT32BWfYS8FbY+UCOy7kO0Jt+ScQoInrcogkJIsYp+K8EXp7iN/H5V/5H06QFsaM2eZFNvYZF7E6vCJ+YpvmRFggQMYCgvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(186003)(8936002)(33656002)(2906002)(478600001)(110136005)(86362001)(26005)(7696005)(71200400001)(966005)(54906003)(55016002)(8676002)(55236004)(6506007)(9686003)(4326008)(66556008)(66446008)(66476007)(52536014)(64756008)(66946007)(316002)(76116006)(5660300002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Dv4MUweOjSn2E3Yiw5QeEO0RwJiITWHO7y0apbdw3xagueR8gRVvtT6QlKSpluwn1mVKtO4/zmCAFc9R+uVVI6OgMTtnwrkqWP1Gyk+BZ7FdhyINP/FS7ebqpeHcjd9SHt50+Ih7vCWpXJvX9I2DDqaqC0vqauqpFXBqtuizLXb1ftWNwqBvj1XsgbdxeB+I+W2ELaFvaQyoBxpIrNI8I1X7T/RnCO888ICSiUeca6ecRwslTGcLQ1+jDisPopWIzHIRkSjviANhlTKzrj2LU35yRHCfFvLS7p/SctWzUaNSsy1KNFPRXNrnnVhbJQnS+numRJV8vVyyI3U7t5Gv4OrWEdQjiFm/l1c1N3YEve6xQmSTKczWpwxWYbJ+mmRb5KiNHP5IpvhVA7W0ZrJlEGVUUijNguGv+UWRo1cgubGQ9VCDnc4Mzb9JlB2+dTQKFLMc1jwyUhdPNOv0dnaBrETjHXtRjK2x+7W6S5gyMNjoJeDeu2BV7NAdiUZ4uRtH2AztceNfOinBGbCOcL+9MQfM8ONsFUvQSspAHawvNIyX+H0hOwvO+O281pdYxEqBLJCmUitF8qwJm+ercM6RQPc0jWYSPBf689ElgDCvjnNeHeetxDVTeSbNU6pm0vvBs2HOfxBtYFDCWLgvQYA1cA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f145d29-9ed0-4f58-eb86-08d88aae81da
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 04:08:57.9440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z83JBeWwmuYQZ1n0TNlqy22h6W1HWRfeC6LSHTwnTDQ44Lud/YD7w9cDmFv5gt2Ky6oEraF2dYFt3F9Mk63f+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3110
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605586131; bh=krSCZSu5sxw4gbRTuvuIEpuYp6Tf7jG5Uyt/9mCpHgM=;
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
        b=SfgSnNzjQjrw7wAVii/JCpXVbMuHcUq4iCe3nZf+SKkBtYiKm/EP12mIfA0MrC8Uk
         doMTYGb6JHtUQ+5JeKF4G8xstYXryPMamfhiFIbrmR5fHFRE2bR6FuLxqB3GIZs8ya
         +R03gvLRQXE1h0IIM7Tm1VC4MzFZFsb1FAbOzcDH2KCxhhhm60WJTtXSMhuXB0eRXM
         yjf2O6RytztbvmQY8mogzV2qcUpRK0lvtr7ATFeQkO8u62dLsa+yykQamNW/VRA4Z5
         xWjl7x0NNpg3iQWOrcmjFBc6aiDlkr4gGFWwJB+Y3ccaRBaKak5Cqe6P8QMZFFyEkP
         1KrpOFsem9p0Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 17, 2020 7:28 AM
>=20
> On Mon, 16 Nov 2020 16:06:02 -0800 Saeed Mahameed wrote:
> > > > Subfunction support is discussed in detail in RFC [1] and [2].
> > > > RFC [1] and extension [2] describes requirements, design, and
> > > > proposed plumbing using devlink, auxiliary bus and sysfs for
> > > > systemd/udev support.
> > >
> > > So we're going to have two ways of adding subdevs? Via devlink and
> > > via the new vdpa netlink thing?
Nop.
Subfunctions (subdevs) are added only one way,=20
i.e. devlink port as settled in RFC [1].

Just to refresh all our memory, we discussed and settled on the flow in [2]=
;
RFC [1] followed this discussion.

vdpa tool of [3] can add one or more vdpa device(s) on top of already spawn=
ed PF, VF, SF device.

> >
> > Via devlink you add the Sub-function bus device - think of it as
> > spawning a new VF - but has no actual characteristics
> > (netdev/vpda/rdma) "yet" until user admin decides to load an interface
> > on it via aux sysfs.
>=20
> By which you mean it doesn't get probed or the device type is not set (IO=
W it can
> still become a block device or netdev depending on the vdpa request)?
>=20
> > Basically devlink adds a new eswitch port (the SF port) and loading
> > the drivers and the interfaces is done via the auxbus subsystem only
> > after the SF is spawned by FW.
>=20
> But why?
>=20
> Is this for the SmartNIC / bare metal case? The flow for spawning on the =
local
> host gets highly convoluted.
>=20
The flow of spawning for (a) local host or (b) for external host controller=
 from smartnic is same.

$ devlink port add..
[..]
Followed by
$ devlink port function set state...

Only change would be to specify the destination where to spawn it. (control=
ler number, pf, sf num etc)
Please refer to the detailed examples in individual patch.
Patch 12 and 13 mostly covers the complete view.

> > > Also could you please wrap your code at 80 chars?
> >
> > I prefer no to do this in mlx5, in mlx5 we follow a 95 chars rule.
> > But if you insist :) ..
>=20
> Oh yeah, I meant the devlink patches!
May I ask why?
Past few devlink patches [4] followed 100 chars rule. When did we revert ba=
ck to 80?
If so, any pointers to the thread for 80? checkpatch.pl with --strict mode =
didn't complain me when I prepared the patches.

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://lore.kernel.org/netdev/20200324132044.GI20941@ziepe.ca/
[3] https://lists.linuxfoundation.org/pipermail/virtualization/2020-Novembe=
r/050623.html
[4] commits dc64cc7c6310, 77069ba2e3ad, a1e8ae907c8d, 2a916ecc4056, ba356c9=
0985d
