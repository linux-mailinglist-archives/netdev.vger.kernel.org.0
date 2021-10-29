Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C915F43F989
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJ2JQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:16:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:2240 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231436AbhJ2JQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 05:16:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="210677950"
X-IronPort-AV: E=Sophos;i="5.87,192,1631602800"; 
   d="scan'208";a="210677950"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 02:14:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,192,1631602800"; 
   d="scan'208";a="636641176"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2021 02:14:23 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 29 Oct 2021 02:14:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 29 Oct 2021 02:14:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 29 Oct 2021 02:14:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4cVaqVZs2QTsvFc3zeQSg2Oy4Nm3nmUKBs2H9uF6Q7b8VGxylhT0xiOCd/bk61utGttsCNKwz/1qbvsKKGSU2/k/FboS0LgIKA4FK5YU/aGYrX84s3NFD6wJHUCX91ql3VZhmjjgOIubmk6gc8tScJa5syq+njUYLn8L9547mMoHTpMLfLg19UOy2O9Z82nVBEYMwIjzZTFgTCPJ+l2QTp7ZQx3t5acx7pGZqdiqJ2GkJlCvOifXgwXr7M5CBciQOVLZDh4nGumU1UqINKgb8wQB4horQ72Wf6uPDPE3p7qMYVHmcR0Gwg0AAkk6IaWbsHKjeAQSvSfEn/WuKekLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPQhb9rYo0PfzrB6NHx3s+ke/vWmu+rv02V+NiFs+TY=;
 b=kU8TVDXmun2UEgwoBfKnnpdW1yqTDEY0qmKAJ41xJ5i3PS2BUR/7+U1P8Vs7r7ryNmi88+eUwS+gab1dNlPvJGaQ4P8wret8o9tDDVTI+lyj4nE4UksvbvSYhwxDZvGQnu8vJlDHRzC+xnsxREG4S/YRn6qym98s/lJiNYr5zIMAgjagp7I7OptP4rQ1epN0FpIC4qtUreFXDjcddFz0SnQAfETVqVOfmCLedxVIaWuJcSKxDush+qoEHdILyXr/Rpmj0PXIA+BwO9J5jtG5D592MI7qRpoUZmoJuXWSUue46LHs+qbeChgh1vIHpU5/bRANDbT1jaykTMfXTWREVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPQhb9rYo0PfzrB6NHx3s+ke/vWmu+rv02V+NiFs+TY=;
 b=XbolyhxGSl1HZ0aZ/OLpyvpUA1nrWUV8v2MnghZ8X3HK1vFD6OIE/aIRcevhD0JakDu2dev4dMLc04WEIkvhZ658Poe9PhdZIoHQifSV12Aj5xrgpVtlYBLS5F3sCfL+UxVfEU03iOdccXYGClkBxbxhhENw23s2POaVXlYFB0U=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 09:14:20 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 09:14:20 +0000
Message-ID: <f6a4d53a-3ec8-b5cd-9b6c-b14c69d20248@intel.com>
Date:   Fri, 29 Oct 2021 12:14:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.1
Subject: Re: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when
 DPG_EXIT_DONE is already flagged
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Dima Ruinskiy" <dima.ruinskiy@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
 <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
 <CAAd53p69k-2PVw5RpJOAbe=oBh11U_UqzsyMjxHFbo7xqNBDsQ@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <CAAd53p69k-2PVw5RpJOAbe=oBh11U_UqzsyMjxHFbo7xqNBDsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::41) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [192.168.1.168] (84.108.64.141) by AM6PR10CA0028.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 09:14:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4656d3-2197-4fd6-685f-08d99abc7d4e
