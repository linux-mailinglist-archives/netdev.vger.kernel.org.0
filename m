Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA363B5D3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiK1X1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK1X1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:27:52 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B92F1E718
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678070; x=1701214070;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ETfo9zUdOkcnedgFUMhJ+WNYd3HrlKL931qpzjjkMm0=;
  b=Vpshd6CCYl5KxAgrETTVlsyS+zzZLm6nkscHLq+6/xPJwDUeqRSfLEuj
   GFMg4FL0kXRbChsamum9BNcOSa/wcT+ywfoLy3+UCwFnTFHKQVCiNwArF
   dyUGZFGQV/jgN3cWUFbjghnuAsUAed59oQvHJMXXsub+ilccjmglr+0uz
   Ypmnac7iPR9aMOVeaID4eoL6fZ0RXPbMTQOCenQJCVUxBQeBOLuIMWawT
   Ub3UmF2OYY67MNDtC8Dj4+RJcyYfUN8lE1ClV9VPnXLgRaPVZq73puAqh
   +Z1LId+JUhPNCQ+zmqTHDepMj0KWD96EZcnC89+0BXTkVrNg6MajCyl2n
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377118808"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="377118808"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:27:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888622504"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888622504"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 15:27:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:27:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:27:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkaH/tzGIG8QX7TWm3y8QJEFckICoB03xiEK4A2qVMtIuuslXESE1UG/ynCS2AIR5cqgpOCE7ek732EEPXyy+gxR+Igtz3NCaBscRkFbQAAjKlNatHn0W9WXSqXB8Jr4lqpcsXMg+cOFLbuVxXJH25BkJgsLvyCQmkkgSugFhP07jzkGj/JfkagO6ncBA0tc2w4JscVdnIfgDD85bmYMmsjjkHRoWlX1R1lBfBggKpeOS3kdUBTBNhRiOpKmy8jNFf8+N7dfUtbYEzqiy+or9Vmho1RdFaUXp2R4OHI/lyYZPGCYJiWELS/vaT452i6wTkdNiLnxt/XBzyhQk+abZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiRPjW0szh1I2GGOb12QfLKarvQRyBN0b5jYSfpCAAs=;
 b=ck2sp3ub2i/sMtlTrsgjCr/1Yqk7pPRprkrDAGesIIs5YELD44S3DERqUDFq22UaKMF0XyOvTJV9kj7rFZ6Ua/Cv1U+Q8RPXa5+Pqz3szCHBzAaRCzBPpYJlTH71DuDX3BUy5Sy7MXsHZ7MCOCXwH5VFA+VsyKiRkkIKrP1jN+TPVH7nTEpSZQDOnQB7OsMF0lCf2JP056ao6mDKHuBW4XyTXtrA60SnCLdQ8+lIrpP110fxxtr7TndPmldM35iDPt+tulUJnfXx6yReN44QHrn/hw/2ePbw/41106kV5l94Xqfd7kopCGAZfmJdt/sTTjPC3fGViFH53x3vzQwaPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5349.namprd11.prod.outlook.com (2603:10b6:208:308::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:26:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:26:58 +0000
Message-ID: <f94e54b8-6366-b782-5e4d-d18aba464e1e@intel.com>
Date:   Mon, 28 Nov 2022 15:26:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 06/15] net/mlx5e: Fix a couple error codes
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-7-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-7-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0065.namprd11.prod.outlook.com
 (2603:10b6:a03:80::42) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5349:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b8b7c1a-cb74-4f04-5369-08dad1980a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85+8eTVdDEwbYNvaxcpyTBLSLFlz3Zr8dWLzs7eN+j8u2yJXzSljUWqn7jQFXyFDQmZ88oLqPuhXV+CQyBLwqPT8yRXvxIRRwVW8nXyCX3s9zagvTachetVISBjcG9FUHwxISVWQVMMiAl1lm5/LpaUWUVfocAMm/VCW418P9nPcx7rsjKIg5CdVuFwSBmNhrgpGRsZJHhqQOgFt65lNlH7CddyC/W36XVYLtoAp1gqpdojl37n1csVi0mDfC06qUVePKSidU5V/ojpx8cT8mvlfOk19B29UHUMY6hUiRiSmvZr33vj+okojzdLqFk1Mw2MUFByTHyKr1wLtsXe2K3i9sxzwEs0rJiW6fJ6jzlg4cVTDWvxlJAWrGkIRnao0diuD+Otx7suDXIbSgxfdb+arMpyoZI+IO/VQiwqKTC/T4wFGEK5iZf5VZHgvfpdx9Ktp19gnLW967hR8JTBbk9IyJy17TXIFD6UaY/x1FU5rvPTTXv+QNySiGw2BAXvaOSqUo+3hOyNrMtF7viDur3DE0Anl2qGAu7TPgMjhtjqBkq5h+TWpHtOzaHvBraWuTYxrws8WQM9uLr5izo2MoKOgCiIhfUtWzXA/gUtzmXp8/YHqHTLfgvFMu8gzjc6MmZnFZoKaR/Ah+KZkFidRcBuUI2jROQuJ0Z9c+sklfwqu8aPJbrmCNxePcg9Ci/eFMSYrjYan696i5Aj+uEFB2bPXa/HS66/CBMtEr0nSq8C91msVYvXnTznkyDYledFdSC2Lntv7KLBQfe8+9FRG9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199015)(31686004)(6506007)(66946007)(6486002)(53546011)(6666004)(31696002)(66556008)(66476007)(41300700001)(110136005)(54906003)(8936002)(2616005)(8676002)(26005)(6512007)(82960400001)(4326008)(186003)(5660300002)(36756003)(86362001)(478600001)(83380400001)(38100700002)(316002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck92WTA3c0NRczhDZzVmSzNiQU8wVDhzWjN3T0Z2cHF1OEE2YjgyQWFKOHpF?=
 =?utf-8?B?ZWJXMk1pRnNwMkx3S0svenZPM3NsQnluOFZUUGVoRW1VcjR2Q3N4bno5T09h?=
 =?utf-8?B?bnB3MTZieUJqaFRlUlU1NlNVQTZ2RXZHZGhqdmtlWlRySWtEKzR2aTFOMnlZ?=
 =?utf-8?B?bDZPOTlMMVdzSkYxSm9CWUlydzI0K29nVnBOUllhci8yeVBvalZNWUZ5ajhM?=
 =?utf-8?B?dHRJTnBjNEYweDdQS0gxK05FYVBLK3I4YStxWG1ZcldFa3czSUd5SS9JQUla?=
 =?utf-8?B?Vk05ay9BQXphM0w0U3RUVzhVdmRuQ3ZUOXZNL1NuTWhKUUVtbklMTDI4MkFX?=
 =?utf-8?B?S3Z5RlZEMjFsOGtnUWlpRlhCQWh5NXA2RXk0ZW9WQjhkdmxWNi9tNWw5VjN0?=
 =?utf-8?B?RSs5eEJUWmdyVDdRVjJJVURpc1FkU0kyY2pmSExBL3A3dkd1YTR2MEU3MnJT?=
 =?utf-8?B?L0R0WGRkaHRrM1lQbys5RVVSUlRPVUdrN1BNVnNNaFpybDVyNld0M0xpUE1Q?=
 =?utf-8?B?U2VGbkU2V3BScmorTWwrTjlSS2VQSi9ENkZ6VTA0RUM3Z3BSTUowNHpkbXds?=
 =?utf-8?B?S05CdDhMTGVsZjdwRG9uS0VXT3BNbXJGQ0RoaEVFMnMyWmtINFppb3FsRnN6?=
 =?utf-8?B?RDZQaEJwbWpuWXhMa1JsY1JoTHRQaHFncTVYbnpGcDJET0J6bHk3aE5oV09z?=
 =?utf-8?B?cUVQLzRDcjZIQk9ROFl6TFRITzZ5TGpNMnduaHRhVUp1UldCTm1RZmY5elFL?=
 =?utf-8?B?ekw2YWIwZXNZUzI0cDM4Y2VScEhIVDJwQ0N6OUhKUXA3YWV3eDFtdGN5YzNw?=
 =?utf-8?B?cUltaitOU24wb2FmVS9PL3RYNWszcWNpWS82WHU3OW1KZDBHeFJOYmdwVGZ3?=
 =?utf-8?B?c0wrSnJMemRyYmwwT0loVm1pNUtYN2tKUzloelczdXphNWZHaU9tSGRPVEJ4?=
 =?utf-8?B?ZWxCVlRUMEpYaWp2Umw4Z3VLdkNkN0Z0VnU3MlVTS1ZEK3h3ZG5wMGFaUHhZ?=
 =?utf-8?B?NDUrbXowQnJ0WmJNMlhzZ0x1MEdpWmU5M29ab2JjajRQeXVQS1o4UC9mRWdv?=
 =?utf-8?B?WUtyNXcvSjVER2Q3NWxYRVc1TzV4dng4ckVTdmRlWC9sT2ZKektoOWRIaExO?=
 =?utf-8?B?bEZmUUVpaGRyYjM5YlJqRlhyUkNuenliQW9LWkNrdFVseFBEZVlhWncwQjJp?=
 =?utf-8?B?WDdGdlYxQXA4V3FUOVVxR0dwVlp0cFRTYWJKb3B2K2d3Q09oYXV0VkZjOXVa?=
 =?utf-8?B?cW9YTmk3RWdqUEZWcTF4cHlkWmNtT3I3MHBrK2ttY2x4NVYxN1pXekJxaEt0?=
 =?utf-8?B?YTJ4SkZnOXE5UXpoK2tITC94dkgxR3Q1MGtmWk0waTQzSXBWaCtjY3BhaGky?=
 =?utf-8?B?MEhaRnlUdVYrMGRMbk50R1QrWGxrTm9hb2o4VVYrWHF0Mk44S0Uyc1VFcHdi?=
 =?utf-8?B?Ym5kM2twdXFrN1c0L2E5eU9jMmFvN3piTUwwRVFXV3lERGsvYnZiSjRjSnRk?=
 =?utf-8?B?K0tpK051ZWZCQ1FuSTA3N1dKL1BuVWFKdi9tOS9qQzJJMGJ4OWVGbGlranRQ?=
 =?utf-8?B?Uk9RM1FoUlhUU0FoUXZtZmdZOTRiN0xYWW1RN0xUWDNacTRmVmo3dmE1amhG?=
 =?utf-8?B?OWJ4NXI5aC82TCtDc1RZL2ZWQTRORUJ3TXg3MmI3V0FmNTAwbEdQY2FUZG5W?=
 =?utf-8?B?VU5kL0trN0l5d29UejB0bFhkT2JRaHhXaVlXMG01NWkwK3hrQ2NVUnpseWFN?=
 =?utf-8?B?blBPTUVhWGNpaTlGVDJHSXlndm9wWXZRTm1GaEdJbzZNdnY2b1NlVHdGUitr?=
 =?utf-8?B?ek91N2tJakFKMlhaY3NhMTFmUkF5cGM4ZTkweUxOWTlyeWgxdWh5V2tvTlBS?=
 =?utf-8?B?SUpMZW9BRkR4Y0NOcjdjQ0dsSFV4QXJKSDl5cFgrbHBpbVdsYWU4ZytBQ3cr?=
 =?utf-8?B?aTROeXFVY0t6U2R2TVFBOCtBQXJqa2RtdVlJSk8wWFRMUXNETm5CTG9PRHlu?=
 =?utf-8?B?bzErRmdzbUt5VkpnN1ZuV01WOFhMbHJseTVmLzB4Tk02N1IwUHFsTFZwY0kx?=
 =?utf-8?B?c3BOUG9tWjFXSU1MU0U0MjFPL09zUmU2NmxIVldmMDRRdmRUcThQKzZOT3Bn?=
 =?utf-8?B?OUN2QXdUY2VUSzhFazJYWU41MzdpN3h5SEVpWUtRUVYxRUVzQjhwdVlBNThy?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b7c1a-cb74-4f04-5369-08dad1980a68
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:26:57.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsN2U+W86mXkr6RL91YJ7MYgYg9pZwFLJFrgblkkEmBQNth24FuLuuhoU2nlK02WxxOgrOQMPBq4wpxwmpo1wNGLCwVgKvBW+rBS+CjwxLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5349
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



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> If kvzalloc() fails then return -ENOMEM.  Don't return success.
> 

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
> Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   .../ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> index 1ac0cf04e811..96cec6d826c2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> @@ -250,7 +250,7 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
>   	struct mlx5_flow_handle *rule;
>   	struct mlx5_flow_spec *spec;
>   	u32 *flow_group_in;
> -	int err = 0;
> +	int err;
>   
>   	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
>   	if (!ns)
> @@ -261,8 +261,10 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
>   		return -ENOMEM;
>   
>   	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
> -	if (!flow_group_in)
> +	if (!flow_group_in) {
> +		err = -ENOMEM;
>   		goto out_spec;
> +	}
>   
>   	tx_tables = &tx_fs->tables;
>   	ft_crypto = &tx_tables->ft_crypto;
> @@ -898,7 +900,7 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
>   	struct mlx5_flow_handle *rule;
>   	struct mlx5_flow_spec *spec;
>   	u32 *flow_group_in;
> -	int err = 0;
> +	int err;
>   
>   	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC);
>   	if (!ns)
> @@ -909,8 +911,10 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
>   		return -ENOMEM;
>   
>   	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
> -	if (!flow_group_in)
> +	if (!flow_group_in) {
> +		err = -ENOMEM;
>   		goto free_spec;
> +	}
>   
>   	rx_tables = &rx_fs->tables;
>   	ft_crypto = &rx_tables->ft_crypto;
