Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1109E6D6D3E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbjDDThI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbjDDThH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:37:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125FAAC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 12:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680637027; x=1712173027;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dRttAEBaFEA8BbSrEt1088Ad/nSoYtCqoZjrwNXJo1k=;
  b=WuvOagqQEzHJPfETWmmdNPMsn7VIHSRW43qQbGO4Enr6Qy358pF5cRCx
   QE1DOYPnvpdf5zsmIg1ubxnXCQvTW4LbgclB32808y6Y9PHD/vcandvKf
   kIa/a58xp9X924gw304M6mAmOsHwSixZuSschQzrBIF9XCGL5g+GdXhl6
   YPMramxGc8UNnXJkLhkKrPo9Ccpydse1cJqvyHP2SHCWiZxd9uns3tJrX
   HiHqXBEGqfL9Kei2jZdUY7Q8MN5gTc1OEq0GAPAXhRwy95iOiE8MfJI3B
   wmyReLyhMbK7jwpGMr7kqp5/EDXWCwR0lzUm6SBW3h2I5etUhaHX+ZFE4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322670360"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="322670360"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 12:37:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="755762106"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="755762106"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 04 Apr 2023 12:37:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 12:37:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 12:37:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 12:37:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 12:37:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWCVmEwN7PsNuKjo12+52fhw5OEz+rUWDzmOVg1p6tsSGlAOF3F0RnQERWuVj7PqjoIiHKunZgatY3b9g4wSl384YoRf6aPPHu0Y/6l0gsD6YKdiI2tFyWvjLKC5okhLdhUoEUd7B/azk/CRKmGtfnhat59KKuA3V+Lpe8uHEVc8vL3x0WbOdT//o9BikF1FRa9e7s1NOkb85BQbCZ7PGSF8dnT4WvDc6NYqLrJjLFnbYSZuezj/Fn3mU5j3FXd3Mumn8RR2YSeTlPg8/SzDyZolsRlprDYaWs/sr3brpQXFnHnjt3Z+6lnkgrfEM3EudgfYDUTNF/SIqoVQX3iEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=op7Rt6HpW2bvgK+s6Lx17YUypkyL9Q/3rr9f5OVPHZY=;
 b=RQbVVhQFcMQ7KuYYZaHIMy9z4MBNwAUxiVSt4YN3OXpTSA4xwHih73/O81LoHN3ikuClMz2Lg4U/rm0a1E1oHwpRfpH18P6RrppGapdzTE7HhJErGvxKRJLNTju+csNtDWJU3a0tYy+YPZpLehSTpu3gARgsPPtPRGo4/qHWWDPMQZTio7GO4ZCA1JXUBNAuRi1SCUZtw7oJnmFazOG6RpJbyQXkhgUxVp2dmvumWBBJAdRVMdbW9KS62lQS4hyhYPau3MUGgp7kKIc3LbS8m/Vd1YgP714NyURbWpMbbq83lYKqU+fIItdvvdsaqNrrYNDcLuWLrgpqRmGB4ElyNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by SN7PR11MB6849.namprd11.prod.outlook.com (2603:10b6:806:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Tue, 4 Apr
 2023 19:37:00 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc%7]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 19:37:00 +0000
Message-ID: <ee6468d3-8212-7bbc-447b-6c659727f5fd@intel.com>
Date:   Wed, 5 Apr 2023 01:06:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net-next 09/15] idpf: initialize
 interrupts and enable vport
To:     Simon Horman <simon.horman@corigine.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <emil.s.tantilov@intel.com>,
        <willemb@google.com>, <decot@google.com>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-10-pavan.kumar.linga@intel.com>
 <ZCcDabCHzjXeN+xI@corigine.com>