X-MS-TrafficTypeDiagnostic: MW3PR11MB4522:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW3PR11MB452204DD78E25737089B302097879@MW3PR11MB4522.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZD80ppFDlAJj4SHMZbR/1DxgzB1WaOTBS5crXWgDF6CXPfxDT0sd1mcnL2gEImRlcHk/JB2V368mZwVqF8MLWai8ZQq78o0787DVSLOUNq+ZsJyTm6JsWXKiZrszu5xT1WdAS2xP0Rc9aTpGRb0izTshcMpAS5WTMB9QE76TRIguyLCw7rA+CRKBdIq9qRGfHZ6I5aJk1rFtHid+cWLIWqBfZOTzG+AYCoHYeUEM6G56SUFvRk+bRIF6YiTFPdtHwPO1wNAMtlk3Z1loIq6MRa5V2BaqDqRvZljN4myK5Z40t4ZfRrZDL7sCFAry3ymIiilSl0JI1Rg1kbCgKuHqCM/yXDv1oIJxXqQWIGsaUm5c0zlFFHGKZRIThGeVkSSMfQEhkesqHqfG833bFPrA2y7vnve0SC1G47EvzILzAhPH/PZJX6RmohnQ2RtPkbjnrJ95trT2xcbG6JUCO0Zcx0VZFgiMox77G8N1mTFqvtouaX7EEKrTDu2KwygVcEl9GDJW5B0aZiHxnrj/YfnwN3/X+59bnAhW6qfyHEjHOMcs28QMX+dOnll+EKVwrnnXvcWr/CQ/FQnyyTB2WOSoQe/LI5pyZne9OXGSxOECKcSrNuegJ5z23Y4ACic2Mj/dd38GIUDzMUC3HrPgC9Ey4057i9I2dAm+2YvX5M++ikJhKKBEZbg1DE4i0HkOGOZKhjNOqq6lcHERCmnFcZtnxk1fKov7CGboG9BWUzQti4iJUDa3RWp5HnJ2lgDFpDxwyez+EVYdVSNJlQ1RlZFRPrq7NpRXM5CDWFGkSX2lCYo4Ea/XF6ozss02iUy1MFkybEpJWC5cLWAUxVHYsuq14edVXSNk+xLVYanCMwwS6O0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(82960400001)(16576012)(6486002)(66556008)(2616005)(36756003)(956004)(66946007)(44832011)(31686004)(31696002)(86362001)(966005)(66476007)(6916009)(2906002)(316002)(53546011)(26005)(5660300002)(186003)(8936002)(6666004)(508600001)(54906003)(4326008)(8676002)(83380400001)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzNJTmNvQmRnUHU0RjdrVTBHMXlqVURrNDJiK0VNM2hzYXhoa2RnSmZaRXM3?=
 =?utf-8?B?OWdoTklWUDdGaWNtL1h0bllJcnd5OGZJL3ExVCtXaExIcUxVMVZGMGdqeU5z?=
 =?utf-8?B?STNiYmlrSzBoNEdEQktRU0dBUHFGNW5nbE5lRTFHR2ZqS3crY0ZBMnNNSUkz?=
 =?utf-8?B?czJqY1VmbmZ5RjltRWxobnZtRjNVblo5elBSa1dZNlY2N25KU2lFdE1UdXov?=
 =?utf-8?B?NVk3YVJvcTZKaWlUK25pdUpQT2cxOUwrK1pRNFlqZnpmMWV3b003V1dtelNG?=
 =?utf-8?B?TXZRbGZvbi9oTFVmTUJMcE0yekFkYVBLeG55Uk4rbVRHS2FobmJURlNBdXVY?=
 =?utf-8?B?YzliTXNTWDBuQUtsL3Uvb3pJdFdCY2Q5OGt1L2dxdnNMUkVMT3JCZlcxSWZW?=
 =?utf-8?B?S2xpaG1GaFQvYUg5YVVKY05JOEN2cEt1UStPL01lOW1iMlVwK0plSlkzMzNS?=
 =?utf-8?B?clpRR1hMNWkzVUpLMWpVa3RFZWxQdEpUTHg2TndGalRjZ2FUVVN5TlJ4eEtL?=
 =?utf-8?B?ekhPa2FLVmZTTEtLUXVhQnRPSXJRQ1M5Rit3YXhHaHh6aS9wRG1KVE5yVTd6?=
 =?utf-8?B?WHcrUWRGZ01EVlBuYm11cGxtSWIvWmlFL2VPWndJU3pRSXZoUFNhRHk4aDNw?=
 =?utf-8?B?OWF3ZG1LeUx1cStVNmxKM2lEeFZBRktyS1hHbWxsU2EvSmlZWEVHd0ZRaS91?=
 =?utf-8?B?UFVub3JIbWtHcnFNbU5yempTa1BydFMyNzNpL0tnY1FHbXc4Q1UzcmNFQmlK?=
 =?utf-8?B?UWZtclBFR1Fobm1aT0FwVlNZS0xDbDhiZnFxTFZNZHZndDRxbWErbE9YUG4y?=
 =?utf-8?B?d3I3YTVoWHAzLzBMZlM0QnFzWDMvUW9oY2M2K29GelU5Qk5IUjhNbjQrd0Zo?=
 =?utf-8?B?NmF1aEhvM3BWTkpNblNUd2hpWkZ3a2ZkOHE2eEVOVjB2QmpoMVl6TDdSeEJL?=
 =?utf-8?B?aXB0aHhzL2tlVTl2aXJiNkgvYXFnTk8zU2hnRzJMZEYyM1Q0N2VXRUd2eGpR?=
 =?utf-8?B?Q0p4YjdTM1RpMm9kQjNTWTE3QUora2hOd2syckxETTZ4bG9qdmVoL25ETG5N?=
 =?utf-8?B?K1lLaTdjZGxseW12VEpKTjJpMW9GWmFlUEsxK3Z1V0ZiUWRJdXFHek9wSnRr?=
 =?utf-8?B?YW12N1NoYkozKzJjSC9iRVpWMjlhYmpvU0FzSFIrOStxMXFiSWV4WlhCVXVK?=
 =?utf-8?B?NFE3US8veDJQRTFyam9WdnFzMkMwSmpadkZTRG4raUNwc0RzZVdteXZLZFo5?=
 =?utf-8?B?MWFKOFFwNE1MU1ZoTjZsbXVOUE1lL2RReDc5U1p3MW4xbVJ4UUNzTEo1SUsv?=
 =?utf-8?B?U0NXVnNqZE5iTUI3RFI2ZVpOWC9DR1k5ZDQrSkpNVWhEZk9QNG5qZTFWSHpr?=
 =?utf-8?B?M2pXdE1hSFRwRU9zVGswYmJZdHlzTURRZklvNjVHa1grRGJrblJGTDlwNzdu?=
 =?utf-8?B?T0NWeVpZRzZxNUh3K1lkS0dGU0RCU3JDUllNUGRZaWhpQ3p2NUV5Tkk4dVh2?=
 =?utf-8?B?NWhrRFdWc1JDdVZLWTNCVzlVM2lmcitkUWZHU3lBR3VwTXJpMCtUU2lIUENV?=
 =?utf-8?B?MTJCV1F6Yy9yak1URWJxTC91TG5ZUjMyQkdmQmozdnZrc1NESFlPZGtqQkVH?=
 =?utf-8?B?emY1ejJ3MzRVUXU2MVoveEVkR1ZzakNMc2NDeEJGVTZwV0h0b1JwTkoxRGwy?=
 =?utf-8?B?bklEcWdkdVNsVklpdDF1NldpcVdrc1ZMcUNnbHdSbEVCMXcwM1RPbHByYVlE?=
 =?utf-8?B?dHBDMmZGUmtKem9wWklFWTkwN1pGUkt5aldVOTUzZzhzRzlRYStnZUcwZm1t?=
 =?utf-8?B?d1FkS2NuemlvMkFWRmFPbktCWXcxeVlSdGNzZm5TcXVuRzBSbVFrR1h1NkVI?=
 =?utf-8?B?czRNa2pOTS9VZ3Z0MU1ZaThSTUoybkkwMjZBelFlUjBWT2tHdjJlZ2Uycmox?=
 =?utf-8?B?UEk0NHJyYW04VWhzV3h1SEJ2czdKRGZHSTI0NWRPOWJNN3IvWWJ5RHhNWW1a?=
 =?utf-8?B?VTdVZlI5Z25FS2dmWW9wMmw1ZXVwcVI1eUNidENZenU3Z1JqM1g0QUdjRU5M?=
 =?utf-8?B?bjd3ZjdlTEdsWFF4dUZwZkxiQjh5aUNnZmR6V1l3SVpZSk5rUFZoRzlPbVJJ?=
 =?utf-8?B?S0dOYjJLUVRmc2ZDeUFtYmNHZGgvVTdYQm9BMk9yUDBwNWVsdXpKZjhwdkRE?=
 =?utf-8?Q?/0q6QxjDqmcmAStM2JP6etc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4656d3-2197-4fd6-685f-08d99abc7d4e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 09:14:19.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Chs7XvV/bAuBhR1mU4gyErBSKL+j4Zx9DlatpGzQuPpq5hZbIUkXjYnvnb+MEvNxJXDFrdevLqIRhW210Z3LNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4522
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/2021 01:50, Kai-Heng Feng wrote:
> On Tue, Oct 26, 2021 at 4:48 PM Sasha Neftin <sasha.neftin@intel.com> wrote:
>>
>> On 10/26/2021 09:51, Kai-Heng Feng wrote:
>>> On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
>>> polling logic doesn't wait until ME really unconfigures s0ix.
>>>
>>> So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
>>> flagged, wait for 1 second to let ME unconfigure s0ix.
>>>
>>> Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>> v2:
>>>    Add missing "Fixes:" tag
>>>
>>>    drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> index 44e2dc8328a22..cd81ba00a6bc9 100644
>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>>        u32 mac_data;
>>>        u16 phy_data;
>>>        u32 i = 0;
>>> +     bool dpg_exit_done;
>>>
>>>        if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
>>> +             dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
>>>                /* Request ME unconfigure the device from S0ix */
>>>                mac_data = er32(H2ME);
>>>                mac_data &= ~E1000_H2ME_START_DPG;
>>>                mac_data |= E1000_H2ME_EXIT_DPG;
>>>                ew32(H2ME, mac_data);
>>>
>>> +             if (dpg_exit_done) {
>>> +                     e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");
>>> +                     msleep(1000);
>>> +             }
>> Thanks for working on the enablement.
>> The delay approach is fragile. We need to work with CSME folks to
>> understand why _DPG_EXIT_DONE indication is wrong on some ADL platforms.
>> Could you provide CSME/BIOS version? dmidecode -t 0 and cat
>> /sys/class/mei/mei0/fw_ver
> 
> $ sudo dmidecode -t 0
> # dmidecode 3.2
> Getting SMBIOS data from sysfs.
> SMBIOS 3.4 present.
> # SMBIOS implementations newer than version 3.2.0 are not
> # fully supported by this version of dmidecode.
> 
> Handle 0x0001, DMI type 0, 26 bytes
> BIOS Information
>          Vendor: Dell Inc.
>          Version: 0.12.68
>          Release Date: 10/01/2021
>          ROM Size: 48 MB
>          Characteristics:
>                  PCI is supported
>                  PNP is supported
>                  BIOS is upgradeable
>                  BIOS shadowing is allowed
>                  Boot from CD is supported
>                  Selectable boot is supported
>                  EDD is supported
>                  Print screen service is supported (int 5h)
>                  8042 keyboard services are supported (int 9h)
>                  Serial services are supported (int 14h)
>                  Printer services are supported (int 17h)
>                  ACPI is supported
>                  USB legacy is supported
>                  BIOS boot specification is supported
>                  Function key-initiated network boot is supported
>                  Targeted content distribution is supported
>                  UEFI is supported
>          BIOS Revision: 0.12
> 
> $ cat /sys/class/mei/mei0/fw_ver
> 0:16.0.15.1518
> 0:16.0.15.1518
> 0:16.0.15.1518
> 
Thank you Kai-Heng. The _DPG_EXIT_DONE bit indication comes from the 
EXFWSM register controlled by the CSME. We have only read access.  I 
realized that this indication was set to 1 even before our request to 
unconfigure the s0ix settings from the CSME. I am wondering. Does after 
a ~ 1s delay (or less, or more) _DPG_EXIT_DONE indication eventually 
change by CSME to 0? (is it consistently)
>>>                /* Poll up to 2.5 seconds for ME to unconfigure DPG.
>>>                 * If this takes more than 1 second, show a warning indicating a
>>>                 * firmware bug
>>>

