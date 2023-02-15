Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C8969815C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBOQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBOQwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:52:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A423B65E;
        Wed, 15 Feb 2023 08:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676479938; x=1708015938;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Eg3ZR0G6ZPW8S0h24w1khtSBMdvOg6Mvz4cRKxm8nDk=;
  b=LX2USWbt+HGEzXU/3Vk28NT1rkU/94elK+Zf8Ta02m+vspDCOV67WdGM
   TgyXhY/G7pajdyHu96HWuwK7novz0z/qy8PnUhS2F6xR3nXSxmHa98ps8
   Ti2DRphe2HSoIM/qHHq5+Cgd+r+nxwghqzIkAqFV9dAvSosLsEq9w7AZA
   iynsGQYXqjQYBDQKdBc8z5lFPw4q2uvGkjo37dEakSb30sRj0uxRvDw9T
   4XjWi7fsWvqQSufU2wKzK1sPce/eI5VkBPxFVwpqr0VOR2+aI6lNfPy4i
   lIYmntHJbl0PKPxsFwngjUQj5xyaTmrqMRcAIupT78AZEsHU+Ne+cdIYO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="329197980"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="329197980"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619526485"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="619526485"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 08:52:17 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:52:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:52:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:52:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAACv8rsdRPlqtFltQRg0dQSSWZBr5vg/+8B1wY2gJ4RJgg+Hgi44TIsbCcAk9dchCBSG8AHkkuMSz8QHOA5S/wiDs42TUF8ln21hSWoMzL0eWeBbv9J8xU75QacdOEfXQexASKsilSw7tLobGsV95AiWfMhdUKSHh7y5kTQvspigBnI9qUsWt1NTBKytzFmGFVFgOK5CDLgFfsQzPoM+mPDlpgqIKGwzasgHdYUGCFvSJhLfk/tOtOMvOs55XXyrAgGgx0VXw71QF5xEjdPHnHo6PU1G3c+JjNBg7Jc2vyUImqZEP0KsyrpVYLZ11HQvDIHtBcF+c5QGVHxCKpF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZH9LLngi6HgskB7x/B/kIhAE+PPr33NSEqmWq76uBA=;
 b=jtpeI7rwmWMBIEyE6tPPh5MOwDtIG2uSD5m/5roxROKlzzXhMpDonQA4gUDe0/PjJ3/FNCc9PULIan/ZylS7FiOb4hGPGFEs9bqbdPnE21oL0Ez16m6oIdWdlNC6klARreGI4PdJ38sQG7cXh2M1rCLrQd0h5WT1OVqdJsFkvVhNuKUZfwuk0qzo+vtdcjMJT59kGhZ0sbsS3LclzVyjw6Bk+wD/ohoOc3tQzI3KY8H8cAz8Jq+zlI5qEXoDeq1CcDJdVnkYTIgfOfy4H4dFVUSDShA7BcshQOGSYIOG3ZFOwxGpahWIUayL01ANdGExmdtPUQ/eYaHDV7r4VvjVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM6PR11MB4756.namprd11.prod.outlook.com (2603:10b6:5:2a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 16:52:15 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:52:15 +0000
Message-ID: <d42b574b-d546-1557-a61b-b183df84a991@intel.com>
Date:   Wed, 15 Feb 2023 17:50:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3] xsk: support use vaddr as ring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
 <3cfe3c9b-1c8c-363c-6dcb-343cabc2f369@intel.com>
 <1676425701.9314106-1-xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <1676425701.9314106-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM6PR11MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5ddf7c-494f-403c-9e5b-08db0f74fdcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJ5y4FHUluWcpGWdzzrvOAIboHA/8eXpNIm9A7HMVimoeY3VtWVBxiOncgkVO+DKx9gVxAhj76FFItVbMghd5SVNnPUzGTx0k1hmZqAgc2HD5Ssmm8PfgE3wVz7zUSEcF5P+HQfvDIum5oRmixWTG3ChN79aRXtAy3a/EEivqLOXHTEXq5WSpfqbm8xiHe3Fl4rTqTJ5Crt5nZYPcMwdq9UmY5w4/xQGX1kxT2lwjDPovHtjEd2kYtq0s2Vk4VqJ4MYZt3pgz+cof03V9Hi16rdu6FiheOQsFG+dOBUtYFeJpjf/vtafKjaFK/HcocyDWLn55EUgqRx0o44AsMZvcZgMm6qiCj3vF+ys5j3MwtjHcKQQOc6tbLvtnm1F/D0TxcnrWwssjvP4SJ78bvErSENw9XhLXR17ydtHD2IFKKYnRsGVQtXAq5AKT0/JWFeIeL+i6QReGwkodtycu0rfUM096ipkmjY+9T/yKgKai89Dy+rQ5opnZQBy79MyZAk2lgIUuz6f9uOtPG/HE/PPgxFqMNa81YklkT/1gz6HYfTHx73StwUI9W/r94E0xQ6Xvkqh+QWD1tuA32VjMe5I+XWg2bmCZEshD8O8K8KHLo0w3/x6gFwsnbMaU2c2vVne4DgMFkHukOO1PHCrX+C/ndAM2pJHf5FRxzsVtSPoMX1B6BBALmVMYlRAhkT8GhVqNmx4kTt/HHzf48jIDgicPFqL0NYidNd/Dc6FRKlah0k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199018)(83380400001)(82960400001)(86362001)(31696002)(38100700002)(6486002)(478600001)(6666004)(6512007)(26005)(2616005)(36756003)(6506007)(186003)(41300700001)(66476007)(6916009)(8676002)(66946007)(66556008)(2906002)(4326008)(5660300002)(8936002)(7416002)(31686004)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aCtzNlZXajhoUjBFb2h0azE1RlZtL0s3bTdnR08rSXYyVGs3OG9iK3FjQnJT?=
 =?utf-8?B?RCtkUFNJOHdWZ0xPNkJkY1dZWU81aVpHUzlnTERBQUMzcEJyN3YyN1FBSUF4?=
 =?utf-8?B?M0xEOW1oZk1XaGMvaHV5ZW5LY00zakNNWkVsVkZzcUx6N1gwN0RTMnpleEw4?=
 =?utf-8?B?YmRrSnFvS2thNU1LV01pMmVaTitxbkZqOHBvUzg2UzNxRi9uUVJiNW5Dbjlk?=
 =?utf-8?B?dHMzdE01ci9hckhJZURKS0pLazFkbURKeVlUUDd1K1AvTW53WGljenFhOEd5?=
 =?utf-8?B?NStiSERhTmE5RFBNVjdCaTlEVHZPSU04UGdBYzVZRVVDcXY5VEJZQXVjbElJ?=
 =?utf-8?B?WklJTk16RzF1YURGeGR0SGpoYmlnNDBjMGNJZVN3bTJsZ1B2N0MzUlFDNDJv?=
 =?utf-8?B?N3laNUp0SHc5VkhOU0EvTExsZm9OZWw0WnZOVEJ4U2pXemVKb0JBRGdCTlFG?=
 =?utf-8?B?QnZCd0xmZDIya1JjQ3BrYlU4eVUvSFNaeENsZVlRZjd6TWEzL0FpcmJRTGdz?=
 =?utf-8?B?bzJ0d25lN3ZQZzl4SUV2UXFoMGtwdnljMUNpT1AzbE1JT1lTQ2pqVEZCZHFj?=
 =?utf-8?B?U0pKUWNiYlcvZ1hpSFFjdEtlVnRGS0lxTUlhRnI5dmxXT2x2YWNZZTdUQTFZ?=
 =?utf-8?B?TnpiUVUzQXo5NDAyU1VZWWw0YU9rcm1vQzBSaXVkVTdkMElUZ3JteFZvV0Zu?=
 =?utf-8?B?Skk5bHZLdDg4RFhKUGxkSTZHQ3lseDZsME45MmVObWRRUG5qVHhNRUcvUUtP?=
 =?utf-8?B?MmdRT05INFp2djZVTFVoUnpsaGVQcWs0dEVtd2IyWlhhT3dsaEwyVFhFWTlp?=
 =?utf-8?B?WEVDdElrc29HVjBiZnA3QThLNHNuNkpRWlp2WlJaVkZTNG9KdnRrYnFUTkZV?=
 =?utf-8?B?Z080OEdjUVZGajFXOWpBRXNaVmdIcU1ZOTZvQitqdlRPQmRGZU5QUGI2djFO?=
 =?utf-8?B?eWNiYVlxQzIwdmhOQVh2Yi9Lc3hFU0VHWDRXSkIyMENvd0tyNE5rRnFBcGlG?=
 =?utf-8?B?UVFoNzZQb0szYjUwQ1pCSDJRV0t6OUZCVTNyMWM2MnVnMmRZbE0vb2g1aS9Y?=
 =?utf-8?B?eHpxaTdWc1R6b3VGZ0xqSmt3YmxWUlVpQUs2U1RLRVRZZk9rQnV5R3FBNFE1?=
 =?utf-8?B?Q3diVU5lcmtJTVg1WmNYZ2pacy9HUW95b215UWVZNDJOVkFrRDFYK1hteFd4?=
 =?utf-8?B?U3ljNkxCVmlTaDFGZ25sNlIxOHNoS21IVThRNGtmTHFFYm9VZ0NHbC9sdXZJ?=
 =?utf-8?B?Zi85Z3R6eHhPNGVvR0xBZnJFaDVkQ1gwKzVpd3U1cmRuMm9lWUN1RWRJNG1u?=
 =?utf-8?B?SG9tN29PckxJcTN0K3QvQm96SnBLL2QzdEQ0S1BpODRvdFA5aFlQaTdSUkpF?=
 =?utf-8?B?aDV2K2x0QmtHRUVXQ3V3L0tTbDdhNG9RYXNzSlBxZ3dPZ2FtcU4rd00vU254?=
 =?utf-8?B?RmkrMXYraWRuNUxkb1psUVFHZzRBcVN4d1NHOEpGRUduRzlHRDhiK2VEeXpm?=
 =?utf-8?B?ZDRFL0h1dTA5SlNsVmxrTFhQa1JTMEo3YlpXY0wrb1JwN1JqTTZLK2U5eThj?=
 =?utf-8?B?cW9VcER6YWozSXhpWTdHeVRuWTJINEdvbVgwbExzY0k0cXQyOXpFNVhhTVcz?=
 =?utf-8?B?ZmUzemthK0hsMWFTcEpORkRGT3k3MStNSEp0RDV4OHhuRU5yRDlUeVZDMi93?=
 =?utf-8?B?dTd4OWlMNHVMemJkOEduVytBcmNLZWtkd3pueExiVE81NEVqNWMxWXFNcmNn?=
 =?utf-8?B?ZVJMR1Y2ak9EYmdMNTJZWVFBN1VickIzN3U5UWZ6aWNibWFSYmlSVDhYTHBQ?=
 =?utf-8?B?UXJrNFRlWEZSbW9mZmJKQW5ZZTZITkVRQ1daUllSb3RtZFJRVzBweHZ4TkVh?=
 =?utf-8?B?UnhVRlFkQUlIS3JmVnE2elYrdnBScEdSWDB0Rm1YSThwQ0ZFaThDRDMzWUxY?=
 =?utf-8?B?RnJ3cVYrNmVhRFlWV1NjQWZkbHpBa1JidC9MdUdYTlFnSkV2T1d2bHF6Um0z?=
 =?utf-8?B?RGhUcUx3c1ZRVnhzMGxaL3E3T2RKTE16a0lEYW9ZWEY4aHYrU240Y09PQTRO?=
 =?utf-8?B?QmErRU5TRWhHelluRlF2TE1uT3REOURBN29IcHFzMmRmaFRIK3poa0RRMVNS?=
 =?utf-8?B?NnNQaG01WVFoeTAvQUFEeXgwK0xWMGVFVE1rNnhBTnhUUzRLdWpYLzU1SUcv?=
 =?utf-8?Q?80nanTnr6CLrEABU9u8KlvQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5ddf7c-494f-403c-9e5b-08db0f74fdcb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:52:15.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zyelT5X0A173QJne+Xi2GhCTXznlUs0tqRGfMgq9xeE6LpZzzX+lU97idYEBOyAdLCK0Ucq9XDZNMiuKoB57z5XB231vWviT00Z3XLmJoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4756
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Wed, 15 Feb 2023 09:48:21 +0800

