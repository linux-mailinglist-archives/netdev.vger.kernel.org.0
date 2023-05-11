Return-Path: <netdev+bounces-1765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E22C16FF167
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A1A91C20F17
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D730F19E4A;
	Thu, 11 May 2023 12:19:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C865B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:19:10 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2123.outbound.protection.outlook.com [40.107.92.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2A530D8
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:19:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tx4Zyz3SugMbiaeo+G6B5AhnFwGK79rfYTxkNc9QJUE5lZWzq8dEc82rSlPvsl9jGg+oC3UfIXsfgS5TMnXUkX30NvKOD2R9+hmmhuVd2/EopxZwRhjdQsk5F+gL4l3VraLT2UaJEPoJKNqvb0VdTH7AYL4cXEKswM/JiYv6heddHDu+VgcMc61D4rDyBsPKz2Rt42zQ6VLVWTEMG4Pf22kpuswUcmN6sXK5+3DyIHpMK+Kfbz6vb+wSzMaYekmZPwuRT0VMH8Xbym5pQRwM0BpTu2DMDsDZOR8b6BmaGw3Tb9LvdUTl5c4B8RWi0PWJjW9gQQ3wGCqoF6lkATZj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOqhFCKtomXI+36Hwt7K6a5osO0/jX6lwC9asfIdnTY=;
 b=XoUjq+HcwROfvFxxgjzo0FthWpdMCHvruqoVAeUsJrGH76CwrSk7Z1cpIzcBnMnBKAm89pEB4+SSWTWOd8SmkPwoAd983raPAx+WMWqoJ++SMwe/0x5S03YoVFQL3slMEraousFDO0mwhzviUm9wgApd7o2WOwsSgplyQHY8ohJL26rOEEv3xEETwWV90jKT1jgVMRKTkwdzXY17x1bCztC+QARRcrREerY23mQwwjuPnkkTGVvoKSc7grYOWJLN5lrmrBv3urmcpc3X12hBmXaBHgHveyVompz8TMEjKl/ixV2V5R4ztdvqPz4D0hT0acsCBPoCF8PZPDa1Asfsmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOqhFCKtomXI+36Hwt7K6a5osO0/jX6lwC9asfIdnTY=;
 b=iz5Q0ltlloYwIFRw+TsIvnDK4tPQRXOlUndc3/rY8DMCYBdy3TrCT9nlzsEDW9a+bH8/FiwqDS5S7Uw2/PxvT1mbvklyWTHlpkDViJZNLXydZLvreSSva/ITg1UsNdNSOTULw5ShtxrgcdkjjkAGvpvCE0ZbPsOoWEHUuaWitlw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6530.namprd13.prod.outlook.com (2603:10b6:a03:56f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.7; Thu, 11 May
 2023 12:19:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:19:04 +0000
Date: Thu, 11 May 2023 14:18:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, jacob.e.keller@intel.com,
	saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <ZFzdMsyV0wzLmEa8@corigine.com>
References: <20230510144621.932017-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510144621.932017-1-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR10CA0003.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: c174ef5f-a0b7-4ed0-ce40-08db5219e976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EdIADEAI0SpwW5rK87zzIaYDIk5JmiO2StLspvhA0w2D/nAYE1pWjF3VZaXDPcOPdl4z7HBv3r84G2XN6FfxOXgRyHwGMLDiHyWg3/xNwr/sW8YwSuBygGgczBlTRhU95lRy8v20uc2WPnLEOaYNAuWHj2Roapkc7JoR6g+hsy0HPwzG2EqBQyZgr5eWfdLLEzzi82FVRMKTZrTQm/7HfoDUoGqKt+a2wb6Z3iF4B6B01pIcSImU8EpdzTuPgrzJkPPNWp+RttF80FytTyzyDSDx/tmSqMiRXWDK5YwfOfKOX+LndZv5zCjEqG12jYSEoULbvUVRtg/AOhQKQo6ul8b3P6agtyW4hwNFVvWryqL9f6neOaJfznzWclR9XQL+txKKPkSGSjQnWs7FX2VvAdqxKShyScuVA5ZUvZhtnZ4FKXHnZJklFig7w62DohdEukmU0NruFcAqZhhflGpTZlgc00WaHMpE/V7SBbYlmh2/fCKb2UGwQHyn+v9LXHjoJFcCsGqqt+JCpwKjCY8Risi0QtbjcUqJtghzbroK2WyuWtcedbA9Nb1fXbzz+VPPkVCGtfPZVViWWzCHPEi0lPZk6ECt32I6iavuNMGd5+w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(39840400004)(136003)(451199021)(44832011)(5660300002)(8936002)(8676002)(83380400001)(2616005)(2906002)(186003)(36756003)(38100700002)(86362001)(6506007)(6512007)(316002)(66946007)(478600001)(66556008)(6916009)(4326008)(66476007)(6666004)(6486002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iu4i37fSJxGBTRVTwnQUnWtGauDv+pT58awYUE9q+RDIPJNKdiFNl7amP32F?=
 =?us-ascii?Q?aUzgnjx4QABy1ZcyakW4ZwsicT/zPsiEWxu2g16dO7lg0Cb5pYCc5t0hckwG?=
 =?us-ascii?Q?9U9WlOvOho4tjX6WvHwJRV4UDdBun/XnYvPEJEBLvk7gc7G41RP3AHu/7IIm?=
 =?us-ascii?Q?0LoKV6LkxtJr9/YIS01KqTmdBqPBCPh1aOeE61/N0tqLiWW2PiRPhRTAo1Ui?=
 =?us-ascii?Q?ybod4kFBWi42nHvEpq0OsgpdMpwMUNqMPOBvcRIkAnzHS7TWrMPwcWaSUHOL?=
 =?us-ascii?Q?cK/ZIFoezxBB5j+Y/0lcgUnjTUoTKBmiOBaK61fgeXxm1Nrb5tNAF4/xHhhi?=
 =?us-ascii?Q?S0WoK0Lbm72sTJjLcxLoJcdioy2Swn5/zWEbrAzTBeAFFa3IdjbVpWLkRe6/?=
 =?us-ascii?Q?emXKJgS2R81tOoA9l7ATFFtzgNOENbjnJ50zuE7iD1OP86jVXXpRFiMUAPOW?=
 =?us-ascii?Q?xwUfWpYVDMfbch/rXw1HqEa2WrnalKRbkh9GctGXqMhEaImq5chW8IZBwn/o?=
 =?us-ascii?Q?NGdMIlFaU9YOLIln8JrrWAYsYKQRudmq+FXMI/mA/pnwOas5RX9rXfyz8LMM?=
 =?us-ascii?Q?yenJeV1GwIAIs9iGTe8/neCks2XZmw//XCNavJnzXMI0KRhfKc1zaDGkM+91?=
 =?us-ascii?Q?7sanWEME4I+gfGoqM26779pPHOCPyi0DAKiAC5rBuKiraUax/48+AOOOP9s0?=
 =?us-ascii?Q?ClcTw8xWMYNubImxpJJw5UZY/3fy0wvHrSjkPYOMMpg2XxnpXUQbl9AI+rYI?=
 =?us-ascii?Q?pKFy5PugLvdAeeL5MUh3TKta8UnFlBeBeZJrHiGl7GgBQgim0sLfjbt+W+KJ?=
 =?us-ascii?Q?I1tPVquLmUMUZ2q3Q0u3JOuqNDqtotFnolaR897Q8kEYMd0TndsAVnvKefAH?=
 =?us-ascii?Q?xCQNpsyevAQYhZ36z8sQOTLlR6fcCQJU95tzjqBrjX/tPaJWdckW4LThl4oq?=
 =?us-ascii?Q?YJPVNVMGeuZ7TTubABcUSFlE2brPVdiVta/Kp5Rn1qXBRA+LjP2VUUNSzbja?=
 =?us-ascii?Q?26pME1fV9s8uS8ckCZENuN5TDxHoXdbXZJR69PfQExNKH7oIiRWmX06QyPMW?=
 =?us-ascii?Q?6ua6828hl8KCduVV6rcRbJLr4tad/VDxdoUpG/SqlasBtubk4H6ZoXszYpZ+?=
 =?us-ascii?Q?uBFJMbCXfjk0rFPh3DU/ZGK5iamY++g2Z2ZvYcsqeswKrMbzUHhjRi4355i0?=
 =?us-ascii?Q?YsM+1qWX5+77mQl277zqhH0DMRtb9jAzsMpMzTEuZv0HqzaoDU5NnlU55jVU?=
 =?us-ascii?Q?hlq2GSIFEjU0Qd+kWo+kT1+Bdp9UBoEY1E8ek6Cpd9AbHQ03pmKR/oACCdgm?=
 =?us-ascii?Q?ywhqke8dugClDvlbNQEWoRhOOXUTkaae8zmwj4SEZ4y52Ed7svi6s3LfHmnf?=
 =?us-ascii?Q?8++PfTgPaBXEzV2Q56D57Fn5NMcLrpGdyrkkYYL59paaDhssBvC/nh/IGsrs?=
 =?us-ascii?Q?p+YCasMC5woc1bWy8m74HCIY66No7COHzWh+7RDm1reL3RlZJsGXojmtL3+d?=
 =?us-ascii?Q?ClemhktbTWTblu5GUg4xqrL4XMHQ3+s/mgF0ITkHsIedlGlkmJm2aNxRd47e?=
 =?us-ascii?Q?MA2YSdaiiyyQvLHjgAcnBFDHZszHb+ge1DJn4g+J+6IOFTBmRxjWgB9qTWmV?=
 =?us-ascii?Q?VDxYcRbqwYDuC5+/RJdOCKUSOFHcnoIXO/yd4G7TixX58TW2o4uvgALyu1yH?=
 =?us-ascii?Q?AHB5Nw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c174ef5f-a0b7-4ed0-ce40-08db5219e976
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:19:04.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u18paJ1VvYSnLkmrzn7DcmMIpdYqF3eUiFO3owlLWAHI+jxU6EhxRC0ynX8G7unHDKEVcbV7uB+D9w31T/AHb874GN1ttP0qcZsve+vTHj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6530
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 04:46:21PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be
> per-devlink instance. That fixed the issue of non-receiving events
> of netdev uninit if that moved to a different namespace.
> That worked fine in -net tree.
> 
> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
> separate devlink instance for ethernet auxiliary device") and
> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
> case of PCI device suspend") were merged, a deadlock was introduced
> when removing a namespace with devlink instance with another nested
> instance.
> 
> Here there is the bad flow example resulting in deadlock with mlx5:
> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
> devlink_pernet_pre_exit() -> devlink_reload() ->
> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
> mlx5e_destroy_devlink() -> devlink_free() ->
> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
> 
> Steps to reproduce:
> $ modprobe mlx5_core
> $ ip netns add ns1
> $ devlink dev reload pci/0000:08:00.0 netns ns1
> $ ip netns del ns1
> 
> Resolve this by converting the notifier from per-devlink instance to
> a static one registered during init phase and leaving it registered
> forever. Use this notifier for all devlink port instances created
> later on.
> 
> Note what a tree needs this fix only in case all of the cited fixes
> commits are present.
> 
> Reported-by: Moshe Shemesh <moshe@nvidia.com>
> Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
> Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
> Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


