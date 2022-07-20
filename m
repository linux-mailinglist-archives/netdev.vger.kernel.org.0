Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7498457BFB5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 23:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiGTVj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 17:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGTVj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 17:39:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11E866B86
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 14:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658353195; x=1689889195;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uXR2sMnQiAev67GH2WYLd4COiH3NbrjHC6BlBxtypKU=;
  b=ctdOAPl1daVIE+lcE7SWNAsWRN3IIclg2c3f9dHm3neJX/OiTEXj36R2
   40fAVJV96NEHKuqIzshRH0HTNmlIXhlCHyMrKzEIQx5TESnPJlwiqypoc
   gNopbIeTZRYTRZNiWzX23wUCMi3Dpm5gmPB/XRdPeGiCbmIY2Cv6ydXcy
   aPiqxarLDySf4rdtFjrm4ywOLigZNlETNPj+sFHziFHrJ2lV33xLqxwAP
   qMz0gtyx0auY6ghs5p+Zqtfbyyod8EC11wXhM4yl47LifZc71gPA2stDz
   eS1izjDn5r6u0cmVuwe53CN1TRnwvG/klhkvoPqobbERKGNbxlhZDKjis
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="312594683"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="312594683"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 14:39:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="666028636"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2022 14:39:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 14:39:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Jul 2022 14:39:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Jul 2022 14:39:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYnvfhZQUKwAjDqHy6ql3UEPvBOaocp9+OJc+ZAfHBICB3IHaroNRqe8gwCvOXJk75hIT0ptzBbflt8T6BakRarb+YVjBxyAxopw26O2MDr/UDqhkR6Br5QOpxZAKbYuPieNtVzXbMSAwO1izGkwSoQta6smajYFiKMvjvNn4Mdd+bGRQSZAVa/TPl83qT2KpX8zqaO0TwqUY7crzELf9NV6gvMH+MmVN6gBXB90IG1HqT2+UqhyXcgQLFUIaOEEjV9TifzGGAorM1sk7hyy1a+mmbW4b4JJuEF37BSPKlURSlmH/6/5KdM0kdN3wOa8RpRHs8uMuryIs9zVG8lXOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25XHFSWehtTPMbUVo/fy5ZhlBx8pQ3XwJLF11k7Ld38=;
 b=KMp3qh5N4/4KPoI5Mtb5EWw7MFnXGYFNSkayJp0cGmR2HG+PZ+pPijeThzSIs2Ob+P55qx5sKCTWHuOkMytj2IYgtGh9CSd2PknoHkEx6pwiMSifq9t1oST5Wa7HVx0vuDzZIFxg5ZNMHqmv3LFgtOVF0rKlzSW8B2rBg9CmDY2hcgtnzU1ekuoMKTRL5Xf2gyFzfWVEy9I4hbmBzmX7C1bcV9Hmnu9xwVvl8vgka/xVaL/oFsHBQQfnSU2o6n1WkGu5B/DlrOz66+rpnjAlr6RHcqvYZNzgSjW+ZGE3tiL28CBhfaFPmjkacRO6vun1sv5x1uo3f5kzvtZ8M6TVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by IA1PR11MB6265.namprd11.prod.outlook.com (2603:10b6:208:3e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 21:39:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7504:add2:2794:3ecb]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7504:add2:2794:3ecb%7]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 21:39:46 +0000
Message-ID: <04864247-0e37-6294-9ff8-4c7e9d7a830a@intel.com>
Date:   Wed, 20 Jul 2022 14:39:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Manual AN-37 for troublesome
 link partners for X550 SFI
Content-Language: en-US
To:     Jeff Daly <jeffd@silicom-usa.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Skajewski, PiotrX" <piotrx.skajewski@intel.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20220316192710.9947-1-jeffd@silicom-usa.com>
 <56cd0dde-600d-1bb0-1555-e66de8c37236@intel.com>
 <51308ed3-09c1-6bf2-190b-306abd42f3da@intel.com>
 <VI1PR0402MB35172FB699C5CF918C65D3DCEA8F9@VI1PR0402MB3517.eurprd04.prod.outlook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <VI1PR0402MB35172FB699C5CF918C65D3DCEA8F9@VI1PR0402MB3517.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::33) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8317fa8-609d-4793-5488-08da6a985d53
