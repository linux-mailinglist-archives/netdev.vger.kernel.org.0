Return-Path: <netdev+bounces-1584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3CB6FE5E9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EED41C20E35
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB97321CF2;
	Wed, 10 May 2023 21:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96DC21CCE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:01:27 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B92E61
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:01:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyDaTTIUWSpYa0JmJB0KWOAp7zv8xnhDWUDvH778lcVMYRYtrF+NvjupBMCrl0/0846liJBcatmPvHQWjOw2mYV+UXo4/QIIMXHzTmbM/6QUr8KhdE1IsRXCtWcsf2ypYJyvRtemg+8K7wPV636VZTmjS0GBxuasVK/3VvHP8Rw8u0CJVs/NsxpdZOwTwkrZqlNBg+UvSXSZZQllkNkZNYnnt4VBo/Wr7+Xh0pqQalGggnm71ilBzo+KEUUFWf3RvhQnO4Khy+iBq9XcLyInohYLH4z2qPmQ3n03j75usF03MECNpoFIxJTHEWuU3dgoIIIdGqfOWTnsYeOMvWcOqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJ/xMCqdKVjA/lFAgq2we6RsYGLYDigZg+OaKLHcnJ8=;
 b=iEg5e/JFhNXqeBX2X0nALUifqhrBQrHgtMEFIucyvD43jTL2m0nsS4iIwQzw4Bo4iz9iUgn1P7mLhBO0MFV+vS2AgGH9ySJQsB1OjuO4+QMPRL7rKPnLjuusUx2uIe8MUsffged9wDoHb3RqWAoVdlpLyxupKk6AvBzklJ3AitkVjqP6fPaXLC3yPeyTjTn5SNyheBkYnrGP+ChK6/XMDid4IQzXSGnw9Mq4i0OKM4J91xR4BgaXxKOVMlHlKcMpJs5yTxRyuUbw36llP4lC7zuLY9JpRAOmhpmR7FyL9pwq7/T1MAJ1nujTVC3qHtZwCG1jc0WXXq+Y2BpJjL3NqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJ/xMCqdKVjA/lFAgq2we6RsYGLYDigZg+OaKLHcnJ8=;
 b=rOJdnVV3QLahpu2Sj/HPPyNqv7LB7CAU3bIaZG8+o0uFkKoF0zrevM3g1WfxatvwxBzocKtV0Eu+nl83kdM2k5zILrMQbCvJXJAPvy0BMY07wGA5fVEvRPNnY7YBfr9iJ4FuUqIZT0pt4ydl52sdNveok8nN7nTOAnxdBR1w4TRJzLzNAhvRVCSP9/hgY1c2kr3zGky5wLHAXzvwa5H8sa9I9QSNRk4vXno9OGPkVF1lq0+853tsGHJBvW4gjchb1iXILiZgKG4h+Bc52/6vVU1AyaTFmc0nTrOctEO7OLbVvB7WgF77wPBZSXbVtBH2iVxYbxXgVkW0Dbyq6oKufA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:46 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:46 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 0/9] ptp .adjphase cleanups
