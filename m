Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDA437CBD
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhJVSrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:47:00 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:9427
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232375AbhJVSqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcnQVu3sKmijZ/8e2GCchArh8qplws7UpSKspA5lQk7Er69w311ek9rHg8nf4S6bdRxog4s3ZckPs/TWrXT9EK/2jPaBmmxjC+e0jVyBlUx8alM/3VyJ8+4tRgJsv/+15zDxYh1VMotx1SjZjUhT+X2OWlgGSLHfBK5+WwUz+9YTfwOhaZ9mZ+Od29DsKn3tl2EcDH4q2PZedNd182rigvlCiIoPGOA3KQKHwfLCOoVp5cvLkhTXRnphl4WvywuLdMvEj2lpwATU2ofxu92laiG9vTLRCU/7uF8z6yl5ypQKfSSRYRI7NAUEyxPatw00UP0K8YFJF9y6wEkT1cpFBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCRTWDrToKpc1/M2nuaQv0taStCAaAz6y8BxBG0Zo/U=;
 b=Fj31jygp0HRqIQyb85Lm+nHG4qYgVRWnyda5rVMobuSWv6s4HChkUyJ9RvVmKQuuOTqhwpdSd0cLEL1MfCapehP3brExKyAGriSodpMI46Dnfuk8oUMH97LkDfl8y6jGEnu3T+ToovaSww5DclWG4MuWuGg7PcjRudetGgLGgmRKez+34aTPRB3cl9YdPBlefDfbWLQH2apR2Y3MX7KyxJgl8oMXsql1DsiI4rgtIH7SPMbzosKhhFoXdJt4MjHJPdIOIzDFusJK73WZ+N+Wg/tu+M8T4miUMYhPPZX1m0GdGqJemAx8vzbTPyGmg6R9Xaz6AXzdalR8uOF65Zwv9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCRTWDrToKpc1/M2nuaQv0taStCAaAz6y8BxBG0Zo/U=;
 b=did1tdowbNAf9ZP22f6igcB7HxJMVH6CwPouDBO5wzwzJDfLJE/ruW4q9uHgB69OtkbtJ3pvPaWm8+hpQ4KSkz0db1iu1YmEBfQAC9TZ+mVfsfRN5jMAElrh8bsSz+nvw7+lWh8lXTY1d5/f8Ct2Hzl6irkTgD+mxspRLiDPIVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH v4 net-next 8/9] selftests: lib: forwarding: allow tests to not require mz and jq
