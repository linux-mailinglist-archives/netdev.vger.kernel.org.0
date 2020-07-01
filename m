Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E352210338
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 07:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgGAFJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 01:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgGAFJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 01:09:52 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D565CC061755;
        Tue, 30 Jun 2020 22:09:51 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id q22so11009963qtl.2;
        Tue, 30 Jun 2020 22:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqV/UpQm42TyjbBOS0aVKjc65sxASToDyPti3Rp2Pks=;
        b=u11v4HA83pTSMBQcV5+6JELg8FTDxzQlVF7K5K6o+Tk21Oj+bOp0yagHq/si5xYM+8
         cFWN6BlxG0nhvfFINj5+3AjuhTUJ0ecmT595e9sFFx2hCvg4lesLXCV8+tSF+WECheUs
         5tWWgvez5o3yI+c8KaPOg+QdHpB+8TBmd82OAJV0TYYlXjT2x80gROnsoFmNePZa2nEN
         eDp3Q3v73AnN9cFIi6DSH3dPPEbR4f2ie2cIJPhrZZ5GKbUddb+mOAu5Nw6TZAH6GFbp
         IQHT2D18seVCyl0Nfq5nm1acBJ7amGXcAKyuDOh5aADkq8DjSlcGtiiPZyLqmf2pvSb/
         f5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqV/UpQm42TyjbBOS0aVKjc65sxASToDyPti3Rp2Pks=;
        b=P/Beh4Xx5SXA0NtZG51W0A+8Xwe538Uo8ZGeBXETsN9rBd1Q/MNb5Wakzj0LwX3RhP
         7J3BYi+c06gYTMu+oNw8fMLCUpl7n1tqtMvCSnhMTrV0TdQ9hO3oQCh/YDWNMcvhWcNS
         KLNPm1x04W7Ay9WVYVaNG7jIkk4+xDg8cFQDle/YL9ie1k7WRrgTr9+2QiRinpQb0sW3
         wC84GfQdWizye7/go14zL0DZhceB2pKEy8aI6do5bUgEBeD6omUVGdOw9XY+2thZamt3
         q1C6VXCHeo0qy6LYzmY2ZhWaYMgTRi2RqOJPNJby+MCv7dda/cUgMjpB/QsvQCVcNmm+
         yU/w==
X-Gm-Message-State: AOAM533ymzH9NwWbSrQ7AjqoD3RyC1EBU9Hv3A5R37muLtuV5Vao0X63
        YciUvEDj8RGwcd9uSDpJQLd1BqAmGBBVFhihGzg=
X-Google-Smtp-Source: ABdhPJwyg39qOXnU68YZj2xjLcwFkqeriuEqjxQWoyBekFQrX+V7cPJlwwDolRE654WUJZHp16Xl3yFsJLuHp1rSPIg=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr24119361qtm.171.1593580190904;
 Tue, 30 Jun 2020 22:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200526140539.4103528-1-liuhangbin@gmail.com>
 <20200701041938.862200-1-liuhangbin@gmail.com> <20200701041938.862200-2-liuhangbin@gmail.com>
In-Reply-To: <20200701041938.862200-2-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 22:09:39 -0700
Message-ID: <CAEf4BzZmwDjWZJJiuiPWD+ByDqugVA3GQSe6OJDZdd0+zf-8JA@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 9:21 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> This patch is for xdp multicast support. In this implementation we
> add a new helper to accept two maps: forward map and exclude map.
> We will redirect the packet to all the interfaces in *forward map*, but
> exclude the interfaces that in *exclude map*.
>
> To achive this I add a new ex_map for struct bpf_redirect_info.
> in the helper I set tgt_value to NULL to make a difference with
> bpf_xdp_redirect_map()
>
> We also add a flag *BPF_F_EXCLUDE_INGRESS* incase you don't want to
> create a exclude map for each interface and just want to exclude the
> ingress interface.
>
> The general data path is kept in net/core/filter.c. The native data
> path is in kernel/bpf/devmap.c so we can use direct calls to
> get better performace.
>
> v5:
> a) Check devmap_get_next_key() return value.
> b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
> c) In function dev_map_enqueue_multi(), consume xdpf for the last
>    obj instead of the first on.
> d) Update helper description and code comments to explain that we
>    use NULL target value to distinguish multicast and unicast
>    forwarding.
> e) Update memory model, memory id and frame_sz in xdpf_clone().
>
> v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo
>
> v3: Based on Toke's suggestion, do the following update
> a) Update bpf_redirect_map_multi() description in bpf.h.
> b) Fix exclude_ifindex checking order in dev_in_exclude_map().
> c) Fix one more xdpf clone in dev_map_enqueue_multi().
> d) Go find next one in dev_map_enqueue_multi() if the interface is not
>    able to forward instead of abort the whole loop.
> e) Remove READ_ONCE/WRITE_ONCE for ex_map.
>
> v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
> include/exclude maps directly.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/bpf.h            |  20 +++++
>  include/linux/filter.h         |   1 +
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  25 +++++-
>  kernel/bpf/devmap.c            | 154 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          |   6 ++
>  net/core/filter.c              | 109 +++++++++++++++++++++--
>  net/core/xdp.c                 |  29 +++++++
>  tools/include/uapi/linux/bpf.h |  25 +++++-
>  9 files changed, 363 insertions(+), 7 deletions(-)
>

[...]

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 0cb8ec948816..d7de6c0b32e4 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3285,6 +3285,23 @@ union bpf_attr {
>   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
>   *     Return
>   *             *sk* if casting is valid, or NULL otherwise.
> + *
> + * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)

We've recently converted all return types for helpers from int to
long, please update accordingly. Thanks.

[...]
