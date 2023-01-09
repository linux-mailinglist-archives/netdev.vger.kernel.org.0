Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5598E6620D7
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbjAIJC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbjAIJB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:01:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E059FE1;
        Mon,  9 Jan 2023 00:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673254466; x=1704790466;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HnA8mqo3euc56QM4Ne/dQkL1C6EgjQ4iN/0A5YUbLR0=;
  b=R1su3nm5A2bvGTy+ww7+o4nCgA6hprBI6LJOKKhS6KrVGwAtrGkG5Pqf
   kgpPiBXtpd0MAGWxtVNozwKLAvYN8tOlbVzYjujJlDNJSlIKq93jh2ipP
   4Ln41OoSaZaAEA+/BVKN+ZetW3R3w9xmof1VBXjjeneWkT+Xv+bs773AW
   jQoHC9FCFP3NgIx56Ghq9K4ohYODO02zqylLKSPTQ4CiUJtv1snxbJM8y
   lwSWUEEtR8jalvYmVl0NBow6+zX1wpVODyHLuExe9G1VvG4dSP/iPIC9n
   e3o3cZG6QjDuZ3dN9URSn6y/piDxf+PPEYDep1PcW914YYyx8u7F/56xA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="385127333"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="385127333"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 00:54:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="687130415"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="687130415"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 09 Jan 2023 00:54:23 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 00:54:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 00:54:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 00:54:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXNhxDchMWhXODzQsj66xCEF2qV3N6am4su5TLMfwjFbIAsdE2wDg+BXnsW/+LCNj4kwnK9Ii4RrWS4FdYAr1k1t2JR0rJXtaeUqQnPbIkmbonEs+4lLtlbK06Hs7UlzJa0qkTgNuEeapH554GYFW0EkqTqhwnvqCcHuEze91accRfEYdBPAWKpTMeGh9er6QhssTI5kDgH9ZLWpcTpeVm+KfF2lU8zX6T/YKm+H44TMhqDjgJfsOtOnWtbfl2xg8vp51FwJviDCgzgg64hxLgBnvCw9aUTfvRi4RKy1BR4lSN0KFm47cWAIqoXfDLVz8Zc6zjRReY3foUvfMAZcgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mGR/DVyXIsKSbS5Mpd01/l4fgme6e1YoSIv6tcPgqM=;
 b=hcmQyhFkwte+pfBp6+cDltmurEZ612mpK+DYC8g27ODTyQpk/fo6lmCRnOa5JW7rIo81+ngBJZ0RXEBRc9UmT4+EvVjLLISPhz78YvgEoCd8nmofWXTu5udzQu2V0AOPiJ99f7n31fPGGNvuXttp25fG9Kt48M7jE+H/OkAWAlgu/n/zQE+BjQECIZvy4Hyk7y84hBk4A0p8jyU4t4mOSibzVOoq+TKr77ujAhJmpQiYPpT9XD3dqYcd7m6zx2i3WBJaIVbfxj4DlJM/uWqNHkzuC56a9N1Io9fkE4BgLrMy6k73yvsqSESB3/8yeGmy9qoaQcK81J46drH19K0mQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SN7PR11MB6773.namprd11.prod.outlook.com (2603:10b6:806:266::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 08:54:21 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::1d81:371:eb0a:cbcc]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::1d81:371:eb0a:cbcc%9]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 08:54:21 +0000
