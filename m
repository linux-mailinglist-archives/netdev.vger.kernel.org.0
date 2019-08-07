Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D57D8518D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 18:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfHGQ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 12:59:41 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37031 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729804AbfHGQ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 12:59:41 -0400
Received: by mail-yb1-f193.google.com with SMTP id i1so25330023ybo.4
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 09:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyNwybw8VXShXpoDRYy43ve4PM+gvZH/Whv5uWEXwS8=;
        b=jO9KZipqu8Dld/+ZvUTV1x1zHYnfVqYdnYrUsitarU6qLYMZ7uVxoXjMKXvQvMhRpW
         qU+/6JVT/VrS53spTGcCCbs4aaHoDSWXiB+HBbAGvgJhUV0v5bpfVKOGjT2UPBjkdoDB
         8g8NU7VEJCr/wcNkBc9u0uTYlTJvriT2QVeWfRU8rdOwgBBX+TpzZiQdJ8RS/fCYWHtM
         S9TyN8bJ77lT7TbE9SaF2kmUuB/hMEDGnHe2wYKMs4DJY6dsQXGuozMqVPL2Cl4APgKY
         6GbyqB6PrRam5YNf8TDNnMIc8PhKyjW/30AcptSQDg1CogWAPwmrG5hBAOmFIWnrhpBc
         bsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyNwybw8VXShXpoDRYy43ve4PM+gvZH/Whv5uWEXwS8=;
        b=D86EQDfWsQfRPP/pR6pypieMlaHc87NmpTTExaZAgFqbFUo9eWiuEN6SR/MkYR0c9N
         vi9ClNDKDxTT57lsDVsfDx5LvNA16YFTmZ/FVkujhTHSgtsueHhyWGt6Js3aoTYMfiZg
         3C7pG8vQNo7UsQarlNwR6qc2o1sa00QmiBzEl961J1ggvcoh1EaicDC6nOtFhcxXwSlh
         ZP9ru8ukBD08Lr6rqgd0qhcHLryP8wnm8Id4CP/VbJQ8G8GVTUDDcaHRrYlxgXs8+PfM
         P7hxDQtFttD50v2jHGgVgFw8Zd7JHzBxRuSGlGuHf/nNW++W5FNcbWL2mja3o2On6zoT
         Q/Jw==
X-Gm-Message-State: APjAAAXUmvSTkWHXVTh620lhIFR4FA8rR3Da9F28vSQvMRem5mMfn840
        MBeRsOrNlCfy7G5VM0od+Cc2aY56
X-Google-Smtp-Source: APXvYqwZiZgHmqCXlMyOCbl+ennA26Wdvjyqv+1RVrLx+p2339Mf0FGY1kBEF9uCYyiHn9OpLJymuw==
X-Received: by 2002:a25:1dd4:: with SMTP id d203mr6766187ybd.124.1565197179169;
        Wed, 07 Aug 2019 09:59:39 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id l82sm21984675ywb.64.2019.08.07.09.59.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 09:59:38 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id x67so31355233ywd.3
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 09:59:38 -0700 (PDT)
X-Received: by 2002:a81:3301:: with SMTP id z1mr2396111ywz.190.1565197177626;
 Wed, 07 Aug 2019 09:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190807060612.19397-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190807060612.19397-1-jakub.kicinski@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 7 Aug 2019 12:59:00 -0400
X-Gmail-Original-Message-ID: <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
Message-ID: <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
Subject: Re: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 2:06 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> sk_validate_xmit_skb() and drivers depend on the sk member of
> struct sk_buff to identify segments requiring encryption.
> Any operation which removes or does not preserve the original TLS
> socket such as skb_orphan() or skb_clone() will cause clear text
> leaks.
>
> Make the TCP socket underlying an offloaded TLS connection
> mark all skbs as decrypted, if TLS TX is in offload mode.
> Then in sk_validate_xmit_skb() catch skbs which have no socket
> (or a socket with no validation) and decrypted flag set.
>
> Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
> sk->sk_validate_xmit_skb are slightly interchangeable right now,
> they all imply TLS offload. The new checks are guarded by
> CONFIG_TLS_DEVICE because that's the option guarding the
> sk_buff->decrypted member.
>
> Second, smaller issue with orphaning is that it breaks
> the guarantee that packets will be delivered to device
> queues in-order. All TLS offload drivers depend on that
> scheduling property. This means skb_orphan_partial()'s
> trick of preserving partial socket references will cause
> issues in the drivers. We need a full orphan, and as a
> result netem delay/throttling will cause all TLS offload
> skbs to be dropped.
>
> Reusing the sk_buff->decrypted flag also protects from
> leaking clear text when incoming, decrypted skb is redirected
> (e.g. by TC).
>
> See commit 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect
> through ULP") for justification why the internal flag is safe.
>
> v2:
>  - remove superfluous decrypted mark copy (Willem);
>  - remove the stale doc entry (Boris);
>  - rely entirely on EOR marking to prevent coalescing (Boris);
>  - use an internal sendpages flag instead of marking the socket
>    (Boris).
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  Documentation/networking/tls-offload.rst | 18 ------------------
>  include/linux/skbuff.h                   |  8 ++++++++
>  include/linux/socket.h                   |  3 +++
>  include/net/sock.h                       | 10 +++++++++-
>  net/core/sock.c                          | 20 +++++++++++++++-----
>  net/ipv4/tcp.c                           |  3 +++
>  net/ipv4/tcp_output.c                    |  3 +++
>  net/tls/tls_device.c                     |  9 +++++++--
>  8 files changed, 48 insertions(+), 26 deletions(-)

> diff --git a/net/core/sock.c b/net/core/sock.c
> index d57b0cc995a0..0f9619b0892f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1992,6 +1992,20 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>
> +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> +{
> +#ifdef CONFIG_TLS_DEVICE
> +       /* Drivers depend on in-order delivery for crypto offload,
> +        * partial orphan breaks out-of-order-OK logic.
> +        */
> +       if (skb->decrypted)
> +               return false;
> +#endif
> +       return (IS_ENABLED(CONFIG_INET) &&
> +               skb->destructor == tcp_wfree) ||

Please add parentheses around IS_ENABLED(CONFIG_INET) &&
skb->destructor == tcp_wfree

I was also surprised that this works when tcp_wfree is not defined if
!CONFIG_INET. But apparently it does (at -O2?) :)

> @@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>                         if (!skb)
>                                 goto wait_for_memory;
>
> +#ifdef CONFIG_TLS_DEVICE
> +                       skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
> +#endif

Nothing is stopping userspace from passing this new flag. In send
(tcp_sendmsg_locked) it is ignored. But can it reach do_tcp_sendpages
through tcp_bpf_sendmsg?

>                         skb_entail(sk, skb);
>                         copy = size_goal;
>                 }
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6e4afc48d7bb..979520e46e33 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1320,6 +1320,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>         buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
>         if (!buff)
>                 return -ENOMEM; /* We'll just try again later. */
> +       skb_copy_decrypted(buff, skb);

This code has to copy timestamps, tx_flags, zerocopy state and now
this in three locations. Eventually we'll want a single helper for all
of them..
