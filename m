Return-Path: <netdev+bounces-5177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C277100E2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 00:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EF9B28140A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 22:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5986023C98;
	Wed, 24 May 2023 22:25:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4588022627
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 22:25:10 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576CC1A6;
	Wed, 24 May 2023 15:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684967077; x=1716503077;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2u1lF6jlrDv8UezwFTut5gBPLfmmNKglPYUp6Ax98sk=;
  b=NneJ/kYIrgUvPRmKvq9MlD57iXcVyP6cO9Moseo08oRnz8sXmVYxNUhu
   J9P+jenjG9pGdqYYgrFrdmkdZFUFflospa+UrsDUdK6hvmfE6FE7lFVYw
   klefgZXnEpaOyq9wSY6rxzYcjmHLVKA7z3XRk5LzVyX4/5CEvFhrzukII
   Q9gslLAqb78uA6rBjawOlwtBoJheAFGE0W93ZE3hc/6kTAlCX+312IJbx
   lr5B1TcQJA11RegN+SLtCoscs+zgN+d27mIgVAsqnCotZf0WBeN0dxzgy
   FqsGI2fKGH3oHlRKvsdIBCPsYVqk9V7p8XgWnvaAwOam2NJIIkQc+0o/g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="352551124"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="352551124"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 15:22:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="707734312"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="707734312"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2023 15:22:51 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 15:22:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 15:22:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 15:22:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZSxmKiK5Uv22XH4CikQBACYT2UjKAyVdLMfTqxTBgou+tH+x/jmHCYwtJcBB2xHy5hwQq65okLQOVluhOTgYnbUisTQXzQumUrK8SoXfMiunOTXXyv+ASlmw74yDujsYFaEOlf1k1FDP0IF5M3XyEhyjVnf2gKsXdSvGOYcgLIfyGGy330u4yK0HXqfywUVAQcY7VZqa/EGwOEAud15D5Og8zb1u4Gomw8smT0lfha+6JOlQzppQDXcSuUOcOWjDWBSePAyP8w5Wk+PUWuBzGx0RXWYyUPdDLJhcssWCgF6rRFdYeY7JPf1ksCopfsS3Rq955GatTydeQ4ByzldpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9MZtVSMFJzi0cjXx3brURpgiZGoLZCHX7wT7pk5ynM=;
 b=nv3qSY9zV0VFEIIyvVYONwMA4FCPo8b7frpYDOVnU9K0w1tWMlVO2aFG+yirFzJ3DDU5dyff8vFIVS7pwS4s4FS+rphi0lH5jw0EGFiLdMkRo4Wf8UioOmrxlgdNzxq8wY7CbLWF319SgtwoLCZta9FdcRkZEL/S5Ki8annkIXiFaC/cID2KzvcJwy91eebxyga9uNNlFoCOnZ9e+rC2qhxfLB9s62nEDIq6j6hVdxkou1ddYCIdVB22aMhg65GNmqTPUQshVPhT1ayEdDEP6nvsUOUba+V59jLzWfBt05i4EDw109KQpA2c246FuibSEZSrHYAmlphEj+sFdrAWkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA1PR11MB8374.namprd11.prod.outlook.com (2603:10b6:806:385::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 22:22:49 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 22:22:49 +0000
Message-ID: <82a3de3f-acef-c8d9-000c-8a54c2276b77@intel.com>
Date: Wed, 24 May 2023 15:22:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] igb: Fix igb_down hung on surprise removal
To: Grant Grundler <grundler@chromium.org>, "Loktionov, Aleksandr"
	<aleksandr.loktionov@intel.com>
