Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536296ABCDB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjCFKcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjCFKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:32:24 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81721F75D;
        Mon,  6 Mar 2023 02:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678098719; x=1709634719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xkEkL2Sq1KGFgn2PK+uIV5qm/FusPlBvGO++oR1Axws=;
  b=hjAxihXKQBZRvSee/N6ylT62IEaNVEcHxlfSG1yhoZWfddms1LaDotlW
   gXpdkBM/584bHD8outFtROK/F2n5sJo5MdKOQCiFu7xeZOzn9/9J/85g9
   CnaTs1JaLEcxZElFB+oBNv2PgLWPVl8iLiBHaTyhaSFsnT2pB81QkcDht
   aZvB1uNdctO946fUU78nGJo3vGGY79CtJ9cWY8OA5UawcIBeJO+yIi7q9
   Ft+Hz0i4YTq0DWubBVccemcqikRkw1CLa3ySR/NFnfSjVc1gXR8k1wDzY
   ba1OLeJlVWqDXORYVuQNp5AzktN1HLrD3PTmDNZAGbpjJ2rItRYo7Ktpt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="332996155"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="332996155"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 02:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="676120492"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="676120492"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 02:31:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 02:31:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 02:31:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 02:31:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5FCeRUsUYzwztvZA+ZmtXRrhvPm3Kwj5JXbSM6n9muApwr/0MS44tLcPru2w4Tki7z04UuB0MOpLekA8JeEeeP2wSKjMTLY2Y7HOnsd6xUaR9BGxu1XJPWzBfQjXL80soaR8+v+gR8um/AeD9ihZ5wL7XFGTqTZoEa4tiEOGgv48HhuPOBxXtRfpgjnPLOnRVd0dGzdJIci+PYVn+RqZArZUVQ5NJJJg8Rs/K1z3YptY286VupXh6FdS+Kuf4NkEdM/7AsvcyiBPs9xbsgrT4fdbWMVbTi9rab702yf/HzDWoYOx6nYuHps3l81KkmFS0BrP23JOkUpX1F1AFXaPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLrHHMqE/YC7Ir0tNxllDwW/Od5bt36MtRepMwLMUFc=;
 b=lzVwKn7gSP8d9eKltIxII+vWNxplE6G65iRxRQrj4QuhuG4/mYwdd61xkSUt8q+2URtLLUJV8hnQVw5qTjJDODHt8J0J+dnWjIx/wTGbw3ZkT5cyDWY9poicPyCS7nyG7nPSc2g0CZ4ne0LjuG8TpysscYw3prU10sN1e33Yj2i3BR8RSualZvqk+bzQuf4xikmxNuQ+wPZv2oRO/icjAbvQ7dxGAgiv0tUFKeHLeVVmKT7L3Hr/jCBa8YkVWYd1MUIc3n0xY7T8T5bT0eD2Z7zijhZTRyMVetUpQ6VlDuCrRKzCNzmEwEg/eCIHMeViJY0lG402OdjXsVhiCreTlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB8108.namprd11.prod.outlook.com (2603:10b6:510:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 10:31:56 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 10:31:56 +0000
Message-ID: <07f6a7ce-ff22-695b-f843-d0d8ba275ae7@intel.com>
Date:   Mon, 6 Mar 2023 11:30:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Content-Language: en-US
To:     Alex Elder <elder@ieee.org>
CC:     Alex Elder <elder@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <caleb.connolly@linaro.org>, <mka@chromium.org>,
        <evgreen@chromium.org>, <andersson@kernel.org>,
        <quic_cpratapa@quicinc.com>, <quic_avuyyuru@quicinc.com>,
        <quic_jponduru@quicinc.com>, <quic_subashab@quicinc.com>,
        <elder@kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
 <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
 <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
 <4c92160f-b2ea-c5ef-5647-6078ab47e518@intel.com>
 <a919afca-d33e-618d-5db3-17a08d90e8af@linaro.org>
 <5d90b252-c650-9908-05d3-fbbfdf47aa38@ieee.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <5d90b252-c650-9908-05d3-fbbfdf47aa38@ieee.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0194.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bd01f23-5b15-4cc7-c7ec-08db1e2e023c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Pkzvrt+MQeFlcsaD1fthNCkcnvCKHJkhitw91VP75RqZGmr3pQrBa8TSnobcwPeXrJff0yKyDD43ViVv3i69FgKE+NsB03epodYNAeXEEmp1yiaRZK0s0jf6u4QmxCN0MW6V95H1iY1CSGMQBrlID1/F+M/MO9QJEqUiU1vT/5bhROdliHzYmObOwLwzCGXoQmvD7o3Kcm3biqlCRjTkc4iMukDW/dpEPMsCQl5t282W2xsxOt8+gIwVnyVKtub6/yaFrNzauQ9FfWwo6MgoZuNzw3gOG7N4E45qFYNAwxw2vhGox8APzq+/YHz9l+IpSr29UOqqf0RNHYyp15GljTVAG4GBSVLq9mjmF9+hTIVwIsceXjva44S0u8wX1/N+jzFQZXdAYU4dFj/hbbZ0tcf7tgLTFjd49VuODJ4f8O3/9jfLsUZfd+cIlnBKJfNi2qmyS1AX+K3tDqw5HNdyCiTNq0KCRQGEqtxDMRcxOmvluwnHWnjn+wyyNy4cdPplLqbewpiHXubZkBSpPk6tnNQMZdjkE5xD3xhB68VlufNrrzYO4EQTFN6TkLHPQ8ogERUCgpMLVs4cCiDDv/NjRkm9ZNAEoCM3Dkf8ymPBxNuDwnMFUyDAcxfzZWQABB2ror94VulbNYmsjYe+tYUgPbbL4+9FlfiH/51VhjBt9+lN394Tp8AeBPyFbgAE4Viy897d7T9wTWhO/nQlNVB4sVsOK2OV4O40RLyvRY0IV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199018)(31686004)(7416002)(5660300002)(8936002)(66946007)(66556008)(66476007)(2906002)(6916009)(8676002)(4326008)(316002)(478600001)(36756003)(6666004)(6512007)(6506007)(6486002)(53546011)(26005)(2616005)(41300700001)(31696002)(86362001)(82960400001)(83380400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTR5RWs2ZlY2djZyZzM5dEFTUGhqTkNWQmc5RWtqVVJJd1Q3c283UXBzcUd4?=
 =?utf-8?B?ZFp6a1Jsc3U0MTk1TnhqbGdiRXBWVDVCeWNPTUJycGNoaEpqRk00aTY0aTgw?=
 =?utf-8?B?NXJxbHB1QncyYWtnSkRicll3aGhKOEE4VEdSUEsrSUpjT2o4QXVxUENOZUNG?=
 =?utf-8?B?aGtvZjJqcEw2dGhNUktSQS9ZaEI0cnRhcVNvamsyVVp6dlY0TmhIbUZnditY?=
 =?utf-8?B?Tnp5ZkhGUjNDaksxakp2S2hlQ2V2bkdFcXFlbDA5eUZQL2cvVUdJSEtFYnRJ?=
 =?utf-8?B?bkdlcUtOYXRVQTlidCs1cVNjZndvcEpsbFhaaSttYVlvdzJYcTVWckVUN0Fp?=
 =?utf-8?B?cU05RTl3anJET1R5SUZQVUhTcEZTdytjNjNqd095Wnk5UXA3NkdXRE9pQXZM?=
 =?utf-8?B?V3Vmd3BWQ3BGZ2tDZGZxQWZMR3ByZ2JBb0E3VHpIc2xTdmRpMWVScmp4KzVF?=
 =?utf-8?B?VC9uN1ZPSHRFeFlpeCtCOGJYeHc0QURHNElydjlET2U0dVFCcmNIcHltRkw0?=
 =?utf-8?B?czhENXpiUzdnbnFRQnozMnVnNHdFUGZ1S1AzY1prSjJkQXpYVncyRGNPd0I3?=
 =?utf-8?B?R1dEbWtFRzdqRnNnSzBINDFiWHpsRE9PK0J3MXorN1B1NnZKWVZwUjFnQjZj?=
 =?utf-8?B?UlJHWHoxNExZempWY1pId09JeGF0a1E5Y0NETGFkZ1BmdDBvVDJBdHRCMDBJ?=
 =?utf-8?B?T25UeTlWQjdpQzE5ei9QZ1VQak8rTitqNFVvc1V0WC9DRVhmZEhmc2RXQmxK?=
 =?utf-8?B?Yis1c1JzUHBmakczSlpaL0lzVXMxUGpJNUVGMVdjZVAyMHN0MW0yRGM0QnVu?=
 =?utf-8?B?NzlQQkgrSGV4eklMUUlONmxya0wyQWNwc2hDRE8wQUJsV1pqSU9NM2wrWVdE?=
 =?utf-8?B?VTdnTUNWWG5tcTBhWEVJUEM4N0NMbXg4WDFreWsxVmxuMXVqbWljcEN1Zmk5?=
 =?utf-8?B?Ty9GRnJoeDdCUFdlRlRDcDhxek04OGU5d3AzQXgxRE90Y0l2Rmk4VlJkSVZZ?=
 =?utf-8?B?TVhJelNDOTI3eCszaVQxQ0xLMk93ZFBMVElOQjNtbk5EUVM5dU1FdjBZRXpC?=
 =?utf-8?B?SlFnSE1QQkdhR1NSWVY3YTd1VTR6b0VJSE5scDIrcTZkYUF0M2dUcUFDMzY4?=
 =?utf-8?B?eGlvVXlQWEt1czlEN3BPSmhxdTk3bGM0dzZvTHpKVzI4NXBDS1dKL053ZkJo?=
 =?utf-8?B?T1BjWTVuRGJESndPbzJoOEE2R0xkVk5JOUo2NURuNzQyRmQ2UWwvQ0dmV043?=
 =?utf-8?B?T0VQZG5IS2ROVUNxQ3pKbjloSEduMTJNMHRlR1B2VGVINHptKzR6QjRhazI2?=
 =?utf-8?B?Q0NSUEpUb3FRam8rLzY4NzJ5azVTR0pPbk82MFFML2hZRHBmQ1BFQTdaakUy?=
 =?utf-8?B?blJrL25NUVNDRnpGVGhqeUwxT0U0OVRWRFEzdDc1Nmp4OHNSTmQ2SkRJMWps?=
 =?utf-8?B?OVJqZVlIblNtS2NOc045QmwrNkJtazBFZ0kwOE5KdXg4NXZVS0IvWUNnZ1pC?=
 =?utf-8?B?ckErUktXZjJ1Q1l6MzVPejZXblRHTFJTL3ZUQVdRaHJEVnJudm5MMElMMWcr?=
 =?utf-8?B?blFQVGIwelhhT2RnRm9iZStKQnRoMjlKV1pwLzM3djBvWTBSMjBORi9MNnBK?=
 =?utf-8?B?Qzl2Z1pVTm55NEFNcjRQZnNNYmx5emN4YWhMVXgyeFhaMTJIcTdxVGhYRnZi?=
 =?utf-8?B?cmJIdXVoQ1RGb3lzSUV2cEZiKzVVUStndHRXZW00eGVXSzZ2Ry96bExKM1lD?=
 =?utf-8?B?V21DUFBVa3VKcGQ5OFk0WlNiSFIzbHovRlR1YXhXcmVET3ZIK0Z0UWNHYTM2?=
 =?utf-8?B?enVVMFBjL1Myd1JpakJVMzRUOXJPNkpBN2UyeERacGRrTlFGcjY0eUJXSk9z?=
 =?utf-8?B?bU1Vam1VVHdtTUFqWHFUYzFaZlhoOXZIU3VBdDk3Vk9tVWF5RTc5aFFQaHhG?=
 =?utf-8?B?K1gra2lGQnhpY0dHZ3pqRG02WXBlOVhzQVI3RXpFOXRhNC84eXNlU1FMdzJ0?=
 =?utf-8?B?SEFSVy9JOGppUmVOdEc3OWxqS0REWDJVSytPanZkTXp2KzBMYTU1RlNDanht?=
 =?utf-8?B?eFBSZnFtRHdVcnJwR1IxM202MmVDRWxXaDdwMVQ4WDNqU2psa2lSTWZoank4?=
 =?utf-8?B?b1hUdVYwZW5qN2ZpT3d3M1FtK0p5NzdhVXM4RmxLT0ZuM1BFODF0eTdMcEZL?=
 =?utf-8?Q?35w2nWaYsmPV2HCEC8f4AF8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd01f23-5b15-4cc7-c7ec-08db1e2e023c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 10:31:56.0423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrxkL0E6j1KcaLQXIAGpDcnf22eMKMTjRIYifmGFIhc3MNeA2xT/lc2nNY2Ypvi4VWICJelL7JCnXxAIEMrCmNPFG02DfrIvHhYKO51Lnjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8108
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

From: Alex Elder <elder@ieee.org>
Date: Sun, 5 Mar 2023 10:58:19 -0600

> On 2/17/23 7:04 AM, Alex Elder wrote:
>> On 2/17/23 5:57 AM, Alexander Lobakin wrote:
>>>>> just devm_platform_ioremap_resource_byname() be used here for
>>>>> simplicity?
>>>> Previously, virt_raw would be the "real" re-mapped pointer, and then
>>>> virt would be adjusted downward from that.  It was a weird thing to
>>>> do, because the result pointed to a non-mapped address.  But all uses
>>>> of the virt pointer added an offset that was enough to put the result
>>>> into the mapped range.
>>>>
>>>> The new code updates all offsets to account for what the adjustment
>>>> previously did.  The test that got removed isn't necessary any more.
>>> Yeah I got it, just asked that maybe you can now use
>>> platform_ioremap_resource_byname() instead of
>>> platform_get_resource_byname() + ioremap() :)
>>
>> Sorry, I focused on the "devm" part and not this part.
>> Yes I like that, but let me do that as a follow-on
>> patch, and I think I can do it in more than this
>> spot (possibly three, but I have to look closely).
> 
> Looking at this today, the only OF functions that look up a
> resource and I/O remap it in one call are devm_*() variants.
> There is no platform_ioremap_resource_byname() function.
> 
> One that's available is devm_platform_ioremap_resource_byname(),
> which could possibly be used in the two locations that call
> platform_get_resource_byname() followed by ioremap().
> 
> As I said earlier, if I were to use any devm_*() function
> calls the driver, I would want to convert *everything* to
> use devm_*() variants, and I have no plans to do that at
> this time.
> 
> So I will not be implementing your suggestion.

Sure. It's fully up to the developers as it doesn't make the code worse
in any way.

> 
>                     -Alex
> 
>> Thanks.
>>
>>                      -Alex
>>
>>
> 
Thanks,
Olek
