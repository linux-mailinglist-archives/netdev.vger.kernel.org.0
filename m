Return-Path: <netdev+bounces-7431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE737203E9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8315A281945
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19441990C;
	Fri,  2 Jun 2023 14:00:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69F419523
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:00:06 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728F613E;
	Fri,  2 Jun 2023 07:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685714404; x=1717250404;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UljNFM7q/+tAFOmri6Z1er4uwJAW4uM8wmAhDUmAI9Q=;
  b=W8W3II/H1Ixm9xxZdhARR6Dx67pYFAeTW4XZS0KDYtKFgYQk8LlCriAu
   kM4Snp+AM39EilG8FyDyAB3XtypjAE0t6U8jz8VuKusxJO7+qxdjGGFNG
   JS9M12QFiAOko8Aukui/E0Ypbh/xaFGl8HcOzovkD7EFOZ9UT5jeLofT6
   qVqwVEXm7PK+WPttLFrZQAPlEDF/kSRtO5rewtG16p8m2FhGPNThj+5Oi
   j5xaK1qZ6V025dd0htUOc5u9tYPBfbO+0EpXiSvOWwHxI0ITR8c4EegYx
   h1Y8IvCvU0J+dwfD7AVNey3Bhvd3Mx2biGUn23B4BCiYsneBgzT/Jh/r6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="419404598"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="419404598"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 07:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="797608920"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="797608920"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jun 2023 07:00:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 07:00:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 07:00:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 06:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqVAG/DJxkzuT3kMhODzpGqNGa2JDCQG2Ge+PRnXxe/LRqQTVlCx4nWChlhSF8E5KbVF+8CgZNxC/vZdfq05vGkCcVLmO00erYBjUR2pKSRo+3Q7H816Qk+HlHv663NyOzox9xKk7AuXG+uwmMFHbp/tSj1XOIIgd3HsS+g4muotbhLr+P9BHAuzjU490un7g6h9qS+1/AwM01Ntbx6kr6KTdG/PrxOHjaG35pSN+uA/oA7VmxyHUByFPavKWFHKyvNAuNPM8QSBqYBjGTTvWjekR/3uKyjve9AJw2GvkIj9iEg3cBggKcSpf6laWrUiM54zz9gFZqNvRjPgKk+LAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE3dCj1Wf5hzf84GJQ4X6StcMYH5Z5jwnF81PsVjl/4=;
 b=htFEhUwHuF9DoOEbAFy7uRxTA3S17N5e85tCBeAAZl6xI1gexaMqZjSCNDemQWGJs+0HbdGtrnJd0Dh2FZgDAFF4HDEfHlhlGkl4Tohi/6T8l7i11wLFEVXyX8W//ifaXA+LQJIgPjkh9Ibq3GeCxy7eC1YoMpd00lQp70fx2smSmNpbI8xyrWqTL/bkTJ9dhojt+OL9MvJE+pSG8qMj13mvUjYNE6AhCBHp7IAdhH/WkLzAGPXlvPgkyEb6QJPAnzztj0EYnuo5VdYrP5e6EhfjOa9jmvkWLA5RVs1noPhe0mLNDFh1i50ZgbwFt5tEpXs3Ctj0nPTvM4GTI6FvpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 13:59:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 13:59:58 +0000
Message-ID: <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com>
Date: Fri, 2 Jun 2023 15:58:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 03/12] iavf: optimize Rx
 buffer allocation a bunch
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: Paul Menzel <pmenzel@molgen.mpg.de>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Larysa Zaremba <larysa.zaremba@intel.com>,
	<netdev@vger.kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Dumazet
	<edumazet@google.com>, Michal Kubiak <michal.kubiak@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, "Magnus
 Karlsson" <magnus.karlsson@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com>
 <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <cb7d3479-63a5-31b4-355d-b12a7e1b2878@intel.com>
 <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5295:EE_
