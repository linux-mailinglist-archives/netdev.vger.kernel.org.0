Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5501364FAEB
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLQQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 11:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiLQQBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 11:01:13 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E715FC2
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 07:42:43 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-43ea87d0797so45202767b3.5
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 07:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X4OmTeCEyLnq28o07+5IlO/ofoH0BOCIhR4T0E2A8lk=;
        b=WVvnbbH5JfZq1EnPYlDL+GLxfAIYzoSnJ+FPh06wSpdO90W9SVE2VsMihSi71tIWn4
         qF+FZOQxcxoOI/3wb0t5BiXWOj8L9vf7YsLKztw7Oqcp5DjatBZYIy1jV51v+hYniSgB
         SUEZwXMXZqfSGaRetDhbWq/TQySBlNPiFKMTqK4HvS4dF259J6O7xI0TOm1ZhRx8z5Yw
         YxVxS6fo71d6WZzGaWwtHMx7lc/U1zqsdGeu1vprTLpd0AaHnjsOJkHf6O3Ole6cc+kl
         XrgW7W5XBCfeOxf1//TWr5x7gFjiRd71frDkN2PRl6orfyA+YFyaAMGA4G0w1CqWF4ak
         tffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4OmTeCEyLnq28o07+5IlO/ofoH0BOCIhR4T0E2A8lk=;
        b=aoTKWrT27EiNnSQVDVQsXgKzsiF+Acecn+xsbEiq6yIkmOEgSJtF1nnFshPmGDLltu
         BDCZXJsPTYfBL8d61xNk+W3cV2W0aZyL2CljGTl4EmMHJ9tiFhU8ghlHH7v6Pt2mUL48
         H9xQ/p0sfxHrkU0wYcy8jFO1t0YCC1qZj6jlpW1zAKK6Lm1At5HQ8a/A7r+c/5pHmzaA
         bjJEmYz1mtgQ+e3TTWjawhb3j2a8oNm3iZ6301q5R46diJ/MYwGVy7VrcyunmnEW2tzA
         UaNN+7p0GuYzCKvBo/EPvWSsAQ9NIvl0+RQJpGz/qa7+s+byD/ljqbYbwLifSFtBcDOs
         mo2A==
X-Gm-Message-State: AFqh2korZWCYdz9zyUSohj6eFXL05iH76jU+S3l5PmbYwhFqRpc66OLb
        CQSECQ6M+4hinzFMos9oh4jrxoSe7++5tvjdsbRksC72
X-Google-Smtp-Source: AMrXdXvm82lezZ51nuiz6DIw/54FaW+JYCpq8BwKzuD5wLSlJy8UMTnJQ80UHo/tNLz16s7hmQIFLQ4rpuitRSP44hk=
X-Received: by 2002:a81:57ca:0:b0:3d2:b057:9925 with SMTP id
 l193-20020a8157ca000000b003d2b0579925mr1813172ywb.455.1671291762966; Sat, 17
 Dec 2022 07:42:42 -0800 (PST)
MIME-Version: 1.0
References: <20221216144118.10868-1-u9012063@gmail.com> <c4c62a4563d6669ca3c5d5efee0e54bc8742f27d.camel@gmail.com>
 <CALDO+SaKd74n_PDB+kN0KQWt_Zh9NjzPAm-kWfie4Vd+jOeCZw@mail.gmail.com> <CAKgT0UehKpZMhcCgDPg00BoajxaZ23L9OzZ9GAgQd74xW6zkqw@mail.gmail.com>
In-Reply-To: <CAKgT0UehKpZMhcCgDPg00BoajxaZ23L9OzZ9GAgQd74xW6zkqw@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 17 Dec 2022 07:42:06 -0800
Message-ID: <CALDO+SYz2LYk8_tvwoY75OVT-7B3_HgjF8PTnUN9hdDL+pucwQ@mail.gmail.com>
Subject: Re: [PATCH v6] vmxnet3: Add XDP support.
To:     Alexander Duyck <alexander.duyck@gmail.com>
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

