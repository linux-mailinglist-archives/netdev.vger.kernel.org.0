Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8B38CC6C
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhEURnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:43:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7512 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231508AbhEURnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:43:52 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LHRMSG016412;
        Fri, 21 May 2021 17:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oztnREE1GF8hBcqD7+KzTMdkr0gOV7m3r51yhwxrvyc=;
 b=i9SdLQd/XZBHfSONhvo/+lM0lZeKv6/T7i0q33fmjtJ7VQVxxB+urriiooC3epZml3Rb
 Gs4v5q1d9TlmgnKZtgT6aq4BycYz8KPgnbWKscUfd58hLKvg+RQApC08acDb0/mFqMDg
 cnW6FQCdVaQasLyBGTtgA2UZfxeS9QhOsHVqsaDSo8P6F0jgEhP/ztNMXdJLTaokzKxH
 vwd79EEgJbjPXI3eaGNcPypudu8rF9SKRGclhm6IT9edBGxEaSeXKcgK01Gs83IeEJaj
 o/1RKOOI1ij5BqOAuD33F+nvWvuyBk1pb//jmXiMA9A1ogt1ORKZOKBDvDxUlskGhq6Q JQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38nhjfrpas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:42:18 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LHdXh8072625;
        Fri, 21 May 2021 17:42:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 38nry3dt7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:42:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVLUDO6c7eiAwSdhj0WYLG/AlNzBVzXKRDeqIju+yRzGkrgh5YGz7cUBuVUVtgn28C7zXVhHOM5EsU5/BTkKvvVuJQCwPmcnm37pW6ImRDFM8Jk6i4mL+GLFrfajJBlQKq1/MkkPt0bPBdy6rgXsj/Z6sH8AcIz13+d+HYR7WNV1igogCjn108xCsgsJVYOTWWPBkq7MQSGsvEZfkKFBGRCh+ISsiMldGI5W+062oe5ByRhFRZU4MDkeAVUJVB+DNBvri4wj+wKK443mqAZmgii8r+oxTumKhzLMaalFsZ+CCpGAwOd7+9it2f7/DZr5XZKyXYmIQPUr6gOgmVcXvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oztnREE1GF8hBcqD7+KzTMdkr0gOV7m3r51yhwxrvyc=;
 b=VP7Wy60ZIA4fKx4ylZWPKuqQwwzel992NDz5DhXF1qEj9FfkUmNGZKNu559txqX5FxQe34y8WyGTCU2fxb8C/HVrHHJwLWcomp4cPPN5gCq5gs6mKalQK77YugxSPaWzPnfqjGUJLTGEirovMR77efDSSKcnxx1uGvZ3ebUdWoKpwYYUdXh23mg0aIzgMn5YjaTYeeH0bVZ3sgkZfFGe0UI9qgHIJjeRyWLsxIV9nbr1nyqxTMlbRcR+atxm5oXTrMcRvgvWgu9hNYMiDqtNsfn91N17xw+WP96IDXbS1McWH1Xycdbm+1cvWtUoRZrrGqKmSl+XWTTT/ZHNIO/zSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oztnREE1GF8hBcqD7+KzTMdkr0gOV7m3r51yhwxrvyc=;
 b=I1G8FEO7mnFxu16onPC1PNetq1v3JOWInPNTt1/xX9tuFFPCjOE+myvEpGXY/c6/pP1lE7cpLP7ERdN2rKu3xTs14z+MXfkxV3mTvoElfqM1QfZ02GA76eebVF7BvMfykg3P8lZJMWpGjldTT7jIRHvqHWAYbhdDhN/JUYwo11Y=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4427.namprd10.prod.outlook.com (2603:10b6:806:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 17:42:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 17:42:15 +0000
Subject: Re: [RFC PATCH v5 05/27] nvme-tcp-offload: Add controller level error
 recovery implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-6-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <220e96a6-de82-4082-1d4e-2d95dcec5562@oracle.com>
Date:   Fri, 21 May 2021 12:42:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-6-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:806:23::12) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SA9PR13CA0067.namprd13.prod.outlook.com (2603:10b6:806:23::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 17:42:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd5783a9-32b8-4539-db87-08d91c7fc5c6
X-MS-TrafficTypeDiagnostic: SA2PR10MB4427:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4427F3466FD718D7F3218B38E6299@SA2PR10MB4427.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiptR+myFXb/cmrlmoIFLeOniEqHw013tmf8cP21MZj5afaJEQFxscifrRSJNEzQW57pTKEil0JNMy776dLPgZ48eabSjUqauAM7F/rrjtUTrw6/HmQKUvrE7R7TSV5GH7rL95th1Btz74L28Uz6T0hWMMOmOU9Y8TGpTPDBuJucg8AWiLSKF971QfHFeqRlajnXtwIvWQCvgpaQlAI5tY44nyrgm4Q3a62u7NRKNhgLMTZqUcqETEYZOFU1jDzUqpj8HciNn3lOu7dfq/Pwkq8TyixD2dowZ/gz4yq777hA7LWvpOZQKgGUdJODDibsOp50KscuR79OD3iXkX3vmwr1j3GSySLL0SW7x95GLlbmz0WtOkOtp8Wn+vmapn8j18jxSvzYU/aXZFK1GppJteitKuf/Ze96SWdI8AQyxoKXBA63cvgbE6ICgneKIyeeZcEabH6OQKrA45cmaMJ1jQkns1RQ3WQHlRKZNRLGADtls3LsinvBjzjDJgMk73KRNok2myyIscMns0uTeztJJzhX+gbpusxTUDrAZaFNAd/1O4YjvlSzDr/OsnAvUaQ6yDUdT1NLs7jEG6ecAQ3/IuSxHVNcgCfL7Vyz+UfREZsAexmVO507d8EeoUK/5OUqmd+y3q8Q2gHovagyo8bFSQ2DeAW5vNbyWbg5WSPu+O17Efg4E8oQYyRrgjrN7Pwj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(4326008)(478600001)(66476007)(31686004)(5660300002)(66946007)(186003)(44832011)(16576012)(7416002)(6486002)(8936002)(16526019)(2906002)(2616005)(86362001)(83380400001)(36916002)(38100700002)(36756003)(26005)(8676002)(316002)(53546011)(31696002)(956004)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bzgzZUgxOXk1b05CRGZ4d2JSeThCNW94UzhjeUE3Rlh0elhOZXhRRkFhWW0y?=
 =?utf-8?B?cFJhM09TK0gzSlZFdTlxUktMU0ZVUnE2MFZsaU03ejJ3MmcxSkN2UU96bTlJ?=
 =?utf-8?B?QVdsVUM0d1ZYNEVxd3FNSXVueTZiSnM4NHhVc2swRm9zUm5rQnNJQlB4SFI2?=
 =?utf-8?B?NzJmVlhsVlBKZXZJVC9XcGh2QjdVOUZNVlIzMm01bVpGWXVPL3J4d1UwK1lm?=
 =?utf-8?B?dk1hUisvdytQa2ZqQzdYd3BoOXdLcVA2OEQwV2c5aDdlcE9aMlk0U3dydFRw?=
 =?utf-8?B?cDU2L0ZjSEUvbk8rS2kvbE1ZNnJaaENOQkNIckhNVUFlemY2dTNaTU9iTzFi?=
 =?utf-8?B?OWhWY1dlKzlOa1I2S240eFNEMWtUT1BGMnJEVjlwdU9xM3pxaVgxSDh3YW81?=
 =?utf-8?B?czZJd1ZOWlpHSUpsRk9sTlpJVVpIWThDMDRxMkN1akd2MmFMY2J1dCtmR3Vh?=
 =?utf-8?B?UHhRWGZFWXFGL0V0TmhKSXJGbjEvd09LYVFJR0FVTlRvQW03di8xRXkyc0lo?=
 =?utf-8?B?dThMOWNQeXp0K0xRcThXZ1BhckNVaUJacGJNODBaV0JRS2FWaHJTS1VnbUdG?=
 =?utf-8?B?TVk1NmE1ZG5nQmJXcWc3MHBUZnJnMXZWaGhSUnhLZGgwKytPTVVtc0FoQVNt?=
 =?utf-8?B?U3VKODgxcVIwMzZ0R21xT1RvemNKMGpsM291cTNxa3JhYXo5dnRFY1hYdUV1?=
 =?utf-8?B?VG9PMTlVUWRjYmJKWFNWaVRYMmJqWXJBL1ZLMEZWcTNqYVBlaDY0UXRmRkF2?=
 =?utf-8?B?TlJ4TVBhSWNXMXpJYUw1blZxazczRzJQZUxlZFU3MmNuNS9zcFBncEZoRVVy?=
 =?utf-8?B?QXNOU1QvbXBBUnYzMm9MaXZNRXVHRE13a0dzVEowUUdwMmJ6NUMycTgxdFY0?=
 =?utf-8?B?SUdBNndQQk5ybnlqYXJ4akxXa2hKcHk2NXhjNTRWb2NxSGZmeG16eVlEVnZs?=
 =?utf-8?B?VFFyNi9Tb25kdVpabmdFYk55bVNtU3Y3R3dwejVFbkwzT1RoTjFsSW00K3Ra?=
 =?utf-8?B?bTNuVS9lbkwvWThMZ1dSQ1g1Ky8xYmRGL0FVK3J0OEt5MGlxZG9xUjNLOUFi?=
 =?utf-8?B?enFzRGh2SkpobCtDVllON0owM09PeVJpbThndUd4NjErblUvNVJzeGtkQ2RF?=
 =?utf-8?B?VVFSUks4dWVtL3VlQzhoYzREdHJ3WU9WODNnWDNhS2hhbGRUSHE2M3ZQY2w4?=
 =?utf-8?B?NnB1Nlp0UFFNMkdxQU1ZTXozZGlZLzdTZFFCS1Q4MWZGK3Q1Kzl0cGRTOW5X?=
 =?utf-8?B?ajBxWHVTNkJIWHJJTXA5VHgwWHhXRitwTGFrU2RrQTViaGlaTWd0WXVNZWhw?=
 =?utf-8?B?NTI5T2pHTllJVVV5Y0lqL2tGS2ljTE1JRUl1RDRIUkhVWm95RmlTTXlUVUt3?=
 =?utf-8?B?RDFXVHM1NTNIRFdmamlUMmc3d0hidjZRejc4ZVZzcmRoV0dYNE9XNlFZZ3VT?=
 =?utf-8?B?dlpvdjFFWjhVRTU0ZXRJYm9nMHZqKytNY1ljNEdCME5vT1JwK2tpajBOdUhk?=
 =?utf-8?B?OWtpc0NVSW4zU0JDc2h1czhzMUFOUnRpR3A1aEhqNUwvT0oxOWxucjZHYklH?=
 =?utf-8?B?YXFieDU5OGsyTmVOSFNkVUkxcDlQT2gzbmZyTXdjaURoNld1WHNsU3dpc1c2?=
 =?utf-8?B?RVR4MmtyalR2SWkxU1pKOENIRGp4WmhVWkVoa3plS0w1cnVrSERsdytmOUg4?=
 =?utf-8?B?eXNlMWVmMWlBNEFLVDRKRGNUaHNwekdPR3FVb2ZPMjdGTUxDWDhMVExoNk1x?=
 =?utf-8?Q?cbQI9GTubsArLiBYUpvFQARcgR2pDkQvaruadSj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5783a9-32b8-4539-db87-08d91c7fc5c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:42:15.6102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBHR+yL4Fc/3jCINPv50H+WgIgtT5M0wYfQl90JD6r+vAji+z6m0OwGRebKi9FAGldOqGNr+ahTU3C0LRCX/8Vd3F6g3GwO3vrOIvlh9szQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4427
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210092
X-Proofpoint-GUID: _alSkQsB-63QLPsM67J2fv8RJVrxNryW
X-Proofpoint-ORIG-GUID: _alSkQsB-63QLPsM67J2fv8RJVrxNryW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> In this patch, we implement controller level error handling and recovery.
> Upon an error discovered by the ULP or reset controller initiated by the
> nvme-core (using reset_ctrl workqueue), the ULP will initiate a controller
> recovery which includes teardown and re-connect of all queues.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/nvme/host/tcp-offload.c | 138 +++++++++++++++++++++++++++++++-
>   drivers/nvme/host/tcp-offload.h |   1 +
>   2 files changed, 137 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index f7e0dc79bedd..9eb4b03e0f3d 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -74,6 +74,23 @@ void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
>   
> +/**
> + * nvme_tcp_ofld_error_recovery() - NVMeTCP Offload library error recovery.
> + * function.
> + * @nctrl:	NVMe controller instance to change to resetting.
> + *
> + * API function that change the controller state to resseting.
> + * Part of the overall controller reset sequence.
> + */
> +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl)
> +{
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_RESETTING))
> +		return;
> +
> +	queue_work(nvme_reset_wq, &to_tcp_ofld_ctrl(nctrl)->err_work);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_error_recovery);
> +
>   /**
>    * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
>    * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> @@ -84,7 +101,8 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
>    */
>   int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
>   {
> -	/* Placeholder - invoke error recovery flow */
> +	pr_err("nvme-tcp-offload queue error\n");
> +	nvme_tcp_ofld_error_recovery(&queue->ctrl->nctrl);
>   
>   	return 0;
>   }
> @@ -296,6 +314,28 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   	return rc;
>   }
>   
> +static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
> +{
> +	/* If we are resetting/deleting then do nothing */
> +	if (nctrl->state != NVME_CTRL_CONNECTING) {
> +		WARN_ON_ONCE(nctrl->state == NVME_CTRL_NEW ||
> +			     nctrl->state == NVME_CTRL_LIVE);
> +
> +		return;
> +	}
> +
> +	if (nvmf_should_reconnect(nctrl)) {
> +		dev_info(nctrl->device, "Reconnecting in %d seconds...\n",
> +			 nctrl->opts->reconnect_delay);
> +		queue_delayed_work(nvme_wq,
> +				   &to_tcp_ofld_ctrl(nctrl)->connect_work,
> +				   nctrl->opts->reconnect_delay * HZ);
> +	} else {
> +		dev_info(nctrl->device, "Removing controller...\n");
> +		nvme_delete_ctrl(nctrl);
> +	}
> +}
> +
>   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   {
>   	struct nvmf_ctrl_options *opts = nctrl->opts;
> @@ -412,10 +452,68 @@ nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
>   	/* Placeholder - teardown_io_queues */
>   }
>   
> +static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl =
> +				container_of(to_delayed_work(work),
> +					     struct nvme_tcp_ofld_ctrl,
> +					     connect_work);
> +	struct nvme_ctrl *nctrl = &ctrl->nctrl;
> +
> +	++nctrl->nr_reconnects;
> +
> +	if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> +		goto requeue;
> +
> +	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> +		goto release_and_requeue;
> +
> +	dev_info(nctrl->device, "Successfully reconnected (%d attempt)\n",
> +		 nctrl->nr_reconnects);
> +
> +	nctrl->nr_reconnects = 0;
> +
> +	return;
> +
> +release_and_requeue:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +requeue:
> +	dev_info(nctrl->device, "Failed reconnect attempt %d\n",
> +		 nctrl->nr_reconnects);
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
> +static void nvme_tcp_ofld_error_recovery_work(struct work_struct *work)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl =
> +		container_of(work, struct nvme_tcp_ofld_ctrl, err_work);
> +	struct nvme_ctrl *nctrl = &ctrl->nctrl;
> +
> +	nvme_stop_keep_alive(nctrl);
> +	nvme_tcp_ofld_teardown_io_queues(nctrl, false);
> +	/* unquiesce to fail fast pending requests */
> +	nvme_start_queues(nctrl);
> +	nvme_tcp_ofld_teardown_admin_queue(nctrl, false);
> +	blk_mq_unquiesce_queue(nctrl->admin_q);
> +
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> +		/* state change failure is ok if we started nctrl delete */
> +		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
> +			     nctrl->state != NVME_CTRL_DELETING_NOIO);
> +
> +		return;
> +	}
> +
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
>   static void
>   nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
>   {
> -	/* Placeholder - err_work and connect_work */
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +
> +	cancel_work_sync(&ctrl->err_work);
> +	cancel_delayed_work_sync(&ctrl->connect_work);
>   	nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
>   	blk_mq_quiesce_queue(nctrl->admin_q);
>   	if (shutdown)
> @@ -430,6 +528,38 @@ static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
>   	nvme_tcp_ofld_teardown_ctrl(nctrl, true);
>   }
>   
> +static void nvme_tcp_ofld_reset_ctrl_work(struct work_struct *work)
> +{
> +	struct nvme_ctrl *nctrl =
> +		container_of(work, struct nvme_ctrl, reset_work);
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +
> +	nvme_stop_ctrl(nctrl);
> +	nvme_tcp_ofld_teardown_ctrl(nctrl, false);
> +
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> +		/* state change failure is ok if we started ctrl delete */
> +		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
> +			     nctrl->state != NVME_CTRL_DELETING_NOIO);
> +
> +		return;
> +	}
> +
> +	if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> +		goto out_fail;
> +
> +	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> +		goto release_ctrl;
> +
> +	return;
> +
> +release_ctrl:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +out_fail:
> +	++nctrl->nr_reconnects;
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
>   static int
>   nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   			   struct request *rq,
> @@ -526,6 +656,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
>   			     opts->nr_poll_queues + 1;
>   	nctrl->sqsize = opts->queue_size - 1;
>   	nctrl->kato = opts->kato;
> +	INIT_DELAYED_WORK(&ctrl->connect_work,
> +			  nvme_tcp_ofld_reconnect_ctrl_work);
> +	INIT_WORK(&ctrl->err_work, nvme_tcp_ofld_error_recovery_work);
> +	INIT_WORK(&nctrl->reset_work, nvme_tcp_ofld_reset_ctrl_work);
>   	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
>   		opts->trsvcid =
>   			kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERNEL);
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index 949132ce2ed4..2a931d05905d 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -210,3 +210,4 @@ struct nvme_tcp_ofld_ops {
>   /* Exported functions for lower vendor specific offload drivers */
>   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
