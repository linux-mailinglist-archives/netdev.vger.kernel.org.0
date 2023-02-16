Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C1B699AD1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBPRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPRLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:11:46 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06E3A0A1;
        Thu, 16 Feb 2023 09:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676567505; x=1708103505;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D9qh7pcQ/M7oxgKwAk4F4gicS5kkWM0GpbVFR3Nh+5g=;
  b=kQgAcvCukx1zy+rliFV5NIgosMUDNpbg3iySB52Xk98SnDDBCn2IXBza
   kWvgzii5iw/pSXoYCjJlI/V6ygSSbz+U97KWg5YxFwVTzd/xskfyd94jT
   QFe7pGhG5GAMnZ3G9O3VcfI/km6rfVVNfRL4mkiIAvN9PY7trxBvE7maR
   3V0aszzp5yZrl+mWKUl98y2mqNkuZtHDfADXjBC36OH+8BNpCdmDlk4LY
   Z135JgvazgnNZecOCmP/9/pBoYA/wYKWvHOUeD7prOBvJFWrQ9Z8XyNlF
   9Wm7KucxDvH3ekoQgrZJfdmlpw2iNCyErwtkeaf8w5PlEuwzGoBp09H+Q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359207880"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359207880"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 09:07:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="999110383"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999110383"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 09:07:24 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:07:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 09:07:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 09:07:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6ftc6idJpQXP/vw/af9KlQ/yvM8QZ797AtI9MbFyO/XbqQcKm2ODJKD13PQLibTUorNxV9dUePVYFRcJP+XfwKfZF5UOGUnXXcdolIxPfYTsTyBUtWXPhSoWxNsAaH7oueFpUfvTz2HjWJqddyAOejx5ahvuqwGoHLVI9sWCwESyryFYNiMyDRsIATUZwH4bRWucqBIL7r9xLbXXxli5o72T8MKZ3nHiecyGxJaWAWarelgSbmuScr5puCJntGWSQJN01x2bZBUjWlGnJWC8648bi7HrJ4Eb/cVfWxUEdh9feCyMgullS7zIj0OvSOJG3MNhDF3kCSwnp8affcazw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fC+dqm9IyXudZg/VL5KcxrxDRtnQJwRy2aW+jJRBr0=;
 b=XIUG0Sz6TBnQVbiLpMDs2EpmehQDtWn8aCpCUOHCTxjYmTNeok0txQmfKsVXy81E2NerLlzACKmSego2AHJHDkNonIQ1a1Bk+c4t6NVviFR336LDE4xkfwjTd161MZ5zZN8FxX5XENQk9OXzAYiYXdsAz1hZ5TNWYXGZrav4fDxhn3Xn7Ls419WJwfjsPDb8drDK9pNWVWtur/cAbvY4Wc31GM/jcNFlag+8EqdF5L5o1WjlizjxtMUv2DjGAY7VVYNLTwMQAa6einZik7w6H6ZSLOi5J1q2AMkbdWccATBaTNmdj0aLUEMyI7q+GT7iQQyFGZ8CrrlgIyo4WopMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW5PR11MB5785.namprd11.prod.outlook.com (2603:10b6:303:197::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 17:07:21 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 17:07:21 +0000
Message-ID: <597822c9-b859-7a08-6987-1d8a552f6f32@intel.com>
Date:   Thu, 16 Feb 2023 18:05:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [Patch] [testing][wireguard] Remove unneeded version.h include
 pointed out by 'make versioncheck'
Content-Language: en-US
To:     Jesper Juhl <jesperjuhl76@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <wireguard@lists.zx2c4.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <83474b0e-9e44-642f-10c9-2e0ff94b06ca@gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <83474b0e-9e44-642f-10c9-2e0ff94b06ca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW5PR11MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 733c2a48-f8eb-4d66-dfbd-08db10404462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYdpamMQsLUbmgCC7Vssmz/0sa1DaCm75+ISoTDcYlemBV+lJvEWITcwXgtB4P2PMUmTWcsVFqirKQq4HDck5VHOlfsheLkIoCrwuxUCNiC1hq/avyZ/3SYwUpkCmcDg1iDCcUx62ksLn7YnNkEP8OqICBBCPB46VyqXNLVJQqEct0ShKqLrYWhMa4qmHMYyBJePK9ifYzdAA6lm646qq6r14hmOsNgJnF0KjEkq6MzwZ0/ys5e7acEsTi6u76vl+M2hW2tcS8qVTjGFJcE9fo+4w+VpFE6niWET6wMgNkOD6q72DBiCcoyBbypAhHUwdTp7tRkP2y7SWjGJxez0g2jdcMAM8lniTBkrzaSWkxo/Of54rSe/6skwNYBTDij/+7cv85kmTcMpjV+t1tLBaRcYqU79GJxJCiEZuf5Acvyz6+ZwoJFgIGxPM0qXg2jOk8/UMqlvvD65aJXW4G5KiyVVeY36W28co44lWrSp/QayQpckNG1KP4JExozhtnGayYnqNnxPoPGXZksFAcDvsanTKojyZedy7Php3R8Ii3Uad3CxIY4msv19kFGuAWCX1f+MPU7pFMR0kjTz76h+doN9u2MipW+KilU07y3GIKAaxWPegBSy0zRER9ZSQZRiGA+2Zw1tg8KCRaD+E9d5jkaKrYvNbnyGhBH61IiWUY83QagFE/18xPJ2g7k/3JtmPkELKUhysQ4VCZIcEHhEZJ5W8sIxIvj+zfJ6X/ZVQ8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199018)(5660300002)(6486002)(31696002)(6512007)(2906002)(86362001)(36756003)(6666004)(6506007)(53546011)(186003)(478600001)(26005)(2616005)(4326008)(6916009)(8676002)(82960400001)(41300700001)(66476007)(31686004)(66556008)(83380400001)(54906003)(38100700002)(66946007)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q05wSEQzT2w5VHFISCt5SjdOT1JCaFlGcittcFhsWUp4SHR5ZUN2Z2RSTDE1?=
 =?utf-8?B?enJiOG55a1BVaVlwV3dTSkVBRzFjUTZYclBJU3dZWG5EaS9YSVNwQ3BHQm40?=
 =?utf-8?B?ekpQQ2JVNlJZY1FzS0VpckJERitNZFh6cXc5TlpHeWYxdWYzSkxEZjZEbHVr?=
 =?utf-8?B?OHdKdEZZaEt6OXFxWFJCY2hzeEdRRE11VHp4MjhRVEpkMzNXSzNOVTQrQ1FF?=
 =?utf-8?B?RDBvY3ZHcGlHZmlvNFVmSW10d091VzFHcDl4Wndzejhnc3A4d2pWOTdhUDBw?=
 =?utf-8?B?cGhFMlVGRU5ML2FsSTY2MmZ2RHArY0hRbncvWWNmTTVmdXo0V3pNR0tleFp2?=
 =?utf-8?B?VFByRTdWT2hqc2pLUC9hQUNaTE41WWo5ZjBkTlFnVGxSS0huY1IybW03bU83?=
 =?utf-8?B?Q3ZTMVJoVmtHZk4wcGlIRzlqSWgvTGRCeFBDL1VIT2JPRkhQaFYxaWN2VGJD?=
 =?utf-8?B?MHErTGhqYU9HblQrYjFzWXpWY0tzZldQNHRQeDhMUlk0WHdEMDZsWXRRbERn?=
 =?utf-8?B?ZnBGWXNlSTNkWmszQTRoT2ROcE1qcWZLbm9FUWp1QWwrR1BKdFpScHZZMkdh?=
 =?utf-8?B?dDRjU2RORTVOQnVENU1MbVpXczR6SGpqaHNWWXh4YVIzN2pTM1k1eUZBZkhO?=
 =?utf-8?B?TGdrcFZKMVFiSURzOUg1SDFnbmFZL0tQTXlWTmFWWWRGYWg5TlRqYzRqYzRl?=
 =?utf-8?B?Unpkek1zMkJObE1IV1FSZ29mNThBekdreTlaTU5haFZKcmV0NXIrUzV6RmFT?=
 =?utf-8?B?Q0hBSzZOZjVGU0dKWmVKVnFTR0R4bzFGNWFRV25abStXVitremdJL1REdEJF?=
 =?utf-8?B?TmJubXZ3cVRlNHg4WmRQUjM2RENQbkdTbHFZNVdBZHRvWGYvNGJ5Um9WclJp?=
 =?utf-8?B?Q3R2MVFWYkVtSXgvUS9yZm9uVkVWREdLWTdZUzYwSUtHVjFScllHL05qYlFj?=
 =?utf-8?B?YnZ0L0daYTdiY2tjK3ZHRVdNcUZMbVhRRzUzMWZDY2Z5NDBvYTZFcDMwMVFN?=
 =?utf-8?B?cXQ4R2xoUUxzNmcvQ0QyV29CbGVHdWFSbzdKTitoVnNjdU5iMEhudHdWTk5E?=
 =?utf-8?B?YlB5dUJEemRoL09zUFJ4WC92UkgwSGM4dG9rMFd1MUN1ejd0dUdzTEZwSS91?=
 =?utf-8?B?QkJtUGRERUJSOHRFa3RkSE5nN3ZwVXFmY0hrc0dYSExPcVp4WXlJOHZzTEVW?=
 =?utf-8?B?L1BINE9wNWdGbVVZOHFJUXkxc3YxS3QvNk4wa3Zkd3daQW5hWHZoU2JGOCs5?=
 =?utf-8?B?RXNaeS9mbVNoS214eUFnbTZIbjNheW9mWjhxcUVQd1FWdnN4R2ZpTDM2cVUw?=
 =?utf-8?B?TVUxMEJRNlVZZXlzZFpTMWxxQnR6Qnc5SDJGK25KYnFHd3VrN3hsWmdWSHR6?=
 =?utf-8?B?empHTjF6ZFhQT25sU3V2QzFJTmpEaXN3Y3RSSUZlbjZpdkZuUktLQlkwS2pS?=
 =?utf-8?B?VWZjTVFoaWs3UjRrSy9TaHNCb0lQd3NlV3V5c3oxcXRJbDRYS2EybUhVN1Z0?=
 =?utf-8?B?TzZodlRMVE02YUlDMjF1Z2FHbVQ4clhQOXF4SnVsRWlnRlBHR2tobVBtSFda?=
 =?utf-8?B?bi9KMjRUTDB5d1N3T0pzaUpIL2R2U1JzUEJMc0FzVUhFQVVZUnZ1eWFHYVBR?=
 =?utf-8?B?c0I4U0JoR2w2U2RqRE1WZjNKeHNXQldtL00rNkJaY3hqMUtPQy9uNzA3Zmh6?=
 =?utf-8?B?MXFJc2NrVnlPMTc2aFhUUWhrVE1tS0pWUjE0QVBmeXFtMXpFalhHaDdPNUxH?=
 =?utf-8?B?YnJVd3NHVG8xOHBtRnZNaXpNR29ybG5EOEh1SjdQR1pUK1RNV0tBbjlYcW43?=
 =?utf-8?B?OXBkSDJrbk1lNEY4bllkOUxkWFAwZW1RT2t3YkV6ZkNzZmtzMVZWYjZzSGVJ?=
 =?utf-8?B?NzdzT0hWeU1NUWRWaHMxNzE4aEU0TVd3VTdIT2xqdCtWc1kwUWJRQ0lZVVhI?=
 =?utf-8?B?U3NWRlhTcDE2WkI4QmRpWHhxQzFqdkZEMktrRHdNQlIyQldyTEpMTEJqUzJK?=
 =?utf-8?B?a2ZBYklObjh1KytLNUZRdzFTdFYydHVMZXlCZld4dk0rN2JOaStlRStGQ1VZ?=
 =?utf-8?B?c2VaNHB4dXl6L1RHZEtKMXY0V3FUOFB2RWlEOXBYQjRyRGxSVnJPNFZ2emRT?=
 =?utf-8?B?MWU3amo2MlVzd2xqVlRIYis5amEyUjY0L2JwR1NSYi9DU2duL0REdGdFRkJZ?=
 =?utf-8?Q?9B3mUh2jKHNYNBofHl/vTuo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 733c2a48-f8eb-4d66-dfbd-08db10404462
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 17:07:21.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +urx6KwRvnQTPv9q28rxxuiOSkK5uCLbXvxBMgb/gnXWMm2cljZyyrBMayPK0hvUweJvzZCe7V2LOgPCewXq71prhXfzegQrIGzZZVmibjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Juhl <jesperjuhl76@gmail.com>
Date: Thu, 16 Feb 2023 02:01:05 +0100 (CET)

