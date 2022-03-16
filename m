Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4157D4DB9AA
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358039AbiCPUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358140AbiCPUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:48:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EC35A598
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463616; x=1678999616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=re1L+F4AL6PV01egiOG/o4PVXXboJ95btxyfKsBDsSA=;
  b=ZwmlTil16OUOHAKFJlQBhVSz5klxQynfA++sSE6shOSFDHp4NenY1MyD
   LXmTgge5rZ9gD3UZl1Knnfz2CebTGhV6bhiEMDwcp8kjt5hpC+TV33046
   e4P3KYb0Roh3HWR/jLWmiq75Rn9vDIbNH8wBdMLG3cYoYdKtN/YogvNlO
   ZYppjOEVlqRJZBoqrljDuZPm3HWr37/K76nDoLPGkXJPvvSAof2Km4MM9
   /nMRMfgzJ7TgML/m8gyLRORSZO/IE9jPvUgazG51hQ93K92UYTDDmNnlV
   HzX8SlfaDuLLBT/xbLUA1bv1FuPVesPhDXL62GZtBNoQe63eoe9+9dusr
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="244161217"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="244161217"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:46:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="557625544"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2022 13:46:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 13:46:53 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 13:46:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 13:46:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 13:46:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpQ9Ldnx6Ty5dq8horf443NoBsXUgkBRiwEI/NCJMV4CBp7/yY4RNZ4F4IAGM3x0aUyRm/Z8Tjc3hjtEsg/28O2RQP1KN4c4RfOcglktl0BGczp0FqGYF6CXcJMhjoBmlz2meMCUTcmE0jDdPLOV9kKmycT3SdtdoL73qdx12LyxVlHkoENnfCvhEZc8YtVeRpLeB2Voq5mvzHgXrfwjV2YbT5y4ehpe2pi91YIRJ8hl9KqF3Zw1zG4Xq6M0e/QmdcgbqF5++gldxVnrePr3rgW22+KwvP928Gp5CC5bEICNC3TTQAS7ZmpkR49eSTWeHURh86PKGfVbqNssrbzqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofutuAmaxxQ52IapfNKFYD7KvD0AhfurmOzrcDbUZyo=;
 b=gWF8q+U7xSwXlvTgrJLwbHYFQZRxsQ0Fptr1sRQ21IHtzuPTSfQMeb9ALqOvG9j7pjGeR77nv2/27FDEBEj3hscuZjyva9zUKddJKcNIlHedUb9qNbk9LTVuwtvn2RCSP0Xob7XfgMeHpIMr7j+SzIXr2ny8MON/0vcc0R+WjNVSQAfw6KfM2h72Sp9cqLE9ZbYkuR3d6I2g9ziKo2WA5ZHd68W2UryRthOjCFqi5PQZ0np1M5Jiq7tcHnDch15jqXk/PGrI4bvYPxdw5A9cjPX5MINscs0m1aXDG7qG4u1UzWJTRU38BaiT3qxWW5hNVYTqwAM1h9Ds+fFpmiYbeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW4PR11MB5910.namprd11.prod.outlook.com (2603:10b6:303:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 20:46:49 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 20:46:49 +0000
Message-ID: <1e22c10f-1814-10fc-b0bd-e086eccf3e71@intel.com>
Date:   Wed, 16 Mar 2022 13:46:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 1/3] ice: fix NULL pointer dereference in
 ice_update_vsi_tx_ring_stats()
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>, lkp <lkp@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
 <20220315211225.2923496-2-anthony.l.nguyen@intel.com>
 <20220315202941.64319c5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e0d1a5caf1714f303ae89c909dfa4d04ebdde3e4.camel@intel.com>
 <CAKgT0Uc3MPiVijAMc3opdqUmEXMT3umqYWMrowHznoT=L=-5nw@mail.gmail.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CAKgT0Uc3MPiVijAMc3opdqUmEXMT3umqYWMrowHznoT=L=-5nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:104:4::33) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69894a2e-c67d-4ba9-aef4-08da078e1815
