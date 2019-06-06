Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00B336E6F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfFFIWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:22:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41892 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727238AbfFFIWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A73CD17A3AE11E0D17AC;
        Thu,  6 Jun 2019 16:22:43 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: small changes for magic numbers
Date:   Thu, 6 Jun 2019 16:21:03 +0800
Message-ID: <1559809267-53805-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
References: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

In order to improve readability, this patch uses macros to
replace some magic numbers, and adds some comments for some
others.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 118 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  24 +++--
 2 files changed, 79 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9fe00a8..36a92a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4490,19 +4490,19 @@ static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 	case 0:
 		return false;
 	case BIT(INNER_DST_MAC):
-		for (i = 0; i < 6; i++) {
-			calc_x(key_x[5 - i], rule->tuples.dst_mac[i],
+		for (i = 0; i < ETH_ALEN; i++) {
+			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.dst_mac[i],
 			       rule->tuples_mask.dst_mac[i]);
-			calc_y(key_y[5 - i], rule->tuples.dst_mac[i],
+			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.dst_mac[i],
 			       rule->tuples_mask.dst_mac[i]);
 		}
 
 		return true;
 	case BIT(INNER_SRC_MAC):
-		for (i = 0; i < 6; i++) {
-			calc_x(key_x[5 - i], rule->tuples.src_mac[i],
+		for (i = 0; i < ETH_ALEN; i++) {
+			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
 			       rule->tuples.src_mac[i]);
-			calc_y(key_y[5 - i], rule->tuples.src_mac[i],
+			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
 			       rule->tuples.src_mac[i]);
 		}
 
@@ -4538,19 +4538,19 @@ static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 
 		return true;
 	case BIT(INNER_SRC_IP):
-		calc_x(tmp_x_l, rule->tuples.src_ip[3],
-		       rule->tuples_mask.src_ip[3]);
-		calc_y(tmp_y_l, rule->tuples.src_ip[3],
-		       rule->tuples_mask.src_ip[3]);
+		calc_x(tmp_x_l, rule->tuples.src_ip[IPV4_INDEX],
+		       rule->tuples_mask.src_ip[IPV4_INDEX]);
+		calc_y(tmp_y_l, rule->tuples.src_ip[IPV4_INDEX],
+		       rule->tuples_mask.src_ip[IPV4_INDEX]);
 		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
 		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
 
 		return true;
 	case BIT(INNER_DST_IP):
-		calc_x(tmp_x_l, rule->tuples.dst_ip[3],
-		       rule->tuples_mask.dst_ip[3]);
-		calc_y(tmp_y_l, rule->tuples.dst_ip[3],
-		       rule->tuples_mask.dst_ip[3]);
+		calc_x(tmp_x_l, rule->tuples.dst_ip[IPV4_INDEX],
+		       rule->tuples_mask.dst_ip[IPV4_INDEX]);
+		calc_y(tmp_y_l, rule->tuples.dst_ip[IPV4_INDEX],
+		       rule->tuples_mask.dst_ip[IPV4_INDEX]);
 		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
 		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
 
@@ -4799,6 +4799,7 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 		*unused |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
 			BIT(INNER_IP_TOS);
 
+		/* check whether src/dst ip address used */
 		if (!tcp_ip6_spec->ip6src[0] && !tcp_ip6_spec->ip6src[1] &&
 		    !tcp_ip6_spec->ip6src[2] && !tcp_ip6_spec->ip6src[3])
 			*unused |= BIT(INNER_SRC_IP);
@@ -4823,6 +4824,7 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 			BIT(INNER_IP_TOS) | BIT(INNER_SRC_PORT) |
 			BIT(INNER_DST_PORT);
 
+		/* check whether src/dst ip address used */
 		if (!usr_ip6_spec->ip6src[0] && !usr_ip6_spec->ip6src[1] &&
 		    !usr_ip6_spec->ip6src[2] && !usr_ip6_spec->ip6src[3])
 			*unused |= BIT(INNER_SRC_IP);
@@ -4966,14 +4968,14 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	case SCTP_V4_FLOW:
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
-		rule->tuples.src_ip[3] =
+		rule->tuples.src_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4src);
-		rule->tuples_mask.src_ip[3] =
+		rule->tuples_mask.src_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4src);
 
