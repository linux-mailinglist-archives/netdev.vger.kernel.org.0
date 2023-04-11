Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E516DDF8D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDKPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjDKPZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:25:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30C1123
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681226719; x=1712762719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mOkOFrQ7tx+pRu32sZ2zM0P5+9gVj445gEoFmuOcRBY=;
  b=JP2rYHd40gFvbCe8MpXB+eIb2VbrFf0xVIeeYKnYCgNymnzagHDTNzaC
   MHlYflXtwQES48KYlTj37td5gKkmNuAf0jWoirAcSaInBBYDfJW9A4F1s
   ZtYwKhdBhKhHi+F/QaXgBhEO/wDZQwAVwuIjyDNbq2tddxNWNCHBii0Ib
   bmfsZ7PBDkT5ibg562mr/UhHRVtMohE0O9LQXJvyJ6j59zW1QstVJMCl6
   jkjJPwC5/EP+mcMwgmABl8upEdXXkZTevviB2rX0Un7YTCwUu53QzxBFx
   Z+uYtORsJNQ5JpdsX6FfPNoYVVoEaJ0Ohwa7Luqh0nuQliJjAzijS3u9C
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="342408273"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="342408273"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:25:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="1018405170"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="1018405170"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 11 Apr 2023 08:25:14 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:25:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:25:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 08:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtLd+0YD/NMTv2cbHb3oLVK6MZamIWqtFS80hf5hii6UoWAAu6hBqKYgEwbKiy2UcmY/7UUzBKdrgdFbK8lMMWUDJ7aW5F2Y3CUfGzzq0H/mkfpNoDs59uTXoFl/Vd9YiTDz8KZuK56ezOXdOkhJHiARxEP1kv9CzyhcguO0eIzRCTYaGp/nkGp2TNxIJ5T7g7wmP9ClYAOGXegboJDEMDkc3LPQe9E4teULbVa48rbuFAOdI3MiopeyRYDIuv+gBOKa0DcrudJLQxI8+lXOE76N2XkiEYXHbjadJUtEU8h2/95hjtSbpBcAUu2NVz1/kwy+8d0cvQoCdec/rHE4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXye95uJgPkkOEn/4a7EYQILSwgKZV/LcJmv48bexnI=;
 b=B2u1p7Fbtc7P/OQLuGA31PSmLNA8leOd8ocw1tCbNAIAY8VizSLh1yLBPlEycAB3qXRqLn97cWVaBAdDKecmKDLph142pHgBoDTX351Z+7jFwZf5FaZMugP+NZQP7HtfM+LrqMAZc3biGKgZwlOo4ANERgWnbtYIaExoBvx0sShFpO9MQqXQyP1/SZnC+TWOhVpOB+yyC4la2mf7nIXHpyUTsGpf+2YENkKepdZ9MP2RGLTFCduEAY+hrsNdZK3WTknuqQ7e7D2J88zTPHwT+CyamF5Utqz3i3z0yHnh1/wfHHEwGHfSW8ZO1bBUtTMaXujKkD807B0BsYhQexImjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB6797.namprd11.prod.outlook.com (2603:10b6:806:263::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 15:25:11 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:25:11 +0000
Message-ID: <5cd0369c-4bd6-e5bb-c2a2-04be52ebaa72@intel.com>
Date:   Tue, 11 Apr 2023 08:25:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH 1/1] net: macb: A different way to restart a stuck TX
 descriptor ring.
