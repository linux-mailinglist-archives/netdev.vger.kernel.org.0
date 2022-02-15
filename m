Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F62D4B694D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiBOKaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiBOKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:30:23 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58472B183
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:30:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOpa6pKEkDrsG0PWnLVk9l7DP9LZlmMbtUuNDcBkP6LcT/kHtbbq8T/wjA+CZpzxLdj9QVDWKpelzr/naPCjaRhG7je3F+IP2ovLXMljy9hyoIQoWqw9xvAS091bjV9tfP+OTcQcnmNvEEyt/OmLA0THc43OxxHm32RcYhYvegD2BDqZTW/s6iDM+iLIXVMVyv5JPOSAPeE7duC5I01jxFAV+KNFWooyXNLVf80d9ZGv+5NIHXcj2X4DNk5fs1LwAalJf5p0QJIH6waY3sNt+maXfOqEC0eAUlPK2sxiw99QbmP3mlQ5+XYjhv80vkfV+OmAdlFaghR64C92kAM+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQjaxP00l1b1vCW7J2mybUp2ft9II24N6IA2tgQLlZw=;
 b=l3YMviD1bURPx0JZc9jRO6EMmQLaZP440wK9NkVHs5rMtR14MAcKqEFqKOoP62F9ATBNOhz8qNIkZxZHcsCtQ4sg0YxwHrdiIx/OglYWk5vqT/o3Ln/Oz22z4JMFQDNpQTi55ogZqu1R1smUdZM2S7fe/oLu1QZMYQ6N95f1hhnNeHDRy2jUnnNZidawT1r456BxzXxTPzPCqCULT42zPS7Phre7jxUBinVGUGUUGZ1JsHoKE35hPMU6LpeEqJ4IXTgWQP6ihxI7+2FpJ6NkbIZE017OPSoIekmewkSsoqesxexysrYR63OAGPz8GO3rNmjq3d5YEmTVkoLaKdb+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQjaxP00l1b1vCW7J2mybUp2ft9II24N6IA2tgQLlZw=;
 b=WQTo7zJgdVTj9BxTA+H69pAZykVnJwziiIC/0JhoVvnrdxLKjQCOG9sciEDclENIQBx8CTAwwnEThVcfxvSKwujZDl02LlVo1ynCS2tDoTP1XIMTcmZOW0Z7raXYaRb5Iq9a9FdqeOEF+tYQtL/i1YeUvlcJv6ksiPFoBM/Ugi8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0402MB2802.eurprd04.prod.outlook.com (2603:10a6:203:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 10:30:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 10:30:10 +0000
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
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4CAAAUOgIAABQWA
Date:   Tue, 15 Feb 2022 10:30:10 +0000
Message-ID: <20220215103009.fcw4wjnpbxx5tybj@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
In-Reply-To: <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98188831-21c6-4f7f-2441-08d9f06e24d2
x-ms-traffictypediagnostic: AM5PR0402MB2802:EE_
x-microsoft-antispam-prvs: <AM5PR0402MB2802A6D65BB16D6001A02556E0349@AM5PR0402MB2802.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3YwnLWXhkokSHZRyroRA/UsGgCGTImHVwUXdOM+Scoy1afzgVJAQhQ5Ma4//GqI12jjryE796blhYGIeRL+sVd661lX/B0ZO60ZELywoFnNWqqAcn6OuHHRC7ehwvqP/AEoWXMseSi6Ut5WKh2y0JB60sj2mtcEpAh5nqt3oEX6sXypRHyOtf8AGy8ZRhN25CgjMLzw7roEkQ+VyDMqxqAccagGvvOZqh9GFSWSIQ002+jD0snHEIiNZ4k/Byp5YJWjjXf00ZP2BhPGmUseHzgw3ulFmIOA7ir557LcO3SbkJ75m80kHBvX13oH6+Z/EUH6J28gnBokskkveL7uIzwnxRpatCBg77FQNMOM1DfvpAE9MBtBaJabgr6n0tV6hTfNOmadOjqI1lcwP0n1Tz/XhPywBiFVMSNjE56ORoAQwrfhNeH9GTf6wDCwB5T8Fym0fNtg+n/nIy11DJ9c9Q400nQBd2hCNJpcyqJZUIb16mz8K1MGb81LB3njKXXjKK8cwsowTdaskbs7ik1jde3CJ/xrkUavL/noLq2P65HebgYTJ7jLVrlcp+dgW+QJZ7Y8olboQ1Nl67006ib0ITmO94BSrkc8YdWGQnMwRgVJ1g19HZmGIMcmnGpBB8yvhsmQoOykAVrOytLFnjLOI95571fuRnPKJM6q20XFFEvx4rY4T53U7RvrZuKCktj3j9zt2Q5qB+jqhqnmkIvHcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(26005)(66446008)(66476007)(66556008)(64756008)(8676002)(33716001)(4326008)(6916009)(86362001)(54906003)(91956017)(71200400001)(1076003)(6486002)(316002)(122000001)(38070700005)(508600001)(9686003)(6512007)(53546011)(66946007)(8936002)(7416002)(76116006)(6506007)(83380400001)(2906002)(5660300002)(44832011)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cpx3eB+cQkdIw7Blan5i5K49kSgh5ul7ziyrsbUupbKebJaLeUtSauZpRrXm?=
 =?us-ascii?Q?lBQrdu41dPdq8L3aYqfwjCaaU58APZVD8uNPdL1N56JGUpN6CVingS5PZrMx?=
 =?us-ascii?Q?1+i4YcYJKHOdaWBCS5cnea9pRsS5GtumnfTwVn71rz4nXJ+JtbsJH/lbijAj?=
 =?us-ascii?Q?F2qqBdSwq8HqZfAthIAbIN3ayPOyf6WTu1vSWzp6os+cTNIR5baZr/0u314R?=
 =?us-ascii?Q?/ChIs88Wcxt+aUschHfGafBk55YyJiyig6OPLdjuN+/Wgm/hUQOYLOQIdxPg?=
 =?us-ascii?Q?B03TwB/SorKKZQZSH8HGqs/hDigv1kkewkX7BHd75wIHvISY3ASuTHmFhqe1?=
 =?us-ascii?Q?T6EWy/UuCb9iJ+TJy7b4yEcJI4wkEEgD4BMzj/YSjK/zlpK2ARtmuIa578Zp?=
 =?us-ascii?Q?8TUIvDNkXPtI/lx++qxwG/XXL5GffKRnEkVsuXsGsJuUpNkPY3hG8rOM0qOk?=
 =?us-ascii?Q?niQS75UZ9MRd44E7TDhqHgE86oVlmzNrD4odvP6jRHiRbel4MArhckCBZtjl?=
 =?us-ascii?Q?5KySWMIeMMbE746m8b4XZzGnjSWkyXipnJipOV+oeQxQubgq6oRdnmfTN2fR?=
 =?us-ascii?Q?Hf13dcP/2h20l3KRaWwRkaRN4a6nEfj4e1hYXsO3J/uXWIjr4Dy0M/NqKoE4?=
 =?us-ascii?Q?RFN7oL6jVE+ZARedofXs4JaCX2zoNo19+0wfXt9QH2XadAv9Cfa56aWuXfFN?=
 =?us-ascii?Q?B4gsFTFbTf7RIEdF6DTDByjpicsmbyTXuxvbeYRL7X8oOwCLBeiBZvDXlfwk?=
 =?us-ascii?Q?9zPMromCFEjIuYtBVefAHkj41kvEU3jN00cRBSgZsFR9+e8nhAIRXzQz4QpM?=
 =?us-ascii?Q?WveJuQN/SaTgcbzdh4FGbKT+NqlW3ehMps/F3FlKttveiQJRE59X6J81W6vH?=
 =?us-ascii?Q?hN6Dmh4pwPhiWjTGM8bR+/X7bNU3AuFxl8mv9MuEXS0f91LMqlp61BKPnSSZ?=
 =?us-ascii?Q?/73QBhtkh4LA0VzqAYSQiZJlqurbhOL+GkrqMgjUr1oieSV3av5MkZvE4QGg?=
 =?us-ascii?Q?3GGSSgSCPPEYNevAFxVKiBhGOGj5TxwG8WH9aAUrhfpS5uZNIEk8paqQXbIY?=
 =?us-ascii?Q?8SFIGzqveSZ6TPESqXx4/gMt8LD4R78dzp70sUW5ii8/Afcb5U6loqSVgVfe?=
 =?us-ascii?Q?u0WpS9t15WTD9zvcmMOxlgpTRfy29hfmAgZiCVbaUrMOmNZCzbtyqDXb8nPl?=
 =?us-ascii?Q?9s01lYdskbGLE7pKxtbFHV9z+LSgYfleJcpg1JN3C5PsqF8wk/eSsPYmgBLa?=
 =?us-ascii?Q?3QcdaF81GviPKOD3UkAg5/MfAxy4eJJqhKKPsarTQvmAhseJCBLG++YCYYA6?=
 =?us-ascii?Q?I4mrL4Kopw6vMwLSrlPWQb16g2aEG8OLivCQreyQk74NXUupLrnmjSwxnJPk?=
 =?us-ascii?Q?ZoLwIx49luqzePoEFulIV5MAmh29HlULzFjMlNWLbZ3BA0OZGW84r2lDOjU6?=
 =?us-ascii?Q?OEQuGz/CNLiNdce+QSiFjwzdMEuDb3scMv2nVurXo8t2YFyTMgIYyIfXcFNW?=
 =?us-ascii?Q?QMzFJXW7RRm231r37JLsTRLha9dfyJ4tBWMgRcfbjk5qkPZaD+qQKCXAifxl?=
 =?us-ascii?Q?lG7e2YGFreeMguPiiFrdf2Hig8JsEmDEL2ui3gCPR8ayraANsuajaMBRt3Mb?=
 =?us-ascii?Q?5jkwSNz7tAE65wi0Rpu/L5d3UnOgvWnRP5tAnRTSo3di?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF62AF027797A54E80CA458ABC25C506@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98188831-21c6-4f7f-2441-08d9f06e24d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 10:30:10.3362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hN3COjR82MjPuUYFWi3R+TtUyRcY2oKMeJNBj5PSw1a5W/hURBrEXtBMhIT1/2vnd+NvvkgMcgnXI6oddxmILQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 12:12:11PM +0200, Nikolay Aleksandrov wrote:
> On 15/02/2022 11:54, Vladimir Oltean wrote:
> > On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
> >>> +/* return true if anything will change as a result of __vlan_add_fla=
gs,
> >>> + * false otherwise
> >>> + */
> >>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16=
 flags)
