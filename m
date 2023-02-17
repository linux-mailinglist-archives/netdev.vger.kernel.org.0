Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E669AEE0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBQPDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBQPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:03:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FE230B0D;
        Fri, 17 Feb 2023 07:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676646164; x=1708182164;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zgb9y36l8/JWbQti9gsRvINbwVbk8vn3rfXNsKzse8Q=;
  b=ZNWne1ExbjvJiv4Lau29ZSL3VsV+Wc+J+q8Z/foLPPIAh1LX5k2QT8VB
   7Qgq1vsk0Oc0ju3b2cGmaGB5nRXnxxM8B0JpDV210PslMqfRvEscXSoxF
   uTn+OZO55JDJXyhpnyxWo78XMKhvPPbM7KAoPvKcVpj6RTCwjVvi1lkUi
   0iXxTeakScBJs4w1hpAI6srynRRFUQ8OFYUU9/XixU7nIqK/ALiHvi7yB
   0OuNm7kJ8clzg2+8yHj+kgRZyacxlcOxac22dyPr4gQPR54vbPZrV7bwE
   9duWqW+P9jVn3DcyBM6qpz9LPrZy5ux/IYa9alI+5aC/jrEaf2ki9tvql
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="332004135"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="332004135"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 07:00:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="670565621"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="670565621"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2023 07:00:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:00:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 07:00:52 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 07:00:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdCBklSJMohwFjeWMQ3p56XHQ0V06pqdJT0NNt0VpmTGWyGNMljjC5ry39exR8fEHf6KKLALPT4leaRTNZDQMh/cpwpSSnil4KeHqBWZuTVC0aPFMleYPMzQ8NZFONTUA79Wotm9fxkJt6TNkeWwyaI62Q5I4vf0kGUlVpNuLbm52663GKv4noafQnafAPZjXVaswcF3K29E39bf9vKoU4NAbwEM1yLJGJf1UJENFb2zOwqNT83FD6o/2TrWyeBrUViQGqMEqsr0LxLDQSdsE55jZs/eo6Z8pX72sZQCfwgi0+c+CLd8+x7z/7IpK1lHDNR1/DvV58Ck67AaUAoE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4FjMSoZNsWIp3jlUVd68buF2XS0Ce0tdNBwm20Z7eE=;
 b=BPb+CwpXnazzSWNc4q+MeURfSI0TucPJszlutbI5j6WBLLBeiwE7Kh6uddZ0nX952+WwvZ/Ini6CW51gItwAiFyO6i6bCcsStnc4nnhS7k3sP65QE5chL6ArN67F8Wa84e5anZ/VEqFYDw+DHC2g91oO1Q8/v6wOG4pWgmm4NyAXEunSES/1b46ZkgXeQXygbSI0iiT2kshESszOab5I8f/ErR1CdH43GcH7f4IR1AuH5TnTeha0wvxxbWlxlGcfGkmuB9iHoiwRk7BIA8zEPdG+YeVMxN8sMiAXnxSkiKbge2K5jmvrWZn3vVATGKUeqt/1jaXduXgqkAOZD8y40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 15:00:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 15:00:50 +0000
