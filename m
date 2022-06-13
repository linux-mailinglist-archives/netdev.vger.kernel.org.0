Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762AF549CBA
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245625AbiFMTDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbiFMTC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:02:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2054.outbound.protection.outlook.com [40.107.96.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C59100B09
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 09:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b75FBlTOZAyr2ajKueWq86dTXTZ9d0RibLTqEz22ENZ99yEC+veIO7kEVEAG3Arer1AV93ujKGjZVszAjlklMcXfoVG4R3M0k4rBY06CjleAxbOdhfzw3E/atrdfXWwnAnphEtbf9Fse++3ql+59kK82Qc3MSU04w/t/0uGUAPg2nj/BYkvuonq9REIk6enKDtLIp4PrHdCvpN/N2YiwnSbzM+SywxPw+7/g4EfK00zCTiJGnsMEgRcmqkt0NgIFkqjLL9tvQz6oFul2APzdKsvMWZxnRpqISuWodO4g3+5OkT6dgnoY41einXnD0B0cLsctOPYwtXOcQ//CMswpdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOTIoC0LmJelfs+8v5A/06X8BbBJdu2wsykPuhIIWJA=;
 b=PVe3tf5wFpgvRoWwbSXZ0cZajW/uz+4c/QhSWSN1HbAWbSLgdoJTjdASHwnbyVnIH+8gEtrizEubfs6sFKfCaEYDhSPMzdOZwZxnGOt7mNa5AIzQFIrrXyiivxC/6yYReXEn/9ToeBeyvHhIssLyimtZetKKemav335SeDeTupXrRLS3qDSZAaQTfGmC8hyohNqcm7Qa1fVypMIMgsuST1A8KPOlR4i+CWg5Ko/DsPBiWTDPT097bMU5ztIf+62EgvFBWcRY0SmNakxHMvtnATElcj78EPOtYscrfQ6PB2plaVurxQZ7LEaMfwBJ7dpVOlxNY/raeE2V7gn/7A9s5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOTIoC0LmJelfs+8v5A/06X8BbBJdu2wsykPuhIIWJA=;
 b=UQgNBcTyEf/adw4IVqFudaSohi3oW1TcyAuocl4jrvGEEp/kUvUv2wZSXgIaXxcm+HPmUssAsIkaq7kYDHM2xW6dycY4+w4ZPsM2n0SPeNMc5GywwK+xVbn8uVDhP/S9s4Q1fRCSzv4cwRZPeLUHiXNA8e/F3Kd4pBxfdqlMzDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB6663.namprd12.prod.outlook.com (2603:10b6:8:bb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.20; Mon, 13 Jun 2022 16:39:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5332.021; Mon, 13 Jun 2022
 16:39:50 +0000
Message-ID: <3067cab3-21b3-456a-37a5-f21a349f3b8e@amd.com>
Date:   Mon, 13 Jun 2022 11:39:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] amd-xgbe: Use platform_irq_count()
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     robh@kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        maz@kernel.org, netdev@vger.kernel.org
References: <20220609161457.69614-1-jean-philippe@linaro.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220609161457.69614-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:610:cc::33) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e077f648-8233-4597-a0b7-08da4d5b55a7
X-MS-TrafficTypeDiagnostic: DM4PR12MB6663:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB66635799EE043AB3B0D9F291ECAB9@DM4PR12MB6663.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dl28YCiORzT3OwQ7ZmHs64JTSUjRcLKEND/Lwjc9yRYx2poUMcGoDWTu6paR+XfPU7hiOwBYZewsxjvcLuwHPWkTA269uDhdpTURbOkB1ecMnFdjTqFHIgCwmeEXh9lv74IUmLzCCWp1hmdNL8gIU+JC+DwnnKp/zl5kyQti+FoAAQH+bqKk7213MQpXxYoujWkOP3MiO1nkGQXbG1fn/tb+pcdBr6l/iSqsRBtWo2gczJ3qH8HhNeU6r5TcV+27OoqCBJcaHnDy+v170+RNKVq6vY4Q97PKoo+loQabHnvU8J3WnRZU5lrF9aSzxdUYOCupZVjstmseQBgKYp6NZpwn3q8+jRpykA1CWnpHuPCjtGtGCwptYFq6Ds+whQbgd9+/UBrVcPoni5i3j77tiB/ZL0Y/vs9+NiPRV+W9qd3mcS4Q0qWpNAwbTy6RXA9OExp2K8q3Bj2Fc+8P25EBLlOsVK4GrhFbw2BGzn1uih18blRAtJFCbzH19mARy4l015nOwZgAjYv1gW/Y7nIZvJHnlJv99NiZCzoMETrl8i+gOPfRQBD9ez1hUp/uReuoLft55Saxgqq334iQR50fx77+cgCgLtFBNIIXh8mdd0XF7jiNbUViatybesK4cY13UzgZTF3U6OX6eeFn+/xN5IsIg2Sz7d4YazrInIrksqCQ4j5R94gF5u9i1jFq4nd/v5q20xz1C2z2JPY+C0nCsLcHqGt1qbCRtUH83kpJP8J/UVadSj4lYxx8VsAJyMD6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(31696002)(31686004)(53546011)(86362001)(4326008)(316002)(66946007)(66476007)(66556008)(8676002)(2906002)(8936002)(5660300002)(186003)(2616005)(6486002)(508600001)(83380400001)(36756003)(26005)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnFUNEdPK1lnV3pXY0MyK0txUktJNU45WlFsVWRXd0I1N29DdnhUb0Z4aEl3?=
 =?utf-8?B?aDdQQnNzeE1XS2ljTENSRUZoN0pPUXZWNWJCSjNOMks2cW0wOVRsaFg1WGNa?=
 =?utf-8?B?dCtiTHRUTWxId1FaUEVTRko0K2dQT3VzZU0rVXl6VXVIWGE4NHFTenBuZ0xM?=
 =?utf-8?B?SEc2RlVsbDduWG9KbE9wK0REMjR5SGF6N3Frbk5JUk5RTGZieTl3QkdXbjYz?=
 =?utf-8?B?QnJyRndtRHhYOUVOM3RxK01tRVpIMm1yREI2N1ozQmRld01wZ09KTTl6YzRM?=
 =?utf-8?B?dGpMOW9BTCtnSlNYVHh2cmNFU3Y2VkdKdnliOUh2Sy9KZTg3T04rQjJoZGhn?=
 =?utf-8?B?YjZIcE5BYVVacTVzSEUrVHBGOXJXYkp0WkY4ell2WjVUU2pqdkM0bDNyQ1Iy?=
 =?utf-8?B?NHFJR2NQYzBxcXI3dzdZSzF5MjdVeXVWMGoxWGRVRm9raHlKS3B0WU1UcVk0?=
 =?utf-8?B?UU1PTjh0TjU3OCtSNVkvUnVEZCs2Vkw4VUt3bWxFLyt4UWFTeHpJeG1LZDV0?=
 =?utf-8?B?c2M5ZlcxZ1pTbGxaczVqSkNpb0NYK2hTNXNNRldmNDloMVBSVU1Oc1k4QXFK?=
 =?utf-8?B?c0FEZzhHby83ejQ1T3h5RzhldGhkZHVoOXpiamZ4dDFaUUVQdTlrWGRFZkQ3?=
 =?utf-8?B?UGNLbDlwWE1FRXpIV1JXc2s2VmlWcnFrRFJlOER1byt5QWJBY2dLZ0ZBUzNi?=
 =?utf-8?B?ekJEVGs0Qk5XOXk2MGhSWUFvTEhnNEJhZ1hYOU5RaElYRzI2b0tHaE5kMjFv?=
 =?utf-8?B?VmJqM3RrRWhFeTVJSzVHdlFFOWdFMWQ2ekJteE1Bd2YybnB3WmV0RFM3OHRS?=
 =?utf-8?B?RFNkdCtWOER0L1lJQUVIMm9oakwreWdycFhzRnR5MWNFK0h2Mk5XRlNYMUJB?=
 =?utf-8?B?T2EwYnVXdlNmTUpkVmJzUW9sNXhXbGlveWVLVDdFQ2VRVEdleGZzYjd3eDlo?=
 =?utf-8?B?QmlnSkEyRTNEeUorRWJSTHB2Vm11dG1NdnBJdU5WQlNiSnRGZ1loZFhpY2NV?=
 =?utf-8?B?d1RTckJQaWhzTmVQaEFsRDhmdVFNSlJGRWdtYUsxcHZIYXlSTnJNK0xFY2dY?=
 =?utf-8?B?Smc0TVlYMzdtRXRSQ1E0MDBDam1vUG1FalJmLzZjS21ZTmhMelkwSjBGdHNj?=
 =?utf-8?B?SERhRExrQ05sRGpGbWdoaGxhWnNOVDFNdGhQU3g1T3RGbEt2RmNrcGhtK1Uv?=
 =?utf-8?B?WmZzMjF2L2F4WDhFNGJUbHNWbHgyZ1hBNGhUM2xWaEVJMFNBYjBNNGVVekp2?=
 =?utf-8?B?UmwvVDdlcXV5MjJSMjlzOHJ0bzJPdUtaYWEramM3b0ZYNmR5SUVSMkE5TmJI?=
 =?utf-8?B?TkNjSFVYS01ENGlMbWY0OGNvcE1ZaEFrMk9CTERqTDZtU2JkaVFEcUJDNzdk?=
 =?utf-8?B?T2pwWFJqQmZwZER0V2xHQjhDemVVMklFR0NnSnhMV3cyOXp0b2NpdTE3dmNS?=
 =?utf-8?B?dmprR2UvakQ3ZndhS2hFcEhyTndRQk4va1UxeEltcjR1Z0ltTUVBekdWRmht?=
 =?utf-8?B?MUZRdk1FOGp6aUhoNEJ1VDBjVXlhMVhjcGRpMFFaV29lY2NMc0Voc3JFY09x?=
 =?utf-8?B?d2xLNko1RDdHZjBrVmNqN1dISDdrUk5zSklRbXg4Unh3bU5FWDhhNFFIanNB?=
 =?utf-8?B?RENWeUdWa0YwaXhwWnhFTlpFc1oyY1VURWJOUW1hK0cvNVVLTGFsNGROdDBa?=
 =?utf-8?B?bWJZMHQ3ZnlROUJtMzAwTHlKSkExdERZazllQ2ljNitUUW1wSGN6TldjQ2h5?=
 =?utf-8?B?U1creVQxV1poaEZyelBPNGgxQkZwRStDTmZBQ1N2S3VCNnRZMHBOa21TQXJr?=
 =?utf-8?B?Q3JQKzBoc1ZZb0NCMmZucFduUU5JS1ZDUnVvVHhzaStBUWhiMDlrenFxMXhU?=
 =?utf-8?B?V2xUb1VLWlR4dmNhY3NpTTZTaWt5MytrYXBhVzhITEs4RncvTUZvR01wZEVB?=
 =?utf-8?B?NEdlV3JESElwNllqQmNocTFFbzJnc3gzeXhuSEtqS25BSG1pYk4yYnZtbGNP?=
 =?utf-8?B?TjhVaXczOVdlbDc4dkFZZDNsUUM1SlVhY1BkOWNvMGlBcDgyR2ViWDJZblNs?=
 =?utf-8?B?L2Vvbi82VWtRc2FvR3BJQ0hmMDUwMGFYUS8zOFRINHhsWnExWW1OSEVlbllw?=
 =?utf-8?B?RjVaVUtmcGppODcyV2dLMDdBclhUOG9Jd3FCb1B2SC9RTkZybzdUNjlEUGRt?=
 =?utf-8?B?bUx0MlVyMkJvYjVjM25TbnlpL09KRWQvcnVoeWVEWjI3c3JwT0R0b1FpUkpK?=
 =?utf-8?B?eGNEZFJ0MXZmQkpIT1ZCMldMOEdQajNPUnZ2QnZOQUhwL01pMXp0OENUU2p5?=
 =?utf-8?B?Z2pJTHVKd2k0RFhWMm92U2pFYnJES2krZFovQ01CYjZzVWN1Q1E0Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e077f648-8233-4597-a0b7-08da4d5b55a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 16:39:50.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPBzla4MeLGjdsEh88bgocHiQZw8tFIUfxvckphnGBWBJ5xah6GijAZPVbLhaZmM76Jijf7IdhQkkBi5OtQ4wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6663
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/22 11:14, Jean-Philippe Brucker wrote:
> The AMD XGbE driver currently counts the number of interrupts assigned
> to the device by inspecting the pdev->resource array. Since commit
> a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
> core") removed IRQs from this array, the driver now attempts to get all
> interrupts from 1 to -1U and gives up probing once it reaches an invalid
> interrupt index.
> 
> Obtain the number of IRQs with platform_irq_count() instead.
> 
> Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

It looks like the CCP driver does a similar loop looking for IRQ resources 
(sp_get_irqs() in drivers/crypto/ccp/sp-platform.c), have you looked at 
fixing that driver, too? I can submit a patch if you hadn't planned on it.

Thanks,
Tom

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-platform.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> index 4ebd2410185a..4d790a89fe77 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
> @@ -338,7 +338,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
>   		 *   the PHY resources listed last
>   		 */
>   		phy_memnum = xgbe_resource_count(pdev, IORESOURCE_MEM) - 3;
> -		phy_irqnum = xgbe_resource_count(pdev, IORESOURCE_IRQ) - 1;
> +		phy_irqnum = platform_irq_count(pdev) - 1;
>   		dma_irqnum = 1;
>   		dma_irqend = phy_irqnum;
>   	} else {
> @@ -348,7 +348,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
>   		phy_memnum = 0;
>   		phy_irqnum = 0;
>   		dma_irqnum = 1;
> -		dma_irqend = xgbe_resource_count(pdev, IORESOURCE_IRQ);
> +		dma_irqend = platform_irq_count(pdev);
>   	}
>   
>   	/* Obtain the mmio areas for the device */
