Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4C26C9C46
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjC0HhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjC0HhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:37:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EAB40D6;
        Mon, 27 Mar 2023 00:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMw7h9bzEgn1mZJmjoCmEl4kaIU9uCnXJsRLF1fiYQ7q8krdWceMCBSoNWmM8sPbYm2eApfNM3589yRUftLJYnW0kuYO5JLERCFBw5o/MXHPPIjtn4RRLpPF8aY/wJlFvvvgSHNFVm1nN2uOpQvXGgllhr4Em24d0S4l0rXQ+GyDjiKDJab8+HYs9tDMr0qj5B8sqoEQuUnCUVbo46glG251Q8xPdrfZAbAa4ookbT7E/CdGzUWTNkPHKFO63CuEW7T5ktozqzsJBUsd5O3z4xCYDyCpoVL9PQqWSUGeq/mki+ErunoQX8hM2dUo815mfTlvbxO5/sbA21wxP1bBpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgX7KVvpqyx2YC1iKHneFn3hC5K/2tDyHTzC6v41qC0=;
 b=eDExwPjjJVa4S4X0ChWj56tXLeQAGcy08fDcBNhTjytf6nLYlC8d4PEimDXvTHOwTJVsFsqA6wjapf9g4/2LBjwvitXx8jvI2w/3u1cn+xNmLOBxzuSM5EqWjo2vrLtNPvWsHsFvDEc44pCSbQzTVENZa9mH5cM3GCKHMCgSduhw5lBvUsZVJhHQ1xQkJvkzhM6sFKE15U2HmhyjHbjtttpQuIpd24ZCZllqym7I6TdxnLZzlE7hGb4zunfTCV0VSImMiSJARQY3T6W+2tFlN7Vkh6i/vzcvEronTryIxG5zcPkjm9gyduDodRf+JNBy+XTok+403fEmxAQImEhG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgX7KVvpqyx2YC1iKHneFn3hC5K/2tDyHTzC6v41qC0=;
 b=iPPw3rW+H7zHWYXYu3du3S94uyX1baO5KGNVOJBx3GNziQ+JGCwoAF8O6VrDlsBTMJeAYTESNFmgkd/q5t/oNbkTdzu5+ZQjWKt4Of7w6lBXuw9qt3FAKO/QYmdC8UnFdiS1CKy5RKm3tJug/DHGo4W2iDsUZRXAwMxWO8tW9uhKqi9jljmt/4ROCTyGv18Rb4Sr2Mr1TKOrsWE1YmkBHwQAzKB4XE7X16kenRWFwdVKKK4VvAi4eRrG6papnpRxLooexWWultlfuzH0yLKmbRGlXZBQL2QsqmFaeF2PPlRxtXxMDbEMz3ows/jiNWbFkHEBuoZE65YkOnJ1L2b0og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Mon, 27 Mar 2023 07:36:19 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a%6]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 07:36:19 +0000
