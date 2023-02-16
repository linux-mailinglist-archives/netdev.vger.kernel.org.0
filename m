Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9084699C18
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBPSV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjBPSVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:21:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D855034B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676571683; x=1708107683;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9qMOib0QoLbVhfdYKGL3KTl2bn5FL/utt4lJ9XkP114=;
  b=G05QcP8IBcl1KPDCcINGC8egkWR/607SIjZsHiHW4RnJ+r5XD+hVPn37
   B2/bz7hoVzORXTmbcDDrj0pLHMg7ba2q7ssq+E1S/LmV6jzqj3iAcT9SF
   quov89YTDbtLP5soYwQWUb5WvweiukafsGXxAFn8Yq5zOKp0i6Vnj0Fe8
   hULVZjofD1r6wSBLl4HJ3M6DRjTGEt/Y+s0JjjGuZXSmZKDII6tQJU+0n
   rS4PFT9HPfW/u9iKKciOtnOeagZz6+zDjQcj7bDSmi+jEPkg/yvNYXSMH
   Hlik2iiBwlFw9UKaVjQBPh90Gp5PKtR2fHbuNlzPJN8kXLreN1ZqT2+Eg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="319890892"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="319890892"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 10:21:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="794137269"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="794137269"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2023 10:21:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 10:21:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 10:21:20 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 10:21:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT78uzU/eFlpua1dSe1lNLFyhCcaWcA0cCNudIPY1OMLpLiBbdHNIFaVGaeZGXP1YK81UULrJ0O+4gH/AyDGGLaah1vIs9Yg8oecRoxHwjGiwCpEQ1r9D9GkeLlkppFXmWYcaQeh2SaFdX3NLCrMFaqO1zLH+YoKM8UnFiRY4ntL4YCQxFoPOjW+cXKhL9TlJZixSA29fGkQZwiSApdBQTbmHROJNzd2DjROb9xX2737vMOC6o4MzGz1wReP1YFlsgw0/8Zw5ODhN/6pD9joRXjkqdeMV045WY5o2Yemrwjt+oiTKpQGcXgMlFuwwt1yQij/+nuusSKeLOo04YwlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzze0usli9JM8Jv0h2/4x6K7v8NwgdTXmsc8/VnRzB0=;
 b=LZHzGo9TLXmS4S7I6wheUAVGstqEOhWg2YPLHP1qH6YVofwiF8fKeeGOSuoGoNe7RMqHidL0iKgBGE0sgPi+xu7izC8kYG/aCTdkuGD/857TxAEpNiaEqeKUtGdlq6eICPyybWwto3BPrqLBihD3q/u+XsCTFdNFSarHlTmRwU8gpJ1wfuwWMSSb1zC1gDd//LoDoAWOFOjRb0WbowIaifWNJX7W6vu5S8K6Bi3WN0g1BcD95FFw0FiUE4JSvl7hzsNaqa2ls6IW16EckU3+FXR7/QbxKsijAO5gAxoKdxkkEIvNrmCcSneZyDtC1YcBGJVnfgvgWqF841J/FpMkUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6689.namprd11.prod.outlook.com (2603:10b6:303:1e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 18:21:18 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 18:21:17 +0000
Message-ID: <e4863729-4ddc-f6cc-85f2-333bd996fc6a@intel.com>
Date:   Thu, 16 Feb 2023 19:19:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 1/2] net: flower: add support for matching cfm
 fields
Content-Language: en-US
To:     Zahari Doychev <zahari.doychev@linux.com>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hmehrtens@maxlinear.com>,
        "Zahari Doychev" <zdoychev@maxlinear.com>
