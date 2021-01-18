Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DDA2FA969
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407962AbhARS4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:56:34 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:55552
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407898AbhARSzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:55:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8S4gV8P16Do2utLyM4vwk/skWCTA39+7wIDgNQ820RkPD8fivRekXR3vAUJfV5zNj3D+NqDrJgGUiUPDbSOu0r/m04/G0HbMGSSLoHF+5S/aLmY2G/MiL/+bo04WszLtfOyPrayv9LLb/KgXNyvG+a/np5HV3NZ+/zdcUhPkD/m1MAFItui1l5PZvse0ylUm6Gqd3irjNQ1KbIcjAq3JPIjKMdzUud9PxtCSGxWr95+R0/2ki2zJ7aPT1TH4B66gj4ILcd1wd6ef1g1+xtvq2zBKr8rYcMh+oVQBCHJf/lhSk6x8o2u78DhlM0uJURPI2bgOku3NR8lt1P4wtMUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWSudLwQ1wk23uf0seOQefx1bzPO+ET9lJaSxnYXzGc=;
 b=gnjRvaqVAQeo2fcdCkGesGzOVsx/yyUq90zmLGHzxPlUyY1RQzfBwSaCAAmhu7/LqWghQXA06Rr0Ws3Cg3t384BS2+b3c924qBN2mTOL6wh7pj+A+C0wlbxIzXCbXVIHRONqibVM+OUTsF9TtjQvCnK8RpwLbVEcOrOGc+CjHtoNhcQuTJNYhPz/SoJHqQDFrxMzm4JrCqhtWpx3D5gj0i779TjR/ffWLwX79Gg7sNnv/V0R3P8gPDIi/9E1v/hFD/RZj493sWCmZ6jNex6ud86UsCfRs+Tp5UqzmtRJJh991Emm6ft3/tBeZNjTRXBUXpIO0zc/TScr6B56Gl6Txw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWSudLwQ1wk23uf0seOQefx1bzPO+ET9lJaSxnYXzGc=;
 b=NlVSSx++1F2I8HdhZgfxl5O90BtC6QHbZMWax/FsfdWaOzhPNmo18b7ox248q8p27Hlf/9pa3bktlwaA8u+cidAg4durYMDKvjPm/XPRgq6wy0ayGb8zLT0nb1QR1bt7rg6NAlAGyWAtDZSjXoU9jFDtJUVDxyZ/1nu8t6mNFFY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 18:55:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Mon, 18 Jan 2021
 18:55:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Bedel, Alban" <alban.bedel@aerq.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Topic: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Index: AQHW7bOA9fYvcfmYzUChcnWV1prsRqotu3KA
Date:   Mon, 18 Jan 2021 18:55:01 +0000
Message-ID: <20210118185501.6wejo4xwb2lidicm@skbuf>
References: <20210118160317.554018-1-alban.bedel@aerq.com>
In-Reply-To: <20210118160317.554018-1-alban.bedel@aerq.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: aerq.com; dkim=none (message not signed)
 header.d=none;aerq.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85e53ce7-e104-4f9c-8295-08d8bbe28fa8
