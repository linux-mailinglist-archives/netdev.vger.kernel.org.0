Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57AA4ADB60
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378354AbiBHOkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347514AbiBHOkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:40:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906F6C03FED2
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 06:40:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjxt+ekqoCLZxauuo3PTOedVYe2xgxZuZYVmWXBl57Ba0fTe/MBa1RlyjKqNmWuNvNjhFfJkJAxVTP2i53tjHRtJQPHDz2mf6Cdfnw8gDV5862yLRIkmPzUV1Vj80iQri5iU7mVNJXdqG9u7hl/2mAB9khf1+6HgMugojG18ahcvB5h6LXjnxnHPWzPbP4vrCFO1X0JFSZv8IrRWR4vG+t0yptt3K7NUdbZ/B3S2neum0pvkQhSNHjqQi1XF7KKRfNQrTadOQ4AtgIRqmunCIQ7CCoEhGcPQ/2bN6obtabh4u8+3c3LmRJsnHDezokmOx3vdVoMikMpIQKHE2Ilabg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pk8sOHI0CWS5j8UVyFRnQnwaiQvZYlcLA0lr4TaUemY=;
 b=ZJtMOhjriUGURUhV3+PvOOIDX2uI3evckuWxR4U7a0YVnY8VIeo6Ndag1kI+xhYMx7GDzYXG1iM/WJj11f7D26brMC6lqlnGD5niMe9b71rgwbGgjdsgYRnWLC7ggLmhn0QMLQqZCExGiYkGbYmqJLTEQIrLeyAB8GV0j7XNJ0ok7bp1v1hCHLKxpw1Npo/EieiI8lB3JjXcVdF0C0KiehMEIjR3hlQF5Rr+ubeJmVPwd2lMrEbowrpiTlDnOIqiiIwqm3reqrD1Br7wmMuVwENHd+gandYxfINAYugQsMWi4dMvTCNwBV8uL44OXzol/QA5jWjIYr9ToRCrelAvpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pk8sOHI0CWS5j8UVyFRnQnwaiQvZYlcLA0lr4TaUemY=;
 b=qZykmozuMkT1O3/cqgJaxgSa77ovv/kl1gkX/C0U2h4d087TKDPub3YXtDuo6n8618vROOYWqaHxD6DIuk2tpJAmCBa4/WkPH+D2NTkok/+hL005QCgGP/AXZOUdlpIbIv2B9e7W+GLLaa5xY8A39iebdTC+yvLaC0HYnGQyw3kU7UouwSPfWE76yqeilOEBp2kehXh3YshKnbRojFyfM93PQiunh/noddUxoH4+CkSsfCui8yG4guwdmR0FRWx88kKaQjiltfD0MToOT9Y+wDNBwY/MIsmN7yoYSKgmG9oPK04/xRaelSYFkIKCyvLeRgE2eGmhay/O5wfeSZRuhg==
Received: from MWHPR19CA0058.namprd19.prod.outlook.com (2603:10b6:300:94::20)
 by DM4PR12MB5343.namprd12.prod.outlook.com (2603:10b6:5:39f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 8 Feb
 2022 14:40:10 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::a5) by MWHPR19CA0058.outlook.office365.com
 (2603:10b6:300:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Tue, 8 Feb 2022 14:40:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 14:40:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 14:40:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 06:40:07 -0800
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 06:40:05 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH iproute2-next] tunnel: Fix missing space after local/remote print
Date:   Tue, 8 Feb 2022 16:40:05 +0200
Message-ID: <20220208144005.32401-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 314982cc-e044-4fb1-7f02-08d9eb10e821
X-MS-TrafficTypeDiagnostic: DM4PR12MB5343:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5343FBA53F8C3F02638CA630C22D9@DM4PR12MB5343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:390;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpPEaC7w+HemmwtT8lytYvfQZecwI+pg5IbnwMAH3Lu1ceVfsK2Cd+i2mJvGRoy0ODyOtTG2xAx1wR4ePNKCbTg5CIeB5W8XRyH23o7Ap5KiDcA/+wwFfdiKNtEBf2Zd1BmvdOllPpkLlvTYFSt2A9LVoc+rlGoBJevslgVqEGdJs2sRmTkqVLRNvgIq8u0tJU/ghue/X7OoQisYoy6ceWzY/efHb/FOY7II80vqv+CGuZLTB86gehY2y70+LZNchrM8VX72uabEBBThTtjduK7uUg2ZdTFenqdAZEiSVyq1Bh5y/bJdtTW4Cr4zBEbpQKOP+J4jx6ZznTSS2XoiQyHFTcr5Wl4UMzxDSRSis8vsOwuGvPmKqf4YQ22rE4d+2mwkc6Vqx6Xo/N4zapUOX98ui143d3aAeUSdvdTkajxSXZoY8bOkY721i7pma7wpeak+octFByYLlzn5G2dZtA97P2obS1LYMdE8qiNXbTE2EV9ong2Sv7nbFLQspjplm67hsyRix4SQUHmXifad8MkN9EEH3n1CjeKyu+iwxS8d2cppIWJxRPIbrjn2VZWiGSt7MJiGsLlNURbkv4evfGu3GAgMIsZxxyo9lDukKavbrcqVKM5DTb/l+XzXTBK1rN2zwnpuMgoXsllqCNfEewHsErXb/8QSbJa8oKT32ql8dKWpTcGCzhLKNWPsmJqvaOpwC4AzgQLbJa2lbHszXQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(86362001)(336012)(186003)(26005)(1076003)(426003)(107886003)(110136005)(82310400004)(54906003)(2616005)(316002)(508600001)(356005)(40460700003)(81166007)(7696005)(83380400001)(36860700001)(47076005)(4744005)(8936002)(8676002)(4326008)(5660300002)(2906002)(36756003)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 14:40:09.5055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 314982cc-e044-4fb1-7f02-08d9eb10e821
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5343
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit removed the space after the local/remote tunnel print
and resulted in "broken" output:

gre remote 1.1.1.2local 1.1.1.1ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 5632cf69ad59 ("tunnel: fix clang warning")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 ip/tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/tunnel.c b/ip/tunnel.c
index f2632f43babf..7200ce831317 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -299,6 +299,8 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
 	}
 
 	print_string_name_value(name, value);
+	if (!is_json_context())
+		print_string(PRINT_FP, NULL, " ", NULL);
 }
 
 void tnl_print_gre_flags(__u8 proto,
-- 
2.25.1

