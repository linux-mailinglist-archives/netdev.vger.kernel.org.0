Return-Path: <netdev+bounces-3688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C67708543
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C90031C21077
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F26C21094;
	Thu, 18 May 2023 15:46:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E19853A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:46:17 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2109.outbound.protection.outlook.com [40.107.93.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B6D7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP0JdWTxPlvpv8Os6nNJNNUTCkZCwEi3SNrLrcZQHlR2KX16X7zdk9f5q0RbTphpsS08MHn9BUC/RDHR1++Zt8RyjvwdV1FXK0FZaERP6RHwvdVk6w1TCBNtQmKfY2/WDr1fCbgP7mEFwUQIUFyfmbxm8KoZyDgMKt6wszr/gSwirkt80bmoNKq846l0XVlLexgiQlJRoNVdpCNMM4//pYHJPaGNSm3BC+R1Jr5fyjla9E9aeMYwt29UdQpPIDlq0Vdb+tzJ9ml0h8bkxcNfjDAQ05pvwDeH+Y+MdM6MGgx1w+b2TG7raip2FcZNZS2Sfu5RWzo+pr94uVVIjpszdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQyj/U6XjC/a1UU9yEc6BaznqVt1Y0UtBk1XIaRJAPM=;
 b=kk1JLr09ca741mT0PaWuxzzbnRzI4Ha2rFQNCOVEf0vuXGejuTequujZxaEbMBKKn5QDwperQ8COMgOVpV4He7Pk+Vu1qHtFpYZouq1jExoFz3+oHs8rSSAS+72+QJU/y5V+caNPdqTVfhgGp87PoeSZpGPT7RMsbMTa3baaJpIJGJ1Bp8U59rIEgINHTRbETBXN6MwKAX5NplfIl99uRpDEpMxT+6cTE6Y8RhyNLTKXWKvL264w0An42XLPS7ZhBKaKqtRFWzdgOvkJzULFibZe11RcLjYj7/K7cM6LA5d8szn+UT8EAeg/8KJXA7HgRnBHmYQoRLl0P0pclb/tyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQyj/U6XjC/a1UU9yEc6BaznqVt1Y0UtBk1XIaRJAPM=;
 b=TMs0zYdBBbsVRe2T9gl7vr61jhPGyrz4bujyPncQl///+qiIDHEAG0Vo7o13mw58SkNItQO0HM70qcmBIK48emyuAoCWl0HSsfh0CTMMNy0uXtv5rSn7jUb0plgJtZmc+uY1aj7dWgOP7nxz8S7X4GFqGdaGI9vl26ZHwFsITGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5495.namprd13.prod.outlook.com (2603:10b6:510:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 15:46:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:46:12 +0000
Date: Thu, 18 May 2023 17:46:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 6/7] tls: rx: strp: preserve decryption status of
 skbs when needed
