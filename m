Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6456863D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiGFKzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiGFKzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:55:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E94127CE3
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657104952; x=1688640952;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9mBUj7eqa2RZZWpO2sG1fUj4JovC09R0HTglTwbRtQA=;
  b=f1FP4kw82JDkjHtJ370+vU/0uKsJFjJI88Sa7s9vgR4wzEdrQO19Sgv5
   IkuKe4m/X63d62+hbX9yzLBE9inZuu2MONppsVKnzxl96j8R+WL4tHaTj
   keykE/HzB1MjlzFT2lAbDkyS2FMnVF3KJI7DKYBx4PdBTRfxpukFZHt8R
   Std4NnaUs6GLXcY4JiJZBD0C4O8sqFgYklwFJ8a6VFikb/vc+Axu1kInf
   zFtLsUq4shA7aW9DFwa8zBwRuTTG2TrrCh4Muubu+aygWcy4NtAZTR+Rv
   B4AmUvNd0MShLwKqO/ESZA3rUC+vfmAYPbXTaQAZ+uQFfXBTOpzsMG8je
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="370032323"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="370032323"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:54:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="650613066"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jul 2022 03:54:20 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Jul 2022 03:54:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Jul 2022 03:54:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Jul 2022 03:54:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4DuCIps+YuEK8cgy4Yp+RD2iRkzRCCChL2vCk6x0K9SVFlA2ToQNebqhCKYXeB0z0tal/tERP4aKj0Q/SgkqxX1uFQKDFaoOBYJrOa1gucA/2ftxxOL235Tx5U0pB+6oOGZEtV1ZU5zwnABZ4Jpsuilmok0a769fwiS/XXYk3Lz0K65ZMXspMnM+8ASc4S74x2YpyHKfkjZ81bR5WIptDprqawpHy7lyPnlhrcqk9/NsSm6EqiCjLwy1uBELcZtvOvcW7/fpKEx5kLXonS0u7OLLpDr7NkCVrCXba191p9L+cjEyit+F1KQxaBYdClnBQUMJ8xxGjGvd7K+guoEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLszalAVnqiFOuQAmgRMzEvnlRMFA0597rRu60vt6Mg=;
 b=iH3jfjWevsNb6udlHGgt1k6u/5QF4pwTUYUQ9MZRzGLY5fv6DI0CPj+tVMGjH875pnfLm/+4Z1dYj0rofbFChpdXb2wUQIJq4tcA30W1ChSFqwStW+ecD7RNLjaKybRucSqotxm+EF23bZmeuXTYAaiGftzwWIRd1yRYOiCqN+JRxutffwlQQUHApCgW2jd0wqchaE8qPMCpONTnm41omsqxW5sGb28u9U9Vz/37fGDDlqi+JjmrsMbsh8yC6G2ZlWCUmGDuRqUseIXdlh2/40gbqPNVJEwDld1N6dm21IMUec43s5/It01AqgVUwd7WQNumMl4frHZPyRNQOuXGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM6PR11MB4265.namprd11.prod.outlook.com (2603:10b6:5:1de::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Wed, 6 Jul
 2022 10:54:18 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::5008:4f0:1078:7ba3]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::5008:4f0:1078:7ba3%7]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 10:54:18 +0000
Message-ID: <ec6bfee4-cf0f-c5c1-a7b3-726d7e3c6d33@intel.com>
Date:   Wed, 6 Jul 2022 12:54:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] ice: Reconfigure tx scheduling for SR-IOV
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Dima Chumak <dchumak@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        "Knitter, Konrad" <konrad.knitter@intel.com>
References: <20220704114513.2958937-1-michal.wilczynski@intel.com>
 <20220705151505.7a4757ae@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220705151505.7a4757ae@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR07CA0006.eurprd07.prod.outlook.com
 (2603:10a6:20b:46c::7) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b24c209-ed6a-446f-8c52-08da5f3de025
