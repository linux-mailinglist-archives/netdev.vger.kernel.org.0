Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8AC694A5C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjBMPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBMPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:07:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A21101;
        Mon, 13 Feb 2023 07:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676300868; x=1707836868;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4YLzazmhXyDFZz9jW0vYkLnVWx/q2KltMV4QzbwKbfE=;
  b=CmraXgqGkGO/2iMzm195w8HiSYMUX2OHwInCjnEsfvjMZcez2nXHhGof
   qYy1b380tgzsXrKV9XnQmk8MYI8q/GEoO++mbU0WVOSLWUSXqJYJqOAgY
   O1aNuXBpR0G+yyulmi/O0ERMFCyecDy48FgCMoaOZsiK/Gaq4wdQU6gfb
   0uHmyEKEQfHawBfXxRmR8HI9XGBvX9Kl/OwUlTi04dQ9m5kewv8rhXM2W
   kssWFSDHYra9pEcMdNrS5/zujRwD3xoop3zw9rpLgn/o1AoXjZJ5n2r0H
   SS0PjXDAMK7VPaXEqTXlYNSn2KboGiAqfiAysFAkU+Gf/0iimeqmLcR3C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="330915502"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="330915502"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:07:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="668827711"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="668827711"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2023 07:07:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 07:07:04 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 07:07:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 07:07:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 07:07:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2kAdomVz9Qeq5Eu2WBv5cXaIyZnDK10Ei0LqSkuh0oVkOVs/cPelIJ2b+x4zyvBTuk3tAplRBbfsf+NFFCE++huTfSWCnqtTHHdpPIpddQnM/O5x0V3eEM59w5v0igMh0smx9abz2roZPa8IKf3udEEpOInSdnfUQVVCyzMQlFti7i4YYIDHtU9oaF/h7wCwZyWyLsD+DKkRV+L8sulkLalcol0954ruFLIa/2NEd544vbxDG1+O3WOhoKMPJ78R24ZRhxrNjC1C36tBHyNg7tlmOwMR8Z2Fg/f40xHZVyQqCrh9KI68M0iVOLomGpuCXEb7fTaxTS3PYWSTYDvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6/WpHO0zr6i/KMU5nvHfXHlQwMW1d93L9bpF9lKmVs=;
 b=fK9uiZGpQadx32dgydSuuFJnD5cGfbtg5qraVjB2qlJKoMsTJW9cmLKEhjghYmzFThSCKZaI+uuUzJ8x0LwVQK5qric3tLOh5r+Ux4aKLjT47s3Wlb1v5LAF/cThP84C8qid7mbd/BSuZbQacg6OeFFEznGXE++Sh7ANpz5Z8jhP2uKMqDnj2shS1qG8cQ63mIpCLTmqz2HEGgw+pvQR4zC9LJAUZbB5GTbQy4H1HJhwYQtxp0hOQIm9f/EWxyzopuu5LzpsvLM/Kqz1JEZ7N5v5wrqywhCDt5l98Zyt+Oub3GCobFozKWW8x1a4TObf4XzPthZG8W+dDBlNNKFgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH3PR11MB7348.namprd11.prod.outlook.com (2603:10b6:610:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 15:07:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 15:07:02 +0000
Message-ID: <cd8907dc-0319-6c04-271c-489ca4550579@intel.com>
Date:   Mon, 13 Feb 2023 16:05:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Content-Language: en-US
To:     Shigeru Yoshida <syoshida@redhat.com>
CC:     <jchapman@katalix.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gnault@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230212162623.2301597-1-syoshida@redhat.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230212162623.2301597-1-syoshida@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0576.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::23) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH3PR11MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 3497b136-ae59-4621-f475-08db0dd3f5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nc67oRtokU74X3wBrhruBFpFhYHZUtizoWJ1txpvXfOVQrp+xnQlidetSGRtGE80ZxPW8mEPfYVvgB1LxwICSBan7zD0fuHhrO5ORJrqZf0dXAmvKQ8AhbQ9ZNDaSxFBwUBKAKkwMo01/UDTEe2iSFZ4W3nbG11X5EUfzCtAdT69YCafu+83rrHsBN58RD/+ca12ykwEQKnSRkLoUjxKzVR5BsF8h+KcmXT5ci4ovkbdZ8TNPnuCouISKeFQ+r4Z/BC8IDucTmiKseG+r4//XFDJFEZJIMvwROCFX2FJuthtwzsM8VG+1TES0cwBgai0TOlhrfuTKeVN8/WJmgz5N3WjFlparLeG2dWwBvIJk89ANsONMM0oZfMx4+oxEQboUBxfayvTICyzbAJVSf+plrkZSeUdLzYuOtVtDq+aCdf6nuvgqpFqSXZqqEUKwga+m2EnOruUYs2lO4S1Yj0WaHCnSGyM9ZY7fteTTHu/sH0qMgFgacNsoFe4G0JEVTg3YnAKFilym0rnjbqcsRerkfqWJZFzUdOtgtglvL4Ir1eU4/UPxnG63VkZoTfuKdA9PQypeZv8enfwzSyqaW7rNROn9z1o4MAdQ40VtLtGPLsKqnCI8jiVtFZGa0f1FTqzxRYQ4x7oNESDfKNqo2sHHzTpepxiwrHDfJRIQSVx4/n5KCbwEqoZ9vXmJvdaOackkR2NQH0SjLJ+LjuyqVBaBXvMv12XY4m5Uxto/EnNYcQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(83380400001)(66946007)(316002)(66476007)(5660300002)(8936002)(66556008)(4326008)(6916009)(8676002)(41300700001)(6666004)(2616005)(478600001)(6506007)(6512007)(26005)(186003)(6486002)(36756003)(31696002)(86362001)(2906002)(82960400001)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGdQV2xrUU16d0s2SmVCUXd1YVY3MEhkb0ZNNFQ4cDBJSjZqSGxMeDNZVUs0?=
 =?utf-8?B?dFI0aW1jR2VXSjJwVmFvV2VNaEwwb0ZVR3V6ZDFIakpvSUFxaWFpZEJWcTdF?=
 =?utf-8?B?SGtYUDhHNFloM04wVjFtbmJOQ0FEQlpuOWFVMUxZWnBCaWR6T1JldERtQzR3?=
 =?utf-8?B?bThQbFRXRlMxUzlwTlF1cU5MSFV6QnR1TWtITG9oTWd3cmJpSlRwS3RFOUZP?=
 =?utf-8?B?T2ZMLzBYTGxseXZVV2VIME9rTmovaDRSbHRhMEk5aGVhVUFlYzRGaE5FcC8z?=
 =?utf-8?B?UlVDeTJJV2NUUVhpanFKbFAzRzdhdDZQUWNDU3AzNUZvRytHc0gyZTYrWVR6?=
 =?utf-8?B?QU9LbHQ0VjZTZTdMS0V6d2NoNnRPbmQwWUd1L3ZVRjQ2eEd4c0VvYWZlRDlw?=
 =?utf-8?B?WjhMUDk1Nzliczl6UEptTEc1TlJON2lJRDdTZExMQ29INEhHRlE2MnNMYS9Q?=
 =?utf-8?B?RGprNGhQbTQ2UzZ2TzZXaGkwRHEzaTlVWFgzbDk3N2dMUXV0blhuWUhTOGtM?=
 =?utf-8?B?SXJrczIrYUhGdEhRU0tneWdSTS9RTVo0cmFlUnpIekFzbHJxbHNlZlNRUURn?=
 =?utf-8?B?WWF2bjNMcExXeEY1MjY3S0JIajNaOFpOQmxOdzBxeHZqR2RuWmx2ZklMbWdk?=
 =?utf-8?B?T2ZKSHE3aTNVRnJjbjRQYVp4ZTFYU1hlSytwUG9sbUtqVG9YcmlNMkdHYkR6?=
 =?utf-8?B?MG13L0dzYUMwbnhUZTJoR2VEVnlydS9JTVE4eTF2V2ZGd0dFUkltYnlQcjlZ?=
 =?utf-8?B?d2hmemt2MmNGRS9lWUI5Vy82SXkwdU5yeXRtMjNlSWRreFUrN0dWSisyWnU1?=
 =?utf-8?B?OXZxVWRLVHpRWWpWSUpSSlZ5YmFPNFZCcTJidm52dE9zdnNtQkZJRlNCbXZW?=
 =?utf-8?B?Z0Y4bnpIU3N6VWdvTWtTZmE1UU0xTUg4MWxGWWdaSXYrdmd2cnFWNzJ6bzFK?=
 =?utf-8?B?QjZKZWRmQkQ2bzB3L1VZVnB2K2sydEc4TXJmYnVQMUNZclVqdGlwejAxVVhw?=
 =?utf-8?B?eWRCQktsU2luaFdrMUY2UHRJUmVwMDhtY2s0ajZRTEhJdHVWT1FkNWIxNUor?=
 =?utf-8?B?dmNyTTRwY2xvWWw5TjZzQVZEUm1HVmw2Z01iMndOdWhucWRzMTVoaW1zR0E0?=
 =?utf-8?B?MHhNRkdGeHRaUzhJN1k2K25JWnJPZGFkeG1vbDFxM3F5OEUwVXBhYWQ4RVdS?=
 =?utf-8?B?N0h6clJYTTl3RVJVQnlBRHhMSVpaS1lqb1dUa3NLT05pdGcvQ2ZjZUNYMUxW?=
 =?utf-8?B?QVZyZlpla1BydE95a1BaalNqY29TSnN5M3JEQ3JORlMrekxDNnN5U1Z4R2RM?=
 =?utf-8?B?UzRYR09LeERJOEZlQ1N3T1NwQmlUWWVPcmhlejAyYVpEN2JqclQwWmR2UUxv?=
 =?utf-8?B?RkQ3Wld2UUpXLzhTeUd5NmkrQXBNSThENWlSWUhwVlpOMUtEY0RWak9qQUta?=
 =?utf-8?B?NEsveHlEZ091ck1xTHYzVTRGc0xlVENQdytEYjdDMkVFMWZxSFoyY1FFN1VB?=
 =?utf-8?B?cHRPb2VVOHdWMUgrd1pJYUs2djFmd25sVCtTc3lRcGRKTnNKbWh2UktxNnkz?=
 =?utf-8?B?dUNMVWFsL1hUU0Y4cVE3ajZqMzE3ZUh1RDU3UjJDOURIbHhKREtFN1V6WnVT?=
 =?utf-8?B?eEtJdXY1cThqdDN0V29zbTNHdWFPTGNteVNJQSt4bUVFenVWUHgxblQ0elkw?=
 =?utf-8?B?dmNKNko1aFhVaG54ODAxRGEzTkIvdURDN21VUncvN2dXMWNYY25wZ1I0Lyt1?=
 =?utf-8?B?cGNDVnkwL2ZnMFRjQ2YraVRyR3lHTXNxcFROT1BkS2UzdXVJa2Q4S3VsZUti?=
 =?utf-8?B?VG1vZG9oYm9OVko3aGJVRGtGbDVZbFJjcGxsSVJHUFlZeXVOcG5SQjJQV2Fo?=
 =?utf-8?B?QUNnYkgwSk9Xa2ZsNTNLK3ZWMHVSaHZsYS9MZ2tnZ3ZreEh0a0crT2JTVjI3?=
 =?utf-8?B?b3RsZXcyQ3hHMUc2RVZXejhIcnFlTGRzZTU1V01MMHN3bkZ0QnE2c3hvUVdX?=
 =?utf-8?B?UEhvRUhTK2FFUmw1bGJSMlNIc2Fnb2t2SlRhVTBFZVZlL2tRdVgrSVVjRjBN?=
 =?utf-8?B?aWJBS1ZFU1U3cmZmTlVzS2I1WngxWFZUdkVNN0ZFSWJvalF0RThINnlNSHQy?=
 =?utf-8?B?NGZkb25XaWp1WjVMNjhWcWNMdzEycVcwNER5S0dIakVyUkcrQUp5UCt1Ujls?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3497b136-ae59-4621-f475-08db0dd3f5f8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 15:07:02.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWB+IEahCC0IXB/kcrwQeuGiMmjqJQmRjGF9lZJtrpKK5arZRVQynfrltRvzWwGhJXpkIhUYz17J3aSiszfAfqIH/qW39TdD32XoBQwCkwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7348
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

