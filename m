Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF5F3BF6A7
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 10:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhGHIC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 04:02:57 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:23413
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229851AbhGHIC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 04:02:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvLzDk97z8M6qLw1UbQoMm8oqFwKWf7Sb86blz3H1a9+pKs7cFpK9sfVeCX6Z27KtMs9XFYrDXApkq02qi+fmfBkgkEKEzRRwHjLb1aaOrWk+Mm2LASOcjWcMtEpKj3hDCc1QzNMpcAuS+uPiopzkcdwhRmwgxuVoANdGvxKZwTjHf0B0IneiRDXRzRKX/QZUKZnUYJ67Q0FxCG7h/Dr0QlzzOxr8NEJJKLffj14UkFsLfDzwnIGC9pTzD1j10dGqueqM1EXthvy7IkVL5yhcU4C9zZCpKbkX1vb08SeqmuyXvIuxKjoUQMA2oQp5iKFEj61reEMFsf1c6Xt2njKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BLQSdYRm2DfXVjfCdZttW741q8mZfBvqg+d0IzeNBo=;
 b=F4/sKc0Ecd32bp+i+HvVhfW1afcy+0UmDT65CxkNo47O8J5xKnRJwIBQY+LCzhRHH2zYaExRJYlCAn7ZEkpyz+6uwC5agGcrZFMIor9W6HmlfmY4Xd8IO66IdaArL54SMlxnMuEgwcq67b/CImjrOF4YPORhgC8xZIEqUpfqxVWyG4j/+3ksW0xzB5GzoVMfRilAXeHr98joDGIAG7o0sKFUlJSOhWIwUFIuBaR+v91jO3cbHru2PHvvko1LRzlSuM/RHP81a74oE7GEMHMHfk7Z9VIuqVJTQ+ZKyt2b0hhyOAldfM7znTby9RlHf0P+CpTwfJxn6qVOmxQsiW/jMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BLQSdYRm2DfXVjfCdZttW741q8mZfBvqg+d0IzeNBo=;
 b=jZlWhphbRZBqpLVPonaD0Nbp/4A6AR9LR2NR42NO+v7Pqxy4U4W0iFcv0di+bcMZrzP49wp6w44RpI0bxq+eSXTwCEjEoqSLP8iV4rV2QuGvoBzTsgj3cohwJ54nEJr+Y/sV38gx1XuTM40ZZhXHUXbEB4GWLehMJVprTy7Ojfq6ad3a11cmVtVIUrQvFA7hAyoOxJEybSATdYAgY+D1qOqCpLFO0ew3GVXapCLH/6wXTJMfJzWNWzHfNAILpcXMnb9lH/+PJOdBNnVrfgjCJnFHkFpl5SuP2t0qjeo9Bsw2x0yMIC4/AA8whNVywmbKBhyTIDdyw1PqhER2pVbEFA==
Received: from DS7PR03CA0282.namprd03.prod.outlook.com (2603:10b6:5:3ad::17)
 by BYAPR12MB3509.namprd12.prod.outlook.com (2603:10b6:a03:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Thu, 8 Jul
 2021 08:00:12 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::1) by DS7PR03CA0282.outlook.office365.com
 (2603:10b6:5:3ad::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Thu, 8 Jul 2021 08:00:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 08:00:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 01:00:10 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Jul 2021 08:00:08 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH net 1/1] tc-testing: Update police test cases
