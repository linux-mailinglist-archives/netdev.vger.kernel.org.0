Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB916795B2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjAXKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjAXKtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:49:05 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6630218B04
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674557315; x=1706093315;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M3hMJVGxGoGeifKmMhQUFbAM8lMGNeNtEccTXtu/QxM=;
  b=RpE/PHs6a58/TXMyjWqRVoQG/3wXV/vHtx0N6cfhu1z4IMVpWcbicw39
   t6taAiKTFgC9lOLtF5cAxrUNmpYV8irNECH9za4aPp885PFW+QDG4mp0J
   r95PTE1qml0dv+X/q7hEsOkNKeWbCi/7Ao3oXYM30BQkG58Jn2+0OxAZh
   xqQMHKpTnUezU6mlf184+gA528WMfHVw+C5VlFZ5xWkN2lYUkVTir5Ppw
   3S4Xfu0/DMcC9N7/FMmWZFWacBPimNmklCNXn5HF2igckcR2I7m2u9yx7
   e/sIP/MW9oCWOz/UiqAP2eeiVj+5NZYUsI7DsMGswMwaqFGiDsLFjbYxV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="323961829"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="323961829"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 02:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="770259824"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="770259824"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jan 2023 02:47:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 02:47:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 02:47:43 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 02:47:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 02:47:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3MQk1On1qgs9CkdxbE3dnqDunC3xd+3rzlb8QO/4UANo6bLlMaAQAoYOd1NVW28Ys1GV35H3NtQiBuD7eOfZMoVyMhX2W1qjaQe04XeMhPVoYRw+PAZkxoaZzFsujAuBEqHC4mvJPmLNyeh7bz7ak3VDp0ntBirF+EFs67uheabCmXhLHB2o7CIrbmpX5dkwTx75Fwb2iY+nAAIVeA9wcnno2QTHd+Uol4K5p20udkJJha955wCofv7AONlr6FSIiimV40EALg3E28+NnuYoH3mzhZIbeHOBrnoVoFYx49pstLZwMfKAMiqAPiIGPTY96LFaq3n5lb7SH/kdayhVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlrOQaIcWtAr75yfr2TAm4AXb/qvQ5gDpexGGNPBm64=;
 b=IKgN5K6yYZlV2VeZz/SFgkughhdIggCSNVBUJWTYYjesdR3u+CertFQ1fq+VDOykAAm4KUoQ1/j3HtRYuAOKt08ZRlj5EIvoiJPjfCjQmqiNS2Dz6SNMSVN6/EA9qzvPo41Y/ZqMRr+ubUrZZlwHo6QLbRL/oK2BB6XnT3s506P6lcW9JRABqUB9lfGaP0S6AKuaRvnxMggHzSXcPGqQUNWlf5fqLdJDgPKl/7YPWnAKF50YGjLHzqco8aZT+VhKJfauSsyhorMULIDcGn5t5i+MSB/r0wFJXWX7ndeqRxVDZiA3x2GXVHA489cjJkzEMDI2gvJ5fA80UdlHrzUaZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6474.namprd11.prod.outlook.com (2603:10b6:510:1f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 10:47:28 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 10:47:28 +0000
Message-ID: <af962003-5d03-ae00-0f05-085fc74add6c@intel.com>
Date:   Tue, 24 Jan 2023 11:47:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH net-next v13] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <gerhard@engleder-embedded.com>,
        <bang@vmware.com>
