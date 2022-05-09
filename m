Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16E651F634
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiEIHm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236821AbiEIHeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:34:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC552DE7;
        Mon,  9 May 2022 00:30:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xlw2dNj5LO9ZWslvXKbPIL3FrvU+g1Vazh57GyrPuZijqmgz3+C9GD0yEzKkBCe7UdVCZEHujz2wa4KSc2SrQdYSwEiFQ2fYtVHE+onnSNogn9UDX+c9l/URlDNXPlmLpNl0L2gcoEn6JBNxOoV+yfLsesImcskHxa5u7F4TnGAmT06FGhWeHoynA2friEcqA7FkcCVrAIFbjsJm3OVsa7upI+mEjZrQ2gNaKgLZwUU9vT4S481afAuKErvMsWZjSQnbUHh36Y6rKiOBWxLBkyCQMSnIkz3fO+GQvRmXRakErxyI/9VSNne46F86FygnGevBC+NErtUnuFlR8QQolQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxAXCMvfrGbkeQeYyHzFixS0bWo3pc2m8qHs+zf1frE=;
 b=arZmi0SJ3sp8Qe3k/gAeQ+CyfrXMPp7Qg/2ARhepkXjTWaJyqWbuvofTLeHq3l1XvDozILTltw9sCXuDI9ybUzQUb5wblRZ1vY6dgHU3SV3dnQAfjJkpH38t4Iyjn+r2DglmMwNt84A4TylWZO8lieDoGwwh4w9OHq6O4KS5Wf1crO4v5zOXold1I0FMR1RhHeZUyA9vaI+0HommG2+FmAQ27x5BAmHQjKmoUGspG03UXs706Vx1vHzLNRmAV7Qnq9w7afb3li2INCQ2MS2W+PFkEFP4ogTg2eC2wVNyzsaq4sqdEpdm8DogJNvykKOqmLZARTypkKrJtwPC9E6BQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxAXCMvfrGbkeQeYyHzFixS0bWo3pc2m8qHs+zf1frE=;
 b=S+HWk1QrZWsJvONRhgZxKpS8GlV4QE3+arievIrerGVr0XDq8FuEVJcLR+X1bkPbp+Zx7EMrIQ4cn6Rgr5Pu6K30d+DQd2GqZqcApluKZM7V5Pnv1xTLm67ZzEnKkSaXrqScuokHzfLLNXpwfDLe9b0QaLxyoJU81xQBuFGafaNtwVOA15vU+WaMBlz4sCpNzV5M75bwolcVeu6Ib4+tJBsc7gWXnOBz/1wcSBRQcRxUieliSGvEmhS1svF47qcHbFcQpk1Mbir92K0+pTOEjMp7f0Tqt8xvqaazxU84xv6kW7XtjC9un91fVXttvHWK+TciJUBcsfdwu7Vv5j1hVA==
Received: from BN9PR03CA0328.namprd03.prod.outlook.com (2603:10b6:408:112::33)
 by BN6PR12MB1777.namprd12.prod.outlook.com (2603:10b6:404:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 07:29:37 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::bf) by BN9PR03CA0328.outlook.office365.com
 (2603:10b6:408:112::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21 via Frontend
 Transport; Mon, 9 May 2022 07:29:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 07:29:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 07:29:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 00:29:33 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via
 Frontend Transport; Mon, 9 May 2022 00:29:32 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        "Florian Westphal" <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Date:   Mon, 9 May 2022 10:29:16 +0300
Message-ID: <20220509072916.18558-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc5cca49-1c8d-47ac-5d7b-08da318dabe0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1777:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1777EE36DF292DDD0B5EA3C3A6C69@BN6PR12MB1777.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYU1UX2ds0jFtF0W1EFJmZ5RO6z2V0QBHJsXxAqosAtfab12NkH+yBb1bPLKBjiN330sickzzCu59TroM1POSqnEJjIDf80jCZOEbvXxkXciBkKCl0pvzuIpTQeQ31EC81W/FwE4rJnk0nOy9QXX1YIehtPfhbrtEHbGGyhLC5XS6qdP0EY44rE2e0IBpvUaA2BWBaLYx05VFklBteQI7tpwHtWi4PcgxdKd6f/xo/mAgJpxfq5aKxHTID5ooA8Xat9saWykjEXmQSY1rtjhZoqT35eU2Zu2JmmFMl6rCi9CXIrnw89HDsou0JQ6PObTuOkIQk8Z0MBgKCH3zr2O17iYiqhH3e702lF6OmralZD+DNMu9sBK+SLA4KZRZuch8IjhTznI3dG3GB+TmUTaE8fDSjG1iWywGe0IWQHGLRRRekc14b5bARi7tvDSHsXqfcKjDQmP0IgtpxwCFZnvGpcdvjQ3AXqCTAZnhGPOj+bM0KP7HToxN3rPklJVTkuVk7/AV6HmvSkwqPt2VkQ2IfMXvLN7Ga8t1vGgVjUhmG9f25jL3uMxyel/6uQnoczzrD7PjqQSspoeEPqzSqcfHYuhn8U2t8UW8v4h6p2f4mwQpmjax1F2z+5FxlhfioaMBRd3on2+Iv22Hl5Y/MgQGKS9EFREoy24cvlO0P9XTzOHmZAExshSWmKyc/3moNLACjwqap1P8a9xyfNX3EHecw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(356005)(508600001)(26005)(6666004)(8676002)(40460700003)(110136005)(81166007)(36860700001)(82310400005)(54906003)(1076003)(186003)(336012)(426003)(47076005)(2616005)(5660300002)(107886003)(8936002)(36756003)(70206006)(316002)(4326008)(70586007)(86362001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 07:29:36.8541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5cca49-1c8d-47ac-5d7b-08da318dabe0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1777
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connections leaving the established state (due to RST / FIN TCP packets)
set the flow table teardown flag. The packet path continues to set lower
timeout value as per the new TCP state but the offload flag remains set.
Hence, the conntrack garbage collector may race to undo the timeout
adjustment of the packet path, leaving the conntrack entry in place with
the internal offload timeout (one day).

Return the connection's ownership to conntrack upon teardown by clearing
the offload flag and fixing the established timeout value. The flow table
GC thread will asynchonrnously free the flow table and hardware offload
entries.

Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..ef080dbd4fd0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	flow_offload_fixup_ct_state(flow->ct);
+	flow_offload_fixup_ct_timeout(flow->ct);
+
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
1.8.3.1

