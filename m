Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A006982C7
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBOR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBOR65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:58:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1AB27D6E;
        Wed, 15 Feb 2023 09:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676483936; x=1708019936;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ftMdAuP2ShKITZfD0HY7BCME1AjcwCrSnSS5Tou7zDM=;
  b=VKFHZtv9Xyl4q9NQKR2IgWS26JyjiMGba45axlfZG4rZVmr3Jipchzu5
   vFuKWMWXmbha+V1uVB/O5Kfzvgt4ayhGJiDfnFVZIXU3oJn4tXwVS+udu
   es1DhQLyMYDYVKTq2bTTw8HwH0Vpb+V432/DNYbYfSjE/jZgrf96H6n+r
   L2XPddV4adoOi+reBR/W4Ey8/NaZdeuMjnqRBPlwjHX32GCKlKV9uhHuJ
   vJlaP2YOkTwt5lGs10n+FVOorJ3jgAXoIW3LzkEcDNpTAKfsdHQE7zHnW
   12LXctxqRXFy6yvS9oaloeGN1rwZaHaDrLXni/szV8o20fZCm1Gmpj2hT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="417717059"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="417717059"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 09:58:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="663085940"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="663085940"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2023 09:58:55 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:58:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:58:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 09:58:54 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 09:58:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wgff4/UC2163+eECBs8ju6H/CYWsSrd3yWLeWYcevLU3dsqPhVcOTra/sUdD/5F93L3Rt5jGoEpCxWenQRhDqgIAa9x7aB3XaKcF2hWd6expL73Put68ckWyi5EH5NGqpkRZDjYXbRSxNwvX6UyCLq5LeRRXdRL/5Xiwj5/If1wZ8xGfDHSuDUhMY90bG4/fU+/3TQD/9kf6HuXR09jpRnJQ8lxlp3JQBxsNdMW7/WkVAq/H+muErAClYHnkNVpWCqu0PbHrbtcCxqc3ywmrFrlnlUuHYZGZf9SXlLXT8sa691cHq3JuF41kqpynT+rQ2yJRTyEkpHgL0BCduS15/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEqLz716G6M4oY8P8GTAESKLDj1v/GuOW++h15qTTkg=;
 b=iVoe8qxhIjCf2qXT6/HyD9dceaeCYHSEA47JtggwMi3UGejUOIRweFXeXNMG+hCN92tvvfW2RVaaBWdv2x5mYhDT/EVjGXxvoWFEhBUAXpVIMGWLVvxQaAzqpiYSr2xA1yIaarPCmg0u6WtMYn/xzLfmiXhzAFlF9cBQ8JvOpjm3bZr0kETCQ1BUGVW1xOnz574PVMJTWo8EZyPcRDS8ebM7/n4NsEYm/kV2uh9LOGemwMbelhlwltupkgQgIgp72VQBuI/JnmOl93bTnQFKAtxw0PUS2D4M7DPwxm1s1CB/x+FO0MYWPkLmqMfsTGywBJDg6JtJx3aaYVN1USsgdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB7447.namprd11.prod.outlook.com (2603:10b6:510:28b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:58:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 17:58:52 +0000
Message-ID: <4c993fb0-de7b-7671-8d0a-19bd7c49e70c@intel.com>
Date:   Wed, 15 Feb 2023 18:57:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] xsk: check IFF_UP earlier in Tx path
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <magnus.karlsson@intel.com>, <bjorn@kernel.org>,
        <michal.kubiak@intel.com>
