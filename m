Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87D47B382
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhLTTLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:11:44 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:42476
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234420AbhLTTLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 14:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEyZjk54D51KRkEEdOfI1yJ32TmW1wSmDrOm5LVvAwnYtzCd7GfbwK4Ve4F5baBSNYErtf4kvvv/ZchamY9o+UNh8lzjUSG4WHcrYEAOqyaU5w/6Bz+2Esf7r9NCeMfUBXiuCWwc5zZ1ZFGhLI7XZSbzmhYKOYFM7ulx6m99iZ7B/63Kw9/WpYNLyqbrUMX5yBb8BwLObowRaywrXV9TEOFUCk5O6wXZnRfeGt7eh0tSYa8F9shgJzP4a1S+QmzabYk3/8aCxbjrHIHs0cXep8RTVedfOloe2CmYb2sw84XbjpUPBA4CYd4kVt4GnPvKCVXplEUoS5H8zZctWGnC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2cfhVw8Jrva7RGFBfwckUQSxGvsPMfwfvGfIn1qovk=;
 b=LGmAvEro7le6auE7tHBzIYXb4xWrfREVVo7mkeN0h48QtbbHZTzzqPAtSpiO7lkoNIUYqOOzV1cW2neYOifa1CCzqC55uZPB8cmHPI6kaMAbBaU92NcYmRGCgy2zQWHTLhioAuyywX/RyW8s69uGw6BhLL/Pym6eOwmDuaCRrWDP+tUrBh6SHRARQcYJr7s5N/7vvar+jAyQAeXG6eo4sMI4j4+7GeVzSLAULQZByAU7qaX68UkZdg7cIzoI1vzqLQnBALt6dp2Mo0Y2gi1zykMOSLF2X3nUjkj3ja7CFRkiNP47igcMqjfhSoAiLMLMBTgF0Uy7oJmweQ3lJmiYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2cfhVw8Jrva7RGFBfwckUQSxGvsPMfwfvGfIn1qovk=;
 b=FfUC2Vuyu/zApdD0cdshXWXVSXfRhoLzGkFrkb/wImGJee1k3iXhhOlQGzUrrf1BE5o1Q29iWpdaAv+LMFqxtvUn9NfHuXyfq+oNsJA6Y4bfU9cdVV/npxbcxRb07ATNLFu+fIHtWNkiHi6HRLfT8wbi3dZvWvTigofkarApen8BLxPjXKmmIy7bSc8QEIpQ1jcaLqEoqUK74nm52wbJTxiiTkzPcNekzl+rMipMOrPwHjAxa5RJ4lgdos8b+vv+0dZVX0M7B5FXu0bRckgUWxqqNfGOsvkwUc3S3eQvsqKVqLdDwMqHAMw9TU0z1ndigjx+yKBGQgzjwMDPkc/Nuw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5483.namprd12.prod.outlook.com (2603:10b6:510:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 19:11:42 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1864:e95:83e:588c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1864:e95:83e:588c%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 19:11:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Thread-Topic: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Thread-Index: AQHX8x1X9Wn4iy01GUen8mUL9hh9r6w4vEKAgAAUvoCAAfAdkIAAi7YAgAB3j6A=
Date:   Mon, 20 Dec 2021 19:11:41 +0000
Message-ID: <PH0PR12MB5481E1BA270A1992AC0E52A8DC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
 <20211218170602-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20211220070136-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211220070136-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ff6d703-9551-4976-97c9-08d9c3ec8e80
x-ms-traffictypediagnostic: PH0PR12MB5483:EE_
x-microsoft-antispam-prvs: <PH0PR12MB5483EC7C5B6FCE9D46AC3E19DC7B9@PH0PR12MB5483.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4L80e6c6r/DagPXp6aJXiWSbhWwu11/VFSiG7BTK1W6Jv5vh4R63B5mam5KguCBVtW0/aC/w6DxdLbk7OrJlGOrOVPOmfuAo2VKy0hIHh7bq7LgNzPPpNxEnNQsUufaXfKMD5eDtNIraCHcT6aNx3k80CGFtwfgxmtx39OPscgcodUM++tnKxApwi/4SYn2O37iloRVHvaM8z45R4I0KZPIgYc4mHESRfMe2oPCXAJYGYim+nV0BdLL7/m+gfCh8age13Dk+5tuvAUXfuxmEQvMkeEoL2p24QCC1FoZFnrPQtpIXcYLFTIWNcBAysfW6qbt/R9xJPosqe4K44kkI8fi2Gw1kEf8SNGWPwFLBrzoLC6KuKIsu1Aj4XCuqYIcw3PZC2EoPM9eSKVkC/uJ+q+Seh35Z/cUL8kaV5zuAi/ni+kkP8jAHVdq585GbpKK6TJc886zFG3gwwbcaHWR7hDfKHpxho0cKLbaBTSzD4mrHnGMllOsc2MuJIfwnRwcK4snrTVzLKhr5PID4w31yGN48a6shKwfbhI5YBXFo0xT6guIAg4EVtkYZb+4OMJypkua8BYrIcGXmcD1VlhJgtS1PrzGkthbala/3iO0mMsds11wT5OL7P6PnjLk2zLMzu8ghK+MamDERdx+HYrjc0j2Rj9zuUm4Wiv+gfRLfvhf/RfIbf756sMvAK9TJGWUs6DTH/R2fNLHlKv3YmEyraoLKMNVziDl/cGO8f5H16s61ohTm95pEM6hJ0wuhQ7AhV9KzbaTvn8XkXnJNlmERYnoc5gugckpMuJ0W4kH+rQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(316002)(8936002)(54906003)(33656002)(83380400001)(38070700005)(9686003)(966005)(26005)(6506007)(122000001)(53546011)(38100700002)(7696005)(55016003)(4326008)(508600001)(5660300002)(86362001)(66476007)(186003)(71200400001)(64756008)(66556008)(66446008)(66946007)(2906002)(6916009)(52536014)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fVRzUL9C4kPINraiidpVRZmSZuzwdRFkUgPPAxKNSRBOKyUQezeiQAJ3yAK9?=
 =?us-ascii?Q?Htr/gB47rXagAErOuvAa4RSMQzCMmemNcLZfVemhiCNRFXZF4WY4MzLDx1kZ?=
 =?us-ascii?Q?kYaPRLY+K+sZ0qg5vL0m+UJc7uc/OGfeNf1S4GWbfVwwKe8FMj+QFOiD7YHl?=
 =?us-ascii?Q?yd1kUggMHPJawRrK3ieAI49Di06CCDZ3tvYGkVetcjBDuhu80ox04+0hwSyJ?=
 =?us-ascii?Q?KOANlwCZGOBC1MxGRzKcecR5JDTLBRtr3DdlC4ofd4g5U6HVibbRI1Ru70kY?=
 =?us-ascii?Q?CYxPdyCLdy1H4KDEyX6esnTmcC6QXmAIMYkGFFC18FS/0GoSkOxg7oR+c34V?=
 =?us-ascii?Q?UGsEt3AH7U0Taqa6oU9PnJzlNXvCu9b9KZdpnLWGtEmsDmbY8YDbNRIkA8QH?=
 =?us-ascii?Q?KxNPRbOhFrMmoy2VsiiWrzwId7THC3UHUbBVpBESs64h1CeHne1gF+XCyDOq?=
 =?us-ascii?Q?z3+Ee3/s1z1G0H+q/zqt46quslIVd6mL1N98X6wGRQmMOyLufwU/tPAJ1lOx?=
 =?us-ascii?Q?ZRxrSJjVLJSdGBsyew67aP6pXsD4BaQt8C9xNK8siVYsomN+fhtoE7o/AOvz?=
 =?us-ascii?Q?8FA/JuL1SAY/P452mvuLK6JH5rdrwd24LUq6LPX5ecrEmvzEI7jFt5qPyF14?=
 =?us-ascii?Q?iO/KcRTR3nwo+ixrS1upUTx6z2X6KlfQVTecl6f3OWtiqVdMn9HFKx1UKkdF?=
 =?us-ascii?Q?3nEsbnBfrT+b3+YihLRTVCIReeYIloE0TL7NgS0+KwfqI8eQWxu4BAMgDv80?=
 =?us-ascii?Q?uI36oLFBlRpbMGPtpHuWrbyK90ZtXkaaHM8Tm6P6TwRm56VRxseIzt/k1JnZ?=
 =?us-ascii?Q?bpKaF6TEJV/fhlQXbP3QeR8lwSQO+DG0FhcrB4inbZGoKOuu6p5ZOhm6W+K1?=
 =?us-ascii?Q?nZh9P41yOFYgphpyMwZI2PMhtQo5xE+pYLhqTivj5mNjJlQQGIySxblXeTt+?=
 =?us-ascii?Q?Qn5G+aGGg9LWF4aCj3tV0a06fLgh1h01EkVBpD2npPW+fa0/HUHYnDJ9+GHv?=
 =?us-ascii?Q?SnO+nVbgrBb4+G9RZnjv4J7eRqQDFHG86c4JP+mJyM1I3mjsSTdAMIr5deiw?=
 =?us-ascii?Q?Tzh/BIq/WTjvp8As+SNyida/VLSqP9CzVB/W1qS9rHlelJY+oHRsAfU7RVSf?=
 =?us-ascii?Q?BoY/YepmtBESkZJ3DrvD522OLtJl/3IN2yuTMXXMU1JSQ1+ajVFZYnPwqUPl?=
 =?us-ascii?Q?S9TvRdCHQR1cwQtDyoNrvuwtiQQjxP1J5YDK2Vbkd0bx5WWlJKqUpcj+sL3z?=
 =?us-ascii?Q?9Q4rvcKAUZuqx9pFrULGiRoKPC0gcpVXP1yEmExDym3G1BOGajWPQ2Wt1fbr?=
 =?us-ascii?Q?6oliZfWRxxa0+k7I3bFJp6+N3IMmimpjBTOwpRhZe8BMPhHa64vHpbVwXk9A?=
 =?us-ascii?Q?kjFC1mZvHRbyGnftRr5iLBabYfyKFPTEAe2/odrSf5J5M/Tq3sWI95oiSOwI?=
 =?us-ascii?Q?XWp9427aBbbtawtyO1baSoQK5cf37W82i5MXL0f9DsQnzC6AXuwHz7sdhFXI?=
 =?us-ascii?Q?jYJZUb14GtQvYNMlCrC5sjLR43SsvPFYHBCmrFe3vPZ7DylZJOab09n2lvJ7?=
 =?us-ascii?Q?bbUKE7JQV/UfZtfR8JWaOMM8rUVkjuNPdLohdXA9zAifOOdFUa7IZa5c/AGq?=
 =?us-ascii?Q?hQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff6d703-9551-4976-97c9-08d9c3ec8e80
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 19:11:41.8720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkHpfmE+6dlcpht4eWRx5Z6/2CZM+wNi21dRtqlBpUiFvoKTkdrG+mDRW6JbaTCDPIpVbZv2IGTrqdPuX3+KHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5483
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Monday, December 20, 2021 5:33 PM
>=20
> On Mon, Dec 20, 2021 at 03:49:21AM +0000, Parav Pandit wrote:
> >
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Sunday, December 19, 2021 3:37 AM
> > >
> > > On Sat, Dec 18, 2021 at 01:53:01PM -0700, David Ahern wrote:
> > > > On 12/17/21 1:08 AM, Parav Pandit wrote:
> > > > > @@ -204,6 +217,8 @@ static void vdpa_opts_put(struct nlmsghdr
> > > > > *nlh,
> > > struct vdpa *vdpa)
> > > > >  	if (opts->present & VDPA_OPT_VDEV_MAC)
> > > > >  		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> > > > >  			     sizeof(opts->mac), opts->mac);
> > > > > +	if (opts->present & VDPA_OPT_VDEV_MTU)
> > > > > +		mnl_attr_put_u16(nlh,
> VDPA_ATTR_DEV_NET_CFG_MTU,
> > > opts->mtu);
> > > >
> > > > Why limit the MTU to a u16? Eric for example is working on "Big TCP=
"
> > > > where IPv6 can work with Jumbograms where mtu can be > 64k.
> > > >
> > > > https://datatracker.ietf.org/doc/html/rfc2675
> > >
> > > Well it's 16 bit at the virtio level, though we can extend that of
> > > course. Making it match for now removes need for validation.
> > > --
> > As Michael mentioned virtio specification limits the mtu to 64k-1. Henc=
e 16-
> bit.
> > First we need to update the virtio spec to support > 64K mtu.
> > However, when/if (I don't know when) that happens, we need to make this
> also u32.
> > So may be we can make it u32 now, but still restrict the mtu value to 6=
4k-1 in
> kernel, until the spec is updated.
> >
> > Let me know, if you think that's future proofing is better, I first nee=
d to
> update the kernel to take nla u32.
> >
> > > MST
>=20
> After consideration, this future proofing seems like a good thing to have=
.
Ok. I will first get kernel change merged, after which will send v3 for ipr=
oute2.
