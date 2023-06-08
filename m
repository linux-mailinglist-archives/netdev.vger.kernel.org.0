Return-Path: <netdev+bounces-9391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274FE728BB9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FDCD2817C0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36A934D8F;
	Thu,  8 Jun 2023 23:25:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4932A9CA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:25:27 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B2F30DF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686266726; x=1717802726;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=THKotNSkKCe1PQcsH4BNfjRwnZlasb5Wadg8XgWkIVM=;
  b=Cx9O5CkyjQ04opn2p0JH4yMhcwVpZfY6NU41p55vMuSVGoAuIgWSgtmE
   /owvY05BXHBc41Zo6kePGKM+aARJZPIfWv6M9faDlBgmpX9iohFUCuPGw
   vfXW+m6i7dQBvn6sAWyH5n5CV1QJPo/yL/1kEJLQEp3pepyZkKTItHXDI
   CkwVgZiZVrgkHFD+KPCqiQLsDySAO8yTBfFDEWAwCDbZiGAsrgxhWBYNj
   rPyQDcLAup1yKLY1ORiivQvtN7X4iPU9Im0EsXVoYkDH+cSa5LNWl9vzV
   46T0zWsJQSF0NcZwLckFnaJ4jccTlhm6y9zI/QDQzgfVNojA4lSCaOifz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385812412"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385812412"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:25:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="687527596"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="687527596"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Jun 2023 16:25:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:25:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:25:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:25:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIeijbDRxZqWrdklgt6qSburqU3B0kkA8Klzlhcio8FTtwyM3a+tFQ4MgpkzgyOyH4u4xw+53SatPOrsdFTjKMs7zKSqbdjzFcsfqiYf+WJj4KSdEW3P9inlIx9rbiMVoNmFaH7e4kqhkATExGlUa3CaCa059ToeduRtwA6Ul+/E4lSsapedw2Vj6vUcm8IzmCwEAJfBw5Na4q5+YzJaYLbSnHhnroI1y1rGwIwb9x0K93E+920NgCngGwuQoiankMWnQSfE4CotyNKPk9Ev45Xg7YZrxf0Y9aer6bV7OLHl5V5bTPVOBhhHE5Zx5njniN8MXMBiK7eAgzJPXwF6FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6nJ0ICqigRH+EIYd8lMk81BgDehLAAdHvL+BSPxXik=;
 b=SfMPD8exm6AWnFgf7pj5cXtxQoPvhueOL1/duHp+HbxE+Eu5nAcbxL47zzgz/khB5H8Ig6GfCQ/g0x/0Ijg1KBeL9AxkfSDjJ+t7ZV5O9S+6EBrO21X2bMn115iV/1bw7bTrNmGlr+rF9as6Oof2xBxNqRDba3lrKTNHaQQZkNShk+/r2BI8dgyN8yw0y8wfqFDFt2w3kaC8P9sYbdSQr3x46ou0XZohBwSp/QEeVMJke3hWaDX3XYlyrV/jTfueSM0Ge3HHHRKKdWrK6sF4nyGHsrdie4xEvkyj+eQntkRVcPm87Rp4PXIdf5vU4Bo6jbBIyQgjAWonflSqwGRdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MW3PR11MB4652.namprd11.prod.outlook.com (2603:10b6:303:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 23:25:21 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:25:18 +0000
Message-ID: <8dd9b4a4-a3f9-a7d9-e3b9-a2946ee7d067@intel.com>
Date: Thu, 8 Jun 2023 16:25:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
To: Asmaa Mnebhi <asmaa@nvidia.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
	<chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>, David Thompson
	<davthompson@nvidia.com>
References: <20230607140335.1512-1-asmaa@nvidia.com>
Content-Language: en-US
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230607140335.1512-1-asmaa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|MW3PR11MB4652:EE_
X-MS-Office365-Filtering-Correlation-Id: c000e79c-fe1c-4aa3-ee54-08db68779ed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDI6eV6JUIrgNH77jfQnfZf2lN86VTh6DMtf0PkmKnfCdiyPV0D2cMyeBb4mT3xFdWWRm05LVrMW4h8Rv4MksMSMqoh0bbjSOfNd2WX67jT96L9ETxV77KySkFzsNzb3NHu3bqvTzE86YudiSciKb7+6S4cjvmz4/mmKdQP7bh3XTxQ+CgsaeJ9GrfIJjJIGL6K7L97BmcMXjT2k6jt+x/8kPiPwhT/NXvULtmDr+0mstEtfjKqiv2tng5wyHT4WdcuKcKZhNJoyk9kgqXBGBwbQN851eJibygNYaPjnSc44C9hgcD26s6jeupTNFiCCU2oK9YvsFzIGg57n+5G2XYlUk7DEQbQ+xRXugYoz4K9KqfdE4CKCMviV110A3X/TneIXuCuQrlOeYSaG5VWCHjKT4U4Tbj/NRXrqas+OHmHbxiXu+UPn2mZlNKOO81GNY6zhGYSyEJsvfE+womtrlSF9Y8Qw0Q7g3DUm3LE93p2NXPu6eyKa9J1GrEadfkUSSMvUZBKWPglMK/kSb7YEoK5AfJeOIUmO1kymx82IzQHQHEkOkLRvgb+4l1dBmLl28rPe1wNLkWsY7pYfecxCNNTwKTPch0vTfHqQauxiEoupHONWzl9pbkWXibKdfllxj62imf+PUIxBFVx9avGxyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(478600001)(316002)(8936002)(41300700001)(8676002)(66946007)(4326008)(66476007)(66556008)(38100700002)(2616005)(186003)(82960400001)(53546011)(83380400001)(6486002)(6512007)(26005)(6506007)(86362001)(31696002)(7416002)(2906002)(36756003)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0lxbU5CVTMxMTBLQ0lrUUxTanRBVUlUZHNycXNNdit3YlNzSllkVjBnbVNI?=
 =?utf-8?B?NUJDM09jYWJGSDVlS1JZU1U5VE5MOUNEUnFKMkRTWlpHc3FmQ2Nrb3FUSVVu?=
 =?utf-8?B?dG5LVUVLdWlMSi9NQ0xBeXFmZEtJMlB1Njl5eTJQWm9lMjgwZGpDVDZERXNx?=
 =?utf-8?B?MUhCL1kwZUV4d2lkV3N0Vm02M3kwSUtIWGoyc3VINWJNTTk0Tm9wM1JpbStS?=
 =?utf-8?B?MFlnb09BcXlWcU1NOGdLQm5hNmJ6WTNNWVg5Wm5SalRDam1lRlpLUFpRQk9G?=
 =?utf-8?B?S2xMOGhUNHhySDhoTmU1TUU1bnhhNDlaejhxTHd0V3BGTW9RZm1PTld6NTcw?=
 =?utf-8?B?OWFrVGNNRFBsbGhES21rZ2o3QlNrTExCT1ljNEJXWkZ3blFDTEV1TU5hdllR?=
 =?utf-8?B?Uyt1dnBPVy92SlRmUVc0L1RJSkhBL0s5OU00MmJkOHlJa3I2OFVCODZ0L0ta?=
 =?utf-8?B?UHFjTG56NkVGaG9SMVJvUGJhNm5YVnBOVmFPL2F0RW16VUl3MHlPRHMzckpJ?=
 =?utf-8?B?T2g3dDF1YW15NmxOZ05TOENFRU5LaTAzcWNkTy9wYlMwME9LOE0wK3lwMnVY?=
 =?utf-8?B?WUdLeStIQjNjbHZBY3RieWljVFZSRmxsNlFrUTBPck0xcmVwZHBBdXprTVoz?=
 =?utf-8?B?VEFYSWtwTzlxSFhKVHRFMHkwNUxXZTVla1U4QXZYcEUvUEtPY3RuRW9wOW96?=
 =?utf-8?B?RlN3WStNVmlnWVlNc21MMzhGNURUZzQrMXBtK3hiSm10UUVRM21HZVZDeWRa?=
 =?utf-8?B?SFREcmowWnlFYjF4eVZwL21xVHM2ZHRtZ0xkVXRLb0ZPRU9WSmlPOUFxckdk?=
 =?utf-8?B?aHdIek1tOFIzcXB6amNnQlJMNWxuZ3BkTFZjSi90YXZTOFhXeFBud2VZdzJq?=
 =?utf-8?B?cW95cEpWeXZGOVlSL3lMNUt2bXQvL25zNVVoTkFFUExsVGxveXFFT1hMTmpL?=
 =?utf-8?B?N004RGZOT1Bqd1hNTXZoSHhuNWYrV2NRYWVRYlQvc3AvWTVDTHZrMGkwL25o?=
 =?utf-8?B?SDVYd2RreDZpRWRGUkozZEJkT2pwaFhOSW9VSE1OYWZyZzVFM2xWVG9mNjZT?=
 =?utf-8?B?eTRFdzUycGFTRjI2WXJBb20rcGhKc25xMFFtUzcwdEpPSXcveWQ3OGp3Q3NK?=
 =?utf-8?B?U2NYZHlNMjJyelI5QkNHSDZCcm9LQ2lrR2RlTnpTYk1jYTVYdmowUEE1bEZk?=
 =?utf-8?B?MGR2QXBzMWRDZXpNaWhjcVpCdDJsNytIWkZMU2ZXZDFxUmNONU5WNnlOeGRa?=
 =?utf-8?B?SGxrYkYvblN1NXFmaC9hOGd1WHBxcmg5bWhoY041Y1N5NGN6TVowbWpucVBy?=
 =?utf-8?B?eksweTBIRjRSd1RoSGJMSHNTV1JDZDRFZ0lqWkxpM1RENnNQZTBYYi83YTVw?=
 =?utf-8?B?blNKckhWS3A5MEI1ZGlrQXlPTCt3amVWWE50RC96OFRQd0trM1lDRjl3bXVo?=
 =?utf-8?B?MUFZYnlZakdlalNsWXVibWV5d0Zyb0dxaHVJelJoZ0RLTmcwR21IWGRFZS8y?=
 =?utf-8?B?WlNRdmVDQ1N1WWx4c3lBNFBMbEZQTjBKOXFManVNSDBqTGlTb25lYnpuQzJS?=
 =?utf-8?B?dG5lWTc4Q003UWJlUHJRTGZkbHZ0MTNJUlZrMFdmdUp1Mi9KQUpudkNwVFpu?=
 =?utf-8?B?dFVNMDIvTDJDMnR4Vm9RRGM2dWJyR2R1RmtKaTJ3MWZZYVFSV3JFaWtidjVF?=
 =?utf-8?B?d1ViSFE3SVNYbW1aV1JtbHgxdXB5SUZFV0x2WnhnSFdrQTdaK0gzVENuOXhW?=
 =?utf-8?B?YXk0VFdGS296QVNJdDlWeTZiVjgvTlVVaFZ5YjRrTmRLMlNEZ1pNcjJNVklt?=
 =?utf-8?B?OWQ5disycEZUNm1hOFlySnQ2OVE4R3hZWlhLVkVyL1ZOa0w4WVpNWjd6b2ow?=
 =?utf-8?B?aC8vZ1dMT080L01XVVRZZUZUYkJjaVVCc0VwQm0rOEZEaE8zcDlHY3NxdDI0?=
 =?utf-8?B?dHpnRHFSRFh1TlkxQVNKNjBEVi8vaHYvK2Yxb2hiamFMVCtQS0lnNWVmUnRs?=
 =?utf-8?B?emwrQ0pSUmZxS1JOWDVydGRhM3VoTWRCZzJ0M1lJWUUwY3l4QUpVTzFuK2FD?=
 =?utf-8?B?MGZSZ05tTU9KcUgva01jMlJIOFRtcU9Hc283R0tab3ViL3NJQU9TSm0rT2NC?=
 =?utf-8?B?aU55TmsyRS93c3IrdkxaS0E5WCtVWCtJVmp5VzhaTCtLdk1YbmJVZ2laUVNX?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c000e79c-fe1c-4aa3-ee54-08db68779ed4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 23:25:17.9641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoHq7gFHEtXwqNHE5CxcjiymQE86NcdYXrY+xTVH0xWgLYXEOUJQJlNDdeYDq2YEHjSO9L4KdRmU6gfJSoLfa5yDxm3ag449ZcmZx2SDnmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/7/2023 7:03 AM, Asmaa Mnebhi wrote:
> There is a race condition happening during shutdown due to pending napi transactions.
> Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
> result causes a kernel panic.
> To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> index 694de9513b9f..609d038b034e 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -475,6 +475,9 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
>   {
>   	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
>   
> +	if (!priv)
> +		return 0;
> +
>   	unregister_netdev(priv->netdev);
>   	phy_disconnect(priv->netdev->phydev);
>   	mlxbf_gige_mdio_remove(priv);
> @@ -485,10 +488,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
>   
>   static void mlxbf_gige_shutdown(struct platform_device *pdev)
>   {
> -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> -
> -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> -	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_remove(pdev);
>   }

With this change, do you really need mlxbf_gige_shutdown() as a separate 
function as it is only calling mlxbf_gige_remove()?


>   
>   static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {

