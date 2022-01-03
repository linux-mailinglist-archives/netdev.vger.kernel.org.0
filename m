Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424EE483466
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiACPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:47:01 -0500
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:21703
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230160AbiACPrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 10:47:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFG7oqAbvPI5xleru1A9a4HvaVmGWzjLJ6TwGdTxmONJTp1rWUl0PgtL2C+8m0cX+MtAztNEWa8QZZ37cyZUaHMjrVVWuQuCCz9Zngo0bLXZaa6CP2G127BGibe7qQaMOttcy4mpJO8VFaWtCjl3rjGEYjxxWn37Pqh7E9X4Mej5J0dCKcx8RA8rj8T3TIe5NcR5a273UaxbLw0s69lxS4PoaN/mar+jLJC885vbK7sTeLGdMRM+YjGXgLn73JWJt4FucnNCXvDYaEGfUTd2pKsyWG4HWaiKfrXOHh14DUxzA9Et7NpBksIPhoHUUwzkaUvarM8lGxDEobvLjfln1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTpL5srFrM15X5S6Bn9wNdFyWmyz+ATgOVHTYp0o640=;
 b=e2QHFfky9wqlV+7DpqwccyjN7JnO+RFlJss8C0p7Yo7VXMiOkZRj+davhurpvV/iKkB3n6bsQzRcySjHXYLoMs+v/kpkbt3baWfDGQixoHAZihS4L+IgPGZFv9VRd/I6fOD5RUPaeXx8Ojljibf1gy+x08ZG7ABE9oqr/Epe5LYmn6wmfS+lsuTKNlrBVPHeUPfVx85o8FoYRnox23X/Bic1jIn5EV5u4PwFNZROQyX3P9Nv6MUv5dDD30Srtev0+2hSW8vsNYk+H7y7Qtk3+6B/obZairAYRoxa6wFujBew/+NTY9rU2WOugIy3iKQoOrEtok+PmXzZypoNiCSeSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTpL5srFrM15X5S6Bn9wNdFyWmyz+ATgOVHTYp0o640=;
 b=N3bSuH1lavAc0t1IhBuALHp8g+8DxPBcRV0XnGjx05z1iMGDaPNPEvYdbu0WWk4lSe9WMfm5XmZAy1x0MgCsMOEgaxMGPMEilcd006pFsvu4LIuZ7QQ/RwP2aJsrNK2PAjtwB16Efk/bTsjlg7PF8pI2AUGqO4s+sbYXtKT1Imo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 15:46:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 15:46:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/3] net: lan966x: Add function
 lan966x_mac_cpu_copy()
Thread-Topic: [PATCH net-next 1/3] net: lan966x: Add function
 lan966x_mac_cpu_copy()
Thread-Index: AQHYAKMIDc/8QMjaPk+JwRMQCQIKvKxRWuoAgAAT6QCAAAIsAA==
Date:   Mon, 3 Jan 2022 15:46:57 +0000
Message-ID: <20220103154656.4irkytj6dpxne2py@skbuf>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
 <20220103131039.3473876-2-horatiu.vultur@microchip.com>
 <20220103142754.vtotw3clkwdrvcrd@skbuf>
 <20220103153910.pntxvz7qjaodd6s3@soft-dev3-1.localhost>
