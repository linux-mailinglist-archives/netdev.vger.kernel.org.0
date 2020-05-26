Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793B91E2801
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgEZRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:51 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729825AbgEZRKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLGavh/EEoxRSMY1ZTv0BFWSvX/OAFGU2nuLtaB3JZSipLp7rqzI/qZAmQn0PW79TB8h0NoJjKiS1Cj35YwYnlBC6UY5jKVdBHJp6o4/PWlQyb2ZN1zOyQjQYQ5cnzNRVZilKHyfHjeMEnZcjUdZhHlvMNyHaAIkw0jw1kFtgjF/Om0XuZAzc9XayFXxZ9pH/F6uVZs1rgCgWWG5QwleNCbHrbqIZql8rtKGiOQjJ1Clz+1xiM4mtx83KN57PPK2m40MA2C52kNZykTo0oTV4NcexI6TAnQkNA42a0zCcVhXCg7gMRdYhCYiW8hE0IGEOk8XU15I+WshwitvdSo/2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFvt3AYzLc8vnVuXKAbqnOwhelN/2Q1uZcpGzQ5CF1A=;
 b=LTZ4nZJodYxflDcSUZDaC//sEP0kU6BfvCXs7Ap7ZSLbhNdmqdsxEkAkAcqEnAMdLl1PkqJWlJzY6zI03jfZ0zuX+OHv1U7iJKuIBIVQIaopgCCft9tNu3zcMjnBGRkF4y4msLPrGM8pG9bkmJ7ajjKB/AXj/LKVYWuI1dDsCZzm0KCs6jN70mzxWRHAdD9PZp1fFBGLU3OKcpHT3SFSAHSoP0Cv8Woa64T8xqgXirFYg/5Tp4NeiLXOP6iv9p98UkbI/8haoW+utw8qYT3bblz449PoHasS29xEIWWy9KDeARYmLxjaiwcsFHJKee5qB0eL3TWVwQFPAZ63sfAGxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFvt3AYzLc8vnVuXKAbqnOwhelN/2Q1uZcpGzQ5CF1A=;
 b=gvizpGOvlUUFZUbo3F7q2o0l7xWu4Ps3bX4cv8gMAvrWwPidOR0uwelT76fczd06Adao13baYQPnDYibo//zCsRdFUQPSKdQqoEOTuQoCUjqI1o81XHepTKOo8r5ANzgySIsqIcx63CDup+/8mmOyL4hjKvCIaUAonQKxKCSBc0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:39 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:39 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH iproute2-next 3/4] man: tc: Describe qevents
Date:   Tue, 26 May 2020 20:10:10 +0300
Message-Id: <b804110022027fd4eec30558c03504e066071cfe.1590512905.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
References: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:38 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 87cdd3ec-9fd9-41c6-1b92-08d80197b6cc
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3225D08F7F1C6578EF1AF45DDBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snUsiryf1FPIT6mU4NDBI3wEhp6iJDc6+inUcxD02Y/CBz4jZVyVQfO/T06ZwWic7jvt4pnC6XDk5lozeqSxb9ZrRKmEggQrZxen3z8hB36toV6SOt3l/Q5iCnNqn468sZkZC9lnxlHUe22Qgjp3u9JGU6EEd6pXzKf49z3Th5ClfcdQgRhsB/pXi9w5syAtMPlvN7WYyOcFSoztVs/VidDA2vuM/lnwsL+HNwzHDY2Mw51xJ4mpqTMNuEgrWPAITA72ea4z4C8qBOn2JM+WgExvpaFJZL2doqgrEjaGYZWUOb5sGQ1AVsu5rO4tpOnRQ5azbxkQ507ZHXeHb4eQDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GpX/T1OVz5zcbsNV+ePgMHVJxjnLQ5XMKFNSejnvp7rlInN3Zry+VwS9VOMITFjb08Y5zxlyGDvFxgUeR1VhmfySbvhhUX/AE87ayF1i7YqbgnjGt4Wbz/11ZTF5Q0mXRt/Yb9hl0UR/kDMxriCCQu0/TJofXx48qnB2sf+7SteQC+dgv4C+poVWnfndi8C81qFkq7bX+FmlfAxqeDsUmyzCXeaxau1aGTZ+x1OyHnAeW0WUd2KqqD41mfWgGkXcWAL87jMy7oPEwV7mX1pDn/znoMiXWp2qH4+ROrhPtJVEJaKMptc0TkQCUfgD+JKwnJ12LVjY7qTSaRBjn+HtWD1YsL8PgDGHpaTd/eUzIUI5Nc9zE8Gs/zAE6J7oiPEV7Kmt1LCZDi7UwDizu0gVnWlNJz5JPXl/jGZwLtYVgXGqBj5MScxJ2OrRNltAo/SdupLvyjJqh3TrhulBPrRxfd7ECM9uOo2QqeGfEMw2jhDh/dlW4EfWq4PjmH1UsXsk
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cdd3ec-9fd9-41c6-1b92-08d80197b6cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:39.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbWDmdm8LKvykaWJsH+5YcqBtr5mvdGRqAiHWhtnV0EdGLa6wymJ/3AWIkdwZ4YEdTQTiDqiU4P2vPDBneSw/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some general remarks about qevents.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc.8 | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8e0cd0f..970440f6 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -254,6 +254,25 @@ Traffic control filter that matches every packet. See
 .BR tc-matchall (8)
 for details.
 
+.SH QEVENTS
+Qdiscs may invoke user-configured actions when certain interesting events
+take place in the qdisc. Each qevent can either be unused, or can have a
+block attached to it. To this block are then attached filters using the "tc
+block BLOCK_IDX" syntax. The block is executed when the qevent associated
+with the attachment point takes place. For example, packet could be
+dropped, or delayed, etc., depending on the qdisc and the qevent in
+question.
+
+For example:
+.PP
+.RS
+tc qdisc add dev eth0 root handle 1: red limit 500K avpkt 1K \\
+   qevent early block 10
+.RE
+.RS
+tc filter add block 10 matchall action mirred egress mirror dev eth1
+.RE
+
 .SH CLASSLESS QDISCS
 The classless qdiscs are:
 .TP
-- 
2.20.1

