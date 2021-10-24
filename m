Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD602438AEF
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhJXRVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:36 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:35552
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230492AbhJXRVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:21:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC34Z2BAEyhIMvAY7UDo/3vpTnkYN+IdRHTXoSrCQ0TOCU0ipeAnkBKv0UkAumKSVF2OAnHVmqwCUH41H7H/AZu90InyaZ9KuQfZ1wVpLgb+giacthQsoGetrvEsMoNFVFxESyanxQ+hjGbXCtBI6nXDB7DsFLR+3dzTJoiMO4si8ouiqed/OhppcYkcPp7fdbckw731ikzKG7184IZNGgVVCO6pZ9kceXy+21mBfqXQM6YIkG2Xa6DBmrFwpYCmj2QKsIHh/m9Z31qntogqHe7oZg3tEVqlMAHvSdw4v0j2ICxpz2fOt0qoQuMpJlPTwXr8x+AX5ppbtiCI4Pu5dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7r3WVFO/H5uaAfhweT5TOwYQsf35ds3Hfjak7kZX3Ag=;
 b=eyph5ohyGZNIH+0fiBmM2TLAG84wde/BIAqpGX38nGCFAFL/VIS/xkcaFDo5owD+y1jGkxdc8HAROTjTW8lFEtUIyr/yrbXmXZ4Fqx6j/I1oKWYXKdMGKIYSn8y3hCfhV64XJAyP7kHmTtI4VtRZlmiZGQ0KG4YtLZtQgSWkxv7/CL5NZAMuf5kbGVb2MeMFajfQQp6YXBr5MlYw+aRRbNpAYQzqLJgAj+vF1tfgwwsqkXTO+5hehtQ98e/D44AVePy6a46aIDbTJ6t+C0M6CdvqtrT/y1SdBHT/vLC8/YZ6p57x0ltDyPVzOzSJq2Z0MlB7RyVfPOkfph+igRKM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r3WVFO/H5uaAfhweT5TOwYQsf35ds3Hfjak7kZX3Ag=;
 b=FSPEuj2cWnkbtFZbzwCY9oGW5zRWj8x99+1kUTZi3oEz7LjLzCXfr5OYdimew/Cau/8UDkFriJTD0K9shxSMdNmTRESmdeGLWRw+5ibiwxPECIT9LeGu4D5vbuY9j9dw1QmmshwfPge4kMw8DDdZZXHm9YwbnPVVhNAmixFUaHo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:42 +0000
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
Subject: [PATCH v5 net-next 09/10] selftests: lib: forwarding: allow tests to not require mz and jq
Date:   Sun, 24 Oct 2021 20:17:56 +0300
Message-Id: <20211024171757.3753288-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8295321-e050-447f-6e54-08d9971253e1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2510F7D5CA9791132B8228F2E0829@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBPg+O5XTBvsRKAzHCJtACCAbgMK8rCSKC6huVzyT03fnCVqHFIhYEM39Z7jSvxk6/oKGyvqf4Bre/X0KQHCFoBAKLI+JGcs5FKSe3RXv7p+/lWDGw/ukHhvpnTKR/NBjlbPQzU3C61YSo6XwABGxF2SFHjWEgDdoGCRM/sG4N53Rtou7Dm202a0NN0sK1y8j3+NTezf01cX+lZEuED30DM7D09F5qPkzwFVC7ZxVok6RWeLdsuclcibRtDRKJLDOfwx9ystHgfgKr3x8ROAX175uN9rGt7WWF9qyrCRQGFkai7qBEzldymK6kuNBkSmvP5ibBqwOCZ/QxdarcrY77Tq+Z7spNS0bkfm2/QVcpbliKLEs4f0ybVxuXEB5YahlEbR2hyXWrKF5kXMP0q13qK4zGBj0TUyIUzrVoYbopH8vo1im2P/t2ux3tRvQ6SIC9jrcaJVXAWZI0KTZXzsnzkitavwJaWy2ZjmY/b9lJ6m6ktNNVSn26vlZGTNXU3n/f0Wi73/DCnLo1qcWkWoMjH9caDmKvlc6i3X2wb4I6D5UDJQdmShSB0FK5D1hmv5zm74ySZpJ69iIk4xD9Gy5t2JO3ibaDhKb1edWiHDK6Myn6PlI3eevxtvD4U9ZhN49h0OdHrkqterPbVqmJgG/paNGoR1RPclw5Yaa5BHsvjwUjMB2oPVpIJFWGcpqhPbIAC/uqCwrhzTDgBqmj2JYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(66476007)(8936002)(7416002)(316002)(54906003)(4326008)(956004)(1076003)(66556008)(5660300002)(6512007)(6666004)(6506007)(83380400001)(44832011)(38350700002)(38100700002)(8676002)(6486002)(6916009)(86362001)(508600001)(52116002)(186003)(26005)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iZsbormCaMrC7PuLwTltpJNW1jszK7sCyn5WWH+tnfSY7pkD5PEwNPFFNz7t?=
 =?us-ascii?Q?caJLnKdBofVuC1s+/ZJFeVQCoF9udso/oo7STJ86eVk8cDTZmKzE/90xIm9f?=
 =?us-ascii?Q?x76rXuRWO6yQJCCF8500SQ09a+KktinmFEJxE5Bq9Xxfwz90yIlkK9LQHjHH?=
 =?us-ascii?Q?p5YSWp1cKJL6cxtDKNYJ3ODAwYJBIs34grsZG66M4rAK8rYOGdHEcCfWbAex?=
 =?us-ascii?Q?0opUp65ORSCArof3u7PTOekkSQWRPjajV7qY9zdc+49Pv34yYWT/pppduUH7?=
 =?us-ascii?Q?KuaIzMkEAD7CltDHWgaQyTGXOEGViLH53JkZ2nJtPxsMJTlxtcS+78km4YsN?=
 =?us-ascii?Q?Jrj/VElIYxlrlqOGcjVV04wSazUlkOKJoXUCjd0MLFuaLfy7zKsb8YSm6q6/?=
 =?us-ascii?Q?XG4DYSu+xPpqsgOTGkIIM+GyC09cv7PWQ9gxpIepEbP6pcjGDFg/sLNoDZ+9?=
 =?us-ascii?Q?k1waxP6kJZsxEXgGSw/b13xVU++Tpcu9YSqAbat+MC1dCe6GlVdbTb2f7tvw?=
 =?us-ascii?Q?L6NNSZHudevH5V69VDIOHaF536qrtgmFiLZ9gGEN9tMUPxBZ6mTHGmk9ruYZ?=
 =?us-ascii?Q?7rnyX9AtdlOOiEJyj+dtat22fU3Uooc8SGJFbq0P0H1EkLm6tR8pWnmQAyPE?=
 =?us-ascii?Q?blkJrNh3hlJjZvpVX6d39erzNd810mZpqligUkPTXwPq8mPXyz0tW3mzNk62?=
 =?us-ascii?Q?kuNnEBHTmnRpk2cVhgJUjCUOwBdCmGWjUaVY1ykogjMSyTPajc8WfmKiTv4b?=
 =?us-ascii?Q?Sw7qMGhhwEY0RmEZaUYNMCmRxNmWFVX96fZ1sgV6634jF6iFID3U4UMLsEwi?=
 =?us-ascii?Q?e2EHlQhiOqiJe/KiuiQ2El/dmIcboEVg0bx2PSkdq3qa0LJBY4wufXegawVQ?=
 =?us-ascii?Q?BzCJc2iPZPju7Ge83HxE2eP45S3ZwlCrfsNZsac3FIsZhk1Jg6F6TYc0WpcT?=
 =?us-ascii?Q?iYFOBqbb67XowBm28hEVKZuXsDofO8zxELnomfH8g+2v95IZ9jNnocFvwMix?=
 =?us-ascii?Q?TUHfr1fWPWFCQ2JsTV6X5ob8CJa5DT3+k0LJ1PpLKQWX6ui7qxy+/xbpPQuk?=
 =?us-ascii?Q?QqQTovm1wkGFH+tzN0bxRYcsr8ozRtJDxWhZ066hexwEpGC19RwUX2Ox0Xze?=
 =?us-ascii?Q?75TgABs+u6tYFpR9UQzfre7yN6E4wmi22+pXLPVj0/opGoEEpHpy1ZQwK4vp?=
 =?us-ascii?Q?w3nN2dWSLxjillELapWUSJ/wTpNukyJhHmPE4pxz3/I+yVlv00wo68fjX3u/?=
 =?us-ascii?Q?B/OOP2XrtorSr7dWaZSMMrHM+Pgnb+TljsTb9o0KLC3iwbv2k7osiIJE23VO?=
 =?us-ascii?Q?4fYBcLCamtpCgen+ETizdMJ6fsAquWITYa0yRO33QFTxAtfTAq/Q5spixyXn?=
 =?us-ascii?Q?QqkhWzPyROxZ/CtVPIIKUwUUNktkMT0wH+ORyaAzpt2FZpri7ww1jJc23Bzh?=
 =?us-ascii?Q?HdHehWn/KhzpKdO96ERXCzUI48M5l4krxLs1YBvTMKAzn3vzj+vzRlKFy6M6?=
 =?us-ascii?Q?OJN0nsTQfm1tcTnnlgRnO3mMwfbkmbdw662LTZ+4SpjmgnkVU4kC1U6e5ecx?=
 =?us-ascii?Q?QoJnGC6O1VQpr11jSnRlin8Qkh+4PvakBXFW4dvzF98Rqc7aJEiDJHX45nEB?=
 =?us-ascii?Q?/QtAQCF8/CVrCZ9S0tT9F74=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8295321-e050-447f-6e54-08d9971253e1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:42.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnQTMaNq8MfPQmZzdvy2gsTyuwhacUO34nirBXYsdh8cPVgAjsNQO8LRQgwHKkUMFKjldXVjWEnP9EkPjS5O5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
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
v1->v5: none

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

