Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1538CBF6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhEURVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:21:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16034 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhEURV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:21:28 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LHCJbW003576;
        Fri, 21 May 2021 17:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gAnZzojEXFSWsFxA5tWb+2xuo0pzxaT8y222RgqPiOM=;
 b=CsuEJyOEWcJfeRVTDK8zobXnBUmtlps5JKDM12ITOB+1pV1UJMmB65yBwVm+sOTwoBhP
 2HzoRoprhy+gM9XyfRZWEjv00mWYjW8hG3KBH26lKKGduZcu+H+UuQZ0cFmM2kjNkVF/
 VWdP0gqW4eksT11eB1uQ7h3EZsAcG9AhYMtwl1CWldniT+cr0V/TUzHlxMC77tabzR7V
 cuerY1H4+aoP76Y3UtE308USIYZGns9sYyHpGiZCaUrLXS5d86fmkq8TOlDtfirk00BA
 l69jGT45Xf+nTlheVt/syVavCg2jrwF5+FO+hIx9z8750U9zybFSeudgv1C2OmO4myNs Ew== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n3dg1170-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:19:49 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LHJnfv058507;
        Fri, 21 May 2021 17:19:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3030.oracle.com with ESMTP id 38meehxesk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1C18oIcbR60BlqXawkxyLmMeKhOCL7xGlnxDRAWiPrC4UX2U/tQRzV12OlBxshjoL+gHKiP40NpmyulDz+3HhuUPrs9p85rUuOieIRVWXyiVj9Kh+P4ktF6Ve9eDbR76+cqLcz+Hm+wkKM3MRLt8mYEQZIdNpO+JiRrN9NHfPmDHkoKX90XFRsbPkBFpPXamFPy4TkJSgHS6Kue++lhsKow0MerVDRcRTYaaJGicMUyv/7fkVV/WLPFCEmnSI1PRGO6FKfNMgs3vdXg6e2qOyytUr50bigAFCeRB/t0FNHXD/z1mRTzHcMi/soVSpbO+HQglUAIYsd/PwyFxeNGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAnZzojEXFSWsFxA5tWb+2xuo0pzxaT8y222RgqPiOM=;
 b=LvqYxVFH7fUzY+D5b1XJQzzt/xJyncVkbKczUQ4QHkkc5m03ON1Je2tmqHwpbIf5CnRuYCP4Yf1Hqme2icB9p6LIKDVTa2p+6rJFGZ053AYNC/VXIzfeTehCIJaXfpX45G/sGY4hU9eCbX+HY1csoOrJwJE7U4NOAdywjunqpfD02oluTGmPxwERtCiqXILzh4nFbxGULfq8onkyRTF4MEJiA/M6ocEcZPedeVjRoMmMkgNQcZvasAw0B4UWjSWJ+raIIy7wBNuB+gpczAVoD7lmTOluaEVxUULWVP5jWAn/StR1aO461BtpbqNeIc6IgCXRmhr+/z6txc0U+jn4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAnZzojEXFSWsFxA5tWb+2xuo0pzxaT8y222RgqPiOM=;
 b=gutbF9p5FohH2czieZLqJ1TJFU/N4tUUWW/wzv/tbMuGt5GS2zivVp/4Hbsxe3n6ou/FJHlOMiZc+Vh0vJqu8CYbwYhId1WJBiql62E9G/s2d9UrfcgG+l7tfMeSjBXFVXNqDwB7MIWZIa5RopufKdQR2af6i0SrKXsalmlqLkE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 17:19:47 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 17:19:47 +0000
