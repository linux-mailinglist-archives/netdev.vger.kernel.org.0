Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1931E31B
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhBQXjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhBQXjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 18:39:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F758C061574;
        Wed, 17 Feb 2021 15:38:36 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g5so246078ejt.2;
        Wed, 17 Feb 2021 15:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqKD4385HtPzJpxNaFEp7frHm8dOSRRgs99GkVuwN9I=;
        b=jm1ls5dh6neIFVdO5uKyYn2ZWGKDO+Rbz6PRcPEc9r2X2eQSRo6i/Dp8X6JPgC7tLx
         zsLITcSepJ8/hV6wlkWNjGBcYzfy+t50yni9xwFOVzLt/md7kqn95B6X3rfWYDi5NeKO
         7KRJ+5OrsLXOkZ15Op3I2zQVETegTw6xZrOvoGHjPxgPa8dJSVFl+QoAJsvfYTGb1KRF
         IrkjF1XWKhUtA+jUWxU0afcqsk6uLJnWD991FJYULtjDRvuEIyDxQrVUQn4bapgZCE1/
         nfMihXUBh0UcnptSZ5hgyQewzMGNd5iC+6m9GnFovLt/z70y8j5qbzxMZT5tODvo/IQt
         0i7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqKD4385HtPzJpxNaFEp7frHm8dOSRRgs99GkVuwN9I=;
        b=CiTV9D5hJjU/Hdey+WuIagZlM/RbUn51g73lAv4ldRk6GwKb9jT+iBwxBh7FUWiCP7
         GLfNRzwy/H9gZDqT4AbpJzsZ5xBXuuRJCZoP/aHVnn27xRBPWUeMdVUjRNu7YfrwZG7E
         r7yQAugeA0/09CGiOgMbVJshY5jKNUb7tz7nMh6I6cqZfgy18+kH7c3Qoo92QeRZgnrx
         M80YD9qME2DywHBf3MALqQ7Ihomr6wGIE3RClY3xqjq2BU62sVzmUdZQEfwESoG7QR/A
         LdOvcvvl+oV2sEl1ZjDvbgJdkGQ2hXB/pTGxT2SOhp8czP4AQ4KfU5QUOUC2kYS4vDV7
         rhRA==
X-Gm-Message-State: AOAM532z/DkgDbDQdn0WpqgX13loXASvOZoyld5zCKdERy/xmq6zaxV/
        tuVussaWt829VA9VJZiUmQKZjchIvNG73/sL7PIqVsXE
X-Google-Smtp-Source: ABdhPJzSZWre9B/vS3q/nuLZU9v7WdwKG7FL5jW4ATOaQCKP9nkctOYi+0P0JsNV/a78ha/ijlxvVY3WqQ7i7N5zAbY=
X-Received: by 2002:a17:906:fcb9:: with SMTP id qw25mr1305980ejb.11.1613605115001;
 Wed, 17 Feb 2021 15:38:35 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
 <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
 <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com>
 <CAF=yD-+Fm7TuggoEeP=Wy7DEmfuC6nxmyBQxX=EzhyTQsiP2DQ@mail.gmail.com> <CAHmME9oe59WAdNS-AjJP9rQ+Fc6TfQVh7aHABc3JNTJaZ3sVLA@mail.gmail.com>
In-Reply-To: <CAHmME9oe59WAdNS-AjJP9rQ+Fc6TfQVh7aHABc3JNTJaZ3sVLA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 17 Feb 2021 18:37:58 -0500
Message-ID: <CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com>
Subject: Re: possible stack corruption in icmp_send (__stack_chk_fail)
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 6:18 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On 2/18/21, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > On Wed, Feb 17, 2021 at 5:56 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >>
> >> Hi Willem,
> >>
> >> On Wed, Feb 17, 2021 at 11:27 PM Willem de Bruijn
> >> <willemdebruijn.kernel@gmail.com> wrote:
> >> > A vmlinux image might help. I couldn't find one for this kernel.
> >>
> >> https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
> >> has .debs with vmlinuz in there, which you can extract to vmlinux, as
> >> well as my own vmlinux elf construction with the symbols added back in
> >> by extracting them from kallsyms. That's the best I've been able to
> >> do, as all of this is coming from somebody random emailing me.
> >>
> >> > But could it be
> >> > that the forwarded packet is not sensible IPv4? The skb->protocol is
> >> > inferred in wg_packet_consume_data_done->ip_tunnel_parse_protocol.
> >>
> >> The wg calls to icmp_ndo_send are gated by checking skb->protocol:
> >>
> >>         if (skb->protocol == htons(ETH_P_IP))
> >>                icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH,
> >> 0);
> >>        else if (skb->protocol == htons(ETH_P_IPV6))
> >>                icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH,
> >> ICMPV6_ADDR_UNREACH, 0);
> >>
> >> On the other hand, that code is hit on an error path when
> >> wg_check_packet_protocol returns false:
> >>
> >> static inline bool wg_check_packet_protocol(struct sk_buff *skb)
> >> {
> >>        __be16 real_protocol = ip_tunnel_parse_protocol(skb);
> >>        return real_protocol && skb->protocol == real_protocol;
> >> }
> >>
> >> So that means, at least in theory, icmp_ndo_send could be called with
> >> skb->protocol != ip_tunnel_parse_protocol(skb). I guess I can address
> >> that. But... is it actually a problem?
> >
> > For this forwarded packet that arrived on a wireguard tunnel,
> > skb->protocol was originally also set by ip_tunnel_parse_protocol.
> > So likely not.
> >
> > The other issue seems more like a real bug. wg_xmit calling
> > icmp_ndo_send without clearing IPCB first.
> >
>
> Bingo! Nice eye! I confirmed the crash by just memsetting 0x41 to cb
> before the call. Clearly this should be zeroed by icmp_ndo_xmit. Will
> send a patch for icmp_ndo_xmit momentarily and will CC you.

Great, let's hope that's it.

gtp_build_skb_ip4 zeroes before calling. The fix will be most
obviously correct if wg_xmit does the same.

But it is quite likely that the other callers, xfrmi_xmit2 and
sunvnet_start_xmit_common should zero, too. If so, then icmp_ndo_xmit
is the more robust location to do this. Then the Fixes tag will likely
go quite a bit farther back, too.

Whichever variant of the patch you prefer.
