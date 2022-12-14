Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3A964D202
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 22:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiLNV4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 16:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiLNV4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 16:56:21 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D421024950
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 13:56:20 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y135so1373648yby.12
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 13:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fgIb49LfLEKYwY6gwAC111+PjN7tRIIRREUluv9BAWA=;
        b=g4mUc9toM6ilIIZh5TwCVOjFPQJDMZNAc2rk+SED6lZy6AvD4gKsP6gvti3irCXiht
         +GkYNXcCJDhvXLAYia1/iX65lYE813emAeySjAsIPtrvIWfMymXMhdjgtD99mqsvKGBV
         HOLjcJg90AyQ1Y56mE50aU/EvPVcgnRh/yPQEJepVXaBONn0tBlmjcFBD0hVmtFlRH2p
         0tFb7EoEqkUT87UWlBoqFWWPv94qhh+gQRy2svy+Oa7YjK8I6bib8m2pJiApArLXsx7g
         EDKdP9c9eT1x2/TXrMbDYESJi/iZ0LixtiRabXRI7BQHxAxu1orIL/CXvSz84QPT5tCX
         66Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgIb49LfLEKYwY6gwAC111+PjN7tRIIRREUluv9BAWA=;
        b=nKzjyxaZwNppqmcNRQP/LPrNQ6UkB3pQFYEKpOFDccZYMijkVteahWv/wpbjHx9DI6
         3fcuPtw4HePX8+QERttcl0Mmf3y1+O9z+/1/nuVvTiRgqm3gpr8ugk6MgzRNvDYG66qx
         1HWMTm2WVxoRFGhWJCC18fUA4Wq0e3mosj7u15wJEKielDcLaUc04PimxsrQXlDS9pXG
         Lk73sP4AxWGncPD5ziIGDs0HU1/rL2yre2sz9YJ8wlrq0J/unda+lS9wjiSkWkJ/OTSE
         l4mEfZvPG2JkKFWZvS/4UPoYKkwc0zyImaoQsJCpAXFqDeCgxScyekZXKSzguLN5rMk5
         bB0w==
X-Gm-Message-State: ANoB5pl8ghrmkiHcxoQCOuEOTPHpPX1P10yaPsDMR0hDM4bwZ3Vxtav+
        GxBkgX+4D+K8iGBf+qtQG+vfTZTI9+4tLxe+oog=
X-Google-Smtp-Source: AA0mqf7JqLqNibx3YlOtuq4tXtzAykutDyUcy6tYyEN21EyKioxLRbN5ZG3XsvZkEHc+3f0z3f17cuYuM73/qnmbkdE=
X-Received: by 2002:a25:5382:0:b0:6e9:6a91:7f7a with SMTP id
 h124-20020a255382000000b006e96a917f7amr76243039ybb.356.1671054979929; Wed, 14
 Dec 2022 13:56:19 -0800 (PST)
MIME-Version: 1.0
References: <20221214000555.22785-1-u9012063@gmail.com> <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
In-Reply-To: <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 14 Dec 2022 13:55:43 -0800
Message-ID: <CALDO+SaoW5XoroBMoYLWsqCvYYVkKiTFFPMTLUEt7Qu5rQ+z3Q@mail.gmail.com>
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

Thanks for taking a look at this patch!

<...>
>
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
> > +     bool rxDataRingUsed;
> > +     int ret, act;
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
> > +             ret = VMXNET3_XDP_CONTINUE;
> > +             break;
> > +     case XDP_DROP:
> > +     case XDP_TX:
> > +     case XDP_REDIRECT:
> > +     case XDP_ABORTED:
> > +     default:
> > +             /* Reuse and remap the existing buffer. */
> > +             ret = VMXNET3_XDP_TAKEN;
> > +             if (rxDataRingUsed)
> > +                     return ret;
> > +
> > +             new_skb = rbi->skb;
> > +             new_dma_addr =
> > +                     dma_map_single(&adapter->pdev->dev,
> > +                                    new_skb->data, rbi->len,
> > +                                    DMA_FROM_DEVICE);
> > +             if (dma_mapping_error(&adapter->pdev->dev,
> > +                                   new_dma_addr)) {
> > +                     dev_kfree_skb(new_skb);
> > +                     rq->stats.drop_total++;
> > +                     return ret;
> > +             }
> > +             rbi->dma_addr = new_dma_addr;
> > +             rxd->addr = cpu_to_le64(rbi->dma_addr);
> > +             rxd->len = rbi->len;
> > +     }
> > +     return ret;
> > +}
>
> FOr XDP_DROP and XDP_ABORTED this makes sense. You might want to add a
> trace point in the case of aborted just so you can catch such cases for
> debug.
Good point, I will add the trace point.

>
> However for XDP_TX and XDP_REDIRECT shouldn't both of those be calling
> out to seperate functions to either place the frame on a Tx ring or to
> hand it off to xdp_do_redirect so that the frame gets routed where it
> needs to go? Also don't you run a risk with overwriting frames that
> might be waiting on transmit?

Yes, I have XDP_TX and XDP_REDIRECT handled in another function,
the vmxnet3_run_xdp() and __vmxnet3_run_xdp().

How do I avoid overwriting frames that might be waiting on transmit?
I checked my vmxnet3_xdp_xmit_back and vmxnet3_xdp_xmit_frame,
I think since I called the vmxnet3_xdp_xmit_frame at the rx context,
it should be ok?

Thanks
William
