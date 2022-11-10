Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C05E623E60
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKJJO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKJJOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:14:54 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2715A682AF
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdIpjTTGIfaVejdsVEcUls5+s9tg63RZjGd1pwlFVLRZfxKuCuzKzN8YNYZYgtSsWmA5PknhaUa3lO5rN8q7raTaMcCtB1nM3m7vHFj4KWa4pc5GLKeyromiGap/RKTSnglYB50/JMn2eYAnMRxBrsNffVD0P6iiJ8bXDMvmTIF0noIJ64O5XzHaAG7lLYmvBYaLeGMADrS447cNMt262Sg3Wz4Zorm0Pbv1HpyJ5cJqhAlmH1Dl/91N1WZ0DxDh0rk2z/S3HLF+P6Z/8ZbPHIkAAQytji1iqBg+saYXDmKxSGmxjPDt23POrWB2DBwCaPIzpKwu84KnkSytHwRUkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvK6ulC7XSDKpjPfWn5yhppkrkEGJQ7Yss1yUr4BYJI=;
 b=i8SlT+7/wFF5Hu9wc/SVkKJNKQy6e9Zk8jRzBGbr/kz8rFtrrEbZ/aPMWOEIINrUJjS+rnwOd2VVhR/L1S+bUsds4oopn4J8hhsvNWhez1bgrrmlqkhHuqsNxW6CdXYSNXpFtf0OTHvwSH3J+5v5rvSW2EoLQW0+u36YYfj7VUbCdL9SFT8arq7xVSocoGKxtWrCEvkxytoYwbSVHDLPj9YqRtV/+QtrfdxGqwjuDhcS0xTEKPv0mG5OskAzxHMTtLB0m3PIDE1bMRrtob/MKWUGojFnrkbbOavBblgVcKCH+4EXcKbQm+98i5CwBWGtovy7dERySWttGxoIOeVtAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvK6ulC7XSDKpjPfWn5yhppkrkEGJQ7Yss1yUr4BYJI=;
 b=UcjBkMI+iUcSuSIwGkOurqKrKk7+P7vFu2F3hE2LNT/PfMcg2fKl7Eb8cvvDQ/fVoaJ8iqMKOK8qUOUd8nVZgwz1mIFSpzq+QNBm8PM51QA+n7U1lE/pUjQkYJjyDpxTHup7wiumf/qGpC9EB0H7aLTbZBT95VhKnC71g4NN7FCycL8UlxVfilDWRhWjK7oS/nEpOWSqrrqsSqjzDlv533mBZW+pBe7pmeLePla8ZJa+qcGqf0XBTyz/kNlT5LNK4LAIoMTvWu8Xy6dPumKtCSA/2ZVBNocAJKz/YYvbe3zOk/45reLh4g8u3YoV77gsqO5GFB1B6ukkU644E9CPBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MW4PR12MB7431.namprd12.prod.outlook.com (2603:10b6:303:225::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 09:14:51 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5791.025; Thu, 10 Nov 2022
 09:14:51 +0000
Message-ID: <88c671dd-4d24-bec5-eb22-0275657cfaa7@nvidia.com>
Date:   Thu, 10 Nov 2022 11:14:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] net/tls: Fix memory leak in tls_enc_skb() and
 tls_sw_fallback_init()
