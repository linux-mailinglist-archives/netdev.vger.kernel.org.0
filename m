Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBA682B27
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjAaLIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjAaLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:08:04 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2813D4C;
        Tue, 31 Jan 2023 03:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675163282; x=1706699282;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XuTi+PyPf3jYo7hVXtszbZ8CZwXpO0f0PWjsYPo+YRE=;
  b=bfLTV/E6unS8PaUwMvIixzkakh9jOmylrWdgkPKZa226FkVL8zLjH1Zu
   eOXo6fL84U3VV2l6D/Jc4SGHUgHo117e6LrkRed/ANGXy0jE9yNUu5UoQ
   JD9rW2WyhNBGo1SkIyK41KqhMAiBSydVL9NHS9JitrOXLTkKgLjRMVNHj
   t81L1k0jkzFgppfdWYhTQiVC2V/kk7BIR/y8j5eO+layrkK4vBMwENGbv
   a+FiJ3kXG67R7+pEFYnwg5xR/4/RFrbVzgWLMv1A7NVIEQ8DIAIdi5Itu
   6VrzCGeSeTp69oJ4dwTd2udVRwlxfS6nzHeSKAQ/HTxrcaAtORnMzAnCO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="326472463"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="326472463"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 03:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="733064053"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="733064053"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2023 03:07:46 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 03:07:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 03:07:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 03:07:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcNPAJDpH4T301bxXYL8O7fqQY2b+qSMqDZXZkkaK7CxysRKq6AZ+SYkZM+bIURZirHIB7Tf3rB8C8nS7XNAhZCNx+ocTSjsgvh225sVdWAVayYVamdeT+5632mUvGcjBrT360z9Hz/pVEnF/aBEP0g+pyQpduK9M/aIEsWAatIY8dyJujNwA1qhqBclqNPLb1WlkeDeXnlHVZIIAq3kqddeEItdrbXhGeT58eQqXhVGZTiGQ6axKKhjwDwwRyDUwMfIuyWNOApvR3cTF2rcTYMzTtHD+380YI0ZHgHEPIvS+yT1v5fjXgVI/hulL4u7jHWlInCmstQha5Jl0hCkdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwHE7x9lGf5Yi80nnbhKVTL4NF6z/K3u64lztpGEshs=;
 b=Gv8qVNKs/Q2zi/7P22TVyhBgZc99DNe2ZalB5RDbQW83DTJj/ctTsqKy/Iqk1WNNesFiyKunNva1lZ7w5Y0QmdGCXbJzJh9WPb3c3vBczzQ4tEGlpvCV44iIzvaGu4KD2c5D9W3+X5th2j1ZLqixkOMwDGh+KGWy5Aa26OP7yKDOfEIV+vSebiXHSdY9jHkUZePvCw4f1MZv+fVc7ixY09J/F312aPPDsHPcfd32jKTejlu7MhVqn/oV4ZCNLVlZj7wKoW45IfiKk6c+jrvEhC7ojfiVy6wZ4PNjg2FZ8Fcz2XbS5V0+ve4kMobTN6QhjHl6xiQsr4jHNMDyIeo+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 11:07:43 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 11:07:42 +0000
