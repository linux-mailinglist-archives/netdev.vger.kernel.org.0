Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA8241CD9D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346810AbhI2Uwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346776AbhI2Uwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 16:52:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EFFC06161C;
        Wed, 29 Sep 2021 13:51:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x8so2387426plv.8;
        Wed, 29 Sep 2021 13:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BoiIwPGlmB+GI+ljM6X3206faXHD3JRHXYQbXhb7vic=;
        b=fj70wDysjSxfYIARyPtKORSQCRSxDiq50TIsPVrvAFtxBHB9OmQEZkipDYrkaGNhQF
         mnLYvajf52becBYxnhU2yCaCTPCQCAkEmiGeovJMo/CFc0akSgncvOctbv+7msyhNong
         E5DpCqX97Jq2MHrgCMbqu2bQ79WjCD6OcUaMzOZCX5A4Dhjv49SdIPEFp8TllTJt8Ti4
         i63RboSoLseoX0rMIsqkhEjD81yAbEuhd0KF8kSaFXzi52OBTDJQu8xalKn9+rzwHR1b
         CC2DxrSfaUSTi/zH5Lb3gbF4GApY3BPMTxXsfrDKA81l5XWZj/1xV2sGa8GgHg9uZgbv
         quOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BoiIwPGlmB+GI+ljM6X3206faXHD3JRHXYQbXhb7vic=;
        b=T+2lIjfE4dPANHLWv5l+JjVY+5O7zDxqRtAjeE+n4TuEEDnTJV2x4hYYlDKm8q03BH
         qk1zks36dqri5HB3g87OZScOxii6TcS45TxhAVg5SikzbIqO+Wv5QeDhORN8o+/aCPi3
         68D1UBEzppcVvKiSZBjK2D3BoTIJ7tP/yDSuLkr7v9WhQ1712ltmnAmiQ9awGVv4ugOP
         8GQCOrUB3oQ2qdZwsKFm/5ykyRYWcvISB63OXsRIa6twrNpdGnJa+VYmvFu5DDPAoxSh
         HHKZAt185hzPkZqgvsnXZ0dziuyt3VjArB5UqoHwuDeW8aFo5m0y3m9M41KHJMTv+h0b
         I1NQ==
X-Gm-Message-State: AOAM530Hf0V6Ad6Rgwt8aossgdAGu09yWfbmY7oL6xmf4rAJa+5lACNL
        8KQFDv6eUgw8J+jeNRUUPdwAdPYuI3DAIXtiCH0=
X-Google-Smtp-Source: ABdhPJytBLgObAivspTM44bl5d0f1bbY/VEvRYdRda6R9n+4SonlspblOYW0zOcXYdzNzelzbopgpUnUE4Ha9zD1uJA=
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr2095181pjh.62.1632948665222;
 Wed, 29 Sep 2021 13:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210927145941.1383001-1-memxor@gmail.com> <20210927145941.1383001-9-memxor@gmail.com>
In-Reply-To: <20210927145941.1383001-9-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 13:50:54 -0700
Message-ID: <CAADnVQKnoFc=_jKNH=8-HWYuEw=FP941igh5Y1OgtQjdnoFLTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 08/12] libbpf: Make gen_loader data aligned.
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 8:00 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Align gen_loader data to 8 byte boundary to make sure union bpf_attr,
> bpf_insns and other structs are aligned.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/gen_loader.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
> index 8df718a6b142..80087b13877f 100644
> --- a/tools/lib/bpf/gen_loader.c
> +++ b/tools/lib/bpf/gen_loader.c
> @@ -5,6 +5,7 @@
>  #include <string.h>
>  #include <errno.h>
>  #include <linux/filter.h>
> +#include <sys/param.h>
>  #include "btf.h"
>  #include "bpf.h"
>  #include "libbpf.h"
> @@ -135,13 +136,17 @@ void bpf_gen__init(struct bpf_gen *gen, int log_level)
>
>  static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
>  {
> +       __u32 size8 = roundup(size, 8);
> +       __u64 zero = 0;
>         void *prev;
>
> -       if (realloc_data_buf(gen, size))
> +       if (realloc_data_buf(gen, size8))
>                 return 0;
>         prev = gen->data_cur;
>         memcpy(gen->data_cur, data, size);
>         gen->data_cur += size;
> +       memcpy(gen->data_cur, &zero, size8 - size);
> +       gen->data_cur += size8 - size;

Since we both need this patch, I pushed it to bpf-next to
simplify rebasing.
