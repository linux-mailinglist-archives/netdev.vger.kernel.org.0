Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF947C1E0
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhLUOuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:50:14 -0500
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:58826
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235023AbhLUOuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:50:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYrIp8/NGxYS3MQGtTRDDNnH99AoSEkj2tM1MC29m79iIcaKSQKG0Zkerv+HhkoxJmi5TC3i6icrvrNJCw38dETnC6C1doqP7q+udRGfrrrcZmbj5TnauoxlTMLQ85vz7w3xy/Bu3/48A5+Kw1o6XTyZAvNvjCEFJvcYYS2gq/pyaq57rcsr5OuHafjL6h//UtsPaH9fJ3Q0Y8FJKGMRTEGBU9bdSbfQM01OayJjzwjASzRd7MSzEHPjyzptSR3wMNk3OVCyH3DMmiU5pLKs1px/4e/EO/UMhjvMQtw0exHO6UGVD6degEDVZkhaEvy1kqShFyZwzKHMt3CqFof7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIVlKkcOqJ1nmzAKoIRdvnIsmIXwC/JS0IjNlAJZt9A=;
 b=JOvgotg0+7xjAhtqfdqr/8oJ/H10K12s6kiwQVkutYCe/snRxf5oyrtf9DsEEYHTsyVcPoaR9irUPaXvZfCmjHUAzUKKY8CsoEGCHONvVFI7Mkyvx4plpeioLLwKWqtJIvuNioYxra6XWlPA2visqnNwL7+XlcqZuf+DIVuJ23gB6iZeY6bGBMS4ngNdL2J7ykIHy+DHrOcoyLzdN1IdKVHKll3PUdbQGDs8WL70fM/LLS86bR93YXiVhzSsjW0WOe2shqf8fFTU2+Bpok5cxGq4KZR/+CeQTAtiEaSwPFasCs5BwFPO7wxIO23d0khsI5ojZrBSYOxzR0Lt1vqZWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIVlKkcOqJ1nmzAKoIRdvnIsmIXwC/JS0IjNlAJZt9A=;
 b=ferot0cqSsfcR9JyiVXEfB655gTs6LlL/JRnxuvHhXG2i+t1dh5m7GfmsVltxB7EoUSDZiHd6EyR8m3+H9Cr86GAP5GH4wbOWUsOGlsVHOWOdxuX53R0nT2RvZfTM5WUOLo/Nw0XNFxSMhj8kVMR6BhSJhX/Wd8DT8hVSvRE7iS2EonbI05+CYbyAkibhJcJmRrfDfmV2HFb4Gw63sJhtdgg7jPkXVhWGXfTyglwlgqkknQoax5SgbZ7T1bNvKHsN9wGNwctFHA8zhAhd+XXniF9fqb4kpWhjDQ3TuTRhk4+Y92MfLpue3QSYwtw6+WbX7K+9iZUsSJcOMUaS5f3ig==
Received: from CO2PR05CA0100.namprd05.prod.outlook.com (2603:10b6:104:1::26)
 by BN7PR12MB2691.namprd12.prod.outlook.com (2603:10b6:408:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:50:08 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::d0) by CO2PR05CA0100.outlook.office365.com
 (2603:10b6:104:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16 via Frontend
 Transport; Tue, 21 Dec 2021 14:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:50:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:50:07 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:50:05 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net-next 0/8] Add tests for VxLAN with IPv6 underlay
