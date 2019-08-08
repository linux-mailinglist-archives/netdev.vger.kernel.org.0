Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634BF86660
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390115AbfHHP76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:59:58 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35687 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbfHHP76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 11:59:58 -0400
Received: by mail-yw1-f67.google.com with SMTP id g19so33626616ywe.2
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ubOmn2gBoTyTmZM4pw2lAt8LcXn2eJI3XLCjuL3DFY8=;
        b=V4WXRN6lpGBz3TPfijw4jfPIyNwi3VEfhe1O/A/JaqLuV3un/MM9JqIJltnr2sLXxf
         7zCWijd8DpG0xiyWbRF//apsKTehPhoyCC+kyREu22kJrT3ESCEfA0cSt+2GDZIwtl+Q
         97WbFWKKPLDGGKNB5nOu/BEj4k78n90435gwTfVKhD7gCrl9lGe3x7KKNVBzbNab6MSc
         pQ7d1QF8w7tno2JxNws0hNWOcsZGgK1yTmzEwgY9Xk5WJ/jUYis5dkUTtqEsmr2d+Fg3
         Z9rUeDLIz4EsdUnTb1Eo0D0yYRgRa1Ej1jS5+mfForO8/KaOylkwoGXZF1t8xP/Cf0G7
         vZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ubOmn2gBoTyTmZM4pw2lAt8LcXn2eJI3XLCjuL3DFY8=;
        b=DK/T7sQkDWk41VrMtHjNQ/7SVIsRLYYPBig+ENvSsiJQMfEC/t3aEpqlvbdBJtksMd
         cZJeKK3jQ/82eRLxUa0Q91cvAlkXvkBY2eAWRHR2SxYdvpLbmiUv7ESZf2q3jXQicBLS
         IIoOQsO5E2vd+aQizG9t0YMaYZRSGMOdXio5g+LH3IwT0C9dbtWVKeiTa3Tp8yNOzy0h
         TlRUgmmlzVMDl8yQjWIoMSv1Y5RfgWsxhDUCGzLCdzdvVl2YeWoqEkMdMLdYAwa9Cn25
         cJ3pyI8nBZfoct05RqpMWgbEs0JKbLQI38f+pCyJQTeYuSFtgwAqA+IJ86UDe3Vw3E0B
         p83A==
X-Gm-Message-State: APjAAAWlJR9ij/VCrw1fXk7cDGSEJG2K80/l2qWPSkJ+ClukpOTLKQNB
        3+40rn6ZmHW7PfRwKtPvEO9fhHf5
X-Google-Smtp-Source: APXvYqwxXpuoB24+PDRdhW0Zo2t2Xsf38FvtfIa+ZghH4J5H6zKVZuHEFGT7O8NHLCDwaFDVj37R1A==
X-Received: by 2002:a81:6b41:: with SMTP id g62mr5880131ywc.413.1565279996512;
        Thu, 08 Aug 2019 08:59:56 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id 202sm21011313ywv.94.2019.08.08.08.59.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 08:59:55 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id l124so34267358ywd.0
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 08:59:55 -0700 (PDT)
X-Received: by 2002:a81:3945:: with SMTP id g66mr7159842ywa.368.1565279994828;
 Thu, 08 Aug 2019 08:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190808000359.20785-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190808000359.20785-1-jakub.kicinski@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Aug 2019 11:59:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc7H6X+rRnxZ5NcFiNy+pw1YCONiUr+K6g800DXzT_0EA@mail.gmail.com>
Message-ID: <CA+FuTSc7H6X+rRnxZ5NcFiNy+pw1YCONiUr+K6g800DXzT_0EA@mail.gmail.com>
Subject: Re: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 8:04 PM Jakub Kicinski
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
> The only location which could leak the flag in is tcp_bpf_sendmsg(),
> which is taken care of by clearing the previously unused bit.
>
> v2:
>  - remove superfluous decrypted mark copy (Willem);
>  - remove the stale doc entry (Boris);
>  - rely entirely on EOR marking to prevent coalescing (Boris);
>  - use an internal sendpages flag instead of marking the socket
>    (Boris).
> v3 (Willem):
>  - reorganize the can_skb_orphan_partial() condition;
>  - fix the flag leak-in through tcp_bpf_sendmsg.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---


> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 3d1e15401384..8a56e09cfb0e 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -398,10 +398,14 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  {
>         struct sk_msg tmp, *msg_tx = NULL;
> -       int flags = msg->msg_flags | MSG_NO_SHARED_FRAGS;
>         int copied = 0, err = 0;
>         struct sk_psock *psock;
>         long timeo;
> +       int flags;
> +
> +       /* Don't let internal do_tcp_sendpages() flags through */
> +       flags = (msg->msg_flags & ~MSG_SENDPAGE_DECRYPTED);
> +       flags |= MSG_NO_SHARED_FRAGS;

Not for this patch, but for tcp_bpf itself: should this more
aggressively filter flags?

Both those that are valid in sendmsg, but not expected in sendpage,
and other internal flags passed to sendpage, but should never be
passable from userspace.

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 7c0b2b778703..43922d86e510 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -373,9 +373,9 @@ static int tls_push_data(struct sock *sk,
>         struct tls_context *tls_ctx = tls_get_ctx(sk);
>         struct tls_prot_info *prot = &tls_ctx->prot_info;
>         struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
> -       int tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
>         int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
>         struct tls_record_info *record = ctx->open_record;
> +       int tls_push_record_flags;
>         struct page_frag *pfrag;
>         size_t orig_size = size;
>         u32 max_open_record_len;
> @@ -390,6 +390,9 @@ static int tls_push_data(struct sock *sk,
>         if (sk->sk_err)
>                 return -sk->sk_err;
>
> +       flags |= MSG_SENDPAGE_DECRYPTED;
> +       tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
> +

Without being too familiar with this code: can this plaintext flag be
set once, closer to the call to do_tcp_sendpages, in tls_push_sg?

Instead of two locations with multiple non-trivial codepaths between
them and do_tcp_sendpages.

Or are there paths where the flag is not set? Which I imagine would
imply already passing s/w encrypted ciphertext.

>         timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>         if (tls_is_partially_sent_record(tls_ctx)) {
>                 rc = tls_push_partial_record(sk, tls_ctx, flags);
> @@ -576,7 +579,9 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
>                 gfp_t sk_allocation = sk->sk_allocation;
>
>                 sk->sk_allocation = GFP_ATOMIC;
> -               tls_push_partial_record(sk, ctx, MSG_DONTWAIT | MSG_NOSIGNAL);
> +               tls_push_partial_record(sk, ctx,
> +                                       MSG_DONTWAIT | MSG_NOSIGNAL |
> +                                       MSG_SENDPAGE_DECRYPTED);
>                 sk->sk_allocation = sk_allocation;
>         }
>  }
> --
> 2.21.0
>