X-MS-Office365-Filtering-Correlation-Id: d38403fb-7b27-49e5-2d15-08db6371a606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/Ttw9Cczq5eG9Gfy5w56tPeBIoQbJhXXhl/KqTJNfF92DTjgCGLjSCgaKfwuhUelXpqL/0g1mYYT55EbOEgE9MIdWLEGer3zmxlcKx1ugd420oYBIw0JDe8/RGDLMzLizEjWgEdp0JvUu8RjMc5iHcww2O0a8Y/JG2lMQny2S/jN3kwTnNvuM89fuUHRbsz78C/vw2xjamawDHcC8lpt4oJMWdu4Rufq/YlD9neFGL9CvmTdyayr52BRuhSmEF94bQSpg5r+zfXByvb5SzlJH8q/1pNZl7Z1I99uYmrtocB218xSH35rrYapjxBDciYFXqaTTtyCOhxucGap32BvDHDMzCWU/V4FmM+9S2KQcI2mfRYhOjKlA8eq7WPFeS5pr53zx7PfGjLeWRhQ61X1yjA4F7q5Ln6HaNGfyH2LmqlORp4ukwt+CehSBv7DvPEov5FRNk0VRyC6ZL+ea7uS/1aXP9kczTzyScAwjuPMPPkoFbUZ7ZQrDEQpjs4JBlNW8Y37qbkULdvuodD8jV9V6ZJ7ojVQa+yhCC7wQJFrpWhXLtTv+EMR99HIsoWRm+nWkGZ6cG4R3VNwkix1lmFBVYMx+E6rFTWXzVInFC04Ln4xXwclCN8YIQrH0+bJbDBF9AqI7OfrWLXALckeBOIiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(107886003)(7416002)(54906003)(478600001)(41300700001)(316002)(6666004)(5660300002)(4326008)(66476007)(31686004)(6916009)(66946007)(66556008)(45080400002)(26005)(6506007)(6512007)(66899021)(53546011)(6486002)(8936002)(8676002)(186003)(2906002)(2616005)(83380400001)(38100700002)(82960400001)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1Z3a3lCbVRCZWMwd1hwdllHK2pMSHJpRXNuOXlRL0RpblFtc0VBaEVNVVZa?=
 =?utf-8?B?dC9QU05uMTE4SU1NdTZlWVhRM2RQeWg1bnFaVC9DYXNBTFFTZVZtWDIvd0Fy?=
 =?utf-8?B?ZTdNdW16cjV5WTJoWTZiYlQ5QnU2UEVocnV3eDhqekhQRHM4bHJYczhFaStL?=
 =?utf-8?B?Sm9kQkRRaHJodjFKY2ttTjZub1NjdG1lYk1QYWRwN3dhZ2JObk5UQmxkVHVr?=
 =?utf-8?B?dEJvNGFmVGZHZFhmVGx0N2N2VHJOdjROaGQySzZ1TmwzNURibno4UFFLYmJt?=
 =?utf-8?B?YlRuT2dXanNiaXlLR21USkwzeUJpNnUxSnFsMTBwd0cwNVlDRDBZb1cvbWZ4?=
 =?utf-8?B?aFZNaXpmUzgwM3JqWFUvS0tWdzlpcmJsMFF1QVdqQ3lqak84VDFTVDBDWU9I?=
 =?utf-8?B?RG8wMENjVURkSnpFMUZnTXpPdTNsNHBteGFsNGV5Y28ybXNTcmVWSGJFRzE1?=
 =?utf-8?B?UTNsWEVJZ05zUTBBVmpXZWFXNEFpcmdFUEpadVl0bXFVd2ZnTnozb2RkSllx?=
 =?utf-8?B?akR2M0owYW4rU0JwM1RGeWdmMFR4amdhVUVBWTBFR3NUTi9ydTZULytCRnBz?=
 =?utf-8?B?NC9COENQanRJU2FkeFlIUkk2LzgzMXFGRHpsd05VMzIrcGNRejNRTXhtdnB1?=
 =?utf-8?B?bW9ma3hzMm9mZ3puck8vVTFNV2JnNEcyQ1hqd3gzUzU5WVJwZ0grVjBDQm9K?=
 =?utf-8?B?akZhS0VPeGlLYnd6L3AyMitiNVJCY0FlaWdCaDZPdVBKZ0UwelBmRmFBMXVr?=
 =?utf-8?B?aDZ3aGlpQXprSGQ5anhuSnBBdzV5bG1pSGNWd3pTTmQrZXZCNWdVNWRNcHd3?=
 =?utf-8?B?MmtQWm1rUW9sQitsMGkwWEpHNmpkMHpLOEhGaS9OOElYV0FyNVRDeDRIbEUw?=
 =?utf-8?B?WE5jOGVyQjUvWkt5ZFhSbHAybXJta2hQTGpFTXptVCtaVlg1T0pYdno5MURm?=
 =?utf-8?B?VzBYQldydjZoYlFOc2JUc1BwV3BIaFRteUNBejdHVSs5cFltbGh4bHJpVW1t?=
 =?utf-8?B?OHZsNDVzWGYvSFZud0ZLdVduRVh0UEo1OXU1ZDRZcWNlcVRFMU42R2d0K21F?=
 =?utf-8?B?TmpodUJHcHVHN3F1REx1dWNORDd0Wm1FNk1vZTNlTk1DNWNxM1R4ZXhYQ2h2?=
 =?utf-8?B?ekNic09scjZORGJ3SHNNMFdJMHJDZnk2V3FjQkFRa21TNjU1TndRaVo0Z1o5?=
 =?utf-8?B?WFVseHpHVi8xMlhoYWFjcXVINVNtbEhUekg2NG9oYno0WGJETmFkdTRnRmE2?=
 =?utf-8?B?elZZaHJpRzBsN0JqajZxbGc2alB6U1dSZ1NNYnRCTmMwNFlXZytNQ2JCUk1I?=
 =?utf-8?B?eEVzMklmV2hON2NkR3VyUjZXMzUwT3RQcGVSRG1WSk15cm5PdFVTcUl0U3U4?=
 =?utf-8?B?dmVqVW9uVXUwanA1cjVscVdtS3lZN3JpSkxqRzEyRldEQ21jeVNsbnM1VVJw?=
 =?utf-8?B?eTlxVmZ1amhrTTg2emZpQkJDbXpqTjQzaHhrRFhLYStLMjdYZG80Rm90TmIw?=
 =?utf-8?B?SkM4V3FYQ2dFemhZS3JpdjhWUkg4YlRvQ2JOYk1PVkNzWE82NXVOeHFkN1No?=
 =?utf-8?B?Z2lqV0hPYml0Lzg5SEs3MkNyWnY4MEFxdE5zVVVpbU5ObUhVZFRYVTBLQ05J?=
 =?utf-8?B?SkFpOGd1WEdlUm1mZWZRUmJ5ZWJGcCtmU2pnOWJ2WDFpMVNrNUI5Q0Jqd0E0?=
 =?utf-8?B?ZlNhRm1NZVd0NCtqdHhrUGFsNWh2SUE3a2hIbWhaRDNQVTZaTmtBRE1Pd3Nu?=
 =?utf-8?B?a2VydFQ4bTUzZ2ZKRklSTTdmOGFlY2VXeU9yVndNOFNHc1ltY2xiZ3BscHZ3?=
 =?utf-8?B?NGlqOXdPNFhPNXZSNVIxd3pkNmlZMTVIeC85c3U5RWo1NVRYUkgvV0ptVnhT?=
 =?utf-8?B?ZVJOU240b2xwRTZSS0pJWmhRQlpMQ3BkUmZGdE5yWTdvcUtHbVRKbHpXcU5U?=
 =?utf-8?B?Vkcybjd4Zjh0U0svRVh4OUY0b3ZrQ0dLRUtzdTlNNGhNeVAxb3paTVlmekhj?=
 =?utf-8?B?cHhoREVJSkZrcThhanpxSTNjN3QwMHFwVG5wMWZmQlUyN3FyL1F5cUhXR1FF?=
 =?utf-8?B?M1k1OWlyMkF1Y01ydU5JcWFDb1ArTzBlTi9qRURhaGNHMUNQSTJHaUN6Q1F1?=
 =?utf-8?B?RFVmR3NaRU9aTm1RQVdZNUlrSnBQMmlSV1Q0ektMbmRWbENoREp1Q0xTRVNK?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d38403fb-7b27-49e5-2d15-08db6371a606
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 13:59:57.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXtwJB7gsy7Puzeor63NC2YoYKnvE7ryKYK4PRR0/oBKOiebtcWlVKwP28gR+cLAMiWxhE1M301n+/kfzDqtZHMRE0umc6DvFzMiK/Zw6ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5295
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Wed, 31 May 2023 10:22:18 -0700

