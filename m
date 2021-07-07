Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA73A3BF11E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhGGVAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhGGVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:00:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CFDC061574;
        Wed,  7 Jul 2021 13:57:59 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y38so5351016ybi.1;
        Wed, 07 Jul 2021 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1nWFHfORcbPdTsbgHYGUaQxpYC/3l7L+MYxNakAZpg=;
        b=M0cWHNpid6NNkynCPE2Cec9kLqdEdL7aKrJ0VQbCHizASblHv9ByqrwoYnlHGWQw/Z
         TfQgbCdNPSTdgeDqB+Uqwf72H7JgGuzIq/OjMxoIzQo7xXFT1M9fmpEBXltdGe5JhQjn
         aVDJYbaGnVup6vQEgNf5WXkIgh30vsqQUXg4JueHw3Yj9ZWDf68HylQ6tMvDyBItldEe
         9KJEdr2hT80lvfAzdG5Ww4RtHwpvG2Q0H862aGK8S5qTJlZ/ok0EHzMBGgO2Ltmo127r
         P/Px/JdQ98Ukemt5MHLxOmCBvabbQS4IKrhvdaLg+H1UHgVcaWrQiKU3GRVKOtOm5qmt
         yRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1nWFHfORcbPdTsbgHYGUaQxpYC/3l7L+MYxNakAZpg=;
        b=YDrIu/qiduVBToyPXMUVrWXhGT9Jr5n6j798aW7YLXPrO7TRbro0jBjdywseTgB+4Z
         9pkQkV9/gYo8zsRqges29BeIxZLFcnMjlxBxMNi8k1zz2NKXhRncSgaqW23MOsWdJUNo
         V66CEJO4MISwWFRzD5MfREagzfKYEa0HjAlRSdINz2w3ebXaujVOSujofbOh5o22/yg7
         Z0cs7+JURjBceVacr+nJ/CHuWeaaVocs0Gotrfoyymx+xTfYBiuzrF+fqirJuLFC7zuH
         AXSFpKsQrigXIkT61xGbqmEu4B96WADnMpSdslJotTlh1Z9j8ZzIbBQzsECIFcoDu7l9
         iB8g==
X-Gm-Message-State: AOAM533R2KPic7AxljvC3zaBPYLrox+xxsh2JWbKaNM3V2CqjxOnVsuE
        kk1AqsMfpEJRCFkqQpeanN1OSpM6MSs4fMCD+c0=
X-Google-Smtp-Source: ABdhPJysgjeZc92yss6nOlW6MfGYOC8wccAWm6AilKDpGGEIOIazJuAonm1eQ9+dfonueuqRwFOazrp6R/DAlaw8HSA=
X-Received: by 2002:a25:9942:: with SMTP id n2mr34880526ybo.230.1625691478671;
 Wed, 07 Jul 2021 13:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com> <8ca15bab-ec66-657d-570a-278deff0b1a3@iogearbox.net>
In-Reply-To: <8ca15bab-ec66-657d-570a-278deff0b1a3@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 13:57:47 -0700
Message-ID: <CAEf4Bzb5GvwsJ-UrxqZdqOSARirCGKZf3-a7UUAgfKvzFYKGnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Introduce 'custom_btf_path' to 'bpf_obj_open_opts'.
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Shuyi Cheng <chengshuyi@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 8:06 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/24/21 6:03 AM, Shuyi Cheng wrote:
> > In order to enable the older kernel to use the CO-RE feature, load the
> > vmlinux btf of the specified path.
> >
> > Learn from Andrii's comments in [0], add the custom_btf_path parameter
> > to bpf_obj_open_opts, you can directly use the skeleton's
> > <objname>_bpf__open_opts function to pass in the custom_btf_path
> > parameter.
> >
> > Prior to this, there was also a developer who provided a patch with
> > similar functions. It is a pity that the follow-up did not continue to
> > advance. See [1].
> >
> >       [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
> >       [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
> >
> > Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 23 ++++++++++++++++++++---
> >   tools/lib/bpf/libbpf.h |  6 +++++-
> >   2 files changed, 25 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 1e04ce7..518b19f 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -509,6 +509,8 @@ struct bpf_object {
> >       void *priv;
> >       bpf_object_clear_priv_t clear_priv;
> >
> > +     char *custom_btf_path;
> > +
>
> nit: This should rather go to the 'Parse and load BTF vmlinux if any of [...]'
> section of struct bpf_object, and for consistency, I'd keep the btf_ prefix,
> like: char *btf_custom_path
>
> >       char path[];
> >   };
> >   #define obj_elf_valid(o)    ((o)->efile.elf)
> > @@ -2679,8 +2681,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
> >       if (!force && !obj_needs_vmlinux_btf(obj))
> >               return 0;
> >
> > -     obj->btf_vmlinux = libbpf_find_kernel_btf();
> > -     err = libbpf_get_error(obj->btf_vmlinux);
> > +     if (obj->custom_btf_path) {
> > +             obj->btf_vmlinux = btf__parse(obj->custom_btf_path, NULL);
> > +             err = libbpf_get_error(obj->btf_vmlinux);
> > +             pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->custom_btf_path, err);
> > +     } else {
> > +             obj->btf_vmlinux = libbpf_find_kernel_btf();
> > +             err = libbpf_get_error(obj->btf_vmlinux);
> > +     }
>
> Couldn't we do something like (only compile-tested):

I wonder what are the benefits of this approach, though. My
expectation is that if the user specifies a custom BTF path and BTF is
missing then the whole bpf_object load process should fail, but in
this case it will be silently ignored. Also, if custom BTF is
specified, that custom BTF has to be used even if
/sys/kernel/btf/vmlinux is present, but the patch below will still
prefer /sys/kernel/btf/vmlinux.

So the semantics is different. I'm not saying it's wrong, but I think
it means we need to discuss what behavior we are after first.

>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index b46760b93bb4..5b88ce3e483c 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -4394,7 +4394,7 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
>    * Probe few well-known locations for vmlinux kernel image and try to load BTF
>    * data out of it to use for target BTF.
>    */
> -struct btf *libbpf_find_kernel_btf(void)
> +static struct btf *__libbpf_find_kernel_btf(char *btf_custom_path)
>   {
>         struct {
>                 const char *path_fmt;

[...]
