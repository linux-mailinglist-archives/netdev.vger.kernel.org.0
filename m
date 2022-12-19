Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDCF651157
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLSRtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLSRtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:49:14 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CECEE03
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671472152; x=1703008152;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pgmsDmkMMweAT5tZoSWWz2zpHymu3w6maJ2mUQbW5VE=;
  b=Docdy/zbG0IlRJm2LcEM1yPM6asnTnM8YuJmN/V+PuPGXZZ1Ph7tjf9p
   1rEFnZua93lwPZfoWhCYCr5yzjcZyNMOOTmNaLwsALLDbL8bCgjn1x4g/
   VqePVM0qiCuWTT89nkMALkxCJPHMNg8KiCWwCMNBg/HLQA8wQERcq8Lnb
   Q0g/muEdnIq1Vfie5XpegSkae9Wjghv0xTCr0UnbQA0lhc3JDehh9sUV8
   8QuB4M+5w6G3peW+EjktrKmIKAZrlTV3I3ksnU2V45z+MNDoFrHssR4uA
   0Z910hbyVvOa7oBzqtWzqYY2rgkCRobbkfCBlQDkmKJHWIllyrg6R4hss
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="346508910"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="346508910"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 09:49:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="792970265"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="792970265"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2022 09:49:01 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 09:49:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 09:49:01 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 09:48:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjCHosYHt2rHXT8HzP+yf14u/fpsVGrA4uyXGTDIrcvvOH8/R495Wu+bsgzYXEkFZ02Rp3OY272KXB9ooD4oahScyM16aGrH2I93I+yAyz62zEg4WfmSodg3g8gsNRjDrBlq8aPWyYE5cTRmN4O9Bie0kwU4SzUynATwbqErbLi+QMRxkxDYe4gwJdwJurUjFYJpGcrsIgoK2CSULwLJIVLqfsi1vfaipSXT5vK6mDm0gSV6+wmkZujooeltV2CP+QWlukGSeIsBGDXhVS+oWWvCx47EeI0AMqdInBHCfttEKJN11OW6+V4ziN2dyIt3c1YotgyXvoQYQmp9Ev09Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Na/2KyYGuw1wsPhGoLBwycsLPr6CWKpsDmnWTB4jJdM=;
 b=Vt9ckUdewQNPkDPWQxtQGnYqpGMRSynqWgtRoVuVuswjdRd/YNR+aT9X7dCe0Er6iGEmi4AcY8wKUdFokYPGMViaHkpcwjZoGFsOXQAB/Ks1VZscIisv9RiGshYPXTbbncLxhDH5blm9pToK6aL4KTp6QydXJuAlqdVPt0St4i7NkNNXm0uQBnTHbO0wmYqm2KPYdgg6yL1gT6zaqKQWZKOJ/ofQ8DuNQtk5XaQSrbwaldb4ntHAL1VSmESSjq92qF43/R8oenxmynjIY94N/Lr6U81O1yY7nJLO4yg6atVtMgUzL9Eh8jMv6VIv63SGxZFjVa5wbF5UmFn+tvUoPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 19 Dec
 2022 17:48:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 17:48:58 +0000
