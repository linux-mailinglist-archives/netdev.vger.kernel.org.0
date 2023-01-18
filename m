Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6EA672A4A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjARVT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjARVT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:19:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B1E1BAC8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076798; x=1705612798;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jvm5GS9AKqGnmSO/lbslHJ13KMk/Wmh0/wJViSvSkgE=;
  b=cIACdfvNTNbFrvEqIc0awlISyku9kEKgV7Lp38p04yltfBlQvrdYdgKi
   +nFbSsITWC2Dy16ipA2uRMgpwScgCCZk+2Ov5v4uDwCcx6C8gX9zFJrIf
   +qhSByQpJNOmLq518sE0P3QqSQLszZTcFgb8ghsTbrBba0x8vz97ffUFf
   +WrRCqz0lMzoJpZ4z/qFCSk7x6ZV97ADxkrQTWuvYkmmmzrrcwVCX54Uh
   n9x98Xe7xTlEHuC1ZUwMIgz6yXyGG1KO5bzF4lCGSOh6VFXSFW2oOd/Rf
   E4Pyzz6//WZW7aDHAlFcbDk1elGPEH7fjX6qh70BM7rWIAGxag7zgFuGE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="326369644"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="326369644"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:19:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728388523"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728388523"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 13:19:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:19:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:19:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:19:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkZgd31guQTruyS6Oi5q5FG2Uom3j0Od1pY8QIbv838coMOOKaTLIgPTPTDa3sfR00Hz9sLk01qQawTIAzR0Uiy55+CVU8MRT/dvsrMsoSiuTTM5xO/dAlPyUURr9yc5d0H9bd9FGa7tn0iNj5kuv3/Lg46L12JhdrLl6pP3sPi1mac8g78vzVXc7YDYueH0dlDtKDS1PFQvgaDMKvofHt4jskBQewJ4EpV7Exx3qnXYWYbJK0iBdPqXdPrAj3WS5iKr8m3Uf7cyfPSVaK6P/CrHuiplRHQZ20Xcrajk801MFkWTHm5Tii6Oejv/r4KYMcUlJRdFRLFOI7XwdDxKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZfJkhxkzPKG/S2F43jXeOrUxUxMee3rlKcBTgWqoF0=;
 b=k5WQDeLgNSdjXbQ96DviHVWfbmSrFNinZzwFhOJnSL/XRSfMBUo+p4NJWZuhn8WlWqEuOyk5YBI4ZNLefX3L2mZeul7RAFbceHFKLztNbAyAOQ4LrY3JBnoUScg+QApbpSwH0N0xw2oE7evTtaZoqcdhv6XIebw+kFhItBkiFkoL4rbtXAgi060Pzgl2kfi30VlBlx0kqeyVrZ4+e8lfpG4Ne6T4qsk+vIm0/uR6DkXefRrCm2QKnHbGCYxzkQqNJz9mMBia18ZOcGRVsHMP23DmvMlzK7xVBst0G3yQCdwCFXulYaus4ZQRfypFM9FqEeIAZ3LTjaM3ReJw+Ubjow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5312.namprd11.prod.outlook.com (2603:10b6:5:393::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:19:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:19:49 +0000
Message-ID: <4e67ef80-9d5a-3732-f333-fcd16ebb4d67@intel.com>
Date:   Wed, 18 Jan 2023 13:19:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 07/12] devlink: remove
 devl*_port_health_reporter_destroy()
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
 <20230118152115.1113149-8-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-8-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0145.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB5312:EE_
