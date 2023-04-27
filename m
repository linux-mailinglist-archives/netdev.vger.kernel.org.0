Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3AA6F0E4D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbjD0WXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 18:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344032AbjD0WXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 18:23:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1D30EE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682634198; x=1714170198;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tt1iQv3Ms7xaCqxClzjULaoNfyL70w7Acrctbm9EZBk=;
  b=F4JlIEcadMLvnjInMzK1w9rtgBZ+SmUyr/ZPyne2pLh2MtsRcIOLV+k9
   BYQ75naoilFwnG8nGfP+jy1qSn34Vu+uN4/VFXUbuh0zbyI2wW9ZwTZ/w
   f9sHr1VkHrRZA8yeHgdgIpnyOzRI8di1ErQ30Kj4EqqeNCVbbRzKQ80M6
   lQMD1IO7WozVamjkAUDg96QnIb+ZMc3o2V7ay8RUmIBphjDcq7Zgj7yEX
   5RI2/t92jXCYqJCzLT1lUPfZ1BLABbti+Kc2EKsI7v8K//L4utaz8reWx
   IwM760AY+qCSMDeApbLDaE5Sf4lnyqrITD97uVMNxrRh+qzFqoPmDXyJT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="410643097"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="410643097"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 15:23:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="644872909"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="644872909"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 27 Apr 2023 15:23:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 15:23:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 15:23:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 15:23:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 15:23:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI2N/hs0QjZCauSt6MUrw4IeSLHhDTB9sq4GP/9mkC7A/b2edqjVHIDx8UMw9gjShSBNX2dGDCwuIChuF+2+2PXNH0kM4VolGRHFo9r2OXU36n8kNILhDDpJaOFEnHY2S6QhoGGKSL8oZzLyG/JiIx+QEPO5HlMOiFR7gUJvqVF1VgQdG3kaMLKHFBB1UGEvRucW+yAhDL/Zl4CrwhZInpXSCyajCfOYwhIoCpBeZ/ru14NsqnPC0KKHGf8DUNb8czB3NyiKuHp3wjgiR/wKwhY4b/qFSRYKWh54Dz+GpgImt+cypZPv54zv8ZeWdcdFXDuiiNuBogm37KDlirIRCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tt1iQv3Ms7xaCqxClzjULaoNfyL70w7Acrctbm9EZBk=;
 b=gOZjX6FQ75mIaIAQYPH/2zMAvZCnl6UYrXjGYxvcVPgDNeyc00qy7U2JbME/+rigE7TaxMOTEKgAxjiKF8CFPvi8SY8zCHuI8QffHKKtRHWkpcyiP4T5RzFb/OiC84G+/ML9cv6DLe0RPMQRioQDAjCN2wMo8DYPwhDHVJPl+e0x7HZUBLR9rZXk0aFxk/GHpxdqeMt+ToJaGdb9JaSoxOpBdaF0olsJNvNc12yh5gRMuNli3QVR3vEdSqJMohdMFqWmovMzYyW+MpB4SI+iCoKvMNS3IhurnDSymzCHr4YXR0jJN6dUT3NPCJu1bt9cXQwMi15iBc2jNTDadh2p6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW5PR11MB5788.namprd11.prod.outlook.com (2603:10b6:303:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 22:23:16 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 22:23:15 +0000
Message-ID: <965fa809-6cdd-7050-1516-72cc33713972@intel.com>
Date:   Thu, 27 Apr 2023 15:23:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <anthony.l.nguyen@intel.com>, <willemb@google.com>,
        <decot@google.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <davem@davemloft.net>, <alan.brady@intel.com>,
        <madhu.chittim@intel.com>, <phani.r.burra@intel.com>,
        <shailendra.bhatnagar@intel.com>, <pavan.kumar.linga@intel.com>,
        <shannon.nelson@amd.com>, <simon.horman@corigine.com>,
        <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230426194623.5b922067@kernel.org>
 <97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
 <20230426202907.2e07f031@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230426202907.2e07f031@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::16) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW5PR11MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcd4194-f80a-40ae-02f2-08db476dfed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcDZPQ5nZ8VWjcpZrhCTw8PbGkgF5kPHmibs5D7KgBxZrDjriIvdspfIB+k1/7+6TUk8wiBsqQZjz+EFn5urT+ckgdacyEN+EtSfy92s2+hpfmEBvC/h1NCQ0qX3LoWReIeZuhRGLK5fKt2LeLTIWc42L/8JZbs70XxoTb7IF9YMsqEcdb2gn4vlcdjBTMcbqpLBH4xMFjmUeVsbpjPTuX3RA8R62evW2QCgSd2e20GlbTIm0q3CsTkR0ODK+NiCB6KhiJvvPeLshyoRkyEMSksAbFzEOiMyBQrfsXyonybFU5SbSYkz5lZThtfDLMMAFq2evCS/mMNazh3QDavBLzDE4H1E+HU/Yg2Jr30UtJ5YW2VlISu014hXYJnnZQSoMGSZ85QtDJ+nZo9heTZQyu3gg9mMQXDv6z3VwszC0U5HpU4DgtJlX6o0HbOwAKAUY7Dw3y245JvIG2ahJyZSCdpxGbURnFNEwJP+2KxT5YivILebcev6yAKRiJ1LEjfmL4PiMTa4OaNFOfoZso8OsFQKn1bka2aD0WqmoMDhjnRkFehdJLLvsP0Ibw9grMl/GpQkIWykBOGc+29cav8TZJY77rkOjRSuTVI3OH6rHxmUU3O0/Y/OLQ7AlES9hpEJhQQYPv1DAHkemeWzvzgVxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199021)(53546011)(186003)(6512007)(26005)(6506007)(66899021)(2616005)(83380400001)(31686004)(110136005)(66476007)(66946007)(6636002)(44832011)(66556008)(82960400001)(7416002)(5660300002)(38100700002)(316002)(41300700001)(4326008)(2906002)(31696002)(478600001)(8936002)(6666004)(8676002)(86362001)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHU3bVhwVkE4RmlWYlEzOTl3YVNPNXFHemljcW5DTDFVZUtZQ2doQnQvb3Rl?=
 =?utf-8?B?M1NTZThwOTNOSXk3MWQ5TjMwTlptK0s1RkRSNGs0RmpSYjVWQ1NObFlFZlMy?=
 =?utf-8?B?US9JcTBtUlZ2dTNYOWFoY1FRL040czVKNHFSQ21ubzRPbVlqU3V0eis2d003?=
 =?utf-8?B?Y0x5c2pHQzhvR2xrcTRPU0o0Q1VOMjhOQ1NFNGFXcHlSNzlJRzg2dEJ3Mlhn?=
 =?utf-8?B?SytGVzB0WVRMenZzT2J5ZnMrRGt5ZFV5dmZIQ0FoSGsyMFIvRS92QjJUMklU?=
 =?utf-8?B?TVJLM1ltT2FqbXluWS9McG9uR1pTNURGTGdqREFWSG5WMEtQMGYxdmN6czdk?=
 =?utf-8?B?N1RVRWZzdkNZdTlrbzBtd3FXK1pHZlgzK3V1Q3VLQkFXMTBDSm5CSkU4M2hR?=
 =?utf-8?B?UTNaTy9QUFhaK01TT2NCSTc4WllFbU5uc0htRTg1Y2R3SkVqZUV5cFFYTUlM?=
 =?utf-8?B?MkZzV3EyS0VhMWh1ZFFEMEhxK2RDaUxVVlBhZnRJM0tnUmM0VDVxZ2VSdEY4?=
 =?utf-8?B?ZHpUbGxXQ3pyV3NtK2RpWlAvb0wrR05zWElkVm9hK0c4UEFhWnpJTEtQNm9O?=
 =?utf-8?B?b0xhQ05sbHV2UUNhMXpZYVloT3hPeUIzRmdrRjJ3cFJRK0hmN0J2UGtlelBC?=
 =?utf-8?B?SFM1WEhZYk5IdDZ0eTkvbTJwS0FOK3Fnb3BmQ1JJQk1xTG1HQ0pib2NOZXRY?=
 =?utf-8?B?Y0dpMURVU1dVWEtYUnRaSDQ1N1c1TktXbzluLzJUOTRnOXUxYU5BSm9vY3ln?=
 =?utf-8?B?WkY1Rzdoa3NWMDdKV0dmL05LdnJqemZDS29aa2FLTjBmVGsyMkxiRW5IOGR4?=
 =?utf-8?B?MDU5OHRmZ3EwZ0g3RXo4M1JoWlVEY2VvTUw5RTRlVENRRlY3Ny9MbFF1NGdr?=
 =?utf-8?B?Z1haNzd6Rk1YZ1VvLzNuYUVFL3IrRXdMSlhxRlAyMVhZRkszc2hJVDFXaGcx?=
 =?utf-8?B?NTlpRnQ5ditIb2JPT01qU3g5aHk2aCttOVBxNEVzRDhISEp0M0dPN2tGbXR5?=
 =?utf-8?B?OHFkaVhwRjRZM2piM29pWlhNcmsrS2czMnFBMVJFYi9IMEp4bkVxekpBazA3?=
 =?utf-8?B?Si9TRFJPelVWOWt4eGR6azZvWUtBM0hPSFNoSndINTdWVlh2cVlLUll6VEta?=
 =?utf-8?B?bU16MVJSckxLRjhpT0FvMFJZSXo4OHhSRmw3dHZrWVRMejN0WG8zY3NhdElu?=
 =?utf-8?B?T1lLQWQ3SSs2ZUhqNE1HQW1sKzZ1Y05XemZiT2hFMXZTeEF0QkJMTDNKQ0VX?=
 =?utf-8?B?bWhqd3BrZTlwNWsvblpUNldTVFdnWUlSZTVqRlk0S1F2K1NHU1U4THZmTXk3?=
 =?utf-8?B?U2VRMjhybVNkZW0yc21MVWZEbnpKTlJtdXR4SnQ3K1M1dXJuZEYzS21PNnVR?=
 =?utf-8?B?emtxUkVnUytyR1VWTjE4b3BEemZ1OE44ako5T0VkclBERkRYWGE2UTBLMlVB?=
 =?utf-8?B?elE5K1FQN3FhNjB3cWk4Z1EyS1JiYTVWeC9HSm9ZMkUvZWNuSUx5RTRtWGdv?=
 =?utf-8?B?all6RGExbVI2djUrc0ZZSFk5NDlTZmkzL28yeGhkR1pLa2I5UnJ3TnhxQWYv?=
 =?utf-8?B?RVJGelRFajZqMnU3U2tZRUdpVFl6aW1RY2s3bzBaK01JZGg1amRSSjRDK1Mz?=
 =?utf-8?B?Y0ZCcWFQckhiOGJVbi9VeGJpN3NMcW0wRngzeVJQMnZsMkw4bE9JMWEzQlpo?=
 =?utf-8?B?V2trdW5VTXhzbm42ZU1vN2d3dHB5dmNWRlE0Z3VOaDlNUE1MSWkwZmFMSnU1?=
 =?utf-8?B?YUsvTEJSZ01DMXZ1VjJiYk9aRzZOcGNjdGpEcWRpZERHMVczZEMwR3NKTDl3?=
 =?utf-8?B?dmdEVEdnZEZUNTRuNzJlRjVGTkF6WXdzYytseXMyRE1ObE1kZmhNMTE5MDVZ?=
 =?utf-8?B?NzZQMWZjaEtRQkxKRnhuczJubUkxY29SMy9wVVUwQVExSWo4RFhiQzYwczl1?=
 =?utf-8?B?Vi8vT0xYRnlMWnRQTGJDNk5oanZNSFFGZlZnT3JlTzNVYkdLRG1uamxUdjJl?=
 =?utf-8?B?NWRIZzZ5SWgvSzdSOWdPeEFkL3Z5Vm5mU3habDRxcHA4R3ZPWUFOS3Z0eStq?=
 =?utf-8?B?TFlQQWt2WjRzS0V1SXJmY2ZoeTI4T01xTUFMbjgxYXdHMFJwR003Z0dFWWgy?=
 =?utf-8?B?UFZHMUVMeE5KSzdIN3dZa3FmSkJqUVhnVnBQTFo3SFg0L3NZSDA2bUtsRUpi?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcd4194-f80a-40ae-02f2-08db476dfed4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 22:23:15.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DK4Ujjes9x6gQlk9uo+x9lo7Qjghg05J8mUS1U+n14sn9AUA/dZ5a5V23HsKUZXAfwkDywBglbGmKYfjBF2PYmQ+gFVL9h6E9+lS3VhvQ9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5788
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/2023 8:29 PM, Jakub Kicinski wrote:
> On Wed, 26 Apr 2023 19:55:06 -0700 Tantilov, Emil S wrote:
>> The v3 series are primarily for review on IWL (to intel-wired-lan,
>> netdev cc-ed) as follow up for the feedback we received on v2.
>
> Well, you put net-next in the subject.

