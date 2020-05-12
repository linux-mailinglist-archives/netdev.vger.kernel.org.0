Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919041D01C8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbgELWUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727971AbgELWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:20:07 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA4BC061A0C;
        Tue, 12 May 2020 15:20:06 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di6so7185203qvb.10;
        Tue, 12 May 2020 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eCNY+sYyp8cnHHAxm0+RTbQx/EjkeGToMjAfjaq5U/E=;
        b=r7Pyw68MI3bSUo8gpXaW8NWDQenOwKxpAWXtg/hB2W4WIOz0SdclQLGo2ESgyFU5+8
         UGeNLBPXXDBfdIYOoxoN+Ljjn2Nja5ZvSqIZSxHTEv0yeSTQW4D0u4IG5PLdEYMywjjC
         1gNIUOBpogl8vZWceWgy/kHbQpCgcjjIGQG/lNaN68NO2A6dPTpCmgVUvKXCv/9AK39N
         2/emvzS/0/vYD+JlaJwd1ahPx2zaAyk/2/uojKuNRwrZ4SwxOn5VCkQretlw76L03PDT
         4gupiciuYOxgjT95eSjwfMG5jorzj9aoRWmu6IP3gqrvWdn4QDOqHhsme2r5Q6ZPUp34
         nahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eCNY+sYyp8cnHHAxm0+RTbQx/EjkeGToMjAfjaq5U/E=;
        b=aLTw5ZGHSW2VzrIupYbptM5JU9QoFUA0+s5DGPrO3aQte3hIYKt7bS/Jy2inylbhg6
         QoHgOrHsSebUwP7WIjG4eUB3HPBhGNQZBc1qpXBnkNOxoO0bQETD+BOiYWQMzW3k/clh
         GTMlwxrDBuCiXVZFPYGKwXxgbPRKa2kUm/cTT0BlWyaaL7iRNMnlE8yOeKGJT6BKW1A1
         RIvGQp73I5IHMb6uUuRVloEgn2YO7AH/Ctk3JZx0QKvKcIvlSl1QunfFoZdJ/DecX+O/
         TOI3ZgQvRsonalzI/E4A+UPQhTuF7uwCanMAqT39X88LxG8Iu04cqsnjs1CGRlN4KyV6
         a9Dw==
X-Gm-Message-State: AGi0PubvRr7WLWng7yR3iGNEjlA8RkeREmYQGv4fdndGeuskXQ1dX2ZJ
        BzPB71LOVrdcO26LzFIWqqq+8QlNJUtHj03Wn9g=
X-Google-Smtp-Source: APiQypLeKyLIfVIn2yDJYhtyP8cUsNnyyOba6I3IVR1XRiT2Blml2LNgAcHFkvIf2pkAdz5MlekUNNZiWhvgAyMkXtk=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr22656432qva.247.1589322006110;
 Tue, 12 May 2020 15:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155237.1080552-1-yhs@fb.com>
In-Reply-To: <20200512155237.1080552-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:19:55 -0700
Message-ID: <CAEf4BzYVcZkhthJAPW6QnLWGwznWpqAhOuTJtTVLMuNs6t0Zwg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: net: refactor bpf_iter target registration
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:56 AM Yonghong Song <yhs@fb.com> wrote:
>
> Currently bpf_iter_reg_target takes parameters from target
> and allocates memory to save them. This is really not
> necessary, esp. in the future we may grow information
> passed from targets to bpf_iter manager.
>
> The patch refactors the code so target reg_info
> becomes static and bpf_iter manager can just take
> a reference to it.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/bpf_iter.c    | 29 +++++++++++------------------
>  kernel/bpf/map_iter.c    | 18 +++++++++---------
>  kernel/bpf/task_iter.c   | 30 ++++++++++++++++--------------
>  net/ipv6/route.c         | 18 +++++++++---------
>  net/netlink/af_netlink.c | 18 +++++++++---------
>  5 files changed, 54 insertions(+), 59 deletions(-)
>
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index b0c8b3bdf3b0..1d203dc7afe2 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -8,11 +8,7 @@
>
>  struct bpf_iter_target_info {
>         struct list_head list;
> -       const char *target;
> -       const struct seq_operations *seq_ops;
> -       bpf_iter_init_seq_priv_t init_seq_private;
> -       bpf_iter_fini_seq_priv_t fini_seq_private;
> -       u32 seq_priv_size;
> +       struct bpf_iter_reg *reg_info;
>         u32 btf_id;     /* cached value */
>  };
>
> @@ -224,8 +220,8 @@ static int iter_release(struct inode *inode, struct file *file)
>         iter_priv = container_of(seq->private, struct bpf_iter_priv_data,
>                                  target_private);
>
> -       if (iter_priv->tinfo->fini_seq_private)
> -               iter_priv->tinfo->fini_seq_private(seq->private);
> +       if (iter_priv->tinfo->reg_info->fini_seq_private)
> +               iter_priv->tinfo->reg_info->fini_seq_private(seq->private);
>
>         bpf_prog_put(iter_priv->prog);
>         seq->private = iter_priv;
> @@ -248,11 +244,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)

const struct bpf_iter_reg *? Can you please also add a comment that
passed struct is supposed to be static variable and live forever (so
not a dynamically allocated nor a stack variable)?

Also all the static struct bpf_iter_reg below should be marked const?

[...]
