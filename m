Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3387A1D12B8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgEMMdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:33:32 -0400
Received: from mail-eopbgr80117.outbound.protection.outlook.com ([40.107.8.117]:4078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729688AbgEMMdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 08:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nv7i391cE3Y05XUSgD5F9TLHMMRy9PNawHRsJQ2I8/1QhhdRH3Kluuknoz1tr+473SyqQ4+lcnM+6BJVjFf9vAkQEiTHy1GYfJwkryDGslX4oBQa9++bTdKsDeGOiKkvDMe7nGLwfM0HlFosoIE8/92tS//TyOHEeaxweJysNXXDJcGckTK6pdZbyTfqBGPUnOC5R2GjMZWyiOls906oGP6gqUuBryLCEa9P1McG1RJinlT9XIIueJFP3lj0F32Qoy+nFHtdbecTK8PU/Q53IeLzfMTMxqlcyVMweWpMVTHklTHExDuI9KebcGgqeR07kwC3jQLwr6NFmkLtGm5XiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/PsN5Cb5MBONg/tn8ZF2lMfpOqbfSGVpgTKEQVmKv0=;
 b=XfjDiXczKxEMQ7ubgOzAdejAN80IkzjRYUFnPZZ/W4kwUBbbmz3Rpibaz3PjqpwVRXUoN84Vq69hgBSEnFX6YsPpFx1v/qopDfWG11c6NSj3XSHTyVBmCw64LTJx3f76BmAZHaXleF3D5ZH4HutlkabEzq/jt3LukGPTxDehAXWGZRUG8ITgoUN0ahq6nxmNI3EDfUlhIvwOF8lXhBj9mMyBa2qz+K16Vcjw8odpR7+A0Uv0xhMxL7XVsRIdvWcZd0AU+WK+kOFaBLqUp8cnxdAKUZKyVw0Z6wGTOfZeFj/PvF03qs+1hbkPAvhZ/e3b4dcSD6lsG0PRL6YB3Ev9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/PsN5Cb5MBONg/tn8ZF2lMfpOqbfSGVpgTKEQVmKv0=;
 b=h79dAWgqhzMqHYSW/f6i6N2fTuzAB1qibDIxj4bHaxLxDq3Zs0VsX/NiUq401XK2PTyG9qVrXouHtPR36QxcjFEKdFU+qR90WHHUmmunxt08+2YfXp3Q4BDKWQSczaIk0+2znfqeQbQfWv1oEv517WIFvSqmOGRgdMjeXcj5RJo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6SPR01MB0038.eurprd05.prod.outlook.com (2603:10a6:20b:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 12:33:27 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3000.016; Wed, 13 May 2020
 12:33:27 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 0/3] tipc: add some patches
Date:   Wed, 13 May 2020 19:33:15 +0700
Message-Id: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0203.apcprd02.prod.outlook.com
 (2603:1096:201:20::15) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR02CA0203.apcprd02.prod.outlook.com (2603:1096:201:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 12:33:24 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a80cb80f-4fff-4580-67f8-08d7f739d59f
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0038:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB003831C4019151CE50A0563BE2BF0@AM6SPR01MB0038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1AOGuVXfDHotdiSk95PeR5xAHG2JOIw71EEVl1yKnOzHnhGtFjMta7qkuUkjN5sg4tMX1KQm6McUjewm+v6XTG8O0tjNe7wWkesrnwH95p2ZNlvE1sAWGh7GL2dIexDNqnhu1QxYH/le38UDr1P4sJWk7A/b/n5oYEz7+w/OMTyBhyQtcslz/aeLGWV28nR9KNV2VFDQxlek1sDHyI1666k42i/gDyq8Cn8UoSER9gT4gQmCFihiTJ/HWIS4D7vRPSpZNQcQlFfoTm+Gw9MxET9IAZ5eNfxFPgUAjD4oZu4Ah+PU+FLTwZ+K+rI3axCViNgAeL6xS+OO527K2ZYL4eyQImfQgbHmePmc8Vkof6886/ER23o9VXyEDdAZOWxrcvnFqPqCLy1VCeQKQ/OUIvOH92Oee3S+gLMpQivK2Ma501DlWogc0WCzvBfawfT4e8nh03NenzJy/xBiT9aIWFML6lJVB1DKtkm+4C4axit5BKsAEbQ3VHvxKab0f6cgsFGJhGzRrtVD5hbgUuqYOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39830400003)(396003)(136003)(366004)(346002)(33430700001)(7696005)(478600001)(2616005)(52116002)(186003)(16526019)(66476007)(956004)(26005)(316002)(6666004)(36756003)(55016002)(86362001)(5660300002)(66556008)(103116003)(33440700001)(1076003)(8936002)(2906002)(4326008)(4744005)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2mqq7WB/10gLkLITn48vJcc5chfVLmKQCqZfyINKYaIt4aYThX8yRNxzvdxVOnEbNQ/a5SnEsBQpV7nAfQJQmcX1HEQ83hA4yES1L4GnaIE73+Rjo1t9/dcMDhfLF7qZOsgdZq2NtKMiYLdSGvfYKqFKZ9GUUr2rZLfk7Aiuo4VakcpNl2T7CaLpUyrmPhWr/NLSZOhCClktqCPUxDtaP0Pcb1gQxpfJZkW2yYm4aM690lImwvfdFvoLHev59HnCMgphEx1ETcJu0bZy5BUQyJWnkShWLbXPR4byyzp2W0b70QFBmniwaWRPHZopXAjo+n0gcVXao3yMsWyJHJUhoOZjNQdG2G7jS3XgznGT3s8e5fFh10sHSH1t8LXtkzKBaeWCf7ezxhGTymAxg/RwyH7AZQpJQof1Il+cyCk7MIVrWScIl+wxJ3Ugjv3SVzy2psIV0jqVlUMX73m2pN4c7pN/xAjseKpYRSR8EsBlz10=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: a80cb80f-4fff-4580-67f8-08d7f739d59f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 12:33:27.0731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tRYwi3XR6JMYXZwjFdkv2Eng00t02+Kh/5vxNj4gvv5BUwuVfll6PlSpJmEMQWfmbo6ExPtxO98aQBK6HeTGrZURqAqo+3jIqrxLRvw0Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds patches to fix some issues in TIPC streaming & service
subscription.

Tuong Lien (3):
  tipc: fix large latency in smart Nagle streaming
  tipc: fix memory leak in service subscripting
  tipc: fix failed service subscription deletion

 net/tipc/socket.c | 42 +++++++++++++++++++++++++++++++-----------
 net/tipc/subscr.h | 10 ++++++++++
 net/tipc/topsrv.c | 13 ++++++++-----
 3 files changed, 49 insertions(+), 16 deletions(-)

-- 
2.13.7

