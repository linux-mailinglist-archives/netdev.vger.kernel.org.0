Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAA4586F11
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiHAQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 12:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAQ4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 12:56:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04826385
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 09:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659373011; x=1690909011;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZJrNuhZDIfkEyT8RuOf3xkjuInb68hA21qdb29vQ1QU=;
  b=Pq+5Zj6OTnGi88FrDvXi5PzYz5oPWtdiF8Rbqd3bYw2KGJHH0g0lGe7l
   kg37NdvUPIaO3XVP79pPZLeYZEmXq9DREO0BYHU3lD6dNl1DX5F2EYd4y
   f3kMxJNQPs0DEBBFohQY67NZ/WpyYIH90MlQRqx14ptM22g39WSCx/fmF
   N54uhKXPrqJO+yikZG0BfylYCCAMnEioCVI6X5nXNi2GRjot+JuWtfNga
   5/SGb8FoMRzOONNS60C8jLEkuxr+d/s/mWKzkFg3Sn1eR8lIK+qnOl8Kn
   S/324FXbnodPAIBiDJJ3AU35x0hKpMAtf7PP4mJAdXXRbsLOD+Q0+9MLM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="290407142"
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="290407142"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 09:56:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="705039588"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 01 Aug 2022 09:56:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 09:56:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 09:56:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 09:56:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1YQO2e0u4jDl+r+X6fMnf5OGX7Zz5epYzO4iRnA2+wWYwyyD+lJRjJ0b0ACsIaY7P99DgCZ9oR+f7E7jEY8tC4atkUe7S9TgYnKfIjYr3jz7x0ZOci3SMFaHqBMIkdDk7qT8gtrcYX2P3jcmmFQiOEsjGFmz+PwmG7UQrOuNC09OJ6iJCdk7N9kE4os5FeWpZZzZtDlzqZk614Tvmq0+DCXu8IIsC9qTpRNo6YPC2SVxkOM2gpp1ANXJi42nWkujvzDroRBFk5g5ApbfaD4izsjRisjfiCvC+OTN6496CQxH+iqnjVoD+jaZMTHKEIJkb1e+7S/v30GnArpRQVc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKvfW0oErF23D3EYNIlTGURKLxVrJtAkhlVbzmxE4hE=;
 b=j+1DdLJlDI4wZo7J+KdaklLi6jpe2XbCeyRaMO9YP6WVjMWq+3ut4IBxPiJs/8PEYlo/WWT6wKIfMS5ePBCmBEVkuB3Mas0755lP/KYzLQIlS57QGUUh5pKxhCyrOx2ENhXKfRg2ekTRGBSwVnSnw6zLP6s7PC1pgic1+UH28shI9+nT/F8gw2nZPyB7t/cvz6a3Tq+z1Kk7IPrP0KTGm/hwU7Hni5sKQWx7tfjgTvjuR3TlWq26mm7++F+CExEu4fT/StRZBEaZgSYRDxVnImL/hSFZSJZsELypIn/zFj6TkDybXBCbHBbKDKUDFzZ/FoAa6DQSbdrj/soqh+PHew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 16:56:48 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7504:add2:2794:3ecb]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7504:add2:2794:3ecb%7]) with mapi id 15.20.5482.014; Mon, 1 Aug 2022
 16:56:48 +0000
