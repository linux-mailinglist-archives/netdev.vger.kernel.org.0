Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73701442D61
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBMEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:04:46 -0400
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:21216
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229720AbhKBMEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 08:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dq6XP6L/0nxsF49sJCBAoYc7CFgpug5v+sBIGFkUJndSxXHEwTrlaAzInP8wYQjtIfFJw6F1xOgqI4Ag4lw4Jb8qvfreCpHTeXxWuk1wtxoZbaFUGTZiBh5MTK6jJgvli971jrgBiXrc9kYskHiY0RCGGDbvs6/WftOTzPxgTiDwngW2D5ebqq9FM/MXdNesQCEIoUqLWpG32QdJrvC+a8GUVSMiCPH/mFq3LZzx1hXFw/nY7AZwph2RskOBaWytyl0r3bCP9W9MHo/Ri0UN56b468sGcdNc/LVEGBzTW1BF5Id0jKXHtA2I2AsAnABvKuLuNfOEwpo33Ev+XlHIuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNwsbo1KDxN7PB8e/U7dfkpUkQJW3KZw5v/KCQw9ve0=;
 b=cvS25fuEbJCA5BVOOUkG2uKT/H/RwzRyUFptVlwjUy6OhwT/XNuvQJ251gBCd+Ak7NLpOkpcXfAXoZT6LH39vLZI5drLH25fisPtacZFwVDwZ+lA6E5l2UiH7F4hB6TQAOyE+08pgNvNa0mAemSL7zzqOuWC9bAXwc9rBiINgB6GZw7szQACvXSGk7L57Chsp/UE3YiOMWm8vhSj1b+oRKXrDIuwan/oxGM3IOTI426FiLG3XWPtKQw5zYqFH7yq6AZg8OfCrgo1CsydS7s5fViNDrYywEgdN1NdltRDmOLuv0DlvrFwdP0UjE6mbSrjDGapXGfJ20YVAa80hcqbng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNwsbo1KDxN7PB8e/U7dfkpUkQJW3KZw5v/KCQw9ve0=;
 b=jfvzhnACLGAbWyHueKzXmLnn7rvBnZz34rnrvuspsg8UC47IVOLAx2pcHkchKamqKlHEwEFdgmDDRqrKUmyqP8BWzXTNZMa3MxwRIqNmNn6GWwaIurqAw2uHniw104CLeBsRyCS2edst6KkBNhbm4IQOzQ6Q6Tz/uAoa2ojWXmY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Tue, 2 Nov
 2021 12:02:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 12:02:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Thread-Topic: [PATCH net-next 0/5] Code movement to br_switchdev.c
Thread-Index: AQHXy06ynOa6d3fRmEa0KFrEH+B4EKvuzUaAgAFRBYCAAAqWgIAAA2oA
Date:   Tue, 2 Nov 2021 12:02:06 +0000
Message-ID: <20211102120206.ak2j7dnhx6clvd46@skbuf>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho> <20211102111159.f5rxiqxnramrnerh@skbuf>
 <YYEl4QS6iYSJtzJP@nanopsycho>
