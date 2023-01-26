Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664F667D0B7
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjAZP47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjAZP45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:56:57 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8564741C;
        Thu, 26 Jan 2023 07:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674748614; x=1706284614;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I/nFjLzcMvYJ8V/A3quQsPPm9oFGgfVcTBd5j3l2oAU=;
  b=dtzH7mGiZUr008e0Hi1HJuEDUumW7ZJRCNEKhK7VYdAfVU9Ve86y/mjz
   Vrxci2QVu0BVcCJMJhOTOGvsuQC0d/PevmIAdSVLMJI+l2RXtY0gRQ5V1
   mVRQO8xMFRyt1Ga6jbfnkhQPL1a78V+3wgymr7vE31Kt7xbeVCkA2iOaw
   X4ZlNuWsC2yeb7tJQf/rQItZCoH/VM7g7s/Fnb/l6KC8JRzTTRU6/Qt5P
   q8x8Vt63WQQFy5ftzE0zonrgp5HyDRdHqBVpT2VuMLP1QVibfjbgEVzwR
   u5q/i+GqbnHE3V66oP/WHoXLKEhc9a/olr0zfSQ5Lx+0KI2IV/uD2IKKC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="389205010"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="389205010"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 07:56:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="908274865"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="908274865"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jan 2023 07:56:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 07:56:53 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 07:56:52 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 07:56:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 07:56:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CW36mEHkUGj5BX95SB3Sk0GqntyHgcU8jkvd0UaqoQsEBBJT3KvG0U5GsRJ2Mzk8Ik/Axg7QlOurGLujgbqUIzBDWdQT8AXUIWZMa7YXRIbJrJU6ZZs96h8LLKCflZk5B4an9o4I0VoViATLUem9m19CCAM7hnO1wmn1PjDUpHo0DLNlfCNY/Jsf1ZQ7aFbhVGhcD5zYOgc07HBuvTEyJY9UtinhZhKCwFPiOYzkD57HyzhWMvyFpqmlDzf2Zhype9PxTf9cld0rMT1tcv0R3JrJVafhIrVc/V4byAq8KWyRNzwZxpERR2Y5o3YOwSHeSmzFU2U9GgMD/enPq6WvEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2zgg7g9W15aOLqBN5VXr9QkM+tjvP8EysC69OCKMfY=;
 b=b9OW5tgxVJvszbye2GL10A4B9E0vj96FHCbDuFk6ZCmljTfpZSTxPtDJ5+BzJ3FApYV5B5BZ+g6JDWn6yTYclbrDK2lxGl2knfFL1fvZyqWRYKPJkiBcHGG8AtTgqxhB9bdzH2E7cg7gtrZhFajYXntc2YeyaIYOKNZQKoCUAnEjQ9eY38gjJ2El0LWEaQS9QGbcOPbcIs1eQCN94X+rnyxccKCh92ynvuvrmMbcja2HrX/p7aPPuwq6Fs1Ctb8GZqEFbzo1Y+acHM70iTVWhV8Kot0yeTgtzYTE0gcbsEg7J2DIbnEuGts1UjD1KZuChqSG0fMXFRMWBVDv777LZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SN7PR11MB6749.namprd11.prod.outlook.com (2603:10b6:806:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 15:56:35 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 15:56:35 +0000
Message-ID: <48639eb0-27d9-5754-0687-286e909ceff0@intel.com>
Date:   Thu, 26 Jan 2023 16:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] ixgbe: allow to increase MTU to some extent with XDP
 enalbed
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.co>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Jason Xing <kernelxing@tencent.com>,
        <magnus.karlsson@intel.com>, <tirthendu.sarkar@intel.com>
References: <20230121085521.9566-1-kerneljasonxing@gmail.com>
 <Y9JvUKBgBifiosOa@boxer>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <Y9JvUKBgBifiosOa@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SN7PR11MB6749:EE_
