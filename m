Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0E26238E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgIHXYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIHXYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:24:38 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8FCC061573;
        Tue,  8 Sep 2020 16:24:37 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x10so534214ybj.13;
        Tue, 08 Sep 2020 16:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYVhovqs2j3KoA4gmhQq+5OptjVoJrHHS0XWbOyxGCc=;
        b=tEpfTrc+ty8RUU8NDitrBu0EmiVv9VDw/35KowfWS/DwVr2cX2wt7NwJLdTN8HLw7/
         ucoCALkuuHxElquHx9kv/fx4rvaqVo19yM3CebYTF8QzMT+QUc3AYEJza5n4gy5k8J9P
         x/PWTZWbzfU2GvV96PW6SVIkpvj99FOq/64rHhQL/MeQf3BsXkwkqYl4gvVj2xWsXuu7
         EbE5YlZuuabnXsdu4vEYitbSIf96lKfCKVpOGQnWUnkD2WrcfqXHRluMERtnOc2yiGmT
         s/MbnFXCyH2MqPMdMzNbqjHZLMnqJFDk4PWQS5UCM/d4tvZ1KyxXPM+2Hw5IygK7CF8X
         37Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYVhovqs2j3KoA4gmhQq+5OptjVoJrHHS0XWbOyxGCc=;
        b=Y1ujONOhV1MUKU48i3eMYN3jiMMygEE4GJhfzo45g35upGiSDNueVvEdyVzZ15ct9j
         sBYiVYoqibY9ZZZ9NvkDQx0Qx9Iot95MqFnmkz8e6my9UY2pUSgdqRDUR8W3K4+IlQA3
         LLgyHIB9LQO68hDOewc66v3uigFQqPqY4LAsLk3hE00LqjG/m1gWcN3Rgrg2A4A5XIlw
         Vh4JmfJDpyIOKRwRneiDS/Xstx7NeJZjudMPTVR45KQxNNP/zNc15gspvN4MkvhhLOpJ
         xV7BOU4sm9q0YdX1z0G+iomFl3umEOf/HdK6SS9K33aO5J183AaQwaP/MZ+cfq84pp1g
         OYpA==
X-Gm-Message-State: AOAM530efzTU2tb0F4UVpZIUrbU2hnC4AiiqmjyNHojhhK5mW4ZWOaTh
        mvGeWNXS62Q3y5TW/EgzmLGG4NRun3ea7Gm9MBfx7saV
X-Google-Smtp-Source: ABdhPJygsGJhQUDXh7pikpKR2SLK+zH4iLYyUljjsRRD1kLZ0P3OfC9Ua6h44FzidajC+SOdhKOS1FI+8Qirw0SMmJg=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr1763333ybm.230.1599607476570;
 Tue, 08 Sep 2020 16:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200905154137.24800-1-danieltimlee@gmail.com>
In-Reply-To: <20200905154137.24800-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 16:24:25 -0700
Message-ID: <CAEf4BzZ+tGgeqpPiKmChRYQ7FH==3AHXUK5V+Sy2tjZiO58u+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: refactor xdp_sample_pkts_kern with
 BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 8:41 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Most of the samples were converted to use the new BTF-defined MAP as
> they moved to libbbpf, but some of the samples were missing.
>
> Instead of using the previous BPF MAP definition, this commit refactors
> xdp_sample_pkts_kern MAP definition with the new BTF-defined MAP format.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/xdp_sample_pkts_kern.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
> index 33377289e2a8..b15172b7d455 100644
> --- a/samples/bpf/xdp_sample_pkts_kern.c
> +++ b/samples/bpf/xdp_sample_pkts_kern.c
> @@ -7,12 +7,12 @@
>  #define SAMPLE_SIZE 64ul
>  #define MAX_CPUS 128
>
> -struct bpf_map_def SEC("maps") my_map = {
> -       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(u32),
> -       .max_entries = MAX_CPUS,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(u32));
> +       __uint(max_entries, MAX_CPUS);

if you drop max_entries property, libbpf will set it to the maximum
configured number of CPUs on the host, which is what you probably
want. Do you might sending v2 without MAX_CPUS (check if macro is
still used anywhere else). Thanks!

> +} my_map SEC(".maps");
>
>  SEC("xdp_sample")
>  int xdp_sample_prog(struct xdp_md *ctx)
> --
> 2.25.1
>
