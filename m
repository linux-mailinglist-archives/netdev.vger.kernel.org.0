Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A46785E6
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjAWTNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjAWTNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:13:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270203AA2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674501223; x=1706037223;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dxXXEdHr/fZM1WOZMewK6nnes6ROQQTIQ3hzbQNQWQk=;
  b=YNNVePaaTXsoD9uujnHuY/zQu9XGa8n/TmsXRnoqDCd3HXD9TVi+TQjx
   1ybVF0NZ1zUQ7Jksowph6ADNDLt3HK22H9tL72V8qtijl6i0/rMUEy2Ra
   F9arD6RQX8Ujb61IvSuteb99M0IMz7inQY6B0J2gs/7wDms3udbfM47Cc
   Bsc0RJ1wAg/s1YfVQ7dDP5ImclRCjulj0xZZg/UzPqCzAd/HcSLX+S5Fw
   r4z08DvIkUbpiXM9I5aO6AKRDR0lpvC6phHfasAmRUgJznMgug5lEKP/l
   gTrxKU54Ff9MwxrMyPATgAUwNZtu8zmYW/2LPQoEtMRTxxprSeMiVlk/D
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="309701726"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="309701726"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 11:13:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="907206034"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="907206034"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jan 2023 11:13:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 11:13:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 23 Jan 2023 11:13:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 23 Jan 2023 11:13:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq8aU9zByMagmE2/i0d1x4QELpcTfRTc1VMELTApJWV6rI55qzKERbb/9FvuDGnrAnxDMOe+rGiQ9kJa3Mry+CEiguPfPzjpLoGmAwjN5FNSGLAn6cCXRoiovVxy8CHlBu1VHfLMU9iZWmnbpDtzfsZ0Oi/PXq1DkRzjFVDLMG95EudN+4T9+WJLatGLWFc2XJcSWJHGysbQDcnse3wigeg2CTxaeP28PLZu/w2p5NX5UK7rw8Rs88020XeLBRgmEgUtOG1W2evKFRu63GlKl6sj60uwpDff9farpLMNnOekfNpNQpiYTQWq43zGbg7x9yoP+zEgYyV5t1Rupq5NPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFJg7RABIyI/HZyAt9UlZ/qRATp4gQpsFSHtlNcsi1Q=;
 b=IL1LSrPn/wIrxiheg6xBEpO7x18NiRnFL7TXlWKYU6IObZ/48Mp1WtUeBFE1kpZxbnNQrLxZd5mt4fFWRuR+I7ErXTtKYNQl4DlG2AHue6pkCCIe8c8RTJpSmYSYCMs1TinOoK3v6yQbmNXZDaDp4p/O69G4AqARhTFSzW8vfTeH0pBogVNyAP1Mc6UeFe0B+/KLRS5Jf1UClT7KVPh9oYFqdPz1EdEZrAL6ZjkC5aSkS5/JdRlDGHwhpq6ete3MKUcrS33YQV1g3TAaLENkY+qaY0BVpsOb3E5kfnLusYNcXzj04cRlYlVLXWjMHiU9XAZCXFynkZS7I7TqXlQRUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 19:13:38 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 19:13:38 +0000