X-MS-Office365-Filtering-Correlation-Id: f1468c1f-7e4d-499b-2c78-08daffb5e6c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lB7lv32QmTCt1vvJ9h/Ff3XPeelxmxAmsnXFAvF2Ovw5lfJMDWAC5UIg2NIPjnLpCeJRHqeeOLpby8qPSa0FWvx1nhpKGpYrqcgpZYkX7/e4lfvl5+SMSuo25OcaMdBBDuZ/kJTmCCF83waU9+bK8JWdu1MZP81GrFd650ZMfN4ve05gl9mv8bGhB/60UGLAg4uOA5z3jTD2l2y2MnoLbNN8qb0D8tl/9npVn5Ch5wsqpV48LSU0JIoHZpsRyXNWALFOZPc1wlVbi9EL6dMx+qp5Kocc7D3H6+Ia0QoEV/GbVvs5SbWwvG4t4H0tQtobwv5TPWg5eBieTcXYU0t+j5yZ718F+SLDld1NVDjobmGhJm7hKyCRewE6aQkG6fy5Z1F4Et6E4rVAuMJR2ojSi+4LEEBSjFQhB3yem34t0cjbMyqFtASU/zynWQgOeGIb1zE1g8omoh5HjU3ExEj7QmAYiGiWc0YOyTKpFGSY+WxHosqqtvf5B/x7pvBg5nQ18eVV8OGzI2D+8sBy9VhzQkSBw9xNMgmwXJ4cSx9O1qx4ony2jCdFe/ZDzSxnh6/5K/8DG1Q0WU+uoV9IwV+2buDA9oci8VXJdlWy884CPfA7TAz+jDRcsU3i/rnD4PIwP6z1mdGFPHoUGAGel7RPJPw13/zMKe7hf/fnZZcCJRL4t9/kGs1hV10W+SHWFqp3I2fBT/jlNgzQNU1foWV0fS63tCbt18HfDlTohZ0lG6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(54906003)(66946007)(6666004)(107886003)(6506007)(6512007)(26005)(2906002)(2616005)(8936002)(8676002)(82960400001)(36756003)(316002)(31696002)(5660300002)(66556008)(41300700001)(38100700002)(83380400001)(86362001)(66476007)(7416002)(4326008)(6916009)(6486002)(478600001)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDgwbkFITmcxSThHZ2Q1MUNIeWVKdDlTOVM5MCtZckgrbGhLZythcWUyaDBW?=
 =?utf-8?B?VUxpSzFjakNOTjRPL2U1REN4Z290THJqbWVrL3R3OTR6TEp3UUxKRklwd1RB?=
 =?utf-8?B?MDF6ZUlia3dDaHFlWGVSSDJqUjcyNG9KNWRyR1Bub01vUVoyTFJFbExSVEpY?=
 =?utf-8?B?dnRIS1RRZW9sVWV1L29nZ25GODMxR1RodFMyWE13VFhCYTFMajZreDVCL251?=
 =?utf-8?B?aVluazllb3lmYjNzSHR1d0d6bWM5SHFKM3VGV0dRN0w5VjRkMWJyVFdtR1RT?=
 =?utf-8?B?bnM4OEt6QnhzbmFnTlpVYm4rdE9wMHg1MGRSRW9ldnN5ZjFFOGJabDBYOHMv?=
 =?utf-8?B?clFjNFBLVkRlUzJJUnBJOEg3alZwVDNnREJwRlRlNGlVUGh5Y1FJbVp5RFNC?=
 =?utf-8?B?RXpHV3d0ajcwTE9iSU9hN3A0aVQyc0lGR1NBSzY0SnYwbjJRNXhrYXpZWjNr?=
 =?utf-8?B?T1NmYVhTNUZjWVNtWjdNOStIUXU4NVBqeC9DdGxLVzdVd1ZrRUZiaU5nWTFi?=
 =?utf-8?B?Q3NReEtXRyt3OXZlWWZxVmpXTHBZYXo5ampOcHprckZIK3d6bE1OWjFCYjNE?=
 =?utf-8?B?TEpvcjgrWXJWQlpMOTlaVUtJRFZyOENpdmorSmZ1ZnUzRU15Y01nVXlYWkFJ?=
 =?utf-8?B?YkRMbEx4QmZtMm9DZlozSkMvWC83MXFWZ3Y5VGZ0OU14S3dvWTFXeUdwWWV1?=
 =?utf-8?B?Wm9LTzNrc29CeksrZUpaT0JCeisxRW52dklGdlkxQ3Vzc016L1ptWGdxd3Yr?=
 =?utf-8?B?UVhOZlFObEtQR1BGcjVzWDQ2QVV4NXpCL1dwYVRGMi9tV3pmTndFNHB0RmFs?=
 =?utf-8?B?VHNsd0ZoTWlGbUhnRTFDWmdlR0RXQ3BpT3J4MDNaWndPM1BtZDIvYUJXN3A5?=
 =?utf-8?B?SmpVY2kvVHZNVGJCM0NkMjFEcUVTK2pNRXdBVE02RkVzVkt6RUtZeTVyRzZY?=
 =?utf-8?B?bm9yTHJYMk1hM3o3U3F6ZUJMQWZzUVgxSzlYVzRmTG1GNjVTR1hCcXFLdlFM?=
 =?utf-8?B?SWZOYW1yVEZaTE01bkxsRUV5NUlWK1hTVVRYSHQrc2dBOTZTdXRpdndyeThL?=
 =?utf-8?B?R29mYk5SanZTTHhmckJTU1pQQUpJaHZlajNZbHNQUkt0NzZUb2pZZHdTYyth?=
 =?utf-8?B?TVhMRFE1SFFRTU84YVJEaURab29zQWduQzVyUkFlNTFOUGVNdVlub29rVTMw?=
 =?utf-8?B?WXNXRW03bC9yZ3NRVEtWcEh4OEdFL0Y0NGRZajZ0TjlGR1lTVGNKRHJyOEJZ?=
 =?utf-8?B?MlY5ZGwxU2lZSmI5OGRMWjBUY2dmbHM4ajNlY1NRZWJPVDZmZ1JwRE85YjBQ?=
 =?utf-8?B?eWJTOG1Mcno1OWtQMklHUW4wWXdJcWpCWWF2S29JaUR3WnVkck8rN01QWEhI?=
 =?utf-8?B?ZlFMdGNqaEZQbHRpeVo3enZRNXV2OHZXVjkvcnhaWU50SW9RaElEQzh5RGtn?=
 =?utf-8?B?SnhMOVlGaWFJa2l2aE9XVGMxRUVubG5CRFZlcW44UUttL0Z0TUQ0aCszZjM5?=
 =?utf-8?B?cVlmbFdKZFNqVzJVMHhxR3J3Znh3ditKRFpyTnkrak1IdGo1RGdzUGRsdnhD?=
 =?utf-8?B?czJGNDRYT2FqYkdraUZkanM2YUR6ZXk0aU0wSHhLcVZqcjdabDhvbFBCMzJq?=
 =?utf-8?B?L0VjZmRrRnlQN0djbXY1MzVsbEhFbVNlaGlFUGlwNWU0T09nS3RYTGRIcFRk?=
 =?utf-8?B?MzQzeGtCVXMwaEEwbG9uenNyWndrYWJMd0hxandYV3FBSUpVa2drWExFam1p?=
 =?utf-8?B?L3N5L0YyTUQvSWx3MlRUaVY4eExsaEdWTk56b2lJSUJHVThINXNCUXlvSmMr?=
 =?utf-8?B?bGpjTVZQYjJwNVZVNlF4RnRXdEN0TWFubC9CV0l0TldNV0IxZzJyMlRwaFBK?=
 =?utf-8?B?L0pEUkVLWGhTVWVtTEh5SWE2VjVJc1p5Wk83a2I3YnhsY05LeHlsK2pJUGpK?=
 =?utf-8?B?bkhKdUhYc0p0QkduV3BmQ1R0bUVkM1hqdTlXeHhPRXhKTFFjc1NTbldPRHIy?=
 =?utf-8?B?SkQvU3NWMS9DdTR1ajJOV1pRVkdMYm5DQmk2dGNwWEEwZ1d3aHlpeDBDTWI1?=
 =?utf-8?B?enlic0hqQ3BrMFNJaHg1R0lLZXFSTHRvLzZWMVRSOG05STM4djF0SlE5dGRK?=
 =?utf-8?B?a0xZWUR4a1dkeHo4SFVaT3ZWb25rbVNjZ3g0U2E4dGhvQnhmeVJiT2R3QnMz?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1468c1f-7e4d-499b-2c78-08daffb5e6c6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 15:56:35.5225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjGQFxDUHyBqCM55n/cAi0fJNJ517fviTNxVSU8uvYIZZhFju6NfjZNXB8YvCt+VCOINrbt+YnZQZ4VMUD+P2+UR9GdNoQ9p/NX8l3mOGg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6749
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Thu, 26 Jan 2023 13:17:20 +0100

