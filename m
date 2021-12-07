Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9993046B322
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhLGGsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:48:13 -0500
Received: from mail-psaapc01on2124.outbound.protection.outlook.com ([40.107.255.124]:10529
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhLGGsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 01:48:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHdLigbK6Wtu/MOL4z2icGqbFKp2Bh5nFJ9R83idctJCGUZF6SxDu29VEVEcDvzhdwkZgtpV9EWKLD3qr5jQnyLUrvT16U+b1U2Jco3Z8RVFnJofqwh74DVrxP/7YUB733zInVwQyi2zX+r3mJfd6+UWYq+jjlMR902VEKjEYliAqnAWkpukPHcTiSdlLfPTErt0y2z4pvxuadTwplkmnIYdASlHvO5nrbMaJ7vie2pkrIQvkf197Kzsx8qmA+ens8s8c6P4gxyeiA11E2s3gjQFbTDQsgsFfBnmx4qKg59iu+jRFGtSGA7OjMM9OoC7WIy0VVJszBFtB1Asy58okw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0S0WDG1jcvqHu55xBge6L5sXg/JWLqvWkXc8emQUY8=;
 b=B6bJTRToPxmEWnOQpcgLHx2yqRR9ArnHtCrOpCR2wY8xB5+HjsfAvCJAuX5Xqw/w70wMNDXPBEKM9a/IqtcvgTzawkYu/GJWUR7SROBHqT57kyVUs9ZwUPTt50QM4vaPdHvnkl3Y4Z8lZKERZ9F024udw3kXN1Tg4h4ZzG5gbp06H7QvdW55Dwpp9/DvfaeCAVcEuWFuDxC0nDBcbBNBML2j/aDIJKYtHBEa1M1KbQRXHECvhRMKQkYIgK/F0Btl3My1rNN4Ok5Rdk5A3O7QoR2PFA0JbpaLKLr/jtEt7D5V1+lEpuAXo+Hnmc0gHqfJX5v6Cm9pBAXWPFxdxZHM2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0S0WDG1jcvqHu55xBge6L5sXg/JWLqvWkXc8emQUY8=;
 b=h3H5RBcBpPcZabjk7nxZet3HszAItDwnJQAgIEZTURoIAAXpYSS/vsOIjlCLNmmzGg0vF2tVg9Tof+4HkE+EdXhjyaBw2nk0T/6/fEejum3oYgYtkIs3lA3iPFg8m0/GBqM9RLUZ5rSSzPmnjuQnVpaECeUcbsU2qI0Gyo7ZdDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB2735.apcprd06.prod.outlook.com (2603:1096:404:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 06:44:38 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092%8]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 06:44:38 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] net: dsa: felix: use kmemdup() to replace kmalloc + memcpy