> On Wed, May 31, 2023 at 8:14 AM Alexander Lobakin
> <aleksander.lobakin@intel.com> wrote:

[...]

>> But not all of these variables are read-only. E.g. NTC is often
>> modified. Page size was calculated per descriptor, but could be once a
>> poll cycle starts, and so on.
> 
> Yeah, the ntc should be carried in the stack. The only reason for
> using the ring variable was because in the case of ixgbe we had to do
> some tricks with it to deal with RSC as we were either accessing ntc
> or the buffer pointed to by the descriptor. I think most of that code
> has been removed for i40e though.

IAVF was forked off ixgbe as per Jesse's statement :D

[...]

>>> Any specific reason for this? Just wondering if this is meant to
>>> address some sort of memory pressure issue since it basically just
>>> means the allocation can go out and try to free other memory.
>>
>> Yes, I'm no MM expert, but I've seen plenty of times messages from the
>> MM folks that ATOMIC shouldn't be used in non-atomic contexts. Atomic
>> allocation is able to grab memory from some sort of critical reservs and
>> all that, and the less we touch them, the better. Outside of atomic
>> contexts they should not be touched.
> 
> For our purposes though the Rx path is more-or-less always in
> interrupt context. That is why it had defaulted to just always using
> GFP_ATOMIC. For your purposes you could probably leave it that way
> since you are going to be pulling out most of this code anyway.

That's for Rx path, but don't forget that the initial allocation on ifup
is done in the process context. That's what the maintainers and
reviewers usually warn about: to not allocate with %GFP_ATOMIC on ifups.

[...]

