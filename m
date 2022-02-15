Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEAA4B5EC8
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiBOAFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:05:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiBOAFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:05:46 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A82B7921C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:05:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcwnOWVaiECZvLpewNLjerQlrB7fpy8zpk2zpZ8H/ns5nxLzOoeKzPWcZxKoyCcNKQTz4zJFa3xonBWpaeED9hcevm5W4m6xgOS/EQz5wmebgbPBXLOyVMzmj3hkgioLPcvNMxWhw5t0hx1XkaSbMxfBQB9RDmkF9S5jVoXeTnctUkDS9uIp4p3DrgLs0sUUQ3CsMepWS9rhmqeeQDgur8FB9/y4H3zKnj4onqsmmiFTQnnQMUm/Wav5NkFYJww/JzyhdHceppGC3AmRfuRsU9tmW1FFUCy8goruHbtjt+uSLhZCI13ksCi+/r1w5+sqsPZ0RPKalFJ4eT2aOF+JDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pynQI2c5qGpIhMX6Eg3jGR8nWl/9wPxekv4wejVQojU=;
 b=oLdPIiOK7t58h28p8sdkSu0VGw2Ba6uew1m9KhFS4n4nu0FOPvenCdk9+0x5tWQGDceVkzBiMDhCU641J9Phf1D/h0wlkPT6IX/MuzrzzTlBY9QvX4r9fjrGYuyjI9R3s9FF+Gusf2CQh6do7aGuQrvheew71PqU6ilcPLu8NHOS6K/oOeqwuXDoYspLHD+UBloGdp4XATeH8Oj444rDsVy2m2cAygBzkehiQ7v587nimduZEWmMd85jTXmVPCCiWqWXA02hb4ktk3DOntaGuroOSS3Ki7/aDVD+f34AXSPGkKzhDbDOjCVGsWODB5Gf94/TeO8SbZEAYwkr+ZhGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pynQI2c5qGpIhMX6Eg3jGR8nWl/9wPxekv4wejVQojU=;
 b=kL763pM5azzLCPtPS4fosJF9+gajDo0rXIdsbBBfHOhkfyZICG3H+Ketus+PHPowVBAIj7OumFVHTP+085rNWDMkR8Qt+u0TUnVPjoYEQ/cpYZBh3ZynFeBal97Ie0QC4GAeW+7fXDOZTZ8mQELMpsCItTKuNCb8wmuZPCPHcMY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8288.eurprd04.prod.outlook.com (2603:10a6:102:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 00:05:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 00:05:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yTu4sA
Date:   Tue, 15 Feb 2022 00:05:35 +0000
Message-ID: <20220215000534.y6lhn2uvdtepx2v3@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220214233111.1586715-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5371566-e0f0-4fb8-371e-08d9f016e3fb
x-ms-traffictypediagnostic: PAXPR04MB8288:EE_
x-microsoft-antispam-prvs: <PAXPR04MB8288D03991A27DC08FC900E1E0349@PAXPR04MB8288.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qogpw3REYa25wYDttiR2iiW80XmVQNLVvc+MPL7QP0qQUv1rz7YojV7UH2kUY5ErItX71n8AjXYylMHf/c7hTvUADrtzIqeKbsgyf7YVHFniiCngWaN8fpHnniUNi+u0/AbGbA11cEuWwfAUPDT7WtmKcXFIjxP8o+GWoJ63hVluHEsjcK29YmKL8ymC2UDgmF/nVz4BI0iyqj14cK46hO0HsedGmejZHi1IyeyUTIrSo/kPuDsmv4CsQnxTIHb1rpN8z4gacvosjHa6Wiy07GpO+0PZOFgeLJYBy9E2oqVhRUJwcrv8C7YdgxKlPREFRMSQ3/e3QqHpWIDHfbZK9c+t5aYKsvD4Pckt/mTpS7PAQOrDhF78NFMURUgBP/vM2CesqDHQmk3nKk4ta0SoEUqB3C+3XLuSPjnYYqVo7KR5zrPEApvYq9RaMpH6mJ42kTp6LVPQJtjhhNZhBvY9xi3zhTtKWAlw3PRIteZUXEXVUcaX5elYPKbPNYzrGU+K0PoRdtLkWseJBaZR5UInEzp9IErlnVSlSDXlR2sMllg/yC7bYJdysrrZVGdE1m/Rtwv15ZjqvmM3AJ/1F/LL3m+5Eu1w4aoTn2+Tk/62cx4aPHYGxL7IdKxsmDcqeRXCOrgJadCrzPE7J5G9e0jPsdWysP/Bpo/TMcucPzSLCF2xAKq7ezgoZl8qGivqgSYLTINuT9wDmLt/iCZ4lZyE4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6512007)(316002)(38070700005)(66556008)(66446008)(64756008)(91956017)(6916009)(54906003)(33716001)(66476007)(5660300002)(2906002)(4744005)(7416002)(66946007)(38100700002)(6506007)(26005)(1076003)(44832011)(8936002)(186003)(86362001)(6486002)(122000001)(8676002)(9686003)(4326008)(71200400001)(76116006)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a1FbiC0je4Ss6wfX9Pt7FhtZVtgSHgZ/3X3ajKAyjs2iNB9BXRoxTBlctekE?=
 =?us-ascii?Q?02NU0T4XvXxJNd9hMgQ+LBo/YxcqmESYYc8xXR4ksn0nTs64rsWtZokhJZbq?=
 =?us-ascii?Q?CyuDp6jTDVQ6mbvb6kZJvexV3E8hflguYuTD0+aVHwYCPz+fo6IX6Loz3KG/?=
 =?us-ascii?Q?KY22LsSVyjdYTLbN4Y6ekLyb+usKNxaExRTfW2z4C062M78MVOx9BNo5tRH/?=
 =?us-ascii?Q?43DP+uYKdNi7kffiK2TS253HWdQ2dhHR06Viwg5tf8x7qci8EDY7W8jF1E3K?=
 =?us-ascii?Q?D8qJKaUDBbCHiM6bSqs448OjCcHz++vM5ouslHLxaxt4DgaI9kMRG4UpOx2V?=
 =?us-ascii?Q?jVZYGat47ff0AgbLKK/X7Wh53Se6uMaQZ1kiw7bSsSWbB9eCtQpOERGT2d9O?=
 =?us-ascii?Q?xtQQlOVU06wm/EO6BGSsnveMdTv/WJeP3HMBPP3Y4VsbI61x/Q1QwHLBVNAN?=
 =?us-ascii?Q?ifdkvycuBbohfxj8+Blp51hSPqJjEK3WG8jup3L87v+UJa0BP1BUfyGNU7SB?=
 =?us-ascii?Q?V5nWh1qeJ7e5lMPdK3KC9o625+f5U3Pmiwwh4NlITYfvdgi2kA+PMYndF1gK?=
 =?us-ascii?Q?3qYXRmF6VpeLhbJWryyvF0XLKlb8o3CPhkNFbJB++FFJLv7Iw6yGkkw0WsAq?=
 =?us-ascii?Q?w2cPXVlRMSurtIOmpM3IBEV4PdU/dRghhGbFmeA8bEwwvMhyGD8jPb2iaDxp?=
 =?us-ascii?Q?RzDST8Ov4Us10R6yc/MKxqre9BCfZdhkXxmCxzpcYttwBca47bvvXGBvg30o?=
 =?us-ascii?Q?nSnW8oQE7diMBjXrCoeME7cib5M9df6nLDk4dKVuKlKqPBw42MjbSLFBZ71i?=
 =?us-ascii?Q?qXkwvU/sfr8FnO7UGO4Mv8Nx+Al4RPAlZhoUo1DO9qVSiTXRxVlDb86KlRJw?=
 =?us-ascii?Q?2ZKGYhpimM2m/pz1WaByRVvfwwS95OOhucCXNTfT4Zr4hXzxG+yLXptGStHk?=
 =?us-ascii?Q?1d2il00Unlt1OUI467fqKBovfq+PfsYV/tQed6Dc5OhNJRSqMkLmuT1z+Yfg?=
 =?us-ascii?Q?EDBs/+bwP6Crj67WvnGOCsR7l4kXAs9b94F8D6WirLtcXdBBtE9DPf6qBbWT?=
 =?us-ascii?Q?c1x4YlP9I40BOcbXX0MciqGmwhzG9dVMcE/56nR0B+qxZCLw6ppZd2ZnqAKC?=
 =?us-ascii?Q?NP4Y9WVOBhYL5jMEsgKDPc7P54GLT8h/kekR0VyDJ2VTJFODKJXF8tyzHlW3?=
 =?us-ascii?Q?BT0jKqwMKxjoKPxeEbmGJEo61Y72wmHSt/KZH2l3rBiNawgM6pmqcIQsoMhy?=
 =?us-ascii?Q?2dCF4WXJfN4OJsyHDapJHJFscV3SsJtp6WbjrdvJ7nVdjKCppBR9uQTnGuHd?=
 =?us-ascii?Q?gyIsCqv51yLsylS+Bmtd33NkPebsBt1pdcr7QynfsYvJtjEEjjOSTMZjaI7s?=
 =?us-ascii?Q?oqL9c2lnZuyZePvx77BDiu/Nx3i91vtpX0vSQo1F0o5qraG+Yfn2AWCXUk3M?=
 =?us-ascii?Q?s+cAny4ff8ew2WEZV5d3ERI4cLRZdnT230HJTbBTuQ2Tns+QeMPbYVE0cJka?=
 =?us-ascii?Q?6KiLLVLKq160PfS7ETcudl53eLpsWfe0bp4u5cKUHqxO4Z5ukqljf+rkc3d3?=
 =?us-ascii?Q?NIKc8OWsSQCMDzWpn665UbpwHQka6LZMg4AYWa0ycFnmftcsBxQZANaLuGNd?=
 =?us-ascii?Q?Qs8N1LlA/yg1Pr7fyOd0YsU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <84537482B0AC9C4CA6D2309A2E410F7F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5371566-e0f0-4fb8-371e-08d9f016e3fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 00:05:35.3380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mn3FscekJhcfO8wUyCu0HPYleKUKJNH5ER+Za4NwzHAw2r7iPXnJcCZLmF29h16N8OVd9ffyh0uGY5nSglAN9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8288
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 01:31:04AM +0200, Vladimir Oltean wrote:
> +/* return true if anything will change as a result of __vlan_add_flags,
> + * false otherwise
> + */
> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 fla=
gs)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	u16 old_flags =3D v->flags;
> +	bool pvid_changed;
> =20
> -	return ret || !!(old_flags ^ v->flags);
> +	if (br_vlan_is_master(v))
> +		vg =3D br_vlan_group(v->br);
> +	else
> +		vg =3D nbp_vlan_group(v->port);
> +
> +	if (flags & BRIDGE_VLAN_INFO_PVID)
> +		pvid_changed =3D (vg->pvid =3D=3D v->vid);
> +	else
> +		pvid_changed =3D (vg->pvid !=3D v->vid);

Yikes, I was planning to fix this but I forgot. The conditions are in
reverse, it should be:

	if (flags & BRIDGE_VLAN_INFO_PVID)
		pvid_changed =3D (vg->pvid !=3D v->vid);
	else
		pvid_changed =3D (vg->pvid =3D=3D v->vid);

> +
> +	return pvid_changed || !!(old_flags ^ v->flags);
>  }=
