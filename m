Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75D013B2B5
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgANTH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:07:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34042 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgANTH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:07:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id j9so13241463qkk.1;
        Tue, 14 Jan 2020 11:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KywcGYQBkVB4bCsYUmibfnbDV3DyYwAuKAHGhay72eM=;
        b=hThFgLfWMQHuL8iBdMJqJbijRr0KuIeO7ZYW1iiSupaYwL0H9afGrhX8tFdq9eOqRV
         b3UZ3ypQxMbe8Y6JoKDge4EOof36L3m2cKPL+w126l8WW4X310+r11iKvMazTaVI15Sw
         8SjNdKTiZWkc2I6Jj3doMAp19ytlKs/qegI76D1IMTSbLzQPIk9oTCk1jSHwA88k0jU8
         KiVUltdyuv7QVOSK2OkIYx/5SCzf0l/5oURXFUZyFvo2OeL4NrGKr+mo9hTl0Tm196AE
         qr5JqwNuAuo703qaO7afl9u9XICc+SdNG7JaWMYYQGepPffRLz/djJAg8MLWsxAofilI
         278g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KywcGYQBkVB4bCsYUmibfnbDV3DyYwAuKAHGhay72eM=;
        b=EPq9kzyAKDU5JvzM/PVKA4EgO7vmgXZuZx2yaMfJMA/ObBcYNA3lmdUwa0BNcYnw7i
         nNASgCJrIHPw73+KZFMcsAnytEErUBrwI0Lr56SeHdJtRmUBNfdqxL4ulfdsiuwt3gCk
         6xOtBF0KfT/kxCCh6Ox4VeykynGJ2orWnrzaPlXPRlDDY1iWTNffAeM+35vgMxxTM4c/
         RHmwBmsp1HUM433DReATWZ73GJGrnJXEhJZQk5Hncup7MmPHaFdmASyVemhwrEgOz793
         mxthrNnJfLAB2cfqfe8MplRbhtW3B4eEYWeoh479826mrWlgtZOwH4+/zdlEG/UOWFJt
         6bAA==
X-Gm-Message-State: APjAAAUYEOWWMTt80syzKDSKePWDe0PgK2eLK58IK3f1eHfvZCH0W75s
        XbOAjcMCC0AmxYt1pUwrG2o8x0xAtLvk9GkTaq4=
X-Google-Smtp-Source: APXvYqxB0TVzILGo/cuSe31sPbEd5gBKIz0oiSnjuXTstxXgiCoDyhcVlSn6i7ISxOtnexzGt5KT+D7ubjsI4IEc21I=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr7062200qkg.92.1579028846373;
 Tue, 14 Jan 2020 11:07:26 -0800 (PST)
MIME-Version: 1.0
References: <20200114164250.922192-1-toke@redhat.com>
In-Reply-To: <20200114164250.922192-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 11:07:15 -0800
Message-ID: <CAEf4Bzb9sTF4BWA1wyWM-3jsMUnbwYi1XtkDj8ZXdyHk7C4_mQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix include of bpf_helpers.h when libbpf
 is installed on system
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 8:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The change to use angled includes for bpf_helper_defs.h breaks compilatio=
n
> against libbpf when it is installed in the include path, since the file i=
s
> installed in the bpf/ subdirectory of $INCLUDE_PATH. Fix this by adding t=
he
> bpf/ prefix to the #include directive.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> Not actually sure this fix works for all the cases you originally tried t=
o

This does break selftests/bpf. Have you tried building selftests, does
it work for you? We need to fix selftests simultaneously with this
change.

> fix with the referred commit; please check. Also, could we please stop br=
eaking
> libbpf builds? :)

Which libbpf build is failing right now? Both github and in-kernel
libbpf builds are fine. You must be referring to something else. What
exactly?

>
>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 050bb7bf5be6..fa43d649e7a2 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -2,7 +2,7 @@
>  #ifndef __BPF_HELPERS__
>  #define __BPF_HELPERS__
>
> -#include <bpf_helper_defs.h>
> +#include <bpf/bpf_helper_defs.h>
>
>  #define __uint(name, val) int (*name)[val]
>  #define __type(name, val) typeof(val) *name
> --
> 2.24.1
>
