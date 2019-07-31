Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A56A7C7B7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGaP5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:57:51 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43191 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaP5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:57:51 -0400
Received: by mail-yw1-f67.google.com with SMTP id n205so25135073ywb.10
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 08:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UolfIcR0nWAbKNkl/4Se44XTUfwKX0dEscWjUzKZKlg=;
        b=qGq0RHAOx3OfUf/rV21eKD5WqRN4Zr9V+ijC7i/bdU1uyYlQG8t2o2PxSxKB9v1GAm
         Bk9lqPl/eP5h+eufLJ+FwQ1s+heEI/rR7pIVPYbUJEJuofBIZHA3+JMDW1cPMM3bjAhz
         F5B9MoDNz4IcJEVxk2iQX9mXr/idZJEx8g76U1CDwZdU1pQZghHAua+IOZtz33gr6/Cz
         RhUKG+cAj2zUxvJKU5f7Ffi996Z9ENa4tTu+HwfqODrUfcNyyZgphDdt6abZFACxN7DK
         yRHW+mIsYO4Uyj2Oym/RNufEcxvArHvMRoLGpwFVZEkuhVDKsFnZPDXry5P1oxbgWt5y
         7jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UolfIcR0nWAbKNkl/4Se44XTUfwKX0dEscWjUzKZKlg=;
        b=YSkKGp76aKfqhUnfggcpbqtDjHVk9mqwFa4roA3drfg6liRWXaooNjPozdCRAaGPXm
         w9roVoLg7gJx1dFzE8+dyMZ77bXma6jVkrBwSjGT4Ingdgv8L5/VNv9EB2QJ9SeNLoTc
         eMCCEvoUVIcX+QS7RW4QxSjWg026I5KAaiBoH1aZu9HQEZuiUxBgP+Pt2wyIqVH49RGK
         XVzJyv+XCh5BsyjAvk7x7ChEItz5F+zI9PsiKblZ0Xpp0R8fetAmyxthw73M0h2ykT4H
         9ugL/vKf0pZab6EzgyluDoFuS4gkRHik0dOfuP+rr4IdoOsDNaFt27xb2LWTYjIKuzpF
         xghA==
X-Gm-Message-State: APjAAAUE9c6Eik3KfYWrGx1YnsS8YkZYPZljeXX55gRD4Mdb04WxZTR5
        m6DGpteUdwwVSusmq9IVfKWQi8FZ
X-Google-Smtp-Source: APXvYqzxTW9vtykfVPvJPagct3OS8g9y5pnJvkVHyuunhf5/g9sIvYtFWevXJAEqJSAAhay/gYiJWw==
X-Received: by 2002:a0d:d9c4:: with SMTP id b187mr76707761ywe.23.1564588670143;
        Wed, 31 Jul 2019 08:57:50 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id 66sm16527930ywb.82.2019.07.31.08.57.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:57:48 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id z197so25131939ywd.13
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 08:57:47 -0700 (PDT)
X-Received: by 2002:a0d:cc48:: with SMTP id o69mr70328826ywd.389.1564588666625;
 Wed, 31 Jul 2019 08:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190730211258.13748-1-jakub.kicinski@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 31 Jul 2019 11:57:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdN41z5PVfyT5Z-ApnKQ9CYcDSnr4VGZnsgA-iAEK12Ow@mail.gmail.com>
Message-ID: <CA+FuTSdN41z5PVfyT5Z-ApnKQ9CYcDSnr4VGZnsgA-iAEK12Ow@mail.gmail.com>
Subject: Re: [PATCH net-next] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 5:13 PM Jakub Kicinski
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
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> I'm sending this for net-next because of lack of confidence
> in my own abilities. It should apply cleanly to net... :)
>
>  Documentation/networking/tls-offload.rst |  9 --------
>  include/net/sock.h                       | 28 +++++++++++++++++++++++-
>  net/core/skbuff.c                        |  3 +++
>  net/core/sock.c                          | 22 ++++++++++++++-----
>  net/ipv4/tcp.c                           |  4 +++-
>  net/ipv4/tcp_output.c                    |  3 +++
>  net/tls/tls_device.c                     |  2 ++
>  7 files changed, 55 insertions(+), 16 deletions(-)

>  Redirects leak clear text
>  -------------------------
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 228db3998e46..90f3f552c789 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -814,6 +814,7 @@ enum sock_flags {
>         SOCK_TXTIME,
>         SOCK_XDP, /* XDP is attached */
>         SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
> +       SOCK_CRYPTO_TX_PLAIN_TEXT, /* Generate skbs with decrypted flag set */
>  };
>
>  #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
> @@ -2480,8 +2481,26 @@ static inline bool sk_fullsock(const struct sock *sk)
>         return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
>  }
>
> +static inline void sk_set_tx_crypto(const struct sock *sk, struct sk_buff *skb)

nit: skb_.. instead of sk_.. ?

> +{
> +#ifdef CONFIG_TLS_DEVICE
> +       skb->decrypted = sock_flag(sk, SOCK_CRYPTO_TX_PLAIN_TEXT);
> +#endif
> +}

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 0b788df5a75b..9e92684479b9 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3794,6 +3794,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>
>                         skb_reserve(nskb, headroom);
>                         __skb_put(nskb, doffset);
> +#ifdef CONFIG_TLS_DEVICE
> +                       nskb->decrypted = head_skb->decrypted;
> +#endif

decrypted is between header_start and headers_end, so
__copy_skb_header just below should take care of this?


> diff --git a/net/core/sock.c b/net/core/sock.c
> index d57b0cc995a0..b0c10b518e65 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1992,6 +1992,22 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
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
> +#ifdef CONFIG_INET
> +       if (skb->destructor == tcp_wfree)
> +               return true;
> +#endif
> +       return skb->destructor == sock_wfree;
> +}
> +

Just insert the skb->decrypted check into skb_orphan_partial for less
code churn?

I also think that this is an independent concern from leaking plain
text, so perhaps could be a separate patch.
