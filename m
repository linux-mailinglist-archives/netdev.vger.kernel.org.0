Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD922287F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgGPQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:47:26 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:16119
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbgGPQrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:47:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8VuQkpXmJtTufi4T4D/0TDfNTK86x3W92cZC3b+IjEZ8tMcKUEmjHVY+K/k2sFnLbU4SH7XF5+Dt+eFJXyfTMfSlOy3cEbjOPn6q1o5gQoz4QeHteH8XFuIZyXD+4h1V2q9tmhDLGzJT5tFpygdirMf8GDTlz13qXKwoeWU/cIi27kSQqBVIDfYScaszcrJ2mh01q0l03Sz8UwWfLev/KyOmlAzaJACzabf8Az/MAPDxEcy2TdT1gfhadYo81YTE/qqDdmUK0i7J9IDQPvP7FOV+vsodSMStdL6YSQVlYvOmSg8JYR6y2yI3Wbf6dx4ptT2JTknRSuaaFmoJtimOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FogDE6wPWcgcCCbPJXerHHvdGxKbR7FoGBeOJuSvPVY=;
 b=E31BUilxDFWNNQSBgaex8BtSG/89Jmqek25hWsSGeT3h8tmjYAt8Joxn0mSQSIkz/cQOth8zo2UWnEw11I6DGQCEm0IiQ4XwGuzXUX0wg+SK/vMiPMlgsKXO6YuuQhBii0o02D45HNL0ncca2ztKtaD0TaiDdox/wT0N+Kxz0kfne4tTp971R6sFqOhLVS8v2SEPQUA/SsxmHJSi9hnu7gOS89MnkL+xJO/1Wd79W4dnCkHb0bv02xzIFQBXd/yxKLvqD7SsFPJ2BJNa34iq8JDT3QCDi0kY9VmwaZWUrMMcsGwXfgJEHnihzdhJ8iTq2Zljcf3yHXnzNhJVVr9pOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FogDE6wPWcgcCCbPJXerHHvdGxKbR7FoGBeOJuSvPVY=;
 b=eTDlNF5swkag5y2AXgviv+K68wzM59A75I8RcF8X+P3SlWV8k6s6WdF3iMeYPaJSZBzmrAfcI0Ui13xfxu1GdWny5sBO9RWTb+eeQeqRzXELOojVBchQQbTtc1XyqS5QLVYe1RIE/UkWuObJVqpU6Rui/vnSEs6dtJsL9CHU4pU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.24; Thu, 16 Jul 2020 16:47:21 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 16:47:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v3 0/2] Support showing a block bound by qevent
Date:   Thu, 16 Jul 2020 19:47:06 +0300
Message-Id: <cover.1594917961.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:208:3e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 16:47:20 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed433b2a-5e48-4309-1cb9-08d829a7e86d
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB383416ED610FC2FEB81E06CDDB7F0@HE1PR0502MB3834.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POlgLOZAJDgcKksFqlr7qn4SNSW3cUOied68Y8HN1skdNkMIbNXREchVksjnEjt3bJZwG4Crj1a8PTflbIlt27bQ/On4OthcuC10s36e1q3CQjEX59xLgJwaSUa3WgILDHdRMEG8toyiB6WZRIpDoxE05C0JsMv7EajZ1nP9F2mdHN9SQvP/V/SXWkOEpoR4Yi6JihCWhU34Cilp9nDX9Vb26Ymsnii6PnQbaKSLWGP03/lCu2NZZu3M8zxwbGzqsGOMRLkxxipdfHj4WuRHVlH1Q8QGMTmq831TELn4fdz1f4PITcGSrRuLyfaqTmQ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(83380400001)(86362001)(2906002)(8676002)(8936002)(478600001)(6512007)(107886003)(6486002)(66556008)(54906003)(66946007)(6506007)(26005)(186003)(52116002)(6916009)(316002)(36756003)(5660300002)(66476007)(2616005)(4326008)(6666004)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z/BZRV0dlKfQyfUekMgLMWrBwyTamZb1L8AwmS/xOdbbhEbVId68dEvRVGKam/IhXI/k7432w8O8X+hdQLmvXt7O1jZBLEtxhI9jpw242Oh7pDTQXHUOAjcdAIfpUswt+WivabEmjT2ZrN0az8xIA+DB+eTc9tdEoGQgBy63Bp0xZhO6jb0BYfthfa2SaPZKEIhE2ja71WZWpQ//hUwjLqAEBeribXRiRkjeA2DRTvNUvveVY9fnyrkq/THTc1K5uEQwAtHccT7tCuI8Lrh6iJ88aKR1oclva0uLj101g8ER3i66oxua3YjsE4GMRtjmXe+/1rQyJZ85zW+WgynhOiSj6K8waBACN++V7Dvjwc6ct8ul4yTNlfbvs8DIiZ8a7X/QFJQrJxAciNKm7/buUkIOllH8wB6KHajmnKJ4bwT+p2K2kRpkeUwtJZxC98bvhsbCxbzf0JomVDxkWY5iBk3lJQIMaTB8rG+ip68bLxUv4kF+yH61/STL16GmhtdC
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed433b2a-5e48-4309-1cb9-08d829a7e86d
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 16:47:21.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eKxzAJ3AySgckAmwe0qB6W5kjfbiu+62qzJnQ2fEYt5qrAguXMWV2Ih0lsf1Sp93qoIkpEMaQN1CeHMKLOmQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a list of filters at a given block is requested, tc first validates
that the block exists before doing the filter query. Currently the
validation routine checks ingress and egress blocks. But now that blocks
can be bound to qevents as well, qevent blocks should be looked for as
well:

    # ip link add up type dummy
    # tc qdisc add dev dummy1 root handle 1: \
         red min 30000 max 60000 avpkt 1000 qevent early_drop block 100
    # tc filter add block 100 pref 1234 handle 102 matchall action drop
    # tc filter show block 100
    Cannot find block "100"

This patchset fixes this issue:

    # tc filter show block 100
    filter protocol all pref 1234 matchall chain 0 
    filter protocol all pref 1234 matchall chain 0 handle 0x66 
      not_in_hw
            action order 1: gact action drop
             random type none pass val 0
             index 2 ref 1 bind 1

In patch #1, the helpers and necessary infrastructure is introduced,
including a new qdisc_util callback that implements sniffing out bound
blocks in a given qdisc.

In patch #2, RED implements the new callback.

v3:
- Patch #1:
    - Do not pass &ctx->found directly to has_block. Do it through a
      helper variable, so that the callee does not overwrite the result
      already stored in ctx->found.

v2:
- Patch #1:
    - In tc_qdisc_block_exists_cb(), do not initialize 'q'.
    - Propagate upwards errors from q->has_block.

Petr Machata (2):
  tc: Look for blocks in qevents
  tc: q_red: Implement has_block for RED

 tc/q_red.c     | 17 +++++++++++++++++
 tc/tc_qdisc.c  | 18 ++++++++++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 5 files changed, 54 insertions(+)

-- 
2.20.1

