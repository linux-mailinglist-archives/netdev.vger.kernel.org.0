Return-Path: <netdev+bounces-2404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CAA701BDD
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A64811C20A71
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 06:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819B3186D;
	Sun, 14 May 2023 06:00:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693A9185D
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 06:00:47 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA40A1730;
	Sat, 13 May 2023 23:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684044045; x=1715580045;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=gxHm+L2JtZKfzKT2LTb5r435pH+vnhx0iVAJm8yCETQ=;
  b=dNoFFqJonsMOwzh+DhXDeOcD26R92ywAd4DKGp8pRKe+Qrjz9e54e3ie
   SO7G5jBBiK+3HeY3UZCN/VdjFd0xq1Nf+hCu+kWoSsJO8iPT5lZfRex6F
   wsQYAofvIkJ31bVBUyICfiYAR1gBBTX3RAUx1QExuzoPMCEZ5msunZKUR
   y7wZULr11BpAsmIKK1MzhnkLNMFMlVVJNL7J/lygJkMEjOJVSMNFgIrPA
   jYSl7O66qvKU2Sorkathi2+LVT13+VAI2MirCo8EKp7JGxFkU0hvkgCeV
   8JnhRA84YKaIIZ1/xwontSn6n3ikafTfjVAGA7KxKhp4DumLNbbRP4Kht
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="437349354"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="437349354"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:00:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="703598483"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="703598483"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2023 23:00:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 13 May 2023 23:00:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 13 May 2023 23:00:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 13 May 2023 23:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvfbNtZfpInugm9+V29iRVTpfXs4TnpH/3mcS0R/sJEQAc4veDKmledDUdSE+wzs3gjXRFVmp4axNXTnYBr+uATnLJc1WhTLQ3WCY1N6xNiLKLSImz/VdZVNM9c5d2M82V+B9uXL4hB6ztdWVO6BCuOZBoQaOs7R5DjokdE7X53w+/gr7zrsHTRUsD/Vcp2xbVGetRajDq+XolA1f6JPf+X6nX48VvBhfODiuSH3MxG+YJHs8cI8wLNNR0AsWUuXilNvSSTZdd/EGSEsAK9bBvoiZu7LMnMDMWHvCz60Z4ziGOVo2EBSpscguk8fOTNHtBJ810iZZeDCLabI3qsAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idve2rQucr1j9btqbewvJl4KayGIsLoE+00/ULvC9ag=;
 b=YEg4yuEcgfrLE7AqFsLGtpHiFCZdYLLcTcpH+SOOiZ1NRYMrATDEXxe4uSnlXsnkb6SB+kgfZq985nbYvPg+16hqr42N/1dHfbiu1wzQTYKE5Ajgv4KG+UNulwRMOf/Lkb5R/GY9mIFoFmRtpdQ0b+p+SivdzIJkE2gBfH2lE4hcRw++eF+ej+hNY0iuTZwaZGmhPBMjwWRObKOca4sYPrTiCnRsnUk7ZCP6hqBl6L77jszAkMk8ChxvjFaAlevOyNweqBUtPA3OphpUNywWerrJdUncrbIQIWzeEpk72/rZHiUqR/8ykMlUBqQHY5glp08fhgdSLi0vKVurkU+2ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by DM4PR11MB6455.namprd11.prod.outlook.com (2603:10b6:8:ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Sun, 14 May
 2023 06:00:42 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::df65:1e83:71ec:e026]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::df65:1e83:71ec:e026%5]) with mapi id 15.20.6387.029; Sun, 14 May 2023
 06:00:41 +0000
Message-ID: <c9ef1c57-3ec5-5cf8-c025-63527280f2fa@intel.com>
Date: Sun, 14 May 2023 09:00:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH] e1000e: Fix bind network card with ID = 0x0D4F
To: <kovalev@altlinux.org>, <nickel@altlinux.org>,
	<jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
	<davem@davemloft.net>, <kuba@kernel.org>, <jeffrey.t.kirsher@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	"Ruinskiy, Dima" <dima.ruinskiy@intel.com>, "Fuxbrumer, Devora"
	<devora.fuxbrumer@intel.com>, naamax.meir <naamax.meir@linux.intel.com>
