Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78362227CC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgGPPuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:50:04 -0400
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:21828
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728374AbgGPPuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:50:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJFVj8nnAbDTzSYqbuO9p1ML1n2Jg+JSsKYiRj6vOv62pymWPoza/dom1f87O+LTpaswY6JWO66QXwVrAUgukJDPXjNxJXgG1Rm08lPnP8DP+bDGj6T7e167b8ksa5e/d/O3zOXg7XKP9HYoxbpi8ENhA6Lz5R/GHIgwJXX5YpHRbCfUSfMGL/nk7CfBsgW+tbo335mBTtqFzT7z3uFfj9W3AJTD2QAtrmykMX7UPy97K7ScEsWYPUwJz5WqQ1pf9pXSCq0Q7A3l1Xz4D9k//Pt/4Wz1mxJ4JWGXZ0lhr4Oalx+WB3khBZtukE5ygWcUV3y+SsAnJhSGR9icO5of4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVbvWHa9mUP7g7CnVGzOK3xwLYbURuBIFpmCowPcPUA=;
 b=V9IWqWhIUCsF1XggxwsUOQ+Vb7QlF8OrBaz45Jg5wa4zRvaZuCVRl6PGN2+hDULjFKLNEuo2jXvRIyjGgcSVU0+zT/znZIyupzV/WZNq/oEs0AnFs0XznJ3qahqo1NcPP/mJlO6mIFyzuIjbZtHMaxYzdvimnzmUjH8K0mDMLblfml7CBYD+JOwud2j9vg/Ujv/zFv491wZHpUeGPsi44y4RWt58/x9Eu3EnTdBeCu4tcheLDoiSstx0wfpSAuCWIg8Aq1rLO6gIZs78d0NLunSt9CX2G0Qi3e/OtnlgnBuy3sBi0IQT5jWomBnC9KixeiW9oz/+ANaHQtDC9iuj8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVbvWHa9mUP7g7CnVGzOK3xwLYbURuBIFpmCowPcPUA=;
 b=Mhdp2maEhegz+yR6iJvT56jiFNz8NX0o0oHn+JIFYfEQsGkgTgeO8rdOmL4Hw2w/c4aXyTfEjsAm3yhUkNo0WFvcjL8Frdb85gUQO6zK7H2HTJH9e455lLTyY54yLOCxVWYifgbfcEs101foiFOIyojIwyjx1HeIGES2l9ICg8g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Thu, 16 Jul 2020 15:50:00 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 15:50:00 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 0/2] Support showing a block bound by qevent
Date:   Thu, 16 Jul 2020 18:49:44 +0300
Message-Id: <cover.1594914405.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0501CA0060.eurprd05.prod.outlook.com (2603:10a6:200:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 15:49:58 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76da3aa1-9d34-46e4-bfc7-08d8299fe54e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354A2E7507756EB5A19425CDB7F0@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z50fddwj3Cwo1uYiJQTpggRNOiZrujEHNe3llkOrhJr2KWxiy6oXESJrl3Dd3JydVeiwEF1lsIOEuPkhVHxj8T9GxzZLIhYtFUmxsIf2UT2GaoIKbuRExFNWvJlPOxslAWWmW247D6MvtHKZPAaP1sf3FPih7livt8ES2gq/vBj4O5NVur60nr0lXipbf5+6Wus4maixoHPKBcA4WVrCs9Es1LG7R1TRNzWopIqIEZAoZUqSCOaj8mpFW5j875LEWd//jfLXEZ8I6CMzVnrYBjgFdW8Sbud77KfRPCuhR+hasF2iezy/QD7kKlpQ5y6o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(6916009)(478600001)(107886003)(54906003)(26005)(66946007)(16526019)(956004)(66476007)(2906002)(2616005)(66556008)(186003)(316002)(6486002)(8676002)(86362001)(6512007)(36756003)(6506007)(5660300002)(6666004)(8936002)(52116002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7l2CEQ6Dy+HtlAcsL16wBvodglmhBhbJmaXtyzUPsbi4tVNIHZ7k8lKfDNRqWUujB119001Omea+TZpbeBD7WOTyakcRjxw6FUAmJ/KXXjYhaPoHdeUJN6JurJ4Fl7IbPw97hBdHCbVRTvbpkuheCxlkFQgYLTCn5RR2u9+bkSON+tnm2AW2p5ScT9LMg9lNqW0e98aEpn3nmu6NlbUeNsjI0wDY940JhMz7+E+61Z3limg0dabARU0P5UVxPFGkeyDFD4jhq3PVaJTZkz1te5wmclGTTAHnwZB0f5vKvoimEh9qN+2yGHDzQy49y6UCUP8P33SEDrTCOkrUh8Qa6QXNL3OnefJlC6eW8sm1HxkCXK8vNPghvmQvqh4wvBDwJdS35vuWOP4kVnlgHtm4Fn2yXSp4PAHrpRzhbCrqIW/JHyCXYUz2Y7oyo6jNQSKkkdJE6XDhrWAb2jBU8lM4Hmsrl0KPCY8MOZJV58MiHl4BIlD1u4hX8N6GsdICgt7U
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76da3aa1-9d34-46e4-bfc7-08d8299fe54e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 15:49:59.8916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8q+6moOwP58OZjYtuOQ0+sKvYFPUdFaVKIQlnBBima/grMSftL3Im6YqoqdpLJ0ijlo4wyQ7Oxw3p77Z/w5a8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
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

v2:
- Patch #1:
    - In tc_qdisc_block_exists_cb(), do not initialize 'q'.
    - Propagate upwards errors from q->has_block.

Petr Machata (2):
  tc: Look for blocks in qevents
  tc: q_red: Implement has_block for RED

 tc/q_red.c     | 17 +++++++++++++++++
 tc/tc_qdisc.c  | 14 ++++++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 5 files changed, 50 insertions(+)

-- 
2.20.1

