Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1E672A52
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjARVWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjARVWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:22:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B467F46BA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076934; x=1705612934;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xcw9d5MTqV8tMmKQfi+78+8JTI5igmdx81mpmDMjC3I=;
  b=UvbfrfHW0FRry4WnkIjsOfZcNN+guLZ/iCt5YzZpN/8TLN+4igTlS03n
   RaDz5tr+Ukuyem9vUjZYMwCHea9iErfaii5YEsMJyP+cSj1Zyz2pH2Ev0
   AK6KejZnunPvlGRtBbuVE8b9WScC9USTMdEOri669TkXemBv3P2+I3U7I
   GItdIvctYNDffSFREybgTXvmJm1E7Lv5QcGXUBXZttSR7XXl4Dy+VapW5
   abOmcSa5nmKDQiH1X1JL80ap8+FqxFGTMVyG3rDXIhL+xXrKw0DWm4xtb
   1g1flhr2bMoFX2POq0VNDhLlYiN0FAtv1NcQ8MBDtqtA/QEhN4qJiyc7P
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352356163"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352356163"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:22:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988752676"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="988752676"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2023 13:22:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:22:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:22:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:22:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:22:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDIHvYRYcklHXvSwZGc5FYjiO/QLI+JTnHyP7P3YJmwH5QLynylAVpvoAp/aY8dS2aJdQTEqWEFs6QJORvgoznGqqI1rl1vp3isKOYhObTFdFrET6yr2x1TB0mHEUGeQM2sXANoCJBXx8soy2BF3fZYvOoOmItox5ordU3awgs3dPi0PEzGmZV8OkPHU+MmYoAXXoDgJ5po9Luon36JH3fv97BF+jEPEijH5duPdcEtpdiRBgwwz5thraZgwnodC8DOlBuGIvsLLcYRfURaLqpGniDI/tzDsCBNLXtAjf9RTHvQzYmvLp/NmeMrek6/6/Io5yQpR/C6FY0ehfNcudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLHYTGQ3WVqINSHuWIlheMI5M0J/5a6WRfDgrswsZSo=;
 b=fHvSI30myZHW0MXP/sqiR+rDQ/w4OivO7ob9l53klftWALAFvJiNdWFzvlmEZq7ttOkR3CAjcgnKzIvC2EgWdOAmTL8xXT/mu3ARPBF6v85JualzcWqRO3KmYe+n4YTvzktps97SEaz9xporUx5lY/tuJzh0l66GljPvjEulLmcyFas7vYaltscxijZ4zNMuJS5NlzXnammaNDVKKh2C06v+3is17wdn7mxroTC3PZ6zB1a5LIJMeapvezl5VJwjbNEOvSDgKGqUGirTnPXqpsfX/6t1y5BySPvQAPeU8lcgNmvQvEmRY3IVak+V0rtWsjrNPL3D4LNvelDMwruC4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:22:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:22:07 +0000
Message-ID: <58495fff-f728-1ede-caae-5f0f3fd587c1@intel.com>
Date:   Wed, 18 Jan 2023 13:22:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 10/12] devlink: convert reporters dump to
 devlink_nl_instance_iter_dump()
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
 <20230118152115.1113149-11-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-11-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:74::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5366:EE_