References: <20230512231944.100501-1-kovalev@altlinux.org>
Content-Language: en-US
From: "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20230512231944.100501-1-kovalev@altlinux.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::20) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|DM4PR11MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 81114e71-e0e9-45ad-14bc-08db54408c30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 030+60B3pi/8xzP23varAcowvY6BVCp75Phu1mwvI26lE2weXPj7hXUkpn/3iqsmckdb5dA/GLowqkTF2aiYUg2ruE5LB6eIEAc491zEwASKNsj78Obf01q9+NPHSux8G4lZC9FQhiJpEV39tOix3n4Pr2nhzC4aLevDaQW5hgx8WDizoDRhFXpCZ/n47ktRo/S+gge1bl0uHqQs8uOWFckM8spdRNdRnIQ5+UVdtYNcopSWWaR4gIuv9Iki6+ZBkn/tGAS64+ZRwKD9YegGzBwlt8gwp/Ahx11duKjcl7ooojYC5YgmO32Dc+UcEWpgN0h68ZwQYDYsbWJAsM0ZgFMDfkRrKsZLxUkGA3CTh18Q00sktp4fX+GfLx1B6BgG+hTpDc3m1ZVWy4uJV2uL9l+o4PpID9FANFeGvE5/7NF3fLqhBrvwCMwazN6oVqLi69N+tahxNOtdIUOMg5s0w094BIebckchrYUdpygsv0c5LFANHUG2rQeX7k9f6gMZAXrcI1rMmc6gX9jPZsLkrPnevnXk9adDxt3uBws09X3HRVzW434ORZqUY5WEgcNuhYnaPeLpUetnxxFa7loNkTB6FKqPaRpoTaD8agtZeOn3+5iYOitBi6S/3HlwoCybe8REOC69x5ZnkwDf8uYj2X3FKAWSRw9PTz65LkGbxOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199021)(966005)(6506007)(186003)(6512007)(6666004)(53546011)(41300700001)(8936002)(2906002)(2616005)(8676002)(66556008)(6486002)(38100700002)(7416002)(66946007)(82960400001)(5660300002)(478600001)(316002)(36756003)(31696002)(86362001)(921005)(83380400001)(66476007)(26005)(31686004)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXZWUk9BKzZJN1kzaFgxVXdnYXZQWWM0S1NhYnZsNS9VSE9wZW1VR2RBblRR?=
 =?utf-8?B?djNjMU4rT1A0TmhoSlpLdVpSOWJLRWdMSjZtN2tSbEZLTzhyUnFLVjJCaWxL?=
 =?utf-8?B?YzBsdVJyWEcrZnlSTkxJTHZISDVENnpUS3FNTGwxejlyTlNzNHk3cGdoNHkv?=
 =?utf-8?B?bkRlTnhpYTFXV3JUak9Xalh2bWwvVEFXNzYzRFVnOXhHby9UWm1SQzM0dFFQ?=
 =?utf-8?B?ck9rRThIaUlXKzFucmtaS2xiTEZhMHN1ZFZsLzJMUDA4akoxQjJmQjJjUmJH?=
 =?utf-8?B?ZXYwUzBQaFNIdUJoeWJLNDVBOXlkb1ErRENoWTJHM2FPbktuRXQyUkRENi8z?=
 =?utf-8?B?ZllJaEcwRVVEMnVObENINS9pWlA3M253RUhaeVMydTF1YVcvNjNLUlVDbHNr?=
 =?utf-8?B?a1l5VkVmRkVSUkgyWGNQMi9uN2xNY3VNS09XL216RzRTWis4Vi9SYWM5K1Bn?=
 =?utf-8?B?VjdqM1F1THBPYkljQ3k4MjY0ajA5RFIyY2RwTkJObTJnOG9Id3VyZWJJVzlH?=
 =?utf-8?B?TmNUQkVrNHRaRzFuek80UEhDRWloK1loS2EyWFdFWnJLcS9VazVWaVZiVEdJ?=
 =?utf-8?B?N3BqdnJHZm5LZXJCWnJaV3BxeUdsWDZ0RTJKSUZUUUJCU0JKNmsyQkRsQ1Fa?=
 =?utf-8?B?eW5HUzBySlZKTWU5WUpWN2FHWHZpR3EwYnV0MW1LYTlkSUpLWS9vV21aZFd0?=
 =?utf-8?B?ajJmT05OVE5rSlN6UjZJY0hQZHljdEtsRndPdnl5Y3piWEdQeEh6blZ0dUZR?=
 =?utf-8?B?NzNYT2xlem9KeUZZcDFyR0xPMm5abjBxN3NDcktKazZMY0dLc3JKMWFOendS?=
 =?utf-8?B?dlNpenRxdDNEUEdOWk9ZejNlNS9HeVJUUjdodk1DUU02SzFvaExkNzB4ZjVG?=
 =?utf-8?B?MnBLenlrOStkbkQ1RjlSZitkYU1HZER0MmVubXlXTHpXWitvd1hlTWo5Nm5K?=
 =?utf-8?B?MEVIZVh0ZHRyN0t5b2V2U04vZC85ZkpXbVo2RHVweGp5M3BESU95OU1Dbk9t?=
 =?utf-8?B?bWl1YjhaRFpwME1meUtJOEdRMURZUlV0TjZoZGJERFk3QWZUbHFYSFZ3WkF0?=
 =?utf-8?B?UlVXSmFjbGUrazRjc2NLZ1VQaHZvYUNMelc0L3YzZjlpeVFldUh2azBUM3Bm?=
 =?utf-8?B?U05MUm4xUkw2SWlJOUxVbjZzdkYrNU5aVzROTEhTZzd2UmRrbWErNDI4NnZ1?=
 =?utf-8?B?cWlzZzV4V0NENjBrcFJPOFZqN0xVNTMzRElITyt1QS85OHFiejFWaGNIK1FF?=
 =?utf-8?B?ZlJ0N1dCN1lqbE9tK3VPdTR5bk5yY1FZV1ZUMnZLb0lzR2R6NUlxR1BVNnBw?=
 =?utf-8?B?MVZ6V25lT1ZXUFk1SUJxQmZ1TCs3aTVkV0Vqa3VQbENLcU9RNzBlbEhueWxQ?=
 =?utf-8?B?a2ViYTVYZWZERWNMNFZQZC9xTlV4NTFZMW0vSWtQVkhYMDFFdmpNNmN5Mk93?=
 =?utf-8?B?ZUpKOHdiMEoxUTl6SGUraFFZMmJScmtWVzV3U21GNTdzZlc3ci9IdVNSekEz?=
 =?utf-8?B?a1c4aE5BeEgvZkxaVmd6dU42VnN2ZXk0UjF6TGIzUlRpay9ULythOFlvZXU5?=
 =?utf-8?B?QTRiOGExOUtjQTFwZGM1WEVZTU5uWjJraVh3VXBNdUt1RGhxYXZQbEhCWjEv?=
 =?utf-8?B?eVROSVZzNGZ1akxMS2hCWEt5VUp4VXhCdWFSelE1cXBKVVRtY2ZJZ2VXSENv?=
 =?utf-8?B?VHhwbUZINTFtbnhQS0RHVWZRT1g1LzI5RzRZL3ArVzJYbHBSNmlFR0t0Sm9L?=
 =?utf-8?B?YXYwWnF5T2xBWFhuYTVJNlBTYm93RnR4SnhNM3EraHZSSlJCWm9rd3NEQ2w5?=
 =?utf-8?B?c1ZROURERTdUYzFXN2ZKbHB4L1lUSFB3UjFibks0bitOTkZGV2QvSHY5UHp2?=
 =?utf-8?B?TCtTQXNGaEFBQW03Qm9MYktPTm9QK0xGNGdXeWlqTlpkbHJjR3lhbW1ZWmlh?=
 =?utf-8?B?bFgxTDYzME9MOXhlR1ZwSDNvTENFdGJta01QL2ZCQ0dXZjZzT2lRQTJlMjhZ?=
 =?utf-8?B?NWFPRVBWU09UTlpIV3BRNHE4NkpZVTJNZWVWL1RIS1BxZXQ1MDdnTEFLUCt4?=
 =?utf-8?B?R0tUVSszWDB5bDR0WlZwQzM0ZWFBc3JMWVhraE0zaCtURVdaNGMyYzcxWEg4?=
 =?utf-8?Q?QwqRPx3LTk2bIcAWBiI75PUMC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81114e71-e0e9-45ad-14bc-08db54408c30
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2023 06:00:41.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZEpWrOkE0E5E96Ld0cX5zQJy0uHpyKUMKS5DqhKkkcD5nMNZTSjy7fVWUR8b4s/n/j5bVtPkkVeLU/weeWqSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6455
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/13/2023 02:19, kovalev@altlinux.org wrote:
> From: Vasiliy Kovalev <kovalev@altlinux.org>
> 
> This solution fixes packet loss during download, allowing you
> to get into the range of network cards of 639e298f432fb0 commit.
> 
> Below is a summary of the hardware:
> $ cat /sys/devices/cpu_core/caps/pmu_name
> alderlake_hybrid
I didn't hear about such combination. Something wrong here.
> $ lspci -nn | grep 'Ethernet'
> 00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet
> Connection (10) I219-V [8086:0d4f] (rev 01)
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217436
 From attached "dmesg" I realized you use new system with old BIOS 
(where is NVM of the 1Gbe adapter is very old or wrong). I would suggest 
contact vendor and update your BIOS.
> Fixes: 914ee9c436cbe9 ("e1000e: Add support for Comet Lake")
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index db8e06157da29..8b13f19309c39 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7887,7 +7887,7 @@ static const struct pci_device_id e1000_pci_tbl[] = {
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_LM9), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_V9), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM10), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), board_pch_cnp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), board_pch_adp },
This is wrong approach. (we can not process old board similar as new)
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM11), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
Looking in commit 639e298f432fb0 (e1000e: Fix packet loss on Tiger Lake 
and later) I would suggest to replace the mac->type as follow:
"if (mac->type >= e1000_pch_tgp)" with "if (mac->type >= e1000_pch_cnp)" 
(more correct) - try it on your side.

