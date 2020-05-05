Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00931C61EA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgEEUYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728076AbgEEUYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:24:02 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:24:02 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q7so193527qkf.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nU71uN6a9cWiSFlJfVXXBXRBImWeoLqu7MgSy8U/okY=;
        b=S3V3u/nGlQ5spxJ+Lbkm8sW78Z50b7+KtThAiiuXrVHJL+QOQnUn/QfQZbxb0/guXR
         NEzx+vcEaU1jH3QVgNqVcx2pSgdTV5uWqTDjWGbNxZGpxZFoIYurZKNiF5mQAiAD2tAR
         DX4D3tvrfolgkTaWBTXU9xfLH379fHrYIIvlQrl1jVzFwV0f+FEEZTb9SCIwkZpKa5rd
         PTJ46nXjNRadnQDOwtyaqiOg1fFrBMdbO/fhUM7+aFFjxrrBj4vwHHTgsv06Vl57+0oC
         WoWZwtSQgS75hdnJzLuN8sV5D6iqQnUd6gr6JaYD+EHjQQT7Avxy/nSZ0MOaT34UtQHK
         /zQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nU71uN6a9cWiSFlJfVXXBXRBImWeoLqu7MgSy8U/okY=;
        b=jr7omiWJtA/e6jZg7bfdk7mMumuqRvgvz2crcBuiR6lvjhtoogpWlOazhitlXDqlDS
         J+FTyCjchM6sPaEK9eB7LJRHLmBQYWHPZifccYAyrH+gM9HM53UbJYiMg6lvLwLIy90L
         AFkXiQR0v44jGFv5TCze0ZC0SeB8vbxQVck0pd20pl8WLVcwiuQnzkBF+UB+4GYq+wZK
         6pIYkN+8rAOHMs5ih74w8VxZZR/yphQ/yJJi8s/exj3gfXv9PyLLH1ssHNIAokUvQ2A0
         5YYAq9x4TgHoRvrrvOOgiNBOeASmCUr7jlm0TSXFUV9yYSgavVKSnJsidnUkEG/e2fbw
         zN8A==
X-Gm-Message-State: AGi0PuZ570NzZyqH0K19sDcCw00R+HlqgFtGKaDCfsV8/nN4osYDDahm
        afflgk+zAU3h5Tz7TdCIUl+FarWZ
X-Google-Smtp-Source: APiQypI5Me436ZM2uKfIAENRt6w8o8MgbU7HojrQTD7UcQN5g0qvQAW1LDP9qJa6dXDd1FFIfJNs7A==
X-Received: by 2002:a37:b95:: with SMTP id 143mr5216982qkl.409.1588710240454;
        Tue, 05 May 2020 13:24:00 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id a64sm2681588qkc.114.2020.05.05.13.23.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 13:24:00 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id w137so544947ybg.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:23:59 -0700 (PDT)
X-Received: by 2002:a05:6902:533:: with SMTP id y19mr8102031ybs.213.1588710238623;
 Tue, 05 May 2020 13:23:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200504162948.4146-1-kelly@onechronos.com>
In-Reply-To: <20200504162948.4146-1-kelly@onechronos.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 5 May 2020 16:23:21 -0400
X-Gmail-Original-Message-ID: <CA+FuTSco8n3CFJ78RF_rTLCoGd5=haFxrrOKHhuD6UdyApC+Rg@mail.gmail.com>
Message-ID: <CA+FuTSco8n3CFJ78RF_rTLCoGd5=haFxrrOKHhuD6UdyApC+Rg@mail.gmail.com>
Subject: Re: [PATCH] net: tcp: fix rx timestamp behavior for tcp_recvmsg
To:     Kelly Littlepage <kelly@onechronos.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Iris Liu <iris@onechronos.com>,
        Mike Maloney <maloney@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 12:30 PM Kelly Littlepage <kelly@onechronos.com> wrote:
>
> Timestamping cmsgs are not returned when the user buffer supplied to
> recvmsg is too small to copy at least one skbuff in entirety.

In general a tcp reader should not make any assumptions on
packetization of the bytestream, including the number of skbs that
might have made up the bytestream.

> Support
> for TCP rx timestamps came from commit 98aaa913b4ed ("tcp: Extend
> SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which noted that the cmsg
> should "return the timestamp corresponding to the highest sequence
> number data returned." The commit further notes that when coalescing
> skbs code should "maintain the invariant of returning the timestamp of
> the last byte in the recvmsg buffer."

This states that if a byte range spans multiple timestamps, only the
last one is returned.

> This is consistent with Section 1.4 of timestamping.txt, a document that
> discusses expected behavior when timestamping streaming protocols. It's
> worth noting that Section 1.4 alludes to a "buffer" in a way that might
> have resulted in the current behavior:
>
> > The SO_TIMESTAMPING interface supports timestamping of bytes in a
> bytestream. Each request is interpreted as a request for when the entire
> contents of the buffer has passed a timestamping point....In practice,
> timestamps can be correlated with segments of a bytestream consistently,
> if both semantics of the timestamp and the timing of measurement are
> chosen correctly....For bytestreams, we chose that a timestamp is
> generated only when all bytes have passed a point.
>
> An interpretation of skbs as delineators for timestamping points makes
> sense for tx timestamps but poses implementation challenges on the rx
> side. Under the current API unless tcp_recvmsg happens to return bytes
> copied from precisely one skb there's no useful mapping from bytes to
> timestamps. Some sequences of reads will result in timestamps getting
> lost

That's a known caveat, see above. This patch does not change that.

> and others will result in the user receiving a timestamp from the
> second to last skb that tcp_recvmsg copied from instead of the last.

On Tx, the idea was to associate a timestamp with the last byte in the
send buffer, so that a timestamp for this seqno informs us of the
upper bound on latency of all bytes in the send buffer.

On Rx, we currently return the timestamp of the last skb of which the
last byte is read, which is associated with a byte in the recv buffer,
but it is not necessarily the last one. Nor the first. As such it is
not clear what it defines.

Your patch addresses this by instead always returning the timestamp
associated with the last byte in the recv buffer. The same timestamp
could then be returned again for a subsequent recv call, if the entire
recv buffer is filled from the same skb. Which is fine.

That sounds correct to me.

> The
> proposed change addresses both problems while remaining consistent with
> 1.4 and the wording of commit 98aaa913b4ed ("tcp: Extend
> SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg").
>
> Co-developed-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> ---
>  net/ipv4/tcp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6d87de434377..e72bd651d21a 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
>                         tp->urg_data = 0;
>                         tcp_fast_path_check(sk);
>                 }
> -               if (used + offset < skb->len)
> -                       continue;
>
>                 if (TCP_SKB_CB(skb)->has_rxtstamp) {
>                         tcp_update_recv_tstamps(skb, &tss);
>                         cmsg_flags |= 2;
>                 }
> +
> +               if (used + offset < skb->len)
> +                       continue;
> +
>                 if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
>                         goto found_fin_ok;
>                 if (!(flags & MSG_PEEK))
> --
> 2.26.2
