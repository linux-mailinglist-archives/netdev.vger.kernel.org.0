Return-Path: <netdev+bounces-4216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0107770BB3B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B986B280F53
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FCCBE57;
	Mon, 22 May 2023 11:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35808BE4E
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:11:10 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F4D268A;
	Mon, 22 May 2023 04:11:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WH6twpsz55igOizEQGC/q3TdO18dgzbkFWOKday3u4nzh60e1+pqaM/7EyMBn4pLcJLduoOTDMmLhRho6SQ1neLXjpZMfrRssV1hzTTp2OvjdbypAajYQKLM/4JQf4lm5MN5GMK3wMwF9EPKJ5AejrF6i/WOUxgRzTNbYkki3un+qjp5OcwhnyUMXsEwHbNKwtkXumjmu+ws31418uFFdTQ6T6KmJWeR40VcTyUSt+2cQ03d/FQqYA9GYojj5MTONAmOD2w2RKsFSvayk3pBxbqjGHYEloyASYqsPFXJ1WB9HFLH4nNoDU/utFX4/WUA8FfiAzQC6WTj+pEHDCjPYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yk1GrI3tu9pj4L7Lu+3JkZc2w7wCCW+Wj///DxtWro=;
 b=IUOaN6lIJ+P3WqodVwNDRyJx9qAjwrQtT2s82SXqVil6tGHCYmXk1FGNeEZ96jtdRwB/8RAuIylgUUoqKuIKaOepUEU+oy/QHlLH3W3H2ftAzJ+3u+BBRIbwaVUhXXMDNbNF56sB/HccMd22cSYv5oBYfaKvvD9ZX8ORUOddT3kZBs+h0nIPy367Yvri84oZ8L5IzSsvS138R8Jt1NJFJQzg6m5eOIuksqVwLr0uJDurdHH689m3i+1Wwa9gfG0yg5P6HaSrYARPDqAbhfnMYL7Ggm7BTKD9XvQNtCHcxqeKIkkOOwBsgALBF1n9HS77d3gFdFbn+jGz7Bs0YdLqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yk1GrI3tu9pj4L7Lu+3JkZc2w7wCCW+Wj///DxtWro=;
 b=bFXsLvh407nYoEpHi21AZAqVmHc58Dt29vFP2DnYj7sNhj4DgLAASEVGfcvgXtDcVXx/+S5T03nLAdgJ8d5rgEojSmo0pa67rp/fW65RVziu/RzEGAW5myXV62LipXj/4w+izllDL1ghHzbipkeUNUHcfY+GlAKGqwjce+fDbEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5965.namprd13.prod.outlook.com (2603:10b6:a03:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Mon, 22 May
 2023 11:11:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 11:11:02 +0000
Date: Mon, 22 May 2023 13:10:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rain River <rain.1986.08.12@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] forcedeth: Fix an error handling path in nv_probe()
Message-ID: <ZGtNwCc8ogSlwtYV@corigine.com>
References: <355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr>
 <ZGtAIJZ3QzkBJgHI@corigine.com>
 <f4296d23-83ce-4147-894a-3e5640cdf87c@kili.mountain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4296d23-83ce-4147-894a-3e5640cdf87c@kili.mountain>