Message-ID: <14e5bddf-9071-55b9-a655-7ea9717d33b4@intel.com>
Date:   Mon, 23 Jan 2023 11:13:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
References: <87tu0luadz.fsf@nvidia.com> <20230119200343.2eb82899@kernel.org>
 <87pmb9u90j.fsf@nvidia.com> <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com> <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org> <87y1pt6qgc.fsf@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <87y1pt6qgc.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::41) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: 2663cfbb-ae74-4267-60fa-08dafd75ee4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HIbulScQS2b8qOyLnodFY8Jd/5etcq1H+Y+tBfyEpqRSwHfE7PpVP3rKvOr0cWiwEYWwTF0UiCcbRWb5y7y+nPkoSeeng0+MVomVuorEVvpurYQeL9BaYfDe3XBYzt5Od6xXHyqvXB+gw97NTbJtjn8OYQyGVFr509FUDNggpkbZEyianRRUOOHwG2YB99qMvGadUW9dSw/o+lovNg6rZpCmh5UBwORoOniR2Rv8qbZzNbKJJpayl2kDEQei9kXdISagtj3fe81DukS+g1XnzRUvFgpLct1ei6fyttuMrSkrKzl+aU8buNwEKt23uNi2CZ2mKwBruKa0lBl+bb/bg4tA9+m1xxVBoJgCflYqSFSLvNbcG8XpSTKcvNhg4mOkBrxeHduOejdocLAuMyWiGiZrPgS6883xuTlOsTDgh4kg0ERbnDo4JkYdRwrKfvnEpI6epLHU/pjxVPTIBz5JosbOqgV9Bb+eLtSjjDamWXQHuHAEuJNAemKpKnlMOuMFuWMJUzruA4Bot5PRYtvSKfa14XwwFH8ojw6ctsq+XQ4+V5QdoP8HLu0oyXGJ8GKE2vURgWeFNSsR4pc1L+BiQRoVnPSeaFLHFI0seUy+Zc/30vGaZ8z2e+rHWWftlXRfSx0PWZvupW8AMhccjTslrXdvqSnOxeGOwxIJxESkzATMIKrqHQGH3D6zp2/c1j6P6wynsrkKZANuirpSwybqwycO7hzSItEYRaoJ4Wn82I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(83380400001)(86362001)(31696002)(82960400001)(38100700002)(7416002)(2906002)(5660300002)(41300700001)(8936002)(4326008)(6506007)(6512007)(8676002)(53546011)(186003)(6666004)(66556008)(54906003)(66946007)(316002)(2616005)(6486002)(478600001)(110136005)(66476007)(26005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHNFUFNwdERkVXAwNGhTNEZkcU1CNDBiYnNGRU1kNGxTb09EUm9iYmxhVDBa?=
 =?utf-8?B?S3VFYm16QWZmbEtLUTBhdkd1RDhNTlJieUh5VnZYRjQrakFqYWVhMHRtSTFt?=
 =?utf-8?B?a3VWOUI0QytKRGZyckxjSGJ6eE5KSUVZanFFb1hqa3dCTVRWK1lNRlhBdDIz?=
 =?utf-8?B?QmEyejYwU1NoVVFDQ2JlMGNNNS9nNW43TmVhVERVbStTN3hxdU5hd0J5ZzlS?=
 =?utf-8?B?NFBHY1FPWkdFcXNmRFNPSlRqL1dmMTJYNmEzRlkraHhoM05DMHlQVisxN2lW?=
 =?utf-8?B?ME5IVWc5N3l1Ni9wdHVtOFlQUzFXWHFtN0UyQmRwbjFtSXpqNUFxWFVsVkZX?=
 =?utf-8?B?aHJVT3JzcXg2UHZlRU1HV3BIajFZZUpVSDJJSzY2VE9mT2pSRVRoMjdIUGxI?=
 =?utf-8?B?TGVyVVNGK3pjTUNPWTNaaFVmZFV5eWR5NDhkb0JEUEtPcHhiMmZlSjhneWxP?=
 =?utf-8?B?NkFnZGMrVElRbXJUU3R5YzBJKzd0cVA2K0hNK2tZS1g2c3FTWVdYcTRrT2xO?=
 =?utf-8?B?QXVCRENKNVhFRW9Bakp3UjdEeGdhdkJzdFN6aHZmazI0VllMaHdpa2RBQmlS?=
 =?utf-8?B?TE9lMjFxTkVWWjdVTnY2clNaMXFhcmRxbXduempXbHVka3hpZDhERVc3b0RC?=
 =?utf-8?B?VzRoRXZnK1R4RnhuTWVIVzNIQVV5blFySFJaS1plNEgzUzdpSE5PZVRuQWRQ?=
 =?utf-8?B?bm5BWGR3U2xDblpCdDFVK1dIaHhQcVplOEJZUjRlTkViNjk3U05vU0hZMEIx?=
 =?utf-8?B?QjRQTDhQSUFTckhGcHRNMzNHT2J6QkYwWjFqZS9aSmhvU3JjUHF6SlFCME4v?=
 =?utf-8?B?ZzkrdStWOEdVcEdkU1MvNnpkNUZvandzbnNlOE0xSzdrTFFjWVB2ZnFnN216?=
 =?utf-8?B?OSs4WWFRbGhFY1Fvb0hVcSs4L253aUFoL2JhNlg5MGlEUmYzSCs4RDZ3ZFRp?=
 =?utf-8?B?LzB1RXoycEIwbGdIT1ZlTFEwd3dTcTVqOU5HbDFkZ1FIbGtUbGl5RjNiNTg0?=
 =?utf-8?B?QUwzQk5jMkx5a05OUFVtRHVzaStTWEhjUHhrcFNoMGdiSWxRL0RvOHhpMlg5?=
 =?utf-8?B?WXpKY2IxRXlGZ04rYzFQaVMrWS9TSWpYb1ZaRDAxU0NhbkZKdzV3dkR0VTJx?=
 =?utf-8?B?UGxTQUxESElDYnZZZ0xSSW8xZXlrUkN1bkp2SktTTkk3bEJDOElrSHFnMVp5?=
 =?utf-8?B?clFoQVY4MTBTdHpIMFBtZHBwUTAwbDBUT0hmeDk5d3Z5ZU9tdms5Vm5YMDFt?=
 =?utf-8?B?K1RLMkVkTEdDa3ZzOW9ReTFLTDZKNlkzSFloVmtOWkF4a0wyWCtqT2hNVE5p?=
 =?utf-8?B?UHc4WHducFB3OWI3SzQra0U0RVBOODNBaTZOckU3NTN1eXhBYTltZTdSYWFs?=
 =?utf-8?B?cVRDRE5FdjZIekJvMWpQMUlPbFFTY0FuTHpWb1YwR2h3MUZMK21scXoxUENn?=
 =?utf-8?B?SjcrU0xTTVQ4TEY4WElOajNYbndINkg5a0Z0SlFyMVlSU1dXWW1DZFBVaTJE?=
 =?utf-8?B?dERTVTRnVzM2M2NPbGYwRFVZQzR1d3lud290Y2ZqWDhzYlpHRXFHUE8zOWZs?=
 =?utf-8?B?YWxtVXlmMWZocndqUHJ3VDJacDVJYTRXeGtiTlJnZHgzdVhuSWgxK1ZuL0Rj?=
 =?utf-8?B?Rk9veUMvNXJmcjNpOEZnTjVmblpqcHNNNUk2VUpGVTZUZ0lpOUNDZjAzaUc0?=
 =?utf-8?B?cDNPSkRJcUMxNUNja1pTK0dxUWNVVFMvUWNqU21NemI0MmlwYmJOZWZJVHJL?=
 =?utf-8?B?cCtubDhTc0RmSERWd1hGdjZWSmVUUENTUkxrSjloMmJpSkMwU0ZhM1lycUtk?=
 =?utf-8?B?ckhvak5GMG9iMy9DcDZXSEVRNmdEbC9hcWxQd2p1VUtSQW00bnh3c1RhU0lr?=
 =?utf-8?B?VWdjN2tPR0k1ak1hV2VOV0o5MWR1VVpmMXJ1TEhhTjFucWNUaWNaNGx4YnlM?=
 =?utf-8?B?b01JRFZoSmo1dFJOeENFQm9NVG1qcU9GZE9sWTJZS2J2N2JMK1o1a29BbTJq?=
 =?utf-8?B?a21PZjZXQnh4QStxL0gyakdlUjVhQlRoKy81b3hsak5OQlh4ZndyNndwOEJk?=
 =?utf-8?B?dW5iRS84NjlZRC84VVlZRDM2YkdhNWppN3c5WDlPeUx3eXVyeE1uclpGNC9u?=
 =?utf-8?B?RFRRSm1uSnEvdHNOTEY1ZG92ODlob0ltMTFVY3V2dUtDU2FJWnJGb3ZRU0hp?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2663cfbb-ae74-4267-60fa-08dafd75ee4c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 19:13:37.9673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqVADYcnPb0lIW9rpxweDRL5V2G+rMEukiHkFJ68M2d8h684De4iQrNTFT8PK11xlKIPPULax98hiXVU+oDe4wqQdhYslG5abiaBzNDYky8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5782
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2023 10:44 AM, Rahul Rameshbabu wrote:
> Thanks for the followup. Have a couple more questions.
> 
> On Sun, 22 Jan, 2023 18:58:48 -0800 Richard Cochran <richardcochran@gmail.com> wrote:
>> On Sun, Jan 22, 2023 at 06:48:49PM -0800, Rahul Rameshbabu wrote:
>>
>>> Another question then is can adjtime/ADJ_SETOFFSET make use of this
>>> servo implementation on the device or is there a strict expectation that
>>> adjtime/ADJ_SETOFFSET is purely a function that adds the offset to the
>>> current current time?
>>
>> ADJ_SETOFFSET == clock_settime.  Drivers should set the time
>> immediately.
>>
>>> If adjphase is implemented by a driver, should
>>> ADJ_SETOFFSET try to make use of it in the ptp stack if the offset
>>> provided is supported by the adjphase implementation?
>>
>> No.
>>
>>
>> BTW, as mentioned in the thread, the KernelDoc is really, really bad:
>>
>>  * @adjphase:  Adjusts the phase offset of the hardware clock.
>>  *             parameter delta: Desired change in nanoseconds.
>>
>> The change log is much better:
>>
>>     ptp: Add adjphase function to support phase offset control.
>>
>>     Adds adjust phase function to take advantage of a PHC
>>     clock's hardware filtering capability that uses phase offset
>>     control word instead of frequency offset control word.
>>
>> So the Kernel Doc should say something like:
>>
>>  * @adjphase:  Feeds the given phase offset into the hardware clock's servo.
>>  *             parameter delta: Measured phase offset in nanoseconds.
> 
> Questions based on the proposed doc change.
> 
> 1. Can the PHC servo change the frequency and not be expected to reset
>    it back to the frequency before the phase control word is issued? If
>    it's an expectation for the phase control word to reset the frequency
>    back, I think that needs to be updated in the comments as a
>    requirement.


My understanding from what Richard said is that .adjphase basically
offloads the entire servo and corrections to the hardware, and thus
would become responsible for maintaining the phase correction long term,
and callers would not use both .adjphase at the same time as .adjtime or
.adjfine

> 2. Is it expected that a PHC servo implementation has a fixed
>    configuration? In userspace servo implementations, configuration
>    parameters are supported. Would we need devlink parameters to support
>    configuring a PHC servo?
> 

I would assume some sort of parameter configuration, either via devlink
or something in the ptp_clock ecosystem if we get a device that has such
configuration?

>>
>> Thanks,
>> Richard
