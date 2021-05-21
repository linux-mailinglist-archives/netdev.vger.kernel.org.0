Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC46638CD88
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhEUSiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:38:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59170 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232153AbhEUSiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:38:14 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LIZx2l022129;
        Fri, 21 May 2021 18:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5QUKedEDV9brlzK9MEOG6Bv8ZcfBjd89Ap52BrOBaRM=;
 b=b/p0tWCH+9vQZxFvntQIktFGdXkQ952//nG2VcwgRfVktNa9o2R/So5oSgvssOJh49iG
 E1fbJIihjRiQamV5E2QOezkElDvIJrFO1u1t7yzSsziQ37jg82o/3G+f0VW9HD4Fv/Ar
 bc2SYt7X5H0jrrHhu7kO/UCz7ckvc70NdZzVij/GXZ6jjnb8zQmcU2T4/Wn2XVnuT7Ak
 TslHdndsyrApX8Ou1af4NHDCC8J3RqOmnBoFQGu3wphQtMCqe6jWWVGVVYTRkvrygA4n
 MrpOx2lpJ6PyFq1bk1INQreSJLxgoFVYO907M93qWAXJMlLhSyiemgMAYbl0NxODsoqy IA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4uks0vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:36:38 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LIab3f002260;
        Fri, 21 May 2021 18:36:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3030.oracle.com with ESMTP id 38megntnyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCZxKvmrx+Gie3JYerHypqcmW11134x+KMjgQT6svt8FzaSSbz4TFIjNZ+whx3+LfPFiGrID4e4Xc0uAxlH6VUfV06GqnkZ+6ISy1Kd2dvT3eQC2ode8FLxGC/g4uuh7XF8S8iaw5yN7Uq927EUSaDOV6de3j6Wi+KeNKq1H/mp2Slqvd9wmInJyLvS9CL3t9ewOO9O+dtHACfIiustKmL+iviS42EXV0tz93GdWW+wbAPqhqtKUNoY+SL5GWRUdO41SnCOCtbubvUKxwwvShNOZwss0UM3WZ5UkhuKpoYjNuWPN+kLExAIjeJB20tX+lo3bIZlmKAKhKRm5ell/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QUKedEDV9brlzK9MEOG6Bv8ZcfBjd89Ap52BrOBaRM=;
 b=KIaVfyQ63m7LiVy4D/GBZVwfkEr+GqbeswDT9bhDPIJEzlnSG0wNBfycdMssySSnxZctPxuv4FALAptrCM8BlZ5PTTuk1RmU1MTqWgqxKq7e7s7eJlwR0JwBiPSvgBvIYl8IW+5msageckjj6XBt1NQ5R2fbqGezLNWbTOqGUiBmyzNAopwIjM6LrEVFEdJrpASbM/CIxa79IEIz+Y3NBmBgbR+XEuLD48u3tjzJDjBbPhbDGwdVoowzUOk2xkKh6eNQH7AIw1D18OI1Z57WHngmnDvXgUSZDHyh7CNiuw09Nh5IsvTU2kRTtW9U9LFwM7tSDm1UVD3TyKmrU27Xcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QUKedEDV9brlzK9MEOG6Bv8ZcfBjd89Ap52BrOBaRM=;
 b=SFhf6zYbWvgq5dUtV80/I/CD1VKhN4V4iDs2dvfJdzgrnCFoccba7chILStWv+p2K29eQS2pLr7UwuG4ev+460G+7Uhs3/8LpSUi2ZYtOqu8NgVGK6HaqutE5dZ09PJiPp2i6uQ0DpebQ1decScgyTsPX/UiaZelKvCbRx0n1p4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 18:36:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 18:36:30 +0000
