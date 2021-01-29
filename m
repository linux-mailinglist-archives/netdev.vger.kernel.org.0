Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F70308566
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhA2F6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhA2F6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 00:58:51 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B936C061573;
        Thu, 28 Jan 2021 21:58:11 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b21so5934741pgk.7;
        Thu, 28 Jan 2021 21:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsHed3ut7U79Mgn47q8Y22uRCmTVaBBVZk8xxt6wB7g=;
        b=RWCGQbWnK8Yz01uebviscoaJ4CNVzqQlNGaRymHiZ1JN3CJIETrdQTvDk3Oo6VAvKy
         weg+sl5/Wz8Skw7dE+c3BPi1BsalqaZo7So9bosy9CZhUuoQcd583qfYQX1GiMPaVPpE
         74fYfwINU0pqWS0PGgqk4u8/Ml4gGku6+OQvbKHe4pG7+a406UF6cHZ2cK8LXJKKMxbM
         0tIYAYKcpcw8LMferlthCH8T1VBifwcU/2PEy6Pc/Dz7U09sUKrVK5BfNGh7XSrcOwHe
         kS6a1VGPCnmmz7srx7LEDJnpiekkx7yDwj8AS6x620VMzmuoJuoDShrYgwZXybnD21gh
         h+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsHed3ut7U79Mgn47q8Y22uRCmTVaBBVZk8xxt6wB7g=;
        b=HU84234gwOpAbQCatULeTO/FllbJSFlIYm1UMDsmU06YjMN6vaMCrs5dpgf0vUYX7a
         ao/0AHVldQ0aINhRLQEadOyRK9xlaNWNm+sn1FNLh5ne+fnhJJdr3vbAk3KVGu0PGE8N
         rVM+gZJKGobWZqkuj4JROnElbPJPLSEPETI//GKm8K+PAz6Rci59aDQO1LwPLHrGmGKR
         cmqWjwo2WfQ8Mr0PlOeUC91S/EopCLdM7jFvZjrbxD9Ss9736BdG7RFe8AC2wQaRd6Wb
         jCnBvAYv55MxpZ7mrVD05aU9ZXiRy6QCnPsWmh40CMnpGOJRG+ld5BeNP8hhHA9cQn/2
         u0pA==
X-Gm-Message-State: AOAM530srRVt9OW+H9hthIf2pvIBxWMuPcbkFwVTfk7SUE4qAlaMnw5r
        7qO0i5zT82sVuWsRsedDE499GypJ3x946emz4vE=
X-Google-Smtp-Source: ABdhPJyfCIWSukCmMCrzd0CvBl6NiWm8Os+WaY16xuqIBiztRiWQbcJ3EWSt0n4NduNjfOzGM2kVVbgd3IxjIpMs4LA=
X-Received: by 2002:a62:ac18:0:b029:1c0:4398:33b5 with SMTP id
 v24-20020a62ac180000b02901c0439833b5mr2976760pfe.10.1611899890140; Thu, 28
 Jan 2021 21:58:10 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
 <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com> <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 28 Jan 2021 21:57:59 -0800
Message-ID: <CAM_iQpU5XSgOjdkKbj01p+-QZ5vUof9eZTWR8c0O_cHkHXVkwg@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 6:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> I meant it would look like:
>
> noinline per_elem_callback(map, key, value, ...)
> {
>   if (value->foo > ...)
>     bpf_delete_map_elem(map, key);
> }
>
> noinline timer_callback(timer, ctx)
> {
>   map = ctx->map;
>   bpf_for_each_map_elem(map, per_elem_callback, ...);
> }
>
> int main_bpf_prog(skb)
> {
>   bpf_timer_setup(my_timer, timer_callback, ...);
>   bpf_mod_timer(my_timer, HZ);
> }
>
> The bpf_for_each_map_elem() work is already in progress. Expect patches to hit
> mailing list soon.

We don't want a per-element timer, we want a per-map timer but that
requires a way to iterate the whole map. If you or other can provide
bpf_for_each_map_elem(), we can certainly build our timeout map
on top of it.

> If you can work on patches for bpf_timer_*() it would be awesome.

Yeah, I will work on this, not only for timeout map, but also possibly for
the ebpf qdisc I plan to add soon.

Thanks.
