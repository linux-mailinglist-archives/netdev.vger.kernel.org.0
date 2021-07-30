Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6348B3DB97A
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhG3Nkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:40:37 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:37764
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239007AbhG3NkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:40:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+TjGKRWQAXc0bCnZP1dZYiUepi7l5QAfdgBWVWq2uVTCvTvUKtDVLjEscrNwXolmQy1pVh9x9BafuBHtOSmSc5mZglkfpAagtnAZx4XJBIPedroWO7mBanylHStfA3gXC0weDWWbTGr3Hg9K9FK9tGM4EOAJUWzW8sO6+6j7LpX7eFIG2CroB4VQxcDmYhKwQpkN8R1mpBkfDAfcRV/5O3Ha3+FNtgmRKgC8kbAciAZDdrsAUHvt6PPtWTy253C0K7EME0KDuaBiBspfCU4dsEzrjYnS6UrDzfXjDPEU7i/D7nyN5st3WKPQ8VwNeecA5tA5dQAfMhTrbsGMsXKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kP9oM0zFva25BhuKewz9q/gaIkw9UA0YoJA7v8DZYo=;
 b=CWfEDwBZj/PBwthDexMyTSCgNsnxQidRohAaa5MWmutDKYVVkXwP8Ozi3tZpbH6b8X2mED10GihsmTcg4MlGkXubW4kot1lvmXVV9+O7cbG6k6KbLAubYTJ6VIRa9H0M44syhO0ECegEj8i+f9dB6ahXjWa1tUxYQWL9Al3GCu/YY1SganL050OXXDwRQ3NqIGzZmVlRwqWXGxqPJ0KN5x4uTemba8UWysatoSlfGGInm/c8f8VbFFd2yBA9oXrJ5uVBp/dbgqd3pQ8jSb0a2YmufIOVEP3sUsg4qAlKDmYEtvpkeJUElb0sIk+dSrWevtxODqJ4AvZvWo50PwlMsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kP9oM0zFva25BhuKewz9q/gaIkw9UA0YoJA7v8DZYo=;
 b=e/8KT0mQN/9+WFmIQvxuWCdKrQ3L5bOxdZgcTSLM3jeqN1KMOBfLKb6RpedHXXbOHteYH2ml3z9F802bBJedsixdlAG83vOvkPlpw8HYY0n9mN4OHvnjYcyX63Z9GFakz/ZDxXGGzgDtWyG6bC+qkJcGInKHKLzj8J18DVpaI9c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AS8P190MB1271.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 13:39:44 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 13:39:44 +0000
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
Subject: [PATCH net-next 3/4] net: sched: introduce __tc_classid_to_hwtc() helper
Date:   Fri, 30 Jul 2021 16:39:24 +0300
Message-Id: <20210730133925.18851-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730133925.18851-1-vadym.kochan@plvision.eu>
References: <20210730133925.18851-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::25) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 13:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdc346a8-1dda-4939-0d71-08d9535f7db5
X-MS-TrafficTypeDiagnostic: AS8P190MB1271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8P190MB12715B9207A578F87F0EEC3295EC9@AS8P190MB1271.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /OMDr5lSkX5WgfowaR0DX/r5nh+dcYKjiHzGWZbHyqx9RqcD430V/4r9eFVKQqUcVyqgAIQHEmnuLgxLetU3Hdc4265rE19Xt6jUthfEncY22gfJ7JI2/y0Fyz/C5L3j5DzTXo+gQ/nJD5DG6oFJLURt9+F0JWNhyt23L90Frnscuo6CGN2O4wDs8UhTuSYkl9LpqQs4TfKvtzl/dMsTPTnuAWby6J1nac5R/ZsB3ixpcakn42YKd2zaV/GxvwU+dg/3J43Y6UshcapdkKutIQqRyRnlzgpyvagV4QG6YTztyzkv4ut17WyeimEtdvscM0F0u16Ta/13nNF27fHXg+4qzRezGejh7m5ur2TbKa1aB3dMrDW/uTRtv5gT7c3NMyMs3xcJLEn6uluY3Cn1s9ybPzLbFX4D+JxnxY8Q56PNcjXakSdRrXaEagigwLDy8UXv+9mjsLgJnWTeyPqOEdN7MwJlCwA+hz5i42VyWFajh6drmiXKmv7g+yZUkD/e5BFMWqZDTj9/1U8vNthWkUG+3YQDzozMYU2gy7GoHPegK9Ct0laRJxj5jPJ1yRjFXlKLO8DjmLHDnjRCNLyTxZo2FHD0cc8tdxOaHVENBv3/CYqzZQ8sWoXZ0U4Gj4COD8GcZDL6aoA4eja66EiVldx5u91GKy3UT8UxCMqZhKVL1fI7zrUtzbjOEDP1rAkHPlrN35q1vAWy0Eng7b57pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(52116002)(8676002)(83380400001)(5660300002)(36756003)(54906003)(26005)(186003)(110136005)(6636002)(6666004)(8936002)(44832011)(2616005)(956004)(478600001)(6486002)(2906002)(6506007)(1076003)(6512007)(38100700002)(86362001)(38350700002)(66946007)(66556008)(7416002)(316002)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwgZZv8h/7O54AIrexb9+3C7SO7ZJZSOjDvCoURRw17KZw0+96EkdEmQgwAW?=
 =?us-ascii?Q?uBvFwa/bkn2P6VtmwMPFhVOAvFjI+HNfHQxyTc/AzAZIfo/RHNwm39BwdVmj?=
 =?us-ascii?Q?LiupYYcxxcROcwAhlRCFQziRMFY178aaUAwAKv3P2P0P6cdNO3noC3lDBRQ7?=
 =?us-ascii?Q?0mfzenZj1xiZfUWH6G8orbZYfF/AeQYUI3uB3qyf3dFG/AyLIKp4ztYe0Rs2?=
 =?us-ascii?Q?Cum8ahww1zoBxqlx172xFQUSELE/8U98qtmopcBG9R2tmo1uiO8RM8FF41sm?=
 =?us-ascii?Q?rdaVPWB8zu89fnZZnQOfm6tAXVigqAg5xMio0slosNuzrOe9Zt1jGO2LAWk6?=
 =?us-ascii?Q?cq3HhNUGgzEU36pyXE8oqRoQMfgIHwkeqHqk4NZ7opF/hBwafcOS/+AgU6en?=
 =?us-ascii?Q?m/PWHWTPMqtyHbVqwkLU6DmGKEt/bZgqkp26uwti+y1Ug1S/N+S/2dPlO/sD?=
 =?us-ascii?Q?XBVbUqDTBtKftG0gJ6Y1yu81rbGPW8ksQzBWWGvPEjtOYV6ZjLfcFLkxWZ16?=
 =?us-ascii?Q?4QG1VSoerRQd2wkS5+5lkWS37xM3xMAOabrOBF9wJjwdj+BpYuJj3EyNOEyU?=
 =?us-ascii?Q?5HiyH7Ial4reMvZYezR26BUw9uLGrPa2mgkCk2cBzpHNvRPIsr2CvSlpvVth?=
 =?us-ascii?Q?je1euTKLocnlr/8dcm5T0FtGLpVa79NKmFeFxuMKkq8zif91qkSOO6hN69J9?=
 =?us-ascii?Q?ioW4mb6TzS8ld87alS8FaT3vJozMFD5U5Zf/93C+Y13fgdJEYOzvCgucOZ37?=
 =?us-ascii?Q?gyhIKGmVdv2MxWUJrTlWes87FQC/z6rj15KxrFsJ/dBUpKUehSxv16u9GkVb?=
 =?us-ascii?Q?uxj6oq5pLJV4YC1DbnoRCpI8yYQsXSe9KCqBWXs2We5rsrJJtvPURLFSDuYO?=
 =?us-ascii?Q?h+IOacVsNpNGz8R4O4l4x8TjX66MSDTpM4lIg12F50gr2rChqtVdVHbOlOaA?=
 =?us-ascii?Q?+xbi9zUPJOs71nMnHzh9kZnvYmGZO/adyYAWOmplJbD8bQrlWnuNyQbd98IX?=
 =?us-ascii?Q?ALSZgj7pF+XlV49UGfu5EC/f0SdIILIj60PVLai3lCjeRcqdftZDQzgmjGoH?=
 =?us-ascii?Q?tf53f87K1oF9naw016+erBDFXlyvGFaelBePAgWaq4DquMkykkS8BSVtloi2?=
 =?us-ascii?Q?FLcvyKWLIg5Qum/uKll2FKSmj6C7EAWc2TVGZxzx1YnV+C0hCunfe9Pj3d3/?=
 =?us-ascii?Q?YYa0r4pFfkbrtAqhgnFyJZ4OG19VB2IYwgrq5y4HKWr5Ssu9wzfsO6RuTvdV?=
 =?us-ascii?Q?MiZG35GpWqdCYTxmECdindvx2YBEU52UNcWcdzx8W8CTzPNJr2gK++Pie5Vt?=
 =?us-ascii?Q?EKIsO+S6vjbsXKmAVuK3lMuI?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc346a8-1dda-4939-0d71-08d9535f7db5
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:39:44.6846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myzA0ilC3gdRyJFb7GjrvK6R5z5s8uA8ip/E5EK/6wGDap3a+H0L+dV9pU8yEfKv2c7sNs0wuUcO0zKKZBBwG7mdSEudzjUYHONs66L9TGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1271
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
index 9ed33e6840bd..b6e65658b0d8 100644
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