On Fri, Dec 16, 2022 at 4:37 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Dec 16, 2022 at 2:53 PM William Tu <u9012063@gmail.com> wrote:
> >
Hi Alexander,
Thanks for taking a look at this patch!

> > > > Single core performance comparison with skb-mode.
> > > > 64B:      skb-mode -> native-mode (with this patch)
> > > > XDP_DROP: 932Kpps -> 2.0Mpps
> > > > XDP_PASS: 284Kpps -> 314Kpps
> > > > XDP_TX:   591Kpps -> 1.8Mpps
> > > > REDIRECT: 453Kpps -> 501Kpps
> > > >
> > > > 512B:      skb-mode -> native-mode (with this patch)
> > > > XDP_DROP: 890Kpps -> 1.3Mpps
> > > > XDP_PASS: 284Kpps -> 314Kpps
> > > > XDP_TX:   555Kpps -> 1.2Mpps
> > > > REDIRECT: 670Kpps -> 430Kpps
> > > >
> > >
> > > I hadn't noticed it before. Based on this it looks like native mode is
> > > performing worse then skb-mode for redirect w/ 512B packets? Have you
> > > looked into why that might be?
> >
> > yes, I noticed it but don't know why, maybe it's due to extra copy and page
> > allocation like you said below. I will dig deeper.

I've fixed the issue like you mentioned, and now the redirect shows
better performance.
I will update in next version.