X-MS-TrafficTypeDiagnostic: IA1PR11MB6265:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDFPCvNLn86fgW7ww/SEC5RbWvt+2+zGMEB52usikVhqteu/ixq6oYgFlbP7G5NWm2ZQn9wt12NQVvZGRmX7B0p3/9VX/oQA1ztvkViI9T5h5Fr/m5l9xof2weMOD67yZP/Fp1QfNB/F1sEuWWtmI7rIjPRkcg16M+eqgPtNZG8GRVVKj5c4hYiyV5IOfBu21WNAQmASAS/G2+K0rEvP2Wff4yDH8s4IJg9sz+Fh8jT5g6Q/iwpH/6TGriuBK+ibMpXCkGnLhqnxrUBRZ4LahJjmYzMMiDA+WUaLnk19MQEkvn3CFAPNTT5IpMBWBMepnoO4947a8fWppsbh6N/BTgo9Rmg+S+Rm4Mqkv3QcNWe19pDQ6sbdvdjKF58GUwNWASNDf2j+ZOUyrXSzVViW/khIkKg46qL0qgUf/2GKhyPigHnekpkUzxgmKLmFIR5ycAdJCDPuOxwxRWSOFxO4ZmCF4lsZF1KGx/pm3LBYeMig45OIqYicTbF1Dz0RKgN9zk43A4PthnwaITcO+sgNWteidzyMoZj2owxv+prBqJibi6I6Alxieyir9hb3i5Hfffcme3bXQnR/Tbfl2gIcQPTVsH7ukNDf+R5VwUo2ZMh75Rhdohd8J0xJ8zVkqSu+BBgYFxKNbS0altJeHehVn+A455jzlEAirJLELTzqvCATPIoWY3qV/3aB4G7DQBRstSJFIvGkBaX5vUrOYZ+XYVolrVrQFqPvmwQx6ImbnRRF1BAUd77ko6By+3yNWAlaK9jioE5TMVnPjDnFiG3XG2CVfqWrXBGntWQCqd8G9+xwlb5dURISKtpLAZ+G2GP2jgY0MoVDyYm19rP4OtgHxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(346002)(376002)(136003)(2616005)(38100700002)(186003)(83380400001)(316002)(66556008)(8676002)(4744005)(4326008)(5660300002)(66476007)(8936002)(66946007)(6636002)(478600001)(41300700001)(6512007)(6666004)(26005)(53546011)(2906002)(6506007)(6486002)(110136005)(31696002)(86362001)(36756003)(31686004)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TktZUDU2dXFXZFplbGRUbDZabGE5ODQyZU1HZ0wzOHp1bEdwcGJJdFY1SUYy?=
 =?utf-8?B?Vndib0ZudzBqbXUxdXpBbWFNN3ZIWG5hSGFtTlhzby9INlF4b0JvU091T0Zv?=
 =?utf-8?B?bThwdzdRNDVaK1Y3cEFHemhMOGltSU1zL0pQR0k2YWYrekZEY2xUYk1maWdr?=
 =?utf-8?B?VkE0UlJzcjJYOEZEK0o2T2U2aEpKdkM3SFpoZ0JFeS9wc2ZYWU9WbThFOCtE?=
 =?utf-8?B?RjlkTVUvbDAvUjgvVzhlM2NmMUNvNnZqZlhqNmxDSnZxMFpBWGxLa0M0WGI0?=
 =?utf-8?B?bmRTRFljdmdiQ2ppS0IvTXN1UzdBVUwyaGd3aEpOaWdscDRwUzdWd2RaQmNQ?=
 =?utf-8?B?Mk03clBHeVlnZTBBYVJsTmJQVlhJR3ZRV0NKZDh6c3dQVmVUS1Z5blFVL3Ba?=
 =?utf-8?B?Z0ZZVWtaKzlYcmlDYTJWSDJ1VEM2MjB6UzRMa0JLYmdBVUZFMm81akh5QUk5?=
 =?utf-8?B?bFJWSkMvT082WUZFSGVUT1Z3cHJuTGhQdlZmSDRlOW5kVDEvR1ZZdW1vNkFJ?=
 =?utf-8?B?ak1CVFU3Qk1YaE1TUHJVVGl3a29jb21RSU9jWWNTTjZMZXJ3RHN3Mi9WcGE4?=
 =?utf-8?B?VUZrV1hlNS9CK2ZSaG1DdVNXQ0NhSVBjaC9haXFzL3NpbGRMS2UxemJnMFdZ?=
 =?utf-8?B?M3Bwczh5SENlcWxjTXppSExWRGlweXJaRmJSUU5Yc0JrNlVBTEpLQUhIZzlO?=
 =?utf-8?B?MGZseUowTVhQYURVUHFpK2dsc2tvRlBaSVlmVUpLUjlPZmRvazBFTW9yWDhn?=
 =?utf-8?B?SkVkZXFtY2RWaTZSaFNXL2FmZ0FJK0pGMkxuR21IM1JEd2xtK1lBTCtzQzF2?=
 =?utf-8?B?amFnc0dPZi9NQTRTV2NSU2NFalJIRFRKQzN4NTZiajBPNUpnY2ZkcWJIakpC?=
 =?utf-8?B?S08rTnRSN1FYUXEzWW85N3p0S0RtUHFMQnMzRzFCUmpZQlZCTzhTY3RqSTk5?=
 =?utf-8?B?OFZma29aMEk3ZVJXZElka3QxQ09OOXdNcVRxcnNqTTBzbDBicDF3bjJLa2RV?=
 =?utf-8?B?Q0piTTVuUldaSHNsQkFiLzR0Zk1PcEJRT3Fscis3M01HNXhnd2dDc3dsai8x?=
 =?utf-8?B?YWxHdVVyaXNRbGtGblFwUkt0RFNjbklWS3d0TFEwTHF3dGlGMDcwTlB1c0lu?=
 =?utf-8?B?dW4zWnRXSys3RjlZMEduUDlHRkQyWlJyWjBiMklOZGxkL05vTXY2M2F4TXBn?=
 =?utf-8?B?LzNmQXBvUXk5RWlCYWlUNnlRUG1NL0RmT2hzUFllTzgzTGxkU1cyN3AzV0RH?=
 =?utf-8?B?akdDdU9mdjJpcU54NlpNRWVKWTJTS3d6OWdPalpMeDl3TDd5Tm5VKy9MaFgr?=
 =?utf-8?B?a3VkNWxVVmxEaDh3ZTNMenJhUzNaWWRqYVprTkN3RHBZYkhqcDYwUFVxSE0v?=
 =?utf-8?B?UzdTR3liZ3FyaHlTUjFtOU1QYWVzVktabjlKUjFlTHBzbVJEUXZYTlJqVXBh?=
 =?utf-8?B?aWJWcTVuUERjYjZRaWRVWnBJNmErbjNsdUFJcGt4MkRWd3lscTQvOWZoa05a?=
 =?utf-8?B?Rjl6d1dsbTQ1OVVxM0ExY2tQdUhRNTZ4WnhqV2ZRQ3dLQmlETktxYXNoQXp4?=
 =?utf-8?B?RUxvMDJWajNURWIrUGJFempmcVEwTnRiVWhVUExoSnJXYWpqQjB3dHBIbktX?=
 =?utf-8?B?dFYyNWtETWZQeXFFRmpTOVFMWFZsZVRSTVRUY2pDY0M1SFpHVlZRdFE0ZVJo?=
 =?utf-8?B?ZjIvUFNOZEhjTzF5eFZyWlpodWFMdzNSRkdKTDEvdU5vVnJpaGFhNnMwemps?=
 =?utf-8?B?UEhsdkFPMVNQNGlHRWFvKzhiZjZ5SVRlWlA0VEs0aytLZWlsZmlGUzN1T0ZI?=
 =?utf-8?B?cHByUlR3ZmFZSURqZWVnV29jOVk4SSswZWhmcFMrMlFjTGZCbmFRdFdMaDhW?=
 =?utf-8?B?bmUrMDJ5aXY0RFBuU0hCQXhYRWgvMEI1dHNGT3E1Z3lub1libytWc1NvUXY2?=
 =?utf-8?B?RTZHclNoWW5od3hHVG9oWUhhNlVQWGpDV3pCdTNiUzR4dGFLaldPUkU0ajlK?=
 =?utf-8?B?RzM4YTBzbWlBYjhIcHZvM0NOTXNsWUdNanIvVldBcUpRZXpaeU5RVjMzaGdQ?=
 =?utf-8?B?Q2lLL0VrODl0MGhTNkF5RzFzWjN1dUVDdzJaNk52WFBLaUJIZzQyKzh1bXdW?=
 =?utf-8?B?Nk82NmFreVV0b280Yk5mTWQ5ZmZWVElRL25OREpoUWx3MU5RTVJzTGt5Rk83?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8317fa8-609d-4793-5488-08da6a985d53
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 21:39:46.2318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXom37nxgwXDBjmGds3Cyk35rRktZVl+vMIGW5NQjWov8rgego3tc7io5/fnestCtjkiYtGZFL8/SCq49YG1vMMA+Uv3AuhkgdiRd5P5fyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6265
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/2022 6:30 AM, Jeff Daly wrote:
> I can't replace the hardcoded values with meaningful assignments because I don't know what the bit names are.  This was originally a patch that Intel worked on for Silicom.  I suspect they are all DFT bits and as such are probably not going to be disclosed.

Could you re-send the patch? It's many pages back now and, likely, 
easier if you could re-send it.

Thanks,
Tony
