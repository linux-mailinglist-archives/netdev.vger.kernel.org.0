Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887D1478DD0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhLQOaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:30:14 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:26465
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236899AbhLQOaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:30:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auH7yoDnhoxBQ/dmgsamW+/wjXO9Y3QfJbdM74mZJnqgRuNDzjPu/lNbyUsccQh/QapFgp9yIC2ToqFDt14ekaC3iNooqHfc41tL8me36JXLbXbB1dcoAe7VA0p6TI2EuyZF0C8TSwEverlxKswGaX8V1IKccW+UVBvOWeT+65LZEN3RC+Cul3e/pi0g2bY+Thels7/+w8BehmYi5SRzcFAxg4rQtid4bS6/hKDVQagHQ705msSdd6FeXDYkOdjqO1KBr+FpM46yLqEEv3fY6DlUQ/80tTe1pJbX/GsfdEo+qmIjI16N+MtKQqrUFcQTT1UMshEzmp9lm5A6HwGJ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ee59TcWm999VlmI1fs2ftoTaHI2mcmnRgUF+wWuwo08=;
 b=DePQlmQs6EnjNHysGSnNkT/jcJvbYW8f1aueK9qeytMk6myf3JuNuYA/WZkY62kuF56lq2dkzGaVojR+xsy8PTQq28xAGY5ISwmwisSCtNoBK1CXpSQwqscfAT8Lq1nVhZK/1FbjOKvH7ORrvLSRI0fzFIM093j9OuuYUiZVlYY7uX4epNIim5s4zvj/yt/OuljYVgOjLJxNglryrHbenO+xB3cP9ECz1M38HUWIshznv0HQvInM5Zr/5hRGaae3UiVDIxbuungj8vgIKL+fCBrPfoHtEQjp2zrhfqxOdrCJLi0dxzGvCn5CljwtwO4bOOTE2cXi3Fe0bcav7JLhAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ee59TcWm999VlmI1fs2ftoTaHI2mcmnRgUF+wWuwo08=;
 b=2/maikKxZM2kCNmzRlAv4UPlYHlRa7UwEdwGzUqqbqCqXf1Qh80sndGYpTdtXqHqut4R0gNPQTKQlkZqgYbINCc9la2VN3DQEGsPxbMrGgBXKH5Hs7gWX8bNRfAjjvsz+wSJlWeUnFpF6WDN9cd7bpBy+bgaRcZd6/qSz8xGXSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 14:30:12 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 14:30:12 +0000
Subject: Re: [PATCH net-next 3/3] net: amd-xgbe: Disable the CDR workaround
 path for Yellow Carp Devices
To:     Raju Rangoju <rrangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com, Raju.Rangoju@amd.com
References: <20211217111557.1099919-1-rrangoju@amd.com>
 <20211217111557.1099919-4-rrangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <85ffbb22-c808-b2f6-980e-4ee6a294ed98@amd.com>