> On Tue, 14 Feb 2023 15:45:12 +0100, Alexander Lobakin <alexandr.lobakin@intel.com> wrote:
>> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Date: Tue, 14 Feb 2023 09:51:12 +0800
>>
>>> When we try to start AF_XDP on some machines with long running time, due
>>> to the machine's memory fragmentation problem, there is no sufficient
>>> contiguous physical memory that will cause the start failure.
>>
>> [...]
>>
>>> @@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>>>
>>>  	/* Matches the smp_wmb() in xsk_init_queue */
>>>  	smp_rmb();
>>> -	qpg = virt_to_head_page(q->ring);
>>> -	if (size > page_size(qpg))
>>> +	if (size > PAGE_ALIGN(q->ring_size))
>>
>> You can set q->ring_size as PAGE_ALIGN(size) already at the allocation
>> to simplify this. I don't see any other places where you use it.
> 
> That's it, but I think it is not particularly appropriate to change the
> the semantics of ring_size just for simplify this code. This may make
> people feel strange.

You can name it 'vmalloc_size' then. By "ring_size" I first of all
assume the number of elements, not the allocation size.

Also, wait, shouldn't you do this PAGE_ALIGN() *before* you actually
vmalloc() it? Can't here be out-of-bounds with the current approach?

> 
> I agree with you other opinions.
> 
> Thanks.

Thanks,
Olek