Subject: Re: [RFC PATCH v5 08/27] nvme-tcp-offload: Add Timeout and ASYNC
 Support
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-9-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <5daf1d33-300b-6aad-3b28-6c4030d4c674@oracle.com>
Date:   Fri, 21 May 2021 13:36:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-9-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0201CA0027.namprd02.prod.outlook.com
 (2603:10b6:803:2e::13) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0201CA0027.namprd02.prod.outlook.com (2603:10b6:803:2e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 18:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e7d7ec6-e098-45dc-0390-08d91c8759cb
X-MS-TrafficTypeDiagnostic: SA2PR10MB4489:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4489BDD392075F5C99A3E02CE6299@SA2PR10MB4489.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:215;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlKYPiZ15+mWbAi9GsFIb+UOlosfKJGPTBNIvGTRZuw7oPmWGDcRxXn4yu6mJq8GA1ZAHOQ7R1e0S5ZK9EXK8hNJbLfG98sEWAqLVZYinn2aDrICOp+jw7DE4E+arZSdiMLx7kUpX3CeRCGqtlk4te3XPDqD+vk9mLeYFLdH8Jw/br7JQgf/QyGN/ySE9DN9YrYmOrS/Rwv1q1QpWMYSEIzLrWZc/RddLS1oRuzJbXUiDyk0ACrHZmXbkL98wY7Ep+XKOOzVBPpH3tmopteCianuHdDxvbWVFYwS2kpGatD9gEyKU8qvLQClEZRW88666hKveJAYtjWqmN4oJT2RW1pAp01ND6jF+eQ1F14TQO0riJGm25oduCv08YOOV+FcVHtq0LveE86Qw9RYStt1pyxlslyl9/7AzWUXTHKJRzUJ9vz0M3rdzBmvGJRAVqm3yzydJtF3F0/EGkc+w+a7atXOwe8vXIIa564W1CsxF/qHJa55DtI7x6CFoucDHwL5Ofi4wRnkg6/CAiHN9SpeyyJ+KtC3MKUf669s/G4nGM4ofbegIu56Tx+xI40+/zhXF+X3IFlasSpGK7oBUkuLkAnE5eaGFltuQg4z54aXIy7G/ERJx0s56ftSDVQPkcFygk+TR+gXlVeW1m0O8gMaaniYbtrO7QqXdX9ZAmfcurD3zbCmm1t6VeF5n0qD9JF/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(2906002)(2616005)(956004)(4326008)(6486002)(7416002)(8936002)(16526019)(186003)(38100700002)(44832011)(66476007)(36916002)(478600001)(66946007)(83380400001)(16576012)(36756003)(31696002)(66556008)(86362001)(5660300002)(8676002)(31686004)(316002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUdtRHZ6blU0YURsRUlEZFk4RUJiTFV0ZjlEa0pLV3I2Y3h0RlV6NHZwN2NW?=
 =?utf-8?B?cnhqLzhCMzJseU1xYnVlMmplTGlMaDh6OUZGbTVRYXl4WGMzQU4vRTk1Qjdt?=
 =?utf-8?B?UnRDeDBUazVVdnJ2Z09xNXJJQ21LQ29TUDE0ekRsQ3p6M01sdFVTOEdZUGI0?=
 =?utf-8?B?TUd6TlloWnZVbmpKRDg1UnVsMUZVZTVnRldLajR6emYwTGg0clA1UUt6ZFVR?=
 =?utf-8?B?T0RtQ09sckNSaUFNQlBxT05LbUd6Qmx6TGhIa0VnSXF0OGludklDWllzYWJ6?=
 =?utf-8?B?Ym9PTHlURDQ4a0JhMkdsVUo4YW1jK2FPN2lrVDBNdTRxQUVzekptWlhxdzI0?=
 =?utf-8?B?TTRQamkycWpaK2pVZUR6QlIrYU5Jemh0STJNNUhmSmNxUVJ4K3dybFNjT2tO?=
 =?utf-8?B?ZmZZNjhPTUpUenorbVY2ZGVLTmNNRi9QS242ZVN5elFtNXpZRW9JUTlYOEZn?=
 =?utf-8?B?QzhFd1NzODdkRDNGMUViTUFPeGUrQXpIU3FvZ2dydUJGT3N2YTQrRm02TlN6?=
 =?utf-8?B?bzZaMjB6Qnk5SjV0LzNwZE11R1c4WUs0NE9qQ2prTUMvRGZjcWVJc29HbU5t?=
 =?utf-8?B?eUU5eDZMcXZWUVpPc0FFUFNIZE92SG8rMmN6WE0weHRqSCtEZ0pmclpVZ1E4?=
 =?utf-8?B?cGRVbmRzeDFOd2hqY3VtV09leWZQcFQ4WWVMY2R0ZXF0b1EyaXZ5MG9MTklp?=
 =?utf-8?B?RWJldXJ0VWl6cit0RWxYSyszWjhnRnNrQisrbVhRWDRzMlZQSHpwUXJqdFE0?=
 =?utf-8?B?MHJxdklVVTh6eEZZY1Byek45Tlo1MVNlZE55Nkg5NDh6bkg5eCs3KzlzVWJ5?=
 =?utf-8?B?aXdLSEFQVWxBT2hWaFBNcGp2UFhMYmM3VHFoYytPaTdpVmJFQndERGRFM09k?=
 =?utf-8?B?dVpyWmhTdUV3b1FMQW80eFNSQy9ZSldwUEhTdHYwVXY5VFVKT3pEbVlaTkVx?=
 =?utf-8?B?K0RZNEtaU2cyMFpzQnhDWkc0QzZGRlR4UVo2TEFaUUNhSzk4dWVQNEFUeTNz?=
 =?utf-8?B?RjFuNlkyYUh0dTQ2QXFzRW5jYlJvZ0FKTkhMdjhqaXBmMHFPR0IwUnhyRmVZ?=
 =?utf-8?B?VzYycFNyTVRrNEFTaTIyWVZzVmdmZzVHZHRrem9oVHJmREJ6M3pUOUZnNWl0?=
 =?utf-8?B?dU9IN0RWUVdRUEN5RTZVWCtPanFSZzJuM1VHcTB4U2NMV3pMWkFyZlBGcmRt?=
 =?utf-8?B?cVZ1MEpiTHB2ajkzaHpBcHRTSUE4aXExL0IwaWtJeERoNkY5a1lVeG1RZmVM?=
 =?utf-8?B?NVNSSG0zaHlmZEt0NTdPRFY0TFduUmxMOGRKT1NQZG1LbnFZTmVrT2ZxWlRk?=
 =?utf-8?B?Tlpxc3J0T0liejJSVmF0eFVVcnNwc3NxK0dPeW16RFp4ekppV3lqWHZqcVB5?=
 =?utf-8?B?Nlp4ZEU1bHZ2eDNGRVNMcEJjZlVEcnA4dXVyNmhQLzcwM2VJUXdOVFkvRTZi?=
 =?utf-8?B?MVhMSjJoam5vbnNRRFV3Tlo1VXNLTUNxMXlTcFY4WDJDYVhkaUdsbkhmUVF1?=
 =?utf-8?B?b3doK2loK0IxMzRKeWVIN3NBME5JL0I0Z2dEb2c3VFJZRjdSTGRVTlJDam10?=
 =?utf-8?B?aXFGV2dZSUN6RXA0cG1yU2t3OGFxbytwa3JpdStXYTlqYkpqWWYrTkVPOHlR?=
 =?utf-8?B?RWtLOHBhUi9kZ05XNUx1ZjI3aGpCYm1WV3FsdjRHLzh0dEFBYVRBcHpmT0xH?=
 =?utf-8?B?c3FjZzJMSElRT2U4bkdqYXV5SFlTeTJQamhWYVdGVm5aMjFOMGlJajdrUjVX?=
 =?utf-8?Q?isBvKN1TdgUPciNbVG++e2F85X+S3szHKle1W9j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7d7ec6-e098-45dc-0390-08d91c8759cb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:36:30.4074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dWsc4bQLkC9ojJAJ9A8phYWTTNdT1z7VcuYDol/vvfI6ITFMW+3vF864q67ou7M6VPGu796+DOeNo67gDJ4/K/2GmGHo5vrK/C1ggZq6Fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210096
X-Proofpoint-GUID: PZg3cSWZKrLI916Atd5Kf6u7If0rLGC6
X-Proofpoint-ORIG-GUID: PZg3cSWZKrLI916Atd5Kf6u7If0rLGC6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> In this patch, we present the nvme-tcp-offload timeout support
> nvme_tcp_ofld_timeout() and ASYNC support
> nvme_tcp_ofld_submit_async_event().
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/nvme/host/tcp-offload.c | 85 ++++++++++++++++++++++++++++++++-
>   drivers/nvme/host/tcp-offload.h |  2 +
>   2 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 276b8475ac85..01b4c43cdaa5 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -133,6 +133,26 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   		nvme_complete_rq(rq);
>   }
>   
> +/**
> + * nvme_tcp_ofld_async_req_done() - NVMeTCP Offload request done callback
> + * function for async request. Pointed to by nvme_tcp_ofld_req->done.
> + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> + * @req:	NVMeTCP offload request to complete.
> + * @result:     The nvme_result.
> + * @status:     The completion status.
> + *
> + * API function that allows the vendor specific offload driver to report request
> + * completions to the common offload layer.
> + */
> +void nvme_tcp_ofld_async_req_done(struct nvme_tcp_ofld_req *req,
> +				  union nvme_result *result, __le16 status)
> +{
> +	struct nvme_tcp_ofld_queue *queue = req->queue;
> +	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
> +
> +	nvme_complete_async_event(&ctrl->nctrl, status, result);
> +}
> +
>   struct nvme_tcp_ofld_dev *
>   nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
>   {
> @@ -733,7 +753,23 @@ void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
>   
>   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   {
> -	/* Placeholder - submit_async_event */
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(arg);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	ctrl->async_req.nvme_cmd.common.opcode = nvme_admin_async_event;
> +	ctrl->async_req.nvme_cmd.common.command_id = NVME_AQ_BLK_MQ_DEPTH;
> +	ctrl->async_req.nvme_cmd.common.flags |= NVME_CMD_SGL_METABUF;
> +
> +	nvme_tcp_ofld_set_sg_null(&ctrl->async_req.nvme_cmd);
> +
> +	ctrl->async_req.async = true;
> +	ctrl->async_req.queue = queue;
> +	ctrl->async_req.last = true;
> +	ctrl->async_req.done = nvme_tcp_ofld_async_req_done;
> +
> +	ops->send_req(&ctrl->async_req);
>   }
>   
>   static void
> @@ -1039,6 +1075,51 @@ static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
>   	return ops->poll_queue(queue);
>   }
>   
> +static void nvme_tcp_ofld_complete_timed_out(struct request *rq)
> +{
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_ctrl *nctrl = &req->queue->ctrl->nctrl;
> +
> +	nvme_tcp_ofld_stop_queue(nctrl, nvme_tcp_ofld_qid(req->queue));
> +	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
> +		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
> +		blk_mq_complete_request(rq);
> +	}
> +}
> +
> +static enum blk_eh_timer_return nvme_tcp_ofld_timeout(struct request *rq, bool reserved)
> +{
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_ofld_ctrl *ctrl = req->queue->ctrl;
> +
> +	dev_warn(ctrl->nctrl.device,
> +		 "queue %d: timeout request %#x type %d\n",
> +		 nvme_tcp_ofld_qid(req->queue), rq->tag, req->nvme_cmd.common.opcode);
> +
> +	if (ctrl->nctrl.state != NVME_CTRL_LIVE) {
> +		/*
> +		 * If we are resetting, connecting or deleting we should
> +		 * complete immediately because we may block controller
> +		 * teardown or setup sequence
> +		 * - ctrl disable/shutdown fabrics requests
> +		 * - connect requests
> +		 * - initialization admin requests
> +		 * - I/O requests that entered after unquiescing and
> +		 *   the controller stopped responding
> +		 *
> +		 * All other requests should be cancelled by the error
> +		 * recovery work, so it's fine that we fail it here.
> +		 */
> +		nvme_tcp_ofld_complete_timed_out(rq);
> +
> +		return BLK_EH_DONE;
> +	}
> +
> +	nvme_tcp_ofld_error_recovery(&ctrl->nctrl);
> +
> +	return BLK_EH_RESET_TIMER;
> +}
> +
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
>   	.commit_rqs     = nvme_tcp_ofld_commit_rqs,
> @@ -1046,6 +1127,7 @@ static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.init_request	= nvme_tcp_ofld_init_request,
>   	.exit_request	= nvme_tcp_ofld_exit_request,
>   	.init_hctx	= nvme_tcp_ofld_init_hctx,
> +	.timeout	= nvme_tcp_ofld_timeout,
>   	.map_queues	= nvme_tcp_ofld_map_queues,
>   	.poll		= nvme_tcp_ofld_poll,
>   };
> @@ -1056,6 +1138,7 @@ static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
>   	.init_request	= nvme_tcp_ofld_init_request,
>   	.exit_request	= nvme_tcp_ofld_exit_request,
>   	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
> +	.timeout	= nvme_tcp_ofld_timeout,
>   };
>   
>   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index 2233d855aa10..f897b811c399 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -117,6 +117,8 @@ struct nvme_tcp_ofld_ctrl {
>   	/* Connectivity params */
>   	struct nvme_tcp_ofld_ctrl_con_params conn_params;
>   
> +	struct nvme_tcp_ofld_req async_req;
> +
>   	/* Vendor specific driver context */
>   	void *private_data;
>   };
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
