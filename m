Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F55672A86
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjARVcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjARVcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:32:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111ED366A2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077542; x=1705613542;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8h57mF/wcNiyIevzpbvr6QWBlJLzSvBFnL2ubEp0SKg=;
  b=PKKRzUEhrVPKVxxaYGGr6nDONMUKyaYB4S+G+dmXO0NNLObOilEOZNcK
   e6Ox6IEtXIFU2uNh7IaCKLW9Pfy5fkRMjvcIhC6IBAThZqBXsInR2vVhi
   BWYe3RaYN2lek15Zp4tuYdXSOFmjt6GxpTsBR/aj2UlF22cSO5ILnENsY
   WOsaNHlXJEeecY0ZSC5UwGUQCjyfIPNlSULnMKHlh/AHt6SVvz7wb3XKA
   xzGCetNAaAqMBwtThfQQFPrJ9+XJOuLXJgzmOLeEW77xLVNIt3PbeWuRe
   yb78MiT/gn34JVT5RGMpH/w6lG2emW+YsNdvptMF4MocT3qMH3jI1dvtN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322796967"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="322796967"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:32:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802368350"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="802368350"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jan 2023 13:32:21 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:32:21 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:32:21 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:32:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5vF4Ng+pYqfHeWlSBti03ncaWz4+rde6XQB5F5AwINbQUlEog48TNwrmK85gNCOLFE8ILkR6ym/e3x5IC1Gj4sLXvZMlCSVccexF02zuczymeq6Ztvg8p2jNNUE7Ku5rZtPjKpu5YFi6y+xI+cW7M2/d/HepkNgSF5CK2AzksG3Hbf6sht5eRNlbsW3Hf1yuCxHlhd0le7be94W4J8OFsAZeNFd6T6OaYGv9CyqOty20egt+JnhKv/Avv8+PDb/TmiKPPLERlt6jOKt+6KS37BVkqwWIwJ+MMUNEQxcVJD7INh6neNb8FKgKXRmOuNPlarM3qp6V2Z9l071W+okWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OFvSZwniUKE6ZKpiySXqYwm8UXBbMYSoqzgE/Qt4gI=;
 b=Xegzjzc7JJl4r4IAmaO/xZjaB1F20jmN77o0scMJuP87zLl0e/94t9q7hesd5cm4knxIboFLjT2lqWlzQigT/437M5XNMwq77fhZH8ACN0XE3X0J/ywv8CCvB4MoXj27Ts6AfdnRfL5NOv0Xxf1PoQoJMtBbqBLK+Le5aN2vGXJuFobFIEkGsWNVAQdFd61/2Z2qCYVVE+IbHgXAQ+YC4tKqdbiEwreSI/C+A4UXyjg8z8wBF/Q5n5rwoFAZshp/apkjl5IeG7mwbXJucO5dlWJ7Vo7/NttpH6ncw8mgAbzfpFzAeesMLdkh1YxaWsqkR/VJs3W7m5prO/+uSIALsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH3PR11MB7249.namprd11.prod.outlook.com (2603:10b6:610:146::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:32:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:32:19 +0000
Message-ID: <89b5a36a-96f4-5bc3-1b02-c88925fe49ee@intel.com>
Date:   Wed, 18 Jan 2023 13:32:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 02/15] net/mlx5: Suppress error logging on UCTX
 creation
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-3-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-3-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:a03:333::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH3PR11MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1a753f-d429-4ccb-844f-08daf99b7a70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fffDid4ajJmOOSLgMGhN+6iWp0aVViji3QL8TuZ4iG2YXq2SYyUD63Dmzg1YBUmCgbk2eEdWK7F7EiXZonW3tIb1Obrfjp+SUbjxI3FCORsM9uDtVIvKSV8rGs2zeylDkpp4Jhx3NwUvV0hcNO0FQH67iaFZKQxKQLiFQgNARx60Cq3/ZoSOVYoZebU84izEfIoq2p/8JZKKp0KZMDOaNssj772b3CvcEDo3evxGI2BK2gJCezzurfNAqXb5C0BPvZRbgy1p1AMtSSRa3RI1zmuHVeq11lqWTpNeB3pxA2546wV0GWToJpkv46dI1v/XlOsj3RiW9wFj5WAXtnVMPqvlAbiihCB7VJVgcpiWwwKvR62aAGTW75gr+G0LMz6zZyYit5ytjbl5Hqj+J8gxQTpM8XUOYyCjVvo9w3lEXVr+BrFwLmm50ggVbIjvDy07JFHXR71oZLrWq2TSzd++4twaFaoAH6ztLb7R3UpfYTXyA+WlIfkMeMKJjM/3x22DbdGawvURvA63TB2zLbUeMyElRtOE5WUC1h3dG/S7aQuMA3t9ZZIzkArZj56VizZgJBoygQO6ioeCtfyvpmF6vM20wXNw4XDnG6x4aG9FMNMmuJ5W0J7ywGEq9mXZYSqySPkQTSlFzdhvHgvvH/m7KBhrKs8GLXahy04ATGd0OVQReFsqnj2fBw7Ayg3XzF9t1aFn/bPG11K26C0Hu/p26V363KjdzQ+JsfufD5t7/4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199015)(6506007)(7416002)(36756003)(5660300002)(53546011)(2906002)(8676002)(83380400001)(31686004)(8936002)(4326008)(6512007)(38100700002)(82960400001)(26005)(478600001)(41300700001)(6486002)(66476007)(66946007)(31696002)(186003)(66556008)(2616005)(86362001)(54906003)(316002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGw4amgzMktaUFpPblFha2k3b2liMVpwUVcvSlJvc0N6OXNZYzNjSEJWQVYy?=
 =?utf-8?B?NGorYUdqS3JjU1RVWG5zODZNWTlJQVhza082TUNrTXYzZVdtWDc3Y3BjVDVS?=
 =?utf-8?B?a2ZtdjNXMU12dk1rR3lnL3NEdlh6WlNTcXowd0FsQk1jRVNOSmpIN2VjN2tv?=
 =?utf-8?B?c241Y3hNN0tVSVNFQlQzTitBRGdrbTZzWnZFdEVPY2t4OGN6NEh4Nk1Ob2xK?=
 =?utf-8?B?OTlsZWpXcGZ0V2Fxalk2NHd6RVJCY2kyU1BNY3hDc0hTZ25JL0owcEV1cWxR?=
 =?utf-8?B?VEJOUGNvZDFVQm5yM1I4YTYyc0JUcTFYZFhadjNkU0xReXYwZ0NVRWJIL25O?=
 =?utf-8?B?N2c4L3JQcVRick9IWHpxckNMNUNNZ29La0lPaWgvSnVwU3J2a3JIa3ZuaFZY?=
 =?utf-8?B?ZWo5cFgzOC9MeG8zbEdNbk5MajExMDBHbExRc3p1aW43QlJYa1dkTjBYaTlJ?=
 =?utf-8?B?dW1VREYwVXd0a3BtRWV1NW0vaWhkd3R4STJSMVBhUmNsaStRWCsrM0JlWXF1?=
 =?utf-8?B?bi9nWnpCRllxZmM1VUR0d0FhbnFzS3o4WEZ3MEZlbjJaU3FTdmdXUWgzeVJV?=
 =?utf-8?B?M08wVkI0dlB0TG5nZklUaWgzKy9DYmdNSjRIMVE4K3k2NUc0TDlOTzBkdTNU?=
 =?utf-8?B?WjlnbHUzTXU3dzFuTDBtSDBLckVMUy90U3BNSHhkYkdlU0N3V1JZWG14ZHFx?=
 =?utf-8?B?YW5MeTdrdlcwN0I0ZFJsZ3lUT2pLVTI4eHVhSjRxRUZvbjV3cW4wMlZaNU1s?=
 =?utf-8?B?UGIwZklOa3dMeGVlbGx2dXJzSG1RNS9DUjBYcExCNHB3WmtkOUw1RFlZbS9K?=
 =?utf-8?B?QkVISk8wd0VKY0hLVmZENkgwbHFiMm5LWDdvT09KdnFEdHVKOUhwakU3NTZP?=
 =?utf-8?B?SEc4djNaNzhxZS9VdXNabW9ZUEVuMXBzY2wrY2MrL3p1TW9qMGYyeGhOWDRo?=
 =?utf-8?B?ME5OY2tzQ3A2TmNLelo1VUZVSktIWXpBbkZGamtDS3JYK1hvYWZtQTZWK2Fr?=
 =?utf-8?B?Ym5GN0llNU9GMVMzdkllN216bkhXcTZKKzI2UUN2cXh2TEZYWUJWWW9iSnBZ?=
 =?utf-8?B?ZmRQeFZZdCs1dDBsd2Q2QnQzendHbWJ5NmdQM3M2QjQ5UXdyazhSSnVVUGpY?=
 =?utf-8?B?bVNCdDZpaXJrakhKMjJURHlabGlvc1lvV0UwbnRla0xrQnlVN0h1bDJQcGtH?=
 =?utf-8?B?MkJpdkNmQ0J2N3pvenVoUHlKVDBsc29raEFidE0rYUFNUi9iS0NkN2dkMWRY?=
 =?utf-8?B?cjRYVlRiYU1LZ0VqWnhZU3dwS0o2TEJ1S3pSaVliMFQ2MUtqV3FSOGg0S2FP?=
 =?utf-8?B?cDRxTzhscHRHNTM3MXdydDBKZEJCOWhUdFpINE1yUVFjeGxoTnVXK2UyaVds?=
 =?utf-8?B?bmZTUzl2aXlzbzdTSzNabHFLMWdKT2V3c1NVeTEzeXJaL3N4RGtOdzJwa3Ri?=
 =?utf-8?B?UXBYMGZXekJYZENLWEJGTFo0bURSYW1ZTU5HUm5GWVBIczlNT1hJN0FHOHRS?=
 =?utf-8?B?eTk5UEJReUk4OUwyd2pLa0VqQklXai91UVU5OTcwTlU2blpDTUNtOGhHYnRq?=
 =?utf-8?B?elVWakU4REpHNVJkRnBzVUVNcWdaaVJkOEgxR3BtdFpFdlgxeVVLV3FQOGRW?=
 =?utf-8?B?eFd4alBpNHkvcjd3a3paMUVXV0Z0RDRSWXJHYkFQN3NZT2VIYlFTcHFEbzM1?=
 =?utf-8?B?M0Fic3lrZnFxeWxLM1JsMlpDdWVEVC9tUTFxa3lTditiRTVmWVhOMkpGTzF6?=
 =?utf-8?B?V28wdnBncEtsYUFRVm5VTzlQM3QzTW81QkZIWjE4K05Qem1WUklxb3k1TUM2?=
 =?utf-8?B?MU5xVTZ6cUZUYnNHUE5HK3MvUlhSYyt2QnEwWndQdUpOaE44emZFV0dyczND?=
 =?utf-8?B?VGwyTkQrZlZYbEQrN1NmQmtvd2lpcFFKRC92YjJUVFAyOHpYTVU4UFVkekNa?=
 =?utf-8?B?anNoeEZOdlpNWkMvU3VaTzRSeW1kWjh0MzdibzlGdkUyei83SVFPSEU1WkE1?=
 =?utf-8?B?UVdvcnJNYU9qVUo3Wjhpb3NNZnpMeFg5VUJoWkw5a21FdEFTbC92UU1LMWhx?=
 =?utf-8?B?QlVDZ0wwUjF6MTduSVJLcUFYamlhSmdvTjRGM013NkFQYk0ybnhwSWVWQ01Z?=
 =?utf-8?B?ZUkyTkNYYXBSK3Jwb3NwVnYyVlpwWjB1U1djbHVGU3d1azhHS2p2T3RRUklp?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1a753f-d429-4ccb-844f-08daf99b7a70
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:32:19.6881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31aqD9dUQ5yA0YV+Q2iJ96odpBVB9w4ASCfbuDHLr7fey+dJa12FrT2QDqK7LGQJz0feW5E4VtFDbLsgbmhMyfcdMmkhlmUeOvEfOrgWtB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7249
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



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Suppress error logging that can be triggered by userspace upon DEVX UCTX
> creation.
> 
> The reason that it's not suppressed today with the uid check to suppress
> DEVX is that MLX5_CMD_OP_CREATE_UCTX command still doesn't have a uid as
> it comes to create it..
> 

uid isn't added until later in the create flow. ok.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index c3c8a7148723..382d02f6619c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -813,7 +813,8 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
>  	op_mod = MLX5_GET(mbox_in, in, op_mod);
>  	uid    = MLX5_GET(mbox_in, in, uid);
>  
> -	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
> +	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY &&
> +	    opcode != MLX5_CMD_OP_CREATE_UCTX)
>  		mlx5_cmd_out_err(dev, opcode, op_mod, out);
>  }
>  