-		rule->tuples.dst_ip[3] =
+		rule->tuples.dst_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4dst);
-		rule->tuples_mask.dst_ip[3] =
+		rule->tuples_mask.dst_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4dst);
 
 		rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc);
@@ -4992,14 +4994,14 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 
 		break;
 	case IP_USER_FLOW:
-		rule->tuples.src_ip[3] =
+		rule->tuples.src_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->h_u.usr_ip4_spec.ip4src);
-		rule->tuples_mask.src_ip[3] =
+		rule->tuples_mask.src_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->m_u.usr_ip4_spec.ip4src);
 
-		rule->tuples.dst_ip[3] =
+		rule->tuples.dst_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->h_u.usr_ip4_spec.ip4dst);
-		rule->tuples_mask.dst_ip[3] =
+		rule->tuples_mask.dst_ip[IPV4_INDEX] =
 				be32_to_cpu(fs->m_u.usr_ip4_spec.ip4dst);
 
 		rule->tuples.ip_tos = fs->h_u.usr_ip4_spec.tos;
@@ -5016,14 +5018,14 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
 		be32_to_cpu_array(rule->tuples.src_ip,
-				  fs->h_u.tcp_ip6_spec.ip6src, 4);
+				  fs->h_u.tcp_ip6_spec.ip6src, IPV6_SIZE);
 		be32_to_cpu_array(rule->tuples_mask.src_ip,
-				  fs->m_u.tcp_ip6_spec.ip6src, 4);
+				  fs->m_u.tcp_ip6_spec.ip6src, IPV6_SIZE);
 
 		be32_to_cpu_array(rule->tuples.dst_ip,
-				  fs->h_u.tcp_ip6_spec.ip6dst, 4);
+				  fs->h_u.tcp_ip6_spec.ip6dst, IPV6_SIZE);
 		be32_to_cpu_array(rule->tuples_mask.dst_ip,
-				  fs->m_u.tcp_ip6_spec.ip6dst, 4);
+				  fs->m_u.tcp_ip6_spec.ip6dst, IPV6_SIZE);
 
 		rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip6_spec.psrc);
 		rule->tuples_mask.src_port =
@@ -5039,14 +5041,14 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 		break;
 	case IPV6_USER_FLOW:
 		be32_to_cpu_array(rule->tuples.src_ip,
-				  fs->h_u.usr_ip6_spec.ip6src, 4);
+				  fs->h_u.usr_ip6_spec.ip6src, IPV6_SIZE);
 		be32_to_cpu_array(rule->tuples_mask.src_ip,
-				  fs->m_u.usr_ip6_spec.ip6src, 4);
+				  fs->m_u.usr_ip6_spec.ip6src, IPV6_SIZE);
 
 		be32_to_cpu_array(rule->tuples.dst_ip,
-				  fs->h_u.usr_ip6_spec.ip6dst, 4);
+				  fs->h_u.usr_ip6_spec.ip6dst, IPV6_SIZE);
 		be32_to_cpu_array(rule->tuples_mask.dst_ip,
-				  fs->m_u.usr_ip6_spec.ip6dst, 4);
+				  fs->m_u.usr_ip6_spec.ip6dst, IPV6_SIZE);
 
 		rule->tuples.ip_proto = fs->h_u.usr_ip6_spec.l4_proto;
 		rule->tuples_mask.ip_proto = fs->m_u.usr_ip6_spec.l4_proto;
@@ -5389,16 +5391,16 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 		fs->h_u.tcp_ip4_spec.ip4src =
-				cpu_to_be32(rule->tuples.src_ip[3]);
+				cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
 		fs->m_u.tcp_ip4_spec.ip4src =
