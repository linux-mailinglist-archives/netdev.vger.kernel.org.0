Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1FE64D296
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 23:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLNWvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 17:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLNWvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 17:51:31 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A471205E6
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:51:30 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d3so4943523plr.10
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tLBnyMGHR0zwFzGn+F+AOOpE3l8HpRK9u0f8I+O5fZk=;
        b=ZRKGvQhpbp7BezVOAoCEPXsnFCZ8RAA6ggQkumLi9+UGaA9rCKyyBfEmaHi1Kq+RFq
         /duTtc66gcEtzdr2ggQIN9kddYHks04i4GVXQMOW0mXFET2wSw0gAn0ugA0Mo/3zFRE+
         7QE7ic1LVyhIdkpf2AFiSQtjlIYJFQjQx7zbBeiWSVaFxKelTL72HAUwP4dXUQ5hYjsJ
         bnwbwUHyCL8TCjsIixkkZRWtHhyKj2IcZz+Eu+TSrrBK6PW6iDz72OP5Czw/T32v8NRi
         tO1Y747eDXeGO0XojQlj89Qc7ELVFmzx4uorqWzK8wiwXVPWC1GP+ow2TtFRVZ4bolFu
         vePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tLBnyMGHR0zwFzGn+F+AOOpE3l8HpRK9u0f8I+O5fZk=;
        b=3e54pJq8K+DD+dc+EQtsnC7rDqSE3d53cuZ/x1QPWVcUJGP1l/d0ppxndHKE3SnuAH
         pF9NYZ8ZXGvo8yZJ2HuBcD9cDnOUBOHIFu2OiImSsRwf0PImU0MiUAFVnLpEXa2EWhxQ
         gsc9GAopEk3cbO+Xedp/Qyy5fqaVoWlJVblwIgxvWPtNUqvQ7IN7EC1kLRafRLduLtBA
         Jftqn4pu/wCnKDwkYXKlqdbncyG8u1WIWGuhmTxrgHsBfxsgQfATmkx6bz/iettKfruI
         zVy54/Yu6G3OhqacBEIkKCTY1OlnBdLjqJ/oTBHow/kMa2qb5vg3Lq5b9B6wy1Nd9hvC
         GZZw==
X-Gm-Message-State: ANoB5pm5Yl+zagpHlUnn1QWV9zh/z6FUw02JRW8g2SIZ+Ai2v0Rt35B4
        T0UHoQVdnELYRXrwfxg9fmo=
X-Google-Smtp-Source: AA0mqf4LG2ye0fhSanBMDxmMFpzxtHVU/4p1Po5EP1rNVUbaKyEBeep09j8z3s/AaEy+YvUobkPLOg==
X-Received: by 2002:a17:902:c1c5:b0:185:441f:709c with SMTP id c5-20020a170902c1c500b00185441f709cmr25424941plc.33.1671058289640;
        Wed, 14 Dec 2022 14:51:29 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id o1-20020a170902bcc100b0017c37a5a2fdsm2325709pls.216.2022.12.14.14.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 14:51:29 -0800 (PST)
Message-ID: <c213b4c3e8774e59389948b3b9b3ff132043dfcf.camel@gmail.com>
Subject: Re: [RFC PATCH v5] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com
Date:   Wed, 14 Dec 2022 14:51:27 -0800
In-Reply-To: <CALDO+SaoW5XoroBMoYLWsqCvYYVkKiTFFPMTLUEt7Qu5rQ+z3Q@mail.gmail.com>
References: <20221214000555.22785-1-u9012063@gmail.com>
         <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
         <CALDO+SaoW5XoroBMoYLWsqCvYYVkKiTFFPMTLUEt7Qu5rQ+z3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 13:55 -0800, William Tu wrote:
