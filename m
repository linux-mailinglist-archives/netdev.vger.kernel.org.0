Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AA628CEAB
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgJMMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:49:07 -0400
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:37794 "EHLO
        mx0a-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbgJMMtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:49:06 -0400
X-Greylist: delayed 2810 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 08:49:05 EDT
Received: from pps.filterd (m0108158.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09DBrn4n026653;
        Tue, 13 Oct 2020 05:02:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS1017; bh=YGGZEi/B8Aq8FATDO4DHl48nfnoXekwAJwlcZlCgTVQ=;
 b=tWkfORWJTF4xV4PYOkTMvSiOUZ2VGCYsmunHGJ85tyz+SmGAuqBlptqOXZXO+Zz2xXTq
 HGlEoB3NC3dVI8nLXAbaUDoetADYTiDpwmdaklx7hWI6w7wDWA7sjaCocrfKctz1OSnM
 TURnYhDk6zwnmsl9+JNUGbcZ8se9h7CIzP6Q0/9ma1+YYwOptPAa864/3UGRf4L5Bo21
 eRanu0Ry68lzZUD/MeQdYXjboVu2mTpprXDnHeXeUMz8GaktuWGOTjWM2sKbaULODr6c
 wHHR3YVSZNLWDY/W4FYFBxK1I3/Xq10ln7L9e5J1AePtlqv3HKraWLxqwd6zK2WRppCT wg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-00273201.pphosted.com with ESMTP id 3438npmeeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 05:02:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQWScJOwz3oKYNzdZJXBDPT+zaTBfp5lj0iX9Kkqg1HXW5gM4nH+JlRoR9cGJ4MYD/xdvfOLB+HiB3eUKNHZ4nyjJ0nIB6FhI9qowE782FsspyIZQlUMYeiV1pZ1jCwUnkDDBVx1E1lwk3cMJZdyHvNC1VVaJU/HXpkNPNQX1e50j6au6RNXESys4FnvQne5LDeU6pgbXGTEUbAukdwqQ9KpNLGrWhKzClV0hNOPmGztrhwY2Tmzg5YB8JvCsWeikR2ITEYArmX/C6rDeNEEaJScMrL4EiTKZg1gnJc2zmGfTeS+gkpKxp0+Zr8H0x5tXRET7eEBVV5SYQrVD1KqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGGZEi/B8Aq8FATDO4DHl48nfnoXekwAJwlcZlCgTVQ=;
 b=e8Ut1kPK2ZZdn/7DPYHl+vvnwYawWpf5ArEf4448Yp0wBVfLzSazansOu9e9gpO9SVf6Ii9zZVUvDB5zdFnX05O5ERJ0z6ZCMPwB5KLDwmv16Cqu1QR9hCWVHOL2NbVLFW7gWmCtC5OedjXhd3rzp9IUwH6a62zICxmqI0Hs2b1e17JdWEXmB82ro+U9P/QBoyCvpdIvVshhunI00dKaQFjuiR4lWqqxlA0Skwt7yCFWXKMHwHFs1+LLjovzUSC2jSvWzo4I504isRnoetDfQIxGWbO1lrOD5zjMFpXBEmX3sbb5oqmk8LWHBjYSlhHGDYKq4stO1+1+l+Z+aNYDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGGZEi/B8Aq8FATDO4DHl48nfnoXekwAJwlcZlCgTVQ=;
 b=WXbmmE2y/wG/7MINq9B9ezvPxNtL3QfPw4oNm2BWU+DqRJrPsvNej0Nb2efJ3TZLJeCHAbiGuK8B+cb7OrUvC1sYgCgs3jFGbQNa3eYWnJ4Zk9WDhH6BS3Swg2VZk54bSoBHx70hS75VefZhdUO7mYNymD5Vgr3nullJSGjC15Q=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=juniper.net;
Received: from BYAPR05MB6709.namprd05.prod.outlook.com (2603:10b6:a03:e3::13)
 by BYAPR05MB6613.namprd05.prod.outlook.com (2603:10b6:a03:f0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Tue, 13 Oct
 2020 12:02:07 +0000
Received: from BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470]) by BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470%6]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 12:02:07 +0000
From:   Reji Thomas <rejithomas@juniper.net>
To:     kuba@kernel.org
Cc:     david.lebrun@uclouvain.be, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rejithomas@juniper.net, rejithomas.d@gmail.com
Subject: [PATCH] IPv6: sr: Fix End.X nexthop to use oif.
Date:   Tue, 13 Oct 2020 17:31:51 +0530
Message-Id: <20201013120151.9777-1-rejithomas@juniper.net>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [116.197.184.13]
X-ClientProxiedBy: MA1PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::12) To BYAPR05MB6709.namprd05.prod.outlook.com
 (2603:10b6:a03:e3::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rejithomas-mbp.jnpr.net (116.197.184.13) by MA1PR01CA0096.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 12:02:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 336a8748-1022-4f54-e4f3-08d86f6fce1d
X-MS-TrafficTypeDiagnostic: BYAPR05MB6613:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR05MB66134B90B485EA757A2F7F43CC040@BYAPR05MB6613.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBqd5OtLowxfNxbah0fZKVj1zSpHvmp9Fq/nJLK6UqkdhfudSksiprMbuqhcc4CzGMG9m/W2uTaW20l02Jh8M6IvYM0jdJE+HeTwcEv90o2rPWNqBoQbQqIbN3dQst50L9F7fgXF6XCGNJkk6xo+uSTeEojphLzEASoSdNAri1hMvuFlCmOM8unN3Ch+5KHQKklVepmSF5aUODWa+wFUf6ZbbcwpHBODNnx8+MuyqGNCD3vdip+w49soDVZYvEWw27DEImzlBn4RTBE5q/h2RKZORHXOrkQXzTz0XOXRoRhNshLoyhDdkNybut/WoBDp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB6709.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(2906002)(6916009)(4326008)(6506007)(52116002)(186003)(16526019)(26005)(6486002)(83380400001)(6666004)(2616005)(956004)(8676002)(478600001)(316002)(36756003)(8936002)(5660300002)(1076003)(66476007)(66946007)(66556008)(6512007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: oGFo0WTUwRPxeTk+1muywSUb4ZM7l8HbMLbC3buh8zMqOR7HapmgINCEftG5zYUYhZHtjCGBIO2ic4IbfF+5GIJkkmUYhZa4um3M8LeTc1hmTR9X5/UThLTqjGO034ZH/eCue4HjgTk0tAe6qMxQE8ISRoOiZl3dG3tf6awV8ZSGHJTcrdAdxcK8yz2pCCNJji5DzKlTbDoAw004zldkvhksEEuSIRWJSOmQgU7mI+XYHj1Ahni2uweJ3Mn9Aae+qMdCCjudHRJHQHA1LvAWjQyHTgNQt3Qezd2yy5h79GAoaBPWJkVYEQJxTVvFxHHDjI95BD5U3l5MhTWxePM0a6lR9b4BAw6MYejv+vIKPcbIn3hZQktltgrhF/Xr7eJybrffAweap6bUwxghNKx+LIY4B3nSAVYOy8Y2tndyQeJkyKOS0VCOv+rgg/qUMkBQbeID5m+omKPwX26hepaKkCsaq0DhU4lU6mhLKVsnqCmn5V6b/HQ4znWW/dYoidTUzDNpaDWIwoBWgwdfwhlQ0qHF7yUd6QA+vJTgZSsGyEETAjlD7dYgmMZpadcDops6MXAKo1fYuSe1Mu3Rhf0xeo+3jq9hlw+cQnInycbgxEcUg42k4zz5WAf8Rt/Yswlf52BSd/etDPvdgSAtL3Dgzw==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 336a8748-1022-4f54-e4f3-08d86f6fce1d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB6709.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 12:02:06.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEN3f7x3zjbqfDVltsmSPClu1mWvkisSFW1tJ3IVKwWZUOlWasvWsMiZO0hEgHWEiXqkonGwalDgZbE2UwxFrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-13_03:2020-10-13,2020-10-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 malwarescore=0
 clxscore=1011 mlxscore=0 mlxlogscore=801 lowpriorityscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently End.X action doesn't consider the outgoing interface
while looking up the nexthop.This breaks packet path functionality
specifically while using link local address as the End.X nexthop.
The patch fixes this by enforcing End.X action to have both nh6 and
oif and using oif in lookup.It seems this is a day one issue.

Fixes: 140f04c33bbc ("implement several seg6local actions")

Signed-off-by: Reji Thomas <rejithomas@juniper.net>
---
 net/ipv6/seg6_local.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index eba23279912d..1a669f12d56c 100644
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
 
@@ -212,7 +216,13 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 int seg6_lookup_nexthop(struct sk_buff *skb,
 			struct in6_addr *nhaddr, u32 tbl_id)
 {
-	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
+	return seg6_lookup_any_nexthop(skb, nhaddr, 0, tbl_id, false);
+}
+
+int seg6_strict_lookup_nexthop(struct sk_buff *skb,
+			       struct in6_addr *nhaddr, int oif, u32 tbl_id)
+{
+	return seg6_lookup_any_nexthop(skb, nhaddr, oif, tbl_id, false);
 }
 
 /* regular endpoint function */
@@ -239,6 +249,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
+	struct net *net = dev_net(skb->dev);
+	struct net_device *odev;
 
 	srh = get_and_validate_srh(skb);
 	if (!srh)
@@ -246,7 +258,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 
 	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
+	odev = dev_get_by_index_rcu(net, slwt->oif);
+	if (!odev)
+		goto drop;
+
+	seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
 
 	return dst_input(skb);
 
@@ -412,7 +428,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
 
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
-	seg6_lookup_any_nexthop(skb, NULL, slwt->table, true);
+	seg6_lookup_any_nexthop(skb, NULL, 0, slwt->table, true);
 
 	return dst_input(skb);
 
@@ -566,7 +582,8 @@ static struct seg6_action_desc seg6_action_table[] = {
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