References: <20230215192554.3126010-1-zahari.doychev@linux.com>
 <20230215192554.3126010-2-zahari.doychev@linux.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215192554.3126010-2-zahari.doychev@linux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 086234d5-6e37-4299-4076-08db104a987b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +mNHUD7RUhfMqSTBpWPOsxSqZtI1u56MtPX/rftdzVoHgyCaE4NfwgvhYVjZLuNz60OiNx+U1CwttxJrC1u9LXkcHf4ALAv9SpATjT7nKEN2z7PzCttoORn6bMIhIO1rZlDLTu8/vbn/zelb8/Cko37HNd8PZibt4xkpV8k/jb2r/bgx3r79t8+Yfgdj7e+9bEagWbgXVVrEdOamROnwnPc0Oi3Axr4EVBpewRKLd8jjSUG1upsGSQhKdvwEfg1me3bcIZH+P+sxlFG58wI2GBlP4cqbSVDnFxRRvPob9ueuek+BPETvkYNshQPbm9LQRdiZKVXC+r2RavpjAU0024eOIAu3+zIiMzzMIAoaQwZ82PDSMd3oUXBTJAXGymlNUdCOed+PvLkl5yy+1WS+foRxD7+EepN/Hfkp/+Z788qDGkhKXM/WEgJYdXR6W7QNBmuBqcZDGxLqSSBfXsyHF2EfvvVQqkLV9sH4VTlnPiqrBWsE88Sc6ZpaX4h9PWpZi9XKYeUE7XoWyTrdKyRZLonlxv0mFRAlR7VEmpr5fZHNuKEd4e+kYzf4/WZini7BK0wxxV803/JrOPrrs+yZERxAwqNLoT51PVF6QGKs6RdCoxhxWyVy3BKCmM3yZPGU7NVAyRnw9j6eHJhtFg6v3FWcidEhMusfu1E0kde+oem/z4LuN9GmLh6juxynWfXsHxGbmW4+2/xfSrmkc0escvVad39Ghoero4W5cSg2Y5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(30864003)(5660300002)(6512007)(26005)(7416002)(186003)(31696002)(41300700001)(82960400001)(6666004)(38100700002)(36756003)(66476007)(478600001)(6486002)(8676002)(66556008)(6916009)(66946007)(4326008)(8936002)(6506007)(2906002)(31686004)(83380400001)(316002)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjNQMHhPUDk4bC9BSllLWnB0Z0JPYWtUNGZQZEFQQVFZeEpDWVRhODlQc1l4?=
 =?utf-8?B?ZHZ6cWlCa0ZJQjk4T0szU2d0TWNTL3E0UlpMZGREbEZHSFpSYjNlS1FsajZn?=
 =?utf-8?B?S0IvUXl0L1ZGeExoTlJqTzdjbFNnbnU2YndlMXhhbWZHYUZveWNjeVRVU3p2?=
 =?utf-8?B?OTR0WjdFb3FLN1Y5OHpIWXRPRlgySHdtUmcvRytURkNvUnhzMVJQL1JacmZz?=
 =?utf-8?B?RStzclIyeTZtejhyTnkwbWdyd0NwR3FyY2QyNnVzT1hhSmJ1cjJVZktyTFE3?=
 =?utf-8?B?dGRKTWZaRFQ5U1VZNTliVUJIWHZ0ejAzVEl0c2hQdmlyMGxzbmZVQXpNZjhn?=
 =?utf-8?B?WmJpclkvQnNuZFdqaWIrK0RYNC8yZGlTRk9QM1VoQmRIeTgxSTl6QXNUZVZy?=
 =?utf-8?B?UFU5SGVPU2M5ejN1Zlp4YWpqdFFmRWxXbENSSFV3OGlvMEFyODg3Q2tsY3Fi?=
 =?utf-8?B?cmlEcFo3cnpDU0N3dnhlZFFaY1kvNWxVc2txM0tua2k2UG5zYWwwQzIwR0ts?=
 =?utf-8?B?eUNpZzFCNXBsbE5jaDVnREF3WFR5OWoxWlBOUncwbGE3WlpmVkFzSjh1Vm1R?=
 =?utf-8?B?YWZ3TTFmQnhXNWhQeWkxOVZjaXRRRHBra0hUeWdCbXhsblp3K1RaMWlNbHNO?=
 =?utf-8?B?dEt6OVZuR3ViSUc2Y1NLb08xV3VldGVhUjFiZG5LVVhFOVlDU3dIcTZPbUN3?=
 =?utf-8?B?Q1IyNHpoVFBaYm9Sai9ITFZ6Um9mYzhDdFEwQjVXbWwzczMvR2xyb2tLNWk3?=
 =?utf-8?B?UGt5UHp4bVcrVW5sMXFDQ0RvRGtlOHRFakNZRy8xTWRLeFc4c1EzUkRCOE9m?=
 =?utf-8?B?N3MwVjI2ajdUUmwvVjFXc3hrVTlTMUgwc1dPejJRWVlFbmplU2c5RFhjbHUv?=
 =?utf-8?B?RHdNdGJKODh1aEU0RVN1b21Ba0huMmlFbEFVTnVETE5USDJVSzZxTE1LZCta?=
 =?utf-8?B?aUQ5VE00UG1lRjJMcGZhRHpUVTNWY1NKbmcvQUZUclhqUFhCVHlDUjhRQm9i?=
 =?utf-8?B?cDg5cWg3QjZEbjlNM0FSd3JqVmNFSVQzSE5CSVJTaGV3dHpUV3FzaVBBNFlS?=
 =?utf-8?B?S2NGdTF6TW4vamhiajNIRTZzZFNxSS9rRnpBRFExajFndGVCMUtVTjUxMC9a?=
 =?utf-8?B?OVBDOHNxYmpDY051aFJWM0xjK1ZKM2oyL01WVld4bzk2R2hQVTJGeTcraTIv?=
 =?utf-8?B?MkpMd1dCd3hOZC9SSWR4U1o2eUtEa1llcitHeFJnTnBzNG82U3ZTak9RQkg0?=
 =?utf-8?B?RnhyU0diNW44YTkzQTdNTHg3NWJqVnpRcFYvSUlqcGcvZE9yTTFhTTNCZFhY?=
 =?utf-8?B?ZXgwRUk4bkRSRnhsK25jVXVPZGhFNjlSNUFleC9CQmFwejYzNUhxcnJEUWpX?=
 =?utf-8?B?TkwrbEgvcXFld2pnc21XM2R5bjc4TmRkNGNLeTZqSld0NHdUd1Z6ZTQ2Mncw?=
 =?utf-8?B?L0RUMmt0b0RsWENPT1poSnVQMC9KMWJoeG1aWlhIOTkyaU56YTE2RkVGR1Ax?=
 =?utf-8?B?aVpEeVVvMHlxZzZWbGFDUUFpVkl5cGppTGt6QWhHTzhpR2M2RHJzaVAzWUx3?=
 =?utf-8?B?ZFVCYWxMbHcxeURBa2lwWkRXMHhVaVdmNlM0MVFza0ZsdEFlVFlMR1MrN0F0?=
 =?utf-8?B?c09Nay92SXF6VEcyVVpKSkU3QXV5SkN3WHRRYjFZQ3hSYlBGOWZuSHhzbjZm?=
 =?utf-8?B?WHJJT3RSeEwzd0svME1xTUNIVzdOb1c3aTIzNDZuU3kyeVpvQlFUWnVGY0Fy?=
 =?utf-8?B?MTVmVnU0RVBubWxqQ1B6R1p5QzVWcnVrRXZ3K0F4NFdXdkVNcm9GcVpTRzRR?=
 =?utf-8?B?Y3JTeDZjd0Flemx6djFxNXFDSTZXZytmd0gvcVVXWlpXOHdnR0o0NHBDQ1Rl?=
 =?utf-8?B?bDM2WmY0NU41ekpYeG1EYm5wQ3VpZ3ptYVk1UnpRcnI3NWFLcDZYeUxvUEg1?=
 =?utf-8?B?dUsxb0RPVEpEc0xGcm11blZZc0JpVTFLTmRLdjNDclNJb1pzZkY5alZZMXAw?=
 =?utf-8?B?OERKcTVLRWFLU1NyTmFndGlpNDEzRDhDRG1XOGpJb2QvSVc3SXF4Z0ZkaSth?=
 =?utf-8?B?WjduTG5qclZDaUZvRVhMc1I3eG1heEFUV1lKSmx0aXE0Sytnc2QxemtpaGdC?=
 =?utf-8?B?WWdrd09lNmMyVll5QnpoM0g1anhQL1RJTjA5a2Q4ZUtDUXd1YzdVcldGUzIv?=
 =?utf-8?Q?+q8vFcWbmz4+UC2WedwbYGQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 086234d5-6e37-4299-4076-08db104a987b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 18:21:17.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNYKP28qlqM5u68vPJx7jmJ7c5BlYdSjl8N0YJIeB8+lScbLrV2EUgG1frDPB9v/fkIX7H3b4V86hKO1xGeebwwgImU8K+kpqueDBTs7FrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6689
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

