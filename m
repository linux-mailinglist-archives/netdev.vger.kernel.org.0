Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D613DE10E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhHBUxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:53:48 -0400
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:9383
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231339AbhHBUxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:53:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CA7MXf/f4Xq+9dToL3mI1XglTbMj59QHmyp6Zp7AcGgPumWLD93/uoooDjM66Jj9sR8Gs0oxFkuE62mHP/h+MJtRqX9MK+VcEA+ARlikEAPomFPlS42/4d/Dg9ww9xdRN89eJ21vh/9A8QQgSrm8/4jKXM5XPBu51rqqY1sfJxU9pTCFrE9bPSX4iVATEkhuhb/bERS8Iq8n5KIwrjjKk+xm8RQozFJ+w/sYXFq9pN3BWXNtSETmeJPstCfA/ITfZBlltuqul9AckWOkMFJOY3KbeZRehQmMuKzCidNO/wA27Qd/3MQ7pSv3RDoU1ObumWn3YLpzBvmjzqtu9jxxvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNAyTLwpv9AcfxseD0NMA6X66sndpMIi5pUzav0Ojb4=;
 b=WdH6LQLkiKELrlUeHiJJI+GIXxMr2yia0gOYWZConiYCI/7haU8Nyj1Xl04oKy+ldRypeqZejhcaPpvoEHwt4mM8iS0M8BIvWcKCt87gN+tvdtRv1UwVCqWX5dXuNhzvMnfVTvjWvgaobGKrU+iZtzaQV+JGha4XfQN9KJu7ENGf2Lmc01k0G0mctGtzmzQ1Wda0IO6NuCd09i5h5x0oSTDjc19yFbaOfSpsWkhYL7dv07EItFoCFXi89dm6XZ1NmmpZbUcQ4LsS961EaHiwxQZ79YMLNpxUoTKukcPyfaVcFWy4YBjnUrFb6rMpzeyXzq/ni+biPBJ6GCsuh8YxZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNAyTLwpv9AcfxseD0NMA6X66sndpMIi5pUzav0Ojb4=;
 b=fbF2o4V3BxTQscQaM3UfvLWQoVldasA0mEsxxZuYm46QcayQc4e3Id38FtwJtKL1wVLelRU980giUQYc2APk0MHbSZprTtUt294KPz1mofNCv+rZPJk20YGzoZ7nnAtXjGqS2CmS6rDFnOBjVkI743VylZx8S8Gx8LAsIiulI4w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 20:53:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 20:53:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Topic: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Index: AQHXh61yQBka7eM/OUS0Ww/tlViNv6tgZe6AgAAjW4CAAAnwgIAADhEAgAAHHICAAAaCAIAAAqaA
