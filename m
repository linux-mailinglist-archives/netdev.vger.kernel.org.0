Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F2164E0B4
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiLOS0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiLOSZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:25:27 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B90F49B61
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:25:26 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3f15a6f72d0so1645207b3.1
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mrdZ/aTLAvya+fD1g9Bz5EjCm9Cq75n/uqIEg/TN3js=;
        b=bN4LEeR5xno9op+pXByt/BSQjrOlHcHm70zkgbtAJYHmF3BT8ktESRshtjTu9rFXiM
         0y99umOSost4nb/q83TskU4F3xMD1elMYMwk1lpjJKdrOqx7RGJVlYaZnTAGBL3dN2Ij
         N6blj5qFdVDMH60hSeI7vI80QbT1ikimwibLeFSi6K0lH8UafWjw1Ge3kGSuQfz7TAJb
         PZ7JA0tifxHfmdlM7pTIFY/AleLNS1NG10B4wsAEC++03P9jsGgYd70aGWh1qnp+JanH
         WEKAKYd0+bLtJm/Od4E8aReGaI3hDnUM1g5329ahdanSFTrQI5MI4/F2cRwofWMPBejS
         6v+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mrdZ/aTLAvya+fD1g9Bz5EjCm9Cq75n/uqIEg/TN3js=;
        b=OSjulKv2JQlQfSWkS62Dz2dyZNwfphsp6Hb+jDliNSXoKO33ETARvMFED1qu+H2EQq
         v7tlu2AQB3p9X+0SbM7DaHlRXt7hUabgRB7nbQWLNCEfU0Kd9DNhvW1SLPJhaLTCled2
         rWM55nQ9YOy3FnXnzbdyFn/H6eDqShz/DKY6L9YNV2125nXAulj5xFVh2cu21QzmQvzX
         tn/4szK8b5rNJU3QAEx3+ZgDI7d77/CvkIJ7DkeV46Vh0ZnmY+H8oroGDjPPfOWK01IF
         cmzTl8Zj7SRnlV15IjW/KNc3f0TLuq2s2g8Vp9ld5qEdzQcOI2orHsBN+WaD1mrA/Ois
         9BVg==
X-Gm-Message-State: ANoB5plqSYTP+oEZKcdZ4SYhTbCdMwyczla1esVAKv5F6kzR/UmMVOHS
        vGekiFNuQyc/lNs3jfzhz9k2MXafc+iqSuTriBWj1tEV
X-Google-Smtp-Source: AA0mqf6bxHIvz7euloJOXF8yWOsByupIlphCWKwEG9KMEt7Qte+q3uQNQ3PypZhcAl3EjpbT7WdIpFhlGlHWez0Xg04=
X-Received: by 2002:a81:1dc4:0:b0:3ab:d729:399 with SMTP id
 d187-20020a811dc4000000b003abd7290399mr9475808ywd.36.1671128725378; Thu, 15
 Dec 2022 10:25:25 -0800 (PST)
MIME-Version: 1.0
References: <20221214000555.22785-1-u9012063@gmail.com> <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
 <CALDO+SaoW5XoroBMoYLWsqCvYYVkKiTFFPMTLUEt7Qu5rQ+z3Q@mail.gmail.com> <c213b4c3e8774e59389948b3b9b3ff132043dfcf.camel@gmail.com>
In-Reply-To: <c213b4c3e8774e59389948b3b9b3ff132043dfcf.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 15 Dec 2022 10:24:49 -0800
Message-ID: <CALDO+Sax4=0tkq1xeH5W3FGaqXtweHj=eKFAUf15J2k7K1_4hA@mail.gmail.com>
Subject: Re: [RFC PATCH v5] vmxnet3: Add XDP support.
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

