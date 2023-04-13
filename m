Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889AA6E14B7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDMS6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjDMS6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:58:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06403C39
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681412332; x=1712948332;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yhB9C9pIXohEEmFtjF7H3MK/Z3nbATRyRqI9/ROegCc=;
  b=EW7747pMSAUXoKL61PijepI2NNJg3W8URbIASktX3TBs7G2B6uybjtb/
   fSWLiWEYq+0gqSlzY2ASQhaYsGrDphNwvWkEUPWhhT8wRervecQq9XamM
   l3tBT+ZyCGimHXh6DAp3T2RON9K/Acca61Lik8MyiPVimxmBfkWxziJwI
   mq6zesEPaAoo4ksAwCIbcvrdl/RnLL6dQ8tMmyeebQmIACkcJWqds+eWT
   R4snxnIwCe3OGCI6jw5XiomDH+teBtEOPFnn3K0JkiJtbAd1mguyqEp7J
   2PP7McpSHNa018ha3ZknueGFDf3loI4DlWX63vNEWGN39pjTAqWHJMADF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346094706"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="346094706"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 11:58:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="754124378"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="754124378"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 13 Apr 2023 11:58:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 11:58:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 11:58:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 11:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5pN36PVU43QoCG9ceXkvRT+lLJCIvWIC9n03jdVkzE4PkYJeBDD6YQjJxwOjc/+jYXCyKfAZqsu5irbZt/MmFJlzqYDNH228u1+B3TMuNXTp2FE9FZDmz1P8LAW1FhYaa0fNRyFFIRrFTER49Mi/rrCcG31IDB3fuEwQ8ERzPlviUgdg5BXnDMUOLkb7jXAO6AdNHw+QYwGhxada5gpgUaUj87+gqxUgBj0avNCrLMqDJIP620BD5VZiBRkyotoKTX1EQ3Pp9wUJk/FYRYmaw1I5hdw0ekBW334bRN6bqP7+LYnAmtYyKBTzWkzPhGZj8+xvNZKvaoz5C0KGUEJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mGzGd+tnfCAa4QRmJcwq0W8Dm3k1vVEXQk8bqcfhQg=;
 b=QeHeLlCGcvBeHlaHDYRvNiHHHF8BuoejG0hdffTG9bBx8TnSfTHHJ4L9zXR8036IcTtnSbaf1kchnuz1X/hcPMHVcji2vRdvLb2bnWU1LClpPCgiZD8llO283EzQiO2WdXpGYosPH2lRFA+8QGK08mDqmMRS4MWUUG1a1glPtQAm8h2gN2XvLmhlMJAzCb+C97MibIc5UPh3NJHlEFSjrtln8qp8w9zEEpYu0nEaDU1PYVbmDi/CPOVw8yPN9YV5RX1K7DoWrlPFggb+2l8dTuq52RTM87N5U1YHb6kSTfXHwiqtn8f6H0y1Z6WwUWVaoisbKs9Cq6XK90dG4zAPPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by IA0PR11MB7694.namprd11.prod.outlook.com (2603:10b6:208:409::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Thu, 13 Apr
 2023 18:58:48 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 18:58:48 +0000
Message-ID: <c95589a0-e25b-e8be-ebbe-7f99d801c230@intel.com>
Date:   Thu, 13 Apr 2023 11:58:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 02/15] idpf: add module register and probe
 functionality
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
CC:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <willemb@google.com>, <decot@google.com>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
        Phani Burra <phani.r.burra@intel.com>,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-3-pavan.kumar.linga@intel.com>
 <20230411123653.GW182481@unreal>
 <b6ed7b0b-9262-3578-1d88-4c848d1aea82@intel.com>
 <20230413060357.GC182481@unreal>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <20230413060357.GC182481@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|IA0PR11MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: d132ba65-cc10-4a39-f009-08db3c511cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrHQcnpjmf6ZJVMwcgItOEBvBIBfDeJAucAmaubr7+fFm4AF85O3zblgoYmRucn0UzGEN5NC8jMEx913pXOhL6RR7uF2b+ihtPshf0sf9dhbnaeeJWCuxtIIxaASjx+iAMgglRpZ+xOUeqxgb66UXB5rIfen4NN2hkcRr6zjImwaPA3X6tSswpCDUQVpLpqolVMQIzNUU6WhkV4Il9zCeo+dUbvbR7sB6uk+Yl0Ruk+tyqOmEf2Nuuphg0WVMlQm+Qgt9DC1i8EIDIKpXIXIPmOnHehN/QMwjzZlcxnvKyZTvvAbLo2RkWrtAmIm6iSO7awWIcWdCyOb1CXGiHQRa/fhLI4KfnQeTLNy2inRDZ45JMNjgs3ebttTX8wtB+oHd5Hxfq+Qxail6bsoju6QXc2hjTje/YXIjmPyKPHgbtrsyR9RstpAGYQhjP2Rqps2kIollAZpOuyKy2XQW2K1twcUmg8gj/KdhigqPCZDhRTiDuJmtDohMPb+bru2uqi4oivi4HwcZRHeyakOh6JUMxm+RQHQdtP72yRNjXDAmBOBaHep6wx7t5GkU9VLO6xAD6NoC5IgvanofoYXSb19ZfdqnjXl4jcCFT6N46C4giIdepe62wwHJR40qVR+yFYOW/cahTRiZ9S9jG+lIGGn5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(6512007)(478600001)(26005)(186003)(5660300002)(54906003)(6506007)(2906002)(53546011)(316002)(66946007)(6486002)(6666004)(4326008)(66476007)(6916009)(107886003)(8676002)(8936002)(41300700001)(66556008)(83380400001)(82960400001)(31696002)(36756003)(2616005)(38100700002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am1rQWg4VGl4dHlSNmM2UXc5Q0tYMFM1aDZBQ3VEQXg3L3daRytNQmtXN3Vn?=
 =?utf-8?B?MVByKytuSktCUWloRnJNaHNjcDlheTlINlp3RFpqMWVvdU1zUGxwK1B4RkFO?=
 =?utf-8?B?L0VQRUtyWW1hakIzbjExdy9DVzhBSWZnNUJkaVRBZCtRQlhLeVlXVS9UaWhC?=
 =?utf-8?B?OGJUdnY5ZFNJTzV1ZU52Yy9kelc4ekl4dFVpbVdiakxDUjJ2SXlrTEhRUGNZ?=
 =?utf-8?B?NUNIOUw5Z2hwZ3FYSkJiMTZjckwxaDhVSG1hTTJPWHVxK1pkbktFMmJ2VDlV?=
 =?utf-8?B?SnkxWUc0cHQ1c2Q4R0FocHFMTDBqbmRzdE1yUGg0cWd0NkZOWkl3THNlS2h4?=
 =?utf-8?B?YmZOZmppcHhQd3N3Wkkzdm9tMU1KRHcxckZ1Z2o4YWVUdmdMbllLS256dXRN?=
 =?utf-8?B?SHpXUG0vdWQycS8xa1FPR0ZJSUFUaUxJcDc4anVCQ1dUYVZDazBJQ1hFeHow?=
 =?utf-8?B?VVFXNFJzMFZUdzRLQ3BCamxSWU1hRnp6em5BcFNoUkhOc3JXTUJqT3k3bXU3?=
 =?utf-8?B?QTJYQnB3SGVnU0swVjRvTjZpbTNWcFI2UURJS1QrRlJOa05XTy9IUHV6dFUw?=
 =?utf-8?B?OEVxNGpyNFR0dzdKdEkreXJCMXZHYjJ1bzFKWmxHQURDc29JcWJxa2NNWlBU?=
 =?utf-8?B?Z3dlbXpNR3pvYnl1ZHMzdHpwWkRZSGdGczRTREhKc1NXclVsOWd0Sms4TW5m?=
 =?utf-8?B?YUtCM3ExbW1keGNNWUZMeldvcUFGTlVXYVZwTXhFZzRlT0RnWnRNVmx1RlBw?=
 =?utf-8?B?QWw1aEdsMGlxVGk0VnFOV2lDaklEa3RLdzlVamNWZXY5VHlYckN0NnViQUZw?=
 =?utf-8?B?V285ZERXZEo2ZkJDM0o0aXQwdStycHNtMFRJSGxMZ0JHNjFiNEdoMFZNUlBN?=
 =?utf-8?B?T0Q2M21RbysvQjhpRGJRSjYxMCsvZWd6MGRQT1U5N24rbzBuSUZ5WGlHS1NC?=
 =?utf-8?B?UXoxVzJaSFVoM0sxb29jU0pPY2hpeGZNRDhQQnhnRmVVSzdhVld1MWMydnBM?=
 =?utf-8?B?Vk5uTEhPaVlCcjBOd2dmVHc3UnRSbStRb2hXR1BIaVI4OXNtOHVjZnl3R2h2?=
 =?utf-8?B?aXVhL0IwTkpPaXFIemZzb2daSVRzY05nK1p2SlFOaS9aQ2p1dE1RZWlZQ3Ez?=
 =?utf-8?B?K1ZNOHczbjBlQndJYlo5cGxWdHhoRkVwSGxDVzhtZkpqV29jVit0eTFPdnp2?=
 =?utf-8?B?Y2x6akZaMitxbUludGN3OHppTER5RTBUS3hTb3huby80a0FvbVgvby9DYmRB?=
 =?utf-8?B?SElpNVBqUC9qS1ZmQmxWSEMxcGkvaFNocitzRy9abCtJeDdiMlR5aFNrLzJF?=
 =?utf-8?B?eWxhb3JqazMwS3dGNEtqQ3F3NjRDcUNCcVk0L29NYmZiR2RtUHRhampPK0pK?=
 =?utf-8?B?Z21YVUYwUWpjYWRXbCt0TGRDL3RMQkd4MHRuSkh1RDFoOE0xdUhDUUtRa2U5?=
 =?utf-8?B?Umx1Y3BUUTBTbk5qTlRMeG5ydTR3NDVVRzJaWVJ4RGxhTTlXL0d4all0SnZK?=
 =?utf-8?B?MXBFWGlkaXNXSnZoRHlPcnZoRjJkakpUOG4rdWY2eFQvc3ord2V0ZkZmQXVC?=
 =?utf-8?B?VXNDbFJyS09YMUFRUHR4cHQxdU1SMExuUlMxR29vai8rak5GdWpVWXV1ZnpW?=
 =?utf-8?B?R01lN0VyTUFUZHpIb2w3WHZFeXYzeXVJZW1XOE9BdTZCR096azFhNDgrK2dn?=
 =?utf-8?B?YmZ4WHNRd2RnekNaSXJBWkpLV051ek50SDRpbE9uYnVYTS8zWkdndEhEb3Yz?=
 =?utf-8?B?L3c3V1kxU0Z4UDRMTTM3b3Y2RDJKTG5ZS2ZWeUZKTHg4dExabjRvVGVDalMy?=
 =?utf-8?B?QWxwTXhCejhEN1BHcXJXc054VnRBcGk4Ym1KdkttVUQrWXJYMnFKYTg1NTF1?=
 =?utf-8?B?SFVSU2dOQ1NwNVI5WnlyS1lqWEU2YkkwSGU2TkZQV09BTnBXTU94WnRNL0wv?=
 =?utf-8?B?NHVFSU5zbmhKMzdxMnkweFZhWnB2MmI1TjRrdmc2TUVWYncwRlhvQUpFRWdv?=
 =?utf-8?B?WVRvRm1wUVBnSWV4YjBuaDRiTUtlTEZ5M3B2RkUvNWtrQ01MbW0xOVhLbFBE?=
 =?utf-8?B?cklXd3Y2QXM5M3FnVTYzZHFWSHVsNmY0UHJ1T3JUUUU2dXhKL1A5L3JIZXFR?=
 =?utf-8?B?ajl3V0NNUjZPZmgvZVA3Wm1CQ3JnVWtzNTNndnJaL2IzQnJ5b0s1MTVVUk5M?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d132ba65-cc10-4a39-f009-08db3c511cde
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 18:58:47.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxP2r7G0sr2HXkmu1JWg47MgcoZ/xD8PkhQn9GXHHWw7CO7ocLXVE9zY8f/Ha5QEFa67rJX+phtRRrAmM6aQUZNTUhjlto83LlTfIPEqM4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7694
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 11:03 PM, Leon Romanovsky wrote:
> On Wed, Apr 12, 2023 at 04:10:18PM -0700, Tantilov, Emil S wrote:
>>
>>
>> On 4/11/2023 5:36 AM, Leon Romanovsky wrote:
>>> On Mon, Apr 10, 2023 at 06:13:41PM -0700, Pavan Kumar Linga wrote:
>>>> From: Phani Burra <phani.r.burra@intel.com>
>>>>
>>>> Add the required support to register IDPF PCI driver, as well as
>>>> probe and remove call backs. Enable the PCI device and request
>>>> the kernel to reserve the memory resources that will be used by the
>>>> driver. Finally map the BAR0 address space.
>>>>
>>>> PCI IDs table is intentionally left blank to prevent the kernel from
>>>> probing the device with the incomplete driver. It will be added
>>>> in the last patch of the series.
>>>>
>>>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>>>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>>>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>>>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>>>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>>>> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>>>> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>>>> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>>>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>>>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>>>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>>>> ---
>>>>    drivers/net/ethernet/intel/Kconfig            | 11 +++
>>>>    drivers/net/ethernet/intel/Makefile           |  1 +
>>>>    drivers/net/ethernet/intel/idpf/Makefile      | 10 ++
>>>>    drivers/net/ethernet/intel/idpf/idpf.h        | 27 ++++++
>>>>    .../net/ethernet/intel/idpf/idpf_controlq.h   | 14 +++
>>>>    drivers/net/ethernet/intel/idpf/idpf_lib.c    | 96 +++++++++++++++++++
>>>>    drivers/net/ethernet/intel/idpf/idpf_main.c   | 70 ++++++++++++++
>>>>    7 files changed, 229 insertions(+)
>>>>    create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
>>>>    create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
>>>>    create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
>>>>    create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
>>>>    create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
>>>
>>> <...>
> 
> <...>
> 
>>>> +/**
>>>> + * idpf_probe - Device initialization routine
>>>> + * @pdev: PCI device information struct
>>>> + * @ent: entry in idpf_pci_tbl
>>>> + *
>>>> + * Returns 0 on success, negative on failure
>>>> + */
>>>> +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>> +{
>>>> +	struct idpf_adapter *adapter;
>>>> +
>>>> +	adapter = devm_kzalloc(&pdev->dev, sizeof(*adapter), GFP_KERNEL);
>>>
>>> Why devm_kzalloc() and not kzalloc?
>> It provides managed memory allocation on probe, which seems to be the
>> preferred method in that case.
> 
> I don't think so, as PCI probe/remove has very clear lifetime model and
> doesn't need garbage collection memory logic. In general, it is better
> to avoid devm_*() APIs as they hide error unwind flows.

We'll remove it in v3.

Thanks,
Emil

> Thanks
