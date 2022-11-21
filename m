Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0306E632CA6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiKUTKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiKUTKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:10:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAF4D2F78
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669057842; x=1700593842;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CLO7TlCDncJ490C/vRJQ4I+0wKHhEtlDL/wj/P+BAcQ=;
  b=C3niGOZR646i0+Ay9m6IJZig3Hv7OfBdtL2J1WF8KZrTiruTG9kJyG/d
   lNUs478MMpKRoyp31VQCLdh7QWtgtDYmvveHOEgntNVZOcNUwMIlgzLnv
   t3Tn23VrS3M7FJ2CbABqbhkBpSA0cVqWkrPNRh8XtiKAQWRWXXDzqnHGJ
   gyWRkPMPfL8Vspvryl4Idr85orPVZ7fZebXpxZm6GmjS4zLQVPL/VWul6
   xWXbctDC+PlXL7DaID96ya4MimzY4srvW9OJ+4RxqDMdbo2OLeMj7dlAR
   ffzZ0BddzT33p4eWNpPuhDD+JlnBk0JT62yATZRZNOhL2tQWy9Lxu+S7R
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="315462772"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="315462772"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 11:10:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="674081555"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="674081555"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 21 Nov 2022 11:10:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 11:10:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 11:10:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 11:10:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUv5hS14D3YnB7zTR2iXB3IRiV+AEdL92XRQlCLx2UHuWt6jUPN8jgYzV3w/Sp+eFzEXFtCBFmGOLOJvkp6FViN6g+Agd7ZVMOfJYkS/0J/WPwk5T9Kn4f346/iArdo7u279pSf47m1FabYbj97OdlagMdwP8yil7wiGAZYLX5+5ukYOCgOrxEThWLlRiS7wjzgWIvKQMLGVC9nILVMFcX29sfNFRp0U//iLLBGySHHLj58/ncabOz4uT3YAMo9GdM2mvNblkyARiPpry4qtHMX3fv0suOPRlf/8tEvuFeqykd8hNpi+b8Ajh0XzGkutfVvRw40Ki4U1EbAqbdVUyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+eCTkNv5YU6WKTDDAg2QnD5FD/Z58o30+m0atVH/XI=;
 b=JbzS1MhunVY7q3tl5m2vU3vItyoSbw5yf37Z2erYrut1EAe0VEeF+mdIHdZ09Wq6umGNGrmulf3cnpBTWWTQtbUGbUTJbBF8g1pcRT8vI+ji4EtugSJfHHjjVZSlK5QsvW54pw0hFsmZ8ZSelEZ96/xQ822FjhqhFAlfIdYNxz5cfgHL9peczrQxvrowOCpF8xfIETW/sejxAD3kyIjTrj0igijQIzWVO6hzlIQ065Z4lm1FP91q18XvrPyNaTJ3r5TyUP+F29P+xMg6d7YwynqBxm7pTutVn+J2ej+BEpJtiTbYsXF5Z9QnArT8FR9R4Y7YsKT6j751aRHQCoJCVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4559.namprd11.prod.outlook.com (2603:10b6:806:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 19:10:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 19:10:39 +0000
Message-ID: <243100a2-abb4-6df4-235e-42a773716309@intel.com>
Date:   Mon, 21 Nov 2022 11:10:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 3/8] devlink: report extended error message in
 region_read_dumpit
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-4-jacob.e.keller@intel.com>
 <20221118174012.5f4f5e21@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221118174012.5f4f5e21@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0153.namprd05.prod.outlook.com
 (2603:10b6:a03:339::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 151df868-8a38-4a44-edc6-08dacbf413c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0Gn9PnRP5QTWXYuzAL33bmb0qWP9PI/VymWLb48VRej3OZkPkDFZG2L3HzDxaG7atZEv1yxSo07YI8NhWXk8kjcmcN88wp7eoVWDzpAorjQ7GiHjxXcJD53Ge7hyTnvya+HxtADAS+A9fpMbftCBUhfan5Rz4G6UVbyNBMosi0qA7HPIAZ/PidEPyqnaqv3V5ilR0D2dGT0/0TWgJG+JeqmUUe1f62xkhKNKhwXH5HM6KuDIV9tRf5+diye1jONYfUtY2tkTp41dYQNgWELxqKvoc/CCncOLmYElSvLazEpVs3Exp7vw85agCbpG2QGIPRZGec4jg6O0UIhByK8at5m/SCs+7JKAlHDwvPyMXDTS1kIvt65zOBATBsuJyJzcpERJ6c/4jw6cyv5LwSld9j/D6cdNK+dO0NAK9du9R3jTqrpte+W8cl6Gc2+/1d/BjK/osfoRCJ0VYWaDWscH6oZSOZjgiiG/RkEFGSXTriTn4MCZm8yapU0ZHSCl87xxMBIZxMv+6IY9lqZ1K0SzYmtosq+j8tApog+m4oYaB/Z9MJwf9L27uCQ11+jzdlp1pTd5XaEhGYEuZt2hGdeGx9sLOjsNZJzU2+1dXSghAukZ9amToUyTSI5gAnTcp/SHdXxmS4VFe4SXyNR/hsNYyl1Rb7T8aZqZoWIjXv5KpI4Rp7rdIYhpsC+mZObEfzq+HVeluAa/SSZtnpo27KQF1FX1kQnW9ufUvoxmSBRKu8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(26005)(2906002)(53546011)(186003)(2616005)(6512007)(38100700002)(83380400001)(82960400001)(6916009)(66556008)(6486002)(6506007)(8936002)(41300700001)(66476007)(66946007)(316002)(4326008)(478600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGxDcE9DWjgxYm0rQlQyaEF0azRaQ204RGU3RlVkME1tM1Jyc3Bla0RIZnZr?=
 =?utf-8?B?U29BUWIxTUhDNEx5RmdSTzVucXJhZzVLSGlkUmtPRG9RaTRHdWE0LzNYVExK?=
 =?utf-8?B?TEpvVTl1eExQbmNaMUJWQm9HdkVwd0xZY244Mm15QVVLNGRqRCtxcjdyNDMz?=
 =?utf-8?B?ck9lYWt3LzlNQ201dklzTzFUQ05EYUZtUm1nMEhLTERUaGlLWVUwaTVzTm1T?=
 =?utf-8?B?d21UOWZDbng3NmRMNmVEZ3gyUmZNQ2xJNzJSTTFtZmJYMlZVOWV6WmZGS1VY?=
 =?utf-8?B?SnRoUnl0SkJZdWVwRVFwZlhtcHVJTU9OQTVGM0hzVFJuRFVIeHRlbS9nTDZ2?=
 =?utf-8?B?Q2kzZWI3bUdqZW43SEJlQzZEMEtlelM1Q2xXQk1FdjhFd1p3MG9EbCtjQmY1?=
 =?utf-8?B?L3ZQb1pUN1lBNG01bFJlUjM2WnJNYWthdDZqWkNsa1RKbVVCM2Q5T2hIajl5?=
 =?utf-8?B?OFpRRXRGblNpNnRXSzdWZ2xrK2RoZWVTbnNvVnk0Nkh4VVE0MFB1YVdiemV4?=
 =?utf-8?B?YVlnc0YxU08zM3RFK2Vxc21DSjZmRFhRbTZVMHN4aHNpd2dXRTNKdEpxSjVB?=
 =?utf-8?B?dnllclNBQnZnT2IvUmQ4SE9zZHBObGdQdzI5amxXaC9IektiUFNSM0dBMGVn?=
 =?utf-8?B?d2JqSzVUWkFPQUQvYmJFWUFIN0laY0syY1ptK1NnbTVvMCtZcDZKUUJJREgw?=
 =?utf-8?B?NTg5T0RpZWJuSEI1dFRoMEswWHVBRTBCQjVQVHBEOWFHSi9DN0xQNkhUUlBn?=
 =?utf-8?B?S0FKWGtFVVgxbUsyc1NVbzM2WVZxVU90RWRTRG9tWENMUXhxNnU3QjZHb3Ew?=
 =?utf-8?B?UzFCaUZSbkgzbkhuNFI1dmFZMTRHdTdGVmhhYWJENk54KzhwRzVmRy83SUUy?=
 =?utf-8?B?Z1EvQ29aM1JnYmNQblV5YjVqcXF2ZEJRYkU4OWVLT2tpbXF1ZUR1b0txTUN5?=
 =?utf-8?B?ZnM3czkycnVzTGFDTVViVW55RzdZQ242eTRybDhsMGNCQThENi9xQVlkdkdj?=
 =?utf-8?B?aG9ZMjRZYVZkSnZLTWhEalduNTlacXVCNktpQzM4bWpheTYxQ1VRZUpuOG13?=
 =?utf-8?B?WlJ5Y09sY0U5VzNnNWNwWmtpajNocHlsNHp5OHlqekFlRnU1My8vODB0WmNR?=
 =?utf-8?B?Ni8zYTFCaWZBU2Zxb2kyYm1GRTVzTDBXQVRvVmRzRkIwZ3Q2V2IvNWJ0aW1Z?=
 =?utf-8?B?ajZwN3k5bmdGMnpONW44T09MMVZkSjZhY3NYMnJqNmRZeWcwV3hOeUdjbTI3?=
 =?utf-8?B?VFNKc1NPNE9NWVFTTTRYSlFHaDFnZ0M0dGRBOWtDbVdaQUlYYXhXc05PeVNB?=
 =?utf-8?B?TzVZcW9EN3lUQ1dpcUEwWlZTMnJRUU13V1ZtOTBSZlU3Wkx5OHNZMGlPMUdP?=
 =?utf-8?B?RmE2Skswb0svL2ZVOWZaUDN3akRTREdTK09EUGlCTldiTHhJaDZrVmtTSUZE?=
 =?utf-8?B?SFBkSjBQRHRudkxmbHJSMkFJRzF0ODMvNzg2K1BvVHFMU1dCeDhpUHhPYzBt?=
 =?utf-8?B?WXhZUEwyTUxmejF0ejVDc1RUcVFCUjVnL2x1a2RndFR2L1ZkYm5NblFHUmg0?=
 =?utf-8?B?ZkNiNnJITGNBZEVHditTa2JwTU1LUXUyWG5aL3JmaHNXZE02TThFeS9FQWhT?=
 =?utf-8?B?dkhmNjZJZmExVDVEUnRMTW91WTUrZHAzOHNJMDB5TFdvU0IyeHhoKzJuazIv?=
 =?utf-8?B?YmZaZnA2UjV0a21Nc2FmSWhheEFsYnl5dWtCYTZwOVYrQzBBL2VZQnAyZzRH?=
 =?utf-8?B?c1Zjc0gzbmllRkpyZDNLMGdGS0N4VlhkY0x1N2lrTHB6Y2xhczFZSE9wT3Q2?=
 =?utf-8?B?YXYySURPLzIwMVhYdmFoSForUkFrM05ycmNic01KV01sNzNncHp4WTQ0WUg5?=
 =?utf-8?B?Ujl3THQ3dE83SXhuMndWaldLVll4OGcyKzlQODhFWngzZGJFblBPRlByT0tS?=
 =?utf-8?B?dW9TcXBybDlFcUh0L1BjS0ZjN05Ma2phaksrTUsxRTJsU2MzSTJwanZIcVVQ?=
 =?utf-8?B?YklILzJRVWNSWGQwSjh6N2l1RE91WFhiNENRcm4raGU1ajI1UmxNQzJrOHVk?=
 =?utf-8?B?WDE3TDFtekRLTjd4dVU3SVFsWHZFS0twaS9SRkVLMEc3ai8zZ3lrMXVlYkQw?=
 =?utf-8?B?QlNUY1N6QVk1bm1BSnczcnlCT0oxWnRGU0ljRUdZQnkvQTZtOXpmd3FyVWdW?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 151df868-8a38-4a44-edc6-08dacbf413c1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 19:10:39.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOjU3Xc1vL9W3MzTSK6DQ5/tx2ShsG9dmLsBSns5+ZEq9AL2HzRyhn3uuI5v5AhOAlBhFq3YFJ1xTLaYHxsTZZC+g9lJgJnXaCgjPHylvlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4559
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2022 5:40 PM, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:07:58 -0800 Jacob Keller wrote:
>> Report extended error details in the devlink_nl_cmd_region_read_dumpit
>> function, by using the extack structure from the netlink_callback.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>   net/core/devlink.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 932476956d7e..f2ee1da5283c 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>   
>>   	devl_lock(devlink);
>>   
>> -	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
>> -	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>> +	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
>> +		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
>> +		err = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> 
> Please use GENL_REQ_ATTR_CHECK() instead of adding strings.
> 

Ahhh. Figured out why GENL_REQ_ATTR_CHECK wasn't used here already. It 
happens because the dumpit functions don't get a genl_info * struct, 
they get a netlink_cb and a genl_dumpit_info.

I can look at improving this.

Thanks,
Jake
