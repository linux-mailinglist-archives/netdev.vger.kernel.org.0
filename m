Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616F746A20A
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhLFRIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:22 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:26236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241961AbhLFRCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:02:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoEn0gURckJPrm4cwL1tC44yx1BKkn/W1dl8aN1SJxd3gLRaaFT0z866i+vcszMBbJEZPMmRQbdWT/MnQfIkC+1INEhiS/OEbyKCwM+z8MZijf3KKOvSyWtUzaawuHGn0YsVclzt157Zh9WJJ1Bbk+NtOefhaVkYk3Psztd0lTaIUmcdzdxx6dpGOrPoXdWBTWe53IgaBZZdkHd6BjrFpK+O+MqhyzxRICpt6bSyhTKIQXM2q99DNYsl4mStyFawRzIQ8EWGNFtH9LXoYdRdsSHxrupT91vgBxSa30WaGSTuS/5u9URoeBIvBtWrNJuANQkx7ft3ii9wTYqIcz5h7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phoA3JDmzLfj1y5UStSsHdmgyeRf9SSgtxhXwzG4mpk=;
 b=j0dLNHxbmAYBiBAd4nDpIHZGh4gEqcvH9RJBAoHfO0qqxji3hbckK/BMreqCXQROaT/qZvylt7dSTKmHcrsDgvordwDpKLlByAJWgjj4Cog+UiYOjhdvQhwbjkTrFdP5tYNlATswbvMWQzIS3BLh56973zRa5U6elpEkWcvhoaOYEAVu+ut+yIzUZsAtqbZeh0jTo2xlmsMkf3IDEKIAUxk41f31QsGTVpyubBkRZIz6xpS6eI/rjqDe/KPcaUorfTpWDzSNUsypx+K/grnjZlKb1RE74Rgw+AI5KYgKEH/yS5pxvcnM3oG3HHw0wOtmbagCTI/OAZaXNN92gO0p3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phoA3JDmzLfj1y5UStSsHdmgyeRf9SSgtxhXwzG4mpk=;
 b=b2qAR7a5uX8by1r2fLIyMqaiTp6xyoUdsk2eC17tCIlm/9D9gc12aAyzkMmILLPDDq3YLmr1HJWgaX6HJ7mKNKmzJRAdllxBSH0n30COwjodYdeWCKh8Wg1GcXZDrPkEeVFd8ys10CWiTzhqNblEyPGAvS/1djEVC2snug8+Ncc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:32 +0000
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
Subject: [PATCH v3 net-next 10/12] net: dsa: keep the bridge_dev and bridge_num as part of the same structure
Date:   Mon,  6 Dec 2021 18:57:56 +0200
Message-Id: <20211206165758.1553882-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4d0e3ac-0869-4955-5e1b-08d9b8d9a268
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4912EF99AFF80DF98580C9D9E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9OCgkaSR6jSgFNOSHuv3BUQ5dc9GNRF3pi1D4FpquBJShzj1lQAhXLu0LshzI6FqUFXYLe/+nTlM94OP3+XiokTb4VHYNXIIyHug1ZDLbqU3GQogHZgXryTlJKPFZtFfSjew4/fhEY5yz8IrdwU1gGkV6sHduGV7sBfIqx3gsoyEZdowx2PXf5WTVhqkpfYegI4cgqPkUJwi73eRLrgbb1QgJGnYZ4qvhTeFUHeyxp3hF/vMBp0zSVomhQ8tNfWZ515q98Vei1ZVzjQd8CRk+TM83rPMmzVQ9+ZgzlRF6MWcvzKJ+4R416kWUk707XJ+gPkQ4eyQk/ZS7APaGXAfodPwyh8CDFqEDFt05VKSUQKhHEUix9Fszngz9WeUc9lu254ufPwBDVJCrodZxys2dZGupkXv+HIbQuxyPZUXzeobZ87Sb5KD1qCPi1d6UnidptYACY2jvn4w/ZfhvUwfPnrmMYiNuGPU9hWsFG7WJQF29P1TW6SRkcGYTTAVoc9qB6xK4GasqzkGIEl12hzDCgU9Oa2oCMvp0hN97IQQsKrhlHcxNNaDtD+fiEJYReeL18bL4dS1ESe7ZokuoiboIG85klkqk2Vc0CNFjcL4hY4UyqMfPlcCupFCr4KRo9UKu11NMntidevF7/tZREpVWOixhbqZ7OQzBEQzOA/0ri28b29BOQBa+Zq7k1y++PfXMZAvu6mEXuh+uO/nL7yzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(30864003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(66574015)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEQ5b25JM2N3VldXTkFKNzI1am1ZYjJzcE8xQUNrdzI0Q3dSZUxrbDRYTExI?=
 =?utf-8?B?NnZ4U211U2Z5OEJvbFY4SEg1MjBFSVpBMUFmZStkN0ptTGQ3NnBsVzFOdzZC?=
 =?utf-8?B?TzFlWG9BUW43U3gvNVVUUTMzbmxvcUgvZGJJWW9ENjk4UEVrMzdQbEZOclFr?=
 =?utf-8?B?cDYxYmovbUJoNjBsSy92aG5vZVR1MTc2cjRWMjkra1grQXNLczYzZlhXcW5a?=
 =?utf-8?B?TVh2aG83NTFJby9UeTFwRzMvVDRTeUdzQUlTVEFmcmR1TkhqQkd5eWJpK3Qr?=
 =?utf-8?B?d3NNY1FKcnNkVkNPVnVXQkFaSE5sLzZpT0t0T1d6LzBTTHNxTUNoUTNLUG50?=
 =?utf-8?B?OHZlR1pxS05wL3p0MmszTHFEdnV2N3h0WEZkMzZ2VHJFbHFGa3NQV0o0UXF4?=
 =?utf-8?B?RzBWN1VmZ1dxQmdDa1Q2WThMZE5qMUZaUVJoUWl6UHcveko2SWlsbWNQUGdt?=
 =?utf-8?B?dzVEMkJXWTVCS2RtdVk2Z3pFeTArSm1FMlFaelduMlFGTkJ4clFlK29INGpz?=
 =?utf-8?B?QlRlRlVmdkpXVmVlK29DQzhWdkMybHhWY200RGN0dTlic0xyeU12NTNINTl5?=
 =?utf-8?B?QjNwbnZFWnlvb3RxRFo5OFNLb3YvbllvK0JPODZ3bFNpZ1luS2R1ejBaejdM?=
 =?utf-8?B?a0V1QU1BNnh0VHdwVUpxYnNBeVJhcGxoNlJHVGFJN0VXLzJPY3VoVE9PK2Vj?=
 =?utf-8?B?NVN5dVFvRS94bkV5TjhmSlRjQUhubDQxZmc1Qk9tWE1wNFZTS2NHT0VJN1Vr?=
 =?utf-8?B?NE1rNTcwbDZlQ3lqczQ3YUd6UzVoNDhKWXRpU2pVdXd5dFdPQ211cnF5aFVj?=
 =?utf-8?B?MzhKN1BPL3pXYzhzMmFZMU1LN2V3ZEZxbDRsSjdvNTQvOWtnQnBjWTlacVVM?=
 =?utf-8?B?TkVTbC9WQ1poKzdhbjhPOUdOa3czM2JlUkJMTHRuZWZqbWM4blQyV3hKVWJn?=
 =?utf-8?B?YzVuMnpwSUg3TEExZEFYZjZtR1NmL1R1VEVoUkYzeDFwSmRWRDlUTWVVQm1L?=
 =?utf-8?B?Q1VoSTh6OUMxSDAxemN3ZjFVdTVmb081Um5qSkxia3MyUFM0NXllUFkrZitX?=
 =?utf-8?B?SkU3WXptbjhSVC9MdEhidDNDSkZkRWsvVjhPYTRuYU1xenY1b3RBN1VlYTE3?=
 =?utf-8?B?SnZEek94aGFhWDhEMHZqd3pVaWZQSVo2bzd5R0pMZ3lnNTl4OHcxaWptZVJB?=
 =?utf-8?B?c3loQTZMQW1VMkJJREU4czJaajMrellpT3QrdXJsTXpteFBsZ0p0SDVNMEpC?=
 =?utf-8?B?VW5yTldVLzNiL1c4SnVUQVByTmZJUlEvMFo4YUlKM2drcnBOekJESG1mSUlV?=
 =?utf-8?B?S09RNEFLbytUZWlkNFhiQitqMloyVE5TM2dIbGlnME84dkp4QjBqVHU2Tmcz?=
 =?utf-8?B?L29SbnhsbHoyRUZBRDNvSjQ2Z3BrMVYyQ21ZTkVTcGp4MzVhSmxybmtBR3M1?=
 =?utf-8?B?WDg3S2FZdFdCd3JPZjVXdlppekh3UGE2OTBlODdmVzlSVTdjUk0yRjN1UDI0?=
 =?utf-8?B?bHA1NzBDQ1JGaXZZdm45bTBIKyt4RFUyV2Y1a0FqTVppN1VJTmJnZ1pjcGp2?=
 =?utf-8?B?MkFGc0xoT3pxQk8xeTdia2ozUFpUYnNQeThXZ2NMRmRxUXZnaXF5djZZWDcv?=
 =?utf-8?B?ell5ZnkyQTEwa0xzS2RkY1NGcWNUTjJ5RDlPenlJcjBvaEdpZ2F2WEdoNVF0?=
 =?utf-8?B?aERxaUNoMG5mem9vcUZ3MzU3eFhZTWxBcy9mKytVTzZEZ1JVWkZsdG1QeGVw?=
 =?utf-8?B?SG9zOGVFUmRhSFFuMTJyaDRXMWVWQTI2L2ljam9OdFc2ZVQrNVhickE5QlZz?=
 =?utf-8?B?b01WaWNzOEVrd1htOHZZeWYwS2YxdTYyZVBHUzJtUzFVUkJ5bHk2S0orWVBl?=
 =?utf-8?B?N3FvV2RSRnNreVVwYjVNMktGR3lmS0swNzFjNEMvRFhBOFY5QkpzaGwvU2xJ?=
 =?utf-8?B?R0JsR2hYNTFBL09FQWtFdkhySTJ3NWFXYjB1VCtraFZBU2NIQjlBY2lHM1RW?=
 =?utf-8?B?d0UxYUpkbTFhNTUxeEs0VTlVanIzK1YyRmxYbmlyMTJOb2QzNHhkVEJ0WWJW?=
 =?utf-8?B?N21Tb2ZrdlMyOU1ZMThZMzh3K29lL2tVaXdRL1ViTWI3T2g5Zy9QelV4WGc2?=
 =?utf-8?B?NEwySDhzeE5XNHlKTXFuQXZBeEFQOE5SS2tFU3lwNWk0blJJaEcxcU14dVNh?=
 =?utf-8?Q?KL7WouMuL2BwYA+8ZxaHXm4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d0e3ac-0869-4955-5e1b-08d9b8d9a268
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:32.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JuTgvfdZ7i9eynRN21EztA0cfWFVgHA4U9a9w4ypadvRKXFnJM9k9u/1drtHM6SlmKFjfU4zFooOdE+p9pWiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main desire behind this is to provide coherent bridge information to
the fast path without locking.

For example, right now we set dp->bridge_dev and dp->bridge_num from
separate code paths, it is theoretically possible for a packet
transmission to read these two port properties consecutively and find a
bridge number which does not correspond with the bridge device.

Another desire is to start passing more complex bridge information to
dsa_switch_ops functions. For example, with FDB isolation, it is
expected that drivers will need to be passed the bridge which requested
an FDB/MDB entry to be offloaded, and along with that bridge_dev, the
associated bridge_num should be passed too, in case the driver might
want to implement an isolation scheme based on that number.

We already pass the {bridge_dev, bridge_num} pair to the TX forwarding
offload switch API, however we'd like to remove that and squash it into
the basic bridge join/leave API. So that means we need to pass this
pair to the bridge join/leave API.

During dsa_port_bridge_leave, first we unset dp->bridge_dev, then we
call the driver's .port_bridge_leave with what used to be our
dp->bridge_dev, but provided as an argument.

When bridge_dev and bridge_num get folded into a single structure, we
need to preserve this behavior in dsa_port_bridge_leave: we need a copy
of what used to be in dp->bridge.

Switch drivers check bridge membership by comparing dp->bridge_dev with
the provided bridge_dev, but now, if we provide the struct dsa_bridge as
a pointer, they cannot keep comparing dp->bridge to the provided
pointer, since this only points to an on-stack copy. To make this
obvious and prevent driver writers from forgetting and doing stupid
things, in this new API, the struct dsa_bridge is provided as a full
structure (not very large, contains an int and a pointer) instead of a
pointer. An explicit comparison function needs to be used to determine
bridge membership: dsa_port_offloads_bridge().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2->v3:
- rebase on top of mt7530 and mv88e6xxx changes
v1->v2:
- don't call dsa_bridge_num_find() from dsa_bridge_num_put(), it isn't
  needed, as pointed out by Alvin. Also add a comment to clarify why.

 drivers/net/dsa/b53/b53_common.c       |  8 +--
 drivers/net/dsa/b53/b53_priv.h         |  4 +-
 drivers/net/dsa/dsa_loop.c             |  8 +--
 drivers/net/dsa/hirschmann/hellcreek.c |  4 +-
 drivers/net/dsa/lan9303-core.c         |  4 +-
 drivers/net/dsa/lantiq_gswip.c         | 14 +++---
 drivers/net/dsa/microchip/ksz_common.c |  4 +-
 drivers/net/dsa/microchip/ksz_common.h |  4 +-
 drivers/net/dsa/mt7530.c               |  8 +--
 drivers/net/dsa/mv88e6xxx/chip.c       | 26 +++++-----
 drivers/net/dsa/ocelot/felix.c         |  8 +--
 drivers/net/dsa/qca8k.c                | 12 ++---
 drivers/net/dsa/rtl8366rb.c            |  8 +--
 drivers/net/dsa/sja1105/sja1105_main.c | 12 ++---
 drivers/net/dsa/xrs700x/xrs700x.c      | 10 ++--
 include/linux/dsa/8021q.h              |  7 ++-
 include/net/dsa.h                      | 34 ++++++++-----
 net/dsa/dsa2.c                         | 43 ++++++++++------
 net/dsa/dsa_priv.h                     | 10 ++--
 net/dsa/port.c                         | 70 ++++++++++++++------------
 net/dsa/slave.c                        |  2 +-
 net/dsa/switch.c                       | 13 ++---
 net/dsa/tag_8021q.c                    | 12 ++---
 23 files changed, 177 insertions(+), 148 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d5e78f51f42d..4e41b1a63108 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1860,7 +1860,7 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
@@ -1887,7 +1887,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
 	b53_for_each_port(dev, i) {
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		/* Add this local port to the remote port VLAN control
@@ -1911,7 +1911,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 }
 EXPORT_SYMBOL(b53_br_join);
 
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
+void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan *vl = &dev->vlans[0];
@@ -1923,7 +1923,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_for_each_port(dev, i) {
 		/* Don't touch the remaining ports */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), &reg);
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 579da74ada64..ee17f8b516ca 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,8 +324,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
+void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
 int b53_br_flags_pre(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index e638e3eea911..70db3a9aa355 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,19 +167,19 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct net_device *bridge)
