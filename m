Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D5F3A674E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhFNNDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:47 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233304AbhFNNDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhQCrE5XiGpox3fWMP2GzKGzqmSBn2e4SwhgWURbMBdCjdG/nlgbIA7EFaWgnNBD7wGhGeri2Y8O0L4TppgljgPAl0VtlhRSZUK/6KcDAs33fYVuJvuHSGzKKuYudLwAIr5/FZp9JG/LjtJbwi3okw2iqVtuqHz8YzlJd9Ej0pytaIujgZLoyxbHUKbDONiGVbXE45dAkNPMQ4K/u8nRF6WjhmgMgPxzVvVi1RLuCw6YZ10SyJIywFZ97Br6O1rBlfWd1RSz2iUGAjSbFhrMB1FSxxCwa1Kq0mQxuJ2ZTNkb5BCZPCQZ1qInrd/ejMGo1vIxo6d9VgubS9TboBNSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2lDWVe+IBUBCHeJ9EXu1ejzqvj+f0xU5dG3BVwHa/g=;
 b=iVvPzRukXkDZ0zH2l3l+lvIC7qQotrYSHqlz2yUsui/rgLZ/oyQF4CijBX8z8P/Tcv6aNENvss0VBG+RJqF3LjheTv7pikjgssNLZVjO+85kCCacdZFXa/8U5QDXK1BGZdZQSJjFx9d4h3WFuTy1IyMJ+v1zoJWIZkdeFVOAqwXfINIuOsRMNbm2HqVr+KILEDtRacD0t3YbyYCMyudUHeTxy3N1GAXwot8VUgWLY+tvldzjupAuwPu5Ze3+FXbMhuzocRjq17O3y+UbpzWdrxC2w6KtlDRqJJVJM03JPz+pz5/nTZPd0puwNTQM/26vAPEJ8T2FivIN+b8nP/do8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2lDWVe+IBUBCHeJ9EXu1ejzqvj+f0xU5dG3BVwHa/g=;
 b=Xfd8I6X/cIlDvkj46/8agEp3+bIM/2c4cxmiK7UrmgEveLRkMU5nvRJnUL3jDt03Lxn0k1GY86liKeje8MbWRMqtM1cCjkbEd9EAQDCLEbgkti+lNfTepzKbXf7OreOlaKW35+P7mVLS+KHdQVZE/LZj06TMtQ4ZkuO8o/4Y51s=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:37 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:37 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v2 2/7] testing: selftests: net: forwarding: add devlink-required functionality to test (hard) dropped stats field