CC: Pavan Chebbi <pavan.chebbi@broadcom.com>, "Neftin, Sasha"
	<sasha.neftin@intel.com>, "Ruinskiy, Dima" <dima.ruinskiy@intel.com>, "Ying
 Hsu" <yinghsu@chromium.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, Paolo Abeni
	<pabeni@redhat.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
 <CALs4sv2+Uu=Bry=B3FYzWdNrHjGWDvPCDhTFcNERVpWTjpmEyA@mail.gmail.com>
 <CANEJEGuzoBa_yYHRCa0KygUe=AOhUkSg4u6gWx+QNCuGtKod2Q@mail.gmail.com>
 <52cfebaf-79f6-c318-c14b-3716555d0e8f@intel.com>
 <SJ0PR11MB5866456B9007E3DC55FD8728E5419@SJ0PR11MB5866.namprd11.prod.outlook.com>
 <CANEJEGsOU3KkG5rQ5ph3EQOiBvPXmhUk7aPvM3nj5V5KudP=ZA@mail.gmail.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CANEJEGsOU3KkG5rQ5ph3EQOiBvPXmhUk7aPvM3nj5V5KudP=ZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::19) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA1PR11MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d1dace-7573-4c16-4b28-08db5ca5681b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DGjL1CTMrdRJpnQnuGRNjHg1iPOoILE/pIQ0HEhDvBFDIuNkaMchzKgrYP5TTZDop2iT9ocnYQsoDi43VcmsiOx7bmVFt/0HBjFRxhYqUDUsOUdqBvPOtolDlQy2xhhvVENSZT1GfEcudL+kwkSa/3nZSGfQV3YWaWnpPhr1zhTXIZyjX2PiA820/77Hzw8AjNe//MNMesZgWTXYfQq6qdc90Wyt0uQD/RJJEJo1AaB0ub7u8ACHhvWooYUqGson9VXgp3w7/Rn1qs1ZVN/ze2gkzZEf4h38RVcJaX+pusQOnbg/KIXL1ONqCErMOQjh14IG80L80+zDPCORvFys8ZH2Q292p+M9PwqpAslUf9a4H/E++/lhzd6z1pmp+ahvLEgi7DEzK5x6l6uOrnt+n2l4VA4aw88QmgM/hZwTVXtpDHSrbBWT9IGXTICt9KlG7pp5aLMDxG4uEK1NZuUHocA3bCQt/qjtma0kvtGc6oO13JdL6VieZgS/PM/6uDlrrm6e23E2b2ZTjihbKM928Ayr5mGIo8vl4m0fA/dOiy+VJUgd9VzDkdxyLyW4AQ8jxDwyxA/WgtKbl2jlZ/plZXUvWSYKTjfQrNonM/pKrEd8f6q+zOqDrVQ1WLVlR1uPWyDz2dv4XkiFjCoKEbg5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199021)(478600001)(6636002)(31686004)(110136005)(54906003)(53546011)(6512007)(6506007)(26005)(6666004)(4326008)(316002)(41300700001)(6486002)(66476007)(66946007)(66556008)(8676002)(8936002)(5660300002)(31696002)(7416002)(36756003)(2616005)(38100700002)(82960400001)(186003)(2906002)(4744005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzlNb2doTEpXSGNGTHQ0YzNaMGZvcm9WeTdZMXhBRThidTBEU01yTW5mVmpJ?=
 =?utf-8?B?RHdjOENPWTZRVnZBSkFtcXpPcjVFaU5FZzVoWXl1MDI5YWlhbUlpbnJPSDR6?=
 =?utf-8?B?eDFQVmJKY1NXbVlXQlBYZ0pIMzJHVy96S3FLVzRobmtEVUYreXJRMGtFRDZ0?=
 =?utf-8?B?azRDOWpUek52dXU3dHJvV1BpdUNXUmJKenAxM0UvTFNTWHQyMWhYUThBR0py?=
 =?utf-8?B?MFJVc0NmTjYwbW93enRPVjgzTTZsY2FpMGtCaFBuelpOc3YzTEE1SU9WS1Nr?=
 =?utf-8?B?QWtwNmNJemRNaUFmaW5Ta29hRmd4OFhEclJyTEp2Y29ZQ20xbHlrbGJYK1hq?=
 =?utf-8?B?VVRySTRnYUdUVkY0L1J1bHFmU0RjSCtJclQ4M2kzdFNTdnhWQWJXeVdEbXFJ?=
 =?utf-8?B?SHVSQ2tTRDBza2xqSWJFTXgyMmhtQzZOTHpiL3djTUdIZjd1eVJuZFBZTWVZ?=
 =?utf-8?B?UjN6aW1ib3pIbTlUYUR0SHAyOEpoYy93OUw0MGZkdi9lQjIxVjdBZlFkNHdQ?=
 =?utf-8?B?Q0RxbXlOWUcvVTBhV2ozSldEK3ZpaHNCTEU3WVhzNmNNNEVKemVqYVU5MXl0?=
 =?utf-8?B?N3JTT1p0SWZuQ2ZpWGFaV0dCcG53V0VLYkZwWGE5VGlISEIrSVdMbFR3MEo4?=
 =?utf-8?B?K2RUbFhvOEw4VWIyWGRaZGZZSmR2NnNiZTNZelVLVUs3WnA4eThDbVR2YVAv?=
 =?utf-8?B?SElVbVd3Y1VLSzFyMytaVDlOaXlmbzhBazFmQ1k1VzdlcWdmZmFiMFoyUGQ0?=
 =?utf-8?B?c0h1VndTYndWcUFFSzlPR2hJdzVPQUdMR0h2STlIQU9hSnNrQUxzWVFDaEFB?=
 =?utf-8?B?TlVUSW8rUndJY0RxQWZDWXBuT0FrcjErSVU0alNpZElNWGxlOHhvL1dHMkIx?=
 =?utf-8?B?NjEzMFUrZm14dXBzYWRNTkFiSmYvS21QYjI1RERKR2R1ZEZpZnBMMmtuVGtE?=
 =?utf-8?B?TnFMZVl4VzNheHdQSHNNSGRsRGRCa3NpeG9RQlR0YTA3ZlhHWUxKUEZBTXRx?=
 =?utf-8?B?ZXZtNHZ6N2EwZEJ6cTFtcERQSzI0dmEzNlBWd1BZdlNCZlpGTTgyWmtFZmpw?=
 =?utf-8?B?amVTTWY2S0MzbzVEUWthV2Vjd0V5eEd2NjA4VUVzd0kyVjh1T25aRDRrNjlk?=
 =?utf-8?B?aDFwVGdwVDB0WCt6dERYNEMrR0Z4emRzaGRHQjFPcmZuMTZPenZ6Q3E5eHZv?=
 =?utf-8?B?eW9aOWJrejdWWnE1d05xL2d0T0g0REJJMDdTa3BPZVFBTnU2NmJxbTVkY0Nr?=
 =?utf-8?B?ZVdlSmhWWVN3ZE90VW8rU1NsNVhZR2NxL2REY3NuUWtJQXptMzBjTCtRNS9E?=
 =?utf-8?B?eDZxdVB2dFpGUnJYZ1RpSjV5YWxiMTlOWWhYZ1VWNHlIQndiMUIzZnBrTWtW?=
 =?utf-8?B?MElseUlkQ2tQQXF3QXNOeVIzaWhsb3gwU1J1RW44TTRIV0F6Tzk0VUkvUFhu?=
 =?utf-8?B?cFFJT2lWVWsyaVk4UGlJblhCYjdlVXQ0SHo4bDN1Ni8yOHdNaVBJNEtjTldJ?=
 =?utf-8?B?bWM3aHRXUFBUOU9vK1RaWDVXVHNDMWpkODRwWlhocHZtU2xOalJ3WndScGxr?=
 =?utf-8?B?blJZNFhHcVBINGN6a09IcWxyckRVNXJRRXNQazB2T1BCZ3d0azdrOStCYkFn?=
 =?utf-8?B?NHNGbzhHWVNCU2NqcjNqWnpjNFBobTFMVmpIZE8wWm5VMGZDbW1HN2h2di8x?=
 =?utf-8?B?NHhYV0Ztd1ZOeVkvT1lYZDh2QUFuUG1HaE5JNXZNNnlNb0NaOFc3K0EvR1FD?=
 =?utf-8?B?emNGNTk4MGFVVldYUzR3clJ5TkZ1L0V0N3lVS0w5SXR1b3RXNEttZXZrcTRv?=
 =?utf-8?B?Y0RQR1N6QmkrS3grWi9WMUJQa280UjNRUFF1U2JaakI0bk0xeWtjTGJQelN1?=
 =?utf-8?B?UlA1MVMyc044NUtUZmV0dUJOQU9vRmZUQ0ZPWHBDS0ljcVk0TmZnaVQ0YUdX?=
 =?utf-8?B?c3I4eGJhTytSRUtUY0VJcEpkQWh6U0lqV0t0cDRtSDJIaWpVZUZtTHNBVVUv?=
 =?utf-8?B?NjM4RDBVeUZmK2xGKytCOEUzQnk2SDhmU1hZS0JhVFEzbXpYMzVuMzhXUHhM?=
 =?utf-8?B?ZktMd1BmVG9iZzk1dmpsVVVsRmF3dElQRFlPT3Jkd0YvQnhwT0UrV3lxV0oz?=
 =?utf-8?B?WldjNEpTRVpybGR3cnZJNlMrRUZ6R0x1MWJPbHRDOVRzYW5yOUJJOVFtbTJJ?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d1dace-7573-4c16-4b28-08db5ca5681b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 22:22:49.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBNu8/sl/qL9wnFaIbyCDve4Lnm0LIYYG3YMvT6XURYIqMzJrRkfVQoGpBRGmvnf0KZlphRfd2yDCSSsmEk2ygPsuIxpAIs9rfOb2KmyIHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Grant,

On 5/24/2023 2:01 PM, Grant Grundler wrote:
> On Wed, May 24, 2023 at 5:34 AM Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com> wrote:
>>
>> Good day Tony
>>
>> We reviewed the patch and have nothing against.
> 
> Thank you for reviewing!
> 
> Can I take this as the equivalent of "Signed-off-by: Loktionov,
> Aleksandr <aleksandr.loktionov@intel.com>"?

Unless a tag is explicitly given, I don't believe one can be inferred.

> Or since Tony is listed in MAINTAINERS for drivers/net/ethernet/intel,
> is he supposed to provide that?

Assuming there's no comments/issues brought up, I'll apply it to the 
respective Intel Wired LAN tree for our validation to have a pass at it. 
Upon successful completion, I'll send the patch on to netdev for them to 
pull. Hope that helps.

Thanks,
Tony

