Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CB2220052
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgGNVx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:53:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgGNVx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594763604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBrBUXOa+KygAEI8uAc8OVy988cLmukQNB62vtaLvzc=;
        b=HAx8biBFPD/3xCnWPYr+vwOrkU5brCtZ56NC/ZsEwYJ54vsOP5e5Jq87Qy/xWeMcpgghO2
        XxrrIFZ9f1u1R4Bm35VEhlkllD7yB/B5Ze5WPEQlVQDq5J4ZabKc2wgfp2JnnAbz4qMR8/
        7vdlhzcL+ipy84FkTq/HUe7aaSzVxUo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-Lzi0MKYGNjeIyoPBiSi10Q-1; Tue, 14 Jul 2020 17:53:23 -0400
X-MC-Unique: Lzi0MKYGNjeIyoPBiSi10Q-1
Received: by mail-wm1-f69.google.com with SMTP id e15so59406wme.8
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gBrBUXOa+KygAEI8uAc8OVy988cLmukQNB62vtaLvzc=;
        b=ElhF77D4DdJ8QPOvvkfa0ZiwvniOy4ctTqoPUqlUVM4CXpS8qS2/lh2I/3p6NJQNju
         ZEaerI6qBuVIG7yNbju4vIJQMe4N2LlzMlX8N4BjcK9uAumZwvqIqALv62ESXc483ZUS
         4zxCoy/VSDdwiZDI0CdnkxFjk3J1mzKszbIuE6xdvAXpSeO7XZ7zV0//SYnYwzr4bas9
         v1ZPxuD+8RyGHgx1dSr8a97Hb8jSs6aNaI48cNyAnv0WMI7Q4e2j8kcNJfkuP046U0ev
         iXfhrVGetwQGJLJ9aGeoMK/eTwRVjeUYx+s9mur5h6WtPc20xX+Vo2LXwaAaLz8v12Mn
         x3pQ==
X-Gm-Message-State: AOAM533hScLS+HFOa+5NEir5O8GJSdTVc5oZLSIi75NPt2LUPz5eiOe1
        E/g8HsGCBvYjyQTHftdG9OKeqyxGkBbFtTlhUrrNudWpCCXNruWXw3+OZG0usQK5NTurPjnmLBD
        GMXw8tF/NFVQA/P1g
X-Received: by 2002:a7b:c348:: with SMTP id l8mr6030578wmj.54.1594763602010;
        Tue, 14 Jul 2020 14:53:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOig18Rp+KPD7Wpf+QRvy7WLjAI48A0io6QTqe6iXIDxlYocFZ/gT86ity7m9EDbKj+ugSew==
X-Received: by 2002:a7b:c348:: with SMTP id l8mr6030561wmj.54.1594763601805;
        Tue, 14 Jul 2020 14:53:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m16sm105682wro.0.2020.07.14.14.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:53:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D83DF1804F0; Tue, 14 Jul 2020 23:53:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv7 bpf-next 0/3] xdp: add a new helper for dev map multicast support
In-Reply-To: <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com> <20200714063257.1694964-1-liuhangbin@gmail.com> <87imeqgtzy.fsf@toke.dk> <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 23:53:20 +0200
Message-ID: <87ft9tg3vz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>David Ahern <dsahern@gmail.com> writes:

> On 7/14/20 6:29 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>>=20
>>> This patch is for xdp multicast support. which has been discussed befor=
e[0],
>>> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
>>> a software switch that can forward XDP frames to multiple ports.
>>>
>>> To achieve this, an application needs to specify a group of interfaces
>>> to forward a packet to. It is also common to want to exclude one or more
>>> physical interfaces from the forwarding operation - e.g., to forward a
>>> packet to all interfaces in the multicast group except the interface it
>>> arrived on. While this could be done simply by adding more groups, this
>>> quickly leads to a combinatorial explosion in the number of groups an
>>> application has to maintain.
>>>
>>> To avoid the combinatorial explosion, we propose to include the ability
>>> to specify an "exclude group" as part of the forwarding operation. This
>>> needs to be a group (instead of just a single port index), because there
>>> may have multi interfaces you want to exclude.
>>>
>>> Thus, the logical forwarding operation becomes a "set difference"
>>> operation, i.e. "forward to all ports in group A that are not also in
>>> group B". This series implements such an operation using device maps to
>>> represent the groups. This means that the XDP program specifies two
>>> device maps, one containing the list of netdevs to redirect to, and the
>>> other containing the exclude list.
>>>
>>> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
>>> to accept two maps, the forwarding map and exclude map. If user
>>> don't want to use exclude map and just want simply stop redirecting back
>>> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
>>>
>>> The 2nd and 3rd patches are for usage sample and testing purpose, so th=
ere
>>> is no effort has been made on performance optimisation. I did same tests
>>> with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
>>> test result(the veth peer has a dummy xdp program with XDP_DROP directl=
y):
>>>
>>> Version         | Test                                   | Native | Gen=
eric
>>> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1=
.9M
>>> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1=
.6M
>>> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1=
.9M
>>> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1=
.6M
>>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1=
.5M
>>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1=
.3M
>>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.=
98M
>>>
>>> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we lo=
op
>>> the arrays and do clone skb/xdpf. The native path is slower than generic
>>> path as we send skbs by pktgen. So the result looks reasonable.
>>>
>>> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
>>> suggestions and help on implementation.
>>>
>>> [0] https://xdp-project.net/#Handling-multicast
>>>
>>> v7: Fix helper flag check
>>>     Limit the *ex_map* to use DEVMAP_HASH only and update function
>>>     dev_in_exclude_map() to get better performance.
>>=20
>> Did it help? The performance numbers in the table above are the same as
>> in v6...
>>=20
>
> If there is only 1 entry in the exclude map, then the numbers should be
> about the same.

I would still expect the lack of the calls to devmap_get_next_key() to
at least provide a small speedup, no? That the numbers are completely
unchanged looks a bit suspicious...

-Toke

