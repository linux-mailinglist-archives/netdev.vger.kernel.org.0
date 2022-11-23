Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817A863691B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiKWSim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiKWSik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:38:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E905DBA8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669228719; x=1700764719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iBtIRbrg+ACPg7DAleEIf5Y3JxuErXGUbn4DiJ9PfPw=;
  b=nIhaN7cEW4WMZXBQIj2Q0ZrlWmpev3oYBeCjvrgmbAJ7jBkLsfVX80e7
   EpOQw6UtFLqVXr6H0SK3zN4RuqOkmBBPvhb1xMQ2ZhtpgmqiU7Ac4fw+X
   gGsg37qBm3D6n9/tlMPSVfzfYBVM1aat1RE5BboQEOo4pnytLSyDXZ9JE
   0qPFxlH82dw7aaZQqYq4gacyilI7GoOmE9f1CGhaHGPE4Dc2q/ISKtW28
   B8SKsBxuNhdjcYIwBmtJRMX9OJ+N735AKVOJYPD/1nG/TU+0NqVVqKaVb
   Wtx7QRPnT7lL22M/ceSKvzBhnxN0f+lbdogR8N6AabEZHelJv1GIfs6AH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301696443"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301696443"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:38:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="710688157"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="710688157"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2022 10:38:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 10:38:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 10:38:37 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 10:38:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEDHKfQ6/6OH+RCgj9Jx5+zV0f+yPrSwqLClhWSeyiiaGE1bE9AlPdRTJ9FPB6/8mG/7zbJbux/22PaU81tAY2l9cQVvcK0SOlx9Jc72kRP3Xla4A2FHgkf/BMqGbGpzCA8c4kOOZjQot5PSJXbXXoyQcJQ9BU0yZqr7yarRVAboQKY5pEweJzWVvY5YyF4Ts5WPksBrI5Ba0yFlwsI3yTWFf9Pza8ygKEg0/OXAmAPFxJ7wm3I9OpbWMex8hzIw+SB5KfETBqIV1ChGZcniteSwGISCmsq04T9xELgJMHCa8lBfVGTuYA6U+MqaOWbgULOiR+UyBiiS78G9Wba9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pe31VCLnHBALI4Ji6PFwHwVhUNO/7D1wSjLBHutouRU=;
 b=oMHOXPQEL/sSEbz58x+N7k46uJinJrGb3s3DVVP0Y5OWbgcFfes+Sj0YkOugn1Y14j3xRLOkjQ9122EK7oYqObQTXLwEU+sZ5+x6m5xr5jlmnepM6mgDkMkqg0znxbe6HC9B/aoRwCc1qC0gsT5C8LtSJEgJ6ExjT2r1QFyPxUSC6EOIGNDgq/C+OIFmPh0xBT38Tfi18FvwM3G5CwHb4skFcJfdGS+FnqyX0abW6Td7PtqB+ZQlCuoox7ANKbpBu2/q5F5U1B+EsRoc8HQEsfoXyrtxacMPn6j+tYe53IbfPukk+X/+j2tUwu/1Ot97Nw3ZWat5h3fD8Rv8MyFQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by SN7PR11MB7115.namprd11.prod.outlook.com (2603:10b6:806:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 18:38:36 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:38:36 +0000
Message-ID: <99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com>
Date:   Wed, 23 Nov 2022 10:38:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 0/5] Remove uses of kmap_atomic()
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <Y3yyf+mxwEfIi8Xm@unreal> <20221122105059.7ef304ff@kernel.org>
 <b19e7bcb-e781-779c-0d2b-42b2e9b184fe@intel.com> <Y33NIiawcUn7xulO@unreal>
