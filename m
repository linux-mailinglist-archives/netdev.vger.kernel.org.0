Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9643C46A20C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhLFRIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:24 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:26236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245416AbhLFRCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:02:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkmyH2okULvfDcweC/jTv3POrcRveUUqrEdkH2xNQGX4wIczSk2eaodvOy0mJbPpDWh1rgurrvuBzZJmlqRMF6y0oGa6370qu86/+UasLSS82vGScBKccOLEkcvaSrOnrnJ8orodU6ni93xq3xq7oavFdCy9QfhiUioX4wph/E6ezEgWNoyHyEHOiGyEFXbCpHl70jQIGPWt86JPynAkYC1oMPxFav17OQpb0paaf/vr8jKubwsVtnxT6oPJb7x8wT9d9qfH/PAxpWiM02KcC+YQZorUuluXyjI76yLAF3FScaJpuXzdU9LjlUc4gteBcMMGAQydaZZUgFu99ffeLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6ESHyL0zpYU+MGZwGKAjU/v+41/CKSkGxlRZ/6SgY4=;
 b=leLjqnrI7Jb1mQXl4/FNEgtYBphyJ1kgsL4eHbVhSXn7sT/aVdMvXDRTPR5Micl5dOby8kkohAhZ72yVwtBe665fXIMYlgLWDhwwF49kEE1wJPI+W7yy8FaSfupadQlxTYGkQdR7TCaPqCLRoJFHNhiDFxXplaG/bEpyTmN57a+O1ZseAzNqxdD/HpMg4XigCIbU1XkzmPMxbXUmyD70quEmYnwYCpXiqEue/gf+6lemIO29nyUuFjSPer2Tov3SOD16/YeW8jc320piEUi8q84M78DFUxpIFVYCVN/K9IRpbtg/viU5KX18PBLBNN2vu6VUPNELJoVSpSjVETD31w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6ESHyL0zpYU+MGZwGKAjU/v+41/CKSkGxlRZ/6SgY4=;
 b=RlMTZc7NIddUWhx0cGDt9ChjUuCVevTH0Uv56F8E405Q0f7XrNToe3iHNAuZ1+2u+2wPwv7o8fl2N1HIKaID15A2un2JQc++mEClGE2vA2CvtFLIy41kb/OazfGaeUkzH6ngdsFmsyie57IGLv1vny8MCQNyTV99N+QL9fegv4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 11/12] net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
