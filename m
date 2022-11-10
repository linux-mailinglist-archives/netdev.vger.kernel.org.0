Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3048C623D2B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiKJIOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiKJIOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:14:32 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA316367
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:14:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im9TN+srGY0Y6EwwxuquQshNCF6W+bIyQAobL/kEigxuFFc1tV4UoE0vSlpCcgB2zwDCDZlPOO7zlVQh1x50UPgW/zDjP9zesFDwYwLS10sIXrIDAgL1nMvNSxY8CvBrWznj9QO+Uysm6Z9BnUXCe5bwLkQE/HSGs3NEgv2qJfbSP5yZa8bmXy1fECGi4w4I2gTfPwCVp8/SbUs5cuzcHgFjhQLbfxEYZ0jfGQD1BTNm+gwjXB9G9iBd3xtThH4RpPFwBGLw1h93qIeLUkZWKSod6KYYp/NbYXL9rBc7SuFMr7CIqSAXEQihUU+yT2Birab6/tqvD59bSieRJvbKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jdn3U5Z06Ygf+uq4+dfZD6CanUXfHVdZFaXWx1i1Qcg=;
 b=BsbUAyfYaX8hMhEFv9QAqkoug77grRHD42KvEjZ76D32+ft5xX7mNiJsoaARXsWKfr3hbQ2QHH6KQUk5i9spoUnggSuDrI/LSrlnsJOBNYmMEGkpu6nLfvqw3GcqkAcLVoSkm9oUYxC+DuZh5N33CZi/BpvBGA8g4OPNeeTuW7xNDJs/LlG/+fgiksF9V9ry1S7eCRu65AfgXtpRfYpu7fN0q0e+GJM20GcJsKW4EX10vmGbO3VXm6X/pFQZxJwsCBIRmgeNEM2rtgowcrQA80RMThbhmgNdTXvjOLHzXfXU0L2a9kKBaMK0GxTxVZmA0tZNe7JRwUGj+pG7VXxgtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jdn3U5Z06Ygf+uq4+dfZD6CanUXfHVdZFaXWx1i1Qcg=;
 b=U+ZaRST1KTnjoVYAu2rs1zvuxyfceBRQPXdtb7UyC4uN7tLpl4/C1e/ezfhZlKtcEGP2WEwo3GmcFkxKQB+jFf/xHjWseZD7RIpIPYMEigx08D0oKyzQpvNNz18wXoYkuTEBGT0pggT5Ksp5vibTJV/qYq9ppNuNHKBWcUiXpltJbTbinsFWqtliNOQxAEu73pcqvIWt7OlXEtAy6l+1L084kLGzHqrsrpedjU5xz6qHxB8kZ+Bx+U606de/uIokk4RjuAwa92F47ZfcadrlcaDC6QcljiKKq4Sl6orjm5XwJuAMK6DoryQNQoRCL9V1Ph0qytYy8V6wQzfJxx5mGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 08:14:28 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5791.025; Thu, 10 Nov 2022
 08:14:28 +0000
