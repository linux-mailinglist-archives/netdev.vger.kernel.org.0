Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC5D38CB93
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhEURKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:10:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26664 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238018AbhEURKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:10:38 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LH6W7R010557;
        Fri, 21 May 2021 17:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SyrfK1YTvGTEPr0szShAUS/zYkqv2BFmG5Y6O1I13xk=;
 b=iNq3Cc2da+VSDX85d1sW3K2DdfCuK2kSVmgbuNpusDGAHnHWGFTonO8BUJXQVAckGXLn
 UYzCccuDzzuo/YkysLNH+x2avTzcDiibpMb3+nkWDlFDBDz5W9NBxjxUnn8aAaX6iJja
 REDxDBtpuc3qBOn3IB39gjUO4UBLFypjMuefgkP+C0FpPN5DM1+MYUisNVCDidWw8d05
 VcaV9caPvTFOddXCqeoLrYSri7HFD6FIuDUzCAuj78u/wI3ZcEUDMc7jK/6JP/HxYulW
 ON4VdbchqGw/s7O8IjibfYPPp/g3FBHkgS21DL36Za8yLUAtdaWCcIGZLb72k/tBeRyY FA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4u8ryu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:08:57 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LH7ksL101012;
        Fri, 21 May 2021 17:08:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3020.oracle.com with ESMTP id 38n492xy2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtoMA6PO8vRqXVgoUlK2BbowyEmHikHZwsO2wQGD4cFSLh9XyN04xS3yAkwD48Xyl1zFDHnua76vbI3aQm0KPaFoq5s1k/9aLbXMEYmeA9w7aiGmvkqzgLZnvm8ItfEO6y1+lhq9tnRzJYeO/C/oDE77EWZz3DgLxtT9QwTqMFWbxbTipbyojkXxerrSzYc5DvbrCFfrD6gmHnYYWhxTNBcWog64sYRXXILAXber2r71Q0ZXHSb9q1eNrbJSyz+gt0O8jRV9AsGzex6J00fJTYQmEZ9ZrhiK4B6oZ1JF/7OdFLK4bwvvFkHT0WkZP4ugtbp4Gd2yk7xlIcy2X1SEqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyrfK1YTvGTEPr0szShAUS/zYkqv2BFmG5Y6O1I13xk=;
 b=S3ZFT+iVlSCUDYucrst1Vt6ZqAjTXu2igRHun273vM5ayj/lWpSXCUzpBYpjFRC8pyqzxiIO+3Qz3RMBrUum/mt03ruNScTX5HNUsYVMI0DVs4HShQbz58+z2JsEvi5cz7eh+azfkJ19elDiK5LKGFm1C1okyqkGiUpEmgISnemuEXSgvlpDKc2tUzJzbi5XXDdP6t6aX3hOKg6B1mRJfv+dT7t4gz3paTNcgfykObp85QlwcJA99cwJHsctxeYsXuNwY6nBPqAqw1tQXiVjV7EOsJNE/i+FrfNGYTwQx/mtF0unePycrGsXemchnzxPIzaPIDYfJD2xegNnjf2z4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyrfK1YTvGTEPr0szShAUS/zYkqv2BFmG5Y6O1I13xk=;
 b=Nq51R1Z9dD+SrysJ8zGB6hVNzDVxjpN1UdTVjHn1K5xLb1JpmqHYnzpqnYtdQ3KlYlCOorSXui0U2jMFQkLHgrGTY3kqp//yhfVLnr2azHTdo/svmRngGelI3FI1ZZIFLQBuv9ivYtnYCvXMCUuz61a67HqKuJN0kJWHD1f0dW0=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 21 May
 2021 17:08:54 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 17:08:54 +0000
