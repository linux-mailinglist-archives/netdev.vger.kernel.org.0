Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F049A624E6C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKJXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKJXYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:24:25 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F3014D25
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122664; x=1699658664;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=27xxdJbMcpeNIA6hFEJJR8//tshTaI/TEzpqtfJrv3I=;
  b=EO22dY3vn9BUCtU8zYpip1kr8VZ11uD0Mi9BDiGZ8Z+lCveZWAqzrixm
   cFuIv/Fmfn8LYBXFVmYQmgi36Zq6cFhlp5eukhWBO8fLv6c5coxGusz4l
   bviEDmqoOIu8414HqD0XJxgQ9xdaQFT68tGF/5S/ZaSlFgMYIs+1Jr8Wl
   KNzFX3rTKKAJwBPgP4zNxH+OX61ICMWpb68xgz3APt1IxL8sMHAVYV7/E
   ZeatBTYYvoHGbFHBe9qRooUmkaeJsW5hxsmbloFPTBaJaMV8rLBiWeG71
   FPWE9b4kOi/eYag8dQAzpjIoHlx1m2SicAUczjUqRvBoTa+XK+vfmuV/X
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="291872725"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="291872725"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:24:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="670541923"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="670541923"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 10 Nov 2022 15:24:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 15:24:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 15:24:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 15:24:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 15:24:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yms70xMQTotE+AX7ICCPz2B9xyZ1qCDDHnthAsw9wzyhV3aEfbgVx3wycjntQ/S92RO6yn4LTNZ1PeprqNDqi38hkMyQVtSgkqDqB66DFE9qdmh2o8fDG2VsrxooQm6yz0l8yWUobS3EeI0Ahk6bU1UsvX3YNbL2HaA3UwMFgZQDivDu/J8lRSUOG9xxDH54/2mPb2AsW0NA+NJXplDNypgYw8IzLe+ptj4TlS6m4ipv6ONe3JAXoMgjSXEh89aBdCn4R/91t5ktSMggdvDSeDGtm630mpFw0qhlwt0MejF7+wlPY4HPILXDN+X0IN18BG/ICnapyV9qNu6HVEKPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02TYYmBk3oExyN8Wggwp5MEZZaXFmP7uQSDVHqU/oe4=;
 b=TV88k4bF4S2XMrDFWBJkXaBDg3C+iWu09NCSEfu7bRYJvLnKbpcN10JXqQ9BfnhEq/FH5QzZUTiCylWeVuE9EUp7C1d+cyAVRcjnRhjWCtJaAi8JWNUKmGKZjQDtBBjQ0DfRoEIc6TFnklRIP9cKwmc0Utmeysk+yMjgvotHA7C00CYkO4G2SoVlUbKDdQLyvuaGLfaYdTqRngXA6BaJrdB62iSBJvL0ONlOk67oGEAVfiYUb3Sg4uY/haWsN7PdmAuo0gVS2iloe61x50hjq4V9TwHUo0q7lzXUMcXrUkzxKosRRR9YXCpZOBR5orHbJqQW+pfNdzfwmHJXjbcHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SJ0PR11MB5006.namprd11.prod.outlook.com (2603:10b6:a03:2db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.29; Thu, 10 Nov
 2022 23:24:20 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e%7]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 23:24:20 +0000
Message-ID: <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
Date:   Thu, 10 Nov 2022 17:24:15 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
 <20221107182549.278e0d7a@kernel.org>
 <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221109164603.1fd508ca@kernel.org>
 <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
 <20221110143413.58f107c2@kernel.org>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20221110143413.58f107c2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::10) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SJ0PR11MB5006:EE_