Message-ID: <84151471-4404-d944-417f-2982569f44da@intel.com>
Date:   Mon, 19 Dec 2022 09:48:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <jiri@resnulli.us>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221217011953.152487-5-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::36) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB5358:EE_
X-MS-Office365-Filtering-Correlation-Id: c31a0541-0814-48ef-2cfd-08dae1e94df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5c27Re+p6x40/9i2aekXqDqm9vVEhy+MVbkKlpMLnIsVc4NOn7CV29ZULlZbmPvAjf5sHuP3oq7cF2Vc110WYtaemkFwTK29J1D89ssyIvHO78yqm/yyOPIRqJj6FUzxDF/+1LBz8abCfwHi065NTaDtl1rmA2d3kLPfNHEFs4l8iiATKjQX4dttI8l2vQXW44af6u1wSyOr2BbZTDizuCBGhguIXdt649NKTuIB4Jv1wLS+PGg6WmMQft+sx/MeKXpfpwYeWhF2g8zVOSLaLc8zt0gvlMTi/1xGrdwwu1HNxid6xrkV9fNe8/2mj8fer3iEhiSQs2ysr+GUQe2P4uPCO2HUqs7vhlwDglJRik/FmKGKdei86Q9uXpaKTlfveH0Gn1TeoVOP3ABtOum1yI61k9rO8WhXaYqatZj+H6XwJ+LNzR7FtmeHPFMasSThUCPT1Lu82nRkXI1nqfoRKj3L2/xsTLpmA5hyWL5Hz0vBLRcXvV0BgrRP5W0lZGDuyLcl2rOzZsdZxrsuu70C8xRdUKMKcuGGNT82rXFQR+fTKKLRNNaAJKeXGKNJ6brPGWDL+4V5fY4F2wd3rQjanl49bHZ/dLZl+Bfkpth9E8zuMaKqTnLooS6ECsVKUGN5ZPUgscfSvKhPD5//mugudsAo0cNxRH2KppyEQQ9fZe/Hr7SmgzSy/jPghfB4L9yhwv7fxuLUxCgSTjulm3M2v+x2NVUqJvUqdV1Notdd1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(31686004)(5660300002)(38100700002)(36756003)(316002)(66556008)(8936002)(8676002)(66476007)(82960400001)(2906002)(4326008)(83380400001)(66946007)(86362001)(31696002)(186003)(6486002)(478600001)(2616005)(6506007)(6666004)(6512007)(41300700001)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHQxUFZSMjFuSkhzWUNYZi9ubWh4YUR5REVFdVh1L2xKZ2Fxd3Bkd0swYUNU?=
 =?utf-8?B?aDBSalREWWEzTnRMcDB6N2lXdDdmUDdtN1ZSNzNYUlFwaytaQy9vUm1TMGRj?=
 =?utf-8?B?dGo2YktjV0JUdGhyV2VnQ3BsR2VIVnpxaTZteWR2dlpLbnlLK1VaTk5KbTZG?=
 =?utf-8?B?T2VPRzhVblBTN3hkSTg4aHVTOEhhKzFkRVh6MXhmZHVYUXNOYjh1L2ZoNnlD?=
 =?utf-8?B?dmVpVXNWaWdaanFqV1dkZzJSb0gxc1d4MVhGdjFiRDJ2ZU1mSWcwYlBjZTZW?=
 =?utf-8?B?QmRENmpLSDdOaElWZGpqNllzVkpDR0s2V3J6alpxeVpIUmR2ckg3eHY5Q20w?=
 =?utf-8?B?a1FPc2gxSGFSR2Y1K2VNN1BjR0t0ZmREZ2lkMGxyRy9RdEw3RjZKT240Wito?=
 =?utf-8?B?bEFaTmF1YU0zdnFXUVlIelZxV1hoeHd2VjZUbDlnM1dvYm8yNzBsZmdacEdz?=
 =?utf-8?B?MHUvMXZnbVljM0JOd1dTeVM0Tk1FYmthSERXOEVtMU4wZ0dpZDVxUHh5aVY2?=
 =?utf-8?B?SXFwV2dKRUM5NzFDVkVWNjZ5dUIxb1RGTzBlcWMxczJ0Zmw0eDhsbUp2VG9z?=
 =?utf-8?B?djZUTTBkaHkyd2xhc3VOdmRpVGw4TUVFQWtyUk0yaldHalBFYWNmTnJld25h?=
 =?utf-8?B?aGJrb2ZhWVdwOThjMHJPbDBrbzlSWitLaWRadnk0dVhNblAweS95QTA3UzJK?=
 =?utf-8?B?U2h3cEtTWlNPZ2RuSm0zdXEzNURlb25ra3YrczlEajh3L1Ribk1hMEd0T3lE?=
 =?utf-8?B?dzljK3lTZUJlRktxV2xzR2ZqWjQ2WU42TnlycCtZRFQ1TjBjcW9Ka3dMd0xu?=
 =?utf-8?B?d1lwR29Iam40Ni9YclZzay8wZlFsRGhEemRkdTV1dnNHYWtHQ0VHSUgvTTNt?=
 =?utf-8?B?S1N0K0Zsb0k0VlJVdXZ6TTdiaFBWZlpyV1gyNFZiakdQVDE1aW9PY0FXenQ4?=
 =?utf-8?B?T213bUFwSS9JVGtHV1Z4SThLVW9wd2ZWVU1lek04VHMzR1pHcVpjZzlmcFkx?=
 =?utf-8?B?N1c2K3hiUHBwdEdyRUpPRmdENkNMNXA2ZjJFMG4zbTBicmtDUlVPUENpUm9C?=
 =?utf-8?B?dFpuTEpBNy9SazR2VG1LcHNvVW9VbXVJUk9NaUk4b1lRVFJ6ZE1XREd1bWpV?=
 =?utf-8?B?Sm9uOVA0c01SK2Y3UHRrdmhrUk55MFdFaklnMVVRRE5DTEVzYXBOdkluYU1w?=
 =?utf-8?B?VjdzMXM0akx3eENpQWJ5dmJmdndpZEI5ZlkwaG5NVVhNMHNxckxudExSU2Vx?=
 =?utf-8?B?UzFPRUFpK2xjR2lFQlUvQnV6WkdqMHZnT2cwdFRwRkdpMXQ1bFk2YTk3YTJC?=
 =?utf-8?B?TVFZWTQwMmVDSFNaKy9vSWVzcjNYWVBhMWJHNnIyZmliOVFWdVoxZWFpeldN?=
 =?utf-8?B?TmdCU3A3dXdpRktuNHhMSlZtNW1QU1crVlozMjczOFNyL2JqOVpFWXozMmpZ?=
 =?utf-8?B?WHhRN0dKdHpiN3MzVEd6clVKYVErQlRDOE51bDJFSWpMaUxwR3ZtaVFGd0tB?=
 =?utf-8?B?UzlIS0o2STdHQUZxeC9RTisyRk9YVzQ1UUViWDhSOWUycklkcWx0NWEyTjFR?=
 =?utf-8?B?UFlnOUZKMkY4NS95ZEQ4UFBGdGY5U25wdWQyVDhMcFQvcUFQWmdseE51dG1u?=
 =?utf-8?B?UndzZXIyTTZhdzJWOWRKZ2hUOXBrU1o0cGpuaTJvWDRBL24xOFVvRVdYb0Uy?=
 =?utf-8?B?V3JTNWd6TGNxSDBHYzNTVzNwRkZncHIwcHJiY1VQNHc3YkpIOGl6a2xqMzM5?=
 =?utf-8?B?eGZhb0hDQU5oME05VXFub2d0TkhLMnM0T0M0SUV1Zk9tR3JWTTlneDZGT09F?=
 =?utf-8?B?M2F5djZpSlFsbHEzN3EyNENqUkRZTjAzOHNnUVIzd0hML2NGUGlKNzdnaW5m?=
 =?utf-8?B?S2dXM3JhS0ovUllGZU9mSkZaY2E5elpJUkVLeUtvdjcvWjgrOU4xVHlnVDlF?=
 =?utf-8?B?S0hxTFBqK1VpZTFjMlJ6UTVkRlRWY1VuZTdpYkdEV2I5WDg1aEREcllTYWpD?=
 =?utf-8?B?WG5VU1lPS2oyUlQ2WHF2RnIzRnhVTjU1VnRFTlhLaXU5a3pWMTVoaXlzK0ll?=
 =?utf-8?B?VnlhZmtvaFRnN2R2ZW5tRW11bmRjWTVmVWMxdTg1dFhXYjlndWZWVnB0aDJQ?=
 =?utf-8?B?c25IMGx3dFlyUVN4QmJFalhaeUFJUFU4bTVtcVdxclZmY2lvTWJmRlA4eDJy?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c31a0541-0814-48ef-2cfd-08dae1e94df9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 17:48:58.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwePnvL5Wlh4jB0VcuZBwNWF3bDJjbiD8ki9V9j43y3fBM/tz9yf3v1T54Y6NWxZQ/fhlMtMfxhFVfRoPbhOfFx6bpYRZyh92Bneol/uqi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> Always check under the instance lock whether the devlink instance
