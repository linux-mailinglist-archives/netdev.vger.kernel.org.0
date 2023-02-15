Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E691B6981A1
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjBORIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBORIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:08:39 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F79227D73
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676480917; x=1708016917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rY2E5/zVemIBHwt9IEf8K3Z04YhvSr6UbeXHuq2INA4=;
  b=GdVkZF4Fy3Zy5RYqYKoeNRk5u3MizE6o2vE74v6ywKwC9qnTLjBGrUUC
   mBTXDmRnNF9FHyCDectf4L2oGfkdL7eHm1Wo02GF4GB9gtavH0G+gD5Mc
   Q4bpI2DkK4nQ55WG9W+OuvolmcprFlHmYgldn6mAGjsJTw8B3RpjWL+qr
   Wxcd+EMMPK6XCtRdRQi2tRxPg5rsimvpWFzM6yB2m6FgrnV31Cze7f8de
   or4sxlB4p7S9Gycoknc3rTl9KZS47NClT6WMBB79PV05qSBnDdGAEmyUt
   rZfkeG5olWqao187aWk9VlSCOyghhRFIW0tILKFkP/sLX//IpjRIH0u80
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315138447"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="315138447"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 09:05:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="738424382"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="738424382"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2023 09:05:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:05:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:05:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 09:05:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 09:05:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJWiMsNEtaHyze87IySjcF9sfw5V/igvVerEhD8ygOtubQ9QQ+pC3KQefPADg0AlTKY4Cg8LDfxl9TyL2khg/JBNHtFa2CEOj2bgVBNJ9YeYPMZWGBpA7hvM8w9Q0S8MzvLRrts6nUn+PRCAYhJpjaky9rLBsmlTwaP1gtSjg6bAvdjf3kpgC3D+UiZKoRCEYVvL6ImVPpFNZd77CBtLvUu+RH6RLDS6LTgwDNbDwIDKmHl5zraX4SgBQO/tpZw22CObIpesZRWofGt41+TYAYhv12WYFh/frHeNgN94j6W6QtVRPNUWVnBvMJakWvi4PdvaLiBbUoRhZoFCKwoL9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbHidBgFrqV7HNCyx09q001WfxgEJH4vmQVH+EVzLYw=;
 b=md53zIQwCRQkXVyJeOeTtF0GsKZ3lzZ0FarR7xT/QyXywvXWYqfRVErn3OSNHrLGDrgKcqg7du1j2FD7LjFioYe74w0CUl2D2dtWw2HltK6NIknIDYt2pCMkV9QROC6wOetjz5HgVINq/I2RX4YYchfwlxXy7g/bbOSZMV9kBMFmWL2vgjk/boVJe3EKxorGdUHT2fXmFF9aCmk9TerRdz2s8yS+6iBIURMxL47fz55BFaL5c0psKic9b530OsHABmYMXm8mj1ktJzwS28Uzh8VLW+ORvGWw+PAzFLFGFtIuTbm+Obt+igWblOC8LZVienip0YXbxX88vbb8VqKnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:05:36 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 17:05:36 +0000
