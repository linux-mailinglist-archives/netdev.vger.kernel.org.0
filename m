Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0DE4378EE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhJVOU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:29 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233059AbhJVOU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S08G8mr9kTVhKY4+JXekZYJ7XYcibfrr+A9fC5M3vxLWPVOlpCEDH48nuVUdtAgPR8rQS/9n0ImtB7lqj5LanwsxcmimlYBX/WwSm+rPyzOAnaHOd4SryDiGUl/cy0DsajVQvsD8En+kpDAI4l339JtI9UU9/2jpL/wttFNX96h6IWcdodJ6ISvQzFfay6X+b+1/diqAFeD2IFGXIHnxpJjchDadqhcKwFM6YEoIdq2FAubkSn0nPEhzrZU2e+kA3v7+UqXxOGAgQQWz3htnzSSFlNCGc8HyMxJdaDllyeSA2qF5RE/0Bvfgig2xYRopWRiwuAPLFu0a7pCnG+mbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wp6y/wQG3E6+O1ToLzm5Cn0t+pqax6RObs/OjdtECwY=;
 b=DsvaSeXXXrtMyc+ySa1dVZdVC8e7o/IHVWPoAOeGkqj0NpVFO7eGmTMNRBWwQgofYTKu2DSb29tRl7ZV17FJuDFzIWEeOt5ewKSrTtRYD+zCNWEx97LXA/cpgq2jEnoYa2mmcPJ3dwFUf5r/f/JfzRTnFzt0FBTTUJy1qEuAPboWypgC7UEdmQr4syvmFWBRvE165N8KjEtG6UIfGphVrGsmS9nAyjqHxVqf+opmYWOUbUIQ8X38Sht4/iuykOpjuO+E4BH+KW20XAhYQiwTSmQEJdPvKhbzlEmfXkQvZ+VCDEY2YV0sLcNlwE6BLgOKhSFZ12LjHHyivo89gYfyoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wp6y/wQG3E6+O1ToLzm5Cn0t+pqax6RObs/OjdtECwY=;
 b=Xt/TH7ISPxAiQLl7yt3onJen8Txl5IDYjvZF+c/Xh4lpUNBYfadLPbAefhvYIhOwU0D78Lhb7/P7Pnn9UNpSY2aaU3daZ8iiAVD8E5yR/GHg3+kQOfrs2EE3x0hKYhgQk26AG53iV6BynDyPK5qMSG3NsnjHla6ZQPCLP8XFmQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:18:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:18:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH v2 net-next 8/9] selftests: lib: forwarding: allow tests to not require mz and jq
