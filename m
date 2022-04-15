Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4039E5030C8
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352331AbiDOU7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 16:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352342AbiDOU7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 16:59:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371655BF7;
        Fri, 15 Apr 2022 13:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650056197; x=1681592197;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J0A72hg7m2APRZS7xHjGjW//Ez40bEKzvZnHrW1j/PI=;
  b=k/R/TMB1RZBzFbCvgjrUeQkXVywWnBMhuBcRK7MqiP2hvg55rQsEtIZZ
   Y3WdlC/t9nO67mEIX3lRYKiQS2n9FocOqjnyOXEZDYovXuySOEkIoI65H
   J5517qNfAR1JaWtOMEttIPoi22yX/ACYPRyTXUf5ZOwbgoft0YRsnpcGG
   SPKAn2zyEV3J1V0URFGxU3T2ZZHuelwqmZyxjVjBBJnkdBFrSfmRTJmO2
   3m6V0Gg+p6dTSUvFI9K0iZ9EPyZtS77wIlGw2usqEFze4YpMElCKTMjnj
   a3IkFGGMvAOVp23zlLDZuq/mc0t0N2tYpxljbgcj0f3O981cDfdysjS+M
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="288295410"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="288295410"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 13:56:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="725914172"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 15 Apr 2022 13:56:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 13:56:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 13:56:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 13:56:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoSCdjmaF08qQjOOCVq68Jb/x2JtQMN0K+aMoPKQqTQyo/Fawgh6iWpFtcS598h/9443NnQTSLmJJQk5SsDTAnlJyzHA6dvIMZc+gwnZGYSV5BNmOTX1MgHeA/ZgqZNoXliKyIG4UI0o1anLhqwWhkSoJ3y6IP63O0q9V9IErfjJ+rMyoPsMHJ210DqfV9mKQ9hcK43Y9cK0YxR4VOT13Rf7iE6StV9qR9vaDMZSLh0tchZdIp0rXdahE6HZog4i194PMMaA+09pw0bzWT+fpwqZjV/1mQJJZXfzIXlq0GHbRdC0WEDp9fJmHWx5JXLI9OH/StCj+goHRuZTd+ms4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0A72hg7m2APRZS7xHjGjW//Ez40bEKzvZnHrW1j/PI=;
 b=NyLvdVtzOJKNlM59FNY5O4vxSqg5yjmqEKXwAebdV5mfzTl1FiG7nxDdmUHc1/vwzrfOj0TKQggou0sZ+58h/145Bn1beFC3hbcuqpT6PlRGb5OYAohN6MKWrbv8lczY5ncGEto617HIsFj6RporlqhRLIFg3NvxAVsEGlmSe1QUqmkX6pZMOXcOgSYicdeoVpVGVbtF/lqr6piXwK2Sgfrw5FpPL5MyJmOii76cZ6IaKqJVdbuf3wppu3uqmqOl08tNeYXUazVUad5GGJzbhJCSoFQD/K4EEmJ93y8Vcb2fT+AAjmEy93V7W2+/g2Fvu5GxJXcVlXCsHPU6WxnpbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN9PR11MB5337.namprd11.prod.outlook.com (2603:10b6:408:136::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 20:56:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354%7]) with mapi id 15.20.5164.019; Fri, 15 Apr 2022
 20:56:33 +0000
Message-ID: <5f4c6fe9-0b4b-5474-50a6-bf9a6bbc3b9f@intel.com>
Date:   Fri, 15 Apr 2022 13:56:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] ixgbe: Treat 1G Cu SFPs as 1G SX for X550EM
Content-Language: en-US
To:     Jeff Daly <jeffd@silicom-usa.com>, <intel-wired-lan@osuosl.org>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220414172020.22396-1-jeffd@silicom-usa.com>
 <20220414201329.27714-1-jeffd@silicom-usa.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220414201329.27714-1-jeffd@silicom-usa.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::29) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4631d38d-1c68-4552-94e2-08da1f226c65
