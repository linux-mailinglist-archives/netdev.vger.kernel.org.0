Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEBA4BF6F1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiBVLIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiBVLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:08:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE565B54EC;
        Tue, 22 Feb 2022 03:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSxq21kr56ymOTjD3OZrspOc8Tu5eUsnN+dC3yfym2t7sAifTORpnfD8xdnaPfJvMIV5/EjSgWN+AeROnRI1wdXZaJnkAU+7lX1iahTkA+Ngv33Mec32WmqVbw9xkc/gYxH6Pc17NQy0zb3BlkCMFAZVlWDnQXKTtgQH/cF2QTuzGbOHP9ezd1vwMOJS4vn2gfOHdF4J7aGfL0CWMtCQV7V2Qs4qNv6ISYd4IARaEJWJ1PocWjIYjT6u11Uj1cNHNl66DtMAAsOkKxEZbwr+40bf3/yJ03NPubi6KmJvI+Zp4x5+CFp7033b5V1Zgg1+0P22/fTR4gcKi+w+2sdbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOMFDq4QE6VORqebDv2FV/10xjOx8JvCW+nDUBQjRz4=;
 b=lQ3zoPNh0nTTE3W9lVV2uKH5wqUBljCVV8O7phnDC2fjpSx6gOlHIYNhBvy3jZWhe5EiwqVs09b3DUrq8RYJr1dkAdAxz0rYZJ2Bg778WnXRKv1hI1zaUL6onD9xyVaOVz3Mx55Uv9cTzRoHAAHopsSAhsK4j8zl80/s7CaTOqgsHvOd4QQLBUNndwigEM/ejoEbtPz4eQrofyE2fc0hLi0+Js1EqfkqjXwc7oxt+WsGbrMJDIU1qgNH/9pA9RQLBZ7B+3KsIypcqJg3QDhK9VNXErj3ry/8L1KizdL25xAqaYDFwZyqJnhpYRt8ISH5qb9tEXiiDgr+ed1djbz8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOMFDq4QE6VORqebDv2FV/10xjOx8JvCW+nDUBQjRz4=;
 b=uSF332aLGdvPHKxM5/VATROGm1bdy9DxHHoqvAGwGUyUEt0Tng9AeC7yNGkMSYxGmk+Kg6NxfH2yRQHZp/YftRi5vhPER/R311e9s/vsQJ4wctvEzZgSc3ZPUehm0OO/L/U85+vNKcSFRxL15h3RA+wcqawipY7QRqY/lr49xqV/LfQJ6faH3yJPSlNY+WlmffSlsj98ev5nhem/JBPbkCQ56+JkRdXXCf5xLmuM9+62En10jgZpW0MlVZ5EC+pTjmJFCghzr5uBVfpJxQMUJTtEU4QSQQ04V2E48EjXXoviEJ/B1GXYqH8qqNA6DIIsq3iLJv8oldYiDGYFz7VXrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Tue, 22 Feb
 2022 11:07:37 +0000
Received: from MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a]) by MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a%11]) with mapi id 15.20.4995.027; Tue, 22 Feb
 2022 11:07:37 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 1/4] net netlink: Introduce NLA_BITFIELD type
