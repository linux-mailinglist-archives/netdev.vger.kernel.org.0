Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B456B3E44
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCJLpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCJLpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:45:40 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2029D110520
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFvg13o5K0/bFxNTYnWJ3sXJhQH/keCPB1uuHOmaFoNDilgz1yr7Q/0HUIJg6bczcBEM2KwHWRQlIAlAdIqcNLGKZjtEuRR9D/0N4JUo/4Gic8qVJioBmmFq0tP5c4uiqfrHseogzV8Sc3p1N0NxK/FzGAStF98heoWY3O8GZ6wmRroK1SCbQtzZoPqjyb6Ibpr+uSyGVILFdEuuuYX5BBe5X11qcc5Wd5lAfcEzdLWlMO3loviu8Gf7PBYJ/5rkVOwe3bEp/dPfL3PUQ9jtv22J3YkHcXd91iJyH2Wye8fEnVmD4lJQOAA8zD7bbV2jTo+rCM91G49WsRecIWsS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaAK9kFFiRTmmvMVDP7lKkjf1SW89LwHM/tomqAd2VY=;
 b=X/aFUU/wMrrO3y2Lt931Q28r5gHLjqdSjGfyhdyjjuCWoxY6JZVglR5Gwjx16xn2aJkGHRsNPMYYvndeAAmMbJL/DpjDBHMKdIMoo089ZXuOWy6PPUboR0o4Lx2Sb3ngELge9ZxDPWxwcvszmY7wmitGZuIH6snDCp37LCDvLBGKXLcbARkxLbl33CP6AjhIhSMtnrgeO8DO60XGI1dfGmlaDfw90BsMvjCirRFpQIDqHdxUA1En8eBUEAgpX6kjqisHl/edTi6gxoA9E0Y5YGNKZPt0KRiWVstINypSzfkYwpk1Ba7WcR18S5EuEZtWZ7T1Zd5g4JNHpA3p3CbYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaAK9kFFiRTmmvMVDP7lKkjf1SW89LwHM/tomqAd2VY=;
 b=JHAUsxE9tNRexwrpRxCID8i3lYW2bwMiWAqQ4g87MVxNjdN30Y1Goqnhadz3UhxC+pjXz0bjjJcM6ExCjy5S3FwLSRVg2jD20laWEXqaT3zuUby4v35MXAlr0nqPLfT/zkACk07kQ2QVjf0mcdculzllazRJqScZVPObT2kmAcRKCsJL0zzyPLvAIjBN4ApdqSBV2EyYXdwk/AHk884CTFAiPNTIEJVFLv8Cp2PgF1wCls0WOAIhQpvq+jaKzAi5PW30PMxGBii5o5r5iZv4VeNKRvsoyVDXhUWGYcI2Cr0G+ThVc4ZjBHQAsDRS1J6uLFyAjSU7oPTYfUl2KeeLBg==
