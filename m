Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949786D5D67
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjDDKYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjDDKYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:24:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD6F4687
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680603792; x=1712139792;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JDBFA0qYFmnzsEuFWP7lO+1Y2rv+p/kdULWKSTUZkTY=;
  b=MUDolyC/pNfuKexseoqiiRhXciTJOwnU6RdXYsmYQi91eVv39GeFGTE4
   EllQHBtO2lGlGzxjEFJUQs3X4nzk77INqMcPop9l8mdqm9hwFQX1pV66o
   onn0QIqQYQkcevA9hJCwbbf/nKpeT5UxuhUv5afFV96MgLirYu6YZ8WMq
   7iVBoAOA23vAnzuGE5QZYRivVTpZ5chz7jdrzTOegeqzXXYmYbAVsxqz6
   UDhKa77Wgp3G52aZpgTVMA+2JRnaP4Guoa3l5nYmRaZvkxXyZfr+6wTk8
   miGdyjBAMkw/+iBlG9+1I6Dj2pwtLJRGfgOlCrdv1So7eehm0bTCUFpAu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="344706163"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="344706163"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:22:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="679839671"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="679839671"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 04 Apr 2023 03:22:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:22:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 03:22:48 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 03:22:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqAI0h5LtVPqkjqytEhU867vL9zfDtHRbNl1X6A7Wdhs1UvFftp5C0VTLRY1KGWcvMn4hiFyW2re1387OOaA4T/rlaZIm3OANMfqNy7hyvm34QTMnYKvdY+8DOOTMMyjNEv3Y1ado3XJfhn0Xn3431HnpLziedvN630vaT8PHKNB0opM007qPxTwoDcTB+PmDeZ2EYIe4+JtvXz5oMOTphmIwBqceg3g8imWyAd09DvLQ8Q/xVbVLw2G4dvmuwDLFx5NKdOkNac9uaSPj3Ko0jFLz5WhbW6q1biATl1t6juj7DsaRbdwpSSX5gtLtvqniEOTl9LE6a8+6OXPdpfK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gtr7eQgWs8K6v8JNq0krurjm7Vl650v3YJnxpSMWu5I=;
 b=eRMKJYPFqo6ZmWkEGvRtJpQZ4PhgYLAaPMgmpGgrgwRbv774vy+AHd/XkmD0kfPw2ZlV6nvzOVZkiWrtdXpfI+vT0HDksV/+FVJTTxTzKWEvPpbrF7eoB6cMESWNprPGHUYURKjAfiu+cgficoPJEFM1u0lyxz7ew19rTrIk5ItWqzlWKvoWEOXh7dN6OfFyYHVpCWpc1u8V0KnK7leIKxRnrMAxJB4SmRR2VqjCNYCTU0U98EFpflgHdpMMKmPh/4CErToh32/JJs80z4Pa3Wxg4P6rk3mMV+UzabU4R+NU58aaK3R0IiYMXqiWtrNU7DPe/rNIiDS+cpBUtvvfmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Tue, 4 Apr
 2023 10:22:44 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:22:43 +0000
