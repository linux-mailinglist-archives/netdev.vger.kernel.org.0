Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3296A5CEB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjB1QQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjB1QQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:16:13 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B812A142
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677600972; x=1709136972;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YYydwtQw6B+6gP3ih7owkWnf6QubJusVgIGlXXlXO+I=;
  b=LJeJsWi2W/x6pEy2fWF7UT0eBEDIhwNXdXabQVe1Hm8eQ0HMHUBekfy9
   qxn1/i+6s2M8BhcedKORGI0yXl0rwcfh3Z3h/IVh67osZDoB5klSyXds1
   OYjY9mJPItYZxTe6AhYKP+LbM8v4zAtnZ5tZvDkRHS4nyJdc5gQuol1aM
   dmRZDhJy+rGDRINzVsXdxSclBlAF6XPpkABDV8MPnzNjG4z+/3a/8TIOL
   fmuy232Wxhcuyw4GMz5zcC6IA4v5CBzg6ma7rOKwp2TPoiVWtwqZYOnG5
   MsBHHsKIQLOVPIDcHjGp8xxk/fj47JTag4uYg/zIK6femw+XjO1O4QgbZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="322431559"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="322431559"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:16:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="817129946"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="817129946"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2023 08:16:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:16:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 08:16:01 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 08:15:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sf5x3T687OsBWbPJJ3wDtl10cTjJ+KfHnhq2Z1mkg69xGKj7p8dVIjKvxnk+1j3FKrUahaXkro3a9Qqfm16hgRwOeierKGXRHS/qRobejAUEY47Moif/U2O+sMjG9HH1Jn9CeQgn8gPWXJDq+6pxkzlzLdKEzMMZY5aMwVcA2mycM5iblMqtJ73cgdqDsSOurLxbgUuwrzPEQDjmlya680Bg4BiJgGhoFr2uXmKdh8pJJy6Bpckd2QPUk8I+PAErileCYmY6+e90nbQiTNEzcljtMineCTCGSUOt5yrL145aF+uoUQL0rREpxO/yrxnwUKJqRAzvRMGFi1z1gjXl3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WI9GYDUguckRmVkfDDsHz0kFC/unJMuHS756VHOjF1k=;
 b=L1zuj4Rn2lbb33WuYWU/Jas18OTVOvMOUH9FTf3eDAX3PM7F0k95pXMKI6T/9fKMOBjp3SvjjfPLawIWsaTXTTDoEq2XvsS5hMsqFFxftBK7orrtXIx2vkd8DVOYJUqBnlQOx+TgR32sI5lsFYfGoMOYmCv3luKYOQph7Xd9VwE3rbgZ8XhHzQrnX5k4dEK1F7WJzEqBEFS+6KLIfPPRisGgbHc38vS4O0Zj/wDos9DBP5CR0l+I3tX/4LRuM3/rQwSQWThubGfKUb1YLvXjcPr/VXUf0K4GLOh22RM5yYsa8/nZGnV8SyJHTspv4h7lVhlJUh+HblBqVUknaKF94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 16:15:57 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 16:15:57 +0000
