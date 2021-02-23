Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26715322C28
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhBWOYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhBWOX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:23:59 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C5C06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:23:18 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so34875770ejc.1
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H8vtkyNEqRRd14jBt5G4psDBq4qKhtCm/tBgnQUuw9g=;
        b=oAm+pHr8pWu0D3JchPjOuzr7uAQ2Bmv+Ra/5Lxx7zHox9Rs9tfInDEkRM6xpTWz+KZ
         yJ/SRL0VKYvCSK2Ng9TAP8PJSiIdrGP0aAZ5YAYA0hproABdyl1MYeD29VFK9syRJ+hI
         hHG/vTLhT5wM/7Dhfq14Ck2y+QlKAquiKnVcPKLkodBi7JCCTZrFhVn/PCh0Cl0SSAid
         0iWe4pTQnVz0poMJGHeVAwOFJQnE98JepJgJlIdDw/4yZI3uG99RHmbHJEbmZzCb5W7I
         AD3gmHHbBDG8vQiMoKCs5+Zy8dOV7AvCI3kolnTbnidkR8CatWvsBzJAc+ai8daJdAGS
         X9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H8vtkyNEqRRd14jBt5G4psDBq4qKhtCm/tBgnQUuw9g=;
        b=V8yc3tol1LPpjtbQXYqxQnAiknl8opSvY/xSHthjlN7NL4g1KGyBodqAP6yaETreWY
         9bjoa8DJc4CoBWqJcv6o2uW1IFNkcyhQYblINcDGOol5UILUOCTq1Q3vlZKZMPTRip4E
         KT+pYQoHgiTwXqjH2uIIdwOLg4nc8lobp0/oiBcPh+2BJmegLuztu4gBC2ovN8eDnEIE
         yeipzqbqKcQ/xKuRcQhFb4zSse2A2oEJVUQJljogy10rKurF91mNP3j735p1okBVZk7C
         xxFaO5Fak0zLhmFD3LXd6NH5Jxi5w2sauqYxK/aG5fAVmbgYogQ6Hc01ydyo9rBLUT+1
         G24w==
X-Gm-Message-State: AOAM530kQgYzt8YOFJ8cUj5tsjDCuobU2rZzQzOnIQ9uSI6PApA/III/
        byXJaDcEAt16DdkxffuJre4/th2cyos=
