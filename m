Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D114864E12C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiLOSox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiLOSop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:44:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6742E32B92
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671129879; x=1702665879;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pwpF84LlCHWJoiVpot2sg8jw+14qXxypjGwfs5DNKrY=;
  b=GQDMr7Ln9HuWeaE1oODaeDwvfLn5RPu3TJTKpAbkwP9WQh4RrbxNmkDR
   zUGvhmYNj9xv51Ik26EIv7+GNoMTNhq86wBj5eRovVN7rHeNUrTqo+HTb
   D3uAG8Ah/T4Ov7emdKCFrP+L7n+cTlrCFv0f7KAcF79nDaIiO/gPlXNum
   HimJALBtGdymEV+PxtxTnkjvb1L6ThYsKGkmZCIX/3Awal3Ubjj2Do7bn
   pygXTxmyjHHqey9P4jUXNsV2BSKWc2/pklD7KtbMdBWe2S1CjX++D0vhx
   8ZPU5lksz1fMfiWXLU4AF7ajV7SpyljNfrynv5iUPklWiUzkovQzMJGjN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="302195472"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="302195472"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:44:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="643005776"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="643005776"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Dec 2022 10:44:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:44:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:44:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:44:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:44:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAMBZjFGMDqFdvj0UZvfr3A61T1p3BUbBTioc9Mj5wM3kmBaDr/KZxaydm+FVSgzeW4FLzoLZV9Ip0Bf6scl2jInkmKJSHNCuG0NxXLz8hfwWzajUOMPR5oyhOX6OOa9l4Je7MEViYGLyIMW3DmQB4IsyvLogDzupLZwyFDxA9wzKhWga+OCPI4+nNErZnxS2j5HWiAX/VZc43eBztVOv6Ca4TrzYJCinTiIpiOTqDZWFaSqAiZ/VnapNh52sVjtzCnptPCAnXIXsbqV4WmZiPIJO+yU4hOwoVAvGK1YBAaCcmkhVbxKTajRSeL+wnxYYxvDriqqt0+7eJ1gUMyDcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8Z3KzAd3iJ6ji+0Ow0ghpqOhbSPmErR7o0daAJg5N4=;
 b=DnZV3jsYx1axwcxax5DKCOtYPpr5jm6NEq+kyt1xor50NSPtL83D5as6a+hI22M32wgD0bweOUoeworKRDqbQLCOf4FSjfGr+xEPutNOtGqRhm4WQrf/mzfmpwxxN5CiCS2FJioic/PHjL31VOnTq+8KAZuEoYzB9P1uV7CnJFlOaCACsrK+6aPQxBbNJP4ZAgsx/7CU8B3IJL4HXdVsE+sHfyTJuD7joMfzjaTxZb0i2LQDzMGb+TnaB0bRsp0w75mawJGRbsFA5BJ524E68fTljXPaGzdY8xlE0uXt73Tt+RFVVvvBYrswnaWHKlPa7mMSlaMSCCqvJbEDRpnHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 18:44:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:44:16 +0000
