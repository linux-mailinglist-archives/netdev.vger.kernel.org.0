Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A3328EE5F
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbgJOIVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:21:46 -0400
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:43820 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgJOIVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:21:46 -0400
Received: from pps.filterd (m0108162.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F8LYWo015288;
        Thu, 15 Oct 2020 01:21:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS1017; bh=BHVIB6j3qGD2jCpb0woT1TIg6zDfSrCdZczDhIV5Lnc=;
 b=Hzch9bQom8R3R9NBPaXyIvppOW3SKmE45ucQkoPgCgA0fvF7kAX0oQTvhK/XcMPXIQuF
 PhQ1DkBwzmJpjMTN+iT65yNOyNSrqt5ZEQwPtO50/ADx4ja7CYe58sXJxMOui0wI3edq
 +O28jyBZa6EVFSgGklu0diPAW0IfUDv4gvng4UXMOkRGtxHelHu/X0VsudvM1etxmRYX
 qdmMktBV+MMH4KFW9NKOAbtsynkz4MFVRu+Lr2bpabtIy79pnmAdtH8GimWrXLiDcBY2
 53797N1wBQswqifEcHiC3XqIMRRrPn2B/uDmsvv344ZjJD2g4z80WQv9+D/irT8GdhSh 1Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-00273201.pphosted.com with ESMTP id 346f340a2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 01:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOlfiqEZvZ6lhmFo89W98hVGel74N1FAIm5JdRm8vXAiExszQBftG2kqYWc7wqg+7vw0Jmb2ssDQbdA9MhOclb86gzkw5xvGeGSawafk/DQnrRg3yZ40mURiXdX1xzUC7HbXr/zB/c9RxwrC47I+5XZJ9Cy2Y/14anYoBvy/l75LVvfeMycLAhC13gIX4rjdkqC41cYKqH+BvekMsoDhHe6cMDudgb1CGMAbW2D2KbvlLBm2f3Fwd6Q38koSqaNU6MNDn/j4pB4Uzqqe2CVuGDT1vLevQPmrDhBg9Ze9iybWdx8HvCUxxQMu0zwU1PaYb6xU2uf/HtUhrt0zoOOs1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHVIB6j3qGD2jCpb0woT1TIg6zDfSrCdZczDhIV5Lnc=;
 b=Kbj4XJXGp6K7XbUlCm4uf0p+e+f96jy6UWO1s0WvEZ5A/NX5cDouAF/H4mIYqty6l+TYF9Jyx9csVy9+ajJkb48k8joXgQG0UhoG+2UdzsReS9LBnChTsCUIq0BTbZRK+gB5gZ1o9U1kzf0gFXFlw4Msk5llY1nfx5ZCAz8UxpwiIqh0YFBRGJhy9W9qz2l/nTsbSNOtV9Db721oi+o1fjrKqVbmrip4b7tEYJcSzeoVZ4dib/R2dtsu/TZTESnMs5t8oPc5wY61TMXdzm3xhy1B+ibmRU54wM0u3QeJdrXhVWCAXUgpcWG/HBvj/jwVB3Ukh9jhMN91/FzTANJhBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHVIB6j3qGD2jCpb0woT1TIg6zDfSrCdZczDhIV5Lnc=;
 b=aJO9MVC+5NPckZhnedysDQE26A3MHqjCET13X7c6Bi/bBFzMVUNgc9K6hvtjXi10YT85EU5HWQ9w+7N8Lm498HaiKSB9JSPeUG1xs+w7tlcf6qOGfVSVTnPfSRMo9CgZ/q5FnxM0zZSOR1dt/bpXAt995cuHK/i93+K802f5dmY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=juniper.net;
Received: from BYAPR05MB6709.namprd05.prod.outlook.com (2603:10b6:a03:e3::13)
 by BYAPR05MB6613.namprd05.prod.outlook.com (2603:10b6:a03:f0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Thu, 15 Oct
 2020 08:21:36 +0000
Received: from BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470]) by BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470%6]) with mapi id 15.20.3477.020; Thu, 15 Oct 2020
 08:21:36 +0000
