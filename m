Return-Path: <netdev+bounces-8531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C541C724786
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00A38280FCF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107482DBCB;
	Tue,  6 Jun 2023 15:21:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390237B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:21:57 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0381BD
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:21:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+ewuwAx0WDJINqzYmHH9j51q8owTubGRHhiCnlV4TmA9aWqZMirKjagsub3MofgerIUBQuHp9vum8crnruRIe5vv8pjLuPxgvbbJGc5ApvPX4K6PvAfyXGHJfzkxCQs51N8lvAqk5WWf/KcXw/4WexVaKDXp43O41ZV7j0gkS19i8OCUkHfndRLM4iRcABt7BsSVTaQov0w4f4R6MIUX8faZSzCLjUGNBRNG7GJDerufbpKOtcaXuCxyTpRd3BmMHnh8kg+RnvdBYDi5m2duDzeObHHJLXAzUC9ovGxcDk3BpHntdaG0Wrl6oUeeLFi5vmiJmI0qFZyGBideGkR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1P5nLkQKz9wzN+uTy1KlS6nWvnJASwrwtGQSgvCpzKk=;
 b=HZJZzvab+apA6Hu/Dp1CFpebAgIaH/bjrAahU9unpgDiGehcyEsIKUV/i5nCg6PXyFeQgCSUQClUnnOfkkkmMs8ygk/gffzxZTfD9GUCIZf9kgGTpZpaKKjTBkgTXJ573XzqSUZmT35Eji8dmNE8464NJ+5sgQ2tVWQOOi8cIH4UiBLimZ/tz1y7SGMPJFgdXeCREPnk+5n6rYUCJCFi5tVb1xzL4YjHtyGd5ZurLOKRtvJwB6Pg+N+xRMtB63Wak2+e9P3fDSTzZodjTjO8Nnfjy4v05Ig2KIyZjBrT6wshNHkeWEApxjgHE3KWl46EccjY3ZzGIY2z00KP0l+TOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1P5nLkQKz9wzN+uTy1KlS6nWvnJASwrwtGQSgvCpzKk=;
 b=mnfu2k6k0C85Jr/t8WTBnlnA9JMC5pPD4PzizhBxxrQpyiwUrzdMJp/qPFEYlLxtdVs5OP5Bc7wOndAenDAPt6oQnuGDiqezAK59F8jPZHNw/S1QOAjnseO/3ZcUhxlgrBmyz3ybIbr3oxW6EaYyye/u+K4+b3AZDHrq6vCayq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5448.namprd13.prod.outlook.com (2603:10b6:510:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Tue, 6 Jun
 2023 15:21:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:21:52 +0000
Date: Tue, 6 Jun 2023 17:21:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] net: sched: act_police: fix sparse errors in
 tcf_police_dump()
