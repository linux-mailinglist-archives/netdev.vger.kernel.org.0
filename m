Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1720CA4D
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgF1UEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1UEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:04:48 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E4C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:04:48 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id u12so11364363qth.12
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1zn/fxfOmFeMHXh6Gk5ZdelSOYcZKVlBOAb2rVI9JA=;
        b=EqfFC0dU0x9WmdbUtY9//oru81LC5z9OHEIZ/cE8DpHTbzHFsiXIulMEAgIgpIIaIP
         GkRIO+PtS+PrpMmfhiVfor2iXBSbT3w4R+wEr27nFnuk076Fl8ZNGCaxEnAX4ab0dB8i
         mc8IzAv35RgtJ4E7vi61uoy4bLdYiJy1l9O8CZWiIsVXOpR0+D7h+95vPps5OH9Scd/T
         SblhjR97HBCCc5pbmHdlH5CpN3v8KFBvjJt3qBpBfwITW7f0G/XHzg1AISj3sTwjlFG6
         apRaSMFFobh+TgUWCQ8ayJxtVbNhGeOQYQU+G2HAZok+redvJoqLxMkSifYHdXqYxR+1
         EK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1zn/fxfOmFeMHXh6Gk5ZdelSOYcZKVlBOAb2rVI9JA=;
        b=sZ7NAb5Ol2U2czyV0ya1QOaMTgYMc2ym1gd1S3csEnFW6zP3f9seORFcPevSOxoxhx
         mXIEAyFKIhSvbdVGLX68O6rXU0VVVQYvNZIzY5Rky/LOwVhLSLdH87dd4dCIBxqhrl48
         218zWX9CYXUi7PhOLG2qW/ISX+4sYmpz5Dn5dWL4lvF8MBndpbIsdlGY9BvWRdEXV3wb
         fxFjR1cWoYVdfo4LsFLT6bqc/vxoZ0VPt44P0aNX7brYoAM5sHW9kMw3Bw9gYd12XKpg
         DlMlAzqa/LduYmIQce2bWBgKVT1ho8NlOrZhDJMVwxqgeLIIbGCjSeBUX3CUtvbQWZAv
         CvEw==
X-Gm-Message-State: AOAM531cbaEeB6Ns/fWBCpgc9rvrykvqioRvtBeiA+12iD6AosNVdKYR
        5XDus8Jf5/kP62hzvvUGgVZYM5Cw
X-Google-Smtp-Source: ABdhPJywgbdAa9TZyDrQW1rYgmwAM5tLoQCj7uINeWaaKblg5e5v5ThX88v4Lpxr+qrhQ776SyuvNA==
X-Received: by 2002:ac8:3438:: with SMTP id u53mr12966125qtb.102.1593374687512;
        Sun, 28 Jun 2020 13:04:47 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id g5sm16675873qta.46.2020.06.28.13.04.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 13:04:46 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id e197so3388403yba.5
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:04:46 -0700 (PDT)
X-Received: by 2002:a25:cf82:: with SMTP id f124mr21339639ybg.441.1593374686050;
 Sun, 28 Jun 2020 13:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net> <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
 <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com> <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com>
In-Reply-To: <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Jun 2020 16:04:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdpU_2w9iU+Rtv8pUepOcwqHYaV1jYVfB6_K157E6CSZw@mail.gmail.com>
Message-ID: <CA+FuTSdpU_2w9iU+Rtv8pUepOcwqHYaV1jYVfB6_K157E6CSZw@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Hans Wippel <ndev@hwipl.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 1:58 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi again Hans,
>
> A few remarks: although gre implements header_ops, it looks like
> various parts of the networking stack change behavior based on it. I'm
> still analyzing that to understand the extent of the effects.
> Something like <https://git.zx2c4.com/wireguard-linux/commit/?id=40c24fd379edc1668087111506ed3d0928052fe0>
> would work, but I'm not thrilled by it. Further research is needed.
>
> However, one thing I noticed is that other layer 3 tunnels don't seem
> to be a fan of libpcap. For example, try injecting a packet into an
> ipip interface. You'll hit exactly the same snag for skb->protocol==0.

Not setting skb protocol when sending over packet sockets causes many
headaches. Besides packet_parse_headers, virtio_net_hdr_to_skb also
tries to infer it.

Packet sockets give various options to configure it explicitly: by
choosing that protocol in socket(), bind() or, preferably, by passing
it as argument to sendmsg. The socket/bind argument also configures
the filter to receive packets, so for send-only sockets it is
especially useful to choose ETH_P_NONE (0) there. This is not an
"incorrect" option.

Libpcap does have a pcap_set_protocol function, but it is fairly
recent, so few processes will likely be using it. And again it is
still not ideal if a socket is opened only for transmit.

header_ops looks like the best approach to me, too. The protocol field
needs to reflect the protocol of the *outer* packet, of course, but if
I read wg_allowedips_lookup_dst correctly, wireguard maintains the
same outer protocol as the inner protocol, no sit (6-in-4) and such.
