Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49838487D67
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiAGUAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:00:48 -0500
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:49505
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231377AbiAGUAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 15:00:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYBfA3asAzsEf/QqFpA4zVRIMaeczs5Xs9zb1K1aLnzpatrs7wTcCAs1/wzaeIbIfMAMBNq6fg3GzR8qPXt9Sri7Em3AhTkGFV5HthLEdi9VBVxAzwLX0qkff8KN8Osv82qCk7RifkDGFEOPUk4+DSfqZ9Ww2Qkx0nno3Do65EmY2/EddfrY6DR9XDJI4ECwKIpUpng217QeKjxrBIFoMeQ1iiO117pv/rE3jFJ7zZzrgWVC/LXugYDv5+kk+I+eE5VmBL5L9lXVM4pvLXI6SYBfX6lyriBuQR0P8lBPK4E/hxG8njH/Wg4Q09/O+hTuQsjzQL4noitvvqYZsRrq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEM6ON+x3UXPraXdhJdFWTNXktIEeT5GpRApQP53msQ=;
 b=bbIBQVdvhAQRTZvsSH6kdvXt3hQTEYVKF1MpPe3QVfx6dLTtfuzrDt5ViSIZqo8rHFE2ZArRFq4H6sanQuyeST9rPRa0mKCh82uOcMyj/jB3qoOq9GHp+RlMwwUVY28Aldb0a+wZgpTWzgoZrmYWJyZ8eoEFBPPl/J40c59MisTxzrBSrmJcQkiP8xoBGp4tVNGM5i7GTqSJaRNYDn4hezqrhQeau+XlJX/4sMRvszyMec/rWyDHYV3zHKerPxZp6Cdtu86jUIPc8e6y/51TWwdVlfXCHJEMZK3fDQ24tNFr2vTu80V2B8jFRP17FuZvXjVFwowAUrm7GDQhUyApSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEM6ON+x3UXPraXdhJdFWTNXktIEeT5GpRApQP53msQ=;
 b=GwWKbwQ1TG8mF9eW8brKEAbJZWkOlFtNRGNbGCntKcuFGKVYGig4jth31RyC3eSmTXfciKgbFNWFu6w8OcSO5LQCLkaz/vAhgSjQJc8JqZL7afqhr16zMbYVCsabSIrcCUPPTxf8vMhIEg1/imER6D0jjPxytjFYIkqiWyCBQcE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 7 Jan
 2022 20:00:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 20:00:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
Thread-Topic: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
Thread-Index: AQHYA/c3wLyWioQ84EWx8jVIHIIpGqxX8/qAgAADLgCAAANpAA==
Date:   Fri, 7 Jan 2022 20:00:43 +0000
Message-ID: <20220107200042.ee3ceehrio2k3dui@skbuf>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-2-vladimir.oltean@nxp.com> <YdiWYydfY8flreN4@lunn.ch>
 <abc74eaa-dd76-a022-d09d-3845e7e9c7d2@gmail.com>
