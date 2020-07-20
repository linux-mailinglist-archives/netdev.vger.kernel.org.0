Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD297225783
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGTGVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTGVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 02:21:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1876EC0619D2;
        Sun, 19 Jul 2020 23:21:49 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b25so12182573qto.2;
        Sun, 19 Jul 2020 23:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=unEM6mZzBiwmeXXw1zFkZp6UX4pprtiHLNJYCNVdhVo=;
        b=JJ6FLlYsknqs0cjaFkw+zN+v/a2bj0HXVs9jYEf7a8xNJRyyu1HMg2UJBxOJXZGiZf
         MSsaukJpXZ2r3u7mLykUCqDKTaXp4YvjIaW8wVUaScuBgrZXT9cT8Uoh6tEbTj742VpB
         gJ4VyCwNeQ/9MzfKxGzh/ZimeAYvZlK37j7kvljUHBh8kD542Pau3LYWp6lqtQn0rbCY
         CgwkKXGawPMI0GCpBIF5wLSvHO/IrAHZdV+ZLvPojpbVanr8VA1dEHen6szm+dbbSDRv
         mufslaPF1GqcUe7TXWIVU0MhRWbHKngdFdgO0/ZqWM/2z8IRhwyUaMvCw/c15I2qooPV
         FQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=unEM6mZzBiwmeXXw1zFkZp6UX4pprtiHLNJYCNVdhVo=;
        b=WqsRHmf2Om/zmRRvWWlWvqHNEIcS3Xr0WMHCIEltMRkHtRrLnTFatwNBHvs7M4uAat
         GmXqf5/BVZwmn5DWOpfX2mQfqlgr1SKnt2m80BsA2DRwQc1inv3UggBvFry+2iYi1PT1
         1K3QM84/L3vHhPimp4VplTT8ckHDfB3fdZWnQFLgJfks8PSgyvy1aBIkbGpPDOIVNpLu
         smB1hUkwQYoUsn+QxsWgS80oE0AhSKAvnhxb/2Ghtpao/zJm67tn5FbJhyAoLSA9Abze
         mGm5pk9GwgkT+EliBIzTAIcFooxA1xE0KGQSfcAwT2L76g/fXDtf/1EfdF5TtZGcSSgG
         AFpw==
X-Gm-Message-State: AOAM533OivI5JQuH14bRLl2485PomSXJ2Y7I3k8uEf95Wkkx7Xd6n7Y5
        mwSccKtc5YFZYYqI6YHr+bIzJR6oekQhxoAsmB0=
X-Google-Smtp-Source: ABdhPJxkZjzkAgCjsrHugDN9xC7tc46uOaXmp3/+1zlTL4vOBOHWUVi5xdvxVXOtN9uLT031KzcVHxUxiE97sLUSYmc=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr22463589qtk.117.1595226108291;
 Sun, 19 Jul 2020 23:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200720061741.1514673-1-irogers@google.com>
In-Reply-To: <20200720061741.1514673-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 19 Jul 2020 23:21:37 -0700
Message-ID: <CAEf4BzaEJOV_eUtUEr6Q=E_fzU1d=jiN_ZwFQ-6=bdF9CYOgXg@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf bpf_helpers: Use __builtin_offsetof for offsetof
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 11:18 PM Ian Rogers <irogers@google.com> wrote:
>
> The non-builtin route for offsetof has a dependency on size_t from
> stdlib.h/stdint.h that is undeclared and may break targets.
> The offsetof macro in bpf_helpers may disable the same macro in other
> headers that have a #ifdef offsetof guard. Rather than add additional
> dependencies improve the offsetof macro declared here to use the
> builtin that is available since llvm 3.7 (the first with a BPF backend).
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index a510d8ed716f..bc14db706b88 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -40,7 +40,7 @@
>   * Helper macro to manipulate data structures
>   */
>  #ifndef offsetof
> -#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
> +#define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
>  #endif
>  #ifndef container_of
>  #define container_of(ptr, type, member)                                \
> --
> 2.28.0.rc0.105.gf9edc3c819-goog
>
