Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6373A4390BB
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 09:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhJYIBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:01:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232093AbhJYIBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635148754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q04iVz1hDDZHwQhitRW4nEgXkPCLMuRbW0JSH/7gDj8=;
        b=Xpjo0vlPHjCZua63JlsGZ9zS9zIRykVvyIPXml3RXKVL3OfibEuBxcYGe+aSQH011KlVwU
        gwOhzIUQTHkTD37DobI3wJ582f8aaaWNTLnuygEUReOYk7k5ONwgfpVKBaCZ4S6vxnSVAc
        AEbgCCP+EtUGVht4HjCrAXbdwNu1/gU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-liNy9nAMNjW87tn7YTOnmA-1; Mon, 25 Oct 2021 03:59:13 -0400
X-MC-Unique: liNy9nAMNjW87tn7YTOnmA-1
Received: by mail-ed1-f72.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so9034503edj.21
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 00:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q04iVz1hDDZHwQhitRW4nEgXkPCLMuRbW0JSH/7gDj8=;
        b=44GI48947+4BzIHSK1AUO0iOnOnQECsbvYkxIVHf4OwHzlOPQrGncs842UvR4WWqMw
         +we9KrhjHnHFlfgIhyTQGhnsOpFjNt7BnAowT3GQ8q1DDnggJN3NPBDNxkxAeFPauxu8
         ZZD+6z46vpwwf7KD1h/mjosLgSyODXzzydoj5PlqJdh7ppZjRU8DFO19Nd1nXvpSee6o
         F+K4Z8MBHZk5Dj4bIxNyXQzlXMj5gafa29u+Y9//E5bmhh8b9BESMRdbcH/TZ4pYMKqB
         RIdsNmlkx/mxVgfYm5da2X4d8M+mFQsn9+oHRD3nBeMJIAUMwObUNRws3oz/yYj2lrqp
         so1Q==
X-Gm-Message-State: AOAM531zcyhHJs4EvAsEy10nVIdDjGbmZoUlcI/ROmYG82yTmCk0MXia
        i7SdI49LxHu3wtrfElWSNYL/BHut26BDQmw1+dfTdhmuiW8jz6h2Bf8b/vtm69XzJ7K5H6UwAql
        XS0dlXgSStJacbwn6
X-Received: by 2002:a17:906:12d0:: with SMTP id l16mr3418132ejb.415.1635148751621;
        Mon, 25 Oct 2021 00:59:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8eMDBf77eHe46Uh3ELHYmE/FONquQfABgzYHv8qlxAf37AXr/2pUt9N94dzZqr3jYBxpbJQ==
X-Received: by 2002:a17:906:12d0:: with SMTP id l16mr3418119ejb.415.1635148751444;
        Mon, 25 Oct 2021 00:59:11 -0700 (PDT)
Received: from redhat.com ([2.55.151.113])
        by smtp.gmail.com with ESMTPSA id ec18sm3818032edb.21.2021.10.25.00.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 00:59:10 -0700 (PDT)
Date:   Mon, 25 Oct 2021 03:59:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Feng Li <lifeng1519@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [mst-vhost:vhost 4/47] drivers/block/virtio_blk.c:238:24:
 sparse: sparse: incorrect type in return expression (different base types)
Message-ID: <20211025034645-mutt-send-email-mst@kernel.org>
References: <202110251506.OFYmNDFp-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202110251506.OFYmNDFp-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 03:24:16PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   2b109044b081148b58974f5696ffd4383c3e9abb
> commit: b2c5221fd074fbb0e57d6707bed5b7386bf430ed [4/47] virtio-blk: avoid preallocating big SGL for data
> config: i386-randconfig-s001-20211025 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=b2c5221fd074fbb0e57d6707bed5b7386bf430ed
>         git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>         git fetch --no-tags mst-vhost vhost
>         git checkout b2c5221fd074fbb0e57d6707bed5b7386bf430ed
>         # save the attached .config to linux build tree
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>


Patch sent. Max can you take a look pls?

> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/block/virtio_blk.c:238:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted blk_status_t [usertype] @@
>    drivers/block/virtio_blk.c:238:24: sparse:     expected int
>    drivers/block/virtio_blk.c:238:24: sparse:     got restricted blk_status_t [usertype]
>    drivers/block/virtio_blk.c:246:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted blk_status_t [usertype] @@
>    drivers/block/virtio_blk.c:246:32: sparse:     expected int
>    drivers/block/virtio_blk.c:246:32: sparse:     got restricted blk_status_t [usertype]
> >> drivers/block/virtio_blk.c:320:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted blk_status_t @@     got int [assigned] err @@
>    drivers/block/virtio_blk.c:320:24: sparse:     expected restricted blk_status_t
>    drivers/block/virtio_blk.c:320:24: sparse:     got int [assigned] err
> 
> vim +238 drivers/block/virtio_blk.c
> 
>    203	
>    204	static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
>    205			struct virtblk_req *vbr)
>    206	{
>    207		bool unmap = false;
>    208		u32 type;
>    209	
>    210		vbr->out_hdr.sector = 0;
>    211	
>    212		switch (req_op(req)) {
>    213		case REQ_OP_READ:
>    214			type = VIRTIO_BLK_T_IN;
>    215			vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>    216							      blk_rq_pos(req));
>    217			break;
>    218		case REQ_OP_WRITE:
>    219			type = VIRTIO_BLK_T_OUT;
>    220			vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>    221							      blk_rq_pos(req));
>    222			break;
>    223		case REQ_OP_FLUSH:
>    224			type = VIRTIO_BLK_T_FLUSH;
>    225			break;
>    226		case REQ_OP_DISCARD:
>    227			type = VIRTIO_BLK_T_DISCARD;
>    228			break;
>    229		case REQ_OP_WRITE_ZEROES:
>    230			type = VIRTIO_BLK_T_WRITE_ZEROES;
>    231			unmap = !(req->cmd_flags & REQ_NOUNMAP);
>    232			break;
>    233		case REQ_OP_DRV_IN:
>    234			type = VIRTIO_BLK_T_GET_ID;
>    235			break;
>    236		default:
>    237			WARN_ON_ONCE(1);
>  > 238			return BLK_STS_IOERR;
>    239		}
>    240	
>    241		vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
>    242		vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
>    243	
>    244		if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
>    245			if (virtblk_setup_discard_write_zeroes(req, unmap))
>    246				return BLK_STS_RESOURCE;
>    247		}
>    248	
>    249		return 0;
>    250	}
>    251	
>    252	static inline void virtblk_request_done(struct request *req)
>    253	{
>    254		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>    255	
>    256		virtblk_unmap_data(req, vbr);
>    257		virtblk_cleanup_cmd(req);
>    258		blk_mq_end_request(req, virtblk_result(vbr));
>    259	}
>    260	
>    261	static void virtblk_done(struct virtqueue *vq)
>    262	{
>    263		struct virtio_blk *vblk = vq->vdev->priv;
>    264		bool req_done = false;
>    265		int qid = vq->index;
>    266		struct virtblk_req *vbr;
>    267		unsigned long flags;
>    268		unsigned int len;
>    269	
>    270		spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>    271		do {
>    272			virtqueue_disable_cb(vq);
>    273			while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
>    274				struct request *req = blk_mq_rq_from_pdu(vbr);
>    275	
>    276				if (likely(!blk_should_fake_timeout(req->q)))
>    277					blk_mq_complete_request(req);
>    278				req_done = true;
>    279			}
>    280			if (unlikely(virtqueue_is_broken(vq)))
>    281				break;
>    282		} while (!virtqueue_enable_cb(vq));
>    283	
>    284		/* In case queue is stopped waiting for more buffers. */
>    285		if (req_done)
>    286			blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
>    287		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>    288	}
>    289	
>    290	static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>    291	{
>    292		struct virtio_blk *vblk = hctx->queue->queuedata;
>    293		struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>    294		bool kick;
>    295	
>    296		spin_lock_irq(&vq->lock);
>    297		kick = virtqueue_kick_prepare(vq->vq);
>    298		spin_unlock_irq(&vq->lock);
>    299	
>    300		if (kick)
>    301			virtqueue_notify(vq->vq);
>    302	}
>    303	
>    304	static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>    305				   const struct blk_mq_queue_data *bd)
>    306	{
>    307		struct virtio_blk *vblk = hctx->queue->queuedata;
>    308		struct request *req = bd->rq;
>    309		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>    310		unsigned long flags;
>    311		unsigned int num;
>    312		int qid = hctx->queue_num;
>    313		int err;
>    314		bool notify = false;
>    315	
>    316		BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>    317	
>    318		err = virtblk_setup_cmd(vblk->vdev, req, vbr);
>    319		if (unlikely(err))
>  > 320			return err;
>    321	
>    322		blk_mq_start_request(req);
>    323	
>    324		num = virtblk_map_data(hctx, req, vbr);
>    325		if (unlikely(num < 0)) {
>    326			virtblk_cleanup_cmd(req);
>    327			return BLK_STS_RESOURCE;
>    328		}
>    329	
>    330		spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>    331		err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>    332		if (err) {
>    333			virtqueue_kick(vblk->vqs[qid].vq);
>    334			/* Don't stop the queue if -ENOMEM: we may have failed to
>    335			 * bounce the buffer due to global resource outage.
>    336			 */
>    337			if (err == -ENOSPC)
>    338				blk_mq_stop_hw_queue(hctx);
>    339			spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>    340			virtblk_unmap_data(req, vbr);
>    341			virtblk_cleanup_cmd(req);
>    342			switch (err) {
>    343			case -ENOSPC:
>    344				return BLK_STS_DEV_RESOURCE;
>    345			case -ENOMEM:
>    346				return BLK_STS_RESOURCE;
>    347			default:
>    348				return BLK_STS_IOERR;
>    349			}
>    350		}
>    351	
>    352		if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>    353			notify = true;
>    354		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>    355	
>    356		if (notify)
>    357			virtqueue_notify(vblk->vqs[qid].vq);
>    358		return BLK_STS_OK;
>    359	}
>    360	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


