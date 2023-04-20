Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9E6E9796
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjDTOu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjDTOu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:50:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1B049FA;
        Thu, 20 Apr 2023 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682002224; x=1713538224;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8GP9c8pqSm4pXcvcyAMy62P3Xq2wnuFqpcM1Kue+xPw=;
  b=dWbRkA5gqu18+LmuaLwWoIjGIpg5bfWbLmk28pp5yYTXErfJtxiQqdB9
   NIaYg0VzR0bGuQyJk79S7C2Te76TXTB8Wo/YP9TN8kU8JeN/JDPiNFolo
   5YmFty9z/Ke4tt7n+vZn3/dHqOXv8Gksjm0bul3OldwJ8MP4GO2KRF68X
   0IamWT7gzEBybHhzseCil5pC2KULKqfpQpaoV4Vpvbr9OWZbBlWCcpn22
   uvWf9OQQTI/0MBtTqEnhTc5S0XlIDHLmeO3C4fU9cF5E91EDLgtmOycRz
   0ZimLNHkjNV7VIuiq+EWj+TYrjmo2tZ5rhEgDSgzLzBsplTLDa9x9wCWq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408667471"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="408667471"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:50:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724439489"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="724439489"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 20 Apr 2023 07:50:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:50:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:50:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 07:50:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 07:50:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDay/fwVz3On8xyIFqea6NS3qCEFRthLIL1HcSEWPPWW6jvywCaqlc6OC4YCYNzC9QSe14hpXfbZy0QgUWWWhLu0sfN1fU+vM9yo3cQyZQWUnKERefKw+YTfS75KGsu9UjVQpkqx0ooSv94kUeoxuYHs0p45atrU2bXbqJUwjumEWA2W4n7cHIBi1iLzKUPU0Wj+Njihe3mjeXcNBHEdtzKFo4zTy27yMKM7EB+7KNT8tJ+XoZ+0mmqnF4c5fO5oTTZnIDiROM2tKmZSnQxTHFBGsT08z0iKgfbpkeEZf5hVrJegeEl0q1c+pGKk6GhduoOG7GZgjpFyZTk9Z4Fpag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9y5vBcwdeYfX/cIHqeVwj4jcfFLcHztLIAvm+lHlIk=;
 b=BHX70XRTIrwiqhRBicaja2afnFzoWWQ6hmzPGSIVVHQsMm4R1nEbL7IHN2HEoV+bheJDxpGnlzVqNcwTBE8BO2ewrixqcgNhRAVCnuJ3tYeNOUQTXzArXEBapoyrMklkOiJnooynsiRoSnX7iFf/O/erSKssgO4a+bqMyL4AsNSc4gsalng3EUjFwvH1m6LEuiGccHZk4DycL81HeThfEIHwFmhtldIcfWickpyzy4C1mY9xJCs/9rOo35mQony9YUCaaWlqim1MI3MBbFixipcAGmEV3u34iuXMsbuyxUqsULyIPbngD5qEabO96krfwbZYzbnXrWfK/JgObF29ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY8PR11MB7900.namprd11.prod.outlook.com (2603:10b6:930:7a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:50:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:50:20 +0000
Message-ID: <f79e2dde-6d45-cc97-0cde-05454bdb5077@intel.com>
Date:   Thu, 20 Apr 2023 16:49:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: lan966x: Don't use xdp_frame when action is
 XDP_TX
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <maciej.fijalkowski@intel.com>,
        <alexandr.lobakin@intel.com>
References: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0118.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1ef::23) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY8PR11MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fff4f08-a47a-46e5-b57d-08db41ae9006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q86TThGrvvz2JRky/9YGMN0G3rsOWaitQARzAdx6cW8WHCVQaEtH59oZfniIOF6SoqWzyVVAhdtr/WAC1X6Oh+9koDhKzHYB3yOaqt2QanuGVG3Tqb+bmhwLeezxbVcZGjeqy3xoPtfozFDGAMFUKroa9dL+Td8+GDIfwd/DFCpgxz3XQoYi8cMre7yS+aALBKxw0Z6olCCDKHZ8scskFPQb0hawlPVnOr9X/8csRh47qDK/19du+nWod1Fke3MtsYrf9JL49EIvWi+iJh9py/MQ9g1COWhNtp6uT7GB8S/qQPhJ9n8+EQ/SBDXBRjw8Ri7ZMHyorQIcg5IN5V/I3+z5xCXT0756k2h4u9ZN9300bUW+lrAV0aHs2Zh43EkRtVq9IAgaWsl/+ysTQpJ+vqvCKDRzNsYUadmeWFGgAMyks1Byy46WR5oJcs7TYLCLYCebmVkHSR+Lx6YPFnXLGdiTbL4IWvLjP8MSj1sdsqdwCxr4S0f+WJ3GcJkWgW1Wr4u9T1X6Ty3Z1x0vBqpoxe6b2uTwkePuZ85+wgfNS4DFHlGhZX/YlGc1cUHNzocjURBeVzB07f3vWsMo4+2LanG3BasWOf87xylN3gciBdB/bMaOe2BjwPdPP4cmmryebg/LeyuYdEwxdOA1xfVNzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(66476007)(6916009)(66946007)(66556008)(478600001)(5660300002)(7416002)(8936002)(8676002)(316002)(82960400001)(41300700001)(38100700002)(4326008)(186003)(2616005)(6486002)(6666004)(107886003)(6512007)(6506007)(26005)(31696002)(86362001)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFpPdytCTU9GQS94TFpXdmJmWXJUcGtHNS80K0tBVmJpM0tDR2d0NjR0TlRl?=
 =?utf-8?B?WTBUS3lQbEhEQ1QvS0NLME02M2RmRFJwQ0tLeXVtYkFqSlpobkpsOEo0UXhP?=
 =?utf-8?B?NW9nTitNa3gxbk4xYXpMamFLWXd4cG81MDhpN0x3QzdLU3IvU3BoakRUbnI2?=
 =?utf-8?B?bW9NbEJiZDZTZXV1eXBXckNQdDF6TUM3WVNGL1J5aU9VejlkV2hteTNuSk81?=
 =?utf-8?B?QTFLQ0o4VjFwK2pyb21KcXIrYiticC9DY3F0MWJOcTRuVTNKeTBMaUhDU054?=
 =?utf-8?B?SWR0eVFtU1BqWE5PbVFCY2o4UGdJd0k4N0IyTXArZGR2SEUybzVQOWZBTmsw?=
 =?utf-8?B?NVNaZDJabDVpY2QxSUZuTWJiWlk2YU1Lb3piT1FBSjR4YWRCVXVwWlVjU3lm?=
 =?utf-8?B?akFmM1ZDSEhHajNoTjF3VG1ROXJ5VVRBdzNkbTB2VTZ4b2lCejJhZ2RWRW5k?=
 =?utf-8?B?V0JJUGFocC9Hd3RFYzNXK1FXazhud3NrdkcweWplbTd3NWF0aDA2TjlGZUs3?=
 =?utf-8?B?U1prczJZOVlra2Z0ZEJmbGxRMUhzbmFTam5OaWNjSkRHcStWbkJyZW55MGM1?=
 =?utf-8?B?ZGVYcVZ0TFdPZW4yN21obnE0M0ZRR1RkSmY5TmJXek9rSkZRZTBSakJoRDBz?=
 =?utf-8?B?cThzbHJJSFFKOGZHRVhRSjduVmlOa0szQ1UrT3hPWmlMRk5HM1dBb1FKMjFS?=
 =?utf-8?B?WC9vZXU1aHBDNUY4aEpwalNzNzMxWURndXora2J3ZDh0U01Mb29XMU5BV0FC?=
 =?utf-8?B?ZlBrYTFRZkN3b0tjWmFId3hhS3htN1pJWXhmeHRMcnI4RUxERlZGNXFPSWVD?=
 =?utf-8?B?S1dQYXluNldWeUUzYzRSbFhDYitkbW5Vb0xHZ1dLRVRuejRSS0hRRURuL1lC?=
 =?utf-8?B?b0xJRy9MbG5aK3laMTFXbXFha0JCakt0YVFnbXduVzJjUWw4dmhHQVRVWC8w?=
 =?utf-8?B?N2U1ZllEVmxRdW1iYlFJcEVLTzgvUVhwamp2cUdWYndsM3ZxRmFOZ241aVZC?=
 =?utf-8?B?VjdONFl0cWpPUHp2ajRPd1BmMWlwdFBKQ01iNERnZkNWVkc0U1EzVnd3d1hJ?=
 =?utf-8?B?L0VBNlBGbjNZN20weXMvdm9OQ3BXL2dNOVVxVDhmLzhhZWpVblZjVCt1VkxK?=
 =?utf-8?B?OVNKeFhsd00vZ25KQjlsN0ZsSFhzYTdlTGNydWRiZHdGUTI2aFpuNjZSc1M2?=
 =?utf-8?B?Y2E2VUgwZXpmNlU3cTdPazZVMjRrTUszZDR1eHlpZnp6TG8zOWZLWmlRNEhV?=
 =?utf-8?B?WjJTWFhCQ0Z2RE9KbEdwK1h6UXdCcTVqYW1wYUFGY2toL2pHdHM3T1NWdmQr?=
 =?utf-8?B?Z2tmK2dRSUZPRlFqVVRFcVNxYzBudlV3d2lvTGNQL1BzL2RldGRvWW9xcHl0?=
 =?utf-8?B?bFBLVWVtUEhjMS83VmtBOG1MOGF4UHRmNGVadC9CVk1DVlBrYmVzWUQ3Uk9C?=
 =?utf-8?B?clJVZG1OcnIwVFh2VUZCM1dmM2E2dDN5UDlDbnBHeW5LcHJ5WUxnV3k5MGpk?=
 =?utf-8?B?MytmalZIRFFvUSs5RFpaYXFDOVJucUxuS1N3WnErcDZrQ0FtVk41dWN5SUQx?=
 =?utf-8?B?dUZzV2d6ZFpLa1N3cVhsOWEwaTVhbFBiN1ZpMXQyMWZGN0JwbGd1YlR0Qkov?=
 =?utf-8?B?WjNFamR2U3lSeHFva0dFREFBWU1ZUDhJbGdMalRjSFFkcWRvekFrMTFGaVdw?=
 =?utf-8?B?OUdZNDdtVnRQbXJNSE1jekpXaG51dlpocEtBS25sNVNQbTFjZGx4RU1YeHRv?=
 =?utf-8?B?cStVOXl5NTVRdEt0dlJGTVRLb3BWS1BOazlENmk1emRMNVNBZmNrak1sUVlD?=
 =?utf-8?B?THdMY1o0MElNaUpLQTVSck5jbDkrM0R6NXhnYUtwK0pNN3FrZ1p0aGsyNTA1?=
 =?utf-8?B?U3d3M1RNNlF2aEhoNDI4bGwvejRGK0lPYzRyVFgrNzhJMUlCLzZIeEoxemZE?=
 =?utf-8?B?L0JtK0x1Z0h6SkRNeElycnN5bjNjbGF6MS8zL3BuY2ZrRmozRXI3WEwxTGtH?=
 =?utf-8?B?bFlWN01RSXhxc01Hc0hqQTMzQVppY2d3cEY3WlhqcGFzYVIvSXJBZjV3eHo4?=
 =?utf-8?B?OEFkdytJRVp1THR3c1daWEZ1YnplYWZhb0NVSnhmaUZqTlN3Rnl1ZHhHSklK?=
 =?utf-8?B?VUxnL2kyZ0FvTFhybjhvRTNIOEZJUFFhMERrTFNCNnpwSnRKQjBZT1N6MnNM?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fff4f08-a47a-46e5-b57d-08db41ae9006
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:50:20.2165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sI3gHp0Xu1fnfwoFuKoi4Ye0k5yvNgrn+jBxGyHXaakr3NrQPQnZ4rOMeO4Pe0FyqNQbC1UPbx2c3fCFzAwFMrLiyXSN5ktaHB483vDtyXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7900
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Thu, 20 Apr 2023 14:11:52 +0200

