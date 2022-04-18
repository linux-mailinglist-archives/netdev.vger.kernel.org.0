Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B2505DE5
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 20:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiDRSNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiDRSNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 14:13:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7517043;
        Mon, 18 Apr 2022 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650305440; x=1681841440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WAi/6D5z5FCnT3F2wlcaw675Tc4ML4lPuAgBGQz3pGg=;
  b=KykneH4hiYyYOHLdrZo9ACPze2b+q51OHIrSJFFEiT1lHcDiTAynFG0U
   u4q+QCE/wsC2vsWY+c2mTM0nUYUkyqz7vGk4HcTU9pP4JU2KaRISGGQMp
   iMNOIURVcz1chhvSGcnOHipbjbOvfXdtqayj5Xa5TkMd9RQQsdVIXlNYn
   lIKCKuOdD7oqQfgXVlqVIXNZNAhkwsRMXzxMm41/IACLEMA0Z2XG/cAiF
   fYlQoyJvF7Hmdc3s6fz0D6BqQUVew23sj6BNVKADrXqpQDo7LGZPhvzHQ
   pbP0ZAew9D21Z+KJEwCUY37ljs+Q11Ag3GgVmkzKmeQ0y8aclvEkXouYE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="288673002"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="288673002"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 11:10:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="561419702"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 18 Apr 2022 11:10:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 11:10:39 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 11:10:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 11:10:39 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 11:10:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEbyDpztXzxZtTb2IvTdIf74VpFN2mR4Z6+u11hORWKa21F/35IRJ18RFSTTibh5oH8H3Mwsr3tTqH7voPChs4aZWbXM65wntZrPZCLnfGGE8bqrRqKwY105vM+I/ujIs1wWuERRm+a3mwHQaHfCHHohtT3J3VxU/M0bjEh8Z/4qEKM1CiHxIQ+07/nSz8c6SoO7FdJVTRC6as7rLMeBCddmYoUccwXnojg+tIeUxMixoGlSZA4yF9mYM7I0ayMKGVjig55vhN1+uUoIP+UWdO518CheEUB/BXC6H7x+je79yx5EqI6WDfH2kXhjcwwQuHrpZTTXL6RvH/KEzVxtng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRizUp1LNuzw8seL1y2geV0vRFNccQ64gfV/OFpiyhI=;
 b=fYnZvoaYnj5TIjUuWkqCuy+0K63wQtNQh3d1gHNse0f3SNjnJk5g4B5NvLA4oD+NFeRRIs1B1Qw1TE16o4ZlTQiErPatX9oQJTLs14MhHM2JL2h/VbyCNPgp3xwE5yGuofs3MxW6mlZqKhrOdSlcAEhMa5i97LxsoJ/XhD+kvB6KlgNBjkLv+yLeeSy+CW2qUv27S0EL5vOlA+VIViu+3YF3XWd1UdXMVrwPIyF664U1A53kHJbSXe2RXKrPVdGgQeu8adufB/ig2lwngt5CuDYpZMrvLO1gmmiNeaNa048dw84iYVGsCw7dupBD6BYx1fWrxqhh8B8Hev3BpKul9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BYAPR11MB3688.namprd11.prod.outlook.com (2603:10b6:a03:f8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 18:10:37 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354%7]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 18:10:37 +0000
Message-ID: <607248b2-bfb2-08a2-3d17-67c5c28840fc@intel.com>
Date:   Mon, 18 Apr 2022 11:10:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Fei Liu <feliu@redhat.com>, <netdev@vger.kernel.org>,
        <mschmidt@redhat.com>, "Brett Creeley" <brett@pensando.io>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220413072259.3189386-1-ivecera@redhat.com>
 <YlldFriBVkKEgbBs@boxer> <YlldsfrRJURXpp5d@boxer>
 <248da3d7-cb00-14b6-12f0-6bb9fda6d532@intel.com>
 <20220416133043.08b4ee74@ceranb>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220416133043.08b4ee74@ceranb>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::34) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f35f0699-b6f4-4a7e-3483-08da2166bd55