Date:   Thu, 8 Jul 2021 11:00:06 +0300
Message-ID: <20210708080006.3687598-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93e90284-c750-40cf-2be8-08d941e669ac
X-MS-TrafficTypeDiagnostic: BYAPR12MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR12MB350968EBEE6CF7695C8A484FB8199@BYAPR12MB3509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6puhe57ATzvsrApqMqNCy1uuK/jPQ+ssXyx6o2MKjoD45EGPxWaVbFU1gRvmUjYK3bNz22AKEG1lW0J6P7j/1JAOrOBiMDHJq5+KN0D8X48hZQrGGb9MnW9XLOBpiMQ5OW35PvmSTzhbguRC3r4kimWXwP74/RWw/PXPzEsEbI3yUt724C4ndDLS7EovbENLoDTdov5UbXaR4OxmT/FrGzZ5C6TUM9Gi4ro9DoLgke48ZqJ5kONQhgKRBcpotHVEZ36NjIKlMpAoZWaCuQyQ5dwn3HKFSZS5MywPD1XM6VFcbpfDi9pzfhClQQZP8gb7/MdGPU6zJdoXqkqY0vC+Lh+i0R8TiHhhVVFw4WdGcz7Y2/GpiErCKFHWt/i1kIHy483h+UPH+8XVqK/itFFDfakYpzLon+9fVJkJPGrzdXuYzccIMkmWyZdcgofNAxxMPh/s89f7scdvLqfNnQ6QT6J5Nbl1hUa0eiOHGfbvjHXCKg+VXX6vNPlFYsHiE2n+B52y9G+4SlwhgcBsLM7Kq+d/LKayBtQH7TPIlO9PW84F2ErHNZeeGTNn+lxwLblZpoDNhdjljjnwWk+ldozgCu2stiLyObe3xAXLe65kJ3mU95yaO+SQ0IK5ZzEIl3Lq3ZyPMFuHWRIe30OXdjRBlw1tsujFq9KNBcHGNHhcXIzcQ8RFT1uvDkSK1mY/kWrSvMbZQ4api7SEj3TxEJPMA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(30864003)(47076005)(15650500001)(1076003)(26005)(478600001)(426003)(356005)(82310400003)(336012)(2906002)(2616005)(83380400001)(82740400003)(86362001)(316002)(8676002)(36860700001)(70206006)(70586007)(7636003)(8936002)(54906003)(6916009)(186003)(4326008)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 08:00:11.9621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e90284-c750-40cf-2be8-08d941e669ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to match fixed output.

Signed-off-by: Roi Dayan <roid@nvidia.com>
---

Notes:
    Hi,
    
    This is related to commit that was merged
    
    55abdcf20a57 police: Add support for json output
    
    and also submitted another small fix commit titled
    "police: Small corrections for the output"
    
    Thanks,
    Roi

 .../tc-testing/tc-tests/actions/police.json   | 62 +++++++++----------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
index 8e45792703ed..c9623c7afbd1 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
@@ -17,7 +17,7 @@
         "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 1Kbit burst 10Kb",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 1Kbit burst 10Kb",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -42,7 +42,7 @@
         "cmdUnderTest": "$TC actions add action police rate 8kbit burst 24k index 9",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x9",
+        "matchPattern": "action order [0-9]*: police.*index 9",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -66,7 +66,7 @@
         "cmdUnderTest": "$TC actions add action police rate 90kbit burst 10k mtu 1k index 98",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 98",
-        "matchPattern": "action order [0-9]*:  police 0x62 rate 90Kbit burst 10Kb mtu 1Kb",
+        "matchPattern": "action order [0-9]*: police.*index 98 rate 90Kbit burst 10Kb mtu 1Kb",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -90,7 +90,7 @@
         "cmdUnderTest": "$TC actions add action police rate 90kbit burst 10k mtu 2kb peakrate 100kbit index 3",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x3 rate 90Kbit burst 10Kb mtu 2Kb peakrate 100Kbit",
+        "matchPattern": "action order [0-9]*: police.*index 3 rate 90Kbit burst 10Kb mtu 2Kb peakrate 100Kbit",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -114,7 +114,7 @@
         "cmdUnderTest": "$TC actions add action police rate 5kbit burst 6kb peakrate 10kbit index 9",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x9 rate 5Kb burst 10Kb",
+        "matchPattern": "action order [0-9]*: police.*index 9 rate 5Kb burst 10Kb",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -138,7 +138,7 @@
         "cmdUnderTest": "$TC actions add action police rate 1mbit burst 100k overhead 64 index 64",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 64",
-        "matchPattern": "action order [0-9]*:  police 0x40 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 64b",
+        "matchPattern": "action order [0-9]*: police.*index 64 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 64b",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -162,7 +162,7 @@
         "cmdUnderTest": "$TC actions add action police rate 2mbit burst 200k linklayer ethernet index 8",
         "expExitCode": "0",
         "verifyCmd": "$TC actions show action police",
