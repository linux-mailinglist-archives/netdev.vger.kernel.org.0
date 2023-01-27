Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EAD67E843
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjA0O2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjA0O2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:28:44 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB859FF0E
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:28:42 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4c131bede4bso69036737b3.5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sWjZNsFiSCL9HKLO389oiSFu1xqsNH70Plh9VC/98vY=;
        b=iiNHB0S8pROMCoNHxbgWEovLyPSMkShK6IAxL6xOfFYcXyWclmG1rqq3j8rMASnxoC
         tdohwboc7JRMZVAssz1fY0J5wa+LJMAF2OL1NiyjACqNL6IobwATG4PqL9tkqmqX2Klb
         1yVcCKYdmTC9sb9stIVA77uoPIdBxxdYXsSQUuhF3DpktVENKCYLv3pMRDw5xSYACxsp
         Cx+qs9iVxPTBQXrghu9EiNLzOoCWHj5Cva8t/Xaj0g3hdpS7hkpipyTGQrtNx9ZpUW7U
         AZrgV/Qr0nA7SLK9InmyPbuveWZWej5qfbqkLL+IMTCg/+ZVWec4+rB/PAj3z+jDjyaE
         8lQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWjZNsFiSCL9HKLO389oiSFu1xqsNH70Plh9VC/98vY=;
        b=besSRv0eAhbJuUXhpfN/UmJWaDOYuESWjRj8lwq0RWXuOrUjtJ1dvj0TN6TLp5aR9/
         xiy3YsxtFXqQ1Ucy7MumWnuwQ2AwNJf/dqjTw2it1pnhwKBjJ2/MkbjhEyh31+Qx0U/5
         nkkmeO1hKIM615RPCrPzUjFyF/9Nm2vthRkaZS2jveWLD8Kl0dGBj6KtOY1tYLTQPlgB
         4fJ9BPNfvcRFbOmENdUCJM1Y8eThvp1aalB08tmCxq39sXj8ki5vO21OjP8i7LpexGW/
         RjttIG8kX3yIDyrudkbHUrd5W9jU/VLo2yS1QdTTpUESrXn3XV7hpfb20oxABJC5fPbJ
         nlGA==
X-Gm-Message-State: AO0yUKWZWurQGfeKANRAGcnKQ3pqHAkkAx7/Mjxcp9Ge7VA1jOqImoQC
        bm+p+kTtVXbSL4MRhecRuOca8usJfQ78pJvVsIc=
X-Google-Smtp-Source: AK7set/BiBuTRnzDfVDnIuvYc+C4nZ5NhFDVjSXSWjsryZmCAHhmdSmagx6Gob2Co6l5QBihAqrjpWV/SPeYzYlC7gI=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr1974282ywk.360.1674829721867; Fri, 27
 Jan 2023 06:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20230124044515.17377-1-u9012063@gmail.com> <f4ed2416-3cbe-83e9-be1c-9d993224b44e@intel.com>
In-Reply-To: <f4ed2416-3cbe-83e9-be1c-9d993224b44e@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 27 Jan 2023 06:28:05 -0800
Message-ID: <CALDO+SbeLUWCQ8iFVrB641zsXX8+h4hhMzYR-0+1CR-KQBhw=A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v14] vmxnet3: Add XDP support.
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com, bang@vmware.com,
        Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
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

Thanks for finding more issues in my code!

On Tue, Jan 24, 2023 at 3:10 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Mon, 23 Jan 2023 20:45:15 -0800
>
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
> > Background:
>
> [...]
>
> > @@ -414,26 +427,34 @@ static void
> >  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
> >                  struct vmxnet3_adapter *adapter)
> >  {
> > +     struct xdp_frame_bulk bq;
> > +     u32 map_type;
> >       int i;
> >
> > +     xdp_frame_bulk_init(&bq);
> > +
> >       while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
> >               struct vmxnet3_tx_buf_info *tbi;
> >
> >               tbi = tq->buf_info + tq->tx_ring.next2comp;
> > +             map_type = tbi->map_type;
> >
> >               vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
> >               if (tbi->skb) {
> > -                     dev_kfree_skb_any(tbi->skb);
> > +                     if (map_type & VMXNET3_MAP_XDP)
> > +                             xdp_return_frame_bulk(tbi->xdpf, &bq);
> > +                     else
> > +                             dev_kfree_skb_any(tbi->skb);
> >                       tbi->skb = NULL;
> >               }
> >               vmxnet3_cmd_ring_adv_next2comp(&tq->tx_ring);
> >       }
> >
> > -     /* sanity check, verify all buffers are indeed unmapped and freed */
> > -     for (i = 0; i < tq->tx_ring.size; i++) {
> > -             BUG_ON(tq->buf_info[i].skb != NULL ||
> > -                    tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
> > -     }
> > +     xdp_flush_frame_bulk(&bq);
>
> Breh, I forgot you need to lock RCU read for bulk-flushing...

Thanks, I didn't notice that, will do it.

>
> xdp_frame_bulk_init();
> rcu_read_lock();
>
> ...
>
> xdp_flush_frame_bulk();
> rcu_read_unlock();
>
> In both places where you use it.
>
> > +
> > +     /* sanity check, verify all buffers are indeed unmapped */
> > +     for (i = 0; i < tq->tx_ring.size; i++)
> > +             BUG_ON(tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
> >
> >       tq->tx_ring.gen = VMXNET3_INIT_GEN;
> >       tq->tx_ring.next2fill = tq->tx_ring.next2comp = 0;
>
> [...]
>
> > +static int
> > +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> > +             struct netlink_ext_ack *extack)
> > +{
> > +     struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> > +     struct bpf_prog *new_bpf_prog = bpf->prog;
> > +     struct bpf_prog *old_bpf_prog;
> > +     unsigned int max_mtu;
> > +     bool need_update;
> > +     bool running;
> > +     int err;
> > +
> > +     max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VMXNET3_XDP_HEADROOM) -
> > +                                 netdev->hard_header_len;
>
> Wrong alignment. You aligned it to the opening brace, but the last
> variable itself is not inside the braces.
> Either align it to 'SKB' or include into the expression inside the
> braces, both is fine.

sorry, my mistake again. Will fix it.
>
> > +     if (new_bpf_prog && netdev->mtu > max_mtu) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> > +             return -EOPNOTSUPP;
> > +     }
>
> [...]
>
> > +     default:
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> > +             fallthrough;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, prog, act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     }
> > +
> > +     page_pool_recycle_direct(rq->page_pool,
> > +                              virt_to_head_page(xdp->data_hard_start));
>
> Nit: you can reuse the @page variable to make this one more elegant, too :)
Will do.