Date:   Tue, 21 Dec 2021 16:49:41 +0200
Message-ID: <20211221144949.2527545-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50a3309f-58a4-4bca-a9a0-08d9c4912ee2
X-MS-TrafficTypeDiagnostic: BN7PR12MB2691:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB26911A4B3CCDAF72015C4608CB7C9@BN7PR12MB2691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTjG3F7axC5Q5bjmJRJdtwCnjHVAvViJfnS7ybiNi+a2S/lVW+djaq0dtk2c70+xA/2KECjWkIMZiPC11AaII2ujpgskPE+aByT46fsN214dM6lvPM2ZxUyl1OSXKXxJ2EVFScQ7DCYgiMg2XBMxnl8iHv3WJrdQROiEs9zRofxmwEEcTDKnYFCG5W2/fk+1dtA55Oy4pTLui/4EkXpmIG00vnxejw8NNe2oTEjxCSKbS8vutGE13Y2GgZMZ9RhLWB+6M1niprVCeBeLZesL+jqV+uH8POtNwUbX4ouZD4YfEJHRCpbYm+yO3eEdqSOThyTVFcnAnsH9AfLlvpRXVDYIFxoe8fUoQPNP/TTI95smtGdmV3PgdwqnSbwO3W6JwyTJdUgtcST5MpdK7W2Xf6Ppj/Z922RAcoTvr0yG00plQy88PefdAU5W484SWFZtHjTwu30PmkfMtPSJtkLlsWAubPWicQZpmWnijNMMC1x7JEEYSD2jjUqaHFbau/3ZKFgROVNbIHQQx9D27eL3DFTIitIH5mzJ2gFY17/xFKbsakYbyFnWDGoTxhY7zyp2/E5zOYlXM/BBPRaCfEcFHg1WKnPRXtZZRBWvZAc+ZiweJJXf8PE7RmVPCtZ7GbQFCuMlof9THko3w0iietjx6dXWV4Luhw9Gsb97Ol1q5aBNziSkMPGkYzAEzlIfA8TITjhh88EnmolBIFyy6Y0CpmOFMKnvhxX3Us/pHDTtZjF/pLXccbhfUXH082/ARAW6T/f7l+bAnUMCUEY9/8HbNFflot22BYGXbBmUG8Zgiw0B272bwxpisqBdlsNt64qWvtibidEJSYmKtp8gdZAjkg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(70206006)(6916009)(54906003)(316002)(4326008)(70586007)(82310400004)(86362001)(47076005)(36756003)(2906002)(16526019)(2616005)(36860700001)(336012)(508600001)(356005)(83380400001)(1076003)(81166007)(26005)(34020700004)(8936002)(5660300002)(8676002)(40460700001)(6666004)(186003)(107886003)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:50:08.3513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a3309f-58a4-4bca-a9a0-08d9c4912ee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2691
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw driver lately added support for VxLAN with IPv6 underlay.
This set adds the relevant tests for IPv6, most of them are same to
IPv4 tests with the required changes.

Patch set overview:
Patch #1 relaxes requirements for offloading TC filters that
match on 802.1q fields. The following selftests make use of these
newly-relaxed filters.
Patch #2 adds preparation as part of selftests API, which will be used
later.
Patches #3-#4 add tests for VxLAN with bridge aware and unaware.
Patche #5 cleans unused function.
Patches #6-#7 add tests for VxLAN symmetric and asymmetric.
Patch #8 adds test for Q-in-VNI.

Amit Cohen (8):
  mlxsw: spectrum_flower: Make vlan_id limitation more specific
  selftests: lib.sh: Add PING_COUNT to allow sending configurable amount
    of packets
  selftests: forwarding: Add VxLAN tests with a VLAN-unaware bridge for
    IPv6
  selftests: forwarding: Add VxLAN tests with a VLAN-aware bridge for
    IPv6
  selftests: forwarding: vxlan_bridge_1q: Remove unused function
  selftests: forwarding: Add a test for VxLAN asymmetric routing with
    IPv6
  selftests: forwarding: Add a test for VxLAN symmetric routing with
    IPv6
  selftests: forwarding: Add Q-in-VNI test for IPv6

 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   3 +-
 tools/testing/selftests/net/forwarding/lib.sh |   7 +-
 .../selftests/net/forwarding/q_in_vni_ipv6.sh | 347 ++++++++
 .../net/forwarding/vxlan_asymmetric_ipv6.sh   | 504 +++++++++++
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    | 804 +++++++++++++++++
 .../vxlan_bridge_1d_port_8472_ipv6.sh         |  11 +
 .../net/forwarding/vxlan_bridge_1q.sh         |  20 -
 .../net/forwarding/vxlan_bridge_1q_ipv6.sh    | 837 ++++++++++++++++++
 .../vxlan_bridge_1q_port_8472_ipv6.sh         |  11 +
 .../net/forwarding/vxlan_symmetric_ipv6.sh    | 563 ++++++++++++
 10 files changed, 3084 insertions(+), 23 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh

-- 
2.31.1