+				     struct dsa_bridge bridge)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
-		__func__, port, bridge->name);
+		__func__, port, bridge.dev->name);
 
 	return 0;
 }
 
 static void dsa_loop_port_bridge_leave(struct dsa_switch *ds, int port,
-				       struct net_device *bridge)
+				       struct dsa_bridge bridge)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
-		__func__, port, bridge->name);
+		__func__, port, bridge.dev->name);
 }
 
 static void dsa_loop_port_stp_state_set(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 86839b43011b..c8dc83c69147 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,7 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
@@ -691,7 +691,7 @@ static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct dsa_bridge bridge)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 1c2bdcde6979..29d909484275 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct net_device *br)
+				    struct dsa_bridge bridge)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1117,7 +1117,7 @@ static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void lan9303_port_bridge_leave(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 6317d0ae42d0..1f59fefc29c1 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,16 +1146,17 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct net_device *bridge)
+				  struct dsa_bridge bridge)
 {
+	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
 	/* When the bridge uses VLAN filtering we have to configure VLAN
 	 * specific bridges. No bridge is configured here.
 	 */
-	if (!br_vlan_enabled(bridge)) {
-		err = gswip_vlan_add_unaware(priv, bridge, port);
+	if (!br_vlan_enabled(br)) {
+		err = gswip_vlan_add_unaware(priv, br, port);
 		if (err)
 			return err;
 		priv->port_vlan_filter &= ~BIT(port);
@@ -1166,8 +1167,9 @@ static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
-				    struct net_device *bridge)
+				    struct dsa_bridge bridge)
 {
+	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
 
 	gswip_add_single_port_br(priv, port, true);
@@ -1175,8 +1177,8 @@ static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
 	/* When the bridge uses VLAN filtering we have to configure VLAN
 	 * specific bridges. No bridge is configured here.
 	 */
-	if (!br_vlan_enabled(bridge))
-		gswip_vlan_remove(priv, bridge, port, 0, true, false);
+	if (!br_vlan_enabled(br))
+		gswip_vlan_remove(priv, br, port, 0, true, false);
 }
 
 static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index cebcb73cda76..40d6e3f4deb5 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -192,7 +192,7 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br)
