Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51617400D26
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 23:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhIDVlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 17:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhIDVlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 17:41:50 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B305C061575
        for <netdev@vger.kernel.org>; Sat,  4 Sep 2021 14:40:48 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id t26so1545473uao.12
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 14:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8N7qq6VRAsNes0XGPcOKkPF+ncbrl0spxpxanexmMg=;
        b=XzkdQGCxXKkuwBuajfKqH9p39GFGeRkpzpDEHqXW4EQejRdwRMqxX06C+vSt+H7bBI
         9TrbRWAUg6878tkrbj/V4hgHGZe2tMlfExi8k3JF2OWdQ91WwdHBeu3J4DT4QyNqBIch
         egwVllD/s0cdEmg/rkWcmpeRFo4i4JpU+X9u9HnB7AsZQ2E9/yBV6VpUnZBOkNurSQDS
         LNYI6tUEawQ9KQDEP0CQAto0zzcCEkXcZyYvRWS7aOCiOZ6TxxpxO/aqOFyJ5+dZhfq0
         vT3WKAbuvxT4v7wxPO7JscsrbZmAZa6NetQdoAgVgEh4bmRBkh59oO7HFCht+AuDMY/T
         VX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8N7qq6VRAsNes0XGPcOKkPF+ncbrl0spxpxanexmMg=;
        b=SDZ0ykZE4Oog/wE73wHMHdP8s7OOEhjzukt6lZD9Y0l/t1xHLCgBZmC621ZXOhCNtJ
         TM8GLD36/VersmFqn+gTuT/EdlkV5oNE2mBE2F6pHOLvQ4xD+iPzP4f2h884L/PoZssa
         cTZg4fCBUNFgjK7V/yltPiMrD+0tXDkOlLvlqyLi0kjnWPfXGqKMS9f5vyhVq2Smf20U
         Gws8QUhPWVe5826p5d51Dm9XJ0uff2Fp19irSWqnXBRMtp3ZD0nVV7kBTXCTUHatBKZg
         ef04V76xWsjQHYPUAb7uMf0rU2gZK9Wpa3GTKTZHNn2Nv+6fL4V13VW5zUhLb6r2yhRP
         NjtA==
X-Gm-Message-State: AOAM532xsZf618JAsOL6MXcERWTngO8EixrlCPPpy/mQ3CahgvW39/Uz
        /Rhuqwn3qBzRx48yBbyVkZzVB3yfWpE=
X-Google-Smtp-Source: ABdhPJzBvn+zu2F5PXyLBfHXD50jAro3+eJZPNyNo/llW/rTLv6MX+yT0XwLWZHnQq3Y6xx5kQi0jw==
X-Received: by 2002:a9f:36f0:: with SMTP id p103mr2692655uap.42.1630791647441;
        Sat, 04 Sep 2021 14:40:47 -0700 (PDT)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id x22sm382210uao.8.2021.09.04.14.40.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 14:40:46 -0700 (PDT)
Received: by mail-vk1-f169.google.com with SMTP id b13so937117vkl.10
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 14:40:45 -0700 (PDT)
X-Received: by 2002:a1f:60cb:: with SMTP id u194mr2600730vkb.5.1630791645120;
 Sat, 04 Sep 2021 14:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
 <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
 <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
 <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com> <CAKgT0Ud5ZFQ3Jv4DAFftf6OkhJe5UxEcuVTJs-9HYk8ptCt9Uw@mail.gmail.com>
