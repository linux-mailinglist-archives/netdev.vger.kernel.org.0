Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E2C6A9855
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCCN2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCCN17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:27:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824189EE1;
        Fri,  3 Mar 2023 05:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677850078; x=1709386078;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UwjLForLoQjIqayoPcbZGxkUvM1P6LsLMUjRkLlYUVk=;
  b=aufRDScvOiUo6J7a88XYDEuf1eq1KGFTx2PSM2AEaUThVPx/lRJoMTSz
   bKkW5aaUSB8VhqAeB0K0wb+fZywUBaj88Qow5cJYN6AOTBcVaEkS2H88q
   OHw+JfuOksewg4WnUHURp4XND/skNajZWvDueDwJ+X5eb0gm+FgG0xH45
   gugt8etEyVBPdU8HHIzzB1aVsO2qXixjQ+QCMYp7pfLS/4mBwExv1dhIX
   nT8hNDb0wiuB6Y8j0akzSGJrv3rG5Ug/KvbIheuvWgvC4wOkowuD0V5JN
   WQJNDLfFQX7Yh9DFYV4s8IY4fIgrTI/DbdGU9Jwyeb0qlc+1nG9xxZzkC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="318863689"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="318863689"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 05:27:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="764421474"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="764421474"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2023 05:27:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 05:27:56 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 05:27:56 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 05:27:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2xiWtUc1KyqDBhb3lfZPIEMwuI0fmZhm+6QJTy+Q7uuL1Uk9ag9FbQRP9CbT3E1dRBwfZNRPpI2LYQjAKXCk05nenDhRmC+u5jtXTsZjlgR39SO5joW5vIhqPYWVgGCw8xQAkGU2++EK7f9oXjoHG+mhAViX8/4/9Sdq71yu10bIZaA9+tNRZC2DfHTso+sjoIWTZ/WmByJ9IYA9wERioWDVJcejiAh8zV98h7xr22tpf9/aA9EU2fQicn+BZQVgkHBbcg3wcXFow9cQ27dj+pf/pJnDhKHM2ZHE7n8PJJhByhaty8I3QTXQo2C8fPN9YvKTL1iV/JgPaWeMZzsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVRDBIF6A/9YrbS6jAQ14WvEMJB8Jycq49OOujweIfY=;
 b=QUS2IBuO+1gY4zH0miY8sZ2DvFwp7gC+CH/5OtcjF+veu3hkV6y0yae1R3dsOUdyp2mfc0PAYE604apYHwIdhWtm8nBOoeVqepQRV2Fvg8iI8MpU0f4q4Kw9lAhoME8yUYNEd7sgU0UpITAEWeFenGsmcJ31mR8DMcMqajH7u+3rxwN/UAJgVmi4a9Xi8RD7YPKG+j8I3ZA5S2H6kRWVLk+bUAcgeL69b/Aj/1w3xeW2ZKqnIjjWTkb4cRH8MqzYi+gwR4iYSwGv6AcLpAzqh6zA7ZsN0PEKyXZ2HzT3o/fEe/gFMDFr6Kz/cac0r6IBC/9L2dcsYw93SmAhrInW7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY8PR11MB7924.namprd11.prod.outlook.com (2603:10b6:930:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 13:27:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 13:27:54 +0000
Message-ID: <9b5b88da-0d2d-d3f3-6ee1-7e4afc2e329a@intel.com>
Date:   Fri, 3 Mar 2023 14:26:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
 <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
 <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY8PR11MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 353caafd-07fe-473c-c921-08db1beb17ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRuSxVNx9u/NV3TDaUBEN3MzFkviBD6dtcAjKv6ZsLhIz1vxFcgiexElwW8GOy8UJDr0NNy5WdTsuYiTxI/H0g9DQPC23bvLLA6Yb3A9HLaO2z5EoDbslJH8fGsCyD4fsRKVbDp3EcsQW0w+355/WH1cjVOSC+QogX9dLZRAsUq8BjxNsLOV3M052SdJkQlJ8SSPALWzS1SswFUWlC3jUiuMVtTFu1UkEK56DgMc/SJ5Rx2+72S1bjICcK4AkSgJANc+E136e8EDKoSafuqtL/5t8IjLqJXGxhvCnEDFlXDiMmYmNKIGxSKCxgB9F6uKEKJ7VyCjPbdP1wz7agnMkO5XhMkNiwyw2pquIMiVj2XOltgqLV+UNOw0SkQ+7l0AyFDIyXEWmKyWQlujUoK2+KY+YIpoTQ+Lg2+eeadRj5RfBgi9GkZUdZJeb54V7ScLJf1X7TS8QM+OIYk6ODe9+YjINrha3b3iadzMYfn/fSH8Zvw6Akjk5K9zuTIF33M+lAirCvFNMUhjJlL3/KKIb5QVmWxtSfLZ3RyokFKLCMYh/bbaWIUe2CvzznF1cCu9JrvanWXJM1bL6fHvcs3P/EVBgJrPWLdQMeiEjXidTu0nZxJAYPQS6G56Iy9TAlJMmyy5JD34/6ub+fmRG8Yr96q5vnD3euIL0qZ7fShJ1nt9Q7I8fItHmq/KIf4/BvP6brQ5PKV7BCAkJDEb/v0cjy7r21CFBvg/vierLqeHAwVOLykpCKl0iwxUqkBmuuPW2lLsftFgMJoQKQVinmI7mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(31686004)(36756003)(38100700002)(7416002)(478600001)(5660300002)(8936002)(82960400001)(86362001)(66556008)(31696002)(26005)(186003)(2616005)(6506007)(53546011)(6916009)(966005)(6512007)(6486002)(8676002)(66476007)(2906002)(66946007)(54906003)(41300700001)(4326008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUJQdGR3LzlMajlnSGIza2xGNGFOYzV6UFNRRkxWeUVHRlp3T3NEblpydWRJ?=
 =?utf-8?B?ZEx4WVVkVTV2ck1HNnN3Kzc3SXhlUkNJakxHRjRkb04yZTB1aUtvMmJTYVJR?=
 =?utf-8?B?VWlheEEzSE96K2dTVTYrNEJVaWVOQW5ZdXBxYW9NTlVLR211TGFFZ3BYSzh0?=
 =?utf-8?B?eVBRTkZDT1RoYXJqWHdIYm5kSGhWRWF3L01BWit4M0RSY09OUEQvb3J5ZzEz?=
 =?utf-8?B?YW8rQVI3Q2IweFk1aUh4QWRWZnZxT1Y5WmlBSjRCbW1sMWRxcy95dlNYTS92?=
 =?utf-8?B?L0FqS0dsTjZCMmtVd3p2dFBKSUUvelY5WkRUZFdWTklXVnU1OURpTnNhQUdM?=
 =?utf-8?B?QzdteTZHZUZkUEtodXNkb1RuRkExTHBJSkdzZ2k4MENsRGFDeWFHcEhLUi9J?=
 =?utf-8?B?dzRwamZGVzcyNEdMS0szN1Jyd0NCcDEzazRsNlViRlZ3L0NoS0N0bzMwcGQ1?=
 =?utf-8?B?Y055RjZDRU0xRUt2RHJIeEpEMDYzTkdQcy9MUzkwME1TVDdZeFh6dzhFY202?=
 =?utf-8?B?YXdXd01jRjlXaWxwVVllVmYzckdrT29XWnRVMWN4SkFzWmh0cmdzRFpTdEkx?=
 =?utf-8?B?OFMyZUdwanVRTWswQTU3UHpkT0NMOWR6UzRHUzBoL3lqK1lKdnFjZ1hHMitV?=
 =?utf-8?B?VmNRdWgxd2FWckFhWjFpNkdBWG5TcjVQVEV1bnFrUUpBbS9HYU05QURMQzRY?=
 =?utf-8?B?Kzl4aWJFNlNZM0d2NSsrb1YwRElNSE1nNEtlK1ovY2VoeVBpYWUrY3JUR2F2?=
 =?utf-8?B?R3hkSDc3QlIrUGJRTnRjaUU4RDdDajZwUXhQWm53VFpicS9XZ3hFbm9lT3Nt?=
 =?utf-8?B?bnJ4SkF6S05SRjdUenRvZDlzL0JEZEFYc2Y1TUdiSjNUVExWY0tBVlJmY0hq?=
 =?utf-8?B?Smk2UkNnRW10dkM1NkFiZE1tcjJLYVpIRnBzd1ZQb3AwWUVDY29jSzVvSTAv?=
 =?utf-8?B?RDNJUG5rdEF0YjE2QnUvQ0Jjamp6QVB2Ri9FbmRNTmtlUWhNVVdTaXdzVUNu?=
 =?utf-8?B?Wm5oUktVUFhrUkZyempubXdnTDlwb2N0d3I0Q25FV3ZiYlJmS1ZSMjRnRFYw?=
 =?utf-8?B?OVNmd1QrVUFSbkJkUm5jOHIvUDB0ZlJ4dW5UcXFjNkEwa0pGUzYzblZFWTVN?=
 =?utf-8?B?SEhUbi8xK3RaWE9KUXd3cEdKMlovTnVJaStBT3JENkFSRlE5bHpkVDMvaEJ4?=
 =?utf-8?B?TUxYTGd4WnBDU3VKdjVHT3B1OUcycE9yQ1ZqRkZYQURRSnRNdHlWYW16QTVR?=
 =?utf-8?B?NUg1S1h1QnFEdlNVdXBBeW1KMFhjb25NTURTcytWa0IxNFZRU3ZNaVVPS0Jx?=
 =?utf-8?B?VlpWQk1FUWJaa3E3OURWU1JtQ1FCM2JBME53MzZFVzFsM0lTaVdyeUpmcWZm?=
 =?utf-8?B?NmhYdlJ6aU9yREh4VDc2SEorbjNleDQ3cWxTYytlOVBoS3gySFhFOUZkcU1B?=
 =?utf-8?B?d0tNTVZqbVpWanRUaU1sTFBDVXNQaXllTk9RRXhXclFZTmJuT3M5UTA1UFJq?=
 =?utf-8?B?ZWdwaVN3Mjhyc1p6QkNFWlpESjBmV1pubzdaMGszZ1JKSXdXeHRSbEN0dVF5?=
 =?utf-8?B?RlFoL0w3QWl4SnVGMXVNcW5yRUk4RDdVc3NBb0xyMERwVUJDa2NHSEFFYzh4?=
 =?utf-8?B?SUxXQWF0VlZ6djg3dWQ4TzBhMG9hbENDU1pZZ0JKRkcraG1VczNlVWtHcXpZ?=
 =?utf-8?B?VXdCbVl6Z05ldDlBK2RTSHFxeUdTQSttMlQxV1BEOXlxWDFyMHVKRmUzdFhy?=
 =?utf-8?B?UXc3NXdNcnFESEEwcWM5QmxmYlJMWjlnWms3aVd2ekNtaXF5Q3lLMy95ZTI5?=
 =?utf-8?B?OTlDK2M4WVJrUlY1K2dMbzNNcW1qQWlTVHRDTjB2blNzdlV2TEdXMG9JUm1V?=
 =?utf-8?B?ZUdjUWlKSFhnOUJ2MnQ1SWlBVm9RT1Q4TUZhUkxwaTREN3RPNWRGdFNSWUlF?=
 =?utf-8?B?SDQzRklYaDl0ZkQ3eGJ1RndUaGZkZUJKN2J5MDdoa2pTZGd4OXlTZ0ZJNWV3?=
 =?utf-8?B?cTNMVmlVQzlZbzJEam1pckkvR25CVm5FZHdlSUExTlJlMXRIdnhLc2oxcW1n?=
 =?utf-8?B?Mm83NTlrNnZ5Ui9oazVFSk1UZHNnbWpsSzhUbEtBbnFjZGV2V2orTDBwMXdo?=
 =?utf-8?B?YVF0VTJZRnVDS3AvQks5MmZJS3dlNVl3cFZBWWZtRGd1YjVicExtYldZQThl?=
 =?utf-8?Q?SbkApd476/gKX44aVkEk1iM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 353caafd-07fe-473c-c921-08db1beb17ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 13:27:54.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gd3YGfJOOsyeNEtzCxlccPjFP25LJmYyw62fbFeI28d7u/Es5j/xoSYYyyK15pSMh1XlIl+sOZItmWsD8GuPBjWqBeFfHWonBfyLyvYvtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7924
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Fri, 3 Mar 2023 20:44:24 +0800

> On 2023/3/3 19:22, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Thu, 2 Mar 2023 10:30:13 +0800

[...]

>> And they are fixed :D
>> No drivers currently which use Page Pool mix PP pages with non-PP. And
> 
> The wireless adapter which use Page Pool *does* mix PP pages with
> non-PP, see below discussion:
> 
> https://lore.kernel.org/netdev/156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com/

Ah right, I remember that (also was fixed).
Not that I think it is correct to mix them -- for my PoV, a driver
shoule either give *all* its Rx buffers as PP-backed or not use PP at all.

[...]

>> As Jesper already pointed out, not having a quick way to check whether
>> we have to check ::pp_magic at all can decrease performance. So it's
>> rather a shortcut.
> 
> When we are freeing a page by updating the _refcount, I think
> we are already touching the cache of ::pp_magic.

But no page freeing happens before checking for skb->pp_recycle, neither
in skb_pp_recycle() (skb_free_head() etc.)[0] nor in skb_frag_unref()[1].

> 
> Anyway, I am not sure checking ::pp_magic is correct when a
> page will be passing between different subsystem and back to
> the network stack eventually, checking ::pp_magic may not be
> correct if this happens.
> 
> Another way is to use the bottom two bits in bv_page, see:
> https://www.spinics.net/lists/netdev/msg874099.html
> 
>>
>>>
>>>>  
>>>>  	/* Allow SKB to reuse area used by xdp_frame */
>>>>  	xdp_scrub_frame(xdpf);
>>>>
>>
>> Thanks,
>> Olek
>> .
>>

[0] https://elixir.bootlin.com/linux/latest/source/net/core/skbuff.c#L808
[1]
https://elixir.bootlin.com/linux/latest/source/include/linux/skbuff.h#L3385

Thanks,
Olek