-        "matchPattern": "action order [0-9]*:  police 0x8 rate 2Mbit burst 200Kb mtu 2Kb action reclassify overhead 0b",
+        "matchPattern": "action order [0-9]*: police.*index 8 rate 2Mbit burst 200Kb mtu 2Kb action reclassify overhead 0b",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -186,7 +186,7 @@
         "cmdUnderTest": "$TC actions add action police rate 2mbit burst 200k linklayer atm index 8",
         "expExitCode": "0",
         "verifyCmd": "$TC actions show action police",
-        "matchPattern": "action order [0-9]*:  police 0x8 rate 2Mbit burst 200Kb mtu 2Kb action reclassify overhead 0b linklayer atm",
+        "matchPattern": "action order [0-9]*: police.*index 8 rate 2Mbit burst 200Kb mtu 2Kb action reclassify overhead 0b linklayer atm",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -210,7 +210,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3mbit burst 250k conform-exceed continue/drop index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 1",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 3Mbit burst 250Kb mtu 2Kb action continue/drop",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 3Mbit burst 250Kb mtu 2Kb action continue/drop",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -234,7 +234,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3mbit burst 250k conform-exceed pass/reclassify index 4",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x4 rate 3Mbit burst 250Kb mtu 2Kb action pass/reclassify",
+        "matchPattern": "action order [0-9]*: police.*index 4 rate 3Mbit burst 250Kb mtu 2Kb action pass/reclassify",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -258,7 +258,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3mbit burst 250k conform-exceed pass/pipe index 5",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x5 rate 3Mbit burst 250Kb mtu 2Kb action pass/pipe",
+        "matchPattern": "action order [0-9]*: police.*index 5 rate 3Mbit burst 250Kb mtu 2Kb action pass/pipe",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -282,7 +282,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3tb burst 250k conform-exceed pass/pipe index 5",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x5 rate 3Tb burst 250Kb mtu 2Kb action pass/pipe",
+        "matchPattern": "action order [0-9]*: police.*index 5 rate 3Tb burst 250Kb mtu 2Kb action pass/pipe",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -306,7 +306,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3kbit burst 250P conform-exceed pass/pipe index 5",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x5 rate 3Kbit burst 250Pb mtu 2Kb action pass/pipe",
+        "matchPattern": "action order [0-9]*: police.*index 5 rate 3Kbit burst 250Pb mtu 2Kb action pass/pipe",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -330,7 +330,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3mbit burst 250k conform-exceed 0/3 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 1",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 3Mbit burst 250Kb mtu 2Kb action pass/pipe",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 3Mbit burst 250Kb mtu 2Kb action pass/pipe",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -354,7 +354,7 @@
         "cmdUnderTest": "$TC actions add action police rate 3mbit burst 250k conform-exceed 10/drop index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 3Mbit burst 250Kb mtu 2Kb action ",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 3Mbit burst 250Kb mtu 2Kb action ",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -378,7 +378,7 @@
         "cmdUnderTest": "$TC actions add action police rate 90kbit burst 10k mtu 2kb peakrate 100T index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 90Kbit burst 10Kb mtu 2Kb peakrate 100Tbit",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 90Kbit burst 10Kb mtu 2Kb peakrate 100Tbit",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -402,7 +402,7 @@
         "cmdUnderTest": "$TC actions add action police rate 10kbit burst 10k mtu 2Pbit index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 10Kbit burst 1Kb mtu 2Pb",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 10Kbit burst 1Kb mtu 2Pb",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -426,7 +426,7 @@
         "cmdUnderTest": "$TC actions add action police rate 10mbit burst 10k index 1 cookie a1b1c1d1e1f12233bb",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 1",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 10Mbit burst 10Kb mtu 2Kb.*cookie a1b1c1d1e1f12233bb",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 10Mbit burst 10Kb mtu 2Kb.*cookie a1b1c1d1e1f12233bb",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -450,7 +450,7 @@
         "cmdUnderTest": "$TC actions add action police rate 10mbit burst 10k index 4294967295",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 4294967295",
