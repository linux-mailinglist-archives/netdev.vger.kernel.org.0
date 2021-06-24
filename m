Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD03B325C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhFXPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:18:40 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:41760
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231294AbhFXPSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 11:18:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hovenQjar5i3cGl5xYd0eRY2MyxQ0P+PkVrfK78Oag+op9yo9hKGcltI9G1LiS1svocfpxB9QiMu3UGmKmp7pv01FC9zLbcFf6WlOS8+akh4swkMvfCKPCDLlUvpD80zd/t3BUxuld0y0DadWVn7pVzqdOtLgs+KCSBfd+RzP2WNlhXdlmYQOqxNwH3Tj6g91YPU5cqqi5hYcFsYe6AVWFTa4+SQQeX89E2WqJY+h6DllDKeeVmj2CtcV57vPMoz+VCYRzToa4LHd4X3QSgf9cv/jcmT1+mwmsea0sDbdDyeyt1LmhlFLO4PmH+P2G4N87Ait/D75S1YktmNqltNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC9yTzL7QTqjy/jpB3ZMrkJDuQj7v4mWm1U7JnRSJ4U=;
 b=Nu0wiI+/RH9tTprI3EpMjgnpvKr4XitBZZ49kgC4nOEmZBdXPDJN2bHA0uzLJc7wnz1/dLG0Rbsq/Wz42SVMxT3wMczSpOF9FHANHRTjrP6tnD7uNTVD+tJd2oIimv+vlFBEFyba9N6keN7Cl1bKWaVhaDg1BY9ipUjFczDCgJ7NaBY743fmCET9rECQcgHT96ApwfMLeiLL1RmfKJSyoFvuovUqs9QJQvur+5G0xi8yRbaiicYI0fufz9A2FK9hKP5WQVL4y2RXdALNwu9fRQWCerOzx4LohPZFNGgG7cEmNrA1EhT3P6zs8Ix5xqV2tHOi14d2mIXam2poeiBtNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC9yTzL7QTqjy/jpB3ZMrkJDuQj7v4mWm1U7JnRSJ4U=;
 b=dP1jfagj6/Aa029+ulcP8i6MCjwK0XgQ/TF1WFXuC/T1WaqYys46wOHgnYLcaGBJrX/hbQ4s83TtgG5tvmJLPkDER5eGWIZCZqBh4QJ8FGx29r8eq/6ayMUZbl1Mgpp0/BRQ1O2NxQ0hi5QxwNS7RxBFxQvoKq3yp46PW2VEEOnpxDgZhXlyIRh7PvETdHvnMds5J95qNo6yga1RMpSErcpUC5QRH0fO++eh00D1jFPw7SudS+V8aaa1bS64WymQW5rwvfieqOQ2mzUrJQ3quxKc+5bYVAqqJAhqP2/0g6jcluWLYOwgeF7qDdiGQ+cTwRDGt0eDYwds5CpPgOiFyA==
Received: from MWHPR2201CA0037.namprd22.prod.outlook.com
 (2603:10b6:301:16::11) by BY5PR12MB4068.namprd12.prod.outlook.com
 (2603:10b6:a03:203::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Thu, 24 Jun
 2021 15:16:09 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::c2) by MWHPR2201CA0037.outlook.office365.com
 (2603:10b6:301:16::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Thu, 24 Jun 2021 15:16:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 15:16:09 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 15:15:49 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <idosch@nvidia.com>, <nikolay@nvidia.com>, <gnault@redhat.com>,
        <baowen.zheng@corigine.com>, <vladimir.oltean@nxp.com>,
        <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next] selftests: net: Change the indication for iface is up
