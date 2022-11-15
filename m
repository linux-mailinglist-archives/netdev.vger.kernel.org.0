Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA40762A1A6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 20:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKOTE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 14:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKOTEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 14:04:25 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ED92A95E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 11:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668539064; x=1700075064;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=bSxpIHsyDiQZSBXZoPU00MEZuN9SHzp0mGxn0dIcuiw=;
  b=GXP24YvNvJmYrE7Rr+Mv8xuMuXrxbc/PwOJDjTy2DBN+ZorDGg+Gakpd
   mEVDiIOO69kRTgufPsQbHRoCsJ72Ythl4ysfpMPfeyECz6bd7Bqyz1lWU
   rKxBAs65O760KMrWzLtTPEWWmTX4XO/Ue87SRcSO7LItD7gkOAEjJEhkT
   gNEyJzQPR16W0AcO2Yl0fxLRhkr/CQPz2FViCntbCKuIG5ncx+1urBKE/
   R25LXi34SN0olyUpAeEIuUobmJLiRdz/Na3Rqq/nZxq43Rvq9QJYzJZ0n
   9DZFNHYlmveX2sj1k45KPfknKxkiXhpsObDTq5a1cUai/CzvI/b50yBx3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292051802"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="292051802"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 11:04:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="639057455"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="639057455"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 15 Nov 2022 11:04:22 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 11:04:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 11:04:22 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 11:04:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8Ebv+n/c8QB6u0WIct30aU88D0bnfIgvjeGhw53VIxqHcZAiw8RxRIEwsvwIqm07edn1UAb77w0yrN/TJ9A2Dz4m95AJHINda8EcFPZoFEII63fDUVEki15+1yqh4M1gvq6RUev+Z0EqewawwUFBVWk9xR6Z+El1T9R7+T1aUtrDBMSPq8nmULAmtERG9UCed/Rhd/CT5WyqEKyJTg6afo5rAayRMjaWaHxhnF0IOPUcesKy4DXJkeM7+y/1U4SKOaJ++xDrln35j4mGwZvIlPZU9IPSVVwVY3v2wQEa+t4Zqjwb0Hq7OK5whx4QpO4xgdXej3ubbqqL6WPwb+0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIA3wJv/nhcU3ViCX4EAxJo2WPMqO+1KA2qEtMkBUoo=;
 b=QQQGYzfNe25FWuZeZ5m/MJOZri7v/kOCQtikR947etvD+SO1pjrOLHQa1UGqwNRC5AOgYbqyef+qq9Hi0OP3pKSZQuERs7jCSw2WQm0/ozJtzkPBc5sZ6bVEhb5lcZiEejWkOw22Ulnwou8uv5yKDceo3Xnt/nAbEYhRoQl8e+MEDyk/HJagAS7dKS/EfKRUcYCkgmr58UYM7skTFOYqRY3NPX6bdf52RQYHV6N0nVCQvVdB1KPK74lsapqzjVtGZAN57oiDMgV2lkR0Xzt8IGg0NpHol0GzYGmjsMqMliOEAnMfinTdV0mcEw1W2i4NISykl+WjXa2LmYOC98C7BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 19:04:19 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 19:04:18 +0000
