Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC06230B0B1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhBATpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBATpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:45:23 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42836C06178B
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 11:43:56 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id u7so4582547ooq.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 11:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GWJ+o1LW+u/gVa/qUfLZCig8y4n1+AmqQVve/uTR1bg=;
        b=cBtyPh5Dv05j12LVwDbvpTEbPP48jrZ3NwuRyzsufBEBwwCcNd1RgbiAXSUHVppXoc
         w7w8JYFtZMrvwH129KuTfThQbND2+EzxTbidOT4CwqCE8BDdCYSaAz5kTWO/eQS4Qcya
         M1QDyxT4gbmRS7uLiBH71VXNIj5AUKNHkwikn6vuAZKP0nzve6/bQruKcd1O0jnKViB4
         RoJPgCTtl12+Z4p5yZSl/tis6xSrghJkcJ1DJtahkxoMeVIlOhPlzdLudHmrXpmy6zy+
         QlFkJaUp0WusroJVpj2BDuM5tXWyvdzVnFhyS0naGX8QXiAGesl4h9nLZ/dmv/a6cx7N
         AF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GWJ+o1LW+u/gVa/qUfLZCig8y4n1+AmqQVve/uTR1bg=;
        b=bNTL0PhS0t9wk2e5vJnUA864llIgJt3CYMkXxWFQ4TG60oAni0Ik65ijNW8mPmr5H6
         NASe0NvDS3Nxb/kgVYY42XSjvITeyfmqUkFxz20Y+DJzZQxJciShzFOGH9t607jT5sM0
         dvI7WN2Oz3zqE5CijRQXeWtVY2X7NkLjElNpQnmGGPYK7qeo6E5BeizOG7cWNxjpaQ7A
         hNwUoRWhAioxxysfMn9bP4qEy0DjGxSb082otZVetDmEYATTrqoMZN/rzXaIDYmbgx4x
         ulyeGu95l8p03RdQd3nQd8S5UGdgmsrNUrmtqKGwZ3OAK77DB6ofCVbjN+Vk+2Nc22f9
         0kBw==
X-Gm-Message-State: AOAM532uDx7x+3i2lWAjyonznsv/o4r9X2v+n24w/vzfoA7A/FlLrEeq
        Lpys3eu2bGL5UtgWNMcxt/QTVBwnC1oXBIRl8w==
X-Google-Smtp-Source: ABdhPJzuWsBofkY0MP1ZWY9i9TQxja4+97NXNNH0A12yWG/hToQz2yKuN3EqHL9KPTWL9ml+aBuXKlV8XhMUoM46bLk=
X-Received: by 2002:a4a:8555:: with SMTP id l21mr13211078ooh.27.1612208635322;
 Mon, 01 Feb 2021 11:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com> <20210201145943.ajxecwnhsjslr2uf@skbuf>
In-Reply-To: <20210201145943.ajxecwnhsjslr2uf@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 1 Feb 2021 13:43:43 -0600
Message-ID: <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 8:59 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Feb 01, 2021 at 08:05:00AM -0600, George McCollister wrote:
> > Generate supervision frame without HSR/PRP tag and rely on existing
> > code which inserts it later.
> > This will allow HSR/PRP tag insertions to be offloaded in the future.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
>
> I'm not sure I understand why this change is correct, you'll have to
> write a more convincing commit message, and if that takes up too much
> space (I hope it will), you'll have to break this up into multiple
> trivial changes.

Okay, I'll work on this. Not sure if this can be broken up into
trivial changes if we want it to remain working after each commit.

>
> Just so we're on the same page, here is the call path:
>
> hsr_announce
> -> hsr->proto_ops->send_sv_frame
>    -> hsr_init_skb
>    -> hsr_forward_skb
>       -> fill_frame_info
>          -> hsr->proto_ops->fill_frame_info
>       -> hsr_forward_do
>          -> hsr_handle_sup_frame
>          -> hsr->proto_ops->create_tagged_frame
>          -> hsr_xmit
>
> >  net/hsr/hsr_device.c  | 32 ++++----------------------------
> >  net/hsr/hsr_forward.c | 10 +++++++---
> >  2 files changed, 11 insertions(+), 31 deletions(-)
> >
> > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > index ab953a1a0d6c..161b8da6a21d 100644
> > --- a/net/hsr/hsr_device.c
> > +++ b/net/hsr/hsr_device.c
> > @@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
> >        * being, for PRP it is a trailer and for HSR it is a
> >        * header
> >        */
> > -     skb = dev_alloc_skb(sizeof(struct hsr_tag) +
> > -                         sizeof(struct hsr_sup_tag) +
> > +     skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
> >                           sizeof(struct hsr_sup_payload) + hlen + tlen);
>
> Question 1: why are you no longer allocating struct hsr_tag (or struct prp_rct,
> which has the same size)?