In-Reply-To: <abc74eaa-dd76-a022-d09d-3845e7e9c7d2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9912707c-e8be-4d3c-16e6-08d9d21862fb
x-ms-traffictypediagnostic: VI1PR0402MB3549:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB354958AB13832AA5376CDAC5E04D9@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wsI5EdF3EZ70bTEWrY3YMh1nwEejT4eQc93n48bua7nzPEIouFdl1SSS6t8thSw8O9lXvr5PBDSKmpEWoiTt7eyEhWJhdbw70KigW1jYj71zr9Bepb+M+G8CxgL8efKyUwWnEBsVpIpU9dappFfYmQgFoNXkt37BLtnhx2KhQxmVKpIzRPtXaxAeOfv7He7rVsKXcOjkqIF5+paP6q3jSmquNH8L2lgVOMIsvpvHHz9kgXWSSM2YDUgwVM1GmBEA1zmcg6prENZWSfzvQhUJWvtdT4qZQxuW18FUHpvi1Hsy10UvIN9Mw+tmYI8ayoNMY2+sEESAewyrEVnCU9KC7PXyRxzAa92rxx1hGThgTsx2c3u/qPR+yjxc2yQ7/vy8ti2uosAT8CYlnEhP47iqhxU38jG8selE7jNv0VTi8uLlZMDAo4Lh0bXTXG6IcgF562KK73NKFAYN0ZmAhZpGW+pf444yOwODhHI/jEply1wQILLIWfSup0+eO7hQZ6lMJarw8ciZSx9ZBK5Xqmg3CNuPIvemMsrDx35YY4rnAzfwRh+dCAyJWZVpbqcHU26+CbYB9bTcC6ELnhHHK9mcmKq7MleHTQq9DReMDgpVg2T+U/xvzrR6ErWK60bTJWMI9eqASncRZHTX8T/iJkV7mahZYkzkE9+G3qzC05qjJE7pbkXIaiqWoLr/HKYs9fgaprcx1c0UjLrTjML9DAHbaNDmIQr+I4AnPRv51jIhzoegVdZqdz1WF8Xy9NrngEcoHFsGrm6FuTE5mmnMXOQ/BH8Xf/oRIjj8VQuerh0qaa8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(6486002)(8676002)(38070700005)(122000001)(53546011)(6506007)(9686003)(6512007)(38100700002)(5660300002)(86362001)(83380400001)(508600001)(26005)(8936002)(66946007)(76116006)(316002)(54906003)(4744005)(186003)(1076003)(966005)(110136005)(71200400001)(33716001)(4326008)(66446008)(64756008)(66556008)(66476007)(91956017)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UnclZ36SuWi/c9JGa0ujbQBSA7MbMalbZZHQr6vND47/YsUdDf4G7KcA9Di4?=
 =?us-ascii?Q?BlqthuYvayWqJUv1AYjYu+cazwVzUM+m3DXsJBbMyA8Q/Zuxs7oQHQNa1KEW?=
 =?us-ascii?Q?jQZjz1VUNf/GEcPbcG+WFfjL5Wm8VCz8aIjZIWEH6tWMJM1YthAXg/zlTid3?=
 =?us-ascii?Q?GXHkA9u6ZmQ6zmlAQkylZKFInRP6vxezz76e7WSvGYUTLY4awUPgKMlwx4vb?=
 =?us-ascii?Q?riSDkwhSnwwdZUcXRKG99rqtgXS0IlcHhfOXJ/cfwqIvQeQzNv+6gHFbPZBH?=
 =?us-ascii?Q?nxkZAiToSxOtvmhs2bUmRi2wcThPEWrd8691CKM6pNrAtb2z2KjnUrB4X9nI?=
 =?us-ascii?Q?lnuQldkTXq3G1UnsOMkETaAbIlzooodPzr75VuVBmwfBVNs5OJSxF0CvGqNK?=
 =?us-ascii?Q?w2TpOM/FaFikj0fabVsuXOuwecEDf9bCF6x3uENPA/sF7Cvjx6UpWSm8DByu?=
 =?us-ascii?Q?4szKFfb83affkhORH/9lHdgihjosxLFNoBaIjw0poMzLFyA6BP8UQypCTUQ+?=
 =?us-ascii?Q?jFTl8tFWEif/OVrlueGWDbY/GuxI/ute8iLnevXLe2IJ9tlRHr/YEX/Xjxx/?=
 =?us-ascii?Q?4Cq/nlvFIwxeU47A915kCcnXcT/rzoE+oXKFyPikhepL5jkSJ6F+hon+8Mox?=
 =?us-ascii?Q?3bI0JaE2gtSYZi2eLc1rrk4Uz5MNZugHmpjnZPvt2SevYJZ6JH/2WMFxk57Y?=
 =?us-ascii?Q?mY30LgZsxVLfVIjIbzfBC8yjEynz831fy1dNJn7s+/rDa2PSDWXMdqiaji9n?=
 =?us-ascii?Q?zFWr0mZ1zeLwyT08tqByMmA0RwdkbSd3btUVbhlzAFIUCIpASMPwSqvVA1P5?=
 =?us-ascii?Q?WNMTDSBoEPjyBYhiGMlyLMgKC8Z9Qn/4osuRse5BeqPGYAAyJwlD4StCVX4N?=
 =?us-ascii?Q?9efePfyS0I15pPEavLIkMuX2+XPXa9EBKpSnCuO7Z8l6QCSBO/SgCQ1gMNp/?=
 =?us-ascii?Q?3Kxgii7H6hTOjs1sGur4R1yDZC5TatRI5ozUA1oNjiKbE0xPTqkhLi83BVDB?=
 =?us-ascii?Q?FvkvPjjCrHRUndSUUDL/XnEyB8/gSgwJ6fPs5y58ZSGxjJcVUhluNvBPhR3g?=
 =?us-ascii?Q?o1rdTq23K2FDOfOrLb6k+Vqum8MttQ0JDVMecr0KPyh77cZxHpCWB26c1w+0?=
 =?us-ascii?Q?G+T/bcSVmQFn7THLXUYq2VSka8s7HgvXinZIp1zHk8a19LJ5x1nW/0ngEnBa?=
 =?us-ascii?Q?KAfBlVL5hx0YPlwyfDUHwYh8pBKEtCbDAfhXs0q5kBUvPCE3CAlfmj3Nc/VM?=
 =?us-ascii?Q?7/fQyFVN+ZQWxttJhJZhjTquTVEadiggy8G7nYVy8CQ2yXUeGjWrA/iTTrA7?=
 =?us-ascii?Q?VbgqauVqm+unuGA0B1flBwtbbpJLxuJ6z8dagIhZdsYoq/zDK1LI5en+fl1t?=
 =?us-ascii?Q?nYFmsITa5vVnlOsUaWDaO6qX7ELzaHf4+ywul7+RgJibQIkA3xRj27zf89Gj?=
 =?us-ascii?Q?Oy85YMe22MRtgFTJmhsvEoEAs6jKBgDVFTapccnNYNnKPOUDoebDcqgs7AOu?=
 =?us-ascii?Q?+qgD/D/32dV/88OyNHOC/LP3wmxGnnlVNm6IK93vrZinNYGr6AY0NueMBgSq?=
 =?us-ascii?Q?6K96VfguNMAht0+bS6+ffA/sUoVio//l9L9SHAU5KvsGar8vwoEjIrkikoO5?=
 =?us-ascii?Q?48ENuHeDm3tykmXPIaNVoEU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF54DEF4A4803C47A887C9DB26A8673F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9912707c-e8be-4d3c-16e6-08d9d21862fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 20:00:43.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qpjY3BON8prZzSp2wHsCxIYVl22YgGsbSJifERrR14v7MhSt2rfNrFlR0TCFutyhA0GOY9g4uGMZp5F5YOg8Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 11:48:30AM -0800, Florian Fainelli wrote:
> On 1/7/22 11:37 AM, Andrew Lunn wrote:
> > On Fri, Jan 07, 2022 at 08:48:41PM +0200, Vladimir Oltean wrote:
> >> There are no legacy ports, DSA registers a devlink instance with ports
> >> unconditionally for all switch drivers. Therefore, delete the old-styl=
e
> >> ndo operations used for determining bridge forwarding domains.
> >>
> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > Hi Vladimir
> >=20
> > Maybe ask Ido or Jiri to review this? But none of the Mellanox drivers
> > use use these ndo's, suggesting it is correct.
>=20
> I confirmed that /sys/class/net/*/phys_port_name continues to work
> before and after this patch, so:
>=20
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Hi Jiri, Ido, could you please take a look? Patch content got cut, but
it's right here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220107184842.550334-=
2-vladimir.oltean@nxp.com/=
