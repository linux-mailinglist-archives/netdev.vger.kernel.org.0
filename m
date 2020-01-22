Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0F145E4A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAVVx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:53:58 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33075 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVVx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:53:57 -0500
Received: by mail-qk1-f193.google.com with SMTP id h23so1406638qkh.0;
        Wed, 22 Jan 2020 13:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcZ5cwHfKJxIEyJorNMki/f4DYa3h+uxxES2FRdsLCc=;
        b=D03gR2pWQuVdPp5g6CKWrFtMK+/Odf2RqQNi+FavGJ6KeBZ1EiEbtDV70Y3qJiAR3S
         kheTuMomQWFF+rKCcxUoIkShCB3hEOFFEWULvzXq+BUAP/KM7Vi0fSVT5Jxfl/lYuhEw
         ol13onPOa7QTW4q9s3cIuXm8V1SuukIH5WpnwnCRlifaOQjCJRBzgnA9/gffXGUdlu37
         7XfmLbkad+fz5PvW5Oohqz6+nHIK+ImydZM+Oy4ZJ77zRo4JKqRi4znizw0ejV6P5/Tt
         zH6WrR7uNYjJ0UMkYiKBRj5GHVCiCB/qIlff8uBIHEmIuEY/RgIXGVtoXxFIfsSlKESg
         QDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcZ5cwHfKJxIEyJorNMki/f4DYa3h+uxxES2FRdsLCc=;
        b=YSqSPSA8X95rsxbIdKmY+zLFAOliEW8toq+NgxHGW2oWFzUpxYs/bAaAZW1KkyTCOA
         lVLm/lH4B3jj/HTpEKrVI5IghBzifZIb8gepgpdNCLAzIho3Lz4YoLk6Ck6Uz/hbBZod
         b1TcuTLaUs21Kd4zGgaiW/QCk/TkIsz9c5N0EWirZhf7gs1J2jFulaGXzVEzAqO3lzgE
         QPlARt9YyQaUtSMGQI6Cc1cV9ofK/MtgxnBA1vw9/2DegCBVE0foUchmUps715UUx5vi
         I1TvUnGkBzgJUJ+1kDJ1uma8pbnBdM6WaXNUWGDv4N3s0xVSiBUaiMjUGbxPNqPZKbs6
         qM3g==
X-Gm-Message-State: APjAAAXhRFW4JA6f4IedF/8nALH4Sg9wZgkdovTKyLWBgOsPijUke8gk
        wg9VBri/UXiezUOUt7fsyN3u3jg8oCi8LGWNOuuuTA==
X-Google-Smtp-Source: APXvYqzFA8FaPTrfJouGdQ9GdUkqUHAAmbtMBbm3oJFLu7zAJCecn+FA5zVrdHd37q7U/DUwjZM7y0fP/zfNn/TswB4=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr12901739qkj.36.1579730036756;
 Wed, 22 Jan 2020 13:53:56 -0800 (PST)
MIME-Version: 1.0
References: <20200122064152.1833564-1-kafai@fb.com> <20200122064210.1834848-1-kafai@fb.com>
In-Reply-To: <20200122064210.1834848-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Jan 2020 13:53:45 -0800
Message-ID: <CAEf4BzYU2xZkUvK-JP53jrKXnWryACHsaX4JO_trEn=1N9-k1A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] bpf: tcp: Add bpf_cubic example
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds a bpf_cubic example.  Some highlights:
> 1. CONFIG_HZ .kconfig map is used.
> 2. In bictcp_update(), calculation is changed to use usec
>    resolution (i.e. USEC_PER_JIFFY) instead of using jiffies.
>    Thus, usecs_to_jiffies() is not used in the bpf_cubic.c.
> 3. In bitctcp_update() [under tcp_friendliness], the original
>    "while (ca->ack_cnt > delta)" loop is changed to the equivalent
>    "ca->ack_cnt / delta" operation.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

just my few cents below...

[...]

>
> +static void test_cubic(void)
> +{
> +       struct bpf_cubic *cubic_skel;
> +       struct bpf_link *link;
> +
> +       cubic_skel = bpf_cubic__open_and_load();
> +       if (CHECK(!cubic_skel, "bpf_cubic__open_and_load", "failed\n"))
> +               return;
> +
> +       link = bpf_map__attach_struct_ops(cubic_skel->maps.cubic);

we should probably teach bpftool and libbpf to generate a link for
struct_ops map and also auto-attach it as part of skeleton's attach...
I'll add it if noone gets to it sooner

> +       if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\n",
> +                 PTR_ERR(link))) {
> +               bpf_cubic__destroy(cubic_skel);
> +               return;
> +       }
> +
> +       do_test("bpf_cubic");
> +
> +       bpf_link__destroy(link);
> +       bpf_cubic__destroy(cubic_skel);
> +}
> +

[...]

> +
> +extern unsigned long CONFIG_HZ __kconfig __weak;

you probably don't want __weak, if CONFIG_HZ is not defined in
Kconfig, then something wrong is going on, probably, so it's better to
error out early

> +#define HZ CONFIG_HZ
> +#define USEC_PER_MSEC  1000UL
> +#define USEC_PER_SEC   1000000UL
> +#define USEC_PER_JIFFY (USEC_PER_SEC / HZ)
> +

[...]