On Wed, Dec 14, 2022 at 2:51 PM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2022-12-14 at 13:55 -0800, William Tu wrote:
> > Thanks for taking a look at this patch!
> >
> > <...>
> > >
> > > > +int
> > > > +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> > > > +                 struct vmxnet3_rx_queue *rq,
> > > > +                 struct Vmxnet3_RxCompDesc *rcd,
> > > > +                 struct vmxnet3_rx_buf_info *rbi,
> > > > +                 struct Vmxnet3_RxDesc *rxd,
> > > > +                 bool *need_flush)
> > > > +{
> > > > +     struct bpf_prog *xdp_prog;
> > > > +     dma_addr_t new_dma_addr;
> > > > +     struct sk_buff *new_skb;
> > > > +     bool rxDataRingUsed;
> > > > +     int ret, act;
> > > > +
> > > > +     ret = VMXNET3_XDP_CONTINUE;
> > > > +     if (unlikely(rcd->len == 0))
> > > > +             return VMXNET3_XDP_TAKEN;
> > > > +
> > > > +     rxDataRingUsed = VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> > > > +     rcu_read_lock();
> > > > +     xdp_prog = rcu_dereference(rq->xdp_bpf_prog);
> > > > +     if (!xdp_prog) {
> > > > +             rcu_read_unlock();
> > > > +             return VMXNET3_XDP_CONTINUE;
> > > > +     }
> > > > +     act = vmxnet3_run_xdp(rq, rbi, rcd, need_flush, rxDataRingUsed);
> > > > +     rcu_read_unlock();
> > > > +
> > > > +     switch (act) {
> > > > +     case XDP_PASS:
> > > > +             ret = VMXNET3_XDP_CONTINUE;
> > > > +             break;
> > > > +     case XDP_DROP:
> > > > +     case XDP_TX:
> > > > +     case XDP_REDIRECT:
> > > > +     case XDP_ABORTED:
> > > > +     default:
> > > > +             /* Reuse and remap the existing buffer. */
> > > > +             ret = VMXNET3_XDP_TAKEN;
> > > > +             if (rxDataRingUsed)
> > > > +                     return ret;
> > > > +
> > > > +             new_skb = rbi->skb;
> > > > +             new_dma_addr =
> > > > +                     dma_map_single(&adapter->pdev->dev,
> > > > +                                    new_skb->data, rbi->len,
> > > > +                                    DMA_FROM_DEVICE);
> > > > +             if (dma_mapping_error(&adapter->pdev->dev,
> > > > +                                   new_dma_addr)) {
> > > > +                     dev_kfree_skb(new_skb);
> > > > +                     rq->stats.drop_total++;
> > > > +                     return ret;
> > > > +             }
> > > > +             rbi->dma_addr = new_dma_addr;
> > > > +             rxd->addr = cpu_to_le64(rbi->dma_addr);
> > > > +             rxd->len = rbi->len;
> > > > +     }
> > > > +     return ret;
> > > > +}
> > >
> > > FOr XDP_DROP and XDP_ABORTED this makes sense. You might want to add a
> > > trace point in the case of aborted just so you can catch such cases for
> > > debug.
> > Good point, I will add the trace point.
> >
>
> You will probably want to add that trace point in __vmxnet3_run_xdp.

Yes, thanks.

>
> > > However for XDP_TX and XDP_REDIRECT shouldn't both of those be calling
> > > out to seperate functions to either place the frame on a Tx ring or to
> > > hand it off to xdp_do_redirect so that the frame gets routed where it
> > > needs to go? Also don't you run a risk with overwriting frames that
> > > might be waiting on transmit?
> >
> > Yes, I have XDP_TX and XDP_REDIRECT handled in another function,
> > the vmxnet3_run_xdp() and __vmxnet3_run_xdp().
>
> Okay, for the redirect case it looks like you address it by doing a
> memcpy to a freshly allocated page so that saves us that trouble in
> that case.
>
> > How do I avoid overwriting frames that might be waiting on transmit?
> > I checked my vmxnet3_xdp_xmit_back and vmxnet3_xdp_xmit_frame,
> > I think since I called the vmxnet3_xdp_xmit_frame at the rx context,
> > it should be ok?
>
> I don't think you can guarantee that. Normally for TX you would want to
> detach and replace the page unless you have some sort of other
> recycling/reuse taking care of it for you. Normally that is handled via
> page pool.
>
> On the Intel parts I had gotten around that via our split buffer model
> so we just switched to the other half of the page while the Tx sat on
> the first half, and by the time we would have to check again we would
> either detach the page for flip back if it had already been freed by
> the Tx path.
I see your point. So for XDP_TX, I can also do s.t like I did in XDP_REDIRECT,
memcpy to a freshly allocated page so the frame won't get overwritten.
Probably the performance will suffer.
Do you suggest allocating new page or risk buffer overwritten?

>
> > +static int
> > +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> > +                   struct xdp_frame *xdpf,
> > +                   struct sk_buff *skb)
> >
>
> Also after re-reviewing this I was wondering why you have the skb
> argument for this function? The only caller is passing NULL and I
> wouldn't expect you to be passing an skb since you are working with XDP
> buffers anyway. Seems like you could also drop the argument from
> vmxnet3_xdp_xmit_frame() since you are only passing it NULL as well.

You're right! I don't need to pass skb here. I probably forgot to remove it
when refactoring code. Will remove the two places.
Thanks!

Regards,
William