Date:   Fri, 22 Oct 2021 17:16:15 +0300
Message-Id: <20211022141616.2088304-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f839f287-7571-46a5-7c62-08d99566c186
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34067D1FFBF074FF849D1A86E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WTiZ9gfGA9VsnX+mb8OByr2R9MahiGRH3UF5nY67K8AmMMdsBq5hSayAzXwuoIfZo1uukJzm/DAYihYkJQzAjRaiXzo3Ggc7zoHJOQ+Zr0hnKONMn0VPSgkCutqeKEAtona6QkwZzC9E2agmF00YgiDjgQnwrI0PotRqOS7bHucSHYuoPsVMyGGWiARYZeXs04Eiz4osjEwHvReq/smBJdAK80cNm/SjCOVUtqz4SFFhFVQLuMg6Jj+O3BodZ5ZhFakmr7a0HuNOZNG47eas52Pzr66jyfljCAHccQ4kTCiKJJ1oB2UJFISIeKhjRpCpOaTsFOvDKbCNO2F/TGpk4m9Qbsirpqp8Lr3kextipPq2KJPscQ44vTenFkkAQ9fbj9kHMBRIJyBKjJpDuxsUqi1xRcv7XsZwGZBmukqS+b2u/NSOBYKpB88VUX5JmhyzguMdGx1P9qpEvCYMG+p5rVzRXIhw6he9VUsNg2Conr1Jqi3MUUlW659X3UYfCMHXQIOe9J1ov/Cd/PfUgr0ucabcHWbr6GF9Othea2coH4z7ZKzdbz7xadkBMd9Voee1Ot3fp+35+ccMxdjnP8QQA9H0yGNKi0FUhVCziVEgOL/x0TSzTrmQVBGOMHlCMJQXGPhfHp5lgmg7YbZYLA53b3tTqK5fzFhogS8UjurSKcG5Ms7VGqcBP/IeveszGcW+zXWMuDxKNPQevMkrbKAAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YjeetYWFZ+zTNIBPHTUyXCTtj836OPOWOpbNt4gmNN0T1+y4QnhsoR+Bzuc9?=
 =?us-ascii?Q?ZXrksghRf33osK7S6/nvZ2KDdLWTA+VFEdDkPIlflZhRyeVYso9c6ihnwy+r?=
 =?us-ascii?Q?e3HYJLBCFoXQrqk6Uk1BxOD7NN8QeSTlUIDzekQgCwXr2AS1J6toZr0rshzs?=
 =?us-ascii?Q?F3AyMif4rd+HceSHqMb3x+LX4hEBjfYOF+D847kh3U5rqEa6ED5wp58cURYQ?=
 =?us-ascii?Q?Pn+/wlX3StzMRCZ2O1aC9X6Egt9Rsbz+fE71Fp5CjCMMTq6lVYNzUvG/SHqv?=
 =?us-ascii?Q?1jvomEsH6rW4iGE3linj7/ntrDhEJwtFlJMsozVxGJ56qghZBXkVaTBr/GnB?=
 =?us-ascii?Q?ls1yNEe4l7p4wAOdqfTWeSz1gasx2e4Jbg44v4ma9yiR40AYO1Sxws02Neee?=
 =?us-ascii?Q?EBxWdCcdu0u/4HvlH+M3QHrDTp5F9aYDhEPjMSfl48P+rHXUhJA0RDB21GvA?=
 =?us-ascii?Q?+GhQcUUcNIPIquS+7ypQLV6eZWeuMRC4KEKE7vDckql72qI/ofAmwKS+zQ5D?=
 =?us-ascii?Q?p7vnmp/7sCOSUgyozpefNuE5hgiU0kpxIC5C6Qa32GzomVC9+0E7cAgZ8iMJ?=
 =?us-ascii?Q?UmhmY++rKUuatUhMSP8ON3z55tet/PNeabhWiLGPdtJUu5edd33Jb5bN7d1F?=
 =?us-ascii?Q?fM+m1Wvw4O6wgneKJNuiNvksUrkOfSbrG1EUw+6MsiBWPwaEekP/2/4MKQpE?=
 =?us-ascii?Q?jUW5XxIh5j1e6T670lHKRZRHgMV+JRexa5ihQFLnl436+yntH6jFtGfJnmIX?=
 =?us-ascii?Q?IfmETyfuCtMb5rB8naeN1ddp+h00lx76mYm+buD/yu/muvp3oGJ7jsmv2/gu?=
 =?us-ascii?Q?vcFb5YlX47NnrV211AZ4BSNSPTv5GYrthm2xqvDAJ7MFgM+0II/bEKrWowpj?=
 =?us-ascii?Q?bWHfpCyvim1aDliVO/LCi9XNN5LVxI1ZSG6TiizILlDIvGC2WHiV3MYSHaVs?=
 =?us-ascii?Q?13GhTVtvW/RV4GstV1zVVKMmYEkdFG0UwDKeFw2wUAMTAUp5qT5/lYDK5ceY?=
 =?us-ascii?Q?/BVQ6RqfyumwLhuyRAz//POkniaWZNf1RRcOztGe1zI6Thn6Ytu5J9VKRbaj?=
 =?us-ascii?Q?S+E5DJgIGLKrMUAvXcVsafpZvWB8DpcfmlQcbXy2qV2xJ+LbIXyLqGmQsBF1?=
 =?us-ascii?Q?EJqPU4u6rUXuI3As+j9NMqF+wYc/sPXzozb5obB89ZysNyPG3DC+cQb7ABVq?=
 =?us-ascii?Q?IgshYAuo90nvTpR4Cuk0MrJmgxaWbgqhxJirEBHm20zUm0UDpkG7pHVVzYBY?=
 =?us-ascii?Q?kmchL+Ymfk30CneB3lDqGLLcs5Kror5aCrwlQWxITBkDrrsC4CA8TsgkwTUt?=
 =?us-ascii?Q?TEhHLrkmDLb88P1GT3bbvOEQy7R2CSgpDbtnYkFx7mo5XL7bBuZQuMxdsk1u?=
 =?us-ascii?Q?6epfehTX5KVniXpBONX1alC8XrQWdsANVStwJQS0ySOiU5217cfS4Om4m6Fa?=
 =?us-ascii?Q?PEMJCA/Bt9AFsUojOGGKWChsLvmmTDcR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f839f287-7571-46a5-7c62-08d99566c186
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:18:01.7004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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
---
 tools/testing/selftests/net/forwarding/lib.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index e7fc5c35b569..eb8c783f35b0 100644
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

