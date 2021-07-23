Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07A53D3C10
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhGWONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:13:48 -0400
Received: from mail-sn1anam02on2071.outbound.protection.outlook.com ([40.107.96.71]:54763
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235480AbhGWONk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 10:13:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXHvumjnh00Ux91v79XtsZ9TledaZj45wm7FepnZi/Jl/Apt3fvmP5zddl4MpQ2ysOWnKW6wi+pK9c5eKoWxJj2ZDQvxKbfV08RzMFU+3TWxmNhDJrntLFCFtT5OO8qAPW6nCkxvbUl7Vz8/HBQ7UGqrqg8phSlQOZ85Kp13WiPxx6kKQ1KC3OPgOkx8WAIKUwRcUgmCWoJCwIQhnubk0n5RW7MEhQA+1VODIKNaC/7IS3N1mucNelmeELzGoml4glEhkhZROeibZv5MErGS5AYTmAE2tZH4l8bwJ7mf4J3egEmZJbF9eX1jUXVqPymhUAwClbExxA/PwskbcAmNJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vivtA8RYL7bwpYvp59MpfeFYEr4ijNLRI9oiF2zuKdk=;
 b=OIrdaooZetrdSZykTjueIlFvLp1GHe7JcxPVV/C81uLgvGbraR42XVs0lzknlg4dlknA2dwkF9GpOuHvTDwKYwbcDsbWH6CSiHRFDRKIV0CKbcswCUQS/0AS5LdGmnYvhWqlm21/OEFqhjKIyMv2C3d3eD0OIfF54v3VXFbcOIY0KkMTcwfHc0HfsmZyRq9mtkS/Jp/GCxnfWvKwfq36gpyqLXiiJM5cvWtM3mZOpGcY/qwaGDQ7V0w8TexRlXUg1liUBCCVRyL9SNXcXeUTDim5vmDecXjavS8UivUOARImFXebCF2CkCq0QhcHwEo3E4aF2eWdlVI3PWm7XpLLsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vivtA8RYL7bwpYvp59MpfeFYEr4ijNLRI9oiF2zuKdk=;
 b=gwrcl9XijJEFQgT7ZiT3knVUSL1eAyWGRwvYF+O9x6tV+HRrC28Crvk1Qd2ctbULk9q8AqVOHhJ5PNznV9l+8zgBcp6PGfgZ6sPgOOxeRpycDppzRUD7yB5SyankIPRQMeHdFuQFL6ndgRx2kXX11rTe15uU2t2dH4VHFnjcmSYGNQQgQIbWEMD4rmD9TgCug8cOp8JPClxqAgleQhZvZXPWDVYAtgeZ1XEQEpE90afs8WAd9xqY9iFKvsSCnYQy6nbT/hBDzQeiVe90XDThNAFvHx6t9ufp+OivG3ZN+3b4P9OZI93Cwpzw2qUXsiSjA29WU1AJHdjZiUYj5jeMVQ==
Received: from BN8PR16CA0029.namprd16.prod.outlook.com (2603:10b6:408:4c::42)
 by DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:39d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Fri, 23 Jul
 2021 14:54:12 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::13) by BN8PR16CA0029.outlook.office365.com
 (2603:10b6:408:4c::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Fri, 23 Jul 2021 14:54:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 14:54:12 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Jul
 2021 14:54:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next] devlink: Show port state values in man page and in the help command
Date:   Fri, 23 Jul 2021 17:53:59 +0300
Message-ID: <20210723145359.282030-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 948f1bc3-4a6e-47e1-8852-08d94de9bc14
X-MS-TrafficTypeDiagnostic: DM4PR12MB5309:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53098779334C7FB0DDF7CC83DCE59@DM4PR12MB5309.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtcUqRk0Ajsd0xkBLf+h3W7MQL4ChuqTHwmE6kQxJ39kTTWgLputM7IQ+h1XOB5jL5sYRcarUtWh/Ut6i+T0UJUsqlFmNBImoLP0VKQBPaMSOgQbk4ZUfzBOlCh8q+faTIygb4la7uzH+5MI0C6vWMFs5D53AZMySeqD/cQySdtObngj6RR/Bd3P9Un8bWuIGZmpoJSYPnbujPy84gY4qSlYC0+BCZQOXZPN2VIpTCHO76OwYZyRtC6uD9zTxqJ8Q+0yPGgmrE+p2tX1Ipj3D+rhiR1jW3UxcIySyd30A9OD9j2bIfAmj/QiILr7FXa8aCn/ZiJ9brHauN+yvunhabo9ze5SPxB8ze2W5fR0uaDWAAeWg6kW4X5ubS1HnbXAxUCG87qKQe8pd1mvzy59yDkcYcBrkWOgy0+W+wNqBpuf/kSSdWRoZjjaz/34hO4rdctXEbTw8tDGPvdeldi1P7eASS5d82hAkEo8JZIk1LoKBIN+IUovV7bY42Pn6JBlhKFum1wk4DPbr9Tz534nmQ0g6JvK620fNYfL+NsWApAfJTUIW81sFnAHFa4i506Q+aaBlm7TvcUsLgX4+s7YSdEiFJ6vIEdhP+BuHDRMxJagmZcteNwuPYsLFfStqVxV+85jUb/JNzeIYcRN4wwjNBLAd5q6/6NwOSsDUKMMcJLLnhpt4ffCThoh6BHQgGqshtoaQtPgoA8Xm874I2+J/A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(16526019)(47076005)(336012)(110136005)(26005)(186003)(5660300002)(4326008)(82740400003)(2906002)(1076003)(36860700001)(478600001)(82310400003)(107886003)(8936002)(83380400001)(426003)(36906005)(316002)(70206006)(36756003)(86362001)(7636003)(2616005)(54906003)(8676002)(356005)(70586007)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 14:54:12.6147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 948f1bc3-4a6e-47e1-8852-08d94de9bc14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port function state can have either of the two values - active or
inactive. Update the documentation and help command for these two
values to tell user about it.

With the introduction of state, hw_addr and state are optional.
Hence mark them as optional in man page that also aligns with the help
command output.

Fixes: bdfb9f1bd61a ("devlink: Support set of port function state")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       |  2 +-
 man/man8/devlink-port.8 | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b294fcd8..cf723e1b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3988,7 +3988,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port set DEV/PORT_INDEX [ type { eth | ib | auto} ]\n");
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
-	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 053db7a1..12ccc47e 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -67,12 +67,12 @@ devlink-port \- devlink port configuration
 .ti -8
 .BR "devlink port function set "
 .IR DEV/PORT_INDEX
-.RI "{ "
+.RI "[ "
 .BR "hw_addr "
-.RI "ADDR }"
-.RI "{ "
-.BR "state"
-.RI "STATE }"
+.RI "ADDR ]"
+.RI "[ "
+.BR state " { " active " | " inactive " }"
+.RI "]"
 
 .ti -8
 .BR "devlink port function rate "
-- 
2.26.2

