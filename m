Return-Path: <netdev+bounces-3704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE6770861A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785CE1C20B69
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65886FB8;
	Thu, 18 May 2023 16:35:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FCB23C70
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:35:21 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64436B3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:35:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4C00bd94v4rvZ2tsKum4XirlRqNJIn78PkoKPusJba8IS8tz8h30zbZqNA2g3xOur1MZ/MWQwCTrdmEMJO2+L4KEd33qVm/Gh2pz8gk96xvQjKpQs3TmThuD3k9vDkc1LX7YvF+HPNfEAzzfxIt4nSkJE4g6yxVOvWXXWqEy0Jzoc1BkSEBbnUDnQDb6F3m/Z5lC3DZssY3XJBZrSFnO5mYQklo8zHVnLPpjdrNuZY64DqFHLUCEX/NZwLIQ/2BshA4qy7o7nEEcUcBKE0WEiyKN3hQuMEu1+CfeVvu3WcIgrqmucWHuj8M09FJNPdkOVhblis2DDLSNZk46tSzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCpjm1qFWULb6ftgTbPDZaOyFF73d1XOS5VMos+PP7o=;
 b=XGufEeDu8fkfaO05zGy2+/9SI1Re041pW1CIGQFfQ7DMFWtxqzwSGIWd0+l6uZrd8DdB2oTsp1B/jInux7UgU4ocdAb77I5rizKIprpacVaqmj2wBXETrew5X89JoBwdU9/tRqPCfYqX/1wG5kUcFDP/g8cVMsoeFEscuahuYu2v+ldd1tFUBvSvxILj8pv3lzfLaJ4Z7Tw9lc9P2t4PSLzdXeLH1rc5PeO0qaX9G+NtBGbpvoHqbJD2fxM4LH0bWvSbW795AkMIS8VPCkcsOBa6KO5tuI4zYBVsWZ6++Cf0QfHNajRusYhmhAOe8dATLeoGoDCcOXF7gyOXgb596g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCpjm1qFWULb6ftgTbPDZaOyFF73d1XOS5VMos+PP7o=;
 b=BT5D2HbEnhWj756dqobbYHaxODd/8+dHGQ3Kyqrjn2t45WIlSsB7kb6p+kGSUEglsZ55XQJTe0bLozgf9nWavGgTc3T12W4AVZWicyOWbrrOXyuAvKCfABgbUIbro62tmFBbqzSORqehv0NZjc14D6ZDKscJpjPNY3T3CK8Xn+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4722.namprd13.prod.outlook.com (2603:10b6:208:333::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 16:35:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:35:16 +0000
Date: Thu, 18 May 2023 18:35:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, Tariq Toukan <tariqt@nvidia.com>,
	saeedm@nvidia.com, leon@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net v2] net/mlx5e: do as little as possible in napi poll
 when budget is 0