Message-ID: <2360ed18-d896-4720-89fc-e12e9b155943@intel.com>
Date:   Tue, 4 Apr 2023 12:22:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 3/4] ice: allow matching on
 meta data
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
References: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
 <20230404072833.3676891-4-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230404072833.3676891-4-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0207.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: ce638660-0d63-4821-26bc-08db34f68707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlKdvZTkwEqfS6aWwDXJxH+P1w9it2FhhoCqM5NN6lekmBmvZlUM66QWtuYIlGdBZuWG8H4RYeSYpf2kU/3hC8TPl3VoWd+G15aYae5d8NkednWdLQnv97gA50LsKWJCXn3ze6IWh4LQbIrSmhMqbsBXIc4bXPtE23hOWxGxwG99gROF3Ku4M8Yidn4cfwfIdDkWZMTuX7P4eyY71OdW/b9+ja5ZxoLD2VJ6fUwx6Fc8KY8P7wnMDo5M/BpbWHkq4ixB5B49Rtsq+7KK1nrGtRRWfVD6AUZX+EuKbYdft7yeb1kcQZKJZkf3oWUdLNyCHDGlfOU6O1ZjtDGXNQsKuLUzl2gsA3H5UTtCUP+PkLRIgECoTDkSU0ttBgEVu0cBghYVreyFVn08VRSmPEWmoJYm75sml/ajPJdyd9VC0z3SK5SfbVFuOL8E5pS0F9YlEHyPRdK4nNdn3KiIOXibX0BgI0YQHMGZF2Rh807wRNf9FNtnEJ+Qi62/At/QfaLlMUAc/FyIyPMb7uCsBnHbyJSczdRRjXxGgaA5bWkEIMEoawrogYqdGZdy1ibgYv6RMiMfjTuAq/S/VcVQlbw+3d95AzKN043N3w9Q7yw4iACPYTmvDauFWmrDEOLoojUunFtB6RQcosWmq+XmdlYKjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(31686004)(66556008)(66476007)(8676002)(6916009)(4326008)(6486002)(66946007)(41300700001)(316002)(31696002)(86362001)(36756003)(6512007)(6506007)(26005)(2616005)(6666004)(83380400001)(8936002)(2906002)(5660300002)(478600001)(82960400001)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDFpaG1EM1dGK0Z4TlVHbDFIMDJJWEdKRUF0RGNvNGo2dDliMWtmd2htdWhW?=
 =?utf-8?B?c0liRkdKWVMzUzU3Q3lmUFVCbDhscENIalJ3MUxHbnVzVTBwbVdtajc5VU9H?=
 =?utf-8?B?MFZiS1k5cE05NlBHZFRucVpScnkzcEZHQ2w2NU1hUGk5RkxZazJoSWgvdS9N?=
 =?utf-8?B?ek4xd2QvYm8rVFArY2V1V3puVk5icnhVY2YrY1JNQW8wVXhKd25YR0JSdXRF?=
 =?utf-8?B?dEpRNGE3MkNVd0pkOFhHbTRySitWY3RtbjdJWmIrYWQxL0JGY1BGd01KQ24z?=
 =?utf-8?B?NnZ1cUlNNU8yT0VxNHhVKzNrK1hxWllUSVIzVWpDeTFyYlZOVXB4L2pBb09E?=
 =?utf-8?B?QWJPVlJkS1pwQmVHSGl6SkZwSmlGUFBWekpiR0oza2dobUJzU0tkc0txVDBq?=
 =?utf-8?B?NU5UR09icTlHMGJPQVpCK2Z6Z05ZcGRzcko1TUR6S3VTUGVST3BGMDlIc29Y?=
 =?utf-8?B?STNNVmg2YjB4WWNnR0YyWlpSQm8xc0ttOTJpYk52RGZ3aGJseFpIMjJ0ZUJJ?=
 =?utf-8?B?ODdaUTJPZTJ2cUxSRmZ2SmtmN2srRkJwTEw1cVdFWElYaE1hRWErcGJURTdB?=
 =?utf-8?B?RlY1Q2NXNVk4OGxiNXhwTENtWThST2RFVDBHYmZUNExGVXBXMFNzRldNVU9Z?=
 =?utf-8?B?TkNVaGU2Mk40WVVoNWFlVHNUUEM3MWIzZXFWQTJZY2pDL1JBQjJJeVJsaVlj?=
 =?utf-8?B?dDJDamhhOFdXQm0ySTZHeU1DeEV4ZFdndTg1RnVQZ1ZBdHRxdUV5SGtveHdL?=
 =?utf-8?B?bEVSRnhLRmFuNzhNYnhxQ1NYeVNzTVZCM21DemgwYm9PUlpwMzZCbFNoVXYz?=
 =?utf-8?B?OXpQQ21Ya2k1OWs4ajdjcFE3cVJqa0E5MklwREhwT3dIeWxPZ1N3OFg0L1Nz?=
 =?utf-8?B?cTlpbUFtQ29UQzBCdnBCS3JzWlFmbDlqNXhZRGdLYkUrbEEwRW9DOTN1ZEdh?=
 =?utf-8?B?TFhXaXo2c1RpWlY5UVdjdGVzNnhyeVhad1YvQ2lqaUI4a3NoSHNINnBjNDR0?=
 =?utf-8?B?Mm1aa2wxRlNiUHF6U09zeUE1UmxNaithc0JBZjZBQ29QbTlDRUNueUhVSFNq?=
 =?utf-8?B?MktsNWtXZG52MVRwYStBbnVFYnl1U2hDZlFXNlFwcFpLZW4yRHdhQkVyYlNt?=
 =?utf-8?B?WXNlaGZzRkoxd1lXWnV4WlMxT0FqOGNxWWZtTStaR0l3dW1uWHdmNXNPSzAy?=
 =?utf-8?B?L1kzcnZENFZqNGUrdmNnaENZTS9Ob3RLa1FGOTlVOFBobHcxdGYySU1wYWpI?=
 =?utf-8?B?LzJUeWVPQnoyWllPWk5pMVJuM0xhRjR4enF3Y3dXaDlWVmt3OHhiT2RycDJL?=
 =?utf-8?B?aUIwcU9Pa3ZKcWxYQ1V3OVdrdlM4WXhlVkJUUkpNNGJGbldvcERtbmxMSm5C?=
 =?utf-8?B?U0VDYWdhTk5RUndSRWdGbTNuOG1mNGZGdGVlR2ZTUlk3RzRHeUUzZ0JuYVVq?=
 =?utf-8?B?V1hGVUNqY1dGaUlrK0pTTjRhcll3VUY0aXJybVRhNDFsYmw3OUhVMmlOQW1K?=
 =?utf-8?B?aytvc3hZQ1o5MTZWYUtISjRmQUNxNDdpTHpGdlMvQ053WHgvUWNWS3plRXpl?=
 =?utf-8?B?eG9aNFNwb1ZCOEx4cmo1eFZrOHJZQy9mZGE3QnlpTG9uaExiMk1MUHVjeVBK?=
 =?utf-8?B?UnM4Y1hKeVVPa2V4MkxLVEpwdWhZc2h0T05oS3pIRk91YWZqeVQyeEtPc0Za?=
 =?utf-8?B?WXJGQUlEempTMEtwMUprb0o2WTYrbGIxQng0RkJjQndwZ3ViZXE4Wms1WDI1?=
 =?utf-8?B?cFlscnFUZUx3OHF6emw1c2J3MytkZGJtUUhkZnJ1K3pTWHVZeFpvMkFPSGtm?=
 =?utf-8?B?ckZ6bksySkVGTXdsZnVFQ0xlUkhIVEpRYmtvbGZnejM4aEIrOGNIT1JKSWZL?=
 =?utf-8?B?ZTJWN0EwYUpoMXlvcUt6K1VMdVZVd1lrYThiWVJuSERzMW9hOTN5SVY1NDZx?=
 =?utf-8?B?YVBpemszeUR3WC9JNzJaT2lscDhvdzRUU3hja044aUxVczFkSVA1MjJGZFpw?=
 =?utf-8?B?RmpaVVhxM3RPZEExcDA4dy84UUF5bHlFeHZBSk02UnYvOUJnVU1lZ1hnYWZk?=
 =?utf-8?B?eFIyQTMrekZqMXpSdS93N0dTSk9oVWZ4L3hWTFZQdGUyL2drc0J1R2RDUGsr?=
 =?utf-8?B?L0dCRnFlTGlXQnlZYXJyNGlFekVhWVVRYnMxMTF5NlV6bE1pSjk5QWR0alNn?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce638660-0d63-4821-26bc-08db34f68707
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 10:22:43.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEpfQbFuGBa3DdwlSAwa4TPvAh14N6MTzDSGl/TsL52IWH2U7SWzTajJsMtO74QKNe6MDv6XXCZrxSUADNh7XI+PKjrIlkt8WykscYKntls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5176
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Tue,  4 Apr 2023 09:28:32 +0200