X-ClientProxiedBy: AS4P190CA0048.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c28aa5-58d6-4063-8bd8-08db5ab53ae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8zTy6ptM2s0OnoM+ukudaZLhkh3theM38PULfkXY1/0ilMJy+LTx6ZmyVpY4v9D6YptmE7SW24Kv/PtwuzvRjv4oZSL5356Njwyoax9OH5Jkil4mxKQ5Sm59ZVPCQDAXIRzfZE8t7MLVg16HRj3/yGNGIaVnld4Zm/ujdD2AvGqB+Mbznp4vvd8CUOlfwZvZ00ToEl5O3Z7I13Mtd9yNaGUYlTUv77I4vmG4X88wCuCAVnAJ/h6t3bX0Xh4MnTcdu0PE+2+gByDyD8Dki1MZ/8VpL1sWWUFjFPz6Mc6ZF2Xl8Mx0SlI5JcHo6w/d8d1VR3r33aeYtUMck5vcsIl1yHwT6Ju/DfTXUszMlJ6orn4rg1iPERvKX7vBEWzsGLoLTPqArXGWyRhwscCuMl0bpOfAC3AV9IOFJ1TGkI3EaZkK/bWgys68IXdb9wo5bb+hA4xG8oCj3nsxFP8bBc3uEU/M8hDZALynqTO8HIhtBlgdKsT2lpNoXlir+z9dM3JEuYE4w8GBlFvm/Nb+RubIFM10HXqI0z6zbuYHn1FiDKj5Z3q5K1fQKV/hkKxRtHIv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(346002)(366004)(376002)(396003)(451199021)(6486002)(6666004)(86362001)(316002)(54906003)(41300700001)(66946007)(4326008)(66476007)(66556008)(6916009)(478600001)(8676002)(8936002)(5660300002)(38100700002)(7416002)(83380400001)(36756003)(44832011)(2616005)(2906002)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z5xbgIPO2ZzGTM8bfqj3zR116YajwvtqTX/clkVtAsAlPFVHHYSLbRXKYcNh?=
 =?us-ascii?Q?K65qZ6xfycmO+D5/8+PxVrrMt4hrPTkXUQkGIs3InXfq7N1qI2YvfYkilDrd?=
 =?us-ascii?Q?hMe9god/F2GUZAQa1n1pgOF4I0jeGIWR28eWDqD62+ThF+ADnMbLxDmNi1R7?=
 =?us-ascii?Q?s+11NZ14qQupyi4yzjKukEOutnHFquddFXTPMbcnAQ9awdL0ZjwlE6mSPHLt?=
 =?us-ascii?Q?+/7lN/upo6OCA6kUcFUlP52uOHOWQlvL4t5Iizx+EpFKZuWKL4XhyKV8KSfY?=
 =?us-ascii?Q?NH2LA85vOlri9x8twLUjQ0xeVSu+qebeSiQxvWfXukvPFshB6wZkKR86YMfQ?=
 =?us-ascii?Q?JKZuQTgmRFigzmGqtnBoBHGiJVe3ayEWi/x9M4220urZMufOsRhMiv0Qx/Sp?=
 =?us-ascii?Q?kK2BVZGdvWi7TWrFKvQ8GIt7AB6Sf3U05xMMzRyoGRoGCGERPsBG1yQ3xAzN?=
 =?us-ascii?Q?tUJvK4FQZM4hNoGJdaNJWEXITekcJw1odSIQ/WC/1fIgoOVMq2STaA21W1KC?=
 =?us-ascii?Q?diLviblinHL+N/+8jNpqh8BBCuzpJI69UnDXZjoNj43Y+BhRqYgi3lZhtv9R?=
 =?us-ascii?Q?XtsYEubngyeiVyk9JWffqHhhbyGHjnOcXpDOoCAbd1CvwOlkUBWv1uapjIws?=
 =?us-ascii?Q?IEuPq1lKIcjwfp1P8GOvnSZsuS1qB/PYnO1ScxOjgT3piBZ7UxZIDr9VJEp/?=
 =?us-ascii?Q?3+tiPm1SqsodCQP9t3c5zfnxzaxtiQk8TERdFR4Wn5o7TP7CtCdSxkSggsql?=
 =?us-ascii?Q?DG0B33MLSGQlHmsVxFJMirG4rkQ+KMw8oK5W5Yq9Mv2hpCcR0LdMXlIDLpBC?=
 =?us-ascii?Q?MiDWTqJZ0PZCV95yZa7zKiCkv+BYQ+h0FjtVQLF4AwyhrLqIwcHlZaKFRy4a?=
 =?us-ascii?Q?YAphRfOaMhWb9URQ+1pvSIvDf2fJZvCvJcNIl5JZrmlyYccaAUB/jlCuuPvX?=
 =?us-ascii?Q?uWCdHM+5LbWxnLJxBAtZ4qDgOVOEkEFAHejnIUnoU/5aiOtmsHMggc8C9Y5H?=
 =?us-ascii?Q?ET4WcHmLImNAG8am86RthtI0G+fPbbhMJWIMRBS3G0MivNlSzminxuXFJRYH?=
 =?us-ascii?Q?wcfmrdOJSLcDjPkxj+7g7CKmNa/xCskargNQ6yAJFnw2UPuFIvnDhgKAc5ls?=
 =?us-ascii?Q?9U/Ozl4ilZNS5/RnlFGYw8gByHWMujrXor/o4uqw4z/mOHp3grUc8BP0IUrm?=
 =?us-ascii?Q?H4f7Ug5mX5bYla2N1xtQ638/FoVCGNY724MOc0tdl20mp1fgueOaDNbbjDTh?=
 =?us-ascii?Q?5jELLXELx6Hl6vdJ858Mm9F45Xd0MKlf3Yz/MmU/bthmV1COMMD1scEwl1Ex?=
 =?us-ascii?Q?8r3FAoZ8WJZkolh5o6n1hJxc1VNTBsKaa9guwG1HY+/eCYhPJ0IVcdVLdccN?=
 =?us-ascii?Q?DwYFaidzqS7Nd2Xrtd7wkoqIfH8uBdv34qVj4GRHLUr1ZrO9PzJcJjUePTzB?=
 =?us-ascii?Q?QsYnZF9aq0MANFN9kWx7VNVg4nPHRdQR9JrM4qqYtrXQNOe/UrcWwV7TawAT?=
 =?us-ascii?Q?mXXT77oPjHhnaYHkQgD70V3OO4AupllH8Wo3MhFhMtS/Un34YNZBrDJ1sNEG?=
 =?us-ascii?Q?mpGNijeXCkrDi/3QRbiBlE9iz2lNCiEuEILGqscFh7IDFmVikcAVctjqygQJ?=
 =?us-ascii?Q?cVLcD0jodStYv4/xPjhpCBbDCt9n6oMkaVZfXYBcU8lksawj2uM1niP8J2ao?=
 =?us-ascii?Q?RkxwKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c28aa5-58d6-4063-8bd8-08db5ab53ae4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 11:11:02.8209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooOHL3Bt6KkU1yHOJV8+l5rO1UVmuR/W9RU7lZkGJi6wy62nkFwxYQI2neuwCyl4kWon5Prg5fsK8VPDiSugcHobK5a6Px8CriGPRxIwYYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5965
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 01:35:38PM +0300, Dan Carpenter wrote:
> On Mon, May 22, 2023 at 12:12:48PM +0200, Simon Horman wrote:
> > On Sat, May 20, 2023 at 10:30:17AM +0200, Christophe JAILLET wrote:
> > > If an error occures after calling nv_mgmt_acquire_sema(), it should be
> > > undone with a corresponding nv_mgmt_release_sema() call.
> > 
> > nit: s/occures/occurs/
> > 
> > > 
> > > Add it in the error handling path of the probe as already done in the
> > > remove function.
> > 
> > I was going to ask what happens if nv_mgmt_acquire_sema() fails.
> > Then I realised that it always returns 0.
> > 
> > Perhaps it would be worth changing it's return type to void at some point.
> >
> 
> What? No?  It returns true on success and false on failure.
> 
> drivers/net/ethernet/nvidia/forcedeth.c
>   5377  static int nv_mgmt_acquire_sema(struct net_device *dev)
>   5378  {
>   5379          struct fe_priv *np = netdev_priv(dev);
>   5380          u8 __iomem *base = get_hwbase(dev);
>   5381          int i;
>   5382          u32 tx_ctrl, mgmt_sema;
>   5383  
>   5384          for (i = 0; i < 10; i++) {
>   5385                  mgmt_sema = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_SEMA_MASK;
>   5386                  if (mgmt_sema == NVREG_XMITCTL_MGMT_SEMA_FREE)
>   5387                          break;
>   5388                  msleep(500);
>   5389          }
>   5390  
>   5391          if (mgmt_sema != NVREG_XMITCTL_MGMT_SEMA_FREE)
>   5392                  return 0;
>   5393  
>   5394          for (i = 0; i < 2; i++) {
>   5395                  tx_ctrl = readl(base + NvRegTransmitterControl);
>   5396                  tx_ctrl |= NVREG_XMITCTL_HOST_SEMA_ACQ;
>   5397                  writel(tx_ctrl, base + NvRegTransmitterControl);
>   5398  
>   5399                  /* verify that semaphore was acquired */
>   5400                  tx_ctrl = readl(base + NvRegTransmitterControl);
>   5401                  if (((tx_ctrl & NVREG_XMITCTL_HOST_SEMA_MASK) == NVREG_XMITCTL_HOST_SEMA_ACQ) &&
>   5402                      ((tx_ctrl & NVREG_XMITCTL_MGMT_SEMA_MASK) == NVREG_XMITCTL_MGMT_SEMA_FREE)) {
>   5403                          np->mgmt_sema = 1;
>   5404                          return 1;
>                                 ^^^^^^^^^
> Success path.
> 
>   5405                  } else
>   5406                          udelay(50);
>   5407          }
>   5408  
>   5409          return 0;
>   5410  }

Thanks Dan,

my eyes deceived me.

In that case, my question is: what if nv_mgmt_acquire_sema() fails?
But I think the answer is that nv_mgmt_release_sema() will do
nothing because mgmt_sema is not set.

So I think we are good.


