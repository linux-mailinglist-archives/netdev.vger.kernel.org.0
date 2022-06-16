Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C3A54E953
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377943AbiFPS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377964AbiFPS0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:26:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166C752B1B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655403986; x=1686939986;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5fZjnX81dssIWgeMKbq/ZdssQD760CdCz7JCcs0QJ4A=;
  b=SCXTOVi1xrhH7FAqvLSj+GOLK3RlSe9Ny1iR0eXbYnNzeCMPnSubJ2Kj
   k/RP/YYHKoBdiAQElCNLr6F8xEKI42cRLm+6+Xywu/lFGlIMO7nvp+Mh/
   WDnCcbWN3bspIs4Zkp67SgXh564ppRagN9Yiy1YcIIdk3FiMfLuEtjljC
   IlGNWGDEBKN2sUuDap43V4IhHpyXabxKVwbQFTtZxvZn+pjPyIVHoyFsl
   tR77NaAmhHtYo7y06OtlWTBEY3FOBeRejvG/kwbt8TZLWlmbqUkZPcLKX
   /TXzg4UgmSARFMGEiHq4eFInCaVQYYDFqY7Dnmi7GgOwDN14S7aO3IeV5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280035140"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280035140"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:26:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="762957769"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 16 Jun 2022 11:26:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 11:26:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 11:26:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 11:26:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeohtWiUn76WoWA8kCuLP64uNJf+myJPRcIKwx8ZOhEWo7WDU2CZe6VvQ05fwCA1J9D1Au6JDfrG1m52ZmK65jKV5kP3+K/fGpqBwa1AK0xJ5BQaw2OGo54DnI80tpRBTtRCmvAT2+bmmikcuQ4Wgp8box1C/jaaPir90nB19eVkLqBb0z8RPn0Muc/c79CtBU/rh15p4ErUYxzIfITCN5sGS2qrYz4e2c2H7SPPIgLVNcRHkiC28Oys9joE7A8ILmcXXzsQLnzbhAsoJV72KlxIxt7P2ovzr1XZN01DlgDee1cqMf/pr/k4F8gY42YJFj6meI38mNrbItUFrOWZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X56T8a/c6JwfEm5lDwwTvAUUsJ/cVDWWLebbDwKk5xo=;
 b=hTxOt3dtMTlbGajd9a+/SVfCRf8kJX1BlQCM7g3ky32012lwOxcPfxNjB9q7JFkCaQGwHuO8W0Or7Dzst9JNEl5b2Gab7TSt+7iVkC5TYgXNMEgN3l6atHmHt+PGAWo6PqdYGp+2acFyeUKq3gUQqHggm0wHyviAuNTtQodRB+rM6wU6CPF8JcTjqaMR04k4E6JVEe9ymnHwSzJ+d85hsKTdZVqt/LDkBJHiTAc/x7Dy2Q4lj0qgdjDD9RhXbmcaThse1CNE4xhAu/srXDkP4GlsCcEOXL+EHDegujcmk/p9Jrt7gng+CvD8vnJJNoVZn7GjMBxJGCfipQyBaqicuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 18:26:12 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::50f5:6d9d:2c7:ebe9]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::50f5:6d9d:2c7:ebe9%7]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 18:26:12 +0000
Message-ID: <f137891f-eb33-b32b-5a16-912eb524ddef@intel.com>
Date:   Thu, 16 Jun 2022 11:26:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] igb: fix a use-after-free issue in igb_clean_tx_ring
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <anthony.l.nguyen@intel.com>, <edumazet@google.com>,
        <intel-wired-lan@lists.osuosl.org>, <lorenzo.bianconi@redhat.com>,
        <magnus.karlsson@intel.com>, <jbrouer@redhat.com>,
        <sven.auhagen@voleatech.de>