Message-ID: <894961ed-1c0b-fba1-e326-fd0517ae5d01@intel.com>
Date:   Tue, 28 Feb 2023 17:14:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v6 2/2] net/ps3_gelic_net: Use dma_mapping_error
Content-Language: en-US
To:     Geoff Levand <geoff@infradead.org>
References: <cover.1677377639.git.geoff@infradead.org>
 <3edb8c30e72c429aaa50d3ba43b46e7579b0da63.1677377639.git.geoff@infradead.org>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <3edb8c30e72c429aaa50d3ba43b46e7579b0da63.1677377639.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 07946f30-a079-410d-da82-08db19a712dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbcAJpUI0QbFSMlRmMxgMkVHESs6H3yNdh40YpmDgBDuq3+7QOrvhcg55HCrbi2oeR6tMOOiFRgoZCnHK7VJNPOSuGt8YjhJTZaG7PmokNspiuCH+RC7+hx9SlSitlr09gNQIOlLQs+LWC8Xtd0Ulyp8LRCxCwOHHY6xZ2CX3hdTUmruLk0M2BdeasiZfF5WCCID7cN4aoFBvTkTwXr6i/2rpX6ymfFJLV09t/CR3Lm7B9RCe4Z64Vb7LgsWCqu+Zgjp0KP3kfrC6HIooHCz5i2qzUg8LOU2/sslEYCRYJkKrxWGB5soqSMnHufk0qtOXV3aSOe+lTnyXLUnQcrMMoigJVO8blxa+BUQT2fAWiOYh7nHu3uCfnTqaW7R6qzmqvhyQq9hAj2WsBf5liCqKDwRVrAhDq6FBrFEZqUOZoW0maFqnF13txmXFrQc1Za+ttPFsjJTD0BFn5i7oF+kNXb2i5Ch57e10fQLUgOWYyRK4SeOPnFcTI/bFAj703vWPkmnH2BBWWyAGZ7VC89BBQhr9zYWBQxuz3c5SsKcdnJEfzU/B+rZeq8KxyTpm7Jx8fEfuVq+2d+rT6F0YtsKTsaTyOrtFzPhOV+rfxVMcJ6tVfCtMjEjO1gEzETy/uNW3nJveyVodh7ro+XXbhh8uyra6LldHda0Ly/CQzH8rmqb8+xBRopdN7pqcppK6aZKLtr2yOyoV/jSCPEl8XhpbWSwAb/WEF5eGoI5YIkspTs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199018)(31686004)(36756003)(31696002)(86362001)(66556008)(66476007)(66946007)(8676002)(5660300002)(6916009)(4326008)(41300700001)(8936002)(2906002)(38100700002)(82960400001)(6666004)(6486002)(478600001)(54906003)(316002)(83380400001)(2616005)(186003)(26005)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUVCak5hTnpydmRMYkNNVzJnR2VhYXFKZ2huVTZiSmVDaGh2Y2xhN3FHdEx1?=
 =?utf-8?B?akttSTJVMmcvbnVyVnVueUVSYWp3Y3VtTE85Ukp4Z1lGMVk1bXFab29qbzU1?=
 =?utf-8?B?RU9DQ0xxWThSNVVUb2tKalJpYTdmVStRYTRYTVZTamhuMWZwUFc3czI5V3Nz?=
 =?utf-8?B?Nm9YU1RvR0MvZjZhSlFzUng2VGRxZTgrTUMzOFFiUHBVRDkxQjVyYmdGZjl1?=
 =?utf-8?B?TmZNeTk3M3ZYUVg1eTFDV0RrWlc0eXdxZHRodnFHcWx0VFlPQmdXUmxqd1Fm?=
 =?utf-8?B?U0xPYTFSZUNPWDVUSExnNUlRVTdJNlh4dWIzVGdreFdTeVU5SUF5MkYxSlMz?=
 =?utf-8?B?U0s4RWpoUWFWSXR1SWJieHZWZmZySnRtWk01NHM0bTJZcUlxL3pHczdmeHhS?=
 =?utf-8?B?a3lMM0Q1SlJTRFBZcFNOMEI0RXZWcEQ3dGNrV3lSa0RpT09WYTVJWHdiaGZO?=
 =?utf-8?B?QzJUTm1MYS93dVJ6bFBZV3BPLzRuVUM5ZjBINVRieFhvOEV4c3Q4Q0crelcy?=
 =?utf-8?B?dHBQTUdselhkdTdPZ09uWTJXaGJLdG82dEpWZ2hnUnN4TDdiZm1hNGh4d0x3?=
 =?utf-8?B?U1ZDdkpIREE5WjhnTTEyQ3JlL1RaRVlGVE1iQzJtMlMxN3M0RjhZYUw1cWN1?=
 =?utf-8?B?bDhTcU1UMXpLSGZZblcxQ2QxUG1nTmZnZlZJbmFkUnowVWw3VG91cldJQnpT?=
 =?utf-8?B?YXAxWkRGSDRUM09kTTJzVUd6azNDNHNYbGQyQ2dqNnladGRZaGtWN0ZxVjln?=
 =?utf-8?B?ZWVqemxmVmk1OWl0WGZxVlNyOHRDNUc3SDZyOHZMQVhwYjY4STVUYXF2WDkx?=
 =?utf-8?B?eDFpR0ZUaUZpd2dING5JM0ZPbDlmeVhwSUVOZTlSWEFJd2YzaFUvd2RqOHgy?=
 =?utf-8?B?anRHc0t4bUE0Y3lhY0JreTh6RnBJekhab3F6QS94QUUvaldIZXg1TDJqakha?=
 =?utf-8?B?NWRTYzA5bG9PTk9aOE1vZ2h0N2NNUU1sNzJ0L3BJWHYyUDFlbTh4OUdQazA2?=
 =?utf-8?B?MlIzWEJuOTU4ajJTbUF2aktuTHBubUZqMjMxZHpXUEl2ekNpMlBOK0R3dG5i?=
 =?utf-8?B?WUlnQ1hoTjl0MEpHSzVoVzFxR1hVUlhIdllWYmpuZCtvZG9WVTFVQzZmYlJs?=
 =?utf-8?B?dEtkcGtSbmlXWGN2NlowOWw1SG5QQ293STBCVGh1OTZ2NGEyOGo3SkRpcjVO?=
 =?utf-8?B?a1RoOXB1bEQ0OTlWcGk0aWZaU0g4TDd3SjV1c284bzMrcFdDWldQNUVlYTV4?=
 =?utf-8?B?SEdISm50bDRsbXRkTWh1dThzQzNFODlDVGlxWVN2S012ZXltRVNpemJvWGNh?=
 =?utf-8?B?WnRNRklIOGgvRGR3NjFMeWY2OEw3RjZjTGNiOElZTkVPaWQ3SUdScytxRDk0?=
 =?utf-8?B?TklpRUdhY1VjNVA2VUVYWE5pZncvYjN5QTlvbi9LeTNsQm9HSW40YitoUHl5?=
 =?utf-8?B?OHJNTXVMc2YrZVBZMm9GakxXd0VLd2syZUlxZUFGN1l4N2ZGdzhwMW82Kzcr?=
 =?utf-8?B?WUlRWTUxbHR4VnVkaVd2TnpoYXVuQ1lSb2ZCVHgyV2lCcFRqZk1IVmI4ZXdX?=
 =?utf-8?B?cGRMd0RBUERKYlk5SWdkYkJ0SG9MRjJJZUl1R0FWY0dFTThBTWJWblRFY0JF?=
 =?utf-8?B?Z2ppaXFOZDVXNm9SR2pwSW4ycVhKMG9YRkJKL0JKU2pEZTg0dktGU244TEhx?=
 =?utf-8?B?bnVMMk9LRklNaXhFWE40RHMzNUxjT3hMYnNYc2VjTGpVZXZXRUtkOEhndDJO?=
 =?utf-8?B?ZHlNSmEvcS8rOW54LzZjSjVsOGgyeWE0d0EydnBGTVVMOTNKRTBlc0tGTUV3?=
 =?utf-8?B?S1p2d2Y2T0o0MWkwRUdHNUNzQ3M4bWVrVk5SbjBUWnVINjFRU2JsT0JDdVVv?=
 =?utf-8?B?YzE0dmgvZ0JLTzRNVTdCVlNWNEdUYUxWL0JiKzVVbk1pV2lieFJFYTMvMVMy?=
 =?utf-8?B?eis4Qy9JajRTWXB3Z3VhRys1Sy81UTFaVS8xVEFHRkE4a0NRWGV4T3VrVlNG?=
 =?utf-8?B?UWZyR1UrRE5nQnlrUkRMN1U2TmMxMUpraHVWVG56ZjFKWlc5Z0haVEtkQUl3?=
 =?utf-8?B?Z2NIeFUzUnFrSVVDZjY4WWtvcGlOQnFNK2VqZnN2bHp3QmNEeUFabkxjdU1i?=
 =?utf-8?B?YWk5WnlkZXRsM0pVa00vZU5PN052Ti81c1RHR1R3dHE0U3paSXl1UEJyNXJU?=
 =?utf-8?Q?vvQQbUlVOCPN3zFxszZjBZA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07946f30-a079-410d-da82-08db19a712dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 16:15:57.1316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kavwUCo3Hbr8lS6Xti7EPWncO+NLvwA9jl2O7cn7AEb3SwgQ9eXqoMVCd8czcdZ/d0qj7A/iHuDBbs09WN4pphys0W/K6IPUTmMAwFYIXus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>
