Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F453DDA56
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhHBONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:33 -0400
Received: from mail-am6eur05on2093.outbound.protection.outlook.com ([40.107.22.93]:24320
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238230AbhHBOLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:11:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwlkSzQ+ZYz8Mpsges6/WIpinVFSLiPy+IA/jU2ts2qb5qw/WlYRoI2tP21AwZ4bpik0Eqs2v7MpMfAImjLr+l01QNBUxgITKpLSGOePDmK9m6S0DW6y/YN/NnfdWsMkEoOtDNLZkD5BJaEvk3XxrS1cpaHJLSOzVHNWpB2w7n8OXleSuHu83hLMg29NdabwYFQOjZgzMv5iU+UqvNqqmmPTTUQ2DN63ZOIs3bXD+Oufhk5keWMU+4ZHedtRyuP8n+Q7otHUevh/nutEGF6T0r0X1eWIhEQQROyMkNMAuGEyvMs6GOEiLyT8dDpYtEw2nUtlhW9BcbAWMaRT41zhyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SJ3yoNsdCIPNrr6rZDTIOM3bKzoM2LejY+DM/1guLQ=;
 b=RLh1fMdX6ljS/1rSuQrmbjLJaKOclx6gZTQf653rIlh5WrfQMns95H95PlDEI46/N9nOCOXv5Nev23WwOKvhlLC9fqF0JcDriidXVjFBZWKSvIAVepU9AF6eBwD4X/oHN/jrFOWQioGbVeAdajjJ8GWnN1U3ScWKc82bKw812yUFAEiL+C84HVFSb3wEDmTjMwK0yG3raaA+CZCrw57wohiihIWIgPvmRsmnZFgjLGpGowZfcIKeQNGmh2VtmCwKfy5M1GxObt12AW1nwRMPgxo40cJxfYBJCpf0QBE4C+t2YNDLTvUb6aVjBN2b39Y6YspZ4CbbjI8FjKi3r3VVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SJ3yoNsdCIPNrr6rZDTIOM3bKzoM2LejY+DM/1guLQ=;
 b=vJQ5Rqui1snsNIzOjnvEer4TO9BBSfNwTxjlP8Krd7y0iL9AWr3InG1WLIEDxh6HJkxsC+fDlI0QmSAGqdvEYuxyT6qzTdrUL3BdfjS78jxLF5YbagJQlGDAsazECLzrVtrohncHiAwyiq1c8lWEiFIrpijisgRhi88weuidajk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0306.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:09:25 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:09:25 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 3/4] net: sched: introduce __tc_classid_to_hwtc() helper
