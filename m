Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2597439136
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhJYIdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:33:03 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:28512
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230019AbhJYIdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 04:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftf8s0gtGw45U3RG1rzk6Fhapceb+yTAmvWvIJpREc5u8w0qYa8XoyQcTQtfOBRvwGuGLV0vD1mgSRDfFf+3nKCPnjyVPG+wdm9h/k//LJQnzZwWQsV5gV04YUdhcN+wCL/q8dBTausHjpxiIFHRowLwbOI1x0xLyUEi53s2dLnjAZ1604zhV7mgwQgdqIJR+p4h3+Bqmr9NdQMmg3ESpnWLEHVf+WdlT6iHWqxW+79B1M9Cr6VDy/wIjrux2p4+XRn+gTXC3JFEFCN9AGlzJjvZGsQ2M8bmWXGbufR+sAZZVgdvZAmrqBs9qgmj1yw8+eagt/NVMDmmfMeYx7kRMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSuMfpSONWjPIAcX6BQqjXzhr4sa3xSKKC4Z37lKqiM=;
 b=jenb4bT+JgqgfVD4n4bdb7hzrwwyXyBKhAKtezGAngiwukeZcfW2w+XSEJtnP8CKDa8uyTaCcU+DvsqHUvD9cIYI3giYGCv1/xL1l9dO1Fbqtp98jHDU5NmxKl7LeQYeuQ6XC6iqxnf5XacxRN4QF6a4dqI3jTf0XBcmMSB8WrO2rcsblhknvKrR1k6m2RAo44+1X4id0k0V9MmDl3D3nGg3PcVuWWQhm7pfNJz9wYhXxg01g2CbLDj0D6faJeHT2jvDg+Q+kkilKrVfkzrRv0Tn+qtmz5xZHMGpFptgLjaJaT5xjpqRzJzFnkeBE2fX0smZsN7mB5gf+XvWhsiJ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSuMfpSONWjPIAcX6BQqjXzhr4sa3xSKKC4Z37lKqiM=;
 b=Zl57rbDnrVZmQziQuIQECPXBEd0Ku93EMhjPo00D0oQDfbWZLaT/JB7/EbqUDM+ljiZHzcoBImYyo6n8RH0/ifkq/XfYTQiUsWw0Wi3kiiOCYIZakodQ+bD+p42dNS1BZRbs27+vJlL652+SgQNs995iCPJVBtXTH9yuKGEDJmsxCE4KOj+TVq/Zf+OMEJlxnziojM83C3PvipfjuMjBYpDQzqqL9fle5Z1P4RfnKZPm5EDHxKmYNe60XfcLWTypiGpvA25gacy8aOnUMf9YjsrfqMwanip9htreofv1DdILn8qSbdO2aOqNPqtxTNctCfj4jyPzxKowuncl3iP1xw==
