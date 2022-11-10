Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D4B624878
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKJRkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKJRkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:40:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718324973
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668102010; x=1699638010;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z+a7LEGfq2opoa5QqcY1UnmgpMSty+qaUdMbjDgNOEI=;
  b=jLrs3IluOgZQ1w8xozBGmYxl4+J5LODbuMt1NWMopI+RRzs+LMGKoVfb
   2fUDsDcSx2fxjJjVV18BEG/QL/bkLV/GyxaduMWVbGc01Zr+nJKGSCAQc
   6LyhlgWTSDajgxuFIEMwLsfjiQUvExzPB41ocLrI8OlTSZvFgwrJUiMo+
   Ugj/XSGvlwBLM3OSHkqHX1JJlyuGOfEE7md+vO109GqeaGEdoERra4Fhj
   nXhSTUQ+tsABWH71Zvv/8rrpjUmo4AM0FhaEQbbLJfjWs8LE8/+WYT/Mm
   CVUBymZCX3XVkaF8ll0fYjrQh85EPakILBD8Pcrq+rzD5vZJkFup6sKFs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="313160466"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="313160466"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 09:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="631740122"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="631740122"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2022 09:40:09 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 09:40:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 09:40:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 09:40:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 09:40:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOOmN58fhJdSjDAQK5fSPJDeZyGiHUVYSHwP4xhIRM6amBSfdqO9ZTA1BwywXtRu2Iq4G++srKRrsCq6D3L18IUCumR8ZMpwHBYhZx1c6ar6+FpCl3WcSz4Iz9RIAnBP7jxeNvzVu4l4uN7+aGF+IZx7fBbJYWeh5o8SmKV39gJx9cDiZy4OTT9cMXgGoB+RxNpXwiuGuobjoSckHKFzcT8Ma1Y7LdIu9nkl1SXRxzex13BKL0qMdvARo/HcNN/P2m0/6xFXJ5LghJ3YDPwdAR06JcQ9gJQknmwY4ozibzFZfdWVM/O0Ma7IiMU+1Lr0FY5Ak+NfProuGjZuMCynHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+a7LEGfq2opoa5QqcY1UnmgpMSty+qaUdMbjDgNOEI=;
 b=YSHGlpo7YFo//KDFXRU9kVqs3rHOyVUuPmVl+3rUqKfNGEWJzCn8zmqjtA9SzzzQnS+m2PBzAtp2r3k9VtSIEfQABYJm5eE0l8a4T4ZKshQLxr6RBdsx3EArUAiJErkUWlt/xEGWIj0kYwN4BzfPM68vtSroY7ohKPVwsQPJjR8qrhgriyDu8vN7+N71uR8x7zYYVEALMEH/C40img+1IpN0Gz006pzrxmnA1QlDHwyCbyH76Rfpc16/2rdhlrD8SKl4eenMnShHnpZQ8VjkwfzBCODF1YHBQx31ce3LdEstcAxM5SWn4LTuXYIL5PaSTjeKVXfRDOXXveT9/g/aMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SA1PR11MB7062.namprd11.prod.outlook.com (2603:10b6:806:2b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 17:40:07 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 17:40:07 +0000
Message-ID: <d739c8b0-e43d-4b7a-f312-2edace91c953@intel.com>
Date:   Thu, 10 Nov 2022 18:40:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
 <20221107181327.379007-11-michal.wilczynski@intel.com>
 <20221108143936.4e59f6e8@kernel.org>
 <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
 <20221109132544.62703381@kernel.org>
 <717a9748-78a6-3d87-0b5a-539101333f57@intel.com>
 <20221110090317.3b5a587c@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221110090317.3b5a587c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::22) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SA1PR11MB7062:EE_
