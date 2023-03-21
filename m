Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78F6C31DE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCUMkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCUMkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:40:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90BC3B3C8;
        Tue, 21 Mar 2023 05:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uhtr0vlD2jab0GRbps5J+LTuGWs8ijH0xpDxapHmDHF3R8gzgL4XwhoxSdzEDDZb4pKly9RFGf7GMSnqJ5H4XwPQDdcmduRTdhP8HKZUVUa+mFvVcKXsNljXEJ6GNFRrHfwYgQL0v4Sl24iojB7f7r3Pb/m+ASAP54/+8uxsAaLcpBHEd2u1k6pojbZThhf1VF6wRrVJSIizPPxAmFCslOUW2OWLejfWpXvW0AypxYpg1sN15TgqyjOS8YO3EcUvR+hA5GzkFH8/8CFTf7MLh/HDeXXqzuulMhUX/b4hsBiJKXkh62bh3Jv1berwAIseaHAmGGtKAfV+ljR1kX/5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbRoW6+D7/O7l/79tpnWPBKbEQ9EHSjRvBSvgdbmFG8=;
 b=f+2Ri+nwbNfajra1IgGYIm8vzbvp3A+jYwJpUdJGkkG8wiaJLVDYn3ACOBBgUaYXVMFr3eNto2yh5QfiXZgbdb0d85cVt7gg3g6WEXHTvwadopJ+ATdanKXf3WbOXDDhYJM/16jUWVezTl85bDK6408JkNnCEsL4/21UhgZPn6UPJN8s7Bhxdjod/D6VzXlkW+0oiEeSwxM1omPfKEtyU28l40Mrbs3e3TdHwaJei5UFGOKob/pgm0Ggx1lsxtnE59fgAhl3NtPks1kLAcqTFHf6RB9TDdEb2YLInhnb8QvWra7B2sltChkqewkja/pFjwzaacqhXakidi7C1Lv+lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbRoW6+D7/O7l/79tpnWPBKbEQ9EHSjRvBSvgdbmFG8=;
 b=r+oFk3yhrqmQRkbYv2IE7C3qkHDGh/Ld5K2xHA8BZ0Yo+s2pOKbw+SLZ+7L/nheMVWT1PV1H0AeoCpEgiT/AX0aMPE25R1+STOMbRm83NaghEH3V8wbAMYHOUuw4ixWYSeWbfa03iniT0A05XFL0ZQ2Gy2eceLB8jVMf3u0QWAU=
Received: from CY5PR14CA0009.namprd14.prod.outlook.com (2603:10b6:930:2::31)
 by MN6PR12MB8471.namprd12.prod.outlook.com (2603:10b6:208:473::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Tue, 21 Mar
 2023 12:40:10 +0000
Received: from CY4PEPF0000C97C.namprd02.prod.outlook.com
 (2603:10b6:930:2:cafe::32) by CY5PR14CA0009.outlook.office365.com
 (2603:10b6:930:2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 12:40:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C97C.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Tue, 21 Mar 2023 12:40:10 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 21 Mar
 2023 07:40:09 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 21 Mar
 2023 07:40:09 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 21 Mar 2023 07:40:06 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v2 0/2] Macb PTP minor updates
Date:   Tue, 21 Mar 2023 18:10:03 +0530
Message-ID: <20230321124005.7014-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97C:EE_|MN6PR12MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: 8007cee8-5832-431f-8d02-08db2a0968bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PExYr+TX5wZrerjRql709w3u1HclR/tRy+OrySJtbowMjIWJDqjzwdCedS2a2EAtbphwsQW2atypKdYb4BfUie5AqDuCNSJgtvEHCwyZ+DC9zBYOj5sSyv5Hf3TrNNUzEpQqn3ApJ9+VdKV+edBs4LoRpruzdnC9gO+Z+XwvjttilcDixE86Q65bjXReUeQUsQoIUVdVsp1gIOR97bFr46oZzt372y77J4prdFJ31hjwXYxDxzQNRujhDZKKmCha85O91K71MFQUgYNjM32Kt/JXHPZP8+31GgdrVcVMjx3nVYUIalO5GL30gXYFjPfrNYopE4KGV4LSGhnns4Mjznfp7ukSCMvLKzYLBknPjn/VsaxhMkrILEZaPNv+dsywQKAib3jxdZdOusnFiYupWXjEir9KrJ8csxfwLOIOIqOwbe/ZUZMJ0tvkApbMJpkiIiS3dKy+0ayZay1UtOfgYSLQsbON8FPoyNDIxwuNX5k4NbX3DnPYDzsmONxYcM7wvkTnvr8dolDLoprksMC0ORB21l7CD3QxQxX0ktxE/vc81s7bFwqeXl8NHJfe8bqsD7JCMKyLwi0q3+/3sfTOXWB1iS1jk5FZpoY1FS6EUgSlR0i/EKVR/DO8HGHhYWd8tRXE85BygM52JwcfHPY6NR90nJuX25uTx70xF49m7oxjSQbZCldiDJ4DLTgm32v/zT9nqwjG4kTctScMqFwdMnCYbX7dLYNXz+FBSV5fYlA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199018)(36840700001)(40470700004)(46966006)(54906003)(70586007)(7416002)(70206006)(478600001)(15650500001)(36756003)(110136005)(8936002)(5660300002)(4326008)(41300700001)(8676002)(44832011)(4744005)(316002)(40460700003)(356005)(86362001)(47076005)(426003)(336012)(40480700001)(186003)(26005)(81166007)(6666004)(2616005)(82310400005)(82740400003)(1076003)(2906002)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:40:10.2419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8007cee8-5832-431f-8d02-08db2a0968bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8471
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enable PTP unicast
- Optimize HW timestamp reading

v2:
- Handle unicast setting with one register R/W operation
- Update HW timestamp logic to remove sec_rollover variable
- Removed Richard Cochran's ACK as patch 2/2 changed

Harini Katakam (2):
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 15 +++++++++++++--
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++--
 3 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.17.1

