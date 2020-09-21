Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36342721FC
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIULMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIULMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 07:12:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109BFC0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 04:12:42 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so14878680iow.9
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 04:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUYVwNlyQ9a2Um+ZV13wS982WbKUYf9s/Uj9Vkz9D4Q=;
        b=Yde7QrYHzVe62EUIFRpCZ9aHp9D59yHcy5MTku5aWbubs6iccWQchRNTpC1ActEaZp
         JUkAh7S0Fb/xIN8Ztex33vcUzq6zKGyfENvRvf0R6kOvDDzBeCZib5368E8VOq8KUdQN
         sct270kzvIt1aumXM+Fzts/TXFmaR1clgSEkETXuujLXzoIKy8rQFHCCN31tFH2+hU1c
         D7w/TV7Jv5qVYot3ln30OYDN+oABhIsLI0iKZKXHVdd/FpAOoyX0wmTS5t1apdgUWk30
         vHU5raPaqVSkclcZLmNx1XIK1PRHu+9JTaZ2gSXMxVmZxfKMkLgKY0U1IJABEDjQj1JZ
         jDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUYVwNlyQ9a2Um+ZV13wS982WbKUYf9s/Uj9Vkz9D4Q=;
        b=ss/Rq7lx+bs2/gsHxATr5PF/5cX/G5abrAiIr18UdLNjKUScsjNkk+ESrd+R+r5A7A
         HqjebdIekiLL9L+cg+heGUOmqpE9kXo2Sx0lidr40k2SltnAa1bRjHO1dE8HNrNvEn4h
         kJnmFSjsROScu1FBNmbVruzYm7hSXIdLWwLQPMUbUL3grO1SJkZ4yZ0j5CWMcbAlV425
         +DOBHyjP+rX3u8Y9VQX41YU+r+O26HyW9osXKxtuvN7zVPp3ni5WVPeKlfOTmU0+hdvH
         SF+1prWimiUW547vmoi+GsvO/7T3g/Zy93IMeUdszDBDpdkGdPJQ1TqVyY28Awicr2mJ
         a8gA==
X-Gm-Message-State: AOAM531PBsWovWB/z1PkN38hioaDc16mgN38vYnAkfvWRHtTaqfLVqpb
        EYv+xYZ2hj3yIsuk7zbquXcZI5FlFChcMgFoW7wuFyu82Ezp360g
X-Google-Smtp-Source: ABdhPJxnUKyKl5acoPxK8RLk1Z2jF6RegSpyqpTa+qbbpKMENKMVscvrMmrNOx8Lxm4izkMJCfZ5LRQOSSeQSUGS+js=
X-Received: by 2002:a02:a047:: with SMTP id f7mr38588064jah.31.1600686761273;
 Mon, 21 Sep 2020 04:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200917135700.649909-1-luka.oreskovic@sartura.hr> <CAPhsuW4WXqiK-AFP6nU1L03yXGLLuz845mFP8W_rhbyaw=Ck=w@mail.gmail.com>
In-Reply-To: <CAPhsuW4WXqiK-AFP6nU1L03yXGLLuz845mFP8W_rhbyaw=Ck=w@mail.gmail.com>
From:   Luka Oreskovic <luka.oreskovic@sartura.hr>
Date:   Mon, 21 Sep 2020 13:12:30 +0200
Message-ID: <CA+XBgLWBDJbCgToWPW2FkRO_AkkaE8+DMnAk55vyT+KyLZv4Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add support for other map types to bpf_map_lookup_and_delete_elem
To:     Song Liu <song@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 1:21 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Sep 17, 2020 at 7:16 AM Luka Oreskovic
> <luka.oreskovic@sartura.hr> wrote:
> >
> [...]
>
> > +++ b/kernel/bpf/syscall.c
> > @@ -1475,6 +1475,9 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
> >         if (CHECK_ATTR(BPF_MAP_LOOKUP_AND_DELETE_ELEM))
> >                 return -EINVAL;
> >
> > +       if (attr->flags & ~BPF_F_LOCK)
> > +               return -EINVAL;
> > +
>
> Please explain (in comments for commit log) the use of BPF_F_LOCK in
> the commit log,
> as it is new for BPF_MAP_LOOKUP_AND_DELETE_ELEM.
>
> >         f = fdget(ufd);
> >         map = __bpf_map_get(f);
> >         if (IS_ERR(map))
> > @@ -1485,13 +1488,19 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
> >                 goto err_put;
> >         }
> >
> > +       if ((attr->flags & BPF_F_LOCK) &&
> > +           !map_value_has_spin_lock(map)) {
> > +               err = -EINVAL;
> > +               goto err_put;
> > +       }
> > +
> >         key = __bpf_copy_key(ukey, map->key_size);
> >         if (IS_ERR(key)) {
> >                 err = PTR_ERR(key);
> >                 goto err_put;
> >         }
> >
> > -       value_size = map->value_size;
> > +       value_size = bpf_map_value_size(map);
> >
> >         err = -ENOMEM;
> >         value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> > @@ -1502,7 +1511,24 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
> >             map->map_type == BPF_MAP_TYPE_STACK) {
> >                 err = map->ops->map_pop_elem(map, value);
> >         } else {
> > -               err = -ENOTSUPP;
> > +               err = bpf_map_copy_value(map, key, value, attr->flags);
> > +               if (err)
> > +                       goto free_value;
>
> IIUC, we cannot guarantee the value returned is the same as the value we
> deleted. If this is true, I guess this may confuse the user with some
> concurrency
> bug.
>
> Thanks,
> Song
>
> [...]

Thank you very much for your review. This is my first time contributing
to the linux community, so I am very grateful for any input.

For the first point, you are correct, the commit message should
have been more detailed. As for the second point, I see the problem,
but I'm not sure how to resolve it. Maybe moving the
bpf_disable_instrumentation call could work, but I'm not sure if
that could create different problems. I'll try to find and acceptable
solution and resubmit the patch.

Best wishes,
Luka Oreskovic
