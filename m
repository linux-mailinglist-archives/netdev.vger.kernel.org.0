Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11602F8A87
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbhAPBjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPBjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:39:55 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A2CC061757;
        Fri, 15 Jan 2021 17:39:14 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u17so21853949iow.1;
        Fri, 15 Jan 2021 17:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PoIsXC9DSnvY/q8pSjUqhgcuN6YyItMJJNHxvNzTBLE=;
        b=i7FHNlPg7W8euHKdfl30sU0R8phdn6AAxuipGHevgWY3JRft5Tzz4rn2OR3+gd9Rte
         J7aCj6lz4+u8YGAwQCEoLz0X8ZaBRJHESfPDablZvXE2Hyi0MlXanMh04RNTqHy55v6t
         sjPE8lTIo4UPJMPMfC2pnSPDBDPPcQV6nb1NJiMPTUhPQ+OWf+l4dBNZ/k8ZXM1Zgo/f
         cYxywEeVNlMogfR9Hie7rqVateFarvP89x9dPfHorxLQ6wh0fnD7DPWrHmjcr+YI7LTd
         SzapiEgYIFhKyE4O9LNUCjTR2jHUfGD2uaJqA6N023UPTpvU7Xc0PiM5wR9sehQboJUD
         ZHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PoIsXC9DSnvY/q8pSjUqhgcuN6YyItMJJNHxvNzTBLE=;
        b=VGppMJ4pJ9ESWiyUQ3PdXjF/5xwnX41IXIcbdBC/bXkDPMEyc8yI36+KCpAfjqKEN9
         bpV1GS0lQzkr2JWrMuQBJBqUajBLkL0qebQXwnlGEW8hNOIvfoS+vqJYiZ+RuRUBeDx5
         U9sTFRypJj/XP9lsAGSaJKwFUBwkC/98dKyQkSTvTbH5B0W8FlBvHR/tmcia0AJuAhHx
         BNOaG2aaX1wMP2e7NSo3Dyy5MKaGZnzaXYh8aF8HVQ5OEyvQth0cd+y0dAvpAkSuBdJw
         w03h4H/UUgfDwOlD2Zx71b3n/ABmP25VbAUWak3iX1/Uv7TUrSRiK300VeQSAmUjqNsu
         qRCA==
X-Gm-Message-State: AOAM531vPG3crmoO/Ugl4FoHqn9FYoWVs9e6JJ9SI/zJ7i5OurvVQCbN
        iZCfj7+urooWtyjEdlzfmypXPxGMnqhUXX9DdPs=
X-Google-Smtp-Source: ABdhPJysaIvPF5yj15PQO2cl6ISBgrayNnipTKTvPCZLSd4s8wevmblZh1wmgl8Hm1D6wG7X3ocGYKtXZxJXJBWZsyg=
X-Received: by 2002:a05:6e02:68b:: with SMTP id o11mr13289917ils.237.1610761153931;
 Fri, 15 Jan 2021 17:39:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610703289.git.lucien.xin@gmail.com> <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
In-Reply-To: <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 17:39:02 -0800
Message-ID: <CAKgT0Uc1iObzmeFL8G91jxKxvWARb4z2bJJxv6yJ+5QOYPJQsQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net: move the hsize check to the else
 block in skb_segment
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 1:36 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> After commit 89319d3801d1 ("net: Add frag_list support to skb_segment"),
> it goes to process frag_list when !hsize in skb_segment(). However, when
> using skb frag_list, sg normally should not be set. In this case, hsize
> will be set with len right before !hsize check, then it won't go to
> frag_list processing code.
>
> So the right thing to do is move the hsize check to the else block, so
> that it won't affect the !hsize check for frag_list processing.
>
> v1->v2:
>   - change to do "hsize <= 0" check instead of "!hsize", and also move
>     "hsize < 0" into else block, to save some cycles, as Alex suggested.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  net/core/skbuff.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6039069..e835193 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3894,12 +3894,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                 }
>
>                 hsize = skb_headlen(head_skb) - offset;
> -               if (hsize < 0)
> -                       hsize = 0;
> -               if (hsize > len || !sg)
> -                       hsize = len;
>
> -               if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
> +               if (hsize <= 0 && i >= nfrags && skb_headlen(list_skb) &&
>                     (skb_headlen(list_skb) == len || sg)) {
>                         BUG_ON(skb_headlen(list_skb) > len);
>
> @@ -3942,6 +3938,11 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                         skb_release_head_state(nskb);
>                         __skb_push(nskb, doffset);
>                 } else {
> +                       if (hsize > len || !sg)
> +                               hsize = len;
> +                       else if (hsize < 0)
> +                               hsize = 0;
> +
>                         nskb = __alloc_skb(hsize + doffset + headroom,
>                                            GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
>                                            NUMA_NO_NODE);
> --
> 2.1.0
>