Received: from DM6PR02CA0149.namprd02.prod.outlook.com (2603:10b6:5:332::16)
 by SJ0PR12MB6992.namprd12.prod.outlook.com (2603:10b6:a03:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 11:45:37 +0000
Received: from DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::73) by DM6PR02CA0149.outlook.office365.com
 (2603:10b6:5:332::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT086.mail.protection.outlook.com (10.13.173.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 11:45:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:28 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:25 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/5] net: ipv4: Allow changing IPv4 labels
Date:   Fri, 10 Mar 2023 12:44:54 +0100
Message-ID: <34b8d6d6f7ff59eb26490eb1065304c827afcd74.1678448186.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT086:EE_|SJ0PR12MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec5b09b-b759-4a7c-9d92-08db215cf6c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Mbt/f7NxpF7sDofd4AVFxy/1zD196nXj0KYVQjNDc0PV/e3p7rhv3mAwCUHqwEZQ/3IJjfreJS3mqcC/Lf6WepPUrMzt3A8jAwpXpKaOkkxBFu0vSBxQq51ZZPj1FWn5pne8Qqd5tp24QKcU/5nyehreiLZC0olSVfE8dDBF7FzIFlvmPV7uoA2TChwrWi25fgMFwrwNO7XUlfjSGhDm6zKyYfJ2OPhB5Ku8TuNEfvGvVh/I+Vkycjucs/XlnwonXwnsfUL4vhF5bkecWAwgUbAffrPj91r0WNnXtsPBIx59FVMMVvfwBKILq9quFl5HB3+Bg+1K7sZia6dqFFaQ56n0yypJ5Uktz+WCmMH0Qcux6CpZu5i1wq/FPPlhna4tx3SNPjHYjKjXGJ9wO60JLo9rj8tgxVq+7m0M9E6Xyg3aythiW0IcyWuR80v96qx+9lsz6BW2vbGBMC9WFDFT9NyvrePC8QHgWRoKUfIyJgTmJDRnH9Bm2t3EMwA9tuHaujFQAMmhYjaE+axEo5u3/CSSZEum9KB8GkAbSntOSzXbcsQMPg0SbKflDFNraiVoR6xI/8wzz9HlxE8enXGjtoTBb42h39bZOZuQP04YFguy49J+Qvp/aYvN5yX3Dop3meGqZ/X+WnG3mmN3ID3noph5WuYvXPwjnX7/Mk1Q4I0a/EaxlpFCyST62YNYYfC1Zage/00HMhxpR1lZZ/rY9VFRb61Di8w/EAEPiUF5u2a7/RJfPv38eUm2Bs7Nixi
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(110136005)(36756003)(36860700001)(83380400001)(47076005)(426003)(82740400003)(107886003)(6666004)(26005)(16526019)(186003)(7696005)(40460700003)(2616005)(336012)(86362001)(8936002)(5660300002)(70586007)(4326008)(70206006)(8676002)(41300700001)(2906002)(316002)(7636003)(54906003)(478600001)(40480700001)(356005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:36.1995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec5b09b-b759-4a7c-9d92-08db215cf6c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6992
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
which are used for prioritization of IPv6 addresses, these "ip address
labels" are simply tags that the userspace can assign to IP addresses
arbitrarily.

IPv4 has had support for these tags since before Linux was tracked in GIT.
However it has never been possible to change the label after it is once
defined. This limits usefulness of this feature. A userspace that wants to
change a label might drop and recreate the address, but that disrupts
routing and is just impractical.

In this patch, when an address is replaced (through RTM_NEWADDR request
with NLM_F_REPLACE flag) and a label (IFA_LABEL) is given, update the label
at the address to the one given in the request. So far the new value was
simply ignored.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/devinet.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index b0acf6e19aed..dfb6d20ada9a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -823,6 +823,7 @@ static void set_ifa_lifetime(struct in_ifaddr *ifa, __u32 valid_lft,
 
 static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 				       __u32 *pvalid_lft, __u32 *pprefered_lft,
+				       const struct nlattr **at_label,
 				       struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[IFA_MAX+1];
@@ -885,6 +886,8 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 		nla_strscpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
 	else
 		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
+	if (at_label)
+		*at_label = tb[IFA_LABEL];
 
 	if (tb[IFA_RT_PRIORITY])
 		ifa->ifa_rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
@@ -933,6 +936,7 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	const struct nlattr *at_label;
 	struct in_ifaddr *ifa;
 	struct in_ifaddr *ifa_existing;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
@@ -940,7 +944,8 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ASSERT_RTNL();
 
-	ifa = rtm_to_ifaddr(net, nlh, &valid_lft, &prefered_lft, extack);
+	ifa = rtm_to_ifaddr(net, nlh, &valid_lft, &prefered_lft, &at_label,
+			    extack);
 	if (IS_ERR(ifa))
 		return PTR_ERR(ifa);
 
@@ -975,6 +980,9 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			ifa->ifa_rt_priority = new_metric;
 		}
 
+		if (at_label)
+			nla_strscpy(ifa->ifa_label, at_label, IFNAMSIZ);
+
 		set_ifa_lifetime(ifa, valid_lft, prefered_lft);
 		cancel_delayed_work(&check_lifetime_work);
 		queue_delayed_work(system_power_efficient_wq,
-- 
2.39.0

