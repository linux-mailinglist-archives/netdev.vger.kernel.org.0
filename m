Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4A7442C45
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhKBLOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:14:37 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:47531
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhKBLOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 07:14:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAXwdQeMpeByN3FKXkOa8zIc01U2S0olN/UQVGgjNZb60jVeSrsqA4ipEOF6r2XTHwVlZlcao2H0sxDKSYP5TZeh8tiiqCRjTCAH5NYDrC5Xuajnc9kHw0QmV8gb4UAROfp+iCem285d7a1/HwrtJugekDi++x7Zb68w7Kyc9ajeCUk3t6le09kZSrBU/5nt2xb/OZcmLkGgtUMEABIeHOJZAc0R9PA8+nwdk+7h49wdk1RZqbSB60R7Zhx4HUJ0tSWyWo9TTUxdPhKC9JotvzG6EWvaCJDzwBvBL+ZUOITC6GZYqU42RYdhD1DVk10RRmbtUrraeKgdg0Qz04ld6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7d5kAV/y/yGuNkHjIneDi0qWo6R/FOT9aa8gZmqmBk=;
 b=lbej/oWCwudAvt1eJ9L3eExhTKhempvV4YNRSK0M8ZteXToedajdI9tVtOcxPmp0QtAD4h+s5KiVpEskAs+4NKWA8itZBejGcKWz7vaMeipkTYLQIDH1cj4CdKZ+xPjIKfI2XDsO7hGjLvDdBZe9nvI7ggPunp2LQRoMYfTx0Lwq5pdt8+BqphSaufefPy+2Vo4b69ySGYB/LXD120VTo/7T6ZoQNHdKGfsM5givxsD+pV6/ZpUeNjfpFzI2gzM+HAazTHiv3AZNFhleD43VTqhrgPRgM2UjaXNI6uaGPhkDA6NvHUuQQ0uF4szuiyUZad7hklw9wvHdKSEVTc16fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7d5kAV/y/yGuNkHjIneDi0qWo6R/FOT9aa8gZmqmBk=;
 b=S97BgxBidDL7ii7I652wTbgJgaKOeC1+JJOMEAoeOumE7IYbCa54Fe2tkrb/d6Pxf2exPM70VDwZh3LEQbGPqbXmDnb95ZvsrIsKec53WXG6yY0M96OvppkV8+pvTf2C4lV3euvjclFX8REtIauLAV8lLcsSWGY4MgUE4zKOeX4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 11:12:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 11:12:00 +0000
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
Thread-Index: AQHXy06ynOa6d3fRmEa0KFrEH+B4EKvuzUaAgAFRBYA=
Date:   Tue, 2 Nov 2021 11:11:59 +0000
Message-ID: <20211102111159.f5rxiqxnramrnerh@skbuf>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho>
In-Reply-To: <YYACSc+qv2jMzg/B@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66b08cbd-e477-4acf-eab9-08d99df1974f
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-microsoft-antispam-prvs: <VI1PR04MB694131D740784595F2A5F705E08B9@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:628;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 67jFV2pSiDW8vk9+t/DVFINsQGb2xLE/2xceNP8VK5E12CoaZgPetkJ+9pPdyxkK42g0w6i/9fGcQk6r9obF4tZ42GCZv/+fyXbd8pxoF4lLlOBGNynjgcCm+wnclIu+XGmZOY4FIfeAnFn5JFG/TZNdNylxzqd2wU3aZrAXJBcbnUFUlebq2SnYkQgZMh1rWhaR9sQUTzxz35uOjv6J4XNmoetP4MOVZDEUphK4HLfIk/x5ZSsthzjml/fmPbtwjhHAr9dawBemagcTlzCsjHwFE8+y4YRkXyrv/vjZSMalT1L9TRpipAZxoFoCCfjSVlh4B2xcHf4seiLBpbzP+VOIbRgFbmMqO9Otp+YZhpHCRNU6EOlKvWW5aXgZ5xK3Zs4vvPF3y+/F2HnZAR3AJiTol4iH8KwjIkfEkPhcDetHmRMfu+leUOIGK8tR3/rTYHL3M20GB6SGMMntI2k9KZzq89vs1I51no/XUXySEAPm7e2UjpOsypkPJNw1QG7k+kfZL3XhANMIOvfIZ+cJWY4TufaH1xKA2Uw1XfSq4EaC6IPPCOcKYFhzXOrjAWbLCDrQOp9i3Bl3wREX5zdLd5KwV7zh/ktYE1ChI/23MS+7eLl2Ilm11TLLJ8FmNrJOYSniQIpTjkcGi//6GQNgWo9OMr5ORLfan+01VJbvRLsTzGFLsvFLqfitRND7Lc565eiDwnXQdT/IPEZBwk3f3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4326008)(6486002)(8936002)(54906003)(8676002)(122000001)(508600001)(76116006)(26005)(6916009)(186003)(83380400001)(66946007)(86362001)(91956017)(6512007)(66476007)(316002)(2906002)(64756008)(38100700002)(33716001)(6506007)(66446008)(5660300002)(9686003)(66556008)(4744005)(71200400001)(1076003)(38070700005)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eQmZC5VWkzsORhHJQgvOFoTkT5Zv4Jr444kNcdEFrBKg4XCQ888f649jHljy?=
 =?us-ascii?Q?A6csRfOfpl986xcNIiq7meuqa8PkQ+rrNUJTPzYKOF0tCOKfEgx7IUzsRwkd?=
 =?us-ascii?Q?CrOc0fa5Qcl+Xjywn9jrCCdQjQAeP7hqjEWUMbPkUKwP2uSvqcTI/5tme28P?=
 =?us-ascii?Q?U9nhC7oryhF/exE5iycl5Gm6RkBrpo9XifeWqSi/BEliJYlQKpjRJ85RUonZ?=
 =?us-ascii?Q?dkfwV16lY7RWOxFPBXIYjEr78Qfl5NagBCs0a3bsJtVE/P2TRRCK9EshyJ8q?=
 =?us-ascii?Q?pogzQZCiyJeVBMd4+/EBCnRU8eGUYMmmE214HNDha9SLWWyykfA1KN/32bXd?=
 =?us-ascii?Q?WC9t2Cb7x481mK924TvdAJpfoIqrDVu6u0ElFVR+STaxm/f0VA/eTsCh+ytg?=
 =?us-ascii?Q?JC3daED4IE7/x9E1B+gLreXEmRnvRE2bysp7DcEn/iiu0uKAkNNnCCFL4gm2?=
 =?us-ascii?Q?88gigMxIZr+LkCKSkrh5hy+hETNZrVmcVDxhP9EKYpYa3ySJA1289IoX+MSK?=
 =?us-ascii?Q?dbfT+6ItFWfZFi8m5UrAkYbF7f8XsymmHd/ehTuXcSDdIf0P1r+nYcoJ12zj?=
 =?us-ascii?Q?3+o6ZtGLE3C7XtVapMCNZp2QPD4gTYqtfFpx3f7Y7z6t33RzNhn+vOiKbpvI?=
 =?us-ascii?Q?vnx9lrCPcrzuWvf7G16aIEeu3tM0MCjR2zik9m4M7L7m9lUn7TVK7PF6kmbQ?=
 =?us-ascii?Q?FHqyYUjSoysI2rUPhVkEiOZrwQPVj7PBpxSePJGdfU34UQrl1V2Dikl1zpLT?=
 =?us-ascii?Q?QHoxqjzr50j/MuP5jK0YD1x2Lc0TKoDwHDCF8a042JuuS0WT/6zX4qaeDLEl?=
 =?us-ascii?Q?waMfJyRbrdwLtYRPL4b9wsvAeJjLeoi5BAwmb885X06tLjyCF1zdEFw+8nPN?=
 =?us-ascii?Q?Gl6/ILd/jrnXJ8GMreeMG/DN3ZZMPDhMbUc8M9zgsYzCCK9c7fa4a/OGz7ng?=
 =?us-ascii?Q?MDFbPXH+esMhELskidLAjlceCfOyUIalBuxkgLst6ybSjvogTlIjDgz4SpxG?=
 =?us-ascii?Q?LFdKaMJ/PFzxaCtwoGDpZfrWKjDQooXIg3eIkEGgqa/UMHXah9D9enlSXDsq?=
 =?us-ascii?Q?VKkdYljH+0J0457OjtZb9iiMPaVlznecFQJPKpVU5cU0ZYmLEXJeKm9pRSJy?=
 =?us-ascii?Q?7vCkfdT7NF2Dq/qcdLMX25VNxFCc7ckI1dqRJCyKoIbGREnR/JPw7hc7FXeW?=
 =?us-ascii?Q?hykZOV0AcpwXzKb1YzVed0UXLiVIvZMsz3uph7H33JDxvsIgWpHP83QB0sOi?=
 =?us-ascii?Q?/pS3U+EhuaY8gXIwnNWuz6bYuTC8p2RChO3dYRLwUjCnqpkuCipNALySMYxt?=
 =?us-ascii?Q?LKdk1v+7OLRVgTFklS3kEmipwRa2kATKZXOBPwt7ObCGGPy/iBIOxTnDKv1+?=
 =?us-ascii?Q?7A0xT7wF4AnnlvBU1jwRNfog1B2W2RtKhNOqSxrJX/uVtM+aE89XREzf3JC4?=
 =?us-ascii?Q?YQZ8hDdkxvKW8YXXUVnDnYHvWXZZgA7/5Y9KBSQGfT85+PohP1lofquj3q2W?=
 =?us-ascii?Q?SzbZyawwzjx3ZNMijPNQTAw41i3XVp7TC65XF1NOn0Lt3v2wFH6FPmtEfBka?=
 =?us-ascii?Q?XnGydKr/I+yHpOAWGHqNiHDFwCzl4Bq5mgZLAohuLnWuqqX7a2DD4ffEam8t?=
 =?us-ascii?Q?9P2oezglZQeEGvFl18oMTpA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2168BDE4880CF746AE53774AB4B912AA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b08cbd-e477-4acf-eab9-08d99df1974f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 11:11:59.9762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: loKx3LLvy3slm3i4PDqYE+4DGwc2lMDLHb1NAsXAgbn/ecUwD+s+dDmkJKUApfUaLiwPXAqh3auJwgfs3mcSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
> >This is one more refactoring patch set for the Linux bridge, where more
> >logic that is specific to switchdev is moved into br_switchdev.c, which
> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
>=20
> Looks good.
>=20
> While you are at it, don't you plan to also move switchdev.c into
> br_switchdev.c and eventually rename to br_offload.c ?
>=20
> Switchdev is about bridge offloading only anyway.

You mean I should effectively make switchdev part of the bridge?
See commit 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload}
loosely coupled with the bridge").=