> >>> +{
> >>> +	struct net_bridge_vlan_group *vg;
> >>> +	u16 old_flags =3D v->flags;
> >>> +	bool pvid_changed;
> >>> =20
> >>> -	return ret || !!(old_flags ^ v->flags);
> >>> +	if (br_vlan_is_master(v))
> >>> +		vg =3D br_vlan_group(v->br);
> >>> +	else
> >>> +		vg =3D nbp_vlan_group(v->port);
> >>> +
> >>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
> >>> +		pvid_changed =3D (vg->pvid =3D=3D v->vid);
> >>> +	else
> >>> +		pvid_changed =3D (vg->pvid !=3D v->vid);
> >>> +
> >>> +	return pvid_changed || !!(old_flags ^ v->flags);
> >>>  }
> >>
> >> These two have to depend on each other, otherwise it's error-prone and
> >> surely in the future someone will forget to update both.
> >> How about add a "commit" argument to __vlan_add_flags and possibly ren=
ame
> >> it to __vlan_update_flags, then add 2 small helpers like __vlan_update=
_flags_precommit
> >> with commit =3D=3D false and __vlan_update_flags_commit with commit =
=3D=3D true.
> >> Or some other naming, the point is to always use the same flow and che=
cks
> >> when updating the flags to make sure people don't forget.
> >=20
> > You want to squash __vlan_flags_would_change() and __vlan_add_flags()
> > into a single function? But "would_change" returns bool, and "add"
> > returns void.
> >=20
>=20
> Hence the wrappers for commit =3D=3D false and commit =3D=3D true. You co=
uld name the precommit
> one __vlan_flags_would_change or something more appropriate. The point is=
 to make
