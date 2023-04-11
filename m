Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517816DDFF6
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDKPwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:52:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940CD2723
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681228336; x=1712764336;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bmPCFaPoC262AVCdXyM1VbLc216QgL3Ad2NKZi4MZLg=;
  b=jas7haxATb8M2E/AgyAu5Q9EaamHLBHQrJZj5NL04MoFt2K4c0tYaHQc
   wpdRrIABcIshz3YNHsWYY1NcGAGQqgmWepuwO1AZBbWsMTCix4Ho6zc0B
   dOaPqEY0ERMXXgKy/jvMcK60p8/Se+RCjblZWywsuvQsSb5uERfphlcdz
   xmKve8Q23r6CSwLrLCG/BXQKeGcZyREP/D5vQCS6bRCqPGU8K/VxlofGW
   FJLhQigwuT2uwULJroMlEUFbPk2339E+3MKw5TZkUzmyrVvEJKIiQmQ6d
   86JI/DmTHEA6JtVnhlSF40nr8NGIJc2c0U8BH5s1nL4JAolZMqIVx2clU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408795544"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="408795544"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="799967401"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="799967401"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 11 Apr 2023 08:52:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:52:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:52:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyGmNqe56Sx9dt1Fdsegh/A9pMGUaBZONGXHFbmEtPEu4KBi7WJEJJ1fkp6AmtBSqiHBS7ZRtpJoos6BN6aFjvL0HT40aTfkObfpzyo2PbtYg3z0+5ClIG9ace6eeOCnVMmypuZNBfZNKjT5kKSSqNoCneriSp+TnFirL5k0JgNBCKQEmVvs8/24gv7MyqwFo6Oi1wIDaLLaa3mXZm61foUC24z53VAhgOmuEDkSsdWX+SzrIN4i02gJtrXxZ2Gt//RnHVmfkASc1UEli6YkHB/L+5tg46KjU0qMWvdT/2W+nCATKAoqz7ghz1k2ZEW3mTyievmMI4oh91ofnbw6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjqVpVGi5PQIs0SEOzuGHAmj+fCcL0sRB/hbjGle7kg=;
 b=MS+tFTzA5kscKSOTXENVc/pAIWdglzqq27V0fIGx73Q73wT1EwiWPi6vEo/+OdE90TOfaI/EYvUiSzDSAlJCXCihk68flqu+WT4JbifYQWtQznZgtRz4Xx1gqMEGom6xYew46EUCBcuAFSQSIMixf354z1ujd08rmlc4x00G30mqrNrSLmVevVm7ebH75E4BJb0COVN95EFKaKNhzqcw72/lUOb6+F01aouV1GMFb1aHQM6T+uHChBtXsO8Eaap1AY/07JDF2Li+K88NvKCAicULogNIv4y8HRo0Zpjd3813BK6r/2T5wQE+bVpI5Zufyz8lSfebu9rN2K8FQGuJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DS7PR11MB7807.namprd11.prod.outlook.com (2603:10b6:8:e3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Tue, 11 Apr 2023 15:52:05 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:52:05 +0000
Message-ID: <0bc0fc8c-a09d-3310-995f-f44e67a9ab54@intel.com>
Date:   Tue, 11 Apr 2023 08:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 1/3] net: docs: update the sample code in
 driver.rst
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <20230411013323.513688-1-kuba@kernel.org>
 <20230411013323.513688-2-kuba@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411013323.513688-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0162.namprd03.prod.outlook.com
 (2603:10b6:a03:338::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DS7PR11MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: 141db04f-eb8a-45bf-e797-08db3aa4b294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7F2LbQe+kLQ8Ky/fGubU6+KDAnd0C8MLSap9ETUsnohPvIluqCDIm2eqFU6m3LqTAL543y1pwcIYslQxd6Ej5yNYkCvYAIOE1AN6GenyaL+wd6G8LmheVy8BiS6cphJjLYHX8DNkqFQ38Mfz3A0K3kvhbR3Fyu8ZzhJGoL1SLXFcswo5lavVhruo5HcSSrtjRmcdjrTlf2EXRxy8fwQHjsfU/+Y0kRUBtMoN3r6ujrID+U30HvEFrf2EM9XH+XWcPi6lHKGvt3UPm71FJSfIEuWMx2p8jH4WEu1P6csC1a+60CXSCXE1gOJXgN08TE2HN0QYGleuKdCNDjAIirRT/Mag5ZTTL5b9rJW2hsUOc/rS0gwva3Mh7IWLaecgMKg2nrVlHCg0yaRhX2MvMcCep2EGIF0Q0Ftz5964fgdMjW8UVk+X6yG5qHeqZCwDqsE2v0kfob8zPdfuHfcFlC4MzqavMLkZIfxbC5kSyu3iZkdBqJ2PAUldJOStNjsSVYIjHvQHf1TFfD2RxF/ZfUq6Rv9x+RtwS9vli4FQApggJwRwkfRSfrdBxBfDv7nn6Jbo6/yYqQWNbvgvFKgRcexofUP40ExkSOY6T3k1ctB7iqHf8GOaPEQUBXsY6D6KUgncuturkyyYffRtAz36lvJXcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199021)(478600001)(53546011)(26005)(316002)(6512007)(6506007)(186003)(5660300002)(6486002)(2906002)(4744005)(44832011)(15650500001)(66556008)(66946007)(8676002)(41300700001)(66476007)(8936002)(4326008)(82960400001)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b05MM2l5V2wrbzBpRXoya3dtL0VwUFBpcFYwOFZnTml5ZG5GY1MraUJtcWVw?=
 =?utf-8?B?TlFKM3g2anV2WC9wNjlnTTRtUWlHTlQvNmo0ak84M0UrY3JPanJMbHQ0L3Fh?=
 =?utf-8?B?Z0lyYW9yVmNNekpQeTY3S083NnZaT0g4OFlhVUNCSi9UYWJaZlBVeUx1UjlU?=
 =?utf-8?B?UjIzckp6R2lHVnpIMGkyS2xLY29PRWVhOHBJb1NyZkN4Qk8vZUNoOUx2ZjEy?=
 =?utf-8?B?cjZGVkxFcjBxTW5SSjh4NUhYODdrVFA2ZlgzaFhuYy9ZaWt2cTlLOTZDRVdQ?=
 =?utf-8?B?RHFnSWFRUUN5NnE4ZXlaTWEybWNtcVUzVXpVb0JiYUdGSFRWLzdPcSt5UVFZ?=
 =?utf-8?B?VC96WmRZYVcyNnRxZ2RjdG1OS3hMY2FoMU9SamE2dnJYdXp1RE9CdFU3Mmh6?=
 =?utf-8?B?TjFVNm9qamRxVlpTeTRmcndTT0lVTWJJUVQrVmF0MFdkZHlJMjRybncxM0Nz?=
 =?utf-8?B?bHo2eldIdEVPZEdyZXVUSGNONkNjWC9iOVFzOVpmaisxelZOREtiOGt1Vk4z?=
 =?utf-8?B?N2VwN2RqM3lxZXk0bnJnaVFvamVVMmxwdVhWWEZCTXNpMU5jbm9ETHVTMUVv?=
 =?utf-8?B?d2JqYXpObnk0bll5MDdpaVJ2eDdHcEZlVVZJMTkrRVNMeCtqMG04OElkSFd2?=
 =?utf-8?B?cXZaWU1TNnBYaklJcjJBUmIybkNhckhyNG1nOGFCcm9rYXJraDl5ODV1b1FT?=
 =?utf-8?B?UmNTNnhuL1J1eCtjZ3BLcVZpR01DNlVQOWo1L3ppSDN5blMrK1ptZWxTZlBX?=
 =?utf-8?B?VmxQamlycFZBTlZSMHA0TjRWek5iZnRIM2RXNzBoOUZ2US9aQmpjbDFuWGc5?=
 =?utf-8?B?bVRJUWk1b09PNERweUE4UXpSeWhiWnhmdEdKRnhKWFBvMm1NM0V2cGdNMGZQ?=
 =?utf-8?B?TVkreHVKZlhuWUJZRkZUZUhGSlJjU1BoT0dqeXZuQUt2YithTlhla05PZFBL?=
 =?utf-8?B?MElncE1FV1l0b29OUTQ2THFQTWZKSCtmK3pvUW5TcVBKMkxiM2tCL0tzd0h3?=
 =?utf-8?B?OTJzeTl1NmNXbG52V2FaS1NZTTdqY0FmWTBJbk5zVzV4ZFdFVjhMTnB1cTky?=
 =?utf-8?B?R2drci8yTDFmSTlZdnYyZFZZU05NRzQzT2lJNEJiMDZNWXBxZVpLNGVISFpH?=
 =?utf-8?B?UjJ5dGtqc21oZmxIcCtlVUR4eWVCVm15NXFpRkd6dmw1eDF0d3p3d3pyK2Y5?=
 =?utf-8?B?SG1Sd3dxRG8ydHBqYkZGVjJjeFR5WjZBM3Z3ekRDMzhFeFlhNVZ5QUYyYUI5?=
 =?utf-8?B?VGk5OFRObUluaWpZeG9SNVY0UE80R253SlNudnZubjdaRFhQNXNkSENTLzNi?=
 =?utf-8?B?bm9HdGw1SXhBZEs4WmpFeTJtcEpGcmQzVldXREJzWC83ZG1IZDVER2N5OTV3?=
 =?utf-8?B?Q2g2dDN0WHFrN25yaEZuYlc3cFFSTmZQY2t5ZDNsL09RWTRsdUVtS2k5MDZI?=
 =?utf-8?B?QkNyY0F2MDUxS1IxWCtBUXJFSVhZc3hoY0hKc3d5akkyeDI4dFFva3F2UHdJ?=
 =?utf-8?B?dS9wQkRsUUNNOEJIMkJVekJvejR3ZXlTOHlDMUtYVC9qd0ZKVkVrWDBraDRy?=
 =?utf-8?B?L2MrSy9NWTc3TkNDd0xKZmlCVmhxSVNFcjN3ems3K1hlY1hSS1EwTjBtaVBR?=
 =?utf-8?B?akIyQ3ZyWSt4MXBkZ1lmRkJJUFYvaVE5ejEvSWIyOHRpTmVBZHFHZUtyd0xX?=
 =?utf-8?B?SEVIYVFwUU84UmFDTSswZURZREh0UXRSdndMeVYxcUJyZDlsRUtCeTNXd2pw?=
 =?utf-8?B?QndVaWQ2bEl0ZkN2R2FCN0lxdlFEUDdwU2JpNlYya3FSdlg4V3ZvNlNpcENO?=
 =?utf-8?B?aGNON3lvUGtneWJjWWZLTi81aXpZRldkbXR5UGZwaWw4TzY4UTRZVks3TWUr?=
 =?utf-8?B?a0lZZUVjRXp4NWRsZGdYNEt1R1hzYlR2ZkdqL3V0L09zWGkvM3poY1NRRDNE?=
 =?utf-8?B?NzhmUVZnZU16N0RxYkhkekJpZ1k5bkRYOXcvcWpVdXIwdnQ5OWxzQmxrNGdo?=
 =?utf-8?B?eC82NkNwamVnOU92Y3BuK0tOdDQ0dE11U0drNlNnV01LTkxIa2k5QjFPZ1kz?=
 =?utf-8?B?cTgzcS8rMElvaG5jMExONVhyS3FrWUU2UStoMnRPc2VVSTB3dXJNWEpkSENC?=
 =?utf-8?B?WHpEOVA1ekVxa1FCcEdOMXdmVmJ0U3NKbERaNjU3RkMxSldWd1ovMkE3LzNG?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 141db04f-eb8a-45bf-e797-08db3aa4b294
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:52:05.0857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUMmhPjfvWyPWPPpQLuYTfYMQdug1Vu21p9nE2ETcMenIBOzMDwqIcElVPhcjyfV7SNGPlKYOVEGmZxVrXi0tzjscGY3bP9wz+GRVp2ece8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 6:33 PM, Jakub Kicinski wrote:
> The sample code talks about single-queue devices and uses locks.
> Update it to something resembling more modern code.
> Make sure we mention use of READ_ONCE() / WRITE_ONCE().
> 
> Change the comment which talked about consumer on the xmit side.
> AFAIU xmit is the producer and completions are a consumer.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

much better docs, and I'm really happy to see more documentation about
using (READ|WRITE)_ONCE()

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


