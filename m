Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C345E6220A5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKIAPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIAPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:15:39 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EE961751
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 16:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667952937; x=1699488937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iwBW/GbY66DEQIpVU5tO/fvmjBxw5gBuOpxc0iRuAO4=;
  b=NtGwETKVU+/tXau6MYuWmW4mDKSJ0t0nyWtdzEIldJGpPNXh4RUGuKg/
   Vysw4lmpGS0ffA0niafpgrKmV3kvhNkwYbV7a4qgnjQP17QhF1fxu2k+n
   gE5XiEqiBuC0Ip7hJKpeUQz61KPq5xFhBEDGgiXgWAJZROfLphARxQXTm
   UEg382Ir8PBB8tlaKgPKop+rUguzE0CeHZyO0SvWeCqffZ/ucUhLXUPhx
   zFFx62niSTkwEuGf2fjtM1lMAIc8qkbgq5Z4PoCp+erHFGo1s3Vt2O4rO
   ShA8LSLwaQZ1KDR2dgzM2ufiedtzNBEEsSmm9c4X7qN3i5sL7/vQEC4UN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290560707"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290560707"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 16:15:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="587566428"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="587566428"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 08 Nov 2022 16:15:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 16:15:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 16:15:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 16:15:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoZQtci46XHftf0iuMtz79xqjAk3DDUxLot+CvHvlOLFjlKc+FctNTOPEb/JEhywcNVAgplFJesCS6fZxaX2Y6FxHJ0oxGggY2gU/5r+aA8NscK4F0UkyQ8Ofrs4ztXToOJDtS/k7yV1SGh/hFCC/HJUrU3Mds40w/SVvblznm0u1462X1LmEtwOO2RgG2GY4ir1Ab7vVAFAKafyhem8Nw5JSQ4ksVvt/Blff4DDloaSWMvts9cuyl5vGX1wPEiyQy52+q7C6oU3cTSvUI4eZSjv7xjs/UtjAWiki648q/iILSTybuIlDJ6xZULbTgLsdo5fM6BQsfBcT7LHZt7EbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=po/icq/L+kAmd4iM+jTAq5UBllSkF38vSE/zWgUSEmU=;
 b=NkLUc/Rh7y0nT1qbAuBmm43Y4P6wQpRgrsnsSn8yfa1iSG87iEWQLXlE+6Ppu5LnTxryP9Erx5cZs14S3Ts37deLTzBnZoPDU0Fa9tX2wyOgUy30Bet8jmxusaaljmkADJ3EzljTRTFNsXqbtEZuUn4A1CH+LOhv+k0sPhE1N3vatZiDURScoUCZ10TsGVdQUSAqvjWTu9Qt58ilXSF7jC/nBv5xtrgmhUBXaCytCX+1z/vWdDw5dVjX4jTrf7WxQ6BUGPQkAx24yZyEgSeKlx+jkYNOqHMZJlVniXD/U5gJqAy/wj5yGWv2Vrf7N5tDn4r9OmypBY3FEUYWL66Qog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY8PR11MB7195.namprd11.prod.outlook.com (2603:10b6:930:93::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 00:15:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::87e2:5ca4:32bc:79bb]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::87e2:5ca4:32bc:79bb%6]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 00:15:33 +0000
