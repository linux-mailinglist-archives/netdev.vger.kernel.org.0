Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0A63B499
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiK1WH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiK1WH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:07:56 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFDD11459;
        Mon, 28 Nov 2022 14:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669673275; x=1701209275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ygRoIDuIHvZFApg2Vvr65Laa0jpYdcfgaEMPqPWlBMI=;
  b=Q3cDeQrV+hh0cGVZizYkW4XA9Ss2tTaKjB/nupgAYeW0n7ghavO6cu0e
   vgptxahoXdssn+fnE52I30Vgur920HeXSzHdUeOqaZ03FI5ZJN8txm2vA
   ubpRoQHvhJNFYumw/vChO5QMOtcbZvOcE0fjNrE+P317hx8qXkHVHh9NE
   IdWL0g5kEHqiZrVOgRhq/RjDQzo8rooBMjKUJkrnpWKYmnsQY2SNNoH6T
   CjeJmLqJxd7azEpWdvlCDUeGR7UP13Lpav/4Br4DYIw+JFEXdvnrUWC6t
   Zq0S3b54NPKWF2pquAfADGMVkn8z4rY2NfFbZsB+EvwjNc8SAK9fb8VsT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341875252"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="341875252"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:07:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888599243"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888599243"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 14:07:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:07:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:07:53 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:07:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWXhJdUWc6aSKsFFFHPYrHnNnSDTHAy7sGwZ4k9kmdOsaqMloe+b3fBmRcd5HtnuLZgJ5FCR01UZ1frxJl5snKTlbcpnQUVPyX6Uj9QaMbAzDt8blFm48dh/7qNyLkHxkyCKwnaH9jVDB3R5s6YQAX4d0lioR2QmoUtVka3hZLo1c+5dtqnli8qSnSmGRkBx5EjlgaXm4C6MSsiEsFKnSfMPtermMmO5nIOodiLtdMjXgvUC+XDNB0aufKVlxc2uMRl3M93//u5Q39CTtkJkyCEnd81gGSHREZ//he4F4mjTA6Aq6J/5q+5cM2Jq274MxTE/YPpSO4mJ3yeUY8Sr+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+My0ii7tkg/WOsYOiKFs8fr7yyVvyDiIzM9+cEU+No=;
 b=iTgk6sQ2DDvqGd6kcPa6Hadd7wkhfSm65MPNnaT7x8eNzeK4BKz/GIYIfAx6HRikvxtBf37OISi8969nJgexhQI3QyNonucRARrNIELk7wWy1fxIqnFKOwc5W8gO1bXsFbqukpxykma/XcriIUcbWsVTtSQLmzRrCB7j19K3NTCcgqS7mAM/mxY71XGGkDn4thKxQuGc0DicondWf6GoDB86MUALDvs/0vf4KA7VfoQ6pUE3vCdwaDjDQrnZz1DdP34eJdHfNOIXGYmmRiyQPd3m28hcqUUt3GFrP4FcvPbo1myolMqqeFzLHyBFy/VfZhTw/Idx9WoPPyQFDGcKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW3PR11MB4588.namprd11.prod.outlook.com (2603:10b6:303:54::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 22:07:50 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:07:50 +0000
Message-ID: <80e17b57-6d76-d72a-f8c9-fc0e20a994e5@intel.com>
Date:   Mon, 28 Nov 2022 14:07:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] igbvf: Regard vf reset nack as success
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
References: <20221122152630.76190-1-akihiko.odaki@daynix.com>
 <Y3z3Y5kpz2EgN3uq@boxer> <f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:334::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MW3PR11MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0fa63e-4fab-4664-8e74-08dad18cfd77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ProB2NstBaD96lPH5I59gz/xp+si5BpWjmG3Rw1Fh/3NfCsO2gzQL1chfdjJHZo1iys4piT7NT4NfKO9XJKp0t6BbqRK9qVauZV2s070rBrBOGEZ91sxT6Ci1fMXqLp3FTiK+0w3RDy+WHXNDE0EBvLC8vA7ru4a3TqgSngJuud7IDwPASlZsaPNYbHg5w6ExurLz1BsYU08ijYcz+prEJTENqJhvnOhRuPVh84dRCA6rbV1MNNAL0fRohO4zAxjxV2PTyQIZ9k9ZZma4pqX4QJB9p26nTq112zeN9/ZyXswV0wnr74Jy/85moES8QtAjkutyIY2n1V2PZLAD1ei9uDvku8qUXE40z2DvoWnSqO5SyEC+NbS5nnf0LW3HkDAya242IOtKtbZrDJifc15+ctrqm8qZ1VNQoYvYVLM3eMcyYtG1hmWrJfbl0aXLrKj9UiH0UqjQqN6CWkMzca4Ak+bb6gX8/Gk+HBu1YJS5UtvysaNogq5j98abCycLSKDa45DO1iO8RchNUXGHSAMR7XW0Ob1bPbDNWMVfLa4QOypLNOc/uY8QlcymCc3XEoAA/3U6ovFup8SCaS1sNQ3gFhoJcF+gnWdLeXG3ttO0SDbmBmTOnZlkMj3xsbWHqVyDJSSQbiIT4vpaW+bApPUaA77Yb/1KVHojUnMNx9BkDphbhVR0QPphNZQ5W1DT0HVLLnnPFSq/zK4WocL9BTHWA7oEXI7SyEaqxuJZwBIHtKByA9SHEwQHp7y4mR+pFu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(2616005)(31686004)(2906002)(83380400001)(82960400001)(26005)(38100700002)(966005)(66476007)(8676002)(66946007)(66556008)(41300700001)(53546011)(36756003)(6486002)(6506007)(478600001)(6512007)(6666004)(186003)(8936002)(5660300002)(6636002)(4326008)(86362001)(31696002)(316002)(54906003)(110136005)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mzh6K0VnSlR0NzNTc2tqYk05UW92b2xEMmdPdUc5bGcwanh0N0tLVzk4bUVy?=
 =?utf-8?B?NDBvZzgra25GcTFleE4yU2RqMGJvTEpoeWh2WDRyMlZqOTdaTkNzUUREQ2Rr?=
 =?utf-8?B?bUJHVU5LVm5WL2dkVFVGNTBtM016cEVVY0FXaHFlN0Z3bzYyeGh4Vy80U0sx?=
 =?utf-8?B?b1l5RWt5WG5BQmU4UnQ1UEpqUHBobkdvNEVKQ3N4dWdWSDhzeE1xWkNFNHV1?=
 =?utf-8?B?NHg1TjRMaytKYXh6ZjVLS3JrdytQN3A4V0NZamtKSHRwL2NxbFZpN2pXdWZ2?=
 =?utf-8?B?aS9rK1pJRGtNRmJkMm80cThpdkFaZnBjMExIaEdDNzRiSDRkZFNwYVp1NTJr?=
 =?utf-8?B?eHRxR0RCN0hZU0tRcTlucTRVZWlTK3krZ2NKZi8yMitrbjc1bDhvYjVaWGFt?=
 =?utf-8?B?cXA1RkV4YnZEUHp0M2V4TmVPUXhyek1LQzJpcjFoTnZQeHI5aTdsbmw1M2p0?=
 =?utf-8?B?blN1QmpUU0o1cjFDb2wrMHpFaTU0Ukl1aVBvL2VuYzhwb1pXbzk2MVFSVWo1?=
 =?utf-8?B?SzlpSmtWNTI2T1c1ZWJ3RVZNTXRUTnE5ZG1IV0VaN0tpL2w5ZnhRK3pjb2JM?=
 =?utf-8?B?Sjl2QmFSMXNBZGNqUFlFNlpyUklLTzJiT0Fsa0llWTJ1dnFoQmlEM051UUl5?=
 =?utf-8?B?YlJRc0QxNm9aV2lFeUdpOFRhT2NraFJoM3BSS1Bzb0tDTVh3NUlVSS83TEFJ?=
 =?utf-8?B?NnUxZ1o0N0w2dit1Kzk4eWNHVmRFdEZlUVliZkhTWE5zc05hRGd2WVR2djRp?=
 =?utf-8?B?UDJFdmRmNjBUWktvV1NNS3ptQ1FQZFZuQmdKRWI0dVNiR1ZIVm9lYk1obWZR?=
 =?utf-8?B?RmNIL2trVmlidHBkWjN5Z0VTbnVGanlheXU3WEZpRlFQbURUZFVGb3NVNi84?=
 =?utf-8?B?anpBcE5Fb2kraEEvd3dnVitiUy9kS1ZXcjA5ajZQVFZnd1JkekJRaFRiVWhY?=
 =?utf-8?B?UFFmd3luVzFHeWJBRzQzMkxPNVEyS2xWM1I5ZHhleTlYcTd5OGZiSkRNbGFS?=
 =?utf-8?B?dDdFUVpxM1Y3K0ZIcGl6eWFrNU5XWlhlUTYyaFc1OUQxR250anRvc0dVQVk2?=
 =?utf-8?B?akJ4Z0xxWFh2MGY3YzJFWldWbWlYdExqLzY4Q3VkUU9BakhwMTNHVTZ5OUF2?=
 =?utf-8?B?MEx4c2EwLzJrRTQ4Z21ySTZ2eldFd2JKYUV3d2hoYkNCSnVIS2hHSzByczBy?=
 =?utf-8?B?cDlaV1IwSWVHM0toaXlxalo5T0tYeXIwM2tCYnBEZlJGSXUydTNQWVhvWVpq?=
 =?utf-8?B?Zy9JU0tLaHZTTGNPS0g4bi96dWpMcjRmU0RFUFdaQlMwYUF0ZzAzTURONEZW?=
 =?utf-8?B?N204RGg1Rzk5dGNyWVFsekxhMmNZeGtURWtyTlBXTU1MeDlmYmoyWExiU2Zn?=
 =?utf-8?B?ZjdHQ3ZvQ3YxdjRQUWFGMmUvOWdtQUcwNktCT3NManR6Q0hLdWZWQkNySjBV?=
 =?utf-8?B?cWZIZzJ6Q2xob2pFbU9VYmRVY1M2T1FWSWdXbjB3K2tOUkZ4OTFWVkxxRWoz?=
 =?utf-8?B?KzhoMFcrV0g4b0lTWXp1eXJUOXU0bkhoUEx0UDB2MnhndWlWa1p5b1MyVXZ2?=
 =?utf-8?B?L090ODJnclRsMWgza1czQkJEVkF2SFNsL3JtMUhwdnd5UE1TdjdiS3dTOVBR?=
 =?utf-8?B?UEJaZWwycVJnYmU1VVBOQ210VFZYQytzS3Y1VHl0SE5XMk1WK0hWbVVJYnRw?=
 =?utf-8?B?UHk2WWxyVDY0ZWFkOEhwSmdnNFFhdHpnelp3QXNqU3k0Y2xnQjRLYTRYSmhL?=
 =?utf-8?B?cHMvWVFiUGE0cXFpRCs2THdNNitkVWVPd1BWdjBveEZlMTVvcGlMTUZnSDJm?=
 =?utf-8?B?dlhlS1hvV1BlWng0WFFMWkVGWDJMQkhmazQyY2J6RUVIUHdMOFpraS9IdWtV?=
 =?utf-8?B?c0FWSUZEbnR6VDVadFpEZ3Z1OG42MGxCV0poMlZWam9YOVRFZ3BHdDVlZmp6?=
 =?utf-8?B?WjhPdXVaMFVwV21hdS9TSzBOZUJ3dG9PcVNrQWNxaWxWWExqSGlTR1NRbTRj?=
 =?utf-8?B?Qmt6aUlIaElwbDY1VUF5a1pCb2tSR1pGUTZKVDhubGUzMHVHdlR1RTB6TnFY?=
 =?utf-8?B?QnYzNGRSaXd0VDlGUm1LVk1rekg3NWdyQitqZFpJN1ZnRnhBd3IwQnNuNHZ1?=
 =?utf-8?B?ZnpQZmRpQTVBd3ZUMHJNNFN3aEpDTUU2ZnhGb2dvUHRzeTFYK2tSS2VmWjNr?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0fa63e-4fab-4664-8e74-08dad18cfd77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:07:50.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBUY1Vg/uz+jkm7X8yYFJ/uQTFlMyfOdkfYj0ClhlOCMfWebGCFtf7uZ3OEnCpoAmCjmY0fdCFXmJ6m3IDkJ0lIB87ZoU9eaQYFMAmqYedo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4588
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