>
>         page = virt_to ...
>         page_pool_recycle_direct(pool, page);
>
> > +
> > +     return act;
> > +}
> > +
> > +static struct sk_buff *
> > +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
> > +               const struct xdp_buff *xdp)
>
> [...]
>
> > +     page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
> > +     if (unlikely(!page)) {
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return XDP_DROP;
> > +     }
> > +
> > +     xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
>
> Isn't page_pool->p.offset more correct here instead of just
> %XDP_PACKET_HEADROOM? You included %NET_IP_ALIGN there.

Yes, will fix here and others below.

>
> > +                      len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     /* Must copy the data because it's at dataring. */
> > +     memcpy(xdp.data, data, len);
>
> Aren't you missing dma_sync_single_for_cpu() before this memcpy()?
We don't need to dma_sync_single_for_cpu here because the xdp.data is
part of the rx ring (%rq->data_ring.base) and using dma_alloc_coherent.

>
> > +
> > +     rcu_read_lock();
>
> [...]
>
> > +int
> > +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> > +                 struct vmxnet3_rx_queue *rq,
> > +                 struct Vmxnet3_RxCompDesc *rcd,
> > +                 struct vmxnet3_rx_buf_info *rbi,
> > +                 struct Vmxnet3_RxDesc *rxd,
> > +                 struct sk_buff **skb_xdp_pass)
> > +{
> > +     struct bpf_prog *xdp_prog;
> > +     dma_addr_t new_dma_addr;
> > +     struct xdp_buff xdp;
> > +     struct page *page;
> > +     void *new_data;
> > +     int act;
> > +
> > +     page = rbi->page;
> > +     dma_sync_single_for_cpu(&adapter->pdev->dev,
> > +                             page_pool_get_dma_addr(page) +
> > +                             XDP_PACKET_HEADROOM, rcd->len,
>
> Same.
>
> > +                             page_pool_get_dma_dir(rq->page_pool));
> > +
> > +     xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
>
> Same.
>
> > +                      rcd->len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     rcu_read_lock();
> > +     xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             rcu_read_unlock();
> > +             act = XDP_PASS;
> > +             goto refill;
>
> Is it correct to go to 'refill' here? You miss vmxnet3_build_skb() this
> way. And when you call vmxne3_process_xdp_small() later during the NAPI
> poll, you also don't build an skb and go to 'sop_done' directly instead.
> So I feel you must add a new label below and go to it instead, just like
> you do in process_xdp():
good catch and you're right, will add another label below.

>
> > +     }
> > +     act = vmxnet3_run_xdp(rq, &xdp);
> > +     rcu_read_unlock();
> > +
> > +     if (act == XDP_PASS) {
>
> here:
>
> > +             *skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> > +             if (!skb_xdp_pass)
> > +                     act = XDP_DROP;
> > +     }
> > +
> > +refill:
> > +     new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
> > +                                    GFP_ATOMIC);
> > +     if (!new_data) {
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return XDP_DROP;
> > +     }
> > +     rbi->page = virt_to_head_page(new_data);
> > +     rbi->dma_addr = new_dma_addr;
> > +     rxd->addr = cpu_to_le64(rbi->dma_addr);
> > +     rxd->len = rbi->len;
> > +
> > +     return act;
> > +}
> + a couple notes in the reply to your previous revision. I feel like one
> more spin and I won't have any more comments, will be good to me :)

Will start working on next version, thanks again!
William