>> From e2fa4955c676960d0809e4afe8273075c94451c9 Mon Sep 17 00:00:00 2001
> From: Jesper Juhl <jesperjuhl76@gmail.com>
> Date: Mon, 13 Feb 2023 02:58:36 +0100
> Subject: [PATCH 06/12] [testing][wireguard] Remove unneeded version.h
> include
>  pointed out by 'make versioncheck'

Your patch is broken, pls resend.
Also I've no idea about the subject/prefix, shouldn't it be like:

[PATCH net-next] wireguard: selftests: remove unneeded version.h

?

> 
> Signed-off-by: Jesper Juhl <jesperjuhl76@gmail.com>
> ---
>  tools/testing/selftests/wireguard/qemu/init.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/wireguard/qemu/init.c
> b/tools/testing/selftests/wireguard/qemu/init.c
> index 3e49924dd77e..20d8d3192f75 100644
> --- a/tools/testing/selftests/wireguard/qemu/init.c
> +++ b/tools/testing/selftests/wireguard/qemu/init.c
> @@ -24,7 +24,6 @@
>  #include <sys/sysmacros.h>
>  #include <sys/random.h>
>  #include <linux/random.h>
> -#include <linux/version.h>
> 
>  __attribute__((noreturn)) static void poweroff(void)
>  {

Thanks,
Olek