Because the tag is no longer being included in the supervisory frame
here. If I understand correctly hsr_create_tagged_frame and
prp_create_tagged_frame will create a new skb with HSR_HLEN added
later.

>
> In hsr->proto_ops->fill_frame_info in the call path above, the skb is
> still put either into frame->skb_hsr or into frame->skb_prp, but not
> into frame->skb_std, even if it does not contain a struct hsr_tag.

Are you sure? My patch changes hsr_fill_frame_info and
prp_fill_frame_info not to do that if port->type is HSR_PT_MASTER
which I'm pretty certain it always is when sending supervisory frames
like this. If I've overlooked something let me know.

>
> Also, which code exactly will insert the hsr_tag later? I assume
> hsr_fill_tag via hsr->proto_ops->create_tagged_frame?

Correct.

>
> But I don't think that's how it works, unless I'm misunderstanding
> something.. The code path in hsr_create_tagged_frame is:
>
>         if (frame->skb_hsr) {   <- it will take this branch

it shouldn't be taking this branch because skb_hsr and skb_prp
shouldn't be getting filled out. Let's resolve that part of the
discussion above.

>                 struct hsr_ethhdr *hsr_ethhdr =
>                         (struct hsr_ethhdr *)skb_mac_header(frame->skb_hsr);
>
>                 /* set the lane id properly */
>                 hsr_set_path_id(hsr_ethhdr, port);
>                 return skb_clone(frame->skb_hsr, GFP_ATOMIC);
>         }
>
>         not this one
>         |
>         v
>
>         /* Create the new skb with enough headroom to fit the HSR tag */
>         skb = __pskb_copy(frame->skb_std,
>                           skb_headroom(frame->skb_std) + HSR_HLEN, GFP_ATOMIC);
>         if (!skb)
>                 return NULL;
>         skb_reset_mac_header(skb);
>
>         if (skb->ip_summed == CHECKSUM_PARTIAL)
>                 skb->csum_start += HSR_HLEN;
>
>         movelen = ETH_HLEN;
>         if (frame->is_vlan)
>                 movelen += VLAN_HLEN;
>
>         src = skb_mac_header(skb);
>         dst = skb_push(skb, HSR_HLEN);
>         memmove(dst, src, movelen);
>         skb_reset_mac_header(skb);
>
>         /* skb_put_padto free skb on error and hsr_fill_tag returns NULL in
>          * that case
>          */
>         return hsr_fill_tag(skb, frame, port, port->hsr->prot_version);
>
> Otherwise said, it assumes that a frame->skb_hsr already has a struct
> hsr_tag, no? Where does hsr_set_path_id() write?
>
> >
> >       if (!skb)
> > @@ -275,12 +274,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
> >  {
> >       struct hsr_priv *hsr = master->hsr;
> >       __u8 type = HSR_TLV_LIFE_CHECK;
> > -     struct hsr_tag *hsr_tag = NULL;
> >       struct hsr_sup_payload *hsr_sp;
> >       struct hsr_sup_tag *hsr_stag;
> >       unsigned long irqflags;
> >       struct sk_buff *skb;
> > -     u16 proto;
> >
> >       *interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
> >       if (hsr->announce_count < 3 && hsr->prot_version == 0) {
> > @@ -289,23 +286,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
> >               hsr->announce_count++;
> >       }
> >
> > -     if (!hsr->prot_version)
> > -             proto = ETH_P_PRP;
> > -     else
> > -             proto = ETH_P_HSR;
> > -
> > -     skb = hsr_init_skb(master, proto);
> > +     skb = hsr_init_skb(master, ETH_P_PRP);
>
> Question 2: why is this correct, setting skb->protocol to ETH_P_PRP
> (HSR v0) regardless of prot_version? Also, why is the change necessary?

This part is not intuitive and I don't have a copy of the documents
where v0 was defined. It's unfortunate this code even supports v0
because AFAIK no one else uses it; but it's in here so we have to keep
supporting it I guess.
In v1 the tag has an eth type of 0x892f and the encapsulated
supervisory frame has a type of 0x88fb. In v0 0x88fb is used for the
eth type and there is no encapsulation type. So... this is correct
however I compared supervisory frame generation before and after this
patch for v0 and I found a problem. My changes make it add 0x88fb
again later for v0 which it's not supposed to do. I'll have to fix
that part somehow.

>
> Why is it such a big deal if supervision frames have HSR/PRP tag or not?

Because if the switch does automatic HSR/PRP tag insertion it will end
up in there twice. You simply can't send anything with an HSR/PRP tag
if this is offloaded.

>
> >       if (!skb) {
> >               WARN_ONCE(1, "HSR: Could not send supervision frame\n");
> >               return;
> >       }
> >
> > -     if (hsr->prot_version > 0) {
> > -             hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
> > -             hsr_tag->encap_proto = htons(ETH_P_PRP);
> > -             set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
> > -     }
> > -
> >       hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
> >       set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
> >       set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
> > @@ -315,8 +301,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
> >       if (hsr->prot_version > 0) {
> >               hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
> >               hsr->sup_sequence_nr++;
> > -             hsr_tag->sequence_nr = htons(hsr->sequence_nr);
> > -             hsr->sequence_nr++;
> >       } else {
> >               hsr_stag->sequence_nr = htons(hsr->sequence_nr);
> >               hsr->sequence_nr++;
> > @@ -332,7 +316,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
> >       hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
> >       ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
> >
> > -     if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
> > +     if (skb_put_padto(skb, ETH_ZLEN))
> >               return;
> >
> >       hsr_forward_skb(skb, master);
> > @@ -348,8 +332,6 @@ static void send_prp_supervision_frame(struct hsr_port *master,
> >       struct hsr_sup_tag *hsr_stag;
> >       unsigned long irqflags;
> >       struct sk_buff *skb;
> > -     struct prp_rct *rct;
> > -     u8 *tail;
> >
> >       skb = hsr_init_skb(master, ETH_P_PRP);
> >       if (!skb) {
> > @@ -373,17 +355,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
> >       hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
> >       ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
> >
> > -     if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN)) {
> > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> >               spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
> >               return;
> >       }
> >
> > -     tail = skb_tail_pointer(skb) - HSR_HLEN;
> > -     rct = (struct prp_rct *)tail;
> > -     rct->PRP_suffix = htons(ETH_P_PRP);
> > -     set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
> > -     rct->sequence_nr = htons(hsr->sequence_nr);
> > -     hsr->sequence_nr++;
> >       spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
> >
> >       hsr_forward_skb(skb, master);
> > diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> > index cadfccd7876e..a5566b2245a0 100644
> > --- a/net/hsr/hsr_forward.c
> > +++ b/net/hsr/hsr_forward.c
> > @@ -454,8 +454,10 @@ static void handle_std_frame(struct sk_buff *skb,
> >  void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> >                        struct hsr_frame_info *frame)
> >  {
> > -     if (proto == htons(ETH_P_PRP) ||
> > -         proto == htons(ETH_P_HSR)) {
> > +     struct hsr_port *port = frame->port_rcv;
> > +
> > +     if (port->type != HSR_PT_MASTER &&
> > +         (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {
>
> Why is this change necessary? Are you trying to force fill_frame_info to
> call handle_std_frame for supervision frames, which will fix up the
> kludge I asked about earlier? And why does checking for HSR_PT_MASTER
> fixing it?

The eth type for the tag in v0 is the same type used for supervisory
frames in v1 so if we generate supervisory frames without a tag the
existing check wasn't sufficient. Anyway, no point in talking about it
now since I might have to change the way this works to fix v0.

>
> >               /* HSR tagged frame :- Data or Supervision */
> >               frame->skb_std = NULL;
> >               frame->skb_prp = NULL;
> > @@ -473,8 +475,10 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
> >  {
> >       /* Supervision frame */
> >       struct prp_rct *rct = skb_get_PRP_rct(skb);
> > +     struct hsr_port *port = frame->port_rcv;
> >
> > -     if (rct &&
> > +     if (port->type != HSR_PT_MASTER &&
> > +         rct &&
> >           prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
> >               frame->skb_hsr = NULL;
> >               frame->skb_std = NULL;
> > --
> > 2.11.0
> >