+			 struct dsa_bridge bridge)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
@@ -203,7 +203,7 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
 
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br)
+			   struct dsa_bridge bridge)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * forwarding state so there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 54b456bc8972..88e5a5d56219 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -155,9 +155,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br);
+			 struct dsa_bridge bridge);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br);
+			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 73c9f79f9e9f..5b74c542b1e6 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct net_device *bridge)
+			struct dsa_bridge bridge)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
@@ -1204,7 +1204,7 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 		 * same bridge. If the port is disabled, port matrix is kept
 		 * and not being setup until the port becomes enabled.
 		 */
-		if (dsa_port_bridge_dev_get(other_dp) != bridge)
+		if (!dsa_port_offloads_bridge(other_dp, &bridge))
 			continue;
 
 		if (priv->ports[other_port].enable)
@@ -1303,7 +1303,7 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 
 static void
 mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
-			 struct net_device *bridge)
+			 struct dsa_bridge bridge)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	struct mt7530_priv *priv = ds->priv;
@@ -1320,7 +1320,7 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
 		 */
-		if (dsa_port_bridge_dev_get(other_dp) != bridge)
+		if (!dsa_port_offloads_bridge(other_dp, &bridge))
 			continue;
 
 		if (priv->ports[other_port].enable)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5afc7a1c0dbb..aa5c5d4950d8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2410,7 +2410,7 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