X-MS-Office365-Filtering-Correlation-Id: fe141036-ed43-4782-10d1-08daf999bb26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LXcUGybAP3DS5fPwyNxRscexSjyBu1osjxmSKR0vmYo/HxywIiRQv6SWJgWK2aCt5p5MtAsqW7VpW1H5xISR7NDtTirYD/CJXBMbLvaxwqhz/ijBj6E0QXBV/g/lpORt4IbPKkml3mB+vqOd89hUwv5X3DyokVljqndhXJ9NVZnZO6pam2kIPtKXhxF2xcA8wKZI9lS5ZMrA4MJ8pBiCrrzya3EHu6zHk/uUCUDi7O19Wka0bBsPdr5v+jXhjSdb/kLa9qFzXsTzP7KuPr7hsG6MQiOJVmo2dS2bRBLAQDwxoNwm5rMCsY+GsXOF3meqN/+GzUSeKcN/wsepf4qKkHzqkFmFOZDET6q9QQM8TAytF6bOFerEjgAhsC3h2xPuSSBPwN6Diim3e3G6cKPv++y1dSBzVxhRUK+IRrl1BtFqNQf03scHo6hY1LW0h2NOsxYuAkosWdYQSLzc48Zc2imz3urmaBD6hdE/0+iydTY5ya4cpQiygkBfwYkAbiqBv06JtODaH8PjOwETZ16iYCstdULhLEbt5FT81Jr7t2vMjURaOU8UEPt2dD4l1l1bSWlK8I+5geoGjEVfY3abxQqgUlKR+8Ez9CL+KCBvQ7lFVWtEZ/VoDEfrK5P6jl6vpVwyIh0DDs+BIpqrVRlJO8NZwnCkvFmDSyP5mIqMjluNM32nwIAphwN2bAe7WLi7BMVd+0zfM8CgXORuh9SslD0h2nohKOxiOjSWqhXTmBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(26005)(7416002)(5660300002)(86362001)(4744005)(8936002)(2906002)(31686004)(66556008)(478600001)(36756003)(4326008)(6486002)(8676002)(6666004)(41300700001)(6512007)(38100700002)(2616005)(66946007)(186003)(31696002)(66476007)(6506007)(53546011)(316002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2JlM1dtVUltdmFJTVRsNkhKNWU5YUQxd0x3d2NsZjBtTytIbTRwNkV1emtV?=
 =?utf-8?B?TDUxaWM1YmpPM2N5anQyWmp5MW1UaHNLeWllSm9iWnpQc2VwQjVQeEpKT3Bn?=
 =?utf-8?B?NjM5MXlzMjYxUUdJcjFOSk1NWkxrUldwdnQ2RHZidHdVbjlwSGxXN1NlTFAx?=
 =?utf-8?B?a0lCd01MNWpBNnk3UWtwNUp3ZGxDWGYxN1BDdGdha3JqTDZWNmdYZk9vLzMv?=
 =?utf-8?B?Niswa1phOXN2WTRzb2J2UzcrNDA2UFduY3pEMFE2QnhDTkxJSmozUmxYRWxP?=
 =?utf-8?B?U09pclVLYkZlTFNMNVlCV2g5K0tnUGNqSTRQbVd0dFRLeks0QWEzRDdXOXdX?=
 =?utf-8?B?YmhFLzhadFkxdll6L3J3MzlFVTc2VFUveC8rcXlWN3grMG5SOEJLUlNQVGtt?=
 =?utf-8?B?cWF6Vm11NWZaenF6TmZiOUY0UEluR3lPMHYzQlQ5cTNkZ2x3NWlPQ3FRcWpl?=
 =?utf-8?B?Tkd5ZGVaNjFuYkRBcTdEU1gwcnp1aHZQeGQyVWNYR091bHFkSXJqVlRRdzFP?=
 =?utf-8?B?bWk4SlgvWC9PWlhTZ3Exd29QRzlJaVNieUZ2RkY4WnNNVzFZb0YzTmJpZlJj?=
 =?utf-8?B?cTZXVmxwUitWQmpkeEF4ZU5OaUc3VWVBYnpJQi9NZ3BoMENHZWlyTDl4Rlh1?=
 =?utf-8?B?eVlGQ29xc2t6UCs4NlliWVZ6cVB2UjJCSTV6VlpGRHlBNkg0MW1FNFd5b2pw?=
 =?utf-8?B?WkxybWFEUGsrVTA3cTBVM01kL01paTFsRXFzYlNqNHBmSVdVYlF5ak95VEdo?=
 =?utf-8?B?NWpmM08zcGh1MWFubmIxS1V3bUh3ZW84OXlnZFBpRklSNlY1Y0lPUysvYkJO?=
 =?utf-8?B?NDMySnNsZFhDSnBVMDlOVVZVbUVaWk4wNldOK1VwalVEMUwydHBQcWxka29x?=
 =?utf-8?B?QlQrUVEzTEp1dmxYbFRrVzVIb0c5ZGFFZGMrMVFnTDIxN2RwaDVqYk9PcVBn?=
 =?utf-8?B?TGRoTlIrSWxaOVFMNUNsVVNHUzA2MzZqclpnY2QyYS8wWDBVbXc0dklYdVBY?=
 =?utf-8?B?ZnEwd05MY21VdzFFR3VNejd3L1JWMGI3ZUIrbFlJMGIvaFdTNUlNOUhTRUVN?=
 =?utf-8?B?aXNzSXpya0cyWHlPbk0vdkdIbjhLdDNjVUp3MEgydXBQUk5rb3RqdDM5bkdl?=
 =?utf-8?B?NHkvTStPZEJ3SFFEM2VOTXNkNnN4bmRCTWhvNG1GaElYcVRlRjhxeGF6eXYv?=
 =?utf-8?B?ekl2V0ZlZk54REhRa1NPeXc4M3d5N1ErYXl3L0hNdzAvZHFxNXZWakVYTTJL?=
 =?utf-8?B?QVdxWmorbU9JZXJUS0pGbGNmZDJDL3BhOEVlYzdLYS9JRkQzV09hQTJTNWRK?=
 =?utf-8?B?bThVS2hBTU1MTGFUU1ArUlpyaHcxMHowZDUzWGhMS3pOVHZCTzl4a1RPUUVO?=
 =?utf-8?B?YWc2SDQ3WE9GUkJzalU1L3hMQzRnNk9JaW9wQlVac1dTYjFFSWJ5bkpEYVFG?=
 =?utf-8?B?Q01sSGFQa09SUExrTWwrVjBSa3AzR0xXbFJsNTI2UEN1SVVFRE5Hb0ExdTE0?=
 =?utf-8?B?Y2tHUUZPQjZrUWlmcEhBUStlMUJERmpNUXp4MnFZWFJxWFpvTG5Gc1drRFNO?=
 =?utf-8?B?TUpkWmVHYUVqQUtzYzRQRTRPNzBCMXA3Wkhacm5xdVlOQ1A3OHBiK2J4c1Bs?=
 =?utf-8?B?QTl4YzUzTzVnUGZHNERCalBoam1OeXdheStqbnhtMUNzbTk3S2haNVJVeU1I?=
 =?utf-8?B?L29XOFNmMjh6S3Y4UmhDY2RqNzRKSC9WbFVVU2JOcTJSVjBoRUhxVXQ4RHhF?=
 =?utf-8?B?a2F3OWxCZXdLYXBQR2lqU2VQZHh5WHRyQXAyWktFV3lWNHVsTm10WFRZeFNU?=
 =?utf-8?B?aXU4MUJodGRXMTRFeGZjUmlYN2NPem9UVzJhdHJkcG5qSzNRVXdyUEx1eTJG?=
 =?utf-8?B?RnJXbmVvSDRTcUV5ajJHdmdBbzhnTytwZU5MK210LzdQQnBpNlZ0aU5aWlFD?=
 =?utf-8?B?MlFURGpnU04wcEl6a2w1cEpUYU1JZ2wrZzd2bFNvQUpsRS9yUzAxMnI5SFd4?=
 =?utf-8?B?TUFBM0dsdHBENzFKQUVHOUhDUlptNkZobldIREw0djN1SnZnWkdXay9FbE15?=
 =?utf-8?B?Z0ZMWmlUS1hEbEQyOEhJK1NOcXB2SUp3ZmRDdFZGUUNEc29OU0pvNWY0T1VS?=
 =?utf-8?B?eVlSZjBPSG10WHFUenFaMGFaS2l5ZG10azZDcW1WT2hNanNraXAvaHZnU2Iz?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe141036-ed43-4782-10d1-08daf999bb26
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:19:49.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/BO3EQU9iwCK1DWTNlzwdlXx8UnQ3amwJsuIeEclv18dFollmnc7FHkhu+f5voARCTf60jPi1qShFNLdYV0aYebYda32znpObyad9m9nCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5312
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
> Remove port-specific health reporter destroy function as it is
> currently the same as the instance one so no longer needed. Inline
> __devlink_health_reporter_destroy() as it is no longer called from
> multiple places.
> 

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
