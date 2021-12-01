Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2A4652E9
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351451AbhLAQmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:42:07 -0500
Received: from mga17.intel.com ([192.55.52.151]:24719 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238010AbhLAQmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 11:42:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="217187228"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="217187228"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 08:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="500318510"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Dec 2021 08:38:16 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 08:38:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 1 Dec 2021 08:38:16 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 1 Dec 2021 08:38:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFbkiccQbXvgdKjIU40OP8ryBYPcQX57Omt6j9cp7BNkoWia1AC2xAejhsdDNUiBfyrRCayt6nvHe0ZRTWrm98ikCQr/LxM0cwY19nleo4AZbY0G7QmXJX28Zm2b0nzU3ijIA8vIMqPy+NPB0gPtuRxdF21IJ6wN+0FAlM4hK6UhdfzzQpvLlj0gV0CEGpSMaKmkcVLWBU/f/+yLJ12C+xL3X+teJoKu3sc3puhqkS9OWmvNGqQojKbi4rPDWAqWpeAsF+vunzHALIX+j5Ea2wpYevF8j4Zqb69ZOmBTqXZPiqurNnXbGgNXjHbwn/dk/ve54zWoSfrgXzgUu12uWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcEfBt5nP66fFsi8fSFIUBzoO5P5CQjl7t264HI3xEk=;
 b=lkYp8lcMWUU5iUhgOkurrsA4KAQ8Se9EVX379PaX4ShALJGzst1BrsMVTSUeIFhUOHhooei0hR6D6futP70fK4T+NYN6D14caqmXFotLUynGwrA++RJHwXX1zFZnpynSH35MQxpyjz0VSQi9w1/XQKYlhH/VznxMEchF+19XglLwFiSBOrrLBWUu+eXT1tZgbXAz8GtD+TAd23PeoNILzZV2fx07UHjzMNoedoxKsvbj4nP1gJbg2h+Gbuld72pbCVCzo4npAQ7EVLY2xD4yaXKiIzEKYJBc/W60KoOKLSXPQaJ0rpPTPgTaG8gtUBfmzp3S6gM5/KDm+PMsxuGxJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcEfBt5nP66fFsi8fSFIUBzoO5P5CQjl7t264HI3xEk=;
 b=CGMva6pnKlYjYgfeJwFcTD9TsWbIwaEeooIOHuHN6xrQt0oBllVx8tBRZAdko8aZAd+3SMicNL6uc8Pxt+7N4HVVDTwirp3XnJzCoUIkMspZOMLt8HiYY3RNUpWdZ8XjaIya6yGVQjZ5gP9sCd0+9a6FlVlvIhDvGZEvOCkojlc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5)
 by PH0PR11MB5926.namprd11.prod.outlook.com (2603:10b6:510:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Wed, 1 Dec
 2021 16:38:14 +0000
Received: from PH0PR11MB4821.namprd11.prod.outlook.com
 ([fe80::2c3d:1bff:5730:f5a3]) by PH0PR11MB4821.namprd11.prod.outlook.com
 ([fe80::2c3d:1bff:5730:f5a3%4]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 16:38:14 +0000
Subject: Re: [External] Re: [PATCH 3/3] Revert "e1000e: Add handshake with the
 CSME to support S0ix"
To:     Mark Pearson <markpearson@lenovo.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
 <20211122161927.874291-3-kai.heng.feng@canonical.com>
 <0ba36a30-95d3-a5f4-93c2-443cf2259756@intel.com>
 <3fad0b95-fe97-8c4a-3ca9-3ed2a9fa2134@lenovo.com>
From:   "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Message-ID: <aa685a4f-c270-7b6e-1ede-24570d30dd98@intel.com>
Date:   Wed, 1 Dec 2021 18:38:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <3fad0b95-fe97-8c4a-3ca9-3ed2a9fa2134@lenovo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0389.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::7) To PH0PR11MB4821.namprd11.prod.outlook.com
 (2603:10b6:510:34::5)
MIME-Version: 1.0
Received: from [10.185.169.25] (134.191.232.57) by AS9PR06CA0389.eurprd06.prod.outlook.com (2603:10a6:20b:460::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Wed, 1 Dec 2021 16:38:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf02c595-e954-4292-aedf-08d9b4e8f82a
X-MS-TrafficTypeDiagnostic: PH0PR11MB5926:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <PH0PR11MB59269B063EE06E76C1B8A5D6E8689@PH0PR11MB5926.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2F2CZ7rBm5H2pPWrbCJEHUZG9eSSzV0oY3ExvKaCsWptfOmIkdrJL3FchY6li7PeBmpmXuxcs9fkmyKcpKy8rDg7wXdCOME3nvSahuN0rk5SdeYt5rFZShJLOgxqZey1wYHXhrexW4HNa52uFHn+5HZVQT5FsaloT9Iobjgo5pd+0LSqCFyDnv+vQMpQZo0YHRwCBU2CJTWigxLPqlYBqN4/mC2Jtay6uO8NKkp3m7wLsRrFnRriGNP5MmjZHLLpmvbOIzutrgNRiZkmnPFsaeWKgfXA/BCWL2J9f0N7ExOwmYt/mBCTX/MsjXKVG5SsCdbAuhfU42mdc1mdyLtOUInh92ElB7m5YxhqQUnUw1CBcYVLcfmp9GX9JFkuBECYKKZadjscRDiZyCZ9nP61rHfRtwaX7jV/ucaf/q+mBibicCHKSmfJJUBrl01+uxA0GVx6+Ik0e9ehT8lwlbpzneIjwPUrLv0IOBAJPHdz7S3wryq6NVm1oekuisFFFOocZYkvFxqniiKZ5He1p9DAwTTXeqV5CDP+6GInVZh/wRd/eVGK0ELjZa1FMWhq2u2AFXzHVdd/WXP5bCYn8P+onbdfscaFerGVxd/HA3IygwzIdhosK9EHEZrRZcrxNdxFuxUG/k9O/ev18v0q44dcvSUm8kIYG+g4xU0o3tBVUhLQK0Ztrl6mc5DvSQ3gh1dLjrHctABJQkaEOf4E5ORt3eXdqCFoRlVJjHC6L1UVdZUBWmiDM6h8g/Xx0kHc1HIo5vHjBqZRA1NhJTKNc5eJRF7u9fZYLr0u3LGHiX0yjdF9S7adCHh5/s56Dp224eU3gdXTilriNJXKoeaDlSBKy1j9GFXUW7HCKZ8K8r8odz8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4821.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(86362001)(8676002)(6486002)(31696002)(186003)(66476007)(38100700002)(66556008)(5660300002)(2906002)(31686004)(54906003)(8936002)(966005)(6666004)(4001150100001)(316002)(110136005)(4326008)(2616005)(16576012)(26005)(83380400001)(956004)(53546011)(6636002)(508600001)(107886003)(66946007)(36756003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1hkR1VDc09Yb1NsdDlJS3BuaFhFYjMvNjRkRi9hMHk3eVkweGpwU2d6V2pZ?=
 =?utf-8?B?dGhKTXRoeEZIbjMwZ1dyM1FLbTRRTTlQeDZON1ZKWWo5OHA2engvbVA5Rkpo?=
 =?utf-8?B?aXFjbm5FOTF0OGg5UzdpZkgvNi8wb3RpOXIrWENHWmJMUnNqOGdFTkxMcUZM?=
 =?utf-8?B?SENGcGlqa3ZCQ1lhTUJPWjdma0tBWjFWNytTbEdUZjZFaExKa0doekxVaGJ4?=
 =?utf-8?B?RWROdmdXckZPNTdQTUFvdDRBbG12eG1nWmRlaS9qTWRySWRIYnlXT3VHVWh3?=
 =?utf-8?B?NWRoYm05TTVJZzNsbkM2bzNtS2lvcUxOMWNNYTRNYkNBczQwRjN3ZGlnYUV1?=
 =?utf-8?B?QlJXcW5uUzFub3daSWNGZXhVVHJ2cTY5dHExNHlMU1JQaFMrVE9ESHl0amNQ?=
 =?utf-8?B?bGRIR1JENEpiMjFGb3dqSmZZK1duVDREaStwc0hHZmw0SDBSVlZpMTMya3l5?=
 =?utf-8?B?VHlDcW1KSVIwdmloM3laOUdKQmZuYlk4aE5rQjRJYkhvSE9LU3RyclBaZjk2?=
 =?utf-8?B?VS9WTFJUSG1BQklQc0U3cURzK09FU0lqNVRibG9TdlBmTVNvdFdjV0dkcGFX?=
 =?utf-8?B?aWtLUTRFcEIyU0VUcnBVRjJmSENVQUY3TjY1OTBMczNTaUQxdmQ1b1BkNll3?=
 =?utf-8?B?c2NVWEFuQkJSRjhVbW1SRHp1OHk3UTVnaGRFd1FRcUdvalFPL21yVkgyUW10?=
 =?utf-8?B?b3MwR0xNR1hWV3hveG9Md1Jjc2hBTXVWSGdPYkRFYk5NdGtSS2h6a2pkNGFX?=
 =?utf-8?B?RlRPcDZEUkhva0xvOXQzRXc1UkpWVUVHWUNCeHJ5UTc0eTQyV0JBZkExbHhq?=
 =?utf-8?B?bWJ2TXNLTXluaW5pbWE4OTZsS21qRHJQdzhaUmJpdi9Kc08xcTYxOERtWlBy?=
 =?utf-8?B?Z2VJZmFEeGFsN1NnYmVUUUcwejBrUDd1T0tLd09NQkRucEIrNFA0ZFdQVHVs?=
 =?utf-8?B?aW5Ja0o2SDEvdlY0VmRNTTZUNjJLSWFiNWhjdW5lUWxtdHc5SEk0aXVGaWtI?=
 =?utf-8?B?MytuK3Y5US80OERhMHlMMkhpNzRBdUhPWXEybUVGSmxRbmJ2ZmtWM0pXTVpq?=
 =?utf-8?B?RHc1Q2doVmdBa01jR2RJNWtzeW9LNVBOZWRCbDJHc0FSMXpidzRrRi9wNERZ?=
 =?utf-8?B?ZUdTandQMGx6aHpXYzVTd3d0Zko3bGQ4OVNWY3BVaXB6M2VobUp5MHlqT28w?=
 =?utf-8?B?RTkvcitEQUVZd1pxMzVrN0dtV2pSNVhud1lYWXNhMzcvdGhseU5IeG5PTnpn?=
 =?utf-8?B?YU90T0lqQ040UGk1QjFJYm5PV1VaT1dOUjRtaFFHbkFzL0NtZHBXd0Q0WkUw?=
 =?utf-8?B?SnNudTN3TVNmRWI3MkRoa2ZrRllTTWlLWCtXQ3NvOHpjZS8xajJNZHF6ZENt?=
 =?utf-8?B?bHcxYjhCQjI2YlBQT0R1bkdXWDc3RzRKRWgxWWlwQVR4eWQ4SUdCVWdSV003?=
 =?utf-8?B?RjA1S0l4TlBHUFExVStLcVJ0dmhBbXcyYnhwVjF4WU5nczN0SmpiQkVucWhh?=
 =?utf-8?B?SWdNcUVYMEFIWnFtZUM4a3BySWRlZzNJbS9xU01VRlZLeXoxODFVRDc4WEZy?=
 =?utf-8?B?Mjk0NXZjZ3BwQm15MzB2TTF2bkhjM0VHcEVnbHlsdjNTUGUrNjhKYzZIbGlz?=
 =?utf-8?B?Q2F3VmlldkNPM1FBdnM2U1ZWOVBqcm5sQ2gyU21rRFJWYW0zZWpheTdJOVV0?=
 =?utf-8?B?M0NROXpUOHJESUEvNnRSdDNYUUs3Ymg1OXRmV0Y0dDJBcHZFRzBMOEJhdC8x?=
 =?utf-8?B?REd6c3dzbkNXR1JXL2N5Vkg2RTVmUXhOcG5VY0pXbERzNndrSW80NW9SWWtz?=
 =?utf-8?B?Ull2djN4a0gvaUxjRE91aVdKdDJIUjlGalVLYnFhaXMxNGFqRlBFRWZhQkJQ?=
 =?utf-8?B?WHJYWG1yN2tQamtQaThwODdzT1puQ25JVDNqZzZ6MnJyRk9FeUl1YWpxdnVE?=
 =?utf-8?B?SnEyekJzTUsvck9zTDRSZXlkUzUzeXBUd3EwMG5uSEZvR2xzVEJRbGlMeTZS?=
 =?utf-8?B?MVh5UTRrWThiMUJCeis4MEpzWTJ0Z2RxOVJzU3dWNmpoTWlMTnYyRlZVVlNJ?=
 =?utf-8?B?QW1OTnNHRUk0dmhVU1h4R0ZYcjYxNUdpMVI1b0NaZnlScWpmSWFFc25nbjJN?=
 =?utf-8?B?UklkelRKeWJ2OTJTTFg1MWdGbU9YS21kU0l4Q0U5eXowMlFhWW9hcDExeWcy?=
 =?utf-8?Q?zO7/3pvlMQUK3+Rcezns/cA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf02c595-e954-4292-aedf-08d9b4e8f82a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4821.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 16:38:13.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaGU/+lgPCwJ/1xy0ID6YoxfXkUVo7o9fqJroRkc7mHlxCbnRF7viZU2uzHITeqASeFAksg+UOuOe8gRvOaECw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5926
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 17:52, Mark Pearson wrote:
> Hi Sasha
> 
> On 2021-11-28 08:23, Sasha Neftin wrote:
>> On 11/22/2021 18:19, Kai-Heng Feng wrote:
>>> This reverts commit 3e55d231716ea361b1520b801c6778c4c48de102.
>>>
>>> Bugzilla:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=214821>>>
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
> <snip>
>>>
>> Hello Kai-Heng,
>> I believe it is the wrong approach. Reverting this patch will put
>> corporate systems in an unpredictable state. SW will perform s0ix flow
>> independent to CSME. (The CSME firmware will continue run
>> independently.) LAN controller could be in an unknown state.
>> Please, afford us to continue to debug the problem (it is could be
>> incredible complexity)
>>
>> You always can skip the s0ix flow on problematic corporate systems by
>> using privilege flag: ethtool --set-priv-flags enp0s31f6 s0ix-enabled off
>>
>> Also, there is no impact on consumer systems.
>> Sasha
> 
> I know we've discussed this offline, and your team are working on the
> correct fix but I wanted to check based on your comments above that "it
> was complex". I thought, and maybe misunderstood, that it was going to
> be relatively simple to disable the change for older CPUs - which is the
> biggest problem caused by the patch.
> 
> Right now it's breaking networking for folk who happen to have a vPro
> Tigerlake (and I believe even potentially Cometlake or older) system. I
> think the impact of that could potentially be quite severe.
> 
> I understand not wanting to revert the change for the ADL platforms I
> believe this is targeting and to fix this instead - but your comment
> made me nervous that Linux users on older Intel based platforms are in
> for a long and painful wait - it is likely a lot of users....
> 
> Can you or Dima confirm the fix for older platforms will be available
> soon? I appreciate the ADL platform might take a bit more work and time
> to get right.
> 
> Thanks
> Mark
> 
Hi Mark,

What we currently see is that the issue manifests itself similarly on 
ADL and TGL platforms. Thus, the fix will likely be the same for both.

If we cannot find a proper fix soon, we will provide a workaround (for 
example by temporary disabling the feature on vPro platforms until we do 
have a fix).

This can be done without reverting the patch series, and I don't see 
much value in selectively disabling it for CML/TGL while leaving it on 
for ADL, unless our ongoing debug shows otherwise.

--Dima