We tried to convey intent via the To: and CC: lists, but this review is
continuing across multiple merge windows and we previously had been
sending with net-next in the Subject and had continued in that vein, so
we intended to convey the "request for continued review" via the
headers, but didn't mean to violate the "net-next is closed! Don't send
patches with the Subject net-next!" rule.

I reviewed these patches but didn't block Emil from sending v3 (right
now vs waiting until net-next opens).

from the other reply:
> RFC patches sent for review only are obviously welcome at any time.

In the past, we had developed an allergy to using RFC when we want
comments back as the patches had sometimes been ignored when RFC and
then heavily commented upon/rejected as a "real submittal". This may not
be the case anymore, and if so, we need to adjust our expectations and
would be glad to do so. In this case, it didn’t feel right to switch a
series from “in-review” to RFC on v3.

> Jesse, does it sound workable to you? What do you have in mind in terms
> of the process long term if/once this driver gets merged?

Sorry for the thrash on this one.

We have a proposal by doing these two things in the future:
1) to: intel-wired-lan, cc: netdev until we've addressed review comments
2) use [iwl-next ] or [iwl-net] in the Subject: when reviewing on
intel-wired-lan, and cc:netdev, to make clear the intent in both headers
and Subject line.

There are two discussions here
1) we can solve the "net-next subject" vs cc:netdev via my proposal
above, would appreciate your feedback.
2) Long term, this driver will join the "normal flow" of individual
patch series that are sent to intel-wired-lan and cc:netdev, but I'd
like those that are sent from Intel non-maintainers to always use
[iwl-next], [iwl-net], and Tony or I will provide series to:
maintainers, cc:netdev with the Subject: [net-next] or [net]

