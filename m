Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93784B8B6F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiBPOc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:32:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiBPOc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:26 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555AA6B083
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjflzgFr1q3nX+7l71W/Bwe7SD7KrM2/Ai1hZoR91G987qsnC8lEOY9/KmEmDrwehxJbMX6lN5yvps6CX1wN6cTQiZrNybQpVe5boI5qD/3hkqYYPrGLMGsdNUGF3uz92un9yCSxxuzUwR/u0SJR9u3qm0ZCfNcn81zIl9ShhBvhx3tYYlJccjCBituKnYcpyBYWjVUNtoRv4lYfDXp6gSE8BvagZ5Si4+J1qyUA12wvvzDx5NYVW162B65L3mcRRi4eR57y08EK0h/KkfxKEPYLabQsHv/AyEGMSxK4Zm4hHH3lzZk7nnNwg43kOj/SKnPGd7+HjKAi7X8ZadaUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5ofqi851zRUmANxiFl9draHRQZu0rK1Su+h8G8Ph2U=;
 b=SgVIFM/N5KCWlqe7gINFNYkB5CJKELoNux5UCJdrWKitrmfroWQ4ko3JZPYsP7UAPyvBCM4lUCk/QyYcwmj+lQcVUZr9thZOVoy+BOUysB+lqIHlQIwiOMOYIqTrTQlnwKyA9Uig/9yTybAUkaBg3Xk2GzOoaLJipVtFejubui5vmmT9hfUBfCPFPDMdd4FFn98mBSETveupdsH6dBb1/G9xVTzWtj+CUTqyE3xLbeQY9wTPw7/yyUuVQB6XCeVcRg2ol1kLFLQundlhabyWvZV7y7Go33YOlCDxf1KpCff3I3Mj0u875CAXaaeTyC4ocvSxDWp+UkjCz8FidVv3cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5ofqi851zRUmANxiFl9draHRQZu0rK1Su+h8G8Ph2U=;
 b=tAPAErbgDl2HX217OfUBxjmKK04akwEu8GxLo38Kdm9JsHNH8rtQqwK2BFNBPKG0OOL6KcOxvYPpovpGdJuzjgUO5ju2ALHVfJMC8rnUXo0+KTr8MO7OeC52gDcXCTTjUp6Zi1cN7rV4SbhLeBpYzsEujT7JqlNF3eBwyX2eDJGe/WAZrPBFME0UcBqynsmEOhlcauAqwCxA9yfM4xk4+DmTTbPnOHB4mkjvgJ5f1yaFtIqfhEt9qBo16rLM5/IkYQKU2lEr1w9hDz5XPf+I/5Cbi4bdXJboYqNJcL5lPR7qOCt2T9viqoWEej8qXKeT3Qop9Q8y1mXwlMN5nYGerw==
Received: from DM3PR11CA0013.namprd11.prod.outlook.com (2603:10b6:0:54::23) by
 CH2PR12MB5018.namprd12.prod.outlook.com (2603:10b6:610:6e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Wed, 16 Feb 2022 14:32:10 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::5b) by DM3PR11CA0013.outlook.office365.com
 (2603:10b6:0:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Wed, 16 Feb 2022 14:32:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 14:32:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 14:32:08 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Wed, 16 Feb 2022 06:32:05 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next] net: rtnetlink: rtnl_stats_get(): Emit an extack for unset filter_mask
Date:   Wed, 16 Feb 2022 15:31:36 +0100
Message-ID: <01feb1f4bbd22a19f6629503c4f366aed6424567.1645020876.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738d0d38-4d70-4a1d-199f-08d9f1591d83
X-MS-TrafficTypeDiagnostic: CH2PR12MB5018:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB50181A69A3A29370DC2BF9C5D6359@CH2PR12MB5018.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRkQtWiJ9UpCnN6jwW8IpE2mQ4tNKQUd+bneK/j5S/E83XlPwPCXMX/Z+IU+xOtXGCV/fuFLx7Yjc3QlzaLoN701Ld3GIJhhsT5vUebDCHSH9UfEBKOPa0XcfZBnqbVFS0v8SRvztBxAGpAV088oTi83NtyojCoWnzzKKytfNry1T2HZdRtaMQborgwXQpzUtfqyaULwXX7HJNNx7WB9e3g7zyIuFb0Me/qHdbN1r5ybavKZLIWnNBg2pt4lCSyp/NtONpaT84xmqNML5RWHBfVDqxAYWadbHa7a6dT7T9WGJviB7kF0LrmuWlVmy7P4/5yE2L3RrKnH5OU+mraf9nDWGP/w9G5AIKbgQLOiD+MZkr0WpNr+JLaEy+cHXEqbP76bQmRVrXJEsKo7KqNTE8QYxGfwLMfKFi7afkCtT7wpnt6V86qT5MQCE/bH0bCDODSZcWBxMkX3CRj/CgPwx7zOWAub3kPAUUBqFncqeoeIUQBgd7/033whflf7qZedlRrEj+P1Q20+ojWeXSjPxwA68CuB8HYnCD32/upOYhrnCXbdId7GKZZOapzfr/TAK84CxflOfU7wPab0g3QUOZsyV1zM7/LpgNfzqhr0NRlJYwkUxz1LTCucz4PP+CO8CavS9eI1gj+L7F8tQghwf1viyjDHK+W1u/XoPvEQNKt4aJsX6/9WlVKQB14FU99IimBL0j0PulYcc0LzK4/z9Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70586007)(70206006)(4326008)(8676002)(2906002)(4744005)(54906003)(5660300002)(8936002)(36756003)(508600001)(16526019)(7696005)(6666004)(336012)(186003)(26005)(426003)(107886003)(2616005)(81166007)(82310400004)(36860700001)(356005)(83380400001)(47076005)(86362001)(316002)(6916009)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:09.7900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 738d0d38-4d70-4a1d-199f-08d9f1591d83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5018
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and dump handlers for RTM_GETSTATS require that a filter_mask, a
mask of which attributes should be emitted in the netlink response, is
unset. rtnl_stats_dump() does include an extack in the bounce,
rtnl_stats_get() however does not. Fix the omission.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a6fad3df42a8..9aa7d8e0d90d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5405,8 +5405,10 @@ static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -ENODEV;
 
 	filter_mask = ifsm->filter_mask;
-	if (!filter_mask)
+	if (!filter_mask) {
+		NL_SET_ERR_MSG(extack, "Filter mask must be set for stats get");
 		return -EINVAL;
+	}
 
 	nskb = nlmsg_new(if_nlmsg_stats_size(dev, filter_mask), GFP_KERNEL);
 	if (!nskb)
-- 
2.31.1