Date:   Mon,  6 Dec 2021 18:57:57 +0200
Message-Id: <20211206165758.1553882-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a16254f-1bd2-4966-4c1f-08d9b8d9a37f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4912FB1C3F08D725F84002CAE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGSGPwhKUlYsb5+56z3VCXMpTn+5Di+vI/+GTvSgRUkHZjoDUzX+gamTgachz2SdbSNP/L/1Xln8nvyFIZaDIQMQM92TgEwUCQ2TeS2OCBYMMreb2v9Jrp9isi7DfVFTFpQwanhnuXWyQYYcVbX60nSjtW9RizdTQbUH106qL1oL51a1erX/xBrD4kds8NuGA3btZjikmAYCwGCgbvKpaj09+YyYImkJr6b50no63usKTbWF3Lu6pvL01s/Z6Lg3gpryO+ze/9yX8jUGaMjrcdztD8u7IvbLjywacozSmHbEwXSmNe3x9JsNAmsrVs6iAwJVM5I4LL9rTBkxriGjoHwwlCVDIHl/EvC8nZFigxz57sDS+dm42e+MaOK/DlOC7qgm+f08TVK3sqPSM5w5D0KphpFVDbXzhhN+f0dFhRm2uiqt+zwJ4JB0KuYhj0Uvci9q0jvIoiLY7PTuJBjMGEYr1ym2Rrm662XVhF5VfmPehOX4451yYQ1R5THclrFrv1J91IwyqmvWdJ1rj+JelcHKCMgK5eVc98h5fqzSH+g6rNwJpB37h/Ed0ST8yf9hWwfPAUpgyh7YgsZwQYPBdWpTMrBjNHEu+WVy3KmV0YxuX2Nev3tVUopvCkjiLWSIlAbscUDW+RiFaJuVCfkxzF+RgiJ94j1Vugv1NzKwrH9gZ/mmVqz6Pw9GnoQU49VJn7nQGve0gi9PARW2iGs2Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(30864003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(66574015)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzJHamxlT2R5c21OTTgzalZhT2YzZTJUcVVoWGxSUDdKZFlzVlN2bkltVTdG?=
 =?utf-8?B?Q0hSeE1TT0RHZWlCWlh6OFNiZG40TjRHQkVFZ3I4RE1INFRVTFVycE9nNmt2?=
 =?utf-8?B?aHJ4N0RGeEdKYzNINHJ0Yk1tQ1lzRlBmVWJGWTdhNlQyUUoxOHluUUlCQXdx?=
 =?utf-8?B?eDkvZGsycFFvd3l1WUFxLzFPSkpMZ3IrMGUvazRqczUyVHYrVURueFJ0SHZy?=
 =?utf-8?B?YXRzMjFGR3hzQWUxempyRzRaSHF5WHhPM3lCRzRKT1hkQlVRbmtRUUNCZWx0?=
 =?utf-8?B?LytUVmpjVE9EakszbUl0eEwyc1BMSDlMM2xVZGJ4cXNucjNjZ1ZuNXp5aFJl?=
 =?utf-8?B?UUhLZUVCTHVaWUVZOGllTVJiSk00QklFdHdJZjBlcU5xajFvaUdZWXdDZjlu?=
 =?utf-8?B?WlJ2WmVwVWpWeWgzNlp1L25RT09qemxPUEd3MXpZdTBJNTFpbGNKT3ZMbkpj?=
 =?utf-8?B?aFdQc0Y3ZVpTSStGenBxUVZOT0ZPRWhlTlRycWp5UEpTTTNNUWtXaW91WlB6?=
 =?utf-8?B?RXFVS1EwZlVMcDVGY2FUL0lCUFQ1NWxaU2owSGd5cEtpL0RnYTFjZ1lIb1h1?=
 =?utf-8?B?NS92UFhyVVNIVGdyNjdMZTNBak01K3ozSDU2cGdhWVE0Uk02SzVIMmo5ZktI?=
 =?utf-8?B?bnhPUjZSanliYkxYd1Qzcjd3MWMyV0JQUFFIUTdlbmZLd1hURlhnYmtzTUhQ?=
 =?utf-8?B?c3ZNc1NOMDJodStpdlN5M0FVTkZ1L21YQkYvZ3B0UVl4R3J4bzFBMGhQTkpz?=
 =?utf-8?B?Tm5DbFhhbVJ0SGNZOUIwUC8wMmRBamUxRUZCc3JYQ0RuOHJJU01jbExFdTZy?=
 =?utf-8?B?eWEvTjhJRy9NckN0UWk0eFRKRGVHSDVRL3NiWHNhWmpxbmpMTWdLZjRESDZL?=
 =?utf-8?B?YVJQSzVvaFROU3BOSkd0c3A2VEZ3V1BSRHVXR3VzRWFaZy9OVitGdDROR3hB?=
 =?utf-8?B?aEo3dVBvVkR1cUNsR2F0NytNRGY1OXdSbGl6SXQzK0t3dW9IbnNJVWRBT1BI?=
 =?utf-8?B?U2lwUy9wcUZ1ZFRVcFVmb1FHbFdBc3pKU3d4cjRoaXM1eS8wRHpna3BENzVP?=
 =?utf-8?B?NDhTQnRlYkFrUGl1ZlNTOURKc0NwamRRb1hkRVp5bEs4TGU3RXdZRGZ5MXNy?=
 =?utf-8?B?dk5ZM1RmdXFFRDQwTHlWTWpIUUhHL0VIOWIwdVhsOTBUemNvQ0R1dnFyR2dN?=
 =?utf-8?B?djBEMlNDRytabnB4WW4rdVM3TWtOMi91ODJvSjNkS05WeWhkR0lrMEpWcXVs?=
 =?utf-8?B?Z2F2U3ZVc0Rxd3JsWmlIUnhNcXRKTERBaGViYmFxMFFvMks4M1BKUkk1SGU2?=
 =?utf-8?B?UW1NcDBWak9Ic2p3TVJWNGFwN3JlOHJrOEE3MnM3ZzRZZ3NXWFBmMHJzTnMx?=
 =?utf-8?B?Rjd6azA5Mlc5emFwSzRITGxrd1Z1M0ZKanBSVFNxVjV5RXU1NjNLN0RTMW9Y?=
 =?utf-8?B?NVZXVi9vWVZTek1JMDV2R3BtTTF6eldrT1Q2S2t2RHVoeTkzN3R3czVrVWRj?=
 =?utf-8?B?ZjlzUkVlMU5ORnNWTFJjU1hIRlR3NjBCTGxmNzRsbW9NMFBYdlN6RkszRkRX?=
 =?utf-8?B?YmtQMTMwa1ZKWllBcWVOcGJqd1k5U2M4QU9PT3BXUnJacUpYcXVYMTVCaUdv?=
 =?utf-8?B?Zi9pZVFKVERzN0NIWW5VMFZzTjVxT3pBU2NSclVNdFc0c2M4SHEvbUxETUhO?=
 =?utf-8?B?TlVURG1IVEFnUWp3aFJISDRwbERqQU44MW55WHl4VjFkanI1eW9UYVRIRHl6?=
 =?utf-8?B?Vi9nclpsVHloWmU2ZkZmME9wT21DemR2RHpXc3hSQ0pFUU9UVklOMU8reFlo?=
 =?utf-8?B?ZlVjMEhZcXZlajJ5cUM3SGNIS2ZxQXE1bXBzdUg2MkZIQXRXNXV1dGh0RjVJ?=
 =?utf-8?B?U1JUWTcvMXRXeU5RTzFPWEpBM0ZoNTRQUlNxVmNsY2RDVlJsZHNxZkdSb042?=
 =?utf-8?B?NU5SUGRrT050ZEFzd05lMGFLeEtzaC9HRXlzRXFrZ0wyNGJnTys5UDRVYmpx?=
 =?utf-8?B?ajhHbG44MW0yRExZeDI1Myt0NU5MVW02NXpDQXhnRW1MU3ROVzR2NlNjeWhD?=
 =?utf-8?B?YlFTRWFNbnpzbDViWDhkTUpwRmZ0ektON3ZuMnY4cGhpMm4wVE9NK1l1bkQw?=
 =?utf-8?B?TGNid25rcTAyQTl3dkErR0tyQysvNFhIdjhtbmF2WWt6amxGVGRoVFB2TnVR?=
 =?utf-8?Q?LAw224Akk8L40q93ZZ/QY7U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a16254f-1bd2-4966-4c1f-08d9b8d9a37f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:34.1484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbcYeq9LGyLzgYYoSfV1WT3i5fR1XEV1hUk4nzF80FFBmWgsCQU3D5S/qv5ODb5rEVOcOCRF4x65+b5M3HcFzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch for the removal of the DSA switch methods
->port_bridge_tx_fwd_offload() and ->port_bridge_tx_fwd_unoffload().
The plan is for the switch to report whether it offloads TX forwarding
directly as a response to the ->port_bridge_join() method.

This change deals with the noisy portion of converting all existing
function prototypes to take this new boolean pointer argument.
The bool is placed in the cross-chip notifier structure for bridge join,
and a reference to it is provided to drivers. In the next change, DSA
will then actually look at this value instead of calling
->port_bridge_tx_fwd_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2->v3: added back Alvin's review tag
v1->v2: patch is kind of new, the noisy conversion from v1's patch 6/6
        has been split into a separate change. Had to drop Alvin's
        Reviewed-by tag because he technically did not review the change
        in this form.

 drivers/net/dsa/b53/b53_common.c       | 3 ++-
 drivers/net/dsa/b53/b53_priv.h         | 3 ++-
 drivers/net/dsa/dsa_loop.c             | 3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c | 3 ++-
 drivers/net/dsa/lan9303-core.c         | 3 ++-
 drivers/net/dsa/lantiq_gswip.c         | 3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 drivers/net/dsa/mt7530.c               | 2 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 3 ++-
 drivers/net/dsa/ocelot/felix.c         | 2 +-
 drivers/net/dsa/qca8k.c                | 3 ++-
 drivers/net/dsa/rtl8366rb.c            | 3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c | 3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c      | 2 +-
 include/net/dsa.h                      | 3 ++-
 net/dsa/dsa_priv.h                     | 1 +
 net/dsa/switch.c                       | 3 ++-
 18 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4e41b1a63108..3867f3d4545f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1860,7 +1860,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index ee17f8b516ca..b41dc8ac2ca8 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,7 +324,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 70db3a9aa355..33daaf10c488 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,7 +167,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct dsa_bridge bridge)