Received: from DS7PR03CA0308.namprd03.prod.outlook.com (2603:10b6:8:2b::31) by
 CY4PR1201MB2535.namprd12.prod.outlook.com (2603:10b6:903:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 08:30:37 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::ce) by DS7PR03CA0308.outlook.office365.com
 (2603:10b6:8:2b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Mon, 25 Oct 2021 08:30:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Mon, 25 Oct 2021 08:30:37 +0000
Received: from [172.27.13.250] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 08:30:34 +0000
Message-ID: <382d9360-1a3e-a027-eb46-f59c422b5ee9@nvidia.com>
Date:   Mon, 25 Oct 2021 11:30:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [mst-vhost:vhost 4/47] drivers/block/virtio_blk.c:238:24: sparse:
 sparse: incorrect type in return expression (different base types)
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        kernel test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, "Israel Rukshin" <israelr@nvidia.com>,
        Feng Li <lifeng1519@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <202110251506.OFYmNDFp-lkp@intel.com>
 <20211025034645-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211025034645-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aceddc7a-a4ce-4504-9138-08d99791b8c4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2535:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2535EC3E6F4C4036B2FFC391DE839@CY4PR1201MB2535.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M30ULslmXs6vVdGo/+WRnD0Aa5njhIj7YRAffsZ4c6/8Q/N1b0PYLVrycMsF9dfTRK0RksBKjpkO2aetAFFNVDZ35s7GSe73psHCm3P3E0XadSELcJmnY0o2w8EMkrDLny3wrThwesdltxwg8oC0ZliY8bx2a9Z5DKJmk1vZpR8pxA83mjeoXkM9hhnyYV5r4mdPilZomyiZePDqdaKiZC84Vmt2k3V5i9XnuvnjNceGB0m6z9zWIpgtVSb8lagAxhZzQVc8At8FtbBR79i5GjpqAWsCsKCZa+AF4b12L8UnanMjXkT6LewN5DLVaaxRBdgjGEKRkktXabHgnWaqE64pIkTWykGijgiqu5gQKknHohPv9+m2YUgTXobEweDkJKhfUdmsm0d4ta0d9pTD3ezu04QRfEdccHG7rQWspSPdex1uAEZI4Zp569GRMGbt0CaKdZZWKo/vH1szwiclzctB9W7ly1ymIGafGvSEj60I45Ixd0i+9aIAfjkL6P+nqV88GAM9m7OtDFwpNLS7d9rUk29RdNnIIdofZsZuKUDoeORyFMqq41/yoT32awkmR0P7g3NIAT8cmoO4ugLjMh9W21mWkRBK3CzA+nZKWtBCds86Q5N94ZA0VEXUpxR8HOl2jgjd2eQDrraqEFhwHMV/BWlGCOT/KHv5r8AWrdfy1FgH8RGPN1Tp5lkopK0LNfcUmjOEczD7r2EiPknSwENFvelGrJzn1Nc4tMHFHYxZj0ocxUBA9f6Z64xCT0yt7nS1lj7QLh7iw0fiYKtk3zg/zKzoGUlFmZTaFD4HQmM/u9hpt0+mD9eZheXC/8xIyfzozGqmz5Jp/67U9cVbv3/NYiJvGuZHvZcOhtFKsTM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(426003)(336012)(47076005)(86362001)(186003)(31686004)(6666004)(16526019)(966005)(83380400001)(82310400003)(356005)(508600001)(26005)(36756003)(45080400002)(70586007)(31696002)(7636003)(8936002)(36860700001)(316002)(5660300002)(53546011)(2906002)(8676002)(16576012)(110136005)(70206006)(54906003)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 08:30:37.4318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aceddc7a-a4ce-4504-9138-08d99791b8c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2535
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/25/2021 10:59 AM, Michael S. Tsirkin wrote:
> On Mon, Oct 25, 2021 at 03:24:16PM +0800, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
>> head:   2b109044b081148b58974f5696ffd4383c3e9abb
>> commit: b2c5221fd074fbb0e57d6707bed5b7386bf430ed [4/47] virtio-blk: avoid preallocating big SGL for data
>> config: i386-randconfig-s001-20211025 (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>> reproduce:
>>          # apt-get install sparse
>>          # sparse version: v0.6.4-dirty
>>          # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=b2c5221fd074fbb0e57d6707bed5b7386bf430ed
>>          git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>>          git fetch --no-tags mst-vhost vhost
>>          git checkout b2c5221fd074fbb0e57d6707bed5b7386bf430ed
>>          # save the attached .config to linux build tree
>>          make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=i386
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>
> Patch sent. Max can you take a look pls?

I think it will disappear after your patch with the returned status values.


>> sparse warnings: (new ones prefixed by >>)
>>>> drivers/block/virtio_blk.c:238:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted blk_status_t [usertype] @@
>>     drivers/block/virtio_blk.c:238:24: sparse:     expected int
>>     drivers/block/virtio_blk.c:238:24: sparse:     got restricted blk_status_t [usertype]
>>     drivers/block/virtio_blk.c:246:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted blk_status_t [usertype] @@
>>     drivers/block/virtio_blk.c:246:32: sparse:     expected int
>>     drivers/block/virtio_blk.c:246:32: sparse:     got restricted blk_status_t [usertype]
>>>> drivers/block/virtio_blk.c:320:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted blk_status_t @@     got int [assigned] err @@
>>     drivers/block/virtio_blk.c:320:24: sparse:     expected restricted blk_status_t
>>     drivers/block/virtio_blk.c:320:24: sparse:     got int [assigned] err
>>
>> vim +238 drivers/block/virtio_blk.c
>>
>>     203	
>>     204	static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
>>     205			struct virtblk_req *vbr)
>>     206	{
>>     207		bool unmap = false;
>>     208		u32 type;
>>     209	
>>     210		vbr->out_hdr.sector = 0;
>>     211	
>>     212		switch (req_op(req)) {
>>     213		case REQ_OP_READ:
>>     214			type = VIRTIO_BLK_T_IN;
>>     215			vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>>     216							      blk_rq_pos(req));
>>     217			break;
>>     218		case REQ_OP_WRITE:
>>     219			type = VIRTIO_BLK_T_OUT;
>>     220			vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>>     221							      blk_rq_pos(req));
>>     222			break;
>>     223		case REQ_OP_FLUSH:
>>     224			type = VIRTIO_BLK_T_FLUSH;
>>     225			break;
>>     226		case REQ_OP_DISCARD:
>>     227			type = VIRTIO_BLK_T_DISCARD;
>>     228			break;
>>     229		case REQ_OP_WRITE_ZEROES:
>>     230			type = VIRTIO_BLK_T_WRITE_ZEROES;
>>     231			unmap = !(req->cmd_flags & REQ_NOUNMAP);
>>     232			break;
>>     233		case REQ_OP_DRV_IN:
>>     234			type = VIRTIO_BLK_T_GET_ID;
>>     235			break;
>>     236		default:
>>     237			WARN_ON_ONCE(1);
>>   > 238			return BLK_STS_IOERR;
>>     239		}
>>     240	
>>     241		vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
>>     242		vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
>>     243	
>>     244		if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
>>     245			if (virtblk_setup_discard_write_zeroes(req, unmap))
>>     246				return BLK_STS_RESOURCE;
>>     247		}
>>     248	
>>     249		return 0;
>>     250	}
>>     251	
>>     252	static inline void virtblk_request_done(struct request *req)
>>     253	{
>>     254		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>     255	
>>     256		virtblk_unmap_data(req, vbr);
>>     257		virtblk_cleanup_cmd(req);
>>     258		blk_mq_end_request(req, virtblk_result(vbr));
>>     259	}
>>     260	
>>     261	static void virtblk_done(struct virtqueue *vq)
>>     262	{
>>     263		struct virtio_blk *vblk = vq->vdev->priv;
>>     264		bool req_done = false;
>>     265		int qid = vq->index;
>>     266		struct virtblk_req *vbr;
>>     267		unsigned long flags;
>>     268		unsigned int len;
>>     269	
>>     270		spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>>     271		do {
>>     272			virtqueue_disable_cb(vq);
>>     273			while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
>>     274				struct request *req = blk_mq_rq_from_pdu(vbr);
>>     275	
>>     276				if (likely(!blk_should_fake_timeout(req->q)))
>>     277					blk_mq_complete_request(req);
>>     278				req_done = true;
>>     279			}
>>     280			if (unlikely(virtqueue_is_broken(vq)))
>>     281				break;
>>     282		} while (!virtqueue_enable_cb(vq));
>>     283	
>>     284		/* In case queue is stopped waiting for more buffers. */
>>     285		if (req_done)
>>     286			blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
>>     287		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>     288	}
>>     289	
>>     290	static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>     291	{
>>     292		struct virtio_blk *vblk = hctx->queue->queuedata;
>>     293		struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>     294		bool kick;
>>     295	
>>     296		spin_lock_irq(&vq->lock);
>>     297		kick = virtqueue_kick_prepare(vq->vq);
>>     298		spin_unlock_irq(&vq->lock);
>>     299	
>>     300		if (kick)
>>     301			virtqueue_notify(vq->vq);
>>     302	}
>>     303	
>>     304	static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>     305				   const struct blk_mq_queue_data *bd)
>>     306	{
>>     307		struct virtio_blk *vblk = hctx->queue->queuedata;
>>     308		struct request *req = bd->rq;
>>     309		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>     310		unsigned long flags;
>>     311		unsigned int num;
>>     312		int qid = hctx->queue_num;
>>     313		int err;
>>     314		bool notify = false;
>>     315	
>>     316		BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>>     317	
>>     318		err = virtblk_setup_cmd(vblk->vdev, req, vbr);
>>     319		if (unlikely(err))
>>   > 320			return err;
>>     321	
>>     322		blk_mq_start_request(req);
>>     323	
>>     324		num = virtblk_map_data(hctx, req, vbr);
>>     325		if (unlikely(num < 0)) {
>>     326			virtblk_cleanup_cmd(req);
>>     327			return BLK_STS_RESOURCE;
>>     328		}
>>     329	
>>     330		spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>>     331		err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>>     332		if (err) {
>>     333			virtqueue_kick(vblk->vqs[qid].vq);
>>     334			/* Don't stop the queue if -ENOMEM: we may have failed to
>>     335			 * bounce the buffer due to global resource outage.
>>     336			 */
>>     337			if (err == -ENOSPC)
>>     338				blk_mq_stop_hw_queue(hctx);
>>     339			spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>     340			virtblk_unmap_data(req, vbr);
>>     341			virtblk_cleanup_cmd(req);
>>     342			switch (err) {
>>     343			case -ENOSPC:
>>     344				return BLK_STS_DEV_RESOURCE;
>>     345			case -ENOMEM:
>>     346				return BLK_STS_RESOURCE;
>>     347			default:
>>     348				return BLK_STS_IOERR;
>>     349			}
>>     350		}
>>     351	
>>     352		if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>>     353			notify = true;
>>     354		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>     355	
>>     356		if (notify)
>>     357			virtqueue_notify(vblk->vqs[qid].vq);
>>     358		return BLK_STS_OK;
>>     359	}
>>     360	
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.01.org%2Fhyperkitty%2Flist%2Fkbuild-all%40lists.01.org&amp;data=04%7C01%7Cmgurtovoy%40nvidia.com%7Cbf2909ef00c34a40373708d9978d58cd%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637707455621298762%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=BbUjkMGWBZUAfGJLrUOG625%2FU%2BvhXzkBBYAhdy8vQ4U%3D&amp;reserved=0
>