From: Zahari Doychev <zahari.doychev@linux.com>
Date: Wed, 15 Feb 2023 20:25:53 +0100

> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> ---
>  include/net/flow_dissector.h |  11 ++++
>  include/uapi/linux/pkt_cls.h |  12 ++++
>  net/core/flow_dissector.c    |  41 ++++++++++++
>  net/sched/cls_flower.c       | 118 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 181 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 5ccf52ef8809..a70497f96bed 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -297,6 +297,16 @@ struct flow_dissector_key_l2tpv3 {
>  	__be32 session_id;
>  };
>  
> +/**
> + * struct flow_dissector_key_cfm
> + *
> + */

???

Without a proper kernel-doc, this makes no sense. So either remove this
comment or make a kernel-doc from it, describing the structure and each
its member (I'd go for kernel-doc :P).

> +struct flow_dissector_key_cfm {
> +	u8	mdl:3,
> +		ver:5;
> +	u8	opcode;
> +};
> +
>  enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> @@ -329,6 +339,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
>  	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
>  	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
> +	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
>  
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 648a82f32666..d55f70ccfe3c 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -594,6 +594,8 @@ enum {
>  
>  	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
>  
> +	TCA_FLOWER_KEY_CFM,

Each existing definitions within this enum have a comment mentioning the
corresponding type (__be32, __u8 and so on), why doesn't this one?

> +
>  	__TCA_FLOWER_MAX,
>  };
>  
> @@ -702,6 +704,16 @@ enum {
>  	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
>  };
>  
> +enum {
> +	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
> +	TCA_FLOWER_KEY_CFM_MD_LEVEL,
> +	TCA_FLOWER_KEY_CFM_OPCODE,
> +	__TCA_FLOWER_KEY_CFM_OPT_MAX,
> +};
> +
> +#define TCA_FLOWER_KEY_CFM_OPT_MAX \
> +		(__TCA_FLOWER_KEY_CFM_OPT_MAX - 1)

This fits into one line...
Can't we put it into the enum itself?

> +
>  #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
>  
>  /* Match-all classifier */
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 25fb0bbc310f..adb23d31f199 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -547,6 +547,41 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
>  	return FLOW_DISSECT_RET_OUT_GOOD;
>  }
>  
> +static enum flow_dissect_ret
> +__skb_flow_dissect_cfm(const struct sk_buff *skb,
> +		       struct flow_dissector *flow_dissector,
> +		       void *target_container, const void *data,
> +		       int nhoff, int hlen)
> +{
> +	struct flow_dissector_key_cfm *key_cfm;
> +	struct cfm_common_hdr {

I don't see this type used anywhere else in the code, so you can leave
it anonymous.

> +		__u8 mdlevel_version;
> +		__u8 opcode;
> +		__u8 flags;
> +		__u8 tlv_offset;

This is a purely-kernel-side structure, so use simply `u8` here for each
of them.

> +	} *hdr, _hdr;
> +#define CFM_MD_LEVEL_SHIFT	5
> +#define CFM_MD_VERSION_MASK	0x1f
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
> +		return FLOW_DISSECT_RET_OUT_GOOD;
> +
> +	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
> +				   hlen, &_hdr);
> +	if (!hdr)
> +		return FLOW_DISSECT_RET_OUT_BAD;
> +
> +	key_cfm = skb_flow_dissector_target(flow_dissector,
> +					    FLOW_DISSECTOR_KEY_CFM,
> +					    target_container);
> +
> +	key_cfm->mdl = hdr->mdlevel_version >> CFM_MD_LEVEL_SHIFT;
> +	key_cfm->ver = hdr->mdlevel_version & CFM_MD_VERSION_MASK;

