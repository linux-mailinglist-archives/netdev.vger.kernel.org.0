Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC27364F65F
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLQAhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQAhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:37:54 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBBB1CB37
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 16:37:52 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id f3so2861715pgc.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 16:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EpfoJODOk71GHi7Xsok9Rs/EKkfFZ9utwx7jRyIxiqY=;
        b=GXQuKQ+N5a4XRmSug/53HkX6qtubmLXyGX0o2FBIWXfKrZwuM5m7S0Yvg99ZMbbGe+
         eYlpx21A6lDCQJZUZWzYGcavkDGn16BGPz3LaJnKWCpJK31AN0ypRNHIWxvzEXzmsXhj
         +44Fwi9Pw0RdW5SydW9jBAR6GEGta6FKXKAFNJob/ZeljImfmXW+BqYgh8asivgk5og5
         +Ki5qWnb9R6D3OhLm/J4I9UpYSnX84+s0q52DYCoLFaCrUSumb4tGarZ3tnu0uj8uz12
         a6y2saAn8LTeygIPRjzDx6lxVT97ckeJ+Abhbo/T07VcB7gxnZIq1+kP/k39DxXlXHZi
         orfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EpfoJODOk71GHi7Xsok9Rs/EKkfFZ9utwx7jRyIxiqY=;
        b=yrZ+kGGWcWWbS1B52FvZekLin4TTswvcoCZlLjiuKKwfhp25X1oIZvI8YkoCjcZdc9
         cNThzM2lZsM8oUR1/Sj8nQ7pnXUmcfu3IVzCDAGz5dJKHMVs8CzhKlM4O8p49oFIDBTm
         7c37vfRsf0lBf/M3MLxidiCaP58XNsfI0vPj0d+CJ9ez5mQa0bEenlmn57v7sel6hgyQ
         lOYiMYxJwsxsr7BZzyUJ6ErpVy6/FUA3gbkumnCvE54jNDbpCwht9rYRjofzlrijDcER
         DS2Ybsimnl7UX3cWUfwCnUTXLunVvLCfcVg0JvvS4Hr4/CgIx/Lgo7QhpX8hxmBH4Rky
         77wQ==
X-Gm-Message-State: ANoB5pkEl08aEjRAXhJDeIV8g8qWJqO3h8cIaDNU8yilOurR8JDoNmb9
        q4f+3beB2ixb9hMeS5os4BD3f76dpCqJAIGOBaUM0dIptjo=
X-Google-Smtp-Source: AA0mqf6IJqAw4iIoiaFQD7+DB7ksjGQGRa03hXh5yco2RQkIsl25WkEt3Pq3io7vgwoZM0aGNSW6W3gH2UVm4x5KlC8=
X-Received: by 2002:a63:f241:0:b0:46f:da0:f093 with SMTP id
 d1-20020a63f241000000b0046f0da0f093mr70692752pgk.441.1671237472021; Fri, 16
 Dec 2022 16:37:52 -0800 (PST)
MIME-Version: 1.0
References: <20221216144118.10868-1-u9012063@gmail.com> <c4c62a4563d6669ca3c5d5efee0e54bc8742f27d.camel@gmail.com>
 <CALDO+SaKd74n_PDB+kN0KQWt_Zh9NjzPAm-kWfie4Vd+jOeCZw@mail.gmail.com>