Date:   Mon,  6 Dec 2021 22:44:18 -0800
Message-Id: <20211207064419.38632-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0154.apcprd06.prod.outlook.com
 (2603:1096:1:1f::32) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.vivo.xyz (103.220.76.181) by SG2PR06CA0154.apcprd06.prod.outlook.com (2603:1096:1:1f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Tue, 7 Dec 2021 06:44:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3736d355-3c52-4cd5-6ec4-08d9b94d0a63
X-MS-TrafficTypeDiagnostic: TY2PR06MB2735:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2735521B6B19A3401F2CA169A26E9@TY2PR06MB2735.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfTCjP8mmkxU2e4tftkiIPFs7Q/jl3SLE+0O/k1pF7SmRA5cfrCSFQTPsjW+AEHaADwY3oA4WIiKbPaBG+Svx4Ju0r0nQgbcDtO5QE8D4SCgZJ4TURtbP3yL+JpGtON6wD6vaaE/fNGlj/X3ja+YMhSlVVUtsz0ShBT83XpG70pgqPeZ03Ps4J3zeNuotfL7qkZbBEtgA16TA0k2s4e8whixubFHtxbfqvkxjnxM44avd3+sVzKY5xD3LFgyCl0xjBwnwrXZkcqoD9MWJS/ABKWuerCcsgIj2jJpvj6A2pQpRjxfWEOUlTVi7buDBOP58sRUWvNxo5Ue+A0L0Rw6nsAV2IQaM74Ng/PqHl0PJhkcO7Odar34vbt5kVZ6k7+zGsSzHP2o070R2mVb9uabZdTNuRdHTMvmN0XK5hMEEycjjfygNGDRqW+ObUhm2haVfRx8Kk03QikJrpK9zo/lT6v2z0nhyWqnyTiujDs40AsEDI467CodZjwgtdQi4ZOktxR6cC5+pEF+7uVla4QzuvOXsEcz3Om4HWrB9l/1/rT1H4W3FtTdFowyNcR8kWugjDg2dIJiO3jSB3qo0qzwsGVGbD1RteEw/3IzL6sy2xWLfJ4SLMtlaFAJDRep2WhzF8gEvrmTciTojiXguKQxzqgLG5R7P6ft+qL8AzRe+itB0HkPZiqav6dNl5JtxmlzTdt34xJLqlsjoPMpY9KlyfM/JSoH11wlDba82w0IILONhD6vZVjxH7U0C9viCfKh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(5660300002)(83380400001)(8676002)(8936002)(921005)(6506007)(36756003)(52116002)(38350700002)(38100700002)(86362001)(6666004)(4326008)(110136005)(7416002)(66946007)(186003)(26005)(6512007)(66476007)(107886003)(1076003)(2616005)(956004)(66556008)(508600001)(316002)(2906002)(182500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rahLCjeIP3NoQUG738zX4rHwFnPTdX3UvPdgxJfZ+TWNmUwjWa5lot9CkL96?=
 =?us-ascii?Q?5f8AdizQTZpFoAJ8lGuYPNI3ArOoklQENerlDGcgpLZwVWXvj8GddyY20Msh?=
 =?us-ascii?Q?8k8s1/h6Jrjqqffb+jMl8kxlqp8pYweCpZG4nUqMbdenHdFJv1vsJ7HkT6nW?=
 =?us-ascii?Q?QYMLOg8dRW4gcJBoobmDOa2snBXlb2/5lkOd/zwgUhJeJR+KXQIRfxZhkeRG?=
 =?us-ascii?Q?IkJEC9RiSfq8I4+broyqsq7AGzZc61sF1AuJPEg4txMSweNUB0uvvbV0dPNG?=
 =?us-ascii?Q?8JOriCW2QV9aXoE7cyzGKEv1k9LiLxijQ2pOmnuZBl2PrrFbZ+OJ1ilaAknj?=
 =?us-ascii?Q?4maGM+hCiAVtbBac98ggyXQPcDryoYabeQdp1wUchifh3gyBjiQDS0LgH3z2?=
 =?us-ascii?Q?lIey8MeXA3e5sepOR2jDVsIH+yYEUeiZ8nENKtm/bRIiumTNSAwLfGJF/uXK?=
 =?us-ascii?Q?31vwzeZzHsDDboFzVadaT3C2ZSgEq152I/ZPMhkVIGFxop2gHXjdK8O+g05D?=
 =?us-ascii?Q?5CFLWms33MP+mYxoKOXhshOf47V7XOFcNBU5C4qI68zPiamiwxT5mK8/TJyU?=
 =?us-ascii?Q?zSuDMDlgNZHLOHqiJ8XFuV/2nnw/CqJ2jyXiAxnb4sDGFRnC036Jzu/GRfnq?=
 =?us-ascii?Q?dSaG9Fphy1f+IZTklN2UxKpXrXV79CvpB+lvD9AV1RNu08CeK/2/uyz6GLQX?=
 =?us-ascii?Q?yVf51Mf9Q+KS6DzmwH7k0fHVxl7ii6bvZHx2ZuIwmGt/qmp536xuUTq7I9Ot?=
 =?us-ascii?Q?GiFGOOQREWBl29Vlku91jT1WMQ2unIINKeHUgiVXl6N8iZWOZJRecmYfmVaL?=
 =?us-ascii?Q?bg5lxKVO4uopA4rgXSlo4TiEgYxckhSAlUgvERGeW83lahnmowA/fOEvBaeN?=
 =?us-ascii?Q?+nbR3O/5sWgH4LnuQ11sPUxjBTCShYGz2b9WxLG3OBxi5Hjzl6T2Zkj5yGg1?=
 =?us-ascii?Q?mdLfvI+3umLnzd0zoeAttUQ+OJofj4UDk9OEEZwzR/G3kUtgaBMic736e6ai?=
 =?us-ascii?Q?tTM935SXY/wi7VAK8SJkCMaXju37+G4TLCoVbtl87bWpcZ2XpRk3dyQrewdi?=
 =?us-ascii?Q?P8Uu0qc5MpzVR51bLzSrrPmBYXy9IJk+paWgqLoqx3ckxWcx+hgVYXBwwPaS?=
 =?us-ascii?Q?h1NgxYRi/+kzvVLGM/ilsE4rRzBeOLHmER2zKfWpDnh5hzD8ue64WUzxzWMs?=
 =?us-ascii?Q?CfcbFHze9gC7I37LM3lC0+gUDpLu1PLCdnfLg4maymJuK0IuvDtzOxTQSJ0m?=
 =?us-ascii?Q?uOjY1xF33aKB1qEpb4vWaZ+8SHwW5URYldy5AS92Lh0PQ3CkWSfFm1s5Rx1z?=
 =?us-ascii?Q?s98Kd0xGTswiBTnv/vcAF8vnwsBn2+OgApYq4aW0fQO7mh3dbVLP9PbOICN1?=
 =?us-ascii?Q?+CDVjQbNCG845bqO5K94S5gTbQN1rkAb2gldzc1HQQSuxEaDvRKubleJMWUp?=
 =?us-ascii?Q?p6DXq9/uO2CJSVzj9EC3dnQ3DI+QCTvD9Tvn+vqLURouTMm5jaTUEHkXAUsl?=
 =?us-ascii?Q?2Ec0t1ZP0CdJDiQ6PU6fWy8KZg1NBGlAbuIHKeXqfH2p+DNuOoEQB9TqQ9L9?=
 =?us-ascii?Q?5/xTEfT3ieC4Wg4ubt2MixQp2f7Sre9dfvLBB4euoA3INJOXvcbxlfGk80z4?=
 =?us-ascii?Q?YJ12aDayi18Uwl4JqjQDOeM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3736d355-3c52-4cd5-6ec4-08d9b94d0a63
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 06:44:38.8819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlTFxtu8DT4wTo27dKOWcb9AWCXICkSckVJmhMpfw729ji6bqr/AQsXx47SiLNEx4DvTXKQRM7PQaIB2S0qmPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2735
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
/drivers/net/dsa/ocelot/felix_vsc9959.c:1627:13-20:
WARNING opportunity for kmemdup
/drivers/net/dsa/ocelot/felix_vsc9959.c:1506:16-23:
WARNING opportunity for kmemdup

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9add86eda7e3..0076420308a7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1503,12 +1503,10 @@ static int vsc9959_stream_table_add(struct ocelot *ocelot,
 	struct felix_stream *stream_entry;
 	int ret;
 
-	stream_entry = kzalloc(sizeof(*stream_entry), GFP_KERNEL);
+	stream_entry = kmemdup(stream, sizeof(*stream_entry), GFP_KERNEL);
 	if (!stream_entry)
 		return -ENOMEM;
 
-	memcpy(stream_entry, stream, sizeof(*stream_entry));
-
 	if (!stream->dummy) {
 		ret = vsc9959_mact_stream_set(ocelot, stream_entry, extack);
 		if (ret) {
@@ -1624,11 +1622,10 @@ static int vsc9959_psfp_sfi_list_add(struct ocelot *ocelot,
 	struct felix_stream_filter *sfi_entry;
 	int ret;
 
-	sfi_entry = kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
+	sfi_entry = kmemdup(sfi, sizeof(*sfi_entry), GFP_KERNEL);
 	if (!sfi_entry)
 		return -ENOMEM;
 
-	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
 	refcount_set(&sfi_entry->refcount, 1);
 
 	ret = vsc9959_psfp_sfi_set(ocelot, sfi_entry);
-- 
2.17.1