Date:   Mon,  2 Aug 2021 17:08:48 +0300
Message-Id: <20210802140849.2050-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802140849.2050-1-vadym.kochan@plvision.eu>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0066.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 14:09:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57d62989-2202-46f0-afe5-08d955bf2240
X-MS-TrafficTypeDiagnostic: AM5P190MB0306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB0306A89DE222FCB3D42AE47895EF9@AM5P190MB0306.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OuUa0HfAMoYCRroFiRbe+Lv6YhaPTMU6A1MJXaC2k5TJXE0urqzosmkSyoqnoI8m/Rl2zdZc5COWsvUE/lvKwvJ5spnUODLo96070JIb97H7ezLnnGxs1aV6gCV4+vZAO79bUbu2P3rxYIcHPz4XtWWNHNOwaS8/a2OdJe1d8ZJa6l7GnTwOQ/zgy6Z/xK0FfOcCa/mCsQdZ/1msK79JQwxnsBYINroXoWPeIBQGNxSexeuul8VjcS5o3SI20o87aMYwmmnqqIyWqwqBJeHPDDt/o1GJxTp+gDMU77y9AcGn6USMJ7D/k/qM0Ds11SsYEe/NZq3IGw3FUbEkZsQTbgq4s3FzAY5TdP/eSD36QozXkDHOTrhwC/ul6ndwitShqqknAIFUaYcCUWHGuffjzjJnL/irZ35BnlCI14GbRBw8k/vivGQK9LZyofEWzeJVFvRrVr+kKiZpZQoI5CzwLuX2hkGkw9NURAEnsmbcdv7ds4eFNKDCJe4aXNLt7NilpwPOasprmdxmCkUAkLEj+9WB356HWx/rZP/t2+m0GwWiNBNdnjv4+2+Id9wDik2N3fjy6E03Z2eadBKGsf9YRZJqUCEN5ee3VnKAgX30tpUk2oWO4wAcm8NpBrJLm2akwnkunXjHbMua5OB479eXhs1ybuBeM29iqq9dSENNjdiSOABiLDO8CC3zA7/S9LEK6TOkrniHmKs6EZol7GDGuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39830400003)(136003)(4326008)(44832011)(2616005)(478600001)(8936002)(956004)(186003)(6486002)(5660300002)(86362001)(66476007)(8676002)(6636002)(66556008)(52116002)(66946007)(1076003)(2906002)(36756003)(6512007)(6506007)(7416002)(83380400001)(26005)(110136005)(54906003)(38350700002)(316002)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E8JjEthoZBs5umgH9+T+9wct9LQyE4uaZSzyR7mmJ56Xukuk7bZBR09yj9Il?=
 =?us-ascii?Q?3fEAtAuPUQqhmppriHVK/qoNLZDqRxJsryrjYcHCjWUBDjH4p2f2FAgexC6c?=
 =?us-ascii?Q?6H4P8G7UgdTKK0aUWbNfYwHIZGjlzp1OpDQ4ErNNzvjbIvPs/QWjcFAPFt5K?=
 =?us-ascii?Q?3kZr/awcp1PUPIZsm8dxK4u3VWCohjQ+3OptJhJTrXd+KXx79xvHXxKH4A79?=
 =?us-ascii?Q?ds1F+SuhCHChPY4WxKGNhwY+7fy1TjI6rOB88Z1RicR2wKCLVPQHOcl/zD0Y?=
 =?us-ascii?Q?N0K8Tomxw3iolJBNQtzQ/3woXcHPQ4dSEkmYbArptprWi9sZZo8ygCtMgeVo?=
 =?us-ascii?Q?JosjzxESpVfkUCarGalEB5PIoDZP0++mkgulcvgtAt2q5ixGgmxFwDYrkTXg?=
 =?us-ascii?Q?z/ZkLAPyQtCuwV6vA19Hf7CKlpdApnyKe01rhazGjfHkHfECN7PFn+dHDg8/?=
 =?us-ascii?Q?exc1Qkx/7dvP0mxLchfEc6QonZKXnkeky5T5jDGd663PW5PR2lED0oJISouk?=
 =?us-ascii?Q?Y8I8gpJ9Pvksy6uRIoyRZtGbQboj0OBs0wwMNU733KfPHfEJb0lCMfR6DqXY?=
 =?us-ascii?Q?HTpNKf1ZLNM8OvEuRiqAbxArQA9wePZaqP4kl8neEKKNHwdWdqjfgUg4bXzw?=
 =?us-ascii?Q?Iq75zam+q4GQXXbQN+AxpQ3YArLuChSpQEf//Cclzd1wQA7G/PIUyGvWBKgK?=
 =?us-ascii?Q?XqoyxFn/qkPm7KE2n4/XA6Ik1zz14dHCAw9RZDcj2S0PJvKaHerCPaFoRJI6?=
 =?us-ascii?Q?2gha1KtC2sdvypAku/dvgqpA3yw3s2IzxWti4LswIMl9qd3wdthxJpvD/ZGS?=
 =?us-ascii?Q?IjvOw9YCqClLR/1QkZv26ZpGXTf1BriKCsaT7si3N1orKbbs/DzxBot7oe4t?=
 =?us-ascii?Q?zbuMf3zf+AyL3eX08PWyTpQoHKUK2j39v1bwkj1XqBiHsXFD2vCMZhFLAx0l?=
 =?us-ascii?Q?UJMQHgS/iZIIaSw09XFMVqFMqQp1fwh96RzxMB9IJcdPKAE66X4FEk1M8gf8?=
 =?us-ascii?Q?7CIRYuI98YZRcachLUfXXnKfMl7dhFTV38Hvbkg4G0y0aJMrEL3GlBOzUA8A?=
 =?us-ascii?Q?f+BNr7dD/KSV+ZomlLloBk8sVn+UzxAAH+n/LyTPecW2XrHd/LlOlmUHy6Nu?=
 =?us-ascii?Q?3IKnKL4nPywKfdPglBpXdi3ZleOlzeMTCBYA+C1hqx3WYyEhM1Kg1WDdfUp9?=
 =?us-ascii?Q?XXM7Py9vE9DcLyU3yQUHZI5BbXMXBNX6vfj7UMqwAXNOsweBbGJFEv0e9n0U?=
 =?us-ascii?Q?ozsmJ8jT9h1iW/JAiyUqWsX3PZrfKxLl76MX6oyUjm3+FrjrA9HHSiKw3iK8?=
 =?us-ascii?Q?8Tp+bK3CLzlo+LV1jCnY69yp?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d62989-2202-46f0-afe5-08d955bf2240
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 14:09:25.2788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvsCmn3ULBCyfZto27fHJiVoOuWNzBjeiAZejdBdr0KMVE1wRXf06jdetGfGfVfHrgST7u/y5keBKExsLQzxBucO2q7waVd4pGp8Av1Vku8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There might be a case when the ingress HW queues are globally shared in
ASIC and are not per port (netdev). So add a __tc_classid_to_hwtc()
version which accepts number of tc instead of netdev.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 include/net/sch_generic.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c0069ac00e62..df04f4035a4b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -668,11 +668,16 @@ qdisc_class_find(const struct Qdisc_class_hash *hash, u32 id)
 	return NULL;
 }
 
-static inline int tc_classid_to_hwtc(struct net_device *dev, u32 classid)
+static inline int __tc_classid_to_hwtc(u32 tc_num, u32 classid)
 {
 	u32 hwtc = TC_H_MIN(classid) - TC_H_MIN_PRIORITY;
 
-	return (hwtc < netdev_get_num_tc(dev)) ? hwtc : -EINVAL;
+	return (hwtc < tc_num) ? hwtc : -EINVAL;
+}
+
+static inline int tc_classid_to_hwtc(struct net_device *dev, u32 classid)
+{
+	return __tc_classid_to_hwtc(netdev_get_num_tc(dev), classid);
 }
 
 int qdisc_class_hash_init(struct Qdisc_class_hash *);
-- 
2.17.1

