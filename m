Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8CB63B5FD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiK1Xgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiK1Xgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:36:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3123326EE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678590; x=1701214590;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3A6LYdGUgZtjPYBhY8sswqxz0mgYTgqQ4NrBM0knIq4=;
  b=TwyIIh5Vr0oHE2uSUkDf3FwR9iolmWydtDQF1Rj7D2cVc3lEGd+WV1nz
   RRd55OigjFl1X6d0z92yb54PfkdZzJktUIKOPtrQZLhXbQqKoIpUx6nj7
   2rQnWil1tOknTBEZy7RrksAmSA7+WeytdGJ87WpriYV4nCpJtufRYqlB2
   J7wJgd91rlLS3Lvv2Ab6LIFdRjTI9E1SnxFuizpzlVu17Ijyqdi6cLCFL
   zGGqdvJgZTGyYw+4RT91kO3Fnggr685jkVa+R9qIjmg3KQaopluNmk9kT
   PmPbntXKbNEf4zyhIJGTPO3TYu6QXMoqA9J1cfSqLipXUAWy0yu3kFQfi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302558213"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302558213"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:36:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="972457849"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="972457849"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 15:36:19 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:36:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:36:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyaIfIQMwW5ZGSAaJPfayh4g46HMCOd4zTuDnuRg6LIhv/LmEjouqILhf0Njm5S/jvZ2EwrlO8YBKqz7BdN9mu9Dvyq6uluSRY1qI7O9KzjW971u95256XwkRa38rOEaAPZcGMAjE9FBpV1NPzfIESdXY+71BGv23G8nroNEH8LtJk9wCMiz+B1c377yMv8HpdHvOTeI6agk+ubVinNGVcNoupcTZjjjfAhIiUcxe5/sy1iOjWLCOf8U9rb8H61ixhA881WBAzK+gEeEuI20Q2SsKgcRqgMYS+JwpeoNTnApYuvOHYFHUGBpQVxolR6F8aWbKLK8+GAdWLfwDte70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tshF/1vRWPfjvf2LFgp27Q7jNHAZhnTHA3b31mA4D88=;
 b=HF3vdZSCMdX1arSyfkI5WpThf2fq79umbswS4fRZR1VRn8fwo/ct1EbV4VF8DnV+0SmebO/ZG4c0ietoLwoeYbybAHzejX4oycVF6P3XISBrZo0EywEQ1eXoVmGFFrRdez24XxdbsmJi8tNUVzKKteVef3S+qAnty3RdqgR//UxYUcDA06uA1UYBxdlKVgsmny2LJu9QzcA3pen+kMLFAGn2xIlIY26bG8tgcBQLTZvJfSRmsVJC51jLVj5wQZPsshE4rGqsHB6Rv331qxVKiHQJLAKu13f6FnFg5m3mnq/IYDJLQJf+EcYQ8j1QdoYD0fVsV7yLW6woaUC15PclAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:36:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:36:15 +0000
