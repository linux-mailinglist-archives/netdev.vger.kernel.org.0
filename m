Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0F9117BD1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfLIXww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:52:52 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:11447
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727352AbfLIXww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:52:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae64hjE/LQem4B02TGKTzadz6xAxQr3JJs5fXTVxkgIoU2U0KRkGr4VV6Tx4RsJ9bwooPYZam3p7fk518ZR5wJAqB+3qTla911bgo0ST5Joa8iyQXOTqgqFvGlU+zjmLAgOInztA5rWCLZws/cldLAOhETQVcPSIDGEq9U+3bm1wKH3q7dVTNPSoIl9w05xD8VJ0Wy+/Evf4b532RvGP3jGK2Gp/O+Nb56WCek9BCYmG2HXBRustR4SW8kW6NeI6i4ZttNiGY2cGl/YoFgkHfz9ENXsvQ3OM7OCZnx1R/lhQ4p9rE1TlTxzgjCNMXilc0sD90U4XkCXQkLRfdJX1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TF9uFdxKmDnXQ2pI4Cfu1vs2Dyw3nCYVdDw9cQ0uv/w=;
 b=JnMu/QRECAZRYC78W995+bd2hAVxs64sztZCLDMgUH/p6d65hHod3c8RG9Pemh5QfB3TxsPPToXK6VX5kfvxw/S4Ex21iOQro2RqSw/x1NCrbaXIF8lt2Szqpa8N4tTYDIKT1GgBs87z4pdFDO0xfu8guP1dhPM7JNIWc11FnROD/MejKJioj6Q0ZihPdQ1S6b5d+YxUdO1zKZR+wL8WcWrZCom7dmLQWUgBvJFlQV7SegUi0vtOMT/U3KPymfJYwjoy7xiqU0Is4vjr8boMVJVkcRrsWlNtIBzGzWi3NDlxO95BaTseo9khx3Lpq8TVY1M7prCel75Dz897zmm5Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.176.1.74) smtp.rcpttodomain=davemloft.net smtp.mailfrom=ericsson.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=ericsson.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TF9uFdxKmDnXQ2pI4Cfu1vs2Dyw3nCYVdDw9cQ0uv/w=;
 b=clsJ/m8jj3sF3l6Y7Jz2YlhbJXv7EdYvb1e/p0WyM/UXixWbtA6Znh4ZGLkw6lg/EF9xjr114swytv7dC+jG3mOjW5snIyiDGHWMj8XqjeCxMYoW6NxKgbYkdHwk9HdCbLfuqe5NfDfhUAL7mpJuOzY+mydq/4JDC1riLWckkdg=
Received: from DB6PR07CA0195.eurprd07.prod.outlook.com (2603:10a6:6:42::25) by
 AM0PR07MB5666.eurprd07.prod.outlook.com (2603:10a6:208:11d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.14; Mon, 9 Dec
 2019 23:52:49 +0000
Received: from HE1EUR02FT039.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e05::201) by DB6PR07CA0195.outlook.office365.com
 (2603:10a6:6:42::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.4 via Frontend
 Transport; Mon, 9 Dec 2019 23:52:49 +0000
Authentication-Results: spf=pass (sender IP is 192.176.1.74)
 smtp.mailfrom=ericsson.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=ericsson.com;
Received-SPF: Pass (protection.outlook.com: domain of ericsson.com designates
 192.176.1.74 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.176.1.74; helo=oa.msg.ericsson.com;
Received: from oa.msg.ericsson.com (192.176.1.74) by
 HE1EUR02FT039.mail.protection.outlook.com (10.152.11.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 23:52:47 +0000
Received: from ESESSMB505.ericsson.se (153.88.183.166) by
 ESESBMR505.ericsson.se (153.88.183.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 10 Dec 2019 00:52:46 +0100
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.193) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 10 Dec 2019 00:52:46 +0100
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next 0/3] tipc: introduce variable window congestion control
Date:   Tue, 10 Dec 2019 00:52:43 +0100
Message-ID: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.176.1.74;IPV:NLI;CTRY:SE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(8676002)(246002)(356004)(8936002)(110136005)(26005)(2906002)(336012)(186003)(4326008)(5660300002)(305945005)(478600001)(2616005)(7636002)(70586007)(426003)(70206006)(44832011)(86362001)(956004)(54906003)(6666004)(36756003)(4744005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR07MB5666;H:oa.msg.ericsson.com;FPR:;SPF:Pass;LANG:en;PTR:office365.se.ericsson.net;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c0c5326-e802-4ee4-4b79-08d77d02e4e8
X-MS-TrafficTypeDiagnostic: AM0PR07MB5666:
X-LD-Processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR07MB566638EDFA17DC38424D66E19A580@AM0PR07MB5666.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0xR0j/CyIc0Ms70UF1ImpgoJbFbwfPOZIOE2JDfEHnwWrPEcrNPl4FBFFdaJ94JboypVrQzkC++i9xEWOi4Rmejb+5ySwrUNtFKQCWNss6ST/GJQP0I9Dhio2b3tS43eTlg7YinwuHF9+r/PgJzkkgJq9RhVkcXw0s5l5Zqm8CayGR3BAZjBEuK+jIriCoWtoclhXOpyfNudWMg/G8HomQErHcz7UUNv7Mde8I582PDUm1LDLnl8WlZplj+bjQ10KAvSlOuhqtDPp/eAh9gPatw9Xs3h1Fgdx4KQqtIv4PcWFnvxjzcnWl9cPqSteJWJu/8b6HBB4LxHP5PdKYjHvVnELapBJH8+ev6SrLoWGRwp+MG20ihZ0CZ9yP+kqSiHoQKuLLqaFFTOpuQHaePX8sm4TQP964sltdogobKGOUULlgOLbXyWG02YtvczjCm
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 23:52:47.9359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0c5326-e802-4ee4-4b79-08d77d02e4e8
X-MS-Exchange-CrossTenant-Id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=92e84ceb-fbfd-47ab-be52-080c6b87953f;Ip=[192.176.1.74];Helo=[oa.msg.ericsson.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We improve thoughput greatly by introducing a variety of the Reno 
congestion control algorithm at the link level.

Jon Maloy (3):
  tipc: eliminate gap indicator from ACK messages
  tipc: eliminate more unnecessary nacks and retransmissions
  tipc: introduce variable window congestion control

 net/tipc/bcast.c     |  11 +--
 net/tipc/bearer.c    |  11 +--
 net/tipc/bearer.h    |   6 +-
 net/tipc/eth_media.c |   3 +-
 net/tipc/ib_media.c  |   5 +-
 net/tipc/link.c      | 191 ++++++++++++++++++++++++++++++++++++---------------
 net/tipc/link.h      |   9 +--
 net/tipc/node.c      |  16 +++--
 net/tipc/udp_media.c |   3 +-
 9 files changed, 172 insertions(+), 83 deletions(-)

-- 
2.1.4

