Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16D4BF4C1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiBVJ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiBVJ3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:29:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6CB153385;
        Tue, 22 Feb 2022 01:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645522131; x=1677058131;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PWyQu00fp/wF1s5qisBCTiTvYghd2A2DHPwfQyjVpww=;
  b=VVu6vO1ZkhmxacmLQcC9VLQlo4q+rTHGpZu9KX0rDMuw2LoqOiUGAVsn
   TMoOvca9C2RgukU4RPJsiNUWnjLpl5KiP0FJucmj0mjo11Idte7mgWab1
   N4FhRkeIqx5HObXY7zZQIVEEMYfdMR95o1cHABPiKQeMZ7g4e/yvywTbl
   rmtnxl0L8gDL4BxRMr7/dsF09apEAdG+IN+Sx40zjmbLQ+u5RZJznyIyw
   q5AD4GssI3Ig0naEdfqUMY27Eq5QXZXAWF4rSn+d+c2o3ZAXMtsvz026m
   bmT9n6DHJxKEKs31SPbYcIcs/fbwLpC0pdri3C+YVdT3GEDb0dd2meNDR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251418073"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="251418073"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 01:28:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="507916565"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2022 01:28:47 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 01:28:47 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 01:28:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 22 Feb 2022 01:28:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 01:28:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlMqUcgK2f+q2ym0Bho+AR2Fc6RKddIn6xAec4g3iCAd8NHNsBh3LPc+jQEo4fRsm9EuqPJiUCyC290rtJ1iuf9mfUhSdsEaFfL7Ik5cBgVEU/rvFOOy8cvdKkTUzLG32OIcEeaN781wwdZ1YVAEwwJGRHkjqihMBoKcsRaUpVKgK9BRxQ/rN6s/mxiNv+9aXEX2MQC47czdZV3SXZ5iiwMSjvq2md1xUs+ZOLHgEvHqGWR4/W8AE6hcwzB4yF3CIe45CTnY7WOUr6b2oZUjODUS9xYVR795+k3KP/A0MBzCT1Z20++VsrXjtXsMqkPW+seFN0/ydXKZlzvQMyyuiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcKfHFS8vEA8woM/6fDYP4563iXKj27a2p4wpjLbQgo=;
 b=A3LNeezBEKVG50GXvBY1hc0TyqDOkILRmiw0GAfiuRa0AtnZKhGDMUecXV/Ta6jfupGgOyLcixm7Mt5zod5xI4ly4shNAogfDoVYsf1M9VsZvVH060HRTa4dXaGhBkTJy01xmNAoanDitpgqn5AG+R9ytvJ6vak20epybxQP4TiVF3YSJLzGDE2U9hp4mjUlEwUuO4dlgNpdmsqYzueux5BF+Vyz7z2MhYprwozrQXD8DzmxrdIa1bSerx3wXOhSmDqTrDcJ/X1VOxtgVtgqIHFCMTnP+Msv7PSYWQYzxwtSzw4aONDYDT7Cly2PmUBEv0EpOvTDNSiwshEowYM5dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (20.176.122.77) by
 BN6PR1101MB2113.namprd11.prod.outlook.com (10.174.112.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Tue, 22 Feb 2022 09:28:39 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 09:28:39 +0000
Message-ID: <acc45712-b6c7-5cc8-920f-93f3db45413f@intel.com>
Date:   Tue, 22 Feb 2022 10:28:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [Intel-gfx] [PATCH v3 08/11] drm/i915: Separate wakeref tracking
Content-Language: en-US
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Lucas De Marchi" <lucas.demarchi@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20220221232542.1481315-1-andrzej.hajda@intel.com>
 <20220221232542.1481315-9-andrzej.hajda@intel.com>
 <YhSM4HFT7UpRYEIg@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <YhSM4HFT7UpRYEIg@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::15) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d73332a-8308-4ce0-d2fe-08d9f5e5b56b
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2113:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR1101MB21132395AA0B7206B18FF56DEB3B9@BN6PR1101MB2113.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS6ZxiQgoPlgIIjg0qPqVLzbMa8qBv8rDunPiAUd8TwLWdZFFGVnbImo2eEd20gTOo932H2uGCbHB4EL9prfjnJSlHwwQVJbqiEyJMBCIrdpPktccufEebUQ1P5SUQd4nGSIk7xYOc0NQrsps4qavp6JFxLD/pvd7ONRZTQ53EPvw6xjgle1znPbSxt0EgtscrM+ZscQRSBzDfwZurHNKblQ5a57Mf/G00qjRPVKlCPXfD7ZLme9XCjwrRjwSRE84ja+ucx+t9L0dFF8dfXwS9vc8pli4K3//cTF78spNgibSYkMkdCVcffcxXc1F17TeH+wn6x3sWzQVw8d16sluAPJlDuOrcnpJPaeUdhmwiGt0oXNNRfm/uRqnWEvTk59frsNwYl3oHElHKSaKXZSR0QiL8vNGdoJoRM7ZFYJbkp4d1esPFN5E29/cF4pah1Hx50QkmHQiS6butfH6s3QinaYzbjlbJAzbzkuUFCkD3nJ11aLZPVjYuDvcFyIPaz9PhisKYTXylZT5HGNkd7ZVZdXvwRmUXPbVV09rJnkhA5lqyWmGa1VKoXjLG0RmWynNbiORs82H6gysYlejl2oQ/y6qVBHbsFVRjTbraaHWg+7jBJnJimdj+uk3/ckP+/3UlrIIFAEqltoMRx2Ww+ljpcnWGhmMVlBtTL7KDgr9uP6PMXqIrH9tsQWTrn365+Y7KoVD+Y5ZUc9JJvH8T3iPA9F/QtTS4/0NSd0CavGFHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(82960400001)(38100700002)(31696002)(86362001)(54906003)(53546011)(6512007)(6506007)(6666004)(186003)(66476007)(508600001)(2616005)(36916002)(6486002)(36756003)(66556008)(5660300002)(4326008)(6916009)(8676002)(4744005)(44832011)(8936002)(26005)(316002)(66946007)(66574015)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFlqaW5ZRElVaXY0MGdOejNqY1ppaWwrS2xZd3ljdWlBTHpnQTl1U3NFTnFi?=
 =?utf-8?B?ckh4K3dXZzE3dkxxeGZNYjUrQ2hTcThsd2U5L1lNZVE4S0ZJNElnNzJOU1FP?=
 =?utf-8?B?b3MrSVhrelg4RS9sVTdqOGJsTk83QWxsQWJiZUVmSVRHWER0T2lsT29PY1dt?=
 =?utf-8?B?M0RUYXZjSHVRLzRPRm5CNWpreW5EK3FMMGd3d1VFbmlnWEdqRUhjTlpmTmJX?=
 =?utf-8?B?elkxakNVM2hFakRQNDB6b1N3blIwbkxEU0dFVnkzM25KdWdsaUJFWTNhcHd0?=
 =?utf-8?B?V2V1Mk1uSlRGWTFGNHd2SjMwckVIakJoRFk5NmlEcEw1eW9uZ29CSTYyMngy?=
 =?utf-8?B?Q1lrN2U5dVZCSnlLZ2dmOFRPUlpnYUtyVmJMcUdBN3JBL3JZOUVab0VlWUF4?=
 =?utf-8?B?a0NhV2pyWlo5Z0ZHbkxXU3NmQVZPenVlWTR4dC9SUlpiNzRSWjQraGU0aGtD?=
 =?utf-8?B?d2l6UStGZkIxZHNDNXFMYWRYeVU3TEREYllHcWFBcHpzZ2ZqaTd2dGhKRzl4?=
 =?utf-8?B?QXZCeHdCTWRnTDEzc1p6ZVNxNUdzeGx4NVhEZTlsT0tSMjVJV01vT2VhS3pG?=
 =?utf-8?B?L3ppRWhML0wxdWFBeXNpOXpPVnNnRnluU2hwVlBENE5vSWl5RGsrcEJUYkF5?=
 =?utf-8?B?cUpLZGxwdmI0OG1zbmgyamhhV3RNTkUxN0dNM3c5RE5RVmVjZFBnYk5aWkJR?=
 =?utf-8?B?YzluWEVLdXQ2K09mbzQ1U3RicGJSSk8zSzdVVmZOY3J3dEQ4eE82ZU9lK3VT?=
 =?utf-8?B?aUlpeW51YlpXL3Q5S2JRYkI4dnhQZVpRcUdVaWRiK0l6RlVpaDQybXU2SGhL?=
 =?utf-8?B?eDVCeHo4dldZUnlkYm9MVXRrcWJRWkpGdVFjSFV4cEJiMmlkZUg5aHBFY2tR?=
 =?utf-8?B?aFVSeFVNYnczMDZRL3hFZDlWQStMendoWDZwVnhsNlNSZmo0K2haZDFtSUNF?=
 =?utf-8?B?Z3ZlaDkvNFhLMXc2QTRlcVpJWWNNNmoySUFQdDQxKytGSVBsSjZZSG9Fc2xF?=
 =?utf-8?B?RVJ5MUM3bGRMUWx2S21HWmVEYVNVS0ExVXBETXNHVW91R0lFd2lYUGZyQ0V4?=
 =?utf-8?B?TndCRmNVWnFWNTFoa3Z5SmYzRFhKL1lIZVZmMEh5RTBhSTZ3NElucjRaL1lT?=
 =?utf-8?B?S3VSbE1hUkR3ZHlvWGNiUFBEWE1kaXNvc2w5T3JYeHJDcTRYVDZkKytuanpH?=
 =?utf-8?B?Sk9ORkIvbTdZWjR5Q0I0d0tmakJMSjlEc21sMWtQTnd6bDhweFZZNGNzdnBO?=
 =?utf-8?B?Y1pNNmFmQmpwd3NCcE1OL0RxMFg1dTJoK3I0VjYzNzNtMW9nZE0waEJrRzZL?=
 =?utf-8?B?MHdiRmpMTkpIRmJ1VzJ1RThaSVM1RzgwcS9WTU1QQ0tkTzltT3VvS2kwMzM3?=
 =?utf-8?B?YXdUalkzME1qbFB5M3FWeGpuSEpnTFgyQlE4RnJpL0xzUEFNUGZHaWtaSzlW?=
 =?utf-8?B?RmlEbVBKWWpxZHBlWENqNmVyQjROaFhBalF0b3JKL3NBK3ZWV2FZbHZ0Z1ZL?=
 =?utf-8?B?L3JGT0ZUSHNta1dRMHhOY0JtSGE1ZG5RMmcrYTdXOFllc1JIN2xXR1hCcGtD?=
 =?utf-8?B?NWwxTm92cVRoVDNWQjhoN2pSNDdDdjdmWURSK2VIS1g4U2llTjlKdFYvQmxh?=
 =?utf-8?B?YUtiUitaZ0k3d1c5dnlpcWh0M1owVzlEbXFzTGJxeldaRlRmbXRuVlBXWEU2?=
 =?utf-8?B?R1pUaldQSDB4SVVLOEVWUVpUdXdYcGVteUZFZXo4cWFxT09yQXFvQmwrZDhH?=
 =?utf-8?B?dU5pejdZTmlpejVTWFRuUEU5NUpNNjBiT2lYc29ITlNBaWdnalc0RTY0S0tL?=
 =?utf-8?B?dW1pSW4xT0RwTjV0cUxEUXYyOWxTTkRtK3p6bW5ZMkovdWxYaG9zWGZQNkta?=
 =?utf-8?B?TUVXU29jSmMybG1LK28yd3d2Mk1TZjI4ZnhqSkpCRVI3VkNMYlprQkd0ZHAx?=
 =?utf-8?B?Sk1WbjNLWDBTL3lPdWhJOFFlOXdtdkV2aTllZkRScFJ2S1dybnVYRE5uUWps?=
 =?utf-8?B?ajh6VE1OL1VaLzJ6NE1TSlNGZVh5MkRDVzdVdTdkWnBnVG81TldNMFIyWE81?=
 =?utf-8?B?ZDJVUEQ2NjRPNVI0UlpNRWwzY2VQVHRNMzB0UE5saS8yYjcyMlFuN3RmVDNT?=
 =?utf-8?B?eGFXYlQ5L1FYL25leEcyUkh2QUhDWnZVUFdWdElqYlk3SGpXc3JmNEJUY0Jj?=
 =?utf-8?Q?eGbKogWzmkYOt0yZqiVM9II=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d73332a-8308-4ce0-d2fe-08d9f5e5b56b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 09:28:39.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+AZnYDxwfBuQK6ecAPsotvCp7iJDqg70eAekAPGY3YGYXHzTxrmO3LyORKkdcEQbqw+uDms2YhDAG/q98Z2qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2113
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.02.2022 08:12, Ville Syrjälä wrote:
> On Tue, Feb 22, 2022 at 12:25:39AM +0100, Andrzej Hajda wrote:
>> -static noinline depot_stack_handle_t
>> +static intel_wakeref_t
>>   track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
>>   {
>> -	depot_stack_handle_t stack, *stacks;
>> -	unsigned long flags;
>> -
>> -	if (rpm->no_wakeref_tracking)
>> -		return -1;
>> -
>> -	stack = __save_depot_stack();
>> -	if (!stack)
>> +	if (!rpm->available)
>>   		return -1;
> Still not the same.
>

It was fixed but in wrong place - patch 11. I will move the change here.

Regards
Andrzej