> Add meta data matching criteria in the same place as protocol matching
> criteria. There is no need to add meta data as special words after
> parsing all lookups. Trade meta data in the same why as other lookups.

[...]

> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -4573,6 +4573,15 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
>  	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
>  	{ ICE_VLAN_EX,          { 2, 0 } },
>  	{ ICE_VLAN_IN,          { 2, 0 } },
> +	{ ICE_HW_METADATA,	{ ICE_SOURCE_PORT_MDID_OFFSET,
> +				  ICE_PTYPE_MDID_OFFSET,
> +				  ICE_PACKET_LENGTH_MDID_OFFSET,
> +				  ICE_SOURCE_VSI_MDID_OFFSET,
> +				  ICE_PKT_VLAN_MDID_OFFSET,
> +				  ICE_PKT_TUNNEL_MDID_OFFSET,
> +				  ICE_PKT_TCP_MDID_OFFSET,
> +				  ICE_PKT_ERROR_MDID_OFFSET,
> +				}},

I don't think this is proper indenting. I believe it should like this:

	/* This line is unchanged except the opening brace at the end */
	{ ICE_VLAN_IN,          { 2, 0 } }, {
		ICE_HW_METADATA, {
			ICE_SOURCE_PORT_MDID_OFFSET,
			ICE_PTYPE_MDID_OFFSET,
			[...]
		/* Don't forget commas after last elements */
		},
	},

