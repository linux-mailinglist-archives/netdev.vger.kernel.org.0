Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABE62FF623
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbhAUUmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:42:02 -0500
Received: from mail-eopbgr80094.outbound.protection.outlook.com ([40.107.8.94]:39028
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbhAUUl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:41:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNPu0LF2fIObruj1wVaGS1lk/YASGeKmpcT7CQBoJevwrPTmMW6uTdYxRC6zGoIj1Q0czXwEpeSijKaXa9b6EEeET4ATi8vHuQvFArevJOZCRtZ3Twveg7s6TvGumk5kMxw8QsYxLxBIQkuay5WLXNCzBVW5REz6SU6Hwtk0l9Igl/mmXHvNyyxqYAm1l3f8PmnV35WXMuHnT9597vvdbGMdnM79meDbclZdv/VBBkd1eTaBrMCC6Qq+Fcxc90LXWxtDMc0rZrDhFqdr/2kaTzk1953cm76bkIuruz2WHgnpYF1UJONZCJvevXhydcsRYEimlmPGpArRuDKojW76UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhgZT6QYTvk92IBF2mM2SkPFSXetXZtfY7F6+o4+8CU=;
 b=jcEK1fy9bzG9wLrseeGTB1XeprMxQInRNLmAVTHEjV2/Yoyn8My2ZgHV20jNg9odg2R75iYAhweA0alW/MI3elOOMF0m3dAP3WlERAIn/O2AT5cE12u2fjQYhdI8jNqabD/6TGUM68Ao/EKIJbjwraUcgyZlfGRfz+yAjtI7xs+vAXeKRqCEt6jxBQmG/FX5GSvJKmnMLLvsK4+YwBSfDmT+x0TnMAM4ve2Th2pipO6HwrEu1i83/fTFB+BitIxcsd7G+l+FkiH26JGUWNMiVy9SAOrP6Z3XHfAUR0z4HwzKNXgFD0HBCZV7xks89g1faUrCS8swP7WjvyuUJvNpoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhgZT6QYTvk92IBF2mM2SkPFSXetXZtfY7F6+o4+8CU=;
 b=OWyNUCIlVf73SfrHinnti5o79m2XM2T8srFQs9E+ix7rGCqCN5jtlmFwy4NRXqv+AaIxLC1j0yrzQW03+ggwpJ4k8AqQtAalFLLE/pzBZ0RMFFG8A1H/OH+zRS0Ilyxm4EaYSY6ujaDmOO40JuskZjwSiHUnydWVehQfpO097V0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Thu, 21 Jan
 2021 20:40:49 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 20:40:49 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 2/2] net: mrp: move struct definitions out of uapi