> sure we always update both when flags are changed.

I still have a little doubt that I understood you properly.
Do you mean like this?

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1402d5ca242d..0883c11897d6 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -34,36 +34,32 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rh=
ashtable *tbl, u16 vid)
 	return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
 }
=20
-static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
+static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
 			    const struct net_bridge_vlan *v)
 {
 	if (vg->pvid =3D=3D v->vid)
-		return false;
+		return;
=20
 	smp_wmb();
 	br_vlan_set_pvid_state(vg, v->state);
 	vg->pvid =3D v->vid;
-
-	return true;
 }
=20
-static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
+static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
 {
 	if (vg->pvid !=3D vid)
-		return false;
+		return;
=20
 	smp_wmb();
 	vg->pvid =3D 0;
-
-	return true;
 }
=20
-/* return true if anything changed, false otherwise */
-static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
+/* Commit a change of flags to @v. Do not use directly, instead go through
+ * __vlan_update_flags().
+ */
+static void __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 {
 	struct net_bridge_vlan_group *vg;
-	u16 old_flags =3D v->flags;
-	bool ret;
=20
 	if (br_vlan_is_master(v))
 		vg =3D br_vlan_group(v->br);
@@ -71,16 +67,48 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v,=
 u16 flags)
 		vg =3D nbp_vlan_group(v->port);
