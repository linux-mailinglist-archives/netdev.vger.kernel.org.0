Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9341D6B3E46
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCJLp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCJLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:45:54 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2054.outbound.protection.outlook.com [40.107.101.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AE511052D
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZagHVCjTozwDqgj3nxSOZY7uIGRImToc2cmPdYohJIzJVi49RLR8+vHUhJCGm/PDBF4yAJ9X7LbvrRxtaIfro4pyK+7P1TN+m9OPwHdbl7DlOnMCpRUD/oQyL9SZQ2D9bp19jLEAyERpma0F+uQi8LBCGBTofSvykxhyGJGGQHDmLZeK+/tBoaTJbzQ1R0FlpcwU8W4p5XCrLf/lP0yHDZszwm6MLsrLH2AHGrmlBiTY0o3QyW25osBG2o7vuxVgaiLsoCfOgSmhVe1wm1PQtGTdLAcUwwAzMbAVCzt0m+cuszHkh0GC8zvZP6nQq1Cj+S2U3d/zOzGjcGJHnMmX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+egSFDidFUPMFJVKUio+lhm7JMMrqX6niVPaBT0CzQ=;
 b=nSBUsqnjPgoC8gLcqx2dukiRHNsozolNJofVZYCOND3noZnvDW3iP3hBTnDGKTSzVa8bFGjg+wHcgKjHtN1NrP8aL/nD5TttKZf/o7Pj6cUVd90AEoPZnD7ueW8NuYqUtN9V0YwNj2VAtsv2eKcFVcD1sSzwpBu01K2c2VVPSVcJdthdm8GiZXzw237iCi4xH1WKioXlRqOcI+/xOMcxoOTBUEpwqh1fW2KJqLsLttH17LdCqZP+JBrR8rXIxslANdsL+qw3qKNhYfs21FWpdZjS+KI0NdPeP5Cf+xS6ud7Us84mJbUG8OJ83Esn9QlEEB7VF2gJSYjjcEj7VufjbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+egSFDidFUPMFJVKUio+lhm7JMMrqX6niVPaBT0CzQ=;
 b=KxhoXKtnaWXASgPwL7PEak9Xrpy7O4znjYLHrimGo9jtS4YbucMA/mjte0H2yEGPB5Zx2zgztJ1AJqhScGLQUI1cZRzvxgqCu75sXddXMc26fiMz6YIVaXJlRvy/ppb23xQhzSgKz427TQfsCiEUSVN9xo1IlNFfisdEpVjygu5FW3rxI7mdCt+Exc/SwMh4cgJaIwQah7uKqQTFKVZQKCpJY7nt5w3qsN0nVHUS6pt8Ly7qbrjvaECG97+kmtDRRkf20vsAR3iprGXomCxKTSGYH2JX2+7hTeIQoVUuwanuKDrkbVk+8uRMOWzwxmMec0BVrHTgzWpNQGq8kUW/sA==
Received: from MW4PR03CA0253.namprd03.prod.outlook.com (2603:10b6:303:b4::18)
 by MW4PR12MB7166.namprd12.prod.outlook.com (2603:10b6:303:224::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 11:45:45 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::d5) by MW4PR03CA0253.outlook.office365.com
 (2603:10b6:303:b4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.14 via Frontend Transport; Fri, 10 Mar 2023 11:45:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:36 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:32 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/5] net: ipv6: addrconf: Expose IPv6 address labels through netlink
Date:   Fri, 10 Mar 2023 12:44:56 +0100
Message-ID: <001280bea093738b10dd334dcfe9776ef5527bd8.1678448186.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT023:EE_|MW4PR12MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c732b6-20cb-4e26-576d-08db215cfc1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpGVDdYEBB/Og1Gv5+G3gAtEMJD38HRzX0hJYHVz9DNWDa+nR80fjokEEs3jEZ8stJMxguzgDRIB8sWn8kWIPSuZt+d5cwZgTAk6dX1obai5iGRkW/iXCcXIn+uImBtCnAMmfjPMc+NRVfNmeBVdTKjmguqVECddxgOTc9qaA41UbayQBn50qCujU+1Om3EjEDzl5/WGybwIiVr+wRBTKJf4YRFouFBuoML0WQdQmAxEmYIeXeJdJCz+kkvGv0sUhXh0hu7i7u2tGT3kFbZTFb3XfFTz+AVCVq5ONjXckKlIdSUP2kL7CuplomhekZBmk9nOVyrMvu4IajY7cJ7ougMhUiEtaX7IHrjf65xgR73eBwbR8ChCi9HAJNaGXhZqlcvY3n/3eUrUIX0oADfpCDEMXI4q25T5cagtQt9kFjeez8jPlG6tSxoizjZY6hyBDjauxk4NrH0BI84p9GXXDtWAIBNOaKUv090fgx6GcA4u73fpghuRUEqvvLQ6impwF63V+UIrOPcfGYO/ymWVIeJuJiH/mj5kza1bt0jwkV+nK683YfM7nicU4tIaKH0xCQ84PCj8M7ZjjqFR3P6HxEzCbT1+MFBlw1ZI7sGOVCzjQIShE3ns5EHoUTs3C1xJ39A6qQn/wycpp+PBkifI9UzXaCaxpA3uhFaIxz7T9NejX25PrqAlXgZFoaj4dnpUOW+Gl1hauXvu5aZIvDkU4u/Wo/8qUy/cVwfRq+c6RFeHWpcxFKS8QAxFP76uLLm0
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(7636003)(478600001)(82740400003)(47076005)(83380400001)(16526019)(36756003)(186003)(110136005)(356005)(316002)(426003)(2906002)(2616005)(7696005)(26005)(54906003)(5660300002)(70586007)(70206006)(6666004)(8676002)(4326008)(107886003)(82310400005)(36860700001)(40480700001)(8936002)(40460700003)(86362001)(41300700001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:45.1918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c732b6-20cb-4e26-576d-08db215cfc1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7166
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for IPv6 address labels, arbitrary userspace tags associated with
IPv6 addresses, was added in the previous patch. In this patch, expose the
feature through netlink to permit userspace to configure and query address
labels.

An example session with the feature in action:

	# ip address add dev d 2001:db8:1::1/64 label foo
	# ip address show dev d
	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet6 2001:db8:1::1/64 scope global foo <--
	    valid_lft forever preferred_lft forever
	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
	    valid_lft forever preferred_lft forever

	# ip address replace dev d 2001:db8:1::1/64 label bar
	# ip address show dev d
	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet6 2001:db8:1::1/64 scope global bar <--
	    valid_lft forever preferred_lft forever
	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
	    valid_lft forever preferred_lft forever

	# ip address del dev d 2001:db8:1::1/64 label foo
	RTNETLINK answers: Cannot assign requested address
	# ip address del dev d 2001:db8:1::1/64 label bar

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/addrconf.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5f4f16bb6ef0..edd1d08eeadb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4671,6 +4671,7 @@ static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
 	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
 	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
 	[IFA_PROTO]		= { .type = NLA_U8 },
+	[IFA_LABEL]		= { .type = NLA_STRING, .len = IFNAMSIZ - 1 },
 };
 
 static int
@@ -4681,6 +4682,7 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ifaddrmsg *ifm;
 	struct nlattr *tb[IFA_MAX+1];
 	struct in6_addr *pfx, *peer_pfx;
+	const char *ifa_label;
 	u32 ifa_flags;
 	int err;
 
@@ -4695,11 +4697,12 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	ifa_flags = tb[IFA_FLAGS] ? nla_get_u32(tb[IFA_FLAGS]) : ifm->ifa_flags;
+	ifa_label = tb[IFA_LABEL] ? nla_data(tb[IFA_LABEL]) : NULL;
 
 	/* We ignore other flags so far. */
 	ifa_flags &= IFA_F_MANAGETEMPADDR;
 
-	return inet6_addr_del(net, ifm->ifa_index, ifa_flags, NULL, pfx,
+	return inet6_addr_del(net, ifm->ifa_index, ifa_flags, ifa_label, pfx,
 			      ifm->ifa_prefixlen);
 }
 
@@ -4915,6 +4918,11 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		cfg.ifa_flags = ifm->ifa_flags;
 
+	if (tb[IFA_LABEL]) {
+		nla_strscpy(cfg.ifa_label, tb[IFA_LABEL], IFNAMSIZ);
+		cfg.has_ifa_label = true;
+	}
+
 	/* We ignore other flags so far. */
 	cfg.ifa_flags &= IFA_F_NODAD | IFA_F_HOMEADDRESS |
 			 IFA_F_MANAGETEMPADDR | IFA_F_NOPREFIXROUTE |
@@ -4999,7 +5007,9 @@ static inline int inet6_ifaddr_msgsize(void)
 	       + nla_total_size(sizeof(struct ifa_cacheinfo))
 	       + nla_total_size(4)  /* IFA_FLAGS */
 	       + nla_total_size(1)  /* IFA_PROTO */
-	       + nla_total_size(4)  /* IFA_RT_PRIORITY */;
+	       + nla_total_size(4)  /* IFA_RT_PRIORITY */
+	       + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
+	       ;
 }
 
 enum addr_type_t {
@@ -5082,6 +5092,10 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto))
 		goto error;
 
+	if (ifa->ifa_label[0] &&
+	    nla_put_string(skb, IFA_LABEL, ifa->ifa_label))
+		goto error;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.39.0