In-Reply-To: <YYEl4QS6iYSJtzJP@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 596d664f-94a6-4000-8a85-08d99df8979b
x-ms-traffictypediagnostic: VI1PR04MB6014:
x-microsoft-antispam-prvs: <VI1PR04MB6014D2190E3310690D1A1A06E08B9@VI1PR04MB6014.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TEILL5lISoVgbSMS/noT8wpdZPqYFqH/4OqFoQpZW7QAT8JWinZc59RezWFf7udIJyLCjI1/NrR2MB0L8HNhkxGGPVzDQMNnPivgps0DUYI9qF5K4pcIgG9eY+gxJ6Vb/BcpKJf5O1n8hY4VF9zuTUh92D05vIrKIrJV5DfSYojtmspgEZglPquR1rMlszU931qY11O+2aR7LRUT/aHYCbrdTlQ3SE1PrGfAgGxC+kL/Ef3sStGwroRGfayJS2Olo6faaLFteOiud88KI54G7TNVicp+0usLs7DnrdbJHWszggUI1QghJQxCcbt4WRUNxiAL7T3iL6LdAJWybOtopQcYxisy7cuJvKZclr+0o2jsV7oZM3KP/+W6mBl6VvB1tOitUOpI3dxJZUP62XLMiN6/TSMEzpH3YotRXVl3nlhVXYy+DJO4BNXAX1m8WQvD6n7CSpHV+1r7iwwoEaSDT+p9nJgtF/NfpUNSXwBLJpJPESEp8M/sBdszuYWWOjy/bPkWkYcgvu3QEiUVv1YJkFeEhrQ7afn/ycAG4e47VfxYQnYadamghtLJOsMXRlhgiI/jJ3xYzI0nwoEY19i5VNNH8vpG9CNvOuL0FDWjkOtwZFiWZMTTrEoxkaE6zcNyccNg0VJQSDz60BqhZ7pQ7me+bC0XVQuXJ9B1VIg0cC/HFYuzOKJ9BfD3LaHt1hJegMzDqrEl/ERCM/OAI2cRdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(83380400001)(508600001)(8936002)(6916009)(6486002)(76116006)(8676002)(66946007)(91956017)(66476007)(26005)(66446008)(5660300002)(44832011)(2906002)(66556008)(122000001)(186003)(38070700005)(9686003)(6512007)(4326008)(1076003)(33716001)(86362001)(64756008)(71200400001)(54906003)(38100700002)(316002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1z3Nm2vWpQX9ScQ3KBCciPkOWPvaY9eAvJ1lxXiBXwGug5Dk9BSq2Av6nBsK?=
 =?us-ascii?Q?ymzPn7iVygJFqYgihw32mXfFbqApOm03OZzslirz/nHBThd22g40X0bS/FXo?=
 =?us-ascii?Q?ME6L52I4in3XDNuTfcpciSnLaCylf7qoiD+UqZm0lO/6hEIQ5VMzC8ux1lGn?=
 =?us-ascii?Q?Z9ECcjoAMCd167abmFl0icnlOqoxLJwK5WyetmbS/R03RxpVqG7bHYGdVkE5?=
 =?us-ascii?Q?06TwZI8iTX4HnFpDwOfAbLJR07KnOnO9lFWyU93+v776FCo4jTdDFcguKrRe?=
 =?us-ascii?Q?MaclPyvSUt8OjblROBvfHbO3o7rt1eHSO099PWGmT79cADWQANohuRWdYsQE?=
 =?us-ascii?Q?JHu7p41ncxeWJDlhXPfA3nT7PE+WIo4YASEOAwtqA3hbuR/Rp9a5+h3RSJU6?=
 =?us-ascii?Q?XqoZYjcoTO7qb+seYmlAcXVRdrHQraaU7OZglgvy+jyEXtf+Z1n3vCWx9ITm?=
 =?us-ascii?Q?GfSGyA6qR9N6QRPrqFpMRYwOS3uSjdgp1EN/1tbFQpTXQrtf5WggTUl+DBnB?=
 =?us-ascii?Q?1HXb3yVM9Ww6LVmv4fx9XSiX68VYHtaiwy3R7EOpRKFQ+yhyp8nrEpQsevzN?=
 =?us-ascii?Q?YfTkeOWG2oW63NgEXS8WsRmfnwD7N0eE0iRTkyJM8KHr7ATDeXIUSlQdf0Bi?=
 =?us-ascii?Q?2W2c9lEFYzsxOElXXqqqY2En3hbOXH5P/a4hiw5KFuV58RohcFIKGN6HGx9E?=
 =?us-ascii?Q?mBE8vfg554gkQA3EvcaXVKX3O7bVTRCuQAEMUosQwQgxbnjDWPVraP4Ot4o7?=
 =?us-ascii?Q?c6+OMO+IvNh01vCh9+cv11sHekEdNZef9I1vMuVlMDgs9Pb9lXCi0/Dtxj2t?=
 =?us-ascii?Q?MWIWhuwYXVvQnK+MEQkESt2kY5fIDexJjfoAf6ihb0rkRioJKyhCTU9YMYqT?=
 =?us-ascii?Q?DIsxeurLTox9wEfhhARWkI5/YCwJ4BsIofMDFUrh6GcXU2nlWecVLJLpXRbL?=
 =?us-ascii?Q?TbJEb8XSc2LOheFltAY+xMIGzKA04rvzTUt2MdWYmW4itws7G0ISgW9guBWz?=
 =?us-ascii?Q?zL+Dp+WRnsv8sTKyK43pcqpKVibmpkHZuW8681NJl61FGpVG0SD6LT4iMLcW?=
 =?us-ascii?Q?Ay6o3h51skvIN2NHDmuww3lXs6p/gIWk0EUjdwfJXRAKjStGwF0bzwXfKTav?=
 =?us-ascii?Q?6Ou361+JiaNH8mxhJVMXIYK3fzKW1aC+hVZBSu5+uXyx4Lj+kqTk4S0ISg2z?=
 =?us-ascii?Q?DWKGIlTvqlm7Fmj/pfpN9TfAgjNHiBpaBGLuHYKTDPFFtpWxLIzSO2u5W53+?=
 =?us-ascii?Q?t4rnT5h0WR0PH/GZRVAbLWCwvX4TvS5A3gJwokIHzIyZc1iG0D4hXs2SFPqr?=
 =?us-ascii?Q?f5mEFAXoKSNVgvjs5FCHnTC7zjXlOCDOhk2qm99K39TBv4mu75HS6uLYCFy6?=
 =?us-ascii?Q?F5GoLPYIjHQBt4tFnt8Z3hlgNON1a/kKg0eQwHHLsPtcPf9LjkaGUVTfNW76?=
 =?us-ascii?Q?PA9aKJ/+5Y0RqtgfbqBAJmdWwjgxObDgYRJExxmgZ9mAcBdeqwx1QagMxc02?=
 =?us-ascii?Q?Eaiwten0OdQUjTzqo/Y6+DuqhR+TqRtfe2B8KvbcSBpy2mNGxuO/4bG8XN7K?=
 =?us-ascii?Q?yphscnVpItDB5Fx+5SxdZg7Pw66F1DUmVbwR6QZDNWOYP70cEJAtcVTKBijX?=
 =?us-ascii?Q?Xe4izeVCyY8CrGp3z7rGYDo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C69A8E0E158A946B0DA5B436DFE1D1B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 596d664f-94a6-4000-8a85-08d99df8979b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 12:02:06.9310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABXeUMrO8Sw4sGc/0mvMx8fGdFINWHukN5ypo0LjIPztPF0GtQKaIN8aylxpFc5wC2DqyHkPvl/Zdc4U5hPeiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 12:49:53PM +0100, Jiri Pirko wrote:
> Tue, Nov 02, 2021 at 12:11:59PM CET, vladimir.oltean@nxp.com wrote:
> >On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
> >> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
> >> >This is one more refactoring patch set for the Linux bridge, where mo=
re
> >> >logic that is specific to switchdev is moved into br_switchdev.c, whi=
ch
> >> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
> >>=20
> >> Looks good.
> >>=20
> >> While you are at it, don't you plan to also move switchdev.c into
> >> br_switchdev.c and eventually rename to br_offload.c ?
> >>=20
> >> Switchdev is about bridge offloading only anyway.
> >
> >You mean I should effectively make switchdev part of the bridge?
>=20
> Yes.

Ok, have you actually seen the commit message linked below? Basically it
says that there are drivers that depend on switchdev.c being this
neutral third party, forwarding events on notifier chains back and forth
between the bridge and the drivers. If we make switchdev.c part of the
bridge, then drivers can no longer be compiled without bridge support.
Currently br_switchdev.c is compiled as follows:

bridge-$(CONFIG_NET_SWITCHDEV) +=3D br_switchdev.o

whereas switchdev.c is compiled as follows:

obj-y +=3D switchdev.o

So to rephrase the question: unless you're suggesting that I should
build br_switchdev.o as part of obj-$(CONFIG_NET_SWITCHDEV) instead of
bridge-$(CONFIG_NET_SWITCHDEV), then what do we do with the drivers that
assume that the switchdev functions they call into are present when the
bridge is not compiled, or is compiled as module?

> >See commit 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload}
> >loosely coupled with the bridge").=