From:   Reji Thomas <rejithomas@juniper.net>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rejithomas@juniper.net,
        rejithomas.d@gmail.com, kernel test robot <lkp@intel.com>
Subject: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Date:   Thu, 15 Oct 2020 13:51:19 +0530
Message-Id: <20201015082119.68287-1-rejithomas@juniper.net>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [116.197.184.16]
X-ClientProxiedBy: MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::34) To BYAPR05MB6709.namprd05.prod.outlook.com
 (2603:10b6:a03:e3::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rejithomas-mbp.jnpr.net (116.197.184.16) by MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3477.21 via Frontend Transport; Thu, 15 Oct 2020 08:21:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03e5f8bc-d6e0-4625-3eef-08d870e3550e
X-MS-TrafficTypeDiagnostic: BYAPR05MB6613:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR05MB6613A0815787D55336BBD77FCC020@BYAPR05MB6613.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WRGrYAecvTirRQ2PPEl0QnNwVp1/yorMhf5mWKErkudbhVaa+EhHD8c2Xwv7QTZT8Oj6655vjnO0lU2eBtRXiS7DWcDlj/UmEwp902yYxD3mdmcHzyA8ytzXlix7X7pH5sDvE2KSEyp17k4hpznDhehxIj/eqZjvMLbzR34qtjXRvpiW2/MLEEweXcLv6lKd3McBEFjifJy/TggWPc7ooULfuWnI2XmT5A+bMnHhX/M5vkhQipeDSS7CVIBe947asgLpbt3ugrQTRJLKEAOHK+8akW98iadH0GAYhbkF5KpfzI5Krn0Ra0mHyboWd7UgVKS2HQ+mVNWeWzOSJ8cuMKKdwd25qCFR+zUIqmbTr89bUZcAWa0AVXWGT+w0oxMi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB6709.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(4326008)(8936002)(6916009)(6506007)(2906002)(52116002)(956004)(2616005)(6666004)(26005)(16526019)(6486002)(186003)(83380400001)(478600001)(6512007)(36756003)(8676002)(66476007)(5660300002)(66946007)(1076003)(66556008)(34490700002)(316002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: W8YhaPBrFf8oB0pWVRKRdY9FPUYXPQgdfmen8iNi3c7z7qafztXL5dh20Xv8DxI878KYVKjinjIiDiGCBf+E93h7gCoZcwGc33SvKfxXDvGhmnsksMiseDRFngkcgbcSE8S+86ksiIGxR2Ts4kQ8dMWEo8FCQLxsimZR2rFhm+G6JKm+6iKls48jaozwKsV7jDczxNCKIIVtsgsiuDpEwvV09ZqYZPkxiAZeL61JbKqRI8FM0+EfyzHgI+HwKx2w1OTxi+9Du8K6IjIb9THVazRQv2ZcfURE2CAEizYYEZNy2qrvkra+2QHR4qJ8++MSsw8IljfdGiEUGm1kqcQwSUQMVrFRR88HysOILKK3U/2t9wz0OnxgHKrN5VNcBEE/B9JqrEhG7t23kRXXBsYpmX+RmvMMDe7fOktUTCgx7lVA6LNq5DJiMxkaUOIks4MpRsdw2TJfP5Cha7OjQcuN/x+4d4Dzzt0BGQ4U+hNMjklhH5Y62VL7badrsMmMMBQfS9KDUBaepuVNgysVuIT9nKlTtS5BsqU74ybOqFrrVXK94Kh80PYrDf0MyLXChOROLHSnYvIf+spyh9wU43U/OA7aH+qZ5ytEQkF21O9z9qDi1mTsmDttL1RkKz/SVHECYhaLP5j/5RkRGhMIr2PKTA==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e5f8bc-d6e0-4625-3eef-08d870e3550e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB6709.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2020 08:21:36.3717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vW1HYmzyj72omJcIRrkZfNXjOeSPUqU40NgGOHKyUf5eshmKDmR3UZHvgqRKcmb1wDfPY0pnNsVEXIiNrO0LwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxlogscore=730
 suspectscore=1 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010150059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently End.X action doesn't consider the outgoing interface
while looking up the nexthop.This breaks packet path functionality
specifically while using link local address as the End.X nexthop.
The patch fixes this by enforcing End.X action to have both nh6 and
oif and using oif in lookup.It seems this is a day one issue.

Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
Signed-off-by: Reji Thomas <rejithomas@juniper.net>

---
Changes in v2:
- Fixed seg6_strict_lookup_nexthop() to be a static function
Reported-by: kernel test robot <lkp@intel.com>
- Fixed comments from Jakub Kicinski <kuba@kernel.org>
	-Sorted the variable declarations from longest to shortest.
        -fixes:tag and blank line fixed.
---
 net/ipv6/seg6_local.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index eba23279912d..4603daed9de6 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -153,7 +153,7 @@ static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
 
 static int
 seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
-			u32 tbl_id, bool local_delivery)
+			int oif, u32 tbl_id, bool local_delivery)
 {
 	struct net *net = dev_net(skb->dev);
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -164,6 +164,7 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	int dev_flags = 0;
 
 	fl6.flowi6_iif = skb->dev->ifindex;
+	fl6.flowi6_oif = oif;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
 	fl6.saddr = hdr->saddr;
 	fl6.flowlabel = ip6_flowinfo(hdr);
@@ -173,7 +174,10 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	if (nhaddr)
 		fl6.flowi6_flags = FLOWI_FLAG_KNOWN_NH;
 
-	if (!tbl_id) {
+	if (oif)
+		flags |= RT6_LOOKUP_F_IFACE;
+
+	if (!tbl_id && !oif) {
 		dst = ip6_route_input_lookup(net, skb->dev, &fl6, skb, flags);
 	} else {
 		struct fib6_table *table;
@@ -182,7 +186,7 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 		if (!table)
 			goto out;
 
-		rt = ip6_pol_route(net, table, 0, &fl6, skb, flags);
+		rt = ip6_pol_route(net, table, oif, &fl6, skb, flags);
 		dst = &rt->dst;
 	}
 
@@ -212,7 +216,14 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 int seg6_lookup_nexthop(struct sk_buff *skb,
 			struct in6_addr *nhaddr, u32 tbl_id)
 {
-	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
+	return seg6_lookup_any_nexthop(skb, nhaddr, 0, tbl_id, false);
+}
+
+static int
+seg6_strict_lookup_nexthop(struct sk_buff *skb,
+			   struct in6_addr *nhaddr, int oif, u32 tbl_id)
+{
+	return seg6_lookup_any_nexthop(skb, nhaddr, oif, tbl_id, false);
 }
 
 /* regular endpoint function */
@@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
+	struct net_device *odev;
+	struct net *net = dev_net(skb->dev);
 
 	srh = get_and_validate_srh(skb);
 	if (!srh)
@@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 
 	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
+	odev = dev_get_by_index_rcu(net, slwt->oif);
+	if (!odev)
+		goto drop;
+
+	seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
 
 	return dst_input(skb);
 
@@ -412,7 +429,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
 
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
-	seg6_lookup_any_nexthop(skb, NULL, slwt->table, true);
+	seg6_lookup_any_nexthop(skb, NULL, 0, slwt->table, true);
 
 	return dst_input(skb);
 
@@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_X,
-		.attrs		= (1 << SEG6_LOCAL_NH6),
+		.attrs		= ((1 << SEG6_LOCAL_NH6) |
+				   (1 << SEG6_LOCAL_OIF)),
 		.input		= input_action_end_x,
 	},
 	{
-- 
2.17.1

