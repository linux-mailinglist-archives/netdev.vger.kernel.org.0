Return-Path: <netdev+bounces-1384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5B86FDA83
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F7B728134B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9143C65C;
	Wed, 10 May 2023 09:17:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8296C63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:17:44 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E630C7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:17:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH20IUruGjZh5jYTLb4GalkQXthHhanZig3mpkyyjIpeF1M9XBBz36pRDzWKqvx2axplNyDqOU1joHQ0fCBjo/O1TdLHayugJmK+OTLcJkHX82k9XE1DI0gSv9JMQGyFJSmLvxIkapDyR4oyNRKjkYqPx/W8PC2pp/xH1/3YItbElSMVxVn7cYRgQD4ojtGnuTyeAS8+yIz0K0kCn43SjKTVQIoTDbEs/dh6qjzI51gkjs5fCrunkUXFiUhdjuLtLsFfEipPPDrWiN+RVCk0D3WPbalQN8S0k0tWDJZrp/A4YSh+7E9OQ5m2rNYr6Y3wXYV72W/lg98znRj6S7Y7iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8GBidinbtzXAIjgljHCT17wyCJwNy9Ed5FVcOEWmDg=;
 b=XwR9XC7i3wGzwJajHD1QuwCx+LqUzaHWV4Bbf22WkX7Q4aVygAhG7Kgis/m7ymVcN8TNJpFPBiBd4CUyTh8ud85fkeUmMpWI+ivj0EbAikyZz7/9Owjl68BVQzHIp273/uCFVmQFGFF/L/Kl0oY72Q9368wxcjW0+vaCZ5l4YpC1kqAw1fJ0iKgB0rBwKGbpbPnkOWkLpp/j8xqdIoz9k7mGfSJGC4n7utdvS74wndYBAJjFRzEriqftHYhNowy0dFgf8GxR8BFTKMKy0o3p3/H2mJh5pBCpFEV/CU9plMUNXBJLWekkniu/l1lWYk7FNJ90LK55OHPSNainevVyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8GBidinbtzXAIjgljHCT17wyCJwNy9Ed5FVcOEWmDg=;
 b=GBT2LGnQ3071ymyGlHdvB8aKyv3rEpGOOyGbJbAzg/glpR0zk7lke3bV5DRqZpCY9QN/KsKSJxQO/SiU1DqPthRcTZoSGF4lWZ5SZG9Qn203rY+XLJGGxqqF6TB72NtZWnhEy9wAV0W2RKNkTmPt9roGdFE8NXScwnKLfIIFVb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5370.namprd13.prod.outlook.com (2603:10b6:303:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 10 May
 2023 09:17:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:17:39 +0000
Date: Wed, 10 May 2023 11:17:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ziwei Xiao <ziweixiao@google.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	Bailey Forrest <bcf@google.com>
Subject: Re: [PATCH net] gve: Remove the code of clearing PBA bit
Message-ID: <ZFthLm68Ho6PH6qk@corigine.com>
References: <20230509225123.11401-1-ziweixiao@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509225123.11401-1-ziweixiao@google.com>
X-ClientProxiedBy: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e2f4b26-fffe-4d28-cb64-08db513766e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KS/GJ8Wr2ek00xTrhuO1Plx2HCy+5YwU+0PDh1M56HwgpXQKJENU4GiRoduMuEWQyySW76XrOXGm1DR8B03iMKy4KLlS8ZFHAVJofvtAee71QLktqAwflwyn14NIww219AV1AQtMh0YM8a/BwkbK4vpiTYMCZ2RC3Y6TUI6iCC0lihMsubdZzA87bImAo9fmT/qx/8rojAhoA/e2vxlzSPfKRmE7HQmoEKoq72q9chrk1MhtbRNRrVUoOpTbBWMhwdAUzTDqcApxjSRL/R7LrKrlXs1tDsfh26BFSanxyKmfX+9t3wyGnSCchQa1ehCRzO7S9mXv6p0sd57DAPzCpS/51tZTdsaFCu4ewJjHwT5lr1SrOE9M/kOPecHmJxb/YI/guX4A+76caEGvOXjbWsN2fLUTLubGL1SoFgskEtHCTjnsISNMOFp658zV2PzedLfZhs8FhHpMa25D5ThtOe+B1rj62h+nD1mGqJ1bh5bx/p5aTuhQLl1YIgD34hgkMQb7KQQFyJLC/A9BelBGZnWAeanUxNxTxK6AiQGll/NEI3dKVqD9zD2cYG73Ga18IasyhcGg4fS+X8ICQ9D7SQqAjqCmsrMMY3IwPQpqRiQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(366004)(396003)(376002)(451199021)(186003)(4744005)(6506007)(6512007)(2906002)(2616005)(6486002)(36756003)(5660300002)(8936002)(8676002)(6666004)(66946007)(316002)(478600001)(4326008)(86362001)(66556008)(66476007)(6916009)(41300700001)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BvMoq7KYwa7Z6y7bwZ6mIrTuJ5PgeTkjf185gykQVW1ZbvBUSfHArE2A/EJa?=
 =?us-ascii?Q?4mKy/BN0tQ46K9r2mLh9K0mpM3y24md6tHTlO6aaGGS5rcfEuztuLt50sGU0?=
 =?us-ascii?Q?cUmQjLKLvmWUXmA2hT00b94i+qHKPlZcF9Oq0H0LqNjkQo0v/0fSwcePS77j?=
 =?us-ascii?Q?uqZDeh9OvyJktFVi7bN0SWfdrQkRZTxlB3O5SKxwjhgLFtYNtTCYgGviQj9O?=
 =?us-ascii?Q?X+QW6Q+hWpFVwxPIv23t7fZw1afEKsM47z6hLOMs/2TpYdUXy0MljkeYD4oG?=
 =?us-ascii?Q?Ibhhpo6xCGC9ItozFEPffmMfdDYM78XfxwIGZkK1hXpMXGzpMkXc0gwd47iw?=
 =?us-ascii?Q?BTHHsPaQ+ZMNGufYNQ0RUbnvIDh+t0meHVBW/ukLo6Pv2h17uvriTeghSmvB?=
 =?us-ascii?Q?De9xtPcshhvJ59evpZSxbfHZtfQZZ8TkaP3aA4oKrUn30Pts3BezNKlhiTtS?=
 =?us-ascii?Q?+ATV8MczyXj0G+awJyYbKqGeah5dAOAOcpUOmTREwD7FgC3jsNp6FgnrUKzU?=
 =?us-ascii?Q?lhQ0k8EwP+w0jmz5FfWsjOPCZmAPryvGiRx7HeAS4sUIa07ZDcAO4BuflymJ?=
 =?us-ascii?Q?q34tRBSyZ72oLgo5w++qGaf8D0YDBZGXVGNwAna6zRqmepnLsjHscXzMMVSh?=
 =?us-ascii?Q?06LH5vbyrUE53UzUI9QqpSMFU+ahpa5GTIZYcUtnbuXYybLvKwsddvl3QGEk?=
 =?us-ascii?Q?yxFbTbcgapq56heVRBuJv+L4TkHYzsLn63POiWztUddWbcrpkIimJ7r7tVEu?=
 =?us-ascii?Q?kOLuStZ4574idFW6qGGaE49OShbTTsFXza1mUwWuf99LUDEoXPHSjgij1C6M?=
 =?us-ascii?Q?IHxUlUyHkHUptPZOVroTQRN5kHq7BrCAh/9kO8EV3tbUQLzI5OZcdKYuOwdm?=
 =?us-ascii?Q?RW0u/KrbxKI0PseT4d1s4fpLQmOXdEoM/9XibY5MqGgLZZx0hQV7OJuXakEO?=
 =?us-ascii?Q?Q9pAe7Vdnj0nFOZi+tM1nQQpUKqlbZ4KnThB/hYpR/KYBTUHuBzy1PP6uG7w?=
 =?us-ascii?Q?4tvwbckeja1HBQSyfgCiF3lELIuYXbL/cKdjZwMjC1+KHh91JfkeAl9H52qz?=
 =?us-ascii?Q?dNk4dGiLSaXuiLJ2tbxt/Qmqw1ij/L3wohmevCq4fvlMyKT9bbFhDz4s3ErH?=
 =?us-ascii?Q?xM4C+F7KM3g41Jzd//xQseQ8cI633eAp8cq8EAnBXNlmIIqhXodSdq8oaCCG?=
 =?us-ascii?Q?U87BU8Q4lct0vxbiQJkqG+BCFGDroz+TDv/e5tO0XiTfv100YfP4g4b8898J?=
 =?us-ascii?Q?485lnRMJaKOW3wZgUcZRUGCLKAPuAhqErKNq+ao9xjWWwlArq8jNiayblCWe?=
 =?us-ascii?Q?o8n+lsHIlsqlKD7hJf+lQKmgBh8fZ2TPvakvj6rY417ohrTdgrfpG7uYAbbl?=
 =?us-ascii?Q?TXFvDrCTDqrJFjojmg6qCEgZGqYAcRrkpKqlJDIXioleGdpZ0ukNuZxYr6IT?=
 =?us-ascii?Q?DjkqQIVRzaotFZiLsemCKg2xvO5qYeH0+R3eKBmHsy/tM6ZvT/behuEhlVGB?=
 =?us-ascii?Q?klW1DV9+BSJAqKjzkFtJbYJDObyFqtQvMhC6WpBPu5T89s1wbpVPIcOFhFTs?=
 =?us-ascii?Q?OqjJYuQ22HN1U1NxGE2laxEpQF43FScKWBQBDASJeAIGxXq+w6se+uZ/A6vJ?=
 =?us-ascii?Q?oSatSAJDPP+pascsdYYOjybHjCsEoy25vHYI+gKxR6bW0XSs/QF8v/sv9zkY?=
 =?us-ascii?Q?iNaQAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2f4b26-fffe-4d28-cb64-08db513766e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:17:39.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8TwVcIxTEoB9koXVL7StCrAB8u6rOArrXAr5WQjPAyhhyqiyHwE/qcufX6U7ffYlufyNUpj1R0WLGngRAPVkdDIBk6fl+a4um8T282wUbgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5370
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 03:51:23PM -0700, Ziwei Xiao wrote:
> Clearing the PBA bit from the driver is race prone and it may lead to
> dropped interrupt events. This could potentially lead to the traffic
> being completely halted.
> 
> Fixes: 5e8c5adf95f8 ("gve: DQO: Add core netdev features")
> Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
> Signed-off-by: Bailey Forrest <bcf@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