Content-Language: en-US
From:   "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <ZCcDabCHzjXeN+xI@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::15) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|SN7PR11MB6849:EE_
X-MS-Office365-Filtering-Correlation-Id: 160db036-679e-4f8d-7738-08db3543f4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7FkmQDjzyJLX8jIX0DT0lQ+mrgx9qjOGvasOzG9hepChQryqD+Nk2oQS/vGuxsVZYawDJGl1GZYAVEW3dF5mIf1wLdWVgXJkFS3d/BfdbMSPRuS0EWanFsOiqoXEehWTkdFTOOyxV/vCA/DPw0Jh+5D9Kr7x6+gkJ3MlaS9OasGUsmfWa3BgvJWUi6EwIiRClIwvtQrgm4SfpdKAny8Zl5i2pLDt9Yux5IDVtClBeOxkKzHEOnvYGS1cwTp88IQkvXfKK2a+2gBJocYy0xV2BwXjGZZjqqSDQqFbHgiKe78GBPW/TxG+9GIMzmljN7izOEcO1fZXWcH/MpOZrDTz5isHRf2drvybdN9AXdeWQQpzZ3IvN/oaxB6Q9wDOuEPVO3yWt2VQ1ze2WaDuHAnHy4/WaVf1/XGKA9L9vSTQ/b0qWbEk/Uo1l5LwyH+fzEeii5ZKfXJayJH8HuhD6RT1BIiTbjz4mFo5cnDjQywtggczvF4zHq5EioUkn9S8g6mds2mgsJT9Yj2MdFt77wxAYt1udtLtAjEcrg1fDZ0Hn4oJnIWu5NYHbF6vke841J3oxax5BNJJ0EAFrjZ4Elma/bRR6agtgHjN2HDpEcX/JcxZhrPq4Ucw/jE76eDrGAD1jy2EcD8nrXX/Hpq1hkX0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199021)(6666004)(6486002)(36756003)(31686004)(31696002)(2906002)(41300700001)(4326008)(26005)(107886003)(2616005)(186003)(54906003)(5660300002)(66476007)(6512007)(66556008)(316002)(478600001)(66946007)(6916009)(8936002)(6506007)(8676002)(82960400001)(83380400001)(53546011)(86362001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2VDbTBnbUk2L21sdkRNLytDMFNNMjlGcFlLOUJSR0d6YjlYWkowaGlNV0FN?=
 =?utf-8?B?OFFQWFc1TTdIamdZTFYyTFRudU9RMjR4ZEd0Umora2lyT05Db3hoeDdZeEIr?=
 =?utf-8?B?S1ZHampPQ3p1Nk4xdHkwY3FZVzA5d3UrNXczNW5oeG9IUmFGd0FqMHVYdFM3?=
 =?utf-8?B?b3RyWnh6NE1heTRaT0pUa05XaWhsYXNoMnh3aHJka1J6ZU5POG1LOVB4aVht?=
 =?utf-8?B?cVVOSkpBUTZtN0o3WTBianAyemRockdGeFVLUG1ZbUFCakpOMGhiRnhjMlkv?=
 =?utf-8?B?UVJhbUZ3MmFjTjkvUVZFR0l6Umt1MTFvOWZDaWlhSFFvbkhpa1NHWWNmVCtX?=
 =?utf-8?B?RDUxRVZmK1BDdnp6T0pzNWtvb25zM0pIQ3N4VmZMbXduc1R5UmFMYzdxU01k?=
 =?utf-8?B?SlhtYlptb2RoNGgvV3Z6Wlo1alUwWU1UWnVBazZLYUV2OFJrUWcvaXFvYm5m?=
 =?utf-8?B?V0ZiUEFFNHdOOEdkYlNRN0RpTkVrN2NBaG9hNUNWT28wRlNnSXdPSEI5elpU?=
 =?utf-8?B?SnRxbTBhcFVXcTl6TzY1Z29wM3ZRSm1uZ2ZNaEsxZUpwRkZKZzRqODBWbHJQ?=
 =?utf-8?B?QzA1SzgvSU1DOERoRjQyejNJZlpLQzRLRUhoc055WHRrc01ybndFblFjU29o?=
 =?utf-8?B?S09DamQ2Q3V1Qkx3aFQyUkoxdSsrNElidDQyUjU4a3QvRGNnZk9vQnhDU3Y0?=
 =?utf-8?B?dkxDSHVBZE54b1paaXZFRXAzSVhqVUhTS2JHMnF4NjJHdDlKa0JUSUZwR2oy?=
 =?utf-8?B?M29yekZEWjhxY0l6NXhnKzV0NlNvOUwvUnVBc2dQelBndndQck1BUHRUMmpM?=
 =?utf-8?B?WFR0NzMwcUx3NGhmNnowL0prbHJlbXlKVzg4eTlYd1Bna0Q0dEdwYXNvTUxx?=
 =?utf-8?B?UmU3K1pHVGlIN1IxeCtlbWN2YkNiMjhBRDZvOE1MWGE0RmpCYmxPdHZRS1lw?=
 =?utf-8?B?REFMOHBvcWprT3FaUGpQSkR0eEZ5MXFNQ29obDNqSlNyUDg3R1dXOG55Sk5C?=
 =?utf-8?B?WitYVVZnOUtoYi9NWTlrYWlienBnRUxwUi9DREFYMnQ3eDVrRmIxUkpHNVJR?=
 =?utf-8?B?c1dMczNYU2ZUdlpPWFF4T1FzeUhWVVJOZmVNRnBxWDJ3MzByNHA2b2UvU05J?=
 =?utf-8?B?cEpmWDhIYUZvek9BbGY4SjJuSkFxL1lnaUF5aGNmOE5FWjRMSDhBNkxSOGI5?=
 =?utf-8?B?Y3QyelBPNjNOMGVwTHhRNmlnODFxcy9CNkN1b1RKUFY1bGVwTzlCM2J6VVFS?=
 =?utf-8?B?K3NFK29pSFR2c0t4bFBuc3p2cCtnNndHc3BIcHIyWEZFR3NGVSs1aU9ZemQ1?=
 =?utf-8?B?SVp6UGUrRTAvSjBqejFwaEE1Si9JOWx0a0pxbm1QM0FTU2VKSEtlaUh4emI2?=
 =?utf-8?B?SGVVancyeFVpRlhQeWEvOHlhY0NOZFJoRHlMZWFQREgvQ3g1RFYwVUZhYk5z?=
 =?utf-8?B?bGI0R1VoM3huMEovL0cvYzBTN1N1blBWSlVvSE1lNGc5RWw5ZCtZRzEwNnk2?=
 =?utf-8?B?QVVWSWlyczNBbDNRTW5RMGpkdjZSQXc5aktnMHI3UHVtLzBjNkZxUGFXN2Nz?=
 =?utf-8?B?SE5ZczZ6ay9leWVEbWhhNnNkdCtBam5hVmdSd1ptRVBUWmhweFBYR1didC92?=
 =?utf-8?B?d1I0cmMvSVkyOFZybzZET1dRcjc2VlNMa3Q4Q1BBaVpiRHpLQWhYVWYxTHA4?=
 =?utf-8?B?eHZFSHBzamVRcGdRL3lla1djWkF4cHBVaW1tSFR5clFuVmtjMzBaWkoxZGZO?=
 =?utf-8?B?by9JTHRHcGp3WG9NNGJ6OUFaSWhNNkc4UTl2RnY4OWVHcE0rZmhTczNVanNw?=
 =?utf-8?B?Q3puNUQ4V0dNM0dZTXNBOHVrVE1tYUhyeFlENTZwVFRwWHROaXQwenpKQjYx?=
 =?utf-8?B?cVp2eVc3SVNqOWxMeEZORUI0Vmg2ZnlsSWpLdXI3Z3RtajZUWHh1bG5MQ2J0?=
 =?utf-8?B?VWwrck5laGt2TGJKSUp2S0d3S2MxMkFhUnpHUzJEbG1OUFhjUVFzbHlDZktj?=
 =?utf-8?B?aUFTRktsRGZuT0EwcU9tRkpUVUgzc3hRcUVsTEZ2QjA0QkFocEVaRkgzVmVD?=
 =?utf-8?B?UmNmK2RQNjNkdVpYRzg3MGlTNnloTU9HVkZENll2ZkVkTlF4RlR5YzBoR0p1?=
 =?utf-8?B?enU3ZllyWEY5bHVnb2VWRFdaTXJWSnNDczB2UFZhZnFhWVpYNXJmSkpmMVpt?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 160db036-679e-4f8d-7738-08db3543f4f4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:36:59.4139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /U2vpqpZmIQJ47IQWYT+B/oBldhPytdVUwzQ5xOhqi9u1TpqqfOvOvoiIw7veFfqtGUF5vfVOmiolF/obgZg1qGF4CDFLvj1rXyntik+M0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6849
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/2023 9:29 PM, Simon Horman wrote:
> On Wed, Mar 29, 2023 at 07:03:58AM -0700, Pavan Kumar Linga wrote:
>> To further continue 'vport open', initialize all the resources
>> required for the interrupts. To start with, initialize the
>> queue vector indices with the ones received from the device
>> Control Plane. Now that all the TX and RX queues are initialized,
>> map the RX descriptor and buffer queues as well as TX completion
>> queues to the allocated vectors. Initialize and enable the napi
>> handler for the napi polling. Finally, request the IRQs for the
>> interrupt vectors from the stack and setup the interrupt handler.
>>
>> Once the interrupt init is done, send 'map queue vector', 'enable
>> queues' and 'enable vport' virtchnl messages to the CP to complete
>> the 'vport open' flow.
>>
>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> Spelling from me again.
> I think I'll stop there and just mention that you might want to consider
> adding ./checkpatch.pl --codespell to your CI.
> 
>

Thanks for pointing at the misspells. Fixed all of them by running 
codespell through all the patches. Changes will be part of the v2 
version. As suggested, will add the 'codespell' into the CI to catch any 
misspells in advance, during the code development.


>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
> 
> ...
> 
>> +/**
>> + * idpf_up_complete - Complete interface up sequence
>> + * @vport: virtual port strucutre
>> + *
>> + * Returns 0 on success, negative on failure.
>> + */
> 
> s/strucutre/structure/
> 
> ...

Thanks,
Pavan
