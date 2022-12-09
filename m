Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7D264875B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLIRKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLIRJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:09:23 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6B1265B
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670605742; x=1702141742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wHS+WngqtdyHKW3ipogDyTLRJF5Y8GBdzVzwKf9HGCc=;
  b=GCPLdKcHJlhFVbfHvR2pQoN1oVspcRU5neVDGJeUsXwLRr9vnLF/K1dJ
   jeDISeO7BO8nJKFLwEX12CcVvxxhOxWSr9mnncAgEcz8DTKYToPslblDZ
   C/oLDRkOdX4xR+ddFHFV0ejOzDk32oNxDhJNWB4ygfOBAhJKkzpXht4w6
   PyFGnNav4TNgQFapF955ynR1+kCYVAZbuwJk3DU5wq/9UCsPmZn9efxfc
   8lCtqZDIUGCE6CX9gb8Yul1TsAXWj2RMa18EdmLM8lfjgjOZBGYavxdtd
   ZFWlvhqm/Cn9DLRip+disUnf9Tb8uG1lQ/tTB1soqGxueSe7ZCLKMlyJ+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="317529752"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="317529752"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:07:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="597786627"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="597786627"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 09 Dec 2022 09:07:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:07:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:07:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:07:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:07:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OP79m4czH6HcUFbqMa8NDbeelaVXANqUocJy7z+A7rgca//4aniDV3kVHLaipjCYYTup2vNoBO65rSQYt8yez0zVNOqVlsvh3HcbKggwxAxfgmWuz5NqhTN3reGDK1gzb2LFt5/2ghh/T0EKZsK7OmHDYllrdFX3R5JB/dEsiwquzyJx4oDCf98vhJhcGEXn9Uy+6+d9VgwPOVpxHwBEE6ybJ/LcGrXzUqvesqK/p5ErAUVsD1lfg2E1DX2uNyQax7o5uILYpABSJHM1a08fw797+AzcHy9R/9wBAdXmVoEDGjS2PlDGmiYhOTxAXl0vaUMwi8AXzaAH1Ib5KvZrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPzWAlMknTYzYp2nG1qxt1sOx1EQXmLx/JwP4EktgLE=;
 b=mH6xyf0KIbRlsZf5ofqZFdFJgFA7NRiWsDF7BF6eS+TUVXChx8zt2UxxYdKIRw+Wm8WbgaECgOBuJ4dhg2sujF8oGD9h2JPMQzoVig2homE+S3r3ndt0DMLFjH+RRXsGmHC6Oi9NcHluWVTEi1osrrqjNs1vfwYUtHmNwH1PPDQepqc7WQU6BHcNAaAb4FOToHJ+kH//qiFuGAYRHRm1o11jKhDwFJm5qRRPH4bvnToegc90Mkm5FqTQoNMruhpVj8uFHqSNe2g5OTmuAfU7aFwnLTRBo9X3P/fzOG/Xe7IEZT29A66iPfP+gWpUQeD6f1qHq8eYwAw5SQktsQuEqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN9PR11MB5305.namprd11.prod.outlook.com (2603:10b6:408:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 17:07:12 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5857.023; Fri, 9 Dec 2022
 17:07:11 +0000
