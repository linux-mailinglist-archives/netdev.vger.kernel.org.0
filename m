Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90C26A6F14
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCAPO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCAPO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:14:26 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD11B2CC7F;
        Wed,  1 Mar 2023 07:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677683665; x=1709219665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=21q1+A3H1nbGX1+e5YVTScgeuAVO4/oif0zf2tnP9Mk=;
  b=PUKvzwUbaXVXlP7Y7TOSlJMaMKHk2uT9tcfYNL3LInVfqoY8JKrZJ0j6
   f3mwhNFRd79aq6HuyKrh/6IKk87Zf/qM3l/0XJbeXCBOqfdG+m5GlVZap
   GHzlTDDE5zit3zdY+r3rzZFJUi4XSI/b+M2yBcz+17325Z9gw+uSXgdum
   9QYPQ3skZZgLqRofuwVK2PsKly8++glIDs57CLPiJe8y3UxZ7Sxqi0LJr
   5vMRN0+eLoeVC+/ODRCciqDATy2LrN6xAT9Zg5fUPYaRLeknFkZO5l9hP
   3uSK3DCKJ8OFAEXLDHbRCEFnMZUHDpQKB0SwnzDti1b9fiYkt/YNsjFCf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="314853096"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="314853096"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 07:14:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="738673343"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="738673343"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 01 Mar 2023 07:14:25 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 07:14:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 07:14:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 07:14:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 07:14:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdczSKyQVcgWHaNuIaRyEMwriQTUnf86IlC1VVLTxBlv29PtsKEg46/+VaKQIkr9aPSOLTyY9RkK2759Fl4xhpihPyUj5zCwqHZlQUAAsiqsXMODld2FpRQuFwWX2tTHqVKKx3tzl9gmMqC5c+iTX2hK5WjG3xbYwNahtgv8V6+QcK3xhKC6ILXv3Obb993LR6gtSORFn2NtvFzFhZ83nPjPBBs8VzvX1HegwLM1aaOu8z73jkJUbO9nnUrnz/ggjxIRp/DOn+4e1cq03kQAQFUcanFfYp5Axljtc6D+CRmb1sWwMp0j6rXWY1m4nLaAVn6qKyoPz5193kOM4+qJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu0k9i8RHldmOdFuKqhT89LcS7MGhJyJI6XYY0I95tk=;
 b=lYh/v1LuCEIHoRe4IgaDBV7WEOgUc860B0u9PJecz68gvR9Nl/kJ9ZNmH3RXeayJxUpsdOsGROAChoqlXzP3rm50D/2uHqqa5kPA5Y5X0fA+439znD0o6CVP2VVhCSI/p17nQ9E8c3zm/ETGfM9qSmau8lqn3uxhFhY2v5itT1/LANEWvhop39BeYn2kWP/vYrroAe+OVSplBDDIZOQpIxUPERJjmHrlLdACX5x1uXGW1mzfOuzYu+LIogxBTvD1s+lwhliSQQauqu93CmVZPd7Se94Nx9ucHKRWt+mypDRoW9tuDkGhQe8XXRAY7S0/VwaPJyzW2dd+LvsK4yDBKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 15:14:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 15:14:20 +0000
Message-ID: <32fdf39c-9772-61a1-e0d7-40a564f640a2@intel.com>
Date:   Wed, 1 Mar 2023 16:13:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net] ice: copy last block omitted in
 ice_get_module_eeprom()