-				struct net_device *br)
+				struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
@@ -2418,7 +2418,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	int err;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_bridge_dev_get(dp) == br) {
+		if (dsa_port_offloads_bridge(dp, &bridge)) {
 			if (dp->ds == ds) {
 				/* This is a local bridge group member,
 				 * remap its Port VLAN Map.
@@ -2442,14 +2442,14 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_bridge_map(chip, br);
+	err = mv88e6xxx_bridge_map(chip, bridge);
 	if (err)
 		goto unlock;
 
@@ -2464,14 +2464,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mv88e6xxx_bridge_map(chip, br) ||
+	if (mv88e6xxx_bridge_map(chip, bridge) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
 
@@ -2486,7 +2486,7 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
-					   int port, struct net_device *br)
+					   int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2503,7 +2503,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 					     int tree_index, int sw_index,
-					     int port, struct net_device *br)
+					     int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
@@ -2535,19 +2535,17 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
 }
 
 static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
-	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 }
 
 static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					      struct net_device *br,
-					      unsigned int bridge_num)
+					      struct dsa_bridge bridge)
 {
 	int err;
 
-	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 	if (err) {
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
 			ERR_PTR(err));
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0e102caddb73..e563bafca74f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -706,21 +706,21 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct net_device *br)
+			     struct dsa_bridge bridge)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_join(ocelot, port, br);
+	ocelot_port_bridge_join(ocelot, port, bridge.dev);
 
 	return 0;
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct dsa_bridge bridge)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_leave(ocelot, port, br);
+	ocelot_port_bridge_leave(ocelot, port, bridge.dev);
 }
 
 static int felix_lag_join(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7053a3510d71..dc983f79f0d6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1810,8 +1810,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
 }
 
-static int
-qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
+static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+				  struct dsa_bridge bridge)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
@@ -1823,7 +1823,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
@@ -1844,8 +1844,8 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	return ret;
 }
 
-static void
-qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
+static void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+				    struct dsa_bridge bridge)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int cpu_port, i;
@@ -1855,7 +1855,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b6f277a04989..fac2333a3f5e 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1186,7 +1186,7 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
-			   struct net_device *bridge)
+			   struct dsa_bridge bridge)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
@@ -1198,7 +1198,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Join this port to each other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
@@ -1218,7 +1218,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 
 static void
 rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
-			    struct net_device *bridge)
+			    struct dsa_bridge bridge)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
@@ -1230,7 +1230,7 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Remove this port from any other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5e03eda4c16f..24584fe2e760 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1980,7 +1980,7 @@ static int sja1105_manage_flood_domains(struct sja1105_private *priv)
 }
 
 static int sja1105_bridge_member(struct dsa_switch *ds, int port,
-				 struct net_device *br, bool member)
+				 struct dsa_bridge bridge, bool member)
 {
 	struct sja1105_l2_forwarding_entry *l2_fwd;
 	struct sja1105_private *priv = ds->priv;
@@ -2005,7 +2005,7 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 		 */
 		if (i == port)
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		sja1105_port_allow_traffic(l2_fwd, i, port, member);
 		sja1105_port_allow_traffic(l2_fwd, port, i, member);
@@ -2074,15 +2074,15 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct dsa_bridge bridge)
 {
-	return sja1105_bridge_member(ds, port, br, true);
+	return sja1105_bridge_member(ds, port, bridge, true);
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *br)
+				 struct dsa_bridge bridge)
 {
-	sja1105_bridge_member(ds, port, br, false);
+	sja1105_bridge_member(ds, port, bridge, false);
 }
 
 #define BYTES_PER_KBIT (1000LL / 8)
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 7c2b6c32242d..ebb55dfd9c4e 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -501,7 +501,7 @@ static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
-				 struct net_device *bridge, bool join)
+				 struct dsa_bridge bridge, bool join)
 {
 	unsigned int i, cpu_mask = 0, mask = 0;
 	struct xrs700x *priv = ds->priv;
@@ -513,14 +513,14 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 
 		cpu_mask |= BIT(i);
 
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) == bridge)
+		if (dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		mask |= BIT(i);
 	}
 
 	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		/* 1 = Disable forwarding to the port */
