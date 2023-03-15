Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15586BB9A2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjCOQZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjCOQYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:24:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7EB23858
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678897483; x=1710433483;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x2dmRyeQKoj9WDPX1BguNLU+Re1CGqSSdG0/VHv9rD4=;
  b=PPG03FeRhJf0yavOmGKtFf1wj/yWFBalD2rDg1lT9Zfwpox15QGfA1r7
   ufykgzIMU67il+cu+UWYOUD0vy+EK9ZZHnwMloAcUTV89Cu/penSLxBrO
   NaLL8CE2fBj/rasWgkxtqW+l6QHUjV2T6X2VtKW9Dh4kLy3GA1I+lAe17
   Ia7ECvsOdhoMeRFdRDwWhLGofGKKXM5j/es38DYOnnE1nD5WVUAVVlEw3
   3Fy5am5wen4HSUjzaZMGjtNhoJidL/91qqCzASo0l2F8OknZ+mGGvRq3Y
   iVqgBvgabrKZvfLTOlvCnAymBi/cGhyi/sJWOGm3Gc0vi/ayv5uWcZKqv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="400332245"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="400332245"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 09:24:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="709735564"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709735564"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 09:24:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 09:24:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 09:24:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 09:24:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVlJrM/VuhGtQysLb5X4MrtY0dg767Wpwm6qyWDG3M3o6Wtt69hqhTu+jUvyQC+2XJ1AAULpiuuLxLKbzKPlYGomX+tuhg6BWHPqGOJ2e1Agg7wxiaAjYBHCvOFjkV5LmlmXTa08Xy6TJiRN+h+2gVdQnKt0v5dt1gaD/sEzgcep+RjMHYuGdB8PZbd5jzVV11h9CRh+SI3VEPVERelkhHtvFeWOJ53bCqDXhkPwCOug+v7F4NhzovLNHlK5JQJLI615hoVntVUGK/MLbNbWHc7v3F+A3YQRUgXZJsQ3oR3BISqFpviPmQmVoNFRQ6nqp02/MQ/O5/6dWOUX/PqSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAhUwYMqtAsLIBbuywtD0SeGFJo3Tr+b5ikLGVg1wc4=;
 b=jtZYX8q3nqqX4UzDV+X2JpRs9B965lcfmPumskPDiFqGw5wkBS1tn2aaTG77U/wuCU+NvomoW+CQ66RO56+hiyNZy0KuoHip/FCYGwhtkJn9cL2RA06AHnBFS9YyhNFFPwseH6zjO5vFHx1zViV0tLoBrEFSwyi+DBljh/gg7IjItiNCY04iH3iBY0kQLZpNDxgoF39EjNiPUmvV80MFS+jvUxNE3LMZ+w3tWs7z8WlwQfNkX1/TVN83DFsEqfQPou3rRXcJQt0fB6zHoXDny4tyfSOE3Yp76kKP3RFgyYkXZhYQSzdCk4Z/mJZWm1iS6/FV3Te/dCQNjO7Zx0Kihg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 16:24:39 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 16:24:39 +0000
