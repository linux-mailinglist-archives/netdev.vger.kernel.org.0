Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C755B6EAE01
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjDUP0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjDUP0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:26:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE6210248
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682090808; x=1713626808;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VOPTJd5v+0pwFzYgvDFlFbHsujDW9vy0TYLy9Twejl0=;
  b=DO2Gf4YM8JrWxtGZJQkD2Vlz/ul2S7bv5Wd9keRJba42+7BRfxRTpOvx
   lSo8zjhk76K/7v5mq4pbV9YVZDcYkw/630Xg7YXxcT9nwtmfzAbDD3y1z
   5eYIFwKUJMhdA4vIVbHiHTEOHdW1l8W9iclLkjbZQzgn43gN6h9vAdrFt
   eeEVhip9VfZb/NCmwc26alRPPaXM0vF0vOs+/T/16YC5RZgcNph/Sgwmw
   QQY7j9lvCfoBpPLOrKISUxDEXz+/Lc/dOMKGLR1Y3PbQik/rRAetunTkY
   KCFRj+hWUCJlcuVD2E7yynCtvroAMrWbJaASIB++/9YvTbU8bMfu0G0Fk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="325616092"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="325616092"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 08:26:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="642544280"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642544280"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2023 08:26:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 08:26:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 08:26:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 08:26:47 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 08:26:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+hw1nKQOiDiauGNgULgCbPS2GE4wJvWwcfT8KT+VindeqNfab1Ia5Jd4AueUZuR46scpTxRjb/fI8OP29ROrQ2pSYarXDcdelqcnfbMJxxvQ/Z+XK+tPu8QqUgc3VBMWJ7G84WTxO3XomAcB0M0sY+SAGTy/AuZE/0Ym6/GdvSqatvbj5qcSEwUZHeghjRY9LYQhXY5qDgYEdIiP9QfyPvwdJXlXSnoFKvZsP9hBVtomLGAcgfuyS98mLswVegvH8Sf7hAn4HDmuarirs5NLc4/g2XtCioiIc0uCaE9c3HGKgbYWUK4i9JUMIG8Byirouzvl3JKJFNQ3k1vSeLpDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0lgeqXTq0F2N+XU6dwhlICD8HHUk+Y3UzDgG4giQuI=;
 b=TtrknlDIUrJuMSJn9fDkH0Pt2NMxb/oeWVZICfqBQk75UVpPYDY9yXYpL3l4ygLWjX+XVa7PbQGRCjZ/3iVlSEiSc7RiRSaijdb7jlD+SQyoIaYZaGUVHFsxYx/8+dBR//FnL1BOlUtT1a4AkQsJOeOvlSYvlm19wtWAcC02OgESM3+YKQLklRVz/APyx5PM564a+Y9q2kONP5h3e0iv6rFDxxrgTU0qoFSuslRFzUJXU8ArRcYVEuN1hfgaiGL7i0a4cZXUW5bjoEIrNMP6NpA4TGLxYOI5wbNqEm8k2OWCuvMQ4rSQRM6iDEuumyWSk/rEWRUk0BoLWetbw+EwkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5450.namprd11.prod.outlook.com (2603:10b6:408:11f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Fri, 21 Apr
 2023 15:26:45 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 15:26:45 +0000
Message-ID: <d3cc5703-bc8d-9e5e-c354-94dde3b1e91c@intel.com>
Date:   Fri, 21 Apr 2023 17:25:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev
 mode
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <david.m.ertman@intel.com>,
        <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-9-wojciech.drewek@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417093412.12161-9-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0180.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::24) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5450:EE_