@@ -540,13 +540,13 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *bridge)
+			       struct dsa_bridge bridge)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
 
 static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *bridge)
+				 struct dsa_bridge bridge)
 {
 	xrs700x_bridge_common(ds, port, bridge, false);
 }
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0af4371fbebb..939a1beaddf7 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -7,6 +7,7 @@
 
 #include <linux/refcount.h>
 #include <linux/types.h>
+#include <net/dsa.h>
 
 struct dsa_switch;
 struct dsa_port;
@@ -37,12 +38,10 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					unsigned int bridge_num);
+					struct dsa_bridge bridge);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num);
+					   struct dsa_bridge bridge);
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 899e13d56fc2..b9789c0cd5e3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -219,6 +219,11 @@ struct dsa_mall_tc_entry {
 	};
 };
 
+struct dsa_bridge {
+	struct net_device *dev;
+	unsigned int num;
+	refcount_t refcount;
+};
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -256,8 +261,7 @@ struct dsa_port {
 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
 	bool			learning;
 	u8			stp_state;
-	struct net_device	*bridge_dev;
-	unsigned int		bridge_num;
+	struct dsa_bridge	*bridge;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -588,7 +592,7 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		return NULL;
 
 	if (dp->lag_dev)
@@ -602,12 +606,12 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 static inline struct net_device *
 dsa_port_bridge_dev_get(const struct dsa_port *dp)
 {
-	return dp->bridge_dev;
+	return dp->bridge ? dp->bridge->dev : NULL;
 }
 
 static inline unsigned int dsa_port_bridge_num_get(struct dsa_port *dp)
 {
-	return dp->bridge_num;
+	return dp->bridge ? dp->bridge->num : 0;
 }
 
 static inline bool dsa_port_bridge_same(const struct dsa_port *a,
@@ -636,6 +640,12 @@ dsa_port_offloads_bridge_dev(struct dsa_port *dp,
 	return dsa_port_bridge_dev_get(dp) == bridge_dev;
 }
 
+static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
+					    const struct dsa_bridge *bridge)
+{
+	return dsa_port_bridge_dev_get(dp) == bridge->dev;
+}
+
 /* Returns true if any port of this tree offloads the given net_device */
 static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 						 const struct net_device *dev)
