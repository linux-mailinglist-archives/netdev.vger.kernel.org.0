Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2E6A1FDA
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjBXQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBXQnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:43:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D63A1A66B;
        Fri, 24 Feb 2023 08:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677256995; x=1708792995;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+wpXLTxPWPlMYZM3Z1v50U8pMgN3DNprzOhujJG5e8=;
  b=cFMp9xK/29HS/jBTZ7OJGbZlmC3nbHiDb9CdBuiKY4ROtQNNq3H2szSm
   DCNu92UkdXp20Lm7w1Tz3spsEm84Ae5g6zdCAv+BIr4YpIZCD9a/rGAsF
   oYhQsTM2fxEz9ZDp2FtCrxfFYkzrCFjOzR0CyEZXZDbz5JF+d31p/V1fL
   TXVdh2YNtEZEOwtM8FAz4feXMSRTMOP9NpRiKY8+VZ8QqBYuRZc06/sn/
   RdURYw4oYlGk/NmKzBKsdWfmWKxfSsrDD3PRhujaMT6G1HZVBPg6dO9aE
   FB46M0hcAQGKfzjWl0pFJsztCrHf/43fiuhGi/iecW+CzcT8mIg/5CXU5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="317278702"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="317278702"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 08:43:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="650405974"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="650405974"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 24 Feb 2023 08:43:14 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:43:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 08:43:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 08:43:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V593N78RrHXbZqZ+29ZyvS5d/vNvNy2zrrWTNgNp4K4hp5yL+oomPLvTrAGP4QdRUgHO9KkXkPWmyYc3whBIFeeiU6ovvSClfYpiEhCPDQl1SmBkBGm6L007ueNisVl9rmgdlZVlbmr6JAuwjhDMfm5wF7BWACSCWV+14zwj53bxPyQ2FSgi7aIw2NNDm0td2o1D48vZK96Ni6CWkUJv7LQR+vj3mmtJ78eExvqQvN5eEv0fBTxcVTEoRGhqaP3Mpyt7aB7JN7UnDfj9ixTio7X3F7/vFmB8sMC/L2a8JI0rYuKuRESJDIVrp6Nbf/zSRTY0eSAT7zHYWGy9Y+ewNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIv+1Zl/HnLQxitoJV0OSHrOzw0mGRuSuxxb88vXOeo=;
 b=PPADCbcIxGKd4YxNPrtQ/t79Nnq0wR5YnRqxOx9sGs8PKO3MM3C/zNuOTXY2hqwA2QOYkx1Tzuc3O3rGYHGh5/ZF1a7j+CN1hxKNBpnIoP2kfyrVwerkP1teNupJgmj+OUkMrU09vHrki4VirRYjkQBGYqLX8K8HIda0er1U3FFdLhxzReWD7WXNRz3ApmDVI3vit42FquxYbp/h/WbyRsaEQqFOLeq2x1eRENHfb7YogNSJ1sx41ckN7kKyhmJb4mPAboCViNCiAgYh3yn7xi5I6q1ftpnH13t1KV+oyjOaBZSqxl3H5tBwPhgobOMgg55PEmOs65Ux7looaXA5aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 16:42:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:42:59 +0000
