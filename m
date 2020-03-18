Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE66189BD4
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCRMTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:19:03 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:33625
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRMTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:19:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klNVM8cSarVGTcuXe3tqtbHpQbqz+77mk21nnj+S4seVlBmyxc7R3ItJss8ORMAiA631KW0Fcolsnaeb7eRFbf7MvAjetYCQQPOO23Nxn5lnC/aNiFkR9caqrZakHpWNbR0GjTIBE89hNuPUcWcVb0P92tRr/33CgXoylbRWhu2r1OJyopFndULMjq91wXvXjh3mFcy6H9/hbfTTBlw2S2V0/jzZ8wukb/MxT6/xgTqIUxy3X7TaKzKfGfcj1BpgYRhUNqNUBUzOQHh8v98nvsNNJzStjbrDpb3cLJwmPbilZA0LM8ZAeiSVdZ5FjRoFKSF0vqg9ouVDoI3gOhADKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmx+xcrCTPrBNrC8DDCfoq/rJ8PwRGVDBteLwIys6DE=;
 b=EhSDJMRxknEv3RC9ZM1sk6P25DGULOgmL6+x0WfFSKmgGYkPfQCa0gIcjyjvpkQPtJ/XHJZWEhVkJGcP3m+yNNMGk7gYzlIX6b5mhP6DvT1FTt1MO/RMEpUg1LHAl0dWr4Ei1CqkaCQBTfa40CRmhmeibW6mrI6Q9q2lVn5ART9Sh7BdinINSFNp+4puAhwVzcc1C8K5X3MI6gOR15IDyWxXid24UTxt1ElhxjqfAC6j27OtV1tX1x4n5PVdI8bAtmjmHuLoscwjhvTykuzx+UBUEcRJc+AB+2im4v6lqt5AnCmSbuqv8EGswtRF2aSDorReIXuoWe/0Bdk2sEtdbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmx+xcrCTPrBNrC8DDCfoq/rJ8PwRGVDBteLwIys6DE=;
 b=TkIpqZQDbNTwrhGQKDh/JXtaBEGlkNdCiVrxIKHhEoJxhB6z4oSS1kvLOKoYtHkgD0O1PyJJZf1JhnHDJ+m6msurwauXlbLuRMQuCpkWG5pfC5Rk3YW5mXmp4L4RobnEiO8z1dbMd2Mwbr5LfZ2pQrAh6ACqy1wP0yv4Oj9FAu4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com (10.168.18.154) by
 DB6PR05MB4584.eurprd05.prod.outlook.com (10.168.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Wed, 18 Mar 2020 12:19:00 +0000
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651]) by DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 12:18:59 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 0/2] Support RED ECN nodrop mode
Date:   Wed, 18 Mar 2020 14:18:26 +0200
Message-Id: <cover.1584533829.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::36) To DB6PR05MB4743.eurprd05.prod.outlook.com
 (2603:10a6:6:47::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 12:18:59 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d22d196-d8e3-41a7-aa2e-08d7cb3689c5
X-MS-TrafficTypeDiagnostic: DB6PR05MB4584:|DB6PR05MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB4584B694CCC43DB5540F9415DBF70@DB6PR05MB4584.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(6486002)(956004)(6916009)(2616005)(316002)(66946007)(54906003)(26005)(478600001)(4326008)(16526019)(186003)(6666004)(6512007)(2906002)(8676002)(66476007)(6506007)(66556008)(5660300002)(86362001)(81166006)(81156014)(52116002)(36756003)(4744005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB4584;H:DB6PR05MB4743.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXRSxlzPTH1Ojeb9ybbKU0abm9e7MbzUepNOX0Komu3FRsKtMH5TlytOoeBsqByKPiCqFaW08UFttbnmtbAA4/Q5myKgDMPOxKV2Bn4K8M4ogEDgiUngfn+SIiJwm0zHfdoDNuZ3RKx+pRHQJh75a98s/7+cNBahcRUIGWFkZ5vgpnNX93r/upw7g4/GN56kNa+zfAMZ/TsU4qh4HkUmNascEEmVUMSbTm+z0YQblB+dxJplF45a+x4Xj7e0k/3p3zptcbls6+CQWpr2oBk/RjHeWq4Xqd7hLzkO5AM9EktzisH2N8CM3AKCZveqwpHe8Sr86i3k24IH/zkn86aUBRjTpverNYnrSObV/NkUFxjeYkpNDTb0V3mJuI3glIhkEQrvEECBZof9EpOyshyr6oMWR/RjINPLd8rzYiHTdhiGbTgwgoRKAjzSDYOKwFhG
X-MS-Exchange-AntiSpam-MessageData: 9WZ7scFMM3Qvo1eg6VOoH9e4crweYxBiXFJRuljqkHRIbH6HuTSYgBi5YzMBNWQNHQJcltuU48hu3hQtCK3521ee9jfFA7eawf63+f2tAVWoutfCiYGA/9tkbkWNd7ArdHsFhTNZrRtPSEd+IfBOFg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d22d196-d8e3-41a7-aa2e-08d7cb3689c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 12:18:59.9038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKqKFjMXHRytG/bSoUfBIsbbjTmalCYdj+60m6HOXlJ2pDjKSwE7P++yJcz4JyWlQaCuC3gHu7Pf1Bms7U0Zkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4584
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

Petr Machata (2):
  uapi: pkt_sched: Update headers for RED nodrop
  tc: q_red: Support 'nodrop' flag

 include/uapi/linux/pkt_sched.h | 17 +++++++++++++++++
 man/man8/tc-red.8              |  6 +++++-
 tc/q_red.c                     | 22 +++++++++++++++++-----
 tc/tc_red.c                    |  5 +++++
 4 files changed, 44 insertions(+), 6 deletions(-)

-- 
2.20.1