Message-ID: <03dedec9-2383-b0bd-eb2e-4d3b334e8c0b@intel.com>
Date:   Fri, 17 Feb 2023 15:59:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Content-Language: en-US
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>,
        Thangaraj Samynathan <Thangaraj.S@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA0PR11MB4734:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c5d41f3-041b-49b7-3d38-08db10f7c1c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWw//Hqjt80OgRYlsIAVzobBW2UJMwOWbqgq6YW036NA4rHcXJI6LZHQSdDUp1+0OLyp2z4HfSa/hk1SIAPuN6FJsR6A9LBjZLyv3aqgKnIY+g3MAVop0IRJZFr8xNffySsYo57c6o+3QLzyc1Ni8ky1PvbC+2RgaILl3JihhFk4a3r75YyOZDuGsXzb/E+oDsIsDEVdDs5hBhpk2yIu4pSzSZUZhQ4A+UdbFRqfX5TzZAjfW6IQ1cWOIke0kYcmd/RBxQE73B3iG5jq8/cGiml4Lp6/zpVwcfoUKl9qwpPjUj3y7UN4OV3m8nPzpE2KqnpH9FTZ0YAqDAEBKifrmPCfQA8HjoYDMMFbSOXlVqtvUCr0DWyZfjmDi4y7xB/WyD0lOEzW4CnGJg239ZhaEY3vpU/aGvqgajlA1ky0GDRMadkCpNl7e5Wy9A/0IB3c3MQbGiPl4MfyGecBIrtn1VYuhKOddmK+ZmKKo8FDoXPbX+IFpWG1nwmrMomM7CeOY2UJ4Z4IiXzdWdDzpUf4mOmQ0sNPiGIXOYLH5Bfc29TCRZpHJN+Rb7nxlm70cRQyxGp1Iw+0IqjuwP98rTskoDMl+uhtSws6b9l/mOnF6uLzVbciO3CiliB+0itm5fZvbksy8dsmVnDjYKP5d3s061P/muN+mu1T6GVuAgm2ZxfndYtS+0fhp8//GQX3fnUsNm/Q4WMRHPLM1+QSIiqVSpcP/K9XN9ydUX7E5s1fu9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(346002)(136003)(39850400004)(451199018)(31686004)(86362001)(8936002)(31696002)(7416002)(38100700002)(41300700001)(5660300002)(82960400001)(4326008)(6916009)(2906002)(66476007)(66946007)(8676002)(316002)(66556008)(83380400001)(2616005)(478600001)(6486002)(36756003)(6506007)(6666004)(186003)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnFyTWVVRFM1TDJXVjZ5L2RsUS9mamJWNFpMcFdKOTRvVnVyVFQ1ODZ3SllV?=
 =?utf-8?B?VDlDWEwxenUzOE1lb2FBM2FIanRTTGlRY1Vac2hjTFpnLy9jVEFtZk9zcmx6?=
 =?utf-8?B?bHJweEJsWUJSQi8zN1F0MHhNUkt3ZTluWnVneTg4dTFTVWhCaEU3aFFEMEY3?=
 =?utf-8?B?ZzcxbnZWVnQwZmlNZldtcWoyNEQ0eS84VkxUMGtodThkMy9nVWdpaWRtc1JC?=
 =?utf-8?B?NUw1T0xqdDJQdEJLMUVPVUJJbjh0ZjNrdDNEZzY5b212emVsL2krUUZTZk9r?=
 =?utf-8?B?SU5KSXRHVG00cXo2S1JXVDFSU1VHSUk0di9SNXNwSmh0RTY3TDhzbzhsb0lm?=
 =?utf-8?B?eHZqbVc3NHA3SDFRcVphVHpHdjZYWmdaRHlTS2ZlSGdyOFg2eWcyWmRlVktT?=
 =?utf-8?B?S3hsOUdhK2l2OFY3akZ3dkRtazVvZVBxS0xQTGMrOWZPVHNIOVFoTFJ6cURw?=
 =?utf-8?B?TFZYOU1SREkxY3hXajhMSmlrL1BrZWFFZHR4YUcyUERFQ1lKaEVZM3BDVTg2?=
 =?utf-8?B?L00vTTRsc1d3dlVqWWhicGdIYm10cThvTjVTcE96OU5aYlJRVWFzVGErVG9Y?=
 =?utf-8?B?aXdxVEM3eERablJ1dWVjRTRlL2F4eHI4LzU1dmcvaUNFSVQySXpkS25KeHRt?=
 =?utf-8?B?b3M4djlhazZrbVlLL25FQ2RGRkRqcFZxMUMwVCtIN1MvbXFINnBuelN1SUFw?=
 =?utf-8?B?c3BHNnVDQ2pJQms2a1ErYjdGTWQ0UmxkTFlMa3hxMFV0bkNaVEcyZkhGQzBH?=
 =?utf-8?B?cC9mVjQ5Zm9hU0I0OVJOTE5tMko2L3hCOWdFV25idEVWREJnUWZNblB5UzVo?=
 =?utf-8?B?bzBhNUs3T1BzTmtNa3Y2SmFCYUhFNmVpV1cwQ0xLVW9kems5NUtmbXVZblY5?=
 =?utf-8?B?MkN6dnh2VVJlSTQwSDYvdHp0Rzl5WW1MK3RWVCtMTnRwUkdYWVdYalhzWklT?=
 =?utf-8?B?QWZPQVJ6RWtsQ28rZTVPaExmTnU0V1ZlTDh5SmxvcjU2c0hLNmVWYUN4bkhT?=
 =?utf-8?B?SmJ3Z3BEYTVpNVhBZjhDTjJHMTRueEtRUnJ4TjU0cDd0dHlUcWJ6bnBoemN0?=
 =?utf-8?B?MTl6MEVaU0RYT1JVM2Rxc3oxS29SRktFUnFVMm9vZnFHSHlhQThGb3NjUE1G?=
 =?utf-8?B?TUZ6RXRMTkFMUjBoUVZadzZpbVhXQm9ta3g1ZVozVTdCKzlSVFVLMUtPSTdK?=
 =?utf-8?B?eFc3TEg1dHlMbU80VWJXQ056d3FtM0JHT1J3TXNnT2srUklqOWNBOUI4VFN4?=
 =?utf-8?B?dERjR2R3bkdabUJ5M0dNN2k5T2JDeTJqNU1IYzFRcHRvZ2RHUjRqcmFYZDlo?=
 =?utf-8?B?QldRMFhUVXlrck5ma3htOHNyV055V1dBT0g2UUFPbW1iL3pkNGpsUkFzYkpS?=
 =?utf-8?B?c0IyalhCUTN2WUMya2RvazltdlRQMWc1K0Nrc0FoQlhBcnRJMXVpa3VrNU5r?=
 =?utf-8?B?WWJNNytiazN2NElLSDZHVE5XNllTMDJBa1drR2FITmNUZmlweStIY0N2NnZB?=
 =?utf-8?B?Wm9PeFRRMVpqbklNR21DL3BXci9QZUpSZklNVTBpWHFMWjFybDF2WEVTQzBj?=
 =?utf-8?B?Z0VHSXdkNm02TlpONXhZdW5Icm9LYmpDNktMZkkrMEc2Nk1NN1A2UzJqalAv?=
 =?utf-8?B?NmVSVC82ZWJNSDlWakp5ZjZwSnJCU1pyNEgxWHBVRnpLMkJpNGFMNmY1VEpO?=
 =?utf-8?B?TEdGMVAxSHltczNoS3ZLekpBWHRnalhrWE1YbUpwMlJ2QW5pUmk3YXlwakQ5?=
 =?utf-8?B?UldWbGlXdWtyRDV2T1UwdTBQS2NkalZVdTNOQXp4ZjlhdWt1U1JmcGdiQm1p?=
 =?utf-8?B?YWtid0swWXRiUXRaRjJWc3g5ZHNWaTFXSkhZcGRmRHp5cGxDK05FcXIyQzhw?=
 =?utf-8?B?MVN3QTN0WDZkcHVSc0dwb1lpSVU1bVM1WWdyaDRmajJqSW82TjAwNFJhYTZ0?=
 =?utf-8?B?S1pKZ3IzU2JTNVZEU0k2bnRaMnRaUThBNU9vOTZ6TzZjSGhIQTN2anZsQUFV?=
 =?utf-8?B?WndLaTdkOFBPY3NKQlBLVEc2ZXBqWWF5bjNud1hXZzN5RXdTME0zbmc4ZXc1?=
 =?utf-8?B?N3VzUDZPNnA3RlpNK2RwWXFHZFA1WndtTHFRQW5SVW01QWNoeVZZb0ozOG5P?=
 =?utf-8?B?d3lGMjdoVzZsd3g5VVFXbEI4OHovSU9GQ1ZTOGkwb1ozd1Jpa2hpZ3RUNkVp?=
 =?utf-8?Q?FWz9l25a+4QEZso0xpXOBig=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c5d41f3-041b-49b7-3d38-08db10f7c1c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:00:49.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcxzLTOfO0jz0FiXmuqMkDFP5+ffBNH0RrVW2PO2KrEnniPt+33YGjqHrR1e7th2baJxhpKP+L7gFx3A8zIoCuXOcwKuN/D4mv5nmt+zFq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
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
Date: Fri, 17 Feb 2023 16:32:07 +0530