To:     Yu Liao <liaoyu15@huawei.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net
Cc:     liwei391@huawei.com, netdev@vger.kernel.org
References: <20221110090329.2036382-1-liaoyu15@huawei.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221110090329.2036382-1-liaoyu15@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::8) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|MW4PR12MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: ec0d9bf7-6859-45ac-5bca-08dac2fc0597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpY38EPhFz6ev2JdrieFtnX0AQKVDGGcvJ4UhJto+l5cUCzMkDPAfkZDBbHsztJ2aHsKtou8BmLusBCda7Y0WQwNbqFKjVGsSTDabsnVJ+jDXi7lgWNWjRYNg+Ki0/XDOhwO0FTSemHh7YStJCsaFi4rtvd+hynSTz5SZ1spncLI0Mv8f25HKd7RHw4VIwAc9toT75JKBkkuQofKGg7SCHS0U62p1kHmSJ/PpwUAbhXuKMy4ZqG+iOEsoXXgKhKmFKTDrCjfYbtu+rhro2H0AIKEOjrNCSAb+euKtZR7uFEKZhLw+97qkvqqC1yIzml7dWSnWp76drGYHifkLSEae/zH/IaYW66XWzSe7daknkif8a5qeQiACHe/1MdplVbNVoyOYHaNFVQbRBuaog74rASNVl44O6ZrUT+DG30KH1f6ireF+WLPvTsi6oAn6wck35KkJ8B1F9O+SnZQ+AyzymQoN7kXPUu5RjSG+c0onPPYVpTCVNy9AyPor4BY/hlyhn4lnTtG4+QGDOTxbHbol5/IIINsPYuQjpMNZJm3m8H7AuAbd60vtZ1O21ERSXDSexHnVheq3lJnpLv3m+mBXBULmiJY2qPP6KSzBirz2vhK1AfRiwPPHriSsAyHWSZoWR6OMX9e3gR1DTqHRY2WWBCNdHV9xApeu2ORJwWyAHjrenDeqbb6uJ5LT6x8C2sZbD0gFhfBx6YDZsUDgWu/5x8fzWlo/PKVSdb1d2TE7RfXHH0TRdLvs4nXQOHvCq2W/chZCtWUsqbDgXvRFNs/J1dPJ6UvHPjL4uX3Mo07Njg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199015)(53546011)(6506007)(316002)(83380400001)(36756003)(8936002)(186003)(2616005)(2906002)(5660300002)(8676002)(6512007)(26005)(4326008)(41300700001)(66476007)(66556008)(66946007)(478600001)(31686004)(6486002)(31696002)(86362001)(38100700002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjFlSVBabnhVRU1KUzJabFcydnRoRzJyY2dqaTNMUFdBeit0YW5CUTdzVXZp?=
 =?utf-8?B?N0R1SDF5Ty91NUl5cXJTN1BoQkR5VkdBNTlBRGhSNEtHL0hwSjFubWZia2J3?=
 =?utf-8?B?VnpXVFhyNlJhaUwzbHdlYkVrbVZ1VTdTSG9oWXQxejBxTUlHQlppZ3UvWWNz?=
 =?utf-8?B?NnFjaXhWSFVKVUZwSE5wcWZZSlFxVjRRb2FjUUJ1WmsxTHdrVUhHOVdNMXQ0?=
 =?utf-8?B?eGxjdkR0VUwzcTlrNVBsMXUvSUZLdmNGeVkwQXlNK0c1eGNIdlNFTnErejFO?=
 =?utf-8?B?ZExwdlNlN2k0L29WSFkyQU9ZRGl3akhlSG8wcTBmQ1VEc280QTlTUHpXc2NN?=
 =?utf-8?B?ZUpyZU1ad3lZV21RNVM0NlNzb0xCWXJxVVBJM3lIVXN3MUJVaHZiODRaeHdD?=
 =?utf-8?B?em5vTlIvdmhvb290RVE0dmNlTWJJL3oyMDVkak5QaC9vRUlGK010L2F2SlF6?=
 =?utf-8?B?N0ZWL3RxT2ZnUlh5ajVhMGRtUjNpdE00VUpXR1AxUkVMK2pNWkhpa2dka2lJ?=
 =?utf-8?B?SnhjV3Z4eU1WcEdtbEVPenJVSVoxK2NibG0yZzg5amlYaVJObDNrNGYwMTdq?=
 =?utf-8?B?Y2ZXSDZkWDIzbTZUU3RVUURiRFRVa0dzWFd5RExVd1BmVUkzNHNheFhJV2ZX?=
 =?utf-8?B?OWdLa0RhZGxLRk9TL2dGbmRBUGJrUTh0VDNuOUpmM3lyenY3MUMzY0FMQjF0?=
 =?utf-8?B?NzZkUGMvVnlmUGJZbWF3VVRTYTB3cEdMajg4STN6bm5COWIwMjNpT05PUGlv?=
 =?utf-8?B?bXNaT3UxN1M4ZzIvMFBPZTlZbVNqMHRqVS9zN0VpVkFxY29WenpWcGZwbXZw?=
 =?utf-8?B?SXZRNUJwdkNvd3lyTkdkQXJKOERDU2JkWmo3eldhOSt0a1FzMDk5SDRrNWdU?=
 =?utf-8?B?LzhFMEtQQmlTemtDcyt2VkRKQWZVZFgrK05ScnlIU3VNcjVYZ2E3THdJMDNF?=
 =?utf-8?B?ZkpXeHE1N1Q2eFBzbEhnUldUcklmSWdjNVlXY1p4NDZHQm9JWFJqektvZ3pp?=
 =?utf-8?B?eS9uNTRDY1RHVXlyOHByelladktyQWozclJrYkF3M2U5UEM1Tys5dzBMaHQy?=
 =?utf-8?B?NFNHM3A5OHRxblR3UHRRdS9zRlI5cWJzNVJoWm42V241WGk2bzZKcFpubnRz?=
 =?utf-8?B?R250eW5KTXpUZkJMUUtEaE1YN05HNjlqdDhZUkovU1NoeGk0YjZCWmUzcWxs?=
 =?utf-8?B?d1k5enJHQzJLU2VxbSttemNaTGYybkZZUjZnR1RaUWtTalFlbmMwd0NOdVhU?=
 =?utf-8?B?Y284OGZRNkN0Nkh3Z0hKQjAyV0NHbVkxQ3p4NUtjZGhCQ1lvYVpXV0NSK1Fs?=
 =?utf-8?B?bDI4QmV2R2FFeGcvNXhQRjhCaVFoUjNoU241MEFFOVU2ZWM5QlBOaXJYdGli?=
 =?utf-8?B?U1RsS0Nwck9vWjVUamFzaXVkZzlUZWlQYktFRlBhdjVwaENRNkx6Y2Q0bHdY?=
 =?utf-8?B?YXJBR3UrVDFpbzBQeUx3Z014blY0TVdJOUhDZ3FoY0d6TWZYSTVGMEU2d2JF?=
 =?utf-8?B?Q0kwZllWZWt0UVhKVEs0bW9YN1lvSVRINWsxYWVxalFwQm9ocFlDdkZCZFhY?=
 =?utf-8?B?M25lN1YwMnBUNTV3QWNxQWFuWC9oa2RhK1MraDRwS0tpUk95UWlsSTRSVjh6?=
 =?utf-8?B?UEkvZUE1a3FMT1NJUGR1eS9WT1dveUFtbmQzNUpoZm4rZjZwUXBxbHlIam1N?=
 =?utf-8?B?Q05mdnRXWGNZYS85VFF6bTRDN0Iwd09xU29sQTJqa3RCdHhkVWlISkphalg2?=
 =?utf-8?B?VjBFZGw5UWlwMW5kTFE3RmN1VmxxSldHZklOejkzT0o0dWZLdXBGQk93YWRM?=
 =?utf-8?B?NEZiRi9DUW55QWF0Uk92U3lISWN3MmYwQjN4WTh4N2RLeXJwUkJGaHB4SUlw?=
 =?utf-8?B?L2d5RnhJcDRpaHpIRVFRT0dHTVl2ZkU3Q3pwclZOVjFBOUFNTERnem9QWXFD?=
 =?utf-8?B?MnphRmFzWHJVNjE3TGJHcmJPMFFyVmFQSTB2VFZyK2xzdjltTTRBVUJEZG5J?=
 =?utf-8?B?aWtiRzNHTzhNVGZaS0IxUUdESXg0Z0ZyQ2w1Q1hiRlNNRTI4YzRQOWdGRnVE?=
 =?utf-8?B?c1JoWmZjd3pWc1VyNHc0QWt4ZCtOZFV6NmJkcmY4c0FyS2FHVWo1V2ZYRUo5?=
 =?utf-8?Q?bkslUyegL0iWdthJzRmUlRIjy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0d9bf7-6859-45ac-5bca-08dac2fc0597
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 09:14:50.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXTzwMQ8RFjK8ge2PlJLX0Hi1Ab/60KH2HjU7F1eCEH0zVBGUKbZsPyM+SEeqXsH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 11:03, Yu Liao wrote:
> 'aead_req' and 'aead_send' is allocated but not freed in default switch
> case. This commit fixes the potential memory leak by freeing them under
> the situation.
>
> Fixes: ea7a9d88ba21 ("net/tls: Use cipher sizes structs")
> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
> ---
> v1->v2: Also fix memory leak in tls_sw_fallback_init().
>
>  net/tls/tls_device_fallback.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
> index cdb391a8754b..7fbb1d0b69b3 100644
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
> @@ -492,7 +492,8 @@ int tls_sw_fallback_init(struct sock *sk,
>  		key = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->key;
>  		break;
>  	default:
> -		return -EINVAL;
> +		rc = -EINVAL;
> +		goto free_aead;
>  	}
>  	cipher_sz = &tls_cipher_size_desc[crypto_info->cipher_type];
>  

Thanks!
Reviewed-by: Gal Pressman <gal@nvidia.com>