Date:   Thu, 24 Jun 2021 18:15:15 +0300
Message-ID: <20210624151515.794224-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d499ae6b-8e49-44e0-9454-08d93722ff1a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4068:
X-Microsoft-Antispam-PRVS: <BY5PR12MB40689F35AC74BFA223A39DBFD8079@BY5PR12MB4068.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQCmRs33ZRoBAJfcO95qGEL0yN0/3A1ULgj3kO/qW/OHPxf3x3yE7zYB7jOWmyK3KEbbQ0IGPNWxqwsrK/iMyfkRqBNy2Y8NF7pvjSsMpCDQ1Zjxse4xQIiBBhBWdMKA6X7uPShMqYUPRkIqT2S6vyaPfUU9JonPXnWm5lheKkRXvQYecArOUkCDh6zq3gT99cPGKR6ABKIuwpCWmpRVx4TUjPmkdxKNhbajIcDEkAPogPtA0Zj8TlheHDkBeFDSeCxh/m7+61Zse2NajgZ+Gcb7uRfaICoKaCOcQrmTLLvt9W3aciyao7mlLM8D7b6iqPrWOaF/0fe8v4aU8L3iYsR3+v7ivBA8mmxY+q/GmPukZSOJJYuGfdUSLNiyFCglyTDIYybyE/P3y6bxk7Kdma5wipJLza8mz5q/LU+y92i60sFCpWIGhniMBVD+L9o+EjQArc9OemJuXlsvOCtFWbFZAmDjAzjPmxAlDtof/7YIG46dWA+eOuu50yID04vdhaGGgWXlPLebrqczOJuAJl00ptAO8fFy1vPFwWtYIcPGJugDdbjbFyMr0rVnoDYp5xTITy92jlKbkbPntDg6YatWjdzvk+p1OgLjxjHv+jlZyS7k7KIutV2EiZ9P4CVzNJaOOwqCReTZFY+YCVd3VE4GhO5XB8UCDXjZIb4UThxwONGYubbiu8mih/VNpKyJKL22lTfBbr43aScJJRlvZw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(82310400003)(47076005)(8676002)(8936002)(186003)(2906002)(1076003)(83380400001)(16526019)(7636003)(86362001)(4326008)(70586007)(54906003)(26005)(356005)(336012)(6666004)(6916009)(498600001)(5660300002)(426003)(36860700001)(107886003)(36906005)(70206006)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 15:16:09.6894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d499ae6b-8e49-44e0-9454-08d93722ff1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the indication that an iface is up, is the mark 'state UP' in
the iface info. That situation can be achieved also when the carrier is not
ready, and therefore after the state was found as 'up', it can be still
changed to 'down'.

For example, the below presents a part of a test output with one of the
ifaces involved detailed info and timestamps:

In setup_wait()
45: swp13: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel master
    vswp13 state UP mode DEFAULT group default qlen 1000
    link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
minmtu 0 maxmtu 65535
    vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
17:58:27:242634417

In dst_mac_match_test()
45: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel
    master vswp13 state DOWN mode DEFAULT group default qlen 1000
    link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
minmtu 0 maxmtu 65535
    vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
17:58:32:254535834
TEST: dst_mac match (skip_hw)					    [FAIL]
        Did not match on correct filter

In src_mac_match_test()
45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
    master vswp13 state UP mode DEFAULT group default qlen 1000
    link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
minmtu 0 maxmtu 65535
    vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
17:58:34:446367468
TEST: src_mac match (skip_hw)                                       [ OK ]

In dst_ip_match_test()
45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
    master vswp13 state UP mode DEFAULT group default qlen 1000
    link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
minmtu 0 maxmtu 65535
    vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
17:58:35:633518622

In the example, after the setup_prepare() phase, the iface state was
indeed 'UP' so the setup_wait() phase pass successfully. But since
'LOWER_UP' flag was not set yet, the next print, which was right before the
first test case has started, the status turned into 'DOWN'.

While, UP is an indicator that the interface has been enabled and running,
LOWER_UP is a physical layer link flag. It indicates that an Ethernet
cable was plugged in and that the device is connected to the network.

Therefore, the existence of the 'LOWER_UP' flag is necessary for
indicating that the port is up before testing communication.

Change the indication for iface is up to include the existence of
'LOWER_UP'.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c983d41..a46076b8ebdd 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -399,7 +399,7 @@ setup_wait_dev_with_timeout()
 
 	for ((i = 1; i <= $max_iterations; ++i)); do
 		ip link show dev $dev up \
-			| grep 'state UP' &> /dev/null
+			| grep 'state UP' | grep 'LOWER_UP' &> /dev/null
 		if [[ $? -ne 0 ]]; then
 			sleep 1
 		else
-- 
2.31.1

