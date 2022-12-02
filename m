Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15B2641156
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiLBXHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiLBXHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:07:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F639DEC6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 15:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670022458; x=1701558458;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AeZKyOKIu3KbYPr0kV6NqGK1bG4zQSTz81aiuiatm9I=;
  b=bZYHjQholUwrX5tisVuY5ISZfTL6bssJlggTybhMjGK8QPwdvWutN6+v
   jee+9vDaZ2cAx3OYsDH/kcEsyOoFFfyGyWklK2ITt0D1geBtbYndupMe3
   r5dhPq+gWbXh0BRj12mr++J2p2gEHOB74YsVGY+ucx6BmSFa157k43Dpr
   8fUJc+UE8ddkajPIjRvWlJFXuVPR1SE+NZMeCM8lspGM6q6XFw7fWwyfA
   NxZJBUSy3EjrfC5jaWAAiEaPZigHCaY7apQoWOi5O7Kkh1JTv5AVgg9Si
   Hfs61e7q+jv8zZpWAIvE3nCwevPsOvIUf3rEJueTdPJSFexK/Rj89jwEV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="316089140"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="316089140"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 15:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="890322599"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="890322599"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 02 Dec 2022 15:07:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 15:07:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 15:07:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 15:07:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 15:07:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POKQK1EXcTey1HezzoZDyNw516Qu+Qi4CwCzQ6o023wVm/bJe/jzAh7gWljSajqjC8Yt6xEX0xQupFCDa6E6VrZO7IUvu/1rI8yz1DbB3ofDEwOR4SchxODdcXp09i0UV80hP8wkqfavTEf+3cn2ELQcj55rVdm3OkdbL0wFYZEmuq6z9UEFThlsSvdCoqa+LKmw0HKXBcZjxUmG0ZqLmpTjrx0Fyq2TEOT4MqHM0urvrQpwbUQfUmBBGpei/iIQxSBd7i0Rp4norVTEIIZwgzOv65DQEbFT+v4OqeFVZMpfXtTz+Pn09UPNrouDD8JfDwgg7YxDdvR6ieiU2FjZ8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mKQ566I43DOnqw4cv40bXLWf6vGBqtMOW4F7hNyqco=;
 b=dIpaG9TdWw4OJSOwfnPJTbBT2ieCFzss+Xu6s165ndsgMtmdx3qUKqD3EH7gxUj0TLGKU5Ca77TXW0zMmfIGoBEX/2z9hKWPxwlvfY8f6cnhh6M5Ona6tZaC+0PLy0tZ443axsV/mNjPDJQSJHY8yavOLKX0kL9Cmj4fm4356vsfjWy3NKn0tJ2GcgjiS4TgKFtfYoi5P7AJLiaM5Kts8pLldy409CMfp68xOQsXjlZHPKa6ytZ74SOfQF6GbC+35y2Ip5EIqIMYoNj2Yr/Hjr0OmDU8+DGvA8mYxeEvdemuuRwZlWIPsnyTTe2+SDKwJunPfsrA03tQCLJoyYX2+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 23:07:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 23:07:30 +0000
Message-ID: <bb5d4351-af35-e40f-5c2c-031c83dd82c4@intel.com>
Date:   Fri, 2 Dec 2022 15:07:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 08/14] ice: protect init and calibrating fields
 with spinlock
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, Gurucharan G <gurucharanx.g@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
 <Y4hxen0fOSVnXWbf@unreal> <ba949af0-7de6-ab12-6501-46a5af06001f@intel.com>