References: <20230112140743.7438-1-u9012063@gmail.com>
 <450e40d1-cec6-ba81-90c3-276eeddd1dd1@intel.com>
 <CALDO+SYoQ5OaEdxFGh8Xr5Y-kDzGB679F+fSKQGsk-4=i4vOaA@mail.gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <CALDO+SYoQ5OaEdxFGh8Xr5Y-kDzGB679F+fSKQGsk-4=i4vOaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: b1bf1e58-bb60-4ca7-c498-08dafdf862e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyveu9vhFtHZ61XeFU+Y1yVLpFXPU+3qRb3NVYrBXoWTDjbNQADv+WDyRZMAHM5f3bD/6p+tLhYXlRDiIu+0u4bQTi9cB9+7N9y+hublr6y4wx+PbxrASV0Nc2qhTbKtZmTaHtkWTv/qOWQv+6zHRI00Id2+6BmzycuRa9vwW7QM8Xw3PmhkDv2eR0qhxokkHJNEprcotE9esxWmIw9goBXIVUEL3vVudIi37lbhEtjAstzTr1HGOu1yCTZUwS5aErjmdC/xWShEP32bLwNC21WaBDImgJUXuF7b2T8QBTKk+7dAiwjk1pauu8FzGqLyjDNYwyq8po+dDXMN/cu8mByq6PGWf6+acN31DAb3CTKDBAaJninpbq1hyxWkkXREHz09mr7B6JfQq8p8ZD/CH8LdU1uomj9XTu4YWHsMFxKdYSf/q+ak2yeYngM9DrfEL2z0twVR+Nw1Q3/0WKeIEQO5gop0P53fOTZlWcgeF7VRc7OrEJ7w+I91g3V7Rf0fMrZoKy60RmGGK2JIoBb8a6yydVFFc+yNyKBnrmLxaSKFihpEbVDd1lpZMew5oYT6GM0jWPxLjH7C9DMdjzJbv7Is0KmsjRIhv2B2n+NBroVBajYsCXedYfLXjo7xmujNw0ZQKl4xVnKHIaKLVXoFKFXUgyNSbb5HI0aRVmVz9Xc9h1SHcbATXNY61sW9zvktMUl6JugOCOjJJ/l2/wgnbIJN9tK8sB/hrlxxfPvUYGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199015)(36756003)(82960400001)(5660300002)(2906002)(38100700002)(4326008)(8936002)(83380400001)(31696002)(41300700001)(6486002)(478600001)(66476007)(31686004)(86362001)(66556008)(6506007)(8676002)(6916009)(6512007)(53546011)(26005)(316002)(186003)(66946007)(2616005)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUEzVEV2YkxPM1FpMVBXMVJkbnJLVmN5MWZzbGxoZnFOMU1qU0xNcHBramlI?=
 =?utf-8?B?cU5odkcxU2cyckFuaFMvSzVZWm4rbHlRSFdxN3FwZ3FLbUVyekFqWkMvWEts?=
 =?utf-8?B?RmVoelNsTElYSmUreVYzazgrNi9wM3JyajNpZXFkV1pmU1piTGhTZGVtVExw?=
 =?utf-8?B?dGQvWklEK2hDN2E4ZU14N2U3V0VNMTdyVUxtaitWbW41blp4Q0hRMVhWQTM4?=
 =?utf-8?B?N2VFMjRhMjZmUGJ1SmpFSG5wQTBrZkZlS3RjQkdIWHgwVVdoQnY3cHZyaHd4?=
 =?utf-8?B?ZGhWNkt0ZmlrUXpRYkY3UzZySHlkWHFvZS9kUkZRYk9DTFowd1hFR3hoRith?=
 =?utf-8?B?RzdVSWttMkV3Qy90RHQwSlY4c0p1ZjFCWWhSWmg0ODNwcVR5S09tWUwxd0FN?=
 =?utf-8?B?MFlvTjVLSlZSRlJ0aU1nRjE5SW1TajF5WHZ5M1RaUEJZRHhORjJyaC9TZ3Vn?=
 =?utf-8?B?d2Q1UDFGalkwL0tuaVhWNEFOYUlCMUJqMGVqbW92N3dYcDYvY3BpU3duMlVK?=
 =?utf-8?B?bkxXdklyZXdON0wxWmxoNUV5RXovbkswT295dDdQT3V0VkozVUhKNkpSR2tx?=
 =?utf-8?B?ajIvMjBQcC9wWm1Sd09VZzlFN0ErZzBudEpITzZvL2QvYmNVTHZnV3ZEeDB4?=
 =?utf-8?B?VjFPOUlVbDZZN1EveSsyTi9mbGJpWFZtNmJ2NXVnU3JOSTN5cjlyZmJZNTlQ?=
 =?utf-8?B?R3hrZVBITHdCYkpNR0gyajJKZlFQdE9KWEVvaW9qZkRablNHc25EV0RuUzN3?=
 =?utf-8?B?Y3VqMlRLT3BURS8vWmhaeVl1KzFzVHdmVHN0cU8vZUo0U080WDhLV0tRZjgz?=
 =?utf-8?B?MW1odDlRbTQvVUVpbWQ5R3hUN1JtZVR5L2RMeVY4MitNdW5CSFQ3aEZUWTVG?=
 =?utf-8?B?RlVxODRMaWFMUFBHMWt0aWc4dG4wTGIzYitta1JZd25XNlRjU0QrdmhmY3Nu?=
 =?utf-8?B?TmNvNkV0QWQ2cFh5WXh6U3EyOWhPMEd6V3plYzBhM1BKVWZ1TEdZaHNjZWVM?=
 =?utf-8?B?TlgyZnNiNkFpUEZKUlh4RWpkOTRDMVM1QzltN2hRdnRZTGZZZnNpZjBVMDM0?=
 =?utf-8?B?TUlzd0wzVXZRbmltSjcxbkVzYXBmR0VCMlZhR0xrbnF6aDYzRlFFVUNKRFJT?=
 =?utf-8?B?MXNxTDM4d1JZS1FFYnluV3BZNkZoUWdjUFByc1grT0hoT1BnczRBS214eVhj?=
 =?utf-8?B?eVpXL052S1J1azcwQWwwRWsySVB0cHNaQ0JLZzZqOU1wc3hVQjBtcWw3OWVa?=
 =?utf-8?B?VkxTb2xVMzJ6R3JabXFuVEpZKys3S25MT3Z6WUlNNE1tQU1Ea3JpSHZlOURl?=
 =?utf-8?B?clR6WG9yVnV0Nkt1Z1BlZlNJRGZvdDdBaVJTdHZBV0p4MmVOQmxLQWt4MnI3?=
 =?utf-8?B?cG1HN3Rma21aWlRXeC8vRnhWUTRMWS94U0hJcVI1Z3ZScUJWUDhoZWlOZVZi?=
 =?utf-8?B?RldQeHJpT1ZwV04yOGowNjBCTmNNazlNR2gwazhUYmttT1hvWXZUc3hGK0FN?=
 =?utf-8?B?L085Mm1ZQmZlZHhoL0pIcWM4V1ZXM0h3T2J6WWd5RUE4eUNpQzBRRWJCQUVR?=
 =?utf-8?B?WjN1a0pCa3V6TVRJcXVWUnFXOU1mTCtTck5PWWRiZmFZWmtSY3RTWTdQenkx?=
 =?utf-8?B?VXVtLzNjRnZiaWczTTRZZERDdVpjekFoRXU2TmpKYUZMWjZ3ek1xUjFKODhj?=
 =?utf-8?B?UGlmK1RCTjdkclNSWVFJUVdpYmZCMjZSa3RKLzA1emlLVG4yVGgwOS9mZjFF?=
 =?utf-8?B?TUtFQWo4ZWNERlJpVDhKZW9kYTJ3bzhtcHBURlRhR1VHM0pDeE5KdmgzMmhB?=
 =?utf-8?B?ZDVlblQyV3lwUElST2lGU25iWUpQQ3FBcXJSeElzR2VXcGsweE83bE1VdHJQ?=
 =?utf-8?B?cTFxVFJGcW10T2V3QzVXY3hWRmtJOXlSWCtvTGZ1eWxHYnJXSUtIT3pRNHlx?=
 =?utf-8?B?dnZ3MW5GcXNtMFhwVXRMcTRlUkZoQk5PUjZ5aHBUaXZsWEszVWpOUmFnVG5o?=
 =?utf-8?B?cFdKTnhoR1RLc2JoeFdncUhLOHEyZ3NHR0RyMnp3dHBDUmtNbVJId29HT2Zr?=
 =?utf-8?B?RDhwNDA3cjZ0STBnSDVNNDhQSFllMzUrRUNxT0EweHhWczZLclNFemNrUFdL?=
 =?utf-8?B?ZktISVhtZkN4aTJpNkU3TWRQVm4zOUZPTmVoV1ppNzhoMmI5ZHo1Wkgra2JO?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bf1e58-bb60-4ca7-c498-08dafdf862e6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 10:47:28.2010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DysDVqP18uhVuqPJLUmb9494QuPMvwxd3dsmbRqBda5I8NJ1seZHYR7TWQ/bFJBZOXpuxORC0sTVWwh0dO7wlaYxqFWVngbux3JBYVhcjXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6474
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Sat, 21 Jan 2023 10:29:28 -0800

