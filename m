Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB46E4E3C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjDQQZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQQY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:24:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CA2A26D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681748697; x=1713284697;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MyTdExU42ZQXsVIZrH3L5r6DnLwCEhyarr4jE0cQvLE=;
  b=gsNdykOaYE87md5iOo6X036UWfCUtAvelOtr2Xg14AUQlQh26dT4CTah
   PDxjPRcnI6Vn4udAqV1eV1W0pUiE3YoWfXMIHEZaPJGI40gjX113X8dpv
   bo5kuLrPSiMMRT0K8y99lYtzHn9lPsElgAq+d59Sea/0/Dn8KYgQnFjfo
   TldwMMjsqC0kO7oa7u/Y+Ruc7GUh8s9QVOyexp36CxWmDrnnc9G0s7ALE
   EOXWUHq6xqR17GNbEuXb070/6bVZdnDC416TlaIoAoPn6yYBHM5RUzebS
   k8Z3FQyTe1T3Eq0PMPsF4IY6k716uwuIoGQPanFsPl0m5OkJ7ruZ/LGld
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="347678808"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="347678808"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 09:24:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="834504827"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="834504827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2023 09:24:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 09:24:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 09:24:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 09:24:56 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 09:24:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P07DFD30wTdoZsiLoLAc6EFp1AsFyMM4Hq67CffnBEPWpJ0lVr8CTgQs/24CIVJAwrhHRKaEYRV6gzmuYGLEWQcOhKaXaE6f3yD6lkqw6jvnQW5t/pJOr2RcGSMJKFchczJTeP3EvcD9MsdCYoDvdFZ2ngfFnlgMoqmuM/Hocgob6ZA0kUXPRGIwgA/VSrInunxTC9UBIIqxxi3ANVjnGJ98ho4S9tGtvM4kjovgflL1/dhE9MCtj7J+7vRdu6hbSCRhwz33rPTGY+c8+/vmuHFXWFUBPrcVcWDnNw++EgndF2pmwZAL2IIdogb+82U6p1EGWsa7OC0ZYd5+ecHtzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+sAY2+3Vh3MR8wSpbHq9ab+TNQTQRC3+jJ4Snil7Xr4=;
 b=SshAYkEqSnC/wwG+4wLPZWcaRwhepQg+rrgL8A65TaaoxSw1UzmdtN2j2ZlTq35GXPPVynnPcCgnzkQMwR6kuzapH473X3AAuIyNLQqPxcmEW4+hae8zCsZ7U7Bi8em1h1ghxOrca46y5fCr86A6VlBM10jgbSps4gXSXYBKIiBkKTkRaYCCeuC4tc0JcrMopxA+FuXGeu6lFaJ7rq/TO5rBA5YrAbLv4VtwDvpku4uJlnKr2Hech58OqnEK1AOH54XYsTapoLxqXOMtnWVwVeVa6TTCYXiDnvUKzX79UPZO+iCc8cr0LXBYGh6iLWKYf8QCsFC2VwUUudD+n4d2pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 16:24:54 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47%3]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 16:24:54 +0000
