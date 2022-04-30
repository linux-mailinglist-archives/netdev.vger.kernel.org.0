Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C8515E2D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381688AbiD3O2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiD3O2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:28:23 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8E381644;
        Sat, 30 Apr 2022 07:25:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=od58iGjdfKVG5MjILzFPky4u5zqtOi+djjPsIDzUBFY3rGtu4yraAxTP/oU+No0+G7rTdRQ6Kuv/DFC6bzvLAFfWFFadWKD/owRh5p6juhtS+McOXt1EgFp34Jf9wQ6cVjEuZ23iRI/JpksKxwb4H05QjH48O/VlLtoZ3uEiADyS4ucEQwu74Kt4tuGCpOW/LDRfyX+FiccgePu9kYkpozJTDABO6W/Fx+2TmhY9bXieTOAtsYLpQISNdcZ6jrYcnPOlmxkki3QqMsGz44IQwv4e4ukSa+mCSqAK3wMuGGQ2qn28VsVQ63ikQwPuEPoWx2R6xXrC1/unnwlUQjbldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2qc5xiIJt0G/0TLcWq0W1vTGjWEFiHL1LZ0wshVCGk=;
 b=gJGOIMuBS9AZFnZ/OiutuIHHyUUj6wJ4jBKq7dXhWpsmL7bXPhW6gHFct89RsnjHcRaW7ZxczMoxDT997JWeS9P/2APzWtrLTnBQkroK3Ws0OmnsXTSemM2ilsTDdQyzvaWMp3VuajscrYLBXruHXRIK7Fxb1wGtP0+rPbIcdbFrWPmDbM+8mlQtrYf5FbBh5o18Y7YR+4AbN8xAer4JD7QOMVgVey1vfvICyNeF40WEvHJ9Aouy6QCM+VSd+llOHvsbXyy4cBlaThdemv0c0NcJ921Wjx9eh2V0BgAOfG3ovN45+nNla2mjqNryE/0IKJhckRSzwoTQXi571EeoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2qc5xiIJt0G/0TLcWq0W1vTGjWEFiHL1LZ0wshVCGk=;
 b=GVS3m8RhLLMUzQ1QyL2K1EW1LVOfrm6hVpM2DzKRr9h/kLmOPoD2gQHPZ7k+jSLHIdizzWOFee+8dthm9HCOUr/ao9k45+fuenzidG5cJEIteDwlOldbc8fBotu8QaVlml0etNXLHTBgqq7YZmjVS9iGNcZCKeZB6SQM8j4oUKs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6205.eurprd04.prod.outlook.com (2603:10a6:803:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 14:24:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sat, 30 Apr 2022
 14:24:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Thread-Topic: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Thread-Index: AQHYXCE0wfZ6v7cjxEOPYespSpyp0K0Ig9+A
Date:   Sat, 30 Apr 2022 14:24:57 +0000
Message-ID: <20220430142457.7l2towhbptdvrfje@skbuf>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-3-colin.foster@in-advantage.com>
In-Reply-To: <20220429233049.3726791-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0966b035-da87-4e5b-f282-08da2ab53425
x-ms-traffictypediagnostic: VI1PR04MB6205:EE_
x-microsoft-antispam-prvs: <VI1PR04MB62056E34F76E64219A1BD604E0FF9@VI1PR04MB6205.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FtHc+hYU31cliYumX7BxEPJd1DisbYm/olpG7t9MMaWWqEfP8PQ0E6mjuG4N91WnDYMwxea3SxmoUucW9KPS7gnl4jpe19XLj8h/V1qVpw/g4WR7EkABqwv3OnTUSS/g5zCxt4ifFdDLMv0bw0GFlvy6UkAAuK8zAch27Gm3Db7u8oSkjn+zMv6KDKE37P5qau0BHmoNM1PnxbbUA8LCD3Gl+Q4SLdOLuivHwo9X3yumfCSPNy4oF52yg3/8ay7HK5dMsugufgRm4U8khuCcHlAwJh4Rji74tDjW1spHrXn7wvjd14mKPIo9yfX6wb/u6ZvXeWwaU3IHK6dyEPdK3JIS5roryA+rzh07ujjsMkJkKONBMbLIyUT6T8//ABsQEfy69qgqxO0lAt/LIrh2RHjzvX/cBxAnZoKukf3ANFBop0XE41TYaFe1y3a5qujF7GmNyBXF8fVWoSLJsGom6GXcOye27gz2RPKpe2m+cduNC06v3P6QgjzGn7wo6WnkbkT1w7kmf3jgvfdHlDkwn6n5xxmXXqso1DngfuYpDxgHW35nqjQf/KL+AyKO3WBVHW0PyONMR5fSGhx+IqutiDM96ocnA1Rvp0bTzQUeKgbXSvP0hCTIUgZfoiAkCuT8rA9TEU8iQcLMmfQ/TowBpcwvKHIP/kT/S0uV0XNJtx5ZtCV1PlCPL4xzBy0mMhENENTAcqcg/k53XjZMi7FZrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(44832011)(5660300002)(186003)(66476007)(316002)(7416002)(66946007)(66556008)(76116006)(33716001)(66446008)(4326008)(8676002)(64756008)(83380400001)(6916009)(8936002)(54906003)(71200400001)(2906002)(6486002)(86362001)(508600001)(38070700005)(38100700002)(1076003)(9686003)(6512007)(122000001)(26005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9+rcy0ohodJYiTd7nCltJ7f48/ZkSowtE6t70YNbmzBPtWqUf/dnrERXiiB6?=
 =?us-ascii?Q?NAq1hdM18E1o83cUNvhKxuqs9zRcb53apo8D+6JZBSwtQJkjCpq4meyByy1X?=
 =?us-ascii?Q?jiAd7tBHUocwTiEMQKA2pVChvAHCVc5SpkViy3E9QRwvvqBSMmAuePPZVz/n?=
 =?us-ascii?Q?A+a/4aSGzXbSxe4C1AF7P+wf+EVCxCfYh3YsQCPHEEEycAq4GL8UGc0mCoMZ?=
 =?us-ascii?Q?7iC7iKkb4mNdsciRgjs7CE3HYeAtVxfyQN/8C9R2PvYI49wTm5ZmOuHdHz4v?=
 =?us-ascii?Q?f+gnHmtpLNKJfCM80HEe50nR9Eisl4QY8FzQjoUirkIGnCh301hboRIfY2Xl?=
 =?us-ascii?Q?oM9oE+geAurVbUJkymb0U9K7zlKYcmT7/egp85UT9v5frrUxfbyWGpDOtOZm?=
 =?us-ascii?Q?ZnG2PiF3F90ijgVVYVjMKreGlZAZq18uLmbmAm5g7Pm/hr+B9AFVDkXeMfLq?=
 =?us-ascii?Q?H4U8rxRdGhMOw4fK2e8l5o/OnAtTA34IcoxSKdbS4ROzExafIejNMmpnNVW0?=
 =?us-ascii?Q?aNr/w/bZ8+SE6ppoAHia8oMouj8syMP7YkfWEkhXj+lS/95P46PVSnGtoZ6+?=
 =?us-ascii?Q?Zm0HuYDa7QYWsSQb6pKd1pvnL13cuWl+LnAPn9Rr+3Z9ch4cKnWxTrnL9TSn?=
 =?us-ascii?Q?d5u78bcDJgvKyQNcJv5H7JjTS7Kdvf8xmeiDziigN9M8fezTzqnvfGeX8M2b?=
 =?us-ascii?Q?+P4qRrH5Q/WrEllaeQYYQU6z60Zw6LcrrbbRRPtuUPfuA8Jk6f80rdUIMf7V?=
 =?us-ascii?Q?EnHZlUyqHaORrYLsufnnoJBQubQpPtVsam06SzDJWaKNAyHWyQuDFCRgoosV?=
 =?us-ascii?Q?R1tonODxIbW03AWGUlrtgZfouZSchhzEFWRNHvcwQyq/3RJoV5HDFnTh1GVv?=
 =?us-ascii?Q?+hmyA1WuU9aoBY57g+DW14ct7BCWqqT+zL/7W93KDAzPFJDwyBQ5J8MeosUv?=
 =?us-ascii?Q?+tLTgcDiSRTCT5wd8IB1IpLEC1V9VrteQLWQtOs/WrEb1rGCi6KvDMce+25t?=
 =?us-ascii?Q?xAWofMn09P5yO2PQW265pGqYGkN/kxpDEj+MXbZzZz11tqkVgdsVi879GfuE?=
 =?us-ascii?Q?TAzmuvH9LCvjzpCnZBFE3ttUOSW6Pbl8NVLvGohz3ie7TxBx0UrtBC4y3Quj?=
 =?us-ascii?Q?o1kYZH9qHkcVcEu7R/G25JFqqg55to87AMsqObq2Mu/I8vyeCWswBD44VumF?=
 =?us-ascii?Q?5gQNLuCIZr9d/SQvqcMEXfgpaYsyVb69NMJCf3n85Ghx188GSJMoVHWzamBm?=
 =?us-ascii?Q?9MvjQRSwcStaQp/zL5QfSMYCqnvHuRAqc8bB9+B8LT0Qz3XsXy6mSPfVPX5X?=
 =?us-ascii?Q?2Aeox87SRjMMNGIMFwawNRF5eefN3FcCob7jkakhTPcoFnBJM1aChs3u+F+x?=
 =?us-ascii?Q?n0fbk4SRnIK7KmqBB3zmJu2yt41XFtvb39V6nrKuF4PChwNTl7M1hZyGvxWJ?=
 =?us-ascii?Q?sWxfqHK+iGR3OZaXdgOVWrhmes8O6i7Cdxb15VhuiNsQ3j9H8VyIInzs9RMJ?=
 =?us-ascii?Q?nw6wvcqkyYeequGIyQi0ez8ViLxBWvKrM56+cSaTsRWekjKJbrbKhx0UiMmy?=
 =?us-ascii?Q?IoCjwm8iR18h2wthhSlbKcoSzDb/dT/AdNpT+6vvJyvSruk+q8B9GMAWIreV?=
 =?us-ascii?Q?Zx5CE0hviOeX2RbUeMzdSGtNtJC63nJufxOryphjFXCP2AvP05Eb8etKLR6R?=
 =?us-ascii?Q?/SdUa/tUXfcZc6OuF8uthirG1sjy409D7VDv8k4IfXkbZ3UUTrnSZXysTzCO?=
 =?us-ascii?Q?Q9W/2xTDn7T7QJAjupNc25icWmkxXgE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C835CC709FB7C4F8DE6E99A20C6A9BC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0966b035-da87-4e5b-f282-08da2ab53425
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 14:24:57.8383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5MwgCYK5ugkCWOK80dTcoVMcxMEnooMupRAIhsPgVuMTCvHfxswTlWZqBu7JRpa6ZvHMlK+pwVgtFDApQ8jZzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6205
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Fri, Apr 29, 2022 at 04:30:49PM -0700, Colin Foster wrote:
> Each instance of an ocelot struct has the ocelot_vcap_props structure bei=
ng
> referenced. During initialization (ocelot_init), these vcap_props are
> detected and the structure contents are modified.
>=20
> In the case of the standard ocelot driver, there will probably only be on=
e
> instance of struct ocelot, since it is part of the chip.
>=20
> For the Felix driver, there could be multiple instances of struct ocelot.
> In that scenario, the second time ocelot_init would get called, it would
> corrupt what had been done in the first call because they both reference
> *ocelot->vcap. Both of these instances were assigned the same memory
> location.
>=20
> Move this vcap_props memory to within struct ocelot, so that each instanc=
e
> can modify the structure to their heart's content without corrupting othe=
r
> instances.
>=20
> Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> constants")
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

To prove an issue, you must come with an example of two switches which
share the same struct vcap_props, but contain different VCAP constants
in the hardware registers. Otherwise, what you call "corruption" is just
"overwriting with the same values".

I would say that by definition, if two such switches have different VCAP
constants, they have different vcap_props structures, and if they have
the same vcap_props structure, they have the same VCAP constants.

Therefore, even in a multi-switch environment, a second call to
ocelot_vcap_detect_constants() would overwrite the vcap->entry_width,
vcap->tg_width, vcap->sw_count, vcap->entry_count, vcap->action_count,
vcap->action_width, vcap->counter_words, vcap->counter_width with the
exact same values.

I do not see the point in duplicating struct vcap_props per ocelot
instance.

I assume you are noticing some problems with VSC7512? What are they?
Note that since VSC7512 isn't currently supported by the kernel, even a
theoretical corruption issue doesn't qualify as a bug, since there is no
way to reproduce it. All the Microchip switches supported by the kernel
are internal to an SoC, are single switches, and they have different
vcap_props structures.=
