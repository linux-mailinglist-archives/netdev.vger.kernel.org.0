Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ED66BB3BA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjCOM4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjCOM4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:56:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28801EBF5;
        Wed, 15 Mar 2023 05:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678884959; x=1710420959;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IQyA5s2mZ5GkgfdPfJrfWwpt0qKRDLb/ZoxL3Ot+OS0=;
  b=H7bQg9dAhYFf4uEwM7hAH3iGeFSw49RZQXJdRpjvu0P6fnGZqfW4xuoj
   VNK4S1y0gxJBgHXY3QkzhkgyxOEuO3rXhb9BzT5jHSVsEOwu8+Ui4hnmO
   ogCSG+Pwj2SVAISppjQp0UhqiaQB6XIlwexw9vVZOFnhNAeME7IA66RXW
   EDEYq5wNX9Ay4mNW79ucmtpTVdGKp5XuiKHXjmgdivS2+31hF1taV2NX2
   ZiKTUqVNdSEHkxd6gv8kuz3dTBbL7uuXQNtqf1W/TOuaA4OkjSmrd6nwv
   8x9cTllzQSw+xAFqhSLgUDXH5WBOOTmAWTf4RTFUb+SzQhx8+P03/b2kT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="318086871"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318086871"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:55:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925332809"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925332809"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 15 Mar 2023 05:55:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:55:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:55:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:55:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2oIcZVnZDOwaBCAqbqtTQbdo39IbdcnyBH2uhZ9ANQsUxW2882/20O3YryM9EFtX7fnSJDbMFUsLNICxS4HIr6Y+M9ILFBJ/sdQXXz7GxezMF8ZEh2vmdS4NuINhUJbCyYRU1vtGeNscpT4dC1KP+eHndghCjCW/ARwkY9uljsaoQxP2c4/0zD3HQBZ+rsoR3ZLMwg00ziA8cxChdH28tLKt5yH8GWbNCwzj0rsREnjp3up/SYlIReknm82WNACs2BPB9sCFBOUoDYgKJ2G8esFdrZKDUoAojEJiWrYbtjW+k6HvFLk//0vcVoorSbdjm7bUekxCSRg+D1cXe9dMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnU2Rd115zuI/PcDVbbwapBx7Sa6WkEjKMrLs96l6qM=;
 b=eatPdx8lb5jVKJB7kDu9mPvMK3KEIt3ou3/SaziXBwfIcPOioqQrEitk8+GvqkuxDD/sfsWrvIHmCuL5eymm+VK6PSqJz3SFOtWTNIOOaegplPZvLSrIwNEpAS5br9OP18AvQpdVD1mEDDNKgqtjbdHaVzsNOaFC+fZut8pgMkPExQ9yjAHw8i8Ut74nCsOttZ8TZ5E+SayplS3W1pLiGEy6qryIqV2Xpp0rVNfK/pXY/vFyWdu8XpsnrTvvLUytCbTt/LbURvhCcYrBSbOYjHrJd77oppAByslU5aI4iqToxpdd2kzDA/ESWO4yCha8UNupLF8fYId6xm2FGIG33g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5110.namprd11.prod.outlook.com (2603:10b6:510:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 12:55:56 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:55:56 +0000
Message-ID: <9acb9b6e-d998-fd7e-c370-3b6160cfda40@intel.com>
Date:   Wed, 15 Mar 2023 13:54:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [syzbot] [bpf?] [net?] BUG: unable to handle kernel NULL pointer
 dereference in __build_skb_around
Content-Language: en-US
To:     <ast@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
References: <000000000000f1985705f6ef2243@google.com>
 <6b48673b-33a2-877d-dadd-b43a1364b330@intel.com>
 <ec94dad7-188b-96d8-9005-74f507d96967@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ec94dad7-188b-96d8-9005-74f507d96967@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0482.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4aa16a-d0b9-49f5-f5b1-08db25549dd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5CnlHg64Xv86xS4eJ3fvLFG+3b2Q68D9lLnGyCZKT02RxYDSwdlAfcKGbRwUXR84JNCBrmDhCwMPKX4PzDCgryz8XGu2WuDL6ODgyXyBjGgHnNY5vTQg4rX8HZ5v+D35Zb6b3tZmlSPd80OT/mhGxFY4nEc7lzGjl4Pq3uP3VGjWBxlthgt4whgUNkAobWls4baA8KBDZ+Qd1zjLeykSTIh7J3tF7m29QHCnY0WZxcgjDsiT9cp1Ruy6cQtvjhjh3Z373WiGGs1DGxKbAumg9ECLxfE0IN2qJXNM10vo0miB+HzGDJMmRTItONVJw1/0Z/8QVZl4DKeA9l8A+zFuhEr6ouSwh7LqHnHZz2awJaTLOUr/EjupDQxZLPckD3KYdWN18mOzp2zBUidGzU3RtoCDPT8AqFl146gr85tg0g6QzhS4PGKRNdFZIvXbs5/Vxc0LGWvixovRwwUtmjbreqCNMxkyw0kbps6SgKxHpD07B4cXoqoyij8J69IpOYS5yCWL6GhVbA86bFtNfMJNib+KQnwQBrBwXqzNMvfmUzjEwhz2foAwY+vc830bNkXU/5y+VXEOoFgwjbj1UBdF/BhRJxQsf8Cww7L6DxLe9yRBOT43BIIs+VhyCiEz5g6noJa/25zlxbPtOWlleIShtOTyNKakZB4+BEYKeVvZDFWljxb19tzMdBpYG0DZmHyknhYNwGHQyd4Eu/fv5BZKCOcgH0lWFNKQ6R3Lip8vfA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(36756003)(316002)(478600001)(6486002)(5660300002)(8936002)(7416002)(66476007)(66556008)(6916009)(4326008)(2906002)(66946007)(6666004)(8676002)(41300700001)(82960400001)(86362001)(31696002)(38100700002)(6506007)(2616005)(6512007)(186003)(26005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3l6SXlISWh6clJadUlmNjQ2YW5acjhQdXZmSGo5cWZpdE42enNBZHJyS21F?=
 =?utf-8?B?eTBoclZkR044OU1waGF0dm90WVFEaU9uSXhjdGkxOW12dk9BQ01PT0t6Umhi?=
 =?utf-8?B?UldrUGFTOE5mSStEZGZtaXM0ZGpXc05kRzR1Ykw2S3ZIcXBkZFBIdW9BZk0r?=
 =?utf-8?B?R2hWSHMyM1AwNTZrZ2xFY2ZUQUpnS2tjRW9rUjBCSDMyaHFXZ2dwZXg0VmtH?=
 =?utf-8?B?REd3R1J0ZmgvSDNBczhkRndKeWoraGxDbDQrdkhHMXYvNmJsK0lHa2xxNjd3?=
 =?utf-8?B?a2JxK2FQMlpaNGg3VmRGeHV3WFJVWU5JWWdDL0pZYUJxNzlKeEhCQmxKanh5?=
 =?utf-8?B?OWhwNFpKRTBOaTFIdXRKVEw2ODZhV3JFNjhZc3Y3Q1I4amxmRHhkdlJSUUxo?=
 =?utf-8?B?VWppbXVzRlFaQlhqdUsvcVF1cUd6b3NHMTYwTEdkVXhKSVB5cFdQRjlocUw1?=
 =?utf-8?B?SDVHRGY2MGFmWDZYdXNHRUVZRDBSMW9EaDA4Y1ZJTTFkejdSN1hYZzJoZ0hZ?=
 =?utf-8?B?aVpaem9CUVVUaFFQYU5LY2RtUXNZY1Y0RlJZUXZtcWNMU2RaUzlDNVRkZmNC?=
 =?utf-8?B?bktLWkVqQy93eDhBYkZRUjU4QTVvaHpBcDhGNTJybUtaa0JEdHkrOXNmbnJU?=
 =?utf-8?B?NFRhTUhuRkVZZzJ5VEFiNHhtZFdNTW9taEx6WXp3bUErdTVtbjgrNlRkeHk0?=
 =?utf-8?B?b09tQ3JoYkttL1daM21hWXRjMUx4c25UdFd3Z2gwQlMrM0xWTXhrWmM0OEtS?=
 =?utf-8?B?SmNLYkRLajNpS0tPQ0Q1TnNmTUVXa1NBeTVOQTVteS9aaUZ0bEJMNTF6WU5v?=
 =?utf-8?B?VENtK2hrc2RYY283TTlyQmpEMDJ2djlCNTh1QVF5ZTE5SFpCM1RZTWtaQXdH?=
 =?utf-8?B?empzbGZaNVY3WXhoM0xMMG5hck83Vk5jNmwwc3NOdURIRFBrR0RYUEkrTk5r?=
 =?utf-8?B?ejdJOVR2bXF4U3VLalVHSE5LOGF2cEp2K09OeVBDSXZrRWRBQW9GN0ZGVnFx?=
 =?utf-8?B?TGJacTJjQjl6QndPekNFTjB5Q2NXZWlRUm9hTDJDVktUSFpxcVRiTllRMzc5?=
 =?utf-8?B?OU5uQjFTeGhEWWFwTzhIdjJCZTAweUxwbVNHSDgwbXprVmdzTHVQMjBZSndu?=
 =?utf-8?B?U0Myb29MSWVBSi95SUJnd3Y0UDNmd0piY3NhZ3FSNWkrQ054dHJPNVNEdWMz?=
 =?utf-8?B?NXlqaTEySTErYmZtamhxM0I2TXJXdGJhYS95UmtZcElrQzQzU0NCQktMTmRo?=
 =?utf-8?B?bkFRMDdJVVEzbjRMUnE0L1JXVjVTTkJvM3RMMHVWeFVuYldpekRURHhkYm9m?=
 =?utf-8?B?Y3VXTDRhUDlyZmxWVlF2S1pHYk5zemNPWEJ0TW9DTmdRZS9vUzZvcm5jL3Bs?=
 =?utf-8?B?eFg3TzVWbTVsMit2N3FQeXJ0Sk1xQ0o0VnExRFJlWmFuNGttTkU4ODQzak5w?=
 =?utf-8?B?RnFqNXdud1A0V2JmU25PRFlEL1RBS1hUUWN3NngySHhZZU9pZFVWTHhVby9H?=
 =?utf-8?B?VlFWTFduYmcxM052bjhPTWI0MERzb2NKVzhYdGhDQkFQVFRaalRiQ29sVWNz?=
 =?utf-8?B?M2ttTlBEbllzb3pNK01ucGZZUjBmZURhTGw2d21wNFNRMGNIY2N2NW9QWk45?=
 =?utf-8?B?K3dxVHRLRWFPMWtKQlZsZlNtR3gyUUhkYWhyOUVzSnVybmhFaCtaWklsdlY0?=
 =?utf-8?B?TXYwWWdpQ2ZmTy9lR2F0UEp4cERsbEpTYmdiOVVKZExZZUJDTUFucDEvaTFI?=
 =?utf-8?B?OGVXNlVLcEtUdEhkOWNES3JFUUlVNjhTVlV6K3ZibUplYmVuNmFBczhQeWhL?=
 =?utf-8?B?WGlQRHVwRFVKdklzc29QOGdXMjJLZmpCa2RCb0gyZmY1OTBlTkV5cTk1bStl?=
 =?utf-8?B?Wk5nRG9zZ1dyM3dwWlRJaU5wazlaUGhodWNMb2pnYnFhRDNTSnFBZ2psMFlj?=
 =?utf-8?B?cE15eWZZNUMzcnNiaHEreXVlTE5tODFZVzRiZ015cFcrTzBUOWlIejcwZTRa?=
 =?utf-8?B?K3orV2xaMGU5VW83VmczUmw5andTc3MvSXV5eXQrVG9NT3JMbFpqbmlybndW?=
 =?utf-8?B?WmpmRFdYUDZwck1EQUdsSFlhdW9URkRKUEx5QXhCaHl4c01OVm1tU3pjRFhk?=
 =?utf-8?B?OVlFR2d0WVhOakNJSVc0Ym1sMUdTR0QwQ29NbmtUZ3loWWRDR0VvaEFZcVRD?=
 =?utf-8?Q?A53FfOMVzcu9+mCASa4bCYo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4aa16a-d0b9-49f5-f5b1-08db25549dd8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:55:56.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHttMKF9c1gvrMV0fzaLMqn7wJqi9cM30UMjGTn0a3OT/reI//jASkkL430GnKPERWYt240wUJg/v/gG4g8H9XSLbVbrohnRIV5X/YK0Fl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5110
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Wed, 15 Mar 2023 13:51:23 +0100

> From: Alexander Lobakin <aleksander.lobakin@intel.com>
> Date: Wed, 15 Mar 2023 13:10:44 +0100
> 
>> From: Syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>
>> Date: Wed, 15 Mar 2023 05:03:47 -0700
>>
>>> Hello,

[...]

> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 6a8b33a103a4..5b9ca36ff21d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -217,12 +217,12 @@ static bool ctx_was_changed(struct xdp_page_head *head)
>  
>  static void reset_ctx(struct xdp_page_head *head)
>  {
> -	if (likely(!ctx_was_changed(head)))
> -		return;
> +	if (unlikely(!ctx_was_changed(head))) {

Must be `unlikely(ctx_was_changed(head))` obviously, I've got attention
deficit or what :D

> +		head->ctx.data = head->orig_ctx.data;
> +		head->ctx.data_meta = head->orig_ctx.data_meta;
> +		head->ctx.data_end = head->orig_ctx.data_end;
> +	}
>  
> -	head->ctx.data = head->orig_ctx.data;
> -	head->ctx.data_meta = head->orig_ctx.data_meta;
> -	head->ctx.data_end = head->orig_ctx.data_end;
>  	xdp_update_frame_from_buff(&head->ctx, &head->frm);
>  }
>  
> ---
> Alternative version, which fixes only this particular problem, but is
> less safe as still assumes only xdpf->data could be nulled-out. It can
> save a bunch o'cycles on hotpath tho, thus attaching it as well:
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 6a8b33a103a4..55789772f039 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -217,13 +217,15 @@ static bool ctx_was_changed(struct xdp_page_head *head)
>  
>  static void reset_ctx(struct xdp_page_head *head)
>  {
> -	if (likely(!ctx_was_changed(head)))
> -		return;
> +	if (unlikely(ctx_was_changed(head))) {

(here it's correct)

> +		head->ctx.data = head->orig_ctx.data;
> +		head->ctx.data_meta = head->orig_ctx.data_meta;
> +		head->ctx.data_end = head->orig_ctx.data_end;
> +		head->frm.data = NULL;
> +	}
>  
> -	head->ctx.data = head->orig_ctx.data;
> -	head->ctx.data_meta = head->orig_ctx.data_meta;
> -	head->ctx.data_end = head->orig_ctx.data_end;
> -	xdp_update_frame_from_buff(&head->ctx, &head->frm);
> +	if (head->frm.data != head->ctx.data)
> +		xdp_update_frame_from_buff(&head->ctx, &head->frm);
>  }
>  
>  static int xdp_recv_frames(struct xdp_frame **frames, int nframes,

Olek
