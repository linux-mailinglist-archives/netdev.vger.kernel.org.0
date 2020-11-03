Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90D2A3F45
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgKCIth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:49:37 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:34416 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCItg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:49:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170]) by mx4.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Nov 2020 08:49:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfYvGOOzXLFKpsBh6G0Jqk2gVPFhxQVqW8E8rEflz07SknS9UN3qbVDYC9tPFbiHpudVqCwVgZIVKYWCueJYnizh21Eu4KCGl4B8hOqKJ1pqIcq/Hcf8d3l2HbTwae6uKflyTUORtb+mbV0woVfT6uXlxmlI3TNOWVfyf2l1AhQmu7jnTkz3X5QAHhRARCm0hJiP04f8WXc9w37TnjNuMh556dnixRv7BUXlcEqjtjediSK71E22/vJcRAzwRjDBV/hl5zPqlD0N8khhjKQIZSWN0DKR4c9a7D/aq8S5EqEZRRGnArsKHxYIiypiQNW197DFcwf9TkNn+Apkqh1OvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=IuwWUirS3QbGuMcI9tBHXToMO7yrjtKraz+BUbv8QlDB/3vycPU8sTGax1m4fjxTRmUi/e8Lw99m/hrsGCVZC643pM856tVJVm8Eg8daurdTTMy9lRj2p5OI9me4XL695mQeA3n+i8z7yHpIKYwSC+3VpZeBe1lLWnJmhq5z5UHgW1LoEU4CPOCwGh3nqGMh9JZuwyTEXnsFhS8cmRT3iT3oJzziQXhzhSVMbEyzyAB6VwolLDYuUwXyEBaHlut3G5nMuALVKCXrvjcXdGpd3qdDpY7nZADDLvtoO560qmylKV7hDlkDPaEiMAFlj/Z+YStMfqLWIJ/EkA6dHdtyrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=XwwjEXRXOypiIIcvJfF8r0F6TsDVQYMO+KSB7NjX3HjvKDnRZVttZHdt7ZvwwvKY7/U9usOryC8oNIVTvu0ds9+XTNaj0td7Fu52Gg3sKSlEiB+l3zAvvxLffon8eY/TSTqrNnFeOU54X/orsqrUPTw4RKGQwjs0Ig4lHm1H5XI=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 08:49:24 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 08:49:24 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v8 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Tue,  3 Nov 2020 18:49:02 +1000
Message-Id: <57a63f8896068d9628b334e32ccbb49cd63272fe.1604388359.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604388359.git.pavana.sharma@digi.com>
References: <cover.1604388359.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SYBPR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:10:4::14) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SYBPR01CA0026.ausprd01.prod.outlook.com (2603:10c6:10:4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 08:49:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91b72ef2-c66b-4f38-e10a-08d87fd55d2e
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB2883BF9302C7FC4F4EC1CB8B95110@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yboY8PtLTck0fdyrr2hG3EhiktldhUwdM0567Hx5jhgYtloQSS8MmkpaM0f64RfAH2F1/jg8QR30dTFTY7MRYr9xUP2IOtABh3K66J9S4nKsYYIsWpY6a2FZvTkxtKglJKpARU9HCXUHR7hqLdMjgytNTkwiyBagVIecfGo2ra4ciwAuYTO23QYqrpLiTE6WB2gzj07xO7odcW47UpCWnpA0BCk20Lf1eP1hDUMgF/HwoDUhmM6RUrUXwhZNrFEbJALf7bNVL4M7wk/49A4fyzDhF+I1S8uh7L9ea9WboyMpcLRH9yS6VsrR0Lzk/94qXdlYTRfHls/L9ehiDy161fe5mHVth7jv2re1Tn35grTDX8rjqDb0u0zkVTVPRDmD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39850400004)(376002)(396003)(66556008)(4326008)(6486002)(8936002)(52116002)(69590400008)(36756003)(6512007)(86362001)(186003)(66946007)(66476007)(26005)(6666004)(316002)(16526019)(478600001)(4744005)(6506007)(956004)(6916009)(2616005)(8676002)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5+cNWK/da2lM/3Zk2xhDYJImyXvJXcYduZgTbkCbVKPCDYoaImJsfGEESOqz470WGynHRUjiN91rrj5EG2yxkytdZzlWQZWZnpgW9sHj/Kr0x2hWxNZQQRsNKAtScuR29s6Dti6KUqTFJGRpRLmkLSbMSIs4v+BGdAmLQZcg4EWrLb5eub4ekFDH4SMeWordxY3ZdV7s5hq2Cp3pLCMBzrS9GkOIJPqtVreIixuMTstCW8FMjuj9XL2t1jD6BKOoA3XcyWxJ78s3KwNIzhoewoARauLVc/rDn8AiB61MeM0trF8fH+zf3bC1p3q1gHMWbAnynYaixe8NkDV1uBZT+JKCTR1Po8JyzYmwvH9gptqdd7nr448Na6cHLHfqzgrJ7p1/Os7H2tyy8s+sZHtZ/Vj//fyzGIp9LrsM1cAih+rmzy85TWJFqSgM1/q/Lb137PfU9ZFRF+ah5oQ5+JmWBk5sTmDK1gnznfx5JZtw89jcuvK4GCzOftV9U+0wIuuaHTYDvMe/eLoJuHh+W6z5wyehX9B0UZ1kc54b5N1yIW10V4nmOEK1qRULmcvMbIAMoBHKnApKP6eaKxakruyCR60v9FiXW/Z3G+r/+yKitwCakLp/TZnhUnownLROuHZG0m0AxCuf3S8uI7rbvYDVew==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b72ef2-c66b-4f38-e10a-08d87fd55d2e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 08:49:24.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8iIEHg5DGqIwWA+1bXRBrKvzIm0e7znwZto2UYYKVRSfb/jEHwccjppBFzh4oeeX5DT5xzWz68uQDZz/qhZfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-BESS-ID: 1604393365-893006-1653-70004-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.58.170
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227933 [from 
        cloudscan11-215.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        1.20 SORTED_RECIPS          HEADER: Recipient list is sorted by address 
X-BESS-Outbound-Spam-Status: SCORE=1.20 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER, SORTED_RECIPS
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..aa6ae7851de9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,8 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      # 5GBASE-R
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

