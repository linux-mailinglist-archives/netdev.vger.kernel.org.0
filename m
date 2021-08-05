Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD453E1AD0
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhHERx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:53:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:49726 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhHERx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 13:53:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="211113668"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="211113668"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 10:53:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="569488141"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 05 Aug 2021 10:53:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 10:53:40 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 5 Aug 2021 10:53:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 5 Aug 2021 10:53:40 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 5 Aug 2021 10:53:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeOGld0bOgMExwl9DKLCJ2akVz8aJR5l8T0OO+E/hlkEvWuA8p2moG8haig7hLWeE0FWo1ZSTwU+zNF+X1E9DTQMXtTheNPchaFaki1vJAIx9GYy+R19BgMVblTs0kGTTJxEdgaZkAHoJ5T+FbeF/z9PJOoSn6ufggdgEuM0iz6AZYAVTa0qg6UX4BH2B/s2RNTs1NcKUJz1EahHCjWUo6JcIOMkufWHA2ZzDbjF+ncPThQ89b3/ilKgNGxuewI2HxLDBCp66JxHYF4sz/l8Q+L9IRMLu0EkZUjXWGocI4zDSGf6CjPLE8yjXzyTbMbn/CXC8zSl75odv3DsTu99Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaaT6U2jOSaLZsMBobOz8rH3JhKy3TISsJy00SIOJsY=;
 b=h117WAMxL5OlmT9UTwVyHFVFeZdel7+1e+Nj8xjNFPbNsUYbMS3gUI1C0+gBUZcLqKEVRkxjQdHgDgNM43pVTG29WCqDWXeOUYJ3RIllZHDJH5WwvU1gLma+NaYquEtA25o+hwz65fJR0vcCu7XvxQBB3lSNhxqRObvq5/3fHGtwVyho1hwnI/KxDQDl8vZRZ6NHpKneRhH06YmVkul+W7QailHOGks8PNhqOHiyqDuw9e03wi6Sv5ol/C/XA37Lo9vHdlyvkNuN3FVQPhRm1WXKL5SwGlfMwH66aUB9GcwsuqkiAFsEfE9M2DSRGCtdAtlePrAvPHvDY0TlfAhB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaaT6U2jOSaLZsMBobOz8rH3JhKy3TISsJy00SIOJsY=;
 b=zhShWevOFisF3GyiKu0xjtpo9CokgqRlQ3yR6gHuGvGVa0SAFB+B2YZs5Gm+7NcbY4GpcT7SXkT7iA0/hk/7x7hUtGT6FdgARHVvV+2GE7kx45WN1Grs3jzpu8F7+K+0J9Ojo4fk2+qEdxXN1B3uye0AO/i8MdDEAhg4zUR1Ugo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:95::6)
 by MWHPR11MB1664.namprd11.prod.outlook.com (2603:10b6:301:c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Thu, 5 Aug
 2021 17:53:38 +0000
Received: from CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::88f1:7b67:d9e9:f9bc]) by CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::88f1:7b67:d9e9:f9bc%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 17:53:38 +0000
Subject: Re: [RFC bpf-next 3/5] igc: Launchtime support in XDP Tx ZC path
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <hawk@kernel.org>,
        <magnus.karlsson@intel.com>
CC:     Jithu Joseph <jithu.joseph@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
 <20210803171006.13915-4-kishen.maloor@intel.com>