x-ms-traffictypediagnostic: VI1PR0402MB3711:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3711CCB87C0290E2CBCEF5A2E0A40@VI1PR0402MB3711.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wmq1Y76bvgGsK8tJmaevz5Mfs+J9iOZg2xhzAftry1Y1t5POVDATbYvlUqRbWvnm017JFPyqGGZreiar7zRniKPO2Ou0zH+RaBlvNPL/aC5gMuOAxpSLjiex+bu2YEdEhtfIYi4cdGZJU7z4DZyY0a7mv7Zq5mUeXhZ9yBWTPCJLNrwUuWpC4IyPssibEpFijCFpoH3hk7z/lGiWeXGXaUO853H14xHLc8HPTJRcPi1o73PiSNu7GbkmZBQDArz2mylFCqIC5ECRRjqVb4zxS23oJJRFnPdLNa/Wxtx1Aq0ME7U5djY3KSKKCPfor1WFrBlkdqum/+KLlbnZ9llg7XxAj4AncSIG+J5IfT0cEdUSrySkDP47V2nkcpNR5KoR8JBqThZIl+Oxg/xfUNDoj8SUloWe5dfGVXV8CPIpbawk+R7FRZ/byWj2DtVk1dKLnThmMYnL+eYdlw9yifzFtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(1076003)(186003)(71200400001)(6506007)(26005)(5660300002)(44832011)(83380400001)(76116006)(54906003)(316002)(66946007)(66476007)(66446008)(8676002)(86362001)(33716001)(6916009)(2906002)(66556008)(966005)(6486002)(478600001)(6512007)(8936002)(64756008)(4326008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sR4bRZkH+4ekq+L9ZIkF44NptrdEuHgfynrus0Dyzgv8Ue2lAyihum4D8MT1?=
 =?us-ascii?Q?SpUX8I9kSTEOtI5WFpbCBnvRJ/RxvlZjMEuSYHHMqf/wxPqp3Z2sgteTjMup?=
 =?us-ascii?Q?GjIEghdgXUxWldxnO80vb71QV7ol11jTNbvGF3P7c/zQSwkTpA4GhKrV2aM0?=
 =?us-ascii?Q?kd3m+E5C/CGUClMajyRVaQpwI/7Phz5XQbE43+xS5oC3w2U4Y6EIy7u8o7YS?=
 =?us-ascii?Q?LGtZRztFiaFVd4E1hXGmWzFykSOY1gYa312A/gazMdC/bM6AeKNU19cLT7fP?=
 =?us-ascii?Q?BnWxSp+LTmi+sb07z71m/1mAf4KgVxLptP8t+/t9Z/zS86yhXlCt2s+CM/RN?=
 =?us-ascii?Q?6NyS0MAw+6cCQ1XVdDB8Mfe/KX31r3kRGYvetMG7ROGYpIbfawU+EvkLh5DQ?=
 =?us-ascii?Q?44yc+/1OogWuRFuRMRv7utkTHohD0sjXAJgo38X2wfoVeKOMYkyU3WbaIRrd?=
 =?us-ascii?Q?TfwUvUatKQLJE9ReBSNnqL+Vi3tUUqj8PDd32GcLi6u2lTAYy2JUqou2sUP0?=
 =?us-ascii?Q?xk8p/xG6QL08rYvqTqpoouQWSxu54D9wSa4CMfd6rnhqVHa/aVRZ9Zm4Q2/z?=
 =?us-ascii?Q?LunKo6U9M5SitI0NXJBdVII1sjz1cRNKV+4G9QIzZlPClO6n2Lw7AkXkUBB8?=
 =?us-ascii?Q?tfj6EgU4ocONTNW3z5W0evCNcUggh23DVl1eG55F7yuCXHHivEeP7frFYnil?=
 =?us-ascii?Q?l5itqaNLkxFxM3uynXOkZ5ZAk+e/0fKrosdQC37GfHBN6wr5cG42BkwyzoBr?=
 =?us-ascii?Q?dVkb6e8DD5EPe7ANUSmNYIot5Z56O/3eXTlPRRUQTunZBUqbq7a/IGMDk1D0?=
 =?us-ascii?Q?TvVNvjFdvHHc2oKoYeBC5sphbVzfkcQ3TlAntaDfHIp4tf5mzCVT3edLpKPF?=
 =?us-ascii?Q?jJ+jZN1cf7EIuWYEQf4E0pfQQBVi/9Q4k5st5uVgzsiNFQsJ33Rre3mukJH1?=
 =?us-ascii?Q?ZdsUOZFpZJsFLFwYrW83x8XEUOWQ67v3SqXfzXLsZOB4e5deFgD6h1MdHE+r?=
 =?us-ascii?Q?w8YX?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5825BCDFE6426548BECBBF83C7635D22@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e53ce7-e104-4f9c-8295-08d8bbe28fa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 18:55:01.9134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mgnCRYiiHC/lZfcKuHLibJ4rhwgGK8EzuTz98heEd9xU/7BUqdT2ZwhZHFl8bO7OK0AVlfDyi+UXYLzkIrwlHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alban,

On Mon, Jan 18, 2021 at 05:03:17PM +0100, Alban Bedel wrote:
> Multicast entries in the MAC table use the high bits of the MAC
> address to encode the ports that should get the packets. But this port
> mask does not work for the CPU port, to receive these packets on the
> CPU port the MAC_CPU_COPY flag must be set.
>=20
> Because of this IPv6 was effectively not working because neighbor
> solicitations were never received. This was not apparent before commit
> 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb
> entries) as the IPv6 entries were broken so all incoming IPv6
> multicast was then treated as unknown and flooded on all ports.
>=20
> To fix this problem add a new `flags` parameter to ocelot_mact_learn()
> and set MAC_CPU_COPY when the CPU port is in the port set. We still
> leave the CPU port in the bitfield as it doesn't seems to hurt.
>=20
> Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
> Fixes: 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet=
 mdb entries)
