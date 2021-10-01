Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D431A41F6B6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhJAVQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhJAVQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 17:16:51 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7CCC061775;
        Fri,  1 Oct 2021 14:15:06 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id u32so23212605ybd.9;
        Fri, 01 Oct 2021 14:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeEX9crarKhLASXKY/bS9YaGldWqhdVJCrMtsJDrz50=;
        b=EYjnYx9BRxuywIU9VtuNTmk3F5MhvlSPNO0StKxOqQ1vrMRdOD0JM9GCWQpyB8E5SJ
         6EmMh3WcyhvyumWTrVulm1xB9AVM7+G+YAO3IWMBYpyb6tVFie8JgVUQqRWRXNtypQxF
         yLJJvUwebTwCSCVWc7GIvR+FLf+VSslzR7PN3TyHsq216Xfsf6D73J1rQMbG0fGPZvYc
         aIdaYdDou8trKkBrUzYQOUyb1S0nNHutKpeYBopi1dZQ/9P407MNe0fCFiBZk2srLR1z
         DrNBXvwblhBpVKJFqqhbyzr+hk1CtIPS7kPkHvJ2Ymwyv/I/xlRVhwphBvPtEndSy0Nl
         ORjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeEX9crarKhLASXKY/bS9YaGldWqhdVJCrMtsJDrz50=;
        b=TwI/Mx4oewlVBVTPBE46HK46Cy60dvCzfTatpgiESQS9rDGAqiL6A/iolW/bKBNHb1
         nu+pLaSeZIT8iOUk8rin1q5OekKzOH0hw89++FPgiDibT+Wu7IWuEQkiGKEp6UghB353
         TDGwgH6Dz8CIvIJrbOxEtJisSNqbPuotnMxl5wQGcVaReYhXWQpro2cd6ezS9r7GnlWf
         oxXIOBPstkl/8QSCkpvz51ZkrAOfkLUPNzPgDfpFWnfSaLK0yf4xxNrMmLw3FdjQnhEz
         Mr6oubCgPJxkzKyQN8LnJ8BP9lDRdWKngrH9dOM8kjul49qvlK3HuMCkMXYKzsnG7zvM
         EISQ==
X-Gm-Message-State: AOAM533P4mXSlyXdoyfjkS3EecgqDZxvzidTcMd7OhzJlDd2b+3NiNld
        lGBelyIWZPhRNw+gDnA3n4Unf3tTkjAKuh748JU=
X-Google-Smtp-Source: ABdhPJybEGpcTJ+mtqVjkTzBOkpWRi7TpB2rg81rqHEA64JP3u9VtZmfd7gWIfcAdHJyUsdUhepkP2HCQdzOsda6Rik=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr60675ybj.504.1633122905980;
 Fri, 01 Oct 2021 14:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210930062948.1843919-1-memxor@gmail.com> <20210930062948.1843919-6-memxor@gmail.com>
In-Reply-To: <20210930062948.1843919-6-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 14:14:54 -0700
Message-ID: <CAEf4BzY-mLZS6VgoA=AOHji9ULp1a03LgAXThhLEpqMLv3HLCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/9] bpf: Enable TCP congestion control kfunc
 from modules
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:30 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commit moves BTF ID lookup into the newly added registration
> helper, in a way that the bbr, cubic, and dctcp implementation set up
> their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
> dependent on modules are looked up from the wrapper function.
>
> This lifts the restriction for them to be compiled as built in objects,
> and can be loaded as modules if required. Also modify Makefile.modfinal
> to call resolve_btfids for each module.
>
> Note that since kernel kfunc_ids never overlap with module kfunc_ids, we
> only match the owner for module btf id sets.
>
> See following commits for background on use of:
>
>  CONFIG_X86 ifdef:
>  569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)
>
>  CONFIG_DYNAMIC_FTRACE ifdef:
>  7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h       |  4 ++++
>  kernel/bpf/btf.c          |  3 +++
>  net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
>  net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
>  net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
>  net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
>  scripts/Makefile.modfinal |  1 +
>  7 files changed, 88 insertions(+), 34 deletions(-)
>

[...]

>  BTF_SET_END(bpf_tcp_ca_kfunc_ids)
>
>  static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
>  {
> -       return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
> +       if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
> +               return true;
> +       return __bpf_tcp_ca_check_kfunc_call(kfunc_btf_id, owner);

so here, why it can't be generic

__bpf_check_kfunc_call(&bpf_tcp_ca_kfunc_list, kfunc_btf_id, owner);

?

>  }
>
>  static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {

[...]