Date:   Mon, 2 Aug 2021 20:53:33 +0000
Message-ID: <20210802205333.7kcmf6npurld7zrq@skbuf>
References: <20210802144813.1152762-1-arnd@kernel.org>
 <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
 <20210802190459.ruhfa23xcoqg2vj6@skbuf>
 <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
 <20210802202047.sqc6yef75dcoowuc@skbuf>
 <CAK8P3a0hLcNvR0Td1fpu6N0r1Hb7uSq0HPKkF30uCANuDg-SrQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0hLcNvR0Td1fpu6N0r1Hb7uSq0HPKkF30uCANuDg-SrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b715ff24-efc2-4541-22dd-08d955f79781
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-microsoft-antispam-prvs: <VI1PR0402MB3549885CBAE30E3ADEC583E4E0EF9@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93kvXcjQcSCYOv3qrPsBfsiqDEBYtrCgFsGMecrIxF8g9YIRjrVyx/RPUsujQSZBCsRhEO5ztgAdIPmhXpSE3pbvKGyTbvcWNzFxllqMa3XC7R7HrPUgDdbFV+rdRT2ev/hnEYTPK0C/q6naHY6+E5NKok5cJQQ9KMJRi92+hvWhR9r1IRuIAtLuS4f0tBRrKdeGESnh5OQyRH4YElNbg/zXK6zn/tBTk1JkVyEImAWxDB/e8T9N007m5+OTC/GoERAXKSszy1Iw8hHmJ+kvF44qECwAg8qruHIaG3rrFOwXVr1JaM9OYuz4Cf600ZWcBjeE495TzaavYhjDn22+oq5bBAwFVH4lfG3z4leKjmfGYUxgPwMMWHxX4Q5hbi1qkESIvbSZtt/KzN1cRaFnj3laelNKn6qNYIjmkxeXPsR5KOv5y++LikHyly8zH/8ccexbwWFjiMgG8CIoSbz1T7c1rbWmD0jcKTAkSWDPj5EmYKDY08UzFvk1DVYvYatkDtlSLWqOMnoNbkZsq3IKDZubiWxG3/qm4Q0U8M9MlzoCaTZRBp6uQ7Y/oli8lpxdCiqLOdxQ6gEJcgObZ43eURD4fEDhKacgBmprkZF0tLMHCkT6w0wacnb6RQlWzh+v5MVszf9Ob65takiR8BcPmDgNWDAfNorbBVtF1WP/S27WP41+Ffp6/sCDGGckgvyR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(136003)(39860400002)(396003)(376002)(366004)(76116006)(66476007)(54906003)(83380400001)(7416002)(26005)(9686003)(6512007)(4326008)(186003)(6486002)(316002)(71200400001)(64756008)(66556008)(66446008)(66946007)(86362001)(44832011)(122000001)(8936002)(1076003)(6506007)(33716001)(38100700002)(478600001)(2906002)(38070700005)(6916009)(5660300002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QRtYP9ca19w/N7X5g1xpojdOMfTpn/PDHf4B1mK7/JWKBt63akMIh2TxFYiq?=
 =?us-ascii?Q?uCH9+IjVZli8O/xQTdzhJa1Ix5pzck70ZXy520BH27zwfD1VasKbwqx5jDWn?=
 =?us-ascii?Q?D5dNTiSGNgdCa8RDGM3dpNIfxJoaCPGp5+Hm1DE9uX/ipnscWkLCKRchQkUg?=
 =?us-ascii?Q?acPLtDstzMK8GsIYqFoyxIeCxvfvn9RFv7xOB3NFIw/L0NPqCD/vT+US4cRA?=
 =?us-ascii?Q?ertZyTHu9F1rJ6WhNoUjx6kwzWBMCycO3cuiaRksGqdkUghdiJT/AERILg7Y?=
 =?us-ascii?Q?ZloHM3CoPEm5homWF2Yj9RBkc6yd66hwnzxMN6faK9B0aDKA6um/jqKIgGkY?=
 =?us-ascii?Q?f+JQVJ6Q8GviKO51T6aR1Zrira8bTAorfr0p/+2/58Lwvb04mZdK1P57QJ5s?=
 =?us-ascii?Q?XYL1YzGtW8sVygT4nvVDmV5ZNA5Bxp0jhZEIb8KdjaY7MONo8QoAst6V6RFM?=
 =?us-ascii?Q?Y3uMuiwMB760P1qSWxoOpgbNqUO6ovfQUEWGwrav3tCrMXF8zPTVWlhqZGRc?=
 =?us-ascii?Q?iX7NkxRTBY7w64kx5tQdCuZAJ8BUTh7SiO6YJM3nQnw63YrbDX6dXjX3TjJd?=
 =?us-ascii?Q?PQOVw15YLo39opjKFXdGIcUJcqxWpdflTecxSunRNvJblcXvxZ0Gg6mWyUwG?=
 =?us-ascii?Q?F6pPgGXiAJqqyFZAbk2DehWvQyS7uU31wKRar1OgXDify+IgG4WWItAvXF6z?=
 =?us-ascii?Q?tLgaA2ojczX9IVBkWpPQv1TqySoWmKOzWERyxkHUQuNu5NLiwq+2N+NyhIpd?=
 =?us-ascii?Q?teh3ElIi38DYGWoCaLdHEfjgrM0uefNkj7XMdSz707trZlc0tKfO1dJ7mt70?=
 =?us-ascii?Q?M3/rCSjHMAKOVw7R8iTvO2KQpqBZ24lu7sMChesHAW6Ca2YfIEf4PVB5iGSs?=
 =?us-ascii?Q?aW4HXzJ8LQW8mUGqFbbGDh5j/AabFkIg2jwZLeVVe/ovnvaLzl/cucSfQUri?=
 =?us-ascii?Q?NViqq9iCy2Tu0X+agYBjB1vMmtEKN+tT4q+4Em9tuKJm9PBN7MLL4B5k9Ew4?=
 =?us-ascii?Q?GElBQfpRVeccbdVnXh73xlMm/fpcrZ5Gqc961STKa95zke+sZgWbBai5jOfQ?=
 =?us-ascii?Q?VE/0NBedXh6aF61/3CTMMCTW3zLE3VXgP/lUBIxXH2msiYIJ95KtXoIZHcKG?=
 =?us-ascii?Q?GUIcuIBDA59bjobb66x76YniFug2qW9lEF4HT2DJXg+HhHzhSu44LnaROcG8?=
 =?us-ascii?Q?BgeOuko2zrwAkzyNKl85YfDURasGy4FkmrGTl0yNtZ/ptUb7dQ3ISaihv9aP?=
 =?us-ascii?Q?IhD3WX7Mj+m8zwap6bXkgicRRp6z3YhH1FrbfEJ2CFddgSlq6OGtWxkbJJ8d?=
 =?us-ascii?Q?IPIS2MWeGoXyk+X3DWt5ViiR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B819E20F5C447A46ACD60F6E497066B5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b715ff24-efc2-4541-22dd-08d955f79781
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 20:53:33.5622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZEVMbVpMxF/GkqGGbf4xUBEV7HeEO2lz9TyfDdC9lbvs9yfWztjqjHYN+0h4FAYT6SD3/AMRVUhNJ5qj+AfvBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 10:44:04PM +0200, Arnd Bergmann wrote:
> > or to extend the BRIDGE || BRIDGE=3Dn dependency to TI_K3_AM65_CPSW_NUS=
S
> > which is the direct tristate dependency of CONFIG_TI_K3_AM65_CPSW_SWITC=
HDEV,
>=20
> That would work, but it's slightly more heavy-handed than my proposal, as=
 this
> prevents TI_K3_AM65_CPSW_NUSS from being built-in when BRIDGE is a module=
,
> even when switchdev support is completely disabled.
>=20
> > and to make CONFIG_TI_K3_AM65_CPSW_SWITCHDEV simply depend on BRIDGE.
>=20
> This would not be needed then I think.

I've tested this change according to your suggestion:

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kcon=
fig
index 7ac8e5ecbe97..a9980cfc504b 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -93,6 +93,7 @@ config TI_CPTS
 config TI_K3_AM65_CPSW_NUSS
 	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
+	depends on (BRIDGE && NET_SWITCHDEV) || BRIDGE=3Dn || NET_SWITCHDEV=3Dn
 	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
 	imply PHY_TI_GMII_SEL
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? y
@@ -110,7 +111,6 @@ config TI_K3_AM65_CPSW_NUSS
 config TI_K3_AM65_CPSW_SWITCHDEV
 	bool "TI K3 AM654x/J721E CPSW Switch mode support"
 	depends on TI_K3_AM65_CPSW_NUSS
-	depends on BRIDGE || BRIDGE=3Dn
 	depends on NET_SWITCHDEV
 	help
 	 This enables switchdev support for TI K3 CPSWxG Ethernet

and it does appear to work, so when you resubmit please feel free to add:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks and sorry for breaking the dependency chain yet again! It takes
time to learn this stuff.=
