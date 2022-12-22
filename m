Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEACD6544B9
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiLVP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiLVP6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:58:40 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C95BE9
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:58:39 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-45f4aef92daso32848557b3.0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uPHiiB/tFZ41pHEtoTusdICFC4Yptrzs53c/JI0tZuY=;
        b=QONG2/MhpjNLp3TH4rh6QHm0lPHOvRm9VOYs7aJ65Tcd1cg5L8PXmQb3BvlHLww8qj
         k0LljfDbYPN1KfkpOfSGkwVIUZjsoIN7n3zCsnNMJav9Iboajw+YR6OJ5b/A1/fEg0Zh
         ym7J1qvr4fYWSjKOpLVmg8pBuUCSZMbDBxikSjYAal92wKgyUpfqnEGwiBA3dTiw8wxr
         DQugMhCUOAknCgah/w/2fUZyOz1DQeNJ2c470OKcJtj//hU/a1GmapsSl02abZjsadFW
         RMIIiEXH/cj2rEwS9pVRNRfXWFPXaXRQswYsCMOW7VE/C3Qnfle/wzu8jdW3OcHysCql
         56uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uPHiiB/tFZ41pHEtoTusdICFC4Yptrzs53c/JI0tZuY=;
        b=b0YhYWWkqirQmzeN9EqiT0OkRfgwOZxaevYBFLKV+gUwy+Q208xt8eXStPP2b+9ymu
         AhIgW5GdCU7ZsmD1u1QdNjIBDLmG+SZdbkxDOqVO47QPvrjV6N4ZjNPh8ABA3OUyboVk
         RzCUC6OWz8n2s+ig8Wlvw4DDxfp8sohqcXJZD3Zf5AbJUii5LGb48lqSxpEFl03BN2+1
         MrB1Idjf5Z3Et2Rg1IZjP25/qY/TvWYukAXnfInywO7VlakqwXb8vudwEkO1Le4jtNJN
         DLMG7TVK1Rf4qwXMht/M9BhelUHnOtEZpVwg/8KAqTo7jrqTpoFUDBCvAs7D2QIINP42
         2HOA==
X-Gm-Message-State: AFqh2krKTLkWiWKn4dljeviG9W5Bpl0LjU3ay6uPTZZJ1cjnodR+mOk2
        jWUYd7nCwiaSYaOtIIbcT5zF9RRDtdrFGlxTYyI=
X-Google-Smtp-Source: AMrXdXvrHQ2kovz004UtrHTPtA+wn5WMwOmkmHCve+W9QrUHhdkjkPEFz/PqImTlU8ke6a4pg46oxbMKsxk94VdRyO4=
X-Received: by 2002:a81:9ac9:0:b0:3b3:174d:7a6b with SMTP id
 r192-20020a819ac9000000b003b3174d7a6bmr726274ywg.204.1671724718213; Thu, 22
 Dec 2022 07:58:38 -0800 (PST)
MIME-Version: 1.0
References: <20221216144118.10868-1-u9012063@gmail.com> <c4c62a4563d6669ca3c5d5efee0e54bc8742f27d.camel@gmail.com>
 <CALDO+SaKd74n_PDB+kN0KQWt_Zh9NjzPAm-kWfie4Vd+jOeCZw@mail.gmail.com>
 <CAKgT0UehKpZMhcCgDPg00BoajxaZ23L9OzZ9GAgQd74xW6zkqw@mail.gmail.com> <CALDO+SYz2LYk8_tvwoY75OVT-7B3_HgjF8PTnUN9hdDL+pucwQ@mail.gmail.com>
In-Reply-To: <CALDO+SYz2LYk8_tvwoY75OVT-7B3_HgjF8PTnUN9hdDL+pucwQ@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 22 Dec 2022 07:58:02 -0800
Message-ID: <CALDO+Sb7bFD3mwdsRdiDE=tdCsqwM-OSQ3MK4Ev9abM8Ay2h1Q@mail.gmail.com>
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