X-MS-TrafficTypeDiagnostic: MW4PR11MB5910:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW4PR11MB59101F0055161D76F935B023C6119@MW4PR11MB5910.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wNPjKbnAyfNK4KTIVJnvUVcnWndUpMFnxr6AbJqtbqcDOL6MnSV9nXvdFofMzHnjgn9Pz25PXD9pS2KcRup7X//NxHJQWt89SNLgQ0wtYY5K9xNk3Iitn4w0sKY9qNLhlxHPH65Yxa3JANLNaEat1Qeeem5FSjMNPnAvxBme+MvoTH/aQX6gXPvJcVjz7UnkW3nhg+f/DjQJcwp6awxrxVY1jXa/HltLcRjJxGjDcMv2NNcf6jJdaZPCMyTGmK8iP9Bopgz1fyPgusihoZb65ra1qkLS2xk6hjDp9OfDjyKEZo/COGvzYXtt0OB4GMadkVUF2zOjElICPqTgdFsZ8ibgxNXnLjvToqDyuBTOQOCxIrii+WtF+e7JHxDj/lzJhYySOXXy+pA6BmAHy1dsA3SOb0VRYicQLE/K3JdotU17pf7q0FVb2ek6OflrLgytVhwbKR/yEwbvKTq1nJ3ve8KEtMPh/7QtSn02kbLAzz0ScCcIdSKTQHi5R5yn9XYHJ/D5rEJ3CIsbaei4ZTR7HvsB4hbdXZGIALQ7jbxvULkUy1YmKK1XDBob/ZWgaqqZHpF7GNaAvKWSEpN+tGS0WE14JdjNTwK+aG60+Jc127kzKKR7DtDRAogzur0N8UE52PyIjMf7GelVvGqd0vMMGjL7ndYjI0k2twggLlDBGf6bBZzQmh9I9khrPDW8UllElxxfAO1nk3ykyeq6nG/bNbo+IB0wzqI9uojproF97eTvSSlSleN6Y/oSAT2W36SteHEoNm7Ng8btvBd4OHLH3GKCnzDT73Jp+d/8LWfE9jdiTFmNy0U9y4FmEeasFIp5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(107886003)(186003)(26005)(83380400001)(38100700002)(82960400001)(8936002)(54906003)(5660300002)(4326008)(66556008)(66946007)(66476007)(8676002)(2906002)(508600001)(6666004)(53546011)(2616005)(6512007)(316002)(966005)(6486002)(6916009)(6506007)(86362001)(31686004)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WG9GOHh2R0hRSSthbHFTU0VrMXVyU2VyTVJxcjEwV05MMWdtc1JVa3NHYjgy?=
 =?utf-8?B?UmpvV1hobmgwTkdDbjBIZUx6SnR0d2NEYjNkZCtocTYwVkFqSnJGZko4U1Bl?=
 =?utf-8?B?NzlBQk95azhadjR5WmNkTmZoMU1uZzlhODhUNllzakpjOGJrOHk2cnhkZERa?=
 =?utf-8?B?dzMzWHBraGFFM2RqaVZFV2xubzBFSVMzSVVHb2h6WkE2eXNwSFFvTEh0N2hO?=
 =?utf-8?B?cXVSSTVVWmdkajVBUVpvS0x2L01oYU92N09sTUdlbndZajhwVnVFVGQ5WmhF?=
 =?utf-8?B?Yi9qU1UwaUN2ZUNKNHl2SkJicUdJYTZDUmxIZGRNOUdIWmM2TytJMjEyWjhZ?=
 =?utf-8?B?NUxENllEaC92NVlJUVBTanYzUEtZdDUyOFNpcmVRNEhzazFOdkZIVFQ2WmFq?=
 =?utf-8?B?cktSZkNYZzhwTHZ4WTczWkF5eFFvNVpCdGR1cXdhSlZDd2dEcEEzVXcwZExJ?=
 =?utf-8?B?QlhLTFdITVBCY2s5QnZaZUppR2hLWmZ6RmR6bXZxVEtwSGZQOCtuc2hwa1hQ?=
 =?utf-8?B?YS9QZlR6TEFCc3NxaENndHpnUkI3dDhuZ2NDb0Vwcktvd3ZjRDAyeldQRjky?=
 =?utf-8?B?SUpMblNsSXlTUFM4eXYvYnVpeFNZaDNuVmFQL3J1STJoK0syNUxFZGFQajg5?=
 =?utf-8?B?NEZrZlUwWE8vOGFUK05aY0h4WHJ1R1VRS0wzZktyODMwQXNEVzBaZTZwN2Np?=
 =?utf-8?B?WXFaa3Yycm5CbER0L0FQY2dPalMvTWwvczNjaFdsOXZVT29HdXQzdHBSdGVv?=
 =?utf-8?B?WUJ3MXl3NStIaTdNOEphR2ZMVVhPVEM0WElEZ21uK1ZRWERkM3JwOG4rZlNh?=
 =?utf-8?B?SnIzWXBadUo4UkdFaEJaOFdkQWpnVHFXN2toeXRyQXRleklMODJJRkh3ejhZ?=
 =?utf-8?B?SFlEVVdTbkxNT3FLOU1WMUVDZWUyRC9sZ080Zi95dVJudGpWVk5LRU9rUzlr?=
 =?utf-8?B?MThZK1AwUktIWm92MHZpVWdQNXlDRzYwdU0zT05SeTl0UjNEVGpqUlJFYlVW?=
 =?utf-8?B?T1lRdHd1VUJCamp2WjBoQWZIUmVXelBDVGxFQnBIdmg4bTdiMXBjdWZPSzk5?=
 =?utf-8?B?SDN1WHQvYW43N0xrU1N3Z0xTZjc5ay85ZlM0dEVFYmIzMEljSFY1ZFFQeS9T?=
 =?utf-8?B?QWljN01OZE1kV3ZzZmd3aVFabzZhQ0M1WDA5NlVtbEV3aUh0Tkt5N2hjMGhj?=
 =?utf-8?B?NXBCenZ5MGRoNWhSamMzaFgzTTlhb0VBNndINmdoM0hNTUNjLzdSWkZNQjNB?=
 =?utf-8?B?MVlxQjBQWFd5Q1FXWnU3dGJIZlc1OU5KekZRclRiYThDbmRhZ0RYNGd5Tzlw?=
 =?utf-8?B?NU4zNEF0aTZJVE52Si9CSGpaMVdCS2V4TjUwMjIvcVA0alM3K0FWUDMxRWhW?=
 =?utf-8?B?eXdxdEJwVElhYzc3b0J0aEg5RFM0ZDQvQ3hSY0FMQnN0Wk1od0dOd05zOFJ0?=
 =?utf-8?B?ZmpTL1BHNlFkdVJwK2FSY2J6eW5sQkwwM0JGQiszVkhJNEtYQWxaUkN2NDA5?=
 =?utf-8?B?RXJyWjdCRXFQdlFHVWhsSTJ5d09jRnpVb1FMQUN1Szl0M3piWExGV1hCWXgy?=
 =?utf-8?B?cHZ1OHhuM2lFTGFwMDZBeUgwZGZPb3dhZlJENS9Sb0hLMmdjYWZ1czlxR0w2?=
 =?utf-8?B?K0ROcjFqZTZxSWU1T3dRNVMyNTVlbmRRYkR0WUN2NDJCL1hxaHh2MFRkNVVR?=
 =?utf-8?B?VkJoNU1LTTZvb2RLdVI5b3pJdENxMjNyemtyVGFsVUwvbmVuKzczbFAzVDQr?=
 =?utf-8?B?QVJ6ZXdid1lwc2psRFNHdFJzZDNrL3MzY0FmMmMwbjNaWGZmRjJBZXpyL2lv?=
 =?utf-8?B?em9SLzBFbUhEd2EzTnpIWkJYb0RBRVVadndxc1lubjUrUHhjN3ZoVGt3dU51?=
 =?utf-8?B?aWNUeXBNZ0x4WGI3NFRCL05jcTJ4bkwyQVp3MkZWNFBzRVd4d1FndUh5T0F4?=
 =?utf-8?B?R2NtS2tDWjVncExoZVlFMHZOSTNJak8xQWF5TENUdndkdlI3aVN5eG55KzBy?=
 =?utf-8?B?ZXg5aEgrMjd3PT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69894a2e-c67d-4ba9-aef4-08da078e1815
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:46:49.8733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFhvLrZFWZnlXS/g31ys1BmKOfn8ZvQuiRAJJHpBbD6AE0NMEY6pqjN5kX6l8szloeaT9lgkoyZAx0LCECW7lZxkvN8oTmzvBiscWfq9vzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/16/2022 1:24 PM, Alexander Duyck wrote:
> On Wed, Mar 16, 2022 at 12:01 PM Nguyen, Anthony L
> <anthony.l.nguyen@intel.com> wrote:
>> On Tue, 2022-03-15 at 20:29 -0700, Jakub Kicinski wrote:
>>> On Tue, 15 Mar 2022 14:12:23 -0700 Tony Nguyen wrote:
>>>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> <snip>
>
>>>> pointer is valid, but later on ring is accessed to propagate
>>>> gathered Tx
>>>> stats onto VSI stats.
>>>>
>>>> Change the existing logic to move to next ring when ring is NULL.
>>>>
>>>> Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate
>>>> structs")
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>>> Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
>>>> worker at Intel)
>>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>> ---
>>>>   drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
>>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>>>> b/drivers/net/ethernet/intel/ice/ice_main.c
>>>> index 493942e910be..d4a7c39fd078 100644
>>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>>> @@ -5962,8 +5962,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi
>>>> *vsi,
>>>>                  u64 pkts = 0, bytes = 0;
>>>>
>>>>                  ring = READ_ONCE(rings[i]);
>>> Not really related to this patch but why is there a read_once() here?
>>> Aren't stats read under rtnl_lock? What is this protecting against?
>> It looks like it was based on a patch from i40e [1]. From the commit, I
>> gather this is the reason:
>>
>> "Previously the stats were 64 bit but highly racy due to the fact that
>> 64 bit transactions are not atomic on 32 bit systems."
>>
>> Thanks,
>>
>> Tony
>>
>> [1]
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=980e9b1186424fa3eb766d59fc91003d0ed1ed6a
>>
>>
>> (Resending as some non-text formatting snuck in to my reply. Sorry for
>> the spam)
> Actually the rcu locking and READ_ONCE has to do with the fact that
> the driver code for the igb/ixgbe/i40e driver had a bunch of code that
> could kick in from the sysfs and/or PCIe paths that would start
> tearing things down without necessarily holding the rtnl_lock as it
> should have.
>
> It might make sense to reevaluate the usage of the READ_ONCE and rcu
> locking to determine if it is actually needed since much of that is a
> hold over from when we were doing this in the watchdog and not while
> holding the rtnl_lock in the stats call.

Thanks for clarifying Alex. I'll ask the teams to look into this.