Message-ID: <d94b762d-66a3-0d7c-60c7-86e798150546@intel.com>
Date:   Thu, 5 Aug 2021 13:53:34 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210803171006.13915-4-kishen.maloor@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:40::42) To CO1PR11MB5140.namprd11.prod.outlook.com
 (2603:10b6:303:95::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nbaligar-MOBL.amr.corp.intel.com (96.250.176.213) by BYAPR04CA0029.namprd04.prod.outlook.com (2603:10b6:a03:40::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 17:53:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa692f5-6338-482c-ceca-08d95839f430
X-MS-TrafficTypeDiagnostic: MWHPR11MB1664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB16647675D9DAFE8DA3A53045E1F29@MWHPR11MB1664.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUiA3HLmWV53eUuig5nzz98jjoTRSSZzjhzEHmARHVmx+7hmNzMIUXuSVCxhF5+JPr4BOo+y4b/3YA4jPRPHlAnKDPNXzjdQ90IgIF1AINuVU2ZRgTS1RjHyjsMT94HUOFRuHTruEjp+Cypq4F4w+XLVZAi2ghI2/HxoHibBldkr4vABCx+ZlMn8NoyB8okmF5J7vZy6SGniLaJURBE1p6t+s5DwGi5N/CVZNqMptsLqs3Nsx5MSkLCxagETthhtJ31qte8qCIi3GM+ZcrjGQ9wxA0ZJ/ZU2SQlUQIpwSgHZZRQMBrvLE87jLF1sm0TrLWQoeKo7Wgz9kX42n6x2pUHP7R2OnvKJ8fbvYW4XmxVKopReGZYI2mY1Nl6mMM06BAqHfm8XKtEZdk9ZG6jrgRJe6tMRAVzDkX5LRFToLpTsNuofXiSdZOwRtiDthwDLdA8e+2dg7z8xOJ9waB29XbLHLxyIp5HmD3HjhjfBRfGy7p7S1ebbQBKr8ZCNOKJyA3S1xn9OMq5iq+gm5gFWlt0Xn0iwYYTzeS+s6u2/EtbvUNfcdsyAMABnDsugzdKNHPnWh+MIgRcyMtDEQsESEFSP5YgelHuEj1Nk6+B/nzk5Mfgr0oJEL3JaOvG/S/nIHSlScXbUYqQATU0EH13AMg+etfyyUpZn08v2jay20Herhabntcf51DBQ/AsYNMJQ0qjPBG77AVhx8hUrg3YFoVTVHUPz5FQFeTRGqFMgBwfPtTvOh/jXy3MNjJJ/NiNxva2sLF7xotX8XkrIcx87ZETFxu0ftWZFkF8B8cDT1JBI7m+I5ugd4Ex/IuKXTsLU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5140.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(7696005)(6666004)(478600001)(31696002)(86362001)(966005)(66556008)(53546011)(6636002)(36756003)(186003)(38100700002)(26005)(66946007)(956004)(66476007)(5660300002)(316002)(4744005)(31686004)(4326008)(8676002)(8936002)(2616005)(6486002)(2906002)(44832011)(107886003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3JXZURDNTFPYnY0dlZnWkRoc2pyZVBrSVVVbjhBVkZBM05kUXEwaEV6dUFY?=
 =?utf-8?B?L05Dc0lGRmtPY242Z0pIdENuSnZIZkhhYk12a2VJeDdtZkV5eWxGcEFmdzkz?=
 =?utf-8?B?bE8xN1Z3NkQ3UEUrR0Q0YXpNYUFXb0VEeUQ1RG5qczVJVVhHOTZvMVdhL3NC?=
 =?utf-8?B?dnZ4Y05WUXVsWDJ5VTRHc0I4dkYrQ1ZnRFZCZysxL3h2S0lIcmdWcW5HUk9Z?=
 =?utf-8?B?UnNpRG53VmxVL0tPS0J5cDAzdUQ0eG44VGtHQ2p2cDlnVngzN3ppcElrR0Qz?=
 =?utf-8?B?a0M5M05EQXZRRGMvdDdVQnBQdytRZng2RGNBa0JpZStITmt4RUx0eXY3Tk16?=
 =?utf-8?B?ejZwSWxKRnFueGdvUnFDL2FCTjVKcnQrNHgvVG4rQ1JTR1FLbHVzdVVGSlNE?=
 =?utf-8?B?U2tZTW0xcVA5cTUvL2YzRDdiVWZYYXhKY2hnSCsvZkxzcmNEbVpHYXU2bmFq?=
 =?utf-8?B?NkhRWnA2RW41ODNJOFNudWFVS20yOXluL2JqN0g0Y1FGMkFheXBYemVxaWN0?=
 =?utf-8?B?TTZ5M3p5a3h4UW95TTBlYWhNTnR1SVZoY2tybXNna1h4SFE4NHJNR0o2Z0o4?=
 =?utf-8?B?TmtNV05LMkJONnVtb0xhZnJLUHdGR1p0SkRVMDF2SFQwWkpPV2luNHNseTF5?=
 =?utf-8?B?UTl2ZkVwdDNtV3RzNUtvbU1nNkJ6VWJNMWxqRURmVCs2eUtkN0NJbFN6MUND?=
 =?utf-8?B?b2NUMDNYWjFnWVJ5OUlYNlEyZ3JLOXhvVE1NSkRYNVYxU1U0cjE4OXNTSTlm?=
 =?utf-8?B?cGZ4QTZFZ2MxNW14OFU5Uk1YcTZrRDdrVExTQW9INll0UTJBNnJLbkIycVVh?=
 =?utf-8?B?OU10ZzhTaURSYzUvcktyUUR2akVyTk5Dbzdia0JkZzlTTHMyNldqbmlwcGNk?=
 =?utf-8?B?TEJLT3FVd0ppMitTOUgrMmcxb1NXSStkbWRXWnVtUXRNdSszNk5jR0NnZHdh?=
 =?utf-8?B?ZE9LM0xrWjZyQlpmekpEZityV0xyYmdwTXZKRE9zdEJoVXF0OUZTelNBRkpQ?=
 =?utf-8?B?YXpMbE4vU25ONVE4RzVZY3hJWDFMZ09VY2xDazd5YVVTdEQ3SWtBZHYxb1hG?=
 =?utf-8?B?aW5LUTRhVGNVWjBsOVNXR25leHkva1YyQXVZMkhUWjVkUFNqVDhxM0RhR0pM?=
 =?utf-8?B?Q3pZTFlRZzhnMXNrT1A0U1pvd3Bhalc5clBLWUpMZ2hJRlU1YVN0TmNMV2lo?=
 =?utf-8?B?ZVIzTnBBVzJnWUo5b2VBWWVjSUhIa0tTaXdxTUVmZXZDaFpLaHhkVkk1K2Rj?=
 =?utf-8?B?bmloT05vYmJWUzBySTFYYnBkdDZpbTJUVlkxL1p5MVZSc01vV3NuWHpiU3hM?=
 =?utf-8?B?a0tRRDlvcXAvNWNMVmJKVm94S0FxTGErU29KMDVTcGZFSVpERm8yMStXTDB4?=
 =?utf-8?B?djFyV2lUaERrMHVTdWV5Y3o5MGUxZVVFa05od3loMGtkLzhOY0h0WnVObG52?=
 =?utf-8?B?RlozbncyMUtiK3JsYm1idEIvdVVCc0JmL2lqRVlSbW1MaEd4WGRlMnZEL1ZY?=
 =?utf-8?B?MDUvM2d6ZWQvUWNBQWFKTmJZemFPNjFyakRqdW1FRWxLOTlQSWZLMjluQk0w?=
 =?utf-8?B?Ty80OHFGMkhGY3VlejgwdkM3ODEyTEhwdnlrWHhLVHU5ZnZzdy9DNjZEOUxD?=
 =?utf-8?B?NlhnZ0V5QmVWVENuYjBCYktKZUVPeGsrdWFZWWZDeER4aG9aSytnS2xWYVI3?=
 =?utf-8?B?aVk4eE52UVZBaUhrY055OEFSME82TStLQWYxbDhNaE1GTWtnTklPbVlpYXk2?=
 =?utf-8?Q?CWmwhnvva9bQaNiFnhB5fgkLk1fbJ9eCBOjYa4/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: faa692f5-6338-482c-ceca-08d95839f430
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5140.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 17:53:38.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nz0cPB2DTAD2QydTotaXivY01Ti9OJ37qxV3O3klsPrSldVJw/Jg1dLY/1gOr+3d3DgEhNzmvkOfI3dWHVKZtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1664
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 1:10 PM, Kishen Maloor wrote:
> +		if (ring->launchtime_enable && (xdp_desc.options & XDP_DESC_OPTION_SO_TXTIME)) {

The above line in "[RFC bpf-next 3/5] igc: Launchtime support in XDP Tx ZC path"
required a minor correction.
The fixed patch series is at the tip of this source tree: https://github.com/kmaloor/bpfnext