-        "matchPattern": "action order [0-9]*:  police 0xffffffff rate 10Mbit burst 10Kb mtu 2Kb",
+        "matchPattern": "action order [0-9]*: police.*index 4294967295 rate 10Mbit burst 10Kb mtu 2Kb",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -475,7 +475,7 @@
         "cmdUnderTest": "$TC actions delete action police index 12",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0xc rate 5Mb burst 2Mb",
+        "matchPattern": "action order [0-9]*: police.*index 12 rate 5Mb burst 2Mb",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -507,7 +507,7 @@
         "cmdUnderTest": "$TC actions get action police index 4",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 4",
-        "matchPattern": "action order [0-9]*:  police 0x4 rate 4Mbit burst 400Kb",
+        "matchPattern": "action order [0-9]*: police.*index 4 rate 4Mbit burst 400Kb",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -564,7 +564,7 @@
         "cmdUnderTest": "$TC actions list action police",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x[1-8] rate [1-8]Mbit burst [1-8]00Kb",
+        "matchPattern": "action order [0-9]*: police\\s*index [1-8] rate [1-8]Mbit burst [1-8]00Kb",
         "matchCount": "8",
         "teardown": [
             "$TC actions flush action police"
@@ -614,7 +614,7 @@
         "cmdUnderTest": "$TC actions add action police rate 7mbit burst 1m continue index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 1",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 7Mbit burst 1024Kb mtu 2Kb action continue",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 7Mbit burst 1024Kb mtu 2Kb action continue",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -638,7 +638,7 @@
         "cmdUnderTest": "$TC actions add action police rate 7mbit burst 1m drop index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 7Mbit burst 1024Kb mtu 2Kb action drop",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 7Mbit burst 1024Kb mtu 2Kb action drop",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -662,7 +662,7 @@
         "cmdUnderTest": "$TC actions add action police rate 7mbit burst 1m ok index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 7Mbit burst 1024Kb mtu 2Kb action pass",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 7Mbit burst 1024Kb mtu 2Kb action pass",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -686,7 +686,7 @@
         "cmdUnderTest": "$TC actions add action police rate 7mbit burst 1m reclassify index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action police index 1",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 7Mbit burst 1024Kb mtu 2Kb action reclassify",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 7Mbit burst 1024Kb mtu 2Kb action reclassify",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -710,7 +710,7 @@
         "cmdUnderTest": "$TC actions add action police rate 7mbit burst 1m pipe index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 7Mbit burst 1024Kb mtu 2Kb action pipe",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 7Mbit burst 1024Kb mtu 2Kb action pipe",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -734,7 +734,7 @@
         "cmdUnderTest": "$TC actions add action police rate 1mbit burst 1k conform-exceed pass / goto chain 42",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 1Mbit burst 1Kb mtu 2Kb action pass/goto chain 42",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 1Mbit burst 1Kb mtu 2Kb action pass/goto chain 42",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
@@ -759,7 +759,7 @@
         "cmdUnderTest": "$TC actions replace action police rate 3mbit burst 250k goto chain 42 index 90 cookie c1a0c1a0",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action police index 90",
-        "matchPattern": "action order [0-9]*:  police 0x5a rate 3Mbit burst 250Kb mtu 2Kb action drop",
+        "matchPattern": "action order [0-9]*: police.*index 90 rate 3Mbit burst 250Kb mtu 2Kb action drop",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -783,7 +783,7 @@
         "cmdUnderTest": "$TC actions add action police pkts_rate 1000 pkts_burst 200 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 rate 0bit burst 0b mtu 4096Mb pkts_rate 1000 pkts_burst 200",
+        "matchPattern": "action order [0-9]*: police.*index 1 rate 0bit burst 0b mtu 4096Mb pkts_rate 1000 pkts_burst 200",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action police"
@@ -807,7 +807,7 @@
         "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k pkts_rate 1000 pkts_burst 200 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions ls action police",
-        "matchPattern": "action order [0-9]*:  police 0x1 ",
+        "matchPattern": "action order [0-9]*: police.*index 1 ",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action police"
-- 
2.26.2