X-MS-Office365-Filtering-Correlation-Id: e2e99225-f27c-4f36-5b69-08db427cd091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WAuHg6JR9kPrJP0CTw09/Loprl44Yzk3nudeVeyAMHBgQysBNPBpjUwtRHWrx3zxyXKduRYs3S+HRi6XqqTZSpYcrKHyXjSF8YfPCb02ZD5s9I0vdPFM0zkhrr8GOTXebkHWHl5CIWFWEtrxzn3kdvWrbmO/WWIrQ8wOxh5fugjDLt7hDjYallKExhMXYxpK6s8bhnYc2SXR8enngdN65Zdu3n3DrsuMRFxPvT/153LeFsPbWeQZ51yz9gqSwmzojrElxNdoVl9d3jDMUZBlvKxi+A4ynTwYMyHX3XFwsrOz8igL66w03lPx9caM32UJ5zi/j7gaIQoYsBV/XW9dOoYdcLZg61tVM7TvDni3vbEloqbxrhyVKDqPAyBSfCkTE4+4Qx7lZfQaU9i1zNLsjvzZPgj+qAWuH4uVNPB8NFSYVnsYb13NMOptkB8PZyV3212YGW6jPPShr+doSTRXtzDHyDuPctcmjQG1LdFxy82b6DMM1D62hEOkRgKcH+LBE2L6FZAIdwCXcq0pU0UOG4MxMwgX38/Z1IsvEsDNCG5MXprik2jzYTkWOiOpAS6+I2ieOBdJdbHPwSqH+eo4cqU1StTFzBc4o2Rz/i6fzNj2MYxQIuLcURbr3t5xU4zwey5M9cBc1ZSYr1/qaxfH07JkPrSkQQ98MJYs6XMEvSKpKt1xdQ5CVr/74QxKDIX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(316002)(66476007)(66556008)(37006003)(4326008)(41300700001)(6862004)(6636002)(2906002)(66946007)(8676002)(82960400001)(5660300002)(8936002)(83380400001)(6506007)(6512007)(6666004)(26005)(186003)(2616005)(6486002)(478600001)(86362001)(31696002)(38100700002)(36756003)(31686004)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjlnZXZDcEdUK3dTZXJpdVVCWm9nYlBWRVB6dG1xdkdHTFp5aklnWDFtRmov?=
 =?utf-8?B?RmR1R1Jvem9OSC9OTXB2SnExQ1hodmUzOGRoazhFb3hjMzhDTldmK2I1V0l0?=
 =?utf-8?B?MHY3Z0xJT2RFSXppWkhucFFUditUV2NmT1ZObmtuZ1pnQi8vMzE4UE5RVVRG?=
 =?utf-8?B?aW8wOUhMaThJL0ZiZkZDaUFvLzlUMmRxUFNEdG5WTmFOT2pPckZHQjMvUk5G?=
 =?utf-8?B?REN2SGRrVXBpK0VoV01KT2hFN0NweDdDZm5XSktxdUpTNnF4SWlhU2pOb3Za?=
 =?utf-8?B?aUlHcGUzbHRBMVp3cVI0bzl2YVZqYWhCdWNpNDV6c1U0ZlNnaXF2UnJ6Zkkz?=
 =?utf-8?B?dFZRWG5MR0Q3RFhwTm1BaXZkdEF4Ui9IeTdUSTUxUlhMdUI5aEtHczNlRENr?=
 =?utf-8?B?MFp6N0Y2ZHR4MEtyOWh2K1NLQ3ZMeEJLMHpTNzZiTGx2clpZWXZGMDR0ZzBI?=
 =?utf-8?B?MXdHMGRHQzhoRHZvR3F6WEg3SFFhYXlPSEVNWmRVQlQxU2tOT2p2NngvMlBM?=
 =?utf-8?B?NXloaWVSZ1lxNkZjZlFiVThEdkJhMWJhNVR6RFlrVGdaRERXK054ZldaLzYz?=
 =?utf-8?B?d1JLZThiWHNzeFVSZnlNb2tXRy92QXI3MXI2NGFZZnhpc0NvTDFudENwdjNL?=
 =?utf-8?B?cnFUMjlqc0p2OGJwYWJvNnlnU0JWYU9HNnhsbzVXUXdVMHFxWm91a2pEY2dV?=
 =?utf-8?B?aVc1aTdiTnBON0JmL2IxM05IMWI5TERJZWp0QlNvTFRRaDA5MTE0NFNSbEhr?=
 =?utf-8?B?YzhYekVPRFMvNEh5cTM1RzJlaHp6NktkYzFDOTNSVWlpTUM0YjErZkRnOHFl?=
 =?utf-8?B?eEdpMmxjNGFIeENVampRTGt3Wks0aGFxRmdDanFZRWtxcExsUGlpM2Z2MVc0?=
 =?utf-8?B?K2NDaWVHQ2lmekpwYk51Tm91ZjJUWnpGWHFTd3F0d3E2NzRyNDloOFlLQUpa?=
 =?utf-8?B?bzlEYVVVckNVckUzK1Z1MXlBUTJrb1QzUEw2MHdtTUlZaXJKNzdNcGZrSTMy?=
 =?utf-8?B?TGc0Rk8rVlB5RXFlRUNyNWtMdlJEcitERVJraUo1K002NHlZR1A3VWdBSlNU?=
 =?utf-8?B?THc0NEFsUk53S1BYV3NnUEYwbnVCOXkxSG02OUdkNFQ3emJ2aUMxTWxQdWFM?=
 =?utf-8?B?a2gxaG12NlBLU2xXL3QyYWdUYThzaktSV2hHNDVYY014R00rbXZOY2tpK3Z4?=
 =?utf-8?B?a2JWb00rRFJHN3ZRVEl5Mi9Zb3BCR3FTQnZkRlREZlBzRzBwelM5RlE5d0xU?=
 =?utf-8?B?TjlSSnBBSmFmUTAydjRDWm9KMm55UDdpTUpDVU5SZUc5QXNYaWRnSThUSFp1?=
 =?utf-8?B?bEFEZGhoMUlXeUtuSmsxek9SdEY3R3g1RHNDKytnM2VvSE51Z3ZXUFlJRG9O?=
 =?utf-8?B?bEh0TEJRSVZ4c1RLaS9HM2lEa01EODFKOXZkRFJPcU9UcFJKUmJIa0l4OGRt?=
 =?utf-8?B?WVFHVzVlNWQxSkJ5NFVPdHBCdEJTT0dGTlpYSktHdEtsaE5FbThaY05XZ3Ey?=
 =?utf-8?B?cEoweUNTVGlMNTQxdFlNNExEcWNTRTF0STNUbkpLT29rUkY4bEVMK3JTR1ph?=
 =?utf-8?B?b2lNWmIxTE1LcmRWVWxVZEFRNDVqSGJOcHI4U2pJajlhZElPelpqbVAwYzRM?=
 =?utf-8?B?NmRBNkdpVzduUHVmKzloWXprb1B1ZEl5eDlCaFRQNWdEbXRCZXVQUkNDd1Bp?=
 =?utf-8?B?WnYzV1FwbU1oRWcvcFI4M2x5NGY3eGgzUm9LbHV3ekU3S09KUFJCRVNJV3Vo?=
 =?utf-8?B?ZkdzNnJnZFhuaXpvSzhGYVpBRGlXNWtsL1c3dE04MDJWdUlxeHlhTGllQmJD?=
 =?utf-8?B?aXVNRU95NThsaExaZ1RpRFdNekJsOGM4TkFMQTlXOHRoVk9YaVlKUXNHMnhZ?=
 =?utf-8?B?bFZMb3Z0eFpobThPUEc5OEV3TmozRFVsNzFrKzRyek9sRFF6WU1RSWFhMjkv?=
 =?utf-8?B?Z2dsSnZKWmc5ZmJWMFcvc3Q1UjRMTnljVVVETmoySGdBSVgxSC9ldGk3UGcv?=
 =?utf-8?B?WUxZdVJwVythcVk3dUYvRXIwK1ZjazM2T1ozeHE0T282T0E3RkxsWmVtdTNr?=
 =?utf-8?B?TjFaK29iQVdJa0poaHM2NFNwVEdia0NxNitoR29pR3pyeFh5Z2pHc2szeXlN?=
 =?utf-8?B?eTVKQk1DelRJcjI0U0gwZGplait4UkFMTXl4MGRLM2IwVEVMclB2V01sc08y?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e99225-f27c-4f36-5b69-08db427cd091
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 15:26:44.7336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bXv0LLPhcCMqGdgc1S59IaRHQUY6XWW3MkhgbGfDD/n/mf8SowoO4nuA2DewT0Ad/UX1d+hU9d1T2o2tGbVBf8KVOpRRbGn8DDv/PF5sXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5450
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:08 +0200