Message-ID: <e4578331-7761-cec0-7f0b-85d2d92cbded@intel.com>
Date:   Tue, 8 Nov 2022 16:15:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 1/1] net-next: e1000e: Enable Link Partner Advertised
 Support
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>, <netdev@vger.kernel.org>
CC:     <jesse.brandeburg@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Sasha Neftin <sasha.neftin@intel.com>
References: <Y2p0kxpSN20BfiCD@gmx.fr>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y2p0kxpSN20BfiCD@gmx.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::34) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY8PR11MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: 7072be37-ced5-4dcc-886d-08dac1e78480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGV4hW/DyVK3rg1xrH5V1HvVZCXQPbWZO8fEQYGuJJWuli1oB9vSusruubqJTO19lwYqJUk0QQ6GePB9FsE3WaZeXV83+Cya+AEom5k3tOB6ILUS49Q4LXlnVP+ccCKyu1A1YaOONHIOQhObYDVdHzzeH0xXI87hi6Nh+dYyrDfJ7X7o4SgJATuaZT6kS8/0Jxcp1uvtMnH57FN+gjV+mLb2CGEZ/kbvLYUgcdAnW9SuT58WXhCfPwjKBd4FwyuRt82P0ExJ9gPWKY0GoT7XSaH05cDu9aKYbUt5gfS4xSQc2ztBEBjABbfUDhniOKqqThb1b0HlTy6H16ecg18MXfSU+2dpzMpEttd3x/f/YMs9IKGXOxWoHnxnCd3F1D7P4aaF5Fq0rf/PrW+Idh2fOHZAH1HVuhBU0YAMdCeGaHKbrdFf14VsUZ6nLJXj5y/B6YDpUlWLWAsSOfWSJD6fnDmPG/sJGSpITYqwH6WKoxlhZUD/Zh0uUamPKUv13PAIqI+AkrHt6vZ3o07FfHyAHFgTqhz5xCJUpSOp6Q93FBI1drwhpu7L6XDeFRreLKwHhTYlP63epSKKLyPp4FuE07hjp2LJdFqMd5Rk0w9kmonAtqu3DkuVW7c1K7a9F2M6avEvGISYvM42OdSI0vwHGT/0vQdQ0yC6KP8JK7qt/pX11l+lfA3tMv2UWKEPNwxxqVTSkx1NVL42YX1Cqf30OF2XuLJ1Ofc9c69gLjmklESg2yDbh9Do4cpnId0keBq25GtF4SgehmDBm1J/x735BHrKRSY1qAuBIkA5KK03O5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(86362001)(36756003)(2616005)(186003)(26005)(107886003)(6512007)(6666004)(82960400001)(53546011)(6506007)(83380400001)(38100700002)(5660300002)(8936002)(2906002)(316002)(54906003)(478600001)(6486002)(66476007)(66946007)(8676002)(66556008)(41300700001)(4326008)(31686004)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFZ1OVFYMkhna2Y5OUtwZzkwbE03LzVFQVQ5RkpneHRPQ0E1MnM5dlVHbitS?=
 =?utf-8?B?M2xhaUNlM2U5d2FhYkRac1hNSVRsREJCeEhPeU1TODlQY3FKL3V5ekpMSC94?=
 =?utf-8?B?d2I1aDV3MHMvQTQ2bHp4UHdndzlYbkd0VlpsQ3l2UkxyVmRvU0h1Q25VZTB2?=
 =?utf-8?B?WG16b2hGUGhkckxFcmJTTTFvc2luaWNzR0pHd0ZWcFU2Nlo1NU1UMlkweG80?=
 =?utf-8?B?WEZqYmJjZUpmbGtJaGgrbUdaZ0lhWGpGcDc0QXNjdnZ5bUZlam8wbWdUT0Z2?=
 =?utf-8?B?Rkg4VkIxZEU3Y1MrQlR6UGFuRHk2NDlNUHl0MmRXODZES3ZqQTEzbW9JbEFG?=
 =?utf-8?B?Sm9ZUHJldWovVnpDTkhyUzZiT2hKZ2FXVVhrVlhSQ0ZqUkxmQ1NvdEw5K2Vq?=
 =?utf-8?B?T2J1T0lhM2VmUmRISFRtb3NURE9ZSGN2TlFKNUZ2N1MwMnRuS0paQ3R2ZkNB?=
 =?utf-8?B?ZGZNN0ozeTVwWUpzZHNYVVdqSmpoemY2WjNDUm9XNWpzM3FlQjlOSUdnK2dC?=
 =?utf-8?B?S05SemRmWWEwaVJzaUtRclZVNUpQay8yVk5haElCVE83OFVwdjZlMnIvMVZh?=
 =?utf-8?B?aXhpVVpLR0lvQnNsblNsdVBWcy9XbnVzdmxYR1hXM3F0akFWWHorR3R1dFNW?=
 =?utf-8?B?NTlZcjJqK2RVSTdWVzM0R1QzVFoxUm8wdlppNC95QVU3M2ZBWm9CS0FyZkhq?=
 =?utf-8?B?VnlDNGY0bnBFZk1hMmVUVmcvUG1rY3ZiYUVORmNxS1ZyLzlDczlBbWFYdEdy?=
 =?utf-8?B?Zi9hVzUzOE9Gc2VXT1A3M1pJTVdyUlY2b051U3NseStVMWw2Qi9MVVRoVm5K?=
 =?utf-8?B?azRoa05ZSyswZ2RITmhNbXRZK1F3TEIwYTFKcy9yQi85NjNGV2pSSGpCOE1U?=
 =?utf-8?B?cWU4VCtOd2dJaHQzYkdoeGtJeitweHpzRE9pSmp2RUg2T05VNmpCWmxWZGlQ?=
 =?utf-8?B?Zit1azhRN2xyemZWTCsxeEg0UTF1M2t3M2lMdlpZSis5eTR0TWhDRmQrcGNl?=
 =?utf-8?B?RVlLMzUwSlRiR2pPVFlEeGNFNUpUTVRTZGl5RTk4dUFnTGtHUFBUTnNOTFo1?=
 =?utf-8?B?T05yQVBZbVc1VkdLRVJ2blM5ejREZGVhSFN0cjZ2Vk8yejRJbEp5bmE2dGwx?=
 =?utf-8?B?TElFWTRFUVViNU4yREFXVDdjamhGYThndTdWNkp4ck9LejNUeGhDQ1M4bCt0?=
 =?utf-8?B?RlRGYnRiaXNjaC9COW5mSXJWT1BqeENFak1ldEUvVXNyd1RNWllLZjFxMS9O?=
 =?utf-8?B?cTAvZ3NOL2dENFAzamRpdkE4MnNKeFB3NndWc1Z4SkNhU0pISGFuRCtQL0xN?=
 =?utf-8?B?a3ZJY3hRNTQ2WnAxajlRbEZML094b1VmZjd1ZEtvbmxCVEdlOWJadmlqMjlt?=
 =?utf-8?B?dG8rL3B2OEw3UnhsWmFJQmRRdnFaUXk1THZKeXgxYjcwTzAzVExBd3lRZ2hI?=
 =?utf-8?B?d0JNRnFsN21lNE0rRS92cUVBNU5iM2hlRHRQUmdSV1RSWjN5cjRWUE5Dc0J3?=
 =?utf-8?B?UnZPQ1NpYWViUldiaHdnQkRabEs4UDUyUEcwN0VNZ3AvNGt3YnN3SDFCK0NX?=
 =?utf-8?B?dzBuVlpQd1drSDEyR0pTem1CNzZKdXh1Z25jV3ZjTGh3K2dTeUl0N0o3QW9T?=
 =?utf-8?B?NjZPaEJ6QWlsUlJQcDhUQ09oNzhaMG5DaElnZzFiWFRZUlNNelZXS3QrZTdL?=
 =?utf-8?B?K0U1TEdjeUI1WXEwMHVMaXhYUGRNMm9kSGxRYUJpT1JVN2IxZWlCZDE1ZEZF?=
 =?utf-8?B?K2lQbHI3NXZhYmdJekxyRWxPUlJMQjVnYXB4SUI0ZVg3SVREcDExeWwzZG1t?=
 =?utf-8?B?SEs3NjNQUk1aQnR4R3kxMlZmNS9PNUxuVXNJOEUxaDEyQkVwT0huZHBjaG56?=
 =?utf-8?B?Q3g3eFpjM2lJTXorQkU1K25HUjRCVzZyaExpYzhwVTQwb01CRE5wYUFzeDBm?=
 =?utf-8?B?Y3NqRnJqQy9XamxhK1AvOTQzZHNmWkpwTm9qaVh2ekh6Z2ZuN2J3ZWx6aHBz?=
 =?utf-8?B?ZTBvNGVZQUdCR1kzbXl2TmhPbmNCSDRicVRHVllvbjFFaVFUME8vU3ZMSUtk?=
 =?utf-8?B?OUhtM2w5WkI2MTBHSE95MGlCVGd0SEl1MTVSVk00dTlicFhxUXVHWUZTSm1K?=
 =?utf-8?B?d1dRWXA4QWRneVI2YjZlUGpPNitkVTk5NTdwQ2dCRTY4YjczT1dJeXZBblNK?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7072be37-ced5-4dcc-886d-08dac1e78480
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 00:15:33.2687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Um8RG4YKQBI5Y43O6w2Ae2ZkbUUvL6cK0SUC0omgNh2OON0q/fNqvOT99pEib3jdWSSBpVcC9wkA9rZHkQsKRnTX+bqtoMM5WA40fAgMlVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7195
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: Intel-wired-LAN

