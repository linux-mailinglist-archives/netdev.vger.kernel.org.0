Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A436D6464F8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiLGXWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLGXWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:22:53 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA45C5597
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670455366; x=1701991366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y/Yrxy0PC95dD12401Xc6NWnrgnrEFyO5jqg19rpjag=;
  b=YlPvGNexIOvHrdrQnEgx4VCGN5/NRvBJ5SorBLZamqHYAWj6QZuP/8Zb
   odYPxh6ABn9zbK/IfB6PH8blU6o3vD/lKJRuigVca/F3uo8aUAMH92wI/
   smSUDw486YIqJpzDDjcVfj83gySvu6wSlCauhatpfy2AxdNrIeh0S7gDz
   Hl3e7dj9inbYk+ysS9v/1oJ47oPpsOrGZqH0u41wFSsLe0tTZbeFAlQtI
   wuNtTi1/6OP3H2iv4CLWkc2CsBa2RxSGBR7CwIhgTyV43jGxccQM1Flsx
   OKqf+lrUix1gEyvYQkyNpUhhbeU9SJeRtKjKB9GPN06wk6IYBaYRuo1MP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344069118"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="344069118"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:22:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="821124912"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="821124912"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Dec 2022 15:22:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 15:22:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 15:22:44 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 15:22:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wun1UfnFdZGj2aCSUMGfUpIWtLC9J5wT/TWaPzvl1u0qiEfPu1BdRtqV1UnCoWmRZjHpu7dmXZ19eKuTfs1G0CSpwTEJuEpfb16gx/AwIaL12NpzMiFfvquLSnTzF3YBY0g1v8rN+kj0l8nA8IYOlZR8sau85JslMw2Gk7pTXsqxkUA9jatu+sFGh+MSbhppaRCyTDccLdlNJrOzGSbYDiv6adkffaYVKY7u3baYidBpVcldHoyMxJv/CPvjVfBoR5wjWOuGouFL0t4B3MMy03xIb/kEemgr/a/OxyzoNAg3XC6vikBrr+xchGIqjckVU0VAXcCIx+JLt3w1iPrXQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hg9SwqkdrAk4nLox4J+uTwMM/FAeN6Vi4mDy1uC/LBc=;
 b=coUakiEi5oXe/h6S+AnIKbCDUVO8OcfwXRCAEP8pfk/6tbHZipTMGWWhpbO80CzK+BkAvg3wvjvvbBLwmbPz7HOig/dTa/beb4BlxUJs+dNnMflu+6RC/8SWNji3Ng5nMYIIDuXHSvOvOCKfpqJCYq5kmTql8YvfRxtEPnw9+Su3bhlSt9LUBLwKKURLhTNjMOPxPHW7xusIwCfGJ5beb5Jb22e6S6Byd4MbTn8/yrsr03Jqv7zyCH5eMnPi+yMWWkbuZz5bcqjHob7netoH+x0D3wXCAiLcwqwS53pdGfai9cVkGS/cIQEGMZz8ptszaeWPwfiQDn5JC1VEMaY9Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB6937.namprd11.prod.outlook.com (2603:10b6:930:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:22:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:22:41 +0000
Message-ID: <a1e6619e-a2f5-ced7-c053-ab196fb0cf09@intel.com>
Date:   Wed, 7 Dec 2022 15:22:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-2-anthony.l.nguyen@intel.com> <Y5ERcnar+H+xtYYC@x130>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5ERcnar+H+xtYYC@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY8PR11MB6937:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a30eef2-d866-4069-73ee-08dad8a9f015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9bMIaOgWHE1jO+9pPKf+SGO4JI8baUB457dWUOV+u7VWLXbDOnHbzBrWKbBXeI7OuxJdpUPXLMJM7c7Ah5EuRgHqeAMuDpn2c+CLNMZI9FN0hNhXjxiTvIFth3HbaHzoQ0d6xLHL1i0UwvkPhgwjBLCzf7ci4IKkXgaaozmUNmjPah5xQEl1jxvzxGOfU+xXf/JAT92QwKrwS2Cezvlzc9/ykEgnUlu9TKPFuWblnK4dBqZTnQ/PhzCtxTo0vbnBfLcjQ2KyLPkB0GeHF7uunZITJ/hEoQ0IDbKYrn4zGEV4KLfeXrTq560EePXeALl56xg9fh6uAjXYBAXCU/A1YqrKCegOhOJBmK686DUzjap0c8iMynleVNoOrWcs3ddy/pIXHX05mZgihTH9JkAcwRrJnJm/zyZH3pK/aXqEuPrTeYiVpjIh3VWrcaUTjWx0P0bB7UaRr3xnWVLLgUQ2Wl9jpNF321NfjNECJh1yxhEPHFhoqadqYMRMstiZDklMpSBq6n3vV6qBCfU1hQb7uMAosTRIi+mwwEMwO2k7Dd+W/8L36+S5rBAVZnYopyZ5R3GBQoYMptbxi/g/oVB1ouT2XqDZx5AdYqxDbnEMDKiN0rsQS4aekPSHxS+eszwx4JIX7E92YWc076VDTIQYbZrmzgC3MjCGVJVgrhCqEcr3ECLQI8uNgsQ3EGqASw6GhLIQhKRFBOR0F5mOJuBqzMK2Fze5AzbwnrXs2ly9hk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(83380400001)(8676002)(6486002)(66556008)(86362001)(31696002)(38100700002)(5660300002)(2906002)(66476007)(41300700001)(4326008)(82960400001)(8936002)(107886003)(6512007)(6506007)(6666004)(186003)(53546011)(26005)(316002)(2616005)(110136005)(54906003)(6636002)(66946007)(478600001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWdpZlMwU2dCaHgyc1RjY2ZYemJQVkpkb1FSbFBDd0cwOVJoa0FOSElVMXQy?=
 =?utf-8?B?WWVFdWlKdmxlejhnNm1XaTl1V0cwUEN0TUpReTA4R2h2UWVBSDBnYWowdjZP?=
 =?utf-8?B?b2hhb29oNEhZbFEydi9pLzVDUmpMY1lFbUJhUWNOOCsvMC9iTjU2U21EL3dW?=
 =?utf-8?B?Zm55MTNCUXA5UkdtOHBhTEczOHFmbnJCVEdQeGd0UWRLeDRJYXlrV1lxdndu?=
 =?utf-8?B?Q0tYWms5TXZkZHZ4NjVjRUZ3dy9uVEoyUm1TWnRrcW1McVhOS1JRNjE5cUlh?=
 =?utf-8?B?bTdoTVR1MmlvK0JYejJzM0taVWl3MWkwQ2F0bkhTTXprZDN3SG1iVFZoYll3?=
 =?utf-8?B?aWdVa1B5VUVveGhqaFJjYmc5Z3p6RWhWVHlvb1RwUWNFNVozV2dRRG9qU3o0?=
 =?utf-8?B?cXZnY0t3eUNoZHBGVkxST3Y2Z1U1ZHI2aHl2b3JzRlc0SGFYNFdKV2dMc0M2?=
 =?utf-8?B?ME5DOE5pR0xxaUE2QllpYXR6dG5aaVhvbWc1Y1RzRjhyek9xMWpZSXgxdnVL?=
 =?utf-8?B?V2RpL1pOYTAycTR1cUdmb1VSSUtBb2V1MlhiU05PUFdKUXZ3Q2lpOE0yMlR1?=
 =?utf-8?B?RmNCL0RLYmszcDBJaFpZMFlsMGNPZ0NUaDJYdTBpRmtmWUcydkVVYTNxQnFy?=
 =?utf-8?B?QUZ4ZUFSR3pBOEhPUnE1aG5DMHJZRVFoYkMzcFFNMytMRTZnbnFLSWR4ZGJ0?=
 =?utf-8?B?aG16WWVWOEtUQ1pBd05EdmdKcmg4VCtMYWs3RjJHV2g1aEUxeDhmLzVLbloy?=
 =?utf-8?B?OTdoMnlVdjkvemJpblFzVkpUb1M4bUNkUGk5VDFQWko3R25mRytldnFEcndw?=
 =?utf-8?B?S2hMYnBuN2h3R3BmM2Fpd0VNaXVhMlRseDFjaEIzeE4zaisyWEdneTVLZDV6?=
 =?utf-8?B?NHdtdkdVRVdFYzNSM3RhMmhUR2ZabjZkU21Qb3ljZTVFOTAvalc0YnQ4Qkp4?=
 =?utf-8?B?c1drSlFsdEt3UWR3VE03b2FMWjFkOEVldENQVGw2d3J4R25yMk90dWZiMTJo?=
 =?utf-8?B?V3k0clN3SmlGTlhwMWd3a2pPY3hvNFlsSjF0a3RhaXRjUUhnT2N3NEQzWXZs?=
 =?utf-8?B?VDNVU3ZRV1BzbERpTktwUkpyTi9JbnNBUmdNR21ObjdYR0xqMmFWWWlyNDNC?=
 =?utf-8?B?U2x3RXVwN3cvbHJBajkvNTQ0MjFWYVJuczNObVdReWEvRmg2TGYrMFJlSkFK?=
 =?utf-8?B?OTdHMGRNYW1mdzgrWDAvOUFnU3c3ZlJZTjVVYkVicnFTMmlqeXFNVGZ3dU10?=
 =?utf-8?B?VU5Od1lMM3Y2YW5JR3NYQ09KZ1FaaGFsRkY5R0JZVk1yMG5sVzJ0bDRPeVc0?=
 =?utf-8?B?blowN1hmSWJKQ3Bpc3ZFZkZiVXA2ZXZrY2RoVjBXL0J5T3BsT292YjlnMlI1?=
 =?utf-8?B?bjVCTW12VG1ia1lYMC85aGZadjBXSlF4ZXUvSzI4VXNpalFrUXYreHFPS2Qz?=
 =?utf-8?B?Nk5iZWkrcmFhblhnN2V6Q0g5SnBDQktYcG5qbEI5UHZONGxmVC8yZ2RXQmNF?=
 =?utf-8?B?MGZuZktneHRMUnRLYm56UTVMVTZCS2lSYm5EK1pRRVlBbkNWWjVQb1daZEdo?=
 =?utf-8?B?dGtWLzBtaW9QcGFQLzhFZGlGdS9wcU54RVlPbjRiZk5zTTE3ODd4M3NCaGZk?=
 =?utf-8?B?SVJxa254TmRlZk1jMlBtb3RsYVJSL0s0aEdoSzJueGliek5LaTJBalE3SG9H?=
 =?utf-8?B?aFVGbDJuOVdEMEYwbERNYzQvUVVoMFpIUloxd3U0NnUxRlNPTFpEeUtUMmpP?=
 =?utf-8?B?cWJoRVYzWDRUNndISWdSUWZ1M0lDUzA3c0hXcUlsc2RYREFSNksrMTVmMGVN?=
 =?utf-8?B?MmVLaFdNbkxiNGtBUVlKalphbzNEaDZyOEU2U1E1VUo0MFNRbnNZR25xWFBn?=
 =?utf-8?B?MlcxWmZsWjJHR0FvUW9UUFpSSjA1dU9uMUREQU9CblNleEFvbTd1T2J4VU9V?=
 =?utf-8?B?aHJRZ1MxeVhEZ1ZUVkwzMTNDSENvbDdJR2RnZDlhaEg2c3NwUmx5SS9CaDJk?=
 =?utf-8?B?T0ZQZldkeW9nVzUxSnVMcUo5SHU0dWkvL0RiRTkvZEYwSVpSZWV2Q3JsUnI2?=
 =?utf-8?B?aUNTdWNCdlJLRVg3cUNJZG9ZWmZXZWVwNk9wTmNUWmhiSnNmV2NtbkFRcjlQ?=
 =?utf-8?B?ZmVnaldhdDdOdmVlMUxEYVg2eVRqd3VOdURZcS9QY0doaEE3R2JoSjQ3U25W?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a30eef2-d866-4069-73ee-08dad8a9f015
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:22:41.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVWeB33JtU8Am8VGVQu49sRG2ZsIdHfuZc0wmAG7xOmiAzfG69rocm+EvwJYXflE4cZQ+afbDx5kbr6szGOJeli5g6cI/qLNr4Ycvj26MrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6937
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 2:19 PM, Saeed Mahameed wrote:
> On 07 Dec 13:10, Tony Nguyen wrote:
>> From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
>>
>> ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
>> the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
>> sends messages to AQ and waits for responses. This causes
>> ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
>> causes problems with the reading of the incoming signal timestamps,
>> which disrupts a 100 Hz signal.
>>
> 
> Sounds like an optimization rather than a bug fix, unless you explain what
> the symptoms are and how critical this patch is.

I'm not the original author, but I think Anatolii is out right now. I'll 
try to explain for him.

The problem is that extts must execute to read the timestamp value from 
the incoming signal. It has to complete before the next level change. 
Otherwise I believe if we don't read it in time the next level change 
will be ignored.

For a 100Hz signal, this means it has to process within 10 milliseconds. 
Kworkers can only execute one task at a time. If the periodic work is 
already blocking and currently processing an AdminQ message it might go 
to sleep for a while until it can process the message. Even if the task 
goes to sleep, the other kthread item cannot execute on the same 
kworker. This can potentially result in a delay long enough to prevent 
the external timestamp work function from reading the external timestamp 
within the time limit. I believe this results in missed external 
timestamp events. I am not certain if this loss is permanent or only 
transient.

I would consider that a bug, because it results in loss of 
functionality, not just something like lower CPU usage.

> 
> code LGTM, although i find it wasteful to create a kthread per device event
> type, but i can't think of a better way.
> 

Right. I can't think of another good way either. I think we can't 
process this directly in the interrupt which is why we had processed it 
in a kthread item to begin with.

Thanks,
Jake
