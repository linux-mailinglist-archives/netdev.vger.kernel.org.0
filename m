Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E16437BEF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhJVRcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:47 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233803AbhJVRcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSjDZT6TaLwnMo6ffpuJpTKomltBlJqRse3e0MzbLfTsrxJUmn/JfcDqdlRn2JKXyihj78MKOcTHIM42Mgz5ioO57+LEnjDY6Uz3tGahGSXEusX3vzKJTJoSlHXWB/ujWAqZrkcK7bxtmdFkc3rc8etlQVuKPeJ9oW+FMTtXwsA0LRGiHQDnFkg8jS8VmVUo4CcBHXf1m4boDC/zV2pckM6mSnfL0GoAlQrn3YkhWcHljx2oTri00dP9PMOhuFfYkqzyc5ZtFcNuPbWV8gpL2IzS22MalsujDAnQpCGKtaNC1cYOvJ8NyFyf1Ozq5qznqTJ1ABssbwBWwmtFkTQ0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63K+s8vsw18kekoq+SCIkI8P6rhJF7syF08ci5QZEx4=;
 b=cbNYGXQDO1t3ulE3AVQ8jAmGl6ZMzFmahovpQ0eBlHYpYxJrRQAFjWEQ8NZzdR3Jtgjl72YdGj9paVw0XHTIPIAcgVwcxwHvkdhwgcgf878Yb1Q850yGlKep+sNSMuE5y8fWkHrykCS9wAugMC7MUmfI0pWTKaV01eoJfVq7EuF44vUWqpTZS3uSFiUTVUyOQAS27MoIhT4dka+2HMcVWjCx+fxa4sXGaSqsjIDbAeXIb62V/tQSxFd4JMQkZaN4WOg4Sfu6RhRPDmdh4JoC94PUikmJITelt6Q7lZdC+m9WYTRhC7FAl/v6cYGemTeG+SsbbPfN3r6xIaxIRIKGJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63K+s8vsw18kekoq+SCIkI8P6rhJF7syF08ci5QZEx4=;
 b=RP2m5dszxZxooMUwVSV2sw6FCwHAUGiNSc4uwtfOMdvEIQiX8edz5Eqdj2gOa5McibIBWe/0Q2NPgIpzlNJZdSwQ7JbPXlTJdwIpxPofVHo5ypKIvRrJfa5wkb6yE/yN2cehUoSWRjfWGQ0t35WUviEQsJy1UcCJZH1fjwRnarE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:22 +0000
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
Subject: [PATCH v3 net-next 8/9] selftests: lib: forwarding: allow tests to not require mz and jq
Date:   Fri, 22 Oct 2021 20:27:27 +0300
Message-Id: <20211022172728.2379321-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92380fc4-5710-414f-91fc-08d99581a027
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504359E59278DD747433D7CE0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LcU8IiGgTeLgbRJnRLiF94SQZqYuHFpUGyyStpmdoFCQF+Xn/nKtJyFITYA8Q/aB5TG9AFTtJ7G7wKZZubsLuPY4XvWGRKM30eqi8+9aHsm9+9mEAkqSU9H7jZvQNFzYE7Xm8gHFW7dzmkDehiOUbSVoQDh7rd06EGzHP1XNDJD0frmMhNButEqujZFsxEEQOWhIFC0OXLH6ZjvF8rSpU0/Rns7QW0U5xamtpi/MH3vgI5EvnwznHubmHuuhn1PILzMOErXhQ+NO15GRmFnaWsn3BaBo8UV2gZV/k+79jq0x942WpQtHHLh5DYU7hm5VHXU+brKe/CVQY1SR+WEREahtG6KCr8fN4pG2EzSA2S8gYIsr1w5g0aFh1emnhqNQY4nrxiKo41BFK+zK2rLuudsdG1IPKaSlSqi2qLC/e365nC5e8zJmyJdkF893leWju6fiNC6NiYy8W6RWgd681E47vyeVkzOi3wyGbn8aiCiAg+87CKbwApc6QlSA0w3QafSh7U+0MM6gZQIDeK1nJR0pMRGs4PYDSoi4OOypPpW0BDxTvhm852Z4PVq84UE7hv4JmkFP8H2D17NO/mfQGZoQHSqeXOZCsMUqRdEXuUdvAu275NUhSVTy8hKHwXvXDQ7vVLeTfL5NXiQbHFkEHwLVEO2MsjfjuaibuNW1yjUd1wslBzLsmzQvHiqXqQOF9cQ60v/66IMi1wNab/Ec+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lu7+hH3XkuVzHKiI22/xeexu6dzecpuH30MDKy/OJ4aL7Q9DrS30wf69YhFB?=
 =?us-ascii?Q?0BmqvYYoU5dydAC97btbHLkuU+ZTEFeH2SrPNIyxj5ajT9LOfGoFFUtP3DRi?=
 =?us-ascii?Q?intnFQH3AiaAamuG4xKnRcFk47HqS8OJG5qi5TSm0DJtIcZRzXA7JvbuERq8?=
 =?us-ascii?Q?jqN00Z79mU8hw2DwDNwLUntuEQFxv3FYNozFhFjLQRaXRLI/Lmlhjxu2Y6s2?=
 =?us-ascii?Q?AzB7nvTFtiVYuXY/C09ZLxKr3TYkEc98WDQYNnLriTTxz1ta3dJWr7Rry0Pt?=
 =?us-ascii?Q?5KhnXKOVRRJLhu1ZFI/+HDTlKVhiHWDSjkZMO/NjIhPiX+9/b085USFUGNlw?=
 =?us-ascii?Q?3zABsv1LOiQO4+AeD6YkZevmXA3SsENTNLUopDuImwfQeJ74298bClvSvUOh?=
 =?us-ascii?Q?xVWcVKgO0rg7Klv77XbnrTw+jiEHqUMPsvn5HqXOkJOjKDeboK3pO/LpO6Nb?=
 =?us-ascii?Q?jsl9f6qezhm46v+ivZPUqVRpqeMwc02Mo7XeNhkLQ/PA7KzfAO/uejHo3vxB?=
 =?us-ascii?Q?r3xbvXuMKLG8t26sdm5erTrWr1TWqDrdc5X3sqXTxZAVcwVA/6TFBY4yzhB4?=
 =?us-ascii?Q?Dllnz+LnYVvomgutvVc9pfH3F2CZMgvk12xJribsKevKBHVtiD6neVqk85uY?=
 =?us-ascii?Q?z1cMHBp+AXT2e8FDMjQ0VFzliAUtLNTQMMuwkS93YS1ISMDkqiwVykXnjiWK?=
 =?us-ascii?Q?/cZ4/cYvV82kkJKCE6/fhkY7FBfmHizdajP3WFoQJ04nP6rO7w26KJy/KyGt?=
 =?us-ascii?Q?To7exOM68+jmIzWt8NH7s3MBZpgK8NsZzONaC+imSs3Lq3wXMRgOKLYvsEtI?=
 =?us-ascii?Q?yOrZDru0qkrAUKQXqaCxrvxqNCQRs/h7YEV2NBq/gZCkJIvLoLXWVqXdEKkn?=
 =?us-ascii?Q?LECHmlKLSWyB7mf+gjfdAO0iwYs+eeEJYT4rKAhG3tdbFi6T7HXlclb+O6lq?=
 =?us-ascii?Q?GJmWFQJG1r+g51aMxksjUZpW1V9QyPDvItVKCSLbr7wlyVxbUqi8lEVdiYXE?=
 =?us-ascii?Q?qINPmpMSAiH1D0gKB/f5wOfr8rnyG7CZ/JiKBDLhZIv3ygwHGXz/GIn8R9nV?=
 =?us-ascii?Q?S2qN/F2/dPSBNkaZDzqQJGMHt9kaV+d7c2FB/I5DT+kstxxp7lKG4gZWzeKA?=
 =?us-ascii?Q?F8Qjv1OhBRsfSW1PMOjQTl03nD+VAT10+UfidiXANdn+5z+uo9d1zagfbWyG?=
 =?us-ascii?Q?GfSNfvTVREZmdoDTni4tuHucpo+bPTgPc+SMzPMPmadb+uz1Mc7cIrvWDv3J?=
 =?us-ascii?Q?0iUqkAEx2pPJMvcVh63geTJxeaDXbYXpTeka/6VQbXTaDZuS137SEJpXSDAI?=
 =?us-ascii?Q?VPnDVb9D3YjxJoEsEEtpjjyEau0e7IduuxjCbGajfKCfFEumqHiiC1oVDr1M?=
 =?us-ascii?Q?j9oP/68aIfiqfrJONbXF+VEFkLfGUy9W/YaICF4VoZxAFAbecLyFXDsHeXDT?=
 =?us-ascii?Q?0D6sGLY+6A42Ml5InN5TtOnvdbnuPHPk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92380fc4-5710-414f-91fc-08d99581a027
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:22.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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