X-MS-TrafficTypeDiagnostic: DM6PR11MB4265:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sv/OCSUhhfeEqdNyiMSNKj8UlaZDGBSS2d/s5G28mDq7WToJaamvRfp5YxG4bWbobJ2VEGbd7XoVAfR1KzF/BJqXT8VyREVK2yN1Ean3pjq4+bJm7i2AYZ+x1b/U+ArVW4DYdfJ4BxwyNrdwVFRQE63p0lgKA8iK/kgAA0olV8VyPiD9952iyOr3bSBUe5VgtaEg5eoLeSeKluDdkVT54RSvRJ8LqFSlOJkopuuVIf82kwxzXxoVuRkHbYUGut4lftfk9FZUTbZt5AQAz1fFnj1cQBfxQBxQBY1y7kde8vahyYCAxdxCvxIaBKzo+bfg3xmzpLvzlhT4+CeMLcAEHyYG6yRLdFd8fQjRC2TRYzV0M1qgzoKPoUzZdcW3Jt0Bba8Gq0413y/CtEDKJ58Onw1TLbvLrgT2q6cyB8as5pOipoCNRZFzEhQoLW3olAPjFGwfsb/xOC725wbejV8kFnrzFSavFF/6I9SAvrQeGoGJKv7t/GxKEDhq85E5+COLTgvgT+yw5/AgiEE7h0TX6BFNd/AXWFoMUyzYexUc67THgsvQsWwWu6lgEfq/AtAkeJtbDIr/foCRjB7CK/QZyv3v78auieMpijraiBB1MAfAcQpdVWrL+OJ0kM2kJLVChPIFq1L7Ozy+vRhuOgUqcp1LXpNPWFD2R+y9QBuwPytd9edf18UOWfaiwXjwMfEbTFzjwotHTesWm3QIKS2gGSCwDdZRs7A1U93LiHL1pUvijIg8nXz5uO5j2ejnEH6JWkAWuauCriSHcDuA1LAtuRoOvSvqMw3BlmqPeviGl3s6yaI/o3sZO9AiPRglRsVXMliXPYgWb0DPAuqk8sYw9+hMoiVlTEBp4yfxAzPoSL53bVyeo/dr1HonyWJ5XCl7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39860400002)(366004)(136003)(36756003)(26005)(6506007)(6486002)(2616005)(6512007)(186003)(83380400001)(107886003)(478600001)(53546011)(38100700002)(2906002)(82960400001)(31686004)(966005)(4326008)(8676002)(66476007)(66556008)(66946007)(54906003)(86362001)(41300700001)(8936002)(5660300002)(31696002)(6666004)(6916009)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1VMVHRqTkIremlCWDlwcFRJTGNtUFVzeFArU1VRcS9GOGloRVZYUDV5US9w?=
 =?utf-8?B?UURDNUtUT2QvRklYd3JJS3N4UkdiN2c3cjFUWmw2MmZGMGVJSTNlOGJnayth?=
 =?utf-8?B?WFg4cnRqQVQzT2xEMkJsckJTSEZ0WWU2dVVCUUdKS2prbVZoVGJlSDJkamlO?=
 =?utf-8?B?K0owOEZMLy9WUUxEZHYvS0JKMXdjRzk3dklwOHJ6ejZ6NkJsbW95RkVwNDdE?=
 =?utf-8?B?TUJHSkMvc3ZXVFFzMTl0UEtyaTJHbnhwaGwvNkQxNmdqSzRxWWd1bmlLR0pM?=
 =?utf-8?B?V2cwT2xtMGRSaUhhMGFBVGhEeVlpWGV6VUF5NXZNdzRRdDBtaTJOZmN3elNs?=
 =?utf-8?B?L1FJdXJCVmNpc1FXYmdwRHRJQjlPRDJQc0JGVEFQc1ZBMXRxcmFBeWpyUDcz?=
 =?utf-8?B?eGFha3RLV2k0Rld4ZUlMdlJncm1hVUhPdjJ0TnNNNUg0SmVwaHFvS3F2Nmor?=
 =?utf-8?B?YTZ6U3JMMDFST2ZNZXUvcE5xbWZ1aTB4T3RVUS9LSTBDaFAzdHdiVlRkbTIz?=
 =?utf-8?B?amlXZ0VQM0dvMHNnYldxYU4zK2tZckdNQ1dqRkZ3U1FYYTNhVjY4aTlQODdC?=
 =?utf-8?B?MmhpSXR4VGsvc3RlcmxDUGg4NXhSVUZZTkhOUnlmRCttOUZrNlhFaFRjUE56?=
 =?utf-8?B?OHIwNWNSbit5WDN5eUlZK09PR0dmV04vWlY4MjBJbU5sQXRPM3dqbWRjbGE1?=
 =?utf-8?B?Nm9MSFEzN2JNd25lT2ZNWDJRN0paS0lNdFdXNGNla01xZzNKNE1salpuaWhh?=
 =?utf-8?B?VnhXN2NPWTlsM2NYUDlTYm1wVnRDM0M1bXlMTmw3dDBvYTlSNWVIakdOWmly?=
 =?utf-8?B?cHN6azhndkNINGRkSHpNYThMQXp6Y3JGS29YQ2tZRnpsaVNlanBQWXZBc2t2?=
 =?utf-8?B?MzN3QVBESTlhY2JjWmhZbGxmd0hINXJrYWtWNHBGOTkwN3NWVzdhbVcvWkNh?=
 =?utf-8?B?dDRNTTdGZStqd0lvSThxZlRhR0IwdGd5Z0FwM1NVTGp4R3JUVVVjWnM2NXY1?=
 =?utf-8?B?cUFpa0taTVFEQVA1K2R3dnpLanFMWVVHU3k4NjI2czBTaXZDT2JjZmlGYllq?=
 =?utf-8?B?ODYzY05CRTlUa2xONldCb1k5TFhxVWpnOHUzYzNhNEFCNWVYQkJwTUxoVHps?=
 =?utf-8?B?UHFOMW1VN3o1ZmZnazVnSSt2YmRMYnJjcGJqTnJQSUYyS3p6ZG0wTEFtdUwx?=
 =?utf-8?B?eEgrYndHSzdxVnBqRHlvK0xrRTdJOWQ0T202bzNhSWl2azgrMmp4cWxjYk5S?=
 =?utf-8?B?c2luQThzZ1pUakRqZGNEQ3UxSkxQWWk4Mjgyam10bVFpMFhhajY5YVBtRFRt?=
 =?utf-8?B?bVg0TVF3TVB0ZTlyWklRUWgyemtLU2crdTNkVWM5Mm5NTmVPek1TMW1yYmE4?=
 =?utf-8?B?azJqNDE3aE5KdkJNWmV4T3g5My8rYkVMaVk5UmRnb2hTV0JjdVcyNFhrRE9a?=
 =?utf-8?B?SWpWcStiRjBoQ00zQ2J3Q3ZFMjRGQTJScENpU3E5dVQxZWUrdFJ4ZjN3eHFz?=
 =?utf-8?B?ZHFlNlJyTEJXN0J5akYyUHc2V1ZPT044ZXZMNzZoWlhKdDRRSW02U2Vhb3FY?=
 =?utf-8?B?NjNHQi9obHBvL3pwdmprZklvTmM4Q28rSGNUWHJ0SFp4T1RabnNZN09aQXJ6?=
 =?utf-8?B?c2VvZTZUQmVTdTVJMFpodkFVUUpIRDEvazhoUFlmaWxoRnlVWlB1aHAwM2Yz?=
 =?utf-8?B?ZEtIWWRTcTJlc0RFbnJxTFZwWlhZSmlsR3YyMXptTFRHOTZPci9yejRwMkVy?=
 =?utf-8?B?WWtMZGpRLyt3QTAwUzY0b0tYdk1lTVFtQWpoWkpKajRZSExKWWFUZnFFZ1dP?=
 =?utf-8?B?NEJ5eGk2OGEycGpDTU4rbzRSdDVIajZUMmpWNEw0bUNjaE0wOEU4azZHMXhZ?=
 =?utf-8?B?VlI2TXo5T2hOY3dIeVR3QWRseG10dHV0MDF5MTdRSGh0eHgxZGZmZ29XMGp4?=
 =?utf-8?B?eUJ3OG9HV2NzaXovOTZubUxvWmlIUkk2S21UbU9SUnlNa0VlU3dwWVJQMHNh?=
 =?utf-8?B?QUFsOHBiaXBIWUg1UzZRS0w1enhiMEFJMlB3YTJtWFJBaTJ2djRoRGV4di8r?=
 =?utf-8?B?Y2dmaGl0VVQ4cDZpWmlzSjFhRjdRUzJ6QWlIRjdsQUdWc3JnZ0o5QU11NVpz?=
 =?utf-8?B?bW5mVkpJRDdlUjcvRWdMTWdNMEo3Rjk3T0pSeThMcGUxbnNCUjFsbVFUTGt3?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b24c209-ed6a-446f-8c52-08da5f3de025
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 10:54:18.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwkfblrnhRLrJetOqV08owVR7h12NM6Gu8D0c88vIVqOIDmshlnINT29jSaDmKBGc239tZ8FDeUb4eBOZ6IJ8XTkk9pNZCYjIJ8P3NG1AXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4265
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for your e-mail.

I considered using devlink-rate, and it seems like a good fit. However 
we would also

need support for rate-limiting for individual queues on the VF. 
Currently we have

two types of rate objects in devlink-rate: leaf and node. Would adding a 
third one - queue be accepted ?

Also we might want to add some other object rate parameters to currently 
existing ones, for

example 'priority'.


If this sounds acceptable I will work on the patch and submit it as 
soon, as it's ready.


Thanks,

Michał


On 7/6/2022 12:15 AM, Jakub Kicinski wrote:
> On Mon,  4 Jul 2022 13:45:13 +0200 Michal Wilczynski wrote:
>> If we were to follow normal flow, we would now use tc-filter family of
>> commands to direct types of interesting traffic to the correct nodes.
>> That is NOT the case in this implementation. In this POC, meaningful
>> classid number identifies scheduling node. Number of qdisc handle is a
>> queue number in a PF space. Reason for this - we want to support ALL
>> queues on the card including SR-IOV ones that are assigned to VF
>> netdevs.
> Have you looked at the devlink rate API? It should do what you need.
> Dima has been working on extending that API recently you may want to
> compare notes with him as well:
>
> https://lore.kernel.org/all/20220620152647.2498927-1-dchumak@nvidia.com/
