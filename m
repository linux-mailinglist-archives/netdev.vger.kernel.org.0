Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F01211B0E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgGBE0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGBE0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:26:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E7C08C5C1;
        Wed,  1 Jul 2020 21:26:03 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j10so20261642qtq.11;
        Wed, 01 Jul 2020 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PaY40v1MJNPlf27pHh51B9hv4Zqb30lQdG8/nYOAwRE=;
        b=JViK+uY6kyqL83sprf9gSzle9bJ94OMWuE82MP/X0QJR2iX+GSEjf7auW87VeMrDIV
         4LoUWVqZd0pgnA1r35pKcgJWmNC20jMaR5Kzg8sCYhXP8sj19ymE7EaW1iPEES+CZ9aj
         cMxyEAEN839HrolhbQ39QwvCwtI4ZPx5DLHGxPJxe7ZFb03tWHxBraPTZ1FkMaiVmB6T
         +BcxOqU8UbVeQbdynNFUZ8lywAV88F1Lr3X2nWoPpAcY5l7RNOeWq8acLjGaUcFy1HxM
         GaYtqh7XY4JTxLD8zXcVugNcThWB3jZ98JFyrCAKUx1B0IUss9un6TQl87Cm7THWvcPU
         ZJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PaY40v1MJNPlf27pHh51B9hv4Zqb30lQdG8/nYOAwRE=;
        b=JPh5+2ZShdYfiLspFCuy3My3w2Ogz5zaPigBs/S+AmsqiR8hqT+rXv7FPyLbybNHan
         wcyrRUWiKVu3iYLkJrx90t740yM9/igrHGOPtiYPB2uhongsKRlLH7vnvwxOPl/50l57
         QuU0LD0YSTqnt8Nc/LDxKkGPgD1Y4KbKsRKw5czEDTWgV3HLMYhcZdQSsgUaXS0G9S2T
         TBoYvgsHMbHykprgpJ2hP5NQT3OSAbZQUBJAz+osG4tyKIv2byZbsGJdQoq1nYmhYFAz
         5im9XajfgzTuuQh2WdyRXxS6OHHvXbLnkzgLjYJ8woQlxlf3RO+fD0I6l6dcWmyvndLI
         xHuQ==
X-Gm-Message-State: AOAM533pFNjfvN5i7+QrqlLX9WeLDMPBipSLnem+2kYsUW2+W/YitjLZ
        sTS/FzJbXC0GXkAcSjJ+d0Kur3gd9IkzwtvZP4Q=
X-Google-Smtp-Source: ABdhPJzz/VJ2C8tzZ8zm+gpsj2fJ+Um8f6F9IyDdYN7OVCp0vUW1jeyrtMJ/mWR1mh+AzQzljqIZD6pZ2nfIcKvP+24=
X-Received: by 2002:ac8:345c:: with SMTP id v28mr312976qtb.171.1593663962416;
 Wed, 01 Jul 2020 21:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com> <20200702021646.90347-3-danieltimlee@gmail.com>
In-Reply-To: <20200702021646.90347-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 21:25:51 -0700
Message-ID: <CAEf4BzbtsHdRWWu__ri17e8PMRW-RcNc1g3okH8+U9RW=BVdig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] samples: bpf: refactor BPF map in map test
 with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 7:17 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> support"), a way to define internal map in BTF-defined map has been
> added.
>
> Instead of using previous 'inner_map_idx' definition, the structure to
> be used for the inner map can be directly defined using array directive.
>
>     __array(values, struct inner_map)
>
> This commit refactors map in map test program with libbpf by explicitly
> defining inner map with BTF-defined format.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile               |  2 +-
>  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
>  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
>  3 files changed, 91 insertions(+), 49 deletions(-)
>

[...]

> -       if (load_bpf_file(filename)) {
> -               printf("%s", bpf_log_buf);
> -               return 1;
> +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> +       if (libbpf_get_error(prog)) {

still wrong, just `if (!prog)`

> +               printf("finding a prog in obj file failed\n");
> +               goto cleanup;
> +       }
> +

[...]
