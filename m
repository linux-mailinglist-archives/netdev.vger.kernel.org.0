Return-Path: <netdev+bounces-7638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46245720E7A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 743DE1C2121F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21F9AD5C;
	Sat,  3 Jun 2023 07:25:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0915EA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:25:38 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2104.outbound.protection.outlook.com [40.107.92.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA986135
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:25:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrWxxuN5MotGNJKficXBSZ4FDPLe1eknJwqY3B3IXg0CEBaegYoGY2oA/EQ3WBrvAU1NFDq31VTAk0d79Lop/yYcx89rTJ8Q5XBnexhKVbE56ZlJfIc7c+MTnlRLi4N+xdNRdx8Eu1YZ5mVUSVmv1II+QLm6GOIJjYrKxtq+EVHdttfmuUl4tV3W1XHVY7TMY4OWLjOvr/VxSgTSFAAv8D69sKvbgLDk0Q9FTzLi1QOhTA4dAd4Kyhs936HJ5hct/i+8wNUECgcZt2evL8i0MtQRAxvLUaNF3Jc/f/o2ul7ClfwxMYTC7XNy3usRKctWGhGuWLh6mDq+xg5gcQSGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jot+rsOFMooEUieFev/S6XqIBNIfJccXUoRd0RrCJIM=;
 b=i5DODtD75+OpsmZn7jyhCA4fSUQnhK9Qf3ZGGohRXi9FQ7FVGl60IUxOpiyqiRTQzY1R3ok/FWsI9n3bCGQEWy1qcJaCPwp+DioHlQW+R+qwCe7iO/zTbry7riCo8ZhLw1QqJOyFWSCImqj8nQ7ARyFAgHY7r1EmUiIwfz5F4MpzTnWguePZ63ctfiqk2f4iXvmYkGr3fQtF20gX22Vb35l2M2/tp+H4bajPlchFu+sfRoNWsQp9kXzMIbXRww1zZMMG3j8TyWKVOT2Wxk7Q4HIbAgS/m88z9hAwPlqWl8em2eVBKBE1eqP7CJinSTpUAN3oJlBia68M16wsBvg+Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jot+rsOFMooEUieFev/S6XqIBNIfJccXUoRd0RrCJIM=;
 b=OOySL+GBqvLDl9cVdHk8UtKo6mgv3KpvaSWTKgqMZWE3kWKl1WR1Qi3NdUu87RwX63Uyhjd0u/qU7KVniIdd2vU7oQChGDHGJqY2s+AiWiOunBnZI6NvWtSu0W/B1MFzhhknRa/6MNN7LldD0L7VwHglbCnurhBc6u5ZC609NK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4644.namprd13.prod.outlook.com (2603:10b6:208:328::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 07:25:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 07:25:33 +0000
Date: Sat, 3 Jun 2023 09:25:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: rep, store send to vport rules per
 peer
Message-ID: <ZHrq5QjAeUjRv/yv@corigine.com>
References: <20230601060118.154015-1-saeed@kernel.org>
 <20230601060118.154015-4-saeed@kernel.org>
 <ZHoSlnSX0K4xeZOF@corigine.com>
 <ZHo5B9vhM5juCxWv@x130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHo5B9vhM5juCxWv@x130>
X-ClientProxiedBy: AM8P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4644:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f7de80-e02b-4776-50f2-08db6403b754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9okhFPwhdFfoRd3oN+KBRQceUDbwbLaA/m91ALxXI02WEaTvERKnKCKLW7tIkslB6oTg0zofr2XJxbjFLbPxjuLLp63srjE1KL9QrUHyPeYyFITVT58XgcGhFtzOrsz6CQ2IEmlL7YYdymVdItG3I6ypInK2TcdIfNglAPB1QT3VLbrgflEUte1wjAGJVlgtPXIB58ddrrvxMNoqUfdQORNSk1PWOvkcp56mJlRfhlLGplPPYcyJnC2uxQXRVcMGs0BXl51ht2xiaXuwQBsGgosIqFSmmiqmauWWuMujjHctDaQ56nYv69wkBJ9U0afmOPH72bFAtcSnYCpMRTNMPMA6HHUhovEdGx1xUUOPTUgfw23zFvQNgI9YX+K8rY8Ggro+FkEdLVPIZVnCB19ArXsVnSD/yC/9THpOkr9m2RRttcTxic3pQ+CeNA46DHJex6StEviYCjhtxa7HiTn0gQq+C1s2tEs3PwBkTLiJqEIJhtBXUSFNl3q3oWV9kAbCKWHLtnP4DxU5CwRc3yPVEjlh1OgUWjk7Rzc6XRTofkVkWiBUPAejcWNvWqbQbNFD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(376002)(346002)(136003)(451199021)(44832011)(7416002)(8676002)(8936002)(5660300002)(316002)(41300700001)(2906002)(66556008)(4326008)(66946007)(66476007)(6916009)(54906003)(6486002)(6666004)(6506007)(6512007)(26005)(186003)(36756003)(2616005)(83380400001)(478600001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LitZh2otIId9ZeqbkK6rYw3ge2n3LHsnZ9PRUsSwaDYtFCEfKNLMgV3K5TtJ?=
 =?us-ascii?Q?WDHeDi+Ck1dYa4wLCXKGCYPn8NAhVNzsuJXFXaKOyDMngBaE8Ace+iaNWfnO?=
 =?us-ascii?Q?zdYNaUpI92DAxCq1empF/3yscsjIFcnRXX28UfdzFDGRTyooX28/boV1vYYO?=
 =?us-ascii?Q?SWRsOsP3gh95fmF/ZZkhHQocL7JcmFABn2/KXw09YL2JYAxMYcqAaeLqmLl+?=
 =?us-ascii?Q?vB7fSZXxnqchL8g02W/tBLrjZQ1UrQye7YyZFXJQwvMQeWBbquEqsXfzKGOF?=
 =?us-ascii?Q?vgN+970Wr8yoDa8SY39qey4ebEoVQeJnhQUdtKm+K7vv59gnfNlUOwT7hnPa?=
 =?us-ascii?Q?cvXqaEXO15Z139fxrIYYaSwCXCm0wrjpTKUZAhonksdK5BG/QWWAxK197Avh?=
 =?us-ascii?Q?odI9dK1mugZqFbwjpeyMJfI96IguRgXSdOS+aPNjZerDAeaUgFXxlJQcq6jt?=
 =?us-ascii?Q?9GaJ6O47nvw11otqdvPoOwRS8lPepW5o9SjLDvHME964BAxvNv3BftMdVo8n?=
 =?us-ascii?Q?N1o5+P63gxm/2b3omvyNK/0RqBd8uT+Y+xwdfkwKA9RprIPUKnlPQmdQzRq4?=
 =?us-ascii?Q?NBeqcSwt6OnRONTrzmjkd+yeZ7H5r0GDrviTqpUpojJusIwmlTYuq2ptbq4u?=
 =?us-ascii?Q?b2hz9q8a8LgMFWT/aQ1MiEnbg4DqVMXXT0GamtYf4mRQrfvRaxUNHJo+FGdf?=
 =?us-ascii?Q?8WkK2Ks1OsxC7TIPRf9LXHZeqFgg3W+3s/iCh/Fq4dfiRe9c9qYxWOXpD5RN?=
 =?us-ascii?Q?K2Tb5B93TvI6FhoIDxFJGhb3kEjtRhPzRrDCBwMK8/BmyTGpFAjXEXd7Iukt?=
 =?us-ascii?Q?m+dBoIka0dxfiSXFLxhVvsg2xSz6uNWFJg+2ZRPElKGo3gagi41SG5qnmnoX?=
 =?us-ascii?Q?BlcY7NkB3vrhG5CC0xj+eM5aoTlEweispm767sJFkW5eYyCkgdzHCO2Q8aZE?=
 =?us-ascii?Q?ws4/AEErUpkFrVz1bRrO34EIa1plReudkzXpWiGOrdUMnrhijWi1jq7ZOL5m?=
 =?us-ascii?Q?imvP5Vawc0sSuoRi5GHaBnjIi16bjfzC1m1o6CVyn9MLhA4nO+KzlAr4Ivi/?=
 =?us-ascii?Q?LjlczqGXEGWkefOfBN1vabtbIdoNGksspi46T0XmAwkI1FgUuPSJAVPqknFW?=
 =?us-ascii?Q?2s0a9B8fkH4KhfywBo+K8YgnjW/bwUAKhCbZ356qNIAq7lNhAsgFP693jhO3?=
 =?us-ascii?Q?qpY3hVjaRzj9+d52qLjtlmwJi1UqoZN757mo/JmOB0J561TaqF9OSnWuP0SH?=
 =?us-ascii?Q?28pNDkYfJdXxfW9pAMLTEg07g4iLc/1iMvj0Gz6m+Ax0JvYcFZaf/rd676Hf?=
 =?us-ascii?Q?OLpHVg6h891zmLk68t57kiBVXJ68CfnEtMpBxGHVddS6XWpRD4mf1iX2WLXb?=
 =?us-ascii?Q?sTnVZ0UnlkmWc9AIIY6EI88B21Nw3eLF0Zzk3BpvhXX90GBITomZPacey0Fm?=
 =?us-ascii?Q?KEmVEgDMaHMNDkZfPlHYebYNd/t9cJqSE3NLAjB5EcHln8KOWNs908duZpWi?=
 =?us-ascii?Q?K0g3lMksFpnwKEh0rBhSVYPM79vHcQupp7Fiow/N+ff4e2opw7/QflQBMRem?=
 =?us-ascii?Q?vOnp6qGNslpc4GZLibGvkiQI465ZSuufKk2kPexF/EHzhAJFhFzJM13vtTnH?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f7de80-e02b-4776-50f2-08db6403b754
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 07:25:32.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJHYczAABGqvcGu+3DFieRp+J6lhx/o35bWFIO5Tfs3WnWE2Hn4ed0NVelUUrhtQbETPXN17Lh41F4usX75z2fEnwrH35+v77Ob0cGzpTsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4644
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 11:46:31AM -0700, Saeed Mahameed wrote:
> On 02 Jun 18:02, Simon Horman wrote:
> > On Wed, May 31, 2023 at 11:01:07PM -0700, Saeed Mahameed wrote:
> > > From: Mark Bloch <mbloch@nvidia.com>
> > > 
> > > Each representor, for each send queue, is holding a
> > > send_to_vport rule for the peer eswitch.
> > > 
> > > In order to support more than one peer, and to map between the peer
> > > rules and peer eswitches, refactor representor to hold both the peer
> > > rules and pointer to the peer eswitches.
> > > This enables mlx5 to store send_to_vport rules per peer, where each
> > > peer have dedicate index via mlx5_get_dev_index().
> > > 
> > > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> > > Signed-off-by: Shay Drory <shayd@nvidia.com>
> > > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > 
> > ...
> > 
> > > @@ -426,15 +437,24 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
> > >  		rep_sq->sqn = sqns_array[i];
> > > 
> > >  		if (peer_esw) {
> > > +			int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
> > > +
> > > +			sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
> > > +			if (!sq_peer)
> > > +				goto out_sq_peer_err;
> > 
> > Hi Mark and Saeed,
> > 
> > Jumping to out_sq_peer_err will return err.
> > But err seems to be uninitialised here.
> > 
> 
> Thanks Simon, They change this logic in a later refactoring patch:
> "net/mlx5: Devcom, introduce devcom_for_each_peer_entry" where this issue
> doesn't exist anymore, but i will fix anyway..

Thanks, much appreciated.

