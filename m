Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03D30808B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhA1VaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhA1VaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:30:02 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A48C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:29:22 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id 19so6847986qkh.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+uMTE2gQNdtR0GMcHJgKl6VLAZaaMKLPr2o8+9GbD24=;
        b=Eg1lrl4rAGqCPlfw81ivMyFxx6fiwxGEuk2V5JwdkWtJtneoNv08FkASa4BRacoGbn
         lzaFlY8xitM8ckLKcf7/kPWrhH+luJWW/d+EYdp4DOdfWB4eLRJEStr9+xGmxf/0X0Ey
         VSABtXKEe1Jar9dSPG8RK9xVa6DtNZJXdqCd15g9+zeUafX86/yGUEjK1mD3XeNBEWse
         yiydc6vQlsGle1w9l9jmyy7TGeMYefVSurnzieMoM3f6+nCQgDYGQTVJFbLuAQkP4eZK
         5FHDCzFuI2qc5rctrdFnC+4SE1jTHUj54CO29P99rrI7AB17lGptglON4hNUivYN8QX7
         m1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+uMTE2gQNdtR0GMcHJgKl6VLAZaaMKLPr2o8+9GbD24=;
        b=h1m5KzJ2yJq9AiT5Qdy64XfU+9G2Lq8RerHYW4b74uFCzo0AOUMLcZOP85EwgZiNZ/
         hHMO4NpVUI+7n4mFFfo8QaosTcZO+GaokdSnV3gLqcKlMCLtYCrC1PSVBSn3NfX8tUxE
         mRbX9QIrCVWCi2TMbzITyMzNSJi0I0iIffq+zfGcelmJjOFZxSU2KqmG8dooHTMZL1HH
         +NdrTxRgdFi1ChTsboDi/XoEW+kAT8yPLyHhp2FL39SAD+Qu4JR88/UIyysfDUCgMbKG
         0JVxt9Docm+4F/6N7w2Nh0P1f+1Xc0KzRDbH3tRST1UgkTQAvCuQXaCKiCoUP9JnSLD2
         hd6Q==
X-Gm-Message-State: AOAM531RoP6nrcTss07Y4S3g5U74AELO3NHWW3bo9G/HPbKPX61IcyQj
        lo9d+2tvBvkxXRHi+f92IY6A0PrGJKo1ELT2jlQ=
X-Google-Smtp-Source: ABdhPJwXaKBSIMOQRwu4/Ogw2zdYbu3zlAWASNcNuZp0ucc6vv21xwT47NQ1BBs+/A1Ux8Z132k6KgJi6LxXExDRmEI=
X-Received: by 2002:a37:a286:: with SMTP id l128mr1351861qke.78.1611869361456;
 Thu, 28 Jan 2021 13:29:21 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
In-Reply-To: <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Thu, 28 Jan 2021 13:29:10 -0800
Message-ID: <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 6:22 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin,
>
> So, this whole GTP metadata thing has me a bit confused.
>
> You've defined a metadata structure like this:
>
> struct gtpu_metadata {
>          __u8    ver;
>          __u8    flags;
>          __u8    type;
> };
>
> Here ver is the version of the metadata structure itself, which is fine.
> 'flags' corresponds to the 3 flag bits of GTP header's first byte:  E,
> S, and PN.
> 'type' corresponds to the 'message type' field of the GTP header.
>
> The 'control header' (strange name) example below allows the flags to be
> set; however, setting these flags alone is insufficient because each one
> indicates the presence of additional fields in the header and there's
> nothing in the code to account for that.
>
> If E is set, extension headers would need to be added.
> If S is set, a sequence number field would need to be added.
> If PN is set, a PDU-number header would need to be added.
>
> It's not clear to me who sets up this metadata in the first place.  Is
> that where OVS or eBPF come in?  Can you give some pointers to how this
> works?
>

