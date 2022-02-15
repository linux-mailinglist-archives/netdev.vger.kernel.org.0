Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ADB4B72B9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbiBOPoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:44:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240943AbiBOPnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:43:55 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20081.outbound.protection.outlook.com [40.107.2.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F8CE1B59
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:38:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJt++L5yyHRk7KP+MMXdorDEs5bYiVuDoZm4RrkCQoG5EY/EPMM91dqPYrQejHKSNKRJLka/PKFGf5mBll+dNRVGUpqVH5rwmXFYnQfADRKrU1SQW0dU7pSOw1Hxxm/49wOtXPgwGIWY3TEovwCYIZCM/Z7AwAJ2aQFQb58fzXG7IfVmT/Xy+m1z64ty83IGrfgKQ9kIw3wUtSjUcAveWC6DrIY/jXwbaGpmux1n3JAF47PTjCwz+6+5f81iE7mF6+OXIZfJc2+UsJd9PMq/huZKAg+vu7xSapyT/VWlyniMwCtT54cLykJNiD/tR+KjAY6pan6n9Mog8yFoCITi7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrosWMznxqf74IqPaEvBXeoxhKx+h56bPNeMOVMWXIk=;
 b=nZMl0y+ROmboh5SQ3j3VpGM/Se5TKOkGOZQC4YFZQuIiXruFBepwaEopqyh9hr4dmFeHRcqT60gMTwzNR4cQEstLEpQ+6hDlPlRBVWqmySEoO0bAHlOq4kntBE+GdeCMHVdm8usqoj4UdNXnMRwqhnDvfomXWyHJ9QP99OTpTjhb4K++KEHXHwoWClRoSVFPkrycDDrmfxLNZKNTeqsktP88fkcD5aQxVdQpxQSiL09iWNnTFCquqiT3X+FngcUnrCij25fD5rvOMF8Uv3cnTTxfqf1kwzEQbSurcsp/reJyyFZzkl2q+K6WnJcMxsNCNJw58UpA3oOHMK2j60hDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrosWMznxqf74IqPaEvBXeoxhKx+h56bPNeMOVMWXIk=;
 b=eS6BALAfWqQ9Ea5lJ2LDd9x88aY9WBsr1Q0nPWtUDaCWi35YsA9CPwNhQrvXJRugUTT+EpOAPiXjrnOBIuVMw+KC6GPIj7Uya5VSdOqYVx3DWV8y3iGxjAhrPjg9iOOf/affnZIM18T01X/Wd8VBTopMvoqGaKdzOirq4pLwR3c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 15:38:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 15:38:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4CAAAUOgIAABQWAgAAKo4CAAEtkgA==
Date:   Tue, 15 Feb 2022 15:38:04 +0000
Message-ID: <20220215153803.hlibqjxa4b5x2kup@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
 <20220215103009.fcw4wjnpbxx5tybj@skbuf>
 <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
In-Reply-To: <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19f87a4a-f1d6-4d6f-4920-08d9f0992817
x-ms-traffictypediagnostic: VI1PR04MB3070:EE_
x-microsoft-antispam-prvs: <VI1PR04MB3070B0CD83176123A08519E7E0349@VI1PR04MB3070.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGZt4sfMM0z8K63r+mYs35PQh2FBKwBAgcq+QOjMwt7+FNzrugVvKA2JOYbvOS6dofD5026IyN9vsBE6Vv/lnuDvCUiPdR2JL1fvLvHOscHUHXlKHg9xkMsyZ8X2pV+T3JHFJVHjrOCyve8gx/rKGRYoA56lWDi4CsIFmV0qxkYRNBceXmN89wufaVIJF/SLSZ74M2m/E2ZavSoRfqnOpBPI3Q2RohJFoqUIpk/1cjM19wrr6fLi5cCacY775pC8wBv2sYe+LBKNTZ4SNoABoFuuUv3nrx9fAQYmuKfpOKtCp7B4HU4wUdeTjWDZMgqrxr4Kur+QmZdrvaSX66nBekZfX+97RPT6xca5fg700bqZmGtEbG6ynZTf2qDpzyJDUuCUl3JocNqMOH+7QuMCBC5iDcewA6fc78miMO8IMMqfikzzz6/CyDCctSDY2eQ59i6VVHtKhqnH7W2vG5pMXHcFjsHiG2s7tL942pNKQu2wozpOcwFL3E61Pbr3Q2dVPdDc/AUuBclW/uqqxGJGLnuoPqkoqvD2EW1O7ZPNEMdNqcs/q+iWBYZoznkbQtYrnwOt1eep92br/WclHvFCK5fmmyKWkMNddKwu79L1edsXPklfEG2645I+XzmGBCB9mEs2bF2tPSIQfb39wWpaWByhz/KGNXE7zUtWssCrlsmJK8knAF4DTk7u2y94aRG8e1Bev36Ipna8vWqPKO6UZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(316002)(8676002)(6916009)(86362001)(33716001)(1076003)(66946007)(4326008)(6506007)(6512007)(122000001)(38100700002)(9686003)(64756008)(66556008)(66476007)(66446008)(76116006)(186003)(26005)(54906003)(6486002)(83380400001)(508600001)(44832011)(38070700005)(2906002)(8936002)(5660300002)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RDEvkgg7wFesBi9TFqOe7om7vdJEZ3AWK5VDL1ucTw1nccWgcXUF0D/FJB7f?=
 =?us-ascii?Q?ZyPMwfL456WbmHmtXe+bBvcCucQ+epFAdHjvWFULRYC0YFuy1zb+ED9iL7Jp?=
 =?us-ascii?Q?gaFL/rSUBF9PLtWXMbGi7ri/Z0PVZz8zKXvweA8dJUcASuZKYVfd5rIw7gF+?=
 =?us-ascii?Q?E+7/CmXbttbybLUoyeXOT9NzIuG2nvOm3/XSUktD8Kl1rmdea086NmvC4rqp?=
 =?us-ascii?Q?w4K2YSm/fN8hVVk5ICpt17cmUY2ZoZ+67CYdKDK+yGo11eXuxo87imNM38h5?=
 =?us-ascii?Q?fa1rZWCJi8keaqKyFOXSnkJO7lY1AZk2Z0OcsPu57G/xlAmPH+yj4CErTwkw?=
 =?us-ascii?Q?uknZ17c0C9BWCMTsSXaQNhn0v09bDmaCxid0+Wbhvxw2zWEWBm9aX2zzi9Bm?=
 =?us-ascii?Q?d2deUh8RrwxD1O4hd2wZLuJ+xxjzdVV3DY780g43kftYunVURKal3lIi/TRQ?=
 =?us-ascii?Q?/fd90tOBSqUQ0AblXVvOqEjQ9KAXLVGPD4aCbLOCm6ANR0KFW+lM3mC3lI9S?=
 =?us-ascii?Q?jLsK/oIt0NX9R6qCbUgZB+0Wq1hKVxAQUgSLMm/a6D6X41aX1QJjvmBNDHSg?=
 =?us-ascii?Q?JuX2MX36bLHYsh1W1lZLeLkgEEod/tFAFx8eXlBYQUhkBOo59m2DkC8xi7Bs?=
 =?us-ascii?Q?5N81u6+7Lqmt/Tp5wujM8niqeA01gGI9raq0Q9NUPhUmm1VuSiPERSYbD7E5?=
 =?us-ascii?Q?FZwECahGr1U6g7wgTpM+LE8eXi+c9U1kZF2LJAYSN7aBmeaQgivdBJxuccdr?=
 =?us-ascii?Q?PtQKj/CaoprmexOeoNw60lalwPNv8x5Kqu0NkShTe8skVuKrQAWgNr+gJ7Eg?=
 =?us-ascii?Q?Sg9sJpVq/B3rhPNUwqfBqwwg63bHkG0sfdyjV547zKLFJaJVxUNStvh88H/g?=
 =?us-ascii?Q?F7mytuhW49RvIF2r1NIfIjECWfT5q3guznt/NS2+LxxjYKYPzXg4syEWyF1Y?=
 =?us-ascii?Q?NY2Sr4fcsnYDObrequwJG6esfJc7yW/GwzODzTim9z4Ka6BcynRGvhFy4fyz?=
 =?us-ascii?Q?kXAhWMnY2TVIsuBgFbJLB7GViLMHjTv3chos4XIpIcAzBi2fFCVZMvNfeHdv?=
 =?us-ascii?Q?t22etoPEZusd4JQ7oqYXaeFpwz/WirqTYmepGn3H90TPjAzCpdJqnPqtBm7h?=
 =?us-ascii?Q?ZPJAAdeTqSCEwMu+Gm9LPDmf7A4CFaDqQ+oUKCelXUupBINfSZ3ogshxzSdq?=
 =?us-ascii?Q?7FFii0mdQXPXc84dRKw8gb93qCYk8/Jv6Pur+lcm1AZKTDh5dpk+nBHuvi/L?=
 =?us-ascii?Q?KxM5BGX4K1l7k4HHSjvJkJ5BhpIWWQpeDLTEMuZayI8QadsKOZgiy6C3/uyk?=
 =?us-ascii?Q?JOtiIcF66TUdhc4TnSdpL+I3ABHGRjrUIU4ek8341tO8EmIAsHQqiw+Ikwt+?=
 =?us-ascii?Q?D0fT/8xjQZxHJW7KpNTx2x7cDr3Kjrw5g9IJ9h0utqphMN6Bvu8apRHf/BzF?=
 =?us-ascii?Q?LST9Ut406t/IkC73SpCsahq/K3TIXEh1PZMRBrWOOfIzQeE78Mc6Gc5hGkIv?=
 =?us-ascii?Q?AkNbOi+wiUxSLLNshMtk5b0kxuzGJYBr8AGK5Z/WGkDcCd14bCtwEiTZZKYo?=
 =?us-ascii?Q?FC6xLnYRixPVpVcD7qfsBSd+02Ly/satcnwHnZu/LLEjifpmTQfPYMgRyQgS?=
 =?us-ascii?Q?uf6pjgwL+EhNO3mjdqjo7fb5VA9ZwzIlPKYAqjX0bGN7?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7314E84D6F3D247A2AAA36FA64F0008@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f87a4a-f1d6-4d6f-4920-08d9f0992817
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 15:38:04.2444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7P/1InXJE5K4NBGcQYlJb+flzOZrzpOn6xJNO7QjjmbLfsSb9/RqD5LCPnwHDho01E+m7R4lcie0RQHX6ZzMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Tue, Feb 15, 2022 at 01:08:13PM +0200, Nikolay Aleksandrov wrote:
> +static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags, bool =
commit)
>  {
>         struct net_bridge_vlan_group *vg;
> -       u16 old_flags =3D v->flags;
> -       bool ret;
> +       bool change;
> =20
>         if (br_vlan_is_master(v))
>                 vg =3D br_vlan_group(v->br);
>         else
>                 vg =3D nbp_vlan_group(v->port);
> =20
> +       /* check if anything would be changed on commit */
> +       change =3D (!!(flags & BRIDGE_VLAN_INFO_PVID) =3D=3D !!(vg->pvid =
!=3D v->vid) ||
> +                 ((flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED));
> +
> +       if (!commit)
> +               goto out;
> +
>         if (flags & BRIDGE_VLAN_INFO_PVID)
> -               ret =3D __vlan_add_pvid(vg, v);
> +               __vlan_add_pvid(vg, v);
>         else
> -               ret =3D __vlan_delete_pvid(vg, v->vid);
> +               __vlan_delete_pvid(vg, v->vid);
> =20
>         if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>                 v->flags |=3D BRIDGE_VLAN_INFO_UNTAGGED;
>         else
>                 v->flags &=3D ~BRIDGE_VLAN_INFO_UNTAGGED;
> =20
> -       return ret || !!(old_flags ^ v->flags);
> +out:
> +       return change;
> +}

I'm really sorry that I keep insisting, but could you please clarify
something for me.

Here you change the behavior of __vlan_add_flags(): yes, it only changes
BRIDGE_VLAN_INFO_UNTAGGED and BRIDGE_VLAN_INFO_PVID, but it used to
return true if other flags changed as well, like BRIDGE_VLAN_INFO_BRENTRY.
Now it does not, since you've explicitly made it so, and for good
reason: make the function do what it says on the box.

However, this forces me to add extra logic in br_vlan_add_existing()
such that a transition of master vlan flags from !BRENTRY -> BRENTRY is
still notified to switchdev.

Which begs the question, why exactly do we even bother to notify to
switchdev master VLANs that aren't brentries?! All drivers that I could
find just ignore VLANs that aren't brentries.

I can suppress the switchdev notification of these private bridge data
structures like this, and nothing else seems to be affected:

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6fc2e366f13a..4607689c4e6a 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -300,10 +300,12 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 =
flags,
 		}
 		br_multicast_port_ctx_init(p, v, &v->port_mcast_ctx);
 	} else {
-		err =3D br_switchdev_port_vlan_add(dev, v->vid, flags, false, 0,
-						 extack);
-		if (err && err !=3D -EOPNOTSUPP)
-			goto out;
+		if (br_vlan_should_use(v)) {
+			err =3D br_switchdev_port_vlan_add(dev, v->vid, flags,
+							 false, 0, extack);
+			if (err && err !=3D -EOPNOTSUPP)
+				goto out;
+		}
 		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
 		v->priv_flags |=3D BR_VLFLAG_GLOBAL_MCAST_ENABLED;
 	}

Would you mind if I added an extra patch that also does this (it would
also remove the need for this check in drivers, plus it would change the
definition of "changed" to something IMO more reasonable, i.e. a master
VLAN that isn't brentry doesn't really exist, so even though the
!BRENTRY->BRENTRY is a flag change, it isn't a change of a switchdev
VLAN object that anybody offloads), or is there some reason I'm missing?=
