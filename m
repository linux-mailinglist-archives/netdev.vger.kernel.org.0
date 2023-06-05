Return-Path: <netdev+bounces-8025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CAA722762
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C56B028120E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A951B90C;
	Mon,  5 Jun 2023 13:28:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A8134BE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:28:08 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2248812D;
	Mon,  5 Jun 2023 06:28:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=li04Q5iHRLZuyui0KAPqEE9dkBNr1HPArD78aGrecHa42j4XQGER4BhUahx+iFijzUdRIV3Dv1pX8fAUEz9R7GJqo5l+cDmDdjGjDfleU0GznQlnMTGGXBTDU7y886vvLLopEfP96emi+R6ERmbjJtgdw5+yA7d/5pY5s/NNoHHs/aPxXTSTl7OMKiJn8gRCbj723bKPkITU/pYWOxWULHAsZQTIDzN3LglG+Iq8xvJswL/ZNYdGDEdWHhjxWoyzoUkdGEbDt44YKSpiaers60snUUgAv04qQYhxfPO+iSTFsevGsXY769M0Ofvuv/rt7nHl8MwjnemAIAn5j0lZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPnH+FAuA79ba/hXAMpGfrhV9frIggEEKdLSGFTqJz0=;
 b=A3iVi4LvHaRbgFSYcXwV5kbkorDBkyIbupczheoDK3JOdxfI6gJL+7RFgg04e2QHFroPpvY/OWoiC+dPmnrt8OEt7DoVn7O7USAi/iASDmP8FyiW65YhYAipaIhCn9e5Zd1wJtEQGUFUif9gqygM21u2K+yYy6Wq/VdF8OoHugf7JVfXGWVZlmMrrRiNnk2TtZr0mlF+yGTjIgbDwgh+UMvTG4jcnhgLSsdFrDPasHqR+0b3mMb7eV5ZKxfKPaY6ffIEj9cA9TxFG3Mdf9JRhEsiDF4fhIJhlqYgoQEvRT3TGTP0CXBDVlh/i/76Pmk+FCfFbnlTNR5qfTdbEOY1Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPnH+FAuA79ba/hXAMpGfrhV9frIggEEKdLSGFTqJz0=;
 b=XW7OmpeiTuAcZsv8Dh5ojDqf8+tN+YkUxccTRsZilziVEpQXBu4iyiHeGx6MMAm983zWDnWpw+b69tIV8REkj0kAaS7krQt1kGqknVXAl6qeqse3z1nW3b4DgWbNz13aC1po8I/5OTO+aclqjAPKSI7dhs8du6ah6tNzkpjBjP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5098.namprd13.prod.outlook.com (2603:10b6:610:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 13:27:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:27:57 +0000
Date: Mon, 5 Jun 2023 15:27:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's
 relationship with its children
Message-ID: <ZH3i1hxWOuynkbxk@corigine.com>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <20230605125042.lx6ng5jcsxp625ep@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605125042.lx6ng5jcsxp625ep@skbuf>
X-ClientProxiedBy: AS4P189CA0030.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5098:EE_
X-MS-Office365-Filtering-Correlation-Id: 544b0370-653d-438b-5237-08db65c8ad1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XXGq5wxsDGglAS921gM9duQc00EvAWyScVxMc8MlAEd1andO9341ZmwLw3e9n2+ThBCrk1GBIdOUC3OucdnvCwRFu21xyaSINSyfux+S6+QlkXqkGZ1KykRLcCxzFMF3GMi4G19mPB8KzBMG5HCSSOACqTKEVfgF4ZxVXib+NYv9uMNY3r9sE7CkYrY/thZPQck27hSdkzwfLoGRJzZGd9NmZp7hMqGimRh/+m6BQPN5CEKEeuGvdHnDAYbE55qO4qtzaZo2edQ2+JsAXEKS3lR+GV24oeKsg/azvz3ADykfXYX4bNV5SnyiJHnflG5PCzworH0UDBFj+2kr4qUgpNtRqViweIHeQ90LOmLZs7mV87upJzUJbOxfx6lOSC+VkqigcB5e1lOjQVRCZ94LKpc7XXSD4dMpmFZVyqsptjHwyvD5GbR3t43nkwrD3B0VFmFec0Ikhm/IkkgmWSrZeQxmBRa4GLRV5gB7WXX8ddGrBe2bXvhTUqsVBVCYCkicS/zxCteXt/R57+oV9U+lAWX1/LMecAxS+dMFpfSKEOg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39840400004)(366004)(136003)(451199021)(54906003)(478600001)(5660300002)(8936002)(8676002)(44832011)(7416002)(36756003)(2906002)(86362001)(4326008)(6916009)(66476007)(66556008)(316002)(66946007)(38100700002)(41300700001)(83380400001)(6506007)(2616005)(6512007)(186003)(966005)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xsXJ5RrpcHwOGmQ09jPxH3iEnEy6b2KArrJtHVUERhzqHbSh6r2N3wFdqquW?=
 =?us-ascii?Q?+qLNrwabKFdegHoZf0VzgJEI63YP/4DICurIU0ZsSK6Lqkk9NTqYyl7f9ZZ4?=
 =?us-ascii?Q?mwbvtPP76/IMF+eDF0B85QXsUNkh/drZCJJnfhUtRWxqw84K3cfgaamvgw8u?=
 =?us-ascii?Q?gt/nMaGuaqA8lp0VXekpqFwZbDMJPn15f8Hs8ykxQEiPV8+Pym32W3QUlNeG?=
 =?us-ascii?Q?yyULo4pDUCrCml4ec6cSembl5zq7I4d9GsF6X69XiSGL8QGEoD+jdVwDKUbK?=
 =?us-ascii?Q?a30Vqj6zP2B7aDVc77iIVM4+UFli3sELtKyW1d2Q2gvQ9O6B54E5mqRtkZ7Q?=
 =?us-ascii?Q?X55wifohzfjDNVjDxP940ZBl26dGpVKiEOzIoHgaJINLlY3roOU4RlL8fXzB?=
 =?us-ascii?Q?YqpKzMd/cV2/k1Pb10YeD063e3e4g3XNOxT/P0KY2S0EKvJdqHFSXFQNdr5J?=
 =?us-ascii?Q?FCqLPedu3DxqIaKwfPVik/Th3BhoCe555w3096tA+EhxbaF4TeLoP6JYX+dT?=
 =?us-ascii?Q?3K7NcsgD+kPm/wvl+b+wtoFY4Uyaxr08nvGvFu5p31oB1yesoVuqlwv2RE0o?=
 =?us-ascii?Q?1opHgvwcNbLLqXXXE64SU4ZZR/MbbRg8gSXkG3S0R3nQKimvqS/WgdwaM9KF?=
 =?us-ascii?Q?S+YmQJEYmOijSW8dBFxlCwCGg9VQkNYLCWRLJIv0dCluRvxrmhLT+alV1rlc?=
 =?us-ascii?Q?YmFq7TyshBYuI+qU5b0ca29kI/SLpO+bZO9B0HQc829yjfjoDeqH5ECwh62r?=
 =?us-ascii?Q?MOD92MiE8IPQ38SWTK9z3AYpGNeXnsHcnIv/shaL9B7oOemCbQNl3PbOQ3dP?=
 =?us-ascii?Q?Sjh7XiBRQA7ENosURoOYflPdvanmmb87Ns5MXNcvNn6qsTkFLW+9aghA5hck?=
 =?us-ascii?Q?8ymu9zUQ9wOOWuKDACv6dO5vb3Xh/kKAEwAjv7aNfdo0n9l8ISIE63J7lV7G?=
 =?us-ascii?Q?HXxZqVLHW0Fxe79+9Hkw0kXlHYYJswdZ3WC8pgony2eNxrGHgNHl6ZCBJ8e3?=
 =?us-ascii?Q?83xXDb4vThTUaWk9VFBdiYNBl8xtqm/WC3a9SVw2UWcOIl3FosHDOYBQsXFg?=
 =?us-ascii?Q?rOeBZ/57K8I6NTyOfI45N7WUkmsLokvPnlfxbDwBsJfoBN1Po91amj3zW17B?=
 =?us-ascii?Q?+xlRl3JQBP9ad/ZQU4rFcYeKebBg6KHGcDRt+tnXPQASh0ivs9V96OSTi+36?=
 =?us-ascii?Q?hKAMhzvQajlws2ZaxYMWCInV/9UWnBVJyeqm0EO3t4ySyCBXyOw5ROEIIPaG?=
 =?us-ascii?Q?k/QHFWFYXlHxH6TdR7AAkFD70LE8Hhirn/MuyNDRpmDdjT6bsq3miVLSlu9j?=
 =?us-ascii?Q?2fpFst/6FMEUWoPFxKO4IHgb3eJRyVawTrG0/Rvd12K28SEIHBIpj2CrkjeM?=
 =?us-ascii?Q?Ax/urLzmheCk8ugRWTsuMRbyyhX3FOLFVmcjNLCmV4cgR/JFjPUihZU1XNqs?=
 =?us-ascii?Q?d0aYbNUvmzx95nm35nr6//TSUKE8xPeDa4Jk67dGVWpYcSvVRqPJ/fc6gGIS?=
 =?us-ascii?Q?m+rja6hPynGyzEXW3AINSYn2NDU+cjsjOk6whWnL348g4G1K7AkYq0murvsy?=
 =?us-ascii?Q?17yG+5tmfiqpaGHblIYwygvxz+vHec+l6hGbPZ6J1HyVBTBo6hd01kZqOF79?=
 =?us-ascii?Q?w+tkf0R3i0gXEoArK6arcKWb/EHAsHPLRgDVe08ATU18jKh1uQaGXxIALdvd?=
 =?us-ascii?Q?IoRg9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544b0370-653d-438b-5237-08db65c8ad1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:27:57.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvyPOLxgM9/j7KYDLtgm6IYJRW56iS+Jqo6nmy6Li5c5W26KcYgTxPeSXKslkCO+hyfVb4J2Y+AY9b17OkuKwBQRID/Ag1sAtd0+qTjCt38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5098
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:50:42PM +0300, Vladimir Oltean wrote:
> Hi,
> 
> On Fri, Jun 02, 2023 at 01:37:45PM +0300, Vladimir Oltean wrote:
> > [ Original patch set was lost due to an apparent transient problem with
> > kernel.org's DNSBL setup. This is an identical resend. ]
> > 
> > Prompted by Vinicius' request to consolidate some child Qdisc
> > dereferences in taprio:
> > https://lore.kernel.org/netdev/87edmxv7x2.fsf@intel.com/
> > 
> > I remembered that I had left some unfinished work in this Qdisc, namely
> > commit af7b29b1deaa ("Revert "net/sched: taprio: make qdisc_leaf() see
> > the per-netdev-queue pfifo child qdiscs"").
> > 
> > This patch set represents another stab at, essentially, what's in the
> > title. Not only does taprio not properly detect when it's grafted as a
> > non-root qdisc, but it also returns incorrect per-class stats.
> > Eventually, Vinicius' request is addressed too, although in a different
> > form than the one he requested (which was purely cosmetic).
> > 
> > Review from people more experienced with Qdiscs than me would be
> > appreciated. I tried my best to explain what I consider to be problems.
> > I am deliberately targeting net-next because the changes are too
> > invasive for net - they were reverted from stable once already.
> 
> I noticed that this patch set has "Changes Requested" in patchwork.
> 
> I can't completely exclude the fact that maybe someone has requested
> some changes to be made, but there is no email in my inbox to that end,
> and for that matter, neither did patchwork or the email archive process
> any responses to this thread.

I concur. Let's see if this sets set it to "Under Review".

-- 
pw-bot: under-review