Message-ID: <130ac9b1-9ac5-4a4a-2fa3-c1681f639940@intel.com>
Date:   Mon, 28 Nov 2022 15:36:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 09/15] net/mlx5e: MACsec, fix memory leak when MACsec device
 is deleted
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-10-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-10-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: b0c0a179-ade4-466c-8ff0-08dad199576b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gbe9hG2y/m6dWc1RxWv6/0H7Eb/56DOudizotXn8qndBNGCwSwXxFMpXarDDLnc9bP/axR+WGdxm6vijkFMYaduj2sgvIvf/5ab2Mkw8tLx+KETzP1ssnajlPfe8gLkkcSEX9LU4S6ImtjXjZFRAf+sO/isWd9dA+VWH4ozFm8SJer0AhVcQHDzPoyYOEx4leJVmrHoZtaI73Yc9ozBY5CFPJ/QuTLasgnfCxsFS15e/5p8DijtkiX7GJLbmW5v5qnTbbusR8gB0jP9C6phpFBEgjAmUsK/EFlW3ehtyxDw/1oelgb60c/EXKVtW0HID/+/OJoH1VTRcxa7J6Wzr3//b0cRP8Qf2hxIpDWKBPWesro+jEzC2A6ZI2tcpZFUp/+LoLhQHAz19cIifXJNCvPUxocLKQJYmHrv8SZfkGBd5EkjO6ZwmaQC+yzYdgmvUhx/YW6g4sDP+TcL41bw8pkR7o6LkcpDyk307RIgzJpSrPADOQXEFr24T3dWoAZyLQtJkTg8o4ayJKTI9yXskStvsaXz/AYqyd/SFGBPkqlYV+3ZZIFEZeDsayJTis7uxClOsXu4GpCTM/CyeZZtriwSt840NSe55cjlLIZsbIBqIogtwnrCozWmZplzrI8G74QvOqt6hKF0bHMDDcIez/NxAU8NL+OHHSCLkHCk/WiFCxqImS9fqEWxhFw7ikfvQnNdrWZo3CdghG2zLNfJ80hq26Bhv2UHmVIXEvf3vKz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(2616005)(82960400001)(38100700002)(26005)(6512007)(7416002)(36756003)(110136005)(54906003)(2906002)(5660300002)(186003)(31696002)(53546011)(478600001)(86362001)(6486002)(6506007)(66556008)(41300700001)(66476007)(66946007)(4326008)(8676002)(31686004)(8936002)(83380400001)(66899015)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnErSk9QQkQvNHQzcGVGZE14SERucThUTENET1MvcGFvd0owdTAyMGNZSXhz?=
 =?utf-8?B?MTlTQmJCV00rbkkxNDIwWGFCWG5SN2NEZU43cG41NkZRd1ViNitjL1Q5UFZq?=
 =?utf-8?B?bzQ5c01yZisxN2g1M0NHbWVCcm5kRnNhUC9jQUREMWtBMERjOUVRdFZCb0tq?=
 =?utf-8?B?WUllL2U4N2RwSWFkVENSWmNKTGxDNFhFSW5kYVpUT3VDM3dMOUlOTGs4MEVP?=
 =?utf-8?B?NnlwcGRuUHpXN0h3NVh4M2dRdzJCeXZSSTRsN0Y5REQ4b0YwbHI5ZWxyR0wv?=
 =?utf-8?B?UE5MM2VHMCs3UTNlZUU1VndWZFZJOVRCN0lyZjBaUVR2QjNxWVFqYzBHakYr?=
 =?utf-8?B?MWxSTGJQVWxJa1RkY0lnVkpVeVVwOXN4ZjVNYnRQSWJKVGdQMEN1Zk5COFZZ?=
 =?utf-8?B?a2FqQVJnWm80RFUrcFhkTThZYk53WmYrOURsY3RlSjdIamZLQmxadGFRTGlM?=
 =?utf-8?B?Z0ltNVppYUpuT0xmQlJhSEFjZlBUL2N6dFBlcU5SUzVEL2xFZjQ2czl1cGYx?=
 =?utf-8?B?OUlSY0lQeEl1UWNBZHhXcjhVVEJXMU5WYUFmaXBrKzQ1d1NiOVdpakVUVGsr?=
 =?utf-8?B?L0wyN2tRSGdDZkVoQk5OSjZ1VFVwMDd6UDFVM25CQXB4UEI4MzJSYkRtNmtj?=
 =?utf-8?B?enNWWjR1bkcvaTZPYU5td2dYdzJHQnNLeHhUWGV1dlJyeUxwbVpLRUw4Yk9F?=
 =?utf-8?B?bWR5QitrU3pIMk1jcXFLT0Z3K1gvd0JYRDIxY1c5UlFSWWZZaVNxbThJSU9R?=
 =?utf-8?B?NGpiZkppTWRtd0hBR3YrcGNSSGtVY2Joa3Vra2dJbk5SY2xEK2hpMnlVNTZo?=
 =?utf-8?B?alljaFZyNFU1YzNJL0o1U0dQWGtkUDhBaElwRTZqMStieCsxMlowZkdBNzN6?=
 =?utf-8?B?cTJSRm5DdzMyK3hxYkhqaWRpR2E5NVpTL3pUOXNnQVcyOEFqd3h5clNiM1V0?=
 =?utf-8?B?a2pDZGQ3QUZhQ3owRWo0TisrNHFvWnVYYXNEUjhDMFdjOU5KZWdYTVpzQ3Ri?=
 =?utf-8?B?ZU1IU0YyN2psNW55U0N5TW1UZ1p3M2VpcUZSSW1PbXpTdTdxeURPUmRmYVhV?=
 =?utf-8?B?aUp6d2Y0RExmT0V4MVNFYjltTDhKWk94V0R5NVNIU3h1ZEVYOWcwM3FNQTV2?=
 =?utf-8?B?b2NqeGI1dzhIRjZ3bDNDNzc4Yjgwa0E0Zno3eVUrL1FoRmEraWV6MlBjQlNC?=
 =?utf-8?B?RUgwa1UxVythU2RYR016dldQRFJaelkrcGNmam1pbGxYTjFYUWdKdGFYRXZ1?=
 =?utf-8?B?MHFWYWtTd25sTEVSVUpXa0ZWblFVM25Gc2RYTmZ3aG8zTEdYZzRUZkp6bnRl?=
 =?utf-8?B?Mm8xWlJNYjdINnpQMGFKdzk1Q1h1L3FRWTdYUlkrVmFYZTJ0OWJiVkwvdU5F?=
 =?utf-8?B?U2VGM3FCRjE1Zy9ZekI1UE5qc3FveHdaTGZXRDhveFo4cTFHKzBYYjcrWnV5?=
 =?utf-8?B?cmlydlVIeDF3YmN0bHFIbUtjS1Z1UXBKQVN4S25USEVRVUJleHJkaFl3anBv?=
 =?utf-8?B?UXdVTXlybmI2VGVKQ2d0V1QzdCs0b1NLaGcrZDA0VXJtYXc5c24yM25CdHdP?=
 =?utf-8?B?L0l3WmtNVENlM3JyVzdraXJmSHdYOC9vaDRWY2VKTDNqU3Jla2xKM1g4K2k4?=
 =?utf-8?B?Z200aDA2bVQrMDM0WTFJQk4vSGZ3RkxuRGFZQXErTkwzL2JMbGw1TWxyQmsx?=
 =?utf-8?B?WmhQcFZQTWhOYXUzcCtTNFhZb2ZmSjl0ZVRQdzFreUcvdVdUeXNXbnRUTzhK?=
 =?utf-8?B?c0JuTXFZdTR4YVl2UXlVTG5IeXQyTitZQkFzdzZ3U2RYWTBZdHpIaVBPNXBN?=
 =?utf-8?B?cC9jM2crbUVUejdjK01HdTFldjc5TFlPbmlROXZWWit5S09DMTdCSXJ2d2hB?=
 =?utf-8?B?T1ZKVTJESmptMTZZZkhOQlNlWVp2TTlLMnFDTXFHTE5XbGc3NFJaVVJ4RGhL?=
 =?utf-8?B?S1hHZEpWNU1FZ3MrUGJjRjlGQ1F3S2Q0WFBWRnMyMzZyVDFlNGtjKzR3UFoy?=
 =?utf-8?B?OWNTRDNQeGJWUTZkT2RNSFBuR0pyWlhXdWdlTTh6cHpDN2puWml0MUlZbDNi?=
 =?utf-8?B?b3MzQnZNdy9IK21XZ1hQVnF4TTFFQ2JwOWdWcGRWVzUzenFHNlhHa3NBeGdS?=
 =?utf-8?B?NGJkbVVxY2tvYUhZN2l2VlZVZFYwSGhRdXhLZFJNNitWaHBNbVVRNlV4OHN4?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c0a179-ade4-466c-8ff0-08dad199576b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:36:15.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6MN5QLTWpXeWK8sMYGrdeL93NqSxJ+ZkyIraOmI32SJ+DFqMq3SxXcRsHEQnufaAs8/ZTaG4dOcQtHK2X3ELq3dpyfSU+kfcKjXsrgEbZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Raed Salem <raeds@nvidia.com>