References: <20230215143309.13145-1-maciej.fijalkowski@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215143309.13145-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 73ffb1ed-b036-4fe5-6884-08db0f7e4bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+lIpeV/Gx07LUknWMSeTEvUVgfb3ZGK0hxPldswX7jocxG9MmZR0TTFicoSauzro/xaE3WQHbH/wXTQPR6pDdw/kup0ICwBgXJH5r4JrXPsBlVRp2YmsE+7WbLM2d2/17syN9qS8QAVVCKXrvlk6/GCuNvwx8wWa2I0auECQaC7jcuJJyoEmYiwkKCG/7/v5vDgNlWEmO+IGsVrTgNK+ZBF4oNHm7PQgoEc0r3H7z7CMLWfGGUt+lbRQj9h8NDgxDf4UrpuYNXokqcKcTLlE6kPmf6iICysTEvvfRiXDCaoEX9q/3lOtrBPl/UCc4IdfbzXYkvoTJohAcD5+5KvyL5vtQi7kzI9V+QozWTnkIzVAYAhg1ATM/kewUgl4x+xqKEhmCuoGRf5UYYtQXIwsz4PKCJgAGoS04feP87tK8ZghjXmXQkZl0cPyyJ0QxIYTCIDK8GVdiR1XdfM9gst/Pd6AEhGGx13OU1rContomKH2xE5nlcanUCBJBBUqY0uPnIHrZrGh31IDsN5kx4LhleJsC+8TCF6SPtNp0JhR06Loi5USpLKWcRbemnz5DmEB7iE3SY9XV79w9jxf/cF37WPNctFP2JCN+cFriCZXue8dd3xUEzEdUK/Vr5g/ogn5OuAT8BJz2AFhDUzKjaBRV8SUN/iouKXSEZfbnjyTslfVxm8vp7EDWeb2GfueLxxzSdmzMFVj1JhKtesEKFVnrIjDSzrub0okUuNBIOj3wTxpSsZmvY18xMvML6PHaN6JuViPJkyPnCrgb6VDwdWr9F1e19nVGbW2d/7VU3KEMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199018)(82960400001)(86362001)(2616005)(6666004)(6506007)(107886003)(2906002)(6636002)(316002)(6486002)(478600001)(31686004)(38100700002)(31696002)(6512007)(26005)(37006003)(186003)(8676002)(6862004)(5660300002)(66556008)(66946007)(8936002)(41300700001)(66476007)(36756003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFdYSHZySHhFSXdqbVJKcS8wQVpDM3l1REozUFcvbkJMVHUwNC9kNnYwUVFS?=
 =?utf-8?B?UENVaXNxTTN0bFJ3UmZzZWc2cmZqUURVYjNDaXBENjVYQUlRVkIwTGxvK01v?=
 =?utf-8?B?SExDT0ZCWnVUbk5kcGJvZmNXRmlNTVV3SUdjRWdrSmVoT25PdHNpcm92aFZa?=
 =?utf-8?B?QkpQSndsV1dnVW9CN3RSN3JLREozYWZTM1JjMnJRR25SZ1JjMy96UWdnN2V1?=
 =?utf-8?B?aXJxaUpVbWNLS3NlQnE1TXNjaGlGelViU25BaTZRK2lGSHVsZlI1Nzh3czJY?=
 =?utf-8?B?cWpBbWZXOW11RkZEV3NyZFpJdjhlQktBUFlkdkVySndJMnA5VHZUaVFIY0tw?=
 =?utf-8?B?S2lUQTB3M25LL3R1YkxEVXZlcDZNMHlGY0hxQkZVTlNnRk5QUmtEbFBZbUJI?=
 =?utf-8?B?TzA4MjJrakVCMmwzL0xuWGpGdFhIS1h6elo4dmUzZ0tzQThFQ1dsSEg1OCtW?=
 =?utf-8?B?b2FmbVlNSm5vKzdUWFJCbW16aTAvODQ5R3BweVpDZlNlUlBNcnlrUHdXT2VV?=
 =?utf-8?B?L2xMQXNuSGpWenZNVytCNXNhazRWU29HTWtKZVp1SE83NzlkdGV3eE1PdGJm?=
 =?utf-8?B?SUQ0WjQzWUZtb0I3OWNIc3VKZDlrT1lCNW84ZmN4NExrL2phSm01dGp2Ny9m?=
 =?utf-8?B?TUxSQVpCenBQNzBCWjlIUVFJSkhBV3dNajh1YWErQ2lESnFmOVM3NWE5SUV0?=
 =?utf-8?B?UDZtZmtuSkM3UDRBZyticWxHeTVWRUZUWWpHeDlpQWtvY0RmbHo5akh4U3lu?=
 =?utf-8?B?amN2bHoxN25FYnVRUmZaWlY5c2JwK2R4RlZhMG9KbUZUSDVaL2pPcTdlNXJw?=
 =?utf-8?B?SDFZY0RUVXFqS2tGdlk0eTArOURRejRuZ0gxM1dybEowdXJRRVYxbTRpN3VG?=
 =?utf-8?B?LzZWU0hnVUE3SWNzekJZSXdYYVlMdkFHekV5SkdVQklNdUY4NDI0QUhFVXVU?=
 =?utf-8?B?Yk92VDY5dnAxVDc5M1Rlb2V0bGlPY2J2dDEwaVVldWFQOStjdTA3ZkxsNm16?=
 =?utf-8?B?bTdCRHREWkVnbHJDdHk3aHRVRUR6R3Vrdkh1TWJlZXNoUGo4WUVVM2gvQm5V?=
 =?utf-8?B?VWtwakU2UWpTOXRDQlUxRkM2L3MzdkRVTXY0eE1PV1hYc25ocEp1dmswdzhF?=
 =?utf-8?B?TGdNY2tiL0psZW5wa0loRFIxODVBZFgyTjZnRzdJN0o0bnBIRW04VkxIVzg4?=
 =?utf-8?B?dXVaSkdBTWJGZFlqRlVHdmNQWGdEeW1rYmU5cjBZMTByeXFtSmpRc016V2pM?=
 =?utf-8?B?VjRCdkptdG84YlRDRlBFZ0pXVVpNMVZvOHFMUmVteDJhNW9UQ0ZPM3ZEaDQr?=
 =?utf-8?B?MW1MMGROZGRSVTZUOUwvRG9QSlpXNlhJVUZqSmxyQ1pFV0FRNkFCaDAxVDNj?=
 =?utf-8?B?cHdWTzdIYnFSTmRqZzBlK3YzNkVXRG9pVzVkTFRESk83eUdQMmlrU1JES20v?=
 =?utf-8?B?T0ZEUXlMWDJ5Um9UUGwvUU0wTUR3YURUT29qeUtlTEtZK3FXMWswNzI2YzMv?=
 =?utf-8?B?QitVem5ZdlV2bFRvQzFBRU5BM3BBcHRnQzFkUTRHaWNYRmlYNCtURzF6bDlU?=
 =?utf-8?B?U2lMSENGL2tnMGY3cThweW4wQ0NjcWdmcStFeFZ3YTFZb2k2cGZEcWxiVkRr?=
 =?utf-8?B?b3l5L2pCR05wZnovN3JacW01V3o2UHQraFRwZXlHcFJDK1dKS0lib2g1Mkpt?=
 =?utf-8?B?MndHRWtidmVDTm1vMUZiN2pGM21XYk93VGxNdDU5N1RiU20xYkVza0NoQm1u?=
 =?utf-8?B?bW1PeEY0Z2NLd01QNlBhbGNlNnVsZVJxRmlrNTFBMk1NL0VDZlVqbGJsVUVJ?=
 =?utf-8?B?VHd3d2tta3JYNnBlUWZMeWNUa0dEVDZnaisydHhtQVA1RmphaXNQem5rcGtG?=
 =?utf-8?B?emtGNDByUVQxN0xZWDJ6YlBpNmYzeHBCaGNLcGZwdXlMV1M1OTJqY1VRWm4x?=
 =?utf-8?B?K3ZJS3lDUngwNVhXWTQyK3Y5b1ZGaGErcGlHWEcyaVp2aEpTb1FQNS9GQnlO?=
 =?utf-8?B?ZnNuWjJKQUluKzRhRUtGWGlaTGY3Ti94TnVINDNWaGZVaHpvWXRGWDNWdDlX?=
 =?utf-8?B?cTQrZ2xFNGJ6ekJSVUpDRUw4TFRWVit1WTBLVXI5L2JsVnY0WTlWQ285TXBz?=
 =?utf-8?B?MDVlNHJiS1ptOTh6MHVrdjY2RFNWWjJrNnhJV3F3YkVUTXhrNDlJQzM2aHlZ?=
 =?utf-8?Q?bBiOuxKFqc1S+DV4QCepScQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ffb1ed-b036-4fe5-6884-08db0f7e4bf0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:58:52.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIarrdR8PshN17mbbcEXQdtoGbPU1krjxTw6GyoEJeulLgyrq+5oGS6IqAEdYEmR5k+PMHct/aKcpZ1Rc6PmoCsZoVQcy/0a9ph+KU0hudE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7447
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Wed, 15 Feb 2023 15:33:09 +0100

> Xsk Tx can be triggered via either sendmsg() or poll() syscalls. These
> two paths share a call to common function xsk_xmit() which has two
> sanity checks within. A pseudo code example to show the two paths:

[...]

> @@ -627,17 +618,31 @@ static bool xsk_no_wakeup(struct sock *sk)
>  #endif
>  }
>  
> +static int xsk_check_common(struct xdp_sock *xs)
> +{
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return -ENXIO;
> +	if (unlikely(!(xs->dev->flags & IFF_UP)))
> +		return -ENETDOWN;
> +
> +	return 0;
> +}

It's called several times in the code. Have you tried marking it inline
and compare the object code? I'm worrying a bit some beyond-smart
compiler can uninline these 4 lines and slow down things for no reason.

(it's okay to have inlines in C files if proven that not marking them
 hurts a lot)

> +
>  static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
The rest is:

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Thanks,
Olek