On 11/8/2022 7:24 AM, Jamie Gloudon wrote:
> This enables link partner advertised support to show link modes and
> pause frame use.
> 
> Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> ---
>   drivers/net/ethernet/intel/e1000e/ethtool.c | 10 +++++++++-
>   drivers/net/ethernet/intel/e1000e/phy.c     |  9 +++++++++
>   2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
> index 51a5afe9df2f..743462adccd0 100644
> --- a/drivers/net/ethernet/intel/e1000e/ethtool.c
> +++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
> @@ -110,9 +110,9 @@ static const char e1000_gstrings_test[][ETH_GSTRING_LEN] = {
>   static int e1000_get_link_ksettings(struct net_device *netdev,
>   				    struct ethtool_link_ksettings *cmd)
>   {
> +	u32 speed, supported, advertising, lp_advertising, lpa_t;
>   	struct e1000_adapter *adapter = netdev_priv(netdev);
>   	struct e1000_hw *hw = &adapter->hw;
> -	u32 speed, supported, advertising;
>   
>   	if (hw->phy.media_type == e1000_media_type_copper) {
>   		supported = (SUPPORTED_10baseT_Half |
> @@ -120,7 +120,9 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
>   			     SUPPORTED_100baseT_Half |
>   			     SUPPORTED_100baseT_Full |
>   			     SUPPORTED_1000baseT_Full |
> +			     SUPPORTED_Asym_Pause |
>   			     SUPPORTED_Autoneg |
> +			     SUPPORTED_Pause |
>   			     SUPPORTED_TP);
>   		if (hw->phy.type == e1000_phy_ife)
>   			supported &= ~SUPPORTED_1000baseT_Full;
> @@ -192,10 +194,16 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
>   	if (hw->phy.media_type != e1000_media_type_copper)
>   		cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
>   
> +	lpa_t = mii_stat1000_to_ethtool_lpa_t(adapter->phy_regs.stat1000);
> +	lp_advertising = lpa_t |
> +	mii_lpa_to_ethtool_lpa_t(adapter->phy_regs.lpa);
> +
>   	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
>   						supported);
>   	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
>   						advertising);
> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.lp_advertising,
> +						lp_advertising);
>   
>   	return 0;
>   }
> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> index 060b263348ce..08c3d477dd6f 100644
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -2,6 +2,7 @@
>   /* Copyright(c) 1999 - 2018 Intel Corporation. */
>   
>   #include "e1000.h"
> +#include <linux/ethtool.h>
>   
>   static s32 e1000_wait_autoneg(struct e1000_hw *hw);
>   static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
> @@ -1011,6 +1012,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>   		 */
>   		mii_autoneg_adv_reg &=
>   		    ~(ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised &=
> +		    ~(ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>   		break;
>   	case e1000_fc_rx_pause:
>   		/* Rx Flow control is enabled, and Tx Flow control is
> @@ -1024,6 +1027,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>   		 */
>   		mii_autoneg_adv_reg |=
>   		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised |=
> +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>   		break;
>   	case e1000_fc_tx_pause:
>   		/* Tx Flow control is enabled, and Rx Flow control is
> @@ -1031,6 +1036,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>   		 */
>   		mii_autoneg_adv_reg |= ADVERTISE_PAUSE_ASYM;
>   		mii_autoneg_adv_reg &= ~ADVERTISE_PAUSE_CAP;
> +		phy->autoneg_advertised |= ADVERTISED_Asym_Pause;
> +		phy->autoneg_advertised &= ~ADVERTISED_Pause;
>   		break;
>   	case e1000_fc_full:
>   		/* Flow control (both Rx and Tx) is enabled by a software
> @@ -1038,6 +1045,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>   		 */
>   		mii_autoneg_adv_reg |=
>   		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised |=
> +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>   		break;
>   	default:
>   		e_dbg("Flow control param set incorrectly\n");