Message-ID: <14f872e0-88d8-783c-ef6a-517feb067809@intel.com>
Date:   Wed, 15 Mar 2023 09:24:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH net v1 1/2] ice: fix W=1 headers
 mismatch
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
 <20230313203608.1680781-2-jesse.brandeburg@intel.com>
 <f0c898f5-f4cb-34dc-91f6-a83106c52c0e@intel.com>
 <cb406635-0c44-ef7e-2bc9-3c1ecd5c2779@intel.com>
 <356f0d97-84ae-d508-93d2-a3a68187e03e@intel.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <356f0d97-84ae-d508-93d2-a3a68187e03e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:a03:334::6) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA1PR11MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: e985b412-2c74-4e69-9e7e-08db2571c67d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCRtm/zzK1NgDUrgMIQSct+d0+KXLJLhN2fHKkcKDyt9j3dvqNScvDy6ZoYOR4Ke1CumwqwbdCV+iVCXw7S7HORD1Jf4Lqn9Z3cZISSKx/F12lg2wlhGtaR9eFBpNKuhXiqoAMGdLjNTuVinWPPPvX+LupFJGVN32Tg6JEypJK0SVqSyovPWkKEvd5Icnw7Z4DSMUmjxODUJj/nVMkrYIx2Dff2XQ4iVu7SgmJu7j208QzD3YkDZifEkNxoaH5r93DZAOjis0/+WxBPZlwYhql7LH7099VFzI2cKrXJLsVC7udjhFEswNtDEpla4hj01m36cQ3qbsGvXG8O+4Gb7zT1WxZiIsm0kMk7Vr4MPgj5+s2Qh3svIYWwQAIhUD5ihAJeds3nKIO9wCYvVCcjW/rA6eayqfUFSRb1xPd3vJAHxnN4s3f0i7R44boIaVDlIbRwju87t/8s9SQJytZoOAL4ewHZFeKRqf3gQURtrZ9CCHDBaYyGR6qLcysboSI+SrqPDgoCiF1hs1LgFANS1giV0suJiQQmAR2wNk2R8B5OJoJPGR0SWJEK4WVMF4HOmCS4fEqZOJwWgmyBsmD6gWxdx99NlpV0e/94bKQRNl/nqVy5zz++ElR4k86j34/NZ8OgtojbDl7IVLZDQF47ND1gQsZH6LrNlZz5Fw12fkhXeIb1IiIhE12LQMeAQrCFLsxAUDQiENWBpycjdWjotAEbNL3USja5KRryEVfMEB/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199018)(82960400001)(38100700002)(2906002)(36756003)(31686004)(6486002)(478600001)(53546011)(2616005)(186003)(966005)(6506007)(86362001)(110136005)(66946007)(31696002)(66556008)(6636002)(66476007)(8676002)(316002)(4326008)(26005)(6512007)(8936002)(41300700001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N203NFVjT2c2VTFaY0xvVytSeFkzQjZuQ1lCdDhhUnY5YWJodUV1aG1MK2pl?=
 =?utf-8?B?THBudEdDV0t3OEwvdUJOUmhud1Y0aHljZ2d0Z3NhdjZncjlGQXh4Z2lZMU0w?=
 =?utf-8?B?ZUhUb2RhV3VvaUh5d1VKMTgwampRTUU0aWtlRmVic0VXQW1YNEdsTmI0YWhi?=
 =?utf-8?B?YThobG1hQ0JyZXo5bWZ1dXZmWUlFWFc0QkVJWVZEa1U1TitkWmE5d3R3YXdr?=
 =?utf-8?B?c3BoanV2dWVsTWpVSTRIbGNUSy8xazBZM1lUUEdqNzVLL0FtMml3cmFXY3I5?=
 =?utf-8?B?Nm9lbzFqbGlFN3FjQ0RDYzZpenVXQ0ZBMDY5Y0VkZ1B5ZnFyaERIaXdWQkhU?=
 =?utf-8?B?TGFMZDNvZE1wK3RGSDZycnR6SEl1aEhyN00yVFliS2kzSWlsNzN2c1dNZ051?=
 =?utf-8?B?TWJWTkVMRlBGYWlKOStPWmplMzZKellRYW4xeGhrQVZuQ01JNDZJcGwyS1lO?=
 =?utf-8?B?TUd4SS91WUpBYUJJZmEyVHp5bVEwM3g1V1ArNU9FYWdiTitDSWRHMVJZUHNu?=
 =?utf-8?B?Vlc4d2ErcElvNzhBd0ZsNEVEa2t0SDBUaFlkOFE0UlNORGN4SWpRMG1VUitG?=
 =?utf-8?B?bW84REtNYjBPcCtaZitUUmdHRGZsSzM2RXlmSTNuRDVYZUhaR2tNa3RKLzRU?=
 =?utf-8?B?eVpkSVdEaHk2amVhczFDTEFiT2ZMK0thdFViRmlHQW43TThlbHM5M08wMThp?=
 =?utf-8?B?bFdpb2JDUUVCa3c5MllQZ2NQbHJzNERCLzY5K1FHZHpyaTlBUXBpOXVLK0hm?=
 =?utf-8?B?ZmhVUURtaEpFd3UxYkNtd2JDQnBJdDhGclpVTEcwK2RORTZXSlM2T1d0aFNC?=
 =?utf-8?B?cU9yN2FpOGVicXY5aWFUUHloeHY2cmdHY25xcVVTaUZUWEtNTzJyZ21KdzNJ?=
 =?utf-8?B?QnpjZ1JIWDNXZk1PSFFHN29wUkNDbXFlcmFsQnNXUXpmdkllRm9NMHFIR0tm?=
 =?utf-8?B?QmxGRHVaM29oSVF2OGtpL0h3aFRDdW05bVpMMlQyZU9IOXIxcXgxRmN4ak1O?=
 =?utf-8?B?ZXh6TTJjSDNGMzduS3pnOGtsbkNwbEpNVkxvU1pid1hieEtkRW42d0NobThX?=
 =?utf-8?B?UUtNN3RNSUpZYmdSWWVQeVpQZW5sOWxvdVFIU2JaOHNBMkVFVTExMDZkUndJ?=
 =?utf-8?B?QzQyNmVyWStZcDc2c2VNOUpuOVJ2VVUwbEFtQTZwOVprMVBGMEZpc0RKQkZG?=
 =?utf-8?B?cHZFV0R3QkVMZXlTZUVZQ1JwUm8zRU1WY2prV0hKQ1NCNGxEdElBVnhVY0pv?=
 =?utf-8?B?VkNmbjk0a2x1b3RTWlBsZlo4a1JqdUFRZncxYWVUdjZMYUVXdlBhSnR6MDU1?=
 =?utf-8?B?blRKbW02ZU4vVWpvSitjN1JmT0NwN0s5ODhHUVdFVjFDRUNZQVgra0lYL0lO?=
 =?utf-8?B?NjUzWUpvdmY1ODNMSERucE1mWUh6VGdpK1ZQRnQ5ZGM5dDVqZXNlMmN4Y0Rx?=
 =?utf-8?B?cUZkUVRkWXhOUUNIaDZpQ3h0eG1OT00wQjhGU1grZ2VPMzFySStCOTFSZUdp?=
 =?utf-8?B?aXlYMCtvWE56elVMUFkyaUd3QXJyWVM1ejZPYlhrWmdXaGI2eExOcU43RHhI?=
 =?utf-8?B?b2FCOUYrdnM0UWxrcVhIVEJLZEhTc2NYeWtrMjBDZDdjaTJEbmduQUxZZVM5?=
 =?utf-8?B?SjZ2Tk15amJTM2JnbUp3WUtycm54SXBDMGh6dUpBemxTRjdRM3RzbnNjaGNW?=
 =?utf-8?B?RDIwaDN1M2gwcjFXejhPTDlJcTQ4dU1aY2prNW1tdGlJUzQ1V04rV3BQUzUy?=
 =?utf-8?B?VU1GcFNoNTN6WXF6eW5iTXVmNjZ3b09teVF3amFCYU1uL1hKcm5DamFPYkZS?=
 =?utf-8?B?Z1FkN3FjcGxsL04xamJXSUFOaGI3TFpMRnhrQzdCZktST2t0Rk01UURLUEVJ?=
 =?utf-8?B?MmFJWkxwdDNXTE4xR3FkQXlhTDVUaWNJYjU3NzkzbTZtbHR1b0pYNmE5dmxI?=
 =?utf-8?B?cms4NVFYZWtPQUdTY09POGNoSmVUb2xOTDNtbXdpYUVTL0Y0Ynh1R2pYZy9Z?=
 =?utf-8?B?NHcyZEVCbHBJN0hOWWRlZjNKSU5mays0SXQ3cVNMZkNwbjZRTVBjOWM1U0Ez?=
 =?utf-8?B?NVZnZ0hKWjdQZi9TazdabmZObTRUMlNkUzVFOXd4VUJsRWI2Z05iaHdOUXJ6?=
 =?utf-8?B?L1JWeFhHdmFIdDRRZFdSVnNyUElOVVlGRjVaR05yU1RQd0R1eE1EZ2dwZWdJ?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e985b412-2c74-4e69-9e7e-08db2571c67d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:24:39.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnup6WYLeWAdQhhucb8bnsqcBNAgqbD+EXnLkdL2YAiKlIFX6qzLCkOzWRSJJ4wLyd9gZrWfW0BxdCSDmgIT3CkOIwjx5X4avYAes4LfN8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2023 2:55 AM, Alexander Lobakin wrote:
> From: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Date: Tue, 14 Mar 2023 13:29:41 -0700
> 
>> On 3/14/2023 6:54 AM, Alexander Lobakin wrote:
>>> From: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> 
> [...]
> 
>> Quoting myself:
>>> Fix a couple of small issues, with a small refactor to correctly handle
>>> a possible misconfiguration of RDMA filters, and some trivial function
>>> headers that didn't match their function.
>>
>> Please see the last half of the sentence, regarding fixing these trivial
>> comment-only issues. If you still think that isn't enough I can reword
>> or resend, but in this case I don't think there is anything wrong, do
>> you agree after my explanation? Did I miss something?
> 
> I've read the cover letter, but its subject is "ice_switch fixes
> series", that's why I wrote this :D That confuses a bit. I've no
> problems with this spin, Tony doesn't preserve cover letter subjects anyway.

If they are sent on as I received them, I'll carry the cover letter 
forward. However, if I add other patches to them, it won't be preserved. 
I see this getting bundled with other patches, so the subject for this 
likely won't matter.

Thanks,
Tony

>> Thanks,
>> Jesse
>>
> 
> Thanks,
> Olek
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