X-Google-Smtp-Source: ABdhPJyRy000ueabj+LvrYGmXniEIDMRHzTqHsECuIBcAFr41CXA0UjOs+caCCaDqb1dRbZdLzti1g==
X-Received: by 2002:a17:906:869a:: with SMTP id g26mr22817143ejx.441.1614090196443;
        Tue, 23 Feb 2021 06:23:16 -0800 (PST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id e19sm14174614eds.10.2021.02.23.06.23.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 06:23:14 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id p3so2581682wmc.2
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:23:14 -0800 (PST)
X-Received: by 2002:a05:600c:2291:: with SMTP id 17mr17708818wmf.169.1614090193610;
 Tue, 23 Feb 2021 06:23:13 -0800 (PST)
MIME-Version: 1.0
References: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
 <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
 <2cc06597-8005-7be8-4094-b20f525afde8@redhat.com> <CA+FuTSf2GCi+RzpkFeBgtSOyhjsBFfApjekzupHLfyeYDn-JYQ@mail.gmail.com>
 <8168e98e-d608-750a-9b49-b1e60a23714c@redhat.com> <1bcc8d88b4cb7ad5610a045fc013127d3055b0d8.camel@redhat.com>
In-Reply-To: <1bcc8d88b4cb7ad5610a045fc013127d3055b0d8.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Feb 2021 09:22:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdftho0g7ZmUwf=xH5UY6qYyPrNaV7LGmBTuwt=kZfGug@mail.gmail.com>
Message-ID: <CA+FuTSdftho0g7ZmUwf=xH5UY6qYyPrNaV7LGmBTuwt=kZfGug@mail.gmail.com>
Subject: Re: [PATCH] net: check if protocol extracted by virtio_net_hdr_set_proto
 is correct
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 8:48 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> On Mon, 2021-02-22 at 11:39 +0800, Jason Wang wrote:
> >
> > On 2021/2/19 10:55 =E4=B8=8B=E5=8D=88, Willem de Bruijn wrote:
> > > On Fri, Feb 19, 2021 at 3:53 AM Jason Wang <jasowang@redhat.com>
> > > wrote:
> > > >
> > > > On 2021/2/18 11:50 =E4=B8=8B=E5=8D=88, Willem de Bruijn wrote:
> > > > > On Thu, Feb 18, 2021 at 10:01 AM Balazs Nemeth <
> > > > > bnemeth@redhat.com> wrote:
> > > > > > For gso packets, virtio_net_hdr_set_proto sets the protocol
> > > > > > (if it isn't
> > > > > > set) based on the type in the virtio net hdr, but the skb
> > > > > > could contain
> > > > > > anything since it could come from packet_snd through a raw
> > > > > > socket. If
> > > > > > there is a mismatch between what virtio_net_hdr_set_proto
> > > > > > sets and
> > > > > > the actual protocol, then the skb could be handled
> > > > > > incorrectly later
> > > > > > on by gso.
> > > > > >
> > > > > > The network header of gso packets starts at 14 bytes, but a
> > > > > > specially
> > > > > > crafted packet could fool the call to
> > > > > > skb_flow_dissect_flow_keys_basic
> > > > > > as the network header offset in the skb could be incorrect.
> > > > > > Consequently, EINVAL is not returned.
> > > > > >
> > > > > > There are even packets that can cause an infinite loop. For
> > > > > > example, a
> > > > > > packet with ethernet type ETH_P_MPLS_UC (which is unnoticed
> > > > > > by
> > > > > > virtio_net_hdr_to_skb) that is sent to a geneve interface
> > > > > > will be
> > > > > > handled by geneve_build_skb. In turn, it calls
> > > > > > udp_tunnel_handle_offloads which then calls
> > > > > > skb_reset_inner_headers.
> > > > > > After that, the packet gets passed to mpls_gso_segment. That
> > > > > > function
> > > > > > calculates the mpls header length by taking the difference
> > > > > > between
> > > > > > network_header and inner_network_header. Since the two are
> > > > > > equal
> > > > > > (due to the earlier call to skb_reset_inner_headers), it will
> > > > > > calculate
> > > > > > a header of length 0, and it will not pull any headers. Then,
> > > > > > it will
> > > > > > call skb_mac_gso_segment which will again call
> > > > > > mpls_gso_segment, etc...
> > > > > > This leads to the infinite loop.
> > > >
> > > > I remember kernel will validate dodgy gso packets in gso ops. I
> > > > wonder
> > > > why not do the check there? The reason is that virtio/TUN is not
> > > > the
> > > > only source for those packets.
> > > It is? All other GSO packets are generated by the stack itself,
> > > either
> > > locally or through GRO.
> >
> >
> > Something like what has been done in tcp_tso_segment()?
> >
> >      if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
> >                  /* Packet is from an untrusted source, reset
> > gso_segs. */
> >
> >          skb_shinfo(skb)->gso_segs =3D DIV_ROUND_UP(skb->len, mss);
> >
> >          segs =3D NULL;
> >                  goto out;
> >          }
> >
> > My understanding of the header check logic is that it tries to dealy
> > the
> > check as much as possible, so for device that has GRO_ROBUST, there's
> > even no need to do that.
> >
> >
> > >
> > > But indeed some checks are better performed in the GSO layer. Such
> > > as
> > > likely the 0-byte mpls header length.
> > >
> > > If we cannot trust virtio_net_hdr.gso_type passed from userspace,
> > > then
> > > we can also not trust the eth.h_proto coming from the same source.
> >
> >
> > I agree.
> >
> I'll add a check in the GSO layer as well.
> >
> > > But
> > > it makes sense to require them to be consistent. There is a
> > > dev_parse_header_protocol that may return the link layer type in a
> > > more generic fashion than casting to skb_eth_hdr.
> > >
> > > Question remains what to do for the link layer types that do not
> > > implement
> > > header_ops->parse_protocol, and so we cannot validate the packet's
> > > network protocol. Drop will cause false positives, accepts will
> > > leave a
> > > potential path, just closes it for Ethernet.
> > >
> > > This might call for multiple fixes, both on first ingest and inside
> > > the stack?
> >
> Given that this is related to dodgy packets and that we can't trust
> eth.h_proto, wouldn't it make sense to always drop packets (with
> potential false positives), erring on the side of caution, if
> header_ops->parse_protocol isn't implemented for the dev in question?

Unfortunately, that might break applications somewhere out there.