> >
> > >
> > > My main concern would be that you are optimizing for recyling in the Tx
> > > and Redirect paths, when you might be better off just releasing the
> > > buffers and batch allocating new pages in your Rx path.
> >
> > right, are you talking about using the page pool allocator, ex: slide 8 below
> > https://legacy.netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf
> > I tried it before but then I found I have to replace lots of existing vmxnet3
> > code, basically replacing all the rx/tx buffer allocation code with new
> > page pool api, even without XDP.  I'd love to give it a try, do you think it's
> > worth doing it?
>
> It might be. It is hard for me to say without knowing more about the
> driver itself. However if i were doing a driver from scratch that
> supported XDP I would probably go that route. Having to refactor an
> existing driver is admittedly going to be more work.
>
I see, thanks.
>
> >
> > >
> > > > +     __netif_tx_unlock(nq);
> > > > +     return err;
> > > > +}
> > > > +
> > > > +int
> > > > +vmxnet3_xdp_xmit(struct net_device *dev,
> > > > +              int n, struct xdp_frame **frames, u32 flags)
> > > > +{
> > > > +     struct vmxnet3_adapter *adapter;
> > > > +     struct vmxnet3_tx_queue *tq;
> > > > +     struct netdev_queue *nq;
> > > > +     int i, err, cpu;
> > > > +     int nxmit = 0;
> > > > +     int tq_number;
> > > > +
> > > > +     adapter = netdev_priv(dev);
> > > > +
> > > > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> > > > +             return -ENETDOWN;
> > > > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> > > > +             return -EINVAL;
> > > > +
> > > > +     tq_number = adapter->num_tx_queues;
> > > > +     cpu = smp_processor_id();
> > > > +     tq = &adapter->tx_queue[cpu % tq_number];
> > > > +     if (tq->stopped)
> > > > +             return -ENETDOWN;
> > > > +
> > > > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > > > +
> > > > +     __netif_tx_lock(nq, cpu);
> > > > +     for (i = 0; i < n; i++) {
> > > > +             err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> > > > +             if (err) {
> > > > +                     tq->stats.xdp_xmit_err++;
> > > > +                     break;
> > > > +             }
> > > > +             nxmit++;
> > > > +     }
> > > > +
> > > > +     tq->stats.xdp_xmit += nxmit;
> > > > +     __netif_tx_unlock(nq);
> > > > +
> > >
> > > Are you doing anything to free the frames after you transmit them? If I
> > > am not mistaken you are just copying them over into skbs aren't you, so
> > > what is freeing the frames after that?
> >
> > The frames will be free at vmxnet3_tq_cleanup() at dev_kfree_skb_any(tbi->skb);
> > Because at the vmxnet3_xdp_xmit_frame the allocated skb is saved at tbi->skb,
> > so it can be freed at tq cleanup.
>
> The frames I am referring to are the xdp_frame, not the skb.
> Specifically your function is copying the data out. So in the redirect
> case I think you might be leaking pages. That is one of the reasons
> why I was thinking it might be better to just push the data all the
> way through.

Got it, you're right, it's leaking memory there.

>
> In the other email you sent me the call xdp_return_frame was used to
> free the frame. That is what would be expected in this function after
> you cleaned the data out and placed it in an skbuff in
> vmxnet3_xdp_xmit_frame.

OK! will do it.

>
> > >
> > > > +     return nxmit;
> > > > +}
> > > > +
> > > > +static int
> > > > +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> > > > +               int headroom, int frame_sz, bool *need_xdp_flush,
> > > > +               struct sk_buff *skb)
> > > > +{
> > > > +     struct xdp_frame *xdpf;
> > > > +     void *buf_hard_start;
> > > > +     struct xdp_buff xdp;
> > > > +     struct page *page;
> > > > +     void *orig_data;
> > > > +     int err, delta;
> > > > +     int delta_len;
> > > > +     u32 act;
> > > > +
> > > > +     buf_hard_start = data;
> > > > +     xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > > > +     xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> > > > +     orig_data = xdp.data;
> > > > +
> > > > +     act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> > > > +     rq->stats.xdp_packets++;
> > > > +
> > > > +     switch (act) {
> > > > +     case XDP_DROP:
> > > > +             rq->stats.xdp_drops++;
> > > > +             break;
> > > > +     case XDP_PASS:
> > > > +             /* bpf prog might change len and data position.
> > > > +              * dataring does not use skb so not support this.
> > > > +              */
> > > > +             delta = xdp.data - orig_data;
> > > > +             delta_len = (xdp.data_end - xdp.data) - data_len;
> > > > +             if (skb) {
> > > > +                     skb_reserve(skb, delta);
> > > > +                     skb_put(skb, delta_len);
> > > > +             }
> > > > +             break;
> > > > +     case XDP_TX:
> > > > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > > > +             if (!xdpf ||
> > > > +                 vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > > > +                     rq->stats.xdp_drops++;
> > > > +             } else {
> > > > +                     rq->stats.xdp_tx++;
> > > > +             }
> > > > +             break;
> > > > +     case XDP_ABORTED:
> > > > +             trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> > > > +                                 act);
> > > > +             rq->stats.xdp_aborted++;
> > > > +             break;
> > > > +     case XDP_REDIRECT:
> > > > +             page = alloc_page(GFP_ATOMIC);
> > > > +             if (!page) {
> > > > +                     rq->stats.rx_buf_alloc_failure++;
> > > > +                     return XDP_DROP;
> > > > +             }
> > >
> > > So I think I see the problem I had questions about here. If I am not
> > > mistaken you are copying the buffer to this page, and then copying this
> > > page to an skb right? I think you might be better off just writing off
> > > the Tx/Redirect pages and letting them go through their respective
> > > paths and just allocating new pages instead assuming these pages were
> > > consumed.
> >
> > I'm not sure I understand, can you elaborate?
> >
> > For XDP_TX, I'm doing 1 extra copy, copying to the newly allocated skb
> > in vmxnet3_xdp_xmit_back.
> > For XDP_REDIREC, I allocate a page and copy to the page and call
> > xdp_do_redirect, there is no copying to skb again. If I don't allocate a
> > new page, it always crashes at
> > [62020.425932] BUG: Bad page state in process cpumap/0/map:29  pfn:107548
> > [62020.440905] kernel BUG at include/linux/mm.h:757!
> >  VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
>
> What I was referring to was one copy here, and then another copy in
> your vmxnet3_xdp_xmit_frame() function with the page you allocated
> here possibly being leaked.
>
> Though based on the other trace you provided it would look like you
> are redirecting to something else as your code currently doesn't
> reference xdp_return_frame which is what I was referring to earlier in
> terms of missing the logic to free the frame in your transmit path.
yes, I tried a couple ways and now it's working.
basically I have to call get_page to increment the refcnt then call
xdp_return_frame. I will update performance number and send
next version.

Thanks
William
