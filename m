Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA3258E0E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgIAMQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:16:37 -0400
Received: from mail-eopbgr80114.outbound.protection.outlook.com ([40.107.8.114]:39584
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728092AbgIAMOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 08:14:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgh9RKkupP3288x7V9b3yheZI1TMCuRHWjSKnmrbOuI5RqrEfS3JH34xLDonmYBFwosGbv49iMJF/0969fKoDLQbw0OIcW/yeF/oHBxI8jAHuvrtHPn/xggp0um9X4MGDOksFHJOywHC9RMun6h7h2OlsgR6g/D89TzgdyjdWetZPAUn5yXJJLWh86UsiwbaSekSs/2H4xthKKlwS2IuWxzhsvRmBO9iLEesDI1iQFIiUaADSw0Xp/NdqmMvPGIpvzfvSGvzPANETJs1JrFtU1zoJ2kZY95fpACrTb+pIoedWui9hENUToWoVAGYryF5WoLJBe2izgxxtyl0gT4wmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHcgBNRNeynxlvgHTlEHzjQZxwxkxEDtZ8XmtiNWnX4=;
 b=hFjLJUdtA4Snwn/rgjnTxbc+a0/gDpiuWdqtu2bSOgjnBu9PSJa9oWPd8iTo87fT+4ZwmtILXm6HnDV1DOq9rXu++vEDuHjLT4qFBLugBYpVR8jo2Ru+Ns+UKbcGmZmJgOteHaYO+3q52TE7qWfc0Buo4qaDNVGELsknKOKOZnAEYe+8mCLrvOf432eyYoaDUetLeKW+hk08LHVCY4kmI0qRSHTubaB4+neaQiwH1M3T5C7Kesw7rqX1irYoLfhRLxX18lkCCnPjFrTxjznwUNVRGM0VzQVlHGk0FkA8NWGmYMJISINrVanKAKullxS6RsGXXey8tTRW5rxmub2KJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHcgBNRNeynxlvgHTlEHzjQZxwxkxEDtZ8XmtiNWnX4=;
 b=hzhgTexfMMOIBkU7C3XMFub2LlA2a3xWdWblUXQu1mqDdY+4lsbaTHzR+kxEzItlhFW7bO3pOH2YN3fCUVjZ7B75PPRNbSotqq+B9fD+d5xNEaTo9hqwCyeLKg/7dzfotOt5c/yduS98c8waeY4pFZo2cmypVtLtcyO9YDZiVL8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM4PR05MB3314.eurprd05.prod.outlook.com (2603:10a6:205:d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.22; Tue, 1 Sep
 2020 12:14:04 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 12:14:03 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v2 0/4] tipc: add more features to TIPC encryption
Date:   Mon, 31 Aug 2020 15:38:13 +0700
Message-Id: <20200831083817.3611-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0247.apcprd06.prod.outlook.com
 (2603:1096:4:ac::31) To AM8PR05MB7332.eurprd05.prod.outlook.com
 (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (123.20.195.8) by SG2PR06CA0247.apcprd06.prod.outlook.com (2603:1096:4:ac::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 1 Sep 2020 12:14:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [123.20.195.8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5c003a7-bbde-43b0-a06c-08d84e70841b
X-MS-TrafficTypeDiagnostic: AM4PR05MB3314:
X-Microsoft-Antispam-PRVS: <AM4PR05MB331436D0BF94F0B84E89E0BDE22E0@AM4PR05MB3314.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAKTUtCUvr50c4DQPjdND+yPNJLgwgVGbvdtlm2yAFjuoBxAWqRJOmgV5c5YyN/OtOSI3F8903zGyuxB0A9Hf4qzCoVie+4bYjI4C1O7BpG0rYaTyk59ydwK5guvqs9yeaNA2EG2eCnEGSmhvShtfZm/y3gOKO7y1QZF2DLn7W6VkI4yULD2XEXbRboWBR+wNVgFsVF2PPvJLjqj0h93RAEi+2+pC0cmeMGROEG0uc7kTOr82Ad1kWuzE/FfJ69DE2KwRdHld/IeHFZmEudyql28EsFj82VNKpMHZ/fu+VI9q8BHQPqGR3skW7END1le
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(366004)(346002)(136003)(396003)(16526019)(86362001)(478600001)(55016002)(2616005)(316002)(956004)(36756003)(6666004)(1076003)(83380400001)(4326008)(66946007)(8676002)(26005)(103116003)(186003)(5660300002)(55236004)(52116002)(8936002)(2906002)(66476007)(66556008)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WXvzb63mUDu8Bkw1gBq3ZSgJwihaZLIn/Berwk3gj/Em4H1s1sYyp1FyctA+vam4M3bxCzikCllWeK4qga9LgG6juFYhzka6d9+tY1L6LQIVMg78NRmJjbJmwTq36iJP+bm73IGS0xyJihEPPVq7y0oOO5Zd1rsjwAldIiMINu3f5fnA/b+VazpRC0E8c2UGI1yCZwFt7U0tpdRVgzjPlK9IcMskzIEGJV0V6Gu0DzjMYApnsoJE3Rok9P84QOJXXsPC+YB6SDG9tXmLRg16pr8PoYr7EIFx+8+dgLjmOGUCXO+KSt9IruFOHZfDHXPwfXnVB6HufgsyaqcTiWHBZweB3bZMPbpGPeOZRNfPPjYTqRJC14BKslAJQcEfzTfXcnbZJNNycfEKXsBCSysqWTMzDgq/QIHq5x5LCiTT++KXiq8iORDWzKjeBoeG/sZMrJUBXu9chY6wIpsrm46ADaV6BDQNFOkN7hD3E0+KVV6+K2xAwNaZlV06m3dgi0C8nQBFCgzWZFIklsepWGU+cWGwC5sVDoBkIjepR4/IpDEvx8rPbS1wFh49nQZTvyZK6rBH4OdAzOqFX6oQCYfxzZtbFk6nrcYuxQvTslMA27UHqh1JILHRWXtI457/CFcSXZlBU6tHPDmHIVEHcy9MxQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c003a7-bbde-43b0-a06c-08d84e70841b
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 12:14:03.6634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngNnloTnAE9x94Toyupko7/qSSNwpTnt+2q4saw0U85TocvnrKR7qjs6mEgl+g2EnNJkRsEJ562gPhYgTxZP/ZBuQql2ZdeHpj4TvzScmFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some new features to TIPC encryption:

- Patch 1 ("tipc: optimize key switching time and logic") optimizes the
code and logic in preparation for the following commits.

- Patch 2 ("tipc: introduce encryption master key") introduces support
of 'master key' for authentication of new nodes and key exchange. A
master key can be set/changed by user via netlink (eg. using the same
'tipc node set key' command in iproute2/tipc).

- Patch 3 ("tipc: add automatic session key exchange") allows a session
key to be securely exchanged between nodes as needed.

- Patch 4 ("tipc: add automatic rekeying for encryption key") adds
automatic 'rekeying' of session keys a specific interval. The new key
will be distributed automatically to peer nodes, so become active then.
The rekeying interval is configurable via netlink as well.

v2: update the "tipc: add automatic session key exchange" patch to fix
"implicit declaration" issue when built without "CONFIG_TIPC_CRYPTO".

Tuong Lien (4):
  tipc: optimize key switching time and logic
  tipc: introduce encryption master key
  tipc: add automatic session key exchange
  tipc: add automatic rekeying for encryption key

 include/uapi/linux/tipc.h         |   2 +
 include/uapi/linux/tipc_netlink.h |   2 +
 net/tipc/crypto.c                 | 974 ++++++++++++++++++++++--------
 net/tipc/crypto.h                 |  41 +-
 net/tipc/link.c                   |   5 +
 net/tipc/msg.h                    |   8 +-
 net/tipc/netlink.c                |   2 +
 net/tipc/node.c                   |  91 ++-
 net/tipc/node.h                   |   2 +
 net/tipc/sysctl.c                 |   9 +
 10 files changed, 853 insertions(+), 283 deletions(-)

-- 
2.26.2

