Return-Path: <netdev+bounces-4801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4217370E6E0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBBD3281182
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEF28F67;
	Tue, 23 May 2023 20:55:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C43A55
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:02 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC2E8E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQDM2w+T2tqNTT3xKtjB0OULUtNULACJaT3y+g+BgrpeWEtvPpjNtwBaXRHDwWaMCbiVVMYJIq/sYAp7J8lmBX4ujTjbsMljU8IZ216Zs60btezCVCe+u+rlCEnMruFo46xzx6YpSKaPjmnr3tdib4HGI0jotj9NpYXZIV8BSTSlezDK7AEy6xyY9Cum1j9E+WFJCWH0P4sBBfyeCNYTXONLwKvQeNjFrbTc8zBBO6AsazRBTUxt/Vl4FaNlGIdtA5hV7+6HR+9y+omLdMBIJCO4/lDENg39lj0edUdjdhXgS+tcBqhHA8dTtgsQkrogIPChEbhyj9IGQwWfl0Krfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHxjhHC205ubKSAyV2runRJhU5w5TWZH4ADeqLIqeiw=;
 b=cUWV+PAz5qXGMIyLr+u49LgrDsG9MiYq7qeXnh+0o88uAlIPIKDfQ5Oc5hPfZ+D5ISVhcN+EO45XpWT3gv5K1Sk7Yz7a3vmu2ueAM2Ux9Gv1JPJ671UzLrdtNJHZuyZ6lqlzUplBhjsEB50bhB3o0o1coTGgbhZk1N2myOttCNRP8fxvrpC5k63kKkwVIj0zARDuDZNqMsN7a03+D4pOjrKuPjEfz1KeC0WnCzoQ6SpoCUXeelu0gby1nh4yjeBbccsJMKOZCwBj00WHXqc3jai3KvjBHN4aSgGPoQmEX/iXkvwQyoyIFyN9k4qTqpiuFsN65Ic3oNsdsQin7SliYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHxjhHC205ubKSAyV2runRJhU5w5TWZH4ADeqLIqeiw=;
 b=EGoUE6r+LElMfUfF7ZahOO4vOgwpbuDqk8JDxg+nyZJIoz0Njsq7yCnI1sCHRZKuDjGpLi5vjIMEXjF5bS/mneKojp9tsf4iD7M4u9Y2VlDtLvr2Bt8JnNg2JQf0RQ8LKcL8DVMp/q6ktOQhlQZpLF6ljGP3dyYBz7JvoTQagN9hFD4Ue4k8iZW2Xj/i+STU/H+ytbF2M6xh3iBm7XvEdLVgb0XZtRpcLgccZOSEYDkmCCDBFnnF9jsJqLUYL3cwmbSNPHNFC1XqjVVjGdZNfwiQuEu0HMCYvY4w5f+uhzZf7vCpeZQLJ4N8w+ACvcckoQFxmueAyOXJw7z6Km4AXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4314.namprd12.prod.outlook.com (2603:10b6:5:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 20:54:55 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:54:55 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v2 0/9] ptp .adjphase cleanups