X-MS-Office365-Filtering-Correlation-Id: f45ef9fa-3613-4795-a796-08dac3429b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhUGCOYfDzHAelFoSS9GJBsxeyoirSNanUsdPSbPw0OaGGMUGYHvCzBEzjr1VYi8wxt1VULODb6jPCrUOQCcX0lB2KOGGWsIeAExSZG3ai76c7uo4PJKLcb2k66Pg15MeY/MR8ittgPyW4AcsPT5ryeu3ncRU/5D6vZXoEH1mieAZl90f+s8PQJ0d3Lic/2VDC0elHJ8qCMceWvxlhrvnpNZnwE62bjPTTUrKbznGIDx4PI/0FJ9BOvkF69sG7EBKqPZkNuPjAAyLD+P7hyd7D8idmixV4d7UGV+Dddhtz+IhbJc9Reaoa0peXRr5pMooMsrcGysZ/m6ph6zSgSmzaqNGAy2VDbA4avYZ/6OrTC/EkfYII1HEJkllnOTbmLFeBVOZZUOuTO/8S3rUIqoftM0CwJpbG9YS2gTEy2GbZnbkxYQnSOlemlub58FI4DroZ0r380sSsH3xOyeC/gmxdyd40PNlF8RB64FRrxe2RktkqPs5TQfSUP2A+4DuWhXNmX6CcreUoo4UA6QyYvYxjJTOEjsq2NOfS2CDNOBviic5wO0SRCqPL8tL8lVBKFPBCJqu+psEmeIzRnAcZwh1ANECMhbE9bUZHaKljjaEWoRdZGNYuaQy3a8yZuG/MW98FKiHxL1BI1PWyuq/3fCsv2BiQmaAnEKzOOFrFLY8fvw/v/YBNzouq7k4rmM1d4wDQfqkGOj71USiv5MQcLceiKPwDlmVQ5o3CK5C6/gwL+vB+3XCLWqyPrYh8t/GRG0YCM23/+VcUD2GA6pAQH/0rBymUVeXlL+iKNVqOrSEHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(31696002)(86362001)(36756003)(66476007)(41300700001)(8676002)(26005)(4326008)(66556008)(66946007)(6512007)(4744005)(186003)(2616005)(8936002)(5660300002)(53546011)(6666004)(478600001)(6486002)(6506007)(316002)(6916009)(38100700002)(82960400001)(83380400001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUpSSUxPeGFGb212U3VDN003dEpLL1pjYkVpeHg3N2ZWdzhuVU5RUGxPdW50?=
 =?utf-8?B?R3lZQ0psR3NKeUhBT1NuQlhTYlhMNk1oZkRaekRJdDBpaFpIYmVOcjJMTEhC?=
 =?utf-8?B?dnVKKzUxZkkvcEpmaHRhRDRaWDhJdng4OERiLzJQU1BYcXEyVStuUEYvL29P?=
 =?utf-8?B?VXlKdzRvaXZaSEcwallySVNvQkhiZEhwcHNEenYycmhaaVU1Syt2My93V3pC?=
 =?utf-8?B?ZkRqMklZZ1hNTHVRMGxNZjBPRjJMZm5Ia0lHYUx5bVkvcDNZVHhUaWFRcTJ3?=
 =?utf-8?B?ekF0SFhzbXkyNDk4Q01YWDcvOEozeEpzN21TL2NJZlpiSC9NbGR4c0xsVDFm?=
 =?utf-8?B?Y3NhQ3ZLRjMya1FJbHJmVVpneEExWjNmSWZ4Q3FCVndmNXQwbC9SWkdsNk1O?=
 =?utf-8?B?OE1JNzJtdEVkVnQvdjM1d0g4bytvbGNMVis1QTVjaFJTeWYyZzNBZFRDMk85?=
 =?utf-8?B?Y1BYbEhhbkE0aXZhK3FDQ2RqeVRxVlRZZkllQmlkU2k0VTNaRTRTaDJsUEI1?=
 =?utf-8?B?NlB1K2RuZndmVlN2L0hGTmVjMURxVkJldEpXaDFGY1BHRnNwakJGb0xFdVZ5?=
 =?utf-8?B?SnIvVnBZdnE2eUFuOWxMd2x3VUFHM2gxekdiVVZvVmI4QVBHUlpweU9xWVM5?=
 =?utf-8?B?M1l4Rm0rVDFoMGt3TWF3bFhKei9hbDI1blZqaDJYKy9xeG9RMnM5MEorbnVS?=
 =?utf-8?B?c09ULzlNbGN6N3lVZkl2elBFREhNdkpWZnY5U2RaT3hqNkFXUjBZVzc5M0pD?=
 =?utf-8?B?MHJMT0JDNHVjS2xKNklPRzhSYnJmei9INk5XWFZaYm1PY1ZUZTBWaElqb2dG?=
 =?utf-8?B?aUJJbE9abEtoNW10L0x2Q3BXNU1sOUlCMkRaT0ZSeTRRd2tSYlc0UXdoYjJk?=
 =?utf-8?B?QnFpb3QvdktGVWhNMXVOckEwQUtzSyt2NldQbXFSWWdQSlhaVW1wYUZtY2Rr?=
 =?utf-8?B?cVpUUXc0THlUaDdRQXlnZE5ZeStlUWVLTDNNMzF3VmZlY29HYnZCWGlzWXdk?=
 =?utf-8?B?c3VaMHQ4T2c5bVNHSmRBWXBraDV3QmlLMk85ZzNNSTV1akwxbWZwOXBUaXlC?=
 =?utf-8?B?bTJ1M0p3cStiUWhqa3MyekN1WFJldURiaG4zQmNIRnU5NEFNVVN1STBPM0lG?=
 =?utf-8?B?NGp2aHdRQkpmVkNqNWFEeHJ3aWNHaGhrUGdndjdNSGtHN3E4b0pHdTdvTmFo?=
 =?utf-8?B?TXlJNEJOSUNMVUlDaFNkVHJUYnN4WXdiTHJtMWphU250YUJabzl1R1FIVWxw?=
 =?utf-8?B?MzBPalJaR2pPb0o5Rnd4YlphUmRrZ3VzeTZrNkpuRDdMMmdVRjJUL3Buc1RC?=
 =?utf-8?B?Q1dETkc1ald6eXBiWGpHTGo1MzhlaW5kSWpYdTF2WGZadlJNVlRnRlhOb2dj?=
 =?utf-8?B?ZjVIZ1VwbkZyWTc4ZDAwL1dSK2dVTmdadkdXSkFZZUVyV0dZZytEZDlWek5i?=
 =?utf-8?B?NEFIUU82dFN1MzBBMXZ5Z3hyamVZWkxnRWkwSGtqRURGMWhHY1BoM2pCUU51?=
 =?utf-8?B?R1ZxYnVvWnB3N1J4Y1RQMktDMlJ5aFhTZElpNXJWM1JCYWpRNEROaFBBeWxS?=
 =?utf-8?B?TzRZWUo4RnFyNTd6Q0lNSlRDeVRPb1Uzb001LzZOK1IzNmF0Ui93Rm8rVTZ5?=
 =?utf-8?B?dGtxOGk1M3BEMVNkVkREd3BDOUlSMUN5RlROZG9YNVZHTUxvT3E2cmMxdGVv?=
 =?utf-8?B?RXBNMVZVSGozU0ZRNzRCQkF1M0J1aUs2bXcyWjJLTXVnR1NNTng3NTNuQnFF?=
 =?utf-8?B?OE42TldneHZGaHprbkI5VGxRcVJXZGh2V2lTQnJoWTFlRi9KZk5iN2ZvVS9D?=
 =?utf-8?B?T1NrdUQyQTBOamVKcU1XaHZTOVErQ3A2VlR2ZTZqWVRNK3NBTVNXYXh5TTE2?=
 =?utf-8?B?b3B4RDdBQitaVFF6ZGV1SVpnTmRuV250cTVJVXREUUZyeHVxWGNnYWRmVnc2?=
 =?utf-8?B?U3FhMU95N2UvSEZ3bkxPZ3Naa21WZ0x2cDl0WDgyL2lWaThiVXZnc1FpVFdw?=
 =?utf-8?B?eGtoNkdnQm9xZGticS8reHFqTkVEOFZzNzlVNGZLclNIcFlTUmZtTWNzSHFo?=
 =?utf-8?B?T3NwZDl3cytPb1d3V1ZZVEo2WWJyOWg1b01BOGdIOVlaWkUzL3B3TG5ZS1RD?=
 =?utf-8?B?Tzc4Rys4QVlURkVuNXVpaGdON2lGMmdralExL3U5Tzh5ZUVqU2ZjZG9pNkpP?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f45ef9fa-3613-4795-a796-08dac3429b4e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 17:40:06.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPXt6xuLcdPOwNSAc1xK8CUy7nMA6FOzqIMSOMtfyZ/gDkxc7FD4t8gdwlBJ2t4NG2bSRvHTR1KB409reJFxnoIKfJn8PNPIDo4FJBqBfYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7062
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



On 11/10/2022 6:03 PM, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 17:54:03 +0100 Wilczynski, Michal wrote:
>>> Nice, but in case DCB or TC/ADQ gets enabled devlink rate will just
>>> show a stale hierarchy?
>> Yes there will be hierarchy exported during the VF creation, so if
>> the user enable DCB/ADQ in the meantime, it will be a stale hierarchy.
>> User won't be able to modify any nodes/parameters.
> Why not tear it down if it's stale?

I don't think there is any harm in tearing it down in those cases,
can add a commit that tears down the hierarchy when DCB/ADQ gets
activated.


