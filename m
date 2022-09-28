Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7635EDC0D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiI1Lx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbiI1Lxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:53:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CC65E563
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664366034; x=1695902034;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZoAzU1h6SDVO0KRm6fxVlnMiX2HiWe2PhRZkPWOJ+X4=;
  b=Ql9TbrbTAl6UNw58Wn3HX7swIFiUTo7h9gdcLBeS8aQV9tJndMPzskNS
   YDz75Xp104z+CCqw2oalPVFBruugZ9XXmpAgyz+vib+TD46m+K0hj5Xyt
   sMJR/O+XqBkxdRzdwGhzDGHjP/iQaqAHi18sSSWGX8cFqB/o/MTl0bubf
   6G88BXxOlkv0NOjo6vntVJyE2TLj7HmQ78v7jh9FSr5i613wM3xUCE9Lt
   oU2X7GmdaapDWYvklbxgV8nqnNDHMbe6btb+nYBaNh2pY5QXU8aahlvrX
   UoZIhTpTPZQ2tQHaODU+08xiePScnKNHLlUFvmTOtb4U5nqXdbqyjbo6v
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="302492237"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="302492237"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:53:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="725920611"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="725920611"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2022 04:53:33 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 04:53:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 04:53:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 04:53:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLNz01pF2ZWfqkEIYbiINEYGojGzYugDlgE+0KZyovZKktBI4dxy318NERHJWhSCrNHvaF+ygioacGFhIXWFQwWZN7ZO82fNTo7c9gkQYzBe1l8354aiLmua3vVUUqZWQdaD8b4XhW0+fSQwR9EFgiuqRs6BZ3JIim31nOMVYUX0fIdXkAxNLofx7/j0WcQkb8fvXRNKWUhTvHMGN4laH51/yyIfn2RZsmujE2AKPwkE1Oy5UwpqMXs6brwZYj3wyzweoj7JLRKnYDstzuwpziHYpNPYaf59fV8pvbh98DMc7Ut7LbA2ucT+ShxdJ7Tajq7B3P9YJITNqVsUDOMlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZkYb16Vyb2vUZ8gaiyXhCkegI2jzefsj6tiR2M/cvI=;
 b=YP3H6Pq8RCR4WohF1AV+3SpXpLJE0WxMaESM2cxyaKzdRBrq3XdMludEJBUImLd9sl1fTf+3LUrRmFgZPVWUgxWx04mgqhdkUmJp//7SkBX1FBo/hT4W58oN0XOcYUibeqpXN2iA9qmNLIG+SYuui1ZGNrlvFJrVGrX0CwE6kFfWFa20cmb5vzQTIV/l7mYw91OIbaiWQerI1WjmhNT1nWJtyT3IZYD9OeQ7QI6R2NT+Zto4Bgk4D9x466+egu3cWJF5nkHVWMqbj9kHOUx5TWyqSiZrJH25yxz9GGCqJZiAfuE8Eisq3rkjGdgwX3UyUy5hzmXnD8SJlN/JzVn+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM4PR11MB7399.namprd11.prod.outlook.com (2603:10b6:8:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 11:53:31 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%5]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 11:53:31 +0000
