Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9714538CD15
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhEUSUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:20:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55414 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhEUSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:20:21 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LIGMpM021067;
        Fri, 21 May 2021 18:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/nYnwL4rws4nbBaN6oktsc/gousDx+c/e0outMefDUY=;
 b=krhVzenjZ6nfZhqV2+SIhtz8exBFnzfsW0kXAz31jIRFagB4KCowjjJWjBX6UPrNTaoV
 ohhjNv7r77BOxv7Ncrto+xIy7zwDrQXDJxwudPg9FplJ8VQ0mmrlD03plGvcb++Wasjn
 y0aCmVZfpC+/+0DAOlb0F67VepnHpufsJTaIxCWPwG/DUJix4x4MN1aG7BXfpiQfGk2r
 REapDHBbRDRAE+a2mhWwp7mFd0CDL7E/s/dSlG2p6PsNnUlufPLmNxZLsvjpMNlJiarv
 h1KYtzUAM6ZFLL4BZW+nKKTRhfyWaWBP/0dBUoEKcKQApTco+mb/rckUlmhFkWyD1Cyr NA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38nuuwgep2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:18:45 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LIIh07059564;
        Fri, 21 May 2021 18:18:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 38n4930ybc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIMw93rnCPtvLrQ5KFW8Vf8toZRnco+EDleW9+gTqPdpAej7TrYCLOTwewwT/vgg0SuuxfeFMbj3WnFt2rAVBuKLlSXVHnnL85dhYLvZZp3cIRTFWqdrxkPieC9IJGeDVUmpntawRSL9LYcGyMKnpRifaqcWjqQhRWLGxywAUaJlnubxxHIRtV5yZ091jw/uU2HxlieG8rz9Im0NJsDJucOUFRJ9LrMRmhKXZsjxBmKhap1W2RRGmFcAatmZpdXmKWwKlk2TApC7jxn7UV6uo03JUIcHjb5IuuT/y86U0BROV545LxqV8+DRbIWxf/uQdXl28nEDmslc4dCt25yBXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nYnwL4rws4nbBaN6oktsc/gousDx+c/e0outMefDUY=;
 b=SufwRTx+hV877i6MIuedzAWywIAmYZm+BBK33BV7Nvq7jtF3wraMBDGEkVC0iwepoiXVcVFH9ww7AtYCcmqMBJIxO6DCSmi8G6UxrKGYO0aFMehijQpWqsVAI5YeqM2LbERlJ4IiEKsZkRKdOt8jpiB8OEFFFvua0+OIbdo5ryLM4lEMuF52rxDYT664d7uUM/v1iL4an+Z2wYt3pX4a5jU07d6aJBBg9E9ptLzR5I+PB/vAapLsqHBCOcp2uZHYqm9UpDGVUV6ldBxDFi1/7TyU49jFzWBBXzq6lmDlxz2WN1ginmM9/VQTiKD1p2eePZy1Ro5r9hZtgAgIKb6w/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nYnwL4rws4nbBaN6oktsc/gousDx+c/e0outMefDUY=;
 b=MCCjxM/xpbVr+z5uHraJP+zcxEvmmtAbU2U2idJItB12W91TPWqietlCnG3wkqcBkT5bumuRvJ25LkHeiQ29EgYh7bG988LQcenXbT9ov4vUyRm+smeDoqedKadS3uIc/5mjUQGBKQU9avoWu8m9geWTGUcPol11kNKq58gACQg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4556.namprd10.prod.outlook.com (2603:10b6:806:119::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 21 May
 2021 18:18:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 18:18:41 +0000
Subject: Re: [RFC PATCH v5 06/27] nvme-tcp-offload: Add queue level
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-7-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <bed25d20-47f0-3583-9de1-d93a7827b860@oracle.com>
Date:   Fri, 21 May 2021 13:18:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-7-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0701CA0003.namprd07.prod.outlook.com
 (2603:10b6:803:28::13) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0701CA0003.namprd07.prod.outlook.com (2603:10b6:803:28::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 18:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9f09795-3699-4ba6-06b5-08d91c84dc71
X-MS-TrafficTypeDiagnostic: SA2PR10MB4556:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4556A89A4E96752B632A5FF6E6299@SA2PR10MB4556.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOZxIaX3egmAeQYNVRZIvwhCsnIZ7K8+VotsDngCjBvrKDa+BVscqqfa9ny/yKCDu/ODZZh2uhh9f9QGIxXhK4z+ipWMKy30mx6/PFocgHNC33wpIwOpnvF0GD0amQSgkTk25R6lBquwyCkgVY9MNmMttldiERKf8B6zrWM2VblnQkL20o2O2mvGfWIvwIu+9MVjUUkEISQ4avfNaI0Xn541NbuPsxcYUjkT3Ri5DDdPhpLrObSmh2RDuOUWzOixXHKsaEZKQcS6dQgTgX1UWvCYgTaNEU29+nr99Qe1OK5pdRdrZ+F8NsPxDXhDRVIpMvB5//MWZtfP7fS8ykwBvUXVLirbrU7Km8OdAEbkTLldk6y5Irnyt9ECkChgKcJaXatpITeObJN4b+EeW+wTsWJcaEKVpbMu9y6bOLJTMSQ8bL5+J4dnmVkn1hSUTggPskCBvHCcdbRw7+wSOu++mFbPZg9DTZ9RpcJX4Jbj8E66sHMrAbUeLgRBbgqo00VZ0mepNQ0eiTtQJHra7pENCm0pq/H9FNtTvPeF9Jpn5T0AS+dMsMoXaHxZUlKw+aUXGy5+bmph+mMaxPnTODZZ5ICu7thwtv0eMCK4xnr3qIqbuWstkZshf9OwNYLPD4zBv64+forZlSHRB4dY8mNMFofkl+SvN7OqeYBcq56RutqbdPxkfpLdy/JzwyFFUpmD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(316002)(66556008)(66476007)(31686004)(6486002)(8676002)(83380400001)(8936002)(66946007)(2616005)(5660300002)(4326008)(16576012)(956004)(30864003)(44832011)(26005)(36916002)(7416002)(38100700002)(86362001)(53546011)(2906002)(31696002)(36756003)(16526019)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UuzbhzeCN/nXGxl/yUvLc1wKQQPHGorgIUHv6G4oTnyn8Npe4mNTmmqDp2oe5dvw/0NTPtg6RC0G3CA5HcUcb4MzSouWl1c5I9Pe4CLXUDapMiuTwal7qSUMKK/okYQNewzcu0aBe+hIxUKULS/V1oB4IbbZidxtOE2Zf2CElv2WfPKwBnUQmcIh6r4fc4Z3IWHm5gwNKkUy8kJcaU2e35C/jmWRqEggot/ZnZc5ZVuXT8/EN2C+J1tgvCbI1lJ0Z+7FTZbccI+hjSi6fWZaRgda0hferUoPUvw2WGAJgPTy+UXu6kHs9nHTPm6IMvs6IQHLAHR3SgFtelyHcAHeriCuXQ8q8Y7n3LuDcV+YuTxIYke036Uxm1acc/ZksedAs25ZEMHeOOuDUet/C5sgBN7HmbjO+MReNp+2/FqaZvS2N2qDAzy612KeNhtKOp3kbG598xzya9pES7YVBUx/ImHRx8vI4bAE8LpDqedUfKgJ//GUGEgSjW+nn2YrGxmhDro6KeOo7Pjy8OTkaju9ImMpwk6NMrvsEYS9vAmwOUJ/r0YZ1ffAnfwufJtB/pTbw9UM12ukHZAl+1YhI3wibLwn8mcS9yQTMnP59FsJP0vRvcTmTjz027tLxtKyfUjiRvdzN8U2SxGKNytWlDqfyoZI1VvLsW7yCItr16yusnncdQifcDjY4DYvh5HyUe8ABPj+ynxKcM1fgIr8JUUG5Y40DfjnO3aK3H2t79AhUhdYlUqBOhx5lEYpt2ULJoA+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f09795-3699-4ba6-06b5-08d91c84dc71
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:18:41.1450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWebuGTXc/fKDcq95V5bVVmAA590k94Ch/eq1l6NCHjw5/BYQja6gNAaO5ivnkdMdC3uqh0vI5GmH2HzQ+PCSo4RMDf9LZhQBVe4sFDCvuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4556
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210095
X-Proofpoint-ORIG-GUID: DkatYIk9EJ6Xpzngl7A_3TSxnr9tpJUJ
X-Proofpoint-GUID: DkatYIk9EJ6Xpzngl7A_3TSxnr9tpJUJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> In this patch we implement queue level functionality.
> The implementation is similar to the nvme-tcp module, the main
> difference being that we call the vendor specific create_queue op which
> creates the TCP connection, and NVMeTPC connection including
> icreq+icresp negotiation.
> Once create_queue returns successfully, we can move on to the fabrics
> connect.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 424 ++++++++++++++++++++++++++++++--
>   drivers/nvme/host/tcp-offload.h |   1 +
>   2 files changed, 399 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 9eb4b03e0f3d..8ed7668d987a 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -22,6 +22,11 @@ static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctr
>   	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
>   }
>   
> +static inline int nvme_tcp_ofld_qid(struct nvme_tcp_ofld_queue *queue)
> +{
> +	return queue - queue->ctrl->queues;
> +}
> +
>   /**
>    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
>    * function.
> @@ -191,12 +196,94 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
>   	return set;
>   }
>   
> +static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *queue)
> +{
> +	queue->dev->ops->drain_queue(queue);
> +	queue->dev->ops->destroy_queue(queue);
> +}
> +
> +static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +
> +	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
> +		return;
> +
> +	__nvme_tcp_ofld_stop_queue(queue);
> +}
> +
> +static void nvme_tcp_ofld_stop_io_queues(struct nvme_ctrl *ctrl)
> +{
> +	int i;
> +
> +	for (i = 1; i < ctrl->queue_count; i++)
> +		nvme_tcp_ofld_stop_queue(ctrl, i);
> +}
> +
> +static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +
> +	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
> +		return;
> +
> +	queue = &ctrl->queues[qid];
> +	queue->ctrl = NULL;
> +	queue->dev = NULL;
> +	queue->report_err = NULL;
> +}
> +
> +static void nvme_tcp_ofld_destroy_admin_queue(struct nvme_ctrl *nctrl, bool remove)
> +{
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	if (remove) {
> +		blk_cleanup_queue(nctrl->admin_q);
> +		blk_cleanup_queue(nctrl->fabrics_q);
> +		blk_mq_free_tag_set(nctrl->admin_tagset);
> +	}
> +}
> +
> +static int nvme_tcp_ofld_start_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +	int rc;
> +
> +	queue = &ctrl->queues[qid];
> +	if (qid) {
> +		queue->cmnd_capsule_len = nctrl->ioccsz * 16;
> +		rc = nvmf_connect_io_queue(nctrl, qid, false);
> +	} else {
> +		queue->cmnd_capsule_len = sizeof(struct nvme_command) + NVME_TCP_ADMIN_CCSZ;
> +		rc = nvmf_connect_admin_queue(nctrl);
> +	}
> +
> +	if (!rc) {
> +		set_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> +	} else {
> +		if (test_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
> +			__nvme_tcp_ofld_stop_queue(queue);
> +		dev_err(nctrl->device,
> +			"failed to connect queue: %d ret=%d\n", qid, rc);
> +	}
> +
> +	return rc;
> +}
> +
>   static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   					       bool new)
>   {
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
>   	int rc;
>   
> -	/* Placeholder - alloc_admin_queue */
> +	rc = ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
> +	if (rc)
> +		return rc;
> +
> +	set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
>   	if (new) {
>   		nctrl->admin_tagset =
>   				nvme_tcp_ofld_alloc_tagset(nctrl, true);
> @@ -221,7 +308,9 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   		}
>   	}
>   
> -	/* Placeholder - nvme_tcp_ofld_start_queue */
> +	rc = nvme_tcp_ofld_start_queue(nctrl, 0);
> +	if (rc)
> +		goto out_cleanup_queue;
>   
>   	rc = nvme_enable_ctrl(nctrl);
>   	if (rc)
> @@ -238,11 +327,12 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   out_quiesce_queue:
>   	blk_mq_quiesce_queue(nctrl->admin_q);
>   	blk_sync_queue(nctrl->admin_q);
> -
>   out_stop_queue:
> -	/* Placeholder - stop offload queue */
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
>   	nvme_cancel_admin_tagset(nctrl);
> -
> +out_cleanup_queue:
> +	if (new)
> +		blk_cleanup_queue(nctrl->admin_q);
>   out_cleanup_fabrics_q:
>   	if (new)
>   		blk_cleanup_queue(nctrl->fabrics_q);
> @@ -250,7 +340,136 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   	if (new)
>   		blk_mq_free_tag_set(nctrl->admin_tagset);
>   out_free_queue:
> -	/* Placeholder - free admin queue */
> +	nvme_tcp_ofld_free_queue(nctrl, 0);
> +
> +	return rc;
> +}
> +
> +static unsigned int nvme_tcp_ofld_nr_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
> +	u32 hw_vectors = dev->num_hw_vectors;
> +	u32 nr_write_queues, nr_poll_queues;
> +	u32 nr_io_queues, nr_total_queues;
> +
> +	nr_io_queues = min3(nctrl->opts->nr_io_queues, num_online_cpus(),
> +			    hw_vectors);
> +	nr_write_queues = min3(nctrl->opts->nr_write_queues, num_online_cpus(),
> +			       hw_vectors);
> +	nr_poll_queues = min3(nctrl->opts->nr_poll_queues, num_online_cpus(),
> +			      hw_vectors);
> +
> +	nr_total_queues = nr_io_queues + nr_write_queues + nr_poll_queues;
> +
> +	return nr_total_queues;
> +}
> +
> +static void
> +nvme_tcp_ofld_set_io_queues(struct nvme_ctrl *nctrl, unsigned int nr_io_queues)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvmf_ctrl_options *opts = nctrl->opts;
> +
> +	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
> +		/*
> +		 * separate read/write queues
> +		 * hand out dedicated default queues only after we have
> +		 * sufficient read queues.
> +		 */
> +		ctrl->io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
> +		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
> +			min(opts->nr_write_queues, nr_io_queues);
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	} else {
> +		/*
> +		 * shared read/write queues
> +		 * either no write queues were requested, or we don't have
> +		 * sufficient queue count to have dedicated default queues.
> +		 */
> +		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
> +			min(opts->nr_io_queues, nr_io_queues);
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	}
> +
> +	if (opts->nr_poll_queues && nr_io_queues) {
> +		/* map dedicated poll queues only if we have queues left */
> +		ctrl->io_queues[HCTX_TYPE_POLL] =
> +			min(opts->nr_poll_queues, nr_io_queues);
> +	}
> +}
> +
> +static void
> +nvme_tcp_ofld_terminate_io_queues(struct nvme_ctrl *nctrl, int start_from)
> +{
> +	int i;
> +
> +	/* Loop condition will stop before index 0 which is the admin queue */
> +	for (i = start_from; i >= 1; i--)
> +		nvme_tcp_ofld_stop_queue(nctrl, i);
> +}
> +
> +static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	int i, rc;
> +
> +	for (i = 1; i < nctrl->queue_count; i++) {
> +		rc = ctrl->dev->ops->create_queue(&ctrl->queues[i],
> +						  i, nctrl->sqsize + 1);
> +		if (rc)
> +			goto out_free_queues;
> +
> +		set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &ctrl->queues[i].flags);
> +	}
> +
> +	return 0;
> +
> +out_free_queues:
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
> +
> +	return rc;
> +}
> +
> +static int nvme_tcp_ofld_alloc_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	unsigned int nr_io_queues;
> +	int rc;
> +
> +	nr_io_queues = nvme_tcp_ofld_nr_io_queues(nctrl);
> +	rc = nvme_set_queue_count(nctrl, &nr_io_queues);
> +	if (rc)
> +		return rc;
> +
> +	nctrl->queue_count = nr_io_queues + 1;
> +	if (nctrl->queue_count < 2) {
> +		dev_err(nctrl->device,
> +			"unable to set any I/O queues\n");
> +
> +		return -ENOMEM;
> +	}
> +
> +	dev_info(nctrl->device, "creating %d I/O queues.\n", nr_io_queues);
> +	nvme_tcp_ofld_set_io_queues(nctrl, nr_io_queues);
> +
> +	return nvme_tcp_ofld_create_io_queues(nctrl);
> +}
> +
> +static int nvme_tcp_ofld_start_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	int i, rc = 0;
> +
> +	for (i = 1; i < nctrl->queue_count; i++) {
> +		rc = nvme_tcp_ofld_start_queue(nctrl, i);
> +		if (rc)
> +			goto terminate_queues;
> +	}
> +
> +	return 0;
> +
> +terminate_queues:
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
>   
>   	return rc;
>   }
> @@ -258,9 +477,10 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   static int
>   nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   {
> -	int rc;
> +	int rc = nvme_tcp_ofld_alloc_io_queues(nctrl);
>   
> -	/* Placeholder - alloc_io_queues */
> +	if (rc)
> +		return rc;
>   
>   	if (new) {
>   		nctrl->tagset = nvme_tcp_ofld_alloc_tagset(nctrl, false);
> @@ -278,7 +498,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   		}
>   	}
>   
> -	/* Placeholder - start_io_queues */
> +	rc = nvme_tcp_ofld_start_io_queues(nctrl);
> +	if (rc)
> +		goto out_cleanup_connect_q;
>   
>   	if (!new) {
>   		nvme_start_queues(nctrl);
> @@ -300,16 +522,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   out_wait_freeze_timed_out:
>   	nvme_stop_queues(nctrl);
>   	nvme_sync_io_queues(nctrl);
> -
> -	/* Placeholder - Stop IO queues */
> -
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +out_cleanup_connect_q:
> +	nvme_cancel_tagset(nctrl);
>   	if (new)
>   		blk_cleanup_queue(nctrl->connect_q);
>   out_free_tag_set:
>   	if (new)
>   		blk_mq_free_tag_set(nctrl->tagset);
>   out_free_io_queues:
> -	/* Placeholder - free_io_queues */
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, nctrl->queue_count);
>   
>   	return rc;
>   }
> @@ -336,6 +558,26 @@ static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
>   	}
>   }
>   
> +static int
> +nvme_tcp_ofld_init_admin_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			      unsigned int hctx_idx)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = data;
> +
> +	hctx->driver_data = &ctrl->queues[0];
> +
> +	return 0;
> +}
> +
> +static void nvme_tcp_ofld_destroy_io_queues(struct nvme_ctrl *nctrl, bool remove)
> +{
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +	if (remove) {
> +		blk_cleanup_queue(nctrl->connect_q);
> +		blk_mq_free_tag_set(nctrl->tagset);
> +	}
> +}
> +
>   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   {
>   	struct nvmf_ctrl_options *opts = nctrl->opts;
> @@ -392,9 +634,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   	return 0;
>   
>   destroy_io:
> -	/* Placeholder - stop and destroy io queues*/
> +	if (nctrl->queue_count > 1) {
> +		nvme_stop_queues(nctrl);
> +		nvme_sync_io_queues(nctrl);
> +		nvme_tcp_ofld_stop_io_queues(nctrl);
> +		nvme_cancel_tagset(nctrl);
> +		nvme_tcp_ofld_destroy_io_queues(nctrl, new);
> +	}
>   destroy_admin:
> -	/* Placeholder - stop and destroy admin queue*/
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	blk_sync_queue(nctrl->admin_q);
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	nvme_cancel_admin_tagset(nctrl);
> +	nvme_tcp_ofld_destroy_admin_queue(nctrl, new);
>   
>   	return rc;
>   }
> @@ -415,6 +667,18 @@ nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
>   	return 0;
>   }
>   
> +static void nvme_tcp_ofld_free_ctrl_queues(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	int i;
> +
> +	for (i = 0; i < nctrl->queue_count; ++i)
> +		nvme_tcp_ofld_free_queue(nctrl, i);
> +
> +	kfree(ctrl->queues);
> +	ctrl->queues = NULL;
> +}
> +
>   static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   {
>   	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> @@ -424,6 +688,7 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   		goto free_ctrl;
>   
>   	down_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	nvme_tcp_ofld_free_ctrl_queues(nctrl);
>   	ctrl->dev->ops->release_ctrl(ctrl);
>   	list_del(&ctrl->list);
>   	up_write(&nvme_tcp_ofld_ctrl_rwsem);
> @@ -441,15 +706,37 @@ static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   }
>   
>   static void
> -nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove)
> +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remove)
>   {
> -	/* Placeholder - teardown_admin_queue */
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	blk_sync_queue(nctrl->admin_q);
> +
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	nvme_cancel_admin_tagset(nctrl);
> +
> +	if (remove)
> +		blk_mq_unquiesce_queue(nctrl->admin_q);
> +
> +	nvme_tcp_ofld_destroy_admin_queue(nctrl, remove);
>   }
>   
>   static void
>   nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
>   {
> -	/* Placeholder - teardown_io_queues */
> +	if (nctrl->queue_count <= 1)
> +		return;
> +
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	nvme_start_freeze(nctrl);
> +	nvme_stop_queues(nctrl);
> +	nvme_sync_io_queues(nctrl);
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +	nvme_cancel_tagset(nctrl);
> +
> +	if (remove)
> +		nvme_start_queues(nctrl);
> +
> +	nvme_tcp_ofld_destroy_io_queues(nctrl, remove);
>   }
>   
>   static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
> @@ -577,6 +864,17 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   	return 0;
>   }
>   
> +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue)
> +{
> +	return queue->cmnd_capsule_len - sizeof(struct nvme_command);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
> +
> +static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +	/* Call ops->commit_rqs */
> +}
> +
>   static blk_status_t
>   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		       const struct blk_mq_queue_data *bd)
> @@ -588,22 +886,96 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	return BLK_STS_OK;
>   }
>   
> +static void
> +nvme_tcp_ofld_exit_request(struct blk_mq_tag_set *set,
> +			   struct request *rq, unsigned int hctx_idx)
> +{
> +	/*
> +	 * Nothing is allocated in nvme_tcp_ofld_init_request,
> +	 * hence empty.
> +	 */
> +}
> +
> +static int
> +nvme_tcp_ofld_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			unsigned int hctx_idx)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = data;
> +
> +	hctx->driver_data = &ctrl->queues[hctx_idx + 1];
> +
> +	return 0;
> +}
> +
> +static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
> +	struct nvmf_ctrl_options *opts = ctrl->nctrl.opts;
> +
> +	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
> +		/* separate read/write queues */
> +		set->map[HCTX_TYPE_DEFAULT].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
> +		set->map[HCTX_TYPE_READ].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_READ];
> +		set->map[HCTX_TYPE_READ].queue_offset =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	} else {
> +		/* shared read/write queues */
> +		set->map[HCTX_TYPE_DEFAULT].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
> +		set->map[HCTX_TYPE_READ].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_READ].queue_offset = 0;
> +	}
> +	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
> +	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
> +
> +	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
> +		/* map dedicated poll queues only if we have queues left */
> +		set->map[HCTX_TYPE_POLL].nr_queues =
> +				ctrl->io_queues[HCTX_TYPE_POLL];
> +		set->map[HCTX_TYPE_POLL].queue_offset =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
> +			ctrl->io_queues[HCTX_TYPE_READ];
> +		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
> +	}
> +
> +	dev_info(ctrl->nctrl.device,
> +		 "mapped %d/%d/%d default/read/poll queues.\n",
> +		 ctrl->io_queues[HCTX_TYPE_DEFAULT],
> +		 ctrl->io_queues[HCTX_TYPE_READ],
> +		 ctrl->io_queues[HCTX_TYPE_POLL]);
> +
> +	return 0;
> +}
> +
> +static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
> +{
> +	/* Placeholder - Implement polling mechanism */
> +
> +	return 0;
> +}
> +
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.commit_rqs     = nvme_tcp_ofld_commit_rqs,
> +	.complete	= nvme_complete_rq,
>   	.init_request	= nvme_tcp_ofld_init_request,
> -	/*
> -	 * All additional ops will be also implemented and registered similar to
> -	 * tcp.c
> -	 */
> +	.exit_request	= nvme_tcp_ofld_exit_request,
> +	.init_hctx	= nvme_tcp_ofld_init_hctx,
> +	.map_queues	= nvme_tcp_ofld_map_queues,
> +	.poll		= nvme_tcp_ofld_poll,
>   };
>   
>   static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.complete	= nvme_complete_rq,
>   	.init_request	= nvme_tcp_ofld_init_request,
> -	/*
> -	 * All additional ops will be also implemented and registered similar to
> -	 * tcp.c
> -	 */
> +	.exit_request	= nvme_tcp_ofld_exit_request,
> +	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
>   };
>   
>   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index 2a931d05905d..2233d855aa10 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -211,3 +211,4 @@ struct nvme_tcp_ofld_ops {
>   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