Date: Tue, 23 May 2023 13:54:31 -0700
Message-Id: <20230523205440.326934-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: d4195b5b-26d8-4be7-b0ae-08db5bcff674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OZuW+SLjQ5/Jl6avElRvw9K81KAhO43bUKk+gso+k1H8pW4mriPAsuHLr7LleMCLnTevk4A4xOXiPVA5UrIGDViZrJsO9lIZyuxmN52eNCijOP3XlVYbHlYsZcbyR8ripB2ub8eAkabT5Uh2FaSuPoyapLhT9NLjdldhtsFvRO001YU22RZom9j75lQSQBkm5tSB9gdXRrdeZrrSK+hwc4BtKzdrNXiHFusCnnQD0KF5MPaT2yeFC/0ilW6gDZuhYTIJEkqpgEOqiWPqi07XBaaYhcZ6K3XybhHOzf0XOIz4o+KG0HkkrnUNyUNOr5YObtAdr8tijKp/5yWGU6o1m3pnxCa2KOG7TYjFrPo2IN5C6NcsQGzYBmw0kXB6qJHwZ8bCUnvtMusEZXdtxnyE6tFihulCTnbSnQYcwr9SIhtERtDR41NkDUzmxagi8yOH1Gc5vj18UYLjbRhY5FvAjdCJB/E+VZuvlYAGWtUuyPglAgEblcwa4xC9PAidWwHxqNg/kc2vo4l+Xg3b1W0VKjymkEeC7Y04hhP6HF2O0NbNixDIq0KNbSICX5Ia3f3jb61Ki0oFklGnDsH4ZE7Duch71dsrYqkmJij/bs1YUrDPrrnwsJIpveSMNc6KK4CCIOTFEfCcM1EQ91qmTXtTOfiW4MvB6s7VCK2jPF1F+xeKwKDddZPbWHxSwdP2QvdN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(26005)(1076003)(186003)(6506007)(2906002)(6512007)(38100700002)(36756003)(2616005)(83380400001)(316002)(6666004)(66556008)(66476007)(66946007)(4326008)(6916009)(41300700001)(6486002)(54906003)(86362001)(478600001)(966005)(8676002)(8936002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4cdbvlAg7qRhTN8ieCb3HxiIs/dkKuQjxplzUgsewsbn/qqwsNZsFNZBVTTV?=
 =?us-ascii?Q?89L6mh+zC1Dsw+L8nMEBjrVZ5NYtZePQ0UBSh1hbpozvxjpV8AXC3QO1nAR0?=
 =?us-ascii?Q?6H9fK7EvJHd62vDRH+yu7zuBb54JdqSIhqv1wIfPpDX8Jp3aHBSO9hB026bk?=
 =?us-ascii?Q?9ZEz5WhuRY7/fqacYRhnMO7UEMDAF9o+vNot53eFCg7TKuJk6qn6P7rXC9uA?=
 =?us-ascii?Q?qd5NMeYQMvvrWVQE3eUzmdgltwJORfe6GfxZcgGnbnW4FZO2MMN0URRu9pIt?=
 =?us-ascii?Q?8iQDav8jYdJuJ6b9ETkVVyVOiVt9ui4KTTVSGvswgurOrfS1ZkNu3R79rjQZ?=
 =?us-ascii?Q?3kT19lF8k2kCVq2mpQj4ZMTVDoOn6aFmOYIOlszZDVi/jHRU6D1pKw0B0Xgo?=
 =?us-ascii?Q?pzNFNDkInatqvAFezUKZLVCgJUl/p9HtAHPcOq+Kv0CzMMGBfuo/0aEInevk?=
 =?us-ascii?Q?lEUMKKBmPP8AbgK3kYH1r8in2nPFY3bzFW7/ItWUueth2XfKiivSdNWgN0lo?=
 =?us-ascii?Q?R/iD2N2h93M79+XJUJhJfPpC6furFJEQV0SuYWhZ0qRSG5iofz3VPjjLwXiv?=
 =?us-ascii?Q?zYK/WVLNgF924Mr0s/LgPIHQAjo406gtpvg1ipmeGvhnBnH1oj7dxJy8R7gW?=
 =?us-ascii?Q?V6FPQ812C6Fl84U3RpasXs9otyv9JJ9EQQNK/s4/aK1IW7dppJ0phH32NYW+?=
 =?us-ascii?Q?tOiufwyQvZFmcsO3w+RBKg6c3YVNmW8KdGFn1CMxIm2u51Sb47RZICcxnnQO?=
 =?us-ascii?Q?rdGPv+b3zAjPFleVIXKUjAQWFrGqM+ENklaTKAwfyz3op7/54T0U9P5JAjdn?=
 =?us-ascii?Q?no5LNmVI0Uj8eGb0Kt3xsQZ2OHX6APzOmc8vQ7iW7cNWygYgx9cLSgnOxsxX?=
 =?us-ascii?Q?Wpk0vXg5NhZcOin1ruIy96QXeCoGlpVVKaS51LAzTL8Qcw3xzMvmqpK5tL9M?=
 =?us-ascii?Q?XXz7hoP50Z9P0qvMMgEIPhi3PYwFjeovma3B74RY8+spOETqjTBcyhBKxSGv?=
 =?us-ascii?Q?z8RtMljzOY93pS9sRHo3SKFGzqz5q+ilCB2ON2nIKoWtuFvsJKmu7qOA74Oh?=
 =?us-ascii?Q?/XfsjFiqrHqlXPp+JSGmxBMz32IFj4n62DUZYa0dqSRb14bsEVY8HfoQ1yqx?=
 =?us-ascii?Q?7HDiWMqmZvBvgPkyFEoNl29yoGS56Gq0ygTzCibD5EBkLFlO3oM485c5hT7U?=
 =?us-ascii?Q?o4wKLZckR4i8lpk7I1moHtqi8pVBNbvC0X1eD7fUo/si+PCjqgZBo+LPnwy/?=
 =?us-ascii?Q?luCNDpXrvMxakbNLIFQawTB0o/hruidpUCjrf0s7Ndqxbj/TvtWb8YlcGj6p?=
 =?us-ascii?Q?A31tp0fFnGg81etUfUzS9Z4DwjBB/x5Aj4v6nehgyUd+0Ib/8sAj0GcHYfwY?=
 =?us-ascii?Q?HVkzL+9GjQuxdHX/ZmiTOEXllE0q2t1Z8zWLR9mYziI2OLG4AI5PjZG/xSJ+?=
 =?us-ascii?Q?2dL1WsjgIhH6ieyFQU1NVD+LgMPPxpIu9d6ohxnunJU8SYfa3PuJpW2pQHeW?=
 =?us-ascii?Q?XECTb1ykbSrpQecbcP7FDJNOWW2SduRyXmgzAMT9Vk0fOWzlk/U1Y+nBiQ5z?=
 =?us-ascii?Q?FtLrHS8fIFjLQZHusDJqXaGawOZOOD0j1JMQ4VdO1oYZZXad8S4S6HB/mMIw?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4195b5b-26d8-4be7-b0ae-08db5bcff674
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:54:55.6061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glsd7stpUduhpQhbl7Q+G1SUpjxbjxXNDAUXNnweoJOMEqEr5s+wmhxWjzXBjHyMPnhMuBirftpalTdyg7yK9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4314
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The goal of this patch series is to improve documentation of .adjphase, add
a new callback .getmaxphase to enable advertising the max phase offset a
device PHC can support, and support invoking .adjphase from the testptp
kselftest.

Changes:
  v2->v1:
    * Removes arbitrary rule that the PHC servo must restore the frequency
      to the value used in the last .adjfine call if any other PHC
      operation is used after a .adjphase operation.
    * Removes a macro introduced in v1 for adding PTP sysfs device
      attribute nodes using a callback for populating the data.

Link: https://lore.kernel.org/netdev/20230120160609.19160723@kernel.org/
Link: https://lore.kernel.org/netdev/20230510205306.136766-1-rrameshbabu@nvidia.com/
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>

Rahul Rameshbabu (9):
  ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be
    used
  docs: ptp.rst: Add information about NVIDIA Mellanox devices
  testptp: Remove magic numbers related to nanosecond to second
    conversion
  testptp: Add support for testing ptp_clock_info .adjphase callback
  ptp: Add .getmaxphase callback to ptp_clock_info
  net/mlx5: Add .getmaxphase ptp_clock_info callback
  ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
  ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
  ptp: ocp: Add .getmaxphase ptp_clock_info callback

 Documentation/driver-api/ptp.rst              | 29 +++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 31 ++++++++--------
 drivers/ptp/ptp_chardev.c                     |  5 ++-
 drivers/ptp/ptp_clock.c                       |  4 +++
 drivers/ptp/ptp_clockmatrix.c                 | 36 +++++++++----------
 drivers/ptp/ptp_clockmatrix.h                 |  2 +-
 drivers/ptp/ptp_idt82p33.c                    | 18 +++++-----
 drivers/ptp/ptp_idt82p33.h                    |  4 +--
 drivers/ptp/ptp_ocp.c                         |  7 ++++
 drivers/ptp/ptp_sysfs.c                       | 12 +++++++
 include/linux/ptp_clock_kernel.h              | 11 ++++--
 include/uapi/linux/ptp_clock.h                |  3 +-
 tools/testing/selftests/ptp/testptp.c         | 29 ++++++++++++---
 13 files changed, 135 insertions(+), 56 deletions(-)

-- 
2.38.4