Message-ID: <48014a1c-9fec-1bc9-ea81-9611bce742fd@intel.com>
Date:   Tue, 15 Nov 2022 11:04:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] i40e: Fix error handling in i40e_init_module()
To:     Shang XiaoJing <shangxiaojing@huawei.com>,
        <jesse.brandeburg@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <shannon.nelson@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20221114011022.25127-1-shangxiaojing@huawei.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20221114011022.25127-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:74::35) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH7PR11MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a0d8181-b041-46a2-62ab-08dac73c3294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z54z/OoP+IG9nFVIFqUFDq50U1NkAJB4mCPEBdv7KI1P2l/0v6BjBEM6glccwjULYGGEtJBKHf89MFREfi+F07qHYENUai0PK7MwGv5wmA7Sum+YAkKr8hAU8HoaMZbj0p3ib7fjvKwe18+NQ5AaI3lulqLXzgVd/hYQF5L52VrRKnaH7/Py/ZQONif8MTtH0O78sOzEidhZMafCKBxCUYkC0sxP9xv3AR3hFUOv/8ugY0OnKebLqGY1pNWLgL8ltqNzEk9C9PuyV9q+JzdGaAHaY6+KKUX15vsBNKzvV8u8pVN527Nnp7mqm77KFYbQ1L17gQw7dsOcZk/086V5Po5Q/PKp9TLKt+BgFxN7b8/9p/l8ZBJjHtdCwHi1bDp/hZ0swH+N5k3vRCIw15qBW98+F279y9gykddeWvESRlJ2VOFDDkHUbnoJl6ieVjbVoUldw6gpVfzH7i4MXIF6Ap9BRSBiaINhVJLqy8al/HdQgVD73KXVWdBnJuxJSTgb8BlxWMai2qQz/xjrwtQcRCHPpG5/aBysOkZ7E8wucDCTwIiAomJ2Oyn6jranEtRDL9Oadxru5e4mq9yruMk7AfMNCC12Ol2hCKI74TO+LbYOrxM5u33GEyXIi2JYc+DLIrsJLrWjIY5A3JiZuQ787/v7hE1QTRYL+IW81hRWGGxAirSD8gzAxF3EWpiAcKHON1H9H/7hLVSU/1vnhYIR/VyEZGD2cbjzj3eL9GoeTGjrTI5pw3wYl3AlC9wI/aEPqF7kaReQkj32lLhJG+GxVaVg5mJinQjVji/dJX4rVJXaO8rqWXp/TEUYBJ1sT2P2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(83380400001)(2616005)(186003)(36756003)(5660300002)(8936002)(41300700001)(316002)(66556008)(66946007)(8676002)(66476007)(38100700002)(2906002)(31696002)(82960400001)(478600001)(6512007)(921005)(86362001)(6506007)(53546011)(26005)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0szQk11YWVoLzlWMGo3WEFRNVExQVlsSnBQSCsvcTdublFTcDNIQXNJaGZE?=
 =?utf-8?B?dTVEN1JiUjFIZGh1SDAwcDJHUFNMTFI0MmV1U0VYSnBUbXRLam1OcER0U25L?=
 =?utf-8?B?YnRsRUk3bStPRkEvVldzVTZHWjFOUVRiM2JjK3A3RVcxVkhHamN4cCtEWXk4?=
 =?utf-8?B?VkZyZ01IWjl4aXRMWTAwbjN3TEhncjZkQTVZNDRYc3pZc2NXKzdNK0VIZzMx?=
 =?utf-8?B?U0JmK3lFVmNEQ3ZTRHZtc1U1Z0k0U1dJRHU5dDBzWll4UGJJVFdSOEtQVEUy?=
 =?utf-8?B?cTc5U3J4K21iOEcxMkhEelBIc3BhT2UvTXBHUnVzcTRsY3FGalYwZ1VBOXRU?=
 =?utf-8?B?OFI2Q0dDUkovQWNwY0QzU3laQnN6RDBwUzkvVVM4VFh3WHluZHQ0b1dTbTVC?=
 =?utf-8?B?Qzcxd1h4c0dQUHVrRnJiTTBldnBCZWFlVHhENEFzNDF5dXJrOTNiY2hQSGZy?=
 =?utf-8?B?N1hXbXIvbVNQeFFOblpwUmFEam53WlNYUStLTE5iNVBNYis3NXhuTkg4TE5U?=
 =?utf-8?B?STMvNlZnM0FRd3VjZWlHY1pIRytmMGZOSWE3SzM4amdHa2RzbjhnQmdxaDBo?=
 =?utf-8?B?YjZXS1NHWkRlaUNwK1Zla1RzSjNnT0pSc0Y2ZjhuaUFvM1VlTThCVk5hL0cw?=
 =?utf-8?B?Tzk3OWVVYVBQSVEwNUlYT2RNcnpjNTNycU1hWEl2aEpvWXRMTjMxRk1zOEVi?=
 =?utf-8?B?MFg1c1FpeTJwRzYrdGZNcTdsbkp3cmhTMkpoREZ6eHlqOXl6OFRGU3VHRlRY?=
 =?utf-8?B?dGUvRGdVVmliUVJvUG1MY0tRM3BISFZBRWxWcnVDRDZKcHF6V216MHM3akx4?=
 =?utf-8?B?S1lndzVkN1V3RXEvOVRPclVwM283WGN0VDd2aDBLdXhmbTF5T0Z5RVpvRCtP?=
 =?utf-8?B?RmJwZXRzNm1pcFJCUDVHa1BNSG15SkozRHV6V09yTFhBaVJWd05RL0crSFFn?=
 =?utf-8?B?aFlNVVQvcmZQSEs0RXFRV1dWaHB5ZkJ5S0x6S2hSRWw5eEF5ZmplR1htWW95?=
 =?utf-8?B?NkJPRStjdE5ON2pWdzA1NGdwamI0NkVrbVhBWENHR1U4dHFwTE5FNmJ1VElR?=
 =?utf-8?B?cUJzNThzb0dmNDU3RnYzejd2ZnN5QmUzdkZveUpHTG5Odm52SzN1aGhyYk5Y?=
 =?utf-8?B?U1F0aGhoTzZGNFhIeDA1WEdVUW9kekx4OS9wdzhybkRUcm1BREdmM2VwdDB3?=
 =?utf-8?B?Ujg1NzZ2Z3ZiZ0VDZnRvcklQNWlkdkU3OVVXeFlQLys0WTlVK3ZObG0zTDRk?=
 =?utf-8?B?UytkWVo3eStFdHN3UC94SXZ4ekNrRElSV0xzY3F6UjZNNkRqZVA2NW5VSkI1?=
 =?utf-8?B?aHNIRDRzdWJXNVdhOWc5RDV5akYrdUVCTi80RFRabjhYY2dYK2hDcGoxYVl0?=
 =?utf-8?B?K1hucEgwWG1FRzczZWtEbU9henhtNUJCaW5oQTdBTVlDS3dqQUZQOU8zWUNF?=
 =?utf-8?B?Qm5qbHRGSzN6aHlhendaSEExekpVT0F0NHlncTY5K1pURGdJVXVDaEpzMmVH?=
 =?utf-8?B?ellsVkZkdlM0anc5L1ZTakxHVFQ2RW5UVC80dUFLZ0ZYZTQwTDVJbWZaZTVn?=
 =?utf-8?B?Q2RsbzNYZEl4cjJtTGV3czBNazBMdEhQYWdvR3JhWU5vTkpqOHNSOFZPSnpT?=
 =?utf-8?B?S21sOEswYkQwaThVR2ZaczVSek0yb21FM3M4bzhjdHpsZFVVdlM0c2Yxb2Fh?=
 =?utf-8?B?NkwrOHlFWkFZbHlUZmIwYXMwQU90cERIUkF6am1CanB4ZUpoeUZmM0xBdEkv?=
 =?utf-8?B?RGZEd2JJejdxM1BRS21Ob1V2T2FubVdSRU93YnczYndPWVFWbjBMeHptQ3Vj?=
 =?utf-8?B?Wm80VVlJcVdmRWVCdzArQm02SldaMVJZWGkwdlIwVWh2ZTRKYTJHRjQ2Y1VP?=
 =?utf-8?B?TldwbDlHMmoyL0ZTR05XSGJvYzhvOU03RXNScFB1QmptZk5TbFEyNG9UVlhw?=
 =?utf-8?B?Mm5LZFBkalh1eWErTzhHaXdSam1WYytyUlRid2tuRUJYRnUvejRraklYTnZz?=
 =?utf-8?B?bEFFWkRPaVVKY0k0RitJVGhYT08raEZ5NVo1R1J4OUh4dkpLZTJGcGY3eXRD?=
 =?utf-8?B?ZmRYdTQ0Nk14QlNPOHQ2S1NHb3BuZUJpaHd6WEY0SHVNbnBHbFhkd2EzWmJP?=
 =?utf-8?B?ZnFkZ2QrVHVzT1VpNEFQWmVwUVRZRHpIUmdCUWYxZEpScjJKd1Bpdmt3K2Yv?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0d8181-b041-46a2-62ab-08dac73c3294
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 19:04:18.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFQNLluE1BKdmAffLsxcCbF4Yxn3N8C5EfpmCjsMwFRY1gg/KBLQwzNAJ2yeatlY3jg1VliGdvd66EYDichbzbFSQIbvBeLcDfVPQWM+QJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5983
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/2022 5:10 PM, Shang XiaoJing wrote:
> i40e_init_module() won't free the debugfs directory created by
> i40e_dbg_init() when pci_register_driver() failed. Add fail path to
> call i40e_dbg_exit() to remove the debugfs entries to prevent the bug.
> 
> i40e: Intel(R) Ethernet Connection XL710 Network Driver
> i40e: Copyright (c) 2013 - 2019 Intel Corporation.
> debugfs: Directory 'i40e' with parent '/' already present!
> 
> Fixes: 41c445ff0f48 ("i40e: main driver core")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_main.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index b5dcd15ced36..828669ea946e 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -16644,6 +16644,8 @@ static struct pci_driver i40e_driver = {
>    **/
>   static int __init i40e_init_module(void)
>   {
> +	int err;
> +
>   	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
>   	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
>   
> @@ -16661,7 +16663,13 @@ static int __init i40e_init_module(void)
>   	}
>   
>   	i40e_dbg_init();
> -	return pci_register_driver(&i40e_driver);
> +	err = pci_register_driver(&i40e_driver);
> +	if (err) {
> +		i40e_dbg_exit();

For fail path, the workqueue needs to be destroyed as well.

> +		return err;
> +	}
> +
> +	return 0;
>   }
>   module_init(i40e_init_module);
>   