I'd highly recommend using FIELD_GET() here.

Or wait, why can't you just use one structure for both FD and the actual
header? You only need two fields going next to each other, so you could
save some cycles by just directly assigning them (I mean, just define
the fields you need, not the whole header since you use only first two
fields).

> +	key_cfm->opcode = hdr->opcode;
> +
> +	return  FLOW_DISSECT_RET_OUT_GOOD;
> +}
> +
>  static enum flow_dissect_ret
>  __skb_flow_dissect_gre(const struct sk_buff *skb,
>  		       struct flow_dissector_key_control *key_control,
> @@ -1390,6 +1425,12 @@ bool __skb_flow_dissect(const struct net *net,
>  		break;
>  	}
>  
> +	case htons(ETH_P_CFM): {
> +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> +					       target_container, data,
> +					       nhoff, hlen);
> +		break;
> +	}
>  	default:
>  		fdret = FLOW_DISSECT_RET_OUT_BAD;
>  		break;
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 885c95191ccf..91f2268e1577 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -71,6 +71,7 @@ struct fl_flow_key {
>  	struct flow_dissector_key_num_of_vlans num_of_vlans;
>  	struct flow_dissector_key_pppoe pppoe;
>  	struct flow_dissector_key_l2tpv3 l2tpv3;
> +	struct flow_dissector_key_cfm cfm;
>  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
>  
>  struct fl_flow_mask_range {
> @@ -711,7 +712,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
>  	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
> -
> +	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
>  };
>  
>  static const struct nla_policy
> @@ -760,6 +761,12 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
>  	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
>  };
>  
> +static const struct nla_policy
> +cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX + 1] = {

Why not just use %__TCA_FLOWER_KEY_CFM_OPT_MAX here which is the same? I
know it's not how it's been done historically, but anyway.

> +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
> +};
> +
>  static void fl_set_key_val(struct nlattr **tb,
>  			   void *val, int val_type,
>  			   void *mask, int mask_type, int len)
> @@ -1644,6 +1651,67 @@ static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
>  	return false;
>  }
>  
> +#define CFM_MD_LEVEL_MASK 0x7

