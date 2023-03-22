Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328666C5A8D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCVXin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCVXil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9C919B1;
        Wed, 22 Mar 2023 16:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNz57Caoj4S9mx3cRy4OYyhFkuG2+reKeTKWHnVfQpTa8ESCWGTPdtUcmJgfDb1CQCblFPpkgwjLZArp26U9DiE7l0FpRMcfaxaxFNryVZ5NYKmGXxoIxzyPCgLkU9KoC4tZhJarTVq1XtAY2UaOdGoTSw67Obq0fECUuTQsfA5F7iZIlnZ09ygKoLUxsE7mi3jJf20xHB95gjzl35hv02pQzdASv+BH9aMLyWTL+Acf6UGa1gZucS8NyRMxNv4lN7j7o3IybGnDqUBzlFpjGaQH8g6Ds94wS+q85K6rT/pnA47RfwVbQFOqALfuqIN1BJkNIhCP8eteMZdbhQMU0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0nwgOzUkDp4+jLwDdKrO0jKDyMN991pliSwvJEgiJQ=;
 b=lPnMRDxsgaOrT1JMvHjXvUDcng8sWTNX6titFO/2vO//OrlJLBTLcyanHGW/VZxO3xpb8JrnUmUmSjNScPt6g1wpTH7JtC9wWMK1IfP+3XfBwGqzDyGWNO/xJNFKR1ZUA8tYILrv7RqczoBtk8rsV6NGCVa0FOl5hZEIBjj6CPmXkfGkTDWbEKqwzhU28M5xU6a50TjS5nGrTS+DX3IRG7I1HlKr2Unyjy/XTIArxHnoilzPrAwGVw9SnCK0s07tqB0JhTTu0UtSQZs6iGtXv4gjcsiWRXRc+S5MG3j42s0E0FslDM9Xc1R/uQkEMKC53r3GEJFXoOvJmctfy+KRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0nwgOzUkDp4+jLwDdKrO0jKDyMN991pliSwvJEgiJQ=;
 b=sO63j0a74m2ae2iMjUA7aeUnQtP6Jn1o4IZgSAcZPl4DCDIdZsUBS8aE9/kuEy6+kHGQVkGVlbqnaaDXtnsdXe0KPEpd+cfqSlvikl6P1mqbRTwFuXnUsSVXJb9f0ItHopJ22ZAscPb5uSBYUI/Eu8zz1NJ7rfOz/6Vq7fCczrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:37 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] net: vlan: don't adjust MAC header in __vlan_insert_inner_tag() unless set