X-MS-TrafficTypeDiagnostic: BYAPR11MB3688:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR11MB36883CF973575ECB37D6647DC6F39@BYAPR11MB3688.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8vfc9f0Kwt7zD96Jiqx+qqWZuBJNLdkolBGjRCNSgwIIvFOD4QPQq/F122VcwIhDukcqLedoHUWz99i6MyGnFNP5x4bTh38P1+HlaZcwyT9fWjq8Ya5wsvGq53AJTLhK3WAAzodAB7tgB/FqWLabbGIOrnEo0Ad6hYH17gmbtoxoO5Icw6/QLBsishI13vL+zl9CjJ1DRjVCV22ZR32x8AVoW/x9vybvxv2Ye3+0wMGgAJhMjPN2jbBACcqel61O2atIewYLshL5YAfvqZOV5RrlsK396xj26+X6IeV8RHfDMZfS/8CEIF89ajxFZvm6MgdXMvi+xpZAEa0WR1agr5T3DjVNLBjYskW7KVYGmTb6GZBdlFiVts6YWKl7nPyTHNUCd3KsvfgyWJjBHtb/nLv8YISGXBs0qK0y8MF00tErsPnkthj15fcIH7AmdjnpYxJM/2p3VycNBQxGfubsrg13MKMjak6SmSOyyLqZ1K3YKtdxzzQeJWeTf39+5SjwuYmFkVX0z7TfcU4lsPzwK8m28oIFeSQCXVctrNkRLIJP+BE32i5H39KUPejGMTktyE3Q1QB2RhwEya1H/YJf8rxUA/nQOKo3a/Przhw06ei9EopyVscHHwEU1Nc9libN9zi748X5X7/wawYiTRGmCMVFldKf8z7BCgxNujF1iXHVlV0Mx4phuE1csTVRDUNgNomAiULRPOUEdFeT5qcYJXSXnWSfRGg61bJQnX1YM4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(31696002)(6666004)(38100700002)(86362001)(2906002)(7416002)(6486002)(83380400001)(66946007)(5660300002)(66556008)(66476007)(8676002)(26005)(186003)(4326008)(82960400001)(508600001)(6512007)(54906003)(6916009)(316002)(31686004)(6506007)(8936002)(36756003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L25sbGw0LzFnSjZmaVYwMmEydnJkQnpMZ0lzdjhXWi91QndLaWR2Yjd4R3Rj?=
 =?utf-8?B?YVg5YnQwQ3FGNjRHZGRIN1RyS3RqVEtmb1E0SlpiVit0Q3c1cnJxVnJGQUJ0?=
 =?utf-8?B?STIvRW0reUZuVzR2V3ZoOFI4ZUNCQzU3ZkNxU1QyelBkUGFOTzZxV2hhTWNl?=
 =?utf-8?B?SkVQU1FOV1drS1pJcHYvd0JSZDRPUFhTL2xOVUc5cUlWZHNCZDRYRnJUUGh2?=
 =?utf-8?B?ZkpaQlZ4c2dwWU14c2hIMlpoNXN6a3c3YXlmMDJJdXRNVjdQa2cyMnBlV1o3?=
 =?utf-8?B?Tm9rRStaYUxCQ3IrQVVPRVN5NjdhRUxVV3o4RDN1TlFqTUh0WHdYU0FHVERi?=
 =?utf-8?B?R1B6dmdrTU9OUkpucVN6UE95YnY3T1NsdnB1UWZiejJucTNndVY1bkYrbDVt?=
 =?utf-8?B?YTk3WE1POW8vK1pZNEVPTXFpNndZYzNJN1o0eXJxOGlMcmFIMDVtNHZrUDNU?=
 =?utf-8?B?VEtNTEZpdzNSZytHbjlFcndvdXpVdXlMV3ZjbUVka1g2MXUvenhDYzNjZDla?=
 =?utf-8?B?VmRnQVp3eGo3d24vR2xyeDh0dnQvTWpKdDRxMWVNRDMvbFVNSUE4WER6QU8r?=
 =?utf-8?B?NnNndnZtWnpMbS9xUkZ6R1pVeW1tcnh2NmF0em9kdWhOZEFlekRkRlJ0YzM0?=
 =?utf-8?B?Kzg4eTZwclVkMXZlQ0VaVDk0ajRnSGwrNEJ6b2wvUmlpQll3N1dTMHczaXgr?=
 =?utf-8?B?cW9CeDg2VGhML0VramZTcTdxSXI4d0NpUzBjTm1lcjVPakZ5clJRQlpnZHQy?=
 =?utf-8?B?a08yeHlaUVcxT3doM21saE5wOVNJYllFQXBEanlnTnhzcW5qTzVhTERlSTZp?=
 =?utf-8?B?bU5FWm1VR0FuSnVpWjF5Z0NxN0dOYjc0c2JEK3MvUzNpcjUrMENsUW5NQi9B?=
 =?utf-8?B?RzVaemVMbjJ0dVpaV2pabnk0alJDNzVrZk9FVXhaUkJnNGF6ajBpZ3A2dGdN?=
 =?utf-8?B?Yithd3p0dlFJOFVLbThVTHQvOWRldVpndWZkRXpGVjIyMUJVWkRzbEYrV1ox?=
 =?utf-8?B?Um9MN09URW9pZ0RsU2FwaUpiZkQyc2Z2Y1FOdGhnVWtMWlR3d3paYmhodjNO?=
 =?utf-8?B?SXk1blFORlFpTSs4MjFvNTQwK0xjMEp3VG9iZ242bm03emFmMG1yZ3lOQUNx?=
 =?utf-8?B?RUtiZm9SejVOQjlzdHVDMjAxVm1OOGQyVytLWXdPUjZkbDlZUnVDMTd2aGYx?=
 =?utf-8?B?QW5Gek02Rk1EQVN0TUJlY0E3V0JLZnNqQWpUWTlaa25TRkpQV0Nna0ZqcHda?=
 =?utf-8?B?em50Q1laWEl0RldRV0x1SDJJR1puY0ozdU9kbTFKNklIM3Q2aS9wd3M5am5X?=
 =?utf-8?B?Zi9LemlnUkErZFlSUCtsS1BlL05oQ0FKbEZ5SmNBNHNKMzcwUDEvdTJoTHQy?=
 =?utf-8?B?L0RDTTd0bkZUWWx5eGlFUVQ4bnJvblViTzBqc01QZ2ZPTDh5N0JQay82Y2E2?=
 =?utf-8?B?SFplM3ViMDFaaG9KRG5HZmlGTlJLeXRUTWVyeXQxL1A3aDdxWE9paVIxOGxF?=
 =?utf-8?B?eTVFVWxVMnhSU1d1YktQUTgxTS94dUtzV1VJWGdaaWp6V0lBUWxmeEFCeHVv?=
 =?utf-8?B?RmxzYisvcTdKWHV0Q015N080bGRrMUw4ZTFoQkhmNllNVlg5WFZHdFJtaVhw?=
 =?utf-8?B?MUppNEhxVXk4L3lzT2F2NmFNd01xelNCaTh5ZmNVZ0FMam5VWW41S0kwaHMy?=
 =?utf-8?B?Y2dLNzFSS1hzd3d2ZEdUdTMzZmNZdXRaQ3Z2c1ByMm0xVGtVdkJwTVpER3Rv?=
 =?utf-8?B?YTRUSHloWU50alhLR2dqcGQxbHplc0lTU3NjSEt5Wit4ZWtXKzNOdkJpMHY2?=
 =?utf-8?B?b2dsclowWVRBRG9sK1BPV1Mxc0pGK09qemFaQWVSOEQycll6T1FMeCt2TUhz?=
 =?utf-8?B?SVJJSU0xdEpuTU54Tkh4cTdVWVZTZnJLL2hKL2w2Qld1bGgzeDgzUzhsM3Fy?=
 =?utf-8?B?b0MxeXNBdXVUZitOdnhCci9jc3JnVm1QM25XTEJvRnlESUsyNUduRkJHNnVz?=
 =?utf-8?B?djBicVcrN0RZQzhldml6OS9yWFp6QUE0NjQ3MDNpVkpJRkNsWnJEL05mTVgy?=
 =?utf-8?B?SnUwQ3dycE10Z0lRVFlEV2IzME1BcVBVbFpLNGFZeGhuUnlmVTNTY0VzMDBO?=
 =?utf-8?B?VGF4YUtYbWVWSVJWN3o5RFJlTDdQUzJJYnRRU0pTbWRZRklYTXlmcjVxVGtM?=
 =?utf-8?B?clBaSUZqVmJIbitlZVlBcGdJMG83STIvNXdkaTlubmlPOUdmME5oNWlnUGFn?=
 =?utf-8?B?RnR5Rm1tVnYxM2hzdlUwbVNiQ0svU2RiUDc1MUtDWkhQTjk1TEQ0QUdxb0h1?=
 =?utf-8?B?TS9hSzN1bm5EbVVYcUxSdU5hRGdMZVc5VlhOeDFRd28vKzM2YlpRSXM2TVd5?=
 =?utf-8?Q?8w0vD73dJ3+sL+FY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f35f0699-b6f4-4a7e-3483-08da2166bd55
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 18:10:37.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4PuTvFJ1JzHIKHCzAjdXRbI0DvkwaAWCh88Rjsb73Fl1Et9bBq2UShHzLvD9cWtSE9NusKUsDlaJy8bh1oYamh3L1VgM7btp85fbF86NSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3688
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/16/2022 4:30 AM, Ivan Vecera wrote:
> On Fri, 15 Apr 2022 13:55:06 -0700
> Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
>>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>>>> index 5612c032f15a..553287a75b50 100644
>>>>> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>>>> @@ -3625,44 +3625,39 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>>>>>    		return;
>>>>>    	}
>>>>>    
>>>>> +	mutex_lock(&vf->cfg_lock);
>>>>> +
>>>>>    	/* Check if VF is disabled. */
>>>>>    	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
>>>>>    		err = -EPERM;
>>>>> -		goto error_handler;
>>>>> -	}
>>>>> -
>>>>> -	ops = vf->virtchnl_ops;
>>>>> -
>>>>> -	/* Perform basic checks on the msg */
>>>>> -	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
>>>>> -	if (err) {
>>>>> -		if (err == VIRTCHNL_STATUS_ERR_PARAM)
>>>>> -			err = -EPERM;
>>>>> -		else
>>>>> -			err = -EINVAL;
>>>>> +	} else {
>>>>> +		/* Perform basic checks on the msg */
>>>>> +		err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg,
>>>>> +						  msglen);
>>>>> +		if (err) {
>>>>> +			if (err == VIRTCHNL_STATUS_ERR_PARAM)
>>>>> +				err = -EPERM;
>>>>> +			else
>>>>> +				err = -EINVAL;
>>>>> +		}
>>>> The chunk above feels a bit like unnecessary churn, no?
>>>> Couldn't this patch be simply focused only on extending critical section?
>> Agree, this doesn't seem related to the fix.
>>
>> Thanks,
>>
>> Tony
> Yes, it is not directly related but it's just a conversion of following snippet
> to avoid ugly and unnecessary 'goto':
>
> if (A) {
> 	err = ...
> 	goto error_handler;
> }
> if (B) {
> 	err = ...
> 	...
> }
> if (err) {
> 	...
> }
>
> to
>
> if (A) {
> 	err = ...
> } else {
> 	if (B) {
> 		...
> 	}
> }
> if (err) {
> 	...
> }
>
> If you want to leave the code as is and remove this from the patch
> let me know and I will send v2.

The change itself looks ok to me, but for net patches, we should fix the 
issue without introducing other changes. A v2 without this change would 
be great; feel free to submit this change to -next after I've applied 
the v2 for this patch.

Thanks,

Tony

> Thanks,
> Ivan
>