X-MS-TrafficTypeDiagnostic: BN9PR11MB5337:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN9PR11MB533724A14BCA6094C3795C44C6EE9@BN9PR11MB5337.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G9IQcwCJsLVe0qYfwyMBHQpTw0lmMxsN3bZ1FVqzPTMzaBeyVs6h0SUUtWjbxtvJRGG4Jkw5H7GGR4fWetYk8C+o27NhNnyl5IK7xoFqSmZkBHqOvghyfWZDTDcNCHL8ghDgio+7ejezwcoHf66q62L3JUxYU+WQIpIdTs7jefQP3mPxriHa7Y2xLNJSNuDLYe1wTRXs9HMQ6HFtyBEdGpH9SLOoCAlho15ov8g0BOJ1ORCJVZAbLe+vIKj59KBw9Daj0W/HrnWhar3nih+tTgci65QSBG4H2z9RLiymmqK2WZJCsMfHs4+gYuVnZ+mj/sIP3tZJGMzKyf5uRDOFwxl/3j94kVWm9imVnV8B8tKkK225sBnkVsk24YU6El0ZrMR/XpqEyid8WmOaLku7PULhUnUEF8hUtG2LHHcEzHECV9lQBbjymVaZHem7d4mCnyn3bcnMS34x2eksIFRLRZ1dBhGWdf4iGpEyAUnQMfQKSJDUjYOGXcDuBSWZaaxZG0f5QmpCxAtbI9KqbhhAhz2Fh+qf02kOKQD9/3zNausn47mvlIZQ5c2fdiXnTLeaTVbQ6AJsuubMJZgZrpBUWoXO47POkYgLBCLvVeGCB05dMXgHIpTyU9UaHPlYNr9sPa7aNVSGW7xPUtuk6LSGDfDtYMBi6/+kjxzlZhCXy24Q8PHgEWD3SRkf+dqqp09jvZWvZ36pHY+0nxzhJc0CkkzqatUbSNqPwr0JGXZ6uM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(6486002)(6506007)(6512007)(26005)(38100700002)(508600001)(86362001)(53546011)(66946007)(2616005)(36756003)(66556008)(66476007)(31686004)(5660300002)(316002)(4744005)(54906003)(8676002)(186003)(8936002)(31696002)(2906002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWY5RVNNTTJ1RlBVYU10aHByYTI5OVdOVlRuamplWHM1T3BISjNmSm5yYjBU?=
 =?utf-8?B?Yk15Tmo4SDBSS3h2amFyaTdQeTZ6Zkcyald0N2syaHF6dDdObkNFTnU1R2o0?=
 =?utf-8?B?VjQ4bDRZV2dnbjRDalRQK09LVGRRRXordHJ6dThFTGljNUNlZDhlVjVweTA1?=
 =?utf-8?B?bkY1ZnduK3pFYk9PaElnT1NncFdMMk04emJ3Q3FIMnlxT2JIdzBYRjBZa0tM?=
 =?utf-8?B?NDhpQm5BTVpJVUIrM3Y3VTM1QnpCeldBVFNXY2NXbmYvT2hpQzU0SGhOWXB3?=
 =?utf-8?B?ejJiSGxGSW13cW1xNDFwK3J5WTY2U2k3M2U5bEt5VVdwVVJZemprR0dPb21V?=
 =?utf-8?B?ZXpRRFBHTURpMEhSYSs2Tjdnc25CQjFibmNpakZJRzcwUjNPZzZqZ2c4NGJ1?=
 =?utf-8?B?Q2c4NlZhYUYyWHRyQTJMcWExS1NUUXVLNGVkbERLTWNaZWhxWUJxcGI4aVJ1?=
 =?utf-8?B?M2VIM3ozOGw2WXZDREJJeDBLYUQ0emFBbnEvR1lSSVNRbkFjem9YWVM3MFV3?=
 =?utf-8?B?VzZTTXg4aTdCa0NOSk1ZUDNRUDBGZ3dyRk04bm9aZ2orT1RtdFZXdm5MdnVJ?=
 =?utf-8?B?NC9SMDB5V1lFZEZ5Nzl2ZzNuSmN1dXBtaXlOU1Nod1ZMSVd5S2RJRlB4Tk55?=
 =?utf-8?B?TW83alpOWUl0b0VUMDRYcFplN0E1WE9RY3FMVHJwQWR2TlNtS0FmRENtdzB4?=
 =?utf-8?B?N1U3d3ZhQytPSG9IcGRvN3IvcHFBaHlJbVdsOGhtczVPZmZUSWZDaUpPVEJQ?=
 =?utf-8?B?YlBKTitZM3RYZjVTMU1CNEVkMXI2aTN6NTNXTHkvK2Z4cXd0b2tXejNnNjVC?=
 =?utf-8?B?cmFIOWdIQVl6ekJlUVRIaTAwd29RUXQyMjl1QXlqaU9CcDJ3Vnk1WU9vTVBz?=
 =?utf-8?B?SWVQYUlrcmxreHBIOFcvbTFOVUM1cFNkYmZnQ3Era2pHUEZkYzEzLy9JYUo4?=
 =?utf-8?B?L3hIbWl5SGNrRFpPS0YyNHlQTWVJOWN6YUdrMnJQdlNBYWc4RVNhTjRwbEUv?=
 =?utf-8?B?c1BZdVZoM1ZEMDVvdWhuL2pYWjdZL3ZhaDcySmJDZnVxZDZXOGl4Y1NHSHM4?=
 =?utf-8?B?L0JqbFI1K0NWTTc2dnVvUDlneElWSmxkLzcvaWp4QnBYcXVLRWxiVm1tVUw3?=
 =?utf-8?B?d1ZsbWEwSDFWbWhjdElweXkzcFZUNUVNQWZIZHlxSWhERVRiL1VVVW9BQnFk?=
 =?utf-8?B?c0Y0ZTlqQU9KWm96dnpwYjl5S0N6cEdQc29uWFV3YzA0NjF5VXUwQ3BBZzAx?=
 =?utf-8?B?STMxYVBaVjArZ1FLczFnd2FZVTdoUktoY0JMajRCSnkxS0Q2T0syTG96UGRH?=
 =?utf-8?B?TGhMdlRKSGZib1FGMUs1Qm0xZG5sc0FlQ3oxaE1BTldhSzBqVktadlBuL3BO?=
 =?utf-8?B?dWtSZTRQbTlpbGJFbGFUbXFnckFTVkFkS0FrZHVMQU9uMFVzVWRKamxtSFBN?=
 =?utf-8?B?ck1zZFlmK0xoMGVDNG9TUUlXcGlxVi81a0Z3OTBsQ0JQd1BHMFZzQnRsT2dL?=
 =?utf-8?B?QmhmUnhzQ3dTYS9uRU9zTnlhR2Q4MVoxWFhneTl1cm5pZnVSWmZvOUpKd1R3?=
 =?utf-8?B?Yjdvd0FaVWJGQ0ZpdWZvTE1SNk9UU0Q1YXBhLzE1SVVRdC81ZVYzSE84bzRu?=
 =?utf-8?B?SFJvL3dTSzM5dmtYUUkyTkFtdEF5eSs1RGU4bnBzNHZqbFFuSkN2WitsRXdO?=
 =?utf-8?B?blV0Nyt1b256VDFnN2VEVFI4R3ZiaFBHa3Y3a2U2bkU3UjF4QnNIdFR6ZnVa?=
 =?utf-8?B?R0JrZUQyNjFZYUdzK0N1MFg0Rk9yaDdGVG5zT3ltRDlubkJublNCNzFMRklF?=
 =?utf-8?B?VlJ1SDQ1TUtJMENOMTZ5Smh5bWMvbkdKaXltMmd4MERwc0l6M05lWEl0em1h?=
 =?utf-8?B?eDQ5WjlreHU2WkhOT3AvS21tYlg0dEhvQ0dtMWpWUFBhR3hNYi9VaDZnTzJB?=
 =?utf-8?B?T2VLSEtjR1czWlFaUWlsY3hYSlJWeE4rUnhHWHgxZHFDRTlDaTRXalo2TjVG?=
 =?utf-8?B?NkpFTElXdEE5cW54UUR4Y3ZET1Y2dWZzNVlSdk5qRnZrL3pkZTJTT2ZPclY4?=
 =?utf-8?B?OFB2M3ZxRWQydnRlaTYzMVRKSW1OSllYU0xXK0R0YWlaclhpa1hZMmNGZWxB?=
 =?utf-8?B?bXRNaWVRM3dRcGdDQTRFeVZWMW8ydS9OMXRBajhpemxMVkRLQW5oRkhlZ2Fo?=
 =?utf-8?B?YitIdWkzcm51alI5aEwrSkJKYzgxMGZlK2pqWG1xSWhCWUpOYTc0dnI2RC84?=
 =?utf-8?B?VjhGRG1QemxjMGNpK1JPZm1KZmZISmpKa2IvbC9jSThKYUJsaFRpMHhtSEtI?=
 =?utf-8?B?VC9ybEVwWjB0MENIVkExNjhiTm9KNVRTeXlkL0FLQ2RKelhoWVA4N0d0aGov?=
 =?utf-8?Q?8AKfjitBxetBVFYs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4631d38d-1c68-4552-94e2-08da1f226c65
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 20:56:33.5854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVq+/2l6nSyEnnwALUYJIvRUvW4fVyxKQ2/0XdNJpXRExR3OKlXHjYj1EnCrT4TK4yH4yO7wJ5KHkex/WN0HOdLoFVfsufLqA96BPFhi0YI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5337
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/14/2022 1:13 PM, Jeff Daly wrote:
> X550EM NICs do not support 1G Cu SFPs by default from Intel, this patch
> enables treating these SFPs as 1G SX SFPs via a module parameter similar to
> the parameter that allows the driver to be able to recognize unsupported
> (by Intel) SFPs.

The addition of new module parameters is no longer allowed.

Thanks,

Tony

> Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
>