To:     Petr Oros <poros@redhat.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>
References: <20230228204139.2264495-1-poros@redhat.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230228204139.2264495-1-poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7838:EE_
X-MS-Office365-Filtering-Correlation-Id: 54523893-1ae6-4775-e22a-08db1a67a1e4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3b6Uvp6J94y2AgkA9MDKZdxAB7XUrpu7/FasQW37drHqcgGd7Mms8REZzRlRJCzN/NIL5vTd/wbOFCrFusiLgbAUVXXCFd1a5EX4I3DelBTEd7OE/sAmaCtX0/GhlUJoLa47iZqUZlmddhqcUPwKGEDDAMeyd4D+cIyrORf5vlyiLvLYDR2R0GmP/G75t+F8lXa/oSltXwmDYswwIGeTJL30ikt5wHsCGy8QWvjnGdpTLdFsS0AKxv8LA2G+ILN18dXtZ6XiKa3HvvZfsDQsGShqZc1EUla5pCUQ7HJCNDbSjGl2H/34MwJifJnM2IBnH7Hjzu7sTSGGleNh9DJlklD2FauFKeGrmT4NH/A3Va3dDPp/5zk6Ap21eK30DVVbgGPCXc2FJxT2kVAwAJuwrsJ/eXsPjcQjwvEJq1lHOqN+AuqTcQVu1nv8FAa/iGe/7YPltCjOJXvQeMGzI036HfV6asyOIns/k11WioQvcZggLQybmuf8UjSiQ8EzGZwRciskXCf97FOET7IETBJ9CYkbp2XfnfAPbFVmf9RtOKnsbHLQw2P6HOq5c1nRHEmiwufuxnmLUS6VZPNcPZbmRUrjauLk2uOWi29+a6BhO8Y6eLThnF7qveIxuvVi6kw+aRBCEUbbbbUcnmtULKiJlQb7/bUReULt8A1NFi9E8u7+11dJmfdMMc9xUrQj1wKpAJPYR8SrrpCk+SaaqslvlMdiLGdpMiwX87CterYRkA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199018)(31686004)(83380400001)(478600001)(316002)(36756003)(4326008)(82960400001)(8676002)(6916009)(38100700002)(66476007)(6512007)(6506007)(2616005)(186003)(26005)(6666004)(6486002)(5660300002)(66556008)(66946007)(31696002)(8936002)(86362001)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUhoU0NFdmNUaUh5cy9TTHMxZHVwQStkTFV1TTFaVmFpT1VYV1JsMEtheGJm?=
 =?utf-8?B?dzBUQ0p5dmhWa0JTWjZQd2oxYWFpNk9RaFNQaURrYUowQmVCNXNXbG9SbjEy?=
 =?utf-8?B?OElmWWNPZ0JRMTN1ekZva2M5a2tIbTVDM01VdmJ0Tk5JTDZFQ2UzZFZkTmlV?=
 =?utf-8?B?VXdCRVBCVVdVUGZzSjF2VEhwMmwyQ2NnOU5NSFpVQU9IRzBWMHRQSExWcnZ0?=
 =?utf-8?B?algxTzBaNWNDU2tHdHAyK0NmZlkxNGhxVWhSWlM1YU5kUExmbzYrQmtUU25w?=
 =?utf-8?B?Rlk4L0NNMGM2QXB4VTNuMTJyMXo0SmJkcjYrTHNFWEJrZW0wWFdLamJISDdS?=
 =?utf-8?B?V01nSzFIS2swZXkzdzE0U2gzTTYvT1JuYUJXSHJYMUpWSzFHNmN0V2lzb0Yr?=
 =?utf-8?B?dGFtdnlGUjh6ZWhCc05TZDZ2dGRsbjV3M2Z0OXlzLzRIWGJvU3lrU2J5WWEy?=
 =?utf-8?B?c04vRnV6NHJMZ2FZZ04yL1R2VnVORXVNYi9YL0plY0t5ejNVSW93Ym5GanJ5?=
 =?utf-8?B?SEJtSkhQckNqZS9xR2ZaUDFFK3JSSlFXZ05HMTFSaDhxMWhwREFxWmRwdXpn?=
 =?utf-8?B?bW9BWHVlLzUrRVU0YytZRHlHQzNwL3F3cGlqUDJnMDRiNW9OeTFQNEIzekpx?=
 =?utf-8?B?eUJBUVczYndkc0sxeGwyalFCV1BEekxsYWJsRGU3VCtWZzczQUhVcGV2TmhF?=
 =?utf-8?B?T0I2MWV1WllUQ0cvalA3RW5MQW85L3VNWUFMdDEvUzgxajNvUCt3V2g4ZndR?=
 =?utf-8?B?U1ltbmtNL0hJU2tKMDFldjFpSjlveUJVcmFoc0FJWUhydU51VG1tNlJUNnJ3?=
 =?utf-8?B?eTRmYXZGd09ic2JFWUROTXpaNXQzTTBNeFFVekhrR1lweUZSQTdQeWtXWkg4?=
 =?utf-8?B?dW9EUkhmUjd6aitNc0cxdkFWS0JnemwyRm5nYVlLcjVZTXkyaEtGemhQKzFz?=
 =?utf-8?B?dWZWN01QRms2TFQxSDRkc3hKVlZjTkFWclBVWkJzK1F3a041Q1NpRlMxNXVy?=
 =?utf-8?B?ZWpkYXo3VTFIT1NDZ0wzdnIxamhOUGxkblZWOVZKeEtNUWw4WllIUUZHS1Rv?=
 =?utf-8?B?UnpQcXlCc1pBSXFQNE81K09iQzE2UnZ6dlM4SkU1ZWxHS0o0ZG5vMEk1ZGtl?=
 =?utf-8?B?YUJmUitlTGUwbmdsOXBPaWd2R0pIVzBvUWVYSXU0SVRyZmlxaU1ML1g4aW13?=
 =?utf-8?B?V2hEQjd4RkNUVXY2WUVMUmM1L3dhTk1jSUptOHU4WFk5SjczdW8vbktiVTVE?=
 =?utf-8?B?T1lkSTY4Uis4RitDM01MdVFYK3dDQno4N2dCZ3VIRHJ6QTlLdzNCWlphS1lu?=
 =?utf-8?B?ZEEvWE5QYTN6MG81VnpRRWhFY1gzSG14VEdabFpwb1RkbGdxdVZmbmxoa0ty?=
 =?utf-8?B?MVVOQ3R2bEdwdXFvMEdHRElrSS95dURmZlhoOUpLS3VGMTRDSGNvZGszSmho?=
 =?utf-8?B?bjNWRE9mT1ZQakY1YURUR1dTeU5kRktiMmt0aVdHZkV3RnlJUkoxN2VjSGI5?=
 =?utf-8?B?ZFVEbndKU0FMRHhOUnAvWnlYeVEyeFpaSzNpNG9rTDAvZW5LbUo3eHJQUUV2?=
 =?utf-8?B?UmFaditjWkJZVEYzSVUxVW5QRkpkUXpaNlo3UWZTamhKNmJTUm9WVnJjVFRF?=
 =?utf-8?B?Q1gyekt2UnBxSTlDMGNlRXAvTm5nNFRpejh1Nkd3azFaNzF5UFl2WXVOMWRJ?=
 =?utf-8?B?cU5ScGdxVUxaOURmQlZGMEFFTzBjcUhieUxFOGNYNzN1cmp1WW9NRncrdlVt?=
 =?utf-8?B?K3hybFhnT3V4d0c4ME5ISFU5cGE2RjFUbkdhSWF6aHhzRE9JVGk5QlhGaW5r?=
 =?utf-8?B?d1JiWVJodmhvTG42VFlialNCSzdHSUVWYUlIY2JBaGFnMk5Jemdjem1ONFVD?=
 =?utf-8?B?TEJFZzY2QlFYSU5JZnJHNk5uaWtBQWQwWnl1YVRhVU10RjlhRXRFU0ZXSW9B?=
 =?utf-8?B?OUVQRWc4WWlCSDZ0cURBOG1pcFF0TkN4VXdlZXR2YkpQNFdrendBTWtxMVBE?=
 =?utf-8?B?SUhRZmtXL0htWkF5RlVLQnZxM0xxdG9CcEwwOTZuWjRMZ1FRV0djcXRLMmJh?=
 =?utf-8?B?S1o3ZFFUVWVEUlYwakI4NkF4NFhhTVpHTzN6UTErVnFaT2s3QzIzeXh6bDZx?=
 =?utf-8?B?RjhmTjI0RnRwZGN5MU1zdVh3WTNWSU1jMkJKdmVwMi9mT3RmZTIyOVhKcGc1?=
 =?utf-8?Q?OQp8hL4xY2C8GjKnvaXSVXE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54523893-1ae6-4775-e22a-08db1a67a1e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 15:14:20.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvBzKvzNBk2+WW59smNyyIlZKEatvKFBEq/JxyFKgnE1NGuC9H34VPNUvj25gwhet8i01WM+EHtDDQIOcw1a2SAmRGIdsNzmqYzhOK4RT/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7838
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

From: Petr Oros <poros@redhat.com>
Date: Tue, 28 Feb 2023 21:41:39 +0100

> ice_get_module_eeprom() is broken since commit e9c9692c8a81 ("ice:
> Reimplement module reads used by ethtool") In this refactor,
> ice_get_module_eeprom() reads the eeprom in blocks of size 8.
> But the condition that should protect the buffer overflow
> ignores the last block. The last block always contains zeros.
> Fix adding memcpy for last block.

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index b360bd8f15998b..33b2bee5cfb40f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -4356,6 +4356,8 @@ ice_get_module_eeprom(struct net_device *netdev,
>  			/* Make sure we have enough room for the new block */
>  			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
>  				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
> +			else if (ee->len - i > 0)
> +				memcpy(data + i, value, ee->len - i);

Maybe just unify those two?

			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE,
					 ee->len - i);
			memcpy(data + i, value, copy_len);

That's pretty much a reword of your code.
The functional change is good to me.

>  		}
>  	}
>  	return 0;

Thanks,
Olek
