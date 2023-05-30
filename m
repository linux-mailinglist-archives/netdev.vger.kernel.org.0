Return-Path: <netdev+bounces-6582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18192717070
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7099281336
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361F731F14;
	Tue, 30 May 2023 22:06:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20528200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:06:37 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78444C7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685484395; x=1717020395;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nQlKFsMBKz+5XSMSvL6HXLIlUlOn52c+7Z3K3tr27ZM=;
  b=b20QZoami0yQed8uqt5h1M3Oxdu1NFPMQ3cW2dHWvbmiSRK+ZVnzEcmM
   pD30/6+5M7ogA/8Qu6Ked14DZhSTfFH15UjV6RvGHKl73R2ILdG9w7ZRp
   blEjc2BB+AJzV6626cz3RvHvL02AdHJpEGRr9X3QT49M0lxA1YFJZpBLa
   5eXSl/y1mFIVz+VpAc+b9SnjvnVdEtZ8reiTANRgCnFKyUjJvGRjPNda2
   hawZW7P+Ntrl76AOAdwCULbQ9dOEUcZ6by7TGB2twAaqhuWqJhVE4IFVT
   OnmyaKq8IALknzf9wpX0sRM+NaaKkdKjJsCeRjyxtMEEmBD75EilPJaPO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441416766"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="441416766"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:06:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="819003211"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="819003211"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 May 2023 15:06:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:06:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 15:06:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 15:06:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0BSJDWBwy1HNsfKilC6yL1lEn6yu9eTLCGzXlI1MgUXRxmCljJpY3JQVUjtW2ryjzGg6UULOFLvgidnkhF1jOIQP+9N1hafL1LVItdKKbEloCA0U2BufB30KYEeYX0fl7gA8RhsDFlJ97mwx+B2vRW79rY0T71bL+c1RtCTvES1gji1OMjtgiTbaese/8TyhwFU+CScbGDHUIhLsFHqh8x8BQEkOmwi9QKVNbF4rjGi1W6AU7Pizrdm7execaQZh29or1cGNr5cuiuUFzE16i8+Wlt2WfIhZyoskjfhFxcqfvOuZV7BfN6i5bONRNYeCrKZHoDeszYwvWZFDRs42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiIKATpNf/H6zodpP6ex8CW0Mshoal1Cr7iXG9y5AKo=;
 b=TlQ9NsCsWY2lxj2UN1xF56yHgoTZd5BfnYeTqt3j/pS5H4+6pTzJzrbnqS2cusG75Gm9dcBb6lw4G5RF+psZNVhDgNV80HykusZS7a/ilufCL7cVpZbMyDzPc8K0gocUKNCiONelbDu1u436dccXWEz/0wlM/MXCncD4f4ax/NXXNON6UFIrPLvNDINz4yV/Pdv3pzvPxH1QhdHlBner7I5dnSJ4Znl6GtWqicSXkIG5iANPDBC8qHfzV20VRtM4iaTKMNnlkrxVYtCivTWevvg6l6LUmxOyQaPOqCH4i/rNH20+BtdRHNuUTHQMvBS99ddbkUFTJMhX5kMD6Y2EXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 22:06:26 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::61ad:23be:da91:9c65]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::61ad:23be:da91:9c65%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 22:06:26 +0000