Date:   Fri, 22 Oct 2021 21:43:11 +0300
Message-Id: <20211022184312.2454746-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9954a560-2433-4921-8cd3-08d9958bfee0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28627715919A621028EC6C28E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXx3xkos9PfGOyVb9D0p6PCQaanDCoTmYYvX9Ve0tnrFCjJFIiIAW5xWYcw21ej7HjuB/N16hXkncTokc/6flAMT0g+FvN5VUpU2cg9BnwbBlRerN283o0v2QoKCKpGgyEILkn0N4IJI5nJR4frNUVV4PdMzn/5ZwzmGq6udQIWtGH8AFB3YMWl0j3+dAI5Tk0xRpklPhDaauHvY4fHcxcCHaYLHj4aNWdysBP9dUA0VK3CwxyiOAQr3k2JNItgS0CDBqDghzIvm9THpzMyyEWfwd+28c+H3iIf+tEs8Fz6dgFpF53ykP+eUvcgHBWDH1uq1l3OfOLfCwy63LgcqyXzQQQk0TuyDvN1gVj70PdVMJeDc6sBkK3gmB/GjFllDNHyKtDPJ5L0Y4aQb/u9TkrBFf+wSkEyWeRy4AdnVNURbE/PBE0/mFdkthRc+4FzJKo+E3pWFEOpHH7HvvkjK3GGwQ7fIrBMxwyHxg9r74VjHb6LACHmLb4tLTy68THfBCY1ibzYiCGHG/iumFzUdSU0mXQ8Tf0wsR4fuGNxJeKvii8ZGMs/Ht5zi6uAW/9bIdI5f5XKXe7pZlDX82qNFstrSmakjd4OEK3pZhQC45OnL07dHgSZY9fs3wW5zeexk4Q0zjGcz83+BkAGs6NL36kRv1mHeJrpYkYMeVVTa1xusT6/JiBAcpWFOplGB7yIYH0rOfTdQEqKuevQduelieg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?55Notj351VCDt95nPa/oOqK55nVw54di5yr+ch/SpeximJHt6I2kMvZCR5Zp?=
 =?us-ascii?Q?tFOalnRdf88e/j+4KF/PhoEDuwlOuC6fuIw8nEMqCs6u3mQkf7HAuYKE+4NZ?=
 =?us-ascii?Q?42fQNnaeNM8IvwM0Q6kkVcDW2hLIN1WWTm38Ry1KkBOXhghH+XYXRqcjoAeO?=
 =?us-ascii?Q?yNF5rvY2WjH0Q93WJRjWNOHlvRB9BpRTrnKeoUDYjJ1V31iA6C+UiATJJANX?=
 =?us-ascii?Q?inrEqfV+ccoEBccuI8USs0IhwmLVir4ZSx5VFplcfEc8y8S2Zbbp71Z72fPg?=
 =?us-ascii?Q?tjaw7QJgiEWFesCn+lgRrR6JsJJtD35++aCd1/GYe9uVZmvDx+VA3vuCEsU4?=
 =?us-ascii?Q?/RbCnykwGEbZn9QIclfuDKZ/rUrlbim5tseiBvHNFDPKW8FHFnydTQfBvQJC?=
 =?us-ascii?Q?DuK8qopo529IbIamz/WpTOBuBKe0Kshc0yDYmWX1evy2Y53SEMx81uighcIZ?=
 =?us-ascii?Q?T0A/HW3m8a5+OijutSvSPgEY2fW3wR5WFZBNoBUqfc/+s9jMWi//8/1sc7yH?=
 =?us-ascii?Q?pnHgd7l9x37zUFhoKg90Q2/NOcfuKnSEh3NjFTJvuVrhLcV3QvwcA1t3T7vI?=
 =?us-ascii?Q?HhquKRiC/F8it4gir3C/Wz/rOTZLWXw+ibLS5ZD6ZGjo6TesMLii/BFzKzZs?=
 =?us-ascii?Q?wlvDGNtbBAtcaJwzN56JyWATJwKTMjUZWSI8Oz92GVr80Z8wj7ycuTcIrY+o?=
 =?us-ascii?Q?zMEHmzFQrYT/YyDPjRVqR/qtksc6YpmuQ8K8b4nUHNu68oUqHMJkaDIJ+/4T?=
 =?us-ascii?Q?e4yWbpCvw/qNCrVVenHggjfOMDVWCC5cXdPac5z9kNpsXVlK81DS/KWxjD56?=
 =?us-ascii?Q?NPVEzwucJsBcunzFoTwz1D4wZkQXLrkRAB5Jb6OX92a+bYNuDITZUdpGzuEp?=
 =?us-ascii?Q?XrtN8dF6r5yMtjeDn879lsMlAWiZCZnJIWFK0olu8igyAkhav9W+wdvJj55o?=
 =?us-ascii?Q?OxZvG+Jy2COiCYly59ar6ZPgHpX6yQUpyzTQ3mXQMawPAStMaCzZ3EUhVTJu?=
 =?us-ascii?Q?9RGygGenoUVJJaJE0uztChXm20OKW/Ubale5imxyfw0GzzpMEywtvoCOlvUE?=
 =?us-ascii?Q?BIM91vJcO/s4lS1pSp9vIpMvIaJ3d4CyM4/3wT2tLMOFLw25WshVb0Ex7WW5?=
 =?us-ascii?Q?YfyyDekeN3Paz3oA2JX1dauZ+ZrPquZjaiYFyPvusVhkBu3IzXEhH/fQ8PUH?=
 =?us-ascii?Q?6sJ1VS6EvyEdF4kut6qQJLl3yxFgrQkpOuqvxIXpGXDKioWqLOcAu5UrffLh?=
 =?us-ascii?Q?x16sJBhJVfShK5vosirYkxi2buiAnhLBzJjLrga0q/FxYq7EgoJNTtA9cgna?=
 =?us-ascii?Q?KJfciDtb9KrdkcVjKUUYzOFNIXYSowhV6JpflB/DoB3Z0XYtjenTdIi3/Kxi?=
 =?us-ascii?Q?GpxJeN1OonrN0SynDQAnWtinsoGYlleyI2j3xtb/yMOsH88O91k11T2E9h28?=
 =?us-ascii?Q?YLGk2sGeRJdj+TCOLwU+yzINq47AaeKN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9954a560-2433-4921-8cd3-08d9958bfee0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:36.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These programs are useful, but not all selftests require them.

Additionally, on embedded boards without package management (things like
buildroot), installing mausezahn or jq is not always as trivial as
downloading a package from the web.

So it is actually a bit annoying to require programs that are not used.
Introduce options that can be set by scripts to not enforce these
dependencies. For compatibility, default to "yes".

Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Guillaume Nault <gnault@redhat.com>
Cc: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v4: none

 tools/testing/selftests/net/forwarding/lib.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 92087d423bcf..520d8b53464b 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -23,6 +23,8 @@ MC_CLI=${MC_CLI:=smcroutectl}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
 WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
 INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
+REQUIRE_JQ=${REQUIRE_JQ:=yes}
+REQUIRE_MZ=${REQUIRE_MZ:=yes}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -141,8 +143,12 @@ require_command()
 	fi
 }
 
-require_command jq
-require_command $MZ
+if [[ "$REQUIRE_JQ" = "yes" ]]; then
+	require_command jq
+fi
+if [[ "$REQUIRE_MZ" = "yes" ]]; then
+	require_command $MZ
+fi
 
 if [[ ! -v NUM_NETIFS ]]; then
 	echo "SKIP: importer does not define \"NUM_NETIFS\""
-- 
2.25.1

