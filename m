Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B8A1BEC4
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 22:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfEMUdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 16:33:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38763 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEMUdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 16:33:44 -0400
Received: by mail-ed1-f67.google.com with SMTP id w11so19388044edl.5;
        Mon, 13 May 2019 13:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B70CDG0UnrqM0ftRUzJ1VNMZ8Sv2w6+g3UHOZr1Nid0=;
        b=MLkWQwJPXrkBm+//Y7FM9bkiVCUE6aXkrwTn0AEBy7nu7Xn8r0ZDuNd2ba/eNDGTob
         KlbOZumMBvhTOKCeT0gaUNNxZVJkrx/MPTdLlN9ixCZlLYpGeiP6HU94phRJvSk1rkEy
         bZMq43cy9D/ImB0cBtA+B2vaea3o4pDbYhT2ymhH5qe7jpbt0gGA2URrxs2qzrFOyfZD
         Tgvf4GORXooa8d21p986sALJTZKPL/7G8b0NqOAcKeZt4Kv04mTm1kumvaGPuosqhbdo
         yhidkIjdWR2+9U9NRdN0UP3+XIwb5moSL1SwqlWZyCtSG5prKF0ntDZX6w+InOtgQish
         oNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B70CDG0UnrqM0ftRUzJ1VNMZ8Sv2w6+g3UHOZr1Nid0=;
        b=qi97MrQCZCwuRxaJx4EYDo8TOkMVsFbkIB6BLk3O/mcuWELf2j/QKLqvnPpQQ6oM0Q
         xLDwqcmt0sJCxPpaAU53Y6uVQnhwMGVHOxMhAXqwPCcGDdMN9cj/pEAnbE1xs+yooj5h
         aVqfNnWuZb2REhYwje80SOavzDMRd2oxJ9OmlMUjO9qg5AMLN/6OVqlmHAnroNg3hw5x
         a15eMSzTZbVFYNXUXOVbhpWJlnRmaSCnkHGum0S+IogYZRPx18vXa15j2Fn+DZ19tq4Y
         Wo9zsH1uUhl2N7k5LGYeWETAQr29Q6kyevqIUC9av+9C8WjNw1Of4T5faHSYoOqexzWr
         Bhqw==
X-Gm-Message-State: APjAAAUXFmXNp5ailU0MVdnefCTugzdLPSOW06P81uJdknRAr52w+Lb/
        GQ+vT+jjXaORy/42IOxvNKO4b37BBtp5RYB7KKo=
X-Google-Smtp-Source: APXvYqzh/rFmdIB0xWUFlk4UcYw4AH8kUyDIOy03zsZdvOMpFL2kILxPHJ8wDuWHsSUHsyXznBNu3xivgd3D4vY8UGE=
X-Received: by 2002:a50:8dc5:: with SMTP id s5mr4512379edh.138.1557779622307;
 Mon, 13 May 2019 13:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185402.220122-1-sdf@google.com>
In-Reply-To: <20190513185402.220122-1-sdf@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 13 May 2019 16:33:06 -0400
Message-ID: <CAF=yD-LO6o=uZ-aT-J9uPiBcO4f2Zc9uyGZ+f7M7mPtRSB44gA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: support FLOW_DISSECTOR_KEY_ETH_ADDRS
 with BPF
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> If we have a flow dissector BPF program attached to the namespace,
> FLOW_DISSECTOR_KEY_ETH_ADDRS won't trigger because we exit early.

I suppose that this is true for a variety of keys? For instance, also
FLOW_DISSECTOR_KEY_IPV4_ADDRS.

We originally intended BPF flow dissection for all paths except
tc_flower. As that catches all the vulnerable cases on the ingress
path on the one hand and it is infeasible to support all the
flower features, now and future. I think that is the real fix.

>
> Handle FLOW_DISSECTOR_KEY_ETH_ADDRS before BPF and only if we have
> an skb (used by tc-flower only).
>
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  net/core/flow_dissector.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 9ca784c592ac..ba76d9168c8b 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -825,6 +825,18 @@ bool __skb_flow_dissect(const struct net *net,
>                         else if (skb->sk)
>                                 net = sock_net(skb->sk);
>                 }
> +
> +               if (dissector_uses_key(flow_dissector,
> +                                      FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
> +                       struct ethhdr *eth = eth_hdr(skb);

Here as well as in the original patch: is it safe to just cast to
eth_hdr? In the same file, __skb_flow_dissect_gre does test for
(encapsulated) protocol first.