=20
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ret =3D __vlan_add_pvid(vg, v);
+		__vlan_add_pvid(vg, v);
 	else
-		ret =3D __vlan_delete_pvid(vg, v->vid);
+		__vlan_delete_pvid(vg, v->vid);
=20
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
 		v->flags |=3D BRIDGE_VLAN_INFO_UNTAGGED;
 	else
 		v->flags &=3D ~BRIDGE_VLAN_INFO_UNTAGGED;
+}
+
+/* Return true if anything will change as a result of __vlan_add_flags(),
+ * false otherwise. Do not use directly, instead go through
+ * __vlan_update_flags().
+ */
+static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags=
)
+{
+	struct net_bridge_vlan_group *vg;
+	u16 old_flags =3D v->flags;
+	bool pvid_changed;
=20
-	return ret || !!(old_flags ^ v->flags);
+	if (br_vlan_is_master(v))
+		vg =3D br_vlan_group(v->br);
+	else
+		vg =3D nbp_vlan_group(v->port);
+
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		pvid_changed =3D (vg->pvid !=3D v->vid);
+	else
+		pvid_changed =3D (vg->pvid =3D=3D v->vid);
+
+	return pvid_changed || !!(old_flags ^ v->flags);
+}
+
+static bool __vlan_update_flags(struct net_bridge_vlan *v, u16 flags,
+				bool commit)
+{
+	if (!commit)
+		return __vlan_flags_would_change(v, flags);
+
+	__vlan_add_flags(v, flags);
+
+	return false;
 }
=20
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
@@ -310,7 +338,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 fl=
ags,
 		goto out_fdb_insert;
=20
 	__vlan_add_list(v);
-	__vlan_add_flags(v, flags);
+	__vlan_update_flags(v, flags, true);
 	br_multicast_toggle_one_vlan(v, true);
=20
 	if (p)
@@ -670,11 +698,15 @@ static int br_vlan_add_existing(struct net_bridge *br=
,
 				u16 flags, bool *changed,
 				struct netlink_ext_ack *extack)
 {
+	bool would_change =3D __vlan_update_flags(vlan, flags, false);
 	int err;
=20
-	err =3D br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
-	if (err && err !=3D -EOPNOTSUPP)
-		return err;
+	if (would_change) {
+		err =3D br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
+						 extack);
+		if (err && err !=3D -EOPNOTSUPP)
+			return err;
+	}
=20
 	if (!br_vlan_is_brentry(vlan)) {
 		/* Trying to change flags of non-existent bridge vlan */
@@ -696,7 +728,8 @@ static int br_vlan_add_existing(struct net_bridge *br,
 		br_multicast_toggle_one_vlan(vlan, true);
 	}
=20
-	if (__vlan_add_flags(vlan, flags))
+	__vlan_update_flags(vlan, flags, true);
+	if (would_change)
 		*changed =3D true;
=20
 	return 0;
@@ -1247,11 +1280,18 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 =
vid, u16 flags,
 	*changed =3D false;
 	vlan =3D br_vlan_find(nbp_vlan_group(port), vid);
 	if (vlan) {
-		/* Pass the flags to the hardware bridge */
-		ret =3D br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
-		if (ret && ret !=3D -EOPNOTSUPP)
-			return ret;
-		*changed =3D __vlan_add_flags(vlan, flags);
+		bool would_change =3D __vlan_update_flags(vlan, flags, false);
+
+		if (would_change) {
+			/* Pass the flags to the hardware bridge */
+			ret =3D br_switchdev_port_vlan_add(port->dev, vid,
+							 flags, extack);
+			if (ret && ret !=3D -EOPNOTSUPP)
+				return ret;
+		}
+
+		__vlan_update_flags(vlan, flags, true);
+		*changed =3D would_change;
=20
 		return 0;
 	}=
