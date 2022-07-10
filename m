Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A629456D207
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiGJXyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiGJXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:54:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C116542
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:54:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOVFFJRxDYpgriE8cCXin84BponldT/TgLKNhmHKPUee/0ZoRuqw5Jb21k2ZmQS7Qwxq8be3RiIwdcHGu2vJu2vyVQ99fTgGbUXcrqS40nrG6w18bp4R6EzuSYkjXTME5xDzIU2kCy3a9Wo4ORXsYLmNdJAy6qxdY9NrgqUynDQeS82nJVJC7Q1dx0Eo0xlRK8HZ+qIKnsysbZ7SJGZqbFkuK0447GrekcskSy8I9yYWkbn4A/OF2xtvld0FCoYbqvw2JXiEvrrmTIrwevgQeJ3Jpn0deJ/+gvy3YDFlFepiwKxMeid6vIYIinYehNqgEfv4tcYzJetwOZ1R490KYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkElwooMX/IE+kElTOzMu0fY+9ORPwWrL3n1AiU9AiI=;
 b=DizdSI/YauqpGSdIwXaXwRUTIhNbGsY2P58pLRw96gv9ZEQHozmaRUlA9JIDKS737RN1AFWX2Kn9oOr0L6KRa/jOC4KFO7mirER27MqBFb1/07DbhD6FzZgt77EJtbl0GU0xLW3Y4zM4+vDrs8sRHDjWkO3sdgOirlYu63INrELBKD5v/Z8IMOoXArfj261+rADTFO5qayBAeHeRMM1WgpDX5BrnE9sYeDVBgiO3cUL09YYWWSldetLex/2M8//zl+WAYvoZQhjylO/v0TkPdHta5V238cm7sP+N4N0KQyXZgTd8BweX/XXildgxZKXld4bx+PesvseyGLIzJS/Jmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkElwooMX/IE+kElTOzMu0fY+9ORPwWrL3n1AiU9AiI=;
 b=TvcLsxzAIIB+u8O1saVHqPdELR6hHtns1OhuHq+16kQqCcNAH+N8XfuJjYPB7nM9YWAM4aXzQVVXS4wtnRDj8V2hWrTbeIMm3M3628adih4b6JGjLrNZGrcnML9IYWZpvsuwVQ5lUGeJvn34X1esqQNwXa5FygCMVz70IhL6wpQIjhb/H0u4d+qmHxqWq/Ij19BH31LGHkkn1Jf00Ry3UGPr6LFkMdzzvTUS5oIwQOjpMa9PnfAbXJgeyp3RWE7hirl6ZYC+r4jQgh+11bu2QKVGlhqwGdOMo4aW62n6gH7H8iOFJJwTAUnHnBEQKkilcSAAhN9juBY8OjSYu6y+hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by MWHPR1201MB2542.namprd12.prod.outlook.com (2603:10b6:300:e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sun, 10 Jul
 2022 23:54:12 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:54:12 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 4/5] mptcp: Fix memory leak when getting limits
