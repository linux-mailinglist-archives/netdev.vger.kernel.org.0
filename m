Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7CA3B77AE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhF2SVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhF2SVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:21:19 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51938C061760;
        Tue, 29 Jun 2021 11:18:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id df12so32558758edb.2;
        Tue, 29 Jun 2021 11:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u8B55JVj3AHVWP+WA2JTXK0VtfPUkYfFdM8DAYJ94K8=;
        b=Oj1hZbqoyaxC3a03uu3RoxsEX2KpBeNdnDcvAx0HRov11NnOTWwUyoOI+vRvt9h/d5
         QZFVJt7QW2fJBQ4fWcTgBWzGrEBmkQsDmQyta0Pbyrs9fu4OXop9G1bg+Beh+ideJS5O
         b5IQwu5CR6IYrHowV6Tlah2Als/cI/tVsJibX31tTpGsGGAUDUzJwWZcEdsN9uWitj5k
         VeOVkAaTMRgKwYzbFUiiWXcMTJoAiq5JzW++wKJPOYMASl7mMGVFmO2+OZWgn3yfueae
         QRaLPs0c4efNoYg97ipHDVfJ6bKKD0+tyhw3MEp3xvNvdxmRPdhOD/OdugyLWoMTk3GU
         SAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u8B55JVj3AHVWP+WA2JTXK0VtfPUkYfFdM8DAYJ94K8=;
        b=e/GPhV0dcou7EzRqt8mOSoBZLZ8pLj/Edb5IqLSVNV4wOJg7OC/kRWsMtERgf/ojHf
         HqY3Y2b77CTPhApEhoaqnJ00LL3HKifVilyEIOfu+qfaeH0T85Yrw8ganifxN8dsM/bb
         KyccsQEvA/w35chwTLGmwa67SEskVqc18fRIOIXwxJczDIQ0R90oOO4QUoAeLbBd4ccC
         n5btbfkfvUGb2dfHsZIS0PgFP+Hw+XO2qNCgm4xeOD0qFP0O6Er4zH4FpfxWqgfgfty5
         kFzCOuqeApgAPS7Zh6Z6cwSz6pGy2yDo/zwmDarOnk+4vM3+oS+vRL+d3iEEBRd7aQQu
         njVg==
X-Gm-Message-State: AOAM530cdZ9S3MLdXLJZf6oRgHXzxNlvpcms2/kgtQHdRofYUbGVOC+Z
        PFFDKO9z+Sev4hf1YXTi0WoXUr0cuhpkuhfIvdw=
X-Google-Smtp-Source: ABdhPJxzAJ0szesTe7JW6TDJuRTAyrftNGfJQgw9yRGPv+2hlkdSGCHW0ZJKkKzrnzSVjl+NDBbJE70V8B6q4l0F+dw=
X-Received: by 2002:a05:6402:1d2d:: with SMTP id dh13mr29174672edb.282.1624990729843;
 Tue, 29 Jun 2021 11:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
 <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
 <YNsVyBw5i4hAHRN8@lore-desk> <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 29 Jun 2021 11:18:38 -0700
Message-ID: <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to skb_shared_info
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 10:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 29 Jun 2021 14:44:56 +0200 Lorenzo Bianconi wrote:
> > > On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > >
> > > > data_len field will be used for paged frame len for xdp_buff/xdp_frame.
> > > > This is a preliminary patch to properly support xdp-multibuff
> > > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  include/linux/skbuff.h | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > > index dbf820a50a39..332ec56c200d 100644
> > > > --- a/include/linux/skbuff.h
> > > > +++ b/include/linux/skbuff.h
> > > > @@ -522,7 +522,10 @@ struct skb_shared_info {
> > > >         struct sk_buff  *frag_list;
> > > >         struct skb_shared_hwtstamps hwtstamps;
> > > >         unsigned int    gso_type;
> > > > -       u32             tskey;
> > > > +       union {
> > > > +               u32     tskey;
> > > > +               u32     data_len;
> > > > +       };
> > > >
> > >
> > > Rather than use the tskey field why not repurpose the gso_size field?
> > > I would think in the XDP paths that the gso fields would be unused
> > > since LRO and HW_GRO would be incompatible with XDP anyway.
> >
> > ack, I agree. I will fix it in v10.
>
> Why is XDP mb incompatible with LRO? I thought that was one of the use
> cases (mentioned by Willem IIRC).

XDP is meant to be a per packet operation with support for TX and
REDIRECT, and LRO isn't routable. So we could put together a large LRO
frame but we wouldn't be able to break it apart again. If we allow
that then we are going to need a ton more exception handling added to
the XDP paths.

As far as GSO it would require setting many more fields in order to
actually make it offloadable by any hardware. My preference would be
to make use of gso_segs and gso_size to store the truesize and datalen
of the pages. That way we keep all of the data fields used in the
shared info in the first 8 bytes assuming we don't end up having to
actually use multiple buffers.