Content-Language: en-US
To:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        <robert.hancock@calian.com>
CC:     <Nicolas.Ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tomas.melin@vaisala.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
 <20230407213349.8013-2-ingo.rohloff@lauterbach.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230407213349.8013-2-ingo.rohloff@lauterbach.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 135ab616-e684-42e6-a943-08db3aa0f08d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfX/3PzENXXAcIJ3KNDdZuYRRW4qDyqsRjpmsTr2XU+X49xPpXMmte8kjaX1X7jMrSaXa7jUjwCVSq/PASeDlr311s2wLW7RtMTsGlz8GLqPItTnMyxi5EqXg0IIwSEl7Fm/h7EA6CFVLtUCfSYwJzibn2dNDgbopFuFMRn0AbZ8g4QAR3KXVqBmFXQ4mGW3ezpGz0RF8x093VoZDmQF4XY16qIWuAONaCf6DGWi+eACdRQOhAJtC7g3pi0wB0h+wcaOvKhkWohoVnqxpkKEu/m1MaB1Qhlkc3YGdulhAULa5UhOGojb29pz4BgUivwYK1Afp2N8tiLCqUmAqsKGUF+/0W0k5PX6z1QLhVuTT2YfTFHUhac2uJU3Q2hglZiN+m362cIv5SVU0M0mFSPb4WYTcDTqzmNS6xDxpEtkKOrEByUviPqYLCwE3qN+Sae8a1qk6x81f5UPh46erny+cCN2lzOdyaB/j6lN9rtXfP5BCFK1lnB6SWZdreVWxT1/cZctPPqgTw915337+eizWPvvenw+EBaO9kiQDwtF8CfvSngF1ghCAJUgYMvYZUkw2fGrs/GGrD51luYp7px1w77wFaBTNbKHP5A+Mo2ljQOm2CJG3HMwa7uu0FnQxbiAx6Tj0Y982uPfcgcx0TbrYkHqGXTgRbef1uVQrKJtJ+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(31686004)(478600001)(6486002)(66476007)(4326008)(66556008)(66946007)(8676002)(41300700001)(316002)(86362001)(31696002)(36756003)(83380400001)(2616005)(26005)(6512007)(6506007)(53546011)(6666004)(8936002)(2906002)(44832011)(82960400001)(5660300002)(38100700002)(186003)(43043002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTJXYVY3V0o5dlBraFFuRkQ4blg1a3NRUDJOdDVPQTNmVUZkME44K1hKdVBh?=
 =?utf-8?B?aWlNcnBLZlU1VnFzM2FtRnNsblQ1cjVpT1VzUlprMFlzcmdWMDVVQWs3UDk3?=
 =?utf-8?B?MjgyblgxUkQzTDM2SjhnNHdLSFA0ZFhpOGQzNG5kUUNlYW4yZE9zeEtTQjR2?=
 =?utf-8?B?RFZDakJRazdNb3ZLbXViNmx2MVNtbk9VWVlYMDF3dGxQU1pVTnNTZGJpVXQr?=
 =?utf-8?B?UlZ1ZmpPbUpLZGpvVmxHQjZablBJWFRzR1V4a3VQcnM2VGxiZlhmYk5ydlVX?=
 =?utf-8?B?cHN5SlRqSy9LNEswd01ubGNSUGNhSjI3ODEvbnNOMmtsRWc5a1lDR0s3eFJn?=
 =?utf-8?B?V09jOEZZNlc3RmYyVE8rKzFoOVZQay9UajZXNUxZL0dTOW1TWWxoSUYxalhj?=
 =?utf-8?B?dFVzUmRTalA0Ym1vTjJiUjZZMkVOdVp6enBlZU1OQWNOeStMRGVjeEE2U1hL?=
 =?utf-8?B?bVJhNzJsdUxsWXB1Rm9zdDBwOUNoZVFTbVRsM1AxS1lKMXdza0h1SHZwQmpx?=
 =?utf-8?B?a1dUbVBrOEdxNHRMM09HUjVPTDZ2Z3JnbC9OSEZKdTU0b1VjdTZYcHVFVGFh?=
 =?utf-8?B?dFR6UjVRSzJwZy9SN2EwTzRHOGFtUFBpeDFSV3dVUm90ZTdYUE1Fc2dhWVlE?=
 =?utf-8?B?SGVnNi9pZVB0S3JLaUxwS01zQTJxOWhvNHFpakp3RW1wVnhBc2xUQTYxWVFr?=
 =?utf-8?B?aUlOTXhmRklsa0JPMzg0amMrUlF2c0taVVNaZHdxQ2dNV1hiaTFXNmQ0MDU4?=
 =?utf-8?B?ZHV6UDRlTEdYRytHU0U2WFFKb2k3bFhxYUVKYlQ5VktTNzdqaG9DQTVtd0lV?=
 =?utf-8?B?YmdmS0kwUFVuMUpRTVNicEptdnBvbGM0N1hodU5xVlJtV1BVd2plODE4Ui9T?=
 =?utf-8?B?c1NxUkhXM1oreGJrOTFMRUlwSFdQbG1vbU9uYkNXcFZLVXhnQmRxY05VVyt5?=
 =?utf-8?B?eTlJVFR2WlhkY3Z3STZPK3JnTTRGMTZ1V2dCdmtlNmxGd0plYVVwUUMwN0pF?=
 =?utf-8?B?K2NiSUpyMEVYYTZ5VEpweE13c0VsVW1FTVczT0JyNjZXalA5ZjVUeUgrcmVH?=
 =?utf-8?B?WDlQWlhOTThSWW5DeU9QLy9JdE05NUdlcGFBQ3dzMVZSUkxTbWNIVG8vMXFO?=
 =?utf-8?B?WUNRVElTQ3Y0T1VKWXRHK0szL0tDQ3pFblhnNzVvcXRsdlJDTDZrcSsvTGY2?=
 =?utf-8?B?SER0ekw2KzU3aE9Fc1dadktRUW85OGg1d1gyMVhnTW1iVURueHZDaG44S05q?=
 =?utf-8?B?TDU4dmp0MU1DTzlYdnFYNncvRlF3elR5VHl0bnhVeDF5ZUNEVmN2NlA3TzZs?=
 =?utf-8?B?bm9wZTNjVEJOMkorOGtlSWxrRUhCUllMaEZ3WThFZ0Y1dHdQYlVMZGg5ZDRo?=
 =?utf-8?B?RDZpVzNMUk9wL2RUSDRHSmZnUXpFTUtCbzNhamhqbXh6ZUZEbTJMR0E3dXNO?=
 =?utf-8?B?ZFJZOTV0ZTdmOGhDQk9RNUZycC9BT3ZJbFY0YzlLZUhKUGVkTk51UVJ6dWpi?=
 =?utf-8?B?amw2UGRVLy9kbldhb3NuRjBaaFBNRTVZNmNYWlJvc0N4OFhmYTdVZHNKLzBP?=
 =?utf-8?B?QVpvOUdvNCtNem1TMWZNdHJGT0dLRUVaZ3NOS2hpR0hYM3BzWXRwWmRMUENW?=
 =?utf-8?B?NjhXcnNuYWoyTjhtNFRPSjRtNy95V0ZGaGFoQmxEcDlNU0lYc2Z6N0dScm54?=
 =?utf-8?B?WW5JQjZZcVNCaHAyempzcHNiY1BmaDFiclZOY3Z0QVg1N1I2dU8rV3A5clA3?=
 =?utf-8?B?MWV4NXJRQUduUWJWb3c1a05uSGVGWEEyZ0ZyS2xqRm5lTGp0cUNYbFlmdExt?=
 =?utf-8?B?TzJCVDZGVGNMNFgyb1E1NWlTRVducTdvMzBvMnhTR2ZNRS9MWFFvVjhEUG9J?=
 =?utf-8?B?KzUrTFVxVHlmSHMzNDQwNVNCWXBWSWJMQ0s3TE9zM0s0TmdJdG50T3JnQ1Rq?=
 =?utf-8?B?UEg2ZGtnUTUxU1NoREdOWlhPbDFYZFNkK2MzdURyZ0RJN1RsZWJHUnRjbWtO?=
 =?utf-8?B?SzViV2dEekVvY0JINGNOYTNCNUpJakg4ZTRuM25GWnNFelNVbUcwd280OFNR?=
 =?utf-8?B?dlUyZ1lKczBMZnArTW9UK3FzRjlkNWtGd3RGVEtZVTJOOVBhQXI1RXZQUGor?=
 =?utf-8?B?K2RnQTdybGFWdnpacGlqdDgxUURqY3habU92RUVRVG9yZEIvM2VHMHRVWFZS?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 135ab616-e684-42e6-a943-08db3aa0f08d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:25:11.0804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pynwYf9oUH5dvQMcqEA/6NIDkxOyrhzTvO9JQty0eCc1K/910l3GwYehVKPn0Sa4ZdMvBuxzckj1vW/7KHaUt21SJHaMMyih2S71V4zmSYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6797
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/2023 2:33 PM, Ingo Rohloff wrote:
> This implements a different approach than Commit 4298388574dae6 ("net:
> macb: restart tx after tx used bit read"):
> 
> When reaping TX descriptors in macb_tx_complete(), if there are still
> active descriptors pending (queue is not empty) and the controller
> additionally signals that it is not any longer working on the TX ring,
> then something has to be wrong. Reasoning:
> Each time a descriptor is added to the TX ring (via macb_start_xmit()) the
> controller is triggered to start transmitting (via setting the TSTART
> bit).
> At this point in time, there are two cases:
> 1) The controller already has read an inactive descriptor
>    (with a set TX_USED bit).
> 2) The controller has not yet read an inactive descriptor
>    and is still actively transmitting.
> 
> In case 1) setting the TSTART bit, should restart transmission.
> In case 2) the controller should continue transmitting and at some point
> reach the freshly added descriptors and then process them too.
> 
> This patch checks in macb_tx_complete() if the TX queue is non-empty and
> additionally if the controller indicates that it is not transmitting any
> longer. If this condition is detected, the TSTART bit is set again to
> restart transmission.
> 
> Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>


I see this series is still under discussion. Next time you send please
use correct subject line:
[PATCH net v1] macb: ...

Also please be sure to cc the correct maintainers.