-				rule->unused_tuple & BIT(INNER_SRC_IP) ?
-				0 : cpu_to_be32(rule->tuples_mask.src_ip[3]);
+			rule->unused_tuple & BIT(INNER_SRC_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
 
 		fs->h_u.tcp_ip4_spec.ip4dst =
-				cpu_to_be32(rule->tuples.dst_ip[3]);
+				cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
 		fs->m_u.tcp_ip4_spec.ip4dst =
-				rule->unused_tuple & BIT(INNER_DST_IP) ?
-				0 : cpu_to_be32(rule->tuples_mask.dst_ip[3]);
+			rule->unused_tuple & BIT(INNER_DST_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
 
 		fs->h_u.tcp_ip4_spec.psrc = cpu_to_be16(rule->tuples.src_port);
 		fs->m_u.tcp_ip4_spec.psrc =
@@ -5418,16 +5420,16 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 		break;
 	case IP_USER_FLOW:
 		fs->h_u.usr_ip4_spec.ip4src =
-				cpu_to_be32(rule->tuples.src_ip[3]);
+				cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
 		fs->m_u.tcp_ip4_spec.ip4src =
-				rule->unused_tuple & BIT(INNER_SRC_IP) ?
-				0 : cpu_to_be32(rule->tuples_mask.src_ip[3]);
+			rule->unused_tuple & BIT(INNER_SRC_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
 
 		fs->h_u.usr_ip4_spec.ip4dst =
-				cpu_to_be32(rule->tuples.dst_ip[3]);
+				cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
 		fs->m_u.usr_ip4_spec.ip4dst =
-				rule->unused_tuple & BIT(INNER_DST_IP) ?
-				0 : cpu_to_be32(rule->tuples_mask.dst_ip[3]);
+			rule->unused_tuple & BIT(INNER_DST_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
 
 		fs->h_u.usr_ip4_spec.tos = rule->tuples.ip_tos;
 		fs->m_u.usr_ip4_spec.tos =
@@ -5446,20 +5448,22 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
 		cpu_to_be32_array(fs->h_u.tcp_ip6_spec.ip6src,
-				  rule->tuples.src_ip, 4);
+				  rule->tuples.src_ip, IPV6_SIZE);
 		if (rule->unused_tuple & BIT(INNER_SRC_IP))
-			memset(fs->m_u.tcp_ip6_spec.ip6src, 0, sizeof(int) * 4);
+			memset(fs->m_u.tcp_ip6_spec.ip6src, 0,
+			       sizeof(int) * IPV6_SIZE);
 		else
 			cpu_to_be32_array(fs->m_u.tcp_ip6_spec.ip6src,
-					  rule->tuples_mask.src_ip, 4);
+					  rule->tuples_mask.src_ip, IPV6_SIZE);
 
 		cpu_to_be32_array(fs->h_u.tcp_ip6_spec.ip6dst,
-				  rule->tuples.dst_ip, 4);
+				  rule->tuples.dst_ip, IPV6_SIZE);
 		if (rule->unused_tuple & BIT(INNER_DST_IP))
-			memset(fs->m_u.tcp_ip6_spec.ip6dst, 0, sizeof(int) * 4);
+			memset(fs->m_u.tcp_ip6_spec.ip6dst, 0,
+			       sizeof(int) * IPV6_SIZE);
 		else
 			cpu_to_be32_array(fs->m_u.tcp_ip6_spec.ip6dst,
-					  rule->tuples_mask.dst_ip, 4);
+					  rule->tuples_mask.dst_ip, IPV6_SIZE);
 
 		fs->h_u.tcp_ip6_spec.psrc = cpu_to_be16(rule->tuples.src_port);
 		fs->m_u.tcp_ip6_spec.psrc =
@@ -5474,20 +5478,22 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 		break;
 	case IPV6_USER_FLOW:
 		cpu_to_be32_array(fs->h_u.usr_ip6_spec.ip6src,
-				  rule->tuples.src_ip, 4);
+				  rule->tuples.src_ip, IPV6_SIZE);
 		if (rule->unused_tuple & BIT(INNER_SRC_IP))