Message-ID: <af4572a0-7e02-9aa0-bc64-e06471fae61b@nvidia.com>
Date:   Thu, 10 Nov 2022 10:14:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] net/tls: Fix memory leak in tls_enc_skb()
To:     Yu Liao <liaoyu15@huawei.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net
Cc:     liwei391@huawei.com, netdev@vger.kernel.org
References: <20221110080131.1919453-1-liaoyu15@huawei.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221110080131.1919453-1-liaoyu15@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0040.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::32) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|BY5PR12MB4035:EE_
X-MS-Office365-Filtering-Correlation-Id: 7de7852c-5d38-4882-5741-08dac2f39683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDlqrRmbZyP8I/6RE60EH4ZcHAXwU/fFXndt8uBMW7CUfJVLbdbNzTMdsftXiNa8ncVW80ZcTxDJrct2GHg3fj1fabsMzJx6yyw7aDd7QaZR+6wIN+WENvkAfVhzhPrtH8a6+CzLlLFITsMBa5hrv6aARPPy6uWwy/1sroRVwj373VPUZ7pvndhV6MNFPXJzx1o/t3xi1Y+Tpr9/Dk+oE9pKLj+nCtK5ESaiWgx9zaql/NSFFqltDWENf1HbW5jfZWkJAWgtf1fHhYfyL1aNc91PY1fPWO3jUCKanboVqtkBLek0ZrcmEemCRlgdlTkmh1Mp8S+yJZO1RRTyWUN3eZYm2zF94lthbWUZAdMwuc0jSvywX6jqtDFSeUEHCWIKR3ECnlnoOgDUDMWA6KQ9tvS9TjRKxG2+NEH76l7mNFkvW9r0SJrtMG5tL66gCMpxoxD3+OnXun6AvfKNRiD+4ba2eplDg40g/bwI4Gz9jVUwpzXuqAqGO4A+PD496lNkhsQoSgtxLhObYX3DT/WbHqr3jwTCj5Z4waYJvvVG9s5G1VlH1QRDJRLdOkvpKx79H0Mhz9pwGDXvF9HkgNkRvDDUu6C1h2v9H7kYIzQ1D3508T7d1tCBNV0GUbyA6VMvhX3olth/lvIKrDK8sayuUqVQ7OJS/s6ePh6uLcXiSfxALVovwUrOa4ZzOpmmy4d39DFM2y9DMfjYixZRIKamJoMwaOAgecOrKPjQqSV7ceeu30b/hHhq/3rA0FKHipmuxgU6r/uCikzbRTM2OQjCb2MOzPIN8jA2F8pyasGmPTE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(26005)(8676002)(36756003)(6506007)(6512007)(4326008)(41300700001)(66556008)(66946007)(66476007)(2616005)(5660300002)(8936002)(186003)(316002)(83380400001)(6666004)(53546011)(31696002)(86362001)(38100700002)(2906002)(6486002)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWh0VVdUTXpKS3lHeVdwdXJzSXNRU1NiWVphLzQ3NCtsbmZjUFJTTzNWK2JT?=
 =?utf-8?B?dW81bFFhY2xXb2FXdUZ3RGpqVlBnOS93ZWhWZTNycGcyUjlYVFNua3hvOWRX?=
 =?utf-8?B?ZG1zNlFTeC9jL3ppWGpEbFI2VFRaZ1hWbHhpVFpKSytHVGdKUGVlMmZmSkhM?=
 =?utf-8?B?cTc4SjdTZmxMak1IQXk4dVExeWRqdk5sS1F3VEhxVTV0NFJOQlAvQ29NZDFL?=
 =?utf-8?B?Q0pRcUFXMVBkQlBsTloxTnhaQzdOSXhUcWQ1ZmtCWnVvL0FLbExBQS9RWkJI?=
 =?utf-8?B?M2tiY1B3bHI3MzAxNW1mRGd1SkpWYnYzUWFrWGNoQm1vOTZzRk9kRWt3ZFdK?=
 =?utf-8?B?b0pzMFhzY3h4a0xTaFhrempZemVVTFB1SXAzSWdlTzR3Y2k2ckZRMXZPRUxv?=
 =?utf-8?B?T244UDc4K2R2dzFUM1Nkdloyb0I1WFcvTU5iM1A2ZFNyWUVlc294MzZPeE1s?=
 =?utf-8?B?K3lMYUxudTNFYTdBa1l3SlFmNHRZTFhlc0EveE9LL2lDK1ZnUmI3MkZnR21P?=
 =?utf-8?B?dVhoSWdEMGc4YkU2RnNrdkh5TlFUcjJZbnZIQk9rYUJydHB6c3grVmZiWERO?=
 =?utf-8?B?V3hZQTVYUGR5enltVDhkb3BjNG9Rd1ZtSXUyNlRzZ3NxOXJ1dUg5SG4vZEV2?=
 =?utf-8?B?NWdTdUVoNEwwaENxbE1pVHdJeFMzUFFKNXdJZGdpdVBUeGs3S1hGUzFkMmk5?=
 =?utf-8?B?L1BjWVlTNmJzcm5heDRDQmtXMEFoTjU3OGJmcHZxMXJkL0JpdHNiSTk0Q3gx?=
 =?utf-8?B?bmdVdzBsZGlYcFRFSkp5QjY2R2xOdVZKRTlDRklKMWprYis5NVBVWDFlK3c4?=
 =?utf-8?B?WSsrUHdvVEFHUHRTcElIejRPbDlFemJ0MFFXVWpCYTZ0YXE3Wi9RZEJtcmEr?=
 =?utf-8?B?bzUrNmNuVUFQQUdCUkVTNTBwVWFEbWV5cWZzQlhRNDJMSTBYNUhrd2hiQmVQ?=
 =?utf-8?B?OVZXek03TjVNWVdyUjBoaFBkeVJmc0lzTmVlR2xobmRxVThwS2hKRUduQUtv?=
 =?utf-8?B?cjFMUStaQkRFaFFCNGZhcC9pRTJnUHFsTHdheFJSTVROTXRTZTk0RERKN3BQ?=
 =?utf-8?B?V0UrdGF0NU4vd2JscElYaXlVU29lVVl6WGdFUkVzck5wMHhvNFdGckxoZGRW?=
 =?utf-8?B?ZDNkdS9GQ3p6dmhOOWJCeUIyM1VucTRtUEUzNkNFbmFwaXN3d1BGckJLVThz?=
 =?utf-8?B?V2JSUUFvS0lUOEZGSEt2SnNVUXNQa1dWeFdDR0NkcEwvQWwzVVlFRldYbCtY?=
 =?utf-8?B?VmIvd1ZvY3d4NC9zVU1iSmR6a3h4RDZxMy82dG5DcTBpQ2k5Ry94Ri83MmlD?=
 =?utf-8?B?VE4wRzhmRWhBa3VHdVhkL3JCNS9vQU5VaWJXd3l0QVV4K0hKMldxTThKcER6?=
 =?utf-8?B?SEh6eFNNNUhCTlJnRGZFVTVmc29BQ2ZDTmdWRlVISUpMYndRc3k1eEFWeHBH?=
 =?utf-8?B?UXJCajRPaTkycXR4M3FBRlV6c25uY2lKWkdGN0Jqc29teVhrTFdEREQ0UEwx?=
 =?utf-8?B?c2M3c2tuRWlJNDA0NGpFTDAwYUZqUHFYQ0lKWGRMOFptUlhmbjRCVFM3bXY4?=
 =?utf-8?B?RzljZVhiSXJrZG1lc3JhVG80QmZoajVMbkR5SmZzQndyVlhmQnF6YkFuVi94?=
 =?utf-8?B?djZMYjZoVEVmbWFncFhQcWdjTG8yN3pIVEljREs5clk0V2tYOExnY3ZWSVdP?=
 =?utf-8?B?ZC8yNUdtOTkzTFcvZTlwNDRXUlBZZUJpN2dBRHJJS0I2UGxtRC9tYTZORnAr?=
 =?utf-8?B?bDZ5T3kyN0lzeVdORUJ4UW9tekhRQitkczNQSnlsQWE3WjhpY3pXQXAvdEZY?=
 =?utf-8?B?ZXdNVU4vV09KOUVmMHRuNWoyTWk4VWNIYzhZVzJDNURBL0dmZFhGNUU0UDhs?=
 =?utf-8?B?V0lyd1ZCRlVKUWh3ZUFKTnFxLzBENTdoaWE5ZXF2QzRiUEYyM0I4SzgwNUdr?=
 =?utf-8?B?VzZpSU01dVZtSDhncHVCVmlVeFVxL2RrNTUwUnNvYi9aekExNEhUNFp5eWNP?=
 =?utf-8?B?TEIvVktMbkFVUlBUS29IZkpWY3Q1RDhRRzN0eEUrSE9ob2Y2Z0FQdkFkOEls?=
 =?utf-8?B?TmNCYXpzOThUNHhGMHFsUkkvNFZ3a3llYjAvNjlKQStub2EvWWxXSmlOMlBU?=
 =?utf-8?Q?MXZ5QWrKU79DUQw1+F3htUoJB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de7852c-5d38-4882-5741-08dac2f39683
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 08:14:28.6877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVIqEPIA1vbsUFj0RlL9sbEz4yfPc+JxkLW+lgEkg9mDHt8XyfdbiDRaXs2p/aaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 10:01, Yu Liao wrote:
> 'aead_req' is allocated in tls_alloc_aead_request(), but not freed
> in switch case 'default'. This commit fixes the potential memory leak
> by freeing 'aead_req' under the situation.
>
> Fixes: ea7a9d88ba21 ("net/tls: Use cipher sizes structs")
> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
> ---
>  net/tls/tls_device_fallback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
> index cdb391a8754b..efffceee129f 100644
> --- a/net/tls/tls_device_fallback.c
> +++ b/net/tls/tls_device_fallback.c
> @@ -346,7 +346,7 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
>  		salt = tls_ctx->crypto_send.aes_gcm_256.salt;
>  		break;
>  	default:
> -		return NULL;
> +		goto free_req;
>  	}
>  	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
>  	buf_len = cipher_sz->salt + cipher_sz->iv + TLS_AAD_SPACE_SIZE +

Thanks Yu!
Please also fix tls_sw_fallback_init(), it has the same issue.
