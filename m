Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A26918F966
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgCWQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:12:39 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:26101
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbgCWQMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 12:12:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB4ROwgueBkdPkDvwejj5hHJ+tqU4+deFxvFLZvwljKBYLA9bEuFc+w26mENwGlXero3E9IY7Poxd1xnwoy8KjZvaaGkyC3mK4yfTAhtWOkZQtedqQqsRvIdITZW2f0RLpNk9FJnM6/++XqanJTIio6CmR9J6m4ajtqvSVM8Iof3V0UgI24AVEFAYM/rUoyp0o7dgQ3/lU/CYqkVsNQBy361H2bQjWxWWvzsqAjPk4NhOEuxatPIidvX/DTPup/gTsHYUQm0LchqZMm0oWYP7y5kpyEtRsZJ0W1foSy0ZLJZN4VVwJ3cABWWc52mxYLRGS+hY+3olrU+axgi7Lh6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWqewBHwrUqbhHn/SFzE7NWU5XQfJnB/160DtvE/Ixc=;
 b=QeLGRKH5zUBrDBRX2N/46Om5xl0UvqyV73EtkJPtY49pQyvTQCXCSmZlaa7xuTMtDEAKdnlMwL14XRFgMW5g/jljSuP2MHDfT+KBLIyZOHzijzGEK0k5xDDezWsO5mc8RoP7Njab/4DK1p8m8TH5zU0mNoxnGnBhoOG5RLq1FHfLeCJO64/G4A2GBM+hr+pxsugTOBwnyym0089UNxRwjPviyiAk1occHBigxkmFgzPXUdi8hns5G2zIRpjvhKOJnA//wscWbLurIz5zAEtFAL4dotq2KXNfTEW9Ox5Iqo/TkRDDI2HoPmBgBsOdaFfUYLyFGtOhwq3BtQdYF+97Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWqewBHwrUqbhHn/SFzE7NWU5XQfJnB/160DtvE/Ixc=;
 b=U8+gsmEYBtARQR3VsbGg3l9UJLLtWeI+AnXJJDMF15SOcnockjkEI+V4/1WN7oXHn5UkGd7SX8PyHMl3HCgT6J5HdUUDxM4bMNqbMvEOJO28xLABNv33sj1AnXAwrm56B0JAg9r+YpgdPt/s0D+MOb05xjYygkp94k+a5aIVZns=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4699.eurprd05.prod.outlook.com (20.176.168.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.15; Mon, 23 Mar 2020 16:12:34 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 16:12:34 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 0/2] Support RED ECN nodrop mode
Date:   Mon, 23 Mar 2020 18:12:19 +0200
Message-Id: <cover.1584979543.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0041.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::16) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Mon, 23 Mar 2020 16:12:33 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aab84509-f1cc-47ac-6ec7-08d7cf44ff2d
X-MS-TrafficTypeDiagnostic: HE1PR05MB4699:|HE1PR05MB4699:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB469997672E9B2C684C4C2192DBF00@HE1PR05MB4699.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(199004)(26005)(66946007)(5660300002)(66476007)(186003)(16526019)(478600001)(66556008)(2906002)(4744005)(6666004)(2616005)(956004)(8936002)(6506007)(6486002)(316002)(52116002)(81156014)(81166006)(36756003)(54906003)(8676002)(4326008)(86362001)(6512007)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4699;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kczl1Lb2qprtJ8lS7B9m0hWzu4CvQn/9cm7NRrhBZmY5WTbX1cUTxGlLN6C4c4Dqx7ghZZcSI6wj5ZWX6L+vfkkNTo3+YK6jhvmYW7ZoTCsWnYLLobbgeyBVpW52HmEvSb4p/hPLXYZDlDXehTOklVIgGiPV7Y248h4XZM2wG+V+D7BCz4eXULzC2VLMoIwXPFwRgr4MbyfnN8DgaoosvadQFLpZC2c85pALriQLT00kYu8GDkCOlySJBpViHti2CpuprJjAKBBhzKJYrlBSqaNJrmO4zOCJC+zSSk9sQpB+e2NBzQ9c6Iwpd4Ge7FlO4Qx6rGGln0chdgoEb03T3XtUqkWH9d0aBK0CRMGl6xOdCU/jILW6nlPFjZHpAzTMtfDSMfZx0faCWFYkj6s4FVJTd+xqeOjFKhCnLphosHVyoeytJGuful/vlg5Lqd3h
X-MS-Exchange-AntiSpam-MessageData: jaRSMlZVd0RYIy5CF3OowcopE8kOP7g7+WbYtSBa2rX7qOKetKcCUpdr1qyElPkaEwbw9rg0Lk84KIy5ckFKaWc4t3lOR1r2P8imOsf0Enb3s+vVRyWbhCkK0/ljUjZ5HToLAMg9SY3nfPSnXXGyJg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab84509-f1cc-47ac-6ec7-08d7cf44ff2d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 16:12:34.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2viQkiWtekcdSz9dZa1oPcD0Y3OxAyRt1m6E16ugn613/YY9j3b3PrMtZLkvj/3L6dh6RNunMPnUkfjbgTipQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4699
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel supports a new RED mode, "ECN nodrop". In the nodrop mode,
non-ECT packets are always queued, instead of being subject to early
dropping.

This patchset adds support for the RED ECN nodrop mode to iproute2. In
patch #1, kernel headers are synced. #2 adds support for the new mode and
describes it in the man page.

v2:
- Patch #2:
    - When dumping, read TCA_RED_FLAGS as nla_bitfield32 instead of u32.

Petr Machata (2):
  uapi: pkt_sched: Update headers for RED nodrop
  tc: q_red: Support 'nodrop' flag

 include/uapi/linux/pkt_sched.h | 17 +++++++++++++++++
 man/man8/tc-red.8              |  6 +++++-
 tc/q_red.c                     | 25 ++++++++++++++++++++-----
 tc/tc_red.c                    |  5 +++++
 4 files changed, 47 insertions(+), 6 deletions(-)

-- 
2.20.1

