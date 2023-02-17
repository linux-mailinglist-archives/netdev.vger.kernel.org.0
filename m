Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28BA69AEE5
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBQPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBQPDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:03:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B5370960;
        Fri, 17 Feb 2023 07:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676646197; x=1708182197;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2T3ny4mic5fXIhSlI+NKr7qpF8QsAMQ4ZkKl6KCyyo8=;
  b=IAdNkUv/ZB7BBnK5sNlbDn+uVhuj8dQLmJPIMyWy9NQcLlRel0gcouUD
   VTxuGyGiT/2133Oui59xsTFzEl6Es1ZmmLW7HGJ2H9KpZLb6IuAQNqi02
   1cd5X3tcGL7WW+B8Ybg57sl2+e6WWAHZBKL08YKVXyA1L8pe6ZK0Ne3rY
   4vOVsAO1tLOrSht+eGCiw5uky7hSvyCD50OQ2mW4LSyPZfbv36W+DZ728
   xokbu2ao1BQc1uM6xs081pvr0Vz4c0JnUJNTjBKtki59173z1BmKOigOn
   ZyVr0vlMqt7Z8rtXiEXt60f2zO5VClmWU7Yt3LJqpU54lDPT0fHbyH5ix
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="332005283"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="332005283"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 07:02:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="670566200"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="670566200"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2023 07:02:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:02:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 07:02:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 07:02:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVfLSTNwI3TAektFciTGGuas0cbC8d5Y1IUxakddwfQOWQkLAeQV6Dbje/+mAtoDrmFacwef3XwOTjdN20CvBXH0UQ0DErxf0p1emauimo0aVoQmYxEu7TXBDof+XL3BjwB3Um3fVQI8m/2DmjpULRyKGQ05Vt3JpnCTBItFrgvr/gul1f133273stjUF6ulMd1Y+XqdcOJAZbp7c5a8GGl1cnwtIFE8hAgJqntPR8oHzh3pGFMNJV9MmdzRCp1paknh5wsxPH3OxWUB4kCJkcVxyCu6vkIJ3jywKT9OfYyvHfww8lmlcN/lyIyIOItAyY5yFRU/aza44De5WZZidQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyH7k2jObcRe26In60eKtXSeX0yMqZbK+dqbR9Bipn0=;
 b=jadcc3h2kqSrn4iiDc86NXRXSc5eEIPWv1QtMEQ3nOOp/P1evy7ixLxxNco1zXpRKkhz9V2Bz8/4BzCpTPnHy/Og5zie+34LNSQ1+g/k4Y0+b4hh+bqn21BJb+zLlCGmoH4rvSwS4GDk1WjJ3iaVjsZ2xiEjlctB0VTIyqRKxdI4CXAQc4AUFBZCupaKNFrIYQTUJuyVYA7ryTjCfosduQ1NdnzxqXeqqVQscTJ2iJJCiDRLRM5lCUm9inwSGzQlOGWXLTtTLHNgZjajQcsOzWEjXWdl82zCYeAhQvDwJBtnnweX7VMB/it6Zb1JOSucsQIMXRrc6VKyDR+hgL7gIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM6PR11MB4660.namprd11.prod.outlook.com (2603:10b6:5:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 15:02:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 15:02:52 +0000
Message-ID: <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
Date:   Fri, 17 Feb 2023 16:01:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac grouping
 for ethtool statistics
Content-Language: en-US
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0221.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM6PR11MB4660:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a3810a-90fe-42bd-1ad9-08db10f80a83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9WEo7YaMHBhst+Xk9D2hF0U4jOuv45qZiUF4gtyva68YPp9tbZJrN5vSMYfWz0zf+Zw5Cvjem1dufPUje2RlETzJgGCjJW7tjc/3t69o4Vca72ZXktkw+vYiPtKs0lcmZL3cfKOMo7cHDu6RH/kHdJ14x1J67bZydlt8FevOHO8fk92fZyNM3BdxPS7JzOjC42XGZfWmLuNFH6+Bq7ahQRMSaM99hnqPVIER6/dLYR27bGi71ZXPys6CKmtJvcL91zsz7dVo1ZA/gehm4MIz2slTJl488NAB3ObDFFKrFFvet7QCJs0k2AB+i20hR9n2vbOPo7pEOQc2oG68+ndpHpRqRCUdVkGa5tjqQaV5zNc4l3abIcKgYvbb7UdY+OJaHQ7B1ZSY6FxN8Yl8zT3nQroYfI8mj+D6r/ROoTTCMaXypjnbdF8id3bNYO5u9nbNgCZy+caqhE+3oIxjhSMkCdq1iSSr+ApLv+1v4uAyBhGlaganrt2msDvc1AgSfNVtoTDLPWHJRhoFKcC4I0Owb17MDh9yYnDsLhUg6GLC7mIuo0os4NqbuFQA1JUpijMB3cAWDUgdXCw6tZQJ9scGHMONILiCKpC6z/u0mWIYxOYn/2bOwdmvDUQyg3foHVi3W+i7E+NO4DXvQWNW6cL8mXu/mY7KaPziEskmlnvxzd20QahxGAJkbDZGcC/M0mfas6DSu/cYbCl6gaIoHqDi8s+ax/JIXBvHAT8xjyqBWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199018)(31696002)(86362001)(38100700002)(82960400001)(36756003)(7416002)(5660300002)(8676002)(66946007)(2906002)(4326008)(6916009)(66476007)(8936002)(66556008)(41300700001)(186003)(6512007)(2616005)(26005)(83380400001)(316002)(6666004)(6506007)(6486002)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eERhYW1IdVhIaUIrU0Z2aFE2anZpSmRsSTdNcnBuUUpRdUtFM3g4T2FYK1FE?=
 =?utf-8?B?MTlsUlBsdGp6SFZpeW5lWGsremgvQXNPVkdHdWh3VjNNRU9aeDVkbnVXT2tQ?=
 =?utf-8?B?NUd4UGo4d3craWJTNnhhNW4vd1BmU3BFSWNYTmtiaTlRZUl0aElUTUY4WUcw?=
 =?utf-8?B?aENETTZNbmxWVEMvVjFoc1liZzhmbVgyd0xIWllYRE5WSUU4a2xTZ3RRVE5G?=
 =?utf-8?B?QnNhWm04YndYdFlyUm5DOXp6WGh3RlFDRzRmekNKdDA2N093c00yU2ZuMGky?=
 =?utf-8?B?YWJ1azNIUjZSYkpxMFRxTkw3MDZST1dYUFpqYWpOdEFEVGE0UUxhTUZWZFJI?=
 =?utf-8?B?Y1k1UHcyanhxakFsVDVxVDBTWkJLcDlLQjRlTHhQS0tZcmg5NFl6ZDh6WEVw?=
 =?utf-8?B?RURGZXR2TnR4Q2pzNHdPOGJLQ2pUUFZGQlFUU0Zra1ZLNjNMRVA0aHRTRDZa?=
 =?utf-8?B?NlhPM0szanE5eE5XUU1mVm1aV3kvbjk1TVZZK2ZXcUhlS0dUQW5vR2t5eE9l?=
 =?utf-8?B?eVNYbDUvSWt3TncyL2NzV3BCVGlJZUJIb2F3M0themVKR1NnWE8xTlMrc3Rq?=
 =?utf-8?B?NkEzNHpxV3NWYVRkQWhYYmpNdWVEOEZEL1hlMW9WQmpyVlkvQ0N2RTJYeXE4?=
 =?utf-8?B?SEtWRk5EdnExL1duZVR5WDJnQjRUSTBMcC9LN1Y0VDBnQW80MnhnTC9Ca2hy?=
 =?utf-8?B?bmVxbUgxSzJGZnQwQXRQd1FaZVRONzRLeWpIRVk2MGpIQTBXUzYyNVc4S1M3?=
 =?utf-8?B?VUNMWjEwdEhyTTJkcE9JQ3krRkpRb09ySU1NUFlaNEJYUHY5WFBwbk1IOFR3?=
 =?utf-8?B?akFiclhjZlh4SnRVbzI5MDFUUjQvNDV5S1VWb0dxS0FLdCtnMTR6UGdybWRv?=
 =?utf-8?B?L0RTV1M0UG50WnpYSnRoWEtMS1ZVc3lKN0JLZ1lYREpmZTdJSG1xZ1dIR2Yw?=
 =?utf-8?B?M2syRW5PdWwwcDFjU2VCWDc4MHJ3dmdEVWVYWDByQS94NjYrdlFBWmNSU3ds?=
 =?utf-8?B?NmJQVG1PWDhPVlBBeGNtcGVHOWlRYUg0b0NhRGIrS241WENZb1BkcSsvQmll?=
 =?utf-8?B?LzFsbDNKRStKMW9walNOSEJ2dGE1OXRxcE9uUE9yS0x5SzZ0VFgyb1Z0NG9w?=
 =?utf-8?B?cFpTZWlsNkFwY2N4Tk9QaGt6T0crKzFKYkREYWxaUTFDcWRPK3ZEQUlrZkZh?=
 =?utf-8?B?ekVsY0F2U2VSMFdDTEhBWVJwOWNocHpWSlF1Q0tuUURYck1veDJYbzcyOEtS?=
 =?utf-8?B?S1FtT1F1Wkp0Rk9zTkJmbzZnWVlvWW9aOXFCSDZ3dmpnMk95eDFlcTN0OXh0?=
 =?utf-8?B?RnE0V3lYN1JiWFlRQVRZdkU5cWttNkJYRm5PeU1UdnBnVERTUmFQZkxOSWxy?=
 =?utf-8?B?V0t4RFE5VkZIMDl6TWx0eDRXZmkrQmVkRUwwOFBRRDFJZEpTUVJvODgyUHdL?=
 =?utf-8?B?L0NuVlpIMjZGb2NHUk5PTkNNQm43RWZyNExvbzc4dWdMYjVBV21kVzhoVzFM?=
 =?utf-8?B?TXhVYXlRZUxDWWpFT1ZFRmFYTmVlbzJkOEFRemdtWGNaelJZendDUk8rSzVi?=
 =?utf-8?B?NkwyN2t6c1NiSkdJZytRbWN0bFJnWjNZVXNnb1FPbW1QNDFWcTdtOStXdWVi?=
 =?utf-8?B?aVZock5lRUxrWHFtT3Y5SGd1KzVOZFh1aisvckUxeFpkSXBXSk1yYmdTUTJ3?=
 =?utf-8?B?eDN5UjdKV3FVcWREdWVOVmVRZTV0a0xVWDBxZ0VIRG1TOWlJdGlKQXZZNXZQ?=
 =?utf-8?B?WEtoYSs5OXNHZXUrZmZtME5PT3BtSjE2WFhsMi9OZjJDN0NUQ01XVkZDS1gx?=
 =?utf-8?B?cDVxbENXSS8zdDRYeWsyeWV3MXlmT09RbHJZLzBlNkhnaWM1YWUvRENzN2NP?=
 =?utf-8?B?UnlrQU90WnR5bTZXbWxhNkJkY1NieWlsUWEwSWY0L2Vyd2FTWjJXbWJqYXNr?=
 =?utf-8?B?bzRHdk5zWkRMdktRdGN0d0gyYzhWY2I5NTZIOERybG1yOTRLd3p0Y250cldo?=
 =?utf-8?B?VjY1cnR4MTkxTmlScmhadDhaazQ3SnNURkdyMXZ0ODdWTmRkbitjNE5Uek1N?=
 =?utf-8?B?ZjZoVVFJbUlicEZybm03ZW9xWm8xMVFPQXRhQlF6Ujc4TzE2b21lcmhpSDJP?=
 =?utf-8?B?aGZuUStxTlBab0dwR1Y0UTN2YWkzbklxemI2NDk0b3JJWXUycFBQUE42VGRF?=
 =?utf-8?Q?TzIEX+jxWYnEtsraS//p7DM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a3810a-90fe-42bd-1ad9-08db10f80a83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:02:51.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2AqLz3QGSVzy2fkEwqRzqscs7Qhwl/SW26+koL5+2hy4cnESmmB4c8bNi+NFHk1YoWAj3Iw0kSquPb3la0/fVZfOe2ca9VoorgLUEaEDUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4660
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

From: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Date: Fri, 17 Feb 2023 16:32:09 +0530

>     Add support for ethtool standard device statistics grouping.
>     Support ethernet mac statistics grouping using eth-mac groups
>     parameter in ethtool command.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>

[...]

> +void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
> +			    struct ethtool_eth_mac_stats *mac_stats)
> +{
> +	struct ksz_port_mib *mib;
> +	u64 *ctr;
> +
> +	mib = &dev->ports[port].mib;
> +
> +	mutex_lock(&mib->cnt_mutex);
> +	ctr = mib->counters;
> +
> +	while (mib->cnt_ptr < dev->info->mib_cnt) {
> +		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
> +			       NULL, &mib->counters[mib->cnt_ptr]);

(for example here)

> +		++mib->cnt_ptr;

Reason for the pre-increment? :)

> +	}
> +
> +	mac_stats->FramesTransmittedOK = ctr[KSZ8_TX_MCAST] +
> +					 ctr[KSZ8_TX_BCAST] +
> +					 ctr[KSZ8_TX_UCAST] +
> +					 ctr[KSZ8_TX_PAUSE] -
> +					 ctr[KSZ8_TX_DISCARDS];
[...]

Thanks,
Olek