or

	{
		ICE_HW_METADATA,
		{
			ICE_SOURCE_PORT_MDID_OFFSET,
			ICE_PTYPE_MDID_OFFSET,
			[...]
		},
	},

(but I'd prefer the first one)

Also, I think anonymous initializers are now discouraged in favour of
designated, at least randstruct sometimes complains about that. Could
we start always specifying field names? You could define a macro for
this particular struct to not bloat the code.

>  };
>  
>  static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
> @@ -4597,6 +4606,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
>  	{ ICE_L2TPV3,		ICE_L2TPV3_HW },
>  	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
>  	{ ICE_VLAN_IN,          ICE_VLAN_OL_HW },
> +	{ ICE_HW_METADATA,      ICE_META_DATA_ID_HW},

Please replace spaces with tabs (as it's done for ICE_L2TPV3_HW).
Also missing space before the last brace.

>  };
>  
>  /**

[...]

> @@ -5726,6 +5663,10 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
>  		 * was already checked when search for the dummy packet
>  		 */
>  		type = lkups[i].type;
> +		/* metadata isn't lockated in packet */

("located", but I'd say "metadata isn't present in the packet")

> +		if (type == ICE_HW_METADATA)
> +			continue;
> +
>  		for (j = 0; offsets[j].type != ICE_PROTOCOL_LAST; j++) {
>  			if (type == offsets[j].type) {
>  				offset = offsets[j].offset;
> @@ -5861,16 +5802,21 @@ ice_fill_adv_packet_tun(struct ice_hw *hw, enum ice_sw_tunnel_type tun_type,
>  
>  /**
>   * ice_fill_adv_packet_vlan - fill dummy packet with VLAN tag type
> + * @hw: pointer to hw structure
>   * @vlan_type: VLAN tag type
>   * @pkt: dummy packet to fill in
>   * @offsets: offset info for the dummy packet
>   */
>  static int
> -ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
> +ice_fill_adv_packet_vlan(struct ice_hw *hw, u16 vlan_type, u8 *pkt,
>  			 const struct ice_dummy_pkt_offsets *offsets)
>  {
>  	u16 i;
>  
> +	/* Check if there is something to do */
> +	if (vlan_type == 0 || !ice_is_dvm_ena(hw))

`!vlan_type` is preferred over `== 0`.

> +		return 0;
> +
>  	/* Find VLAN header and insert VLAN TPID */
>  	for (i = 0; offsets[i].type != ICE_PROTOCOL_LAST; i++) {
>  		if (offsets[i].type == ICE_VLAN_OFOS ||
> @@ -5889,6 +5835,15 @@ ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
>  	return -EIO;
>  }
>  
> +static bool ice_is_rule_info_the_same(struct ice_adv_rule_info *first,

Doesn't sound natural. "ice_rules_equal"?

> +				      struct ice_adv_rule_info *second)

The function is read-only, `const` for both arguments.

> +{
> +	return first->sw_act.flag == second->sw_act.flag &&
> +	       first->tun_type == second->tun_type &&
> +	       first->vlan_type == second->vlan_type &&
> +	       first->src_vsi == second->src_vsi;
> +}

[...]

> @@ -6121,7 +6088,12 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
>  		rinfo->sw_act.fwd_id.hw_vsi_id =
>  			ice_get_hw_vsi_num(hw, vsi_handle);
> -	rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
> +
> +	if (rinfo->src_vsi)
> +		rinfo->sw_act.src =
> +			ice_get_hw_vsi_num(hw, rinfo->src_vsi);

This fits into one line in my editor :D

> +	else
> +		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
>  
>  	status = ice_add_adv_recipe(hw, lkups, lkups_cnt, rinfo, &rid);
>  	if (status)

[...]

> --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> @@ -186,11 +186,13 @@ struct ice_adv_rule_flags_info {
>  };
>  
>  struct ice_adv_rule_info {
> +	/* Store metadata values in rule info */
>  	enum ice_sw_tunnel_type tun_type;
> +	u16 vlan_type;
> +	u16 src_vsi;
>  	struct ice_sw_act_ctrl sw_act;
>  	u32 priority;
>  	u16 fltr_rule_id;
> -	u16 vlan_type;
>  	struct ice_adv_rule_flags_info flags_info;

Please check holes within the structure. I see at least one in between
`fltr_rule_id` and `flags_info`. Some fields can definitely be moved around.

>  };
>  
Thanks,
Olek
