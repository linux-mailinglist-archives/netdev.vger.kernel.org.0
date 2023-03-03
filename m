Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40A66A9669
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjCCLeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCCLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:34:09 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5FE1BD6;
        Fri,  3 Mar 2023 03:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677843221; x=1709379221;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L1sKqyMMNqAx5N2dPLsrKTJcvRO91pL02/D3biwtrVE=;
  b=jA+3txYRsV/O2d3Qy/ubNnB8x7T43jHmyDl/Ouz9HgIGNfzOlnJX8NSS
   UQJ+/h/XaicDakL2nQOz8oSMGm7f9qh/fGlM4Fz2OQUqv7ZHt+Cp0G+8L
   fky18rCBU3gFJE7tDX/zL7vis2lMGB4h7hGVmcTMJteX19ZqD+RW7Gk83
   0w3SSvSMvfUW3XTUM2vM5r4oI8Gg3wqNdZYYe4o7F9HeZ7NWdNBcUIaMo
   OUhUUn2riafW9i41OW7EZ3NaiEOkN412JWmznKB3j7hsrJKKIHC49fa7s
   8rEM86FMkI+zuLthcCWFI0nV/CV+BNrnUAhxjxwcRxowZx1jHh4SBPQbm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="333746256"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="333746256"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 03:32:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="785238220"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="785238220"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2023 03:32:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 03:32:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 03:32:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 03:32:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 03:32:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYiFQhUKz6Nkw0jHVGL+z59GXbBX49x/EC0HFN66V4kPVcWg1YKKPtPzBtRyAXEqmwoQJIdMvGHTfKH2N0fXkJkWfek2N3jNGDljTBGUAdodRMG1wI9Vy4a2NNEkYkFJUQVbD39R6cNIclyA9zG+BXLFw8LFp2KPfxBSOAqMS8RvDywrgjnRAeJtf3VaWPkBPnWNKV90862alPAYLaqgsMAvawQXukDWOnbMyMgfQ0zH2i//Aly8f1fWu+E6r6/niU7vTAAnrbYBqqo9y7cp4weltUhDh5MNkeaOo3k0ZqjSW9e5pbWyUA1YanrMsilJMohpQsPw8xHpbT/zIBr3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rs0q9dy4o7jzQo77tEJw9c4geweoaklswfnBxclJCo=;
 b=E48wIZjXBfNyNSTnrXK7AYPrKg2kpBmw5tfe0VL6Rhp73zfj5cWMIcPW57XJSmC0hzHM9PXNUr3alqzxlO7e3zM2C21c3HcStfl6twcoR5XQMulOY8g5XxV/d20k8sGnklqo8+g+9rZB9CH8KWuhTSSg19MvDiRnnNWq8nhNwbslyCtYSjVjdOhAjNOgnI9aAd8sEe4iRMh6NU6IJ8AmTqKjC7kK5QXJzodSM48eRxB4IkQLjPP6MZfU0F53CsQaUlQsmWdLsTouEyS0G+JA6RoWv45aJbcAzdVDZG670D1SSMg/gCsX/ClL1QtUQH0pY6CG/NRBXjN3XPyIkVxo5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB6431.namprd11.prod.outlook.com (2603:10b6:8:b8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.22; Fri, 3 Mar 2023 11:32:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 11:32:46 +0000
Message-ID: <2995ad71-5058-2cf9-78ff-0d32ea620514@intel.com>
Date:   Fri, 3 Mar 2023 12:31:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v1 0/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>, <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <22ca47ca-325f-f4df-af5d-344be6b372d8@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <22ca47ca-325f-f4df-af5d-344be6b372d8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::27)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d29da4-a56e-4db5-a91e-08db1bdb0261
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qRU1KpAET9cyUwpdYfN5Pcclj1voaRv4W8qWNjCpZxvAQfKmhuXv4sk85LHRS6eb7RJbjLzHCwYAv15+wqPOfHYkHkD4lOi3eOWbXM1a8WoZuk7jMZOEd/9rstGgA/cG60XOR/DkNBYDIQWPSDsy4Kk2W6I4dvUHgXNc2NmAGk5ymvcDrhCtIY4TVfEBLMRy4V41Ddp0Y6fb6zoUe8O9930UIyDu1sao8WP0nC/DQdm0pWNV2hokRjPrm2jmopf3qK4GPX7pqGUb9TyvsCEWL+H58ZOHaqXOUfOdsH/acUc/+h78oQajE4q3Gwspugv7rLrJ6CZ7Z6Zc52damFJXsGyuFJ5NmR6IQzJe9xZlYiHNp+fuLKVEC8XzsvNFERVdzsrymuGIVZFJ0ZNt6jK16VC5EwMoZ5i7fbUTnIcAccVZG2NRbxm4M7645PZYDw8kEITb1nLslOHrh5Jfv4ndZ3Bq+I1c5YL0X4kXJWcsI2c2UZsvJE8lw9wgR83movGepkj6Aln2RagzyuCM34wWNxckOwSJnFzHy4GoJK+I+nXhxZFF2cnsLKhV1lz5VslYurKVYVmvE//tfDYKWq27JLWsGmHK0+HsnRHBgB5Etf71VxuINNpQx025Ootrb9N0mfHudM4qCKQAwxhfs+woD+OFNz9Skkrmw+8Cnd88a/DIB1mMVI4F70u2GqBfcAIddCvIQkxFoH3YnmBoTenzVVFJWpbx0QV1OkFuub2mvsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(5660300002)(7416002)(8936002)(478600001)(38100700002)(54906003)(2906002)(4326008)(8676002)(6916009)(66556008)(66476007)(66946007)(36756003)(316002)(41300700001)(31696002)(186003)(83380400001)(966005)(6486002)(86362001)(31686004)(82960400001)(26005)(6512007)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlpDemdmKzMwU2ZqaUFVOTRnakE0STArY1dhWXJyelVUUFRqcXF6RTJmTWFI?=
 =?utf-8?B?RURSSy9TNmxuTTU4d3BRUVRTSHI2Wlh2ZnNSb04rOHBQZi9MOEIxZU4vOTNN?=
 =?utf-8?B?czVyUmJwZGN0aUErcEdXaEFham1wdStISTRKd2hEaHBQUi9PMGtSVG9HZXEx?=
 =?utf-8?B?SnlIUjVzTnMyVmdaSWJIVFN0blNPYkt2eGtjMU5Zdks0YjdCTDI0SWZyVW5X?=
 =?utf-8?B?OGxJMUN0NDhNTFppTWVYMGszaHdYOVBsS0FsSlRldXBtTkpBS1l6OTV4SitR?=
 =?utf-8?B?ZEt1QUFkbm44eTluMC92bFhoOU9uNkp6RDVtMzdWTFJ2Q0s2ZnNzTjBUbng5?=
 =?utf-8?B?cGRSMktkSXY3VUtqcytLTktnVVZDcWdDTllhR0UwV0ErU1NyVEFHa2VDMWJk?=
 =?utf-8?B?eWdpVHJjT1h5a1V6SXltdTJRMk9WbVhMWFdWY1NtQ2U2a3BKMGJiOWFYcWhP?=
 =?utf-8?B?UDdTUEJTeEpVTWlYUkZzUmRZdWpOSGZHTW5YNmxYVkt2NkhZelZtcU1TRElW?=
 =?utf-8?B?VHhtTTVSNzBYMGVtT2NucjhweUc1bHZyNG1rRlZjdmh0emZOWVVHd1RTNU1J?=
 =?utf-8?B?b0IvSzg0VXBwUnJoUnBCdmYvSDlEcTlzTEpwSjYwNHJwSFgyY0ZKMDdYZzVY?=
 =?utf-8?B?ZEpVZWxsaUxzWVpvQVQ0NElUVXhEbzRmQUREY01ySTlXbXBPQTZPR05VK0Ew?=
 =?utf-8?B?bzNaUzRLWTAvMnArNU9ONHBEdUNSbmlnM3FoY014dEU0dGhpZE1CRjZsRUFk?=
 =?utf-8?B?RmRzTENHQmF1WmdhczRwVUl3TG9aNUpnajdldFhUZHhvZlhKdDFseFZHVndr?=
 =?utf-8?B?OEV4VzB3ZDcwY2ltZm9PWG4rWjhlQ0pHN3RCTnN6MUtkQVZtZVZ3YWlkVm1U?=
 =?utf-8?B?RUIxUHVQb3JsQVVIM0d4bmRHdGF5aUlucUVEUmIveHhZNEkvTmJVZ3BySy9n?=
 =?utf-8?B?Q1lhT3AzWWthTU9QM2RNUXM4azV5K21sZ0ZMZks5cnVBNEsyUFlReFZVQzJn?=
 =?utf-8?B?UjYvek9LS3BpN2x1MXQrN1FDMFExMnpZUTJpVEpWZFkzVFZIek1xK3NxRkZz?=
 =?utf-8?B?dW5QdmNOU0doTVBBVVlIODRqR3Y4aE5aMjc0Z0M3U21Kd0ZzYVlCc2xvckp0?=
 =?utf-8?B?SmU2T1RFdThieDYzSFJVRWV3NUtIMzVZQ0RWZWZYMGlPUmZoZ0I0a1Q1SFhZ?=
 =?utf-8?B?RnhhTFFoY1lOdkVXWEFYMFdVUnpBV3dXYVhKdE84M3ZTZDVmYWNZOTZmZ2ZY?=
 =?utf-8?B?Mk9QY0lROXowWGJzdW5vanUvRjhEdUMvWVlWZnk5SjN1TVp0cUMrNmZ4UWdp?=
 =?utf-8?B?SUNCVnVTMzE0MjBoOENvMVJod0hIcXZVVFNCMzM5b0FQNkM3S1BmeDY0N050?=
 =?utf-8?B?enJnaVBJVUx0akdvQUk1KzZaajhIVm55NGsvOFZSd3JNRFB1RThza1paSUJK?=
 =?utf-8?B?T3gxRTEwNnpVUmtEeUZ3SmozVkg2bGIxVGtnaVB6OW1yb0o2bjFaa2tVaFBh?=
 =?utf-8?B?TWJuSzZ2Z0ZNei9yUlUzcWdPbFlKZldEMWhabUZnbTBpbUxuend2ZnFGcEMr?=
 =?utf-8?B?NE1yaHZ6UHMwOHJwM1g4WEMySllBRFVTQy9reUtmNjFUMHVsZlh4KzV3Qnd6?=
 =?utf-8?B?dmV0ZEJDVytyVlVWaUFTWnRuNW9EVlZnNk4rblVYejJxYmtuaW9jVkk4bTZ5?=
 =?utf-8?B?c2NZaEUzTERIcGhjcGkvUnEvckltRzFyWTh5OWJ6L1hFZzc1dzZBR2xTYkl2?=
 =?utf-8?B?T1Z6dktqT0oyYVRqWFRQRU44RGlDYWVGVFVkZGk0aCs1S0p0U21hUitwazk4?=
 =?utf-8?B?bld4aFVtRFUwa0ltbEVUTHViZzVxdEprWm9EQTZxVEg2bXNzQ05xUVNNemNl?=
 =?utf-8?B?S1F6SDdya1ZJTVdjZk5WTTBUaXV5Y1RYdnR3R1RIaURTNlN1WEgyYUdEbEpw?=
 =?utf-8?B?WGVJZVh4enNRaDhYVFc5N3hBSVJUS25WRzRGV3JKcGZBbExpYWp5SnRuWGJQ?=
 =?utf-8?B?NmNHY3h3ckIvUVpscEJmWm01QWE0cTV0UkRaOEJXRitOTlBCVFc5ZjVuSVRU?=
 =?utf-8?B?WUtFOGF6ZDRzdlJOUGhWRzM1SFZwZHhnSWFUV29McVpydUhkY3BKY05nQjZD?=
 =?utf-8?B?aWlZbVhreUFNT0FGdFBoZis5Tis0Z2pHQjY3YmZqbUFHTHVOZ2FFUThLZW9C?=
 =?utf-8?Q?UPkHKEY/0X5Gh7bYCQ4uycM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d29da4-a56e-4db5-a91e-08db1bdb0261
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:32:45.7611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQlbbiJOYUd2qiTqkdhuUsODJkwT+qb2hArwOQTZ3loBvAF9K69GX+eubjMmMcFZNamMQCRRMAGyvi5E1IVH3Sf+1J2yrcvC/dk9qvX/z3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6431
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Fri, 3 Mar 2023 11:39:06 +0100