-			memset(fs->m_u.usr_ip6_spec.ip6src, 0, sizeof(int) * 4);
+			memset(fs->m_u.usr_ip6_spec.ip6src, 0,
+			       sizeof(int) * IPV6_SIZE);
 		else
 			cpu_to_be32_array(fs->m_u.usr_ip6_spec.ip6src,
-					  rule->tuples_mask.src_ip, 4);
+					  rule->tuples_mask.src_ip, IPV6_SIZE);
 
 		cpu_to_be32_array(fs->h_u.usr_ip6_spec.ip6dst,
-				  rule->tuples.dst_ip, 4);
+				  rule->tuples.dst_ip, IPV6_SIZE);
 		if (rule->unused_tuple & BIT(INNER_DST_IP))
-			memset(fs->m_u.usr_ip6_spec.ip6dst, 0, sizeof(int) * 4);
+			memset(fs->m_u.usr_ip6_spec.ip6dst, 0,
+			       sizeof(int) * IPV6_SIZE);
 		else
 			cpu_to_be32_array(fs->m_u.usr_ip6_spec.ip6dst,
-					  rule->tuples_mask.dst_ip, 4);
+					  rule->tuples_mask.dst_ip, IPV6_SIZE);
 
 		fs->h_u.usr_ip6_spec.l4_proto = rule->tuples.ip_proto;
 		fs->m_u.usr_ip6_spec.l4_proto =
@@ -6390,6 +6396,10 @@ static int hclge_init_umv_space(struct hclge_dev *hdev)
 
 	mutex_init(&hdev->umv_mutex);
 	hdev->max_umv_size = allocated_size;
+	/* divide max_umv_size by (hdev->num_req_vfs + 2), in order to
+	 * preserve some unicast mac vlan table entries shared by pf
+	 * and its vfs.
+	 */
 	hdev->priv_umv_size = hdev->max_umv_size / (hdev->num_req_vfs + 2);
 	hdev->share_umv_size = hdev->priv_umv_size +
 			hdev->max_umv_size % (hdev->num_req_vfs + 2);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 414f7db..f0d99d4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -474,6 +474,7 @@ enum HCLGE_FD_KEY_TYPE {
 enum HCLGE_FD_STAGE {
 	HCLGE_FD_STAGE_1,
 	HCLGE_FD_STAGE_2,
+	MAX_STAGE_NUM,
 };
 
 /* OUTER_XXX indicates tuples in tunnel header of tunnel packet
@@ -528,7 +529,7 @@ enum HCLGE_FD_META_DATA {
 
 struct key_info {
 	u8 key_type;
-	u8 key_length;
+	u8 key_length; /* use bit as unit */
 };
 
 static const struct key_info meta_data_key_info[] = {
@@ -612,18 +613,23 @@ struct hclge_fd_key_cfg {
 
 struct hclge_fd_cfg {
 	u8 fd_mode;
-	u16 max_key_length;
+	u16 max_key_length; /* use bit as unit */
 	u32 proto_support;
-	u32 rule_num[2]; /* rule entry number */
-	u16 cnt_num[2]; /* rule hit counter number */
-	struct hclge_fd_key_cfg key_cfg[2];
+	u32 rule_num[MAX_STAGE_NUM]; /* rule entry number */
+	u16 cnt_num[MAX_STAGE_NUM]; /* rule hit counter number */
+	struct hclge_fd_key_cfg key_cfg[MAX_STAGE_NUM];
 };
 
+#define IPV4_INDEX	3
+#define IPV6_SIZE	4
 struct hclge_fd_rule_tuples {
-	u8 src_mac[6];
-	u8 dst_mac[6];
-	u32 src_ip[4];
-	u32 dst_ip[4];
+	u8 src_mac[ETH_ALEN];
+	u8 dst_mac[ETH_ALEN];
+	/* Be compatible for ip address of both ipv4 and ipv6.
+	 * For ipv4 address, we store it in src/dst_ip[3].
+	 */
+	u32 src_ip[IPV6_SIZE];
+	u32 dst_ip[IPV6_SIZE];
 	u16 src_port;
 	u16 dst_port;
 	u16 vlan_tag1;
-- 
2.7.4