On 11/22/2022 5:04 PM, Akihiko Odaki wrote:
> Hi,
> 
> On 2022/11/23 1:22, Maciej Fijalkowski wrote:
>> On Wed, Nov 23, 2022 at 12:26:30AM +0900, Akihiko Odaki wrote:
>>> vf reset nack actually represents the reset operation itself is
>>> performed but no address is assigned. Therefore, e1000_reset_hw_vf
>>> should fill the "perm_addr" with the zero address and return success on
>>> such an occasion. This prevents its callers in netdev.c from saying PF
>>> still resetting, and instead allows them to correctly report that no
>>> address is assigned.
>>
>> What's the v1->v2 diff?
> 
> Sorry, I mistakenly added you to CC (and didn't tell you the context). 
> The diff is only in the message. For details, please look at:
> https://patchew.org/linux/20221122092707.30981-1-akihiko.odaki@daynix.com/#647a4053-bae0-6c06-3049-274d389c2bdd@daynix.com
> 
>> Probably route to net and add fixes tag?
> It is hard to determine the cause of the bug because it is about 
> undocumented ABI. Linux introduced E1000_VF_RESET | 
> E1000_VT_MSGTYPE_NACK response with commit 6ddbc4cf1f4d ("igb: Indicate 
> failure on vf reset for empty mac address") so one can say it is the 
> cause of the bug.
 >
> However, the PF may be driven by someone else Linux (Windows in 
> particular), and if such system have already had E1000_VF_RESET | 
> E1000_VT_MSGTYPE_NACK response defined, it can be said the bug existed 
> even before Linux changes how the PF responds to E1000_VF_RESET request.

As best as you can find is ok; the one you point to seems reasonable. We 
can only control this OS so we should point to the responsible patch 
within the kernel. It's better to go with a best-effort Fixes and get 
applied to some stable kernels then go without one and not (and would 
require later effort).

Thanks,
Tony