> From: Marcin Szycik <marcin.szycik@intel.com>
> 
> Add support for matching on VLAN tag in bridge offloads.
> Currently only trunk mode is supported.
> 
> To enable VLAN filtering (existing FDB entries will be deleted):
> ip link set $BR type bridge vlan_filtering 1
> 
> To add VLANs to bridge in trunk mode:
> bridge vlan add dev $PF1 vid 110-111
> bridge vlan add dev $VF1_PR vid 110-111
> 
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 319 +++++++++++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  12 +
>  2 files changed, 317 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> index 49381e4bf62a..56d36e397b12 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> @@ -59,13 +59,19 @@ ice_eswitch_br_netdev_to_port(struct net_device *dev)
>  static void
>  ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
>  				  struct ice_adv_rule_info *rule_info,
> -				  const unsigned char *mac,
> +				  const unsigned char *mac, bool vlan, u16 vid,

Could we use one combined argument? Doesn't `!!vid == !!vlan`? VID 0 is
reserved IIRC...

(same in all the places below)

>  				  u8 pf_id, u16 vf_vsi_idx)
>  {
>  	list[0].type = ICE_MAC_OFOS;
>  	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
>  	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);

[...]

> @@ -344,10 +389,33 @@ ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
>  	struct device *dev = ice_pf_to_dev(pf);
>  	struct ice_esw_br_fdb_entry *fdb_entry;
>  	struct ice_esw_br_flow *flow;
> +	struct ice_esw_br_vlan *vlan;
>  	struct ice_hw *hw = &pf->hw;
> +	bool add_vlan = false;
>  	unsigned long event;
>  	int err;
>  
> +	/* FIXME: untagged filtering is not yet supported
> +	 */

