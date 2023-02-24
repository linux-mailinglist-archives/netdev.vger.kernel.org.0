Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937F46A1F5E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBXQMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBXQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:12:17 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C74F6EB3A;
        Fri, 24 Feb 2023 08:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677255136; x=1708791136;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=snL8u7l37eKk4Tv9qLNBQHNFkZubrXLlES7/4eM/vaA=;
  b=WkRmQ2z0n7gFQgUu6zGVCvGCNM+CVP92D0ju4jj588sY8B8I/Evl+5w9
   9hJSi1KaqfuTrhNGOo5GB9LGYqy0fOVxOIMTO4gC/R6d4aV4IOzIAMeSd
   0MaDDPeQv8+3SJUKd/Iq+AKkbfRwO8IXcqWk9Yv3llCqXyaN2opS48dLH
   3FETRkwIa/KtH2wt6Wpr28DPeq6GMwpv5r0Rz12mjz+ej2WOWx2EBKDFU
   9AUfvu2lQJ4r85zxaVZaVIgzMPi6f9ECVsoBAos9t4/M8RZy85nAw2UFS
   06YYbp6yfZ5Vg2h6gMIdAiRtiPs/VRLwR+q/ggdX0v/K3rphzrzBT1fIQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="331241732"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="331241732"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 08:12:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="846987104"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="846987104"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2023 08:12:15 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:12:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:12:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 08:12:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 08:12:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWjdxPh2Xg6fwf2et4euu/Q736n04fwNbGoY1XNV2X7KIWD0NI1Bwn91p/9WGbMiMJdx7FN+b5ifruTlPstDypJ4bA2WiRqEY+kIC8KkD+yg6Q5aBuThy0WfztonnfcLbg3G6sjhGTQvhOJDnJVeJD/qRM5N5OJsKpWP9uJRsbkxbsIHEmdU7QxB6IlI5QZ7R3x4bdmLI2mGqhJN0Dn7U7AV2+Ze+I9aQlndf9saL6IMSQiI+YJq3579hRHxDiYNEMS/md6vhk9bEUpW80DZSnnwusS5hNYm04BTgpxIog35IJkMqdQMHIYl0IMIL4R/i19Jdn2ctN7t0T/oUybcZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EQggjTbShV0rY+ebhUhfEuaG3XaJn9p3a3wQDbQ+4g=;
 b=MPcmtjRQr6P0l494DMXUrbYDvt2/VVvd6gLWgr2DYRfE6yfp9vMDlTQ9e9N47onaOgAOiWnOTWd7Sp6q2RUPkOualYbq/5vI1Y4iomb8otaY5871NnHbHQ7NXUZe4PbUYAS7Atja544ijK2Div6t3NvfVeg6aV3sLBdhZMPaiZblgIvCob26pxCeBTBxgwqgTVlwmx/O3pq6lnSKfClZQfZ+nqWZ+6splNzQ7cBPyoX223Em16bjjLBZPDwK0/Vbz+WvtrRJvTWaSVIx347EWUJzcHLHSSLQbRPQUch7XdU3bg4d/qd3jEK/ZJGJTf2JBZFFWNbK9C2PRr9sArcI3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB7962.namprd11.prod.outlook.com (2603:10b6:510:245::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 16:12:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:12:12 +0000
Message-ID: <8583ff17-a8fe-c5c3-7618-3ef82364c97e@intel.com>
Date:   Fri, 24 Feb 2023 17:11:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 4/5] ip_tunnel: constify input argument of
 ip_tunnel_info_opts( )
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-5-gavinl@nvidia.com> <Y/KGJvFutRN0YjFr@corigine.com>
 <Y/KKiNHnJ5vHqWrf@corigine.com>
 <021dd47a-03e6-6d27-af3d-c7ff179fe0bd@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <021dd47a-03e6-6d27-af3d-c7ff179fe0bd@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0057.eurprd07.prod.outlook.com
 (2603:10a6:207:4::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bcfa73a-b840-430c-94f4-08db1681e33d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvYoRoaPaxyYeOSO2dfu1D/D+ZJhW706mdpTc6SE1IFRoeCDKQBipJjmqU4HHptGYS1pFlLlgtm7SLa746u119ALB11FRxdcNTVEapMmqerNDyzI+60fsfQ3jwnJfoqnApEQh3qoL/C3ffznWTBPBz6thZH0V1DZ/qZBF3v7u8H7acivAuiWsW9kZFt5yEIGb2LwHyXkDqEYnfRNsonzzQpFQzd1V0vYQaOG2kKJwngSusmME2rqAr9jgxsnzFz+XHNyLHC7OlCv5cIxRlXsM1Dw0EbQHb6d2ef/8Auvr5d8jmKD6q5dKhJXyfMub6oG7GtdiQ+lle41LJzYwbhuleKVlvvoDsTxqM19oV8TKnt4TMZdEW98PVQHQzAA+8pulCYGYwPYx1VO5F5FdU9xTRT765z2WvFf3aw6iu4g7LvE90PpHb/augh/dQgxIxKUGDzZo5ujvnf0rp0trjnjMVNh8UkFwvL5HrRYIJ+wUc5a9QvqC4iHoyA8AMVQUpZm/HcPImfABhyAL3oPeZnCeQWnuWJHMRUZuZ4GQg9fvNWHlCzsP5iwQRJ7lG3SHAyJhG41Xwk8ExcUVRixNg6LBwI1CrfJBSe53BwyWt+AJVCrfYnYIjZRzwuiflhKA1dfcLmhK+jLOniXF++lGuS52vp1Pj8FyNOF2al0uxW9mEsiTcHDMX1zdqGF3P5gtS9j/9f9Y+EzYPJO9oxuFCJQZy8rNSJNjHyiAsC18mkYlpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(7416002)(31696002)(82960400001)(2906002)(38100700002)(31686004)(86362001)(478600001)(6486002)(53546011)(186003)(26005)(36756003)(66556008)(66476007)(83380400001)(110136005)(66946007)(6512007)(2616005)(6506007)(4326008)(316002)(8936002)(41300700001)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXRpZ2NvYkw2dFBuSWUxYUxsUEEyU2lGTjZPMmd6YjVvS2Z6S0RJRUxHbXIw?=
 =?utf-8?B?NndDSkN4YWxpMkRMa0xSSHZTazVkVG8rc3ROM0hNWGZvdzRKaktHTjllL1cw?=
 =?utf-8?B?R2ozVVZiMXhkKzRCNWorT0dKVy9KN2lNeG1tTnRjbXNaVkYwUm9ENU1MT1NO?=
 =?utf-8?B?UDVNSmVUbkJQRTk0djlCbFMxZHliNVJXbGRJVnhEcytJd3E5eFpHUWliaS9K?=
 =?utf-8?B?ZitCYmFYai9ic2taU0lCK0swQkxQTFNUL1RFTXM4S2tGS0RXZDUrRFVpNEhS?=
 =?utf-8?B?WnhNb3QvK1dORThkK0pITFVMRXg4MFhrcW83bzB5Z2hJclhLd0J0Z0dSWUEv?=
 =?utf-8?B?eWxZa2Y5MzF0SzZVQ2JldUJpUVZzeHB6bGY1MStvUzByeHhoNVNZSjd5VG52?=
 =?utf-8?B?eURuMkJQZUhyckNwVUhXbDZjVUxHVmRaVFJoaWFOam4xTFI0ZmtqTDRVZWFX?=
 =?utf-8?B?NU1lQWdYQVBod1NaeVkwUHFUNjJqaHo4eXdacjZzTHh1anBrL2Q3Y0FTYWlH?=
 =?utf-8?B?VmEycXFkMHArb1g2S212NjhBNHFHTUdOM2NoZENLM2JwUlJkZ1FTY2ZVeU5v?=
 =?utf-8?B?VDdnQktDY01mb3J1WlE5VmtIWXBsZXpsc2RmNGNVbVZjMDI5aFpHblpQT3ZC?=
 =?utf-8?B?Q08xT01jak5qM3E0aVVnMDd1Mi9nNERkc1hraVNETHczekdLekhPamtMcTZE?=
 =?utf-8?B?UmVwTS9KTWRwVldBbjZwbmZtZU82OWhnUU5Ma2hJVXNXa3cyUU9UTFhkcEJF?=
 =?utf-8?B?YlpvbzZsOWJGajJNM2RwYWxFclZ4YU1aM2R6UVFKdDZXeGM3eGsyVEc4cnlK?=
 =?utf-8?B?NEhzVndRancrVG95dzFaUCt1UlpaRVNLUCszclU3ZjBqUlk3MWE0blBvRitL?=
 =?utf-8?B?TXNEempVMVNUakkyaVpvVmZjUjBaVEhDMnZjeXNxbjd5cUpXdElYVDhBcUlo?=
 =?utf-8?B?K201ZzdjaUdnWUFpQ1dCZWx6THIxcVlMNjFjanZXZjMzLzQxZUFSSnBBRXdu?=
 =?utf-8?B?ZXQ0R01NTWUvWUF2SWpKM1hPZkJMZ2dkNTh0RUs0UUloL3ZEQ1FMckZwYUpG?=
 =?utf-8?B?bDJBbVZYZnd4RDdVL0h0aGFzL3RXWG4yRzFZMmxYSTJlUG5WNXliaEhkVGFL?=
 =?utf-8?B?RkJHbDZHUzJWaVA0M3hlbkd5Mk9RZGNvTjRicDJRYy9OaUZYL2FFOGo0U1Jw?=
 =?utf-8?B?bDR2cjRpK0ZhNkY3dnhYS1NKZERrMm4yeUE3YUV4S29XU1gwZnNab2lCRVRS?=
 =?utf-8?B?bTZOU2NpUSs0UE1wQkZzTUgzbXNRaDJjaGt4U2ZvT1dmWEFyNVVLbWo3UmZi?=
 =?utf-8?B?SjkvUytxOWhXNFM4UXRZakdBTlBKSlBMbTBVRHZiem5rQk5kN3lJZnkyd2N1?=
 =?utf-8?B?SEpnY0tBSlQxS29sNWlZVTZVb3RmcUp5OEd3WG9Oc1orRTlremtacjZ3VVRE?=
 =?utf-8?B?OFJXaWErSmdsalkvYWhkSDNqa1lid1RIdGNjQThndHZsNHpZRHNxQ1VZZVhR?=
 =?utf-8?B?NlMrMGgxUWlnRURoYjF5bE1jdVNYK0t1NGt1dXJqSnRwMk1YK1FTY1JjRk5j?=
 =?utf-8?B?QkNKU2pJd2Rub29rU1RydGJNUDZkNXpEaWt1U0NGcFp2ZThqOEM2UE9id1cr?=
 =?utf-8?B?UUdHRzZzTnJZL0cxMHkzRk04Mmt5cTFHZXNTb2psSWZDaFJ3dkQwRzJjaTNI?=
 =?utf-8?B?a1M0TEVBSEVQdzhxL1pZMzBPS2VxOE9oc081UUxmT0ZPZTZZOTJtVHNFbXR1?=
 =?utf-8?B?cm9KRktyano3WnVVVnQ2My9zbm1weWV3YkJoWnl0d05CUitRK3p2UHFDVFFH?=
 =?utf-8?B?S3V2OFNlSUpoRlZFVVAzSFc3Ym1wcnhrRUhKYkxwcjZBTU1GbUVhOWZiVUxm?=
 =?utf-8?B?bW12bjgyalVZUCsrcHd2Nkx2L2dUSFpBVS9ORkdsdFFaeDhOV2RnNFY4TGk3?=
 =?utf-8?B?VW1oWHVSc3lsbWtZQmN5d1JzbFNHT2FxU3lGRzlPTGc4SWVsODV6Mlc0SnpY?=
 =?utf-8?B?SmZzVjNUVzVqZlhrd3hQQ1I5R0ZoNDhtMVlYNitZbjBmR3YxNFo5WVlhc1pu?=
 =?utf-8?B?a3RhdXhNZkFReTBHNnJpbEx0TUxlTWl4Z1p5c1d1RVZ0NzVnd21pRERNcm1y?=
 =?utf-8?B?d1FqNWN0eGJDWDJlUFpqS3kwdC9ZRVVSNDcraWNLSlZueEt5Q1Ixd0pkQVR6?=
 =?utf-8?Q?GdRk9ww2+j+la+2LbrrWQbM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bcfa73a-b840-430c-94f4-08db1681e33d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:12:12.4925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7r/N8p95JaIM/wZtV3yA0Yi4cBseiURPYTj8kElCiPeCzUWsFlWJwLhqoG8t2SUGvHPKcp5Q7wquYtm7mS2mfTky8J7YgUMnSgtEwT21RAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Mon, 20 Feb 2023 18:42:14 +0800

> 
> On 2/20/2023 4:46 AM, Simon Horman wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Sun, Feb 19, 2023 at 09:29:21PM +0100, Simon Horman wrote:
>>> On Fri, Feb 17, 2023 at 05:39:24AM +0200, Gavin Li wrote:
>>>> Constify input argument(i.e. struct ip_tunnel_info *info) of
>>>> ip_tunnel_info_opts( ) so that it wouldn't be needed to W/A it each
>>>> time
>>>> in each driver.
>>>>
>>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>>> ---
>>>>   include/net/ip_tunnels.h | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
>>>> index fca357679816..32c77f149c6e 100644
>>>> --- a/include/net/ip_tunnels.h
>>>> +++ b/include/net/ip_tunnels.h
>>>> @@ -485,9 +485,9 @@ static inline void iptunnel_xmit_stats(struct
>>>> net_device *dev, int pkt_len)
>>>>      }
>>>>   }
>>>>
>>>> -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
>>>> +static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info
>>>> *info)
>>>>   {
>>>> -   return info + 1;
>>>> +   return (void *)(info + 1);
>>> I'm unclear on what problem this is trying to solve,
>>> but info being const, and then returning (info +1)
>>> as non-const feels like it is masking rather than fixing a problem.
>> I now see that an example of the problem is added by path 5/5.
>>
>> ...
>>    CC [M]  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.o
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c: In function
>> 'mlx5e_gen_ip_tunnel_header_vxlan':
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:103:43:
>> error: passing argument 1 of 'ip_tunnel_info_opts' discards 'const'
>> qualifier from pointer target type [-Werror=discarded-qualifiers]
>>    103 |                 md = ip_tunnel_info_opts(e->tun_info);
>>        |                                          ~^~~~~~~~~~
>> In file included from
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:4:
>> ./include/net/ip_tunnels.h:488:64: note: expected 'struct
>> ip_tunnel_info *' but argument is of type 'const struct ip_tunnel_info *'
>>    488 | static inline void *ip_tunnel_info_opts(struct ip_tunnel_info
>> *info)
>>        |                                        
>> ~~~~~~~~~~~~~~~~~~~~~~~^~~~
>> ...
>>
>> But I really do wonder if this patch masks rather than fixes the problem.
> Hi Olek, any comment?

Hi,

Sorry for the late reply, was busy at work ._.

I initially proposed a solution via _Generic or __builtin_choose_expr to
return const or non-const opts basing on the input pointer type. I don't
like simple cast-aways.

See container_of_const() how it dynamically chooses whether to add
`const` or not when returning the result.

>>
>>>>   }
>>>>
>>>>   static inline void ip_tunnel_info_opts_get(void *to,
>>>> -- 
>>>> 2.31.1
>>>>

Thanks,
Olek
