Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4230934A
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhA3JYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhA3JVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:21:45 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8920C061788
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 22:59:18 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id a7so11058961qkb.13
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 22:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJ6aYqjOSHvLhuFxtRWPIYV7DhiSEThc3daJnkglJd0=;
        b=mlU0QbtZCCNb243HKoLne7btA4mdp1xMy/Ht3Z97lUfxlQ5JvutCIG7kl7BMMLldXc
         7zHLhR2Bd125YJcoAn4pJK7lw2DJ9AUXL4sX3Q2v1qTkVIQH/0evN+MXMqW08FCHVwT7
         QDAav8Dn4opY+tZguP2AiB5dPXihmoyhsWNvL1z6rw39olMKmcZws78uvJJ6dY0sET0T
         n0FNEeD8507P5VyE3HI9KvGmmVemYFqYJRb/DS0b1cNUE04eeXYzxHiL6jVdXtBPwH5E
         WDOE6vyN4hAyj212QfAdwWps7z0f7Meqlip5ECgtC0bAbISDj0gsLUZz7tI2/vtbLLan
         ib+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJ6aYqjOSHvLhuFxtRWPIYV7DhiSEThc3daJnkglJd0=;
        b=oB785jXsZ3I9eahEt4N47/iNC/rTGtGnIQ/j5wN59+04/VBVzWbr1vtNZ6gFLTV5Ij
         E1Bj2mZhYYDA9KN9341euyThrK9g+gY64XSJF/Jwn3BslPnQ/htekDZWgUukXQmRkioF
         3PbALkW6yjebAxvQ6D5PF2YZeaKxa+GILOQVg9uCKGAhHEYclKw94FdRwZSCO4NMX6vf
         p/v+K+VPk9BRoMQloPeQ2EDSTVkZ3C8vwhlfc9JweiuYVa66rFuHITNV8PJ1+5A0/THE
         wEGnAVhkkOIe5CP3DI/tFoteWt17JpO5CBfoDkI8irbCY/lcrSGCRuP6yDjjLXhG4l4B
         S/Bg==
X-Gm-Message-State: AOAM531WI4+YHFN+NzMeTnnuWje2bRGRYK17dh2YPz4H7FzHHflSgW6R
        bKZZtxLyVXUZzthgpEmVgXECazSMjCCG3RWnF6c=
X-Google-Smtp-Source: ABdhPJyvf18BdwQvb0RNvDy1Jt8j0kcepYqnF2jeDkvZltyfxtvVuI0I8IvtrO7Usj7jdTuRVwrpp2P9QrOMMsDlyiw=
X-Received: by 2002:ae9:e810:: with SMTP id a16mr7530737qkg.244.1611989957642;
 Fri, 29 Jan 2021 22:59:17 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se> <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
In-Reply-To: <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Fri, 29 Jan 2021 22:59:06 -0800
Message-ID: <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
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

On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin,
>
> On 28/01/2021 22:29, Pravin Shelar wrote:
> > On Sun, Jan 24, 2021 at 6:22 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >> Hi Pravin,
> >>
> >> So, this whole GTP metadata thing has me a bit confused.
> >>
> >> You've defined a metadata structure like this:
> >>
> >> struct gtpu_metadata {
> >>           __u8    ver;
> >>           __u8    flags;
> >>           __u8    type;
> >> };
> >>
> >> Here ver is the version of the metadata structure itself, which is fine.
> >> 'flags' corresponds to the 3 flag bits of GTP header's first byte:  E,
> >> S, and PN.
> >> 'type' corresponds to the 'message type' field of the GTP header.
> >>
> >> The 'control header' (strange name) example below allows the flags to be
> >> set; however, setting these flags alone is insufficient because each one
> >> indicates the presence of additional fields in the header and there's
> >> nothing in the code to account for that.
> >>
> >> If E is set, extension headers would need to be added.
> >> If S is set, a sequence number field would need to be added.
> >> If PN is set, a PDU-number header would need to be added.
> >>
> >> It's not clear to me who sets up this metadata in the first place.  Is
> >> that where OVS or eBPF come in?  Can you give some pointers to how this
> >> works?
> >>
> >
> > Receive path: LWT extracts tunnel metadata into tunnel-metadata
> > struct. This object has 5-tuple info from outer header and tunnel key.
> > When there is presence of extension header there is no way to store
> > the info standard tunnel-metadata object. That is when the optional
> > section of tunnel-metadata comes in the play.
> > As you can see the packet data from GTP header onwards is still pushed
> > to the device, so consumers of LWT can look at tunnel-metadata and
> > make sense of the inner packet that is received on the device.
> > OVS does exactly the same. When it receives a GTP packet with optional
> > metadata, it looks at flags and parses the inner packet and extension
> > header accordingly.
>
> Ah, ok, I see.  So you are pulling _half_ of the GTP header off the
> packet but leaving the optional GTP extension headers in place if they
> exist.  So what OVS receives is a packet with metadata indicating
> whether or not it begins with these extension headers or whether it
> begins with an IP header.
>
> So OVS might need to begin by pulling parts of the packet in order to
> get to the inner IP packet.  In that case, why don't you just leave the
> _entire_ GTP header in place and let OVS work from that?  The header
> contains exactly the data you've copied to the metadata struct PLUS it
> has the incoming TEID value that you really should be validating inner
> IP against.
>

