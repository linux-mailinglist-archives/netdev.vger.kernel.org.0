Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5A6E01F2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDLWjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDLWjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:39:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAEF4217;
        Wed, 12 Apr 2023 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681339137; x=1712875137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kRk2j/J+U+RxDnyOJ4YO/adpJKOdeBh+1XweawOHcso=;
  b=MlP2mqrbt85JrFVKHcr6LVB8uXirvuVTb2UvCxW0lrMDbeRNZ5Q+umne
   +q7ZyuU5YWiNXt4WjJF98mtkkUSKrLiPF/ego7mRbfwK+mqMqPWPkJWPf
   sJ3YqshMAIj/pkT0yvsCs79T/q417JohpJBxJsgImY2ZMzkkrw++8F0Cw
   AIPYxlaQYb5iXMNjWFjQ4I4dIbDpOEBYK4RGn0DnJNhK6VNH1yZKdH1JZ
   FOyExC6yPl5JnJ35F2F9o/G9X8Uj2VQ4W9TF4uZy9B0g/5otE1AuEBdF9
   a2LzLQifSNR/QOLa6IloK2kXXThzS8OvGpGaiRZjR00NFdDuPEh7gE29f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="345828460"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="345828460"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 15:38:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="832831911"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="832831911"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2023 15:38:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:38:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 15:38:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 15:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAQR8NOggB4s2yWHiTxYllwbJpSLbSVrIO/B5v38Xh3s7uIFrHPRoNbDDRXnFv5WYUJ6eygCS91xAPmvWPwFS9h//fIrQSxs2AJ4A7hfjWzw+pubpjLUkOnhUpptoGkAGrL3uiIAJcK/zzOFJfy7Wt2AIZA4xWKgITWuwsF8HfeH88J1F7WOvFME0fDS5ULm6JS80fdE2Boqcq+M4M0KoqPn7+gzq6QsJJBvytf5ZDyb6UpopEq75elo+9khn62EzCH5Lx6w2+J+l31wn/Cw0s+L7Ol/YuF3ClMn/MxOKySaarX1y9E+NfXYB1e7ILacimAGVz2yKkcg0DDycDD7Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZyRG3OrTVZMdB/Dm+MNaLn2aZLz/zVywB1ke8S0sHM=;
 b=DxuLdgICAyIwJiprwH4gD2A0J4jhfV9fnroEc/Eg8cAFU9WFK5tRjSNEIulhGe7JwMR5N/0HSkJ6wtubMZ27uL2Oz1q17z8mmTbNwXrZAkMZTeqXWGEd2agBVTL3UQwgJ9vA6Rf6ofR1HzXePv0O5vkkh5H4xZaL8y9u0b10CmogOC+Aoguym7tJ14dPVrHnoiUT1iI7sEknhaxj2PMnk/CQM5Nixcl5iTP5kvH1AiG/bX6VAbF9WFPvYEGbOryIP0OfE3fNpNHIiPVaLtGsMf51d1GCsgPkv330Torz2Ugw0RDpUH3NSzzrbUMivBOso6+JuORlJUCVMlgaA+MW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH3PR11MB7251.namprd11.prod.outlook.com (2603:10b6:610:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 12 Apr
 2023 22:38:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 22:38:49 +0000
Message-ID: <52b8b6e5-3ef0-6143-1373-e41caef19234@intel.com>
Date:   Wed, 12 Apr 2023 15:38:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net] net: enetc: workaround for unresponsive pMAC after
 receiving express traffic
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        <linux-kernel@vger.kernel.org>
References: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH3PR11MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: 897a677b-8daf-42a0-11b7-08db3ba6aee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rwVgv0NFTFsZmbW6ebpxM5i93PvIZS3Umum2oAjgKYHof7IKvxuG5wyweWNfr4gHm01SD9CEmUUqNpVYJ8Xb6hQ5frzA4bBzWmmSVyP7R0jl3XZWo4VoOnaNvpO6uqz+YL/LBFJNjqxo8WKWaameLmKvrbBEgasGZv1U6ym+T4VHHdwcVZX7S1nXqfN4q7XvdZLZk6TJu8B3E0g0zKQ/5bfLk/o6Bzi0DUsFssAyk2Xw2jplWpyZHRSTZfemhqTokxmV9jrs6lPEhQVsZIVg25/4Ax5oQcYdU4DdcgSH/A70kGExwZIaq1UslrwoJewaVDikrQ7TnaM+Bxk0i5AR1ZU9PchKYiLd6sRcefnRO5SLqYwRS3ZE9TVZ116fcMfJQEmhV/J8BYjRee0emkAzbe8a4k81m0Z7p2p8dy7/3YCeta9NF1yT7pbxmEzEzPdh+d0VfRcvYzrGGF+GftJIYvK1wcJBRAVTre7S/pKBU6zcZyG/K4zx6qsDjTP8QHHRFY+OcjSdskCcOdBqnJ1bXmUGhFQ9ia3m9jm7R+C5mz6qe+yvw4HsJaFTW3ytrFg8FW7yE2Cr2K/Mip4BNegXCdLpUsA81F45iGmhav7WC2Uri7GfcIHK0KxclIU3zMoY6zbJ+F9jZGRGF3ihmWhnQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199021)(186003)(53546011)(26005)(41300700001)(6506007)(38100700002)(6512007)(6666004)(6486002)(31686004)(2616005)(83380400001)(66946007)(54906003)(316002)(478600001)(8936002)(66476007)(31696002)(2906002)(4326008)(82960400001)(86362001)(66556008)(8676002)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGRackMvdVhsN3gvTU1sOFZKQVhHL1luTVYyeGdHYkR2ZHVyeHRhTE9xaEcr?=
 =?utf-8?B?ZUllQkpiUFhManVibFYxYWk4WjdzOFZnOHVCMkFMMFVGZ0JmUU9pcUhkWDBB?=
 =?utf-8?B?a29KR05hQmtQb3hYUHEvaTlYcWw5bVlMSmdrVHRXaVdNUWc4cnF1Y2JkbmNv?=
 =?utf-8?B?aGRHK29ldGowcWYvUXVSUTByazdYZHpJSjNMQ2o5dHFLbGZoS1FEZlozTFds?=
 =?utf-8?B?NFN1K3VLSktrcm5JdjhaYnVPakNib29nUTVDa3ZPR1k3cG9YdWVqMkxyWFlx?=
 =?utf-8?B?bU9mYTMxMzhnVUltNDMybHZXVkZQWkNSMEVVaG1LU3BKWFR0OUhTanhRRk1M?=
 =?utf-8?B?RkNLUjd5WG1QNVBRVFZnbVBHQXJXU3ZRYlpiVXdaZ3kvZWpqdWhqMFlJL0g1?=
 =?utf-8?B?dW9sVVRadEIweld3YkhsSGhXUzF5ekFpWkNNUk5Vd0YyTS9xanNCeXR6YzVp?=
 =?utf-8?B?TVdaQTJzMTVuZ0hEd00rUStzS3p6ZkkycEdXOW9lYVNmN21YQW9DQnJnYkVR?=
 =?utf-8?B?SUxUK2dVaUwrMVpaY3ViSGRLVG56S3IvUS9SUGZuYVBrU0RLcmZMMnFhNzVa?=
 =?utf-8?B?Sjc1ZmxJUFRMbWVia2tHYjE3WFNWZnZtdVVPVjZkM09OT2xtWG1UMEdTS291?=
 =?utf-8?B?NDh0Q05PU2M1bHlMcnp2MXJyVy9XcWJ5THN1a3p4elUrekJTbEh5bVZLeFNE?=
 =?utf-8?B?c2p1ZnNWc0VtUnJ4UkhyblJnL05vcmtEbTlCMVpqay85Y2NqTU5scWVLTGM0?=
 =?utf-8?B?R01PemRMRVRsb3c5NitRdjdiQzlKU01IRnF4Mlp6eEprUmpyNHpIZXg4dVlj?=
 =?utf-8?B?RmdnSTk1MDU4azhzblNyOStDTVRiT0hZM0FmV3ZvRW4wd0Zza3h3M0pEZS8w?=
 =?utf-8?B?SGJzNkNHcDNBVkpvTklMQ1E3L1dLSG03VXl0OEFCMTFEa2dYaTNTRS95bThw?=
 =?utf-8?B?VEIxZlo2VzRQUzNZOXRaOCtKSkZraERkbGFuNThOdkVhdjRkb2JRdDlDUmE2?=
 =?utf-8?B?RHRsU3hLdklEQnE3Vm94YjdsSkFSTUFKa0ExRmRxMEszTTdDWklOVXh3dVIw?=
 =?utf-8?B?VDZIVVpxSXFFYkZOdWRYeWdma0ZJQUlNdWlKOUoxR0xMd2ZCS1lKRStaWlBM?=
 =?utf-8?B?SzVDTjBBUjExZW5vZWdTTlI5a0hzc2c1MGc2SG1BeHpoZUdwMzJ6SW1vNkRL?=
 =?utf-8?B?SEtTZ3hDWjgrcE5EaE1nTmxFSmVZV055dll5OFBramp5Ullxc3hZb1lvQlk2?=
 =?utf-8?B?Zmx1VUhGTmdDcURYd2xtWFZPbk9ScXEzS0NZM3NjVThzZG41S2phVmJTMnNO?=
 =?utf-8?B?SWVWZmFEV1ZOYk5pVmllckJwNzNiNTFLZ3JIV2VmWlg2akZuR2ZJa2t3c2lt?=
 =?utf-8?B?RlRoMmdkUjYzTTFZYzgxeFhmOG5oSHFCL1JHVXU2cUNCY2E0MHMwekNDQS85?=
 =?utf-8?B?aDhqUHZCSFFJWE9VZW5WallNWVlVaHZYRE1qSU03ZGlZLzVyY21keDkyWHE0?=
 =?utf-8?B?YnhoakJPQXBjMUpnR09nR2tFRHUxeUlSWnFndzNOL05hbWp6OTJNallUSEdJ?=
 =?utf-8?B?ZEU0eEhXNFZ2SGIzQjh3cmhDcFB3VjhucmZNUzA4RURqdjFBN1l5S2Fna2dD?=
 =?utf-8?B?djd2bEwwZjFsNFRWTExhU0YzOEt0RFVBbEF5Z0Iwbm5vMkNCRzdSUU13dHdj?=
 =?utf-8?B?OVRhWWFKZnNDYmJqYUtUeEcrOEt3NVhwQk1ueVhqaytFSGxQbEc1YlYzekRU?=
 =?utf-8?B?azhQaTRjb1FTMVNRc1dCVU1vZWZqbmRBVzJoMlhmVzhrMDkvSllSZzBjbjZR?=
 =?utf-8?B?eVovSk94L0VHWTR5dGY5dGlFRlJ5bGJ0UVhkL0FPVFlKVkhKT0tEM0szMUdw?=
 =?utf-8?B?VlZ5Qk5ySTRWalAyVS9ieFQ0QkgzTmhPMmU1RCtGbWhIenlQY21Bc0MxMTc4?=
 =?utf-8?B?RnowTHRSQjh2azRDZ003MGJZSVhkQ1JyQWJGMmI3S2NDQ0VBcFVCMnorQTEr?=
 =?utf-8?B?L2owT0g0cmxxZldwckxRYTl2b2FRQkdnVm5nWVRtV2ZGZXh4VFJxOFNxMnQy?=
 =?utf-8?B?djQya1REZEtVK0d3Z1pTSHpMeURleVBEWUVuVVNjOXo4YlRxRWd2bmRJYXBF?=
 =?utf-8?B?NjlXaFpCckt5Nk0vQzNrcHJSSlYySGxhS0t2R25ITDlyQ3RTcWxuMy9rTFpB?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 897a677b-8daf-42a0-11b7-08db3ba6aee1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 22:38:48.9682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAKYUWtrYwyBQqRwqrhoLdweQ6vnEQ31gmweW4QYjdS6Zr1BfHQUcr/W77C3JsprmpmoikTDN2RGnpAnAhs+EUvBHvVjKjpP2ie0y6o+eZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7251
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 12:26 PM, Vladimir Oltean wrote:
> I have observed an issue where the RX direction of the LS1028A ENETC pMAC
> seems unresponsive. The minimal procedure to reproduce the issue is:
> 
> 1. Connect ENETC port 0 with a loopback RJ45 cable to one of the Felix
>    switch ports (0).
> 
> 2. Bring the ports up (MAC Merge layer is not enabled on either end).
> 
> 3. Send a large quantity of unidirectional (express) traffic from Felix
>    to ENETC. I tried altering frame size and frame count, and it doesn't
>    appear to be specific to either of them, but rather, to the quantity
>    of octets received. Lowering the frame count, the minimum quantity of
>    packets to reproduce relatively consistently seems to be around 37000
>    frames at 1514 octets (w/o FCS) each.
> 
> 4. Using ethtool --set-mm, enable the pMAC in the Felix and in the ENETC
>    ports, in both RX and TX directions, and with verification on both
>    ends.
> 
> 5. Wait for verification to complete on both sides.
> 
> 6. Configure a traffic class as preemptible on both ends.
> 
> 7. Send some packets again.
> 
> The issue is at step 5, where the verification process of ENETC ends
> (meaning that Felix responds with an SMD-R and ENETC sees the response),
> but the verification process of Felix never ends (it remains VERIFYING).
> 
> If step 3 is skipped or if ENETC receives less traffic than
> approximately that threshold, the test runs all the way through
> (verification succeeds on both ends, preemptible traffic passes fine).
> 
> If, between step 4 and 5, the step below is also introduced:
> 
> 4.1. Disable and re-enable PM0_COMMAND_CONFIG bit RX_EN
> 
> then again, the sequence of steps runs all the way through, and
> verification succeeds, even if there was the previous RX traffic
> injected into ENETC.
> 
> Traffic sent *by* the ENETC port prior to enabling the MAC Merge layer
> does not seem to influence the verification result, only received
> traffic does.
> 
> The LS1028A manual does not mention any relationship between
> PM0_COMMAND_CONFIG and MMCSR, and the hardware people don't seem to
> know for now either.
> 
> The bit that is toggled to work around the issue is also toggled
> by enetc_mac_enable(), called from phylink's mac_link_down() and
> mac_link_up() methods - which is how the workaround was found:
> verification would work after a link down/up.
> 

