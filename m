Return-Path: <netdev+bounces-9393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00471728BEC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DED61C20F37
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4820735B53;
	Thu,  8 Jun 2023 23:41:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAEB1953A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:41:10 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066EB134
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686267669; x=1717803669;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4A1TKeSZ/K4M67kY8oHjQC/jZ2RmK9haZzDDHN5kaqU=;
  b=ARDarLlLANKMpPB6L0+3LII0XBGzKQ8YCaqBbkGvj3qhzREXlYn64KBn
   OAI66iN4voykCvjz8eDsipxJFsoOiKcNAziAvv0d6dJaoNLpAr4AvOM1J
   3BuGw+M3GpSNolnAI7sB6kAECE9IoWBA+eRv++TjRlp8gYalSEeKstCuL
   2DgE5QH+ylbhw79x++XHdLxoPmIrt1HLtOkwJi6KY5alsntVq55myqHwX
   UDtmEh9ZFiMOGF1U6sc+s2qjCihmAdkTsasRQ5raOgTcmPstMC3SMu/tw
   lovIcaIuyg8N5K4KFB5KKQNbjKU1kkqqNycP5FYL0JfUnwRtu3x5Tgloi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337099111"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="337099111"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:41:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822825338"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822825338"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 16:41:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:41:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:41:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:41:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:41:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3zbSiuPjfbcmWTGcZYCn27w3XDFRYJDIZXEhv1JzhE2dBr6VuOz6+pBcRBY6NL8qJhEcKf71dq/LbHgoDd6rU3dpyaZef1l5soI6i790rV/ckV6WDEeJBIZk9JizSHdVdnIF91WetoGcCBotJ3x+JQ8jqvfPEC6We69J4tEFDLLYAhq+15B5EJG2B/4tkbpRq7AwmHo04AqxedBxK8w1P0BPvWzoyMrOCfptHkzNUoWDaO+AE5L5R1ZDVpJM+06Q0mao3x6isoDqFgGtqRiPFrJAd1AQGNR8L0B/xJ8istIuTWNWDdTsNhFbsGhpifSlkyaY9EjIZiKfhcP8pqlnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNy3NWmCAli3hbeeP25qPEeU16zJzR2V77QeBxYvWks=;
 b=W2qgXvGkdU9fKC0b8ZgPaUZ7RDLcl1OynIc42aDnG3lkpGvvdxSq5T1XWDfsyeHQQaXmrjiuxfFlixwuThoSlQcxhPMg/Ek2bXEhzeKoLNLpZW5GjE8cO1NkRMYU0xPkKnqrwG/KMlAo3FSvcGhitPh0gZP65/oBNqI3FqOY+yPe/9omRVBTYUsK6SHsVoKCyZfvRW0H5/AgC2VOcYlBHhMJ/XePemwSI0i2vzBjP2fJHLC/cfSUrIJ9pH2Mxngx4aLLknykUEkVRPkSNNajca9BEerSqpqvDNaHRoCvFPFcG95JwE1qTSflsNZErnTDGvSKgV0IHDYp42eABIU19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SA1PR11MB8396.namprd11.prod.outlook.com (2603:10b6:806:38d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 23:41:01 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:40:58 +0000
Message-ID: <38c01d2d-7793-884f-177b-ebce71e6da36@intel.com>
Date: Thu, 8 Jun 2023 16:40:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] bnx2x: fix page fault following EEH recovery
Content-Language: en-US
To: David Christensen <drc@linux.vnet.ibm.com>, <manishc@marvell.com>,
	<aelior@marvell.com>, <skalluru@marvell.com>