> is still / already registered.
> 

Ok. So now the reference ensures less about whats valid. It guarantees a
lock but doesn't ensure that the devlink remains registered unless you
acquire the lock and check that the devlink is alive under lock now?

> This is a no-op for the most part, as the unregistration path currently
> waits for all references. On the init path, however, we may temporarily
> open up a race with netdev code, if netdevs are registered before the
> devlink instance. This is temporary, the next change fixes it, and this
> commit has been split out for the ease of review.
> 

This means you're adding the problem here, but its fixed in next commit..?

> Note that in case of iterating over sub-objects which have their
> own lock (regions and line cards) we assume an implicit dependency
> between those objects existing and devlink unregistration.
> 

That seems reasonable.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/devlink.h |  1 +
>  net/devlink/basic.c   | 35 +++++++++++++++++++++++++++++------
>  net/devlink/core.c    | 25 +++++++++++++++++++++----
>  net/devlink/netlink.c | 10 ++++++++--
>  4 files changed, 59 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 6a2e4f21779f..36e013d3aa52 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1626,6 +1626,7 @@ struct device *devlink_to_dev(const struct devlink *devlink);
>  void devl_lock(struct devlink *devlink);
>  int devl_trylock(struct devlink *devlink);
>  void devl_unlock(struct devlink *devlink);
> +bool devl_is_alive(struct devlink *devlink);
>  void devl_assert_locked(struct devlink *devlink);
>  bool devl_lock_is_held(struct devlink *devlink);
>  
> diff --git a/net/devlink/basic.c b/net/devlink/basic.c
> index 5f33d74eef83..6b18e70a39fd 100644
> --- a/net/devlink/basic.c
> +++ b/net/devlink/basic.c
> @@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>  		int idx = 0;
>  
>  		mutex_lock(&devlink->linecards_lock);
> +		if (!devl_is_alive(devlink))
> +			goto next_devlink;
> +
>  		list_for_each_entry(linecard, &devlink->linecard_list, list) {
>  			if (idx < dump->idx) {
>  				idx++;
> @@ -2151,6 +2154,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>  			}
>  			idx++;
>  		}
> +next_devlink:
>  		mutex_unlock(&devlink->linecards_lock);
>  		devlink_put(devlink);
>  	}
> @@ -7809,6 +7813,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  		int idx = 0;
>  
>  		mutex_lock(&devlink->reporters_lock);
> +		if (!devl_is_alive(devlink)) {
> +			mutex_unlock(&devlink->reporters_lock);
> +			devlink_put(devlink);
> +			continue;
> +		}
> +
>  		list_for_each_entry(reporter, &devlink->reporter_list,
>  				    list) {
>  			if (idx < dump->idx) {
> @@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  		mutex_unlock(&devlink->reporters_lock);
>  
>  		devl_lock(devlink);
> +		if (!devl_is_alive(devlink))
> +			goto next_devlink;
> +
>  		xa_for_each(&devlink->ports, port_index, port) {
>  			mutex_lock(&port->reporters_lock);
>  			list_for_each_entry(reporter, &port->reporter_list, list) {
> @@ -7853,6 +7866,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  			}
>  			mutex_unlock(&port->reporters_lock);
>  		}
> +next_devlink:
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  	}
> @@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
>  		return;
>  
>  	devl_lock(devlink);
> -	__devlink_compat_running_version(devlink, buf, len);
> +	if (devl_is_alive(devlink))
> +		__devlink_compat_running_version(devlink, buf, len);
>  	devl_unlock(devlink);
>  }
>  
> @@ -12227,20 +12242,28 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
>  	struct devlink_flash_update_params params = {};
>  	int ret;
>  
> -	if (!devlink->ops->flash_update)
> -		return -EOPNOTSUPP;
> +	devl_lock(devlink);
> +	if (!devl_is_alive(devlink)) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (!devlink->ops->flash_update) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
>  
>  	ret = request_firmware(&params.fw, file_name, devlink->dev);
>  	if (ret)
> -		return ret;
> +		goto out_unlock;
>  
> -	devl_lock(devlink);
>  	devlink_flash_update_begin_notify(devlink);
>  	ret = devlink->ops->flash_update(devlink, &params, NULL);
>  	devlink_flash_update_end_notify(devlink);
> -	devl_unlock(devlink);
>  
>  	release_firmware(params.fw);
> +out_unlock:
> +	devl_unlock(devlink);
>  
>  	return ret;
>  }
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index d3b8336946fd..2abad8247597 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -67,6 +67,21 @@ void devl_unlock(struct devlink *devlink)
>  }
>  EXPORT_SYMBOL_GPL(devl_unlock);
>  
> +bool devl_is_alive(struct devlink *devlink)
> +{
> +	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> +}
> +EXPORT_SYMBOL_GPL(devl_is_alive);
> +
> +/**
> + * devlink_try_get() - try to obtain a reference on a devlink instance
> + * @devlink: instance to reference
> + *
> + * Obtain a reference on a devlink instance. A reference on a devlink instance
> + * only implies that it's safe to take the instance lock. It does not imply
> + * that the instance is registered, use devl_is_alive() after taking
> + * the instance lock to check registration status.
> + */
>  struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  {
>  	if (refcount_inc_not_zero(&devlink->refcount))
> @@ -300,10 +315,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
>  		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
>  		devl_lock(devlink);
> -		err = devlink_reload(devlink, &init_net,
> -				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> -				     DEVLINK_RELOAD_LIMIT_UNSPEC,
> -				     &actions_performed, NULL);
> +		err = 0;
> +		if (devl_is_alive(devlink))
> +			err = devlink_reload(devlink, &init_net,
> +					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> +					     DEVLINK_RELOAD_LIMIT_UNSPEC,
> +					     &actions_performed, NULL);
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  
> diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> index b38df704be1c..773efaabb6ad 100644
> --- a/net/devlink/netlink.c
> +++ b/net/devlink/netlink.c
> @@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
>  
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
>  		devl_lock(devlink);
> -		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
> +		if (devl_is_alive(devlink) &&
> +		    strcmp(devlink->dev->bus->name, busname) == 0 &&
>  		    strcmp(dev_name(devlink->dev), devname) == 0)
>  			return devlink;
>  		devl_unlock(devlink);
> @@ -210,7 +211,12 @@ int devlink_instance_iter_dump(struct sk_buff *msg, struct netlink_callback *cb)
>  
>  	devlink_dump_for_each_instance_get(msg, dump, devlink) {
>  		devl_lock(devlink);
> -		err = cmd->dump_one(msg, devlink, cb);
> +
> +		if (devl_is_alive(devlink))
> +			err = cmd->dump_one(msg, devlink, cb);
> +		else
> +			err = 0;
> +
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  