Shouldn't be present in release code I believe. I mean, the sentence is
fine (just don't forget dot at the end), but without "FIXME:". And it
can be one-liner.

> +	if (!(bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING) && vid)
> +		return;

[...]

> +static void
> +ice_eswitch_br_vlan_filtering_set(struct ice_esw_br *bridge, bool enable)
> +{
> +	bool filtering = bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING;
> +
> +	if (filtering == enable)
> +		return;

	if (enable == !!(bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING))

?

> +
> +	ice_eswitch_br_fdb_flush(bridge);
> +	if (enable)
> +		bridge->flags |= ICE_ESWITCH_BR_VLAN_FILTERING;
> +	else
> +		bridge->flags &= ~ICE_ESWITCH_BR_VLAN_FILTERING;
> +}

[...]

> +	port = xa_load(&bridge->ports, vsi_idx);
> +	if (!port)
> +		return -EINVAL;
> +
> +	vlan = xa_load(&port->vlans, vid);
> +	if (vlan) {
> +		if (vlan->flags == flags)
> +			return 0;
> +
> +		ice_eswitch_br_vlan_cleanup(port, vlan);
> +	}
> +
> +	vlan = ice_eswitch_br_vlan_create(vid, flags, port);
> +	if (IS_ERR(vlan)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to create VLAN entry");

FYI, there's NL_SET_ERR_MSG_FMT_MOD() landed recently (a couple releases
back), which supports format strings. E.g. you could pass VID, VSI ID,
flags etc. there to have more meaningful output (right in userspace).

> +		return PTR_ERR(vlan);
> +	}
> +
> +	return 0;
> +}

[...]

> +static int
> +ice_eswitch_br_port_obj_add(struct net_device *netdev, const void *ctx,
> +			    const struct switchdev_obj *obj,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
> +	struct switchdev_obj_port_vlan *vlan;
> +	int err;
> +
> +	if (!br_port)
> +		return -EINVAL;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> +		err = ice_eswitch_br_port_vlan_add(br_port->bridge,
> +						   br_port->vsi_idx, vlan->vid,
> +						   vlan->flags, extack);

return right here? You have `default` in the switch block, so the
compiler shouldn't complain if you remove it from the end of the func.

> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
> +static int
> +ice_eswitch_br_port_obj_del(struct net_device *netdev, const void *ctx,
> +			    const struct switchdev_obj *obj)
> +{
> +	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
> +	struct switchdev_obj_port_vlan *vlan;
> +
> +	if (!br_port)
> +		return -EINVAL;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> +		ice_eswitch_br_port_vlan_del(br_port->bridge, br_port->vsi_idx,
> +					     vlan->vid);

(same)

> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +ice_eswitch_br_port_obj_attr_set(struct net_device *netdev, const void *ctx,
> +				 const struct switchdev_attr *attr,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
> +
> +	if (!br_port)
> +		return -EINVAL;
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> +		ice_eswitch_br_vlan_filtering_set(br_port->bridge,
> +						  attr->u.vlan_filtering);

(and here)

> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}

[...]

> +	br_offloads->switchdev_blk.notifier_call =
> +		ice_eswitch_br_event_blocking;

Oh, you have two usages of ->switchdev_blk here, so you can add an
intermediate variable to avoid line breaking, which would also shorten
the line below :D

	nb = &br_offloads->switchdev_blk;
	nb->notifier_call = ice_eswitch_br_event_blocking;
	...

> +	err = register_switchdev_blocking_notifier(&br_offloads->switchdev_blk);
> +	if (err) {
> +		dev_err(dev,
> +			"Failed to register bridge blocking switchdev notifier\n");
> +		goto err_reg_switchdev_blk;
> +	}
> +
>  	br_offloads->netdev_nb.notifier_call = ice_eswitch_br_port_event;
>  	err = register_netdevice_notifier(&br_offloads->netdev_nb);

(here the same, but no line breaks, so up to you. You could reuse the
 same variable or leave it as it is)

>  	if (err) {

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> index 73ad81bad655..cf3e2615a62a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> @@ -42,10 +42,16 @@ struct ice_esw_br_port {
>  	enum ice_esw_br_port_type type;
>  	struct ice_vsi *vsi;
>  	u16 vsi_idx;
> +	struct xarray vlans;

Hmm, I feel like you can make ::type u16 and then stack it with
::vsi_idx, so that you avoid a hole here.

> +};
> +
> +enum {
> +	ICE_ESWITCH_BR_VLAN_FILTERING = BIT(0),
>  };
>  
>  struct ice_esw_br {
>  	struct ice_esw_br_offloads *br_offloads;
> +	int flags;

Unsigned types fit flags better I think?

>  	int ifindex;

(BTW, ifindex is also usually unsigned unless it's not an error)

>  
>  	struct xarray ports;
[...]

Thanks,
Olek