Message-ID: <cebb83f7-139d-5d40-5731-425873bae422@intel.com>
Date:   Thu, 15 Dec 2022 10:44:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org> <Y5ruLxvHdlhhY+kU@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5ruLxvHdlhhY+kU@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:a03:333::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 118b894b-3a05-412e-f087-08dadecc5e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+7KfRlmQX8Kn60NLWyfUFNPAsiX8HTR6O0e1q/db9BUzhpCZfX5MNlkS7KHHdNaD3BQr8SMEm3u4VBYHjmrlt0scu41hjU/MaMZI1tNQvPT0oncC7jP0en1lVUc2+mwJEVN3atvgbm8rL5Knw0WAdPriGTAyPjGb3n3wtlIoAZ+BjziY7BzkmVWsTzohGbfU/9HxgYtUtDSTMKZz4SVSu3cESTOpman9N89nIVqLDWeK4ljYtuU7y5HdCsmn+tfexjwZ2A9cWuzKz7H9tZ2KUARsbiVHFVKN2BcfMAdEhPJ1jyPEG17FMzyhdoq1j14Rp+ayfyyT/AqGwa6EQNb44lvVuYjRZfl0wojiDJ7A11UCnvHZD1bWIhZtj8xpVSw3JUHIqLIGsTzhZ5jjfvm4JaTPxu/tqDIciYHZVT4m2B/FLN3gPjOgz5dyvXApiBJ1zIAGHEZwMXq2KYPySjK0m9IlQx0I5fhJHJpWfEJ8JUkqvT90utaeFqMU5PWgaWgMSMmE5/PoY2IfdMMEZiEV+BvxkkU19Mi57fszmICjDRSGptkp9AQShSDwipxjTtyqcpAZLViBiHb+/vLvTlzi+FywbSo9O4aV0/mqXHWFFMx31hmHf7wtdsei7SP88uk67t5b1MUsxVePZKyT1W7oWAOipPuxY6zM7or1Uv9GkyK8YKvFs6cMdLCUF2bkk6M8x3gCHA6S/DMp8ewhTUghAa2mx/7oeeoPsIEsySEm4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(8676002)(4326008)(66946007)(66476007)(66556008)(36756003)(41300700001)(31686004)(26005)(186003)(6486002)(53546011)(316002)(6512007)(31696002)(478600001)(110136005)(86362001)(2616005)(2906002)(82960400001)(6506007)(8936002)(5660300002)(38100700002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UksybkUvRUM3TUt4QTJZeDZKenhWcERRM0s4UmNSOUlpbUhNS3kzWGlzNnYy?=
 =?utf-8?B?Z3VPcWFTcTFycHJXYlVOOXVqVGR6NUpOTkNiYkltU29OdERtOGIzT2h6ZE1I?=
 =?utf-8?B?Qk45d3Q3VkNSeTd4aW15VEZXcktmbisvSlFEWWJNTUdhUGxxc1EydUZEdkVR?=
 =?utf-8?B?RXpzOFFhenBwdHNPdjN2Mnp2Y3dWb0RJZWd5anlWMjVsZVdVR1E2VEVnRWZT?=
 =?utf-8?B?b2FNWndQUStlRlFoRHpEMUIwM0tCVUZsV0xsS2xNWHQ2Wld3aHlHWDNMemVn?=
 =?utf-8?B?SDQ2RjRFMDVGQS84KzJhSWR3Zk5ORGMwZ002NFIwREYyUFBONzdKZlY1eUQv?=
 =?utf-8?B?Z2M0WFpkUEJsUUY4Um8yTklBWDFLRUJlUXcxK0Qvblc2dlVsc25NU0dNd1Bi?=
 =?utf-8?B?cFBjYkNCZnJLNlg0T1k5Mis4RTA2WlY4NVYrV2ZRc3lSY0dyRU0xb2hVdUNy?=
 =?utf-8?B?N1h0NFRHb2lGdThHVDQ0WnhZR2dyWTBkc3hDd2ZRZFpldk80RXI2azBJWXUr?=
 =?utf-8?B?OE5uckFjcWFBUk9RaUJzUDZCQzVLb1k2aHpYWUZvbjJjQmpPd3BRNUViRFda?=
 =?utf-8?B?ZjZDdTlrUUs3b2lEcjErZ2FKdDlOVW9ycng3YmlQWmQ0eTE5bjVERFlpYW5V?=
 =?utf-8?B?bEovYzlWZnpOT1VrYmFBeGpwRmxSdktNUmpvdURzWVBwZFJWU3ZmdGxDYktm?=
 =?utf-8?B?K0NMckRuRDJPdUs0WGprbFB0ZGovZW5RRUdoYUhMWW1kVGMxZmM3ODNJdGpJ?=
 =?utf-8?B?QVE5Uk80M0hVZXJWdmJSVldQYkxxVlpSTmVaWEh5ZlZQbVN1VmJSUzhmb3NH?=
 =?utf-8?B?dWt0WEM1a3JpVVFxOEtUYURmdG4rK3JsejkrVXFKcjRzRTFQRG93ckcvazZ4?=
 =?utf-8?B?czBRMW13STdJOURFRldLeXE3TjRIeUcyeXlEanhiaVBEYjd3TGFKSFNxbHNi?=
 =?utf-8?B?ZTZhdnFCQ3NISTk3NGFvTXJwSStaN2swN3ZvMmZlSE5nd3lSYXhvdFJzUXda?=
 =?utf-8?B?Ym1mYk1VY1J3bDUxK3FRMGM4Sm5DcklqVE1DUWJ3Z2ZzcHl0K1M0Mi94WTFh?=
 =?utf-8?B?aElNRGtiK2NVY2QxaXFPbFdXdi9ESVdLbklPc2NuZVc2VjV5WjZQSFIxSnZF?=
 =?utf-8?B?WUhjTTZtdmxtWWszZStyZjdtaitkRzdrYm03UWdtbngwcjJmWG5kMis1RmFU?=
 =?utf-8?B?Y1RJbThBR2lteTR3QURiMXFxTkdpeFNBTUhUeEpHM0YyWGZrc1NtUFFsbHRw?=
 =?utf-8?B?Z1F1MUVSUFUyL3pHNUxVRXpBUlFPaGVYdW9BbjVRazZXdnlRYld2Sy8yQW9Q?=
 =?utf-8?B?LzRpc3pMbkZFTlBhMEFBQmFEa2NwdjR5NTg2cDAwSFp0Q09vYmlCUFVGVksx?=
 =?utf-8?B?WksvTFJFNTB2VnplU0dYWnNrSGtJdDRES21abEZTbzlsYlRsWEwwNktaOEhG?=
 =?utf-8?B?MGViK1orSzkraXE1ckZmbVlxWDhvUjVUcTdlWUJPRG5FalJGQnd4cTdzZDJK?=
 =?utf-8?B?MEhjR2pxSTBWNGh2T2FlR09Ia1N6eTRXTm1hMEl5RklvSmV1blZ5WUtxUEg3?=
 =?utf-8?B?UHRJL01KTFJPZ3dyUkZyZCtCc3pvMTRQZDJCVklkK0JHYlFFbWN4Y2FyK0E1?=
 =?utf-8?B?L29hT2MrKzVUNzlLUnEvdk02L0lmdldlN1pML3BKR1ZMaHBCSUJLSWpTTmJU?=
 =?utf-8?B?eWxLR09JM2Z1QkgrWWUrZUw0bnFCdWo5MWh4cDQ2VW9xSzJZZWphWk00UDA5?=
 =?utf-8?B?eTM1RDBsM3VaZHY5VUxxQlZKWkFTVm1ranZmOVM1dFJkTG5wb2RneGV0Q01C?=
 =?utf-8?B?dG50T3ZpYUNrSFVyeEhicmRIcEJHQUdSYjFXZklmeUxwTy8rTCtaMmZMYlRX?=
 =?utf-8?B?SEtBMUN2a1pLSnhNRjBQMnA1Qk9VMHBmSHNMc3dYOFgrT1V1a1ZrbDVldUcx?=
 =?utf-8?B?UTZFejd0aGFWK0hWenBuUnh3Vks1MHdWOE5WaE45T09lT0dOQjRYQXZaYm5n?=
 =?utf-8?B?RnNpcmJXM2dBSFIySlU2cGpTV2tUVDQ2TFVGN1AwaWthamROTGRsMzVQK2Zl?=
 =?utf-8?B?ajZqUTRQeTgydGNhUzdIR1lPSmtSQXpFWWZleE52V0lSbUJCamZtNHcyK1pT?=
 =?utf-8?B?NE9VOGx0THhTQ1FmdzJqdU5ocE4zSXJteWxVS3BtTEFUU2Z5aDk4ZFpmT2R3?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 118b894b-3a05-412e-f087-08dadecc5e62
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:44:16.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEwDKcMVlBUfV+D54fREeKcvlHLuaZYw42+APJeb0KKeF67Kdl6Lx73NEupAJyp/m80NkMfo1vZIwvqX2DtS79vUyEp5EklfZbUtUc6sXw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2022 1:51 AM, Jiri Pirko wrote:
> Thu, Dec 15, 2022 at 03:01:41AM CET, kuba@kernel.org wrote:
>> The devlink code is hard to navigate with 13kLoC in one file.
>> I really like the way Michal split the ethtool into per-command
>> files and core. It'd probably be too much to split it all up,
> 
> Why not? While you are at it, I think that we should split it right
> away.
>

 From the cover letter it sounds like "not enough time". I like 
splitting things up but would be fine with just one file per sub object 
type like one for ports, one for regions, etc.

Thanks,
Jake