In-Reply-To: <CALDO+SaKd74n_PDB+kN0KQWt_Zh9NjzPAm-kWfie4Vd+jOeCZw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 16 Dec 2022 16:37:40 -0800
Message-ID: <CAKgT0UehKpZMhcCgDPg00BoajxaZ23L9OzZ9GAgQd74xW6zkqw@mail.gmail.com>
Subject: Re: [PATCH v6] vmxnet3: Add XDP support.
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 2:53 PM William Tu <u9012063@gmail.com> wrote:
>
> Hi Alexander,
> Thanks for taking a look at this patch!
>
> On Fri, Dec 16, 2022 at 9:14 AM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, 2022-12-16 at 06:41 -0800, William Tu wrote:
> > > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> > >
> > > Background:
> > > The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> > > For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> > > mapped to the ring's descriptor. If LRO is enabled and packet size larger
> > > than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> > > the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> > > allocated using alloc_page. So for LRO packets, the payload will be in one
> > > buffer from r0 and multiple from r1, for non-LRO packets, only one
> > > descriptor in r0 is used for packet size less than 3k.
> > >
> > > When receiving a packet, the first descriptor will have the sop (start of
> > > packet) bit set, and the last descriptor will have the eop (end of packet)
> > > bit set. Non-LRO packets will have only one descriptor with both sop and
> > > eop set.
> > >
> > > Other than r0 and r1, vmxnet3 dataring is specifically designed for
> > > handling packets with small size, usually 128 bytes, defined in
> > > VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
> > > driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
> > > order to avoid memory mapping/unmapping overhead. In summary, packet size:
> > >     A. < 128B: use dataring
> > >     B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
> > >     C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
> > > As a result, the patch adds XDP support for packets using dataring
> > > and r0 (case A and B), not the large packet size when LRO is enabled.
> > >
> > > XDP Implementation:
> > > When user loads and XDP prog, vmxnet3 driver checks configurations, such
> > > as mtu, lro, and re-allocate the rx buffer size for reserving the extra
> > > headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
> > > associated with every rx queue of the device. Note that when using dataring
> > > for small packet size, vmxnet3 (front-end driver) doesn't control the
> > > buffer allocation, as a result the XDP frame's headroom is zero.
> > >
> > > The receive side of XDP is implemented for case A and B, by invoking the
> > > bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> > > The new vmxnet3_run_xdp function handles the difference of using dataring
> > > or ring0, and decides the next journey of the packet afterward.
> > >
> > > For TX, vmxnet3 has split header design. Outgoing packets are parsed
> > > first and protocol headers (L2/L3/L4) are copied to the backend. The
> > > rest of the payload are dma mapped. Since XDP_TX does not parse the
> > > packet protocol, the entire XDP frame is using dma mapped for the
> > > transmission. Because the actual TX is deferred until txThreshold, it's
> > > possible that an rx buffer is being overwritten by incoming burst of rx
> > > packets, before tx buffer being transmitted. As a result, we allocate new
> > > skb and introduce a copy.
> > >
> > > Performance:
> > > Tested using two VMs inside one ESXi machine, using single core on each
> > > vmxnet3 device, sender using DPDK testpmd tx-mode attached to vmxnet3
> > > device, sending 64B or 512B packet.
> > >
> > > VM1 txgen:
> > > $ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
> > > --forward-mode=txonly --eth-peer=0,<mac addr of vm2>
> > > option: add "--txonly-multi-flow"
> > > option: use --txpkts=512 or 64 byte
> > >
> > > VM2 running XDP:
> > > $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
> > > $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
> > > options: XDP_DROP, XDP_PASS, XDP_TX
> > >
> > > To test REDIRECT to cpu 0, use
> > > $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
> > >
> > > Single core performance comparison with skb-mode.
> > > 64B:      skb-mode -> native-mode (with this patch)
> > > XDP_DROP: 932Kpps -> 2.0Mpps
> > > XDP_PASS: 284Kpps -> 314Kpps
> > > XDP_TX:   591Kpps -> 1.8Mpps
> > > REDIRECT: 453Kpps -> 501Kpps
> > >
> > > 512B:      skb-mode -> native-mode (with this patch)
> > > XDP_DROP: 890Kpps -> 1.3Mpps
> > > XDP_PASS: 284Kpps -> 314Kpps
> > > XDP_TX:   555Kpps -> 1.2Mpps
> > > REDIRECT: 670Kpps -> 430Kpps
> > >
> >
> > I hadn't noticed it before. Based on this it looks like native mode is
> > performing worse then skb-mode for redirect w/ 512B packets? Have you
> > looked into why that might be?
>
> yes, I noticed it but don't know why, maybe it's due to extra copy and page
> allocation like you said below. I will dig deeper.
>
> >
> > My main concern would be that you are optimizing for recyling in the Tx
> > and Redirect paths, when you might be better off just releasing the
> > buffers and batch allocating new pages in your Rx path.
>
> right, are you talking about using the page pool allocator, ex: slide 8 below
> https://legacy.netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf
> I tried it before but then I found I have to replace lots of existing vmxnet3
> code, basically replacing all the rx/tx buffer allocation code with new
> page pool api, even without XDP.  I'd love to give it a try, do you think it's
> worth doing it?

It might be. It is hard for me to say without knowing more about the
driver itself. However if i were doing a driver from scratch that
supported XDP I would probably go that route. Having to refactor an
existing driver is admittedly going to be more work.