> 
> On 01/03/2023 17.03, Alexander Lobakin wrote:
>> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
>>
>> __xdp_build_skb_from_frame() missed the moment when the networking stack
>> became able to recycle skb pages backed by a Page Pool. This was making
>                                                ^^^^^^^^^
> When talking about page_pool, can we write "page_pool" instead of
> capitalized "Page Pool", please. I looked through the git log, and here
> we all used "page_pool".

Ah okay, no prob :D Yeah, that's probably more correct. "Page Pool" is
the name of the API, while page_pool is an entity we create via
page_pool_create().

> 
>> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
>> also affected in some scenarios.
> 
> Thanks for working on closing this gap :-)
> 
>> A lot of drivers use skb_mark_for_recycle() already, it's been almost
>> two years and seems like there are no issues in using it in the generic
>> code too. {__,}xdp_release_frame() can be then removed as it losts its
>> last user.
>> Page Pool becomes then zero-alloc (or almost) in the abovementioned
>> cases, too. Other memory type models (who needs them at this point)
>> have no changes.
>>
>> Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
>> IPv6 UDP:
> 
> What NIC driver?

IAVF with XDP, the series adding XDP support will be sent in a couple
weeks, WIP can be found on my open GH[0].

> 
>>
>> Plain %XDP_PASS on baseline, Page Pool driver:
>>
>> src cpu Rx     drops  dst cpu Rx
>>    2.1 Mpps       N/A    2.1 Mpps
>>
>> cpumap redirect (w/o leaving its node) on baseline:
>>
>>    6.8 Mpps  5.0 Mpps    1.8 Mpps
>>
>> cpumap redirect with skb PP recycling:
>>
>>    7.9 Mpps  5.7 Mpps    2.2 Mpps   +22%
>>
> 
> It is of cause awesome, that cpumap SKBs are faster than normal SKB path.

That's the point of cpumap redirect, right? You separate NAPI poll / IRQ
handling from the skb networking stack traveling to a different CPU,
including page freeing (or recycling). That takes a lot of load from the
source CPU. 0.1 Mpps is not the highest difference I got, cpumap
redirect can boost up to 0.5 Mpps IIRC.

> I do wonder where the +22% number comes from?

(2.2 - 1.8) / 1.8 * 100%. I compare baseline cpumap redirect
before/after here :)

> 
>> Alexander Lobakin (2):
>>    xdp: recycle Page Pool backed skbs built from XDP frames
>>    xdp: remove unused {__,}xdp_release_frame()
>>
>>   include/net/xdp.h | 29 -----------------------------
>>   net/core/xdp.c    | 19 ++-----------------
>>   2 files changed, 2 insertions(+), 46 deletions(-)
>>
> 

There's a build failure on non-PP systems due to skb_mark_for_recycle()
being declared only when CONFIG_PAGE_POOL is set. I'll spin v2 in a bit.

[0] https://github.com/alobakin/linux/commits/iavf-xdp

Thanks,
Olek