From: Shigeru Yoshida <syoshida@redhat.com>
Date: Mon, 13 Feb 2023 01:26:23 +0900

> When a file descriptor of pppol2tp socket is passed as file descriptor
> of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
> This situation is reproduced by the following program:

[...]

> +static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
> +					       struct l2tp_connect_info *info,
> +					       bool *new_tunnel)
> +{
> +	struct l2tp_tunnel *tunnel;
> +	int error;
> +
> +	*new_tunnel = false;
> +
> +	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
> +
> +	/* Special case: create tunnel context if session_id and
> +	 * peer_session_id is 0. Otherwise look up tunnel using supplied
> +	 * tunnel id.
> +	 */
> +	if (!info->session_id && !info->peer_session_id) {
> +		if (!tunnel) {

This `if` is the sole thing the outer `if` contains, could we combine them?

> +			struct l2tp_tunnel_cfg tcfg = {
> +				.encap = L2TP_ENCAPTYPE_UDP,
> +			};
> +
> +			/* Prevent l2tp_tunnel_register() from trying to set up
> +			 * a kernel socket.
> +			 */
> +			if (info->fd < 0)
> +				return ERR_PTR(-EBADF);
> +
> +			error = l2tp_tunnel_create(info->fd,
> +						   info->version,

This fits into the prev line.

> +						   info->tunnel_id,
> +						   info->peer_tunnel_id, &tcfg,
> +						   &tunnel);
> +			if (error < 0)
> +				return ERR_PTR(error);
> +
> +			l2tp_tunnel_inc_refcount(tunnel);
> +			error = l2tp_tunnel_register(tunnel, net, &tcfg);
> +			if (error < 0) {
> +				kfree(tunnel);
> +				return ERR_PTR(error);
> +			}
> +
> +			*new_tunnel = true;
> +		}
> +	} else {
> +		/* Error if we can't find the tunnel */
> +		if (!tunnel)
> +			return ERR_PTR(-ENOENT);

[...]

Thanks,
Olek