> When the action of an xdp program was XDP_TX, lan966x was creating
> a xdp_frame and use this one to send the frame back. But it is also
> possible to send back the frame without needing a xdp_frame, because
> it possible to send it back using the page.
> And then once the frame is transmitted is possible to use directly
> page_pool_recycle_direct as lan966x is using page pools.
> This would save some CPU usage on this path.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

[...]

> @@ -702,6 +704,7 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
>  int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  			   struct xdp_frame *xdpf,
>  			   struct page *page,
> +			   u32 len,
>  			   bool dma_map)

I think you can cut the number of arguments by almost a half:

int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
			   void *ptr, u32 len)
{
	if (len) {
		/* XDP_TX, ptr is page */
		page = ptr;

		dma_sync_here(page, len);
	} else {
		/* XDP_REDIR, ptr is xdp_frame */
		xdpf = ptr;

		dma_map_here(xdpf->data, xdpf->len);
	}

@page and @xdpf are mutually exclusive. When @xdpf is non-null, @len is
excessive (xdpf->len is here), so you can use @len as logical
`len * !dma_map`, i.e. zero for REDIR and the actual frame length for TX.

I generally enjoy seeing how you constantly improve stuff in your driver :)

>  {
>  	struct lan966x *lan966x = port->lan966x;
> @@ -722,6 +725,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  		goto out;
>  	}
[...]

Thanks,
Olek