Date:   Mon, 11 Jul 2022 08:52:53 +0900
Message-Id: <20220710235254.568878-5-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220710235254.568878-1-bpoirier@nvidia.com>
References: <20220710235254.568878-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0078.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::18) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c2836bf-cb95-4c6f-791a-08da62cf7ce3
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N79pvLIBFo6UAq+fWc6jriB9AETJ3Y2Qw/Z6lZNLymH/lVu1+tGQq9q3kng7vh2eaNPb/zlwcKDrQH4MuhbZrPHHAI7zerdr4C2BwIdWYot0Wp0//t82/M2hStqun2RMDc+Wuu3AcTRrutrevl48AmDv4nLR2WMbktO/b3m2n1Ugb04+mg0Y6IXtBIoHKvUPLPTKixIym1iekyekglgCVUYF66l15jOssbEcXSv+3akr7waUoHtwBTc9qstTcAwgY30ICC/5ef7VKnKy624deizioZbZQLjBetk8WuuPWi1ZN7VrWI2cKYQKFQ2bpM4+IFwITJbpno5MurnKzHscqSbEunEYLvXp3wiQXu8ukgtxFmQ4MFKBTO75T+xWfqr8HO5RaEGxZ4vqRBqOZaLmWiVNQTH8ik/6v7PJCPh9zIcCrVy7AsKmcgT5zTV6WuuzDG/nBWItsC8dJ7KPejuGjFHt+IT4+D4ia61+qchrLwShBncHJbxtUfMFEM6tsXzaLLkRtfMMIAE2J7aHorZGjlkSW0B0eYcRO9j9NG4HzwJzZnolon/haiwJQVbQFaDpng7U1GhjG8r91zej+CzWsyAQwMSPXnRtpVryBHUKG84NtK6avkpKgs1dJ3m6s0yuQKcRWbGwPmB4+aWJy52LmmwMiPyX76AaNjct9GIxZiiSUhZMFIHrDkSGhn5n4qlrkqYAYaRIGcpAsAW93SFhaw7bZ1C6YAdwVlFmshn+gzuGIo1S48lAMJWoNfM0lVZa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(186003)(66476007)(8676002)(66946007)(4326008)(66556008)(6666004)(1076003)(86362001)(6512007)(6506007)(478600001)(26005)(6486002)(41300700001)(2616005)(54906003)(6916009)(316002)(2906002)(38100700002)(36756003)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hokCFolXxbW0HdcnddeOMB/FzDrVLOWo5V8ZBpbJRzkpE2elUEjoisFjFqoi?=
 =?us-ascii?Q?rtHGZ6OGeCPnuf/J4SKbDCM/P9OdEao/zwwv5rqna8jwsj8I0PVFtYrsgWh0?=
 =?us-ascii?Q?K+HUT1MaUPszlz3WulkfCc3kZJMnd8tvMITo/cScEL2Mm9i29TCUJ7wN33uN?=
 =?us-ascii?Q?lKhLom5grqyxX5ukpMqZQ+IObrgTwk3cKnq/rYS//gLnImjCe9eqy1xJCFbM?=
 =?us-ascii?Q?EUDAKNYqI6smHVvt4YnYZHiMloQwyj4G7Q2Uqirqu+ffW5W97Wjn4p4gX06I?=
 =?us-ascii?Q?oZ9+nsaXdyANwe/BuPAC3pRvLhBEZsFV+jbogF+JFuLX3iRwlB+gy5d2QnDD?=
 =?us-ascii?Q?C6yCBMnjoj0ueqSyToZpjlXTuReKty2kwI+A6Mh7b0vPHJwSzf9eDxDD1RAl?=
 =?us-ascii?Q?KcR6UfWPw7UphoBOEVqqiIEu98vvVqAVH6kETf9JYtVvDs86RaFE84QaZS25?=
 =?us-ascii?Q?gLX26gK02WBbKZ9jdYkM4EuEP5F5s/JxWcUNddtc91cDYN9IGkJCNdZJrhJ1?=
 =?us-ascii?Q?7B6XRFod9tVWcvRfAEXxxbQ05qzd3lL3qWUw57YD+y54+dyT+R5BUL3x5/6E?=
 =?us-ascii?Q?if8r9UPEB7z9sCq5OAcnW9JZkd0gFLkheSDUyUeXs+NBxy/yAOJc1y5GsOcT?=
 =?us-ascii?Q?ipYPVHYTa24mLe6Xujn5vzldUevfCqMUFEsBRwZ95vew/HGkN9rOj76lw1aC?=
 =?us-ascii?Q?tOCSQQqOpZe3q1qNQBFV11DI0XK+Lbk1TAUkeqSnihp6BZbOgC4NZJ9s5CkV?=
 =?us-ascii?Q?3vG/fjUol5MwIR3/SDA+XYypPXE2hDuNVWI9ZQfO9954YoqD9iEvj5Dz9d8p?=
 =?us-ascii?Q?vOTROTwkC6fArofyiwlKv3WPFfHn7wjab+QrEak469cj2gNWJ78diIYOpNwm?=
 =?us-ascii?Q?Jh1AN98wzvHIjAqKh5kPi6/XUkHl3BaO84eI2882QU8GA1QhTEBYuF72kpQF?=
 =?us-ascii?Q?h5hQdfUm6CY3jluEpr/zeUNS5SkP/75yfS9TQOgA1ir/wdT0CGUAA+7YtVap?=
 =?us-ascii?Q?mrVte98ERGrqacZgPfQST5Rfb9xLg2GNtLASphwKFUjDiu5jvpM6So9oo0gh?=
 =?us-ascii?Q?0KigEUXJ/u5Qi9rxvWNQ/aF/Qr+bMTzX6INRy7u0LGn6fFRyULm7kq3gJKeT?=
 =?us-ascii?Q?iiO9B2wx6XqmI2PRr8zcnA4tgk8fBiY1I6mzTl5IvoIdmZ37tn7+fkSRcsTz?=
 =?us-ascii?Q?tno0CdPoQfG0Zvnh8rtdaFpeeUr8KIOwvLYcQ9Qo37XxaYhfwQq+EUf+K8V0?=
 =?us-ascii?Q?+F9WAhhWcWlwRZnSO1r1Lmlv+xY0rqnpVdhd+XGERNO4xkcQfdLbmddlF1nV?=
 =?us-ascii?Q?YQywjTniwLh2p50GCZ4xT3bRrtL14R7qmL4CMNg7TuBVKs4MWa0JxYNo17uo?=
 =?us-ascii?Q?o9eUpNTePPMHzJICdubwbLAJc/TtoHZMb95JwIO8xgECaZSj/WnauVmKIfLR?=
 =?us-ascii?Q?kIU0yuWYrSrlQpXQS2zcg0SC8j+FeuJFcZ168i3mgIocR+FaMvxsWIxrxZg6?=
 =?us-ascii?Q?xzsbWlz7CQY9PNtNZ8WtWv5EG86c3XMHzEAmNHxTgFIp0Ev0HzeLlFiG/4HT?=
 =?us-ascii?Q?PtNfzRKKyvXbomTeVw7bGjtXQHyuexEGovxWIIny?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2836bf-cb95-4c6f-791a-08da62cf7ce3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:54:12.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rMN0FC9UUFl8ZT3fToMMmL6Ot68EbvXoD6IJWOnopyymMfSK4VrSZDb/+9+dyq1FPIr4V2f2gKU3DthQ/kzdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2542
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running the command `ip mptcp limits` under valgrind, it reports