Message-ID: <0836d397-6cc8-e5f4-0b85-67ddd30e6321@intel.com>
Date:   Mon, 9 Jan 2023 09:54:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net v2 3/3] ice: Fix broken link in ice NAPI doc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
 <20230103230738.1102585-4-anthony.l.nguyen@intel.com>
 <c94fd896-75f5-6a7b-1253-b1377405fef6@gmail.com>
 <20230104204310.3d56e5d7@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20230104204310.3d56e5d7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0003.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::6) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SN7PR11MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: d01d9448-72c8-4834-745c-08daf21f1935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laRSWfZ2Xzui/IJDHE44W9I5BNBEEoeYPM2E3s9MXJXq6Y/PpJjHyAZIzMTjBtqZPMgIQ8GFhPhGjx/SnDymWsLeTHA/fCiaLBFoKV3Hcs9FuLlLJHNhJoYSZLkpb/iDuCIg7SADnwSODgIChOwVMDN9iuRUzQKJRq1eKh1U8WouGgyy8BLFTg/VkzroGxnHAWde+9VXja7gM1OMlQ3r3ICwzGHyNQ4yOHbso3xcdw0c8jNGwqpob977wHMPJ7k0ry4yny4kbtx64KSEyO4SWb33ZhIRQuvf+upzuZMIuUMxBIfscMIiF8HUaPPAZ+ikxFQ35lvS3j4TZbtg3T+luz+iXefwxOKAph2hem/E1z21Acbt40OcOLejlOt8yROeDavShTXeoDKXr5oR6w9ZNGY+234VYpEcYqzfXTRq36PHqGd50/UieH1mSaQtRJVszrXtCI4FkOM9HEw7JRdqLRRe2t+NSQAxzoxfoBQE6QljGW5tERKAulQS99Q/DnVNon1YZGCV8jKs7J3gd5l33yuwMCepaqJg/b7D74Bgx+k2aa6jnJYum74e4NdldCEL0J2fbfqX0MAsK/uqzTZjz9o0Vb1jJjoIscwFgRgcm8E1fP0F/dqww/RBknNGpfzCY1UyADgJJrDIwZZdhcCMOS0oBIV+fxltTGRi7y8jtgPD0Oww/XZL+leJU3QyVoQ9y1o8My5ELlsxOirieesdLVfBoO9Vg8XtuDutsV8zUXSFfDi6LryG5edzbD6ROEkNPLdbwZiEXeZpXUthYDzV1iRlnZ3vFHWwpOoA1BNTCZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(186003)(6512007)(26005)(107886003)(478600001)(6506007)(2616005)(53546011)(6486002)(2906002)(66946007)(8676002)(41300700001)(4326008)(8936002)(66476007)(5660300002)(4744005)(66556008)(83380400001)(31686004)(82960400001)(110136005)(31696002)(86362001)(316002)(54906003)(38100700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFI1VkRSNUE3VFhDNUhHampPYXVPK0s2dmlsQS91VkpSRHBObTZsL1ZiYXVI?=
 =?utf-8?B?WkxaUXpDcjRhcWFRRmExU3pXS1BUcXFQRXE4WDFqY1NSU3ZqcmVGVFE5cEcx?=
 =?utf-8?B?WFlubk0zYmh6c2lqc2JLYjV3WG0wOTk2djFmYldHZ1hPS1dRWWhaR1JpVzgx?=
 =?utf-8?B?YkRpR3Rhd21CQW4rNGpLbFE4cGdrZEhKbVdGWTRidVpreUZ0S1lkcWNLQUpu?=
 =?utf-8?B?RmhJYmhzTDhzZXhmTm5xMXFqYkV4UTg3N0tRNTRVREpBbmRlZ25OL21UTVEv?=
 =?utf-8?B?OTFoOU9BS2pYNi80UFdtTExYb2ovVWE4L3J0TTFtTndxQWRrQXBka3pmcEtQ?=
 =?utf-8?B?MUhyMHJ0bnJWM0JMdHkxM3lBTUtNUzJKTnhLaFRGVElHcTE0K0ZXbEV0UlRN?=
 =?utf-8?B?K2tLemVkZmI5U1hOTmFvWmZCajRuVUVSb1M2QkVZZXB6YTBqTWprOWh3d2Zl?=
 =?utf-8?B?Ymtvc1BzUDhHVWZaS0F2azRSQS9jVmgrbC94ZSt0ODYyT0p2SFg0RHRhYlZj?=
 =?utf-8?B?Y2s5eGhqancwQk0zdnZBZE10YWlYbmlBN25zeWJ4b21ZaDdxd2R6T0Z3T1N0?=
 =?utf-8?B?amNjYzRUTTA5Z012d3ZuR0NBanMwNURUK1JaUGl4Z00zZ25NcjdURWNLUUZR?=
 =?utf-8?B?WTYxS3krNXR2Z1RqL01ta0pVNU40VjJJanVZWFh4R2ZxSkVpbTYxemliSVFG?=
 =?utf-8?B?dk5jV1lVano3YTk1QlRmNXVnOVhsMWJ4YVd3QS9qd1pQTy9JYW5JRmI0d050?=
 =?utf-8?B?MzN0dldUMTZYTFRTWmxNcEtrQ3dHK1F2azFyUVhyTUVxdkVjQ0FGVGgzd2dL?=
 =?utf-8?B?cFRXNlBlU1h3YkdBT28rZEJpbVNVV05lWUpadHNaSkFhZUxEbGl6amJveWNG?=
 =?utf-8?B?WVRQWElCL3JPR2pnR3Y4TlVUMDhlTGExT09SZDNDNkVMODArWU1RNEl1MnhY?=
 =?utf-8?B?R1dKa09hWjB6RUcrem1uTDNvWXBjVExXd0wvY1RVUTFVN0RJQ3haRHoxODky?=
 =?utf-8?B?a0RmSUo1NEVsWmRQR3RHUC84blJ1bkNUb05EN1E2OW44U0tSMEFzMHVVRko3?=
 =?utf-8?B?cGRFNVJsRExydFN4M1JOQU9Qek1KVjU3RGcwRjFzYmhSWmtZdzlaV01UeGVZ?=
 =?utf-8?B?OEdEZGd2NEJ2Ni9uVUpqTGJiUHdWQThqcHJDaG42LyttYmtta01TQXhNRjFr?=
 =?utf-8?B?V2xXeHEyV2RCZ2UxcjhwaVY4cUkrOHFvcEVwOHBsN1VmUVRHMlhkT1JJT3R4?=
 =?utf-8?B?V3VkN2IvTFVHK3lCTnJKOHJFS0o0Zm4ydVZ2djBOa1JjdFRPQXFWSmIveUVh?=
 =?utf-8?B?cUZZc3NoamhpajQ0ejJ5bnlnZS8yM1BsSDhFc3BjK2JsWWd5QzhtNjhlbzVl?=
 =?utf-8?B?OXBDUzVNWlAzQkpjKy96M3ZpTTJXWUtsUTZ6ZmlFNzVPVFgvOXMzaXlqOGFi?=
 =?utf-8?B?M05jK0kybWl0ZFcrQXF4WnFrNmoycjczcm9hajNFQ2VxRHptQ2MxN3pqNXFM?=
 =?utf-8?B?MEpvQllabEl3amNVcHZrZ1prT01HaktyQkVOVjVjRHg1V1dDUi95ZlQvSVJS?=
 =?utf-8?B?N3FKaTdYQm4xdHVxdENZTU5xVHBxaXk0TXNoRGdSQTFTd2hVMWNTODF6VHl4?=
 =?utf-8?B?VmtuT2xETnNNMEpIOGUxMGFlNWM0T1g2cGUwUm5qZnVxdTBCSFZwV2RYSXhT?=
 =?utf-8?B?WHpGMktKTkNKU0QycTdPZmo5MitRMGU1TU9nOXhrWFY2dkNQQ2hCcHczT0R4?=
 =?utf-8?B?WjlOcC9Zd0NqSWVRcktpeVFNb2FacjVsaW5jNGd3UHJGZGd3am5XdHN5M0cw?=
 =?utf-8?B?bEMvVnR4L21ScFN6Vk5LSkRZS1IwNTM3amZaUkhZSStnMVkvK3pjN1l0eFpV?=
 =?utf-8?B?WHhTSFhZc1llTGVxaGV2Y0xHbk80QWV0ODdIWmFmTVBtelN4VmJEWE5neklY?=
 =?utf-8?B?cHFsMzI4blVuS1YrNFFlZDRJS25DYTVoSzl5Z1U4clEwVms1QVd3QURXWkg1?=
 =?utf-8?B?ak1ZVTZxSGI5OTJMRjZPWHk5aU5NVElFa25MYlBpdUxNVlZFdG1aL2FQLzZh?=
 =?utf-8?B?WU80MUxGQkd1NzFVbFhhVWswM0c3bFVZWUt4aXRaTEpnK1J1QjBrZjFUdmFR?=
 =?utf-8?B?UXQwWkRJL2l2N21ZMlM2V0oxKzREaEpyc0h0aFFyMlZac0xsaElKd3VxY0xv?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d01d9448-72c8-4834-745c-08daf21f1935
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:54:21.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxYDjjCPRu3YioPMF2zPqH38oPLkDLfJ4Hk0NOq5VBuPBiixqGJ+KDAJRceRl11kFM4DMGdurqXKYmdImOAUDbjA2ZCbG+0mZc6LTPRl5I8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2023 5:43 AM, Jakub Kicinski wrote:
> On Wed, 4 Jan 2023 09:02:50 +0700 Bagas Sanjaya wrote:
>> On 1/4/23 06:07, Tony Nguyen wrote:
>>>  This driver supports NAPI (Rx polling mode).
>>>  For more information on NAPI, see
>>> -https://www.linuxfoundation.org/collaborate/workgroups/networking/napi
>>> +https://wiki.linuxfoundation.org/networking/napi
>>>    
>> Replace with LF wiki?
> TBH I, for one, do not know what you mean.

Me too, if you have a better link for NAPI doc, please provide one.
BR,
Michał