> ---

Good catch, it seems that I really did not test that patch with
multicast traffic received on the CPU (and not only that patch, but ever
since, in fact), shame on me.

What I don't like your patch is how it spills over the entire ocelot
driver, yet still fails to compile. You missed a bunch of
ocelot_mact_learn calls from ocelot_net.c (8 of them, in fact).
I don't know which kernel tree you applied this patch to, but clearly
not "net"/master:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

I would prefer to see a more self-contained bug fix, such as potentially
this one:

-----------------------------[cut here]-----------------------------
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc=
/ocelot.c
index a560d6be2a44..4d7443b123bd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -56,18 +56,46 @@ static void ocelot_mact_select(struct ocelot *ocelot,
=20
 }
=20
+static unsigned long
+ocelot_decode_ports_from_mdb(const unsigned char *addr,
+			     enum macaccess_entry_type entry_type)
+{
+	unsigned long ports =3D 0;
+
+	if (entry_type =3D=3D ENTRYTYPE_MACv4) {
+		ports =3D addr[2];
+		ports |=3D addr[1] << 8;
+	} else if (entry_type =3D=3D ENTRYTYPE_MACv6) {
+		ports =3D addr[1];
+		ports |=3D addr[0] << 8;
+	}
+
+	return ports;
+}
+
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      const unsigned char mac[ETH_ALEN],
 		      unsigned int vid, enum macaccess_entry_type type)
 {
+	u32 flags =3D ANA_TABLES_MACACCESS_VALID |
+		    ANA_TABLES_MACACCESS_DEST_IDX(port) |
+		    ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
+		    ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN);
+
 	ocelot_mact_select(ocelot, mac, vid);
=20
+	/* Little API trickery to make this function "just work" when the CPU
+	 * port module is included in the port mask for multicast IP entries.
+	 */
+	if (type =3D=3D ENTRYTYPE_MACv4 || type =3D=3D ENTRYTYPE_MACv6) {
+		unsigned long ports =3D ocelot_decode_ports_from_mdb(mac, type);
+
+		if (ports & BIT(ocelot->num_phys_ports))
+			flags |=3D ANA_TABLES_MACACCESS_MAC_CPU_COPY;
+	}
+
 	/* Issue a write command */
-	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
-			     ANA_TABLES_MACACCESS_DEST_IDX(port) |
-			     ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
-			     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN),
-			     ANA_TABLES_MACACCESS);
+	ocelot_write(ocelot, flags, ANA_TABLES_MACACCESS);
=20
 	return ocelot_mact_wait_for_completion(ocelot);
 }
-----------------------------[cut here]-----------------------------

It has the advantage of actually compiling, plus it should be easier to
backport because the changes are all in one place.


Please make sure to read:
Documentation/process/submitting-patches.rst
(this will tell you what is wrong with your Fixes: tag)
Documentation/networking/netdev-FAQ.rst
(this will tell you what is wrong with this patch's --subject-prefix,
and why the patch does not build on the trees it is supposed to be
applied to):
https://patchwork.kernel.org/project/netdevbpf/patch/20210118160317.554018-=
1-alban.bedel@aerq.com/=