32,768 bytes in 1 blocks are definitely lost in loss record 1 of 1
   at 0x483F7B5: malloc (vg_replace_malloc.c:381)
   by 0x17A0BC: rtnl_recvmsg (libnetlink.c:838)
   by 0x17A3A1: __rtnl_talk_iov.constprop.0 (libnetlink.c:1040)
   by 0x17B864: __rtnl_talk (libnetlink.c:1141)
   by 0x17B864: rtnl_talk (libnetlink.c:1147)
   by 0x16837D: mptcp_limit_get_set (ipmptcp.c:436)
   by 0x1174CB: do_cmd (ip.c:136)
   by 0x116F7C: main (ip.c:324)

Free the answer obtained from rtnl_talk().

Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmptcp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 54817e46..ce62ab9a 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -436,9 +436,13 @@ static int mptcp_limit_get_set(int argc, char **argv, int cmd)
 	if (rtnl_talk(&genl_rth, &req.n, do_get ? &answer : NULL) < 0)
 		return -2;
 
-	if (do_get)
-		return print_mptcp_limit(answer, stdout);
-	return 0;
+	ret = 0;
+	if (do_get) {
+		ret = print_mptcp_limit(answer, stdout);
+		free(answer);
+	}
+
+	return ret;
 }
 
 static const char * const event_to_str[] = {
-- 
2.36.1