Date:   Thu, 21 Jan 2021 21:40:37 +0100
Message-Id: <20210121204037.61390-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
References: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::24) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P195CA0047.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 20:40:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da5ab660-0a8b-4d79-2b39-08d8be4cd5ba
X-MS-TrafficTypeDiagnostic: AM0PR10MB3011:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB301139A8669D30F01DB40E1693A10@AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVHu0Tw8gzsdusP1DC4zUABs73mwpPcMzd1vRJxGg2VJeg4bsadCLmSNVOV0a4TFMiy1kVYxs7xpa8ubG9p6cM+P386ssGcX+Wdw2Ryvr25nclipk854A0M7VZslo0j52jCFHGotIX4upBF1BRhafSCJPOpC3wv6RyvZuKH8LDVJnFWnJQNP13gSNgWCwEycSQ/SqHE5wUZIiUgvT18W4IzJuch9fOBVN2EIY00QlW4WXyEMt0F37BH/z689KkqL5aem5orPY/NE8EODOiSu5S9S6aJhBYDlnJiKI54lDY+Hr/I5gZfEdtA0lNlH7zW7b4ItVIBhVcEzN/hTlbWstpSifajv5ccr8YO76OaU6lyQPLSXA74DGpIoDeajb50UkMae4PZBL4o9PZv4U/Gt2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39830400003)(346002)(478600001)(2616005)(52116002)(107886003)(6506007)(5660300002)(6486002)(6666004)(44832011)(26005)(1076003)(86362001)(83380400001)(4326008)(186003)(316002)(66556008)(8936002)(6916009)(8676002)(66476007)(956004)(8976002)(6512007)(36756003)(66946007)(16526019)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Nv8vsdlh+zbH//88zanJQ8BEdeGq3+jeEHlsav34DzcNyDXUBcTh0dFt2aSF?=
 =?us-ascii?Q?0ZzdWoNoxhXQSYYW2PfX7MUgMMxX+f9B/Thiq1bo4Ue0FRFImmzPGe8nGDVJ?=
 =?us-ascii?Q?d8cqEJHG3ihg50qq05/47gxXUg/Za8+k+arypCdBYsfpeFmuEB0vDa+kTprM?=
 =?us-ascii?Q?l7fZosL0Z9IiMb5hsgqp2TF56gwaA9WiaL4e6onjRg6S5CmbnacxZkIgaqr0?=
 =?us-ascii?Q?xTEL6tkVtaeTU4afbJB9kgTlSUMBXLJ0pnIM3SedzDEcugXcBesaKPcVg67X?=
 =?us-ascii?Q?7BYD10YIkFT3RoTkFVj2jboHEfEso6TobTSy/UD4DMpEXDcq3Vd7PgAilocP?=
 =?us-ascii?Q?pwGw689ri8C7JhN+1+xQ011k7rL28LsGTfthgmOJupDossS2iFVDgVWMhoqM?=
 =?us-ascii?Q?j35/D6Q7aPejRFDvb88hsdcmXUlzehcTQHgIxyZfaynxg0K5kuW4KXuwEVDh?=
 =?us-ascii?Q?pxqAGdz07Pg4r1mLv/B/DWS3Jxq9OopxV1gnAf5pvc2OVsEqQwCT4s4uyNy6?=
 =?us-ascii?Q?sUluGVnGch1c9UW9IWb7+zU+kMWCWxbOyNtVzJL2XWDnLWyl7KbFIxcdG8XU?=
 =?us-ascii?Q?Vi+ceG77IUUTYqe26eEzWrpUV0Blbd0qn41VeAoO/1A1sye80cog42VVRjVW?=
 =?us-ascii?Q?OfPeQ7xsRq7+ozadcRMuUK861kIrR43klc1NvSNb+osexFFnbpIQB2hKmVGh?=
 =?us-ascii?Q?atwk824HlM+qm6Sm1GR2iUq5fDYg4VziHHgjayc5GU5nZgG2tTAvNtbLVAOW?=
 =?us-ascii?Q?CGHV+B7kD3CvJUUwdCeUtMBm86JBTzhsmGhgketZq9R9xKtPJOe71r2ww3Eq?=
 =?us-ascii?Q?Q81foQ5/LI9VYlSLCj6F2zhf1HvwxNH0XL6/JJuO6NLxsaYrR6FIdlkGtNwf?=
 =?us-ascii?Q?v/jMJZ5+HdHAW5AfS+xCqRTsWr+q+tJQd6MY5v5yzJLZMyAl+1/vZA/KaQRx?=
 =?us-ascii?Q?AsKSLF/p2LY0pDnbxs5zwqfDBis3mQkGJvQaQ1JfyPwENka3A3lBVwvaBHlX?=
 =?us-ascii?Q?GkKX?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: da5ab660-0a8b-4d79-2b39-08d8be4cd5ba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 20:40:49.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWNlYxK/A9ifOsBguORqyPXJbcuiIR7Voo1FgISYdhi3Cka1XHIQJ/OJ3PY+bNIeCz+Msz83FEeaC8qsARv6sDV8bTHFygZki1wUoUzEf9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of these are actually used in the kernel/userspace interface -
there's a userspace component of implementing MRP, and userspace will
need to construct certain frames to put on the wire, but there's no
reason the kernel should provide the relevant definitions in a UAPI
header.

