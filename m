Return-Path: <netdev+bounces-2624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CB4702BE5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A193F281214
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B16C2F7;
	Mon, 15 May 2023 11:55:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4500C2DD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:55:15 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD774209
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9/285YqCbDcfOwqTxeSy7zRSAdP87pLA7jSHBCgfEKLx7iYgGgAWmtsruG+1YEt8jexDjG3+mCVXhYY30mT0T3z4S15Gh4aTA3UHPQ3PqldzW1jKUbSYE38ddltOIHXZzlm3DPB+3y/7nKKoduAeNH7dJyaUGtEZAEdET1kSYxifUDc7ODEFaGSb3T+gWC4/0AXutWJqAQCUcACP3HgXJ6uNTorB+n/vxtNDaDZzCY+WpUGoOqOV+0pSbR9ZVWdbclkf0yacFz1Fxy+XT2ERd6nWI1wCpXjE/BtOh6vzjk4WHAEzdt5RdCnNadgzP/pk/9ih6CPg1Ehd9karz/lHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIIxLRxx4OTS6mZsJpMocUpR73SMChfV8k8bLtrxXhs=;
 b=Q8K0J628zs0sMsqBTuYPK6O0BVj5tYi6+5xBOEtpuJqH3F2UV2AOQsLARCX7oKJRQ2lholmoOvBn8XbB4cT91HWpiazbV+RfCSRWjsUhFQPIWk4pxHrkGRpKFnrhzJp5SKmHUshnqW1AUdqTbmZ2e4+AdX0nAj/yFPFjhHdprsaEeO5j+IPR06iuhI96rgkclboTzx9ygaVKvdRWtoa5J74NEU46MTQROufT4yD/4bLW/pDfzFKI0xK+NxWBjUWF6uDtUomd8DnNKmjZ6k/aR7hmpLtuoYrAwTh0zqqyI3us+gNEi1zaJqK5aiOEoDGSu23ZUNAWhIIbw8Y4p/Lgfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIIxLRxx4OTS6mZsJpMocUpR73SMChfV8k8bLtrxXhs=;
 b=IE7HRY2MglujnsqguYG5B+MWioh31A9VJeCT90noVZCWQdz0kT25rK9kDIEg+yg+q56qvyewAk/EtihLHl885ItEl5VMvnpFXImeOS7FCRXvDTeu5jNsQF3c4ljyDthn+BIGhbsl7Sv7iPxoctXQzW6QXaUsbgzbZm/0ml/qn00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6489.namprd13.prod.outlook.com (2603:10b6:806:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14; Mon, 15 May
 2023 11:55:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:55:02 +0000
Date: Mon, 15 May 2023 13:54:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
	Samuel Wein PhD <sam@samwein.com>
Subject: Re: [PATCH v2 net] net: wwan: iosm: fix NULL pointer dereference
 when removing device
Message-ID: <ZGIdj7GBwZBVLR+x@corigine.com>
References: <c1d99c89980ec7f7af8b2ed027237cd34d48aa87.1684135171.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d99c89980ec7f7af8b2ed027237cd34d48aa87.1684135171.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AM3PR05CA0112.eurprd05.prod.outlook.com
 (2603:10a6:207:2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b7ee8a-2b94-40dc-4bca-08db553b371f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yoY4FMqLbQkJFNVdXYDfA0hvrmv2o60x7FGXWxSj0GRKH1FM03CyN9OlX0z5F5bOVYTz5Edj5GhnU1ExeIuPY4WvYoxEGT3jh1NcvYy/W72d+IX27Ex6iN7mqGxCPXct7vbh1gHkRj5qvlIf+O5uo5hiLjfuRHYS34+NackqGEMyeurOjCDgQDahZoX5k7UtQ8wyYnfXvS4Ufw2i+0RxiGbp3N05L9itrH31fB0kuo6y9MXoHm0jgi+e0DaopN3YVHvQVU/vbz60NePa8fReLKqHe6cM670Q1Pp1of3xKDoqYSTkj0vYEB8o5MuSk+YGjyaqv20VcUKOfp5Y7ZGbZma7gaOcJvyN9xHErBKtuHDI5X4PTXPQBfJ5Kl7+oWeSblecpjHSTJqYZncvMxkS0T1KHiIEW8xKYXPOTdJ/tCy0INjxshbhA69kQ8MOfV4IKeEpRI9jicR6yWx6QmjojyU/Zz9R+jV5pN+9B5yTUYtpwvR65spRcZbLEJibYM+fAUYxvNngMGk3dWG4c0s9iWFHCzGrY85L+Ry1emKimCOTVGLUWKuouSILThGoP3tFAELX2+oZL9lqKZNbr6b/WOniqgo5fA+xVlZUj7l3og4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(376002)(396003)(366004)(451199021)(83380400001)(66476007)(66556008)(66946007)(2616005)(6486002)(6512007)(6506007)(966005)(478600001)(6666004)(7416002)(186003)(44832011)(86362001)(8676002)(8936002)(5660300002)(2906002)(36756003)(41300700001)(4326008)(6916009)(316002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?heoy7T+gSkjp+Ox6nbb8yR6+BBkKv+1qb3wNIM0dDXaeMyZOkD6/SO57LwGs?=
 =?us-ascii?Q?y5nSsEyrpZdp3oSgEvmS2j692OswUT/2DGTkJ2im2eff+Sn37yLZ/dn+dezt?=
 =?us-ascii?Q?oBtjwDifKY50Yv4jISEtyIdQGeBqrv9K2sQECEfTmjSwQvGikz9fYQCnjQ/A?=
 =?us-ascii?Q?nCzI6DJTMEENQzIy+I88r4YM9P4x1Rz3hQPBZr/oVartYEECfFBk4cr7Brnn?=
 =?us-ascii?Q?zyDEgX+ciSx6fsj/+/wGkhujXN85+o+od7LDQWuj6Udd6k2kkSO2ktejbAOe?=
 =?us-ascii?Q?1iGqZwz7ZDKDhUM+ZA0WRBiriwEMZ6Dc0UZVpocwKOaZVpvzO8iLAEUra7wI?=
 =?us-ascii?Q?y96czRU3UV/ZHKHbWjrs4i+7ksZ9XEIVdhVTD7/eFJeH9/TSlfuxS7F/Cmou?=
 =?us-ascii?Q?5q9VkBFd+oPcASKhF7EYHnRI/S4FpVUfRPkMZgAML1BnL9aPbxlFp+0I5IoP?=
 =?us-ascii?Q?aOXRjh6Wm1UNqiOLYCMyUxmq4A+pX8qemi7NTa+DMI1fGbT6V1Uw6U3YmPkF?=
 =?us-ascii?Q?uKPvGdF/JFIMEP7BF4q7r7BiRkfeFyDLRfVRfVwo2e3p3sI8yDNxHySSvl5q?=
 =?us-ascii?Q?sOyFlWI8Gia4i1VBsbF6FjaCGUjilqKXEafryDO63fp5Iqu480Cbe39pnNFJ?=
 =?us-ascii?Q?MJrJgQtKlgs2+sccEmGyFkU4EAay/g7txQDGE3F0/zjxqQ2yt3HiE19qjCAz?=
 =?us-ascii?Q?NyZsXSEzZKx5t8PTHEFI6KwxOdBPwwrtxjqS3Npeh5xzig3UY36vB6DEYv82?=
 =?us-ascii?Q?7WzVnoS9VAwrW2ku2RXdGTogtFFZ+4x+b5YkhBcb//kY6/Ytdni/k2SrFS4y?=
 =?us-ascii?Q?s1tluPtZpn87CEKvHR8/OkV5Fjsvv025N6zrXAwgOsOqezTzOWasa2LOgbOc?=
 =?us-ascii?Q?6f0NyEDfyLUZdcXLmSne17xjds806YzvqlDZ9qkIswN/OVrF0j+cU3duDZiI?=
 =?us-ascii?Q?SvEhMwAD08kgnBk0wYLxEBpLOa/wp6Tw/pU7vL7XJSpHKQetDJY1NJhW17LF?=
 =?us-ascii?Q?qezDuhpGE1Q9nZ6qT41Kqo7/d032RGqjtE5aYhnUvRq1v0BPHwkkU08a79HH?=
 =?us-ascii?Q?TY/Zz8rI2uipzCq1QVT9k/m8dtUwo4Ua1024HF4hLOXi2U9OdR9oOH+0OwHZ?=
 =?us-ascii?Q?jJkod6YFVi9A6PYNq2S0EKwTavtHtzDSUHBja75WjSFVFBhGm2XfLmolqCE7?=
 =?us-ascii?Q?QkTOIDExD0xYkP1zg8HaYo7y6gbWs5LcwoI2dw+UtUmDawxgza5GmudTUNUk?=
 =?us-ascii?Q?0Hav3o3ZjT5XLV/TARbiRcufUoQBBJU1MyZYLP/f8XdQwXiEq+sBM012oG2x?=
 =?us-ascii?Q?vwaWrxgA8OOuPf8J7i28BLEBrqhoKrfInR9skxHFssvwDHD2BUeDB/Ix9YtI?=
 =?us-ascii?Q?MbsYvw0T8p0yZi339L3BVjZXaBhECs2CwFH0mr/+yqrBgMHk5DJJ3rJUZLYC?=
 =?us-ascii?Q?0Ze6CcIGlJk8Zpcxm/BnyYcYIczQbef3yj2/mZ2JkoUOT5I24ek2Fcx4TdkY?=
 =?us-ascii?Q?LhjsgANO5Fnh84++Wp0L4cZUzHwRAyJPM4vGxSXzmGnnTePbMCp+r3JLEnVx?=
 =?us-ascii?Q?RT+QqNHP43GLd0fBvrqLebhDR3CVsTEC8ufpJ84Oj+8R6VhRFuH5vZ+lrGtw?=
 =?us-ascii?Q?Oe1TXcnWAADntIg042/72qzCLXzmwuzVA77r9VvvbuLACS/8M6mjw0vxrTbO?=
 =?us-ascii?Q?azVTFA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b7ee8a-2b94-40dc-4bca-08db553b371f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 11:55:02.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BC26F5tM/adTzpaU6/JwjLPekd4J2EzcYiMah0rSsPt1fitd+CWGqsRNPqLi0FY9xHFS50czXrIovVZN9BWkHoOvv7/r+lHwvbFcMR07hRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6489
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:01:25PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> In suspend and resume cycle, the removal and rescan of device ends
> up in NULL pointer dereference.
> 
> During driver initialization, if the ipc_imem_wwan_channel_init()
> fails to get the valid device capabilities it returns an error and
> further no resource (wwan struct) will be allocated. Now in this
> situation if driver removal procedure is initiated it would result
> in NULL pointer exception since unallocated wwan struct is dereferenced
> inside ipc_wwan_deinit().
> 
> ipc_imem_run_state_worker() to handle the called functions return value
> and to release the resource in failure case. It also reports the link
> down event in failure cases. The user space application can handle this
> event to do a device reset for restoring the device communication.
> 
> Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
> Reported-by: Samuel Wein PhD <sam@samwein.com>
> Closes: https://lore.kernel.org/netdev/20230427140819.1310f4bd@kernel.org/T/
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> --
> v1 -> v2:
> * Fix review comments given by Simon Horman.
> - goto labes renamed to reflect after usage instead where they are
> called from.
> - ipc_mux_deinit() checks for initalization state so is safe to keep
> under common err_out.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_imem.c     | 26 +++++++++++++++++------
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 12 +++++++----
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  6 ++++--
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
> index c066b0040a3f..4520fd148601 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
> @@ -565,24 +565,32 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
>  	struct ipc_mux_config mux_cfg;
>  	struct iosm_imem *ipc_imem;
>  	u8 ctrl_chl_idx = 0;
> +	int ret;
>  
>  	ipc_imem = container_of(instance, struct iosm_imem, run_state_worker);
>  
>  	if (ipc_imem->phase != IPC_P_RUN) {
>  		dev_err(ipc_imem->dev,
>  			"Modem link down. Exit run state worker.");
> -		return;
> +		goto err_out;

Sorry, some of my previous advice may have lead to some problems.

	Is ipc_imem->mux uninitialised here

>  	}
>  
>  	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
>  		ipc_devlink_deinit(ipc_imem->ipc_devlink);
>  
> -	if (!ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg))
> -		ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
> +	ret = ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg);
> +	if (ret < 0)
> +		goto err_out;

	and here?

> +
> +	ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
> +	if (!ipc_imem->mux)
> +		goto err_out;

	ipc_imem->mux is NULL here.
> +
> +	ret = ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
> +	if (ret < 0)
> +		goto err_out;
>  
> -	ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
> -	if (ipc_imem->mux)
> -		ipc_imem->mux->wwan = ipc_imem->wwan;
> +	ipc_imem->mux->wwan = ipc_imem->wwan;
>  
>  	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
>  		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
> @@ -622,6 +630,12 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
>  
>  	/* Complete all memory stores after setting bit */
>  	smp_mb__after_atomic();
> +
> +	return;
> +
> +err_out:
> +	ipc_mux_deinit(ipc_imem->mux);

	But ipc_mux_deinit always dereferences it's argument.

> +	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);
>  }

Perhaps, contrary to some of my earlier advice,
it's better to have two labels.

Say,

err_ipc_mux_deinit:
	ipc_mux_deinit(ipc_imem->mux);
err_out:
	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);

...

