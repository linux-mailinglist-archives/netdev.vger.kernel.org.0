Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207041B50DF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 01:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDVX1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgDVX1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 19:27:17 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D38C03C1AA;
        Wed, 22 Apr 2020 16:27:17 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id v10so1938863qvr.2;
        Wed, 22 Apr 2020 16:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVbRCcnlDvVHgrFtItAJpGmOMWHhJ3M/HbbsklJ+CCM=;
        b=qAGHPe2QqVwXV/xlmS6dMgtjzsGDb/3gmTOpNTsG+YTobq6CV0ixT2kvpNnB1hlojo
         1wtWQAF2bCgweWURrYN8LLaDN5UPfJq+924RTIfsrbJXnHi0xtD7gWdkqAolWlR+ZOWT
         PsbvSUVWGIYdU960Rk8H6vRHiXJETY+qdlDHxX7GH2EBZ4JYyknTzJP+Zh5Ig6qxxHU8
         DnjDDWXuynB4/nGHPeeaUjU4qVt5s8JFRaeFfKF/OpXqX/hEiYdtCjyubbts1hPfESBI
         tvMoTufHyTq+5gSw7r0Z1lCbnOZ6xnBxPeIM1sjAGtg1bdv1nRLIVKIE6zpXXLeg47Uc
         Cyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVbRCcnlDvVHgrFtItAJpGmOMWHhJ3M/HbbsklJ+CCM=;
        b=fGQAgUoRSkp2VZFkr/ykk2DjN856XORoZmcTzUoSTP1shW8lxSiYolp5lZz4cRNhXt
         ItD4Z6FenCpQzS1BOetj9eCdOIHXhN76/M8rRYpVrobtsu01XVIseKvR+5FKqf2klc1Y
         YYFVsUyBkuZcruQXo+XZS4qT0bcqYpH+uC8dXPnMDSR+Ckg5dEYi7tclH0GPLc9kx3so
         CCOjdiYvorxvPHEKKt1WX1yCh/FUWRWbfzT7Gti2ZXIfwUqkgIKYV+gx0NR4swkRyJQq
         eCd9/C2OytpGZbjzXOJTgvCyNMY2pa15o+IHFTpf6lgTGfOo6FBg3tcbDpFlvtH8HFsY
         uJsA==
X-Gm-Message-State: AGi0PuaYnJgWULHmZoZ1FxZDHN2PJomGKCFZZ2P5QjSBepSScUUbnCKR
        Twk+HQr2ExUeOlBXGrUZvcM9umj9JZZvaIRHQTc=
X-Google-Smtp-Source: APiQypIfTsL5qIMF9TRjxPp3Fr19tLsAL9y2w/qpS8ptYLmKNCvTIj7MiEM+Z4p+tsI782nffDPMmcyOEx3UkzOyBLY=
X-Received: by 2002:a0c:eb09:: with SMTP id j9mr1537405qvp.196.1587598036356;
 Wed, 22 Apr 2020 16:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200422083010.28000-1-maowenan@huawei.com> <20200422083010.28000-3-maowenan@huawei.com>
In-Reply-To: <20200422083010.28000-3-maowenan@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Apr 2020 16:27:05 -0700
Message-ID: <CAEf4BzaNZe63WxPrv0kAq-VjdoC8gOfrsmNLYBuK6nBu1Wh8kA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: Return err if bpf_object__load failed
To:     Mao Wenan <maowenan@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 1:30 AM Mao Wenan <maowenan@huawei.com> wrote:
>
> bpf_object__load() has various return code, when
> it failed to load object, it must return err instead
> of return -EINVAL.
>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---

This patch looks good. The other one in this series - not so sure..

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f480e29a6b0..8e1dc6980fac 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7006,7 +7006,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
>         err = bpf_object__load(obj);
>         if (err) {
>                 bpf_object__close(obj);
> -               return -EINVAL;
> +               return err;
>         }
>
>         *pobj = obj;
> --
> 2.20.1
>
