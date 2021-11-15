Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13829450814
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhKOPUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:20:10 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:26736 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232269AbhKOPTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:19:41 -0500
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AFC24Vi025273;
        Mon, 15 Nov 2021 07:16:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=kYhs0KX2JV1N9Yt2+N/Cz8SXMuqrGZeSPwS2gpJMwdQ=;
 b=FqUF785z9LgtQM98bzmr30aolHTetbnyjqD3H4sHGsUlgiDfPLaxWOFnE6PFQM2VrmsM
 HTvKyFmzeBi3DZO6x/PyKWm3ndITwkSA1vMzmpTHimY1p8K4oSDM6iyiEW5Mp5H7UwwR
 KMGYh9Vh3dFLoTFYx45SBoMDbMF5gITJ8ZqSYXgmSo7K/Hfb9aTk5t5TUwj81ORwjRRN
 zqt8e79MuKkimcOYBrVEcZAcDtKCxhsXI82Ku3diOq4L4kI2wi9IWh9yHNtVPT61fhxe
 Zk9XhVym+gxobUn8P5KYdwW66PEChQQl4wyo4DpdsonYIbdbHe6VWP9o/FrtP388oHIk Kw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cbdrg1a9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 07:16:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jukzx3cRLmbHqn4jJYVjjcRVpOtcgr/aLzhheAtEGpBc5pBS14st8qi1IMEbfEkqgQESshqwgwF7Qgcvepr+fa2312QKu91zo/Nw/pzRfpwH97gg0BF1Iwqkp9o66vOFvLr6mgjChpGiBrT+RAp6L9i3fszWwqKTzOZfOIPWLs8UEKnq/r/2jhw5rPnkCHlYH9zv1isWhrJLEW6za5PpjG1MilDQtARW4JC0RZYxyHE7mtQrTC8WjSYUqic4pOHPwYHqv6PZcPpMeVCFx3vedi807UpQiNiwZ+zZF231uTu3SsU2Q6ChZQ7FCpckmMg81PzD9pNZlxDJhHKHwWIeGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYhs0KX2JV1N9Yt2+N/Cz8SXMuqrGZeSPwS2gpJMwdQ=;
 b=gi736cwhxpUT3EyN/X5zgNCn41nYbyHvzDWD4fISb+X/hRXXiKgEzvXDgeTQ8xZwB8O5LSLTBXYE8C62elbWftEIq3wpEyFVku/DtSJlGwh2zIueOIa2UaoYf5U49Mkh6K1Ppfy0Z6Urf/4peLqtKQgPJ16So3hcjJxNGJrBMF5t6ilPZ5z5LSFi9Ws0CG32RYzKA52S13ESwUOm/UiGP7c3fLUKM2eK0/jQzJ7/nPlZQylRAC4jkCc+BjzhW94XjnC9Or3jbGIVOUnltgyp98v4nK4bnty7MijQh8w39j2wQJOLiOPTPjJEcY2xpwmqcgcs2eSu156JDPE9TculvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH0PR02MB8196.namprd02.prod.outlook.com (2603:10b6:610:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 15:16:34 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52%5]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:16:34 +0000
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
Subject: [PATCH net] net: virtio_net_hdr_to_skb: count transport header in UFO
Date:   Mon, 15 Nov 2021 15:16:17 +0000
Message-Id: <20211115151618.126875-1-jonathan.davies@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::26) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
Received: from nutanix.com (192.146.154.247) by SJ0PR03CA0141.namprd03.prod.outlook.com (2603:10b6:a03:33c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Mon, 15 Nov 2021 15:16:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1527e440-b9e3-4cfb-975c-08d9a84ae946
X-MS-TrafficTypeDiagnostic: CH0PR02MB8196:
X-Microsoft-Antispam-PRVS: <CH0PR02MB8196415ECDBD156266C795D1CB989@CH0PR02MB8196.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Z4mZYcKtKDea2pzyuwPcxFSfRGLQE1pWICYlwnHufzYA0zd5Hv0NeKhC6/6v4Sxgr1U0WB+TbIHpOYl2YJgb4l66tAI6Sv7MBUSC3aFrK6BfpNWsaK6jxVXHVFdGFxmAKbOJ0KJ7ZccpFnTOj7GnG/TngbDU0XscpCIqCkPH4iNVrt5MYqWLcotquX8yPYAasNjufRp//+8cCr2Q3UFrOFMj614M9q23lpNAIbcilBPuomeP6RW6piE5Gl89rNTwnTF8b7ejEQyhajuAP0eDMkXB57buvSf8FpC3vpxxhcI0IpWO9sbeE7lNAWhYoMe9gaq9U6vFwRE9jPHo35w3wMW4iKhSLOlkYUZfLxWHsv+OaK7uyRzLT2NALTobF6So7RFvaX1lR0qFTlOxUTSBjicXlq3q20nXMGu4YYBvfGij10W0dYTiGrOPw6YKVQmpwbWzLuHjpQ5h2L86Ul5PyjsPxFNmh83++xud090gz/tie3isBkt0Q5WiuGoFo0rRxOovLh6KM583IMeEtkgdMO0xymV7hD1+kuSZBNSOP61PC9ChlHwGyyJgUbRw7W5Ey29+nG30X129wjKPxEi5FCFPs1kJLRGmJTWkpwUT16LFVXi74CQgayqgrw9WNHVVWBYi5tZ+aSDjvbF3tcf3JVN9ovKMGMY7UqFmmGA8kWI38u+ReefIp38UsyncHnsN1AJbLDtNYsiGML8ph2GcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(38100700002)(38350700002)(4326008)(316002)(26005)(2616005)(2906002)(5660300002)(8936002)(52116002)(7696005)(956004)(6666004)(36756003)(8676002)(54906003)(1076003)(66476007)(186003)(66556008)(66946007)(508600001)(44832011)(83380400001)(55016002)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTvBzqj6F3GSKAIxQ6xfylnuAOWwaC41IHbeYyKlZkHIVMrQ+rcM//E3EguQ?=
 =?us-ascii?Q?17AGswJZEGJzej5JDk6UkNjxgH7VZIe26KKKrpMXcaLrPrpNYqMSmuuA2A/q?=
 =?us-ascii?Q?VDATEu9YuN6qPxbKmnj4f3ssYXVa7Do05THbEj+PwcWWnVJGyKc+VNwUDulB?=
 =?us-ascii?Q?YG8BPz+0klqPIBp+81FYmcRJaou+MScjpuFI/0VGKSrQqIBO8FCejjH7vng2?=
 =?us-ascii?Q?3maV/ABGxJ/DACZDcBS2CAOTNMIp77XRuDQNqfp6jQFUetfh3WRn+5pHdl3H?=
 =?us-ascii?Q?vwgQrIi2mLZJf5m8Kx41L3fztqQWd10EIhmX4CtZQuej2znTASQOXL+M2r65?=
 =?us-ascii?Q?sUkrX+JBPTSOPSGYdnVJMj1bJtQnRATDrTUclQ+34LWrqmhxiT76M/1VxjIx?=
 =?us-ascii?Q?mo6nBaD8ddHmcoYQJ7ITVY/Q9RQp+RBLhqkxzOFE/7/0yRMBPgCI7BMkbWN/?=
 =?us-ascii?Q?uYevNk531A3kLUl6KwqnVvwhVC7F25k/UKleauu1oA190/diTOxmxa0yzBK2?=
 =?us-ascii?Q?Cdd17JEGB36pOcAKBfmHWzBqROCNiamSmYeWokD7CBuKsdAKKVgj/X2bSIwE?=
 =?us-ascii?Q?l+/g83PFUhIEm2iM7kvjZnxjpddZtfubxmYhqy+LPQfpxr96g2iZtRFhY5cC?=
 =?us-ascii?Q?u2KaBmPqwwFYAVJ/pQCxPJ2DejB9t9Xj+8qpxAbfLR5J2j//E6I5qZqJWlCz?=
 =?us-ascii?Q?+UhpwBk2LH9obDY773WShFKQI9ROvRoKxQiy/Pk+LsZNybyLrr4X21gaCh0+?=
 =?us-ascii?Q?AJi8xWWznigiMP81XFmDbRpKYPgXHb+yOL7XJCsgDrUpns2mU9hjnFtcrcmE?=
 =?us-ascii?Q?ai6ANWV81mCX+GC+N+rzRso8IaMuTyhmi2FbCvQU/nceFsLjIfB9mzb+8BEe?=
 =?us-ascii?Q?T52EJx+YRkOMpAAIAdN/JfEkIofacKjxv4C+xOWiY4XyBPHD9I+FdfGvw8eS?=
 =?us-ascii?Q?aDsaadeQ7atQBEoB3Des5GRGTZ9vq/qnz7EycaxIY3yWsaUsrhYPM0NwXot8?=
 =?us-ascii?Q?0GYXmT+DJft/L9v2FLH6UbuCd5pf125OBwW6vbHfQgFGX0QM1NGkYOjAVf+t?=
 =?us-ascii?Q?qA+kClItwbsnrPGPnQDDvwV9SYztocjruNmJwug/yykcdpitSBczt/TckDJ4?=
 =?us-ascii?Q?S30blNy/r7wdw/pIE98Syc1CMNxtvANUGc19PVkHjJvZkLzxaeX3baAx5DU5?=
 =?us-ascii?Q?RnUK1eBsCJMQtNXS0W6F0+j51hc3GM96i4rOWVWTHXt63KSTNGoT6aftuScc?=
 =?us-ascii?Q?6BwaHUwxKldnE7rmODRf/K9aXqQtWlzyZd9BGUXfTJSPZZHWRNfVHpaLlaat?=
 =?us-ascii?Q?hiiyvkhQa4lqQ8X+RKi9KkZgt8zWuIW4OUcOeSNAjXdw37aA/RzXRDVeSb/F?=
 =?us-ascii?Q?i1O3vVby3kvY00+9Ca+9YoUiJZURdqJ+ZlmTjx/GG/bSV5RGbtstvsER1OK6?=
 =?us-ascii?Q?Rbtm3MHOhgZz7ExYYar41fJmWOw9fY40mLXFArRlBZfwgUfmrX5waLPzT967?=
 =?us-ascii?Q?UVMs881e1snUWF/HXHDN3461k6hoAoZQ7B6LI9lSgooB5ulPwczgp3AOraYY?=
 =?us-ascii?Q?tqwA0x1y7jZQaXDtO1hxYS3wIvK6OzEQTew8Zgdb6HA4yVu0DrDp7nL/Eqko?=
 =?us-ascii?Q?aAYUs/wIfNBZS+OTYSLMJ/ShK5uknN+GDv+VqtEyUrjg/QHBx44fwSgQvoth?=
 =?us-ascii?Q?ipHx+05xjohlpYKoivt8KPCJPFA=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1527e440-b9e3-4cfb-975c-08d9a84ae946
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:16:34.5614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lI50B9vlkMp00sLOZzHXejDG/OsQEyKpiDaH8DCJyLwd8F2NK+UM0/tjZ2NDFWpTle7+itwbo6PC78H1VAqWm1k8DzTBg3KBL50VsbAIPTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8196
X-Proofpoint-GUID: JUobVU0qhuTIUbtkcsCzPZn8CyilNWp_
X-Proofpoint-ORIG-GUID: JUobVU0qhuTIUbtkcsCzPZn8CyilNWp_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
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
 include/linux/virtio_net.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f..bea56af 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -122,8 +122,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* Too small packets are not really GSO ones. */
-		if (skb->len - p_off > gso_size) {
+		/* Too small packets are not really GSO ones.
+		 * UFO may not include transport header in gso_size.
+		 */
+		if (gso_type & SKB_GSO_UDP && skb->len - p_off + thlen > gso_size ||
+		    skb->len - p_off > gso_size) {
 			shinfo->gso_size = gso_size;
 			shinfo->gso_type = gso_type;
 
-- 
2.9.3

