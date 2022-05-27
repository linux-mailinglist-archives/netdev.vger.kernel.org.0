Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3215365F3
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 18:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353173AbiE0Q04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 12:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiE0Q0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 12:26:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D565344C6;
        Fri, 27 May 2022 09:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653668810; x=1685204810;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ldYq+5OLaDjiX2Q4QhS639Ru0kvnLYGineNvd4dyZc=;
  b=b8xBZxqfc3u1hHy5A+5TQxD3pDKy1s1YhaVl30VBZhtlByg5z6pXDy1S
   e+b355V0xj/rAIJ5tcAwVZuUbM6GcCFq9HTAhhrVsDUTIQzhbUPHv5L4i
   yPP2ktpXN641Sg9u2bboeBIb2du3BbPbDRgjRJ6Jib352TWgNcH6t0dws
   mcMvpIPdfoNCBMwLaXDboduTzbQxfOg1Sj1m4dBNhRsYhBcAloK12dmis
   tD7UJOslTjHigC1xmmU9l++yK1QyOujrAzfgrJk5F+eMlwo7N7PF5Ysd3
   76KOlCWG2PSkXXZWNZ9zUjy3y62p/Sm4V6NAYTt3sVB6Estawfq/cNSWZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="256590964"
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="256590964"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 09:26:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="678061082"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2022 09:26:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 27 May 2022 09:26:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 27 May 2022 09:26:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 27 May 2022 09:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5AfJCRMX1IXphWN/15w7ZODStZ7C40++/xsE+EG1vgWw27rVCQe1qqCYYnEWJT6LmPrMq9ar5m0KcxbxNff1UJyQi3UeMPIkDoc12YWayQiE7gBY+B59dUjUMtLJJvl26aTu+VHByKcD6gIyGkD5OQzG7q8xWkltnySryAxu6c2LWfn52lCIuJz1/S5JSCY/cVFQU8cwaOuW7nmSM2CeXXeAe4vh6jaorF6CYP/XPxbdMzASkvpZN84cfL0i1SDMzMMFlgVgTz9Syqmaj4P7fkpwzN4aocnVSUrIKwEYSGPgJlZCLZa1XP8xFw4GzK7sYURUs5y83bKQYFcLzM4ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SNkc7Tb65kk07OA7e6rEv3DLvnqx16pxi4u2wPEc8w=;
 b=FuHa7iT7KP+cN1YRBQd4JV2shJLaGxJ84TIXXtD8TVKgyFVMu70ChnqiDTqO7p8zF0VYiPUcDHjWd0yv/uQMwmd4Xk5poBRVUTq6dn+L/GJfwJnq0LfepZVCFtEb9T+9YwnQOrM0G4VeO0lprFRL8JbC9sIXiR27cZ17QO/AqsP8jcp+LEkdBqKvQZfh6gOlupnV+lBd1NnP980qtbMdU48oOlqdGUCwwLsj5CA9TT5jX/b1Q0YK4QoyzCiG+W6NRsu0iDFlJ41LzFPiAr42M59Bh6US5nHzxeqsXtSApCN5gBGnqkq38UqPEvxjavKmbhDEoXhhhp0/jqjlxu2S1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2592.namprd11.prod.outlook.com (2603:10b6:805:57::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Fri, 27 May
 2022 16:26:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3%6]) with mapi id 15.20.5293.015; Fri, 27 May 2022
 16:26:45 +0000
Message-ID: <4344ab36-e925-b68f-b54e-4cbb55e48836@intel.com>
Date:   Fri, 27 May 2022 09:26:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/2] igb: Make DMA faster when CPU is active on the
 PCIe link
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>
CC:     <mateusz.palczewski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220525113113.171746-1-kai.heng.feng@canonical.com>
 <20220525113113.171746-2-kai.heng.feng@canonical.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220525113113.171746-2-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0034.namprd16.prod.outlook.com (2603:10b6:907::47)
 To SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb000297-7abb-499e-13f6-08da3ffdb0ce