References: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:300:69::14) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d13b176-f2e0-4a4f-1366-08da4fc5b0f3
X-MS-TrafficTypeDiagnostic: PH0PR11MB5031:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <PH0PR11MB503192B2A5787DC3DD9129F297AC9@PH0PR11MB5031.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtA4Osf3F2A+5gGxvzeWfSHBD4WfXgOcH98KeZfalolp1trP+uxPdva0iGs4qo/eRkRTaLnGyVkZnSzDuvLhfNFiHh5RCacvKYkYfdlVForCoLCdgrCh7AtJOv+REfWivUcaCV65DI5G4LN0TeKorvQcXdkZWdgz3x4zDp8cxBiqoKRs298lvXjuWa77TBdtiq0i+gnc5reCMqNPFcnLqZWef8/SHuw0gKv3nxXLWvulIiI9YG3vLde6A3rCGHDgW2ER4bXHC1d9Rr9WJF9YYXN3hpnOru2r2BmFsNUGHyGnCx50PXi8xJX7eg8OKATtauyKOFhL2Vayr+PzyEMrTtshDLjDkmZj8s/xIoYgbjOPUo0+hRxtXse3NVECP96/6WauLe57pyA2dvIhGlzHmpn2MNdvzg/GR8uhVU72ELbUB7amQ4fKbGByv1/bawkw7Yp/vMoJxoZzaIydRuZ1lsBVMRUUfQnq7QPogc3Y5AeN9rFSSpH2L6QWiwuY524j/L5IqzhlJbT6jz+gCXHjLGyIt3HOE91PuAZpO3Uy08gHCHhNpHcW2Gxg9grRttbSBdoUWV3lRm/JE1rFek7MIAgJSSVcTg5mayndSa/V4SnKW3ZFWp+bgRDXl8tDzMOVFbxvHex4ztxJQlRAt3bCTJMGI5VROQ3FFA94/ALOxqSm994MJvD8kqHwSnpXn4XVSMw4U2Qq29fR7l6unEJTI/+iHvjrv9gdypkyDeEosFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6512007)(26005)(53546011)(31696002)(6506007)(86362001)(2616005)(186003)(38100700002)(5660300002)(7416002)(6486002)(4744005)(316002)(498600001)(36756003)(8936002)(82960400001)(6666004)(2906002)(66946007)(66476007)(4326008)(8676002)(31686004)(66556008)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHVmWFptR282TC9hdHdGdlo1VjVOcExQZkFhWEZKTUVFWU9NNlVOTjZvM3M5?=
 =?utf-8?B?bnZBZHI0L2JGbFdTa3ZhekhnZFg0V25QY1hwT3ZTa2ZKd0oyck5UNy8wSi9s?=
 =?utf-8?B?MmozVkkzaTVCYURRbFRTeE9VV3NkSWhyK3Y5OHZNRnQ2bS9FVFlCSUw1c1JG?=
 =?utf-8?B?TElqMHBBenozZmw5MlF0S2Nkdi9ueXpIbGxYYVd5V0VEb0dNaFhhQVlYNkc1?=
 =?utf-8?B?QmFIcldKK1pQMy9ldURqNCsvS0pPbEV1dXZ6ZGp0L3c0blBwaVJyaHUrZys2?=
 =?utf-8?B?MEZQZzhQMk5YbmFrU1M2VFMrT1hsTG5SaG1kWVNzUVIySmlwKzJTZzM3cHl2?=
 =?utf-8?B?K0VqWTdXNWJjeFJpa0ppU3NsNVRYRU1SbGlMb1F5K01GUExmWVYxbFJhQjZO?=
 =?utf-8?B?NVNUVHhjdThWUlRSK0MzY2hYM1IxeWVBRUM3bzlFblB4NG5uZW1vbXJYamtT?=
 =?utf-8?B?Wkx4K0JKR0I1ekFqSm9CRWc2UVZzZ1RNVEhCZ1ZvSWdkbWhLOUR3eWdhQWdO?=
 =?utf-8?B?dTVvOE5HVWFOcGtQRFEweDE2cUNWSTNYK0ZGZkE2UUFKVHhFcDV3K2dIRGpZ?=
 =?utf-8?B?VFZxLzJQbkNtSGIrNmN5VlVMN2l5OXJTcHNaZTlnWVloL0NmY3JIQmFMa3BO?=
 =?utf-8?B?dnZSQUE3R1VWZnUwaWxHalIvWlRwRFBRcHIwUG5XSnpGZXhTZVpYQUx0TGwx?=
 =?utf-8?B?RzVtdHFKUlFvVEQ3cWZPSDZzOTduSSt1SVF3NHZ3YWYwMlVKTkhTTS9sTE0r?=
 =?utf-8?B?ZldlRkVQUDJsYmlrOTQzV2o2VmtJMnV6dzhkNXFyUXRRNCtma0ttVytLYWpU?=
 =?utf-8?B?K3BGOGZOMDBtTEZaekVDNFhuK2NaOXh6NjdLTEY3QW5qM25aYkhpa2hhamhz?=
 =?utf-8?B?U1FFd21nc0RnWENrVW5jdkxvWTM0cUhra2p3NzJoaElBYlNOWGJjaUF5SlJt?=
 =?utf-8?B?OEp1MjJqVFZHRkp2RklISTFwcmxWWjFqSDYrdlZvdjl4T2t2a1VPVjdscUp3?=
 =?utf-8?B?aldEMWJ3UTIwU0hsTTR6WDFaN2pJdkI1NStmczB0TXRoU09iYjVlRTNkZHMx?=
 =?utf-8?B?bVl4NXFsaWlQR0lHWFN2UlRXWTR2elJWbGtRbmNiZHN1WTQ5blIvK0xsUEdP?=
 =?utf-8?B?WlFlMUlqSFZ4em5ZMVh4R1VoUjBTNG1aUldxM1A4cTdHUXB2dWM4L3ZKVURP?=
 =?utf-8?B?MUw2dU03VmVLRDFJdldQVWRENUFjc21wRnp1dExya215aCt2byt0STkwalNG?=
 =?utf-8?B?YnNZWHRmekIrK2l4OEpoamZsNy9XVEdEQy93RnB2bzNnNVI5K3VnQm8yL1hw?=
 =?utf-8?B?Y2MxWHdLWjliR3pYUGJFbWFjR1EyMFM3WUttYUxiM3ErWk1QWFM2QXRIWWlI?=
 =?utf-8?B?WXdreis3SThLRTZYWS8wTk5QckYxSzRTWDNwMm5la2d3V1h2aFdqdGdEVUox?=
 =?utf-8?B?dFV6N2FtZ1NSVXlQenRzWWVjOEI4V2ZBTzZTek9TaGtXZU0yc2M3TTRGbXho?=
 =?utf-8?B?am9FbCtGOSs2RmVxelJKb1RkOC9XR2tDdklIUEtsbTkwRmlERTBjemdlOExD?=
 =?utf-8?B?cUZieDZvYytibkhmaWYyOHhVMmtPUnVJU0d3NE9ueVNzems4ZUZ0bGJvS2tO?=
 =?utf-8?B?b3ZNMlJ3RWVydThFNDVCcUxTaGZZanpJU3RhY1JUdVVXTDBVazZIdUFqQkNj?=
 =?utf-8?B?QmlzWFM0L0RET045QWVyUzhQeVhtR2hpTjlOY1IvZWY3aXQzQjBMN2I3NjFM?=
 =?utf-8?B?aFBpbldTZzhvWWJhb3ZjYlViYloxS3RlTm1aN0lydUZuaktXWlA5b2dzR1FS?=
 =?utf-8?B?c0d6K0tHTUV6WE13VlZ0c2NpQVhWNFM2TTAvSVBhQWUyeVZ5WTllNlZNNkZV?=
 =?utf-8?B?S3BjaGVLcTIrOHVMTDJ1NG5DNVNlZ2o1OWpOZnVhRno5VXR2WCt1OGNYMUls?=
 =?utf-8?B?RE9USmRBWTZnbWMzYWFwc1ZRWDVwM0dPNHZRTG5vQ3pTSFBFWXRvdnppUld1?=
 =?utf-8?B?K2dXUDNKYmhGWE9sNm16SFdsbjFSdEZxc0NwNkM5blBZUjlVSjJWNzVVRklU?=
 =?utf-8?B?akR6WnNKNG1RSGNJQ3prTVJvRFlwemxzSjNPd1NVVGJHTUpuUEdQbmVYbEhV?=
 =?utf-8?B?SmtyZGtYbHNNYVNUZDhra0xlTThjRU1kcWdZS2N5andsUTdueHJ6YjNWRWJ5?=
 =?utf-8?B?cnVaVGZNVkx0bG8zT3VQUW9oRmpYVmFpNlBRbVFoVGJIdlFlWEwxLy9DNkJq?=
 =?utf-8?B?NHFNWTNxa0NZZEdSYVJOa3NFaUgwTWluWjNOOHNPckN1aGVvcEl4SkhvTXJa?=
 =?utf-8?B?cmhnYkFJeWlLWlk4WHF2ZGZFMzdPSUQ2WmtEbVdOT2NoWjZOT2sxeDFEVVZM?=
 =?utf-8?Q?7u3iUXefN+YfFHaQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d13b176-f2e0-4a4f-1366-08da4fc5b0f3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 18:26:12.5343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvG19ypaYk9cUxcp6WdtZXOa0WYAXXi1yIrI5xkzwchXkQruKWhgQEJrwMZI5Cm65uRt3b0WBgreN/LiEJ+HfKRM0MJhnQ28znL5sjgPrKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/2022 7:13 AM, Lorenzo Bianconi wrote:
> Fix the following use-after-free bug in igb_clean_tx_ring routine when
> the NIC is running in XDP mode. The issue can be triggered redirecting
> traffic into the igb NIC and then closing the device while the traffic
> is flowing.

<snip>

> 
> Fixes: 9cbc948b5a20c ("igb: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Thanks Lorenzo, @maintainers this fix seems simple enough you could 
directly apply it without going through intel-wired-lan, once you think 
it's ready.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

