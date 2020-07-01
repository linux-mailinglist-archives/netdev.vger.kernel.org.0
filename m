Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECAB21024D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 05:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGADFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 23:05:43 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:32927 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgGADFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 23:05:43 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id fe6d5752
        for <netdev@vger.kernel.org>;
        Wed, 1 Jul 2020 02:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=R9DEFN3UTgzrwtlGfelndGRjm/k=; b=K9yaSo
        GcK/yOYEBss/knqA4sTiRkMX5KqDdGkbwByz9yBONvwY9Kg5xE0DrEjBtpOS92+W
        V5hU14DBxg28ufhdNANybwLPlIrIb0RtAWyg/eH26szwQ850oHISlXov24XggwfO
        XxHKH6WY+v0JnhSndQcsHyjY5RHNKMhIJe2kxEaTheDTPpvejFp1hsIBRjwUuAG6
        DZXxuCm9F0g99L+rNcRBQm9Jc5kKXwdanT3A/Hr1nuoJ1VeTShyKlLKplRzB0RnS
        233yuaTxwIm5qD8YhjvRBBxJ1PSJxmyhwFKn7fs1bbNYVtcifaUcZdTSP/8YDNDd
        IfnIUQ5Z4aj4AqZg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4c84557e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Wed, 1 Jul 2020 02:45:49 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id q3so9054711ilt.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 20:05:40 -0700 (PDT)
X-Gm-Message-State: AOAM533Ni84thyNGf+c2R97DcbIAhxr8K+8+K9ZZtfmS34pUNJjTsmAc
        CFzPz7YOcHObzv7/NDkbDM0wcdKvpIFVXhWImxE=
X-Google-Smtp-Source: ABdhPJzvZpPYevkb+E/N947mpuDYYqdmifycB2+o+GTUDXRNw9oidCnJ++JE9hpoFIHfFuPIbNWqU492xSDZnZujAFM=
X-Received: by 2002:a92:50f:: with SMTP id q15mr6007687ile.38.1593572738185;
 Tue, 30 Jun 2020 20:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net> <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
 <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
 <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com> <CA+FuTSdpU_2w9iU+Rtv8pUepOcwqHYaV1jYVfB6_K157E6CSZw@mail.gmail.com>
In-Reply-To: <CA+FuTSdpU_2w9iU+Rtv8pUepOcwqHYaV1jYVfB6_K157E6CSZw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 30 Jun 2020 21:05:27 -0600
X-Gmail-Original-Message-ID: <CAHmME9rZieNAYeeK90HLoaoeKJEv5vE9MHfn-q5zFY8_ebNqxw@mail.gmail.com>
Message-ID: <CAHmME9rZieNAYeeK90HLoaoeKJEv5vE9MHfn-q5zFY8_ebNqxw@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Hans Wippel <ndev@hwipl.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 2:04 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, Jun 27, 2020 at 1:58 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi again Hans,
> >
> > A few remarks: although gre implements header_ops, it looks like
> > various parts of the networking stack change behavior based on it. I'm
> > still analyzing that to understand the extent of the effects.
> > Something like <https://git.zx2c4.com/wireguard-linux/commit/?id=40c24fd379edc1668087111506ed3d0928052fe0>
> > would work, but I'm not thrilled by it. Further research is needed.
> >
> > However, one thing I noticed is that other layer 3 tunnels don't seem
> > to be a fan of libpcap. For example, try injecting a packet into an
> > ipip interface. You'll hit exactly the same snag for skb->protocol==0.
>
> Not setting skb protocol when sending over packet sockets causes many
> headaches. Besides packet_parse_headers, virtio_net_hdr_to_skb also
> tries to infer it.
>
> Packet sockets give various options to configure it explicitly: by
> choosing that protocol in socket(), bind() or, preferably, by passing
> it as argument to sendmsg. The socket/bind argument also configures
> the filter to receive packets, so for send-only sockets it is
> especially useful to choose ETH_P_NONE (0) there. This is not an
> "incorrect" option.
>
> Libpcap does have a pcap_set_protocol function, but it is fairly
> recent, so few processes will likely be using it. And again it is
> still not ideal if a socket is opened only for transmit.
>
> header_ops looks like the best approach to me, too. The protocol field
> needs to reflect the protocol of the *outer* packet, of course, but if
> I read wg_allowedips_lookup_dst correctly, wireguard maintains the
> same outer protocol as the inner protocol, no sit (6-in-4) and such.

WireGuard does allow 6-in-4 and 4-in-6 actually. But parse_protocol is
only ever called on the inner packet. The only code paths leading to
it are af_packet-->ndo_start_xmit, and ndo_start_xmit examines
skb->protocol of that inner packet, which means it entirely concerns
the inner packet. And generally, for wireguard, userspace only ever
deals with the inner packet. That inner packet then gets encrypted and
poked at in strange ways, and then the encrypted blob of sludge gets
put into a udp packet and sent some place. So I'm quite sure that the
behavior just committed is right.

And from writing a few libpcap examples, things seem to be working
very well, including Hans' example.

Hans - if you want to try out davem's net.git tree, you can see if
this is working properly for you.

Jason
