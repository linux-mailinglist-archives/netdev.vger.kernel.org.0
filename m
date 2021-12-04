Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7757C468767
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237873AbhLDUPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:39 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhLDUPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/QkRQhq5PEs+po/81wLpiD3HtHGpeRDgBdzFoZY+hdFWwzBMcGMP380XiIIFOYnyzi2mUJGkcfDNWnxXxWICNuR7TmDWMToBoGLcyoFEVkSZuw9J4mpXv+f4FEHaJhnqbyGQDCkaI/3/ofH4XKF5xTLtFxbvsAaThIx+Qq8hBbgmWwAy7qUxR3+n2ULfoeYvW4q3DVBvxJViRZBnJCexwqXrg8kvrFSahC8ZdHBw5y/JJFJdMoKgn0Tb04+tWK1g1yHLYfEfFGJtyTs2w117apqZZdWWZa4syX6ziapylLiWAbKXMkzMQu+CbDSPzMSWo7Sr6vL965DI4DfjgF0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2cVk7C22s1tpw+8KySUBkpuO4Nw0Nf+Z7jD8vftZKs=;
 b=gKwGag7W6MVhyQxekMzPGw8c+XRGp9Y6uNOzLPvAcf4lg25OygBF1V3B4Zgbq7bnS8h8Xja+ZYilg8Gjwan6ctYKyNobu6JYAOHm8DccZf4Q5LWJXAeHzjIp38csz1IMJj+ePn/yoVS/dgYEaDmaEcGWEnavn5kpfwhneFyj5g+2/TO2F2RcOyYM0qvuMzcpGl2vDyzSwKOKOhWA17wQwnMhRON7o3ulJE95GG4XgWUxz+j1It8RuAND4SNoMyZAolNtD/6kWEF6SeMyHHJyXVR2WhXY74HRENXCYWQe9R/4L4gNJArRpuRtjc2luYcGzV6wcwtWac2B6wlV6YMYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2cVk7C22s1tpw+8KySUBkpuO4Nw0Nf+Z7jD8vftZKs=;
 b=S/DHaHko4h8ZXcTTVG2013/9yi9jjVQWGcpUibpPGFVm2keHIg+XxxoutcfiGvR38p85GFhozNYO8rgnqrxf6MgF+TSoJFs+mqCmiq1wMfkLFiIyr6JDACHyjW2mDXwQc8dHzwMw/xUfCnrkOJNLiyLceXclv61CQ3g6KPshY58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:04 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:04 +0000
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
Subject: [PATCH v2 net-next 5/7] net: dsa: keep the bridge_dev and bridge_num as part of the same structure
Date:   Sat,  4 Dec 2021 22:11:44 +0200
Message-Id: <20211204201146.4088103-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:12:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06537d09-a10e-4964-9450-08d9b76256cd
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB365198462776C3718006AFB0E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvmqTXZNldCoRTFUOcM9ce3mh5WsK05jyi9hSiv96D1DKDq9v6n2el11kvZpRIv3O/9c6owKR3bdmPfLFVftNJ+tZPsg/qmG1ZxgV3R/bWzCRwwM6RSslKfT3OinfetmWyl2PrzqhNog4Sny9OO5kHNBH1te4UQIo8paYSAiPRLY1k2fjELzBSVdkJqXkgsQCcr3wlQE3BnF+u1tgTwX3WFggkGmdaXN54PKht0obNfm5qRgu+FVbT/7v90xDQxdkwaReF/IHthaQ5u2tQHBrO5Lhbqf3zr1mC21Hx5Hv/D8yKP/OhzMKTKFMmy2ynJE7A5AN0p9u6cJDBDngMbtxFG4PoNsESJi5a6p+cTZH6N7yli+CS/WsGZhZIQvPe+C9KcM2WCZ5J16+DGf84X+Vn1atWWklqfL9ZNItZbXO0LdPqfACtSuaf5KeKNOweTVTSQmjRvMNKaXALiQ6ym0ISznrBJuJKiWamNabswtBaLsZcGus6K+XvQiTfw4xzD0ka3mL3HceOsvpgV4NOIAluRSQ7bzVyUZbOLS9NEx6I/BxuuTkkkmG/8ROt2tE0zleEGa47f9hoINC213nT1DMXHfPDG5lIGz3c2pNHqhjbKhzCNeDvzN6TK01L4fWZGvwupD+fmnSBm6mUrvfPs6tqgZMfZ6v51Phy9xKUz1F8NXhx0XNiB1mer3PqZ7wwoxnB/7AHsUr6L8tjmXpbT6cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(30864003)(38100700002)(66574015)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW5peXdhZ0l2elZwYTNQY2FEMlpZVE80bkVrS0tkMVphNmNWYUdpbTJXN25R?=
 =?utf-8?B?T2pFOUlINjd0NnpyUHlndmY3ZERBd3hZUmtsQ1ZNSHk3Zzc3T2JqZk96bVhF?=
 =?utf-8?B?Sk9QYzhDbTAzMUs4VWI5VkJaeHduRStESUdWSm9FL0FuOHlmV0RFcXBYL1Rw?=
 =?utf-8?B?VXF5TWFsQ2RxL1JST3Q0MVZUMWFMZGR3WUxLK1BScUt3aHFjdnpmSTlvcU0r?=
 =?utf-8?B?Qzlia2tUdEUzczFHcE5TRUNOL0NaSGFuVjRkeDJIWm95dm81THM1cXdCTHBH?=
 =?utf-8?B?S1o1SFllUmNoNjBCVVdacVNFVGtDb09yRVlmU2RNU0JUaTFjQUpaNjR6VTd3?=
 =?utf-8?B?VTd6dG1MRTBRZkNXM00yejkraGYrczEySlNLVjByYVNlVVJhODd3bjZpWUgw?=
 =?utf-8?B?RHF4eWNiRkNrYzhtcGwxV3pEYm5xL3o1cXY2blIvL09COW00QjBvRGZVVHNC?=
 =?utf-8?B?RnhKMzZqQ243Y2FnYm5xYkRUUFNRQWdQSE5YVS91cEtvUnNndnRhRTNRMkZv?=
 =?utf-8?B?UHZZbGJGa0dWODZXa2lnd1R6bHMzZHo4UE5zWnV0d1F1NWVUY2czZEp3ZzIr?=
 =?utf-8?B?WDdoZTBnblh2b0FhMENyWmp4L25uZzVnK01xVzZxcHBMSEdPOUtMbFowRCtQ?=
 =?utf-8?B?NFRMYWJLZm5HOGlGVUNFUytGaGR3M2dWekY4NUQ1UElPVHgzbnJJeW9qNHpY?=
 =?utf-8?B?Q0RWWU9ObWt3a1Urb3hPTjRVK1lSekQ4bm1IaUVHYU40UnlYalQ4dUNSR2V0?=
 =?utf-8?B?d0gweVFYOWtpUTAyTVd1VFNvc2Q3RVRYTDFYeHN4ZDRNSzRtbWRGMkR3Q2Vm?=
 =?utf-8?B?RE05UHptekdqeUZEQ3lkaG9sMGZ1YjBjVnNxMkNwRnZRYjZybzFhSGNYQ2FS?=
 =?utf-8?B?eDJjTEtVRDNmLzc1bXE1UzkraHF5SnpCcXRqc1RsNS85eG9qRWw4cEVpSm95?=
 =?utf-8?B?M1paNEFLY1FLSVROcHZ4R0tEWVpLREtQdkJuTTY2UklKS1JlbUlRQ2xpTjkz?=
 =?utf-8?B?cWFLNzN6NHd0ZlJ0NVcxNCtPcUpTZ3d3NjRZTGlxRVdnWWpkaXplTWMxT1dl?=
 =?utf-8?B?Yzd6YXdWUzd3M2o0ZzVkVmdUQ1owTjNhdC9DYjl4U0luVW04UDRXMDlnZzNw?=
 =?utf-8?B?RXlVMnRrOC9SNVVhVjVHWERTYkk3a1Boa0srV0xiRGpUN2dTUy9waDJUYS9H?=
 =?utf-8?B?Vi9IcVlFeENoenBrcmZKWXNDZFB2Ykt4V3Qvc2FkZ01WZll5UVVlQVFlcnZ4?=
 =?utf-8?B?SHRXS3VTb3Y5M3E0eE5UVWJMRTV4aUhMaVlhR2RRcmtmOUs3ZlM0dEh1RDV4?=
 =?utf-8?B?ek9WSzQwSFd2anNrWFlsVloxaXhuMjVpQTl3WlFtVWZPTzczNzZiQ3B2cXhl?=
 =?utf-8?B?aGRHTm1kZ0dBMzJsaklaNllFZ0ZPUWgyRzd5K1IxY2NJeTBGQklvcWg5UmlD?=
 =?utf-8?B?WENYSlRHc2Rienh3ZnlHcjVrU3U0dnVvN2RzWTJyQzZxQU5nQTVwSWNLZ1dE?=
 =?utf-8?B?dGdQQ081ZnJtTXYxdC9JUzdWbExkdm1HSXcyWmNlMHg1dk1FYUdvaGs2dnha?=
 =?utf-8?B?WUdSWndVUy91bmJCSDJ6bU1kNjdvZnRKSlhibFN5bXl4cFpyTnZjUDNTR2h1?=
 =?utf-8?B?TkJKNDJ1WmpVU0tQWDQrWVQ5Y0doRzBwdG9OQkpDbkU1ZDdWNTVOS1hxOHE0?=
 =?utf-8?B?MmlKTG9ZY3AxVlN5cFh0SUl1cUJpYmpsL05NVW9GdG9mcFlRYnhqUXYxRUhI?=
 =?utf-8?B?NUtxWVBhLzBHUzRxNzl1d0lheEl6WHpGL2FXSzRFUVg0ZWtVZEFkMk5EOXU3?=
 =?utf-8?B?QnJRRTRIOXNmNGw0cy9sVWxQbyt0TzAzc3JVRUVtRzd2L0lWcFI2OFBkb1Va?=
 =?utf-8?B?N0VmRnRrN1VONW9Pa2doNmJwYjlhMUxYOWloT2t1WGNhNER2SXJ0SEQ4K2pp?=
 =?utf-8?B?MEN1dndWQ1djVGd3SGN1NGE3R3NPdHJaU0pWcVhMSVdLUE9MZVpSL2VWazdB?=
 =?utf-8?B?SXl5MGhFTG9ZaHlienk1Z095WkF3d1ZkTjR2aFRGbTlmalFYZDRqOEJIblFa?=
 =?utf-8?B?V3BWWjFFZWYrQktvQlAxam1YS1NhZ0lBbHFmdk5qZTFFSVdIL0VYUEQyRkJv?=
 =?utf-8?B?eEYwQ2ZwK3dVMVpEWGF0V3RqTU9VYWxUc29TZHN4b1pEcUVoM0M5V05DM2xq?=
 =?utf-8?Q?W5QqYH7gto5zETFRq9z2axk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06537d09-a10e-4964-9450-08d9b76256cd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:04.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWzMw4j57QsmtzEo+EGl4F4vzG0quGKlxKOvt2ZhWtn8szduUSDdEC0fqGSwoGESpQhzRkD5MRZr3RWo5OeylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
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
v1->v2: don't call dsa_bridge_num_find() from dsa_bridge_num_put(), it
        isn't needed, as pointed out by Alvin. Also add a comment to
        clarify why.

 drivers/net/dsa/b53/b53_common.c       |  8 +--
 drivers/net/dsa/b53/b53_priv.h         |  4 +-
 drivers/net/dsa/dsa_loop.c             |  8 +--
 drivers/net/dsa/hirschmann/hellcreek.c |  4 +-
 drivers/net/dsa/lan9303-core.c         |  4 +-
 drivers/net/dsa/lantiq_gswip.c         | 14 +++--
 drivers/net/dsa/microchip/ksz_common.c |  4 +-
 drivers/net/dsa/microchip/ksz_common.h |  4 +-
 drivers/net/dsa/mt7530.c               |  8 +--
 drivers/net/dsa/mv88e6xxx/chip.c       | 26 ++++-----
 drivers/net/dsa/ocelot/felix.c         |  8 +--
 drivers/net/dsa/qca8k.c                | 12 ++--
 drivers/net/dsa/rtl8366rb.c            |  8 +--
 drivers/net/dsa/sja1105/sja1105_main.c | 12 ++--
 drivers/net/dsa/xrs700x/xrs700x.c      | 10 ++--
 include/linux/dsa/8021q.h              |  7 +--
 include/net/dsa.h                      | 77 +++++++++++++++++++++-----
 net/dsa/dsa2.c                         | 43 +++++++++-----
 net/dsa/dsa_priv.h                     | 53 ++----------------
 net/dsa/port.c                         | 69 ++++++++++++-----------
 net/dsa/slave.c                        |  2 +-
 net/dsa/switch.c                       | 13 +++--
 net/dsa/tag_8021q.c                    | 12 ++--
 23 files changed, 219 insertions(+), 191 deletions(-)

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
index 79bde263b06f..85cc5aca7f96 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct net_device *bridge)
+			struct dsa_bridge bridge)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
@@ -1202,7 +1202,7 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 		 * and not being setup until the port becomes enabled.
 		 */
 		if (dsa_port_is_user(other_dp) && i != port) {
-			if (dsa_port_bridge_dev_get(other_dp) != bridge)
+			if (!dsa_port_offloads_bridge(other_dp, &bridge))
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_set(priv, MT7530_PCR_P(i),
@@ -1301,7 +1301,7 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 
 static void
 mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
-			 struct net_device *bridge)
+			 struct dsa_bridge bridge)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int i;
@@ -1316,7 +1316,7 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		 * is kept and not being setup until the port becomes enabled.
 		 */
 		if (dsa_port_is_user(other_dp) && i != port) {
-			if (dsa_port_bridge_dev_get(other_dp) != bridge)
+			if (!dsa_port_offloads_bridge(other_dp, &bridge))
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_clear(priv, MT7530_PCR_P(i),
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c583ece83b24..b06ac29a1f7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2420,7 +2420,7 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
-				struct net_device *br)
+				struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
@@ -2428,7 +2428,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	int err;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_bridge_dev_get(dp) == br) {
+		if (dsa_port_offloads_bridge(dp, &bridge)) {
 			if (dp->ds == ds) {
 				/* This is a local bridge group member,
 				 * remap its Port VLAN Map.
@@ -2452,14 +2452,14 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
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
 
@@ -2474,14 +2474,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
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
 
@@ -2496,7 +2496,7 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
-					   int port, struct net_device *br)
+					   int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2513,7 +2513,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 					     int tree_index, int sw_index,
-					     int port, struct net_device *br)
+					     int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
@@ -2545,19 +2545,17 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
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
index 18bce0383267..b9789c0cd5e3 100644
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
@@ -620,6 +624,55 @@ static inline bool dsa_port_bridge_same(const struct dsa_port *a,
 	return (!br_a || !br_b) ? false : (br_a == br_b);
 }
 
+static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
+						 const struct net_device *dev)
+{
+	return dsa_port_to_bridge_port(dp) == dev;
+}
+
+static inline bool
+dsa_port_offloads_bridge_dev(struct dsa_port *dp,
+			     const struct net_device *bridge_dev)
+{
+	/* DSA ports connected to a bridge, and event was emitted
+	 * for the bridge.
+	 */
+	return dsa_port_bridge_dev_get(dp) == bridge_dev;
+}
+
+static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
+					    const struct dsa_bridge *bridge)
+{
+	return dsa_port_bridge_dev_get(dp) == bridge->dev;
+}
+
+/* Returns true if any port of this tree offloads the given net_device */
+static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
+						 const struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_port(dp, dev))
+			return true;
+
+	return false;
+}
+
+/* Returns true if any port of this tree offloads the given bridge */
+static inline bool
+dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
+			     const struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
+			return true;
+
+	return false;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
@@ -769,17 +822,15 @@ struct dsa_switch_ops {
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
@@ -851,10 +902,10 @@ struct dsa_switch_ops {
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
index 33fef1be62a3..da6ff99ba5ed 100644
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
@@ -266,49 +266,6 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 
-static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
-						 const struct net_device *dev)
-{
-	return dsa_port_to_bridge_port(dp) == dev;
-}
-
-static inline bool
-dsa_port_offloads_bridge_dev(struct dsa_port *dp,
-			     const struct net_device *bridge_dev)
-{
-	/* DSA ports connected to a bridge, and event was emitted
-	 * for the bridge.
-	 */
-	return dsa_port_bridge_dev_get(dp) == bridge_dev;
-}
-
-/* Returns true if any port of this tree offloads the given net_device */
-static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
-						 const struct net_device *dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_port(dp, dev))
-			return true;
-
-	return false;
-}
-
-/* Returns true if any port of this tree offloads the given bridge */
-static inline bool
-dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
-			     const struct net_device *bridge_dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
-			return true;
-
-	return false;
-}
-
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 extern struct notifier_block dsa_slave_switchdev_notifier;
@@ -417,7 +374,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 		if (dp->type != DSA_PORT_TYPE_USER)
 			continue;
 