>> The point of budget is to limit the amount of time drivers can spend on
>> cleaning their rings. Making skb the unit makes the unit very logical
>> and flexible, but I'd say it should always be solid. Imagine you get a
>> frame which got spanned across 5 buffers. You spend x5 time (roughly) to
>> build an skb and pass it up the stack vs when you get a linear frame in
>> one buffer, but according to your logics both of these cases count as 1
>> unit, while the amount of time spent differs significantly. I can't say
>> that's fair enough.
> 
> I would say it is. Like I said most of the overhead is the stack, not
> the driver. So if we are cleaning 5 descriptors but only processing
> one skb then I would say it is only one unit in terms of budget. This
> is one of the reasons why we don't charge Tx to the NAPI budget. Tx
> clean up is extremely lightweight as it is only freeing memory, and in
> cases of Tx and Rx being mixed can essentially be folded in as Tx
> buffers could be reused for Rx.
> 
> If we are wanting to increase the work being done per poll it would
> make more sense to stick to interrupts and force it to backlog more
> packets per interrupt so that it is processing 64 skbs per call.

Oh, I feel like I'm starting to agree :D OK, then the following doesn't
really get out of my head: why do we store skb pointer on the ring then,
if we count 1 skb as 1 unit, so that we won't leave the loop until the
EOP? Only to handle allocation failures? But skb is already allocated at
this point... <confused>

[...]

>>> What is the test you saw the 2% performance improvement in? Is it
>>> something XDP related or a full stack test?
>>
>> Not XDP, it's not present in this driver at this point :D
>> Stack test, but without usercopy overhead. Trafgen bombs the NIC, the
>> driver builds skbs and passes it up the stack, the stack does GRO etc,
>> and then the frames get dropped on IP input because there's no socket.
> 
> So one thing you might want to look at would be a full stack test w/
> something such as netperf versus optimizing for a drop only test.
> Otherwise that can lead to optimizations that will actually hurt
> driver performance in the long run.

I was doing some netperf (or that Microsoft's tool, don't remember the
name) tests, but the problem is that usercopy is such a bottleneck, so
that you don't notice any optimizations or regressions most of time.
Also, userspace tools usually just pass huge payload chunks and then the
drivers GSO them into MTU-sized frames, so you always get line rate and
that's it. Short frames or interleave/imix (randomly-mix-sized) are the
most stressful from my experience and are able to show actual outcome.

> 
>>>
>>>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>>>
>>> Also one thing I am not a huge fan of is a patch that is really a
>>> patchset onto itself. With all 6 items called out here I would have
>>> preferred to see this as 6 patches as it would have been easier to
>>> review.
>>
>> Agree BTW, I'm not a fan of this patch either. I wasn't sure what to do
>> with it, as splitting it into 6 explodes the series into a monster, but
>> proceeding without it increases diffstat and complicates things later
>> on. I'll try the latter, but will see. 17 patches is not the End of Days
>> after all.
> 
> One thing you may want to consider to condense some of these patches
> would be to look at possibly combining patches 4 and 5 which disable
> recycling and use a full 4K page. It seems like of those patches one
> ends up redoing the other since so many of the dma_sync calls are
> updated in both.

Or maybe I'll move this one into the subsequent series, since it's only
pt. 1 of Rx optimizations. There's also the second commit, but it's
probably as messy as this one and these two could be just converted into
a series.

[...]

>>> Just a nit. You might want to break this up into two statements like I
>>> had before. I know some people within Intel weren't a huge fan of when
>>> I used to do that kind of thing all the time in loops where I would do
>>> the decrement and test in one line.. :)
>>
>> Should I please them or do it as I want to? :D I realize from the
>> compiler's PoV it's most likely the same, but dunno, why not.
> 
> If nobody internally is bugging you about it then I am fine with it. I
> just know back during my era people would complain about that from a
> maintainability perspective. I guess I got trained to catch those kind
> of things as a result.

Haha understand. I usually say: "please some good arguments or I didn't
hear this", maybe that's why nobody complained on `--var` yet :D

[...]

>> Yes, I'm optimizing all this out later in the series. I was surprised
>> just as much as you when I saw skb getting passed to do nothing ._.
> 
> The funny part for me is that it is like reviewing code written via a
> game of telephone. I recognize the code but have to think about it
> since there are all the bits of changes and such from the original
> ixgbe.

Lots of things are still recognizable even in IDPF. That's how this
series was born... :D

> 
>> [...]
>>
>> Thanks for the detailed reviews, stuff that Intel often lacks :s :D
> 
> No problem, it was the least I could do since I am responsible for so
> much of this code in the earlier drivers anyway. If nothing else I
> figured I could provide a bit of history on why some of this was the
> way it was.
These history bits are nice and interesting to read actually! And also
useful since they give some context and understanding of what is
obsolete and can be removed/changed.

Thanks,
Olek