Date: Sun, 26 Feb 2023 02:25:43 +0000

> The current Gelic Etherenet driver was checking the return value of its
> dma_map_single call, and not using the dma_mapping_error() routine.
> 
> Fixes runtime problems like these:
> 
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
> 
> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 37 ++++++++++----------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 7e12e041acd3..2f7505609447 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -309,23 +309,31 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  				 struct gelic_descr_chain *chain,
>  				 struct gelic_descr *start_descr, int no)
>  {
> -	int i;
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
> +	int i;
>  
> -	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(start_descr, 0, no * sizeof(*start_descr));

If you allocated the descriptors using dma_alloc_coherent(), they're
already cleared, memset() is redundant.

>  
>  	/* set up the hardware pointers in each descriptor */
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0, descr = start_descr; i < no; i++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->bus_addr =
>  			dma_map_single(ctodev(card), descr,
>  				       GELIC_DESCR_SIZE,
>  				       DMA_BIDIRECTIONAL);
>  

Redundant newline as well.

> -		if (!descr->bus_addr)
> -			goto iommu_error;
> +		if (dma_mapping_error(dev, descr->bus_addr)) {
> +			dev_err_once(dev, "%s:%d: dma_mapping_error\n",
> +				__func__, __LINE__);
>  
> +			for (i--, descr--; i >= 0; i--, descr--) {
> +				dma_unmap_single(ctodev(card), descr->bus_addr,
> +					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
> +			}
> +			return -ENOMEM;
> +		}
> + 
>  		descr->next = descr + 1;
>  		descr->prev = descr - 1;
>  	}
> @@ -346,14 +354,6 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  	(descr - 1)->next_descr_addr = 0;
>  
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <= i; i--, descr--)
> -		if (descr->bus_addr)
> -			dma_unmap_single(ctodev(card), descr->bus_addr,
> -					 GELIC_DESCR_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	return -ENOMEM;
>  }
>  
>  /**
> @@ -407,7 +407,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>  	descr->buf_addr = cpu_to_be32(dma_map_single(dev, napi_buff,
>  		GELIC_NET_MAX_MTU, DMA_FROM_DEVICE));
>  
> -	if (!descr->buf_addr) {
> +	if (dma_mapping_error(dev, descr->buf_addr)) {
>  		skb_free_frag(napi_buff);
>  		descr->skb = NULL;
>  		descr->buf_addr = 0;
> @@ -773,6 +773,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>  				  struct gelic_descr *descr,
>  				  struct sk_buff *skb)
>  {
> +	struct device *dev = ctodev(card);
>  	dma_addr_t buf;
>  
>  	if (card->vlan_required) {
> @@ -787,10 +788,10 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>  		skb = skb_tmp;
>  	}
>  
> -	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
> +	buf = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
>  

(same)

> -	if (!buf) {
> -		dev_err(ctodev(card),
> +	if (dma_mapping_error(dev, buf)) {
> +		dev_err_once(dev,
>  			"dma map 2 failed (%p, %i). Dropping packet\n",
>  			skb->data, skb->len);
>  		return -ENOMEM;
Thanks,
Olek