Message-ID: <ZH9PB79LUMXLZOPR@corigine.com>
References: <20230606131304.4183359-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606131304.4183359-1-edumazet@google.com>
X-ClientProxiedBy: AS4PR09CA0030.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: d5462c08-d3f1-4a10-e20e-08db66a1c15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uuczsLRk5of9VUdS2+YkjzbIf7p8cwd0TGCnTnOcDP+thnDftgiflCF5UOfQBMlF0rnwc+Nvykp0LJwc8YVxfcAGrh405JnEDhLQPoEalm00GEh2hXHr9js/rh60axSqAHYMmH7ze/EGXQaPvi6u3Ke4VH1QcPnDK/dOF6wa90VLy3bIw7EhQDRX3PYaJBXCJsHC6ENiZwbPX7YF4vtI5YPZu73Mpro7Jwi484ThuQtLzyE4ZhKCOhsK5XxNRoGqBs63PQXvj6xPVcjgUAHXZPEnqZJ5vyyeNNYlZhK2/66BVKbvXYdPPvg5trEgsGD/mKpFfXBW7PswJAgP5Ioo8SDSE7VSivjf1nN6qf8lYAG9tr0A3/eAPvF0RTwbFd//ixRl7lw/eJOZDcUqYAxGHqwH2C+IygOLIO6jBVYs3E3Mgzf7TSPHp2mZ1eDdTuikG3aJXPunXHBsUpKs1b4qz/i4mMCaa9V6NaBxHQd7z7E1hyiaVh8a3CvGmsgdU44FkFXhMEj6GVWrdzLvnecHksQf/qMGh+dOwwZLzR2QLSquBwifeYL1x8AltXceZ+fDNBzZ1svUin2vKckyuYFGuT1f9PHomCsfgmyERiM7Yo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(376002)(346002)(136003)(451199021)(86362001)(186003)(6506007)(6512007)(33656002)(6486002)(2616005)(83380400001)(6666004)(8936002)(8676002)(5660300002)(478600001)(36756003)(54906003)(38100700002)(44832011)(2906002)(4744005)(316002)(41300700001)(4326008)(6916009)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jfoDNXyGiovfBpTBoUoPcDirzA5nD8ZGT2+QYKjf+TsNhEcaTcIzIwbrWP+n?=
 =?us-ascii?Q?DiPmWz0AR1ukJiJEhMFd2+zg5aqadyYC+NUPU7DP7w2g9fIz1UuycXSpvDKg?=
 =?us-ascii?Q?Eqi1scgSgruGQqowix5R1G+/Ns3G7Oft11LZ3smcH3Km1zpKuNlKIoj+W13U?=
 =?us-ascii?Q?SqrP8gdF8RtpncKFiCmkCWndgQ/Mmpe1OirvfItew+hIn9JGdA7KHdoU5iiF?=
 =?us-ascii?Q?Dw4zHaxKDLLYldPvFgQSxhL4B1Z6MUk+BoyfqGPjVFtqUe1xfIxIE1Vn8yua?=
 =?us-ascii?Q?dV2pPXazlXYOsZK0a53xH0ASt6fWgE0Gobyjj+Q4YIlM8PgZlkNpDeebiyol?=
 =?us-ascii?Q?Ou2u3oLIHbSEUc29YutSCeNAvfuNFGWjYDVAJiDJtcnubG3IHEtL0XvOBhXV?=
 =?us-ascii?Q?boGU4TO6UpVUJ+X7nJSAWbilE7Cm7U8CjZ1dsvdFAuFeXK9novMKFF1uL5Jc?=
 =?us-ascii?Q?GniT+Qc7SJIWi+EiSrwV8ot1MlMMqmpWImzGCfoDORmNMWfp8fQtMfY6h7uG?=
 =?us-ascii?Q?VrQoDGWqebmHZRQs1RYf7fPQzFydXe/c+a6hJMXd4KmSZ+AOJ7iUE5M0kuWI?=
 =?us-ascii?Q?xrJuBpWWJhZryzvhnby+A3sEMv172EQU/G1MNZNB7+fMHkJOLQNl6+KimMqh?=
 =?us-ascii?Q?+lIHgD383f2DediTM6sH1f6/31ZoNn2GXhlBTuhLsWbH4tySVz/cEVnZvmG0?=
 =?us-ascii?Q?Q6xmPZS/vsJJQbA9dA5CdINeHQqMJQisgfeckxeKpCAreCa1uLLXoIYdnSn4?=
 =?us-ascii?Q?BZV7Vk5sniRzXPqCq1htPf9xF0I9Xp1W6434c7Dy+VfQXbxyqFELIzRU0SsE?=
 =?us-ascii?Q?MG0Cyf9M9o7QCIVyvghmX6++wDMtlVylI4elMFIFHQuJ0/VOYrzn5Cj5wgz/?=
 =?us-ascii?Q?6l4ekiFoDK6GjRRq9QOgVHsDmhNvsoSr8VpHRse0mS77q8zB+oMfeqRw2qHL?=
 =?us-ascii?Q?hLD/pdx4AUBG9zv1XQY3zBb5H4XlmwBy0SFxOuBXlf/KK55Qb33+EnHDoAtp?=
 =?us-ascii?Q?LdaHfun0KfIjOv1uYPJsbTtLWIMI1V+sE+hB3DNjP0eYE451Flt6RFl4TZd2?=
 =?us-ascii?Q?4f9VeV5xs8xtNScku/b+zQN+vmPnfWzt5AUnIDVOQ35kk4jk5bSHmcvmCbTE?=
 =?us-ascii?Q?jgIcgJ4iYWyHie49zhPskNcn0XH90QDFwwakihnLSbJ/qjsDn2XcGRI3TAb1?=
 =?us-ascii?Q?y0FW6tRZoqEAWU6fptae4VWKVtZAQDp8/isG/y2SMevmPIDmWsZkQtJ/6Z01?=
 =?us-ascii?Q?6mhFNAYj4ZKjOKaEXRgXZorqmAC9yVv2eGogPr2mAvZBTKhEPbnMz4XME696?=
 =?us-ascii?Q?ajjfj/Tc77sOWaJIJbqqJUECkYnI4AHGBQbcJAL5In1vZdGuDThzYU6TDeww?=
 =?us-ascii?Q?gHQha4Io9LA0v9emnGJ6dvsjDTeqHR5hPqR+inhHGMBAZsxkJ6u31facke6A?=
 =?us-ascii?Q?zSFR0s3aEZ63L+JNwnYNqd73iR2sMaHuI5RTGYYmbspQ4LdHnrrqAe7wzY7b?=
 =?us-ascii?Q?AFtiVyZn84pwKzzLW/lNuDdhwrQ3cIJjdcG42XpQXX0s9Q1g2RkB0zBBwhfg?=
 =?us-ascii?Q?Kt9bnHvSyoCDRlwGkWuI/Ns6xmKvdGyIxKgwC2q4UUVJ/Klb8r1IOy6CdHh2?=
 =?us-ascii?Q?6czXQrEJHKcoALb5QMX4rr8PZBrzLYUG8wt5PVxVuKYPjlKErvVBxLwHuXae?=
 =?us-ascii?Q?FDOgfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5462c08-d3f1-4a10-e20e-08db66a1c15e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:21:52.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjYNoIGtOUET6txs2O9g/idZIEAlGS2169VVfTiaLc5KoJyEH48xHh4khPa2S+TN5iQumZRFjj3+P5CtRQj0jA48QC8epbXR377SMamlztM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 01:13:04PM +0000, Eric Dumazet wrote:
> Fixes following sparse errors:
> 
> net/sched/act_police.c:360:28: warning: dereference of noderef expression
> net/sched/act_police.c:362:45: warning: dereference of noderef expression
> net/sched/act_police.c:362:45: warning: dereference of noderef expression
> net/sched/act_police.c:368:28: warning: dereference of noderef expression
> net/sched/act_police.c:370:45: warning: dereference of noderef expression
> net/sched/act_police.c:370:45: warning: dereference of noderef expression
> net/sched/act_police.c:376:45: warning: dereference of noderef expression
> net/sched/act_police.c:376:45: warning: dereference of noderef expression
> 
> Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


