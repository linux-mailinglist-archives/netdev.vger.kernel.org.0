Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED728B1C8
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgJLJvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:51:35 -0400
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:20296 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgJLJve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:51:34 -0400
X-Greylist: delayed 4364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2020 05:51:33 EDT
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09C8bGcZ006875;
        Mon, 12 Oct 2020 01:38:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS1017; bh=8RPgLRB5J8p7n8T0Yy5fqnSYZ0vqd5w/Ff32eQMZ7Zo=;
 b=KJAcR2iq6k9Gb5wgRlNGoo+3DB8AqwMtY0c7MyuL26/XDa+7DyPs113Zgia53gdhpE7/
 Tc1m0vXJQ31eifsENxoWJqI63g1ZtASoouZW9FhOGqEdFJC4yb/cRt6bBBqV2ZOLJkx7
 pt79ney1u7JvR+9XD0NuiB45kZwKqrKluDhU4jJOcg8wJg4CD06vLyFpU0TIeHZ6jU+L
 LzATzmlpO0VCpsx30/zVApkTEcAtD9cQbNNG/r0Uq8LljWZ84pjqOAKCAS452YoMYbuQ
 w9a4qNJu2sRmGGhIjaZWphyBZQe8DPD1BuslCB0hNGS7aVwbO5rp7bbYdOGc7M3ehgam qA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-00273201.pphosted.com with ESMTP id 34386pj6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 01:38:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA7VATNLnXFSUR3cJv7aumQCdjpTI8/oYGWfsdPVSTqtOFnnciwO6Tk4bb5OkIDXM3kzqzeJk7uhfdfRbT2NdxKxUJCQB1Gq6mRlym2fkVTIFAoeMSvHziMA2U+0kLRhAbT7QHuQ7XQI1AuXCBaOqwVKGp/FwuG/W94elk0CuIM8PUW/B/HNcnQobyRjisVJp7xRLXNu23BwuNy3unCBm0/bRQHjzIueM81JUIvTD79fKIVMJfjQpQH3kYHcnbEG1z9hZ+qlfzGYYyQGhmahYahR2odjksCA2fgnwzdjyLy0Dx1lW4/TUGXRQ5FAan0BqHd4wrjSgsSLMXXGXICu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RPgLRB5J8p7n8T0Yy5fqnSYZ0vqd5w/Ff32eQMZ7Zo=;
 b=KePUhWVFvEz+E/SilQi30ynLaQJii75EyJgX+pJn+TUIKS0yhLnvf69mFhgQEez2HKPk+k8wn2F+R0P5UXB4ViN6/fAdSwGMOZ7o1EeMEVo3Hq9IGIo5OZy8G/OcWoi2R7X1TJYcYAsmoR9UE0gOemwLNEwI2JruvOAJYcUtqKKc44x3LLBpt/780m+vRphL8qfCrk1Zktorwj8E67jLR7kDmhN5nASUkBIlWuJUsBT1sU9yd9rwfYRj3GwvmGB69div6xz0mmFY/KNR1vumA1Ovrpc19AqO9jjWVzIS/I9LENn+PFmId6bC8r3p6KeRcQ4rs4M0DdLgsOvjC2aLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RPgLRB5J8p7n8T0Yy5fqnSYZ0vqd5w/Ff32eQMZ7Zo=;
 b=b6AxJ7O78qzp+GfZtXUV2q0ucSlLOzJ+jnl1/CATqlHyWssH38wwCf88SMB73b5IejuzGhbNjZVPDX4fflTTQhJ1hIRJnN0AR0J6vytaHUz9HOx8Jru1iVjcqjQ7OlMDViMJuWzOpi2xdOCpKOvM41iGbky+834RaWCyWQcNoWw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=juniper.net;
Received: from BYAPR05MB6709.namprd05.prod.outlook.com (2603:10b6:a03:e3::13)
 by BYAPR05MB6167.namprd05.prod.outlook.com (2603:10b6:a03:de::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Mon, 12 Oct
 2020 08:38:43 +0000
Received: from BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470]) by BYAPR05MB6709.namprd05.prod.outlook.com
 ([fe80::483:3663:5ffe:5470%6]) with mapi id 15.20.3477.019; Mon, 12 Oct 2020
 08:38:43 +0000
From:   Reji Thomas <rejithomas@juniper.net>
To:     dlebrun@google.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rejithomas@juniper.net,
        rejithomas.d@gmail.com