Receive path: LWT extracts tunnel metadata into tunnel-metadata
struct. This object has 5-tuple info from outer header and tunnel key.
When there is presence of extension header there is no way to store
the info standard tunnel-metadata object. That is when the optional
section of tunnel-metadata comes in the play.
As you can see the packet data from GTP header onwards is still pushed
to the device, so consumers of LWT can look at tunnel-metadata and
make sense of the inner packet that is received on the device.
OVS does exactly the same. When it receives a GTP packet with optional
metadata, it looks at flags and parses the inner packet and extension
header accordingly.

xmit path: it is set by LWT tunnel user, OVS or eBPF code. it needs to
set the metadata in tunnel dst along with the 5-tuple data and tunel
ID. This is how it can steer the packet at the right tunnel using a
single tunnel net device.

> Couple of comments below....
>
> On 23/01/2021 20:59, Jonas Bonn wrote:
> > From: Pravin B Shelar <pbshelar@fb.com>
> >
> > Please explain how this patch actually works... creation of the control
> > header makes sense, but I don't understand how sending of a
> > control header is actually triggered.
> >
> > Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> > ---
> >   drivers/net/gtp.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> > index 668ed8a4836e..bbce2671de2d 100644
> > --- a/drivers/net/gtp.c
> > +++ b/drivers/net/gtp.c
> > @@ -683,6 +683,38 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
> >       }
> >   }
> >
> > +static inline int gtp1_push_control_header(struct sk_buff *skb,
>
> I'm not enamored with the name 'control header' because it makes sound
> like this is some GTP-C thing.  The GTP module is really only about
> GTP-U and the function itself just sets up a GTP-U header.
>
sure. lets call ext_hdr.

>
> > +                                        struct pdp_ctx *pctx,
> > +                                        struct gtpu_metadata *opts,
> > +                                        struct net_device *dev)
> > +{
> > +     struct gtp1_header *gtp1c;
> > +     int payload_len;
> > +
> > +     if (opts->ver != GTP_METADATA_V1)
> > +             return -ENOENT;
> > +
> > +     if (opts->type == 0xFE) {
> > +             /* for end marker ignore skb data. */
> > +             netdev_dbg(dev, "xmit pkt with null data");
> > +             pskb_trim(skb, 0);
> > +     }
> > +     if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
> > +             return -ENOMEM;
> > +
> > +     payload_len = skb->len;
> > +
> > +     gtp1c = skb_push(skb, sizeof(*gtp1c));
> > +
> > +     gtp1c->flags    = opts->flags;
> > +     gtp1c->type     = opts->type;
> > +     gtp1c->length   = htons(payload_len);
> > +     gtp1c->tid      = htonl(pctx->u.v1.o_tei);
> > +     netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
> > +                opts->ver, opts->flags, opts->type, skb->len, pctx->u.v1.o_tei);
> > +     return 0;
> > +}
>
> There's nothing really special about that above function aside from the
> facts that it takes 'opts' as an argument.  Can't we just merge this
> with the regular 'gtp_push_header' function?  Do you have plans for this
> beyond what's here that would complicated by doing so?
>

Yes, we already have usecase for handling GTP PDU session container
related extension header for 5G UPF endpoitnt.



> /Jonas
>
>
> > +
> >   static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
> >   {
> >       struct gtp_dev *gtp = netdev_priv(dev);
> > @@ -807,7 +839,16 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
> >
> >       skb_set_inner_protocol(skb, skb->protocol);
> >
> > -     gtp_push_header(skb, pctx, &port);
> > +     if (unlikely(opts)) {
> > +             port = htons(GTP1U_PORT);
> > +             r = gtp1_push_control_header(skb, pctx, opts, dev);
> > +             if (r) {
> > +                     netdev_info(dev, "cntr pkt error %d", r);
> > +                     goto err_rt;
> > +             }
> > +     } else {
> > +             gtp_push_header(skb, pctx, &port);
> > +     }
> >
> >       iph = ip_hdr(skb);
> >       netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> >
