Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0FDCE978
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfJGQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:41:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44448 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGQl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:41:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id u22so13200108qkk.11;
        Mon, 07 Oct 2019 09:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zFM+RFNtTCECjgV8K/Cr+PeiGDSTRKsIBWVJSjS360=;
        b=MmgnAPioAY9ape0ZaHhj5zu875L3f2UXUYoiIxmVCQwV/Gc61x12xfZPLnghjAdfB4
         xVu7TyMFJDugBMovFjwIUBiEjBtcS2YlTFMnPApajSZBX2olSPylpRM0a7fZE/tT4s95
         avYjnYGwacIk8tbsVqB56fWtNqV/n4W1H/i1JpprPSEqKxauSQQGzjkVNQh6Ba56tfq/
         VHHh+WrisL8G9FvrjAEIAat3fqTCE8n9yTSjCpYoq+SuKwcWjVF6/hMT92J0U3KfR+Ux
         ICA8RI/1+ysf803Y+IEUz+kqTivK1njyq85R6myZcrXl4+aXe5BFOWzVT6e0P3Nr02ni
         4+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zFM+RFNtTCECjgV8K/Cr+PeiGDSTRKsIBWVJSjS360=;
        b=BekZAxijG2KgUWlVSZABSyh14ky+mqYv3jpRb8+WeTlgJY94p8C7fkPvHqMLpBJcWq
         2cz/T2GcCNolCdLtut5ouGjE/0vWmzmKYNMMiYjw/u9Rj6P8Cx+jkyinKEzmT6AIbbz3
         lkYZnw3hqcnODJEr2nQatFHyr1AhI7mP6ap/VEFjgVSkBCpftVA38enGHMJDiK38xuXI
         3VYrHjQUgij5cbXORA7D9rJDMcOOndUqPx5HIBHz6SLzwZW/VPXaGOqAe0F0JD+uuoRy
         00USKheEDPudntAsw4JupUl09qVwWfqt5xyz4UbcDvzlnknIuJGrzsOip3L3Y+kY7Qjm
         EDfA==
X-Gm-Message-State: APjAAAUq9wjQyAWBnqaeLN478eUQ8TQAaEQCbV1vJMoB0d9ECZzilPui
        YeqjaVH0DYoXT11R0bCf7k2K5YxiUDEPd1x++TI=
X-Google-Smtp-Source: APXvYqyW+IiOcuC6GaL9m/1PxjErtVkC/h151rg8wZQoN2lax4niQ46WhIsjKCJq6MVZvUFFkTp0gl906IG5qlG3GGM=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr24065310qkk.39.1570466515979;
 Mon, 07 Oct 2019 09:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191007160635.1021-1-danieltimlee@gmail.com>
In-Reply-To: <20191007160635.1021-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 09:41:44 -0700
Message-ID: <CAEf4BzYV68OubcBFZWpMvkKsHhzb3uuMQ7HcMUgYgqigog4q0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 9:06 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> to 600. To make this size flexible, static global variable
> 'max_pcktsz' is added.
>
> By updating new packet size from the user space, xdp_adjust_tail_kern.o
> will use this value as a new max packet size.
>
> This static global variable can be accesible from .data section with
> bpf_object__find_map* from user space, since it is considered as
> internal map (accessible with .bss/.data/.rodata suffix).
>
> If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> will be 600 as a default.
>
> Changed the way to test prog_fd, map_fd from '!= 0' to '< 0',
> since fd could be 0 when stdin is closed.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
> Changes in v6:
>     - Remove redundant error message
> Changes in v5:
>     - Change pcktsz map to static global variable
> Changes in v4:
>     - make pckt_size no less than ICMP_TOOBIG_SIZE
>     - Fix code style
> Changes in v2:
>     - Change the helper to fetch map from 'bpf_map__next' to
>     'bpf_object__find_map_fd_by_name'.


This should go into commit message, that's netdev preference.

Otherwise looks good!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
>  samples/bpf/xdp_adjust_tail_kern.c |  7 +++++--
>  samples/bpf/xdp_adjust_tail_user.c | 29 ++++++++++++++++++++---------
>  2 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> index 411fdb21f8bc..c616508befb9 100644
> --- a/samples/bpf/xdp_adjust_tail_kern.c
> +++ b/samples/bpf/xdp_adjust_tail_kern.c
> @@ -25,6 +25,9 @@
>  #define ICMP_TOOBIG_SIZE 98
>  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
>

[...]