In-Reply-To: <20220103153910.pntxvz7qjaodd6s3@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ad0dfcd-7b0a-456b-ad59-08d9ced04610
x-ms-traffictypediagnostic: VI1PR0402MB3615:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3615955CD70FE1C0B8FE50A7E0499@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKPUo0rDJAgRgfr1ece6vpFcsQe+RQUkFlOpRxTz7qwltxkTXw/imimVvzkQuI53MbNq9v2d4HzBv0OZ0Tuylqr5i5vn0sPDGQVQyKx6oMIKf9J2Cb/BCX+0wH8dt2gk07UjSGvqqgXM9BPTIhGPfI2EHcELRkAmnJCOmGY3sx9IgJ1+hQAu7uhZ826/imBlira3RAj7PZB8D5oThpj5g0BTpkOg8kRs1zYCPeCr85PO6jEVXXxDikerb3QiRWrvL7StBzzHm+Wkh88helo3Ej7otVoknUypsI1S2BG2UzKXqyO5evge1etWC4x2evAiiPSKwCRKIC1N4wkuHLHDLpBai9d/6v7hIa6Y6u/nOiKNsKf6/SHj12lfvTcty6DkEkbGCuMU7M0n6agtgyW/v1AZUjXdoi1ZR9DrEdta0tsz2oG9N61IOpLkGgss6nP6i3SjFcKzWB9Oth4yENXoKSXImlLTMWMG91icsUWysVRrBxAGwpwTRwpgDJgw/Jb0a9spxhcXcJyEiRDDhm0vrNePFUtX+T9lcyLB+pQUhK1r0z5YOhHS42o6JM+el+lqOCVBj0dDlk8EmBn7biPpH0tHi4sSvnasNy/qY0Sz9ih8CvdP8TIkfgvLLGrFJbOSy5ZB4KZf0gZRjxmqzwd1Lh5wb+qcrjohw51/o5L71Kx2jLJPm1Es12viA/Mc71NNMa3o6NYyfrLSd8XdCnAs/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(83380400001)(8676002)(6512007)(26005)(33716001)(9686003)(8936002)(122000001)(71200400001)(6486002)(4326008)(5660300002)(186003)(6916009)(38070700005)(76116006)(66476007)(44832011)(64756008)(2906002)(91956017)(66946007)(508600001)(66446008)(66556008)(316002)(38100700002)(86362001)(54906003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mFJu5pgp+r3rJYZ4KvQACttKSizh9Is92Ci+HOYOHsSEpZuhirEpCw8P+uHG?=
 =?us-ascii?Q?lOZ6WGcvmFhwa19Na6Cl1C28iKkTRa+Pwpii70RRucQ3cBwMArAk+Ac3Bimx?=
 =?us-ascii?Q?ADiHOiQkqQnZ+RqWiJ3RqgXvn/fGEtSrmVWD4sxB5ljbp7Mg5qD9prix1O99?=
 =?us-ascii?Q?zUzhwQhI98bz0oFAuxY7V0/fcEEFt56jjsZ7tlsO4jQp8LaNEse8NFz/tFgm?=
 =?us-ascii?Q?a94pztzcrhxkDmElUshsWz3XPJUBdNemVdb8xlUG3DJ/zgraLjTzpbo+QwC0?=
 =?us-ascii?Q?/54GRXvw8KVMcepn9Qjqi3IEefz2z87h93Xob7I5PN62alefjT/JUu//56/B?=
 =?us-ascii?Q?1neveRXmrt2Rrdi6iUcBVR7YgIHacttObWR5V8or2NncDzRPmjo2Xlebuk+1?=
 =?us-ascii?Q?fh01HxYgywue9vs7U0eMw0kGmlJxTNJVbnZmy3xSJzQK/Zyf8Kx5dfLEXyjm?=
 =?us-ascii?Q?QBBVDfK3xpFu9o3DWH+N0L1oKyhEAFaszjpZVHbXQQOhKo3NLcqNfYoLspU2?=
 =?us-ascii?Q?+u+4cHhGx8DmPqw+DrHj/LshWE/SOG8LnxriaXX90SZDo+PiHKXeWOgYxcEq?=
 =?us-ascii?Q?9P6T8JcB8JTYTo9ch6Y/jJ0BTvLOn3Wuq1CtbVDzwWLT4WXS2YNPYkdWeFyg?=
 =?us-ascii?Q?O53d6VJ5Tn9GT+6IXJSDZgEGTelrCIGjCtwyiPBv7WHVV8AWmRK6NzNbrFz7?=
 =?us-ascii?Q?MaqDh/GfC+la2kWItfHPcbAPcdndANrBoJP5SCkio/vXqu1qZVh/0c8gvs43?=
 =?us-ascii?Q?18cJhOsYEvMOUk+CzzSzAM/MuurR6NHBNXeVgIO356M37y3BhWfd9YfKIIG6?=
 =?us-ascii?Q?sYLofmR3P5RGuOsTLIT246kH0+0ANygVKggbwXgCBZscV7sbTfuVX5BlxvC0?=
 =?us-ascii?Q?600irBfYAn9lKLtzF2LZqhJaUmsUBAYBObgAjY5taWy4aI16coPYUYeU2xzl?=
 =?us-ascii?Q?BWbrdIrpTePp6Mfp6ciWc86EubNA9Tuf/nZ0UZotDEQkW90/VMplAikWqZkz?=
 =?us-ascii?Q?r6WJQdva5kpPWasqMdfzNYzc1Bfty/aC0onr2B5Kr29IXXe/20EwYk7xoXbo?=
 =?us-ascii?Q?RcIXs8E5j38WkHIYFpKHe5QonR9q+A92nQdkUQLKRgeqbnxalHSzda0iPZEZ?=
 =?us-ascii?Q?GCrPLDdCd+RgOwz5AO0VWoCGgZD5Y8ny3DDpG+ZJ62qOYLFDLgn/4JwLl/WG?=
 =?us-ascii?Q?FUMgRLrbRvgfcBZYeXKCK3x1IJ6p/rgkjyT6A6FFSktwpH3+EZF05jhhm25E?=
 =?us-ascii?Q?jBodxMazIE2h7NFyyt6jIf3ma2s3XZue06VU/CtKK8pdQc8ZDZQJGk/XEzxH?=
 =?us-ascii?Q?NSUCqLcUGSjhua3Ihngj6qmOKkK13y2PyvNEPXKBhBjpXbU+tdWZEjnGZ70x?=
 =?us-ascii?Q?42bdkE0WuFoSP6JS7ZmsuRizfBQ8aRKAt8I/6jlbhDjO9r5ZYqcYW3dmy+DH?=
 =?us-ascii?Q?rFZ60OXH1LcKET84BXOocqy++cOgesK6tlnOdAFLO34NPGT72DZU376N2SDC?=
 =?us-ascii?Q?WnS750MrUwU0CexqBSFwScWYRDammpzqNNd8H9JU9hafsL86rIqNv7T4Ih8d?=
 =?us-ascii?Q?sFb9+iINbmrqxiW/YxLpIb3gXxq3KQmSOFEAaKHSpCGnNLK/SlVic8KiCBG/?=
 =?us-ascii?Q?Wuj659yKSm0AVgIGWKRVlT0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1887D2BFE49279439480D1588D562A23@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad0dfcd-7b0a-456b-ad59-08d9ced04610
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 15:46:57.3028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecJCS4cjuKLJjSR/ogmpNTxr7bttM8j0xmZfAAgVlkUuxSsdsRScJCMMGJvhkAU1pBt5Sr6Jw46jhLZybunJUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 04:39:10PM +0100, Horatiu Vultur wrote:
> > > +int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > > +                   const unsigned char mac[ETH_ALEN],
> > > +                   unsigned int vid,
> > > +                   enum macaccess_entry_type type)
> > > +{
> > > +     return lan966x_mac_learn_impl(lan966x, port, false, mac, vid, t=
ype);
> >=20
> > If you call lan966x_mac_cpu_copy() on an address and then
> > lan966x_mac_learn() on the same address but on an external port, how
> > does that work (why doesn't the "false" here overwrite the cpu_copy in
> > the previous command, breaking the copy-to-CPU feature)?
>=20
> Then you will overwrite the cpu_copy so the frames will not reach the
> CPU anymore.
> But you should not do that. The function lan966x_mac_cpu_copy() should be
> used for IPv4/IPv6 and lan966x_mac_learn() for the other types.
>=20
> Maybe the function lan966x_mac_cpu_copy() is too generic. It should be
> something like lan966x_mac_ipv4(), lan966x_mac_ipv6() and these functions
> will call __lan966x_mac_learn with the correct parameters. Also I can
> add a WARN_ON(...) inside lan966x_mac_learn not to be used with the
> IPv4/IPv6 types.

The intended usage pattern isn't clear at all in the current series.=