Following are the reasons for extracting the header and populating metadata.
1. That is the design used by other tunneling protocols
implementations for handling optional headers. We need to have a
consistent model across all tunnel devices for upper layers.
2. GTP module is parsing the UDP and GTP header. It would be wasteful
to repeat the same process in upper layers.
3. TIED is part of tunnel metadata, it is already used to validating
inner packets. But TIED is not alone to handle packets with extended
header.

I am fine with processing the entire header in GTP but in case of 'end
marker' there is no data left after pulling entire GTP header. Thats
why I took this path.

> Also, what happens if this is used WITHOUT OVS/eBPF... just a route with
> 'encap' set.  In that case, nothing will be there to pull the extension
> headers off the packet.
>

One way would be, the user can use encap to steer "special" packets to
a netdev that can handle such packets. it would be a userspace process
or eBPF program.

> >
> > xmit path: it is set by LWT tunnel user, OVS or eBPF code. it needs to
> > set the metadata in tunnel dst along with the 5-tuple data and tunel
> > ID. This is how it can steer the packet at the right tunnel using a
> > single tunnel net device.
>
> Right, that part is fine.  However, for setting extension headers you'd
> need to set the flags in the metadata and the extensions themselves
> prepended to the IP packet meaning your SKB contains a pseudo-GTP packet
> before the GTP module can finish adding the header.  I don't know why
> you wouldn't just add the entire GTP header in one place and be done
> with it... going via the GTP module gets you almost nothing at this point.
>
The UDP socket is owned by GTP module, so there is no other way to
inject a packet in the tunnel than sending it over GTP module.
plus this would looks this will break the standard model of
abstracting tunnel implementation in ovs or bridge code. We will need
special code for GTP packets to parse extra outer headers when OVS
extracts the flow from the inner packet.
I am open to handling  the optional headers completely GTP module.

>
> >
> >> Couple of comments below....
> >>
> >> On 23/01/2021 20:59, Jonas Bonn wrote:
> >>> From: Pravin B Shelar <pbshelar@fb.com>
> >>>
> >>> Please explain how this patch actually works... creation of the control
> >>> header makes sense, but I don't understand how sending of a
> >>> control header is actually triggered.
> >>>
> >>> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> >>> ---
> >>>    drivers/net/gtp.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >>>    1 file changed, 42 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> >>> index 668ed8a4836e..bbce2671de2d 100644
> >>> --- a/drivers/net/gtp.c
> >>> +++ b/drivers/net/gtp.c
> >>> @@ -683,6 +683,38 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
> >>>        }
> >>>    }
> >>>
> >>> +static inline int gtp1_push_control_header(struct sk_buff *skb,
> >>
> >> I'm not enamored with the name 'control header' because it makes sound
> >> like this is some GTP-C thing.  The GTP module is really only about
> >> GTP-U and the function itself just sets up a GTP-U header.
> >>
> > sure. lets call ext_hdr.
> >
> >>
> >>> +                                        struct pdp_ctx *pctx,
> >>> +                                        struct gtpu_metadata *opts,
> >>> +                                        struct net_device *dev)
> >>> +{
> >>> +     struct gtp1_header *gtp1c;
> >>> +     int payload_len;
> >>> +
> >>> +     if (opts->ver != GTP_METADATA_V1)
> >>> +             return -ENOENT;
> >>> +
> >>> +     if (opts->type == 0xFE) {
> >>> +             /* for end marker ignore skb data. */
> >>> +             netdev_dbg(dev, "xmit pkt with null data");
> >>> +             pskb_trim(skb, 0);
> >>> +     }
> >>> +     if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     payload_len = skb->len;
> >>> +
> >>> +     gtp1c = skb_push(skb, sizeof(*gtp1c));
> >>> +
> >>> +     gtp1c->flags    = opts->flags;
> >>> +     gtp1c->type     = opts->type;
> >>> +     gtp1c->length   = htons(payload_len);
> >>> +     gtp1c->tid      = htonl(pctx->u.v1.o_tei);
> >>> +     netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
> >>> +                opts->ver, opts->flags, opts->type, skb->len, pctx->u.v1.o_tei);
> >>> +     return 0;
> >>> +}
> >>
> >> There's nothing really special about that above function aside from the
> >> facts that it takes 'opts' as an argument.  Can't we just merge this
> >> with the regular 'gtp_push_header' function?  Do you have plans for this
> >> beyond what's here that would complicated by doing so?
> >>
> >
> > Yes, we already have usecase for handling GTP PDU session container
> > related extension header for 5G UPF endpoitnt.
>
> I'll venture a guess that you're referring to QoS indications.  I, too,
> have been wondering whether or not these can be made to be compatible
> with the GTP module... I'm not sure, at this point.
>
Right, It's QoS related headers.
We can use the same optional metadata field to process this header. we
need to extend the option data structure to pass PDU session container
header values.