Date:   Mon, 14 Jun 2021 16:01:13 +0300
Message-Id: <20210614130118.20395-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec4e8530-b0e2-45cc-5ac0-08d92f348b7c
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1396D5C1556B8A121B83675EE4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zu3wNOjUkIFcTtyS7WQrbF5yISPsjQU0I6cPPpOvAyF5m3uJQOX4+/phBVOZkhFzeYa+SHhrV9UO0WlYi7W/bZKv01Odcl3V2j/DGtnFz87CzHngeuPNwus/AyKrttly7Nq4REU2u68tcOqoxEPElRy4dqSrk14q2dryUrtYzcwepEPZBCYArsSeM/ZHB0YEHznKs12RekTRqjJ0u8dg3HS3upQxxJZFSHflM1FpT5yt4aOsfr251a5FJV2J6LLPns9lhZY25EB7nzuqO7RKrDa4JGwB8vjFQx+Q6ntfxYeELvewEzzabA+Ok7T9zFPvVOHpEc6tecdX8v73KffpwiiFiv47JJ1SgxY4PWR639oQxUaPCigeQ/EHIBiutm9jAcpfxt19mg0eosx8Xn/1dd4DndvtmhHiCKF1SMiJyQJk9St9JAMvX2uYsvtQ4ZlqFARwPzkm1udorM9MM5IyBJRPPBmv8woQhemt4gahC2jsvAODMMY/uu8Yf1QTK5KFUAr9RO94zNLZ9vpbSpNImKzTlAABjObbJNqXHhsu4Y2Qr2ChlO9vOWUG2GpPhnEC8bdmGPY8IVKwuXjs4hBPahPo8yAKjC3g6ptP8HujA/hGbL2yvD0An66bM8pZnNcNMG+nEdYiRFtvMhWQ+KcVZgcj4Yv4DC+HoHDd/rFJsPE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(7416002)(66556008)(16526019)(186003)(83380400001)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(6916009)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mTCl8sd2PYLEkaVaN70P5sRD/3OoLIoElvLrprMd0AotKGjfuOGQGFjNj1mV?=
 =?us-ascii?Q?HUVEmKDl/4oLJKe2T+UiIFck2Spyb5/Ve8wY3n2BvZnknnd07rTwYe4bPT8Q?=
 =?us-ascii?Q?h7LDwMTaIrwdfoupTb6ctsJJ+j7PagJ1xoDciCI221Kaqh3ufiS0Zonbg89E?=
 =?us-ascii?Q?6Dg/k5KjangXUSHxbWlm8u4UgkIayHAv1RHeUdfviifcWLRZr4m/UDIaRZXo?=
 =?us-ascii?Q?15cvYZPMMovJGVrjpav06h2uRixOoaF4K0P80Q6eX3YMHkOVeMSYpStL+aSS?=
 =?us-ascii?Q?jH6vrBB5arhJRqZTa09Y2yiHAnLvuSTQycXRDepV23ViRhea1ZOSF9vQ2fU6?=
 =?us-ascii?Q?29wmNdpGNDJbuPIEYWjrBTo1ULb9ORGSk9876EltbZqku2XqVajjDtRShKup?=
 =?us-ascii?Q?MQg/A22HzLZ6C8oKGd5G8zXd/jUKENBre0uESUTH6lfhXu65elBW9T5wTRU9?=
 =?us-ascii?Q?MQDZ1XhOxvalr57Hxm8IhctZijr7p6xUkVtzayUloSja2xd+cdsHWNJVeL0g?=
 =?us-ascii?Q?4OPSxppBmzLkiPNicKt41DWU93AAx5ki5rfvuCXBs9E9bnpwMRSdC1X/Ap/w?=
 =?us-ascii?Q?Iwne+zho8wlfWiocLjUGmtkv0Ub6YbYITXa5sxVjoNpzq1j3MyCY4Ecy5NNk?=
 =?us-ascii?Q?yCw8eZoQRF0W9k4ySMOJRWym9e92LetCbbpKjAs6DnG51GZBUFMTghnF5z5i?=
 =?us-ascii?Q?9gVcoCz4ivZxdQiP/yqWAWPjw1QdCmGhzsdFIgW7Kp5U4UQzr4m+rjQ1k2dA?=
 =?us-ascii?Q?ms2uornRCk1RuB/4v3Q/Ly6gOxDmLI9ssUi5eYYW1FLHDeMRQILEON0cb8M+?=
 =?us-ascii?Q?WMBM7tWpWyJLpTe1AZfxMIrz0ShAy+zuOs7afWwxNtoQm805SUmEXV9xZ0Ws?=
 =?us-ascii?Q?bwjYcPW0vBhWhTUTe0jzgEp0DmaNu9zIBopDRGlYGICHMMGKIDC37UybEpef?=
 =?us-ascii?Q?as+VYDBeCbBx+AxEVYHXSNPm0bIJ/cVBcYj/SeIL20RGbgNXhuwE7QmSFRzH?=
 =?us-ascii?Q?4nUEBEj5aPvs70VcVhKOwytxyl2wK00/aemVdeCKTZi/ffWMycmFshto3NPh?=
 =?us-ascii?Q?pgUxtc/KO8qcUOC+4KOuixQDynlUSakwx9e0tU5MDMQdEZuid0CJ2grs5Lrs?=
 =?us-ascii?Q?NNRbaZaD1pAJTYRhfInQ5jBIOu6gzwfVP7AKCARcYKnyrnvMd5SmdEmfn0XD?=
 =?us-ascii?Q?4funr02Nsukgu6d35AdnSIc/H/G70Sdy6aTtet0jMFA0pzzbVbNsF0eJVZSe?=
 =?us-ascii?Q?KhfgmiCfGRdVnuVNJb0yE4gy4/T/tb/ee1G0n0maAN7sUcjguhdTdLWFqbIx?=
 =?us-ascii?Q?GCDyZSNC6SEZk7NLOtKBVNi2?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4e8530-b0e2-45cc-5ac0-08d92f348b7c
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:37.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZIgbvAWLUPrjIBXi5ttDZtpfqf+QHLlKBIX7BJh4P5OrbNLM7LapK3yjaHSW5g/ocfExbBFPI25nM2FOIsuNFkCzh0NEQsceKLXh6q7YlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink_trap_drop_packets_get function, as well as test that are
used to verify devlink (hard) dropped stats functionality works.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 39fb9b8e7b58..13d3d4428a32 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -324,6 +324,14 @@ devlink_trap_rx_bytes_get()
 		| jq '.[][][]["stats"]["rx"]["bytes"]'
 }
 
+devlink_trap_drop_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["dropped"]'
+}
+
 devlink_trap_stats_idle_test()
 {
 	local trap_name=$1; shift
@@ -345,6 +353,24 @@ devlink_trap_stats_idle_test()
 	fi
 }
 
+devlink_trap_drop_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+
+	t0_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
 devlink_traps_enable_all()
 {
 	local trap_name
-- 
2.17.1