Subject: Re: [RFC PATCH v5 04/27] nvme-tcp-offload: Add controller level
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-5-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <deb7ac09-3c0a-4ade-b22d-ef054df42b58@oracle.com>
Date:   Fri, 21 May 2021 12:19:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-5-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:806:24::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SA9PR13CA0103.namprd13.prod.outlook.com (2603:10b6:806:24::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 17:19:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be88c9a2-e4b4-4852-9287-08d91c7ca1f9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4732:
X-Microsoft-Antispam-PRVS: <SA2PR10MB473273395C80F34BA13848E5E6299@SA2PR10MB4732.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:22;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t35WGMfuqZbczr4DMX+uwlk9GgfHHLknsSrH10DKzQyJSXgEsaDoVZysUeTjTNQZe+9yeplSB+lOA65ecn01piZzEQYQMSTK7BQVD+ncGTLOZpj9YtCsH2a0JeXoE7YPf+FS4OTKdsof+UFnY4INlIf4zTCqKNwxc023otuwFndu5Vfds42EpDtts5wjHO2kLvjW1BFETqzuX6gZCvSHVro8Fgj+zxm0O5+rAn6wKR7eBgJ6llQzI/8Qj3OR6x0WETquIKpiTF1N6FcMz7+hs6MNkHoJmkdB+98T5tB7sCQRefeIUlv1jiN3KaDdh8AZXRe7Oa7kxcBbY0hSmhLQRkuhjzpworDSxUz8doCbblBBkEH273z+yBdu9f5ZSPa+MxDEKeMEcI/lDRVo1601F82tnavSEKfLRL5vWsCUJESKPmefcOGj1eNzJ/rSESN50ADw4qj7IAy/qxzUkyVk0oBkWJE7Zz0Gt/wBxZ0VtQsxM8WhIpKpxm9150jn2vo4OkeD5I76WKNHscyUVaAqWe2InDrz241uEoNdQASnsG7F+oYWPeBF4breX1SyAuZCnloKguFieiXJ4KDQWAlriVwdVsCXGJ86371rZngsVP/Ae3QS3xGSluUhEjqu96aZNniMLXxZq3zZuNqYUqbFMT7395NVaF2SAtqFfc1GBKfW7RUKrhR/qP6WiY6Yqs35
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(8676002)(16526019)(36916002)(31686004)(30864003)(2616005)(2906002)(66556008)(66946007)(66476007)(478600001)(26005)(31696002)(956004)(86362001)(186003)(8936002)(5660300002)(6486002)(38100700002)(7416002)(53546011)(36756003)(316002)(4326008)(16576012)(44832011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFFyVDFqWlg5c3YxcWtiWGE0aUpiL05NellWVi84dTRGbTZTV2RJUUc2V2NZ?=
 =?utf-8?B?RHpIUnVCMHFtN1ZCdmtkUmxqVytTNy94QjRMMDA4Snc0RW5ZMGlKNzJCdFc2?=
 =?utf-8?B?NDNaNW4rc0hnZWs5S2RlMGFOTXJFdXBSN0ZYUHBINllHVlVJUXN1bUxVMlh3?=
 =?utf-8?B?Ui9ZOE90SkV1THRqcFZHeVhKVXZYSlA3b0gxSkh2bHRuOWNXTlpFak0rS2pT?=
 =?utf-8?B?ay90LzJ1R05WM0dlbjNYeGJGUklybk1nWlpURjdvMHlnVGd5WHpkOUsxR3ly?=
 =?utf-8?B?OXZlVFlPYk9sZ1dQMGVGbDV4TWR2NVFibTZwUDhBSlo0L01INDRndSs0Nmw2?=
 =?utf-8?B?anNtR3kwd2FSbUF6UFdKWFYwR3pqUGhpcS95UHpyRHlQajF2Z2tBNDlGZUNL?=
 =?utf-8?B?RTloOWZGaDM4NUJYKzBmVk1sVlE2VkZsVExsVmVQOGJGcy9lSE5DODJTYUVU?=
 =?utf-8?B?UFhNcnJVNDBEUjlJQ1UwVTFrZFJsbmN0WmpOb292aWdUS296UFB5N21ibVdU?=
 =?utf-8?B?QitSeWpCTVRsRGFOcXQwZDhOcEtQeEpkcCtrUTBHTFBFbyszNmtHODNVWU1K?=
 =?utf-8?B?VldiVkVVVlBHVGJncFk2RWI1dHJzaDBsT3NXVmdHUVg2aENzb3BjdGtLMExO?=
 =?utf-8?B?NWNkNWNIZlZkRlVBUzN5UEJhcElHMlhtTEFiU0ZUNk9HcjFoN2ZRak1pYnFu?=
 =?utf-8?B?eXZVVmduaTFGNlRWaGNJcldsejZuemZFaHBrNVZLZHJXQ2ZwbWdWcWo4dnRZ?=
 =?utf-8?B?UWFIaEk4bWpWVTRkdk1lZTNTQ1lkQUJxQnN1cm5wTVI4SXRKVGhlUmoybXRw?=
 =?utf-8?B?SVlVakg5d1JtOFgwS3JBNUI1bWpzTk1YRHdLVElQUlBCdHhsU2xsYTA5VHBh?=
 =?utf-8?B?SU5MSmxEaSszSWZ0ajV3cEdRVWhXdzUxTVRMT1ZacmJTakVaT25zWFpLQU41?=
 =?utf-8?B?OTB0OVVUSGM5NmF5OENYemZ2Q3dmeG1Ma0FJOGFYV3BCRmphdlBqR0NBNkVW?=
 =?utf-8?B?SnYxUnFnNFdKVGpTZk1XQ0YvK3hkeCs3azdEcjJReVVPd2hLcS9ZbzBZdmk2?=
 =?utf-8?B?RkJGbkVqN1BDREpjYWo2ZFhyZ0Jtc3BTNVFkUWlMaTFhM3BzZFVvMFZ2U2Ro?=
 =?utf-8?B?cXFUUmdFTGYwNDdLUDJaQ3Nxc3Q4T2FKM1djODBzQTZKQmpjWC9rMjZDOW00?=
 =?utf-8?B?aXNFbVF4MnVqNndEVlM0OG92U2NzN2k4OXhabC85dHV1M0ZNVk9PeTFhRUlH?=
 =?utf-8?B?QUI1M3dkM3Myc1lDU012WWtOVlVJajloa1FMV2ZvRnlRTUJ5S1RCbG5WNzdn?=
 =?utf-8?B?dVRsendVQUpXQnlPNzRWRWdvQlRWY0xSMUEzcHVsanF2cWlybDJNbkxGN2Mw?=
 =?utf-8?B?VnVQSVR6aG5PdWJBT25UZzVMZE1WelJTeDFoNmVRSWxVN01Gak5JcjBkRktD?=
 =?utf-8?B?U2tpZHQzZWVwMkNFc0NMS1BXb2JueUI4aGYzY2JGM3U2UFVMcERNTG9TQjNK?=
 =?utf-8?B?MDZFQ2VrOHhSQ01Ic1EvRVM3Smp6RzlrQlBHQkZVL1VsK2VLYU5yckNBeHBn?=
 =?utf-8?B?NzF4QU15eEpSemJacklvSHV3SzczTENYYnJNY29GOWJrOC8zYmVPSlgzSExl?=
 =?utf-8?B?TkxEZThZV2hWUFdnRTlUWXlBM1o1ck5IOTY2SFM2am5rd3NBZHhUWUpWZllW?=
 =?utf-8?B?N0xFdVVvTHhtZ05IUUdDcjUwQTZNMTVFVmNvRU9qVlVFM2N4RGhwT3htVk5h?=
 =?utf-8?Q?/zDPCasTAPxiW3OTiW062aHn05cdRv0ybGxlpvB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be88c9a2-e4b4-4852-9287-08d91c7ca1f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:19:47.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7nC2MVrRKYzJPjJlGBzRiey4XO6X6PqbybouHDRaIF8N+ltshxRjQ/U36vLE78jCf6aweNT2HJcTA1YpXR3mawfGjmcVIz3d7i9V4BpW4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210091
X-Proofpoint-ORIG-GUID: FIBZ33pyCdjb8jgb83e0dLn7kNs-q25D
X-Proofpoint-GUID: FIBZ33pyCdjb8jgb83e0dLn7kNs-q25D
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> In this patch we implement controller level functionality including:
> - create_ctrl.
> - delete_ctrl.
> - free_ctrl.
> 
> The implementation is similar to other nvme fabrics modules, the main
> difference being that the nvme-tcp-offload ULP calls the vendor specific
> claim_dev() op with the given TCP/IP parameters to determine which device
> will be used for this controller.
> Once found, the vendor specific device and controller will be paired and
> kept in a controller list managed by the ULP.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 475 +++++++++++++++++++++++++++++++-
>   1 file changed, 467 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index aa7cc239abf2..f7e0dc79bedd 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -12,6 +12,10 @@
>   
>   static LIST_HEAD(nvme_tcp_ofld_devices);
>   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
> +static LIST_HEAD(nvme_tcp_ofld_ctrl_list);
> +static DECLARE_RWSEM(nvme_tcp_ofld_ctrl_rwsem);
> +static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops;
> +static struct blk_mq_ops nvme_tcp_ofld_mq_ops;
>   
>   static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
>   {
> @@ -128,28 +132,435 @@ nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
>   	return dev;
>   }
>   
> +static struct blk_mq_tag_set *
> +nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct blk_mq_tag_set *set;
> +	int rc;
> +
> +	if (admin) {
> +		set = &ctrl->admin_tag_set;
> +		memset(set, 0, sizeof(*set));
> +		set->ops = &nvme_tcp_ofld_admin_mq_ops;
> +		set->queue_depth = NVME_AQ_MQ_TAG_DEPTH;
> +		set->reserved_tags = NVMF_RESERVED_TAGS;
> +		set->numa_node = nctrl->numa_node;
> +		set->flags = BLK_MQ_F_BLOCKING;
> +		set->cmd_size = sizeof(struct nvme_tcp_ofld_req);
> +		set->driver_data = ctrl;
> +		set->nr_hw_queues = 1;
> +		set->timeout = NVME_ADMIN_TIMEOUT;
> +	} else {
> +		set = &ctrl->tag_set;
> +		memset(set, 0, sizeof(*set));
> +		set->ops = &nvme_tcp_ofld_mq_ops;
> +		set->queue_depth = nctrl->sqsize + 1;
> +		set->reserved_tags = NVMF_RESERVED_TAGS;
> +		set->numa_node = nctrl->numa_node;
> +		set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING;
> +		set->cmd_size = sizeof(struct nvme_tcp_ofld_req);
> +		set->driver_data = ctrl;
> +		set->nr_hw_queues = nctrl->queue_count - 1;
> +		set->timeout = NVME_IO_TIMEOUT;
> +		set->nr_maps = nctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2;
> +	}
> +
> +	rc = blk_mq_alloc_tag_set(set);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	return set;
> +}
> +
> +static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
> +					       bool new)
> +{
> +	int rc;
> +
> +	/* Placeholder - alloc_admin_queue */
> +	if (new) {
> +		nctrl->admin_tagset =
> +				nvme_tcp_ofld_alloc_tagset(nctrl, true);
> +		if (IS_ERR(nctrl->admin_tagset)) {
> +			rc = PTR_ERR(nctrl->admin_tagset);
> +			nctrl->admin_tagset = NULL;
> +			goto out_free_queue;
> +		}
> +
> +		nctrl->fabrics_q = blk_mq_init_queue(nctrl->admin_tagset);
> +		if (IS_ERR(nctrl->fabrics_q)) {
> +			rc = PTR_ERR(nctrl->fabrics_q);
> +			nctrl->fabrics_q = NULL;
> +			goto out_free_tagset;
> +		}
> +
> +		nctrl->admin_q = blk_mq_init_queue(nctrl->admin_tagset);
> +		if (IS_ERR(nctrl->admin_q)) {
> +			rc = PTR_ERR(nctrl->admin_q);
> +			nctrl->admin_q = NULL;
> +			goto out_cleanup_fabrics_q;
> +		}
> +	}
> +
> +	/* Placeholder - nvme_tcp_ofld_start_queue */
> +
> +	rc = nvme_enable_ctrl(nctrl);
> +	if (rc)
> +		goto out_stop_queue;
> +
> +	blk_mq_unquiesce_queue(nctrl->admin_q);
> +
> +	rc = nvme_init_ctrl_finish(nctrl);
> +	if (rc)
> +		goto out_quiesce_queue;
> +
> +	return 0;
> +
> +out_quiesce_queue:
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	blk_sync_queue(nctrl->admin_q);
> +
> +out_stop_queue:
> +	/* Placeholder - stop offload queue */
> +	nvme_cancel_admin_tagset(nctrl);
> +
> +out_cleanup_fabrics_q:
> +	if (new)
> +		blk_cleanup_queue(nctrl->fabrics_q);
> +out_free_tagset:
> +	if (new)
> +		blk_mq_free_tag_set(nctrl->admin_tagset);
> +out_free_queue:
> +	/* Placeholder - free admin queue */
> +
> +	return rc;
> +}
> +
> +static int
> +nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
> +{
> +	int rc;
> +
> +	/* Placeholder - alloc_io_queues */
> +
> +	if (new) {
> +		nctrl->tagset = nvme_tcp_ofld_alloc_tagset(nctrl, false);
> +		if (IS_ERR(nctrl->tagset)) {
> +			rc = PTR_ERR(nctrl->tagset);
> +			nctrl->tagset = NULL;
> +			goto out_free_io_queues;
> +		}
> +
> +		nctrl->connect_q = blk_mq_init_queue(nctrl->tagset);
> +		if (IS_ERR(nctrl->connect_q)) {
> +			rc = PTR_ERR(nctrl->connect_q);
> +			nctrl->connect_q = NULL;
> +			goto out_free_tag_set;
> +		}
> +	}
> +
> +	/* Placeholder - start_io_queues */
> +
> +	if (!new) {
> +		nvme_start_queues(nctrl);
> +		if (!nvme_wait_freeze_timeout(nctrl, NVME_IO_TIMEOUT)) {
> +			/*
> +			 * If we timed out waiting for freeze we are likely to
> +			 * be stuck.  Fail the controller initialization just
> +			 * to be safe.
> +			 */
> +			rc = -ENODEV;
> +			goto out_wait_freeze_timed_out;
> +		}
> +		blk_mq_update_nr_hw_queues(nctrl->tagset, nctrl->queue_count - 1);
> +		nvme_unfreeze(nctrl);
> +	}
> +
> +	return 0;
> +
> +out_wait_freeze_timed_out:
> +	nvme_stop_queues(nctrl);
> +	nvme_sync_io_queues(nctrl);
> +
> +	/* Placeholder - Stop IO queues */
> +
> +	if (new)
> +		blk_cleanup_queue(nctrl->connect_q);
> +out_free_tag_set:
> +	if (new)
> +		blk_mq_free_tag_set(nctrl->tagset);
> +out_free_io_queues:
> +	/* Placeholder - free_io_queues */
> +
> +	return rc;
> +}
> +
>   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   {
> -	/* Placeholder - validates inputs and creates admin and IO queues */
> +	struct nvmf_ctrl_options *opts = nctrl->opts;
> +	int rc;
> +
> +	rc = nvme_tcp_ofld_configure_admin_queue(nctrl, new);
> +	if (rc)
> +		return rc;
> +
> +	if (nctrl->icdoff) {
> +		dev_err(nctrl->device, "icdoff is not supported!\n");
> +		rc = -EINVAL;
> +		goto destroy_admin;
> +	}
> +
> +	if (!(nctrl->sgls & ((1 << 0) | (1 << 1)))) {
> +		dev_err(nctrl->device, "Mandatory sgls are not supported!\n");
> +		goto destroy_admin;
> +	}
> +
> +	if (opts->queue_size > nctrl->sqsize + 1)
> +		dev_warn(nctrl->device,
> +			 "queue_size %zu > ctrl sqsize %u, clamping down\n",
> +			 opts->queue_size, nctrl->sqsize + 1);
> +
> +	if (nctrl->sqsize + 1 > nctrl->maxcmd) {
> +		dev_warn(nctrl->device,
> +			 "sqsize %u > ctrl maxcmd %u, clamping down\n",
> +			 nctrl->sqsize + 1, nctrl->maxcmd);
> +		nctrl->sqsize = nctrl->maxcmd - 1;
> +	}
> +
> +	if (nctrl->queue_count > 1) {
> +		rc = nvme_tcp_ofld_configure_io_queues(nctrl, new);
> +		if (rc)
> +			goto destroy_admin;
> +	}
> +
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_LIVE)) {
> +		/*
> +		 * state change failure is ok if we started ctrl delete,
> +		 * unless we're during creation of a new controller to
> +		 * avoid races with teardown flow.
> +		 */
> +		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
> +			     nctrl->state != NVME_CTRL_DELETING_NOIO);
> +		WARN_ON_ONCE(new);
> +		rc = -EINVAL;
> +		goto destroy_io;
> +	}
> +
> +	nvme_start_ctrl(nctrl);
> +
> +	return 0;
> +
> +destroy_io:
> +	/* Placeholder - stop and destroy io queues*/
> +destroy_admin:
> +	/* Placeholder - stop and destroy admin queue*/
> +
> +	return rc;
> +}
> +
> +static int
> +nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
> +			     struct nvme_tcp_ofld_ops *ofld_ops)
> +{
> +	unsigned int nvme_tcp_ofld_opt_mask = NVMF_ALLOWED_OPTS |
> +			ofld_ops->allowed_opts | ofld_ops->required_opts;
> +	if (opts->mask & ~nvme_tcp_ofld_opt_mask) {
> +		pr_warn("One or more of the nvmf options isn't supported by %s.\n",
> +			ofld_ops->name);
> +
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
> +
> +	if (list_empty(&ctrl->list))
> +		goto free_ctrl;
> +
> +	down_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +	list_del(&ctrl->list);
> +	up_write(&nvme_tcp_ofld_ctrl_rwsem);
> +
> +	nvmf_free_options(nctrl->opts);
> +free_ctrl:
> +	module_put(dev->ops->module);
> +	kfree(ctrl->queues);
> +	kfree(ctrl);
> +}
> +
> +static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
> +{
> +	/* Placeholder - submit_async_event */
> +}
> +
> +static void
> +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove)
> +{
> +	/* Placeholder - teardown_admin_queue */
> +}
> +
> +static void
> +nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
> +{
> +	/* Placeholder - teardown_io_queues */
> +}
> +
> +static void
> +nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
> +{
> +	/* Placeholder - err_work and connect_work */
> +	nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	if (shutdown)
> +		nvme_shutdown_ctrl(nctrl);
> +	else
> +		nvme_disable_ctrl(nctrl);
> +	nvme_tcp_ofld_teardown_admin_queue(nctrl, shutdown);
> +}
> +
> +static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	nvme_tcp_ofld_teardown_ctrl(nctrl, true);
> +}
> +
> +static int
> +nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
> +			   struct request *rq,
> +			   unsigned int hctx_idx,
> +			   unsigned int numa_node)
> +{
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
> +
> +	/* Placeholder - init request */
> +
> +	req->done = nvme_tcp_ofld_req_done;
> +	ctrl->dev->ops->init_req(req);
>   
>   	return 0;
>   }
>   
> +static blk_status_t
> +nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
> +		       const struct blk_mq_queue_data *bd)
> +{
> +	/* Call nvme_setup_cmd(...) */
> +
> +	/* Call ops->send_req(...) */
> +
> +	return BLK_STS_OK;
> +}
> +
> +static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
> +	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.init_request	= nvme_tcp_ofld_init_request,
> +	/*
> +	 * All additional ops will be also implemented and registered similar to
> +	 * tcp.c
> +	 */
> +};
> +
> +static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
> +	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.init_request	= nvme_tcp_ofld_init_request,
> +	/*
> +	 * All additional ops will be also implemented and registered similar to
> +	 * tcp.c
> +	 */
> +};
> +
> +static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
> +	.name			= "tcp_offload",
> +	.module			= THIS_MODULE,
> +	.flags			= NVME_F_FABRICS,
> +	.reg_read32		= nvmf_reg_read32,
> +	.reg_read64		= nvmf_reg_read64,
> +	.reg_write32		= nvmf_reg_write32,
> +	.free_ctrl		= nvme_tcp_ofld_free_ctrl,
> +	.submit_async_event	= nvme_tcp_ofld_submit_async_event,
> +	.delete_ctrl		= nvme_tcp_ofld_delete_ctrl,
> +	.get_address		= nvmf_get_address,
> +};
> +
> +static bool
> +nvme_tcp_ofld_existing_controller(struct nvmf_ctrl_options *opts)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	bool found = false;
> +
> +	down_read(&nvme_tcp_ofld_ctrl_rwsem);
> +	list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list) {
> +		found = nvmf_ip_options_match(&ctrl->nctrl, opts);
> +		if (found)
> +			break;
> +	}
> +	up_read(&nvme_tcp_ofld_ctrl_rwsem);
> +
> +	return found;
> +}
> +
>   static struct nvme_ctrl *
>   nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
>   {
> +	struct nvme_tcp_ofld_queue *queue;
>   	struct nvme_tcp_ofld_ctrl *ctrl;
>   	struct nvme_tcp_ofld_dev *dev;
>   	struct nvme_ctrl *nctrl;
> -	int rc = 0;
> +	int i, rc = 0;
>   
>   	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
>   	if (!ctrl)
>   		return ERR_PTR(-ENOMEM);
>   
> +	INIT_LIST_HEAD(&ctrl->list);
>   	nctrl = &ctrl->nctrl;
> +	nctrl->opts = opts;
> +	nctrl->queue_count = opts->nr_io_queues + opts->nr_write_queues +
> +			     opts->nr_poll_queues + 1;
> +	nctrl->sqsize = opts->queue_size - 1;
> +	nctrl->kato = opts->kato;
> +	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
> +		opts->trsvcid =
> +			kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERNEL);
> +		if (!opts->trsvcid) {
> +			rc = -ENOMEM;
> +			goto out_free_ctrl;
> +		}
> +		opts->mask |= NVMF_OPT_TRSVCID;
> +	}
>   
> -	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
> +	rc = inet_pton_with_scope(&init_net, AF_UNSPEC, opts->traddr,
> +				  opts->trsvcid,
> +				  &ctrl->conn_params.remote_ip_addr);
> +	if (rc) {
> +		pr_err("malformed address passed: %s:%s\n",
> +		       opts->traddr, opts->trsvcid);
> +		goto out_free_ctrl;
> +	}
> +
> +	if (opts->mask & NVMF_OPT_HOST_TRADDR) {
> +		rc = inet_pton_with_scope(&init_net, AF_UNSPEC,
> +					  opts->host_traddr, NULL,
> +					  &ctrl->conn_params.local_ip_addr);
> +		if (rc) {
> +			pr_err("malformed src address passed: %s\n",
> +			       opts->host_traddr);
> +			goto out_free_ctrl;
> +		}
> +	}
> +
> +	if (!opts->duplicate_connect &&
> +	    nvme_tcp_ofld_existing_controller(opts)) {
> +		rc = -EALREADY;
> +		goto out_free_ctrl;
> +	}
>   
>   	/* Find device that can reach the dest addr */
>   	dev = nvme_tcp_ofld_lookup_dev(ctrl);
> @@ -160,6 +571,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
>   		goto out_free_ctrl;
>   	}
>   
> +	rc = nvme_tcp_ofld_check_dev_opts(opts, dev->ops);
> +	if (rc)
> +		goto out_module_put;
> +
>   	ctrl->dev = dev;
>   
>   	if (ctrl->dev->ops->max_hw_sectors)
> @@ -167,22 +582,58 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
>   	if (ctrl->dev->ops->max_segments)
>   		nctrl->max_segments = ctrl->dev->ops->max_segments;
>   
> -	/* Init queues */
> +	ctrl->queues = kcalloc(nctrl->queue_count,
> +			       sizeof(struct nvme_tcp_ofld_queue),
> +			       GFP_KERNEL);
> +	if (!ctrl->queues) {
> +		rc = -ENOMEM;
> +		goto out_module_put;
> +	}
> +
> +	for (i = 0; i < nctrl->queue_count; ++i) {
> +		queue = &ctrl->queues[i];
> +		queue->ctrl = ctrl;
> +		queue->dev = dev;
> +		queue->report_err = nvme_tcp_ofld_report_queue_err;
> +		queue->hdr_digest = nctrl->opts->hdr_digest;
> +		queue->data_digest = nctrl->opts->data_digest;
> +		queue->tos = nctrl->opts->tos;
> +	}
> +
> +	rc = nvme_init_ctrl(nctrl, ndev, &nvme_tcp_ofld_ctrl_ops, 0);
> +	if (rc)
> +		goto out_free_queues;
>   
> -	/* Call nvme_init_ctrl */
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> +		WARN_ON_ONCE(1);
> +		rc = -EINTR;
> +		goto out_uninit_ctrl;
> +	}
>   
>   	rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
>   	if (rc)
> -		goto out_module_put;
> +		goto out_uninit_ctrl;
>   
>   	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
>   	if (rc)
> -		goto out_uninit_ctrl;
> +		goto out_release_ctrl;
> +
> +	dev_info(nctrl->device, "new ctrl: NQN \"%s\", addr %pISp\n",
> +		 opts->subsysnqn, &ctrl->conn_params.remote_ip_addr);
> +
> +	down_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	list_add_tail(&ctrl->list, &nvme_tcp_ofld_ctrl_list);
> +	up_write(&nvme_tcp_ofld_ctrl_rwsem);
>   
>   	return nctrl;
>   
> -out_uninit_ctrl:
> +out_release_ctrl:
>   	ctrl->dev->ops->release_ctrl(ctrl);
> +out_uninit_ctrl:
> +	nvme_uninit_ctrl(nctrl);
> +	nvme_put_ctrl(nctrl);
> +out_free_queues:
> +	kfree(ctrl->queues);
>   out_module_put:
>   	module_put(dev->ops->module);
>   out_free_ctrl:
> @@ -212,7 +663,15 @@ static int __init nvme_tcp_ofld_init_module(void)
>   
>   static void __exit nvme_tcp_ofld_cleanup_module(void)
>   {
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +
>   	nvmf_unregister_transport(&nvme_tcp_ofld_transport);
> +
> +	down_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list)
> +		nvme_delete_ctrl(&ctrl->nctrl);
> +	up_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	flush_workqueue(nvme_delete_wq);
>   }
>   
>   module_init(nvme_tcp_ofld_init_module);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
