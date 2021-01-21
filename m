Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67A2FE076
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbhAUEPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbhAUEMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:12:09 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40337C0613C1;
        Wed, 20 Jan 2021 20:11:29 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y4so818758ybn.3;
        Wed, 20 Jan 2021 20:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qu3/Zdh2BNKct5hYooah1p1b6g8ncNuNlKHamiSiivA=;
        b=g1GDQ0/2al2sF4aWAkymdbAOYl7xXJT9cS080xkUl2BLzz4WAflrgOdR9Ojm2yyihp
         +/2j5bPtR3kI6MDbS1UBXWQknA+PjJxtmtSL0IrGqd8jjbtLYqLua7bgJFLlSD/5NdSO
         ob+0I1vujlrPSvbyDDsM5YGUZkEUPmmu+eFeG4nN8H9gRtKvLlu3a314psxwaJGExRKt
         El2oKC32NDPolLz8s+n/hgAlQAsVgZv7Dn2joEGFXA648OXggdgKoOHq9N3oyK8ph/o9
         oYQl10t7H6B3aiXNX07rmuS/22JNKBdl0g35Hm00uC8tJyXIyT70jh3XfU+kvW0g0XF1
         ZOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qu3/Zdh2BNKct5hYooah1p1b6g8ncNuNlKHamiSiivA=;
        b=c4wHGn0x3aLzt/mXOFGHJFkVOo7Xz42pXlhy7uTOsoZQNiIg9u3z+T2LoJSpcD7h8d
         MTtRX21jXnsR7ygGMuXs0lTmChodWWRCriBK1v6SD2PudONPL5Yl2rqiBu9TzODzLb5E
         x+YzAwcCpQovQ6g6tXBx1VE+4SWWvICZmUpbH95Ycn6R3fhhmXcZKv866h6yyBkMnE0c
         et73H2TnHnqdv39wCR8+o2oenRqhK4mP2PFNr5cZ+Y8NpY+WwmJ9ORe0Dw+JG9GMFqTE
         8kSh0uH36gSLMDjzCWp3fYuWNHZm0W+c59BLrxiwahI9ksV/v0ZqoYVTXdIqAMrqQBfI
         jwvg==
X-Gm-Message-State: AOAM533hRfHNo2+XYl5pqEl91qEuAlcRWNp9aJ8N5eCQBoWQQVVQuECI
        KhuXVv4vb2FA49o5AJwvXQ5hCsXDPPcgIMlVjnc=
X-Google-Smtp-Source: ABdhPJyxFuBO0yyPvtF2m38+Pza5hBaaFi/2NaRzY0gNKkmdle6tpnDcpYQwquLeBzDnAk+uYOMOqOY7XTzGP2g34QQ=
X-Received: by 2002:a25:854a:: with SMTP id f10mr16748389ybn.510.1611202288424;
 Wed, 20 Jan 2021 20:11:28 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com> <1610921764-7526-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1610921764-7526-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Jan 2021 20:11:17 -0800
Message-ID: <CAEf4BzYvPiWnJYfVjg5qXaefYOsR1QHHzMfB6XFUSVeOA9W8Rg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] libbpf: add btf_has_size() and btf_int() inlines
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 2:22 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> BTF type data dumping will use them in later patches, and they
> are useful generally when handling BTF data.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 1237bcd..0c48f2e 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -294,6 +294,20 @@ static inline bool btf_is_datasec(const struct btf_type *t)
>         return btf_kind(t) == BTF_KIND_DATASEC;
>  }
>
> +static inline bool btf_has_size(const struct btf_type *t)
> +{
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_INT:
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +       case BTF_KIND_ENUM:
> +       case BTF_KIND_DATASEC:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}

it's not clear what "has_size" means, actually. E.g., array type
definitely has size, it's not just as readily available. And you are
actually misusing this in your algorithm, I'll point it out in the
respective patch. Please remove this, or if absolutely necessary move
into btf_dump.c as an inner static function.

> +
>  static inline __u8 btf_int_encoding(const struct btf_type *t)
>  {
>         return BTF_INT_ENCODING(*(__u32 *)(t + 1));
> @@ -309,6 +323,11 @@ static inline __u8 btf_int_bits(const struct btf_type *t)
>         return BTF_INT_BITS(*(__u32 *)(t + 1));
>  }
>
> +static inline __u32 btf_int(const struct btf_type *t)
> +{
> +       return *(__u32 *)(t + 1);
> +}
> +

there is btf_int_encoding(), btf_ind_offset() and btf_int_bits() that
properly decompose what btf_int() above returns. I'm not convinced
btf_int() has to be exposed as a public API.

>  static inline struct btf_array *btf_array(const struct btf_type *t)
>  {
>         return (struct btf_array *)(t + 1);
> --
> 1.8.3.1
>
