Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84524655E29
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 20:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiLYTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 14:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYTKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 14:10:15 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69C8244
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 11:10:14 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id b16so10178751yba.0
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 11:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wZf3htMYZ6i7LN+syi1sAtSbSg82y6pgdEC6rRSOuWg=;
        b=mqwe23PTnxUNF+D+qcEzf58+jVwQmX3kXxq3C02q3gebmXGEdm/J09c8+CEwBXROXF
         7D23doLXWn7OfqLkPyQ2NGRiZOi8ZYNoPwjdTzgOcsxqZgFDpjuR7NXDJBKmp9hkKSEO
         4B5RABPTzVm1T62+JSgWrzCPSA7bMqaAwkbDoARHKjpYbn7H/4eqdPsfik81avpJJ7Xh
         IPay63H05A4/INsZ/GImp24SJfSIlGXY10yRkGQNrLYG/o2VDIeWkwKnL/C6XuBR+0eD
         lVb8p8tiFJDElTYiU0eL8H/yaCCnF8QKNqvvU/osM8igN7VM6/Bm/AbGQwDivH7K7Gxv
         omzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZf3htMYZ6i7LN+syi1sAtSbSg82y6pgdEC6rRSOuWg=;
        b=HysXV4BoLcpaGIhOV6WLi6w/ai/DDlvVBHHuO47o8oy2sCt9fOV53yvdne0ScUHwgv
         LVL1WZ1Re1KVAgcZs2sDG5rChrjfEAi1hnuLTRBaUXP7Iv4+C8KQ31rVag/51cEKjGY1
         YrQJj50lLSywjcghChK1D9coYAEY9w78pLtMNN7t1udl5FWREt5Rs9YwBttLTh9N5f2V
         au7QjLGxTTg+DV8MHbhM5dBg2+D5vmguYhW4UTf+Z1JO5ErGOiX9mpOsm+sm3ItIGs0F
         VSnUz+CN2TpE5lo+bcxWzhDqL7R2q94lKaBRhuJU3fgoudHXQr6XrHjIIjq4Wf1WNsZm
         cBBg==
X-Gm-Message-State: AFqh2kprqonbbyiZaqQ95LKhg0Fo43Moa0Wv0XWqXzyUgpB2RNoB8W4F
        AD2d2fHUO2mtZTIlpQOwkoLhCHvRHsc3nwtcGH0=
X-Google-Smtp-Source: AMrXdXs5Nfdwkr7V7/u9GMXo83AGfHsotJDPtPjA7viCop/XUZsNX1ENW3lpmYh7Fv+URrqQFEn2ANxg5rSNj1SPMeQ=
X-Received: by 2002:a5b:58c:0:b0:777:7e88:a3dd with SMTP id
 l12-20020a5b058c000000b007777e88a3ddmr451518ybp.356.1671995413683; Sun, 25
 Dec 2022 11:10:13 -0800 (PST)
MIME-Version: 1.0
References: <20221222154648.21497-1-u9012063@gmail.com> <6ca87c55-9cda-294e-43f2-2c9d74b91939@engleder-embedded.com>
In-Reply-To: <6ca87c55-9cda-294e-43f2-2c9d74b91939@engleder-embedded.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 25 Dec 2022 11:09:37 -0800
Message-ID: <CALDO+SZay_vErqqikAvA=p8nEGUT+1gkR3EyKMdObQqPyKGERg@mail.gmail.com>
Subject: Re: [RFC PATCH v7] vmxnet3: Add XDP support.
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
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

Hi Gerhard,

Thanks for taking a look at this patch!


On Thu, Dec 22, 2022 at 1:25 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On 22.12.22 16:46, William Tu wrote:
> > @@ -1776,6 +1800,7 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >
> >       rq->comp_ring.gen = VMXNET3_INIT_GEN;
> >       rq->comp_ring.next2proc = 0;
> > +     rq->xdp_bpf_prog = NULL;
>
> Reference to BPF program is lost without calling bpf_prog_put(). Are you
> sure this is ok? This function is called during ndo_stop too.

sure, I will do it!

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
> > +     bool need_update;
> > +     bool running;
> > +     int err = 0;
> > +
> > +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     old_bpf_prog = READ_ONCE(adapter->rx_queue[0].xdp_bpf_prog);
>
> Wouldn't it be simpler if xdp_bpf_prog is move from rx_queue to
> adapter?
Yes, I think it's easier to keep xdp_bpf_prog in adapter instead of
one in each rq, since it's all the same bpf prog.

>
> [...]
>
> > +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> > +int
> > +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> > +{
> > +     switch (bpf->command) {
> > +     case XDP_SETUP_PROG:
> > +             netdev_dbg(netdev, "XDP: set program to ");
>
> Did you forget to delete this debug output?
Yes, thanks!

>
> [...]
>
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
> > +             xdp_return_frame(frames[i]);
> > +             if (err) {
> > +                     tq->stats.xdp_xmit_err++;
> > +                     break;
> > +             }
> > +             nxmit++;
>
> You could just use the loop iterator and drop nxmit. I got this comment
> for one of my XDP patches from Saeed Mahameed.
Good idea.

>
> [...]
>
> Did you consider to split this patch into multiple patches to make
> review easier?

Sure, but I still want to make each patch as a fully working feature.
I will probably separate the XDP_REDIRECT feature into another one.


William
