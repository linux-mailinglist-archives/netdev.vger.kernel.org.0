Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33B65B67E
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 19:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjABSOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 13:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABSOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 13:14:44 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A33CC7
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 10:14:42 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 203so30869462yby.10
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 10:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BOLKGy78iz2a76/6NawfIgKMNBA6w+sorKbNshVj0R0=;
        b=qQEVcG5hYQXiXZ+d0T2ZzeICaNpXkIHhbyNmi7mx0RsUXkjimUHOptqpO2QKuhpzeU
         P6R9+junKeP8iUezwx/foCg9KOf03Az7m5jHbqLG94wNdFNrfABuoqHuKhBntMHst3pi
         p+QePgENdRX+Vm+7sBjwQpKzpNSRpzsndnpRHEq0dGZVc1CspxfltanBU3ZUJhkTHZu/
         W4iNqWn74djR38ojeB6N1WxTSZZ0dXumdlVNEd7nHsQyWsH+Xa/RvMHxPOIijd6v2qFH
         QMVUzdcvv7i8lMG2UVQXQXZV3jFKgVCubd9b0RkzWgW5bQhLd4mRlH8lmdbuRqmJ1++e
         pvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BOLKGy78iz2a76/6NawfIgKMNBA6w+sorKbNshVj0R0=;
        b=wRTFc2mjGhT+oW3BiSBVlq5bjrIQZWTGj68CtX4VjkqPTg/akU+faTg2HGHllMNi0D
         tozaTvFe26AMIaN0aEecorFntYQo7ITqT8iEkmKYYvmk4J3qJgRkGx5fBKE022bc6UTS
         GnUO/qEVNr/UA1RJ7WoZRVpMnrmUYlwHkgUMRXri3mMPPwrnbFUAakQ9MIfuTVgIvwh9
         ly/K9Q97SGXLgfkCtkVDR99siF+7GStJm8NSr3isNEfvGU8TcQq+HfZdCKepmS8UclWz
         zZBCNuxwT5LRcUIKO+2znbU1H3btef1OL7tuD0lo2W0rh6vCXR/s8cje+o4Gy7ky2p1J
         Q6ng==
X-Gm-Message-State: AFqh2kr8D9OrmTHXoNTZO9SMZ4Qcj5dO/etu7l4s76Vl7r1jDQ7GAv4b
        E3fpIxCW8VfMYZ+iPpx5wP35IAQKN/qlwZkSS5U=
X-Google-Smtp-Source: AMrXdXtRzbKRR2gqojPy0ljlaG32BhEK8uGGKcNKRLJFRbUICHk7CcnMGj/MDkxdjig+iECAtVI/fQ+JcljvWs2QMCA=
X-Received: by 2002:a25:8f86:0:b0:798:f36b:2c25 with SMTP id
 u6-20020a258f86000000b00798f36b2c25mr1409896ybl.213.1672683281346; Mon, 02
 Jan 2023 10:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20221222154648.21497-1-u9012063@gmail.com> <64fa6e0c14e15a13720e00211da82f56e2e94397.camel@gmail.com>
In-Reply-To: <64fa6e0c14e15a13720e00211da82f56e2e94397.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 2 Jan 2023 10:14:05 -0800
Message-ID: <CALDO+SbmUnthypvqD4zyzSGzTdsCNvMQXPTwcAExKdTuhM+YPg@mail.gmail.com>
Subject: Re: [RFC PATCH v7] vmxnet3: Add XDP support.
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,
Thanks for your review!

>
> So after looking over the patch it occurs to me that you may want to
> lay some additional ground work before you start trying to natively
> enable XDP.
>
> Specifically you may want to look at not using sk_buff as your
> structure you store in your Rx rings. Instead it would be better to
> just store pages as those can easily be loaded into either an skb or an
> xdp_frame without having to do conversion tricks such as taking a page
> reference and then freeing the skb.
>
> Likewise you may want to look at cleaning up your Tx path to make
> similar changes where you can add a flag and either free an xdp_frame
> or an sk_buff so that you don't have to resort to memory copies in
> order to convert between types.

Yes, I read carefully the slides from Lorenzo's slide
https://legacy.netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf
and like you said I need some ground work.
I have to change the basic memory model to be compatible with XDP.
So I'm working on using page pool api and re-write most of the code.