Message-ID: <0706dfce-bb57-dc31-23ce-51165b931609@intel.com>
Date:   Fri, 9 Dec 2022 09:07:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        <netdev@vger.kernel.org>, Gurucharan G <gurucharanx.g@intel.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
 <Y5EvYXK9V+BSU4pS@hoboy.vegasvil.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y5EvYXK9V+BSU4pS@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::39) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|BN9PR11MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 69727469-a546-4884-5964-08dada07cfef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfN0VrMjgbvu0djucmiPilGAI/R2Al3q/qJsLezb1EhZZs9mUcRLQp7QUOssT5dDZahOqxsDYMY/32V/jJ337K2LVgnrgCGP3XxAQxYJts/KLS5Ws50oeP+VSxNBJIL6mHG0/kXRdGjEYQKsKLqDd8A+BrOJK094qpVC4FOe/IeCh6kfJrW8Z3q1o20yayyp3JzVQwnukZhtSdzhvRq6jGI733ef/vqc/VFy89rv7E2Aqc/Wi5aavP4tmKEt8Xy2ZJAkpnieiGp9sly9ayBDgrvOCzEBtQYxds2HGhgkjpn1FGUbHmCng/6POdihyiaP251QFJ0NNQpT2pwVpL6S0q7GiImCtKBzAVJ9RZ2ny3mWpPtsTCLzhoiFiTUQjHkmllQwu4PhldMUm2i0en/61WsN6y0yk1oLOO2/1YLAET4P1dmupAU63HdubiKZeKsj5HOGzf/uJqeYC7jVphsMHB9z5xee4npfdQbs0Ew9YejeH+BXF02xCIPV3n3UIzMvGbemf3pEVClm0qiyJ2MDPao46La0D2BrCL0CAc0KO3dy6PEWrmqUitOYGc1rVYO4kwwSkoYjzBUAudGY0Vml6QS9T6+xs47XHXIa+lERM0X6W5HGD6eanMSYk5fbt+dTq74W+gOL3HYHovw0Sf9LrncFFLMTsUGObb9+g/sqIQTwvB2ydyHQvsSjeSFjiEZYLFkNDubaGbB/6P4AkoWZr0hVd4hChwfgLpzoB9evkk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(316002)(6666004)(107886003)(6506007)(478600001)(41300700001)(6486002)(4744005)(66946007)(8676002)(6916009)(36756003)(66476007)(4326008)(8936002)(5660300002)(66556008)(53546011)(86362001)(31696002)(83380400001)(82960400001)(2616005)(38100700002)(26005)(186003)(6512007)(54906003)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFRYcm53SUo0WEE4ekJRSG82ZFR0b29oR0ZYbTdxVEVmVE9vSlRPM09Qakht?=
 =?utf-8?B?TFhFV1FrZFlINnlJeVNVRm41NGsycjliei9WVlcxMkl4QktzWUQza0M0TVI3?=
 =?utf-8?B?djBwVXlRblpsZ1psNDZyQ0tla2NpT0hoNjVXbnY4WW1GT0p3dFJ6UVQ0S2Vj?=
 =?utf-8?B?WUZGZ0NIOC9VOXUrdkRuNXA2RWtRTTV3QVhJMFZlSXVoRmdDenNhUTd2QXl5?=
 =?utf-8?B?aHZMQUI5SFlBRGF2em1zZ05aSjVCdjdlTllUYjdvVUhqSWpvMDVhd1RmSHI1?=
 =?utf-8?B?MTZ3ZkFsWVpIQmdqcmdzSVBPQjBOclkwMHFlOHozWit5MGJramduTHRSNy9r?=
 =?utf-8?B?REg2ZklMdWNBcXJ6SUpoRjNCMGlTUFVySXNLczk4NnMxemNjVU9QTXAwVDA2?=
 =?utf-8?B?NG53OVBvMng5ekVpbjFRYjZ5MmJvTjIxczhLL1NrZXd2Zm4vOTYyYnB6TFdW?=
 =?utf-8?B?d2NsOG41QThwNEd5Ti82ZE0wWG1RU1Qvb01DSGl2aVBzRktTZWRVVEc5Z3FP?=
 =?utf-8?B?SUdsUm4zWnhaV1dqYXRrM2w0S2dvblFOdWw0UndMVU5PQXpCSlUyZERTd1lN?=
 =?utf-8?B?QnBURkNyQnYySGxxOGVJUFR0QVl6NXRrL1R1UXEzUzFQbjY3ek1KSGQ0U0Nk?=
 =?utf-8?B?TXZpdkVKencrQTZicU16bThkaWpTcndkMWloaWQyMXJJdU1nZlBUMmNyb0do?=
 =?utf-8?B?TXZseFVGRVVYbkQ3VTJ0UFZjeDkwRHAzWnREUDNvWHJRL3N2RUxuOVdSdlZL?=
 =?utf-8?B?cmU1MnUweVV2VVB3SVIrMUZKeVIySDhDNVNpNDRiK203U1dOOWhpdGpndUF4?=
 =?utf-8?B?aW03eDlJdXpYZDhlQ2pBbzMrM0lwZFFvNVZmaVdzNk0zcmRiZm8wa0UyV1Zz?=
 =?utf-8?B?WWdTSDM5VmovRmpvdGY4V3NZaWxvMDhPODliSmhmc01EU25kM1dNUnlOOHhR?=
 =?utf-8?B?ODJhWnQ0b1A5ajFvTnUvY0pZUnNabVgxVm91WEdiRzcrMzVKTFJnMndObmxl?=
 =?utf-8?B?Y2pEeHh1WlRMdFllWmEremdaQUNSUmphWWdYMFdJT3ZiK3NKY1FzV0s0WUpY?=
 =?utf-8?B?Q0tpUURLTndYMkpBS3BzZ1p1cU4zMEhxVUIwOS9uMm9kblEyWWJ5NXpFN2hi?=
 =?utf-8?B?YlQ4RDNraEtGMDJYK0JCWjNWekQ2bm5ocXp0WHJDWUtmZ2Z6eFBsaTErakdP?=
 =?utf-8?B?d2pXb1BOdlo4VzB5V0ZhK2F4VDYzZlF6YWlqb0lrZW52NkZVSHFQUjU2ekpY?=
 =?utf-8?B?UGtQVkUzRjV3TVEyUDNjajdlaThlR0ZwNnVhUk1MckVlK2o2aEIxbUszNmU2?=
 =?utf-8?B?NkdDTVl5WDVQUE00Q2JmS0NRbWxQRnphSW1TdkcvWUNGVEdacEgwSjdGSnRL?=
 =?utf-8?B?MEdFKzBINHZGYVJDQ3BISDA1Nm4zSWZ4YkJneXBnbENBTEhaUDU5Tk5DYTZQ?=
 =?utf-8?B?MXZKaVhwL2ZoREl6czJzZ1NzbkNsTlR0bTgzbFc1QkR4cE1QZjhFQmxhN3VQ?=
 =?utf-8?B?TVQyQncyb25GZERJVzB5dS8zSFFmb3RJd1ZJZk4vMmkvb0dTZUNFUXZtN0d1?=
 =?utf-8?B?M2pUU1orT2hqMVI4cWNiWTBiUVBwcmF2L3o0QmpjTDBVUHJhUCtNVnBuY1Vi?=
 =?utf-8?B?WldZckovUFEzRmNmemxUQmh0eGtvMjNJNlZuRDVidnpuZWlleHdzNllFd1BL?=
 =?utf-8?B?MHV6akRoVStWNCtDSDltY1NkTlphdXA2cWdmaUZYSjFIRTNLb1hPS0VuNGVG?=
 =?utf-8?B?aUVacWU3dGI1OUxkOWY5RXBvaDE4SFpWYWxmSFJjN055RUF1RDJPc0VxUGlq?=
 =?utf-8?B?OUt4ODBSTGVSVlJ0WjMzMWw1TDJYaGNyYkQ5S1VyOTF6eE1EdVJrNy9mL0tV?=
 =?utf-8?B?cU1odG1kVFU1RlV1Ry9NQkRHbGJ6b3E0ZjdjajYyMk16TWtISmltclY0aU1r?=
 =?utf-8?B?S0prWXB3TWVqZ1czUE1DbFhSN2Z2bVBQcllUNWh1UFNDODl3VnZrK1pFYWdH?=
 =?utf-8?B?TlJ6ODlkTzRPVkVyaEtJU2RDcWRPVm9sMGZXM211SWFxWjNMWjM4UnhGQmJk?=
 =?utf-8?B?aEljZmpDY2tsL2ovVVFOMmRvZEI2TVJEKzFBclJGZVQxbTRuZ0JRbEtpVEdW?=
 =?utf-8?B?Y0JlL0FQdEVsTDBmTFdKVmtybTZQZGFQbDE0SHl0SWVZTDRjT2NRck9SRGly?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69727469-a546-4884-5964-08dada07cfef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:07:11.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4Rm1dUHO3WzqJUHUf2rFAuFx7LvKvro4NGUSWeeQ08C0MwZazI0w3VnGjT9z1E6IqyQQvyjh5MkAuZ7TSmkY4OfW17H8v0vjR/hkccaMiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5305
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 4:27 PM, Richard Cochran wrote:
> On Wed, Dec 07, 2022 at 01:10:37PM -0800, Tony Nguyen wrote:
>> From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
>>
>> ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
>> the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
>> sends messages to AQ and waits for responses. This causes
>> ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
>> causes problems with the reading of the incoming signal timestamps,
>> which disrupts a 100 Hz signal.
>>
>> Create an additional kthread_worker pf.ptp.kworker_extts to service only
>> ice_ptp_extts_work() as soon as possible.
> 
> Looks like this driver isn't using the do_aux_work callback.  That
> would provide a kthread worker for free.  Why not use that?

The author is no longer with Intel anymore; we have another developer 
who is looking into this. Will make the change or get back to you.

Thanks,
Tony