In-Reply-To: <CAKgT0Ud5ZFQ3Jv4DAFftf6OkhJe5UxEcuVTJs-9HYk8ptCt9Uw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 4 Sep 2021 17:40:07 -0400
X-Gmail-Original-Message-ID: <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
Message-ID: <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 4, 2021 at 11:37 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Sat, Sep 4, 2021 at 7:46 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Fri, Sep 3, 2021 at 7:27 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, Sep 3, 2021 at 12:38 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > >
> > > <snip>
> > >
> > > > > whereas if the offset is stored somewhere in the unstripped data we
> > > > > could then drop the packet and count it as a drop without having to
> > > > > modify the frame via the skb_pull.
> > > >
> > > > This is a broader issue that userspace can pass any csum_start as long
> > > > as it is within packet bounds. We could address it here specifically
> > > > for the GRE header. But that still leaves many potentially bad offsets
> > > > further in the packet in this case, and all the other cases. Checking
> > > > that specific header seems a bit arbitrary to me, and might actually
> > > > give false confidence.
> > > >
> > > > We could certainly move the validation from gre_handle_offloads to
> > > > before skb_pull, to make it more obvious *why* the check exists.
> > >
> > > Agreed. My main concern is that the csum_start is able to be located
> > > somewhere where the userspace didn't write. For the most part the
> > > csum_start and csum_offset just needs to be restricted to the regions
> > > that the userspace actually wrote to.
> >
> > I don't quite follow. Even with this bug, the offset is somewhere userspace
> > wrote. That data is just pulled.
>
> Sorry, I was thinking of the SOCK_DGRAM case where the header is added
> via a call to dev_hard_header().
>
> > > > > Maybe for those
> > > > > cases we need to look at adding an unsigned int argument to
> > > > > virtio_net_hdr_to_skb in which we could pass 0 for the unused case or
> > > > > dev->hard_header_len in the cases where we have something like
> > > > > af_packet that is transmitting over an ipgre tunnel. The general idea
> > > > > is to prevent these virtio_net_hdr_to_skb calls from pointing the
> > > > > csum_start into headers that userspace was not responsible for
> > > > > populating.
> > > >
> > > > One issue with that is that dev->hard_header_len itself is imprecise
> > > > for protocols with variable length link layer headers. There, too, we
> > > > have had a variety of bug fixes in the past.
> > > >
> > > > It also adds cost to every user of virtio_net_hdr, while we only know
> > > > one issue in a rare case of the IP_GRE device.
> > >
> > > Quick question, the assumption is that the checksum should always be
> > > performed starting no earlier than the transport header right? Looking
> > > over virtio_net_hdr_to_skb it looks like it is already verifying the
> > > transport header is in the linear portion of the skb. I'm wondering if
> > > we couldn't just look at adding a check to verify the transport offset
> > > is <= csum start? We might also be able to get rid of one of the two
> > > calls to pskb_may_pull by doing that.
> >
> > Are you referring to this part in the .._NEEDS_CSUM branch?
> >
> >                 if (!skb_partial_csum_set(skb, start, off))
> >                         return -EINVAL;
> >
> >                 p_off = skb_transport_offset(skb) + thlen;
> >                 if (!pskb_may_pull(skb, p_off))
> >                         return -EINVAL;
> >
> > skb_partial_csum_set is actually what sets the transport offset,
> > derived from start.
>
> Ugh, I had overlooked that as I was more focused on the
> skb_probe_transport_header calls in the af_packet code.
>
> So we can have both the transport offset and the csum_start in a
> region that gets stripped by the ipgre code. Worse yet the inner
> transport header will also be pointing somewhere outside of the
> encapsulated region when we pass it off to skb_reset_inner_headers().
>
> Maybe it would make sense to just have the check look into the
> transport offset instead of csum start as that way you are essentially
> addressing two possible issues instead of one, and it would
> effectively combine multiple checks as the uninitialized value is ~0
> which should always be greater than "skb_headroom + tunnel->hlen +
> sizeof(struct iphdr)". I think you mentioned before placing a check
> just before you make the call to skb_pull in the GRE transmit path.
> Doing that we would at least reduce the impact as it would only apply
> in the header_ops case in ipgre_xmit instead of being applied to all
> the transmit paths which don't perform the pull.

Do you mean

        if (dev->header_ops) {
+               int pull_len = tunnel->hlen + sizeof(struct iphdr);
+
                if (skb_cow_head(skb, 0))
                        goto free_skb;

                tnl_params = (const struct iphdr *)skb->data;

+               if (pull_len > skb_transport_offset(skb))
+                       goto free_skb;
+
                /* Pull skb since ip_tunnel_xmit() needs skb->data pointing
                 * to gre header.
                 */
-               skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
+               skb_pull(skb, pull_len);
                skb_reset_mac_header(skb);

plus then

 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-       /* Local checksum offload requires csum offload of the inner packet */
-       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
-           skb_checksum_start(skb) < skb->data)
-               return -EINVAL;
-
        return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM :
SKB_GSO_GRE);
 }
