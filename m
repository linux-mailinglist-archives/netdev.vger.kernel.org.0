Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F393220F26B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbgF3KQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:16:05 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:41164
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732330AbgF3KQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQs9w7mU9qVoQYc5KeJf+/i+5eotMNDN2+0oWKWrdoCWeQDE8V72MdYogdMEaBue3bXLMnin7nbyZd3d+lxQ1yii/wb7DjKhJ/zu7opmWOLML/OZdm1Jy7kVbWBrm4sr/Pky/oNb9r/S09ZZxlza/gQGdAamWjptdY/Sc6wBwxDP80qkitKwDyP5k6ilrRrWgVi36wZvn0yTW56dc6d5xp4KheGh1fG2wkotmNCTjv5bZ+QY2I+Dt4f+4dqTuuhcz+QB5+cdH797A/2Z3y9XCRHJ7kuWAkoHq5TyOplXKZOSYVLR3sJfIzPiFM3KXYfFa4tiJmS5SE2wAwvgCUCU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KJ3CE0wkuur6D/qcsAQ4i74RaxJhDRjublPXHh0QVs=;
 b=RsRjeOmr8+7hXgJNjG5jChnibayeyCKod/Xn9HXcX+wXzzuAtEeZWuYgsbDbDFrO5RTv6kXPqGoNaunQLW2s0NLIVl/Ibfh/lzWAZZdtcZa50o+Y/AcG+yA2QnOh1j9GXNcUEcGGXszeU6Dcojl0LrDyajWevcU8UPttKBkmbEGmEsB+Zf1KpGCUPXYWvoXUzVLtAm0PlY0dN42LYeANOwzKyXIeqrIjEyygz02vkNrdpAaH1c85KWrqq5nldVDeqaHp6o27NKRXMmlD5jkCYn5snrFg74ohXaDNpJ3DFL2QMx4BFNxPL9J9QwY7gyxQlEi38kQskQiYa6ncUfBAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KJ3CE0wkuur6D/qcsAQ4i74RaxJhDRjublPXHh0QVs=;
 b=VNl6JtDxvjWFsQ9uQowbTTny8vZKScz9QMxPxDFAQJX55+7Il/PMUSaEfZk/8DG399aI0X7+knP23N85L9+Cj0bRDeOdsFR9Q7UxmimAjYu4Yi+um4ps4ww1rrmrgGsnuXawVIie1P40jYSCpBczjIiIZRUjfrQPnD3hqe+Pvx4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3417.eurprd05.prod.outlook.com (2603:10a6:7:33::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.26; Tue, 30 Jun 2020 10:15:20 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 10:15:20 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 3/4] man: tc: Describe qevents
Date:   Tue, 30 Jun 2020 13:14:51 +0300
Message-Id: <aa54b0b3a97ae3355b8e91089cd3944ab975347d.1593509090.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593509090.git.petrm@mellanox.com>
References: <cover.1593509090.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 10:15:19 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d2342462-0030-4061-8641-08d81cde7e5a
X-MS-TrafficTypeDiagnostic: HE1PR05MB3417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB341746F9D8CC37E87355B45EDB6F0@HE1PR05MB3417.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4LXDiaHebQuaolLrWncVHwh0TGikUqSc15ve6gp0pwAa2t6RrFhqDU+wgymUq3KcmC7x11aPUFfdygEYvx6Snl1LTP/93w2EtoBh9JsO2apq24SvL5FOx4PktNnWpGeoK3/2csQTvYnG26kRFWcuJoMiMhVSS2YZYikhhOXCrLeCK+OC+LDi5SuW9bV8oFZAB6LnLc3pMrq3m7YQ63WFoUKsK0TZrx2+UqPz1HjSP4dek5ak9UTNcQNkfwXM6yUHuY3QdKqMAUjlpeNHqA9Ub263DwJWnO3tQ0iKNphorG/t0QNYg9prCBUDTzw0H4Sva1aNdEySkTM0kJGH9QElag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(6486002)(478600001)(956004)(16526019)(2616005)(107886003)(186003)(4326008)(2906002)(6916009)(8936002)(86362001)(83380400001)(6512007)(316002)(36756003)(66556008)(66476007)(8676002)(66946007)(54906003)(6666004)(6506007)(52116002)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zSk09b0Xi273Auc/4EcvtZ6P+mC5iIs3Tma9sP4HB/B7GpfUCGDlyPm+pTykD9LOh6f4gzRVlJixVKmk0ufeZFVHWnZb5f4EAUbmbDlFml6sFMcWQZxeaBaNXbDwljAop9dueQ7Z916gpqja9tl3jgGx5eiOi5sof09nNrA4nIPVwVbgJLftgRZyDau07iGJr/z7cnbiJvjtMgBspHPZnjEXpZgYHbrp0jdWfcikgS6yQtKuL6d30P2Y9d5shCJDi/E1LzpqTZTIxsH75PDTrYgCJi+p2RiBysI89EDeLxY8AY3KRja4EsVsy3Gmb7408wT9wdUPgNH3nCNzBxTNntfqhYUQhSdZf6iXHAnKh478p2ZCKoJwfnu4YL4ZckMj3Wh5QP64a31bDdBXSSEqtM4H55JY/VucRVrUAtT3j6Vur3xIYkr32n1FlpqOsUgguoRoh0MmU8pURb50kqYXDjoE6XMiDbBUkh5YY80/RpM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2342462-0030-4061-8641-08d81cde7e5a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 10:15:20.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3UYSndRM7lXlenjQ8dqsezKxM0FAZ8om0kuQwi66NPrH5lqyYTvkr8nTDfIWRSBJToyECez88k1V+qB3BzeiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some general remarks about qevents.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - s/early/early_drop/ in the example.

 man/man8/tc.8 | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8e0cd0f..eba73dbf 100644
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
+   qevent early_drop block 10
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

