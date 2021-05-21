Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1968438CD65
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhEUS16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:27:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48804 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbhEUS15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:27:57 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LIEvhJ032375;
        Fri, 21 May 2021 18:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FGrZ+uDZvDNfwjR3Zbb6sxV9h+SIfYPXULbCEYjhqh0=;
 b=wV50q0UySz4Dm3y4MiXzQtxWy0Qd+rp1bQpk0OYz6V8/BttDWg7W3PIxHVV3UjLE6VXl
 bFefI6tcogkS28KoUe8rZdjd56xwxWE1a+CGXFuCqpi1tUjw/VXE9djd2Sn8pnFTFgCA
 2kj+0rvY0C/XcpzerVGbrVtnMO7rhV2OkWRv1X3uhHanzluyYztOVCiwLKBwo5mTTFji
 PiPS8iV54lX4DAaWiHOEN7BXvT1x8SfYqZzF092Tvn3igDB2k+8tgo+NlmMnqT3p6ewT
 1fzJiSCUSCmtfq6D0LkFPgNa6B4XMeMpCS0bX3+IuKn8m1xVJd7ho6werHSGUFErI1uh TQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n3dg11x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:26:20 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LINHh6067702;
        Fri, 21 May 2021 18:26:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 38n49313eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:26:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwexhI+EEWW/c66bMvteTPF53ylbkBquvyZsQ4F4/q1YCAywkPwe/hKky9A7EjN2dyQLxISh8ghTrZxL4zb3CfxUnWYN+uunLe2ZEZgEV7cm9TwtmW4m3mrY+RMoqM2e0liVjjjzsLDOlsaI4igck8ejDhWppjOyFZbdCn9/3boaCZwDn4k0qkFRHTgH8698pyg6pc5yhQjW0OTLj+Ppd5rq87M7pu/9IJrKkXlXsivYljjgkKzd0k7Gv6fd9GwRW+82O5zL+ds0xlk2CCnRmYKo9KPkC5rOMWqggLihw+Gkh3Oc/c3GoYamY4+FcrD5Cr2NPx5D/lbM0rxa1b/fXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGrZ+uDZvDNfwjR3Zbb6sxV9h+SIfYPXULbCEYjhqh0=;
 b=hDhaZEfYnUwNLE+5xTZ6XmRg12TSdxUulbDV2vD/pje+LrC/0jPa8eXcMpkav8uIqV8+7M0GjtOOd1Noyhs09Sl3HHwyOcdRcFBIiqqh86tJIZxtdL9U8Q8sJ/TjmKI1tHvW+QALEoQXoBVIOgq0WgHmZnw5pdDlSm+PVLJHisDaM5W5cy7SLy/bechm/mxN2cNJT11NxNENfA/NhXkXSAWi/CZCj3VVCr/2nk2KuE1X+FxWbcebR4oEl7dmqV0y3RHRsfD/LFq3WYKZU2setAh6PUaNBMHRNhOEIFUc07tqIv1X28Yhmz4c6evMnWn4Az/eNOxE03vq5revXncjkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGrZ+uDZvDNfwjR3Zbb6sxV9h+SIfYPXULbCEYjhqh0=;
 b=IzbLwvNqFFnMoPMMWdfDvIMIY4DsZJGr4B76poFh1febN/XE0BmXvJZEQp12XeuakvTjTV5wpnlON+TkM4V+zNWaBQTE+G2dXkisaEGMsghkw35kOMirQCFHPB6hOSCjPOqFvT3pBJfeceooBj5uIXc6mBSechKT0kCiAPkzImo=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4427.namprd10.prod.outlook.com (2603:10b6:806:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 18:26:17 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 18:26:17 +0000
Subject: Re: [RFC PATCH v5 07/27] nvme-tcp-offload: Add IO level
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-8-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <de07b62f-7e85-c053-1657-2d9bee312377@oracle.com>
Date:   Fri, 21 May 2021 13:26:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-8-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0141.namprd05.prod.outlook.com
 (2603:10b6:803:2c::19) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0141.namprd05.prod.outlook.com (2603:10b6:803:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 18:26:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca7f33ed-0efb-4080-a030-08d91c85ec27
X-MS-TrafficTypeDiagnostic: SA2PR10MB4427:
X-Microsoft-Antispam-PRVS: <SA2PR10MB44270DF7834FE86D859D8F4DE6299@SA2PR10MB4427.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQuyXjz/XCBdywIAC94Hst1/WYPvaFDcEgFLWC1gJU5eDMuCKbZI+flaO1ATVTvzDWNVZOEBkXi1cKMgWvqtFtY4+0WxN2xhMRHQ/4j3FG/mkrXd4wfgHIEWB4rMZqBf32fVUwobdjUg19mbRql8B8aUfscW8zYCVuFSwzAykaiGCh0viIxFwt9dpPXzZLy5EOFWgHThwNNxBZZn0EvAnatME18g0WiUM8Ooa5bfCObWDRToB6mgOmw6SR6nSgY8qIurpyIJchkDGn5hfFM7yd2dBt619LFZBKfktyId/m87YzIxM/x8GWS7O2ImJApr4kzZ2eEWdN8BXQbBTWQVbMtFwuXGiDQ0Oi8U9r4UEZINjJvpF2IVmSWgtx10rL2JrB7RhjjGEC0csgXyBIpN+RGaZt+1iKIcJv6r8mW3nYNL020gjZAhcuNO2tupXnhkAtRjKns0bVEWp8z79F5rpq/6s35QGd0pFWLxy/X3vkRHdSjCOqp5CEWN6otlAqTA0CVLaVw+jzmZnC4joZYCy3nZhcj6jfdFD8ItDF4/HTRTObwio4d/XvsDobUjRB7dcDU5TGsL0MFtdbLWQPMG+eaAsyGMnzLOtjbKsB9M7w8nv8Q4HTcjaIUvUpz4I1egmaGOgzBCGGby3JK6E04DEygye/XJIig0yeSo4VmGfz2LLHS4nD4fb7V4rFyOgA1k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(86362001)(2616005)(83380400001)(7416002)(186003)(44832011)(16576012)(16526019)(2906002)(6486002)(8936002)(26005)(36756003)(53546011)(31696002)(956004)(66556008)(316002)(36916002)(38100700002)(8676002)(478600001)(4326008)(66476007)(66946007)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U8+lxVNHuYmWtzRv77TUR0xBdhceu1+ELorL2JbEx1cGT5ixfQhhKVoMo+BbfgO0KcxwaRnp/gzXrh+ubmth4KJRcT841+vGLH5HzL/RLOBu4ixeWaTKTcooeb4q8kLoXc9RQzz+btw/C0isgyhdNAHkKhIn7VXjQbPPv0TwinXMU5tq/RBDK+1vrNZuctSOleG6YtbPsm6iaIK7DZSdCxvK0oT2djlMA5OXfLBh/OHZSq1pyNQbIWHAyQ1ziyUsJGNE1Wk1Ae1zkXUC4Np9TERP13EdebaWjzzZkhe1OcxdbCIRZvDLrLnCr/1EFeHP0t0uI56vAn6g/pHkQSvKlYWEvUBhNw/Zkrld6onUHSvwse1Ns8z91FUu2Y+x5426e+IZYCAF5QBjb2K8IoRzHyZXx/hgtA7hwt7vznTq7RZ/dup8k8TGtJWlUkZyj6iKgGi9c6goNJ9/AoZ2wwzU1a8zb81uFt9Tp4fGepWkCaKWwLSZG7yTNyk27JKVnJz94uWUVxNmfA/N/ZEbrQwNCGn3TjmcoOnZ8TOw0/cH5HmApZi0KW/lewjOnlOibET7no/ImD+5anMLKAaDq/SPBZHDDZ9HR2SvT9y08Bqz5o2poLDKyYmosEMXmZCQFSkq0vOiXmf254tfskPYg05S7IzPwErVm3Vg1p12xGgWBxTlHQvLrs6Dgbf43mS/QtHW4jhD+tVLZQyJq0G/UTVYC9bFR2H680TVbHD2pUdwqp+1OTEvHQ16j0isVKlLoCkF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7f33ed-0efb-4080-a030-08d91c85ec27
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:26:16.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dDFAUiH2fLI6dpxf991NYx21WTKwn29cl2WbIGAqQh5ikp994ViOW75NSxSsLVRRKCnlGLdbn+N9T5a25msqcL1Bvy004NNAt+ZMoyiRAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4427
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210095
X-Proofpoint-ORIG-GUID: hPbS2ffp4U2hj3D_xEEO7YaVvYmmQkNp
X-Proofpoint-GUID: hPbS2ffp4U2hj3D_xEEO7YaVvYmmQkNp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> In this patch, we present the IO level functionality.
> The nvme-tcp-offload shall work on the IO-level, meaning the
> nvme-tcp-offload ULP module shall pass the request to the nvme-tcp-offload
> vendor driver and shall expect for the request completion.
> No additional handling is needed in between, this design will reduce the
> CPU utilization as we will describe below.
> 
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following IO-path ops:
>   - init_req
>   - send_req - in order to pass the request to the handling of the offload
>     driver that shall pass it to the vendor specific device
>   - poll_queue
> 
> The vendor driver will manage the context from which the request will be
> executed and the request aggregations.
> Once the IO completed, the nvme-tcp-offload vendor driver shall call
> command.done() that shall invoke the nvme-tcp-offload ULP layer for
> completing the request.
> 
> This patch also contains initial definition of nvme_tcp_ofld_queue_rq().
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/nvme/host/tcp-offload.c | 96 ++++++++++++++++++++++++++++++---
>   1 file changed, 88 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 8ed7668d987a..276b8475ac85 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -127,7 +127,10 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   			    union nvme_result *result,
>   			    __le16 status)
>   {
> -	/* Placeholder - complete request with/without error */
> +	struct request *rq = blk_mq_rq_from_pdu(req);
> +
> +	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), *result))
> +		nvme_complete_rq(rq);
>   }
>   
>   struct nvme_tcp_ofld_dev *
> @@ -700,6 +703,34 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   	kfree(ctrl);
>   }
>   
> +static void nvme_tcp_ofld_set_sg_null(struct nvme_command *c)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = 0;
> +	sg->length = 0;
> +	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
> +}
> +
> +inline void nvme_tcp_ofld_set_sg_inline(struct nvme_tcp_ofld_queue *queue,
> +					struct nvme_command *c, u32 data_len)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = cpu_to_le64(queue->ctrl->nctrl.icdoff);
> +	sg->length = cpu_to_le32(data_len);
> +	sg->type = (NVME_SGL_FMT_DATA_DESC << 4) | NVME_SGL_FMT_OFFSET;
> +}
> +
> +void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = 0;
> +	sg->length = cpu_to_le32(data_len);
> +	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
> +}
> +
>   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   {
>   	/* Placeholder - submit_async_event */
> @@ -855,9 +886,12 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   {
>   	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
>   	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
> +	int qid;
>   
> -	/* Placeholder - init request */
> -
> +	qid = (set == &ctrl->tag_set) ? hctx_idx + 1 : 0;
> +	req->queue = &ctrl->queues[qid];
> +	nvme_req(rq)->ctrl = &ctrl->nctrl;
> +	nvme_req(rq)->cmd = &req->nvme_cmd;
>   	req->done = nvme_tcp_ofld_req_done;
>   	ctrl->dev->ops->init_req(req);
>   
> @@ -872,16 +906,60 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
>   
>   static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
>   {
> -	/* Call ops->commit_rqs */
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	ops->commit_rqs(queue);
>   }
>   
>   static blk_status_t
>   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		       const struct blk_mq_queue_data *bd)
>   {
> -	/* Call nvme_setup_cmd(...) */
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(bd->rq);
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
> +	struct nvme_ns *ns = hctx->queue->queuedata;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +	struct nvme_command *nvme_cmd;
> +	struct request *rq;
> +	bool queue_ready;
> +	u32 data_len;
> +	int rc;
> +
> +	queue_ready = test_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> +
> +	req->rq = bd->rq;
> +	req->async = false;
> +	rq = req->rq;
> +
> +	if (!nvme_check_ready(&ctrl->nctrl, req->rq, queue_ready))
> +		return nvme_fail_nonready_command(&ctrl->nctrl, req->rq);
> +
> +	rc = nvme_setup_cmd(ns, req->rq);
> +	if (unlikely(rc))
> +		return rc;
>   
> -	/* Call ops->send_req(...) */
> +	blk_mq_start_request(req->rq);
> +	req->last = bd->last;
> +
> +	nvme_cmd = &req->nvme_cmd;
> +	nvme_cmd->common.flags |= NVME_CMD_SGL_METABUF;
> +
> +	data_len = blk_rq_nr_phys_segments(rq) ? blk_rq_payload_bytes(rq) : 0;
> +	if (!data_len)
> +		nvme_tcp_ofld_set_sg_null(&req->nvme_cmd);
> +	else if ((rq_data_dir(rq) == WRITE) &&
> +		 data_len <= nvme_tcp_ofld_inline_data_size(queue))
> +		nvme_tcp_ofld_set_sg_inline(queue, nvme_cmd, data_len);
> +	else
> +		nvme_tcp_ofld_map_data(nvme_cmd, data_len);
> +
> +	rc = ops->send_req(req);
> +	if (unlikely(rc))
> +		return rc;
>   
>   	return BLK_STS_OK;
>   }
> @@ -954,9 +1032,11 @@ static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
>   
>   static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
>   {
> -	/* Placeholder - Implement polling mechanism */
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
>   
> -	return 0;
> +	return ops->poll_queue(queue);
>   }
>   
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