Content-Language: en-US
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <Y33NIiawcUn7xulO@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:a03:80::25) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|SN7PR11MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 50fb1906-0d39-4080-44b7-08dacd81ed6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hke4aLSU/ZhhS56kDM3edgP2UkelTWUpj4ONQafqf7OEio5PJJE+PaT9fuXW31dOIX3bMzjs2VqUNO+84d+pDK9FQpWSZ1Zp7EuplYnihS6V7wCkumzCjPyTB6wyr7orL4T4+/McLB3Y8rVpcxmwG5PeW1d0LjaqfI+ElbBrAerbzxkP8To30X6fOEoYGpJZ1LVkGo0MTPA4xiJTka+hwoA+18F2A79ruhC+VeiSfqV1VEWyzi8NG2jMxI/tAyMD6NQufcFKn+E5hToUiG1OcA2WlZlfJG6uwX/tRcilAYjlJABDlXhA3q9AgHzM8QDV7EWyB7YmjdGeen8dd2tahZHLLlk8Rc9K93E7amEJR3Yqryt5hYNs8eOUdKjSdnlRrjtkJqy72aleqPSeMGO52QGtiRyDhZaQtgW6S8gpNlMPxbm+kGpJ6Mj1kOGZW0v3L6qHySoCrxWt+V/26L7Qgv9tVIaMKgVTjef7b3bdWQUBnFDRagxUqj1VpPY2CkHlwgD1ziLQhSP4RaIUacr/x0M1SMXV9sDLa07NM+P16ZS20clANA/1kjbJv9Y1Nv7taVEoz8F6RPJR2zIZA0mM2z5kq9gmzKIbdw8E0WSIXh7ssdHJNrkQgDuPpagkk5/lKGf+jZ972tUv/mJoedYvvQTb0vv4/B2+Zt4NEFncnG3Vgg4hANnDqrKwUjBaMfbPvyEViD29EUgqo8Tl+2YDT/ecux0d4VWz+uB6vm3ZbzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(2616005)(83380400001)(26005)(6512007)(53546011)(82960400001)(186003)(38100700002)(5660300002)(44832011)(2906002)(6486002)(6506007)(8936002)(54906003)(66476007)(8676002)(4326008)(66556008)(41300700001)(316002)(478600001)(66946007)(6916009)(6666004)(86362001)(31696002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGhRb3htd3pXSGVVQkVMc3RyQXVTeVlFd3hiZXkvMlVwcm12RllUY1k3bTVI?=
 =?utf-8?B?ajlyOVNsdHUySFZpbTd5RUtnRzJ0SDJIRkp6UHVRZUs3UkY2RnFkUElwOU5F?=
 =?utf-8?B?YlVvM29BaURNN0o1OEtXQU55a2tTRGNjdDZVdzhUcmg0SitOaHphK0FXS2E2?=
 =?utf-8?B?MDMzSERiQnY0cysrbTNEVVRUcjd4aDBUZmRINmJKZnlYYUJHamd3THVrMVYw?=
 =?utf-8?B?R2FKdXJYekxNTUsyRVBqMUs2ZjgrZTBxNGU0TUNMWExDc1V6VVN3SGZSVXN3?=
 =?utf-8?B?NHdtelFWUWR5Zmx2MjQ5NlJ5RUtHbkh3QUIwbzJzTmlNcXhqaHltT0VwOUln?=
 =?utf-8?B?RGNmYW1UcCtSWG5nOTBpbklZLzhNeUNtL1ZtblNoRzgxUDVFYmQ1aUhTVUlh?=
 =?utf-8?B?WnZUbmZzQVNmNmdTR1RSVWtWZnNSV3JTMXNUYW1nZC93SnRvRTNOZW1TcVUz?=
 =?utf-8?B?SXlaMDZrazlJTk5hV2Z5RHJzR29nYmQrWE0xM28zM3JIRTFiTmFMV09lOCt5?=
 =?utf-8?B?SjVsU3VFV0UzS0ZESU5FM201TmxQSVBwMzhOcUwvUUVuVzNhdENQRDRGbG1q?=
 =?utf-8?B?dC80M2h4K0RhYzJrWVo1V29LTzlkTXMwZkZBa1IwK1JDb0hsbEpZaElCQnds?=
 =?utf-8?B?aktRUmxrVlF1UkhjZCtvcGJhZzM0WEt4Rk5XdXhGVE8rTGdwT0w3MkVzaith?=
 =?utf-8?B?bEJEeEpUNkptRk5Welhrd0lKcFVqVmJUdFNVN2p2amxyRHZnYlpYRk00YjY1?=
 =?utf-8?B?aGx1alRmeWpuTjBiRkNONHJtM3lPcGkwTm9BdjJIbE5EelZNOEtUUGtXWWp4?=
 =?utf-8?B?Q2hwaGU3T1ZJV2k0R012a0l3cm5aMlZ5S1NuNVVIbWhyVWJRajhPczBnK0Y0?=
 =?utf-8?B?RzFuOEpoSVd6cHNuMnlxcFh1dE8wVVNYbHBKYmpXMnZUQ3AxSGVKTWZqbUFz?=
 =?utf-8?B?dzZuTVdoMmwrUWRja1BoQ2NGVUF3WE1XK1ljSGhlZjAwQUVmc1k1Vk9sVnNJ?=
 =?utf-8?B?RzVXYnJaWDdyNEFQMGFodmphSzNxdjFCNmdYeXU2REN1RUxnSUdMcUZoMEhE?=
 =?utf-8?B?cVlYYjNOQW5lVmNGb1RBL1VwenVxTTVPRGFpYW5KTExvS2FrQ3dxTGIvak8y?=
 =?utf-8?B?UmxyWTl6dFVMY0paNi9LdmJJWUc5SmRxRFZJR3dVTElCbUVVT0xEYmhBblRO?=
 =?utf-8?B?TkxFR28yeUc4TXJxUEtkSHY3SEhuM1RCVC9OYk5PVEh3Sno1bHRmREozbCsr?=
 =?utf-8?B?NFF2QkZISXJZUzVRMkpiMFJlTEFuYTgzUnBZOWd1VHMwNEhidE5hNXJrZUhx?=
 =?utf-8?B?VU1QWEVIdEc4MHJBWEpKcGs1NGtRNmJVTjdyRm9UVEZnTStvSUI0c0U5NFBJ?=
 =?utf-8?B?WEY1Z0NPTHpITTNKZEhKT1VhS3JWOFFhNWc2RU9tSDNOelZybEw1V1E1QVkr?=
 =?utf-8?B?K2Q0ZE96TWJSRGEwYlFFVkFZTGxrUkdtMkFKK3pyNTFQanZzdXVXYlI0MXQx?=
 =?utf-8?B?VVhLWUgzMjUwMHRUU054ZXZWd3ZOc2tEOHZXZEM3NGplUkhETHA1V2MxcUZZ?=
 =?utf-8?B?Z21FYWNYY01aVXNwN0xnaytiaDVtdFRJTE9ORnJTTDd4NjZNc2Q2ekNveWNJ?=
 =?utf-8?B?MEpaTDI2THdhMHZVTmEwbzR2THdiQm1Hc0M4Sk10TGgxbFV6Zld6bzB2VDlI?=
 =?utf-8?B?ckU5VDFBZXVvUy9LOUo3TjBKeXlLdkJMbkF1YnA0ZlgyU3hVUUhEVk1XOFRG?=
 =?utf-8?B?clF4OFVkN1gralRUMVlSVC9IdkZLSGtSL0FabkhDWEdGdHlsdXF2VFIrWGtX?=
 =?utf-8?B?TWIrZW1JTzYzbmVBM0VzTUt2M1JQWEQ0Wlg2MnNWN3RJVTRBTDZqREYzOHlh?=
 =?utf-8?B?Mzk5dmU1MGlId0F2bXJQcUxSYi9yMU9nRXN1N2d0TC81dG9vWVN1Qmg2bTBD?=
 =?utf-8?B?SlJ5dlA1V0VFa1g3L2lxUGZ2SHMxcTJQZXk2d2R3aUQ3MkNSV1JrYkM0NXJh?=
 =?utf-8?B?RnlmcW01RGxBKzdxQzY1STVGYm9XUEdzYTZMNnVqQTI1bElncEo2bHllbmMr?=
 =?utf-8?B?ZEJBL3dsWEhUK1FWUVkrd3hDOWhMMGxzM3lRODRBZzlQWXVhR0FxamNqV2hH?=
 =?utf-8?B?elhVZEI2MXRZSnNKS2hsZ2pKOVlkaWtaVFZ5emdWcDY1U3RVZGRRc0twRms1?=
 =?utf-8?Q?bB6FxvGmZXpbOmI0ZaZ+gbw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fb1906-0d39-4080-44b7-08dacd81ed6e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:38:35.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJLQFS4EBj+LhMUU9LRgeSL8qbE7z837w2OcI4qIZ2IZbtI8rbfgekSNdxFHzRtYw5+Tb5EGChKZLr81CWpeey/W4F7L6fLEcmB4/gtK0WO+flhmMsZ+G9jOKv3mKEsE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7115
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

On 11/22/2022 11:34 PM, Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 01:06:09PM -0800, Anirudh Venkataramanan wrote:
>> On 11/22/2022 10:50 AM, Jakub Kicinski wrote:
>>> On Tue, 22 Nov 2022 13:29:03 +0200 Leon Romanovsky wrote:
>>>>>    drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
>>>>>    drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
>>>>
>>>> Dave, Jakub, Paolo
>>>> I wonder if these drivers can be simply deleted.
>>>
>>> My thought as well. It's just a matter of digging thru the history,
>>> platform code and the web to find potential users and contacting them.
>>
>> I did a little bit of digging on these two files. Here's what I found.
>>
>> For the cassini driver, I don't see any recent patches that fix an end user
>> visible issue. There are clean ups, updates to use newer kernel APIs, and
>> some build/memory leak fixes. I checked as far back as 2011. There are web
>> references to some issues in kernel v2.6. I didn't see anything more recent.
>>
>> The code in sunvnet_common.c seems to be common code that's used by
>>
>> [1] "Sun4v LDOM Virtual Switch Driver" (ldmvsw.c, kconfig flag
>> CONFIG_LDMVSW)
>>
>> [2] "Sun LDOM virtual network driver" (sunvnet.c, kconfig flag
>> CONFIG_SUNVNET).
>>
>> These two seem to have had some feature updates around 2017, but otherwise
>> the situation is the same as cassini.
> 
> If there is a pole to delete them, I vote for deletion. :)

Perhaps I should put out a patchset that does this. That would give 
users or anyone who cares another opportunity to chime in. If we hear 
nothing, then we're good.

I am thinking I'll still include the conversions for cassini.c and 
sunvnet_common.c in my v2 series. In case we don't end up deleting these 
drivers for some reason, they'd at least not be using kmap_atomic() anymore.

Ani