In-Reply-To: <ba949af0-7de6-ab12-6501-46a5af06001f@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c4192c-37c3-44b3-349d-08dad4b9fc9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WA4mWU26GhgQ6xBdjkvdr4aj92p41BGe6qbq11BBr7cWa/pLsvAdLdj2wXNB8mOBNfxTLOAPVKDviZtODVQb4VrCecqHyfW5EVJIyci5I6nxLDxL12zjyf0iHjDbzTVIrIOFUYhfVmnqf9YRiEkbR3Jm7TxJa9nRt0rmZkgStV5vszBeim+aoQjCw4nrH5qgEsoEv3xVE7B1HWVkxZj3iV6kWlDiSRvRaJ90tGIBqfbXKvZNNeWr0+YIUuzY6GSWC8HBWoHHDhvjrByBhPTb2FVndJHlC2T/obiDpIaf9+8PXHjPulGvZw4JiPQiT15teSheJQaDzfTwl3aJl35fbEWa6A8TPOiRWY8fiWF+wMWYljKc4Ic+S5TDSsawvZE3KJNZySPA2lOxuHvSmU3c2fS2FrSEH/eAIctr5ja5P9dcR/8Gd3ekYHq12/hG6TriG/bdG5HwOIp8tjkyOltt0lnswqZR9a9v/pU+pTU0tTB+Z+eV1UCctfepsxJ5jBNEmLOu72k+9hbfXjU3eN0g5F2pO3M+xbzY73WGVosL8xI5Zf6vTzbg07eDZ6cLRJfvvqlrKMWPYGxdUqrxxk16t/jZZ5tNehgw4Y3j4V6VRkWRIsYpJ4BIrZrfpcS2DMe3bzm3LRCKNA6fKN6u39UkEYimCZxNbaEI4GH7jXRS5Sg7uOPdc3C5wKdKgxXlDMoR94xYXf48tQBOR5F5tGYlj9uPsDGRzxtaoiY7j937EFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(478600001)(82960400001)(6666004)(31686004)(6486002)(107886003)(6506007)(53546011)(6512007)(26005)(2906002)(4744005)(110136005)(316002)(4326008)(66476007)(5660300002)(2616005)(8676002)(66556008)(36756003)(186003)(66946007)(8936002)(83380400001)(6636002)(41300700001)(31696002)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkNKNkt4UFNTUHc1NE85Y0RIQWVDUDV5UWtYWElNajFpUTdmQXVZYWZ5M1ZJ?=
 =?utf-8?B?YktLYnlBYUc5VVcyanFaOEJXQmtaMHlKVDZ4Y21EUVlEUjRsNWczRGZtdFRw?=
 =?utf-8?B?SmVJeE8vaUQxeklDczBRMEtaekZBZGtVaWV6dHdOdkJDS1pGNzNVa016MW0z?=
 =?utf-8?B?ZE9JQlN6N0V0Q1ArSUJrWW1EdFh5RXpBWUtLcGtleStZNjVLZWxCV3phWDJs?=
 =?utf-8?B?NlFRRzFyWUZkOU1zNTZDdDYxanpTM0d0bS93T3RxaGZZbVRKaWlZUGhkTkNO?=
 =?utf-8?B?bXo4SWhOaUNmSThSekNKRzdXWWpYSFpLU1ptZVEzS2p2RFhDVHNlb0hUeUpU?=
 =?utf-8?B?blplV2FZM3VtWFdESnN0YVYvOWlDeVlXT1hqNmFCUDF1c1FiSGJjaUZRSzBu?=
 =?utf-8?B?UHF0RndkZVdrdzZEY1hSWmFmRUpVb3pscGNaaitTTUNIdzh4WGFBcXo3aVVH?=
 =?utf-8?B?dk12aEcvSXRrVHlxUFpSTk83dlhxZkF1bloxMjBGdUhSY3J6S0FOdFMvZWFS?=
 =?utf-8?B?ajJjemdjNFkxNE01M0pya2d1UEoxbzMvSWtaM0w3MEpGeEdxcExmZXk4c25R?=
 =?utf-8?B?dGQ1WEZLbmN1bVh3citMZExOR2hFUXFtZU9oOFFpbnQxZWFmK1pCcUlQNUFo?=
 =?utf-8?B?cFBYQTFVNDBQZGdtT1Q4cWpEdDFZYXdISlZMQU5CWDd0ZDNiOG1NQkVvaFZP?=
 =?utf-8?B?ZENBdXByNU50LzM2N280L2VVbFdrdTNGc2VSU3Q0bjJyVHZMOURaMjU3b0ZY?=
 =?utf-8?B?eHBjY2pVb2FWNXlOWFd2NnN3RWNpd1hjSktqNE8rdHV2NWZ2QjNmM3FXRm50?=
 =?utf-8?B?T256TFdJTFRtUXRhMm82VXdVMGlYanlqOUJ1bEhrbzRGTWZTbURiWG5YN2p4?=
 =?utf-8?B?bGdPOUFiNG5Ra3JFbFExNk5GZkNvbGhOYWVVa0lLY0liR0wwdTZ3WnI4THMr?=
 =?utf-8?B?RGZKelp0UHpJbFpMLzZYTGw1VENDdGE1M1RMN3Y5bVZ1Z0l2SWlJdnV5NnJu?=
 =?utf-8?B?V1RmVmJoRXk4bEQ5WU94am9nc3NBVTVjZzFOSjQ4OC9vWVg4ZmF3cnR2Sm96?=
 =?utf-8?B?dGtGb2Qxamx1ck9paUJNelN1cVRUZlRRR0loVm1IdFFyOG05V1hZNU1wVEY4?=
 =?utf-8?B?dStlQkJ1aXNyakxDSDk1MVhBM0VRUnFYZmpDQTdRZWZoNDI2RllYaGx0TXN5?=
 =?utf-8?B?K2lxL2o2dTQ0cVBVZzNSaEhvNWxtMmxWSG1IMTNOalNsakllNkFMWTQrMzRM?=
 =?utf-8?B?ck8rMzJCYll5MGVwbnZGYXkyZU1uanFtU3lHbzN5RElpVkYwUTJZcVE2VkRD?=
 =?utf-8?B?ZTBiWWIxTm96QXAwVFRhNVJKZkM3dmliRGdFdTR1UjdCcVMyWmJSSTJTNHhQ?=
 =?utf-8?B?RVcwdkF5SUQreVczNS91MU5uaS9kQWRnYlROSlc2Zm11QzZrOEx0ZThIYXhj?=
 =?utf-8?B?aU8vc3B2L0RlYUFsTVp1bGRYVllLc3AwWDhXUUpPL3dNZWw0MHR5ZGdHeGNy?=
 =?utf-8?B?ODhsTGdpWUh5NUdTaE9PMGVVTWxUenJnRDUveHQxemJlVW81TTdsQzJmWEtU?=
 =?utf-8?B?alhpd3g1TUFEUWtXVG5jWC9TVGI3NnpVaDlzdjNrYlg1c2JTQ1R5QXNoQ0ph?=
 =?utf-8?B?S0VaeHcvUHlZWVBpU2F6YzMycjc1NWhrZ2c1M1lVUHVPZ1VlbU1vc01WNzJC?=
 =?utf-8?B?VTF1alB1bWlqNVZlemkxT3RLM002cDVjWUtvRDZjTnNVRDhuOEh5dTRUSXh2?=
 =?utf-8?B?NWZDOVZDcWdOQkc3dFlSTno5bkhGcFVpUnVQOGpVdzZXT21NNzhCKzJraHVL?=
 =?utf-8?B?QWFPb2VaV1FCQ3VuS3hWamVqKzJpcEZ0Ty9oek4vSElPbXZCU055V0FlMmdt?=
 =?utf-8?B?UitVWVhMNUZvSkN2VFlRdmdLMDhXNVJTd2FyNnlRdmY4Vk9BYk1lZllYSUk3?=
 =?utf-8?B?Rk5adldwT2lsOERuSGNVSmVaVzVZaXBVaVhITTA2UDVkUUo3TkVZMUNFK3p4?=
 =?utf-8?B?V2gvclRCam9SZmJ5SVI2MW5tdldobFFJY1YyYjBEb0hYVURDTXdzVWJLdGlj?=
 =?utf-8?B?VkpLbzQvTi9mMy9XekkycVFxMjZBb0N1UkFuVHBGTTlKK0h4cVJodUNEUkFL?=
 =?utf-8?B?YnV3cmIwUXZaN1JtZ0pXWDRFdkkyeThmRjZ2SVkyVzU4VVdpSDhkRUl3WkJ2?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c4192c-37c3-44b3-349d-08dad4b9fc9e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 23:07:30.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hTMeUtmflz2Uu2Fpg+BI9hvT+ngvzDmdskDlup3TSN28PYE0lOrXwOlSkzmnVByVHcalH+nHQnQwp3PBV4jg9ZLp6gbEbzXYm3p9nkmPn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2022 10:36 AM, Jacob Keller wrote:
> I am not sure what the best way to fix c) is. Perhaps an additional flag 
> of some sort which indicates that the timestamp thread function is 
> processing so that tear down can wait until after the interrupt function 
> completes. Once init is cleared, the function will stop re-executing, 
> but we need a way to wait until it has stopped. That method in tear down 
> can't hold the lock or else we'd potentially deadlock... Maybe an 
> additional "processing" flag which is set under lock only if the init 
> flag is set? and then cleared when the function exits. Then the tear 
> down can check and wait for the processing to be complete? Hmm.
> 

For what its worth, I think this is an issue regardless of whether this 
series is applied, since the change from kthread to threaded IRQ was 
done a while ago.