> 
> When the MACsec netdevice is deleted, all related Rx/Tx HW/SW
> states should be released/deallocated, however currently part
> of the Rx security channel association data is not cleaned
> properly, hence the memory leaks.
> 
> Fix by make sure all related Rx Sc resources are cleaned/freed,
> while at it improve code by grouping release SC context in a
> function so it can be used in both delete MACsec device and
> delete Rx SC operations.
> 
> Fixes: 5a39816a75e5 ("net/mlx5e: Add MACsec offload SecY support")
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   .../mellanox/mlx5/core/en_accel/macsec.c      | 77 ++++++++-----------
>   1 file changed, 33 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 96fa553ef93a..b51de07d5bad 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -823,16 +823,43 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
>   	return err;
>   }
> 

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> +static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec_rx_sc *rx_sc)
> +{
> +	struct mlx5e_macsec_sa *rx_sa;
> +	int i;
> +
> +	for (i = 0; i < MACSEC_NUM_AN; ++i) {
> +		rx_sa = rx_sc->rx_sa[i];
> +		if (!rx_sa)
> +			continue;
> +
> +		mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
> +		mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
> +
> +		kfree(rx_sa);
> +		rx_sc->rx_sa[i] = NULL;
> +	}
> +
> +	/* At this point the relevant MACsec offload Rx rule already removed at
> +	 * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
> +	 * Rx related data propagating using xa_erase which uses rcu to sync,
> +	 * once fs_id is erased then this rx_sc is hidden from datapath.
> +	 */
> +	list_del_rcu(&rx_sc->rx_sc_list_element);
> +	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> +	metadata_dst_free(rx_sc->md_dst);
> +	kfree(rx_sc->sc_xarray_element);
> +	kfree_rcu(rx_sc);
> +}
> +
>   static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
>   {
>   	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
>   	struct mlx5e_macsec_device *macsec_device;
>   	struct mlx5e_macsec_rx_sc *rx_sc;
> -	struct mlx5e_macsec_sa *rx_sa;
>   	struct mlx5e_macsec *macsec;
>   	struct list_head *list;
>   	int err = 0;
> -	int i;
>   
>   	mutex_lock(&priv->macsec->lock);
>   
> @@ -854,31 +881,7 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
>   		goto out;
>   	}
>   
> -	for (i = 0; i < MACSEC_NUM_AN; ++i) {
> -		rx_sa = rx_sc->rx_sa[i];
> -		if (!rx_sa)
> -			continue;
> -
> -		mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
> -		mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
> -
> -		kfree(rx_sa);
> -		rx_sc->rx_sa[i] = NULL;
> -	}
> -
> -/*
> - * At this point the relevant MACsec offload Rx rule already removed at
> - * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
> - * Rx related data propagating using xa_erase which uses rcu to sync,
> - * once fs_id is erased then this rx_sc is hidden from datapath.
> - */
> -	list_del_rcu(&rx_sc->rx_sc_list_element);
> -	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> -	metadata_dst_free(rx_sc->md_dst);
> -	kfree(rx_sc->sc_xarray_element);
> -
> -	kfree_rcu(rx_sc);
> -
> +	macsec_del_rxsc_ctx(macsec, rx_sc);
>   out:
>   	mutex_unlock(&macsec->lock);
>   
> @@ -1239,7 +1242,6 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
>   	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
>   	struct mlx5e_macsec_device *macsec_device;
>   	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
> -	struct mlx5e_macsec_sa *rx_sa;
>   	struct mlx5e_macsec_sa *tx_sa;
>   	struct mlx5e_macsec *macsec;
>   	struct list_head *list;
> @@ -1268,28 +1270,15 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
>   	}
>   
>   	list = &macsec_device->macsec_rx_sc_list_head;
> -	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
> -		for (i = 0; i < MACSEC_NUM_AN; ++i) {
> -			rx_sa = rx_sc->rx_sa[i];
> -			if (!rx_sa)
> -				continue;
> -
> -			mlx5e_macsec_cleanup_sa(macsec, rx_sa, false);
> -			mlx5_destroy_encryption_key(macsec->mdev, rx_sa->enc_key_id);
> -			kfree(rx_sa);
> -			rx_sc->rx_sa[i] = NULL;
> -		}
> -
> -		list_del_rcu(&rx_sc->rx_sc_list_element);
> -
> -		kfree_rcu(rx_sc);
> -	}
> +	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element)
> +		macsec_del_rxsc_ctx(macsec, rx_sc);
>   
>   	kfree(macsec_device->dev_addr);
>   	macsec_device->dev_addr = NULL;
>   
>   	list_del_rcu(&macsec_device->macsec_device_list_element);
>   	--macsec->num_of_devices;
> +	kfree(macsec_device);
>   
>   out:
>   	mutex_unlock(&macsec->lock);