Subject: [PATCH SRv6 End.X] Signed-off-by: Reji Thomas <rejithomas@juniper.net>
Date:   Mon, 12 Oct 2020 14:07:49 +0530
Message-Id: <20201012083749.37076-1-rejithomas@juniper.net>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [116.197.184.10]
X-ClientProxiedBy: MAXPR0101CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::24) To BYAPR05MB6709.namprd05.prod.outlook.com
 (2603:10b6:a03:e3::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rejithomas-mbp.jnpr.net (116.197.184.10) by MAXPR0101CA0038.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3455.23 via Frontend Transport; Mon, 12 Oct 2020 08:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 70ce0560-c0d1-4e9d-f93e-08d86e8a3a15
X-MS-TrafficTypeDiagnostic: BYAPR05MB6167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR05MB61672214F95513E70A2357FCCC070@BYAPR05MB6167.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JPUgmci0mrifiizg9gQT0n9Yc6megbkhYLN3n8GqCJ+Cht5UsbXlVsQico32zvPQojVujn7K842BRoHOtbqaXyxC91tdXc+cJ2j/NNtbPEHHLNurNyY2shyvQUHdRmSJqT/oXJ52TT2zayf7f/6nwN6jqrIg9vL66neXF0hfTSrhWYh9z3pHgBQE660JJ8Dxwn5Ij9e3uNsQ48rpwt6yhlppHW1qI30wtCg1Vg5JnSOfb1An8Y2QzWXN/jFRvx5mT10+159CAnrBDLlnqSnvAKi+cH4TBIuJF8Vops611XVn1oiGs5YwuETs8kwZ8N2D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB6709.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(86362001)(6916009)(4326008)(6506007)(8676002)(26005)(8936002)(83380400001)(2906002)(36756003)(6512007)(1076003)(66946007)(52116002)(478600001)(66476007)(66556008)(16526019)(5660300002)(186003)(6486002)(316002)(2616005)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QHuCvA/vQmFUvxA6qQK9JK4v0+jJEQ5IOhhtAGIQmwUWOSxny3U4+vF+Rlp453YkkuAr0arH2U+vb8rnAxhKuU4tUZULeiI3cExXyZwY/1PFQFDoFMRBR0DDjLUJPAyP7IwFXtuQNZQ0CO2d416pwl5ZQJxR/w7xE0zNMNGCu7DRz1mHK4/RRXy4kXuh/Ku68oqBgVN0KyiXbQBjM2R0TIYbX9deMZHs8VT8tWNwt8r9DDyipwbFFzK/ULjcgY/DF9QVExM9hv2mu8ha/2GkgSCPlc0A37wOlW4pPA+vmwIVzLYLjAOsCqcPjkmkiot6hmgAc8ssJr4gWhPiuK5Rq9ZVG6I/1B2SvcN83OMyylExDH3SEA8jQYfCQuO4EnOIqzfCMH84lzxTK5ugj8D5EaOU2/E41slMesWAMcwUFqo2I5p8ipHhuvvBNd3YDRC2MjU1CobaB2UP/5M1rRuxn77iLUwJNfubKRZRt9rAkqeyaswyuzPYuWd9EQ5ZNCyYFOV+D9eFAdU0YA6YMazckpGLwQlihPVNzC7wKs0Zmi6eXGYNZ2oumE7SUn3V01U5UKTby+CcUxLZVwlHY9OtMEGZiM64qOuM835Fg4E4qWfyyeUNUwCuDu9g66ZvUdi/mZo1fXOLHCv5WD+Fu+8A1g==
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ce0560-c0d1-4e9d-f93e-08d86e8a3a15
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB6709.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2020 08:38:43.6283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+6QAMbm7lmVW4zuucTjHZ7xVW3AFYHXE2HD6Pj6LWH/m/FkjrNb9tyem7rawXHmKzxan99qULwJ2GvwfjWjHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6167
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_03:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 clxscore=1011 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

seg6: Fix End.X nexthop to use oif.
 Currently End.X action doesn't consider the outgoing interface
 while looking up the nexthop.This breaks packet path functionality
 while using link local address as the End.X nexthop.The patch
 fixes this for link local addresses.

Signed-off-by: Reji Thomas <rejithomas@juniper.net>
---
 net/ipv6/seg6_local.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index eba23279912d..26a1c1e3e560 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -246,6 +246,16 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 
 	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
+	if (ipv6_addr_type(&slwt->nh6) & IPV6_ADDR_LINKLOCAL) {
+		struct net *net = dev_net(skb->dev);
+		struct net_device *odev;
+
+		odev = dev_get_by_index_rcu(net, slwt->oif);
+		if (!odev)
+			goto drop;
+		skb->dev = odev;
+	}
+
 	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
 
 	return dst_input(skb);
@@ -566,7 +576,8 @@ static struct seg6_action_desc seg6_action_table[] = {
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

