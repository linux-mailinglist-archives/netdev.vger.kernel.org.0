Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5D64E1DC
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLOTgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLOTgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:36:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5058E17598
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671132964; x=1702668964;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mKuAH7imQlw/7HaqQX1GwUu7NW41Bt1HilNmPZ5XJRc=;
  b=LjvG+DN0p4rFlZ3S+A22zx8i/zW+06u375G4DMFVwavU9/q0RcE6QuIE
   +3pBW9l6PvVgbKEV9yy9JO4XFMJtk/6V5y3Lmq4D2nlPsC0RxYm3JKTWF
   JxKSBc5koB4OoBTDtweYQm2RziDVkBPx5OpOiCkMsEz2747KIcwdlsk/R
   hlgnTrSjdOlNc0qcTm/OjZ06oFnkvaX3TjO4/NUfdOyJLyRioaz/zVAtO
   Nh1JEBdrX6zygLxFXl+2kuC12ue1ptn9oPLoTEdTcdOcgDmRms0vLNbIe
   TPDlvTJGbHG1psBOdAUscA6P3MCppse4KSFc6LSILd/1nCESqBK0vv6AT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="319952676"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="319952676"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 11:36:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="627318518"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="627318518"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2022 11:36:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:36:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:36:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 11:36:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 11:36:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5rPTQ1YwGaN746V5AmZVv6yGoHEBIDQXydbvXcb968pkTvVvzJ4WJYkr/voFAoK1gRgJtrjltkeR6IdNyPgeU+eXR2zuY4v5sGkRXRlbdtvaBR4n8bV3T27IpyePBj5X2sC5XG0z8i/yfh2R8gN6wd6Vl0Yk207kVUKdYxdskr8c/jTlpitPjWHJOfX88xBMVOdMYI917Ur44Xz40GpVfZiRlzZpUF0mwbXVAg1pwn8gZrVK7H7z8a/sGpnvzA8zcH6wpWCS0oXlSQyzUlrMIAZKsH7ERgXh47sedMGQQQKZNRvu1U2eXNYH75/DFXENSn7UACCm5Jr7bUocO/hHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kP/i3cQ84BEIh3pjj1yM3mshpYDqZ5d+kIPXGNrs7IY=;
 b=aYzg+drPURIba6CeqAX+CgV1SwkUtYP1w+N9VbLgRPF5AhcnIeXmz70Y2FttL0v8/w3b3IH08jCpEY8kb5pEuX6rQhSJX0ZZYKgzlRRbc+lRoGwFzl2B9HROo6s+gSldQVP690s+0UZKNs1hTAo5I1Wq2/272Mup9OpG1mFBJmIyFJMCANgF+hCNwzCsO28f3NioYKKx0HYrqQujuovexqxGOz6SbH16zCQN3e4pk6752IeeWC2KNam9sluBbMkL74dZVSpuo1KlvCPw8mj2NEx2AfYi6ePDcMbyPtv5+26rxmS5O9hxpy6aKy9RNUDeNyPx2k8/YGZNQq4dVDVIrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB5826.namprd11.prod.outlook.com (2603:10b6:806:235::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 19:36:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 19:36:00 +0000
Message-ID: <efdf69f7-7010-55c2-b4e2-8a647974bfbf@intel.com>
Date:   Thu, 15 Dec 2022 11:35:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 03/15] devlink: split out netlink code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-4-kuba@kernel.org>
 <e350733f-d732-4ba6-a744-d77a37a237eb@intel.com>
 <20221215111411.5b6d3f5e@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215111411.5b6d3f5e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:40::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f81133-4de5-4bb6-91f6-08daded39836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vC/SX2x/uESz2GQ0p8tN0i+RjD6kjpctx45X/h5AIMhMs1MMneY0YQG3nwjnqZRh+PKTQaV9uuuSGLWYXxLM2yxKH1om1Sibt+SE/9OJUxS+PClk9SnD+r8gX0iD304sbEJqxPYVm5aZJRvz7ZV5VtFm2sdUGXh9IS+eLoXG0rMW8vTYuQE85NuhWS9AFwxICb/Ocb1anXhAX8GLPXUxBkxySvA4tmWZI869gw1Pz8sF8TQf+Pq3f5/y9IztXD6tfBkqBPD5lrWK1I14Gx3Feq2VbU4l4vdQDo/VeM56CnGdw0hxlswzBBfOTkw7fvv66Pe3gU4nnyqj8oplrYuMBLnNFigeGTX47JJjYSFncsJUEh4UvW0EsszpoM57wInZvXneZkVgWBmjsNjHWkucvonTitfovRx2FuT0hpv+XoOm2bbRVomcOR46Aadxh2CFnPWAuXNan3vsvTBvfy5ghbayasjePwnUR/eJjyMNWEsZWiMhCskdpbpakeBjYKGvigy2EzyQpzfGKhXLrw4WSGeQehaJzp/F/evrvn5gRXc2MpDG7QkXnEenZ090eptiNEO8R3S1wSSiVjVp9n0zK01akFyskyinvzC6McjMIOum+qd2as4ZTgQgU2pO5v/JDU5dq61Jb6Ah9PpgGc2Sfv2XjQoCHITOrnxaX2vWehW1OPh6p57Rx7Fiy2ujReOCNvFoObu1UZqipkFsK/TjYaU7ye+WTiBWJP6HsCpHPaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199015)(86362001)(2906002)(66556008)(31696002)(66476007)(82960400001)(8676002)(8936002)(316002)(41300700001)(186003)(66946007)(6666004)(6512007)(6506007)(53546011)(26005)(4326008)(83380400001)(6916009)(2616005)(478600001)(6486002)(38100700002)(31686004)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjA1RTNncW9kUXhNZzYxaElFam00U0hrUC9aa21xKzlYSEl5eXNxOENINE94?=
 =?utf-8?B?UXRNeG5OS2VhNDRxNEF5R2JPWEU2VVNuV0lyem5oeVNmQUdOdE5sbUYydWk1?=
 =?utf-8?B?cmV0WG83SVlIWnNQMTQrUDZDVTB6azJPaHVmZkkwaFBYSUVYblBvNklDcmEz?=
 =?utf-8?B?REtxVkFJOXlPQWh1dndVMWtiRHJ0dUFnTWlFRTFYdnBwTUREdm9OU0QxV3VM?=
 =?utf-8?B?YVhERWxSMlBJUVpHQ0dkZkZjQlgyTDUxN2Y4R0tUbXhwZjRDbkQvR3dJNith?=
 =?utf-8?B?NER0aVZvU0RhcVpkanBFai9HTGErZTErZHpSVHZDTVFhZkw4aFBpU2pMT3JH?=
 =?utf-8?B?ZTNuNlVBUUFnQVIvMlRyckMzQnE1VlpZVGUvVTBsa3NTN2tzZnk3dnlhZDJi?=
 =?utf-8?B?bGpQeitJa1N1VmNYaUNBYUF1Sm9rdGhSS0VTL3VrdnZ2eW9qNy9SL3pHQXdC?=
 =?utf-8?B?ZnRlWlJXSGY2bmNWUnM3RWpoNkg2RXhiZSs3dzExNE50ZVJPT2ZkUzYvc2li?=
 =?utf-8?B?UFZIaFVtMk5aWmxjNzU1VmVuSDhQcHIwWDVybWcvNGpHV25hOG9pcmxFLzBP?=
 =?utf-8?B?TXA3UWlzNGRmTDZpY2RpNXFXSERTVGJpQ21IdzRTRFk4bENMVmdXWWppbDAv?=
 =?utf-8?B?dE1mN25ETXZWaW5TOStSYStXZXNQZ0JoM1BCZUJTZUpSREltbzlEZ3QyN0hk?=
 =?utf-8?B?ellDcEVoRThkZHEyY0RVY0w0cGczdjBMK1lJa2x3K3JLdS9oZWs2Nm9COWtt?=
 =?utf-8?B?WDg2VVNHYk9JUVlRTmViYnZmSDdzVXMzUDhoMjZ0NnJkSjlSZzRBL1k4a053?=
 =?utf-8?B?dmtQSHVadEtXZy8vSDh3V0U0Y1VodHd0VXJCSGlhb0hkcFlFYXV1M3p6eGlD?=
 =?utf-8?B?RktCTGs1RWhIbTdsTVNtRU12SC94T09BUHVpT0dLc2VxRnE1YnhJb2hXUjVE?=
 =?utf-8?B?cm5JWU5RclVFK0toYm9ia3RjaTJrc2VTT2R0YjA3OHVzUFBwenFjait0R0hk?=
 =?utf-8?B?MXJHVjY3YXFuaEZCU2F4SWoxekFyR0Q0M1ZobEQxNWJseklwUkk1a2ZYdnhx?=
 =?utf-8?B?eXdqNG9GV2JvS1lBTzgyQS9BUENRNnlHb2J3Mmcvb00wQ1ROTXU3WFovRnhL?=
 =?utf-8?B?c0tnUDJsMjdTREhMS0xUaHJzekkwQWIxZEJYUmp0L2RIMFlkMnBtYkJVYU1h?=
 =?utf-8?B?WVh5ZHpDVHU1TUxwTlV3Q2xFb1ZRNzB1QkJEWUtLb2h6Z2pha25EM0hya3hs?=
 =?utf-8?B?YWU4RlhTcTUvMi9FUEMxeUh4K1k2VGpicG9Ya0tNV1pLMVB5ZUVOQzBxTSs4?=
 =?utf-8?B?dmxFMVhKajRXY1V6NExHeUtpSnZPTGY0azZuYlZ2M2s5bFlnV3JMNG5ybW4r?=
 =?utf-8?B?d1M2cGg5MGc4aWlLNTlQcXRHS25LbzFmWTZjRXZtaklDRlY1WVZMZFNjYit4?=
 =?utf-8?B?a3VMZlRLR2wrdGU4Tk1kZythcnFRbTNxOEg0ZE9tZUNwcDhIV05QNlFQemFz?=
 =?utf-8?B?WlF3NFJmcEJjcFJYcnRabmZrZzNuVW01bHVPbHdkZEpIVTE3Y2hxZ1NyUnhR?=
 =?utf-8?B?bFovTTRSUTNGSklFK3hSdjFkblhJeXpPbUZPcHdKNlJTZFUxSDlnVWZMN2dU?=
 =?utf-8?B?aHpSZ0l2QXgwNXhZY3Bsb0R1dVcxaVE2bHNKNVpRNnZYN2hRS1M0Zm5jS1I0?=
 =?utf-8?B?MVprekJ3RnZ4T2JmUHYyTFhad0p3ZGx1MTZkV3dEUDV4K015RmpQcDBWVnFZ?=
 =?utf-8?B?TkZaN0Y3QzByRElQWERqUzZTUkdjZE15dFlPY2ZVbDF4ZTFkTXlCNXV4ZEs4?=
 =?utf-8?B?azc5QzFKOXdYUG80a2M3REpGbmJVZVBSbG1KNjh3UFZpWnhZbTcrRWp6OUI2?=
 =?utf-8?B?RDBwbzI5RE5FTGI0eVBIVmEwcmN6U2N5S051eVZRRTBwQk55Z0FZMFhEVEky?=
 =?utf-8?B?RVVUeDhBRjBoUTlicno2bmprSE0zVFp2UXEydkYyb3V0cUZrY3lCOHRFWHd6?=
 =?utf-8?B?OGQzUFV2SHNPYjZzMkVRbUc4Y2NCM0lwcGtNeEtWb042em5XcmhvbTBHVTRn?=
 =?utf-8?B?cTdqSWpxeFFlRStGSHI3M2E2SVBBNUk2S1RaczNkWFNPREpxeDZ1SEwzWTR0?=
 =?utf-8?B?TmJxNU0xNmJYdjc2TEVWdlJNQlQ5QVZNV0FCS01CM0xkb013MHpDZ3V6RGQ1?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f81133-4de5-4bb6-91f6-08daded39836
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:36:00.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w27MbW/UIAcfomKtesJcqaz+bzykiwAu3aC6tCJvnfL2ZDCgliwvFf92btV1zMoYDPyiKtMkWbrHkZjR0ynK+olLES6Z/CJszOUUcx0ihDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5826
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2022 11:14 AM, Jakub Kicinski wrote:
> On Thu, 15 Dec 2022 10:45:48 -0800 Jacob Keller wrote:
>> On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
>>> Move out the netlink glue into a separate file.
>>> Leave the ops in the old file because we'd have to export a ton
>>> of functions. Going forward we should switch to split ops which
>>> will let us to put the new ops in the netlink.c file.
>>>   
>> Moving to split ops will also be a requirement for per-op policy right?
> 
> We can mix within one family, tho, IIRC.
> So new ops can have their own families and the old ones can stick to
> the family policy (unless someone takes the risk of converting them).

I would like to convert them at some point, even if we leave the old
commands as non-strict. Either way I think it would be preferable to
begin enforcing that new ops must be strict and must be per-op policy.

I personally think that moving from non-strict to strict should be ok
especially if we plan it over a few releases. A sane user space
application would generally prefer to be told "this is unacceptable"
rather than have the wrong operation done, or have its attributes
silently ignored... but I can understand the argument against breaking
user space that used to work.