Message-ID: <c89ce464-4374-a3c3-3f58-727a913af870@intel.com>
Date:   Wed, 28 Sep 2022 13:53:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <dchumak@nvidia.com>, <maximmi@nvidia.com>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
 <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
 <24690f01-5a4b-840b-52b7-bdc0e6b9376a@gmail.com>
 <YzGT98W0+Pzhahl8@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <YzGT98W0+Pzhahl8@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::11) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM4PR11MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: 27754f90-7a4c-4804-4cd4-08daa1481026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2a5CjAc3It6pgeSwGAPfpkA5g88UqNM1kuCEClbbDB8crcrf2PBfstV2bHwQvtf3DIC7xdQJ531FjORD4QN2yTo1kxm+G3zUDaVlO/YPwjGrXhLuhAil6LEUvtxVvTJoQDGp+FPKL88XpZHhpnBrPMnwlMGVMvB05thWORZ7f3plKU9EspMuQw3ByyRxUKUKR3sjjc8cWuVnbYas/84iV7QmBD0B+vRfdXnQZeUiufh6HUGUUEN9tUTPLJFG7orv6KwJeZbv5Fb00h7OFc0b3r0sLRJ7OrNqUZxnERuUWR7U1K5sYaOeLSqXQxjsoFKiwLO2hpaospMIsZwdA7xHM25y9gVWCXyx+hOK1L+E3bAzIrygHGCf/mxZ69VoNWhU5vELt0VgwMfpo9MqqSQqNvm4fz99N/fjy8Q2KS5yMHWjBHlPuLxNYGO3PQ7e9hIp6SW0TiGKUi7Fsb8Xp3hcrZNX/47eGoTuC/SEE5rL6rlwoDpSLHZjmmWzO4MlKdULD8ABWKodPknq6PgDkIzjjuZC7Oy5BbonPIiPSLIw81+b6Qy+mwt4yRYza6ugPpwS3ns0MzZHmZLcQs9g1ZEnNl2gfTCnh1I1SwXUZKn7zQmiBQVzYs71MgQ7j4rAcZ22vTfUifgwQDrZn9ntC8NHKINWrnWbqz+eHTF7ns+8e1TSUtSgzE98Y86TSQOsgXSj3tKIQgmECcElUGiCvqFVw64HRwXiVBfay4KspgG3+YS+spTyv+5KMf/HBW8q94PMnu2q6J8z4rrspuXwsiXC1c6+LyRt1RsdEZcy010Qhdc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(478600001)(6486002)(31686004)(53546011)(66899015)(6506007)(107886003)(6666004)(110136005)(186003)(316002)(2616005)(2906002)(83380400001)(38100700002)(6512007)(26005)(36756003)(41300700001)(8676002)(4326008)(66946007)(31696002)(66556008)(8936002)(82960400001)(86362001)(5660300002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWl5Wm55RUUwcHJPRG1TcERjZ3R0blF4bHRYR1p4MUtISG5CV2NhNWpiRHps?=
 =?utf-8?B?SE5QamwwNEV5My8zTnhTdXY3OGdFdnVjaElGcjhHTWxVd3pvcS9iYmVndi9H?=
 =?utf-8?B?VHdPUFMvQ1pFcFRjLytoTkh3RWVCelJudU9XajNWZGxzeVR0R1lONzhUWjN4?=
 =?utf-8?B?cVNUKy82ZTg0TVFLcnBxMTZ2MXJZeldJWUhYLzBvcmtpNTgwdnNCK0NPN255?=
 =?utf-8?B?cUpiWFo1NHhBQnJQUzREdFNMR0IyOWtESXZOeDI4a2pYL1BmQkVkd2NsL3Jw?=
 =?utf-8?B?R29yUlc1MnVzcEVsUE5vOHpBcndoZ0RyMWlFMU5FM2krOW9EQ2FDakk5S0pB?=
 =?utf-8?B?YlE4M0NyNDVXRE9xay9DNjNGU211YnJkYTlUV1lkaEZkQmpGV3o0eFJKRkxz?=
 =?utf-8?B?UDFia0pZK3lkeGkyL29IWkt2dGF6OG1YOXB3eDlRNkw4amNoK0xpMHZRbE9r?=
 =?utf-8?B?TXJGb2VqdUhWUFF0aE5CNGpiSE8vYVpWbXBrMkc4RTZXYVRLNHpMY2ZabDVZ?=
 =?utf-8?B?QWtMWExydm8waDZqN2REYldzeVZaY2tyTFc1eEJHb0pseElyaGpsSjEyWkZ5?=
 =?utf-8?B?UnJoOEsvVlJPRW1HMWlMUzhyQ1pnUnlKUXRKaEdQT1N3UTY4d2VRQ3BhSWUv?=
 =?utf-8?B?MkU4ajdPRFdRUElsdHZLVjhXZDFaY1F1UG5HTi9EYXNsOTg1d3RUVWpid2Jz?=
 =?utf-8?B?RUpHaVNDbm9hWCtZWXVjMWtHN1diaGJpWGZPOU1WV1lYZzg2WjJFcFh1SDNF?=
 =?utf-8?B?TFJBQ3R4Y1hlQjhvZ20wMjRKdk5LU3FpU1JHcHhQMEdIN3ZSeDMrRWVSMFZk?=
 =?utf-8?B?NnBwbzM1REJ4MEZxbEIyV2Q3OHBKeW1vZ2ZBTG9KUjRBYUhzMnhpdldTNGFW?=
 =?utf-8?B?MDJnWUVEc2tlcGFZYUNRcjZNaVlSZU1GY2gyM2w3L1dTbTJCaVVFSDBqQXlU?=
 =?utf-8?B?TDZtaUlWWitzejRjUWhNMmFoMktlem5WbHhGWWJiZE9ES0RFS2hTV3ZFcU9J?=
 =?utf-8?B?SWpiemVzK20yRDBDcVpidTQyR0gxL1FYZWd6cjRoQVp5TllZQmhjK0Iwck90?=
 =?utf-8?B?YlJTdzU0NkVyK1R6MXBrOU1zWHVjeXFveWRtZHI0VnI2WkJDZ2luYVNobHpR?=
 =?utf-8?B?YWlKK0lyZEgxNG5aa0c3Rko5dnozNjFNeitYdHZPcXk2YkdTcmdzdGJXcFBB?=
 =?utf-8?B?MmJ1dC9KRFR2NlRRbEF0QU1DejI3UFpOdjRKMXlSUHg3TVV6U2pzaXVYekhM?=
 =?utf-8?B?NWpKVytjSHpzZlhqb0NZNkg2cDZETUd2aVl3M2dnR1BJcFNMS2VjdHpnNm5X?=
 =?utf-8?B?eGJKSUJXSHgraDhnVG9nNUlpcWorTFQxcW1KWmpVbFN0UkR4OEdaQ2huM2hP?=
 =?utf-8?B?K1JUWFhoQXU0TVFzZzI0NHBXUzFHUGY0YTBmVEtXTTdkaUJBTW9uTVRiREdq?=
 =?utf-8?B?Qy9aZFhkaHpidFNFWm9zaUJtZEpxWElnbUs4SlBkUmxTU2w1SFZVN1k2MVJE?=
 =?utf-8?B?bmJLbENKbmdvUUZhTEVuN1hQakRhRnh4c0xxcEZqR3pIUUg4WGlvMy85c1JV?=
 =?utf-8?B?WllBdEp6bnYzS1hLRXRFSTUyNXVZRzFDb1ArYzQzSTc1MGFOc1BTcVloUmla?=
 =?utf-8?B?dzVySGhjNS9tS3dsOG1aWXBZa2RjVnZqNFYxTGNWSUxmeE5VdWxrcDNmdzJW?=
 =?utf-8?B?ejA1UHd4cXh3K0NlWENzY1BEVzRzajV3TDhUT2pleDl6VkgycDNsVHFxVjFV?=
 =?utf-8?B?MmVLd1gvbmlYczJuMStJRkpPanJ4eklCV2hEak5Jb0lDQTB6b2NQN2hJQllD?=
 =?utf-8?B?MnhPWWUrdzE0dGV3bjNqeWVpVC9CMGpXQTJiZWZZYXVGNGJtd3FUZGFLUFNx?=
 =?utf-8?B?VUxWM3k0RGJQa3c5bzNvTTBDY3hLdHpTbTh1cy9XY0JBeThCWVdHV3d0TzN2?=
 =?utf-8?B?eEJiN3gyWGVMMURWTjIrTXlZRDF4NDI4bFdiMEhpZXlnVDJXbVBQUGNFdmFB?=
 =?utf-8?B?R0NyY3ZqRlRLQzZRNE9lNTI2L1VydnlJbnpsUzhvVnJXWFZ2QVVYV0VnUDlE?=
 =?utf-8?B?cHIvcmdaaUhtLytSNlh0Z3gzZVozTW96akRaUHJEYVdIclREaE01cTFrZmRI?=
 =?utf-8?B?SFpxQm1hTjROOHMrZ0VhU0NoQmJ2UC9VdVl0bHRkQ0x1aGVFNXh5WENkOW9L?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27754f90-7a4c-4804-4cd4-08daa1481026
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 11:53:30.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esyowJtOULXBm6V5MlNIxle6p5x0fKolIm6N4wIdpCNcQMJFYmQ0BWwVStZ3DzK8r/BNfS7MSFRjhHP3BFBccK9pLP5STRBEErA4XtHdpyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7399
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/2022 1:58 PM, Jiri Pirko wrote:
> Tue, Sep 20, 2022 at 01:09:04PM CEST, ecree.xilinx@gmail.com wrote:
>> On 19/09/2022 14:12, Wilczynski, Michal wrote:
>>> Maybe a switchdev case would be a good parallel here. When you enable switchdev, you get port representors on
>>> the host for each VF that is already attached to the VM. Something that gives the host power to configure
>>> netdev that it doesn't 'own'. So it seems to me like giving user more power to configure things from the host
> Well, not really. It gives the user on hypervisor possibility
> to configure the eswitch vport side. The other side of the wire, which
> is in VM, is autonomous.

Frankly speaking the VM is still free to assign traffic to queues as before,
I guess the networking card scheduling algorithm will just drain those
queues at different pace.

>
>
>>> is acceptable.
>> Right that's the thing though: I instinctively Want this to be done
>> through representors somehow, because it _looks_ like it ought to
>> be scoped to a single netdev; but that forces the hierarchy to
>> respect netdev boundaries which as we've discussed is an unwelcome
>> limitation.
> Why exacly? Do you want to share a single queue between multiple vport?
> Or what exactly would the the usecase where you hit the limitation?

Like you've noticed in previous comment traffic is assigned from inside 
the VM,
this tree simply represents scheduling algorithm in the HW i.e how fast 
the card
will drain from each queue. So if you have a queue carrying real-time data,
and the rest carrying bulk, you might want to prioritze real-time data
it i.e put it on a completely different branch on the scheduling tree.

BR,
Michał

>
>
>>> In my mind this is a device-wide configuration, since the ice driver registers each port as a separate pci device.
>>> And each of this devices have their own hardware Tx Scheduler tree global to that port. Queues that we're
>>> discussing are actually hardware queues, and are identified by hardware assigned txq_id.
>> In general, hardware being a single unit at the device level does
>> not necessarily mean its configuration should be device-wide.
>> For instance, in many NICs each port has a single hardware v-switch,
>> but we do not have some kind of "devlink filter" API to program it
>> directly.  Instead we attach TC rules to _many_ netdevs, and driver
>> code transforms and combines these to program the unitary device.
>> "device-wide configuration" originally meant things like firmware
>> version or operating mode (legacy vs. switchdev) that do not relate
>> directly to netdevs.
>>
>> But I agree with you that your approach is the "least evil method";
>> if properly explained and documented then I don't have any
>> remaining objection to your patch, despite that I'm continuing to
>> take the opportunity to proselytise for "reprs >> devlink" ;)
>>
>> -ed

