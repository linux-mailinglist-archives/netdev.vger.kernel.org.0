Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6E2339A23
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhCLXqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:46:47 -0500
Received: from mail-dm6nam10on2109.outbound.protection.outlook.com ([40.107.93.109]:52143
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235874AbhCLXqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:46:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkYfcfgwgpGrgjXKNiRVpM1AL2LDC7kbCnWIiQS+wD5LnQKk94JUcSeIgfovi6WR64/3x2FvLmZ0TLNinYcTQuSBUuby0nautneBEmyZKVDWsh/EIzJSMLOcVs0R2ZibGrAMLYDvW28aJ1tK5eSVvXSoqzeSE/kFXBLodiW04mXHBbYUESl4xlioZ/1Hrn2L1RtAuA4sUSSuBRsIZQ0wowqHDo0D0aKighL96yxp0C//RTmBZBBlDnVxLxYJJOjw1j6sJMkP3zlAng/ykX03/xuowLYlrABCX2W4tvZlQ0rGCTM0bHVZl16RbvhiAevkzQ51kKv/nPYIknwkMpqIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phfrcTnzkIFjtqag+p+QaWAA9aUiPxFefARrXk8slNk=;
 b=iFBhA61zq/o5n+mNLxthyHnMsgFibeNjl8mX+CxGa49MeKSZBrMY2gqB7nRctYSSefJi6x/YzG+pwIi0oewDS1IFWxUiwSZkKRYVFAellE3kdMZmDR5BpPIj7cH7F2lPjTup7MYiVzOcTIt0VE3VNG6O02Z7Ougq4AqJS2Fykvw57XzE/SBhaFojvmodiLtmCA2DDrv3CYbgZEeeWt3IsO2KRnjEDGlefPd7YwLQvkfk5PnftCTk7AXZ6+Umo5MMxmbz8SSkB86Bz1WTz7hJWXBVffF93CA3jHuKKAeRHBay8mlFYcH2WybiENhTBrkOj8z4Eh+L6pEm2wJy5UdULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phfrcTnzkIFjtqag+p+QaWAA9aUiPxFefARrXk8slNk=;
 b=iI6BmsOriYIovx2GDag7HVF20N0n+iQGkJljtH2X70OUkLAKXuFYtwXsFwcJxY+fR2Fc9cXvbwwfCx02aFlH7ANvGtQ7lQXg19ekF5DufqijCBEGeos883L1oebX2MYLuW53H8+GTxmJ+PLG6jIimWkI6pixkwwWZZ0cDGiC04E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1767.namprd21.prod.outlook.com (2603:10b6:4:aa::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.8; Fri, 12 Mar
 2021 23:46:08 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::488b:9500:3b0c:e41a]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::488b:9500:3b0c:e41a%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 23:46:08 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Shachar Raindel <shacharr@microsoft.com>
Subject: [PATCH net-next] hv_netvsc: Add a comment clarifying batching logic
Date:   Fri, 12 Mar 2021 15:45:27 -0800
Message-Id: <1615592727-11140-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [13.77.154.182]
X-ClientProxiedBy: MW4PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:303:b9::25) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MW4PR03CA0230.namprd03.prod.outlook.com (2603:10b6:303:b9::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 23:46:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 183f3c06-a75e-4bd7-cecd-08d8e5b10205
X-MS-TrafficTypeDiagnostic: DM5PR21MB1767:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB17671638BA930A39C42C7367AC6F9@DM5PR21MB1767.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1N6NHzX14qVy3AbC3RXXx19S+lBMafLw0sEd6jnvxKFtm62v9KFfNtZVQiVhYJORT9lktuQXFKLrfK6jMUAHVbgl7ZIBe+ggHZO7tjlkDbzmUX1TE5kAK015+eyPb9RKX0IXevtD6ojaaS+wPqhwWQEv16qxP0BE94+/izHCYiuGUMsXVRAGtjiVAaDWhDovPKgdVDVy4TC/zPRPKXiDfW3EAEvMOlCigzqGkRm1QKXvUHvoY4ZYc91ihjS5lRlTvmW5m/q0+fkSzX043AWhX6T5XUqpZoozsw+vLoX0ra4W+RztYj4u3S9yFb5FwOm49IKBmtfvVYP0zLfT1Y8rbT69+PO2QW/UZ/3HeTUQChuEdlJooezvldCD9EiLy1WWbMj02rqwgZ/LqD028j+Ch8h8jSH5a+UqeSataOZfeYdMhBn55BXp3vTLkRMA9WCbE0d8GpyRy0HhfBz05zFJoVe1hG3XhpQlHv9rBrzgA76E5xvAX+/Mie9q7dMnEGYPHdpizUDf0HagfsN4a6YO858g8xawMCxWQWSmvpshPSfUKplfvgjtqLpn2cT1LLd9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(66476007)(82950400001)(2616005)(6512007)(66946007)(956004)(6486002)(6506007)(4326008)(186003)(83380400001)(82960400001)(66556008)(6666004)(2906002)(36756003)(8936002)(5660300002)(316002)(16526019)(8676002)(7846003)(26005)(478600001)(10290500003)(107886003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d4C3P6SivISwW+mmkjvm+Tk8ljvHKP4KlpXOIET97t8pXZmnhIaeNfd4SqtQ?=
 =?us-ascii?Q?tmsfwib6gILajaRpRhJX5+/ftCuAZnCLzkR9g20jNlreUls+Tybze7TRAcoK?=
 =?us-ascii?Q?gr/Ceoe29bReN0E6dxjFjMR8ydwBONa7iBJl3W29dXtCKMMaR3EbI52EeOcd?=
 =?us-ascii?Q?0SIvcTRyhb4RRoD5d+hjSyV8gBgL6RPqoIk0ZlxXMbLNmhje8QVytpV0BNJv?=
 =?us-ascii?Q?5QfDrSbBCOMfkW8Vp8TJyeGveHZ7LS0UogMiXQHFlDSJHko2W6czwkJgG1a/?=
 =?us-ascii?Q?fmJ3UMAp+zxzY8EBgb9N6NGoq09Ngb3a+xo3oX7ciQk1KZAFIROFCcXN+LtJ?=
 =?us-ascii?Q?p3GMKn+T+tV3qLBQZ/crr3MfqmmBA+xNYbuWTnkiSA+siILkNvNY688GoL29?=
 =?us-ascii?Q?NgprL+11eMyX72QYaWSxfDdt1EkZXuyyLX5MbccdSmVdMlX5MI1wPMf2FDKp?=
 =?us-ascii?Q?nm/esZRqbqJ2zvzTukOJB8+Uzeu8HJZQ1S0qOcJ6mIa3RrkTjaopcwUa9JQ1?=
 =?us-ascii?Q?40K0Vej15CGd2YxZOIXiRaDbQvJv99j2EbxCHmI1CCmL4/2Ol5DpBcy8wxlK?=
 =?us-ascii?Q?FubAD1xtgpLLJdshE+bXvxO8PN8lNFd2bydqQUJyEHJR0CSOgAyvUFmBPTTc?=
 =?us-ascii?Q?3XsoFAJY4e0QlEPq48njtamFQzNmwlfP+YwkJAIKulC2ScmpMtkOaV0ca+0H?=
 =?us-ascii?Q?2g7Tq5MLkY5ib0vwGvcH7pMx6nhmc+I5HEK7YK1ShhU4ltsgMDkojP2ZoED5?=
 =?us-ascii?Q?CWwXaWlnXwFLbxYCWNaEGGqVqZyN/5WA+WUjpYFFoNGq2rn3pFCzsDAq6/Zp?=
 =?us-ascii?Q?AXyzVBHGSWsJ+E11phHeCabsRCS6OBNWZX18Oj8UlZmuDH/hFrKR/++HcNfV?=
 =?us-ascii?Q?wQ5s7zshKzec6z/dlHc2PgKgnRsPX0CJSzKjqfn7/JnCkuXPdCnyrXCqQIPK?=
 =?us-ascii?Q?qxTSFgyFlIxVsE6vIFvo8Z13R3iZzzfgbvVfoOlXKe7YEIHB8Nm8jkvH6kR4?=
 =?us-ascii?Q?DA0RFzcg1AFIzu9ZlFfXaRJxnBX6Az6BMC8rqoQpGqOQiCedk8wuOG2Xu9a8?=
 =?us-ascii?Q?5lpzalU2K7w4R5oPrR9Ft9kneoggWpuJAkAw/bCT0gKapNoWzcfsOPZVq19P?=
 =?us-ascii?Q?1L3f8OiHbLArp36VMeCpQzKL5OLsa0IRWL5Egj/WT7ImxaEt6rl+NzyQW4aL?=
 =?us-ascii?Q?wDEYoDvWmdaAiEJ9uI3m6MgqQQ8sG3YfxUPmIjQvXwrZbL4vD6P509MGbBjU?=
 =?us-ascii?Q?S+DqHlqt5O8WoeoIND2PFa6OUqhjCR1SrU+smvshb/kV/VbR5xWmeZML+yxX?=
 =?us-ascii?Q?AP/rZY4DuDOPzTo/ZHMXLuNV?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183f3c06-a75e-4bd7-cecd-08d8e5b10205
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 23:46:08.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiNfcJ1GXI0TKCLPgmL4veiXze46Jhg7LOvS3LLuyrfgl2FV/DPVOXDKYTpAEDRGSwK1ni4Vvb2UH/6bBXBdpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1767
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shachar Raindel <shacharr@microsoft.com>

The batching logic in netvsc_send is non-trivial, due to
a combination of the Linux API and the underlying hypervisor
interface. Add a comment explaining why the code is written this
way.

Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 .../ethernet/microsoft/netvsc.rst             | 14 ++++++++-----
 drivers/net/hyperv/netvsc.c                   | 20 +++++++++++++++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst b/Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
index c3f51c672a68..fc5acd427a5d 100644
--- a/Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
+++ b/Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
@@ -87,11 +87,15 @@ Receive Buffer
   contain one or more packets. The number of receive sections may be changed
   via ethtool Rx ring parameters.
 
-  There is a similar send buffer which is used to aggregate packets for sending.
-  The send area is broken into chunks of 6144 bytes, each of section may
-  contain one or more packets. The send buffer is an optimization, the driver
-  will use slower method to handle very large packets or if the send buffer
-  area is exhausted.
+  There is a similar send buffer which is used to aggregate packets
+  for sending.  The send area is broken into chunks, typically of 6144
+  bytes, each of section may contain one or more packets. Small
+  packets are usually transmitted via copy to the send buffer. However,
+  if the buffer is temporarily exhausted, or the packet to be transmitted is
+  an LSO packet, the driver will provide the host with pointers to the data
+  from the SKB. This attempts to achieve a balance between the overhead of
+  data copy and the impact of remapping VM memory to be accessible by the
+  host.
 
 XDP support
 -----------
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index dc3f73c3b33e..dc333dceb055 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1006,6 +1006,26 @@ static inline void move_pkt_msd(struct hv_netvsc_packet **msd_send,
 }
 
 /* RCU already held by caller */
+/* Batching/bouncing logic is designed to attempt to optimize
+ * performance.
+ *
+ * For small, non-LSO packets we copy the packet to a send buffer
+ * which is pre-registered with the Hyper-V side. This enables the
+ * hypervisor to avoid remapping the aperture to access the packet
+ * descriptor and data.
+ *
+ * If we already started using a buffer and the netdev is transmitting
+ * a burst of packets, keep on copying into the buffer until it is
+ * full or we are done collecting a burst. If there is an existing
+ * buffer with space for the RNDIS descriptor but not the packet, copy
+ * the RNDIS descriptor to the buffer, keeping the packet in place.
+ *
+ * If we do batching and send more than one packet using a single
+ * NetVSC message, free the SKBs of the packets copied, except for the
+ * last packet. This is done to streamline the handling of the case
+ * where the last packet only had the RNDIS descriptor copied to the
+ * send buffer, with the data pointers included in the NetVSC message.
+ */
 int netvsc_send(struct net_device *ndev,
 		struct hv_netvsc_packet *packet,
 		struct rndis_message *rndis_msg,
-- 
2.25.1