Can all those definitions be located in one place in some header file
instead of being scattered across several C files? You'll need them one
day and forget where you place them, some other developers won't know
they are somewhere in C files and decide they're not defined in the kernel.

> +static int fl_set_key_cfm_md_level(struct nlattr **tb,
> +				   struct fl_flow_key *key,
> +				   struct fl_flow_key *mask,
> +				   struct netlink_ext_ack *extack)
> +{
> +	u8 level;
> +
> +	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
> +		return 0;
> +
> +	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
> +	if (level & ~CFM_MD_LEVEL_MASK) {
> +		NL_SET_ERR_MSG_ATTR(extack,
> +				    tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
> +				    "cfm md level must be 0-7");
> +		return -EINVAL;
> +	}
> +	key->cfm.mdl = level;
> +	mask->cfm.mdl = CFM_MD_LEVEL_MASK;
> +
> +	return 0;
> +}
> +
> +static void fl_set_key_cfm_opcode(struct nlattr **tb,
> +				  struct fl_flow_key *key,
> +				  struct fl_flow_key *mask,
> +				  struct netlink_ext_ack *extack)
> +{
> +	if (!tb[TCA_FLOWER_KEY_CFM_OPCODE])
> +		return;
> +
> +	fl_set_key_val(tb, &key->cfm.opcode,
> +		       TCA_FLOWER_KEY_CFM_OPCODE,
> +		       &mask->cfm.opcode,
> +		       TCA_FLOWER_UNSPEC,
> +		       sizeof(key->cfm.opcode));

I think at least some of these fit into the previous line, there's no
need to break lines just to break them or have one argument per line.

> +}
> +
> +static int fl_set_key_cfm(struct nlattr **tb,
> +			  struct fl_flow_key *key,
> +			  struct fl_flow_key *mask,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *nla_cfm_opt[TCA_FLOWER_KEY_CFM_OPT_MAX + 1];
> +	int err;
> +
> +	if (!tb[TCA_FLOWER_KEY_CFM])
> +		return 0;
> +
> +	err = nla_parse_nested(nla_cfm_opt, TCA_FLOWER_KEY_CFM_OPT_MAX,
> +			       tb[TCA_FLOWER_KEY_CFM],
> +			       cfm_opt_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	fl_set_key_cfm_opcode(nla_cfm_opt, key, mask, extack);
> +
> +	return fl_set_key_cfm_md_level(nla_cfm_opt, key, mask, extack);
> +}
> +
>  static int fl_set_key(struct net *net, struct nlattr **tb,
>  		      struct fl_flow_key *key, struct fl_flow_key *mask,
>  		      struct netlink_ext_ack *extack)
> @@ -1794,6 +1862,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
>  			       TCA_FLOWER_KEY_L2TPV3_SID,
>  			       &mask->l2tpv3.session_id, TCA_FLOWER_UNSPEC,
>  			       sizeof(key->l2tpv3.session_id));
> +	} else if (key->basic.n_proto  == htons(ETH_P_CFM)) {
> +		ret = fl_set_key_cfm(tb, key, mask, extack);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	if (key->basic.ip_proto == IPPROTO_TCP ||
> @@ -1976,6 +2048,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
>  			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
>  	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
>  			     FLOW_DISSECTOR_KEY_L2TPV3, l2tpv3);
> +	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
> +			     FLOW_DISSECTOR_KEY_CFM, cfm);
>  
>  	skb_flow_dissector_init(dissector, keys, cnt);
>  }
> @@ -2984,6 +3058,45 @@ static int fl_dump_key_ct(struct sk_buff *skb,
>  	return -EMSGSIZE;
>  }
>  
> +static int fl_dump_key_cfm(struct sk_buff *skb,
> +			   struct fl_flow_key *key,
> +			   struct fl_flow_key *mask)
> +{
> +	struct nlattr *opts;
> +	int err;
> +
> +	if (!memchr_inv(&mask->cfm, 0, sizeof(mask->cfm)))
> +		return 0;
> +
> +	opts = nla_nest_start(skb, TCA_FLOWER_KEY_CFM);
> +	if (!opts)
> +		return -EMSGSIZE;
> +
> +	if (mask->cfm.mdl &&
> +	    nla_put_u8(skb,
> +		       TCA_FLOWER_KEY_CFM_MD_LEVEL,
> +		       key->cfm.mdl)) {

Also weird linewrapping.

> +		err = -EMSGSIZE;
> +		goto err_cfm_opts;
> +	}
> +
> +	if (mask->cfm.opcode &&
> +	    nla_put_u8(skb,
> +		       TCA_FLOWER_KEY_CFM_OPCODE,
> +		       key->cfm.opcode)) {

(same)

> +		err = -EMSGSIZE;
> +		goto err_cfm_opts;
> +	}
> +
> +	nla_nest_end(skb, opts);
> +
> +	return 0;
> +
> +err_cfm_opts:
> +	nla_nest_cancel(skb, opts);
> +	return err;
> +}
> +
>  static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
>  			       struct flow_dissector_key_enc_opts *enc_opts)
>  {
> @@ -3266,6 +3379,9 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
>  			     sizeof(key->hash.hash)))
>  		goto nla_put_failure;
>  
> +	if (fl_dump_key_cfm(skb, key, mask))
> +		goto nla_put_failure;
> +
>  	return 0;
>  
>  nla_put_failure:

Thanks,
Olek
