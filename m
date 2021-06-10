Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D093A2314
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhFJEIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:08:55 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:40627 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhFJEIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 00:08:54 -0400
Received: by mail-lf1-f50.google.com with SMTP id k40so831452lfv.7
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 21:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2uTw/zuSQ3CHJiNcw+dmursgnAfC/lxHwCP2iXC1rh0=;
        b=LA6F1I+9tnm85mk3kfF1zI94jdYisokGWetSEGhFkm/mQ8AT1E8ZYkVwBi7yM5+nBq
         xte7gENJQ2DxvbyplMLYsgetV2qDENzHzoaB/TGsE7ZSYFZpj/mbIbKcl+1FO7DjLBIa
         mE0DAbhDccGJQMrNev3u+xan3M3CbPQrBD9ZAj5egcUS6zGG6gbHfD8UJt1DxzX1LPrN
         +gVeT44JgeTleDWTQ9GjqPaLz9sQ31ydmmqb7WWrW7NRg+hduyRx5gr2XEw2U7efqRLb
         lkTm7DutmkHLAIDLJwKdkEj+VQOonxs3vKNxZdL1bnsxZfy69je7xBpaZEzQN+gb5i8M
         ZZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2uTw/zuSQ3CHJiNcw+dmursgnAfC/lxHwCP2iXC1rh0=;
        b=D+BiWb5kkJk5SOIGIBNqAr6T+fuwSCgt0t7G8lm7kIvqeUy3dYWQky791r373isn5C
         AgiNmDQ81cVzeSU8U42Qm61n5A3kbR6YbBe3F34AEwf8e1rijqtGqBBsn3uEJ13dXi5O
         fl9bgJAd4paLHwkqEh5G26nCxRa9nzdZlTeGcct7cW4SbiIVIGRv1jM5CrqrzhMVMdWj
         qopADC788c5TllWmfCvo1mqUkEFe0J9ch7Te82BIqcNSD9CtWeVFSRV65zAFZye4+0iO
         Fk5N5+SMX2VTTYuoZt3G7IkziSiaeUFCey9Ul+jcPyb7yNqAbRw38LyaxogaPqYPM8Kd
         bzcg==
X-Gm-Message-State: AOAM532vJ6reA92zF8z/pvwE1LmzjrsXhPC1JNXIt2cqD0MBGnpmrfvq
        ZuELEB0X9S2T6GBhkTfZGJK4v6/KqYUl098xW8c=
X-Google-Smtp-Source: ABdhPJzsR5Q9IvyYsHaVk2itlCmdhzD+/9XxEdV2U3y21+vLVQ+K4wMDbfhG6jJa9N+577VLqbHnVLZJFKaSh9wVtRo=
X-Received: by 2002:a05:6512:2010:: with SMTP id a16mr654963lfb.38.1623297944826;
 Wed, 09 Jun 2021 21:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com> <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com>
In-Reply-To: <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Jun 2021 21:05:33 -0700
Message-ID: <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 8:53 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> It works but it couples virtio with bpf.

Jason,

I think your main concern is that it makes virtio_net_hdr into uapi?
That's not the case. __sk_buff is uapi, but pointers to sockets
and other kernel data structures are not.
Yes. It's a bit weird that uapi struct has a pointer to kernel internal,
but I don't see it as a deal breaker.
Tracing progs have plenty of such cases.
In networking there is tcp-bpf where everything is kernel internal and non-uapi.
So after this patch virtio_net_hdr is free to change without worrying about bpf
progs reading it.