+				     struct dsa_bridge bridge,
+				     bool *tx_fwd_offload)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge.dev->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index c8dc83c69147..9eecb7529573 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 29d909484275..d55784d19fa4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,8 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge)
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 1f59fefc29c1..46ed953e787e 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,7 +1146,8 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 40d6e3f4deb5..47a856533cff 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -192,7 +192,8 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge)
+			 struct dsa_bridge bridge,
+			 bool *tx_fwd_offload)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 88e5a5d56219..df8ae59c8525 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -155,7 +155,7 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge);
+			 struct dsa_bridge bridge, bool *tx_fwd_offload);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5b74c542b1e6..b82512e5b33b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct dsa_bridge bridge)
+			struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index aa5c5d4950d8..c49abfb83cf2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2442,7 +2442,8 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e563bafca74f..f76dcf0d369f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -706,7 +706,7 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct dsa_bridge bridge)
+			     struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index dc983f79f0d6..039694518788 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1811,7 +1811,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 }
 
 static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index fac2333a3f5e..ecc19bd5115f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1186,7 +1186,8 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
-			   struct dsa_bridge bridge)
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 24584fe2e760..21622c60faab 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2074,7 +2074,8 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge,
+			       bool *tx_fwd_offload)
 {
 	return sja1105_bridge_member(ds, port, bridge, true);
 }
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index ebb55dfd9c4e..35fa19ddaf19 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -540,7 +540,7 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b9789c0cd5e3..584b3f9462a0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -822,7 +822,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge);
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge);
 	/* Called right after .port_bridge_join() */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index da6ff99ba5ed..38ce5129a33d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -56,6 +56,7 @@ struct dsa_notifier_bridge_info {
 	int tree_index;
 	int sw_index;
 	int port;
+	bool tx_fwd_offload;
 };
 
 /* DSA_NOTIFIER_FDB_* */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index cd0630dd5417..9c92edd96961 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->bridge);
+		err = ds->ops->port_bridge_join(ds, info->port, info->bridge,
+						&info->tx_fwd_offload);
 		if (err)
 			return err;
 	}
-- 
2.25.1

