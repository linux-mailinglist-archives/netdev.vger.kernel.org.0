Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479904538B8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhKPRqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:46:03 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:61864 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238934AbhKPRqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:46:03 -0500
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AGCEDXC027240;
        Tue, 16 Nov 2021 09:43:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=nBbgQqfkCcSYLm7PbA4DIjEwip7LRenRfeCF1CmjuEA=;
 b=NJs/0AXbrqvPoYPoGNkyMkbq0NTN2/s1oOtGWA+dNBLqx7g3u1oBKvq5EvpCSj6dpNE6
 bAWQ15y9LriieaY86UWGox/OJaYQ7lC6OJoJCLBk19AAffUItEZZ8qkrxHq/6L6gIfBx
 GSK+xc0BeVaj/p0f4wTCuHq9HRlIzFezt/KKR4Tc9cZ5+i69h1HUnkR5oRbpoRlbnIlH
 fqh072b2pep133S/feA5mrbttjnsMt2GrctrRXjfmCXB1hC43roToQKzDgY3ulvsy/4x
 uuOXq7SHzCPypDL9cQv04cpeU1IGNHA5pxt5eLqMKD0nbpMpvmTnC8wAeWpYNQzrYbx8 3A== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3cccfjrue0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 09:43:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXJC48hZe8r/Xc/atFGoSDxlNqapaq7QJLxRWnxTgI/TI4tV6xfEuSW0/9AszlSFwh9NNoYeb9LMHzNEciMrdcVZmlGPLX0hElLgd3XnT172O5OYkXx8ZMHJ9kKbvd5qVzDsAB8gtqnzxEDNEjdzUD54ADKJmtbghfR3UVp2ZjLS4jl6ou/529/xmEqOsOIBJba7yYsybH7dIM3rOA6F4La4cyOH7KsW1ZZb/IrWP3J7SLcTSYCmwipF0Emqqo10TqHaCB4Xi996ccR0t1z8vrFSdaXNGkPOSFADzhe6TQBR/Xj2bxb6e8f6ml3nCCiVWkBgs7oOFNXWRZkfao26BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBbgQqfkCcSYLm7PbA4DIjEwip7LRenRfeCF1CmjuEA=;
 b=HpkJdtPILoyoPpsug698b1N+TuIOGu0ew8wY1YVjvE7hsuMrLkZrhJt6mL9chKMI/l4rQtcXHXKKRScyndIUB1+wbd0mfd4kh7Nq0fjuMB1cwjzUejXQ7LIEP5NJ+pqKy+x026fQT7hwjzsbkoZ4pCJGsBSE2hyW+vqCqNydc7Z1EumStOwjxxf1lmOSm5Jrea+nWANrYUsz5USEgcFl5Bmm9nVpXWuolP6kPMFdLyeK7ZgbLHV8w2sGNHMnlAHCF/wDZgt+UAsxl1GIdW+anGmuI7Q5yzoP2ycqDQZa4iyyivhxC1VfrbY1Eb4qgZeDItR87zpeXqwMUA+r43X1gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB6727.namprd02.prod.outlook.com (2603:10b6:610:ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 17:42:58 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 17:42:57 +0000
From:   Jonathan Davies <jonathan.davies@nutanix.com>
To:     Willem de Bruijn <willemb@google.com>
Cc:     netdev@vger.kernel.org, Florian Schmidt <flosch@nutanix.com>,
        Thilak Raj Surendra Babu <thilakraj.sb@nutanix.com>,
        Jonathan Davies <jonathan.davies@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: virtio_net_hdr_to_skb: count transport header in UFO
Date:   Tue, 16 Nov 2021 17:42:42 +0000
Message-Id: <20211116174242.32681-1-jonathan.davies@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::16) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
Received: from nutanix.com (192.146.154.247) by SJ0PR05CA0011.namprd05.prod.outlook.com (2603:10b6:a03:33b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.4 via Frontend Transport; Tue, 16 Nov 2021 17:42:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3b3be91-9779-4fd8-56f4-08d9a92886f0
X-MS-TrafficTypeDiagnostic: CH2PR02MB6727:
X-Microsoft-Antispam-PRVS: <CH2PR02MB6727DDD26C7E9046F556EB1DCB999@CH2PR02MB6727.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6N6Q38n4LaLapCh/xHxCuWAxsDzrHg9+Rkl61fcWzh1HT6Sjb3B/+JE7UIM8vNb3R4usqNrpnGZ/ek5RAK/T/Ic0ALx1RZMrl0jty4hA5InBa3aLz5GShVX/8I8j+jYKFaXsg5GVEHjD1hG1Ip/hKOPkIqkuKdZ008Nq80cYjNJ9Cn71hth5x457YYbAxICyexoWo8lykd1Cgcny0BvOsM+O/IjDDm8Apk6KdBElBt8f5zQgaU2OFz4+ZTgkKLa+TpSel+j7LRXCBvGrl3rUFuq5YXb2nNgRcIWuzUy71Rvz27w9JMIDKfV9h+RTz3rfupkCrs2KjWwHfZ2Ti9SP4t7Rn6DGzaMXI9ri4i4MFus5uvbn4FPvIw1cBmzXe4fu4cVKT0mfcQ0T9uNMcPz1wLbiOYDb7j8GJ7WXqF61LUL8ogmygLBzinbOx8WdGpWoMhXDKCtrn5+dwSu8UKxhII9c0y7YsGK/ltOx9SmqgfakSUaoxdaqz2VjI1DIwCqPsjNl07Sa+v5zQ/HKD52Mde3kB5oLDfnJ4wCBbCYmS5ldIXnaleWH3qhu5aZF3Dy5azjAMlS3hb+jlO0WIkdK6IwLbp18jyzSol9X2gVFljfdp7jskHLMZ9nRd3bKNKlUd/2n7025ILx+Umyay7dTRiF5ohyFfCFRUPRu3AN3XaNMsIO1ZVScJTOw8W4yQamS6SIYeRZbshuJcmz/vsCMDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(52116002)(83380400001)(8886007)(5660300002)(2906002)(956004)(44832011)(38350700002)(38100700002)(8676002)(66476007)(66946007)(66556008)(508600001)(316002)(2616005)(6666004)(55016002)(6916009)(7696005)(26005)(186003)(8936002)(4326008)(36756003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HLPkaS84FJpdNRZw3eIrAQU4MTgf7r7WjINrhOq87xxJB4/w4XCig87aj3wS?=
 =?us-ascii?Q?Qd+QiowTxcsiVfdgD781wFPHZggMpzmsozNZKXYepaf0bfhWrEFslV8LX6DE?=
 =?us-ascii?Q?9P5JEuTzAKYQR7dm7vQCxYPVw6cNnzvfmEWPMORD3d+K2GwxOScp/Fb4LAKU?=
 =?us-ascii?Q?EmHlx7Sf67ogz64Wx6bUotLPhFPg8Sec/N+C7UmC3naHcV6lEy3kpmMascpI?=
 =?us-ascii?Q?OenvQ+BfpicrfdNLL0W4BjC5tOBYxEIHAF3Yyr4vii/xpxa0nNSWIuOSJF+P?=
 =?us-ascii?Q?ZoSqoii2Cu6O8OAOOja5iRi2JUAIEtEYa9BkasDzRAqwIRxMBatUrGLpn9/5?=
 =?us-ascii?Q?AIH7M+R2CRYUdPrgr8yVM1Y7VnIyqY6reNZ7xPGPD29mofzKTIQksKya8+j5?=
 =?us-ascii?Q?WkOSaue9hkHJH3prSdXcLC2q1G1badHaIJY1Hr15hTZaJBe9NSBCU7Qmp8Zw?=
 =?us-ascii?Q?hBPKcrn9RMEyb+ssE3V4/BpFhIKekXck5HvruymkrkjEAtgdUsC83bEEI5j5?=
 =?us-ascii?Q?tMgSjYowr3QOpTSTeU/m2HDXLC9EGg+Z2k9pl9UGrVvkBAxRFbhDF5gj+kNM?=
 =?us-ascii?Q?h+/1P9cLs023msyJimSqYHoXQVUHaHIA78sae0FIIc1Tc6uJ6eRaHUCVQTYg?=
 =?us-ascii?Q?K0KLyx3Cx/R83HM9knc/ziG9zpqELWealTKzLBJq46SEFht2QkafXmcxgCIA?=
 =?us-ascii?Q?2l4lAoJ94mkLDRjfgo0PgA3ZpkdLQ+JsoR1PxdpHG/7ZaaBdfewQwXBT3vXu?=
 =?us-ascii?Q?TlXPa98EGVX5+gVS6HdNQ5Z/hv+amwIkRgOI2EKmzd9KK6/Q+Kr+INFX3BD7?=
 =?us-ascii?Q?t+qX1SSKNknLpdJoPw9oU7/xlXaWAZQAUNIza5ItTcGCBruNX7Ax6pqJz1Ga?=
 =?us-ascii?Q?jSTnrgaATsAoHqSBmq7CkvnNO8XdRymYk0guFUPSjiuVZyOnDphdTFQG8HLu?=
 =?us-ascii?Q?vbTgXaUuYRqmbd3TMPh2KdK+2ioR+0IiVMRHEe5h6EB2Z1lZHtENteSIIrhv?=
 =?us-ascii?Q?903PRf/9twV8jxXk8GdKzd8Tb4tziNDKmY0ozUZEKs+9mem0NxnYkkOdExUv?=
 =?us-ascii?Q?DW8x9GZIz0gendXGDpAk38FryEHxZATZFeJgGB/2Hoqdp2siX7HEt8RaSMDS?=
 =?us-ascii?Q?8hFWDvAtcCm9GJO+LfbfKMbLOOQ0wPcd/JssgE/oZsw3bYE/Ku1TrdtrgCjN?=
 =?us-ascii?Q?hed9cC1T8ZYT2hDwNOOdPIXgMmNpl1O2028MUecQ1AEIHCd+OL3EpZD2RLKn?=
 =?us-ascii?Q?ljfiL64AfBMODgO9ct+xkhvL31jLAnF1DO0Ax3Wv8Dzg1F+saJt9w06JGnGV?=
 =?us-ascii?Q?UHLPRHBG71vopL1hlqWTImq8ZEiS7khThqA16z7WsFaugzQ8aJq3i3kHMueD?=
 =?us-ascii?Q?izr7fZm/a//u04vR9gcDObup4yGvVXMRRB709EuV5jAhEQzUz23o8rB6u/Hj?=
 =?us-ascii?Q?o6DEfiBcYJ/OClMOTBC0OUiIYYJUBgRb+KX6rHGHm1l+91aS7doQft4YiF58?=
 =?us-ascii?Q?z7SLEnDjLm9zRa6JLic9BhqbhL4MJhM1nMCf31aMebDuQaWLimjiAgxfao16?=
 =?us-ascii?Q?+bdwL2rmv1y3wfHk6elcpWMdHVFRqlUYmjQmvbqUM+y3rgxGLXqkjzFvhUGY?=
 =?us-ascii?Q?y/yxQ1+tKP0iPpKDa8eSzIiZrzAsZwDxK+vgzFa063YheFnIVtu/pwUDVM8r?=
 =?us-ascii?Q?MwYxHgDG2vl7asCHrTM+sv4Xw4M=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b3be91-9779-4fd8-56f4-08d9a92886f0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 17:42:57.8653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGDqDO0sxS1q1MezXv0qc1N7RlawDuiA2N2pPm7blCFtSjDAJlDFKEkTyc+iHE8LaJjqSJyuCdBa/Yj9iC9AIzB6jihEUe3iul7g77KuLzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6727
X-Proofpoint-ORIG-GUID: spJqN8wY0ufEqNuiIPJ01a0KdcL1Nd_d
X-Proofpoint-GUID: spJqN8wY0ufEqNuiIPJ01a0KdcL1Nd_d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_04,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_net_hdr_to_skb does not set the skb's gso_size and gso_type
correctly for UFO packets received via virtio-net that are a little over
the GSO size. This can lead to problems elsewhere in the networking
stack, e.g. ovs_vport_send dropping over-sized packets if gso_size is
not set.

This is due to the comparison

  if (skb->len - p_off > gso_size)

not properly accounting for the transport layer header.

p_off includes the size of the transport layer header (thlen), so
skb->len - p_off is the size of the TCP/UDP payload.

gso_size is read from the virtio-net header. For UFO, fragmentation
happens at the IP level so does not need to include the UDP header.

Hence the calculation could be comparing a TCP/UDP payload length with
an IP payload length, causing legitimate virtio-net packets to have
lack gso_type/gso_size information.

Example: a UDP packet with payload size 1473 has IP payload size 1481.
If the guest used UFO, it is not fragmented and the virtio-net header's
flags indicate that it is a GSO frame (VIRTIO_NET_HDR_GSO_UDP), with
gso_size = 1480 for an MTU of 1500.  skb->len will be 1515 and p_off
will be 42, so skb->len - p_off = 1473.  Hence the comparison fails, and
shinfo->gso_size and gso_type are not set as they should be.

Instead, add the UDP header length before comparing to gso_size when
using UFO. In this way, it is the size of the IP payload that is
compared to gso_size.

Fixes: 6dd912f8 ("net: check untrusted gso_size at kernel entry")
Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>

---
Changes in v2:
 - refactor to use variable for readability
---
 include/linux/virtio_net.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f..04e87f4b 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -120,10 +120,15 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
+		unsigned int nh_off = p_off;
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
+		/* UFO may not include transport header in gso_size. */
+		if (gso_type & SKB_GSO_UDP)
+			nh_off -= thlen;
+
 		/* Too small packets are not really GSO ones. */
-		if (skb->len - p_off > gso_size) {
+		if (skb->len - nh_off > gso_size) {
 			shinfo->gso_size = gso_size;
 			shinfo->gso_type = gso_type;
 
-- 
2.9.3