Message-ID: <e5620a5a-6fdf-8254-7c42-e816e8977c1e@nvidia.com>
Date:   Mon, 27 Mar 2023 10:36:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] net: ipa: compute DMA pool size properly
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     quic_bjorande@quicinc.com, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230326165223.2707557-1-elder@linaro.org>
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20230326165223.2707557-1-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::14) To BN9PR12MB5258.namprd12.prod.outlook.com
 (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f05236-42b2-40b9-669b-08db2e95f438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+LfFeMiB4orYi/zEsaK8cakG0hJeiV5QpoI0NwFHyVSjXN63x4Jwy3U0ikJmwHDJx/C/vcjL3zuARIJrWboP44GrfkCRsbDbbdV3+P4MlgYYv7W+Iz5+PiiGBXXY/t8YJVSq1D17Ow+dokN6MVtd3rPf3BcqoFGbuaU6Z70fNruohC2pzqX7FS6Ef9cguKOTZi2mi2gjuCMQUK94IB2BXZ3Sb8d7AagFxLs0VakvgxXUixIQByZFHW3xfzt42DcCc2O4RFy9Vxw4LUGoY0BHMAywLSMyU2/Orfbu8xnJ3/XzVbZeYWwtwtyHtiLj+fkJO15+X0YkcP1M7kPab8gKWKPUnTEa9kNlHAlQh/HdvgfobsGV8ymUgnKe6y4zrB6VwQ9GpuZWzsztLbzBaDTa+jDWxLyCoHlViLkbYa2nuGfBHjWl/BrKeEIgNvmEQuMVAy8udATioiteljNJmqnebqRXrG58UDWZcE6JDIsWTawsUdVyLpiHvYKVLQvxVkV8owOjN/yp4QAzb1kKBNqLSmWFz65WXKxGgWevb24vYulKHTPZZPoJWDa4iAg48VjC6RGhX2tv8HehtGRMzgXvzt+0grCE8QOfy7++ekCq8ED2Z9HRNrpOmUQYxxAgT0NFyruaSRDz4UZ58I1spG29w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(31686004)(83380400001)(31696002)(86362001)(2906002)(26005)(6506007)(6512007)(6486002)(316002)(6666004)(478600001)(66556008)(186003)(38100700002)(2616005)(4326008)(8676002)(5660300002)(7416002)(36756003)(66476007)(41300700001)(66946007)(8936002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmR4Y0RIZ0RXZEZhN2tmV0FaTXFnNnFSTk5uV3BkanFvSDJZTmY0NU5wc0Na?=
 =?utf-8?B?ejltQzRBYys4M1NqNHRyVU8vbUFOSDc2ZWZwVDZXQ2k3aTQ1YThWWHBUaWJT?=
 =?utf-8?B?NDhxcHZSUmdOa2p5TDhTQ241NHVxVWUremF0SGF3TlBrR21wK29WQ1hpWG1M?=
 =?utf-8?B?enBaV1ppMTBzQURSbHk1Vmh4T2ZkcUg3ak45V2lCZ2h2bkpwK3VTaHZrb054?=
 =?utf-8?B?ejVoaVFOczRDMGhwQ3pObDR1MkdyR0pFRmd0SnE3STg4b3BybWRzM0VxVlB3?=
 =?utf-8?B?UVBGRndZSDV2YnFyenN4ZCtNK1o2WjZZMFpDajljU0tNYS9lRjBTOWxqYVI4?=
 =?utf-8?B?ZnRnRDJuVTQ0MW9WZ1ZSbFpNZlltcXBoWEp4VzVYZTZrWDVyZHFZb1k0YzQ0?=
 =?utf-8?B?NklNcVhURUhzZGNPTTFGRWhEcmllZUoxbkhTV1dOQ1puTFpVZVBXWUY4T0hN?=
 =?utf-8?B?T094UVZ4OVJJeEg5MENLS1dCdGFxaEVWZUdmUklTRkZJNDFIZ0ozbVF5Umsx?=
 =?utf-8?B?am10SWRIL3UzY3pyZ0dsUUFURC9SckRXNVB3YWlhRVgyN2lpVHdWR0hBbC9F?=
 =?utf-8?B?YjRqZ0dZTURicyt0QzFtVHNqLzFOZ0pVeG1wNi9OUGJiQk54ZWhwQ3IvVmpp?=
 =?utf-8?B?N1VWRXJLNEF4ZTRIaHdXQm9oRHRZdmZQaFhtYmtFcllzbGxZZnN5NHhQV3pa?=
 =?utf-8?B?NTRJMEdTRTBubTBxOUt1d3N3Z1BpaFEvRk5YT01SQVJsVUdHdklhVFpEMXVX?=
 =?utf-8?B?OFBad1ZvenBQOC9nclZScnB6Q1dmL3lXSEFGNUl4NFl2Y1JnVDUzOHBtRXFU?=
 =?utf-8?B?R1lDYnJpYitlUnloKzhRQkpGaVoxTTJpNVZQZkFRaVVkWWhBdTBZc2c3ZWZB?=
 =?utf-8?B?NU1Za2ZlZU9PVkVlUHZ5WnpacVlHYTJSMzE3WTV5WmdDR3ZSdkxUZTFITUE4?=
 =?utf-8?B?bDQzQ1oyWTR4dU1reUQ5UWpzWnNCczJpbmZnaUs3dnpWZW5uOW53cG1ra2Ir?=
 =?utf-8?B?bUV5cVNtZU0rK1lCZnoyTmUzQ0R5ZnVhdDUrOEw1V1c4aWxCOTRQbXB5T2JL?=
 =?utf-8?B?QmtnbEk2MGM5NGxKYmVZQkNIMjFKU0hKaUd4enBkNmdZQWJuOXJaRlprV0VO?=
 =?utf-8?B?NmZZSFh2Y3lLZXM2dmNPaCs3RzBKVXVHN0ZqTXRzYkRsSWkzeG83K1VPcTRI?=
 =?utf-8?B?Rm8yVnd6UmxjOGJyYnQ2Njh1TDFxMXJOMk9DaEhIT3BjSjl0YUVCTUlBVmZz?=
 =?utf-8?B?NnVESDB0NFMva0JYZW1qUG0wTjMzM290Q1RxQlZHMEE5Ui9mOW05ajlCbldU?=
 =?utf-8?B?ZjlpMkkzd0UwZHZ2Q0ZGa1VZbktxc0hFMGQzZ25pY3BjOWI2TGs4ZjZibm54?=
 =?utf-8?B?WHNOQVZ0L01FRmd4Q1E4c0swUFBmOXNuYzJqbWtDUnp0UG1oTjAyd05nZkZy?=
 =?utf-8?B?RmlOb0lUOUFRN25xaGtiTVhiVzZMZ0JUZGNFcy8xRlN0b0RHZUFWMGhVY0Rp?=
 =?utf-8?B?VFNWVlg4ZStQZGdtMkhHVzFuQ3c1WEVmZ1pMUnliN0N1bWozTEx5TlptSTl5?=
 =?utf-8?B?RG1UWFg1bGJYVnNQUWhVbjBaODNVWmUzYzZlQzZpcWZlUVA2NXU5dEtDWFls?=
 =?utf-8?B?ZmgxMHlWZFpxMGVPVjhqT09ubmFrQndpMXNXOVZES1ZOT2JHczBhVEZIMEJP?=
 =?utf-8?B?UiswZUU3Ui9mK0I0bUxMQk13Q0JZUk5EVWtoNEp5UCtCdzAvV211dlEyZ1p1?=
 =?utf-8?B?dzFtaDRrSHh5YnYrQTZrbWFLNjZobzlQZkF3UGt0OTZhN0pUNXVVc1hGdXBY?=
 =?utf-8?B?bUVQeHB6Y0Z4cjlLSTZlNE82NDByY0s4bFM1UFl1RGVlRG12YXAyd2MwZXJR?=
 =?utf-8?B?KzdkY3dXMWNka2swSktMSzFobmJjWTZadE53cEpKNUtnalFrK0dMbVpjVU9j?=
 =?utf-8?B?UDk4enJCaldZZmJkd0Y3R2JuelQ5OGtyYytvOCtCZTdHdHYreVBqK2ZzZE5M?=
 =?utf-8?B?RldFa3Z4TUJNS2lVaG80aVpvdTFRaEdtU1VBWmkwZjFhSHFqdGlIVFROYXNN?=
 =?utf-8?B?ZFllTTM3bFRQdkJmUGxSSk9WdmdjMnVIQ3NpazJiTGRQOXM5VHJIR3crNUdG?=
 =?utf-8?Q?1Br9vUUWWSFUuA6I6hcYiXR2U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f05236-42b2-40b9-669b-08db2e95f438
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 07:36:18.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ts0/N8gofOfaWb45qUInNFp7MkU+AVHVQngacij3UAjZaR0l/b6PS9a0VmljPMty/QEU0vYZObpeY3woo4NulQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/03/2023 19:52, Alex Elder wrote:
> In gsi_trans_pool_init_dma(), the total size of a pool of memory
> used for DMA transactions is calculated.  However the calculation is
> done incorrectly.
> 
> For 4KB pages, this total size is currently always more than one
> page, and as a result, the calculation produces a positive (though
> incorrect) total size.  The code still works in this case; we just
> end up with fewer DMA pool entries than we intended.
> 
> Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
> null pointer derereference in sg_alloc_append_table_from_pages(),
> descending from gsi_trans_pool_init_dma().  The cause of this was
> that a 16KB total size was going to be allocated, and with 16KB
> pages the order of that allocation is 0.  The total_size calculation
> yielded 0, which eventually led to the crash.
> 
> Correcting the total_size calculation fixes the problem.
> 
> Reported-by: <quic_bjorande@quicinc.com>
> Tested-by: <quic_bjorande@quicinc.com>
> Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
> index 0f52c068c46d6..ee6fb00b71eb6 100644
> --- a/drivers/net/ipa/gsi_trans.c
> +++ b/drivers/net/ipa/gsi_trans.c
> @@ -156,7 +156,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>  	 * gsi_trans_pool_exit_dma() can assume the total allocated
>  	 * size is exactly (count * size).
>  	 */
> -	total_size = get_order(total_size) << PAGE_SHIFT;
> +	total_size = PAGE_SIZE << get_order(total_size);
>  
>  	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
>  	if (!virt)

Thanks,
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
