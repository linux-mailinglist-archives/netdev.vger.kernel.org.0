Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D2D3F5D43
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhHXLm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:28 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236792AbhHXLmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCiNSjYoSXI/WTwuZhhEhIGbo3hoe8uv5DoZ7txFHFisi3EiOwaIeWGRg7/6sSHNi+cPWxrYwZ8HiaMpxSuJYk2d4JZ40bR2ScHquAVBg11vedbejNPaTm+Cx1AYVTkZ4GF2mySUbdlNvuyYGa/2hks1jNQCbwYTDNSsumJACWdVzBFZoYcb6fTZk2lQnZxj8OxEIpH3DXgFKjcymmPaYmu0yTZ6CXsQ8qNiL/SgtrGGkdxnkBSPr1UwD9t5IhtRjycgwgHSzZmG+iap2jnlt564nmJq/lXKHpQ474+1wYlrmYXGg3D6ESq26+u0/Vx0XrMx9mIV9VU6DgEeq/BTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=julJjQ5thhy4WTbSi++wwssjpxuglr6L/wHoMXBpEI0=;
 b=aYc9ZVRp+Jh0dekuBzI49P2FkUj+K7p6h3MUJ5ickhL5w1z+Kbm9P+N8yOVam21mEwNzsW9OuV5AKX8U9R7kFhOaCSyZUfmTlRZrgjWG9XnhSr40hn45jT+4fsZLaaTkZ7S/RSPTdrTMjAS/f0hlzkWjAUgBIP4nsaDL70oQMOeiofp2S+u/KfPINixGvCkiVZFDKNH4F9twos9r/UpcSQvy2r2N1YpG6v0/ABdsBvSjF6sgC8OCP9vFYQplCTjx3PuwwVLCY1zVRyF0nQnCemCQP1DyzkR98gPHLu52cXwHHNa67TwRMECI3mbdNg23qCTE4bdXYK4ievLniyDvkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=julJjQ5thhy4WTbSi++wwssjpxuglr6L/wHoMXBpEI0=;
 b=E3XWAa1zsSXByAoHVzErjmHo8SAYHl5e7roKPibJzoj9liywMgnEfL9egDKeHWknpMx0b3OaLdwl7pxOBhy66b/Jlfqgi443U6CX2aw6zQ9TXWk+qXLQg4bWlZUuWzK2O7i8zDJ6266nczAXqgwk+ib4YQ7BRns9ocQ0qpcBrc8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:24 +0000
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
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 7/8] selftests: lib: forwarding: allow tests to not require mz and jq
Date:   Tue, 24 Aug 2021 14:40:48 +0300
Message-Id: <20210824114049.3814660-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8da4861f-5f61-4dcd-c0a1-08d966f419cb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB569646CE3A1441D130A8FF35E0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3cv4L+tDJTf+aO5X4jwdGO7RRoPIfg4LAVAAb3vRSJlDpwxUPRFkxQZk9XZsi0ZAxwjHXwOZmEmFuKtLPwP0DYxf4rgmliyFsOak9mVL7vknqB2d/xaHXhE29kA7ktCb/rHUGOcQ3Zqjo5JrpXjI1/DzYOSskSC8XzElYoUtMT47hRuGnITXpYT33z9PrJDY0M3LgisWrUpsST30wxWMRquOoPASPWkc60cfYdU8GGVuIYYZM5xneVnAlzIdO1y52zlBWc3ur8TTe4CBKB/fVzwv9h/qU+Kyretk8ZS8dbIymwYHuXlzeFzksdrnkCsowrdU67uHd5Ieu/65ZZ9VAc6jwRNVVlxr2ZE0jrK1zKaboGvvXjfYlm8MuFlvxElqVf0tNLbnmgOU9YWXwRc8G4Qq+qgs27S9nj0GFuvylF8Xz+oQI4sGBzj5IEgaiNyvC3FEDcyIjD+jHWYhA5jVggfHx8ROg8of5B3sIYUjUB6dgx3ChtfBTUL9Vp12nngvlznqKAsrlAvSq1bw5e1kMiI+JViQ4wfuU5hCGh53E/vrABVAwLY+zUuHXEPoz3QXwz6InDMV+9cPEk/LqGoj+KIsJvyjhSycuvEqhYtfmNgOz03lVrIofyF422K5Mlh4/1jy30yjvJ0XIG6nM7gySHHzGxyL3hPJ6MvPc/Ftk/Rw4Bm2z5LFOPaygR0QxvBB5p0ShICRRYApuyHq4RRXYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XDEPxSxFxJGNQ01W1dXQOuqthYWtfKFcSTnl6CgVM/MhvHhOaXvFlXT6lGFL?=
 =?us-ascii?Q?Q6sJygUwtjI3gO+C/f02QHCRuEdrAkG6ZcvOEA42hKLno85Qm3r1rgq+LH/y?=
 =?us-ascii?Q?UBnxQpnE/KrYyCXD/3s1mMceVXXk0Ul81Y4WZZDGrQBYBQTP0xBFBYUqP/Xn?=
 =?us-ascii?Q?Csa1zGIRd6mQzIfC6Bs39jP8t7caNA1kjnHF2FUX6ZypXhFp1DTotlOtw2zF?=
 =?us-ascii?Q?YbGPMUyinWC4wSe9A4wXYQFjDd67qeayQjUrQaGWQdx5DKk27Svq/BqiyDOz?=
 =?us-ascii?Q?kJRGrwJ/oMVhnao888Af8vpbLXxDWPVnqazRR7aKjLqw740hbAI/bZjcvWad?=
 =?us-ascii?Q?WdgCsc+EZc1JJ/+blWDMwrTAE1HK2kUwIaEOSOuNGid+tOHMjSo/WiySqZ8t?=
 =?us-ascii?Q?Pt1IlFR2tEwhugpPFJY1VuUxUdA3h0TKWhqUOKM3rxqqED6T91wRBc3uqnDU?=
 =?us-ascii?Q?L4+sBDV6uHgymwDR2z1IGtyPE6i2Y+oAC39vnLNqenvySS1rhxRr3wTke9ZT?=
 =?us-ascii?Q?YpFI4DB6NlR2PC2K3ghw+LcKPiclDqR2OMyBOBEU/uUBh+ffpfzRNLAI+Wpc?=
 =?us-ascii?Q?ipjs8du+5rZmLnXqLjl54qcjk6wUIgRhHDbkxm+AA6gxuxXaDWkAsfkgpmEc?=
 =?us-ascii?Q?biOHwVKGVPtIXxTI57Xvws39YPEzbnrcJx1etRtuOj0eKE3ExjTzbI5N4NFf?=
 =?us-ascii?Q?8w9SUtnBYJGRRwTxMCLRij97I1+Ysp2iygLLD/HhNtzL/MPriOs03hVk7/qQ?=
 =?us-ascii?Q?ZfKPptR/p5IdCFow4/60Bb1cYelDaP+uf0xurIkeWmwPUlaAU5LbhHZMqDrA?=
 =?us-ascii?Q?YsN2cV63HLacq/1/i4a+L4TMFS9u7OH1R+kCTjBxk8p9evfRGQ+ERyTuYpmI?=
 =?us-ascii?Q?9Wx7Llb+cMmRJW3GY+kTsPMHQfVU0IeVtl/O4O8XPLLiHInNeG7o78ypOO3e?=
 =?us-ascii?Q?LZqaLhpzE1QFOqgi8/a/ZUyeXSP4l9UhJ+NPVgxxCGj2lpTUkOGHLMgP4voH?=
 =?us-ascii?Q?D7xUtxzq1psNaIYk5MAkgN35JIGEPxD6cAxDhAqSsWMtaXcrYedjr1imOD8T?=
 =?us-ascii?Q?NqKqSCj+PmB31emHkB1xuK5RmXs9na4h2/ZlLB5Im7XJXcBX8YZrF3/DhJ/L?=
 =?us-ascii?Q?eq7p+nGZPOM+5p+VoY1k9UNJ1YfP8GUSauEMmzaJiyhManK48DdRmWBVarfV?=
 =?us-ascii?Q?GmbIp2VbuXmwuECihrr51q+MXVMxvNTL/q6ul6Gg9uHPfhsTAnqCQEyyXHXO?=
 =?us-ascii?Q?fJ7HRTClVNlzI7jrxA2KpCg4GCB60aN6cMxeVz34RgYQiiy3QvoM0xIHu6Lk?=
 =?us-ascii?Q?pXOJXd0wvBMDFdlyFC6Q+DB2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da4861f-5f61-4dcd-c0a1-08d966f419cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:24.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uqZeUX1+8YALbga8LCwn9Uc37SezlmYyZ1L+WV2T6lQJLSP9TzOtwJhHpvRbNE/soD3s5/ldf8XhDLNwxgUfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c983d41..b937472d2e17 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -20,6 +20,8 @@ MC_CLI=${MC_CLI:=smcroutectl}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
 WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
 INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
+REQUIRE_JQ=${REQUIRE_JQ:=yes}
+REQUIRE_MZ=${REQUIRE_MZ:=yes}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -138,8 +140,12 @@ require_command()
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