X-MS-TrafficTypeDiagnostic: SN6PR11MB2592:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB25928DD436CF42DFF8F7EFFBC6D89@SN6PR11MB2592.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: upc2LppL0NTY9FH2B1aj45N0yPQJd+mxh4ajbpMuInsqON5pab7fv+DalAj79dT8E/r9haC9Sucgo3Mh40JpYNio+BPq1P2ikV4xB0eghHWt6skEttOXlmRcwS2QflIa9+th4DElRKGZaSmVXorENXu3gP2/Wh+S4ILNZkw3xk6rEtYEMFFQ7ZhVYjK5YvEenYycc+08sFuCN09wrVKDF+dcJ+8YzXNuwbxhHb+k31jJzobSYCf5TFaVt3q2EkU117Kodv2vj1gn8tCX3PhHVB1c84pBLS6nm46kj/+8CIQGLCQgonJOE0LnF1xtwAs0/NVvDSESNr+hLRKUZIA/x3935IIzslqN4xiD+GM7rPlzbA0I6XabxcPF9nIaJsf9kxbUyZX+XeHoeAJNfreELZRLJ1yyKLBfyGzFdpJt/zclkRYeuymHitiIivwPqAyxjmV5GP/oEkifLOQRDQWBo48xAH9Qr1Z4UEnzJKy6EO5SKki0GE0OnCkSdFAFQtChtsyL4Z3ZVBUoefzWeu+Y7XWjVPHDZGzbOrqa3tWRZHRPEMn08XtyercHT9FMRN7J38iFHyVXi3qpWnhOVfiKI425zrK+xoxFgOfpcaNYkJ91JG4q8HMBU9x9f/ybzNp7MsOVv8UiPoLhI10pgw6Fgq5MBLiGOlpR/DLTWfse+t2dr8Fo5ql2Pj6TsS/+P8fXW9cUZviWNFoH4biZgCkI/Ne4GNP6MJj7iQV3Zt0JyI9nZHytYiFc3gBEkfTPwyhCz8HDtI8nAAPNcr4IW/2nlLkQyW3UH5EvDqqx2Q4ocmVg9sHdPAUzT0yW5OiSR+D6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(54906003)(6636002)(316002)(36756003)(53546011)(38100700002)(86362001)(2906002)(6506007)(2616005)(6666004)(31686004)(31696002)(508600001)(66556008)(66946007)(8676002)(66476007)(966005)(4326008)(6486002)(6512007)(83380400001)(8936002)(26005)(82960400001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUFxNk4vb1FHMGpuekthK0FobVNxMTVybFoxdGk4ejJjcis5MlVMUmlPN3Vz?=
 =?utf-8?B?Q3pBbWliT2Q3aTVscVNGRDY0cTJUYm9WRTkraXRUVnBESGc4eVF1Z0VyN20y?=
 =?utf-8?B?Z2Z1US9uNkdMQXFNVGtuTnUwVUt5cjdwc2JCaVZIOW9TSEQ3VXpYa1cyY25I?=
 =?utf-8?B?RjhKd1VmalBzYlgxeXlabzhueksybW4zRjBscmovUXdIZzVZYnhOR0lRYTBy?=
 =?utf-8?B?V0N5eHVva21KQlVsdkh5aGk4bUJFUlVYTFFYS3YzTkJ4QU5FR1Nyalo5MlN5?=
 =?utf-8?B?Ui8zTU1oc1VTcXJjRjdhUzlNU2lQc2h4Z1lDSFNMK0UveUZiZUxPM1lOQ2NN?=
 =?utf-8?B?RS9XNDR2aE9URjIyZmUzZWxMM0xYY2ptSUZ2SDBodUw3TFA3S095SHdWc1Z4?=
 =?utf-8?B?a2k2WHUyS1huZ1pxSHJWM3VLc2QrNzNyUlA4azdQQmNjZEFOUDZWNytqWk42?=
 =?utf-8?B?cFZNRGd0NVliVitNeW4zY0J2WG9lZThvbGxadEJBcE91M3JoTGRuSXZzU01V?=
 =?utf-8?B?TXRmelBUNWFKRG9XVEdjSXNORmhHSzh2bDVzQUtzaThYbElvbk52WmtFc2lM?=
 =?utf-8?B?NmhHejN3eU1YZWUzK1VtOVJyWGFUaE10cTZWaUxmOFMrQ2pFYVFlcnZPa3cz?=
 =?utf-8?B?U2ZIcWR3Nk9RNVJEM3RYWWp2aE84SWVrUm9PM3V6aTNzWHVQUXNLcHdKKzFR?=
 =?utf-8?B?VkNtclFGYWYvc01teEdqanozekp2ZVVJWWdCUnEzNFFJWkVaZTczVzV0VHVW?=
 =?utf-8?B?azYvN3plM0RIcWMwQXYvSnV1alNVYjJZK1ltejVIODltckJKcjgvNHhKcURL?=
 =?utf-8?B?UERXWktHcnZpZ2JSSHJFSUhYWkVVbERKOWpFOGNBTnpScjFxMmFaRTgzdWtx?=
 =?utf-8?B?Qnh4aTU0MzlRUkVsQkt3aHRwYXNBbWdFRjJ4REEyOWNqSWtSTTZEUnZFMDVa?=
 =?utf-8?B?QXp1ZDhBYzgrYVlpZU8zT0ZWR1A2aW5pcDF0bGVoaXBHVVhlY2FSQlZMYW82?=
 =?utf-8?B?bzBiQTJPc3dMVnpqSm10azJhWitxTHYxWkE4bnY1R2RTZWQ4YUoyVWZDRzRW?=
 =?utf-8?B?V1k1Y2pOQ2VFY0JtMWcxVW9NYm9HRXdQY0pPVDlmYnUwU1lHb1FqSktmQ1Fh?=
 =?utf-8?B?Rjd5b3FZWGl1QzdWVVVOdEdIb285OStBTFdKM09TUW1RQjBocERad2p1OXpx?=
 =?utf-8?B?WVRlV3pIQXduZkN0eHdNdmJ5MldWdFl1QlhvTVRKSmo5dlNIQnBsbXVKdzJj?=
 =?utf-8?B?T2V6OEJ3QWxES01OdWhHVVRIZ1VMK1MrVEFGYVhXT0prWGZDamZibVBrMXRE?=
 =?utf-8?B?NVVZbTdCWDYyTEl3YlBxOWo0djdNK253WmcvS0Qxblh4S1BVWEZ0amgyTWov?=
 =?utf-8?B?M253WnRHek9CUE53VllNSE56MEVXQmJ0Yy9wTWRMajdDenp0TzlpdFB1YklY?=
 =?utf-8?B?Q0tuNjkvQTdBOGdTUTFleE5VOG14VEZSVHNLOVFVc1FxMXBmRGd3cktvRWY4?=
 =?utf-8?B?V1VrakxFampwVWlDODY2cmxNZ0g0dVQ5RnhTK0ZUUGoxb0ZuUUpUUGVaNXJG?=
 =?utf-8?B?OTd1ck1Qbm5hL2FjZ2lKNjJEdUg3NndPYitadFBYbjdJU1ppOGt4R0xzSW5u?=
 =?utf-8?B?d25WY1ltMEtxYVAvV052amh4MTd6ZTZtYXY1R2hwRUVHN05HY3U2eWF3b2lj?=
 =?utf-8?B?Q3lmb3JlTmRLWVFia3FFOENheTVLdFdKZjNMV1pkSGJ0NE1nOGdobWxXcFdZ?=
 =?utf-8?B?VHQ2dzVXSFpZaFVnd0VYQXlvZFV2dDZ4Yi9POUFKNytnVW14cXlsTFlhRWFT?=
 =?utf-8?B?QlJoOWh3aXNRTlNYZUQ1K1NOSFI0NEpveForanNIWWxxMmR5VnhLaGRTSUZm?=
 =?utf-8?B?VWw1RmVjM2VQeWJ2N2JPYkF3K3pHcTBrVGtrUk40cU9IRld5MUdQOGlQRWh0?=
 =?utf-8?B?cVRmeWZQSGxra2ZyMUdReHcreVJncm55M1p2eDRjSmM5RTcxUVJWVDA4UCtY?=
 =?utf-8?B?RUJSekM3V2JMb2Zwb3ZOeXFnMEIvSjFiVitBQkNES3dMcXI4OFVJT0RJRlVh?=
 =?utf-8?B?QVZ4WWszMHM4dzFLeXVxSlZxNjJOWEdpVEZBRlpkWU5Udk5sSFFaVWhJOFBD?=
 =?utf-8?B?dFBvakVXdzBxWFdxU1IzWWNhUi94bmp2R0VaeWJKTElwRTFsSG9lZ2tjRlUv?=
 =?utf-8?B?YjlRWUZkQmliSURlblNMVVFxbkVOd1pGL0NNQnNXbXNzbTdpaDNqUzJxRy82?=
 =?utf-8?B?eVNwY2U2YXJvTlI3SVF0SmVxYkVkTGE0ZU1iTEVpTXZlZHFoZG5wVTgzM1lh?=
 =?utf-8?B?SVlJUVBYWkdHUmpqemNHTTl5Mk1OS0tYM0hUaFplNXNTL0hqcjFsaXVuZTli?=
 =?utf-8?Q?EMZHAvuc2bKKs8zY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb000297-7abb-499e-13f6-08da3ffdb0ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 16:26:45.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nLdFKtO9GUVOS1ll+cbl5WdYaUq0HH0FgZ/1zYR0kiJFRVL2D9kXvj4JYRFyPpsGfWiPDln7tq5zkk07b+8dFm+O69aUd+7ziMMThZ1fo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/2022 4:31 AM, Kai-Heng Feng wrote:
> Intel I210 on some Intel Alder Lake platforms can only achieve ~750Mbps
> Tx speed via iperf. The RR2DCDELAY shows around 0x2xxx DMA delay, which
> will be significantly lower when 1) ASPM is disabled or 2) SoC package
> c-state stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx
> speed can reach to ~950Mbps.
> 
> According to the I210 datasheet "8.26.1 PCIe Misc. Register - PCIEMISC",
> "DMA Idle Indication" doesn't seem to tie to DMA coalesce anymore, so
> set it to 1b for "DMA is considered idle when there is no Rx or Tx AND
> when there are no TLPs indicating that CPU is active detected on the
> PCIe link (such as the host executes CSR or Configuration register read
> or write operation)" and performing Tx should also fall under "active
> CPU on PCIe link" case.
> 
> In addition to that, commit b6e0c419f040 ("igb: Move DMA Coalescing init
> code to separate function.") seems to wrongly changed from enabling
> E1000_PCIEMISC_LX_DECISION to disabling it, also fix that.
Patches applied. However, this patch seems like net material where patch 
1[1] seems more suited for net-next so I plan to split to those 
respective trees.

Thanks,
Tony

> Fixes: b6e0c419f040 ("igb: Move DMA Coalescing init code to separate function.")
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

[1] 
https://lore.kernel.org/netdev/20220525113113.171746-1-kai.heng.feng@canonical.com/