> On Wed, Jan 18, 2023 at 6:17 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
>>
>> From: William Tu <u9012063@gmail.com>
>> Date: Thu, 12 Jan 2023 06:07:43 -0800

[...]

>>> +static int
>>> +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
>>> +               struct vmxnet3_rx_queue *rq, int size)
>>> +{
>>> +     const struct page_pool_params pp_params = {
>>> +             .order = 0,
>>
>> Nit: it will be zeroed implicitly, so can be omitted. OTOH if you want
>> to explicitly say that you always use order-0 pages only, you can leave
>> it here.
> I will leave it here as it's more clear.

+

> 
>>
>>> +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>>> +             .pool_size = size,
>>> +             .nid = NUMA_NO_NODE,
>>> +             .dev = &adapter->pdev->dev,
>>> +             .offset = XDP_PACKET_HEADROOM,
>>
>> Curious, on which architectures does this driver work in the real world?
>> Is it x86 only or maybe 64-bit systems only? Because not having
>> %NET_IP_ALIGN here will significantly slow down Rx on the systems where
>> it's defined as 2, not 0 (those systems can't stand unaligned access).

[...]

>>> @@ -1730,6 +1863,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>>>               vmxnet3_getRxComp(rcd,
>>>                                 &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
>>>       }
>>> +     if (need_flush)
>>> +             xdp_do_flush();
>>
>> What about %XDP_TX? On each %XDP_TX we usually only place the frame to a
>> Tx ring and hit the doorbell to kick Tx only here, before xdp_do_flush().
> 
> I think it's ok here. For XDP_TX, we place the frame to tx ring and wait until
> a threshold (%tq->shared->txThreshold), then hit the doorbell.

What if it didn't reach the threshold and the NAPI poll cycle is
finished? It will stay on the ring without hitting the doorbell?

> 
>>
>>>
>>>       return num_pkts;
>>>  }
>>> @@ -1755,13 +1890,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>>>                               &rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
>>>
>>>                       if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
>>> -                                     rq->buf_info[ring_idx][i].skb) {
>>> +                         rq->buf_info[ring_idx][i].pp_page &&
>>> +                         rq->buf_info[ring_idx][i].buf_type ==
>>> +                         VMXNET3_RX_BUF_XDP) {
>>> +                             page_pool_recycle_direct(rq->page_pool,
>>> +                                                      rq->buf_info[ring_idx][i].pp_page);
>>> +                             rq->buf_info[ring_idx][i].pp_page = NULL;
>>> +                     } else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
>>> +                                rq->buf_info[ring_idx][i].skb) {
>>>                               dma_unmap_single(&adapter->pdev->dev, rxd->addr,
>>>                                                rxd->len, DMA_FROM_DEVICE);
>>>                               dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
>>>                               rq->buf_info[ring_idx][i].skb = NULL;
>>>                       } else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
>>> -                                     rq->buf_info[ring_idx][i].page) {
>>> +                                rq->buf_info[ring_idx][i].page) {
>>>                               dma_unmap_page(&adapter->pdev->dev, rxd->addr,
>>>                                              rxd->len, DMA_FROM_DEVICE);
>>>                               put_page(rq->buf_info[ring_idx][i].page);
>>> @@ -1786,9 +1928,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
>>>
>>>       for (i = 0; i < adapter->num_rx_queues; i++)
>>>               vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
>>> +     rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
>>>  }
>>>
>>> -
>>
>> (nit: also unrelated)
>>
>>>  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
>>>                              struct vmxnet3_adapter *adapter)
>>>  {
>>> @@ -1815,6 +1957,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
>>>               }
>>>       }
>>>
>>> +     if (rq->page_pool) {
>>
>> Isn't it always true? You always create a Page Pool per each RQ IIUC?
> good catch, will remove the check.
> 
>>
>>> +             if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
>>> +                     xdp_rxq_info_unreg(&rq->xdp_rxq);
>>> +             page_pool_destroy(rq->page_pool);
>>> +             rq->page_pool = NULL;
>>> +     }
>>> +
>>>       if (rq->data_ring.base) {
>>>               dma_free_coherent(&adapter->pdev->dev,
>>>                                 rq->rx_ring[0].size * rq->data_ring.desc_size,
>>
>> [...]
>>
>>> -static int
>>> +int
>>>  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
>>>  {
>>>       int i, err = 0;
>>> @@ -2585,7 +2742,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
>>>       if (adapter->netdev->features & NETIF_F_RXCSUM)
>>>               devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
>>>
>>> -     if (adapter->netdev->features & NETIF_F_LRO) {
>>> +     if ((adapter->netdev->features & NETIF_F_LRO)) {
>>
>> Unneeded change (moreover, Clang sometimes triggers on such on W=1+)
>>
>>>               devRead->misc.uptFeatures |= UPT1_F_LRO;
>>>               devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
>>>       }
>>> @@ -3026,7 +3183,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
>>>  }
>>>
>>>
>>> -static void
>>> +void
>>>  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
>>>  {
>>>       size_t sz, i, ring0_size, ring1_size, comp_size;
>>> @@ -3035,7 +3192,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
>>>               if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
>>>                                           VMXNET3_MAX_ETH_HDR_SIZE) {
>>>                       adapter->skb_buf_size = adapter->netdev->mtu +
>>> -                                             VMXNET3_MAX_ETH_HDR_SIZE;
>>> +                                             VMXNET3_MAX_ETH_HDR_SIZE +
>>> +                                             vmxnet3_xdp_headroom(adapter);
>>>                       if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
>>>                               adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
>>>
>>> @@ -3563,7 +3721,6 @@ vmxnet3_reset_work(struct work_struct *data)
>>>       clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
>>>  }
>>>
>>> -
>>
>> (unrelated)
>>
>>>  static int
>>>  vmxnet3_probe_device(struct pci_dev *pdev,
>>>                    const struct pci_device_id *id)
>>
>> [...]
>>
>>>  enum vmxnet3_rx_buf_type {
>>>       VMXNET3_RX_BUF_NONE = 0,
>>>       VMXNET3_RX_BUF_SKB = 1,
>>> -     VMXNET3_RX_BUF_PAGE = 2
>>> +     VMXNET3_RX_BUF_PAGE = 2,
>>> +     VMXNET3_RX_BUF_XDP = 3
>>
>> I'd always leave a ',' after the last entry. As you can see, if you
>> don't do that, you have to introduce 2 lines of changes instead of just
>> 1 when you add a new entry.
> thanks, that's good point. Will do it, thanks!
> 
>>
>>>  };
>>>
>>>  #define VMXNET3_RXD_COMP_PENDING        0
>>> @@ -271,6 +279,7 @@ struct vmxnet3_rx_buf_info {
>>>       union {
>>>               struct sk_buff *skb;
>>>               struct page    *page;
>>> +             struct page    *pp_page; /* Page Pool for XDP frame */
>>
>> Why not just use the already existing field if they're of the same type?
> 
> I guess in the beginning I want to avoid mixing the two cases/rings.
> I will use just %page as you suggest.
> 
>>
>>>       };
>>>       dma_addr_t dma_addr;
>>>  };
>>
>> [...]
>>
>>> +static int
>>> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
>>> +             struct netlink_ext_ack *extack)
>>> +{
>>> +     struct vmxnet3_adapter *adapter = netdev_priv(netdev);
>>> +     struct bpf_prog *new_bpf_prog = bpf->prog;
>>> +     struct bpf_prog *old_bpf_prog;
>>> +     bool need_update;
>>> +     bool running;
>>> +     int err = 0;
>>> +
>>> +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
>>
>> Mismatch: as I said before, %VMXNET3_XDP_MAX_MTU is not MTU, rather max
>> frame len. At the same time, netdev->mtu is real MTU, which doesn't
>> include Eth, VLAN and FCS.
> 
> Thanks!
> So I should include the hardware header length, define s.t like
> #define VMXNET3_RX_OFFSET       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> #define VMXNET3_XDP_MAX_MTU    PAGE_SIZE - VMXNET3_RX_OFFSET -
> dev->hard_header_len

Hmm, since your netdev is always Ethernet, you can hardcode %ETH_HLEN.
OTOH don't forget to include 2 VLANs, FCS and tailroom:

#define VMXNET3_RX_OFFSET	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
#define VMXNET3_RX_TAILROOOM	SKB_DATA_ALIGN(sizeof(skb_shared_info))
#define VMXNET3_RX_MAX_FRAME	(PAGE_SIZE - VMXNET3_RX_OFFSET - \
				 VMXNET3_RX_TAILROOM)
#define VMXNET3_RX_MAX_MTU	(VMXNET3_RX_MAX_FRAME - ETH_HLEN - \
				 2 * VLAN_HLEN - ETH_FCS_LEN)

Then it will be your max MTU :)
dev->hard_header_len is also ok, but it's always %ETH_HLEN for Ethernet
devices.

> 
>>
>>> +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
>>
>> Any plans to add XDP multi-buffer support?
>>
>>> +             return -EOPNOTSUPP;
>>> +     }
>>> +
>>> +     if ((adapter->netdev->features & NETIF_F_LRO)) {
>>
>> (redundant braces)
>>
>>> +             netdev_err(adapter->netdev, "LRO is not supported with XDP");
>>
>> Why is this error printed via netdev_err(), not NL_SET()?
> 
> I want to show the error message in dmesg, which I didn't see it
> printed when using NL_SET
> is it better to use NL_SET?

When &netlink_ext_ack is available, it's better to use it instead.
Alternatively, you can print to both Netlink *and* the kernel log.
Printing to NL allows you to pass a message directly to userspace and
then the program you use to configure devices will print it. Otherwise,
the user will need to open up the kernel log.

> 
>>
>>> +             adapter->netdev->features &= ~NETIF_F_LRO;
>>> +     }
>>> +
>>> +     old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
>>> +     if (!new_bpf_prog && !old_bpf_prog)
>>> +             return 0;

> Working on next version now...
> Thanks
> William

Thanks,
Olek