Message-ID: <ZGZIPuuhirQLucuf@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-7-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-7-kuba@kernel.org>
X-ClientProxiedBy: AS4P250CA0005.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5495:EE_
X-MS-Office365-Filtering-Correlation-Id: 019751fe-6546-4a8c-6118-08db57b701ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hpdTX8IvAFMswKKDEkAzwdT0VHlu3cPqqVKyPSEm8haMXCw/6aNBdv9XLfc5IrN8JZwWP53D48s7S24ylx0iVjMMYzAlDk6YD+wvkYO2241LuqfTke63kb45ClsyO88F/3AUTLQ5YeJhyyPeDYmy9XJkdPcNs1HaJ4D+dRXKWwCaqZgM6uYc9ev29OvJpzzrCGtroYx/jO7LvWBPVz4EC64rxI8sb0GiRe7Y4eCw7L/5SthbKMzp7C94AcJTrl3n4LFiaYz5/SOYoy12Zd3fhkDwplwUIx2kaS/DA1hEhradAbrvcsAI9cosE3jvIIuLhJnxzzYsYiInRrkUM1z5J+Qsv5HVb9/4I3SyZUYz2oZLD7Iv7KKtkQtIfpbLQfU4PiFyGMmL1ksvnMtxKrZHFQQp8BpG8MToHEVHLECkzK6z3/OOxEyYN99kLv4OZ3wBVRfjc2W2o10yspZ81DlxsQb0BNYFLN73+gYz9O4tGSAuiCK5KgRT1jEXN6YqvDCP56s76A7dl7a4vwHNEv7hc7GP+4ioCjEmCfHTWsG9ymYegfRpHJGc//Ag7DjG4YfR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(376002)(396003)(366004)(451199021)(66476007)(38100700002)(66556008)(66946007)(316002)(4326008)(6916009)(44832011)(5660300002)(6512007)(8676002)(36756003)(186003)(8936002)(6506007)(83380400001)(2616005)(86362001)(2906002)(41300700001)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?upzCJ+coICMv4s7+rVNj4oTL2ekJ0ZRhSZLKbvfjt7kGBwV5GC2JZ0uGf6Ja?=
 =?us-ascii?Q?nWdb3U+XWNiyKyyi36efMKMUCvPONcVX34hBpAx2ZWC63NrQob0Vzzu0WCk3?=
 =?us-ascii?Q?AWF1fWFjrCzty3VQps42+W+98R4iRStGCMVKCBoYiyOcqb2T2lrNWds1qekZ?=
 =?us-ascii?Q?AB9871W4Lzw340+Ee2AdJy4xukzPmQoWVF3078LYclviXOKGdn/gnegkroee?=
 =?us-ascii?Q?xRc/Iezw/nqtaTut58sFqBtjhezmj5GUeSRS7X4Y0sQw8nH+Z3+hnBrgMD6R?=
 =?us-ascii?Q?2TcUUgfJXwkUhWa5R5K/Qbz7tfJTThOMyeDtxgwB05YjdUnvqdb5Zr2gCBa1?=
 =?us-ascii?Q?dmj+sIKZ3cuc4VVf8rs4ygrOs09q3P25t91K/xiEkW2Q2W00c7K2zkoslfow?=
 =?us-ascii?Q?l1q/KGXHEHEX8mf8v6rU9f9nruynboxBzvK0UJuLEhZATdgTP6aBRsRFMQrk?=
 =?us-ascii?Q?DtLzUZMx3HyDjnjaIrSL06z52SaQZ9LP5tVFFZ3Hg1wqft2eomjzfJpE0sv7?=
 =?us-ascii?Q?KKbcB8MDFP7m56gFsgPIdb53u4bN1Br0QJm4v9TFbbPTv6go+drxaqb+3n/M?=
 =?us-ascii?Q?H0+Vj87wXUctrfItYNB7/Rdm2znuDwlXvr1KYHCowfYXjnNIIh0qgNsRCQ6q?=
 =?us-ascii?Q?KXDXiSs7PAUSyQCzIldKjcm/jZXObMA4uivYtusYBHkpOmxARbHa4fbk5zk9?=
 =?us-ascii?Q?sUq5FzX1W9qD37ZkbMYkjDKbT1TZlcSktJTHogtJs1z/z+5il7KUwleYow+t?=
 =?us-ascii?Q?58tZBBPjzv6tpYV/punHYzqWy5m3ymxZsPtu1SSQQsC4rV0z1IeFh3wjSACv?=
 =?us-ascii?Q?AFQwGPDIBYheK7gbCe/4ccboGb1v6UIIgBqhylek4TwtTEUiK5TR7aOHrn9B?=
 =?us-ascii?Q?rqT8SskP3P/tjqzCqZHSihVCuR51QNIPRcWot5H+QOybZG0qdKUZEFv727Lg?=
 =?us-ascii?Q?kyNET6+ntQgx/hTAKc2xvrJ7sinpfSwg5klxMsOW80AbqvtBsi07R8SGhizQ?=
 =?us-ascii?Q?DsGYsDdfUcUjouHmQLo3GIjMT3imx1Whuzhb2zxM0zPjMQurJ0BPDq5D3F2F?=
 =?us-ascii?Q?qfa/FYaPAG4Y5zk8CkQS9IRvcudgt0MYUp3XYClZdkfNaSz4EqR8TwfwRhKn?=
 =?us-ascii?Q?ZBwNvYQe9XePqOuRUBHekiYDS3YgEnYQDC8yoLyGCcUGqjAcnvkryA/w/k/Y?=
 =?us-ascii?Q?e0oZGb/BSMqAfvMWrnJjmwQSPKVLueEViw3ExJJcVrtVu44TIRXQd1gZ/0DS?=
 =?us-ascii?Q?Sw9XPbUtTZvv8UW83x3eq1QAtsVYYoSiFcmStlFHWV+Vp/Tyit0Ie6KU7P7H?=
 =?us-ascii?Q?RtNAMzg0i3SVkPZm4uWR4c3tBxXZ9UejNAr1SJjKr9upwbS/CoaAgUg57c8l?=
 =?us-ascii?Q?jCuGmFb07RLyJHpwu4DkjamJcDQJ/fT+0AXD97Gag0dyqujHUAOu8YBOtD5M?=
 =?us-ascii?Q?br8AI0cJV6CIr9ipXVUZX65f3gsY8ZYlg8M1S1QVcMUqHH60V5BZFYEXYMhc?=
 =?us-ascii?Q?zqi4cUYwdlEkmcAS2dgsspyQA+f0iaPVSYYH27IA3IUO44e9uol2/Q2EjJMZ?=
 =?us-ascii?Q?O8vq/rgyUExq5J9OYsr2/39BO75w8PEzJJer2OuK5TOH45WjXBErMMLCmUqb?=
 =?us-ascii?Q?euOSyJgZ7idsREkoaLo9Ib+a6Puzyc/DNlvfQiemCGnbun/nKrrvx8MzxOi7?=
 =?us-ascii?Q?nvchHA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019751fe-6546-4a8c-6118-08db57b701ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:46:12.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+0A5lXv5lKgwDQuPuVZiyIBV6OjbMC4yhusm2WVyJbc70lpB12GZxIWdJocLkZSCW7U5P3WWjcOHwcNoAOf756PVP039UrkXhYz7YFbtHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5495
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:41PM -0700, Jakub Kicinski wrote:
> When receive buffer is small we try to copy out the data from
> TCP into a skb maintained by TLS to prevent connection from
> stalling. Unfortunately if a single record is made up of a mix
> of decrypted and non-decrypted skbs combining them into a single
> skb leads to loss of decryption status, resulting in decryption
> errors or data corruption.
> 
> Similarly when trying to use TCP receive queue directly we need
> to make sure that all the skbs within the record have the same
> status. If we don't the mixed status will be detected correctly
> but we'll CoW the anchor, again collapsing it into a single paged
> skb without decrypted status preserved. So the "fixup" code will
> not know which parts of skb to re-encrypt.
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