-		if (!dp->bridge_dev)
+		if (!dp->bridge)
 			continue;
 
 		if (dp->stp_state != BR_STATE_LEARNING &&
@@ -446,7 +403,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 /* If the ingress port offloads the bridge, we mark the frame as autonomously
  * forwarded by hardware, so the software bridge doesn't forward in twice, back
  * to us, because we already did. However, if we're in fallback mode and we do
- * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * software bridging, we are not offloading it, therefore the dp->bridge
  * pointer is not populated, and flooding needs to be done by software (we are
  * effectively operating in standalone ports mode).
  */
@@ -454,7 +411,7 @@ static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
 
-	skb->offload_fwd_mark = !!(dp->bridge_dev);
+	skb->offload_fwd_mark = !!(dp->bridge);
 }
 
 /* Helper for removing DSA header tags from packets in the RX path.
@@ -551,6 +508,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f6ea41cbcdd5..b6c8a1a9ec18 100644
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
@@ -310,21 +306,31 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
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
 		return -EOPNOTSUPP;
 	}
 
-	dp->bridge_num = bridge_num;
+	dp->bridge = bridge;
 
 	return 0;
 }
@@ -332,16 +338,17 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
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
@@ -351,7 +358,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.br = br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
@@ -367,12 +373,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 
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
@@ -415,12 +421,11 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
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
 
@@ -429,7 +434,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
+	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7c7aea19db08..2b153b366118 100644
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

