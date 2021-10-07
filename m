Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD89425E3B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhJGU5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhJGU5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:57:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CB0C061570;
        Thu,  7 Oct 2021 13:55:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id s16so6411304pfk.0;
        Thu, 07 Oct 2021 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jS2/b+lbzWP06L31MQafqGN4NvFQGhEEw9KPUBF6vTU=;
        b=ba0Y3T1KjkRH5mo4igmdhPrYnUBo93K2nbl3U48Oq4s06JeAjaWWqqQIUG9XVFXNy3
         xqFxI63hLYFXDlLtg4kTuLJgEy6jxAuL1nQZrsvGEbBAObJNbV4PamO5sMQE9Qyo19aX
         fU1zS/9jxJH6IDSmtuqF8mWWEzSeOA/9ZPNGEP5MlpHZZ3exnoZlYdN/Va7sAM9jx4gO
         zBOKdndiM5sGfhjVF9HyGjCfq3d5scdSf53pAjfqdMlLr2xxIWQrltG4INLe0Dhaz8Is
         LVQSYkUqIWoIa9EWzvicWSHx79HvGPL2sHS+UZjjHMUb3U4KCGvo952PQlzt6RTmGByD
         Uuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jS2/b+lbzWP06L31MQafqGN4NvFQGhEEw9KPUBF6vTU=;
        b=XDkkG9ow7qiGB2Iz2bsW3wnRP5Q3U4eeXKgUzRAj54AV9jF8F3AUiwSp21QECk3u9/
         FSs5AiAxq6yB3KOUr3YY4rwMwyP0HnsusuYJHADt+H4T39qkXiPTFD5S+sI8bzW9va/K
         nDwunZik/faz1PH/e7RIC1hAN3o5WWFZFqRG8+oRm1D9UeeFR2x8ZLwa8fGWxxqWvN9y
         hqESVKJuPmX/3rKPNP6U28O5zjIPPvMHgyb5fXP63VFiyuW9OXiaNnDgqH7KhSc8LWjM
         EPt2ZKq26XoVXA5eaxiQo5BcljdRo6BR7BWuKRyHUD8K09VrFoPn9ZCR/Z9oJz6Agh/m
         fKXQ==
X-Gm-Message-State: AOAM532YmJk+ja/kr0JIFKykicrTgfpuJyxF+h1CYflCqHhNlEiB7xLV
        VOdRfhkHglmVF4d66hggbFg=
X-Google-Smtp-Source: ABdhPJzyID+dVU48WKqiH600GMBY5J8ckSNzbjGBYxKGnm4t7S+bTbRBGqbclAH5cUDrarR4LKoAgA==
X-Received: by 2002:a05:6a00:15c9:b0:44c:a998:b50d with SMTP id o9-20020a056a0015c900b0044ca998b50dmr6401320pfu.49.1633640152661;
        Thu, 07 Oct 2021 13:55:52 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j7sm288879pfh.168.2021.10.07.13.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:55:52 -0700 (PDT)
Date:   Fri, 8 Oct 2021 02:25:49 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 4/6] bpf: selftests: Move test_ksyms_weak
 test to lskel, add libbpf test
Message-ID: <20211007205549.xklfits3xkdligat@apollo.localdomain>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-5-memxor@gmail.com>
 <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com>
 <20211007204609.ygrqpx4rahfzqzly@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007204609.ygrqpx4rahfzqzly@apollo.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:16:09AM IST, Kumar Kartikeya Dwivedi wrote:
> On Fri, Oct 08, 2021 at 02:03:49AM IST, Song Liu wrote:
> > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> > > Create a file for testing libbpf skeleton as well, so that both
> > > gen_loader and libbpf get tested.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > [...]
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> > > new file mode 100644
> > > index 000000000000..b75725e28647
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> > > @@ -0,0 +1,31 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +#include <test_progs.h>
> > > +#include "test_ksyms_weak.skel.h"
> > > +
> > > +void test_ksyms_weak_libbpf(void)
> >
> > This is (almost?) the same as test_weak_syms(), right? Why do we need both?
> >
>
> One includes lskel.h (light skeleton), the other includes skel.h (libbpf
> skeleton). Trying to include both in the same file, it ends up redefining the
> same struct. I am not sure whether adding a prefix/suffix to light skeleton
> struct names is possible now, maybe through another option to bpftool in
> addition to name?

Sorry, I misremembered. The name option is enough, it is because of how I did it
in the Makefile (using LSKELS_EXTRA).  I'll fix this in the next spin.

> [...]

--
Kartikeya