Message-ID: <b8dbd338-e2d0-5173-3186-4f92d7d52f40@intel.com>
Date:   Wed, 15 Feb 2023 18:04:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com> <Y+zGFVZPj2UzY0K2@unreal>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <Y+zGFVZPj2UzY0K2@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:5:333::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a300909-d699-41de-7698-08db0f76db4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1oO8kjvK/IEuvGtzAaltjtvQZVWBHVLXFKihWgxyRsWK0VvZC/Xvfk8lClz6gowsLBTnzGxzuDZwiJlSuMtmYR86udsUBctTsOxbpgA7KoFtkFFSD4IluXu5lYgfX8qoWkjYB75X4HA8spedyBtnMAV86F7Vz4/pRGbhMvK7hX1C4DTBxVVDrtv4yQSdnbQQpWuQwL+hNjQ968qzBYeulCRG0EB1VaY5pou03W8nfse+WdCqnr4SuAaFma5ykFIsOp2h8xqt7IkIbHKJD/oEEo9eKGa/+dYvWqJ16IenAMVR5qzY13OxFW9Rc5AayoxyQE7ZAqOkmmMlxjN/AOr7Phk6bzrF6O09dicE/ScEU4mUvnKL+omChFoDRnSwvvVXxGhVBeWUjMZ8MliMnzq+opMrZ5gkhty299GgSkxrEEOyMA3bJRJ+PhqxnmdUIgGsd2vF0LTRthQ58ouUisnMrsJACFZjtzl1B/GIIWQyfi5Yw4ZfYimfMkjvKGRRbES1xxLlTc/WnUE6AK9lxKu7AXLlq1R2nK9B7uswWDKOTeZ/nY5bImYGqEbNcBFvD8RtvNYWNKVW7+DDCml06PCm+pYpUnNPLOpAYDLEsZhsTo250h5Oa1YZv4e00l59HY5Pu3oIPxu+cBSfL5DHuZlctRXuPpioybZ6XXQ1ITDGwEVPxQBAP9O+qqke2fxcKAUkUrTKsDVq6XuM8ImwWyAf+ErYR0m4QT9qH7n2/h2HzPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(31686004)(478600001)(6666004)(6486002)(6506007)(36756003)(6512007)(26005)(5660300002)(186003)(7416002)(83380400001)(2616005)(31696002)(41300700001)(8936002)(86362001)(66476007)(6916009)(66556008)(8676002)(38100700002)(66946007)(4326008)(54906003)(316002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjJZeHp6bEtEeW8wRjh0RzZlelY3SU1XV0xkdjd0cnBqUHpoUUY5S2J2L25s?=
 =?utf-8?B?Yk9rSWRHMEJvOVc4SEU4azY1YmtGUytHWExYZjZYcFZoUEJGaVQ3eVoxMmtM?=
 =?utf-8?B?Y3I0MXhtK01PK3NKbnZkTEhjMXhiL21hR1ZIa3hDeWlQWXJsMm5LK3oyV3gy?=
 =?utf-8?B?NTZReDVMdWFTSHhDZ3ZiczBodlpPUlFGWGdQSDRsZ25SU0pCQW1zWFdQZUNG?=
 =?utf-8?B?THROOXIzQkhveUNjKzliYW0rMC9oSHkzWGVqMFRZV1c5d2FvMzNEc3lsQ29n?=
 =?utf-8?B?dnE3bmtMdWMrVFZCS1lhaE5iaDB1aXZGM2x1VnIzZFpXdVdjc3V2MGZoM25m?=
 =?utf-8?B?STV3bDJSNDNERXJFRzc1VWRPYzZZQUxFb2ROS3NnR1MxeEl2LzJUSS84cHZ0?=
 =?utf-8?B?YzdzZ05zS2hFaDd4WnFRMnFDMHptT2hYSytyT1dpVTRNT3Y0UVVpVnd3aEpi?=
 =?utf-8?B?S1Q4RWtHWlpUbWk4dVZqWXgrNXAyR1RxUk5iM1I1UnNaQmc2ckcxcGhNT2dy?=
 =?utf-8?B?QnRCelpKSGg0OXpQQzFPWXZydTRmZWZ4RWNXdWJnamJBUGhSUTlqa0IwcEJL?=
 =?utf-8?B?T2c1ck8wQ0VBTkZ2ZVlHQVh2eGRqWTB3dURBMXM4cWprM1ZZbWhEL3BWbFBO?=
 =?utf-8?B?d3RROWlkbi91MFR1dXdxd1IwcUY5ejR4MUluM3ZROG83NW1LQkR6eFBIUEdU?=
 =?utf-8?B?eVpCTndEb0F1dTZDcmpQaGFaUnJpdFY0WDZqQWV3R05qK0V0d0lVamJ6czQ0?=
 =?utf-8?B?SlZUYjhXTG9zYUU2dTZpSXpQSDVBVGtWL0RHMEdieEFDRjFTYVh1RUF4WkZJ?=
 =?utf-8?B?NG1HOXVGb1FCQXlOMjlSSXNsdVRXUFZBT283SG12aFFFdXoydmxpcjZCdWZl?=
 =?utf-8?B?azdTQmVMZldzU0gyZ1phR0UwZDFpL0NYTllRQ0M3VEZKRWVjWDNwdHNjeENZ?=
 =?utf-8?B?czVOaHpGWmdjKzFkUWZEa1YweFNUMEpsbXI0a2FZenhrcWg0VzhrQjJiblMy?=
 =?utf-8?B?WXhXdG5rTWJEMXV0ckU0allZMlVuanlPejEzZmVFZjlJYjg0SHNEb29iK2RM?=
 =?utf-8?B?QVMzakZUdGpGR3E5VVJGYW1GclJIV25wanFmOHFoS2tDcVZlL2J1Q3VhdmJV?=
 =?utf-8?B?K3VpYTNXQ1drNklQMFBjREdIMXBXb2FlTVh6blFOdHBPcmxUblBoemRaYStU?=
 =?utf-8?B?bDNneHk1YXV6NTFFNFRXelBRRVZhZmNQb1NQMzdRY3d5cHhtak9MY0dZZTNJ?=
 =?utf-8?B?bkQzYmkrZ3BJWEZpQjZrZERtV0tTVThwS0FmbVR1SHJlNzhvK1RzNWhpODE5?=
 =?utf-8?B?bkRjNG4wa3pCL3Y0akVMRzlQK2FCRzN4QlJLM1p2VmJhQVkzVUZuUXdvZzFY?=
 =?utf-8?B?MWxjRGU0bmowZnQzejBsVTdOTHFhZnFaS0tFSmpBK2xYK1JkdXh2RDExZWZw?=
 =?utf-8?B?eFE3K1QxZndQbVhXTXdiL1VMTDBYL2o3ZE9YTjY3bUdZREQySGZOa1dsSnNi?=
 =?utf-8?B?OFFBUjF2QkN0YzBWOEl4VTBRRlA0c0tMMHI0SXorbWNvN1lnYXFYQmZPUjJx?=
 =?utf-8?B?b2RoOGR5RjQ0Q0ZaZHVOUGw1dmdTbUpxTzlVLytGeklXNUloYkNXOUx4Sloy?=
 =?utf-8?B?V3hQTjRQRzhoUExqSkliNE11VERFQzRGay9yNG92V1JFSGxnR3cxbU82b3dr?=
 =?utf-8?B?Wi95V3JkWnd6TFJ1V2ZmRWJyVERHUXhFSXBxMnFzVFR3UE8wNDNaUkl4QjFt?=
 =?utf-8?B?WlJ5RnJZd1ZDMEVGS3VrMEdMZWYrWEZjTWV5cXVJZ2FyNTVYT1VJekRCTlBP?=
 =?utf-8?B?VU1neUFxQndxMVY4MlRHQitlTW56WDcwdHcvZWUwRllSczJMWSt4bkNCcVRX?=
 =?utf-8?B?Y01YSDZKeStHbjIvU250NDFPVDdkeE10Myswb1JDY3NvWHBUNGZHVmQ3K3Zp?=
 =?utf-8?B?WUxMdSs0N2VuWUxxcFVPaHgyNEV4VWRzeTJrVjIwS21QNEk2bS82M2p3TGJP?=
 =?utf-8?B?VGptMFdza0s3V1BFUStFMEhhWVRGcHBGZjhGem12V1NBMVhnRWxmdVJIQURj?=
 =?utf-8?B?aFptWVYrc3NGSVNpWGFtQUJTaHRpT3FyMkhwaUZWcFY3Y1d2MldZY3RTcC91?=
 =?utf-8?B?eDBGVEFESVU5dnc3dmJxL0RQMHBLZTVOQVpHSTlUNGVOQi91dzUyT2ZTTjEx?=
 =?utf-8?Q?t5NOnteEGDT8PWNSkEA8BhI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a300909-d699-41de-7698-08db0f76db4b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:05:36.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJW33OS+mbfFl20IpH7QXJNwJcwowcGnopF9Lu6ZzlEi0Ibi7IyWq1ofqPj6Sv7PcSCotJlgBTWrPLykE+2QrQKYTm4vg0CvS0q3coGjyqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Wed, 15 Feb 2023 13:46:29 +0200

> On Tue, Feb 14, 2023 at 06:07:54PM +0100, Alexander Lobakin wrote:
>> From: Saeed Mahameed <saeed@kernel.org>
>> Date: Fri, 10 Feb 2023 14:18:07 -0800

[...]

>>> @@ -437,6 +438,55 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
>>>  	return 0;
>>>  }
>>>  
>>> +static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
>>> +					  struct devlink_param_gset_ctx *ctx)
>>> +{
>>> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
>>> +	int err = 0;
>>> +
>>> +	if (!MLX5_ESWITCH_MANAGER(dev))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	if (ctx->val.vbool)
>>> +		err = mlx5_lag_mpesw_enable(dev);
>>> +	else
>>> +		mlx5_lag_mpesw_disable(dev);
>>> +
>>> +	return err;
>>
>> How about
>>
>> 	if (ctx->val.vbool)
>> 		return mlx5_lag_mpesw_enable(dev);
>> 	else
>> 		mlx5_lag_mpesw_disable(dev);
>>
>> 	return 0;
> 
> If such construction is used, there won't need in "else".
> 
>  	if (ctx->val.vbool)
>  		return mlx5_lag_mpesw_enable(dev);
> 
>  	mlx5_lag_mpesw_disable(dev);
>  	return 0;

Correct, I just thought that if-else would look more intuitive here
since it's a simple "if enabled enable else disable".

[...]

Thanks,
Olek
