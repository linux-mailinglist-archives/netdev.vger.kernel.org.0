Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516E62D215B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgLHDQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgLHDQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:16:52 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD84C061749;
        Mon,  7 Dec 2020 19:16:12 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id n14so15538849iom.10;
        Mon, 07 Dec 2020 19:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mcPbHa59gCWnnXiltyhXQn/v9U9gEcSU1OBLz+rblhQ=;
        b=pdyVBzz4YCTsl/wp45iXLVfBw5NdaF9UT7NrGagJciiDYne+fJ2N6dmWbKs6MrrQNR
         QVGXFIVAi34OlWPRMcYuTeWW6W80qKTOq8D62GHgSU797/toh166SYD7P95HoieYOlkO
         vCUqE9UsmIK4d2XznT/hXD8CivWBfie2diWXp8wHDFupHLRfpNYvE27PBPpcpjV8nUwi
         cLxRdYfd8kGeZhFvyMPk/bn+rbuHu5QDZgLOsd9ykj+E9PC89RBt3qqAErIJgl6ECp6Y
         wL7akNt6nsONGeYvkg8QMLndw29Z97HClGOq2Tr9f51b8/EcJUyNVuc7ssYSDVWh/0wh
         8JJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mcPbHa59gCWnnXiltyhXQn/v9U9gEcSU1OBLz+rblhQ=;
        b=KVgNwPQzkrzm3danuFiR08g/uIOmZPIxVCQRXvsqBs39RwAhyOge1KzKQ1dyFAbCgp
         wnkTynLI5gHavijPsicAbPEkvPKbum9RBRQtm8snLUffOhQYsOjCYAOvmiAZ/99tNxt7
         iDBVJ9feYm4E9az0QnHW9wO4X6/U1BtCMNmCIwfg0Mb/knXjw2nAduevU6ZH8XedrI6l
         SGIwSbI9XhWFGxbV8JbAqV0un4BM84PRHOetInyK3p1m3xe0mxnYLRSgVBRWA/izxnk1
         4vRIAhFACpT/9IrqJU1auW8T/gaN83/0uFUqDpg2gHefVUZcaEgZw7gfW60lZ8A9TclW
         94yw==
X-Gm-Message-State: AOAM53013szsXRLErctHgAmGsIZCGhasoer5KkmSlr1XlfP0GTfTaMK6
        kApsPrBK26kG/wETUkrOzh3wEEbchC5iifYror0=
X-Google-Smtp-Source: ABdhPJyfpNTi+hc/2lZq7V/fn+Qh1iwvtLEvoXSe4exkSGTyuCKVGhFqVAWblPTB0y46QTBcpgvqvyXC9T+3nBVOZH4=
X-Received: by 2002:a5d:8344:: with SMTP id q4mr22971251ior.38.1607397371582;
 Mon, 07 Dec 2020 19:16:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607349924.git.lorenzo@kernel.org> <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
 <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com> <46fae597d42d28a7246ba08b0652b0114b7f5255.camel@kernel.org>
In-Reply-To: <46fae597d42d28a7246ba08b0652b0114b7f5255.camel@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Dec 2020 19:16:00 -0800
Message-ID: <CAKgT0UeR8ErY4AOAiWxpR-j8QEs7GqCGrx58-7oaU3fnV=sU3Q@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 3:03 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2020-12-07 at 13:16 -0800, Alexander Duyck wrote:
> > On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org>
> > wrote:
> > > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data
> > > structure
> > > in order to specify if this is a linear buffer (mb = 0) or a multi-
> > > buffer
> > > frame (mb = 1). In the latter case the shared_info area at the end
> > > of the
> > > first buffer is been properly initialized to link together
> > > subsequent
> > > buffers.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  include/net/xdp.h | 8 ++++++--
> > >  net/core/xdp.c    | 1 +
> > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > index 700ad5db7f5d..70559720ff44 100644
> > > --- a/include/net/xdp.h
> > > +++ b/include/net/xdp.h
> > > @@ -73,7 +73,8 @@ struct xdp_buff {
> > >         void *data_hard_start;
> > >         struct xdp_rxq_info *rxq;
> > >         struct xdp_txq_info *txq;
> > > -       u32 frame_sz; /* frame size to deduce
> > > data_hard_end/reserved tailroom*/
> > > +       u32 frame_sz:31; /* frame size to deduce
> > > data_hard_end/reserved tailroom*/
> > > +       u32 mb:1; /* xdp non-linear buffer */
> > >  };
> > >
> >
> > If we are really going to do something like this I say we should just
> > rip a swath of bits out instead of just grabbing one. We are already
> > cutting the size down then we should just decide on the minimum size
> > that is acceptable and just jump to that instead of just stealing one
> > bit at a time. It looks like we already have differences between the
> > size here and frame_size in xdp_frame.
> >
>
> +1
>
> > If we have to steal a bit why not look at something like one of the
> > lower 2/3 bits in rxq? You could then do the same thing using dev_rx
> > in a similar fashion instead of stealing from a bit that is likely to
> > be used in multiple spots and modifying like this adds extra overhead
> > to?
> >
>
> What do you mean in rxq ? from the pointer ?

Yeah, the pointers have a few bits that are guaranteed 0 and in my
mind reusing the lower bits from a 4 or 8 byte aligned pointer would
make more sense then stealing the upper bits from the size of the
frame.