>
> > ---
> > v6 -> v7:
> > work on feedbacks from Alexander Duyck on XDP_TX and XDP_REDIRECT
> > - fix memleak of xdp frame when doing ndo_xdp_xmit (vmxnet3_xdp_xmit)
> > - at vmxnet3_xdp_xmit_frame, fix return value, -NOSPC and ENOMEM,
> >   and free skb when dma map fails
> > - add xdp_buff_clean_frags_flag since we don't support frag
> > - update experiements of XDP_TX and XDP_REDIRECT
> > - for XDP_REDIRECT, I assume calling xdp_do_redirect will take
> > the buffer and free it, so I need to allocate a new buffer to
> > refill the rx ring. However, I hit some OOM when testing using
> > ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e <drop or pass>
> > - I couldn't find the reason so mark this patch as RFC
> >
> > v5 -> v6:
> > work on feedbacks from Alexander Duyck
> > - remove unused skb parameter at vmxnet3_xdp_xmit
> > - add trace point for XDP_ABORTED
> > - avoid TX packet buffer being overwritten by allocatin
> >   new skb and memcpy (TX performance drop from 2.3 to 1.8Mpps)
> > - update some of the performance number and a demo video
> >   https://youtu.be/I3nx5wQDTXw
> > - pass VMware internal regression test using non-ENS: vmxnet3v2,
> >   vmxnet3v3, vmxnet3v4, so remove RFC tag.
> >
> > v4 -> v5:
> > - move XDP code to separate file: vmxnet3_xdp.{c, h},
> >   suggested by Guolin
> > - expose vmxnet3_rq_create_all and vmxnet3_adjust_rx_ring_size
> > - more test using samples/bpf/{xdp1, xdp2, xdp_adjust_tail}
> > - add debug print
> > - rebase on commit 65e6af6cebe
> >
> >
> >
>
> <...>
>
> > +static int
> > +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> > +                    struct xdp_frame *xdpf,
> > +                    struct vmxnet3_tx_queue *tq)
> > +{
> > +     struct vmxnet3_tx_buf_info *tbi = NULL;
> > +     union Vmxnet3_GenericDesc *gdesc;
> > +     struct vmxnet3_tx_ctx ctx;
> > +     int tx_num_deferred;
> > +     struct sk_buff *skb;
> > +     u32 buf_size;
> > +     int ret = 0;
> > +     u32 dw2;
> > +
> > +     if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> > +             tq->stats.tx_ring_full++;
> > +             ret = -ENOSPC;
> > +             goto exit;
> > +     }
> > +
> > +     skb = __netdev_alloc_skb(adapter->netdev, xdpf->len, GFP_KERNEL);
> > +     if (unlikely(!skb)) {
> > +             ret = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     memcpy(skb->data, xdpf->data, xdpf->len);
>
> Rather than adding all this overhead to copy the frame into an skb it
> would be better to look at supporting the xdp_frame format natively in
> your Tx path/cleanup.
yes, I'm working on it.
>
> This extra copy overhead will make things more expensive and kind of
> defeat the whole purpose of the XDP code.
Agree

>
> > +     dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> > +     dw2 |= xdpf->len;
> > +     ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> > +     gdesc = ctx.sop_txd;
> > +
> > +     buf_size = xdpf->len;
> > +     tbi = tq->buf_info + tq->tx_ring.next2fill;
> > +     tbi->map_type = VMXNET3_MAP_SINGLE;
> > +     tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> > +                                    skb->data, buf_size,
> > +                                    DMA_TO_DEVICE);
> > +     if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
> > +             dev_kfree_skb(skb);
> > +             ret = -EFAULT;
> > +             goto exit;
> > +     }
> > +     tbi->len = buf_size;
> > +
> > +     gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
> > +     WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
> > +
> > +     gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
> > +     gdesc->dword[2] = cpu_to_le32(dw2);
> > +
> > +     /* Setup the EOP desc */
> > +     gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
> > +
> > +     gdesc->txd.om = 0;
> > +     gdesc->txd.msscof = 0;
> > +     gdesc->txd.hlen = 0;
> > +     gdesc->txd.ti = 0;
> > +
> > +     tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
> > +     tq->shared->txNumDeferred += 1;
> > +     tx_num_deferred++;
> > +
> > +     vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> > +
> > +     /* set the last buf_info for the pkt */
> > +     tbi->skb = skb;
> > +     tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
> > +
> > +     dma_wmb();
> > +     gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> > +                                               VMXNET3_TXD_GEN);
> > +     if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> > +             tq->shared->txNumDeferred = 0;
> > +             VMXNET3_WRITE_BAR0_REG(adapter,
> > +                                    VMXNET3_REG_TXPROD + tq->qid * 8,
> > +                                    tq->tx_ring.next2fill);
> > +     }
> > +exit:
> > +     return ret;
> > +}
> > +
> > +static int
> > +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> > +                   struct xdp_frame *xdpf)
> > +{
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int err = 0, cpu;
> > +     int tq_number;
> > +
> > +     tq_number = adapter->num_tx_queues;
> > +     cpu = smp_processor_id();
> > +     tq = &adapter->tx_queue[cpu % tq_number];
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > +
> > +     __netif_tx_lock(nq, cpu);
> > +     err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq);
> > +     if (err)
> > +             goto exit;
> > +
> > +exit:
> > +     __netif_tx_unlock(nq);
> > +     return err;
> > +}
> > +
> > +int
> > +vmxnet3_xdp_xmit(struct net_device *dev,
> > +              int n, struct xdp_frame **frames, u32 flags)
> > +{
> > +     struct vmxnet3_adapter *adapter;
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int i, err, cpu;
> > +     int nxmit = 0;
> > +     int tq_number;
> > +
> > +     adapter = netdev_priv(dev);
> > +
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> > +             return -ENETDOWN;
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> > +             return -EINVAL;
> > +
> > +     tq_number = adapter->num_tx_queues;
> > +     cpu = smp_processor_id();
> > +     tq = &adapter->tx_queue[cpu % tq_number];
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > +
> > +     __netif_tx_lock(nq, cpu);
> > +     for (i = 0; i < n; i++) {
> > +             err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> > +             /* vmxnet3_xdp_xmit_frame has copied the data
> > +              * to skb, so we free xdp frame below.
> > +              */
> > +             get_page(virt_to_page(frames[i]->data));
>
> What is this get_page for? I thought your transmit path was doing a
> copy out of the data. This is probably the source of your memory leak.
if I didn't get_page, the xdp_return_frame report warning saying the
page has zero refcnt.
(Note I'm working on using page_pool so the above code will be gone)

>
> > +             xdp_return_frame(frames[i]);
> > +             if (err) {
> > +                     tq->stats.xdp_xmit_err++;
> > +                     break;
> > +             }
> > +             nxmit++;
> > +     }
> > +
> > +     tq->stats.xdp_xmit += nxmit;
> > +     __netif_tx_unlock(nq);
> > +
> > +     return nxmit;
> > +}
> > +
> > +static int
> > +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> > +               int headroom, int frame_sz, bool *need_xdp_flush,
> > +               struct sk_buff *skb)
> > +{
> > +     struct xdp_frame *xdpf;
> > +     void *buf_hard_start;
> > +     struct xdp_buff xdp;
> > +     void *orig_data;
> > +     int err, delta;
> > +     int delta_len;
> > +     u32 act;
> > +
> > +     buf_hard_start = data;
> > +     xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +     orig_data = xdp.data;
> > +
> > +     act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> > +     rq->stats.xdp_packets++;
> > +
> > +     switch (act) {
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     case XDP_PASS:
> > +             /* bpf prog might change len and data position.
> > +              * dataring does not use skb so not support this.
> > +              */
> > +             delta = xdp.data - orig_data;
> > +             delta_len = (xdp.data_end - xdp.data) - data_len;
> > +             if (skb) {
> > +                     skb_reserve(skb, delta);
> > +                     skb_put(skb, delta_len);
> > +             }
> > +             break;
> > +     case XDP_TX:
> > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > +             if (!xdpf ||
> > +                 vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > +                     rq->stats.xdp_drops++;
> > +             } else {
> > +                     rq->stats.xdp_tx++;
> > +             }
> > +             break;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> > +                                 act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_REDIRECT:
> > +             get_page(virt_to_page(data));
>
> So if I am understanding correctly this get_page is needed because we
> are converting the skb into an xdp_buff before you attempt to redirect
> it right?
Yes
>
> So this additional reference should be released when you free the skb?
Yes

>
> Also you might want to add some logic to verify that skb->data is a
> head_frag and not allocated from slab memory. Also I'm assuming the
> size is a constant?
>
> > +             xdp_buff_clear_frags_flag(&xdp);
> > +             err = xdp_do_redirect(rq->adapter->netdev, &xdp,
> > +                                   rq->xdp_bpf_prog);
> > +             if (!err) {
> > +                     rq->stats.xdp_redirects++;
> > +             } else {
> > +                     rq->stats.xdp_drops++;
> > +                     trace_xdp_exception(rq->adapter->netdev,
> > +                                         rq->xdp_bpf_prog, act);
> > +             }
> > +             *need_xdp_flush = true;
> > +             break;
> > +     default:
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev,
> > +                                         rq->xdp_bpf_prog, act);
> > +             break;
> > +     }
> > +     return act;
> > +}
> > +
> > +static int
> > +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct vmxnet3_rx_buf_info *rbi,
> > +             struct Vmxnet3_RxCompDesc *rcd, bool *need_flush,
> > +             bool rxDataRingUsed)
> > +{
> > +     struct vmxnet3_adapter *adapter;
> > +     struct ethhdr *ehdr;
> > +     int act = XDP_PASS;
> > +     void *data;
> > +     int sz;
> > +
> > +     adapter = rq->adapter;
> > +     if (rxDataRingUsed) {
> > +             sz = rcd->rxdIdx * rq->data_ring.desc_size;
> > +             data = &rq->data_ring.base[sz];
> > +             ehdr = data;
> > +             netdev_dbg(adapter->netdev,
> > +                        "XDP: rxDataRing packet size %d, eth proto 0x%x\n",
> > +                        rcd->len, ntohs(ehdr->h_proto));
> > +             act = __vmxnet3_run_xdp(rq, data, rcd->len, 0,
> > +                                     rq->data_ring.desc_size, need_flush,
> > +                                     NULL);
> > +     } else {
> > +             dma_unmap_single(&adapter->pdev->dev,
> > +                              rbi->dma_addr,
> > +                              rbi->len,
> > +                              DMA_FROM_DEVICE);
> > +             ehdr = (struct ethhdr *)rbi->skb->data;
> > +             netdev_dbg(adapter->netdev,
> > +                        "XDP: packet size %d, eth proto 0x%x\n",
> > +                        rcd->len, ntohs(ehdr->h_proto));
> > +             act = __vmxnet3_run_xdp(rq,
> > +                                     rbi->skb->data - XDP_PACKET_HEADROOM,
> > +                                     rcd->len, XDP_PACKET_HEADROOM,
> > +                                     rbi->len, need_flush, rbi->skb);
> > +     }
> > +     return act;
> > +}
> > +
> > +int
> > +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> > +                 struct vmxnet3_rx_queue *rq,
> > +                 struct Vmxnet3_RxCompDesc *rcd,
> > +                 struct vmxnet3_rx_buf_info *rbi,
> > +                 struct Vmxnet3_RxDesc *rxd,
> > +                 bool *need_flush)
> > +{
> > +     struct bpf_prog *xdp_prog;
> > +     dma_addr_t new_dma_addr;
> > +     struct sk_buff *new_skb;
> > +     bool reuse_buf = true;
> > +     bool rxDataRingUsed;
> > +     int ret, act;
> > +     int len;
> > +
> > +     ret = VMXNET3_XDP_CONTINUE;
> > +     if (unlikely(rcd->len == 0))
> > +             return VMXNET3_XDP_TAKEN;
> > +
> > +     rxDataRingUsed = VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> > +     rcu_read_lock();
> > +     xdp_prog = rcu_dereference(rq->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             rcu_read_unlock();
> > +             return VMXNET3_XDP_CONTINUE;
> > +     }
> > +     act = vmxnet3_run_xdp(rq, rbi, rcd, need_flush, rxDataRingUsed);
> > +     rcu_read_unlock();
> > +
> > +     switch (act) {
> > +     case XDP_PASS:
> > +             return VMXNET3_XDP_CONTINUE;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev,
> > +                                 rq->xdp_bpf_prog, act);
> > +             fallthrough;
> > +     case XDP_DROP:
> > +     case XDP_TX:
> > +             ret = VMXNET3_XDP_TAKEN;
> > +             reuse_buf = true;
> > +             break;
>
> Ideally the XDP_TX would also be freeing the page but you still have
> the memcpy in your Tx path. If you could get rid of that and natively
> handle xdp_buf structures it would likely improve the overall
> throughput for all your XDP cases.
>
Got it, thanks!

I will work on the next version.
And sorry some of your feedback won't apply since I will be using
page_pool api so some of the codes above won't exist anymore.

Regards,
William