@@ -812,17 +822,15 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct net_device *bridge);
+				    struct dsa_bridge bridge);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
-				     struct net_device *bridge);
+				     struct dsa_bridge bridge);
 	/* Called right after .port_bridge_join() */
 	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
-					      struct net_device *bridge,
-					      unsigned int bridge_num);
+					      struct dsa_bridge bridge);
 	/* Called right before .port_bridge_leave() */
 	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
-						struct net_device *bridge,
-						unsigned int bridge_num);
+						struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
@@ -894,10 +902,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
 					 int sw_index, int port,
-					 struct net_device *br);
+					 struct dsa_bridge bridge);
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
-					  struct net_device *br);
+					  struct dsa_bridge bridge);
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4901cdc264ee..8814fa0e44c8 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -129,20 +129,29 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
 	}
 }
 
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_bridge_dev_get(dp) == br)
+			return dp->bridge;
+
+	return NULL;
+}
+
 static int dsa_bridge_num_find(const struct net_device *bridge_dev)
 {
 	struct dsa_switch_tree *dst;
-	struct dsa_port *dp;
 
-	/* When preparing the offload for a port, it will have a valid
-	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
-	 * However there might be other ports having the same dp->bridge_dev
-	 * and a valid dp->bridge_num, so just ignore this port.
-	 */
-	list_for_each_entry(dst, &dsa_tree_list, list)
-		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->bridge_dev == bridge_dev && dp->bridge_num)
-				return dp->bridge_num;
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		struct dsa_bridge *bridge;
+
+		bridge = dsa_tree_bridge_find(dst, bridge_dev);
+		if (bridge)
+			return bridge->num;
+	}
 
 	return 0;
 }