Date:   Fri, 17 Dec 2021 08:30:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211217111557.1099919-4-rrangoju@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::27) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::27) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 14:30:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d810cac2-15ae-4b1b-82ad-08d9c169bc14
X-MS-TrafficTypeDiagnostic: DM4PR12MB5342:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53427E9326B258FAB8891661EC789@DM4PR12MB5342.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drn8GgcGyoXJZmsrFOLWWi7pmIXluv731ys5VcladbtpHky7djT1TI58BMM99BwVIAKmyhNSJc6KSlHaXviGLILL3xJjeRhLGhumojS1rrBdBA0q6FsTnkE7Ffcp/dl0AO3DIPEN774+EsoKWwxOeah922FHsceFritEwTJZPOVd2S7nwSfoVzwspIuVzas8H3Jx9E8i7XcP59IFGGqH98O1rsHLrCvz10flVfW3656A0tqSGowuESb9TGeG5U+NpupMWuSqyrL2JgJzXcZPhvDs4uUayNxQrFCkuN5/fM7PHLRFzfPlNlbZP9JAVbldswn1nC0Vgi0P2/RKgX1xotToOMhYo8Q2dWmVNJZM1dq6v6+EgmfcL5/boWtt290SFCtdzf0BmrqMv9pHVCaaVfFJFtiC0Q582uq/pCpPvzLNFXlBga3ZN3+FFrFY122mokS3rBB2EmKT9lRHXsEkvnCM7E8F7PAGUVJxO+8HohIvU/GNYqvEDAK51FHA6iNbVcpfgo0VqmtX9LZXClCI8SgSfsjWR1vq6/amd8RyIvjNRU7M9yN9Zxyo827qwdAMCG+cLxrp7hBNQeAhhFLc7aHMAhsz90AVChjSXlDJktkFutJZt6ny5z4vTgrNP5+n+TAmSuvRfLscs46u5Oa4XV3YCGF4PwvXr7xthsUYt1qC3Y/bt5yr9xLhOWIGC7Wra0o6QlREpEvO0TuwYkRtT83cd1KRfREe2AGxhkjDZR8Ee/2hFhtKGyQ2oSNIDjfe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(38100700002)(2906002)(66556008)(186003)(316002)(31696002)(26005)(36756003)(6512007)(83380400001)(5660300002)(31686004)(86362001)(6486002)(4326008)(8676002)(6506007)(956004)(8936002)(66946007)(53546011)(508600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ync4ZTRoTG0xeW4wSGUvNDVkNCtQcllIbWNWcFQ2eDh3NDc5aTY5d2pIbXVi?=
 =?utf-8?B?T3BPaGYvWUQvakJoK1dNYWNwZURuNFNNKzFZVExjTGczSzZCalVyK1NZbGlp?=
 =?utf-8?B?c1A4VlVDblRpMlcxbjJQRXpDNThOK2IzM2FTdXo1YXVWeDFGZ3Z0UkdEQ2dN?=
 =?utf-8?B?YkNWeTFVNHFtMDlwM0FGdTYyU3JQTmpQMG9rZEthMEswQXRZZlBkWVBXZ0FJ?=
 =?utf-8?B?dzkzcFpZS3M3MGdtK0c5Y2xCd3UzRFhxdTZCQU85MkJzYnZBTzM0YkZCZWNR?=
 =?utf-8?B?WVFVL1pOSnRjdzFKb3FnYkRlK0FaN0EzSjVRc2YzdFU1UldVWlphYy9hUHNi?=
 =?utf-8?B?eGpGK2g5U0JramZQVHcwREUxNDFxcEd0VDBHelZKTyt4cEJmSFJrYi82aCtl?=
 =?utf-8?B?OEhYRlVRYXRZRnREejJabDRCL0FiNnZmWHlXeHRKWXNPcFRCQVpHeHpQUkJG?=
 =?utf-8?B?dXE4TTQySGpFNVZhY1JZdVA3WXBib0VGZkZyMlUxWExkdFBEZ0REdzB0UzdS?=
 =?utf-8?B?RjY4LzY0V0F4NHZUZ0tMTW5EM2orMzF2TUp5UUo4d3ZDTzVBZTNhYm1qeHoz?=
 =?utf-8?B?RXJxNnVkZlg0TnRyVHQrbThFVVFOSE5pSWFjOTVLNjE0dnhBUm5oTXEwOHhx?=
 =?utf-8?B?T1JTQTV2aFJsWlhqSXpxU2ZqK3lUM3pFazVIQTRzYUdaUy91YUl0T0IxUGdK?=
 =?utf-8?B?UjdTQzBDZWRPY3QxZ3REWmlCYkh6UUpCTURUNk5FTzhuWmtWdDAzeHlUSXZ5?=
 =?utf-8?B?QUw3SnlLeHc2T1BmR2hMb0RUMmVHdFhBaVprTnJxc01LaFNxZlN1WDZmVmRt?=
 =?utf-8?B?UDVaRFA0R2pqdytXUlA0eVU5cUVFbnA4T0Z0R0lPMHZFTGNKK3N3WVU2cVI3?=
 =?utf-8?B?QzV4N3FxS2ZyNk5kTUVON0prS3ZhQmI1RGhmeFhVVkxKR1Vqa2ZhTDhlTWZN?=
 =?utf-8?B?ZW5IOTJXUHlxWVJyUkdGc0VzcE1tNGdQUGIzVm9sZkNXT0dOWjd2Sjh3b3VQ?=
 =?utf-8?B?Y29hWEdkZnhZWjc3OEhucnlYanRBOFdybjREL3lGR1NkeVprZ3c2K0hySFhh?=
 =?utf-8?B?cnNKZUhrL1BtNzU0end0Y29jWTcycnlZNFZLRUlTNGtFS25HWFFWTk5vbHJN?=
 =?utf-8?B?dFc3OXl1eEhjd2JWUS9udjQ2TzBoUFk1NTExU1YraVdqKy83NSszTUhYWHpt?=
 =?utf-8?B?dmwzeDhHSVpwa3BRcDY5SnRpTGdwcjVHSU1vWVZ2TUljVkYzRWllUzJvUVpk?=
 =?utf-8?B?WmtnNy9qa0tsVFZEWUpXTy9mZEZHbGE0UlAvR3dJQWloVXZSNm1kdDYwQVl2?=
 =?utf-8?B?eXdhYTRZcDNqWFBadzJYd1lVaEhxRlNiTzA0WEFFZEpvQ1l6OTBXaXNXZ0JX?=
 =?utf-8?B?djNpaFhtRFoxS01zZ2sxWmZsR2RKZk1wbzlCbHZocFJuTFdod1JaaWJPWURj?=
 =?utf-8?B?OXdlUjZnRjRKKzdLVkhIVHJhSjgxOFZ1dkVaTXZlOUNRbjhkMlBBK3RVSmNY?=
 =?utf-8?B?TUU4S0xvbkZEaU5ybDlWVmkyQ3d1bGZqQ3dvTHAzNzVUaWF0UTZmODlMUkI4?=
 =?utf-8?B?REtmYnFyL3cxOG45Y2FIcFJFcHRCMjdwaWVtNXgyVnFFVmxOWUtTWmdtVTVP?=
 =?utf-8?B?a1o1aUE3Tm13azlOZ1JYTmVOR2FZRDVQK1hiY2lnZTRROVNaWFJjVW5xcE5T?=
 =?utf-8?B?UnBkY1RFeEpLMDlWdm43YWl4b2VlYlNWQVV3emRXTVY4K3ptY1pOVHYzaVVv?=
 =?utf-8?B?dU1kYTFWSWloZ1ZWdXpla1JiZnNMUlBidjhPMDE2TUhaTGorbTJjRjZqZWJY?=
 =?utf-8?B?em1udm40enNIeGh2RjhzMDdkcUhBZm04TWRWSmFCUjJqV0E1aTU1U3pwdWFT?=
 =?utf-8?B?bEpKY1JyaHk0OHlGSkR4Y09PT0E0bUtpVlVFQ2t6MFcvUElRRG5vMjBTbFF3?=
 =?utf-8?B?ZTliRU9yZG4rRThoMHRvOTBQNnJzelAwT25yS2RRd01GU0FGNkZHbG44RXZ4?=
 =?utf-8?B?dm1xY2FSN1NVVFNoSk1Ga1NIRWxUZjUyaElTdHNaS1FCcjU5TlRnVkU1Vkh6?=
 =?utf-8?B?Tkh2S3piUTlmdnYzMlgreGlaaTBwSUpRRk5vU1VNSXhXMEZpTmFjSy9xaERq?=
 =?utf-8?B?UGNBaDZhWnRrU20xeWNRZEdiYW04UlBadXA2NVpPY09VWnpiVDNBaEZZWXpQ?=
 =?utf-8?Q?Hcu27wYAgk1ojqYvY2gy5i8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d810cac2-15ae-4b1b-82ad-08d9c169bc14
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:30:12.2824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTtau4uxBfHzAaPeRNLmQH74S4ynJ/Md2ZCk91WkL+jQQ35Mv3jwUMy9nk7mC68qOi+kd41DLkIEgkzz1ng/CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 5:15 AM, Raju Rangoju wrote:
> From: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> Yellow Carp Ethernet devices do not require
> Autonegotiation CDR workaround, hence disable the same.
> 
> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> index 39e606c4d653..50ffaf30f3c7 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> @@ -281,6 +281,8 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   		} else if (rdev->device == 0x14b5) {
>   			pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
>   			pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;

Just add a blank line in between here so that the comment stands out a bit 
more.

Thanks,
Tom

> +			/* Yellow Carp devices do not need cdr workaround */
> +			pdata->vdata->an_cdr_workaround = 0;
>   		}
>   	} else {
>   		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
> @@ -464,7 +466,7 @@ static int __maybe_unused xgbe_pci_resume(struct device *dev)
>   	return ret;
>   }
>   
> -static const struct xgbe_version_data xgbe_v2a = {
> +static struct xgbe_version_data xgbe_v2a = {
>   	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
>   	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
>   	.mmc_64bit			= 1,
> @@ -479,7 +481,7 @@ static const struct xgbe_version_data xgbe_v2a = {
>   	.an_cdr_workaround		= 1,
>   };
>   
> -static const struct xgbe_version_data xgbe_v2b = {
> +static struct xgbe_version_data xgbe_v2b = {
>   	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
>   	.xpcs_access			= XGBE_XPCS_ACCESS_V2,
>   	.mmc_64bit			= 1,
> 
