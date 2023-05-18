Return-Path: <netdev+bounces-3679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F238708535
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 430A11C21067
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4A32107F;
	Thu, 18 May 2023 15:42:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC253A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:42:57 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2116.outbound.protection.outlook.com [40.107.95.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1FB9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnaTbX+88yCw2opFvjd6/wnyOQUcyhVavPHGCCVax/r4M8fCOClfGjLr7dop5cTiwQkUZEUx7nNGJuk/O0kvIjruTZcOOpDen2HLp3an9cIa+FXTP5+UoFnnT2zi6HWcdX4S4olCMJm23ZmUjmbDf8Xqvzh71dgK8JyeE9NDzQndH4Das7P8OI13VbkImmROxhn50OHt74rj0vhkFuUooUvSh02HqOu2js9P6rL4PEJbnaDk8txZ5eitgg9lVG6UnKuY1A9p4fMiHsKhzRPzWHpXS0pQDjzYHf9vhgOGWhUqK8/qMBsR+RgHOprE0Q2ezd/oAE1lIPxcHFYRZFfYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JqCKzI9ufcsldFowvoHmyhi7YmpsHbxK5eXvg/AQ6M=;
 b=RmanMV5wUsSRa8rrTUKNlRZ64q7tm0cC5d7lLbVKCyh32Q2epbP3r6Qv7c5zVLQkIuX+uMCGNcAd34P1zSaNs8Yfi0TsTyps0dqQhwmVO/CI7H4IBy0XUir87C+XbXKMORe3lF5fGwdivx9oML2Lo+nNEbO2WGA5ctrFvWLQgeDkx6vjg2ea3JFS7cM6tLtK0ussl5CaUJBXPd2/e09HnvjIdKxtajNgo7tnS558f3HYO8bEu5l8yZsDNy/gc4Hv/IsVUl7nl/ujzmtxij2xoedVucRnym5T4dIH+yeVgTWwN2uuXyrfTMSrLDoMKQoC5SkuJfuQqYRhWTaC99VJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JqCKzI9ufcsldFowvoHmyhi7YmpsHbxK5eXvg/AQ6M=;
 b=nhUFOOUcjY2J6BrUqVUJwkP1Y3yqm/nOm399hPFICenMO2QNxuyym7EcE9mG7HSU3FXKHXfQVOayTvG/UAwWrPHRIwVVQs6Op6ptRPZjqYTp0sI8k5l6dFBJDY5j0QiQfSp7DAs1/NzYy3tkjrWzgOgFxdudF1ZGow2hTMw1NHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6487.namprd13.prod.outlook.com (2603:10b6:610:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6; Thu, 18 May
 2023 15:42:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:42:48 +0000
Date: Thu, 18 May 2023 17:42:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 1/7] tls: rx: device: fix checking decryption status
Message-ID: <ZGZHcXD6IPo7ScIm@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-2-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-2-kuba@kernel.org>
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad05b8f-5fe9-418c-be07-08db57b68804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2u1m+LKkwhvahipBDCOyiBDhSlCDoMGsrV1ApZ/edaqGwCpwzrGradvZ1yT6GO2rOE3Os6GwEjzb12hJeXf8zHQqoi0MZu2AGUy362dnFUGMK3wL4y/r4vyBlps6CHZEjlJ7vmmBFImJm4zCFWLLCX+mdw5w325vb5LHrfDpsh51eOVDMSi8lIzBIrnyWZOGmU4BXI6ZQqRcOc0+K0MieOpOG7fQDESNvoRiefGcSAzq0YKt8VjEjQFQHiU+PnZVnGD+t+/E8y/HWhE2lybOFoWwDrP8Qrod+o4J3XO5cRQd13JFlJe/Md9hLQYORpIYTxh9j4Otj2xLFQKfIiK1m4Jj1ze56/7aqmoQRhdT6PCkWzDAetdg6heDWBeDokIhYd8M2kct39KXzwXGcjCGQBR9292iDiHHy5U9agl7f73LfnM5D+Ox4mKgAynGShaJ++41a6DsNCmDzCMJcteeMd4iCty5nMAYQBB3Fivi9R8o0R16gLX723IAeJGEkt5KUttIKW9PVW+pvXspIvJiyo+OsVTFZV+6UlQXuPIOJFV+EDxl/z2i81ppUZRIjZDl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(366004)(396003)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(5660300002)(44832011)(41300700001)(8676002)(8936002)(4326008)(86362001)(6916009)(66476007)(66556008)(38100700002)(66946007)(316002)(2616005)(2906002)(4744005)(36756003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AeWwy3sgGyGQUupaw94z4Q6RXzMitzdJ7vZ/2CLhKVX/5Jncrqh8brtbBhRW?=
 =?us-ascii?Q?+KUq97j8EEOZyouTJDiVQbijeKyBkh0nOIhtrq2AFbWGYTOFEAkJwY7QoWgK?=
 =?us-ascii?Q?eLdRPwBx5aqYTno9uBk/76JDw9QgQGd1YJtJgLEA7w2szuCBYJWgxFH9nZJb?=
 =?us-ascii?Q?cEiM9UaIPo30AIKbnU7JIeIPx16nwCi4LjXZjxG9TVaT2ld2882QzCwoVV58?=
 =?us-ascii?Q?FIG1+VgFLrEKIwBTeGL8+k6UiZH5dyVWUZmgeTaoDui4XiMgZEbw9GC3xCpj?=
 =?us-ascii?Q?N9kaSifFVBGDCmj2NWARbF2j8q2nVKcMMmGkAdCY6PvxyCiWZxjys82xHHT1?=
 =?us-ascii?Q?6kcGcDIqX/zWrWU0Y5wefYwBhCnJuS5eX9Ydfa4bDU+Gh/qaJ5mJi4i6Jp8q?=
 =?us-ascii?Q?y9Yp6ypOKacRVLMH+TXnYf+3udXdai2u6kGUHh8aF/IzLJjOSEmNEtAC/ir3?=
 =?us-ascii?Q?TtR34ViTjNcDidL3qCvzcTIisLqO/nbQRjkxxtDC+b8N8KXaSXAPIMOrWcxf?=
 =?us-ascii?Q?tWDtOCeOacacA6ej4hVaqFlf8oDsuMZnodHrRUXJl3MR3KVogeglyd42GpYi?=
 =?us-ascii?Q?NM5TWWwtze8AdiZpUSusbYgjy/FaKF/+wkrAGtCjsqw2JUnWRA6vLRKMyNY6?=
 =?us-ascii?Q?bjvTE/kkvjJMH+NJwqVpQRrTV6jmKRfsn1f3LzBZfgpZ9JXJME0gi4SLu3bp?=
 =?us-ascii?Q?GNM+X4Osjwsv8z2k8MmujZ1QFBrZUytIVrKnsBuoQG+Gjp3qOGLJyzhkld6l?=
 =?us-ascii?Q?ION0//FgRUW9SxBulSqOCxaf0HlsQKeCv3j+GE2459/rMnmwxxOTBAEnxvyc?=
 =?us-ascii?Q?6xGKLN5nORsj+VrbfzfeSDUKiKyxuQmw0d1uY7ecY3zOghKj/sH8XzlMoWZ7?=
 =?us-ascii?Q?9KEwnj7IekrgwAa7dWJrKaq3pvqZKRXYEvY/Yn9C2ONMTz7id/yKKa8fUzLb?=
 =?us-ascii?Q?0gTYMIyHV1Pg7pDTWEWhqxFjEvjbTp+Goco5qq71WncloWneN4FXvQT6exfr?=
 =?us-ascii?Q?LfFCBlna8CxaI4AbGKIX41VS6ietA5IzF5+iKPwVFJHK2unsw/sCOPubRr/V?=
 =?us-ascii?Q?iK5RdHgjpojKvEahGSnxVfI0XXtgz1myNLIQ+4xV2V5W9eSjXTqhES384yda?=
 =?us-ascii?Q?mfGzBuOQlHpKKnCujJbGsO7hZ9jmvZYWYWXabsJmWhUQzkonTdElLos1Rcvp?=
 =?us-ascii?Q?QF457HZ9LOLInI31/woIxj+aJxSOoDZTl5G6C15OlMDC6mRuuuYTsAZeshif?=
 =?us-ascii?Q?UxXpnTxkWLUdjsAo3DhdeVYN9xb6oOEZB5DxBxAp9usubwv33pEYJ9Eqe8NU?=
 =?us-ascii?Q?bx147aYEAs4qdxGK2hKSURWMK3RM+diM+h5s9fGUxen9X0LUKXv2nUo8RxUG?=
 =?us-ascii?Q?yGzibmUs9VQp/ahxplrtXq9ZEs9i01QUxUSrIXd5BkEQ2qM74BS3MnY8SMvP?=
 =?us-ascii?Q?uIyz65IwuirbHu0VkNS20tSWmCc5UI4d/lJbSZBJTXQMRGTjcB+PW1P5S0kk?=
 =?us-ascii?Q?MfVnzwgoOmRK6VBvMvNjkolJHNthHu7nGjHIgWyxNwhM2ZV2FrvgxPo2WYuI?=
 =?us-ascii?Q?6HWU1h/SvEJBIdPAqqv2XL4o+VKKDzbu4nyuvCd/yEaaOM820fRK66WtZgvy?=
 =?us-ascii?Q?wxMXSledxqAuUQl4OIQJXebn2d09COQ/SyBF4oIeJP/YtUUrGUIkayT2m10F?=
 =?us-ascii?Q?EK5eCA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad05b8f-5fe9-418c-be07-08db57b68804
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:42:48.6407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1GUcIBw6hEWi1uvSNsWMsNi03Pg9vvZG96kM0CSkT+ooOD5vBfEFHvSYDfN4qkCrrSjDxVDxa6Rrk5NqxUZDoAtmkcOdfABDCix9SWEBSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:36PM -0700, Jakub Kicinski wrote:
> skb->len covers the entire skb, including the frag_list.
> In fact we're guaranteed that rxm->full_len <= skb->len,
> so since the change under Fixes we were not checking decrypt
> status of any skb but the first.
> 
> Note that the skb_pagelen() added here may feel a bit costly,
> but it's removed by subsequent fixes, anyway.
> 
> Reported-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 86b259f6f888 ("tls: rx: device: bound the frag walk")
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