@@ -151,6 +160,12 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 {
 	unsigned int bridge_num = dsa_bridge_num_find(bridge_dev);
 
+	/* Switches without FDB isolation support don't get unique
+	 * bridge numbering
+	 */
+	if (!max)
+		return 0;
+
 	if (!bridge_num) {
 		/* First port that requests FDB isolation or TX forwarding
 		 * offload for this bridge
@@ -170,11 +185,11 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num)
 {
-	/* Check if the bridge is still in use, otherwise it is time
-	 * to clean it up so we can reuse this bridge_num later.
+	/* Since we refcount bridges, we know that when we call this function
+	 * it is no longer in use, so we can just go ahead and remove it from
+	 * the bit mask.
 	 */
-	if (!dsa_bridge_num_find(bridge_dev))
-		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
+	clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b4f9df4e38b2..da6ff99ba5ed 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -52,7 +52,7 @@ struct dsa_notifier_ageing_time_info {
 
 /* DSA_NOTIFIER_BRIDGE_* */
 struct dsa_notifier_bridge_info {
-	struct net_device *br;
+	struct dsa_bridge bridge;
 	int tree_index;
 	int sw_index;
 	int port;
@@ -374,7 +374,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 		if (dp->type != DSA_PORT_TYPE_USER)
 			continue;
 
-		if (!dp->bridge_dev)
+		if (!dp->bridge)
 			continue;
 
 		if (dp->stp_state != BR_STATE_LEARNING &&
@@ -403,7 +403,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 /* If the ingress port offloads the bridge, we mark the frame as autonomously
  * forwarded by hardware, so the software bridge doesn't forward in twice, back
  * to us, because we already did. However, if we're in fallback mode and we do
- * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * software bridging, we are not offloading it, therefore the dp->bridge
  * pointer is not populated, and flooding needs to be done by software (we are
  * effectively operating in standalone ports mode).
  */
@@ -411,7 +411,7 @@ static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
 
-	skb->offload_fwd_mark = !!(dp->bridge_dev);
+	skb->offload_fwd_mark = !!(dp->bridge);
 }
 
 /* Helper for removing DSA header tags from packets in the RX path.
@@ -508,6 +508,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f6ea41cbcdd5..fbf2d7fc5c91 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -130,7 +130,7 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 			return err;
 	}
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		dsa_port_set_state_now(dp, BR_STATE_FORWARDING, false);
 
 	if (dp->pl)
@@ -158,7 +158,7 @@ void dsa_port_disable_rt(struct dsa_port *dp)
 	if (dp->pl)
 		phylink_stop(dp->pl);
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		dsa_port_set_state_now(dp, BR_STATE_DISABLED, false);
 
 	if (ds->ops->port_disable)
@@ -271,36 +271,32 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 }
 
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct net_device *bridge_dev,
-					     unsigned int bridge_num)
+					     struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge.num)
 		return;
 
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
 	 */
-	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge_dev,
-					      bridge_num);
+	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge);
 }
 
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct net_device *bridge_dev,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	/* FDB isolation is required for TX forwarding offload */
-	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge.num)
 		return false;
 
 	/* Notify the driver */