Message-ID: <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com>
Date:   Tue, 31 Jan 2023 12:07:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <bpf@vger.kernel.org>, Jason Xing <kernelxing@tencent.com>
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <Y9fdRqHp7sVFYbr6@boxer>
 <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0655.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 393f53da-68cc-4056-0bf1-08db037b5f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1V76tSawTooSoQHdirrteFLkHqRpipg/0gJ2XZcZ0uJWcNwNYzvpxkwIjXouKCm20i5P4fO3r0BVV6dfzU8waA6+3TZrv77bXo5PZNhdH3lcamMRIb0xXyfwUx4arhlv2KxVjBptNeMrOvN7gWYnncoKYBRqsR9C7+eaO4jnvpFYnqtyMPVfoi3A2guWxfip2Wlr74BTPt5sx/759G07agGlWnpVOhKzKBVWJlFP7M33uhq/A+LDfNz43y658FVNiKbCa90Ul2e4M8HHCJm7gk+0ybPapfmt4v47uyJFqnnct+uXKqV+sSk1B2b40tY8+Lg5WUkmP1vrYzJAbtOTu2RvZlnbzrrlj2M/3DJiDxHvktwXjmiESgY+wMvBedcElOk0x1wX0Uulmg+Pk2HHYEvnV1of4sUD2osDYzu91ujfEZyqY7uwpYulu+6g0lI8UY9jHQCSABmmptg17+uuXQgy2nXOd3ikKhqbGHBdh1QIPntJLeDuVcJDPwv/ZC7eWCy57nXsOaikEjMhAh/aXn5tgpoEbgBZ8dVhs24c8ht7nX0XTREPoyskwyNwcJMm9wuBJ5wEFGYU5a+jFX5LgZR+vx0zB9fU43+neyIYIgPyI0ZNgwhypbT/P69Jyv/tfF1iZe1Aj/C1oCOv7VZlAW3Rz9ISjsfPO72/vsS15A7cyyu6gTMRlNMluVQvTZK1Li9DBUvPvQbcowGK+1wc+PCC47v4MJ3G02Vqtu60K7g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(31696002)(8936002)(31686004)(2906002)(38100700002)(8676002)(4326008)(6916009)(478600001)(36756003)(6486002)(186003)(6506007)(6666004)(53546011)(5660300002)(26005)(6512007)(2616005)(7416002)(86362001)(41300700001)(82960400001)(83380400001)(66476007)(66556008)(66946007)(316002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzFDdHFuL2dVWXlWaXd0dmlqZTdMNjcrVXFOd2V0UHZtbEwwendhRWVON2lR?=
 =?utf-8?B?dDg3K3I0bHBFOXhJcmxkeVVOSVErUkYvVXlyZXQvVTVDNkFnV0h6VlZsMzNK?=
 =?utf-8?B?Unp2SHcvMUd1UlRtUlJmWDF2TlBONDdjOW1icmVZZzZRcHBpZ1dxamplRk5R?=
 =?utf-8?B?RFA4UXJURElUeVJscEhCUXhkd1JmR2ZxMkhCY0hmVDcxWTdwdW1JSjhXV2lR?=
 =?utf-8?B?YXpDMkU1M2QxTWxjN00zWm40ekF6ak9lNGVqYnBGOUlEQTFQbWFvbXpXK3V0?=
 =?utf-8?B?N3JweW96alJvNkxwenRnd09KR2NlZjdUQWN4KysxelhRN1JRaFNJU09NTUtK?=
 =?utf-8?B?SDVJenR0OGxOY3pkWW82Wk44L3NRNkpVd3pTZGlteXJUb090S09iVCt6bFJH?=
 =?utf-8?B?bTV1R2Vud05QeXJKOUhIQWlpV0xHNVVjMXhPdzFpNzUzUlJxZmY1ekVQTElz?=
 =?utf-8?B?SjRaNUs4K0Nib1J6MjdiNitUTEJkQjZ0dmMvS3RmRitSRnkzWmJEN3lSSTh2?=
 =?utf-8?B?MWN5dGFlQjZpRnhndEoxdmdDZmhGUm10TjE4dkhXQlJrRm9KSGdaQ3VDRTB0?=
 =?utf-8?B?cnVORC8vM1B6MXhoMlJoTjIySzlwN2ROZ0NLTlUzSk5oZkp0M3pxWE9hZnla?=
 =?utf-8?B?M3FFclhYRERGL0ZPbXZkQTNCTzd2VGd6UXNWbUxoYUJxR1BHOXhKMzVvWVhK?=
 =?utf-8?B?dUNPQUNUc2M3ZEdnNWNpVjVPUjNINi84eXg0c0lXZ1pldmZFSlc3emFibmpP?=
 =?utf-8?B?ODYrZ2NtWW12L2F5WGx4Mlp5cm9yaVVYWk9tb09JUGxMcGFXU3VwS0U1dWcz?=
 =?utf-8?B?RkRzZGdWZ2gyM2VaQ3RiRjhUZ2ZSU3lyNDJIcEEwcXlEcUMvbGhCK056S1M1?=
 =?utf-8?B?M1laT01pRjNxM0JiV2lCL3lQV0pFVGhJMWVTazViSW5BSUFrYlhGazhhUWJo?=
 =?utf-8?B?UVM1Q2FKS3p1UFZPVmNuUFV2OUNUM3dEL0ZQYldiU3hlRGxqRVJhME9ZZU9L?=
 =?utf-8?B?NkpNSldKOVpkbXgrTnBKNk8xSkpYblFVTlF6S2owd2NEb01QcnF5Q0IvUHVv?=
 =?utf-8?B?Rm0vQ2pmVEN3bVc4dGUrYXIzVHlXeVJjakhLQ1ZsVitrdUR4UnJpQXc0Z04v?=
 =?utf-8?B?aVBCM3JraXlva1gxRm0rSUMwaFoyc2xCcEhTNjM5OW0rTEpCejdFK05uWGs3?=
 =?utf-8?B?aHhyZGFzdm1uMEFtSFdZeUdBTm1NVkhrV2FoQWZUWWFkdjA2eTFVeCsxTHla?=
 =?utf-8?B?d0FFRkxkL3ZrNVhwRUxlSFhiVTdsNUFoU29vT3B6QnQ5YTdqV2w1UlkxNTN4?=
 =?utf-8?B?a3ErQWpUMWpBYy9mSnpoZ2hFN0NCNlVHZGJqWWZOQ0h0QktBYWk4QjlZOC9n?=
 =?utf-8?B?M0VMUlZvZDFTTlNiWmdNVm4vWGxpdmVrV3JsNEtzZGRQU3JZU1VFTjUwVjQy?=
 =?utf-8?B?MHo4YXpGR09pekl5dUlIMXc3RnNKWitVT2N1bGZpV1BYTWkvQTRTcHNiQ3lI?=
 =?utf-8?B?Y2RSQW5zN3IrZitadVlLV0Z3ZUMvSjZkNjZTTkliMzlEOFg1akNudEE3b3p1?=
 =?utf-8?B?QTZyMFlqc1RUODR4dWZsUzNoUlp0bTlFK3JKT29KRURYaTlxcUxMeGdJbk1t?=
 =?utf-8?B?ZlNmSkJ1b0hQbnBmRDF4V29UdDJscmFYT1o0dytkYWFQOS9lVTB6N2FWVHhM?=
 =?utf-8?B?bDM4OFZoWnd4MEg1ajhrUTZMekpWTm5idCtXN09DbFhnRFhPTUhydGZvWms4?=
 =?utf-8?B?TEt6OVZwb0RpMVBuR20zeWpzVi9CQ3RieEo4WlpGSWVPa2h2ZWIwYnVWZVM4?=
 =?utf-8?B?b0R1U3NxT1lRT2RKSG5YMFR0T2RrVVFNUWFYT2VUbFZmSnNBMU1CWldySmRB?=
 =?utf-8?B?QVJ3YkJGNlpETEprTUVmRENSSXhxeGRzd1d5SC91U1cwSkZTNkRrRWxxTXBl?=
 =?utf-8?B?VzVSa1N2R1Fxa2NIcDJmSEZwQUltN2lTOGwyNVVnTGMwTldDR1VaOE92dEN2?=
 =?utf-8?B?ZE5hUmlocHJnemN1SnRlOUdMV0VaMkhFRjdJcUhWVlNoRmlSZ1I3alFFTUhX?=
 =?utf-8?B?YU4zQVhYbFhwWTlFUSsvTTJPNXBKKzJWUVlPdEc3RFpPRlUybDZNdElFQ1po?=
 =?utf-8?B?MHpKSjU5akVnQ2gvZU5QWkVNQTBWNFVtWG1CZGtkUm5PTld0ZVkwTFloSk5Y?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 393f53da-68cc-4056-0bf1-08db037b5f98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 11:07:42.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTX8AAKBAtAjC72pz4tY9ktYsbvpxkYqCfWuyzRS4ACLKOIehy1U9ABmHmVMP3PWxmUX53qR5wFxWSridqojmyLlOXYKX1vyc8H5YlkWcvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 31 Jan 2023 11:00:05 +0800

> On Mon, Jan 30, 2023 at 11:09 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
>>
>> On Fri, Jan 27, 2023 at 08:20:18PM +0800, Jason Xing wrote:
>>> From: Jason Xing <kernelxing@tencent.com>
>>>
>>> I encountered one case where I cannot increase the MTU size directly
>>> from 1500 to 2000 with XDP enabled if the server is equipped with
>>> IXGBE card, which happened on thousands of servers in production
>>> environment.
>>
> 
>> You said in this thread that you've done several tests - what were they?
> 
> Tests against XDP are running on the server side when MTU varies from
> 1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a

BTW, if ixgbe allows you to set MTU of 3050, it needs to be fixed. Intel
drivers at some point didn't include the second VLAN tag into account,
thus it was possible to trigger issues on Q-in-Q setups. AICS, not all
of them were fixed.

> few days.
> I choose the iperf tool to test the maximum throughput and observe the
> behavior when the machines are under greater pressure. Also, I use
> netperf to send different size packets to the server side with
> different modes (TCP_RR/_STREAM) applied.
[...]

Thanks,
Olek