Date:   Thu, 23 Mar 2023 01:38:15 +0200
Message-Id: <20230322233823.1806736-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef91e27-6a3f-48f6-7c16-08db2b2e8ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8MNN0q+wZ3YoGxc29TcxFqHFPMPtt/eON+jS8ehL3mX9cLGMttF/sUtGOguuR9yfD3kBEo00vdTMAkghDowmy6EwSuJx0M5TOWF0yISWwaEuzXChWeVOc4hvMfouc305BWep95qZc9KxJpGki/Juyoz/aQSC50NEGcvKdyp8N+dsnNzi084Xtgvag02jW4U3P8Ito+LmzUYOSFNP0Yx67H62ItyQYz8SQQXRIknm31WQOell/WggHIip7caw7QE5CSRHYBsAXaeI4Jv6CqQrvQugzGMfGotazwQ4RaOfwmYQFeBamacVz1UbcnyevYx79H/AFCxje7zNlN47t0+cvDQjZi+YNSv+rmd5FrUbnDxWSKH/f1p6W5XOQoThUYALjq6JVvCG/mfhGrnjjvTypvUuhi/1CSqJHjw+i9qaAiMCt+KccmovJkfbLuh9Ucc+mcwbevz7Wd+2guyvENZ9TYN7tatDP878UEIO4ybySX/i7If2MD7nODKlEEr8++/ICs5X3uzelMuTijPQWlaA9z8evzLK6zqcONb7LtRxI+K7v0UXfh8bojLB0GbUnE7SLTyNWGylM0y3bhwg+PyAbc9EnUij1jILTU+3JghdAARAwSUPhWBqxbyzN6JJWElRzLUgzYhgUZs2PRFjojjQ+SY1l4VZOaqrrPLC2DeVOssdWzSV65VAE434Eqm/EB9ht/xiG7QS8zKJA5npYipJHZZrh039rsIg3rNZgyVl/18EgYC4fUnC3GOnwySSKD7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9TCiQQKEUDuXb4s5SL3NLQN4gc62T30HolErvfPwpbgXa7fvr6DnZshmWxTz?=
 =?us-ascii?Q?2IJPZdSMFswX/JxHdA9uRkJoxA3MAqUkQvHx8s57TAiLMsGV4TD0CtBC7v/M?=
 =?us-ascii?Q?N1ue5D4ShGLwZb+osTrPqnDyKoNEwolO+tJDpjK30ADQ+Z7ASW+Sx8c/IcAu?=
 =?us-ascii?Q?iE9XVqQ/ZWhORUO6B2C3IZxde+Hzl490Vv/6KKUWPKEvwWKn3E47FKx5rgtz?=
 =?us-ascii?Q?dcXnYwUJeU3+jPae+jw8m+KdkwKnBVQWgI6J70QCcsCXRCZYdmS62bhBi03z?=
 =?us-ascii?Q?1wnz+plK+VIDAPd+ZnonzH2tUq4ezKkeQbSvhzZBD5ej003PCxbRHRHkv59Z?=
 =?us-ascii?Q?Fte2RRaKTE+SxEIEhr/2lxI0WRclvjJafFJuIROQuY2sl4Z8ExRNsChbp0u/?=
 =?us-ascii?Q?jCaCOvGoWy8T2O+ZYQWBTXdg0iR1wPxUQDJaQdN8TxM0j6aHjCC+CNVbL51m?=
 =?us-ascii?Q?qHbV7qHEgGU/esbQg/va6nguio7bv+TygZ5Omhb1hg1hRG9+Habc6wTuOniX?=
 =?us-ascii?Q?m02Fh2nQRjLsaKzNnCH6bWU//IgQO+KK3EMzphT9zp5n54klejJqeOxDGQaq?=
 =?us-ascii?Q?EzYzWXmHpE1hWC1lQvje0RSl5Ey/mtf8kv/Nw7l8pTiwQe5w5XIQMVmxaNyj?=
 =?us-ascii?Q?3wj7xw2ibn5mAs/NhaoBzRUvVC65Bl6AiL0heZcQFuH6NdY0pRJeyrDP7Ygr?=
 =?us-ascii?Q?wHql2qd7M8DeFKSJBZruOTrqDWn2x11gY0pZM7fkxs6eAZIFZhbdRwkeeqh7?=
 =?us-ascii?Q?6hssamNM3Jnj588XaN7TDn5s6MXxe6hcDJDM0vDZIFKcBfURXljL3hEOBjEL?=
 =?us-ascii?Q?OeA6xIkreMhd5RzniflRAFdH4fK33HhyGaJ3i9HvhlW9znWLs2bJ+CE7TclC?=
 =?us-ascii?Q?N2SCOPa8xROFUkUrVBCMvRievIjl+GnJVtT4qu4UGt9AXK1vxbPCHRg4RBzc?=
 =?us-ascii?Q?vuBmzJzcOYUzQbYstb13gYcLET1hMmpy1i6c7/CWNKT8HTQozdQ9z3/I/Za8?=
 =?us-ascii?Q?ZyebSIaqCr3jKmLkhoywdhDGI1x36d3M/JC3spdjfIWXpNyGxnbHrDwKyT6C?=
 =?us-ascii?Q?7giqoJB+bJP6wGC9MBo4T5byvw/n8uNhvWbzOpV+lu+vHcHKgJx5v3au3r7g?=
 =?us-ascii?Q?a5MRGqfX3QQqy1KBscIEQLMa6X8GxtQIASTzAAMg73keuo2okNFS2c2PMyHk?=
 =?us-ascii?Q?gFwb8juhGiH1YUwN2uXzWyb806evsbufTW5mhTMh6nCl9F+fa4CsUyRDfgM1?=
 =?us-ascii?Q?o4hvNukpxi68Cap36ccxMGaoOrixk0Bbe0IstTAugIXeRei6FteIPeWZjDaR?=
 =?us-ascii?Q?Kj+v/UW9Mk1V9HvQ5BDUP4zQk0mulxU6ExAA43NouUYExJUTK3adUTaImS6J?=
 =?us-ascii?Q?5D9T+EW+lpvTPmc7bsTb5WxLR1jCdbOnave8ytlEnTXcJZstg0GTyHxG3lDH?=
 =?us-ascii?Q?niIbgZowZO8w/TeD8YvUcKJH3B1K1GuUFozkN5AHOKGOszIfnydwLxLZr+PC?=
 =?us-ascii?Q?JvO4Ctqg4pVixT3BOb1cYZSdH4xk0Eec/8xNjvcTxtLSZ5LFJgiC+zD/VxG7?=
 =?us-ascii?Q?SOA7E0O8N7hMQ1qRvg5iie6PXUnvKDTQdD6vnVNhHwBYRPI8ckbplS5rA70g?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef91e27-6a3f-48f6-7c16-08db2b2e8ebe
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:36.9207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRFDoVVswj2UM6BfqLDo/rPF38nQ+JTMZqoYK0EVHUf9v5pxvU9kK6O+TNXTDJud4K9c2vdux5rv5L2M69hy+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparatory change for the deletion of skb_reset_mac_header(skb)
from __dev_queue_xmit(). After that deletion, skb_mac_header(skb) will
no longer be set in TX paths, from which __vlan_insert_inner_tag() can
still be called (perhaps indirectly).

If we don't make this change, then an unset MAC header (equal to ~0U)
will become set after the adjustment with VLAN_HLEN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_vlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 6864b89ef868..90b76d63c11c 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -351,7 +351,8 @@ static inline int __vlan_insert_inner_tag(struct sk_buff *skb,
 	/* Move the mac header sans proto to the beginning of the new header. */
 	if (likely(mac_len > ETH_TLEN))
 		memmove(skb->data, skb->data + VLAN_HLEN, mac_len - ETH_TLEN);
-	skb->mac_header -= VLAN_HLEN;
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header -= VLAN_HLEN;
 
 	veth = (struct vlan_ethhdr *)(skb->data + mac_len - ETH_HLEN);
 
-- 
2.34.1