-	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
-						  bridge_num);
+	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge);
 
 	return err ? false : true;
 }
@@ -310,21 +306,32 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 				  struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	unsigned int bridge_num;
+	struct dsa_bridge *bridge;
 
-	dp->bridge_dev = br;
-
-	if (!ds->max_num_bridges)
+	bridge = dsa_tree_bridge_find(ds->dst, br);
+	if (bridge) {
+		refcount_inc(&bridge->refcount);
+		dp->bridge = bridge;
 		return 0;
+	}
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return -ENOMEM;
+
+	refcount_set(&bridge->refcount, 1);
+
+	bridge->dev = br;
 
-	bridge_num = dsa_bridge_num_get(br, ds->max_num_bridges);
-	if (!bridge_num) {
+	bridge->num = dsa_bridge_num_get(br, ds->max_num_bridges);
+	if (ds->max_num_bridges && !bridge->num) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Range of offloadable bridges exceeded");
+		kfree(bridge);
 		return -EOPNOTSUPP;
 	}
 
-	dp->bridge_num = bridge_num;
+	dp->bridge = bridge;
 
 	return 0;
 }
@@ -332,16 +339,17 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 static void dsa_port_bridge_destroy(struct dsa_port *dp,
 				    const struct net_device *br)
 {
-	struct dsa_switch *ds = dp->ds;
+	struct dsa_bridge *bridge = dp->bridge;
+
+	dp->bridge = NULL;
 
-	dp->bridge_dev = NULL;
+	if (!refcount_dec_and_test(&bridge->refcount))
+		return;
 
-	if (ds->max_num_bridges) {
-		int bridge_num = dp->bridge_num;
+	if (bridge->num)
+		dsa_bridge_num_put(br, bridge->num);
 
-		dp->bridge_num = 0;
-		dsa_bridge_num_put(br, bridge_num);
-	}
+	kfree(bridge);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -351,7 +359,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.br = br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
@@ -367,12 +374,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 
 	brport_dev = dsa_port_to_bridge_port(dp);
 
+	info.bridge = *dp->bridge;
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
-							dsa_port_bridge_num_get(dp));
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, info.bridge);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -415,12 +422,11 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
-	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.br = br,
+		.bridge = *dp->bridge,
 	};
 	int err;
 
@@ -429,7 +435,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
+	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a4c31cce80d..88f7b8686dac 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1564,7 +1564,7 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 	if (!dp->ds->mtu_enforcement_ingress)
 		return;
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		return;
 
 	INIT_LIST_HEAD(&hw_port_list);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 7993192fe769..cd0630dd5417 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->br);
+		err = ds->ops->port_bridge_join(ds, info->port, info->bridge);
 		if (err)
 			return err;
 	}
@@ -104,7 +104,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	    ds->ops->crosschip_bridge_join) {
 		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
 						     info->sw_index,
-						     info->port, info->br);
+						     info->port, info->bridge);
 		if (err)
 			return err;
 	}
@@ -124,19 +124,20 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->br);
+		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
 	    ds->ops->crosschip_bridge_leave)
 		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
 						info->sw_index, info->port,
-						info->br);
+						info->bridge);
 
-	if (ds->needs_standalone_vlan_filtering && !br_vlan_enabled(info->br)) {
+	if (ds->needs_standalone_vlan_filtering &&
+	    !br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
 		vlan_filtering = true;
 	} else if (!ds->needs_standalone_vlan_filtering &&
-		   br_vlan_enabled(info->br)) {
+		   br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
 		vlan_filtering = false;
 	}
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index e9d5e566973c..27712a81c967 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -337,7 +337,7 @@ dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
 		return false;
 
 	if (dsa_port_is_user(dp))
-		return dsa_port_bridge_dev_get(dp) == info->br;
+		return dsa_port_offloads_bridge(dp, &info->bridge);
 
 	return false;
 }
@@ -410,10 +410,9 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 }
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					unsigned int bridge_num)
+					struct dsa_bridge bridge)
 {
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid,
 					   true);
@@ -421,10 +420,9 @@ int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid, true);
 }
-- 
2.25.1

