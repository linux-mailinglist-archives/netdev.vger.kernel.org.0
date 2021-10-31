Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BCD4410D6
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 21:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJaUwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 16:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJaUwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 16:52:40 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F16C061714
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:50:08 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i6so14194547uae.6
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3kb3n2uvpNbEEtpHgpMOT5Og6qfgXaZxIj7JmsnUWI=;
        b=NwH1siHD+gv61qN+rtwmI69GhmPfQebri78WdArHWVXP33Exf1e4eHo8yHTRd+Psm8
         aC6qoox1VfTPjjQkaSv0xK02px06Ud4ksY7QKqxQ9kNN3O1T/SN8iCIqFxnEXw4FjiOM
         keTkbzKJcldI6l4R0pfUrUTVx9gYY8YDGFl2bT2jA5zox2Q6LdnIEadDZApBLqbBwf+9
         QqLvRUVM3RAtqoBBdt3dPDjlVriCoA24EAsrVxTRavtulczVOEXDobLlUbRYpBNvxMqm
         7F5KgbT1ie3u5QnSLKIoMiZZLhTrFhK1kcVmGN4DLVB55YKJdJQ+8B7V2qR1HZL04wQB
         uX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3kb3n2uvpNbEEtpHgpMOT5Og6qfgXaZxIj7JmsnUWI=;
        b=72Ge1quGkCpSfxREiAGVYXaI1jfOH4/l4KsL4VNS8q0QVnlMm/ygr5xu1iXYcLU4nx
         6V14ukbjncZol5ncmz4Ge7IJeF1pM4x61PUFNAztKeaFpNCB5Lt6qS/Epv0lhvt1RwD+
         Ly2S0Yt4jG0bupHAldYrxAdT/mNM9jf0MaSCDLg7eIrFWCF7iINVRh6KlCQRUTWmuPwD
         rSE3BCqcjNwfVtuvB6UCO1lJNc265l1CSVwmjJFmJt9TKOdDRRRjq24mtz0fEh76Gd/B
         CmUzNd2k0xJ7aKP6bysr5SkVeVJ/mAzeOVPWDw2uF4K8Af0flZH+xAmhEGuj2TefD9E9
         +ggg==
X-Gm-Message-State: AOAM531VfJ2N+n7/dU7WqyCHf2ZSxS1+MMGRoSC6tp4Xl+Bd9jCW/4YH
        jRGapDSrH4tYlQJSqxUQaK+4N4FdeCY=
X-Google-Smtp-Source: ABdhPJwGqo/sZHTtu2eHpgfBEWMBXkPWZkH4kfAcNEPF3nub9fZNriffqsIFC4WVpW2QmNwnBh6wmg==
X-Received: by 2002:a05:6102:a4a:: with SMTP id i10mr3394295vss.54.1635713407239;
        Sun, 31 Oct 2021 13:50:07 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id u15sm1901485vkp.8.2021.10.31.13.50.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 13:50:06 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id b3so4701462uam.1
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:50:06 -0700 (PDT)
X-Received: by 2002:a67:facc:: with SMTP id g12mr3716567vsq.22.1635713406223;
 Sun, 31 Oct 2021 13:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com>
 <CA+FuTSfytchd3Fk7=VB-6mTHsdjEjkEEHUFXRg_8ZaZkAyxbrg@mail.gmail.com>
In-Reply-To: <CA+FuTSfytchd3Fk7=VB-6mTHsdjEjkEEHUFXRg_8ZaZkAyxbrg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Oct 2021 16:49:29 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc2XKqWzMoRk3eNp502XQ9rdXBoAmHBcxoHsecamD1bVg@mail.gmail.com>
Message-ID: <CA+FuTSc2XKqWzMoRk3eNp502XQ9rdXBoAmHBcxoHsecamD1bVg@mail.gmail.com>
Subject: Re: VirtioNet L3 protocol patch advice request.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Andrew Melnichenko <andrew@daynix.com>, davem@davemloft.net,
        bnemeth@redhat.com, gregkh@linuxfoundation.org,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 10:19 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Oct 29, 2021 at 6:51 AM Andrew Melnichenko <andrew@daynix.com> wrote:
> >
> > Hi all,
> > Recently I've discovered a patch that added an additional check for the
> > protocol in VirtioNet.
> > (https://www.spinics.net/lists/kernel/msg3866319.html)
> > Currently, that patch breaks UFOv6 support and possible USOv6 support in
> > upcoming patches.
> > The issue is the code next to the patch expects failure of
> > skb_flow_dissect_flow_keys_basic()
> > for IPv6 packets to retry it with protocol IPv6.
> > I'm not sure about the goals of the patch
>
> A well behaved configuration should not enter that code path to begin
> with. GSO packets should also request NEEDS_CSUM, and in normal cases
> skb->protocol is set. But packet sockets allow leaving skb->protocol
> 0, in which case this code tries to infer the protocol from the link
> layer header if present and supported, using
> dev_parse_header_protocol.
>
> Commit 924a9bc362a5 ("net: check if protocol extracted by
> virtio_net_hdr_set_proto is correct") added the
> dev_parse_header_protocol check and will drop packets where the GSO
> type (e.g., VIRTIO_NET_HDR_GSO_TCPV4) does not match the network
> protocol as stores in the link layer header (ETH_P_IPV6, or even
> something unrelated like ETH_P_ARP).
>
> You're right that it can drop UFOv6 packets. VIRTIO_NET_HDR_GSO_UDP
> has no separate V4 and V6 variants, so we have to accept both
> protocols. We need to fix that.
>
> This guess in virtio_net_hdr_set_proto
>
>         case VIRTIO_NET_HDR_GSO_UDP:
>                 skb->protocol = cpu_to_be16(ETH_P_IP);
>
> might be wrong to assume IPv4 for UFOv6, and then as of that commit
> this check will incorrectly drop the packet
>
>                                 virtio_net_hdr_set_proto(skb, hdr);
>                                 if (protocol && protocol != skb->protocol)
>                                         return -EINVAL;
>
> > and propose the next solution:
> >
> > static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
> > >                      const struct virtio_net_hdr *hdr)
> > > {
> > >     __be16 protocol;
> > >
> > >     protocol = dev_parse_header_protocol(skb);
> > >     switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
> > >     case VIRTIO_NET_HDR_GSO_TCPV4:
> > >         skb->protocol = cpu_to_be16(ETH_P_IP);
> > >         break;
> > >     case VIRTIO_NET_HDR_GSO_TCPV6:
> > >         skb->protocol = cpu_to_be16(ETH_P_IPV6);
> > >         break;
> > >     case VIRTIO_NET_HDR_GSO_UDP:
> > >     case VIRTIO_NET_HDR_GSO_UDP_L4:
>
> Please use diff to show your changes. Also do not mix bug fixes (that
> go to net) with new features (that go to net-next).
>
> > >         skb->protocol = protocol;
>
> Not exactly, this would just remove the added verification.
>
> We need something like
>
> @@ -89,8 +92,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                                 __be16 protocol =
> dev_parse_header_protocol(skb);
>
>                                 virtio_net_hdr_set_proto(skb, hdr);
> -                               if (protocol && protocol != skb->protocol)
> -                                       return -EINVAL;
> +                               if (protocol && protocol != skb->protocol) {
> +                                       if (gso_type ==
> VIRTIO_NET_HDR_GSO_UDP &&
> +                                           protocol == cpu_to_be16(ETH_P_IPV6))
> +                                               skb->protocol = protocol;
> +                                       else
> +                                               return -EINVAL;
> +                               }
>
> But preferably less ugly. Your suggestion of moving the
> dev_parse_header_protocol step into virtio_net_hdr_to_skb is cleaner.
> But also executes this check in the two other callers that may not
> need it. Need to double check whether that is correct.

If the protocol can be inferred from ll_type, that should take
precedence over inferring from gso_type.

For packet sockets, tpacket_snd does call dev_parse_header_protocol
before virtio_net_hdr_to_skb. But packet_snd calls it after.

Does the following solve your bug?

"
@@ -3001,6 +3001,8 @@ static int packet_snd(struct socket *sock,
struct msghdr *msg, size_t len)
        skb->mark = sockc.mark;
        skb->tstamp = sockc.transmit_time;

+       packet_parse_headers(skb, sock);
+
        if (has_vnet_hdr) {
                err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
                if (err)
@@ -3009,8 +3011,6 @@ static int packet_snd(struct socket *sock,
struct msghdr *msg, size_t len)
                virtio_net_hdr_set_proto(skb, &vnet_hdr);
        }

-       packet_parse_headers(skb, sock);
-
"

If the protocol is set, virtio_net_hdr_to_skb should not try to
overwrite it, but check that the values match:

+static inline bool virtio_net_hdr_check_gso_proto(struct sk_buff *skb,
+                                                 const struct
virtio_net_hdr *hdr)
+{
+       u8 gso_type = hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN;
+
+       switch (skb->protocol) {
+       case htons(ETH_P_IP):
+               return (gso_type == VIRTIO_NET_HDR_GSO_TCPV4 ||
+                       gso_type == VIRTIO_NET_HDR_GSO_UDP);
+       case htons(ETH_P_IPV6):
+               return (gso_type == VIRTIO_NET_HDR_GSO_TCPV6 ||
+                       gso_type == VIRTIO_NET_HDR_GSO_UDP);
+       default:
+               return false;
+       }
+}

This can be called on any packet entering virtio_net_hdr_to_skb.

But such larger change should go to net-next.