X-MS-Office365-Filtering-Correlation-Id: 8179562f-c918-4126-1b6d-08daf99a0db5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLMQxnRuY59dwbzPoAiTbtUCJaMh+zy3BayiiVfZ7YovbkQW+8cj6jxARCMVCfQdOywPsMjdiYbN4NleJT94CEIEZU/f4uIsqIpfslRAYlXMVZmIeL/sZCe8/hF6bsXuHCT44lWXTgXZabF1U6m11n6VbBHrVOn+QEklRIh4I1IDkFRHsYejiOcyEyrcj5nO4l8JMOIfq5qBhfFB9E6aU7cubbsizkhM6J1liK0KBMI7V/LqtiEfbzvSXMCbSy12LRozY+Vat1avQDjFwKqcqLrdSZkYOkP5XdfK1zZ4Yeh92PO4sC1PPw+qlWmdX+1qPRP76KyvlUVu+Is5AneCzYUt4TJhg0sYpr5BA52626L9dr6qDK7PphhJ4XCzXGPvwFp1lgD05ki9EmAZt0LdLWSyTLc1GuiYGaahC6bZibsTTECSayJsWUB3z6hfNln6NM/Na0UQ1wz4VBNt9AtCmrx/XyY0CWWgskvKr3whlgdjdZAuF0P10yBCWTGRloOorZdaVYRhZYVQkJK2bFma4Pfg5LQ9VVGnPO3cVBQ10kF9sxhhR4KtAGG2ehuCI1m+H0WJH8rnnvDEqGbSUHMb6u379He1m/CESx3BCfy1+TfcSJ7D/kEnnYFIqcJIgSeDeIcOYR3n/DSNvjxnjR6DSS7rwyjAq4RoV4xaWoqPWjcvKdwErDMzSVKa8IargYbjkHaYb4hznj9CK0PoL5B6Zt4HcYALynWyMPwW+BtiqNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(31686004)(36756003)(7416002)(38100700002)(86362001)(8936002)(316002)(66476007)(66556008)(66946007)(8676002)(31696002)(5660300002)(2906002)(4744005)(4326008)(82960400001)(83380400001)(6486002)(478600001)(53546011)(41300700001)(6512007)(2616005)(26005)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QysyWVo5eGR4cm40Rlc2TFVvNDNTeDNrTFcvejJUakJDa2txOU1qc3lSMlVy?=
 =?utf-8?B?ei8xMmg2Zng2SVk0UHV6eTJueGFHTm54TnN3Q0JQOGNGVjZUOWJJQmNleXhi?=
 =?utf-8?B?ZWZrTkJwakRIZzJ4QWVieWdpRkdqeGFVNVR2bGdYRi9QeEIrc0NBZnVmYWgr?=
 =?utf-8?B?M081UWlGcDhuYUZGSGZ6Sm9LRTgvVjFwTWZ5cmlwR1Yzc0kxejY3TTVWTnRR?=
 =?utf-8?B?d0hBOEJWdllRWWtzYkZPelVGL1BCL0tCVFl2TkxjQWZEd1Z6RjFxMzRvWHY2?=
 =?utf-8?B?OW5WTGRCV05EWW1BTXNoam13NTBlMmhuS3Y0Mk5mcE9SbkdxMXVRa3l0YXBQ?=
 =?utf-8?B?eVV6Z0IrMG5ZL2ViSXlqMC9uQTBJZkxtTVpQYitBaUkzUGdIcDlZOUFQcFRU?=
 =?utf-8?B?eExyU3RuQzZ4TTV0MFRaTGx0dm5WU1A1Yyt0WEJBRXNPU3hIK1hMV1BZOGp1?=
 =?utf-8?B?RzN3Tm44Q2Vsd2dOZmZ3bnZaTytYdzZHcWhydEpucFJIcjUzTFMrZmQwSmlI?=
 =?utf-8?B?SjY3dWJ0T09TREViVnlqSXpHSVJCTlFiZVo5MFMvYlgxejJsbDRkMHhXQmlK?=
 =?utf-8?B?TEdOdFNXZzQ4VjA0czNNamVhVzdvWHRaVGRqcFk2c1VZZzgvVTYzazBtQm1x?=
 =?utf-8?B?Nzl5RXdaNVc5WFdSL3JwQTNiMlhWc3FCZk5wNU5pTWhxdzRyam9kQmdvVmRI?=
 =?utf-8?B?cG9ST3ZJVStpR3dZTDViNzdHaW91SXR3RjlURFY4aXRCSDlzeXI2ZEQxeDBl?=
 =?utf-8?B?MTJiOUt5TDBkWXk3UnJBVWNSaXZxNC9WZHVyazZ0SlV1SEZvdmE1WTdmelA0?=
 =?utf-8?B?U3NjVmVpSElFeVAvbEdKalQxaTlJMDhuaTVvT2NuTjJ6WXd4VExsUWhIWTNO?=
 =?utf-8?B?eWsyZjNPNTNuOWRHcUhRdUo0Y2dkU21iTEwxTm9nUDNrZSsyUnhnSFJQdWRi?=
 =?utf-8?B?enlOYXV2eDJsOTJ6Wk5GQmxjN29Wb0NtWlp2TGVvU2xrZ09MclRXRGJkbFF2?=
 =?utf-8?B?LytkTlJYS3hKM1c4THhLSkFtZkFvTDdDUU8wK1VSdllsb3N6a2cvWFUyOTRl?=
 =?utf-8?B?VDFSUEtMSXlnaGt3V1lZU1kxMDNKOHBMZnlacms5Y0xwRjJZaGdudmg5T05k?=
 =?utf-8?B?elUxOEZ2TURlMDNQTXhvbHFBUG9VMFFSc1B4akozQldpZEFWajBSTThKdGlK?=
 =?utf-8?B?OTB3VzFwL1p0TUFuWDVtVXdqcEEzZjBocXlTWTBhdDdLT1dVTUdlanpZV0Yx?=
 =?utf-8?B?K2lJamU0QVlVV2VTWmxpT25OSVArZzQ3elVQOU5Dcy9OU3oyRlprZ25rTjNa?=
 =?utf-8?B?d1BJK0s2V1E4RXArZmVUdU9XN3UwTWw2a1N2VXRWTlQzY1hMVHNvNEZvVndG?=
 =?utf-8?B?STJUc0ZHOHhTM2p2cDVJS29uTjVoSkoxRENyaTczcnVEWlVzWWd3ZUlldkph?=
 =?utf-8?B?RnpHUFpFZEtZeFNMRDAzSWViQnNyK3VwN1dGMVFZVnJJTDZoR3FNS0pkM05E?=
 =?utf-8?B?YWszSjJoMFQ3OThaMGw2elVkVW9DY3ByREJZTkhlOEtCNXpSaTRqSWV5RWNR?=
 =?utf-8?B?M0sxSjJJZ2Q3L0pZcnFiUzB3ZlNPaTVsTXRER0RnVlh1SDg4TmJ5aDF1dGlX?=
 =?utf-8?B?RUg5UXRGYzdFdy8reExSV3loYXpJVVhyZ2xyUVNleGlIRG9nUmFQd2s4TE1y?=
 =?utf-8?B?UnVpeTV2ZnVPcFB5TkNKKzJUNzRPdUN3VytuaFJrOVR3VnBJYTNKNFBJbnJI?=
 =?utf-8?B?MFFETHRtMDJheUJqR1hYMlNtR0tXT3JpYi9BeGN4Y2ZZblRkck1TSXhwU2c5?=
 =?utf-8?B?V2VNQTFGelZLQmU5RE1uREN2MTdoRVZ6TnEyb0V5ait5UTcvVTk1dlE4aHJ0?=
 =?utf-8?B?UzFiOWNLUElNK1N4SlUvN1VUZURiTFcxRktwSktOWjJ0RFpldlNsMHFSUk5i?=
 =?utf-8?B?SW10ZWtPa2syS1lLdDBscnhnYWZYc3ZHQTZzUk9ZVWRlNmtEUllOdVB0bjRt?=
 =?utf-8?B?cXFOaVcza25YYTdqY216REMyQ2U5OWU5cFBrU0MwakdLUkpwd0hobTg0SHhW?=
 =?utf-8?B?ZEdlT0UyLy9xODI0c2s4a1NmdCtFMFE4Kzd4cXpXbWJnQ0w1OGxYa1pDMXQ4?=
 =?utf-8?B?SWxGYTh5RXE3QXdNLzBmcTd2YVVJRkdQY3dJUzhLL0Z1WTE4SXgvdVY4MjdO?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8179562f-c918-4126-1b6d-08daf99a0db5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:22:07.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKvTLsesUJVcZuid5rqfcvqy2GD5aksTZFGhWa0Vp2BwT8psHvNFh0Kj4ZJMyzt6ViRkxdor+oKKURUqbMUy6OyFWLeY5TQBKkjjrX6XIKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Benefit from recently introduced instance iteration and convert
> reporters .dumpit generic netlink callback to use it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