> Thanks for taking a look at this patch!
>=20
> <...>
> >=20
> > > +int
> > > +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> > > +                 struct vmxnet3_rx_queue *rq,
> > > +                 struct Vmxnet3_RxCompDesc *rcd,
> > > +                 struct vmxnet3_rx_buf_info *rbi,
> > > +                 struct Vmxnet3_RxDesc *rxd,
> > > +                 bool *need_flush)
> > > +{
> > > +     struct bpf_prog *xdp_prog;
> > > +     dma_addr_t new_dma_addr;
> > > +     struct sk_buff *new_skb;
> > > +     bool rxDataRingUsed;
> > > +     int ret, act;
> > > +
> > > +     ret =3D VMXNET3_XDP_CONTINUE;
> > > +     if (unlikely(rcd->len =3D=3D 0))
> > > +             return VMXNET3_XDP_TAKEN;
> > > +
> > > +     rxDataRingUsed =3D VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> > > +     rcu_read_lock();
> > > +     xdp_prog =3D rcu_dereference(rq->xdp_bpf_prog);
> > > +     if (!xdp_prog) {
> > > +             rcu_read_unlock();
> > > +             return VMXNET3_XDP_CONTINUE;
> > > +     }
> > > +     act =3D vmxnet3_run_xdp(rq, rbi, rcd, need_flush, rxDataRingUse=
d);
> > > +     rcu_read_unlock();
> > > +
> > > +     switch (act) {
> > > +     case XDP_PASS:
> > > +             ret =3D VMXNET3_XDP_CONTINUE;
> > > +             break;
> > > +     case XDP_DROP:
> > > +     case XDP_TX:
> > > +     case XDP_REDIRECT:
> > > +     case XDP_ABORTED:
> > > +     default:
> > > +             /* Reuse and remap the existing buffer. */
> > > +             ret =3D VMXNET3_XDP_TAKEN;
> > > +             if (rxDataRingUsed)
> > > +                     return ret;
> > > +
> > > +             new_skb =3D rbi->skb;
> > > +             new_dma_addr =3D
> > > +                     dma_map_single(&adapter->pdev->dev,
> > > +                                    new_skb->data, rbi->len,
> > > +                                    DMA_FROM_DEVICE);
> > > +             if (dma_mapping_error(&adapter->pdev->dev,
> > > +                                   new_dma_addr)) {
> > > +                     dev_kfree_skb(new_skb);
> > > +                     rq->stats.drop_total++;
> > > +                     return ret;
> > > +             }
> > > +             rbi->dma_addr =3D new_dma_addr;
> > > +             rxd->addr =3D cpu_to_le64(rbi->dma_addr);
> > > +             rxd->len =3D rbi->len;
> > > +     }
> > > +     return ret;
> > > +}
> >=20
> > FOr XDP_DROP and XDP_ABORTED this makes sense. You might want to add a
> > trace point in the case of aborted just so you can catch such cases for
> > debug.
> Good point, I will add the trace point.
>=20

You will probably want to add that trace point in __vmxnet3_run_xdp.

> > However for XDP_TX and XDP_REDIRECT shouldn't both of those be calling
> > out to seperate functions to either place the frame on a Tx ring or to
> > hand it off to xdp_do_redirect so that the frame gets routed where it
> > needs to go? Also don't you run a risk with overwriting frames that
> > might be waiting on transmit?
>=20
> Yes, I have XDP_TX and XDP_REDIRECT handled in another function,
> the vmxnet3_run_xdp() and __vmxnet3_run_xdp().

Okay, for the redirect case it looks like you address it by doing a
memcpy to a freshly allocated page so that saves us that trouble in
that case.

> How do I avoid overwriting frames that might be waiting on transmit?
> I checked my vmxnet3_xdp_xmit_back and vmxnet3_xdp_xmit_frame,
> I think since I called the vmxnet3_xdp_xmit_frame at the rx context,
> it should be ok?

I don't think you can guarantee that. Normally for TX you would want to
detach and replace the page unless you have some sort of other
recycling/reuse taking care of it for you. Normally that is handled via
page pool.

On the Intel parts I had gotten around that via our split buffer model
so we just switched to the other half of the page while the Tx sat on
the first half, and by the time we would have to check again we would
either detach the page for flip back if it had already been freed by
the Tx path.

> +static int
> +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> +		      struct xdp_frame *xdpf,
> +		      struct sk_buff *skb)
>=20

Also after re-reviewing this I was wondering why you have the skb
argument for this function? The only caller is passing NULL and I
wouldn't expect you to be passing an skb since you are working with XDP
buffers anyway. Seems like you could also drop the argument from
vmxnet3_xdp_xmit_frame() since you are only passing it NULL as well.


