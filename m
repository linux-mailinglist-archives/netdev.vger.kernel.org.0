Return-Path: <netdev+bounces-5247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C89710663
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C985728143B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138E5BE61;
	Thu, 25 May 2023 07:36:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE759BE50;
	Thu, 25 May 2023 07:36:06 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2112.outbound.protection.outlook.com [40.107.101.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C54410D1;
	Thu, 25 May 2023 00:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqXSZLo3gkE7a3ZneiRAAdyqUFBMmQHR46/ehkkCBWy7bRa33AA3BBhWGSrdIe905jTYcXZdeWuY2csbz+oyzixJ8R185axaQAVYBOc1t3wf5uzpYwNI05hex/cjKts7YpMUUWWINCWBpri5rVxdcpCwNXnbfK6ktzOtrnLhMtwNe/BZlHF6rutovVrhpmN9Jnlv3bwZZkf2Zjygk533dGI+JrRESCRFwI0YYvYXIBed8wWjZYkE0ggDOjKWKwb3/g1GoBntMn2UczNlFtpOCzYZvnNucUPNmPGPy8YQDhUgJ3xNNbAVtkMEMIOXvv8Yp9xgyJ9AlQFuCBgMYOe28A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f73BNfGuPBchlZb7dZySCG0YOrR5MrHd/PXGNN4jMSg=;
 b=Ow56Q589u+ecfme6mtlNJG9VjtbpvhrG4ufpOScaWTuEWr1Hdp4Inz4klC1VH/Eys/23QD2rChuiQZrdR6HaNmF5FpXILVKazR6wgQlFamqA6+AZasS3ck1sY9dVRWkqtINv4f7AkphTn3AG9evxHedo6a5vgDZFDYXqZGz+WcwN19byoJQvh3+9NgT6ZQBAlEV3UthsIXAwzwM5iBsXjLQXRVj5kllu+4MtmIXsP/isvcR/FB7wTyGLe/ggMQdFRHsBq2PTtUr0EHagzwk9tKtEqAAppDhPz0v7lLc3g07+YckhCkNOORh0nbxEPWpBlkZ3q7AjedUp+Txq1A5Tvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f73BNfGuPBchlZb7dZySCG0YOrR5MrHd/PXGNN4jMSg=;
 b=aP44JBAWE+Pk6ZbJbnJTlriERYG8wSMS3aAcJG78KUXhGy1qnrtFIS1GQ8vZ8x0ft9tEEIo7L2zoO51pjUastcgeQObnCo4ZovEb6weFiM3I4paoS+Cvwr0ZRPk0btgU6xfSO2Z/vcJEemRZOg5IVNFXMHzAIXeoNEv5gbtt4/g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4119.namprd13.prod.outlook.com (2603:10b6:208:26e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 07:35:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 07:35:41 +0000
Date: Thu, 25 May 2023 09:35:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
	joabreu@synopsys.com, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
	ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@google.com,
	gerhard@engleder-embedded.com, lorenzo@kernel.org,
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: fix call trace when stmmac_xdp_xmit()
 is invoked
Message-ID: <ZG8PxFopfGikTQl4@corigine.com>
References: <20230524125714.357337-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524125714.357337-1-wei.fang@nxp.com>
X-ClientProxiedBy: AM4PR0302CA0023.eurprd03.prod.outlook.com
 (2603:10a6:205:2::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a5b3c97-24c7-4bf6-2aed-08db5cf2a414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1j+l369d7MLQ2MkWczlCwVWIOiZiWB9hUv7xeDXbKXBdhbGJnn+DcHp0JwvhTCMQr44TDBlZNk4b1gvq2IQa7H94F0+u+E+gbNHHPUloebG8uVm+rHH8pZipQqyLroCAQEeZdOletua7ObP7K0b+sQGtuz42e2oNhoQ/v5nM9qxfsHdDXUwhoxt9vIJQIW5PKGcvNNYWmb89K459ZPR2UK4ulWkGWqGH6pugG/pUR+38eGaww2p4gSwmM+DCGm6rj+Z6cCaJOiPIiQEj3bVo2G46cf1oHu7U/bHLWn+5QpMGpQjf6yBuW3GFzjkiuwLnqJcZmTc3tOZCmln+ujyjsqK+Kftoe/ecKz1nABE6W18cAX4okKG9NuecxhT1f4VldUPmc/gWnVErO4Ikokz2BHQst5anIrFlqcCr0+/UFupWVSynhX8onQI6FPFA7owF/CWW7QmLxUrg9dpVg8ga77MJ+2BIkJr/xS3fkmKIDGt5uqITWo8oJfp1kGB4gdcZUb54rVAVwhcxTUeuCJk0sPPIFR8Z3rOUWD3JjfbIt29yGhrMiCp+aHDaj6FFOrwIffPY9EP8cMBgE3UW+lEHUCNjk8hFFk2p57kKIVYyGFo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(396003)(39840400004)(451199021)(8676002)(5660300002)(7416002)(2906002)(44832011)(8936002)(316002)(66946007)(6916009)(66556008)(66476007)(4326008)(478600001)(2616005)(83380400001)(6666004)(45080400002)(186003)(6512007)(36756003)(6506007)(41300700001)(38100700002)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LqSVrANxdgniIUh4Sop8LrUAu9qCoJMFQIN4N7TPPzaU2wXGSpm6E8Kzu5fp?=
 =?us-ascii?Q?Xu8Yxnpfk6w/HGmmWIkyWkjlTZ/2903hsWdtz4yDFE9Jwgpz0tsuP4detlE6?=
 =?us-ascii?Q?9K41GNGH/BLkvbvrgDq+cpC7HD9OeaVOeZkPrOjnLd1PKTRS061vnVhm6vol?=
 =?us-ascii?Q?GwohDSrIpGMf3LA1znDUSfjlxhP32MY8wz1j4BS19XiFjEYzelW+N4I1W3o0?=
 =?us-ascii?Q?EdqoHwYXjIrozugWs7M/XQnNJ6OBaWXyMQfPJCyu2PgfXjZNHZEU+EUgkoUm?=
 =?us-ascii?Q?aqS62zCrsuTTRdKnPHfMGD+78wEj8qZuQof33nE7J7UWV0HOOT3NoAeBHEGD?=
 =?us-ascii?Q?VEPrV4gCIUHxO3PezKsRNKit0xYgvw0RDToxq5IVmlGKcfwOFANRHlGeUbMx?=
 =?us-ascii?Q?07TDi6AGYgZIvfTwdEimfAeosEp1Wd64nE886MDB9zXxQln8gZduI/qU1dZT?=
 =?us-ascii?Q?swDTj/omUXsIppSlcHR7nElwxYp1KnsVgc0suJYMVup5ulOspWHutb8IW1rx?=
 =?us-ascii?Q?Cw8/zvwstaWPVm3iOV9GQsYMuLqBEGLydJvVfAzNgAbFUrKGUwWDhkkxDzT7?=
 =?us-ascii?Q?ls9JNbhoIU8ZbZTz4QGwZzIU+lq22tTz751DbJ2JYSK9C4bTOPsIv8L/yan+?=
 =?us-ascii?Q?Txho/sI9OWnlsx7HHbaLbz6q+kZM+qbwfqccwtGUOMA+Uw3rXWd1EKwdm90p?=
 =?us-ascii?Q?h3cce+s3nsdTOKv5+99nazSSq0W4b1sovbhv2M+fFIHA8udWdyJnqCGOxSYB?=
 =?us-ascii?Q?3bM5yKyPmo/1qBnd8P+qIFGdFbm0FC+bXn89CfNqwy9fAQoQFmU6ICx6H1+y?=
 =?us-ascii?Q?pW51lM7ObbattqfC+ZiM9Fq/M3g4VLpnxk8kPjqH120ChbXxjfWfq7uuDBD+?=
 =?us-ascii?Q?MMSUB9yHKpSkRUF2eCwby5NqOlzIGkwdoTrOr9Hq875CTS5haWvX/1T2scDq?=
 =?us-ascii?Q?azFSjIBl/sL/78SLBSBn4wtiFAIf/J1R12+rzBR7w1aueNP53c+6ZImlZrl5?=
 =?us-ascii?Q?55Zemxecw1ZIGyhthNJjN4sAt9nL9Pj6/WdwmCLWjD8m4sn2Lauyn41EFAhu?=
 =?us-ascii?Q?cDqfMk9iGDhvXDP6aNDxLdBZ8yAtEw2w9XVfoMV6MgWh6ibO4FkSl1UvVUFC?=
 =?us-ascii?Q?nB4YSdxEPo7t6mtbGzG2WaucYa+VH4hGwc1ij0ykThnW8cO3PPb3p5ZeVclb?=
 =?us-ascii?Q?hT0c59NIucKo3NLFfEfnwoO4v+QMUAXRQzRznl9VM1DNZDvBhSn60V/sr/OK?=
 =?us-ascii?Q?jT+EclwmO62dT8R43wSV7YIKpY7wKIx9cBfLY1Y4x30VROK2X1CKftz3pVus?=
 =?us-ascii?Q?zZFKCUU9rzmrvXXYPhKJrLLOCsk1/48pULNJOJ/jymi0ta/6A5noXxfEdvDI?=
 =?us-ascii?Q?xvuZd8+7bRu8SbapRWPicW/HaJ+ysKYMA9vDySXVDRBmClC2JfPqKy7WZpp3?=
 =?us-ascii?Q?zYG5NbVlSsNDQ9AHVXM0i1sJ08R/TJX6Y1XzyJHFDhsf73IanmIxCWs88tNZ?=
 =?us-ascii?Q?WuG4d27V9pMoBOmR5q0w++pWEezA/h7NE3UekGxa9C4nuUWfiFSphvhs3sMC?=
 =?us-ascii?Q?XYx2+zMIi5CODAFQcA6+QGVozYtzFRJQnwK6qWVSSNQbs2ZKtC21r3YEWGBX?=
 =?us-ascii?Q?K2W4B0dN9Y0ctdfzKbyjWi/3xwbtXq50r2tCZdLevWXyl2ThnpRdH/1NfIne?=
 =?us-ascii?Q?MXpY6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5b3c97-24c7-4bf6-2aed-08db5cf2a414
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 07:35:40.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6NZOP2ilc/zSaTx/r8Ea57eF2Lru03BK88kf+1yhUxfG/qtX+eKBptX0O5ggnYDBr5UMBISz0QsyMiDaPgA3X78mGyyh7OYjPmEWSfPxHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4119
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:57:14PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> We encountered a kernel call trace issue which was related to
> ndo_xdp_xmit callback on our i.MX8MP platform. The reproduce
> steps show as follows.
> 1. The FEC port (eth0) connects to a PC port, and the PC uses
> pktgen_sample03_burst_single_flow.sh to generate packets and
> send these packets to the FEC port. Notice that the script must
> be executed before step 2.
> 2. Run the "./xdp_redirect eth0 eth1" command on i.MX8MP, the
> eth1 interface is the dwmac. Then there will be a call trace
> issue soon. Please see the log for more details.
> The root cause is that the NETDEV_XDP_ACT_NDO_XMIT feature is
> enabled by default, so when the step 2 command is exexcuted
> and packets have already been sent to eth0, the stmmac_xdp_xmit()
> starts running before the stmmac_xdp_set_prog() finishes. To
> resolve this issue, we disable the NETDEV_XDP_ACT_NDO_XMIT
> feature by default and turn on/off this feature when the bpf
> program is installed/uninstalled which just like the other
> ethernet drivers.
> 
> Call Trace log:
> [  306.311271] ------------[ cut here ]------------
> [  306.315910] WARNING: CPU: 0 PID: 15 at lib/timerqueue.c:55 timerqueue_del+0x68/0x70
> [  306.323590] Modules linked in:
> [  306.326654] CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.4.0-rc1+ #37
> [  306.333277] Hardware name: NXP i.MX8MPlus EVK board (DT)
> [  306.338591] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  306.345561] pc : timerqueue_del+0x68/0x70
> [  306.349577] lr : __remove_hrtimer+0x5c/0xa0
> [  306.353777] sp : ffff80000b7c3920
> [  306.357094] x29: ffff80000b7c3920 x28: 0000000000000000 x27: 0000000000000001
> [  306.364244] x26: ffff80000a763a40 x25: ffff0000d0285a00 x24: 0000000000000001
> [  306.371390] x23: 0000000000000001 x22: ffff000179389a40 x21: 0000000000000000
> [  306.378537] x20: ffff000179389aa0 x19: ffff0000d2951308 x18: 0000000000001000
> [  306.385686] x17: f1d3000000000000 x16: 00000000c39c1000 x15: 55e99bbe00001a00
> [  306.392835] x14: 09000900120aa8c0 x13: e49af1d300000000 x12: 000000000000c39c
> [  306.399987] x11: 100055e99bbe0000 x10: ffff8000090b1048 x9 : ffff8000081603fc
> [  306.407133] x8 : 000000000000003c x7 : 000000000000003c x6 : 0000000000000001
> [  306.414284] x5 : ffff0000d2950980 x4 : 0000000000000000 x3 : 0000000000000000
> [  306.421432] x2 : 0000000000000001 x1 : ffff0000d2951308 x0 : ffff0000d2951308
> [  306.428585] Call trace:
> [  306.431035]  timerqueue_del+0x68/0x70
> [  306.434706]  __remove_hrtimer+0x5c/0xa0
> [  306.438549]  hrtimer_start_range_ns+0x2bc/0x370
> [  306.443089]  stmmac_xdp_xmit+0x174/0x1b0
> [  306.447021]  bq_xmit_all+0x194/0x4b0
> [  306.450612]  __dev_flush+0x4c/0x98
> [  306.454024]  xdp_do_flush+0x18/0x38
> [  306.457522]  fec_enet_rx_napi+0x6c8/0xc68
> [  306.461539]  __napi_poll+0x40/0x220
> [  306.465038]  net_rx_action+0xf8/0x240
> [  306.468707]  __do_softirq+0x128/0x3a8
> [  306.472378]  run_ksoftirqd+0x40/0x58
> [  306.475961]  smpboot_thread_fn+0x1c4/0x288
> [  306.480068]  kthread+0x124/0x138
> [  306.483305]  ret_from_fork+0x10/0x20
> [  306.486889] ---[ end trace 0000000000000000 ]---
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

This looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Alexandre, is there any feedback from your side?