> On Sat, Jan 21, 2023 at 04:55:21PM +0800, Jason Xing wrote:
>> From: Jason Xing <kernelxing@tencent.com>
>>
>> I encountered one case where I cannot increase the MTU size with XDP
>> enabled if the server is equipped with IXGBE card, which happened on
>> thousands of servers. I noticed it was prohibited from 2017[1] and
>> added size checks[2] if allowed soon after the previous patch.
>>
>> Interesting part goes like this:
>> 1) Changing MTU directly from 1500 (default value) to 2000 doesn't
>> work because the driver finds out that 'new_frame_size >
>> ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
>> 2) However, if we change MTU to 1501 then change from 1501 to 2000, it
>> does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
>> is converted to 1501, which later size check policy allows.
>>
>> The default MTU value for most servers is 1500 which cannot be adjusted
>> directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
>> 1536) if it loads XDP.
>>
>> After I do a quick study on the manner of i40E driver allowing two kinds
>> of buffer size (one is 2048 while another is 3072) to support XDP mode in
>> i40e_max_xdp_frame_size(), I believe the default MTU size is possibly not
>> satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
>> insert a new header, say, vxlan header. So setting the 3K-buffer flag
>> could solve the issue.
>>
>> [1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XDP")
>> [2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations with
>> XDP")
>>
>> Signed-off-by: Jason Xing <kernelxing@tencent.com>
>> ---
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> index ab8370c413f3..dc016582f91e 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> @@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
>>  		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
>>  		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
>>  			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
>> +
>> +		if (ixgbe_enabled_xdp_adapter(adapter))
>> +			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> 
> This will result with unnecessary overhead for 1500 MTU because you will
> be working on order-1 pages. Instead I would focus on fixing
> ixgbe_change_mtu() and stop relying on ixgbe_rx_bufsz() in there. You can
> check what we do on ice/i40e sides.
> 
> I'm not looking actively into ixgbe internals but I don't think that there
> is anything that stops us from using 3k buffers with XDP.

I think it uses the same logics as the rest of drivers: splits a 4k page
into two 2k buffers when MTU is <= 1536, otherwise uses order-1 pages
and uses 3k buffers.

OTOH ixgbe is not fully correct in terms how it calculates Rx headroom,
but the main problem is how it calculates the maximum MTU available when
XDP is on. Our usual MTU supported when XDP is on is 3046 bytes.
For MTU <= 1536, 2k buffers are used even for XDP, so the fix is not
correct. Maciej is right that i40e and ice do that way better and don't
have such issue.

> 
>>  #endif
>>  	}
>>  }
>> -- 
>> 2.37.3
>>

Thanks,
Olek