Message-ID: <46909de8-3555-5bc6-2e2b-e139941f640f@intel.com>
Date:   Mon, 1 Aug 2022 09:56:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 0/7][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-07-28
Content-Language: en-US
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        <jacob.e.keller@intel.com>
References: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdfe1b82-67d0-4fa5-f8a1-08da73ded2ad
X-MS-TrafficTypeDiagnostic: PH7PR11MB6005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4PTKQJwN6E9yy5fx7m/qvSxBntxrBoxpfRghiAA+p8fbMywxYNECd/tulueEc4zxYNkzFactt58GkH7RK+8TGnGhELVAFgx1qdKwWSnJfvJSlIeKmuhKD+0HE65UQNNnPf56Iin/xPTuF0MDbXNCHgiEcov+wblq3kOKAo2w2FDPj5wlcSKXWu/WrcK4yvVVwkkNAIFEScHBwTzKencLxkfuXve7VLuZJZ5PU/X1tfACDPCQPgsRxvBSett84kjVSEXdPXyNhc5JNEwnmA/vqtkgw9WscuksD8DwyKm92f0VE9T/tKO1k1U5OiKtH9otPdQek2MUbzRJ62kmr7nK1Lc7sojxaLhAT3Rk5q7xf2PRmwsRRr1uyzuhYrBDjEAUnOYM0bGCbZuED7I4Xy583ARrWVFMfliDRWP1WC4iKRQmCTBxOLdNMvfXr2wD9kZVokVeyhVckDKQPwhi30YexHbbtLSMeSeeJPKXkQuQxyGP9DbXIR/o9DqsQTqGCh3/Y222/e+ys9wy2AOezf56XOH9zKOwbV0do0quJfFcgHhsRVO7h96U8Z9g1BJn+UjZ31oDxgAsJbVb0fdBR5PZXE6W/InNM7eWI6zKaavM8/lmSxOn5jvhi6jJWhuTqZLoywkPd96xJNdKqX3Grw+o8SuJhi6EAnhdrQfnwb59STPGjsuUkIarldGvUCZGy56hTABK+RP7OIDsRiXOZovfiB6ovlqRpbHkNo6MqCO+RXMHjFU6Cr+xZ2lhU8y/jhEbC2EVdmk9Y2NbTmHrR9TKpJz8MiA/K9opn9r0WTvcF7zTqK9Idal2u8HwI6ZdzUP9t/Pvyo36VEyyDH/mqQUIWX77u6Z4CCL3eVGGEo2bVP6tEPFL+zIBjcQKlsa0NcR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(39860400002)(136003)(376002)(186003)(107886003)(2616005)(6506007)(53546011)(86362001)(6666004)(15650500001)(2906002)(41300700001)(26005)(38100700002)(6512007)(31696002)(83380400001)(82960400001)(36756003)(316002)(5660300002)(66946007)(4326008)(66556008)(66476007)(8936002)(31686004)(6486002)(966005)(8676002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFk4aml5Wk5jUXYwelBDNGw1Rjd2MmVMR1JKa1IyWkpneFJkcEVCUE9wNERG?=
 =?utf-8?B?cEM2bzJQemUzdjlZUjFTUGhhVjJLaUYrUEtXNmNGK3pFRzV0SVA4MHIxbU5x?=
 =?utf-8?B?QVU1K1M2QmpPS0FNYUsrV09DWk04dmhPRmpNQnh6ZU5EQlhlWEhFNGQwU25I?=
 =?utf-8?B?aUFpWkQ3ZUxjblpTSHhUdS9seWZrTWYvZUY4ZkJpTGE5VnVNanZVN3VyN2kw?=
 =?utf-8?B?cVlkMzFhbnFwYkh5WWlkaTdMZGkvc1J5Qi94cFRrbktEMkJtV2tSVnVzR0lI?=
 =?utf-8?B?d0h0cktKRExRNy9EWXI2NlcvTEN6SGluVm1uTWhjL0VQYUVMS0JjN1BwUDBZ?=
 =?utf-8?B?Z2t4UE1mTDJzRTIrenhuaVZYK3U0Z3ljMGU3RlhpNmFVNDdqdHBlUXB2QmdC?=
 =?utf-8?B?OTJEOTJJQ1M1dlREK0xyMVJUL2k3SnprRWVOZk5kaGI5d1dwVG1PYUJEQXdY?=
 =?utf-8?B?Y3ZHdzFHdFVmQkVnN3luYWFkU2lFd2lFeHgranRlR1lMTGF6aUh5S2ZHVThn?=
 =?utf-8?B?YUhHc2VaYm1GUzVPL203bmMwUnlyQXAxcTVjWlBPWWRWVVNwZzRsQlRGY1py?=
 =?utf-8?B?Vmg4TFQ3SW1jK2liN0ljTHdBbXpkYlNmcTBIbHB4RElvY0JLcEpGdkVpTTZ0?=
 =?utf-8?B?V2RabEprUjBJeDJsb25pUFFKTVNhcGFETG5DTXJ3bWZ6bFBKQW10enQraTFD?=
 =?utf-8?B?aitHb1FZNGRITUJiMHdZaWFTZExsSzVrZjVzOHZTVCtINlk4aVlGMGkxMnd5?=
 =?utf-8?B?TGQ3bXg0NkNUaURITmd2RkhLUDh0S2NEN2c4MmdjNnU3RlJONmloSy9RNFZG?=
 =?utf-8?B?L1k0VWhtY2w3SS9GZnZkaUFNdVo5eWlJbGdQc1FWLzdJYjBxU0VHajFzSTBY?=
 =?utf-8?B?Uk54YyswR3RPQ1diTHZnc3A1eDlEWWx4VktTanJtUUFXK3F5eEZuQXhzTElT?=
 =?utf-8?B?aHZOc2hOWjNsRUptajVrNHdqT3RtYXZCUFE5THBhWmgvWUtFQnNLNTRjSFpF?=
 =?utf-8?B?MzNlYkoxd2RKcjQ2eFRyWUl3Ymx2OFcreDBGWU1sMDdveWorVFJ5R0lSMWZ1?=
 =?utf-8?B?cGlaRHgxTGp0SmRKdlZLSTd2RHhXTFZDNkJiTVBGOStKdU1JL3JZS2loNzlM?=
 =?utf-8?B?RW14a3drRFFtZWZ3Si8xYkYxOFhNMHgrYnRmN2g1VGVrRlVGVG51a1BsU3hK?=
 =?utf-8?B?ZlNubTg1azNwV0tIaElKWTBIWHhxSHZrNWFuNVFIamVRM2hBUlljb25oNjlU?=
 =?utf-8?B?b2NLeVZpVVJMTjVXV1o2NytYbWdmMGd4N2RkRnNhaERsRVVxUFR4NlRsMDVW?=
 =?utf-8?B?aUVkOGROOU5WM3Q4bUd0ZEFKOXpwb2JuYWNSZXhxeUxrUUdsaXNTaGcvMXo3?=
 =?utf-8?B?emJLYlJ5VG1PeklVeTFDVTFzTUZtdWZCVDVZcUV5QzgvZDdrc2dWM3MyU1M5?=
 =?utf-8?B?azNXZjN6UFZlQUxRNi9pTG4wNm9UY2dYTFFPQURTdWpMZFlSUzlvSFlDblM1?=
 =?utf-8?B?VEVEZmZIcWZGbXVHNGtXaThMQkx0RDBRZHQ4cnhtNlgxVHVkVjMyeE9NeUk4?=
 =?utf-8?B?akRRZGIyUUppMm1YSHFFaUdsV05zUkVCU211NnFsUmIxTlliTVEyQ25xcDBT?=
 =?utf-8?B?K25GTzFOOFhkd2lBRXdBSVdscFJNUnZ6YllPZHZhbDFuT2dLM1dNSjFKalky?=
 =?utf-8?B?TldPYno0SnRCMVQ2YnBMaDRYOTVLVkxHZTJVV1p1QzdkKytEQnRWUHA1Zm5a?=
 =?utf-8?B?U3NnZmJmV05hYmRVYm05TzlNOXIvbWlHSzVUYkdEbllHQWZrWEZsYnRUSzNH?=
 =?utf-8?B?bFNabWJHcjJvdjE4dk1ibEY4NHdrVFExYlZBNVFpcHN3Z1RZT2dKVlJnbzUv?=
 =?utf-8?B?TkhySnZuS1RDWFZ2VGdnemRYR2E0ajUzQWtrWWJTNFc2cy9KYllHb2dMRS9u?=
 =?utf-8?B?bW1wMkMvMGlpRkRsSWFVeTNWZUsvZVhYMHp5dWp0L3ArMlVlRWJ3T3hqZUFm?=
 =?utf-8?B?R0pIODBiRlIvOGlsSXNtcGduQ1ZNSWF2eDZyL0NTeDBjTHJodU5IcDBYWTJr?=
 =?utf-8?B?c0YybGxsbzFOWEo2b0c3ZTV2dXo1U0JyQVZQRVdPaGNFblU5U0RlTXU0aDZ3?=
 =?utf-8?B?U21nN3FxempobGwxYUl2K0ZmNEVSdWxzRlR3eEh2ajJLUjc0cFRtOHRlZWFk?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfe1b82-67d0-4fa5-f8a1-08da73ded2ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 16:56:48.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pCYhs0sjeCICj345G/tMyHNHriKuu9BSu2EdVPTHQFE4CrUf3KqFyEoPBCxyPMb0nYSYHekcfY8H2vhHC42kGOMDTPA8EO2YA15e9MfsQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6005
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2022 11:18 AM, Tony Nguyen wrote:
> Jacob Keller says:
> 
> Convert all of the Intel drivers with PTP support to the newer .adjfine
> implementation which uses scaled parts per million.
> 
> This improves the precision of the frequency adjustments by taking advantage
> of the full scaled parts per million input coming from user space.
> 
> In addition, all implementations are converted to using the
> mul_u64_u64_div_u64 function which better handles the intermediate value.
> This function supports architecture specific instructions where possible to
> avoid loss of precision if the normal 64-bit multiplication would overflow.
> 
> Of note, the i40e implementation is now able to avoid loss of precision on
> slower link speeds by taking advantage of this to multiply by the link speed
> factor first. This results in a significantly more precise adjustment by
> allowing the calculation to impact the lower bits.
> 
> This also gets us a step closer to being able to remove the .adjfreq
> entirely by removing its use from many drivers.
> 
> I plan to follow this up with a series to update the drivers from other
> vendors and drop the .adjfreq implementation entirely.
> 
> The following are changes since commit 623cd87006983935de6c2ad8e2d50e68f1b7d6e7:
>    net: cdns,macb: use correct xlnx prefix for Xilinx
> and are available in the git repository at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Hi Dave, Jakub, Paolo, Eric,

I'm seeing this as "Accepted" on Patchworks [1], but I haven't seen a 
patchwork bot notification or am I seeing it on the tree. I think it may 
have accidentally been marked so just wanted to get it back on the radar.

Thanks,
Tony

> Jacob Keller (7):
>    ice: implement adjfine with mul_u64_u64_div_u64
>    e1000e: remove unnecessary range check in e1000e_phc_adjfreq
>    e1000e: convert .adjfreq to .adjfine
>    i40e: use mul_u64_u64_div_u64 for PTP frequency calculation
>    i40e: convert .adjfreq to .adjfine
>    ixgbe: convert .adjfreq to .adjfine
>    igb: convert .adjfreq to .adjfine
> 
>   drivers/net/ethernet/intel/e1000e/e1000.h    |  2 +-
>   drivers/net/ethernet/intel/e1000e/netdev.c   |  4 +-
>   drivers/net/ethernet/intel/e1000e/ptp.c      | 18 +++--
>   drivers/net/ethernet/intel/i40e/i40e_ptp.c   | 35 ++++------
>   drivers/net/ethernet/intel/ice/ice_ptp.c     | 16 +----
>   drivers/net/ethernet/intel/igb/igb_ptp.c     | 15 ++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 73 +++++++++++---------
>   7 files changed, 75 insertions(+), 88 deletions(-)
> 

[1] 
https://patchwork.kernel.org/project/netdevbpf/list/?series=663859&state=*