X-MS-Office365-Filtering-Correlation-Id: e2510e41-74c8-4fbd-5abd-08dac372b0d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4niV8loHsM3TghSWOX9FeKgMaRs7ctPShk11acCE4pfqJHVeQRsWnBmaxEy3u3XUPx0z6+Y0SV+D1KoJNKg0IcsZvBhzGg9vF+TOfDABlxXdV1/psN54YmL9PD3ekOTLu8i0BK3V0SBMiFSL6rIEI/AivIK8QGQ8D/XHn/KZh08fIz64KR74DR7hEOioxE0fzce7aMchP6jSsb7eZE5Ud/6L4Tej8RoDVQhWmQZ5ZLDzZ6MFh62c0onRKpOYB0ptltIw5ZffJSLLGJf7axH0+UjiDvsjz2EYJLUMRKYYKjZOl7cmhNttiEBSWm3nSdAWqCGM4hmT+zEUiTQuRaHdVfx3iYeUH7AWfTFrazO4WcpP6SxWbF5u2cVCRbZP/7RjWoxMYrbDCHrU/XmXSxnlIkOGoKuczpuw8sbmdvpVMW4Q+jaD54y34WzKYY+rjALDfW1ujtN8lQJ1OhfGj/J5sSxgmVfTJRdhXead+72gnrg/o5kG/N0PIHT5NZPUKZ/1pRq4eIeiOML00kD0K8oJRjV3nawl6Q4h81cLksIt1XVs90AogpGf9m7O7CJ9YLdbjbIfhy3B9FGDN0QTdR8iy41b5il6EESV0+0KKk4SjvOfr4K4kV0ChNmAYtHHwVzVYhy4fqt/fjYOrOnm5OKlRFntWqiZe3riY2gbhVgY79UhzPpmD/ToAaVibxgmi34DWoZWXBg8t6WRMAJVZTNHEe4GB32300K+AKkoxBqTHgi1+VKrLg5kZKgg3JaBWrkoBm7OWwKkdOIa3BlSskCIrfpU/QmiPKwoeh2HUggf/C/g2FvGH8c9WVwl00PbAsBpztNKoBy87ZIoKMO5wdayNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(31686004)(316002)(38100700002)(66556008)(6916009)(8676002)(4326008)(66946007)(82960400001)(66476007)(54906003)(86362001)(31696002)(6666004)(107886003)(83380400001)(26005)(6506007)(6512007)(53546011)(8936002)(41300700001)(36756003)(5660300002)(966005)(478600001)(6486002)(2906002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWRVVmF2RTlvdXhscnB6RGhWN1FwNkpad3RxVXlaaTEwTnlGQUI1cDhQcDhs?=
 =?utf-8?B?S24zOGc4d0YvVXRvQjhuTEVIbGREYzFaVStiMVcrL3lhN210ZGd5M3FPRkRh?=
 =?utf-8?B?TC8xQSsyN0I4Mm5rVGd3VERtckZKVURRL0pEUE5jTlNON3JhVkNlOU1zNWND?=
 =?utf-8?B?a282a0Y1ZVp3WEpESEJva1hUY1FtejFIVFFZNGZ5UmYxdUJzUi9maDN6dHFC?=
 =?utf-8?B?UlFNeDVZeTJHMlZYL3ViTVRlR0ZRZ244a01hblZXTTliRnZDRzdBZzJSQzdG?=
 =?utf-8?B?U04yNzR2SkMyeHNrOU43OFZXclpxWDJyVDRWZFAxbjkraWg5eS9meFhwYWdO?=
 =?utf-8?B?cGN5bFRYRWdwQ2xaUU9XZitJNlEzL1lya3lHZSttRktLVG52dDIybVE5S3BP?=
 =?utf-8?B?c2hNYUVMckZESGNlTFh1UGowaC9tMmZIczNOVjFBalZsam9peUlJQWFUM21Y?=
 =?utf-8?B?aUM0NVhFSkVFVlo1aTk5bDN1WHhCajdBN3ZWVGFyb0JtdHd0Ujk2SWFIQkNI?=
 =?utf-8?B?NzBwU3hIME1rSjJJR3VjQm5NSys3akpiTzBLSjljWUxTcDNXcWd3MXplSVBj?=
 =?utf-8?B?SUZWV3JTdE5CN2c0cWlURnBSdU9XQmxpQTI0OWFjdDZIVmFMQlNIcXpRSnBX?=
 =?utf-8?B?ZTFsUXdwa0svRFl1a3d2RUFSSUJwaDhOTDZGVjFJZUZaQ2xsUUhYeFF2MEpZ?=
 =?utf-8?B?OStIQkJpempEdHZWMnprYnBNalB6RGx4M3dmcEh1RHNCejdoR2Fmdm9yQVRU?=
 =?utf-8?B?Ni82ZmJnS2MxM2g1c1dSa09sQjlSa1ZLTjdWVkVlUVpCUVY0OVdZVnJBaXQy?=
 =?utf-8?B?UzA1MzdqOExqRm1oRXdVQjZLMUpsalhqK29OMElkNXF5RnJVdi91MXgwWlN5?=
 =?utf-8?B?UXZ5MEU0UmZLS0JueUtleDdUL1lGNzA1R0xiUU1teUVERzFPY3JMWW8vZGlu?=
 =?utf-8?B?WGVJS1BZa0IrSkc3ZVp4aU9ZVmV4K2xDNEpFMWEzQ2Z1ci9taWxlQjdUdGI4?=
 =?utf-8?B?WXZwV1VHZnRVaHg1V284c3ZCRGdPK1hGU0htb05lR01KTThpV2lqTzhtWTZn?=
 =?utf-8?B?ZnplRlF1NmlJWGdrdkp3WHZJUEFPb0xqcTdsQXdzQ09xSGF1MWtacC85WVBr?=
 =?utf-8?B?WGdLN00xdkgrbWNEOFE2N0VtSDN6dGNyOERJK3dqTEZ1N29nTmc0N2Y3TmND?=
 =?utf-8?B?NmEvWWNhdkZyY241UzY5Rk4rdnkyd2xDa3RIL3c3dFJwS2huK2tkMStOTTc5?=
 =?utf-8?B?aG5xRkZJbFEyZG1iRVh1cUt5ejNmaVNBZWg5bWtJVVZpRTJJYWozMEhlK1Er?=
 =?utf-8?B?MEEwNDJ2Nk8wSFFIQlNPUVl3QnBUQnZwaE9OcElGUVV5eHd6OGhFaWVnVlVa?=
 =?utf-8?B?cnJYTC9OR1pHQ2NIUytqaXYyaWZuejQ5SjV2dFdhd0VtMzBDS2twdzc4cUR5?=
 =?utf-8?B?MUgyWlF6M210V1hjTE15V0czKzB3ZStleGk4ZWhuZi8yRkZtZCtYaThwbUY0?=
 =?utf-8?B?WnppK005aC9XQlJQSFAvVUtCT3lEQXdYT2xyRnBVSFprUUR2U1BrMEN5aGwz?=
 =?utf-8?B?ZWdya0U4MzlpNmRpdEJnZUJRSFhFZjZDVnJ3SXJBNTZzTE9RMFZzdHpaY1BL?=
 =?utf-8?B?TmJxK1Y0amlUTnNnZldtTnJHRlY0OFFLTVpqMUpoVG1NN2hiT0dLS1VZRUs1?=
 =?utf-8?B?c29ZSVJLYVZzZWxUbjIwU3RvRDZmd0RNdThMRjFxMUhQL1lxUkNQT05Fd2Yv?=
 =?utf-8?B?Q2xxQ0NKUHcvenN4V3ptbkIxNHVTTjVJSmdaVC9FNVgyVTVyOVVsVVJYbDdN?=
 =?utf-8?B?dlNpNmVPV29DRnBmUUxZMGkyLzlIZmxTdlcxQVk2bnQ4VzlhTkRQOTdLd0Fx?=
 =?utf-8?B?NE5QSGR3cW5BcEtjZlp3QnZJYWY5SFpVY3R2dzIwd1Q3NXJwbEFRcGh4djhL?=
 =?utf-8?B?TGJrbmJ0WDJOdmJLMEpiclpKMWtrRlo1Z2ZsN1F3YWxTTlhuYTF1TE1rUFhu?=
 =?utf-8?B?dDVPa3dvNCtmRGR2clBWRHA3ZkN0bCtlRi9Wc2kxMXhPdG5jTTN4WWRNS2Jj?=
 =?utf-8?B?NHlHRDd1ZGtCQSt5a3RxUWREUklkdStEeVl4Tm5INDBJTmJrNG9xKy90d21w?=
 =?utf-8?B?dVRueUdTRStLWElQa2FUVVpHNExPeU1DWWV3Q09DbENjZ0hjSWlZd3IvSE1o?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2510e41-74c8-4fbd-5abd-08dac372b0d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 23:24:20.0020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMVWLjy9qGkuQA8JHzI6R2mzlWS6yduRYuWQKildLHT0muzBds0hzZRDFVP4/QCExZ53SrgiWty3tgeeF+YbJba9F22qjCORkW3TiEXOVEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5006
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

On 11/10/2022 4:34 PM, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 16:08:04 -0600 Samudrala, Sridhar wrote:
>> Can we use QGRP as a prefix to indicate that these are per-queue group parameters
>> and not restricted to RSS related parameters?
>>
>>     QGRP_CONTEXT
>>     QGRP_RSS_HFUNC
>>     QGRP_RSS_KEY
>>     QGRP_RSS_INDIR_TABLE
>>
>> In future, we would like to add per-queue group parameters like
>>     QGRP_INLINE_FLOW_STEERING (Round robin flow steering of TCP flows)
> The RSS context thing is a pretty shallow abstraction, I don't think we
> should be extending it into "queue groups" or whatnot. We'll probably
> need some devlink objects at some point (rate configuration?) and
> locking order is devlink > rtnl, so spawning things from within ethtool
> will be a pain :S

We are going this path of extending ethtool rss context interface to support
per queue-group parameters based on this feedback.
   https://lore.kernel.org/netdev/20220314131114.635d5acb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Per queue-group rate can already be configured when creating queue groups via
tc-mpqrio interface using bw_rlimit parameters.