> > > > > +     return nxmit;
> > > > > +}
> > > > > +
> > > > > +static int
> > > > > +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> > > > > +               int headroom, int frame_sz, bool *need_xdp_flush,
> > > > > +               struct sk_buff *skb)
> > > > > +{
> > > > > +     struct xdp_frame *xdpf;
> > > > > +     void *buf_hard_start;
> > > > > +     struct xdp_buff xdp;
> > > > > +     struct page *page;
> > > > > +     void *orig_data;
> > > > > +     int err, delta;
> > > > > +     int delta_len;
> > > > > +     u32 act;
> > > > > +
> > > > > +     buf_hard_start = data;
> > > > > +     xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > > > > +     xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> > > > > +     orig_data = xdp.data;
> > > > > +
> > > > > +     act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> > > > > +     rq->stats.xdp_packets++;
> > > > > +
> > > > > +     switch (act) {
> > > > > +     case XDP_DROP:
> > > > > +             rq->stats.xdp_drops++;
> > > > > +             break;
> > > > > +     case XDP_PASS:
> > > > > +             /* bpf prog might change len and data position.
> > > > > +              * dataring does not use skb so not support this.
> > > > > +              */
> > > > > +             delta = xdp.data - orig_data;
> > > > > +             delta_len = (xdp.data_end - xdp.data) - data_len;
> > > > > +             if (skb) {
> > > > > +                     skb_reserve(skb, delta);
> > > > > +                     skb_put(skb, delta_len);
> > > > > +             }
> > > > > +             break;
> > > > > +     case XDP_TX:
> > > > > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > > > > +             if (!xdpf ||
> > > > > +                 vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > > > > +                     rq->stats.xdp_drops++;
> > > > > +             } else {
> > > > > +                     rq->stats.xdp_tx++;
> > > > > +             }
> > > > > +             break;
> > > > > +     case XDP_ABORTED:
> > > > > +             trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> > > > > +                                 act);
> > > > > +             rq->stats.xdp_aborted++;
> > > > > +             break;
> > > > > +     case XDP_REDIRECT:
> > > > > +             page = alloc_page(GFP_ATOMIC);
> > > > > +             if (!page) {
> > > > > +                     rq->stats.rx_buf_alloc_failure++;
> > > > > +                     return XDP_DROP;
> > > > > +             }
> > > >
> > > > So I think I see the problem I had questions about here. If I am not
> > > > mistaken you are copying the buffer to this page, and then copying this
> > > > page to an skb right? I think you might be better off just writing off
> > > > the Tx/Redirect pages and letting them go through their respective
> > > > paths and just allocating new pages instead assuming these pages were
> > > > consumed.

Hi Alexander,

I tried to implement your suggestion above: remove the alloc_page, let
the original
pages go through the redirect path (the xdp_do_redirect), and then allocate new
buffer to refill rx ring but hit some memleak issue.
The XDP_PASS/DROP/TX are good without leak, but not REDIRECT.
I sent out v7, do you mind taking another look?

Thanks!
William


> > >
> > > I'm not sure I understand, can you elaborate?
> > >
> > > For XDP_TX, I'm doing 1 extra copy, copying to the newly allocated skb
> > > in vmxnet3_xdp_xmit_back.
> > > For XDP_REDIREC, I allocate a page and copy to the page and call
> > > xdp_do_redirect, there is no copying to skb again. If I don't allocate a
> > > new page, it always crashes at
> > > [62020.425932] BUG: Bad page state in process cpumap/0/map:29  pfn:107548
> > > [62020.440905] kernel BUG at include/linux/mm.h:757!
> > >  VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
> >
> > What I was referring to was one copy here, and then another copy in
> > your vmxnet3_xdp_xmit_frame() function with the page you allocated
> > here possibly being leaked.
> >
> > Though based on the other trace you provided it would look like you
> > are redirecting to something else as your code currently doesn't
> > reference xdp_return_frame which is what I was referring to earlier in
> > terms of missing the logic to free the frame in your transmit path.
> yes, I tried a couple ways and now it's working.
> basically I have to call get_page to increment the refcnt then call
> xdp_return_frame. I will update performance number and send
> next version.
>
> Thanks
> William
