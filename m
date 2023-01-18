Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F13672A41
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjARVTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjARVTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:19:01 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B015457CE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076738; x=1705612738;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3qeZNomDR5NZFv5orHJV0MtmtUxPodTPg4Gijw9WKGo=;
  b=gP7n23pfIpl2NHJ7zD50smc2+42pKbtizDDmNEFJgw0/Z+NMvgobyp4R
   CW5+VmEjRM9xLvHt7HOmUbv/2G4N1tg9LTjQq1ITP1tXLPqDSB6VAIZeW
   0Zrqn4QOzLeKVzF3xnBeRA4TJy+xtop3gzPgD/vbrSxCz5XjWnHtQAL+4
   UVIOJPoWFyS5vgBoBMbwVETx743FH6ccZfTtLktMxm/Kb28D/kk0uCtC5
   LHkuN57Z1ELjNymhBrMFXFIyNnLVZ6CUe2NXh+Wg7FD3shE9ET89WE2cW
   byTCPaflatkxIC2w3ihDkRvmpWM3fkcsQIdJTd769WKthBMdMlybPKPct
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322793240"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="322793240"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:18:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802366362"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="802366362"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jan 2023 13:18:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:18:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:18:55 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:18:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8MJhMIb2LjV1PyknOr2YObfedmDFB6kTGLprOpP/BOJywTi7JABKIptnFvWg6m+IHAPEgDUN9U7/fDev42TH81uNNNDL56gZvLYBeccuK0pnz5SFO6RpMr9CXkN9OaF8Jd1hZHcuWpLuhk+G4SyAA9WEitXJD5awwHBqHfwUQtqmzJ+mHtb9n9LkPk1IqAYAr+TPiheGW4QkMpR2vgKgBjvf5T4iKCnN4e5iXKA18tcVcVC2CQuAw0T+G66x6JCAR6NAFsRN/26YPPb5VbzXqnTzJUWIvzF+azCs26W4sB15XmZsWnxTqo39lXGsKrsBTeysi3VwP2D3SkXw5PXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aFViURusvfWGJlaKo8I+YOjtED6zG3+5S+v3QXK4AY=;
 b=mZRMrwahrCiC5mS59Mdplr9dZEjy5rf28uuOE9zoGSGG/u7+rsE44Q/yUaHm5YAuN1DpIZmXun0waKjXXqIOxSHdAY2BJFPSJfOTH22AlBvEiuIFyudeZ13g2kMdzfImko3O6pVbL8ZUGHZ+m+TbQVBvlDw93fvgz828yvWGoKXocOicFmgkbXHwhDPToZ/GNI7JKVicEMSvp/WR0iGjqG+1ya0oFNlaLvrUAk3zvsx1Rwf21SZAo+aGrNTOotSTDr/rm7iYXZYYHcerR/DIVvwvKutnZa0wyFHY7TNjJjWl3+O7RgWCDvSnPNEF870/aa1fBEp6jn2ua93zfnbOcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5312.namprd11.prod.outlook.com (2603:10b6:5:393::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:18:53 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:18:53 +0000
Message-ID: <b17b7e6e-4d38-4409-4832-6c0d7b57eb81@intel.com>
Date:   Wed, 18 Jan 2023 13:18:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 06/12] devlink: remove reporters_lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-7-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-7-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB5312:EE_
X-MS-Office365-Filtering-Correlation-Id: 097856bb-8e7a-4805-571c-08daf99999fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWAwx55ukXuUd3+OKmMZwtgv/xYdEYmpZGtoF0KVWvCNGcBOAVf6F7n2UO9tbvbyU0iRbP4pqtA9qdHbfow86ScCA2uyijrFewx1wuJtj5pG/VVUVyXSX2ChC96Z96/k4LYDAXP3pRRX5aXr6rBtIQyBiVDIG/7j8Djkf+YJNkhCqRAcbqqUkMRggN1OsdLIr2lhP7fjL/VMNpLmijWsp8HrrDeD3CiXF0avDMBqvz3lrZTnfzL5BGqvijmztykdlmL75OrqciO6WlZANlCeWnRy5orvO0y4gUiwWK/akgUi35QTiLMWS7sCFfO57++IDT0rwzP0y/Xja7hmz4DwVolvGLSncJpZmp5sok94slNlX2RHHaQagwS+warQi5pKIoP2kp64QEsUj1KG5JWAaOnfInVOUAqgu4tfEYOSavSEiEO7L0EEvegQN2Dv5N1dmcpRVuOOHhaV+ekcJPzIodGfCkaSa/L4pn9m+t0IUd5oo5qYMdOnBbyYfpCWfRgZdMkoc9+T/Gt4zO+/rFHOgurWWvNlhGOoq6lARJcYgInHbBeRyW5ofWDiXzWjd7aBuyZQXoGZeA7a+uO55UE17GdjPq05h6h0uXd8hT6+Lg6nfjpEwdlkz0yoPDQoIUu45jZQ27dN8A0+9pwm9Wuj2gONhnlwsdUixJoILViR4BV7Z/lPVQVbWNzEd+iw8IYeLZIzIpl3ce0mckYaL0zGMwimB1Pdkj4S9R4zLZ6ciHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(26005)(7416002)(5660300002)(86362001)(8936002)(2906002)(83380400001)(31686004)(66556008)(478600001)(36756003)(4326008)(6486002)(8676002)(558084003)(6666004)(41300700001)(6512007)(38100700002)(2616005)(66946007)(186003)(31696002)(66476007)(6506007)(53546011)(316002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjFwTDJDeWQ2bVpSMGhjY1I4WHpiN29jMitpQTZlSnlMUk1uUnpuUk5QL2JH?=
 =?utf-8?B?YmdtTWx6NTFBWjd5M1AzTkdaQzlzd0xWa0ZycDBqSXdIa3VCbkFzdmFZVUtI?=
 =?utf-8?B?RThlSEIwT015M1VUSGlPZXRwZEFoaW5lSllyV21WNGlmWjA0RERPWUQrdXZW?=
 =?utf-8?B?WSsvZTVEMFg3WUhqMnY2TEo4eU1pT3lnbDVKTXFBcHRrWldSSGx4SFl5Sjd0?=
 =?utf-8?B?RTIvYStFSmdsNHp2RWl3MEhLYWpvY1d2WGdzNmZCYjdyU0xjRDhRMHIzdWZu?=
 =?utf-8?B?UEhVbGU5Q2JDRkdXZFNDNWhlMWhFTm9Yc3Z0V2J2aDhJUXFuU1JlejIvNFlz?=
 =?utf-8?B?dU5aNE1UMk14cmkwckJSRVp1VjY1WDFYL2MrTytVNHlQdXMrMlBPYVBOTDB6?=
 =?utf-8?B?R3VLVG5nSkpCM0VSQ3FyTUZMNHpHaEZVWGpSN1M2YjdYa2wzNGpxK2JQQmV3?=
 =?utf-8?B?Zm1QT0tFalg1RG5DS3dob0VYL1FFcU9PU1h1R3pDWmpOQkxTVzY5alNxbHcz?=
 =?utf-8?B?RmFRN2ZBS3ZzQ2FlMWtkWUZqMkg1ZlRCYU5GVnh6TlBNUTNkWGNaRXNQb2xF?=
 =?utf-8?B?K2owT3FIV0o1UGdOdGVoMk5aWW9nNW5WN2dTU1BUOWdlYzdqR2taRkV3OWdz?=
 =?utf-8?B?cHUyVGxlZnJ3UXEzeGJXT2x6STJzTklvTS9TV250Nk55RnBqbk9kQ2hUVHBV?=
 =?utf-8?B?aEtwczVSOWVNZHVTS2N4UXdJaHF6ek5LUTRXQWtsUGNLRDBlWStPbU82VTFw?=
 =?utf-8?B?QTZOdDRCdGtsSFVocVpocG16eE9hdkM4UGd3K1BjTXNod1BRLytuTWVJQ2Fo?=
 =?utf-8?B?Y0g5UlRoR1U1bmpvdXVIc0JnV3hMQTBqOFVTSU9wSy9LSTdaOUhWdHh0azZo?=
 =?utf-8?B?QllQLzBqK3JtOTI3T20rZTZXcmlFM0JJMEk2cnZpd215SDZNWkcwQnJXeDho?=
 =?utf-8?B?UUQ0RitSVlBtcnN5UDV3Q2h5ZXhFZkFCT1pQcUFOeEFwVDJiTmtMakF0eHhU?=
 =?utf-8?B?bjREbU92WnB6ckhidmRISWswYTRTbHA1WittaEFNa1JleHB4U0ZMam5GRUgw?=
 =?utf-8?B?RzhUdHBNbkFIQmdFaDRRRXMvTHpnRkpsRGdITTNMQnJpaU1QejFwNnNQZGhM?=
 =?utf-8?B?UjI1ZlJkVkU5dngybWdaSitPMjZScnhKNzl3UVBDS2RkZWFic2U0WTdRRjhM?=
 =?utf-8?B?RjY5eFY1bTlnZEVsWGNYY2FWOHl0Y3JQWVpDNTdKTmJrVzlpTjFYcG9iL3Vn?=
 =?utf-8?B?Z0hMSnlIUWp6bUNJdzB3TDhUWHpkcVNkK3dpVVlZQnUvM1lwVWk1S0Z4V2Zy?=
 =?utf-8?B?Z1dSUzFxdm56QytwZnB4dlRSRHp0U25HTUMwRFByYkJyRGhsY1B4dVZ6ekRh?=
 =?utf-8?B?c2VjcUVjSW0wMHNzUk03VHlEQndTTVovNlgzVml1aS9vdjVUYXJwdTkydkVh?=
 =?utf-8?B?TS9hZE9QTVNLOUp0UDlpR0pjK0FDMS9PQzZ3bjRHM2tucFRNTkdoeEtVUXZ6?=
 =?utf-8?B?NWp3eUZldmRBYVFTdXN1RzhsMmNVcU8rbUNReUJFSnVVUm1VR2pmUEttdStz?=
 =?utf-8?B?ZnQyTEJhSVFxYnQwbUEyL3ZxZW9LVEg4aGNRaVpuVVZWblBHWTN4d0JnM3dz?=
 =?utf-8?B?S2hvenZva012cGdQallUcTZsdUd6QzNaVWNnQ2VtTDlVeTk0RlJmWmR5VWJi?=
 =?utf-8?B?NzhIK2tzMXlDOGdGcVhlT2cwajBDeWxTNE5qV1NZaHdpamJ5TStkZnoxeDhN?=
 =?utf-8?B?Z2o3RXJqc3JrVDNjeDlwYU1ocGNTekUvYVdXelB5YmJ2NUlQL0I4NXdKWVZx?=
 =?utf-8?B?aXh1ejBmQnNWb29xRHEzN2xmc1ZUcDJTTzlyWnM5N2x5ei9DdlRLeFpEY25k?=
 =?utf-8?B?MGNMUWljWXVHT2NOUXJoVSttVjBxcjcxSzhLUFpaVzU4SmY1SHBOVTJ2SGdX?=
 =?utf-8?B?RFA5V3FjNUVldjYyQUlDTWtYWTJWTHE4MEorNW1naHNiQUtTQmtkTWxDMmFO?=
 =?utf-8?B?MlBrRzlDcWMvUktpZDNCUC82cGcrWEJOQTQ5TkVwdDhNbnlvWkNxQURKcFBw?=
 =?utf-8?B?K1lDdGxNYkxQZlh4QmhTMk54Rm8wdStnUXR4ZXo2d3kxZ3RzeFNEN1ZIZFBw?=
 =?utf-8?B?SjhUMFRIazQyR1BMaEM3MEJkVUtaYkZ6MHV1Qi9yYTNmVEROcy9yUzFmRnlu?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 097856bb-8e7a-4805-571c-08daf99999fe
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:18:53.7565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: big9A4H+8kF56wdPDdHNO8mi1tYqRjWLp0OzWR2JoQ43/983AM0k1b+v24Bt/5tVRVyu1rJuMinpdvPh7MjfwCVJU7hJHgW1g6cKnkPz8RE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5312
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, rely on devlink instance lock
> and remove object specific reporters_lock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