In fact, most of these structs are unused in the kernel, so only keep
the few that are actually referenced in the kernel code, and move them
to the br_private_mrp.h header.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 include/uapi/linux/mrp_bridge.h | 86 ---------------------------------
 net/bridge/br_private_mrp.h     | 29 +++++++++++
 2 files changed, 29 insertions(+), 86 deletions(-)

diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index d1d0cf65916d..f090acd4f6c4 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -70,90 +70,4 @@ enum br_mrp_sub_tlv_header_type {
 	BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR = 0x3,
 };
 
-struct br_mrp_tlv_hdr {
-	__u8 type;
-	__u8 length;
-};
-
-struct br_mrp_sub_tlv_hdr {
-	__u8 type;
-	__u8 length;
-};
-
-struct br_mrp_end_hdr {
-	struct br_mrp_tlv_hdr hdr;
-};
-
-struct br_mrp_common_hdr {
-	__be16 seq_id;
-	__u8 domain[MRP_DOMAIN_UUID_LENGTH];
-};
-
-struct br_mrp_ring_test_hdr {
-	__be16 prio;
-	__u8 sa[ETH_ALEN];
-	__be16 port_role;
-	__be16 state;
-	__be16 transitions;
-	__be32 timestamp;
-} __attribute__((__packed__));
-
-struct br_mrp_ring_topo_hdr {
-	__be16 prio;
-	__u8 sa[ETH_ALEN];
-	__be16 interval;
-};
-
-struct br_mrp_ring_link_hdr {
-	__u8 sa[ETH_ALEN];
-	__be16 port_role;
-	__be16 interval;
-	__be16 blocked;
-};
-
-struct br_mrp_sub_opt_hdr {
-	__u8 type;
-	__u8 manufacture_data[MRP_MANUFACTURE_DATA_LENGTH];
-};
-
-struct br_mrp_test_mgr_nack_hdr {
-	__be16 prio;
-	__u8 sa[ETH_ALEN];
-	__be16 other_prio;
-	__u8 other_sa[ETH_ALEN];
-};
-
-struct br_mrp_test_prop_hdr {
-	__be16 prio;
-	__u8 sa[ETH_ALEN];
-	__be16 other_prio;
-	__u8 other_sa[ETH_ALEN];
-};
-
-struct br_mrp_oui_hdr {
-	__u8 oui[MRP_OUI_LENGTH];
-};
-
-struct br_mrp_in_test_hdr {
-	__be16 id;
-	__u8 sa[ETH_ALEN];
-	__be16 port_role;
-	__be16 state;
-	__be16 transitions;
-	__be32 timestamp;
-} __attribute__((__packed__));
-
-struct br_mrp_in_topo_hdr {
-	__u8 sa[ETH_ALEN];
-	__be16 id;
-	__be16 interval;
-};
-
-struct br_mrp_in_link_hdr {
-	__u8 sa[ETH_ALEN];
-	__be16 port_role;
-	__be16 id;
-	__be16 interval;
-};
-
 #endif
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index af0e9eff6549..3f80a0a79a32 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -88,4 +88,33 @@ int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
 int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
 int br_mrp_in_port_open(struct net_device *dev, u8 loc);
 
+/* MRP protocol data units */
+struct br_mrp_tlv_hdr {
+	__u8 type;
+	__u8 length;
+};
+
+struct br_mrp_common_hdr {
+	__be16 seq_id;
+	__u8 domain[MRP_DOMAIN_UUID_LENGTH];
+};
+
+struct br_mrp_ring_test_hdr {
+	__be16 prio;
+	__u8 sa[ETH_ALEN];
+	__be16 port_role;
+	__be16 state;
+	__be16 transitions;
+	__be32 timestamp;
+} __attribute__((__packed__));
+
+struct br_mrp_in_test_hdr {
+	__be16 id;
+	__u8 sa[ETH_ALEN];
+	__be16 port_role;
+	__be16 state;
+	__be16 transitions;
+	__be32 timestamp;
+} __attribute__((__packed__));
+
 #endif /* _BR_PRIVATE_MRP_H */
-- 
2.23.0