Message-ID: <6a7469e1-1db0-2f62-909b-9dcd65c50937@intel.com>
Date:   Fri, 24 Feb 2023 17:41:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     <brouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        <martin.lau@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <xdp-hints@xdp-project.net>,
        Sasha Neftin <sasha.neftin@intel.com>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
 <fe613404-9d1c-d816-404f-9af4526a42a3@redhat.com>
 <74330cb7-bf54-6aa0-8a07-c9c557037a31@intel.com>
 <59aa33b3-e174-b535-cc9f-1d934204271c@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <59aa33b3-e174-b535-cc9f-1d934204271c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0006.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5380:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a82835-17ae-4715-7887-08db16863010
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhYw1ZrbFIvCRofqphjXr5nN85h5r91njlM8l2Qwld8rZR78cq+JSYXrz8E5XL1g4Y5HKop8PB/mZQ6k+hcwX+14PRtOCVltOPkpO+HXGQCnAeCjxIpcFaoTvdTUQuhYU1Z6yMzKuFIt3J21uDwOoTUTJXKK8RKI29L17ZsMlODLZV/laLWeUpKDpF/w9w8cAaLX6lbzgqwCg3hwOXd46mIjND9f3kIz4S2hifg/KLdN7xUAdyMu46T3ZKzWLGU0v9BQiL+VxKq9JCeIRGLVASfJSc/XsVL1vFgfMpzQpi8o8NTGKhQM+rh7s0hoy6IwHNjvCXhv9QYZNDUcS2sVa8WHnKy/SHBrDWoeBLPp/WWczqSon9FkF2wg0AUrO+ug6gb+jFr+g+w6bac7jjLptQkBSg1fmn56RX64n/KUc1UWzeBh9oVMkCQxT7oYH16WYyS3e1Fw6OHT6rRrzezvIFaQvqrRRZuTgfbaKUFQ49fgEttqFQNLmRXXv0RbncbQmeZJno454zOui8oe7sZR/J0wLRGTgjP03g4498md15VmNMm4sSIbIoCv53S9YBwA2NsNH2glr5rcg6SkeyaOFBQj9wWY7LOfF0BNO9icktWKtdrbk5vYYhduMycSFnQtgPezuNFwOz2WbHzXRQtAASpoQH0Jp2JLG0TzwlWSFEohC2Pn4byMkNBWd+ljymojiFWgqrkQ/q8ANVaZcTbNBe0usntso5xFhKEGzyGJoTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199018)(83380400001)(31686004)(41300700001)(66946007)(66556008)(66476007)(4326008)(6916009)(8676002)(316002)(8936002)(186003)(36756003)(26005)(6512007)(82960400001)(54906003)(2616005)(7416002)(5660300002)(38100700002)(31696002)(86362001)(478600001)(6506007)(2906002)(107886003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V21yMnFaM1pvczdIblBkTFAwQU0yaFZCWEFmenZrdnpqNFdOdG9HMDc3ZCs1?=
 =?utf-8?B?WHRVcXRYNzIvTnhSTnRLWFJ6TEhJOVoxcHk4MVhiS3lQck1qdDBpM3FXSk9j?=
 =?utf-8?B?aHRXUThuS2ZxNXI4MjlER3BwMmRaK25jZ3F0cjBla1h2UnE3UXRZTCtrWnRI?=
 =?utf-8?B?L1BzSGJvUDhHUmV1ckFhYnFYY2lGWGtncUxVOHExd3cvWE5JNE1ON3Q4QUtJ?=
 =?utf-8?B?TGM1L3lzb0RxUkMwOEpscXRhaHJ4YlcvZmsxbkZMNVZsbWI0Zm85QVlpWTFk?=
 =?utf-8?B?Wk5XNHZteE5hU0tvb3kwRWlBTjBDWUJkSStaNnFhcEkveDVBU3ZkbzEwS0Vo?=
 =?utf-8?B?Z0NkM3labVJiUTBQVDBBb1UvSGU3L3EvSTVvdnJwUVlsb3BvMzJldmVtdU1M?=
 =?utf-8?B?ZFltQjRaZFVjOFRRY2lBL1JOcUoxcythWnJQK1FlR3VRNWsyTTBnUjZiS2RM?=
 =?utf-8?B?WGlJTlRhQzY0OVppT00yNk1xSVFLM3JxM1JhcGZwRkkzS0Z1SEF2QlpEbXBr?=
 =?utf-8?B?cmtNVGpFSXNCUGNOcEx1S1FYMitvWTBzTlJTSFlSYmk4ODRJUFduQmloOFdu?=
 =?utf-8?B?UXZFRDdlUWpDbzRxRVRrMjQrWGlUaGpoc0h0OFk0MS9uZWl2Y0tjeURyb3VR?=
 =?utf-8?B?RlZWZEppTlpYb0FhRGZ6MlZESFdobklYdEZvaWxDVWZadjhXY05rK1NEVENj?=
 =?utf-8?B?UGZxN01rZkNiZ2NoMkh1R1BmV3k3TTdvTzVKQ1VvOTRyQklJTzdaY0NDa25T?=
 =?utf-8?B?YVlyWlVtSlVwZ3ZYUzVoTVkzSS94bG45SUhwRmtsam1LY3lwUzVpUDJ0Rkdz?=
 =?utf-8?B?YTU1bXBZbjBBanVJV2F5UXpqdFZJVGZnckRtVmJWUjIyWDEwSExNU1Z3T0Rl?=
 =?utf-8?B?bmRxQWdkcWdFMmI3bDluSkhCSGhJOUNjNzNYMEM5NHdzK1FaVWVQejBzcEFB?=
 =?utf-8?B?MXpNVHBNYzFxSVNqYU05cS9zRDZHSUw3ZXg5TlJjMUVHWnNaaDZrSHF4eEJN?=
 =?utf-8?B?NjJUemE2MXJRWldIRTlBMVVNNGoybXFiTkZpRjV5MndoUHhWYXFnRHh1Yi9P?=
 =?utf-8?B?SWpvVFBCOFEzMjBRcW53ZkNtYmFLSmdQTEt1MjZNR1p3QmpsN2E3S1dwQWVx?=
 =?utf-8?B?Mk9wWXZ3d20zWDlZaHBpWWt3cVhtZkJoLzl6SGI5Rk5QMmJXbktvOXlCWWhu?=
 =?utf-8?B?SFdNUDErd0xJSkhnYTFNYkZ4cTFwN1V4empTTzN0dDFYNkVLQS9CejBZRld2?=
 =?utf-8?B?eXZaWDBJaHRid3NpRkNNcmxXVEp5YURyMUlLaTl6RHVWMkF1c2p2cUhHWEFz?=
 =?utf-8?B?L3htblRKemF5ZENET2prSHIzcVZuSDhaaytiSWRuVmcwbE5jSFNSUFJ3bnlN?=
 =?utf-8?B?NTBhS0hzUWFBaTBCMVhCcDZYNzlzT1hGSVppbDlFUW5iRWFoZU43NmN2Zm1y?=
 =?utf-8?B?RXV3TlZLendQcUtwUlRJclI3THF1b0NjTUY1b2ZTZ3RaR3dMajQzN2IvWUs1?=
 =?utf-8?B?RXBFR1NyZnhiMStDUFZJV2hDNFB2QWVPS2dpUSsveXlJUzhtdG05aGNDUDI4?=
 =?utf-8?B?cUZRUWtVdDdSdDJLNUlmVGhJdlhMaCszandmdXdSR1ZVbkx6cEJ3N1ZWUUkz?=
 =?utf-8?B?QmYzMUFNY0dBL1REL3J3RnBNWmNqbXJUckN6U1FuV0tsem5RTWwxUEdDaHRa?=
 =?utf-8?B?d1U3cjByRkxpU3NWZ3pwNG5JRUdEK0d3SWtLVVJ1MHZwM0xSUkJHTktzZGNp?=
 =?utf-8?B?S2szc0VLN29uOVZBM01Nc2hRYnFyWGZRRnZBbUtVenY2Y3B3L2RzcjE0eUNm?=
 =?utf-8?B?YUJJMHpJbEowSFZiODk0YVowMUFMa1I3SDltREtqanJ3bW5HcVBkVE9uSFZU?=
 =?utf-8?B?VUNlKzlXS0JRNmg1dUY4NlRHRWwyUGsxVjBYRkFScU1PNWE2N2F0KzByL21O?=
 =?utf-8?B?L0dRWEw0WE1OTGl1RTJaSkFweWhPbzZrK2E1RDZLclhPYjdVZXZUVTRUTkVt?=
 =?utf-8?B?eFgvRE5VbEZYZXhaazk3TjYzVlVpbjZqaXo5Q3ZzTEN4dXFjdnJtQnNwOExO?=
 =?utf-8?B?MHo2QnB0VTVEYkFkQkI4bGxBYnFUaFI2UmZneFRseEZQTFlTREl3a0wwNEdE?=
 =?utf-8?B?Yk5ETUpIWGhCNi8vRmxwUDhieDJ5VmNydmlsY2FVQmxzNmpOODJ0N0xpMGtt?=
 =?utf-8?Q?SobxorT8pKFhySFz1e9uXwk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a82835-17ae-4715-7887-08db16863010
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:42:59.3996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPrMWRJPrlvhqxfIwXqsNdx7W2hefbxz7sNvxtrcuxmi0xAYIflszfHZ/vUoqHSWlcx1Kl4nGP0SL20tRZ8ABJ7wQYR96nwnCoRas2niA34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Wed, 22 Feb 2023 16:00:30 +0100

> 
> On 20/02/2023 16.39, Alexander Lobakin wrote:
>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>> Date: Thu, 16 Feb 2023 17:46:53 +0100

[...]

>> Rx descriptors are located in the DMA coherent zone (allocated via
>> dma_alloc_coherent()), I am missing something? Because I was (I am) sure
>> CPU doesn't cache anything from it (and doesn't reorder reads/writes
>> from/to). I thought that's the point of coherent zones -- you may talk
>> to hardware without needing for syncing...
>>
> 
> That is a good point and you are (likely) right.
> 
> I do want to remind you that this is a "fixes" patch that dates back to
> v5.2.  This driver is from the very beginning coded to access descriptor
> this way via union igc_adv_rx_desc.  For a fixes patch, I'm not going to
> code up a new and more effecient way of accessing the descriptor memory.