Frustrating that we don't know why this is required, but your outline
here is convincing enough. Thanks for a thorough explanation.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: c7b9e8086902 ("net: enetc: add support for MAC Merge layer")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../net/ethernet/freescale/enetc/enetc_ethtool.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index da9d4b310fcd..838750a03cf6 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -989,6 +989,20 @@ static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
>  	return 0;
>  }
>  
> +/* FIXME: Workaround for the link partner's verification failing if ENETC
> + * priorly received too much express traffic. The documentation doesn't
> + * suggest this is needed.
> + */
> +static void enetc_restart_emac_rx(struct enetc_si *si)
> +{
> +	u32 val = enetc_port_rd(&si->hw, ENETC_PM0_CMD_CFG);
> +
> +	enetc_port_wr(&si->hw, ENETC_PM0_CMD_CFG, val & ~ENETC_PM0_RX_EN);
> +
> +	if (val & ENETC_PM0_RX_EN)
> +		enetc_port_wr(&si->hw, ENETC_PM0_CMD_CFG, val);
> +}
> +
>  static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
>  			struct netlink_ext_ack *extack)
>  {
> @@ -1040,6 +1054,8 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
>  
>  	enetc_port_wr(hw, ENETC_MMCSR, val);
>  
> +	enetc_restart_emac_rx(priv->si);
> +
>  	mutex_unlock(&priv->mm_lock);
>  
>  	return 0;
