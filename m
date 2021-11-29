Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDE4460EBA
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhK2G27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:28:59 -0500
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:16263
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233060AbhK2G0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:26:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/NNc9p4quwYr6v/sZwPK4Q7GwoNbkhPmSMWPE2PAp53W1NrLL9qxQKQdKjcwU4DljouLjr7IdmbDboYVps8vzJu6QC8hBzSN/lBF8tvGtr9rZjQvAikoKsbQAIfTD2LYtPrKCUKClLOGwewymvICXYfZF/2UDh4Gqza0g4ngL4QiImsxkSnEXhwpHpWGNzmNZuyMSkFeH9VN4zNDqes5ouyAP9GxERnLsLUgwE9Fyb7YhTfncaMurDRjzr2AOkBc/uL58DcngPuB+yRN0iQMaOmpZvvEFoNjQKge3P/65BbjZkkUh21iwrEna7c4gDQ8Le84Z8c5M5oGWbHU5nMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R85RPQX8JQ8Mi+5qdkPkhXZheZt0gMToWW5UCfge3kQ=;
 b=GnRFh8WlFHjLE+o1RQ/PNAm2Fa/FhnODC3CJokVRSJ73UAuEJShm9io5f9LXX/M3AX/TtXfuXXcxan1KHNAQSA3GPIz+Le5VRXjknEnfRAo0e0OLoTZ06kPzEWmLrXylR7yaXLIaEgIkoakQ9e4Ix2Q7SaLLHR7UnD3KnV754RLssI/y7Ukts80mKXG5yLvvVWAA2MUpmw6Y52ztfVbjTNywH8V+4iDSrJ/JhrnzKxvaTtsm60+mP5PQd4xL/aZM3PdKLIEmcG3V8Bur2zPbXLl6/ZTZ4ei+cHrNdNjOB3TvWQp5ZbM+y5L8gAB5oWLFDTVW0ljzIPSVLAJTYQ4YeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R85RPQX8JQ8Mi+5qdkPkhXZheZt0gMToWW5UCfge3kQ=;
 b=W1Kd/P8oM+BNh1zzanOd7S/++JoyhZqatwU2H+Z6wKLvdZINMr2wCmlcorC9taguW3RKOyZxeRdRCffHcI7OHe3vpgRDOBOS51OpMuexIvlhN8BD4a+eu4XIW3lMrnZ2gwCXtMvQJ8XJwmpym3vu+WMwWo3cU9MXHajDNCsmnc5nQimBXhr5jtwL0lqlBcI6Qw++XR/2WOlcy1hbr/3qFt9F+JNVJDxSupXhUpYFnr6wgnNrC1+5lNRvF6QBPrMnIwio8ZSapQzeZEMXn0rJm9x+S4xRvsgqRFcBrDCDMNq5FqT+5LX5j95ZFCUBiPTCMJOfG+cSi4G2mmySm4nf0Q==
Received: from CO2PR05CA0057.namprd05.prod.outlook.com (2603:10b6:102:2::25)
 by MWHPR1201MB0190.namprd12.prod.outlook.com (2603:10b6:301:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 06:23:37 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::d8) by CO2PR05CA0057.outlook.office365.com
 (2603:10b6:102:2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Mon, 29 Nov 2021 06:23:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:23:36 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:23:36 +0000
Received: from d3.nvidia.com (172.20.187.6) by mail.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:23:35 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kangmin Park <l4stpr0gr4m@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/2] net: mpls: Cleanup nexthop iterator macros
Date:   Mon, 29 Nov 2021 15:23:14 +0900
Message-ID: <20211129062316.221653-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd9d3d61-4140-4615-d0cd-08d9b300c6fb
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0190:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB019066F119E5F40993FB8173B0669@MWHPR1201MB0190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdfArOa8/sz0qcrvWVVOhET66TlqpD6qGxbkiXuExAVPFjHK/xyn1P8y6RHaGIEj6tCqEHoLGOn3De567TQ/lugnA4y2PdVfYPl29ozkULCxYr4WFULNvzUmO3ZNbP37l6H1qEorTw1Uo8nlPGShE2w7PSSJX+7N/9amSXLq12TS7AdlfjSBYR+rSH1ASGwD11j/yKaBYpTekSeQQoaVArW0psfVByT0CQbVWBbFd0NY8j5sXZOHioom2qV7v2WH5ln8f3HszC01x78qMl4zIypLbdx7MMDlMP3z86eoJo9F+HbrblUkpp+7GpUpfmx9tjRfQMCPU52jBl9CRcj20CvsqtrGZ9PZU67UUJUXfLInxjBtjQZZPpR/wfYFJDckzvtPXczHUc0VpWUcLrjeM9sUeyHKUG9mWKwr3zz+UuSl8CV1IrfBzYGG0exHOihqnoGxXgqInJKTaHmbWgEjucUNjdDB8Qf/oEcC4lD4VWtOuEiDWelmBD+tfzGeNSJsXRyS5a8DqCrixQ6G8x7WtwRetLo7oYav/eHlBpA6suHHw66O+fN57MLuFZhX/I9YIw6JKOvLuiE+oI6fLGpGjY51evVJzXHYqA2yEsTq1o8adNwhsvnnTDP6E9fN29OBh1k3SXrlspCGQFyVlY/uOlT80UXIRTMTEC1wmy30LNwZFapj9oCOWf/+h6VWL2Ke+UdtqjLaMvVXxGiC3MeJSQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(70206006)(36860700001)(83380400001)(70586007)(8936002)(26005)(508600001)(336012)(82310400004)(7696005)(186003)(2906002)(2616005)(316002)(356005)(1076003)(426003)(36756003)(86362001)(4744005)(5660300002)(110136005)(54906003)(7636003)(6666004)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:23:36.8240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9d3d61-4140-4615-d0cd-08d9b300c6fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <benjamin.poirier@gmail.com>

The mpls macros for_nexthops and change_nexthops were probably copied
from decnet or ipv4 but they grew a superfluous variable and lost a
beneficial "const".

Benjamin Poirier (2):
  net: mpls: Remove duplicate variable from iterator macro
  net: mpls: Make for_nexthops iterator const

 net/mpls/af_mpls.c  |  8 ++++----
 net/mpls/internal.h | 13 ++++++-------
 2 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.33.1