Date: Wed, 10 May 2023 13:52:57 -0700
Message-Id: <20230510205306.136766-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e531a9d-1e47-45bb-c28e-08db5198a5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5oXBfnXsqidRILjlpgJZjpDdwIX5FnpZ5QUp31tdKFk5rvUMv9TP9LBygStWXfeVKJypDjjcYNAQXfhKT/suBgu1Os2zERsbYTK+pRkLzJO086Bnz6drNkyzYZs2hCUhiVKPXTOjRm6s8UwfYGgPUSuDFRMhn0ihUWkRL1Xo5kwN0Tgk1Hnr++IVlVL7q+34S5iiKe2Kj35cqE8dfZjo/NqhWpgmMHKskdP8V+faD/IheoG5MkzlLMk70OlYnZsx+M3GrBGEWK8XNAP6PQiouDZqG9B4LX7DYF+9JhMTpS7crTbUQyEpvJnkM+I+eBYe+gr+iFRQpnTQlYpDDdZ5L3G95DOOjGEr2zhqc9p9lDH4DuI+6VOp5CRJtXq2k8CTP4R/0jsoRXq0Tx7JUYl4rYZR03IYTSOkJBighBgmnYyEFIIyP1vKE/Ecx1f1XHMbWJwA/TcehmynJJkE45axDmi7GNXY0FOZd4S9Fr+KNstuw51xsR4qQLKaQokGCqz+JX8uE+UhVk+x91gstP6djlRkC8TIrU2Ri4T4bu2pgqhpMLExUEwTqpwP3QKxDBd8w701DeZ4JEculiRhBJT5lJQZuQdp4tGbuNqW7qLjZGVEmXjMZZcOd9oZGAOdYRKIbMewJifnunYPr55D0G0GbA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(966005)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Su5vs7m1KG8/mzHoCRWg9X6jMQLU7BZzJu+F5nP+EUAgDMh8+6TJlewErRg?=
 =?us-ascii?Q?DOgGjXRBIeCoU6ONKVTRaclogMV3cIBjKVjQcZ5ukHrB9E9U+MzcyT5b1jf2?=
 =?us-ascii?Q?ezvOALNiZN5Ap0ECjLjUinUSiLX0iTjAg6JBK2MkEJLoAoxa5AU2Sx7yDay1?=
 =?us-ascii?Q?9U2h8vsZNDAMFeFga7kGQ9H+JBwTcItcWgi/VuPu2ME43u65v50HvhQKWuc7?=
 =?us-ascii?Q?Rho3/eHEV2O3yzL8hIc0BM/Lg2viP77MKpgKIkItVjpaGcXj/NI2l3xEV5zP?=
 =?us-ascii?Q?QNicM7pyEY04dIAfkay7IewSV0hOVEa9wLgoTGXwnJtBgbWgYXgVQ1TSCJQG?=
 =?us-ascii?Q?r2s8xj23aMq7n1ccIKowjteInRE8uYzup4DwGCYLGjPfE75Z8PUX+MdVoB0g?=
 =?us-ascii?Q?LJu5/hFczp1BHVfqp3lLX5JPEHxg8xfxtJwZ3gfx8xfyKXc6vEwsysmtU69C?=
 =?us-ascii?Q?3v1+tULlDV8v5R09sa8lG4ih2eBesRlz89si0wzV7CJX1Q7bugnqbAr6oaSq?=
 =?us-ascii?Q?cNsVTywWrFirAcZ3x5HbAnVEqDS/9CyGBIDDUagVQx4VnO2zv/+H88l6RUg+?=
 =?us-ascii?Q?2vG7wf0KxhdkGx/yrOyVdltvYJiaDIKJwMcEceFUMKsV0kIv+cAmam+RD86x?=
 =?us-ascii?Q?cMDdglUXr+M+LYB4/+NN4E1z/TAoO1pcA1FA6ycJ1lJVv29rT/QcnE6yZhMb?=
 =?us-ascii?Q?U7r2MswzzAW9XgWpQ8+NrhaWlqOTrn+A2uw9gj+q2Zvd1H5UFpzBk4sEC6FL?=
 =?us-ascii?Q?wvCQVbROk5B/asZRX5k3JJDMYwAriMfubKFfp3CGCbrnbStW/kSJDkdnAJZB?=
 =?us-ascii?Q?16nm7euN76xgI88O02jj16NkfcSVyFg5J1TnF1trdS73pTf85CwdZ4WWR3dU?=
 =?us-ascii?Q?RU8hIaK8nSYnvUMjYUTverNss1FiH42OYE5wKlbECqTuCBswxCTtz7j8he8i?=
 =?us-ascii?Q?enWd6LZvn5FmxDVeOkc9h+gs/+nYN2W90668GKo9+cx/Sd1CgrxofsP6iu9j?=
 =?us-ascii?Q?ErFBba7VdizGWHdWR27X5/N+SXmln7zT3CSszbBTaRFxr+9G3MjilA6jeqXU?=
 =?us-ascii?Q?vsadyyvA7kikCkD3GkB/nPcmmXjTSdiJdUt+ehtXzxmJDTkSMxtUa7AUd/by?=
 =?us-ascii?Q?VlSWaCOl/bqs6bWXdxvOMObMkKUdfSWaG2UaiRYlZig5XhPejDu+a/3y3JNn?=
 =?us-ascii?Q?YPVNKFOBVzrGxqwm2/4EuDPBVMuMEjnWRfaBJUAVKSfok4AJIbKhhlGULB0g?=
 =?us-ascii?Q?Elth41hXFHqan8diChxJAef+EYWa40/yFVcq6AJmA89V/1d6sbFX1xiMLhHC?=
 =?us-ascii?Q?nV1ppV42qxZCJL/OyL8LYaISMObuTIBpJf7bGlR8zV7BanFJJqgXyz2vBpOP?=
 =?us-ascii?Q?1pfVdlCREmCe0pqkFvqK4KtKQls6wmRPqjAOtMiQ6Tns3tJkZUytuQu5MqeX?=
 =?us-ascii?Q?xKlSmHQvGEeuTy/BYJtxNxsJHqxFL8E+Ibj6dExWIe9pTlpW09GXKGcOtWck?=
 =?us-ascii?Q?phclbRBboVMWHemk3zEG3d05J4jZIh/QzX8TPw5oFCr8IqMjD961ltRJvrdE?=
 =?us-ascii?Q?Ph4c5cg2g30oWS9VRpLqHHcZKs5pYyWbjvuh3YsA4sFQiJ1EOgahCRmqQr82?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e531a9d-1e47-45bb-c28e-08db5198a5f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:46.6001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRre5aJNiQx8fWK4prc1aDufGZTlUGf+Diq+dK2bgCT7JVmPjZd1oWLbzKkvxQTASDDeeqqtVDiH3Y7wvMdyeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
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

Link: https://lore.kernel.org/netdev/20230120160609.19160723@kernel.org/

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

 Documentation/driver-api/ptp.rst              | 30 ++++++++++++++++
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
 13 files changed, 136 insertions(+), 56 deletions(-)

-- 
2.38.4