CC: <netdev@vger.kernel.org>
References: <20230608200143.2410139-1-drc@linux.vnet.ibm.com>
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230608200143.2410139-1-drc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::27) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SA1PR11MB8396:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c749d7-5a43-4836-38cb-08db6879cf67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1E6PQ3lKCPR+bFrrv0HpdjpQnJgkCTDMtMTqjDwk6bxqcajPosX26bdZcnLvJI/HRj3t5qeX1f1V2oClTB+W3xteciOvr6bcHnx4ai0bbMUJEvlLkfN2kpYXXb/trR149YOlsjNxMQ42rR5qce4yF32G+JUpxRmtSEsg7AWAQiDvGuZpDIdkNl/9J1lLgbO4OzziHXtneLh/lGR/0aYyvE6dOU/+BGyMdinjgQAO0jpoBI11jd2f/ehm/tCpSJwb65Nave6RoRL+NdPbI5ovNDRH7yoIrW+jndxdjcdjtMGZUFwgIe9APB9NQO5pI+GFzdhHAzsxPQMJn9+dFdou6MB9/hf4o4o4nN0pnoZFUAhYM8v8ytKQn0iAHvf3F7UxHziRIrJFWmEP0HYqIPLm4jkg+6k0K1nD1vYMWR9+1l0l4jV2VBnolfj37+HBYLFpfQWO8UpFWiofhzPjtwJIFXpdneXYUfe2EQ+WFDcUyG9P9h2B7S9zzZ3jm9vy7wTBDtUTHbDAKN/eaFVDlCfP0+GEQkc8kAhMKD2lYGM/JGKR21pkD+0VzlOEGVm0qb1LvKsduuUhrbD5VPtvbsyehBaAnLZ9cPrqEQITjs9s04odDSmoxjwkW8KGsCIFE64ypMW9caxkFwcHq7NsSIz7YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(316002)(6486002)(41300700001)(83380400001)(31696002)(86362001)(6512007)(6506007)(53546011)(26005)(186003)(2616005)(2906002)(82960400001)(38100700002)(8936002)(36756003)(8676002)(5660300002)(66476007)(66946007)(66556008)(478600001)(31686004)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2RRTmpTWW5ndHB1K0J2d3BZZkRhODllMGd5TTYrSlV1TXhxekdQbU40N2Y0?=
 =?utf-8?B?M3F5Yk5RUTQ3OUExN3ZZR2YrSnVYeVZCTGtzWno3aU0zWFdmOHRTczc5UW5z?=
 =?utf-8?B?akF3M1dPYmx1ZGd6ZkRHL29Ud1p2a3hHb0ptQTVyMzBydzFJcExMb0VmR1I2?=
 =?utf-8?B?VDh4bFBZdkZtRXdQMjhJRmhuSTlreDNwOTlDWjMxeEZOSC9zRmRoOFByZ3dS?=
 =?utf-8?B?VTdUZTVIN0hGcHozbGh6bHVWTjY1dnlDTVZsdzlwRnZtNVpnL3hqV1ZDSnhD?=
 =?utf-8?B?bUJWbzBEN0UzOE55Y0U1UXIxN1lkVTZuSmlVd2JPd0VTZHBlc1M1RUQ2T0RH?=
 =?utf-8?B?OUFlSVF3Y20zZVUvdWQrQU44ck9nNGlwc1dPZm80K0toVlhibmxHTk5jSFJ5?=
 =?utf-8?B?UWlHQk9wSGd6bFozZ3BYaXBHRm81Tko1UDVmU2VBZm9JNnBPeXRSTlB4Mi84?=
 =?utf-8?B?Tkt0b1JGVUVnRkE3WG50SnhPVXdDWGxZR2UrOTVpd21Mc3FnNUdXd21vNndK?=
 =?utf-8?B?SWlDNk1XUFppRHM3UnpXYVp1d2sxalJuQURzZVBtQzRGR3UraVNzYUNYRWpX?=
 =?utf-8?B?clNCVUQ5TFhza29WOTNDVGdHV2J0Vy9yQTYvMHoxQktEdGFST0JMK0RoU0dr?=
 =?utf-8?B?M0ZhZU1DOTEwUHBER2poRjMvY3U1WEpkNW0xbHhjamlIMXlPbHFOa3d6cG9h?=
 =?utf-8?B?S294T2k4S3Y5V2k3Tm1ybTRSalkxNGQrd082RzdUU0xrWEpZVDZOYWd5QnJI?=
 =?utf-8?B?YnNrekpERm1JNFlxUi9EQ1JaWW4xN1ZHNko3bTZQTWgxbjlIOUM5WEJVblJs?=
 =?utf-8?B?WUZUczNXbkJ3SEZZUCtVb0dETERxNThNc1JkL094bkR4bVNoZERQTHlRdkNt?=
 =?utf-8?B?dnZYMlFxdXNBWkJYb2tOend1LzFUeHlad3FRMStyOWNkajEzQWUvdGkzWTVt?=
 =?utf-8?B?d3g3OWUweGZvVnVXY0REZHc5aWJkMER0RkdkRUYydXNVT3lVdG44dm13cjhl?=
 =?utf-8?B?QTdTaDhwR1kzUGdXd2hnK3lNcG9BVThCakppWnhRMFg3d0JyV29iYk9qRzdm?=
 =?utf-8?B?dGtKbGVLOVpBOUcweUM3dWRjMXRtTlYyNjJIY3lxYWllcDRnZHBqUjEyK3A1?=
 =?utf-8?B?bC9vbHcxWmNxd0pJSEloTzBkMitmUmRXZ1pXaGtOMGRvQjNhYWNTT2VzM1gw?=
 =?utf-8?B?ZThHZFRLQXlaZytsbndxNHUyRkp4Qlc5Zk9DcTl6QU5peW1XQmtHRTVscHA0?=
 =?utf-8?B?OWlMR3BaWXJqeUVqYmFtQUdWUjhzNmVwekVuOExQMnhWaDFFTmlNc2lmQkhH?=
 =?utf-8?B?clZVeUx5ZnhzU0hYVHVuRUZpRWdMQlFGM3F6OUxNb21xY3R2ZWdSbjFsV0F3?=
 =?utf-8?B?ZFNHM3gvODRqZEJ5eUhwK0NnWHBpaWJpSUdZUk85TkVaRkREMmxhbSsvaE9D?=
 =?utf-8?B?L2UrS3VIQy9SVGh6cnN0RzV5ZVg1VGtnUjNMR1ZYQzdTV3dtWXJZMitKdWlw?=
 =?utf-8?B?YndFNFo0azNmYnlVVWZ1c2tPY0ovY2s4MFFFSFg0SGYyZzBNTmEyWXNVMFc3?=
 =?utf-8?B?enZUSmYrUEdBcW9zZHIvcHZ3elRFQ2hvQmtIbXJNTzNVODN5dGJ2dWJSNjhq?=
 =?utf-8?B?RGtkcjFNWFRyNDlaeFhlNWJNOEppNnJMaVlWZVA0SHZkQ2JDTkhqeXRsdWwz?=
 =?utf-8?B?M2JRc1hMMnlEZWg1Yk4zNWtWMDBuNXNVQWc3NVUzdW54OWNoTU1nbytMVGwr?=
 =?utf-8?B?MHdFeHpjSlFJRjBlUmYwb3ZKL3FvR3JveGx0OWpjS3JLdXJ1eTJhTVpmWGlk?=
 =?utf-8?B?OVN0U1F5eGkrZ2s0OFEzSi9ka2VRMzgzaEt2NDY5YkE1T29scmFEcjkvT0dm?=
 =?utf-8?B?eDVCSjlJUDZUUk5Ec0xuZHFFcXBjRU03d0Q2b25pSnZLR2hDVW5VcHZ4Z25u?=
 =?utf-8?B?clNDaXNTM1hOT09TbGpNVks5cnZvcnZkMDBrT3JCOTJsLytMQzlZbURLYXFO?=
 =?utf-8?B?djhzNHpLRWxqb2NKYjBvZGhkSkV4T3hwUUFJSUd3a0lYRFZzWTNmVWJZS1Bp?=
 =?utf-8?B?ajZFMThwNFN4NlJUemFXYlkwK04zRWEyK25qakFIejcwTkhNc0l0aEZhM09E?=
 =?utf-8?B?bE5UOWZtaG5LOGtjc2V4bzA1N0NKNjRQMU1PN3M2WDEvaEFRYXVENEZSMlNL?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c749d7-5a43-4836-38cb-08db6879cf67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 23:40:58.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YW0KJTUaUhMBUJITlSB4Z4lSJtNEiKmQgX0wvyK9yN37W4cAztGq8s3N+BNgK6kTuGWfqlSth7us4yFRErx2OswNooFEqzBXBt0aJ657Ji4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/8/2023 1:01 PM, David Christensen wrote:
