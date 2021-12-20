Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAC647A3FC
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 04:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhLTDtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 22:49:23 -0500
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:28640
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237307AbhLTDtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 22:49:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTX0nmAsbDLiopQvKvLwU/tWEoEvM6r4TcsNkibH084GE9kDqsuAou154qO6vDYSQgXRoTAH5iaE666Ll+V9VFjU8v/tbYJ3lzX+BRBzq2F+BxvHoYVHGLXnYWiAyiuir88RSbSDY0OIRjyoZ7saYvoLkK5VOes1SUcopibnHdp25c3maOOo8q4BdDh/LnBtdZ16+zrvK0sI6abGC9bxz7tjaV2ssJDRcRR3e7L6fh3f1H6CRF66Bf4DvPsb0FbR6peqi1QK4Pl0UJof3d+E+FKaAdYoU4MKCd1Wscn+WkBF7c8k4ND3tDSLsyUbz/z3uHmTVyFcworqZg/kXRQvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNxP1Pncs+2VfAiQF4dVZfRojBKpHYXCh7zBp0lEMfE=;
 b=Iivifkxbk7gY0kf54FGod9pfDArJwHa1Islaa7SgusIqVT1ovNWk9wozPl3EmGYg6AZizkxFkIvM5oM7c8UleNazfrUKd6LHN4gWPTcdnfy/BOJGqWVx0DjnM9Ia1oPXdcKLkTSEpnY54lEoUhHnIm6CfinfKrlPWfIX/rQrsQjQMl7LsbsqeDrBYByevGw0F1c2ggCEGacPfBYFT9RBl8O68OtRqbk8JuaBv/gsW4Pn30VjqhCc6KNxLh7kC9lp5k0AMkaUKb3DKKA0UEbrmL1qI9Z2Z+afJWRL2K+g79DSgBJArnQ1RiL+SRkQGZmaZMb6dYJVBSQqESsOMsWPEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNxP1Pncs+2VfAiQF4dVZfRojBKpHYXCh7zBp0lEMfE=;
 b=pAfcksp2Jmz7Oi+OfiTEbgEgdg9Ia60C2xCMrVzZS4KpwQPTVSS7qxCOpTuK8eqX66Gnl6uBvD2g0JtJ4Siv8F/d/keDRhQsb9hAxLNcJOmm/59tCsyZsvq9WiLIDrDG2pwC0sUEyvkmQUZrt5AcbajvaDSYjJq9rKEscgJ5+mxcLmrv5Qs6OA7dFOAWAgAmKzvTyAvPzMSaF8lV3vhLKXeihCZRFJSFQje5b9+vMHaZuvLvBTA2JBigLERp1EmzenyLzsBIgRYcwijUNNqaJZIZiVQHM5ktpV9ge8nS5fWuVIJ6/9PRoys8RmYC5mI0yVeTmO5VEpCfA0ToWTFnyg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5468.namprd12.prod.outlook.com (2603:10b6:510:ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 03:49:21 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1864:e95:83e:588c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1864:e95:83e:588c%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 03:49:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dsahern@gmail.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Thread-Topic: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Thread-Index: AQHX8x1X9Wn4iy01GUen8mUL9hh9r6w4vEKAgAAUvoCAAfAdkA==
Date:   Mon, 20 Dec 2021 03:49:21 +0000
Message-ID: <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
 <20211218170602-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211218170602-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f8304b7-087e-4a7d-719f-08d9c36bb51a
x-ms-traffictypediagnostic: PH0PR12MB5468:EE_
x-microsoft-antispam-prvs: <PH0PR12MB5468B9AACD800758774CAADADC7B9@PH0PR12MB5468.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OY5EslLr4zLlluJsw4p664TqG7jdOAQOfEzbHe+W2PeB6Iuk11Iqkksevlp6kt4FbqUKRZuUpj6hf4hL38ygkC8bjUMCWswFjtDnzYWfHD/3M7eOvJjxyjYsJBYS4JRVXgAdJVJA2CBrKJ8UsWEhEpQaulsiwbdwHRo00PeUxCTBaRLWmAlLftRVcdGmkvBzvO86xP68LL9F0LSUKKXkLcjcVb6MFVhIdNv3N9c7ejLQmyGibwxtwFAiiCtGj6TWmFu3pBDuI6Q8p7d6YEWG9VF7mXPSWZTZUijRmF3rL7ZVN0HrlE7LZABJTjXlhOiy0HFcPZcLDtJRPw5KSZt8JtnqhuMc1H2ieOkxEdsJfcdfrn4VKqmJSx/GCnDNlKeYLCyK0oljdKxbKVP0fMc9wfYgyCJZB+mm1GhV9MmAzyXJSr4U53vZGWpw0KlBQCAadFhSKQxIy8oeW9Lm1ZH/fz3LGA28JuNloeZrHK21NnYhNErLHzwgKTJ/WQGRGHzinkd0Ifh1lz/VyelLx+f7nueo43Ur8agaefjksqKfSkFrxOMNAEZLXlYeeu9GvlYK4z5xuWi9QgEAtQBEcrY6IYbLEIf3DEH+q616xSu9T3u3iLAOp04sTlIes6WXe875aR+u1VAR8H2GZ7tzgLUSqPzcrd+BiDzVKibATGNH4tttB11yz1bwzdKBM3yBJYzClQ2kl8sDTYjMNbyom3Qbejhr6J2LJlYL28YluE4+pG10MCHyv2nc6O8xVXBfQIrO+nVpIs2LKqxl+WUW9DBWpOk7P9LWkmNm/Qf6gtmMmAU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(508600001)(76116006)(64756008)(5660300002)(8676002)(186003)(66446008)(66476007)(8936002)(66946007)(4326008)(26005)(86362001)(2906002)(38100700002)(38070700005)(122000001)(110136005)(52536014)(71200400001)(66556008)(55016003)(7696005)(6506007)(53546011)(33656002)(9686003)(83380400001)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6oRhETREryN9tIqbyTON50u2C9H5VsLnurtip6JN7pqTzm6TLaH3JvRJdy32?=
 =?us-ascii?Q?0rrKY3/Rie+OT6EEPYdldB1RYjnvGGDqObwApkSi/nSy6DyLmopr8M2+p+CK?=
 =?us-ascii?Q?9KmpOKqWhPfswnmUz/FeU2n7Zgj0IBCHHuuwbtXNVdyG0jzFvUBcwuKy23TN?=
 =?us-ascii?Q?AEr1r0gfjngeCxIR9EIbuWqXBnwLykez4ETw8UHaEW+UXMCPnFsBhcKs+rCa?=
 =?us-ascii?Q?jmNMRwDVNhrRHKOIafR1igNPUZ5iDFNRTrUEI+HspewBEOVS5S5XKqomYJ/Q?=
 =?us-ascii?Q?zsUw6uCN9TQyCwOvM46lsReo5AlJ6z1OTm9Hu6ZJjbM1BJLoqxVtKca+Ts49?=
 =?us-ascii?Q?cJ3Y/AiPGLVQRjwkI8X0urAU8Abw0UFecyo3f4LTEncE9CZOLIC6Q0iDfdTr?=
 =?us-ascii?Q?6EIIowb0gtXirVRYZuNAx7WTJz4TJvJwJN0QcN0Q1Vw6SN0pWwHhom16p4Z+?=
 =?us-ascii?Q?7Y5IhA4ipRcgNo5zapKAF2plnmebHU3SIIWcQbSa0Uy8n1qzlcmkwYMU59Ws?=
 =?us-ascii?Q?yHjr3FwP96m5rw7s9xI53xl5MJi1ahQN4U/7B/d4BTUWRS8wepDgBFuiRm1H?=
 =?us-ascii?Q?Ar7g/+rEEX5JHX4ipXniDSEMpWnYNt0KLrW2IdUeebsPUQ/GjNszt2nKrNnT?=
 =?us-ascii?Q?NxGjbHjRIxCNP4DxUMTDbBBcpsejyxtHMDvJYT6G0gDFwU1izipA86x/gN7B?=
 =?us-ascii?Q?JSwPccdxS32VjMH9S1pJAgbJxSx+BVa88glp/4A5OAG8hnkdhM9gRX8J2tYI?=
 =?us-ascii?Q?bW18smevVy+TWlSFDDkwAULg6JDWDlxx7GHoCOZ7SJBfVuglcKs5tkRFuJ4h?=
 =?us-ascii?Q?6+/WCPCz2wFmaO6xrMgqzNLGon7ScXTDdq+3fk4Ur9cV0SN2q3OuOBIB/0+X?=
 =?us-ascii?Q?uS0c7YBImWKZn1GEX+GIV043zFG1Qmko12JsnWiFddDhTCL/TwQdDYKPoHB/?=
 =?us-ascii?Q?OoJ42E+6Z1YXRuYeRRYrJFZY+DmBWPX2iHwa/QrNevx44lEUoq6HlYgSijpZ?=
 =?us-ascii?Q?7xOOgw5iVa0TQrK8XK1IYTrTHT2qaeaZ3MYWaxhuBYFnNCobDW5gf5cgrWLc?=
 =?us-ascii?Q?4ZH3DPbIjLylTvQSOyh5UEfBL9ffd0fF5YoAcagLeaEZcG4oA71wvFkU16Ur?=
 =?us-ascii?Q?QCCA4SIupMtcJkqi7wFfwNMfwdPmLuiZIXwEIi2Rs5Z7Ukb3hZIBz69EKIFO?=
 =?us-ascii?Q?qtWiex2s27Goc61MU0JfctUQfQKcCZyvxDMhD63gFJI5fWxdUsxla9DvtmcM?=
 =?us-ascii?Q?QxhvGkUG7Wps/GbqzhD2pagTZwEHxrnPzzEgWipLieBOEE75Ekz2r9mXM1Bz?=
 =?us-ascii?Q?gjPrJKbI6wKsi7askPDIC2w7SHklMcdEJKBZSpLTauAqfcI/6Qj1VPcyZzV+?=
 =?us-ascii?Q?aXFZjS39TBcaIkHQyBTJmnJKfz9KCDPGENPcNd5HcMc0iU8oIOuITcyivfdp?=
 =?us-ascii?Q?feUiMWmql/Z0Zyt9FbIDUQY7Gpqcg/YPC5lTpbqySvGl6d/WSuE1nInL+phv?=
 =?us-ascii?Q?6SXmfQpMu9jHW6kpMYpPQ0GDeiYT5+3RRcWLzWpjTDhI3m+hNPIwXsDsQaiV?=
 =?us-ascii?Q?R7L57ZFRnOV4srdmr+XCkft98pR3idrTcqyQcbGnNqbUpcJZm99ECxQbsf8T?=
 =?us-ascii?Q?bA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8304b7-087e-4a7d-719f-08d9c36bb51a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 03:49:21.6024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z8hf4XGUsYjWk64ZUI+Si1oO9thkerj7e2vUxbGwsXaX1NQaRTjFC3m6RRyr6pKTlRNIAqu6k6+7SZjF44Bc8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Sunday, December 19, 2021 3:37 AM
>=20
> On Sat, Dec 18, 2021 at 01:53:01PM -0700, David Ahern wrote:
> > On 12/17/21 1:08 AM, Parav Pandit wrote:
> > > @@ -204,6 +217,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh,
> struct vdpa *vdpa)
> > >  	if (opts->present & VDPA_OPT_VDEV_MAC)
> > >  		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> > >  			     sizeof(opts->mac), opts->mac);
> > > +	if (opts->present & VDPA_OPT_VDEV_MTU)
> > > +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU,
> opts->mtu);
> >
> > Why limit the MTU to a u16? Eric for example is working on "Big TCP"
> > where IPv6 can work with Jumbograms where mtu can be > 64k.
> >
> > https://datatracker.ietf.org/doc/html/rfc2675
>=20
> Well it's 16 bit at the virtio level, though we can extend that of course=
. Making
> it match for now removes need for validation.
> --
As Michael mentioned virtio specification limits the mtu to 64k-1. Hence 16=
-bit.
First we need to update the virtio spec to support > 64K mtu.
However, when/if (I don't know when) that happens, we need to make this als=
o u32.
So may be we can make it u32 now, but still restrict the mtu value to 64k-1=
 in kernel, until the spec is updated.

Let me know, if you think that's future proofing is better, I first need to=
 update the kernel to take nla u32.

> MST