Subject: Re: [RFC PATCH v5 02/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and
 NVMF_REQUIRED_OPTS definitions
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-3-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <cd2eee96-6b9f-738d-32f4-9a4b1d2c7363@oracle.com>
Date:   Fri, 21 May 2021 12:08:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-3-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0401CA0017.namprd04.prod.outlook.com
 (2603:10b6:803:21::27) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0401CA0017.namprd04.prod.outlook.com (2603:10b6:803:21::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Fri, 21 May 2021 17:08:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1667088b-3b67-4f6f-abd7-08d91c7b1cf1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795CA9E7EB411FFEBBAEE77E6299@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cT7VjqkTNy3LprKJpcSHw7V8JgQPgV8cNgwkzlf4eFumJUEkcLCqIziW/iw52Y/TI9E+v25F59U+Am2ww7rn54GseBBRcQ6mdERNIDKhTNaE7kO6Ju47vjJU4aptgv1mZTSq8aBdbkcvyY7IGTtmORSa7ltBmZedHBmoYtrdGzph4CWYszQ6kCPryltZf91A0HJOBF423zmPZHY9OmgTxvY+V6xTPzcOhAfpH/QcVbTB+zYZUc977CwyJuUfw7A1pce22a8N6UKJCFuyu6WbZVMg1cfO/5a+5k2YysbbTd/ybVHDiEvSaROtw6aGUxQr5adwM75gJGVObhrO0Igb3FYzxQXFF1RfGP21Mz1uTXTWYbfT5W1g92Zp/8ucn3i403Edwt3J5KNyOhJNYHanepO+dXFgJt64SJrsyIVJ671Hssu4maZFOCZR6+e0RAKzzq/eAO5zI3kUayKEnW5tv31goMUqyFm+fLghV5HrNY8F8+EFc9D10IUZoYAnc8hy1f2XS6y7UNko5t5iONTpGmJTFHu20x+qVdz4aAp6WctveRmcV1MPPcd3VdVxQOIcHCS1ZDjfDU5lJXM9fL0uL0YLa2xUix2c1iwdnNHzXsBw8EC6vR1DoOrD9F5gBxdBRX8KBwRkJ9atPXKUMK+3LiwU52C8RStubNGxPaw+RGxhe+sYRcKpW4GHJ7JXnuz4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(346002)(376002)(6486002)(956004)(31696002)(7416002)(16576012)(86362001)(83380400001)(2906002)(316002)(8676002)(5660300002)(2616005)(36916002)(26005)(16526019)(53546011)(36756003)(8936002)(38100700002)(44832011)(31686004)(478600001)(66476007)(4326008)(66556008)(186003)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmJHOXFGcHNPMExSb0FXeG8wdGZCaHpiRGx5SGN2a2FZeUtEbWhYY2VEZFpJ?=
 =?utf-8?B?amxvVFZiRTMycEtXS1VsdTJ4akxzK2kreTA4QXkvQVVFWHJ2dWtDL3VoWWhx?=
 =?utf-8?B?QzZrdmk0ZTY1RDNadFNzZ1d4SEluK25NZXlDK2tOMmM5dGR6cWl1Q2dYYzBm?=
 =?utf-8?B?Nk9CeDZHMjRlY1l0OVBmM0xoUDFYR29TMndvaTVBdmthUTEvRUtjUDVSTXRD?=
 =?utf-8?B?ZVJFY1dBM0tQTjI4dnZIbGZUMXVKc2Y5S1pUY1RMT1BjSUFrQjJycFRSQTVP?=
 =?utf-8?B?OGRNVFZqQTNYbXVJODhWM3VNT3NiMjhEWUFHTkh5c3lnbDA4V0JVTHpFaWs2?=
 =?utf-8?B?M1FzdGU3cEsrTGN2U0toNzFJZTBWTXdVNnl3ODRvZ0dHOHVDWlF6dWpaZjg4?=
 =?utf-8?B?Snl4N3o1cFkwekZoeWRRZ01pR3ZwZ0Z5WnpLL24xaVB3bXBhWTJXNjR1a0NS?=
 =?utf-8?B?UzdEQnBFZmtQd2RnQ2xpS2VWWG54d3Nva3BVeXQ3a2FNb3A4aWNnSDRVVTNu?=
 =?utf-8?B?UUtSUGJQcjN0VGJBQUZxcjhiMzJQQlNBYmNJVSt3Z09YekhGZXFnSGEvMkQy?=
 =?utf-8?B?dTFKU1orbEljbEwzcDZYUjhiTmJYVTBrS0VSSG13ZVF0bW5qNkptTmo4WmNa?=
 =?utf-8?B?WmZSQVpGSmFrVUhPQlc2Z0laVlp0S1hTOUlrQzFaNGk5bUt3b3YyelVDMklt?=
 =?utf-8?B?RTU0ejZNUFRtbnQ5WGVtV1hzRTdrR0w0ZFRQTUVLdEZaUzUxbFgvMTBNeUpF?=
 =?utf-8?B?YWs4NVhUWGZSUHE1SWxFQ09SMTJWMjIydUNTV0FZbzBtRFdWRWFKQWtxaktq?=
 =?utf-8?B?THdWQUIzeHRJQnNYdTk5U0hVWmx0K0tnNitNSjcyNjJNLytHMkZLRzFQZW1U?=
 =?utf-8?B?UUtuUGxVemsrVDI0UzRLazA1ZmdsQVdyMzRXVmMxd2dreTVNQmM5UmpGQjdr?=
 =?utf-8?B?RTVLdEl3THFCaFpVRW9TU3V6QlJIdm1kYXlGMG5YRllqVmMrMC9wallMcDJV?=
 =?utf-8?B?b1JNRG54MGFXR3NVb2xWVWdVYmQ0elR3ZCtFWFVyZnpZTG4wSGd0L25hNjhX?=
 =?utf-8?B?K0pvQkIzYjlMcS9aN0ZiMWMvY3owWTdmMXFwU3R5enRpZ2NJbTVjdnZYOFFk?=
 =?utf-8?B?UW9KaWtGUkswcG5LTmpmV1dxQm1DL2lOVk53UjZXWThIaDFxb3pSUzVHTEJJ?=
 =?utf-8?B?RGNFNnhkbktHcUlqTGI1SWNWelhlYnlnL1Qxb3A2WFk5NDFKdW92VkZ0VU9r?=
 =?utf-8?B?V3J1Q3NKVDJxL3NoQzFxMUN2bEMrenZ2OGJhbjluYVFhODdPZlBBRGQvbG1k?=
 =?utf-8?B?SGxxam56Qjlwa0gwODhBVldDblZkVkJJSU9vTTgvSm9IQ29kdEVMeFdjWWJE?=
 =?utf-8?B?RVZFODF4Z1doZC9oZEQ3bkZmdE5WUk1nUkRrdnZDQ1UrcitpR0xlZExLT3BR?=
 =?utf-8?B?MnVNMTVacjlRb2FzSFo2QlZDUUVFTVFkK0daV01jQW9wQzBHcVVKa0R6cDR0?=
 =?utf-8?B?eXRMWFdlUDltMVYwTUJlRFZOMEtvMUxUQ3lRVkgwWTVWdlRrTW5EaHhlS0JL?=
 =?utf-8?B?Tkc4cmZTVHV3WmthWVErVVdsc1ZqTzlCSnFzUGhOeW5Qc2J0ckZzQ25LRXor?=
 =?utf-8?B?N1VYMTdWVGlwcnl6VjNmYzJJSURkUjZYd2tRaW13OGdWZHBzWmlva2RQR0ti?=
 =?utf-8?B?SkJJVTlmU2F2Sk1ZeU9oTXovckJaTkI5WGFLdm96dXRDb2tqMGFDdzJ6RGw4?=
 =?utf-8?Q?HBIYGH310TRLtGz8DvoBDW7Yi7hywt3yKWm5kGN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1667088b-3b67-4f6f-abd7-08d91c7b1cf1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:08:54.3300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiYquL9H0yQrBWVQdtz7+hRF3UtpByqWJV8X00dW4E0DbpB4qFm9+oGBDLwXm5sqdW932qPKxmbwrJOKUOis7KypAmG/yRDtxNe+0K2VVwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210090
X-Proofpoint-GUID: jyFjZQ6RYU5_R1peMI_zn86MsQr3Wopy
X-Proofpoint-ORIG-GUID: jyFjZQ6RYU5_R1peMI_zn86MsQr3Wopy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
> to header file, so it can be used by the different HW devices.
> 
> NVMeTCP offload devices might have different limitations of the
> allowed options, for example, a device that does not support all the
> queue types. With tcp and rdma, only the nvme-tcp and nvme-rdma layers
> handle those attributes and the HW devices do not create any limitations
> for the allowed options.
> 
> An alternative design could be to add separate fields in nvme_tcp_ofld_ops
> such as max_hw_sectors and max_segments that we already have in this
> series.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/fabrics.c | 7 -------
>   drivers/nvme/host/fabrics.h | 7 +++++++
>   2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
> index a2bb7fc63a73..e1e05aa2fada 100644
> --- a/drivers/nvme/host/fabrics.c
> +++ b/drivers/nvme/host/fabrics.c
> @@ -942,13 +942,6 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
>   }
>   EXPORT_SYMBOL_GPL(nvmf_free_options);
>   
> -#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> -#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
> -				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> -				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
> -				 NVMF_OPT_DISABLE_SQFLOW |\
> -				 NVMF_OPT_FAIL_FAST_TMO)
> -
>   static struct nvme_ctrl *
>   nvmf_create_ctrl(struct device *dev, const char *buf)
>   {
> diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
> index d7f7974dc208..ce7fe3a842b1 100644
> --- a/drivers/nvme/host/fabrics.h
> +++ b/drivers/nvme/host/fabrics.h
> @@ -68,6 +68,13 @@ enum {
>   	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
>   };
>   
> +#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> +#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
> +				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> +				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
> +				 NVMF_OPT_DISABLE_SQFLOW |\
> +				 NVMF_OPT_FAIL_FAST_TMO)
> +
>   /**
>    * struct nvmf_ctrl_options - Used to hold the options specified
>    *			      with the parsing opts enum.
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