Message-ID: <58a3b5b5-a980-5072-78c8-6e050098f1d9@intel.com>
Date:   Mon, 17 Apr 2023 09:24:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] ice: document RDMA devlink parameters
To:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
CC:     <netdev@vger.kernel.org>
References: <20230414162614.571861-1-jacob.e.keller@intel.com>
 <20230414181850.74279da4@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230414181850.74279da4@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::18) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: b3812e44-5ddb-4c20-4cdc-08db3f6046b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRpUqSyy1RbkxZ3MmvNUC7byXUg8bhJNWXOowRx72NgqLrJL5sRLkccrV89Fhh3K72sAyVKrOAjqRYINci8F/7PYUzMsjVlHni/lnXMEmol+RjVhtrmAQEtAUl+chmdNuZBoj6SFip+BgH/HUDJbpijmToDwRPLPUXHm6KEJLBFbANaa+rHeqFUuL/Mo7Mp/xJSoybwgze4H4SxB9qa2EfroYGJs2LcDTDjw/jrXr8lZnzWYE6x3rcqF+yES9/vqJ0knDSG46gTOvlsZSoIPIA8DH76z5zFZWh9rcm9jfHxP2TtR8V283lNQCSdSTAxCZEuY450bg9sXczKuMGZq98BzcDOev1x+bjER8tGXjrYn0kox3wdhS+pC0hdjFdFdTVzmR3r3S9TTYdG8VlTaMHE07mJEUYPO7uHFXkfLakL5dNzzLEa14TKHLaulFhyxZHO+OrImI9FmYA8aXbxnWqbc9yN8YmRQ2hUiArqTmR8DYlmU3SMWDk+PqcMPMFnZNet531Bx/GJr691gy1PVoIzLR8GjNbGZ9JhcHMP2+BdrSNHA2rATuHJUZC2wsQf5U4T1g63MDMWE/i2Bw0bbp/tD9V2Xrc71L1kEuNiQbqR/RBwqpmXotNZa1QsPBOB3l8hiztCFpGZEkA1q01B8KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199021)(53546011)(26005)(186003)(6506007)(6512007)(41300700001)(110136005)(6636002)(86362001)(2616005)(83380400001)(316002)(4326008)(31696002)(66946007)(66476007)(66556008)(2906002)(4744005)(8676002)(8936002)(6486002)(6666004)(82960400001)(31686004)(38100700002)(36756003)(5660300002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anFURkJ6clRJRURuczRIcy9ncG5VYzV6UldiYnFpY3I0QlFvbmFxV085ZGp2?=
 =?utf-8?B?dmEwUHIxSkxNNFc5TDRvb3FrK3V3U3ExdVhqQ1FPcXlZZG95Vy9KajY2aldU?=
 =?utf-8?B?Vm9BTTZBemdGNmFXbEowblhVRHFGY2RDSlVlam1zR011SE5UTythQldmVEww?=
 =?utf-8?B?M2lVMGpKRkhZYm11ZDdUZkMzekJ5VGVjMHpxUk1uNGJmMEFSR0s0SzI4aTBZ?=
 =?utf-8?B?OVYrTEZqUGZGRnBpRXovVHdLbnAvREVCWFNBYmJXTEtpZjVyeXRkb0szTHA3?=
 =?utf-8?B?eW1YWlhYb2FaNVBkRkpQSmRVaHVZZVI3Y3h1NldMZ0RRaTY3RHZFNnZrdFc4?=
 =?utf-8?B?TEM4ZlBmblRxM1QxMENpc0FUdWU3TXE3MFdzT2NMeVBoVDl3M0VCK3ZIRzhU?=
 =?utf-8?B?Skt6SWJIY2lNL1N3SjlBeVl2ZFlOVTlOOHgzNks4MU5pWWRTUjlBM09TVEty?=
 =?utf-8?B?anNsdEtLeSsvYmtVcnAxeGVSNmpzbDhzQ2phK20wWEE0RmZGVjRod3lYaFJJ?=
 =?utf-8?B?QTlPYWFMSkRIQXhvZUtSSnJadXJBSi9GMUQrQVRPa3Nmd0dRN0kweXIydXF1?=
 =?utf-8?B?NEk4NjZIU2p6dVo4RkVnWlBubzRqWWkybmdzRCthWC9xS1VHbWpka1h4Yk5O?=
 =?utf-8?B?QlFIaytGd3ZzdjZtVGtDcldqQk9LQlpTTG1zTlVJd2E3dlZDYmNhZEhwREEv?=
 =?utf-8?B?bUdOMXAvNTFMbjVCTFVYOGJNUjNIQTVjYURIUGZtYi90bTJxbFZWa0J0ZlF6?=
 =?utf-8?B?NnhlWjVDMVErNlMwem9uRFNpa0IvVlFTWkhlYTg2SlJrQWJ5LzQraVR2blR2?=
 =?utf-8?B?S1R2VUhYWi94bWFSSGZJUlpTSm9BYUtuNnFzWVV3NldiVHNBSksxdXo4R3hx?=
 =?utf-8?B?WHRycCtyaUs4djV4U1VHdDFQeVRTdjVVOGVhMkluaDBDR0lCUEErQyszQ2hK?=
 =?utf-8?B?ZmVOOERLTmFQUmcyTXZoVmV1b2JEOEU0T1drcVJhMHNhcjk4ZUtDNXh0UFFZ?=
 =?utf-8?B?b1NtZGkwcXBCQVB2OUVIbG1JaHRWMWFVcGdGMGxOV0F1bWcyTjVDeXNtMlc4?=
 =?utf-8?B?V2ZpY3hNTGpHTmpnc1pMdzdrd2hHa0Y4Y1owMUxzODZ4dlpoMUgyQXhrbUdC?=
 =?utf-8?B?alduT1Fxc1BpL2RZRmYzMFF1R1U0dGxCUjRLTGRLUzFSVnRucWNjU0RsSkhY?=
 =?utf-8?B?N3hDUEZhMVNJTWN3U2trOXRxR1pqMnYrOFBpd3lNZDNvb1o0RVR2TVJKejRF?=
 =?utf-8?B?VVVZSmgxMHpIQWxrc3A3eFZMeXBtK1dnYmdZTUpDNEpKOEw0R2pDQ0drb1ls?=
 =?utf-8?B?enh2RUZOR1pXdzZ3OUh0MlRxVnVNNktySlJTS1pVa2hGVXk3MW16cS9DUk5r?=
 =?utf-8?B?Nml5dHhCeDd5T0R2UlpTQ0cxRlg2c2RjdUFpeHVUL1RhS0ZlaDdwOWlOMkEx?=
 =?utf-8?B?TEsvb0R3cmdSNlE3Nm9CS0QwYnA3U05uWVBBY2tBbDRUekJFRmFVSWxCV2Z1?=
 =?utf-8?B?bUs4Tkh4Y0FFNTZWcmgvQ2szanAyQXZ4SGQ5WlpuOS9sR0YwMjQ0bDF2aTlY?=
 =?utf-8?B?NEVrcGhjVjNOanEramF0bE0xVVJpT0NEcDZ6YmZCeHJpcTNXZGhFOFhSNC9p?=
 =?utf-8?B?bHVCRHYyaldMN1NCNkJrRUV4YmlkRURlcmdTYXJTZlFFdmxKTmd6cExyVHc1?=
 =?utf-8?B?cU5hUW1kUkhaYnA5UkVueVR4d1E1ZXR0TTNGczJlQTRtRmxabC9LTVdseTAr?=
 =?utf-8?B?YVdZR3Ric2ljY1FwZCtua084MHBGRlZuOE4xWURaVEc5Rm5tVXVlSjhDUG42?=
 =?utf-8?B?T3NlRmd6Yk1QRVBGZ2d5a1JoUHU2U3gwQ2JuNUMxWDBjQ2JxZnRCbWtkZUpF?=
 =?utf-8?B?OVdEUEYzSUZNelhxaldTZDI3UERsajBKRzZhTVNWS2NvM2tER1FmMjlKQ1NX?=
 =?utf-8?B?cE9BZTdVWHJ5VW9JWmp5bysvSGdzdmpOSUdjSFdnMU5OZFRHUzBHdVNtb0pk?=
 =?utf-8?B?dERSVVl1blY4WXRZbEY1OTdoTTcvRWxWSXBlQkVtYThNbVFwc0pueWMyZkFh?=
 =?utf-8?B?cEo1cktLM2M4T0J2dENqK0NWOFh5Z3ZmS1pEMXdrc2tHUGhkaDVVcXFCMjMw?=
 =?utf-8?B?NTFJUzNmb3hISWdlODNSRWxFeGV4TmlYQTQvb0E0NW5sTlU1OUdyWjdSTGU4?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3812e44-5ddb-4c20-4cdc-08db3f6046b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 16:24:54.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsFPeopt9of5cd3zw+tk3B7Y4IYhOD2aZeV9S55i4rvbKpdk7dArmnUzxiNXLv/dkAVJEbC8rWkbsxbKUL2O+q7M2/G812knB1sY46p8UUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/2023 6:18 PM, Jakub Kicinski wrote:
> On Fri, 14 Apr 2023 09:26:14 -0700 Jacob Keller wrote:
>> Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
>> devlink param") added support for the enable_roce and enable_iwarp
>> parameters in the ice driver. It didn't document these parameters in the
>> ice devlink documentation file. Add this documentation, including a note
>> about the mutual exclusion between the two modes.
> 
> Thanks! We do need an ack from Tony if we're supposed to take
> this directly, tho. FWIW in case Tony takes it in - it should
> go towards net.

Since this is documentation only, I feel like it doesn't need to go 
through IWL, unless you'd like it to. I'm ok either way. I'll add my ack 
on to the patch in case you want to take it directly.

Thanks,
Tony