Date:   Tue, 22 Feb 2022 12:58:09 +0200
Message-Id: <20220222105812.18668-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220222105812.18668-1-shayd@nvidia.com>
References: <20220222105812.18668-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0201CA0002.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::12) To MWHPR12MB1310.namprd12.prod.outlook.com
 (2603:10b6:300:a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffb0d4c1-9d0c-46fb-c2ee-08d9f5f388cb
X-MS-TrafficTypeDiagnostic: MW5PR12MB5683:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB568395E8DC0E75C34A427E18CF3B9@MW5PR12MB5683.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ct7omhR6+XdoQZTmBJCRj96sP34W5DdU3tMDVwr5D+ACx6+xoU5BziEh9pRf9EJTNczxlKctKawkRgyHFYCG9BFdE+u4tNi/J0GORynB7ewOxrN6ovzvbi06KLT0qqoH0djsRrpp6jOLaPFZhGj6VF4WZfWerYq984mcw/wNXYVS2uPz2nKsaKPnbsAPEv4MxoXAM2HX1mQSHU4jvAbeax0pCrxxY5Lj8wjuMSRFL+rjTLmW16swHNyK75QP+b3m0jOxurPyFAES6OqgC8v+JqgKGPel5brf6KteEcmuDp1F/sAti/kvmuvVpYmSnqpx8wG6dVt/OJJ6tyy43J5i+5klwMLK6RNpmL+fq1V+9AHAaFTlL/FDRFGvYWy2R27863eCNEcMnnFhmLEUdgIAmGp8Lfo1+9SMMjiYLdf3WJU1O//eEWxkxaEVbWEKo06QYgVztn1JbOy7d1ULa5MHg398JiwjCiLvyhZUa2RLYLrl0gXyjWOgLAuhVRtXK6r/OThIIW9DotercDrUrBvQldDyamVsNaPJ4cH/ef3YUbBqlSoDqN14NmdV/7OeMrFG3dHnM4nGCMuSOwKI+b2AgAq6yzWdWyWfudQDFyZDvh6lYTvWW1UnLqy3fqARWu7IyAUaDVZGEH80RlLBR2u4b9dXNAMMIAppBP4uaOCQjvp111ftrBj8bs7C7FfttPskGuxNF1cuqvQOy6ppw1tEwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(2616005)(1076003)(26005)(38350700002)(508600001)(8936002)(38100700002)(2906002)(36756003)(107886003)(86362001)(52116002)(4326008)(6486002)(66556008)(66476007)(5660300002)(30864003)(6666004)(54906003)(8676002)(316002)(66946007)(110136005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GtPE+L8jAqA5hHygU01CaJNFlWCVvXYTCQfwTIz1moGwtXE/h1eW/pGqTSUt?=
 =?us-ascii?Q?8/rdL0mZjjBiofcrHxd+upnB3RJeW4cJ0XjYVZ3Y6IBU8WFW23KncZm5Yrqb?=
 =?us-ascii?Q?+zXqMuAaWiLDwAxRIZD3l5r/H9NGmLrABnpRNu+x+GKQo/Im1Tu4lqFQyRtT?=
 =?us-ascii?Q?nYGR1BXj36hRSDrzGbDSU3k2BwBD7mzEBwEH1LEme/0dUBDgmaEkTd1WSQqD?=
 =?us-ascii?Q?YJuD++iEOJvtvByOEaF0BnBMkMK6Tq4CZSIyaNDrbtSr0tcUhZnV6vjonbe0?=
 =?us-ascii?Q?r+QC/Uu44tuTO45B+evcJCE/VOH7O+DhrZPWqOsqy4FSwj3L1MBUHYceo+s8?=
 =?us-ascii?Q?x4WlFN5gP0Qml2f8BPFMHpHYFKYVxF7X+Y6K3pSl+b0UhhkPU1j/noZEmzU3?=
 =?us-ascii?Q?I/svSAC4waqnokusY/0XuVCRAtd2u8W6dHAcYeybWwqvCHw0uaduVA6tR8WV?=
 =?us-ascii?Q?wTJsnvmc6D49XMf9neRA4vw9WGpmhfLfxTkE8k+FgQz94FYc+ZaymzwglERf?=
 =?us-ascii?Q?aGGlVkmn0OcTSOB/2EWV7gr5Wj4hI1kLcke2kRZFB8YKuDwLeIOdyw8SBZBa?=
 =?us-ascii?Q?yKYXPiTHpTywuJXfZ6n9dUH3EbN2UMxIyx07CkNzsR1fQFref7jXDnamwiaG?=
 =?us-ascii?Q?Gj4YS55oPIXf5gNhq5kv3a4eYZvaJpsm5YjP4dCrB8ogL626RZ9BKqFpyyS5?=
 =?us-ascii?Q?hzwNwXwAwT6hBl6C5rY+F1m7SrkxI2RVMba896soccKthIxMLMJwsguSZu83?=
 =?us-ascii?Q?AXPIYfwVPcKtEPTWgSaJ1SA7lzuSOLe646XV23Keu1pLZapxQmN6h4khijQ0?=
 =?us-ascii?Q?RqYKuXVxKLlcDq2IDmQ4wTAuSixJsRQOrwVWJ+JRINAA5VZdwCFMFg/ZxB1m?=
 =?us-ascii?Q?xIFTvn6S4kuEyQOkZ8NGjquem/FtDkmawOxdijpjDbecnDVQz/OjfGzZuHoy?=
 =?us-ascii?Q?JZiPThDEKB5bCNph/wbhJjZC0G9ybrSBN1zI1SKkfbOziXnxzNvb40gXSXzm?=
 =?us-ascii?Q?hMZ3aVnayEDXCBGoTPgTkdgXNsR+/5qnjCBUyMWKwYdTXjRSvm38FmszTdPz?=
 =?us-ascii?Q?L02Sye2+JjYemhy4+XKpg3OCNJx04hcDRyvoAr2Ban8P2QXR7kE8avB+87Iw?=
 =?us-ascii?Q?5QVI8qNhz4aNu1UEwOksn+z/iH0LaBttxRT+gJprAcLBTpjts5JkS6siQZyn?=
 =?us-ascii?Q?7TYg96M8r33cPby8NteXmrhbrzMwbjFNejCam5KXyfPA7fxGg8k9TyYUuSHv?=
 =?us-ascii?Q?/E5W8PBhscXyaymr7VV2MDZrRnCMQswnZgsUBnOZhNvov56HwWNVzUoL+R6B?=
 =?us-ascii?Q?46cBV67mQghEvq/CQqvFHezX8q6CA3cfnL7+iFH4SV9XgMdVHAyiWm55sKvS?=
 =?us-ascii?Q?OPYRN9x9gKene9jNMZTl1IMW1036z9TZsSk1dT/9yhpF1MAhUYRWU8HE6KDG?=
 =?us-ascii?Q?cHtFVD13GQ8gqoozWome2YRek7wcbVwYKZDNTR+DX8b9hNZhJ4AamtguP/aF?=
 =?us-ascii?Q?+QIhyJKnHevoAjxn2SCU6Y09DWtrr3PsEgQxa65BZGPQu1oe1y7kcL+ETslV?=
 =?us-ascii?Q?SIpSGsnHPXP60vIN4lTU/01Y9uaRfe8seh5nbhQ8bn3Wxwz67Tm9MwbSNfHd?=
 =?us-ascii?Q?4uohr4nYDWp2H5rC1KONfJs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb0d4c1-9d0c-46fb-c2ee-08d9f5f388cb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:07:37.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnTD+cyFjugRa777PP/aAKX98xGzZJTn6dRwzZROrO6oKFsJkyK3P/yjolL6J+c0+HhOkiFBskWchDR9yts/zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generic bitfield attribute content sent to the kernel by user.
With this netlink attr type the user can either set or unset a
bitmap in the kernel.

This attribute is an extension (dynamic array) of NLA_BITFIELD32,
and have similar checks and policies.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/net/netlink.h        |  30 ++++++++
 include/uapi/linux/netlink.h |  10 +++
 lib/nlattr.c                 | 145 ++++++++++++++++++++++++++++++++++-
 net/netlink/policy.c         |   4 +
 4 files changed, 185 insertions(+), 4 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7a2a9d3144ba..52a0bcccae36 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -180,6 +180,7 @@ enum {
 	NLA_S32,
 	NLA_S64,
 	NLA_BITFIELD32,
+	NLA_BITFIELD,
 	NLA_REJECT,
 	__NLA_TYPE_MAX,
 };
@@ -235,12 +236,16 @@ enum nla_policy_validation {
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
+ *    NLA_BITFIELD         Maximum length of attribute payload
  *    NLA_REJECT           Unused
  *    All other            Minimum length of attribute payload
  *
  * Meaning of validation union:
  *    NLA_BITFIELD32       This is a 32-bit bitmap/bitselector attribute and
  *                         `bitfield32_valid' is the u32 value of valid flags
+ *    NLA_BITFIELD         This is a dynamic array of 32-bit bitmap/bitselector
+ *                         attribute and `arr_bitfield32_valid' is the u32
+ *                         values array of valid flags.
  *    NLA_REJECT           This attribute is always rejected and `reject_message'
  *                         may point to a string to report as the error instead
  *                         of the generic one in extended ACK.
@@ -318,6 +323,7 @@ struct nla_policy {
 	u16		len;
 	union {
 		const u32 bitfield32_valid;
+		const u32 *arr_bitfield32_valid;
 		const u32 mask;
 		const char *reject_message;
 		const struct nla_policy *nested_policy;
@@ -363,6 +369,8 @@ struct nla_policy {
 	_NLA_POLICY_NESTED_ARRAY(ARRAY_SIZE(policy) - 1, policy)
 #define NLA_POLICY_BITFIELD32(valid) \
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
+#define NLA_POLICY_BITFIELD(valid, size) \
+	{ .type = NLA_BITFIELD, .arr_bitfield32_valid = valid, .len = size }
 
 #define __NLA_IS_UINT_TYPE(tp)						\
 	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 || tp == NLA_U64)
@@ -1545,6 +1553,19 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
 	return nla_put(skb, attrtype, sizeof(tmp), &tmp);
 }
 
+/**
+ * nla_put_bitfield - Add a bitfield netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @bitfield: bitfield
+ */
+static inline int nla_put_bitfield(struct sk_buff *skb, int attrtype,
+				   const struct nla_bitfield *bitfield)
+{
+	return nla_put(skb, attrtype, bitfield->size * sizeof(struct nla_bitfield32)
+		       + sizeof(*bitfield), bitfield);
+}
+
 /**
  * nla_get_u32 - return payload of u32 attribute
  * @nla: u32 netlink attribute
@@ -1738,6 +1759,15 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
 	return tmp;
 }
 
+struct nla_bitfield *nla_bitfield_alloc(__u64 nbits);
+void nla_bitfield_free(struct nla_bitfield *bitfield);
+void nla_bitfield_to_bitmap(unsigned long *bitmap,
+			    struct nla_bitfield *bitfield);
+void nla_bitfield_from_bitmap(struct nla_bitfield *bitfield,
+			      unsigned long *bitmap, __u64 bitmap_nbits);
+bool nla_bitfield_len_is_valid(struct nla_bitfield *bitfield, size_t user_len);
+bool nla_bitfield_nbits_valid(struct nla_bitfield *bitfield, size_t nbits);
+
 /**
  * nla_memdup - duplicate attribute memory (kmemdup)
  * @src: netlink attribute to duplicate from
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 4c0cde075c27..a11bb91e3386 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -252,6 +252,14 @@ struct nla_bitfield32 {
 	__u32 selector;
 };
 
+/* Generic bitmap attribute content sent to the kernel.
+ * The size is the number of elements in the array.
+ */
+struct nla_bitfield {
+	__u64 size;
+	struct nla_bitfield32 data[0];
+};
+
 /*
  * policy descriptions - it's specific to each family how this is used
  * Normally, it should be retrieved via a dump inside another attribute
@@ -283,6 +291,7 @@ struct nla_bitfield32 {
  *	entry has attributes again, the policy for those inner ones
  *	and the corresponding maxtype may be specified.
  * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ * @NL_ATTR_TYPE_BITFIELD: &struct nla_bitfield attribute
  */
 enum netlink_attribute_type {
 	NL_ATTR_TYPE_INVALID,
@@ -307,6 +316,7 @@ enum netlink_attribute_type {
 	NL_ATTR_TYPE_NESTED_ARRAY,
 
 	NL_ATTR_TYPE_BITFIELD32,
+	NL_ATTR_TYPE_BITFIELD,
 };
 
 /**
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 86029ad5ead4..6d20bf38850b 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -58,11 +58,9 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 				struct netlink_ext_ack *extack,
 				struct nlattr **tb, unsigned int depth);
 
-static int validate_nla_bitfield32(const struct nlattr *nla,
-				   const u32 valid_flags_mask)
+static int validate_bitfield32(const struct nla_bitfield32 *bf,
+			       const u32 valid_flags_mask)
 {
-	const struct nla_bitfield32 *bf = nla_data(nla);
-
 	if (!valid_flags_mask)
 		return -EINVAL;
 
@@ -81,6 +79,33 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 	return 0;
 }
 
+static int validate_nla_bitfield32(const struct nlattr *nla,
+				   const u32 valid_flags_mask)
+{
+	const struct nla_bitfield32 *bf = nla_data(nla);
+
+	return validate_bitfield32(bf, valid_flags_mask);
+}
+
+static int validate_nla_bitfield(const struct nlattr *nla,
+				 const u32 *valid_flags_masks,
+				 const u16 nbits)
+{
+	struct nla_bitfield *bf = nla_data(nla);
+	int err;
+	int i;
+
+	if (!nla_bitfield_len_is_valid(bf, nla_len(nla)) ||
+	    !nla_bitfield_nbits_valid(bf, nbits))
+		return -EINVAL;
+	for (i = 0; i < bf->size; i++) {
+		err = validate_bitfield32(&bf->data[i], valid_flags_masks[i]);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			      const struct nla_policy *policy,
 			      struct netlink_ext_ack *extack,
@@ -422,6 +447,12 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 		break;
 
+	case NLA_BITFIELD:
+		err = validate_nla_bitfield(nla, pt->arr_bitfield32_valid, pt->len);
+		if (err)
+			goto out_err;
+		break;
+
 	case NLA_NUL_STRING:
 		if (pt->len)
 			minlen = min_t(int, attrlen, pt->len + 1);
@@ -839,6 +870,112 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
 }
 EXPORT_SYMBOL(nla_strcmp);
 
+/**
+ * nla_bitfield_alloc - Alloc struct nla_bitfield
+ * @nbits: number of bits to accommodate
+ */
+struct nla_bitfield *nla_bitfield_alloc(__u64 nbits)
+{
+	struct nla_bitfield *bitfield;
+	size_t bitfield_size;
+	size_t bitfield_len;
+
+	bitfield_len = DIV_ROUND_UP(nbits, BITS_PER_TYPE(u32));
+	bitfield_size = bitfield_len * sizeof(struct nla_bitfield32) +
+		sizeof(*bitfield);
+	bitfield = kzalloc(bitfield_size, GFP_KERNEL);
+	if (bitfield)
+		bitfield->size = bitfield_len;
+	return bitfield;
+}
+EXPORT_SYMBOL(nla_bitfield_alloc);
+
+/**
+ * nla_bitfield_free - Free struct nla_bitfield
+ * @bitfield: the bitfield to free
+ */
+void nla_bitfield_free(struct nla_bitfield *bitfield)
+{
+	kfree(bitfield);
+}
+EXPORT_SYMBOL(nla_bitfield_free);
+
+/**
+ * nla_bitfield_to_bitmap - Convert bitfield to bitmap
+ * @bitmap: bitmap to copy to (dst)
+ * @bitfield: bitfield to be copied (src)
+ */
+void nla_bitfield_to_bitmap(unsigned long *bitmap,
+			    struct nla_bitfield *bitfield)
+{
+	int i, j;
+	u32 tmp;
+
+	for (i = 0; i < bitfield->size; i++) {
+		tmp = bitfield->data[i].value & bitfield->data[i].selector;
+		for (j = 0; j < BITS_PER_TYPE(u32); j++)
+			if (tmp & (1 << j))
+				set_bit(j + i * BITS_PER_TYPE(u32), bitmap);
+	}
+}
+EXPORT_SYMBOL(nla_bitfield_to_bitmap);
+
+/**
+ * nla_bitfield_from_bitmap - Convert bitmap to bitfield
+ * @bitfield: bitfield to copy to (dst)
+ * @bitmap: bitmap to be copied (src)
+ * @bitmap_nbits: len of bitmap
+ */
+void nla_bitfield_from_bitmap(struct nla_bitfield *bitfield,
+			      unsigned long *bitmap, __u64 bitmap_nbits)
+{
+	long size;
+	int i, j;
+
+	size = DIV_ROUND_UP(bitmap_nbits, BITS_PER_TYPE(u32));
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < min_t(__u64, bitmap_nbits, BITS_PER_TYPE(u32)); j++)
+			if (test_bit(j + i * BITS_PER_TYPE(u32), bitmap))
+				bitfield->data[i].value |= 1 << j;
+		bitfield->data[i].selector = bitmap_nbits >= BITS_PER_TYPE(u32) ?
+			UINT_MAX : (1 << bitmap_nbits) - 1;
+		bitmap_nbits -= BITS_PER_TYPE(u32);
+	}
+}
+EXPORT_SYMBOL(nla_bitfield_from_bitmap);
+
+/**
+ * nla_bitfield_len_is_valid - validate the len of the bitfield
+ * @bitfield: bitfield to validate
+ * @user_len: len of the nla.
+ */
+bool nla_bitfield_len_is_valid(struct nla_bitfield *bitfield, size_t user_len)
+{
+	return !(user_len % sizeof(bitfield->data[0]) ||
+		 sizeof(bitfield->data[0]) * bitfield->size +
+		 sizeof(*bitfield) != user_len);
+}
+EXPORT_SYMBOL(nla_bitfield_len_is_valid);
+
+/**
+ * nla_bitfield_nbits_valid - validate the len of the bitfield vs a given nbits
+ * @bitfield: bitfield to validate
+ * @nbits: number of bits the user wants to use.
+ */
+bool nla_bitfield_nbits_valid(struct nla_bitfield *bitfield, size_t nbits)
+{
+	u32 *last_value = &bitfield->data[bitfield->size - 1].value;
+	u32 last_bit;
+
+	if (BITS_PER_TYPE(u32) * (bitfield->size - 1) > nbits)
+		return false;
+
+	nbits -= BITS_PER_TYPE(u32) * (bitfield->size - 1);
+	last_bit = find_last_bit((unsigned long *)last_value, BITS_PER_TYPE(u32));
+	return last_bit == BITS_PER_TYPE(u32) ? true : last_bit <= nbits - 1;
+}
+EXPORT_SYMBOL(nla_bitfield_nbits_valid);
+
 #ifdef CONFIG_NET
 /**
  * __nla_reserve - reserve room for attribute on the skb
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 8d7c900e27f4..c9fffb3b8045 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -227,6 +227,7 @@ int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
+	case NLA_BITFIELD:
 		/* maximum is common, u32 min-length/max-length */
 		return common + 2 * nla_attr_size(sizeof(u32));
 	case NLA_FLAG:
@@ -338,11 +339,14 @@ __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 		break;
 	case NLA_STRING:
 	case NLA_NUL_STRING:
+	case NLA_BITFIELD:
 	case NLA_BINARY:
 		if (pt->type == NLA_STRING)
 			type = NL_ATTR_TYPE_STRING;
 		else if (pt->type == NLA_NUL_STRING)
 			type = NL_ATTR_TYPE_NUL_STRING;
+		else if (pt->type == NLA_BITFIELD)
+			type = NL_ATTR_TYPE_BITFIELD;
 		else
 			type = NL_ATTR_TYPE_BINARY;
 
-- 
2.21.3