>
> >
> > > +     __netif_tx_unlock(nq);
> > > +     return err;
> > > +}
> > > +
> > > +int
> > > +vmxnet3_xdp_xmit(struct net_device *dev,
> > > +              int n, struct xdp_frame **frames, u32 flags)
> > > +{
> > > +     struct vmxnet3_adapter *adapter;
> > > +     struct vmxnet3_tx_queue *tq;
> > > +     struct netdev_queue *nq;
> > > +     int i, err, cpu;
> > > +     int nxmit = 0;
> > > +     int tq_number;
> > > +
> > > +     adapter = netdev_priv(dev);
> > > +
> > > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> > > +             return -ENETDOWN;
> > > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> > > +             return -EINVAL;
> > > +
> > > +     tq_number = adapter->num_tx_queues;
> > > +     cpu = smp_processor_id();
> > > +     tq = &adapter->tx_queue[cpu % tq_number];
> > > +     if (tq->stopped)
> > > +             return -ENETDOWN;
> > > +
> > > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > > +
> > > +     __netif_tx_lock(nq, cpu);
> > > +     for (i = 0; i < n; i++) {
> > > +             err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> > > +             if (err) {
> > > +                     tq->stats.xdp_xmit_err++;
> > > +                     break;
> > > +             }
> > > +             nxmit++;
> > > +     }
> > > +
> > > +     tq->stats.xdp_xmit += nxmit;
> > > +     __netif_tx_unlock(nq);
> > > +
> >
> > Are you doing anything to free the frames after you transmit them? If I
> > am not mistaken you are just copying them over into skbs aren't you, so
> > what is freeing the frames after that?
>
> The frames will be free at vmxnet3_tq_cleanup() at dev_kfree_skb_any(tbi->skb);
> Because at the vmxnet3_xdp_xmit_frame the allocated skb is saved at tbi->skb,
> so it can be freed at tq cleanup.

The frames I am referring to are the xdp_frame, not the skb.
Specifically your function is copying the data out. So in the redirect
case I think you might be leaking pages. That is one of the reasons
why I was thinking it might be better to just push the data all the
way through.

In the other email you sent me the call xdp_return_frame was used to
free the frame. That is what would be expected in this function after
you cleaned the data out and placed it in an skbuff in
vmxnet3_xdp_xmit_frame.

> >
> > > +     return nxmit;
> > > +}
> > > +
> > > +static int
> > > +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> > > +               int headroom, int frame_sz, bool *need_xdp_flush,
> > > +               struct sk_buff *skb)
> > > +{
> > > +     struct xdp_frame *xdpf;
> > > +     void *buf_hard_start;
> > > +     struct xdp_buff xdp;
> > > +     struct page *page;
> > > +     void *orig_data;
> > > +     int err, delta;
> > > +     int delta_len;
> > > +     u32 act;
> > > +
> > > +     buf_hard_start = data;
> > > +     xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > > +     xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> > > +     orig_data = xdp.data;
> > > +
> > > +     act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> > > +     rq->stats.xdp_packets++;
> > > +
> > > +     switch (act) {
> > > +     case XDP_DROP:
> > > +             rq->stats.xdp_drops++;
> > > +             break;
> > > +     case XDP_PASS:
> > > +             /* bpf prog might change len and data position.
> > > +              * dataring does not use skb so not support this.
> > > +              */
> > > +             delta = xdp.data - orig_data;
> > > +             delta_len = (xdp.data_end - xdp.data) - data_len;
> > > +             if (skb) {
> > > +                     skb_reserve(skb, delta);
> > > +                     skb_put(skb, delta_len);
> > > +             }
> > > +             break;
> > > +     case XDP_TX:
> > > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > > +             if (!xdpf ||
> > > +                 vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > > +                     rq->stats.xdp_drops++;
> > > +             } else {
> > > +                     rq->stats.xdp_tx++;
> > > +             }
> > > +             break;
> > > +     case XDP_ABORTED:
> > > +             trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> > > +                                 act);
> > > +             rq->stats.xdp_aborted++;
> > > +             break;
> > > +     case XDP_REDIRECT:
> > > +             page = alloc_page(GFP_ATOMIC);
> > > +             if (!page) {
> > > +                     rq->stats.rx_buf_alloc_failure++;
> > > +                     return XDP_DROP;
> > > +             }
> >
> > So I think I see the problem I had questions about here. If I am not
> > mistaken you are copying the buffer to this page, and then copying this
> > page to an skb right? I think you might be better off just writing off
> > the Tx/Redirect pages and letting them go through their respective
> > paths and just allocating new pages instead assuming these pages were
> > consumed.
>
> I'm not sure I understand, can you elaborate?
>
> For XDP_TX, I'm doing 1 extra copy, copying to the newly allocated skb
> in vmxnet3_xdp_xmit_back.
> For XDP_REDIREC, I allocate a page and copy to the page and call
> xdp_do_redirect, there is no copying to skb again. If I don't allocate a
> new page, it always crashes at
> [62020.425932] BUG: Bad page state in process cpumap/0/map:29  pfn:107548
> [62020.440905] kernel BUG at include/linux/mm.h:757!
>  VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);

What I was referring to was one copy here, and then another copy in
your vmxnet3_xdp_xmit_frame() function with the page you allocated
here possibly being leaked.

Though based on the other trace you provided it would look like you
are redirecting to something else as your code currently doesn't
reference xdp_return_frame which is what I was referring to earlier in
terms of missing the logic to free the frame in your transmit path.