Message-ID: <08806483-959b-925d-2099-561d0f0278f8@intel.com>
Date: Wed, 31 May 2023 00:06:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
CC: <intel-wired-lan-bounces@osuosl.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>, Victor Raj
	<victor.raj@intel.com>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Martyna Szapar-Mudlaw
	<martyna.szapar-mudlaw@linux.intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, <netdev@vger.kernel.org>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
 <ZHY8MqU4Kfb+aTIP@corigine.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <ZHY8MqU4Kfb+aTIP@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::17) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|LV2PR11MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: fcee5add-914f-44c1-b6c8-08db615a1ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/FG4PmBcwwOTiKcspyc+SF2OTjrTbNAJ6zPQqEwlQqBqsp9m1szVfQ+1s6cJI+i3ESUjPGLQW56I8mX1KNuh5s5Au6hwEKQF9pZB8OAz3KeDQeWzTKvVQ46/3M83DLX3PrLshmACKnWeCv4SpWy8Soxucn/y+8SeeGZsIMjmFovLEgn+HWZogUwbFJ2N/OMXrPYtxkNT68wjAK7FeMkGhyyk+cZzE/zRIhz0cx5VQ+o9QIiiz1BdVLwx/E3O+HsAF8+m4O1edAc8cKsjg133eRTY31tgrhp0o4PNn64HnG1lv3axk3N/LbaXEo+GEaIXu6if9Wu1I/5ctU2z82xghhYLMEJ4H+1uBV2GZDpuFIcbY0cUnXWlfpwCL4luS0uHY0U558x6GNxV3taN5th+x9VjBuMpHbzg4IldRs8dYX8px15ygnRRgWyM/GZ+YTCn332qHv8RKzMQZsSU2LhXkX1oq+DHV5gGzJ0+dIfPzBcDc7hz0FMxIMEKL1mVfXz8jPiEVdeBwiQmzA6vBEJznPaqJCSanfpCZmL+Byr6sLeAc1iDscodUvBGiJMSn3VewiEoceOYnsJWn6LTFZXFObhawc0y+tt5xanjzcu6FlXrEMyqQl9MfSFrwHO7N/nr2ptZjs6TueVJ0Uol+dTIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(6512007)(6506007)(31686004)(186003)(53546011)(2616005)(2906002)(54906003)(26005)(478600001)(66899021)(83380400001)(86362001)(8936002)(8676002)(82960400001)(38100700002)(6486002)(41300700001)(31696002)(66946007)(66556008)(36756003)(316002)(66476007)(5660300002)(6666004)(4326008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c21uN0l1cEJJZEUvVFVKYnhzS1pPVjVwbnYvT2FHRTRvRXdpS1dKQzJvd2tB?=
 =?utf-8?B?SDNlb0tkYzdBQ29TSE1YYVBSSEtoZ1RTZTJhbkg2ZG1CNDJWZ2ZybU5jL01N?=
 =?utf-8?B?em9wcjdmY3hSc2hZa3p4amhUVGJEeGNWQ1NWVFllNENPOFNZREpGRnM1NVpy?=
 =?utf-8?B?bWN3eGJKRDl2dlpBSEZFZXFHMnJzK2d0WXFBOW9GN2hSR2FjMkVhcGtkQW9E?=
 =?utf-8?B?Y091NTk1Uk9qTFZRN2ExeHJ6RHRjVXhuSHgvSitITWJDUldtYTdXa3RWakp0?=
 =?utf-8?B?NXptelJmY1gzeGVJcEZvZWxTaUQvZVJPTmVhaUtTYWdYTmJsV1RMM21NV1J3?=
 =?utf-8?B?Z1o2dVY2WFZ3emtPOGdXaUJzQitqRktZRFZsTVptMDY0VGcwcGRPMGR4N1VE?=
 =?utf-8?B?UFFyRmM5QjU2QlhraVNpMnhrQWNwaUVJQzFJNUx5YWN4QTI5dHJqckJSc21h?=
 =?utf-8?B?T3JuRmd1SkhRYlhvZTNIL0M1L3lteEYva000aGtZMStxZ21sV3JpMUptR1kv?=
 =?utf-8?B?b3dtU3VtR3phQS9nY2RReFJGYU04M0l0SXRXeGVKNXFNQ0tmU1h5RVdsV2Jp?=
 =?utf-8?B?K29KZXc3STIvMHFsUTJhS0RjdDRxUHpKY04weTVSK1BDc3lteU5mYS9ESXRU?=
 =?utf-8?B?RGtDSTl6a2o3Qm41UFV4aVVTV0d6MEkwU2tTdjVyZjlGbzg1RmNsNE9JMXhj?=
 =?utf-8?B?b3Z0N090ZzRqbjVpQk95WCt4OFJwNDNUUDlSREZLM1ZMUk4rR0FTUnMrNmxY?=
 =?utf-8?B?ZG5MMXU2NkNFZjNYeWtUY3dHaUEwNUQ4RmprdCtrOGcrcCtkL0lIa2N5NkdO?=
 =?utf-8?B?L1FSNjJYcEMyNVVCMDRaTHR3K1R4a3VvazdVd2MwdkUrMmIvcndvWjBFK2dm?=
 =?utf-8?B?ZUZQUjZmU1B3Z1k4VXRTaHdheHV0TjEzN1F4dlN6alFGSTFTSHViUlBwUGFy?=
 =?utf-8?B?dFoybENzeis0Q25BRTN5Z1luQzBTSDEzSHVDUTA3REV2SWtabzR6R3VJR3I4?=
 =?utf-8?B?bzRjbzUycElSYVJ6UFVkWUROMlZzcmJUN0xOY0tLOEZ6cGhjNVdLeVhKUi93?=
 =?utf-8?B?ZUZ6MGhWUFN4VE9tRjFJa1VQYmk0YjFsUFpMSGE4a1NSWk5yc3I5MUE0bjk0?=
 =?utf-8?B?ck1hcDZObEdYMGlCdXBRcmozVFo4aHV5enZZR0F1dExWZlB0NnQxT2ZkSGZz?=
 =?utf-8?B?RTI3OHVjdThpeWdXVGRFTjRwb1hTOFBkd0kxZlhxWDBkSG1MVkhNaGd4cWdN?=
 =?utf-8?B?MWJBNkJmS2ZqejhNREp4TVJMNmY2QTR2a0xyVUNiajBOM3Q5ayticDRqdnNI?=
 =?utf-8?B?ajVSdEs5bmdJeHNzTU9nQVhHY0JVUXZhRnl4L29lejBHeXd2WE1rd3FIcjJw?=
 =?utf-8?B?YXNidERDOUNEZDV3UkpqSzkyeVFxUDlid1lEcDJJV3l6TGZLb0JIcFdDMEQ5?=
 =?utf-8?B?VlBtR0FnSWxlWEZvalpIcXFPT2RhNElmLzl3YUVrcVcwaGpPZFo4NVVxbWtQ?=
 =?utf-8?B?UG9kVmRaU0ZNdExweTBISWZEUnhHazlmeVN0R3I0SDhtenBHOVNzelVWcXNi?=
 =?utf-8?B?TFdKYkkrRXl3VlBuV3VHc0ZWY2hLTHJLSVZrTjQ0SDZCZ3c2MU03YklxY3du?=
 =?utf-8?B?a1dGcUp1R0F6bUtiN2pmakF4MEJ2Qy83K3JGWUlNYzdqZEpacEE4NGdoNEFY?=
 =?utf-8?B?VXVzWW1TbWk2UEs2RTJsL3c5K0ZMdGFESmxQUVZmSTZ2TmlvM052QXV2MHY5?=
 =?utf-8?B?QU5jZHVraEtYNDNxNTlNdytObDdSSHNQUEpuTmdsOXR0MkNJazJaSmIzY1Zz?=
 =?utf-8?B?Wk1POEVvNmRNKzZMOS8vSk5mSHc4bmRUdkFmWVZnSnE5ajZiQ25xbjB2Z0tO?=
 =?utf-8?B?U1VWdFBjSlpOR3hlTWdEVTJwS2ZlaWVyek40M0Vwc2RXV2t3cVB1VzNYZHpm?=
 =?utf-8?B?bk8xcFRtOVJ3YkVXbG1UNXpaaUV4Sm9EYkpxd2lYekdvSmVRWGRPMDZCdTVx?=
 =?utf-8?B?djFCY2Z2bDQxaVFVTEJCSVB5MldNWG5iTll0dTVZQ1pMRzk5ZFpET3lNeFlX?=
 =?utf-8?B?ZVErTjAwbnByeTNFTDBqMXhyZWs4OFl3ZWxBZ3pCQnE4eVJwekhSZlFpc21l?=
 =?utf-8?B?R0FvTkJ0cSt6Y3pHcDVjNEVWeFUyd3RmMGRhQ2tBaU9ZeWVPZk9qc2hXYXpk?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcee5add-914f-44c1-b6c8-08db615a1ca0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 22:06:26.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFRhXPaniY4SCeo8d1SJT8iaqjGS1Tsq8XmsbaFqkplcFz8bPHmBw4DgmmAJIiTGVX/L1CHsGexuGys3dZb5uFl0m1AouQIfBRqZFp4BVB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 20:10, Simon Horman wrote:
> On Tue, May 30, 2023 at 01:25:49PM +0200, Przemek Kitszel wrote:
>> We all know they are redundant.
>>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
>> index ef103e47a8dc..85cca572c22a 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_flow.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_flow.c
>> @@ -1303,23 +1303,6 @@ ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
>>   	return NULL;
>>   }
>>   
>> -/**
>> - * ice_dealloc_flow_entry - Deallocate flow entry memory
>> - * @hw: pointer to the HW struct
>> - * @entry: flow entry to be removed
>> - */
>> -static void
>> -ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
>> -{
>> -	if (!entry)
>> -		return;
>> -
>> -	if (entry->entry)
>> -		devm_kfree(ice_hw_to_dev(hw), entry->entry);
>> -
>> -	devm_kfree(ice_hw_to_dev(hw), entry);
>> -}
>> -
>>   /**
>>    * ice_flow_rem_entry_sync - Remove a flow entry
>>    * @hw: pointer to the HW struct
>> @@ -1335,7 +1318,8 @@ ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,

More context would include following:

         if (!entry)
                 return -EINVAL;


>>   
>>   	list_del(&entry->l_entry);
>>   
>> -	ice_dealloc_flow_entry(hw, entry);
>> +	devm_kfree(ice_hw_to_dev(hw), entry->entry);
> 
> Hi Przemek,
> 
> Previously entry was not dereferenced if it was NULL.
> Now it is. Can that occur?

The check is right above the default 3-line context provided by git, see 
above.

> 
>> +	devm_kfree(ice_hw_to_dev(hw), entry);
>>   
>>   	return 0;
>>   }
> 
> ...


