Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9449C6E12D8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjDMQzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMQzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:55:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE959F9;
        Thu, 13 Apr 2023 09:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681404901; x=1712940901;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zR/OM+gBsfnhBcWWi8zCgQReNp4sX35a7gjTWDLJZs8=;
  b=X3hjx0FUlzkl2MirYqVDiZA2bHXj3jKT2LQtI5AwGJYHjuurul4NZE/P
   6ChtXCeDKGTqCifaH+Du7TjU6t8X/EDbt2AbPLPPUHVuSSsl21fxU/HWk
   0SpOui4FkY+ZWyXKFJyj47eD3vSBmtof/11G7UdF/7yJBso74AsqmkURt
   fErfYhuUgSO4ugVhw8iomxhorJSiNzbb4pPzK1xqdzFiaDvWUjVdpWHh0
   rIkm00k8QkUgT8tAMu+fiM/xCtypGDFiWkTcYLMB1MBOy39VGkEpyz3cq
   hPphDZlaQ6Jfcl2oF5ORh3eflwvAb4Jbe8T8nHjjbOcovJtEbz0hckzZg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="409419117"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="409419117"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 09:55:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="754081804"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="754081804"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 13 Apr 2023 09:55:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 09:54:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 09:54:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 09:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhz8T7yKC7QrM8dD+6GkAzsYgd+fvYsifTMpVMcQMz7FBpDUs/fbbh8WqsacwZgTI2EwoYvjetGofKtqtd15boGWQ7QbQ8XA+0EaQR8jRDsmWiv/9HWd8TEp+Hco1q7bD5FULh94Z3HslsD6mOzIzqjaa7sUFxGJkO5ZDAtqm5cbsTdb3ubwTH77f7NZhnojG65iuw37j9GLGMu0jVFGvydGZTdRWPuxToQM0qc8HI9vOL4Th939yhkh5elqHJCqeYCSQ5UcOa/s0d4MAJ2qk2giCBdVMGZgR+2J5R0lDLiRQvo4q0xZz8gZtoN1hws9OrroALGg0/1ee7iEbU8VYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCfnaB9S3eUfoxJTc1WqXFvI6E+uAwc6W9LanIw3j+M=;
 b=Cv7E148DQB86Idg+59j9vidyG8ZIy/I/MBT52Ew8RB6ocGDCIYbgecUprhZmY7yvNkz6Nds0pjiBMdcR3FzVFcQr0hCgxa03G+qVHMTcCcgchdQvbCW/zCuYIF4OyJppi4dKpuYUILbqJrUqJDw6phMpYUzbwvRd31fYN5FrglIQ/BOSWsAFGSGBXWPjAjgVQW1cd99cbYzCdyO75iwKXTukPzLX8xMHWnHoC9yne+61um+KCpP6AH9SldGZg8pD0/GIOYIdEZhZUihKtY9tYjkhks/Av7Lc8uTlMCo27b8Niet75/Ey3S7hzS8XhIliv7jNyH2uT0GC2UEoBbBJdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA3PR11MB8021.namprd11.prod.outlook.com (2603:10b6:806:2fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 16:54:55 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 16:54:55 +0000
Message-ID: <11d1bf49-c417-b3cd-38e3-0f7d14dd8b12@intel.com>
Date:   Thu, 13 Apr 2023 09:54:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/1] igc: read before write to SRRCTL register
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>, <stable@vger.kernel.org>
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230413151222.1864307-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:a03:60::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA3PR11MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c965a6-b22e-4dc4-0ab6-08db3c3fce6e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s45XKJYFw97cUGYa9GMVFFOhtles2Ee5jNiA3eO/r/ldDIiVtLCyZLdLnqsYQdKSILg0pNjjS1tGKHZ3iH+4XXqQQzp9DNSgH8Tq8kwD5hk2Q8XPK3reRkRGo9vi+NMzLONF1YfsjGrgzQjl8AwXOR1DxI2lYpGMi3kBMBSV/DiBHGtNFq8StXqopGGSJwCHDkkJW+/gNmnFx8wzRMPAji4QHpt7iyM5RLw224cExjzimfCCEraMeHCbTKsKEYqbQAxd5+cyjx31HnGiU7GH/x2z5KcOvWiTLCNoto22sEyE0YldF2i51gCO+5CgMN15RsZS6UL3asfIOouztmjyQf/VLtR6zS3AhuiywTLD0WuarUArlpm3qTlEDEOpNQGyPKVddEaOoQrjiu2odhjxr9h0VaT6I7mTFKSiSTZ/db8143J1qTbuhQIjzr50HL8ejTxHy+PamtgX+SqmVj6I7sUUxDUwec2ky1mwtz19eXpmDIuSStS4uUNEqq62E+P97BtPAT4nnXWtw4ldE+1nyAkOZ9hMVsKtPXvv/kua6zGt/J6D6FyZmXi+J2KFZ/hF5E1fVDOmofzAoJkUITVy1xeUoiB9ig+vr6AipZVe9EA/ISbt4WONhpmVSXfL5nvTtvlulOfcn7ZhQXNnEbcprKS+RH/W70EXK8FOXs2WlTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(478600001)(2616005)(6512007)(26005)(6506007)(6486002)(921005)(41300700001)(82960400001)(66556008)(316002)(4326008)(66476007)(53546011)(186003)(66946007)(31686004)(2906002)(5660300002)(7416002)(110136005)(36756003)(31696002)(86362001)(38100700002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzFaS2hVdzJ2SUxsWUxINjV3ejRabHJ5MTFSUFlBdVZvTm1mTlFaQjNSaUdv?=
 =?utf-8?B?RGJyZVBQdCtmRWpaTm8rd0Qxc2lnbjYrNjJFbFBVMGxETkZlZGVBSDhsN3hY?=
 =?utf-8?B?dGVxVVFub1NoZmxCeHpxME05ejU0TWlWZkpwNHpSdURySnpleVRIbVl1UDIx?=
 =?utf-8?B?MDB1cDNHRmVFbzFZdlZnSVJ4bFB3ZWRmYWdDWUtYa3VBUEE3SXRXRzRhTGpH?=
 =?utf-8?B?ako5R3laWTlSYUYzdWl1SXBnYjN3Q2s3Rk96d21wMFl3NGt1ZCtZaGNSTEVl?=
 =?utf-8?B?QUJkUzdhL2Q5SUFRdXg3TnVDd0NaVjFHcEJoR2Vqb1cwNDZrcnRIZWI5V1Vo?=
 =?utf-8?B?aHAzaitVUWtKVEh5eEZPQ01QekJFbXhIYkp1RnNURFF4bys1UTd6SVRsSUxI?=
 =?utf-8?B?WjdMdUVtQ29GQnVtS3VZeTM0cUd3RE9RRWdTQkc4YlB5TFpnRkpzVTVZL1Uw?=
 =?utf-8?B?ajJIdjY1YndvWWsra2UwQitUQ0NUdDVlNVB5QUhWektXMnNBbEFjdVZnRktL?=
 =?utf-8?B?U0Q1Q2lUcEdqM3JaVGxLSVVrcnc1S3dMbFk5U0VTajVQaXJWZHNBM21oRnJt?=
 =?utf-8?B?Z2hzdzc4SU1OemJaRW45c0F5ME0ycHFKWTRUK0tyYTJTb1hralYxbSs2WVl6?=
 =?utf-8?B?ZmdhWXZqTmVQMXIxRlNaNW1BaThaZzRkcVJteWsxQTdCd3pLOWhuSHpmWUkr?=
 =?utf-8?B?d2tJNG9Kb1FzcGRyVTR6ajgwcDRjQUN5Mzk5aWMweHlKQnFSTVRtQmgxcXAy?=
 =?utf-8?B?YzlSOFVzUjBhcHdDVjcxWUMzSnNJMGw3bzN2elhJa0tVa25xbjlXL3o4UzJU?=
 =?utf-8?B?Qmp2Q1JYVnVJa1N1cFdubm9MZXdwcWRYMmwraXpXZWNUUjg0L1c2ZkJEWFVj?=
 =?utf-8?B?NlZRWXVCYUEwclRsa2krSXlvUFM0OSsrNjFLU0JVQ1VQUUN6Mnd0MTlDN2Rj?=
 =?utf-8?B?UUYybTA1aFd0NGFac3QvVStTbDllRWVZRWtwUitlRndVcDkrV0JjaHVLUldL?=
 =?utf-8?B?eFIwZ2FMSmpjSEtGbG1wbUxZYUJnc1ljMktoYktMekI3aXpFaUpGRklDLzF4?=
 =?utf-8?B?cXlGU1V3MWtSSU5SNXBjNGNFRTFiTTBIcTRiQ3E3am9jK01idm1EeVN0Wnl0?=
 =?utf-8?B?VGdpdm9ya0VzQkZETXRCLzFYN05sbWtqWDc2cFhlN2E5MXIrekVhR09mQ3Bx?=
 =?utf-8?B?K0tTRW5ZRUdtMjRDN01SdndLS2V5Y0U1bUNzZmZuUXN4cS9YS1ovbmZUK2xo?=
 =?utf-8?B?bzRoL2xrUXhPT1BKSGZUU0NmU0JwakYveXQ0eC9MMWIxcU91YnlhWmE0VnNq?=
 =?utf-8?B?WHZHbjE3OFJDeXQvbGFaRUFkeGNBQnUrZisreWc4ZTdZbHVDSzc2WWVpVytS?=
 =?utf-8?B?M2d5dHlOU1RlaFRneW9EZisvSjVpNGQ5azcxbjBoRU1DS2g0VFdCY2g4dnds?=
 =?utf-8?B?TzZ4RUJ6ZERaRjc4ZWNMb0tEUm9ReXkxWEhIeW1FWUx4azdOUnZiSGhZRVpI?=
 =?utf-8?B?ZFVwZTYwOVFRR0NkOGZMUFZJNGE1NnMvN2dCc1lYWGlGT05kMExrTlRJVnBF?=
 =?utf-8?B?bU1yQ3VVanE1cGpwVmYzeVNKdVM2SVRQczVDRHh5Nmx5VHM2OFRaZERxNUxL?=
 =?utf-8?B?N0RIalNSMjVReFVKcGhFRmc2WXIwQkZicmRTNkRrQTlRcTZ0RlVVOXpnOHFO?=
 =?utf-8?B?ZDR2SDk1dzY1TkhZR21wQTFGKzc0V0xVNWdxaTZDclBWVktobFAvZzYvcGJU?=
 =?utf-8?B?TFh4SUwvdDdqKzk2NE9MWHFrakdVd0o5bzdGSVFuZ2xhc1RrYXVFZDlUT1I3?=
 =?utf-8?B?RldWYmQ0bC9Td2xUZkNDMkl3YTNxUDQ0NnFRZ0hwVFdqYnJSaWhxSnkwNi91?=
 =?utf-8?B?VllpOFdWMUxISlNVTm1PRU1GTXM2TjJwdTZKS094SXFYRVZhOEU3Q0drQXBE?=
 =?utf-8?B?S3BKREtYcG1YMnBhdkpUdG9vN211VE51bVd6SjF1OE81VEIwYXNHdDdDSnE0?=
 =?utf-8?B?ZjBSSU1hMVZLT0pJWFkvbFM0ZXZhSTNpK1JHTWlLN1ZOSW16NGFKK3h0eFJa?=
 =?utf-8?B?UWdVRUhYd2dTeFF3SG1Oam51RmMvWjc4QlRTa3Q3YytwSmpQd0dKQS9ySEhH?=
 =?utf-8?B?dkxNRE8xY0pOUGkyK3R4RGVlakU0UFNCckNEWXlwYmVacVJzTkR3WXBGSlhV?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c965a6-b22e-4dc4-0ab6-08db3c3fce6e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 16:54:55.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+NCRY6cEIHk9dFDsB/fQHfdD7gC7fQFXWB/+Ta3kMLxvAAJrRQQIup4iluOudqZeFavsrytvNUC923wcFRl0B53GrbBzEDR4ayFAI7geOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8021
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 8:12 AM, Song Yoong Siang wrote:
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> Thus, this commit read the register value before write to SRRCTL
> register. This commit is tested by using xdp_hw_metadata bpf selftest
> tool. The tool enables Rx hardware timestamp and then attach XDP program
> to igc driver. It will display hardware timestamp of UDP packet with
> port number 9092. Below are detail of test steps and results.
> 
> Command on DUT:
>   sudo ./xdp_hw_metadata <interface name>
> 
> Command on Link Partner:
>   echo -n skb | nc -u -q1 <destination IPv4 addr> 9092
> 
> Result before this patch:
>   skb hwtstamp is not found!
> 
> Result after this patch:
>   found skb hwtstamp = 1677762212.590696226
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
