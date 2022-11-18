Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942AC62FEEE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKRUi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKRUiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:38:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F58D2CE1C
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668803933; x=1700339933;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KGsOK+bK1sAoMHzNc8kqjHdJSa9a/BJcUKNQwhXMadg=;
  b=I3hCPwTzEJ96MA6QB9yLS2LFAM4FNEXi+1o0CO7FQLCozViP/UbIUp/1
   nPDMaWZKfrwwc5IHMghF9sqqAWmcUgYPHhUyKbDqacnLe6RVsWXX5sPQ9
   lSb92kuziTpM/CeK+SkfHGD8pAsnAV9RKBW7QQ159vVMjylrFKlceN4+X
   +APDaInEavfd1pSgAw6yGFXxd1mSEc2hpKyLRtC7KWzQIpDUshfjrnLF7
   aRtMau/chBQHuHG+JCr6sL53XxZwyjHOH5MeXLTXEyxS5FQ/vT97BGAGF
   KTBDM2nY4PzUtBqJbWT5Gdmp/Z/KYgBEphIwn2XpgkKcAnQ8eJXmfGEj4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="311933657"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="311933657"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 12:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="729358276"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="729358276"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Nov 2022 12:38:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 12:38:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 12:38:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 12:38:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSe0JZFZlE+XJLoRYfrA5J0/GkKexXPV6uM+MkMW8I8tDyUB/Nq0DEycQkcuL4QaJCAFcQPUpKyAm65/4423jEyFtSZ77U5QJRLSRnckelQDGD185w9CWwgWCuSvbkkJbQ9+Wwm15EtSf8rYrI/Oy2cHkO6/QCWxJU1UlZUmu2C6GGry1d+kMEJpQHZH+OuaLoumDeP4/7kzW5XEPgI2gl6y4SDrnpzJLeB1y+E+JP4Mp3SHhC74bE4iJH61aORZZFbutxhWv7QOX/irlyBlg9waetBHMMoa0TjIM4UN18c6X1Z5rZprZrNIqxsZR5MELL1A/z6oyiSomDkhD/Z2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3sQN4i4SvTCIHwpPo4NX2d07StGnY3EaKMpjUo83PA=;
 b=BlcscXmX5uk80yvC/WpwD5I5lZPQ49r8koOo139qH9VLAT47FdN2ovgHG203w38FD8EKy7shcNIFq0yhnI2pPoilUhlylqWyQfUIlM0vOjAaS1J+v9NvZzcogJlibw18QvzBkQohlcsv+3kYIFjqlXIhQ3f2lBLMBvOO15gv4YAfeQLZzoP1kd/N5tSaxzFrjQNA6U9z7Lie9AsagSWZAKVE0dkV9HM0I4g2uRy1ZXs6ZKlONpRVytJI6kLoU2e2iYZ6TEIhRyZfV3XEXU3lCJDTO6y8dBl/lgu7gDftMWtq+jpss5QeV+YgYPxzeVw5NFsr+4LFQvlX+bt8uLrLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA1PR11MB6468.namprd11.prod.outlook.com (2603:10b6:208:3a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 20:38:49 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Fri, 18 Nov 2022
 20:38:49 +0000
Message-ID: <f9d57aea-a0f2-e437-f37a-26c674a60fd5@intel.com>
Date:   Fri, 18 Nov 2022 12:38:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <2310788.ElGaqSPkdT@suse> <4bcad8cf-2525-bd7c-9d58-ae43a7720191@intel.com>
 <4854425.0VBMTVartN@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <4854425.0VBMTVartN@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0165.namprd05.prod.outlook.com
 (2603:10b6:a03:339::20) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA1PR11MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: b04dc9c1-3600-4c9d-3893-08dac9a4e58d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EV3BU8gtUhnvWvRs4thmWd/cmfBxd+uUm0buJwo23hWiLY08uC4gzSuvt7r9mWPVwCwuppDWkzPdIDP0m8vgNMOROVFAFN896+9OYIzQvgFQdNSCGCf8AGW37ngwh8IXPq1PKI8Nij/bDwgb+k6QVe6/hXcWXQ+h69nsmjnMca09Dtw4LwQJV6z3/MeOJ23bddTXnZL2THKD23KeMOUMSKP0Mgjon57npNyx8RKvopzRbzvXInGgkErKmubeHfBJKRYcGxYwQyAYCe+jJ0ejDkqtfA9BRRJjOFYyDfeLA199r4YvQ2cYYudA13IFqNjuZ9qtdC3UOKDUaaFuSmriQJ5BlbwrK7u4brEUrbrphr6MHAymrRBUb/qPsBe0uVIyx5Di24aAlSzealvWSJehT7WkYILqQXz868zCgDfEUONLMVlfsWz3WKa9F37gXpDpM4jlCSpcosdGomfAOiS1mYyhvDVbGNJLGYUg9siOuwmfZDjewqQGp/qY5MqX9Xt96+0FyCHiGe+lDepVjWw2vt/WA1o8Oi6Cgiu75ujrt2M9/VF3U7Y2lr7iDuXje/PfQXAuk3etxgHv85qvDCi9pXqO+teL6pxDB8ICLccmFZ5EDpoW+DFNPl9GvFJT5EyiHwxcEaDMkl4dKg3FdXnfS3les8EIuhNYN8MYU2kNCqf3ZAm6vHO45JMUS3xtRco0F7x1llivmdKcUhtDxZ0Tkfan/7NsXfREtExXWfUZwJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(54906003)(5660300002)(316002)(186003)(44832011)(53546011)(6506007)(8676002)(41300700001)(2616005)(8936002)(6512007)(26005)(36756003)(66556008)(66476007)(4326008)(66946007)(38100700002)(82960400001)(31696002)(83380400001)(2906002)(86362001)(478600001)(31686004)(6486002)(6666004)(66899015)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTFpd2k3a2ZGc0pxMW9GTXl6NWtpajM5SVdMOUJJek8vRVlaenN6VCt1Z1BD?=
 =?utf-8?B?NlU0c1ZBZlRZZVFJQ1QwZEs3Z1VJQXF6M0laYzJOWnJkekdDa0paWitndVFB?=
 =?utf-8?B?eXlUSk5sbERacVhIUjdSclNleEFRc1J1dGh2eURjcnJaL3VMdWJBUC9vOEpo?=
 =?utf-8?B?N2pqNjFRSDYvWC9aeFdCc3VSN0xFSDhoSmhVYXV5aDZKQWRTS3pWQXU2b214?=
 =?utf-8?B?WW11aGptTUR5bllXTTFIeEVOa3NOajBpUXpUQlBVc3d4Q0pFeWNjQ29ieHNk?=
 =?utf-8?B?MWJFYmtaTVVDMHdnVWtTd2NMOStWK0FGUTJxOWNON3lVMUZ4d3JoSTIwOTAr?=
 =?utf-8?B?dmZzRGRyelFidHRVNXRZSXoxelF0cVhFNjA4TDJIcE4rN0dxYVV5amZCcEI3?=
 =?utf-8?B?ZTVTWVBGMjY4ZmFTY1NOUzZ5K1d2RmF4OGpXdmt3Z3cycDdUb2ErZ0hna254?=
 =?utf-8?B?cFZFelIxSUlDa0JFNUdPcVRvb04zS05SVlRSdVFoN2lTOEdmQW54MjNLL3FV?=
 =?utf-8?B?U2FOZllKTVBaUFBoUzRlQ1lGWGgwNFpsMExDc1IybzFieXJOOUh4NlJDOExL?=
 =?utf-8?B?QmtpdDBDc1RjV3p2SFNiMit2WFpHYWVrUkd4ZHJYWUFzK0RycFdJYllNQjNI?=
 =?utf-8?B?UHJFWjA4enRmblRsaTZ3c1k2ZWJoTkNBeGN3OERoViswWTQvZ1k0N3RxMFpY?=
 =?utf-8?B?REJSMkpzMkR5NmZ4RDZzTm9ML2ptVmkxaFZMUk56eDk5cE9MVkVNdHdRMTdW?=
 =?utf-8?B?ejkxOXBNS0pUaERud0RQeFBEaDRweVhYc3h2bXg0R2Naek1VTXpFUFVFNVZK?=
 =?utf-8?B?ZEhtZEcvN00wWEJLdi9lU0lxODBZWEZocVZoNG9yS3dUd2MzcTJucmwrUnBV?=
 =?utf-8?B?dmQzcG41TTcwYUZ1RGU4bFRtamhXcDR6aW5TUmZ3YVI0WVlGdkNmZjNHMStD?=
 =?utf-8?B?UjgwMTh6NW5FaDRjdE9rR1VCZU42SHlsMXhDSmxyOTFJbjQvOXlUVEFHR1Av?=
 =?utf-8?B?QkpMRVVXdHIyK1RvNHFaeXJIWTZtVWVxRzZyajFFWTBTUVhMYzduRWhtTGlr?=
 =?utf-8?B?cEhPeXlZVkZYQ3BSRmhvVjRtTHNVbUJTa25JbWVMOEswN2lOeXdtNk5OdUR6?=
 =?utf-8?B?VnJGd3kwZVg3emxOa2ZobFhaMVlHeHg0RVJaaGFOK3BFRlE1b0Y1ZGtzdFhy?=
 =?utf-8?B?SW9RTG5lalhNeWN1QnZYOUhLT29QWVBKcW5JK0ZGTDQ4T2pMRlpEZjcyL3Vn?=
 =?utf-8?B?aDRYeVNsa0daQ0xOVDZObHNkWWRCQlpBQzJoVUo0Y2hXOUJsMW9tSDl1UjJt?=
 =?utf-8?B?WVlQcnF0RUp1YWUvS21ld0VGMFdMQStRREZKLzZWcGptZmJBN0xpZXZHaGor?=
 =?utf-8?B?WTV5SVRQYTkwby83dFlIMXgwTXdTRzJpaS9hWFh6QkhINnZmNDR2ZWg2SDFF?=
 =?utf-8?B?K3JCeXF6QXZ4bDVoZFNzNWc5SlMyZGNZNDczTU41c0tpQ0lydVpldDh3WFJt?=
 =?utf-8?B?OTZDQTg3bU5lWjhCTE1lMXptQWNRT0pSR1UrVzhVV3FlTXNVOEpQUlk5NCta?=
 =?utf-8?B?Vndpa2pxcVRzOVRRQ08zYUIyOFQzT2hLbzkzNHdTZHBCV0tnaDdGT1RoNTZv?=
 =?utf-8?B?amhHMlhCUmJMQXVSd29iV0ljSkpnZlVGdmxDN1lidW80OE5yZUpOZzBOZTk3?=
 =?utf-8?B?OVF3OU9Gckl5UXAzb2VmMUpwYVVubHJ2dXdjNFl4NWJKd0lzUU50anFOSHA5?=
 =?utf-8?B?UTU3WHNjOWtBdTdHaFh2YU0xNkNKdjVLbGlMZ3VOMURmVDhkSEZPR0xwdkVD?=
 =?utf-8?B?dE1iRnQ4K1pwUDRER2oySW5EZjB3eFNmcVZ3OVowQ09kT09leklZWTA1L3RE?=
 =?utf-8?B?VE96SDJzMHM1cEo0Z3Z1azk3K29FWlJ6NC9hVng3cFQzVGFpM1NxbytIRm9P?=
 =?utf-8?B?b3J2bXJ4UnBXYkRUWW00MlhLdWtUczFxTHVGbkRzM3pqUkJWOENlY04rc1Vk?=
 =?utf-8?B?Wmdsb3prUk45MFAyOU8wZFJIZWxCa1NDNzRiVDllUTg5Y0ZqRnRtcGpvb2k0?=
 =?utf-8?B?VDBmQ3BzbDFpeUJjZ1ZTRzFLTXF2Ti9GUFlRWFdXNUdzTGdTVWJ2cUYvdDl4?=
 =?utf-8?B?d0dlcHJzd3JpbTM0YXBHelRtNHlEUlNwcHlFRTBpVWQxcmMxWG5ldmc1TkQr?=
 =?utf-8?Q?MlMZjnPVbBsnSwgQyR6HIQs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b04dc9c1-3600-4c9d-3893-08dac9a4e58d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 20:38:49.0810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07t7O5EoRebvQp3KVF4v5D4PNJ7IjaOa2owl0kIh39RXPMyAHWMuKZhywaTuDvSVJtHFNzcCne1+4aQND9WLJa0FagvEfnwDz0x8d1+uiJMNAQwzZ6p2yQ/t8ArOt5Np
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6468
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

On 11/18/2022 12:18 PM, Fabio M. De Francesco wrote:
> On venerdì 18 novembre 2022 19:27:56 CET Anirudh Venkataramanan wrote:
>> On 11/18/2022 12:14 AM, Fabio M. De Francesco wrote:
>>> On giovedì 17 novembre 2022 23:25:53 CET Anirudh Venkataramanan wrote:
>>>> kmap_atomic() is being deprecated in favor of kmap_local_page().
>>>> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
>>>> and kunmap_local() respectively.
>>>>
>>>> Note that kmap_atomic() disables preemption and page-fault processing,
>>>> but kmap_local_page() doesn't. Converting the former to the latter is
> safe
>>>> only if there isn't an implicit dependency on preemption and page-fault
>>>> handling being disabled, which does appear to be the case here.
>>>>
>>>> Also note that the page being mapped is not allocated by the driver,
>>>> and so the driver doesn't know if the page is in normal memory. This is
> the
>>>> reason kmap_local_page() is used as opposed to page_address().
>>>>
>>>> I don't have hardware, so this change has only been compile tested.
>>>>
>>>> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
>>>> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>>>> Cc: Rohit Maheshwari <rohitm@chelsio.com>
>>>> Cc: Ira Weiny <ira.weiny@intel.com>
>>>> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>>>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>>>> ---
>>>>
>>>>    .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++-----
>>>>    1 file changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/
> chcr_ktls.c
>>>> b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c index
>>>> da9973b..d95f230 100644
>>>> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
>>>> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
>>>> @@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct
>>>> chcr_ktls_info *tx_info, i++;
>>>>
>>>>    			}
>>>>    			f = &record->frags[i];
>>>>
>>>> -			vaddr = kmap_atomic(skb_frag_page(f));
>>>> +			vaddr = kmap_local_page(skb_frag_page(f));
>>>>
>>>>    			data = vaddr + skb_frag_off(f)  + remaining;
>>>>    			frag_delta = skb_frag_size(f) - remaining;
>>>>    			
>>>>    			if (frag_delta >= prior_data_len) {
>>>>    			
>>>>    				memcpy(prior_data, data,
>>>
>>> prior_data_len);
>>>
>>>> -				kunmap_atomic(vaddr);
>>>> +				kunmap_local(vaddr);
>>>>
>>>>    			} else {
>>>>    			
>>>>    				memcpy(prior_data, data, frag_delta);
>>>>
>>>> -				kunmap_atomic(vaddr);
>>>> +				kunmap_local(vaddr);
>>>>
>>>>    				/* get the next page */
>>>>    				f = &record->frags[i + 1];
>>>>
>>>> -				vaddr = kmap_atomic(skb_frag_page(f));
>>>> +				vaddr =
>>>
>>> kmap_local_page(skb_frag_page(f));
>>>
>>>>    				data = vaddr + skb_frag_off(f);
>>>>    				memcpy(prior_data + frag_delta,
>>>>    				
>>>>    				       data, (prior_data_len -
>>>
>>> frag_delta));
>>>
>>>> -				kunmap_atomic(vaddr);
>>>> +				kunmap_local(vaddr);
>>>>
>>>>    			}
>>>>    			/* reset tcp_seq as per the prior_data_required
>>>
>>> len */
>>>
>>>>    			tcp_seq -= prior_data_len;
>>>>
>>>> --
>>>> 2.37.2
>>>
>>> The last conversion could have been done with memcpy_from_page(). However,
>>> it's not that a big deal. Therefore...
>>>
>>> Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>>
>> Yeah, using memcpy_from_page() is cleaner. I'll update this patch, and
>> probably 4/5 too.
>>
>> Thanks!
>> Ani
> 
> Well, I didn't ask you for a second version. This is why you already see my
> "Reviewed-by:" tag. I'm OK with your changes. I just warned you that
> maintainers might ask, so I'd wait and see. However it's up to you.

I understand and appreciate your "Reviewed-by", but that doesn't mean 
further improvements aren't possible. I believe using memcpy_from_page() 
is better, and plan to do this in v2.

> 
> However, if you decide to send this patch with memcpy_from_page(), why you
> are not sure about 4/5? Since you decided to send 1/5 again, what does prevent
> you from updating also 4/5?

I hadn't seen patch 4/5 when I replied to you. Since then I have, and so 
I'll be updating 4/5 to use memcpy_from_page() as well.

Ani
