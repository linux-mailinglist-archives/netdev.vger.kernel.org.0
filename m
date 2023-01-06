Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D67465F803
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjAFANv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjAFANu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:13:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4353C0F0
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 16:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672964029; x=1704500029;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oOfV40AYFKbz3mVddP4i7vKc4dWBBeMlNkB0vgdw5CI=;
  b=HPe5SXmEpRuWhPiNs36l2owCMOQo2p3kkyvDTjVPPbPt6SH1CdZhEdrL
   2vPB81qK7NDlANl7n9lX7eb5cxeCEfFSpOvEg0W4vdZJjA1xUvTA2QEWk
   nbcp7CD6P+DfTb63pvTg+RfJgu2chtOb+RJcinon6SiL6/wHUq3cYvlbk
   GMPBBPncLS6jevJD03OUKjyJiZCPtThxlBqwWKJYtJ4Alx33mEayW2J2G
   mPAF/bl7Td86qKsLN2grJrJAdMjppZqoqTSuxUSo/T5g3Bw4G8BXtRFgJ
   wU5e9QCAOA5B+yNMnd2QrNC0bAYV+2FwJkYQIpnosGfDy7cCzkN1I/+hu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="321067682"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="321067682"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 16:13:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="901111962"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="901111962"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jan 2023 16:13:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 16:13:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 16:13:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 16:13:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxgkcF+VWScu3SKiNS6VCAlaFer9zEx1nuVqP913KWFi7+AqJ9Jb/miNkLcGI12PFkHLcfodhyuAkpoUup75zFj1DyS9foWWroSRq3UVOKXcXORKPgnmXClg2tEsuGq+NuOnk0T4hDCImXiIUFs1ay08cjVRnJPprv7PUZGnpqIIBt7ByJFfqkO+/F3tKja5HBbbx0H67muau1ikKDtSk5eb0FS3q6Pw2EHlTgdD2liWQmLmUMoRMnFG0iNsRNxPu607ECmg3Lqm5EMLW/ak6y+Ic38X3UUWygB/PpRbEM3LpVNmJYOf5KDZOBkXFI1+qVLzISAilsdr4CMNLYkiXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxztVhSE+FzLArUB4i6pO1XoTA2OYEDcPQ12UnQgfIs=;
 b=ANLbnbiZcnGPH3uoRI8MO/iP1e33SsjRQ6vatACIgWWOieyWhSjk2vbQb0S9IO1DBPPa2NixTZNE2Zo2WBlT/ciqig1k1+P59dQ3UwLNzu/1cqe2DMxufzxbLpeJrTbYUFP6ecJDMFa32c7osXVho4pZkOdPPyExC5VD7TTbjNEm0cuykoIK9URdYRLojrCaXMR2JHqavYQWTycd0Bj9b1n1NDfS1Pa52acRO8Sb3O9pk/ZdKR+KOFszeIXYFfLQwFDr0Yh38Mgllqdk3Y1TfyJRctwSiAnGDHFlhNQLnh9rP4l0n3KaquWpBxYIPn43esr7bjLuXtM53Gibkll+oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB4550.namprd11.prod.outlook.com (2603:10b6:208:267::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 00:13:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 00:13:46 +0000
Message-ID: <1404e736-35b0-9960-e6ac-6b3d290b29f7@intel.com>
Date:   Thu, 5 Jan 2023 16:13:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 03/15] devlink: split out core code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-4-kuba@kernel.org> <Y7aVeL0QlqiM8sOq@nanopsycho>
 <20230105103428.65a4e916@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230105103428.65a4e916@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN2PR11MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: 16131d0f-9b2d-4f18-3433-08daef7ae06f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKPhH/idqdyEj4J98AknUm+zWx4+mhaXftdZfHySx9Ju09ILfRW8EgZTH112DrN18QTaVKlZ2r0v7ZeQPPWahsQn8TtntCwCkbtNzaR6/GOoq2vixEkZeUGgVVNSpecqdwDJ4HnxbJ4+QIxqfdJdCUb722pjj3G76wWJ1CRLX2yvQ1WUdZy9HAHch3KSTyu//8dTlteOrf9vTaIXb6RaLzB6aI/m3K06Ckr0VmKW4dc6S8Euobt+zyoPrdReZGgS/3y29ARsre5JZQYbzVEhe/I1nw1zwqesTCaAUyEGXunbMYRi7Pef2iy8gYWIRHkVAb5W2rsnEWFLk67xdkunpiGGnvFInhFG+NJ5JSFTu/6bbhxETGFZNQkxFnIGHgX+39pdzcRaYwyLejT0YpqXM6qkSU6cRUoMRRAzSmcJNAQb0m9+cYY5CR3FcxFEsGX/ZlGIhOFWtIz75Z+Xzc/VaTLqDJ3VKKxTtD++wIppf5nUTxE1vU077dJbbShzZv9Fg+O0+vXYmz0xtfi08H2YZX7boWjNwjN6qRDe67/AN9pRD2/XxZ7FhavMQ7d9xLInbZxbRLYGpj//PrJWMSYisxqSGL/ei+bdgCGHuGThX8XV3kXL/x6Yb72ai9/qStUoj2Eze6DdWb/URH/idopACcXYKovNs2jolwWrZ9bC6abFXVFMOvHYEZiAhntkrMdbkUGpgy3hgHOj//vllEkbUx4ly6/nIb76HEjK21xJ0wE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(5660300002)(8936002)(4744005)(41300700001)(478600001)(316002)(4326008)(8676002)(66556008)(66476007)(110136005)(66946007)(31686004)(6486002)(6666004)(6512007)(26005)(6506007)(186003)(53546011)(38100700002)(2616005)(82960400001)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0tyVlZnTE5rcTlRb0ttQ1k4czdvaGxscHhkTmI5M2NlMnYyMDI5dEhOYTZ4?=
 =?utf-8?B?V25yT09TNkdTMXVvMmhxMW03V3pDZ2pneHVJc2kweTdpTnVPMUZvbGlwSEVl?=
 =?utf-8?B?UVNzd3pWQ2JyMmFGaXAxL3N1R2crZGozMTY1YVRFQzJsUWNlT01vckdKZEtT?=
 =?utf-8?B?S1JDSXMxY2lpZGJTQlNwRTR2UkRPTVZGOXV5eEI4SHJtLzY4NTd5V1ZrQW1l?=
 =?utf-8?B?dk1qWGk2WVh0NTAvTG15NHlmT0dUQkpJRjdXWHR5VWY1elY0YTVIT1ppZVFP?=
 =?utf-8?B?SWlhTlR3cXIvWHBmM0g0RDNTWFFUQmxtWGpKc1oyalZzbUNiajhjUDBKZHgx?=
 =?utf-8?B?cklkT3prS0NSdjNySWh1dUVJWU5qcFB0T2JZRVJ4QXl3UTFlV2JiVnRYZlhS?=
 =?utf-8?B?eVdXL0ZBZk82OEhuUFZ6ZHE4QmhGVzZBaEFVNkkrbWpocnVZZnpPZU1Ca2JO?=
 =?utf-8?B?SkE4cEQvdFUvaE9tMFZlNHkveVBPOVE5SXV0TGJOZEYzcy94WnZVQjY0UXg5?=
 =?utf-8?B?NEpaUXJOVHY2ZkxjaURBOFAvdWZ2T2hDbGo4eEtJaHZTR3QwTmRWRytDNlRn?=
 =?utf-8?B?aEEvUXJIWFdFeXJkK1puZEZOMjAweWsydEJjVGhHVzF5dHdvdHJqcmxwRUhn?=
 =?utf-8?B?TUxubStnL05zU2J6K1kzcWNiM2JEbjdXamZPR2RsbUJ6Z1A0a2l1cnJiTXJ2?=
 =?utf-8?B?cERvZy9JbXo0TUZZQU1FbUhNNkZBRWtObFdMaGFnRVUvbHRhWUZwNEJPdSt0?=
 =?utf-8?B?SmVabC8yVjZWaTI1dnZWYmhyUGxyR1lUV0NwVjNFekxkd1dPa2I4SUJzb0oz?=
 =?utf-8?B?STFXNitFY28zaXBKV2J1dThyVWpxZTl5cVN4SEdhUUtCZ0Y3QWxSSzNjbWFp?=
 =?utf-8?B?TnRsOGNvNW1Ob29mbmhzUk5rNXhTNjNsT2lxNWtuZCtZWmRMSG1SQzEyVmRG?=
 =?utf-8?B?anh2WDJLQWFRQUUvQ0VBNTkyUUJkNEVvYldrSFRKa1I4VG5ML0hzc0pWdkFP?=
 =?utf-8?B?bnJHWEord25rRmpzQlRWSmZIZFBhMUN0MU4xRWlkc3pyUVFHa1JvM0t5ME9G?=
 =?utf-8?B?SkVzcUtaZGM0SVVoVG1LVytkUnhpZzFpZFF5N0lyajdoei9Mdm10Z0srS1NR?=
 =?utf-8?B?eHFJTDRnaWp3WmswTTFCbHovS2dFQkovQ2xVWkk4c3poUWpmM2N2MWVuTmdw?=
 =?utf-8?B?MTIyenoySTF0dFYyeFA1bEoycVlMK25WbkROeCtjRkJiaHdaQ3NNdDVBRWd3?=
 =?utf-8?B?RWtmeFNobnh0dVQ5b3BzeVhqVVZidVJ1UHM5azBkdjVPcENobXEzK3dnaGZG?=
 =?utf-8?B?YTR0K2NWaTczbEN3eW5obktaN2pUTzJTK0hnSlFSTVFudnlPYWpxT2lQTHhQ?=
 =?utf-8?B?a3V4d2F5TExqdUZpUXFub2QwNExVOGRJNG1ydmxZYWpaUVJ1V2N1di85QkN4?=
 =?utf-8?B?MVBLZVdVMVpqMlM1MjBkTzFsZnJqZk9DaUxma2U2alQwRE9RdCtJNnpWS29V?=
 =?utf-8?B?M1VrMlZtRVBVTzFHYXQ1SDBXUnQ1SCtiSkJjdVc2enlRV1lGck1OZ0VCQ1p5?=
 =?utf-8?B?ODIxNkk3b2Qvb08rQXE2clpPTlF2VGZ5KytLcFgzWGpGY3M3SVpaczBsRzBP?=
 =?utf-8?B?VFhKYlBIcVptdTg5b0E4Vy9QVnVrNFpEekJrVTlVSkwyU0p4dHBMTXNBRDZN?=
 =?utf-8?B?WVBaWnpIVVNOTjRqNy9WTC9RY2lqc0RVREZ0VHFDYnVRcW9FdW9TdG8vdHJy?=
 =?utf-8?B?WjdGNzhackx4Tld3RlhyWisxaVVOY1ExcEhpdmdldlhUQzh6amFtaDZSUG5l?=
 =?utf-8?B?MVZHNlRnSXY3Y1hjTTZSQk1NenI0NVZwK0FiYldsdDJESWZJbmpVQkJTK2U2?=
 =?utf-8?B?YzFNdTZWeDNPc3daMEkzd0o2b0xKWlBWSWZzNUVSekRVYmxPUzhHQU9IZWdU?=
 =?utf-8?B?VTAyQmNCZDV3TnFsbmsvSVJDby85RkdXZ3lkZThjZHk1WG9JZzMzZExwT1lo?=
 =?utf-8?B?bFVnRlI5UGlIUlI3VWJ1MXJER1poSFUwOGs1N0pFVEVoZEQ2bnNCOGdLRmF2?=
 =?utf-8?B?a2pWZE1HN01HcDhIZUczaisvZFY5RWFpN2NyVGhpR1FhdU9CZkw3b0JvTHY2?=
 =?utf-8?B?bVl5QUFmQ2Q3UlptWjVtdWE1d0lpQnQ2VEF5WHJCajdFY29wTytCSGcyc1dM?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16131d0f-9b2d-4f18-3433-08daef7ae06f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 00:13:45.9134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yuL+2mThb3jK9a+SxhKl0KKAWcGcEQe+Mywt4GAXH8uGfx+SuOluf7TqGcTWk7iwfzeJW/ERstyshMnmeLUnwcY4SDmYyY9FAxkLZi115E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4550
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2023 10:34 AM, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 10:16:40 +0100 Jiri Pirko wrote:
>> Btw, I don't think it is correct to carry Jacob's review tag around when
>> the patches changed (not only this one).
> 
> There's no clear rule for that :(  I see more people screaming 
> at submitters for dropping tags than for keeping them so I err 
> on that side myself.
> 
> Here I think the case is relatively clear, since I'm only doing
> renames and bike-shedding stuff, and Jake is not one to bike-shed 
> in my experience.

Now that I'm back from vacation, I can just clarify here:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