>     Add support for ethtool standard device statistics grouping. Support rmon
>     statistics grouping using rmon groups parameter in ethtool command. rmon
>     provides packet size based range grouping. Common mib parameters are used
>     across all KSZ series swtches for packet size statistics, except for
>     KSZ8830. KSZ series have mib counters for packets with size:

[...]

> +void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
> +			 struct ethtool_rmon_stats *rmon_stats,
> +			 const struct ethtool_rmon_hist_range **ranges)
> +{
> +	struct ksz_port_mib *mib;
> +	u64 *cnt;

Nit: I guess it can be const since you only read it (in every such
callback)?

> +	u8 i;
> +
> +	mib = &dev->ports[port].mib;
> +
> +	mutex_lock(&mib->cnt_mutex);
> +
> +	cnt = &mib->counters[KSZ8_RX_UNDERSIZE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_UNDERSIZE, NULL, cnt);
> +	rmon_stats->undersize_pkts = *cnt;
> +
> +	cnt = &mib->counters[KSZ8_RX_OVERSIZE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_OVERSIZE, NULL, cnt);
> +	rmon_stats->oversize_pkts = *cnt;
> +
> +	cnt = &mib->counters[KSZ8_RX_FRAGMENTS];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_FRAGMENTS, NULL, cnt);
> +	rmon_stats->fragments = *cnt;
> +
> +	cnt = &mib->counters[KSZ8_RX_JABBERS];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_JABBERS, NULL, cnt);
> +	rmon_stats->jabbers = *cnt;
> +
> +	for (i = 0; i < KSZ8_HIST_LEN; i++) {
> +		cnt = &mib->counters[KSZ8_RX_64_OR_LESS + i];
> +		dev->dev_ops->r_mib_pkt(dev, port,
> +				(KSZ8_RX_64_OR_LESS + i), NULL, cnt);

Weird linewrap. Please align the following lines with the opening brace
of the first one, e.g.

		dev->dev_ops->r_mib_pkt(dev, port,
					KSZ8_RX_64_OR_LESS + i, NULL,
					cnt);

BUT I don't see why you need those braces around `macro + i` and without
them you can fit it into the previous line I believe.

> +		rmon_stats->hist[i] = *cnt;
> +	}
> +
> +	mutex_unlock(&mib->cnt_mutex);
> +
> +	*ranges = ksz_rmon_ranges;
> +}
> +
> +void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
> +			    struct ethtool_rmon_stats *rmon_stats,
> +			    const struct ethtool_rmon_hist_range **ranges)
> +{
> +	struct ksz_port_mib *mib;
> +	u64 *cnt;
> +	u8 i;
> +
> +	mib = &dev->ports[port].mib;
> +
> +	mutex_lock(&mib->cnt_mutex);
> +
> +	cnt = &mib->counters[KSZ9477_RX_UNDERSIZE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_UNDERSIZE, NULL, cnt);
> +	rmon_stats->undersize_pkts = *cnt;
> +
> +	cnt = &mib->counters[KSZ9477_RX_OVERSIZE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_OVERSIZE, NULL, cnt);
> +	rmon_stats->oversize_pkts = *cnt;
> +
> +	cnt = &mib->counters[KSZ9477_RX_FRAGMENTS];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_FRAGMENTS, NULL, cnt);
> +	rmon_stats->fragments = *cnt;
> +
> +	cnt = &mib->counters[KSZ9477_RX_JABBERS];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_JABBERS, NULL, cnt);
> +	rmon_stats->jabbers = *cnt;
> +
> +	for (i = 0; i < KSZ9477_HIST_LEN; i++) {
> +		cnt = &mib->counters[KSZ9477_RX_64_OR_LESS + i];
> +		dev->dev_ops->r_mib_pkt(dev, port,
> +				(KSZ9477_RX_64_OR_LESS + i), NULL, cnt);

(same, and please check all other places in the series)

> +		rmon_stats->hist[i] = *cnt;
> +	}
> +
> +	mutex_unlock(&mib->cnt_mutex);
> +
> +	*ranges = ksz_rmon_ranges;
> +}
[...]

Thanks,
Olek