> In the last step of the EEH recovery process, the EEH driver calls into
> bnx2x_io_resume() to re-initialize the NIC hardware via the function
> bnx2x_nic_load().  If an error occurs during bnx2x_nic_load(), OS and
> hardware resources are released and an error code is returned to the
> caller.  When called from bnx2x_io_resume(), the return code is ignored
> and the network interface is brought up unconditionally.  Later attempts
> to send a packet via this interface result in a page fault due to a null
> pointer reference.
> 
> This patch checks the return code of bnx2x_nic_load(), prints an error
> message if necessary, and does not enable the interface.
> 
> Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 637d162bbcfa..1e7a6f1d4223 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -14294,11 +14294,16 @@ static void bnx2x_io_resume(struct pci_dev *pdev)
>   	bp->fw_seq = SHMEM_RD(bp, func_mb[BP_FW_MB_IDX(bp)].drv_mb_header) &
>   							DRV_MSG_SEQ_NUMBER_MASK;
>   
> -	if (netif_running(dev))
> -		bnx2x_nic_load(bp, LOAD_NORMAL);
> +	if (netif_running(dev)) {
> +		if (bnx2x_nic_load(bp, LOAD_NORMAL)) {
> +			netdev_err(bp->dev, "Error during driver initialization, try unloading/reloading the driver\n");
> +			goto done;
> +		}
> +	}
>   
>   	netif_device_attach(dev);
>   
> +done:
>   	rtnl_unlock();
>   }
>   