Message-ID: <ZGZTvQheMsX4LzUx@corigine.com>
References: <20230517015935.1244939-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015935.1244939-1-kuba@kernel.org>
X-ClientProxiedBy: AM9P193CA0014.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4722:EE_
X-MS-Office365-Filtering-Correlation-Id: c9f3532a-8566-40fe-13b2-08db57bddc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2lV0/0EavMA563Hwflmr4JkO5pJFAbrw4j9fhKuDFPBZEi+ivqcMJFMIkGnsudT3b1aFM2bkLjRfeXtp48sfeJP/Mp/0PCYIUxs8P3UiBtA1W6GuUR7JYESQtz94S6dLtnj7FDbKdcFpvHGdJtuoNCHfPC4YXqOersfnriROJlzL3nj9vUAIAPjCo8TLqvDYCzc6s32Z8cvwVwyWyi1OzBQQOwzMpWANzIuWHnKIE+omyEDP5ck9dN45TJjqQNoQsufh8UJx9XG8gGpShfyYxq2CldzZ+87ZK8re9t24FOPHIsrI8uDyVRdIHGjQuaerSiw7/IUexa1TjbM8nNK6BtT7jM5yqAfVHh+D+MbalBqTF2PAD4jfXFllu4Xhh/5L+TXaqrQhcGKUM4TpIn90Uuu0tmJPeN4PIH/nhyyo5QbZMZxfSecsVfpUH8YGTQTUruX6iJaVLrypG2qS+m5ZgxsIuJzWJZwN4BUhg3St1skol85Xhd/KIp4V6OIo/Kxldo3sbag5ZrMrxHzyQRYuHqc1a4l5OGX8TA9mqKD7Jrs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39830400003)(366004)(396003)(346002)(451199021)(66476007)(6666004)(66556008)(66946007)(966005)(6486002)(316002)(4326008)(6916009)(478600001)(41300700001)(5660300002)(186003)(8936002)(44832011)(8676002)(6506007)(6512007)(2616005)(83380400001)(36756003)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RlAxg2UKxbu/FKy0kmVJXoNFX/o5/hUEQcOH+ChsJM3wV2vTRfaVzLKNE+8M?=
 =?us-ascii?Q?pa6IJq3WsY+ZRftVo16no2xLJD+Q/GAvSPSGN/UQkPnoBQ2KyLYsEWqG/N8Z?=
 =?us-ascii?Q?WvAG/7eAVOP0GIOI+vg7XmklG3I3vr7Py/6w0KN97zmd7U6qhJvOt93YGGKt?=
 =?us-ascii?Q?8QCZFZlB7IpmeeWvJDxuuyylGVIVPJUiTKG4b03R0D8qjXp+dKxyNfNguNkq?=
 =?us-ascii?Q?04BRD+sNL6MHEnf21rK58GYJUipkPo2LH1sY60yIBZv4vh2F71RgZVJ+x+D3?=
 =?us-ascii?Q?BI+XZ3NlmoohJR8ntSgT8kOY3CtLNlawugEcuEYKWyQCqbXbu9g6WPlCwJro?=
 =?us-ascii?Q?fuw6WWXBzcvRfCNVqdzlUwlM+RR/D5Uk8j3uT8MXJSVAkPHfpxj2pud/bvud?=
 =?us-ascii?Q?nKGGjnElOjW+neWRV6dVlx8lngzw4GDFsZ41R2OmnvcR1tTck10Oae8wiAEp?=
 =?us-ascii?Q?Ra+L9sbmLgyyBZCQI38cZuY7CQAoynC0GO9PDYP3GXZKsb/Q7w4ttmC8Fzg+?=
 =?us-ascii?Q?e9yWtpxKPDOfrAFxbNLVhzA2I+hQuwSXddiGvQsxV96OBu47ixmFwnpKjYIJ?=
 =?us-ascii?Q?n9d6ocjcVPZ8R1AhwNOApcL2mMovRWmJGjEOTfsJaVUN6HZuN1m6V8/fjxNg?=
 =?us-ascii?Q?vR1xN5xyhqFHj543uigBJVVWjqXkIHkGK3t3fMrsZpx+HR9IZ6Yo6tAKWvOT?=
 =?us-ascii?Q?XDUZmheHHlVASTiJBLq1r4TPLPsgEw/IvSydvsqnr2RIQlONbshmOhYT56uP?=
 =?us-ascii?Q?8uAaEGP2J5POu3XJbREeOcpLCl418d4HQMoDN7zeOASHaRcKglbWMSdun4+X?=
 =?us-ascii?Q?Zm2T1zDWZcXEb0iQJLMNWGHXSoTMPvvNbwc4yOmRMtQvUMGXKyOm/dL3c1ZO?=
 =?us-ascii?Q?xsEVX9iwMnNYbenw3MOO4VcLoqbBmD2OR/TyEXTL7VdA9yqXdW/9ap/rKlzj?=
 =?us-ascii?Q?1QgoZPgVkDqdf0CgMXILQ8HiMcWAyMQIZfZPHias2AiBeQJTtxSV00/P1AcA?=
 =?us-ascii?Q?rgm35yDoSPdDmQBGhmG4U1v5ZHfZvaoQBJhpGF0NGAHYBO2dnfrDEnYbTVGn?=
 =?us-ascii?Q?+DeQ+16dTwK1w13khdXkddVJblOLElJ5e+eSME0Ft0ocZ1PStWdlCzbeAx21?=
 =?us-ascii?Q?rM3WsYZcHWB4tQVLPHSsO87EqfDJRM2b/gUzv33SJpGQUgsVso8WMuKJtYtr?=
 =?us-ascii?Q?mNOnutc1+LDPsHT5C1R973bQoCTaNLQUoEpAUGCqLkNlOAESImivOwhjPoJs?=
 =?us-ascii?Q?XXYLewf1PvHEqephAdnRuXnutK/mUZkDUqwLRNv+dv1CDMhlHEZ6SKwjbqZ2?=
 =?us-ascii?Q?kFOy7/KDhwutdNnq3VFl1aUumnFP1hzgIEnHrl+ZLb2/orgxigUVfeX23mti?=
 =?us-ascii?Q?gHnrkuPaJBcxQ6pZVj8VS8dEquLYJdOfrd6BCUnamiy0yP+XO8dYcO00yO0h?=
 =?us-ascii?Q?WBnjoaRGxtFXTsZ8qfkBqLEYDScB+izM8GCVvzrQ47Kuztk2PDJoiS+Q2IE0?=
 =?us-ascii?Q?48SIMDAnYdn682eevQdI77w17stVL142bv+6JrvCSjhHB1iWWZM4hCS9vB2q?=
 =?us-ascii?Q?NhJUSPWKX2HcwB4+NZfzntyh9qNjdBgneH0Zd9OdOFqUpSFVwszM8QGuiFlZ?=
 =?us-ascii?Q?kpwU6eUiAFFo2U9eQKYvQtLCSgO8zXW7MA11hLcM4dLb1Vj1WEOkvR2D9vyE?=
 =?us-ascii?Q?IoMzpQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f3532a-8566-40fe-13b2-08db57bddc69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 16:35:16.3451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kK5Mr2xHTCsaigOxc5Tcuhf591k9vDqDqra9K0ow+dbdEFKNMH4LR9Xx6pWlVvyH2UuWsguFx5SbfV+mWa9lcOQ5XdevgPVYqnaDhKSZc6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4722
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:59:35PM -0700, Jakub Kicinski wrote:
> NAPI gets called with budget of 0 from netpoll, which has interrupts
> disabled. We should try to free some space on Tx rings and nothing
> else.
> 
> Specifically do not try to handle XDP TX or try to refill Rx buffers -
> we can't use the page pool from IRQ context. Don't check if IRQs moved,
> either, that makes no sense in netpoll. Netpoll calls _all_ the rings
> from whatever CPU it happens to be invoked on.
> 
> In general do as little as possible, the work quickly adds up when
> there's tens of rings to poll.
> 
> The immediate stack trace I was seeing is:
> 
>     __do_softirq+0xd1/0x2c0
>     __local_bh_enable_ip+0xc7/0x120
>     </IRQ>
>     <TASK>
>     page_pool_put_defragged_page+0x267/0x320
>     mlx5e_free_xdpsq_desc+0x99/0xd0
>     mlx5e_poll_xdpsq_cq+0x138/0x3b0
>     mlx5e_napi_poll+0xc3/0x8b0
>     netpoll_poll_dev+0xce/0x150
> 
> AFAIU page pool takes a BH lock, releases it and since BH is now
> enabled tries to run softirqs.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I'm pointing Fixes at where page_pool was added, although that's
> probably not 100% fair.
> 
> v2:
>  - don't call napi_complete_done()
> v1: https://lore.kernel.org/all/20230512025740.1068965-1-kuba@kernel.org/

Reviewed-by: Simon Horman <simon.horman@corigine.com>