Sure, not for fixes definitely. +

> 
> If you truely believe this matters for a 2.5 Gbit/s device, then someone
> (e.g you) can go through this driver and change this pattern in the code.

[...]

>>>>> +    [10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9
>>>>> "Reserved" by HW */
>>>>> +    [11].hash_type = PKT_HASH_TYPE_L2,
>>>>> +    [12].hash_type = PKT_HASH_TYPE_L2,
>>>>> +    [13].hash_type = PKT_HASH_TYPE_L2,
>>>>> +    [14].hash_type = PKT_HASH_TYPE_L2,
>>>>> +    [15].hash_type = PKT_HASH_TYPE_L2,
> 
> Changing these 10-15 to PKT_HASH_TYPE_NONE, which is zero.
> The ASM generated table is smaller code size with zero padded content.

Yeah, and _L2 is applicable only when there's actual hash (but it's
hashed by MAC addresses, for example). Sorry I didn't notice this :s

> 
>>>>
>>>> Why define those empty if you could do a bound check in the code
>>>> instead? E.g. `if (unlikely(bigger_than_9)) return PKT_HASH_TYPE_L2`.
>>>
>>> Having a branch for this is likely slower.  On godbolt I see that this
>>> generates suboptimal and larger code.
>>
>> But you have to verify HW output anyway, right? Or would like to rely on
>> that on some weird revision it won't spit BIT(69) on you?
>>
> 
> The table is constructed such that the lookup takes care of "verifying"
> the HW output.  Notice that software will bit mask the last 4 bits, thus
> the number will max be 15.  No matter what hardware outputs it is safe
> to do a lookup in the table.  IMHO it is a simple way to avoid an
> unnecessary verification branch and still be able to handle buggy/weird
> HW revs.

Ah, didn't notice the field is of 4 bits. Ack then.

[...]

Thanks,
Olek
