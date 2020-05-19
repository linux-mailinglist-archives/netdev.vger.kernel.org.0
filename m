Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CF01DA265
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgESUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgESUSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:18:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4EC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:18:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l21so523967eji.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lL4ozjO7sIu89/0ZdtpZ+grNZO7La5memrjZAz9fUk0=;
        b=ZByOxcWZEGVSx0wUUQIKY6Lw/heX5sMkMCAxTHHPK+6ioi6FiW5Ivw4Z7T0/Nsu58c
         KBdpFSMR5DZ9/Fan6TguF2CqRqBB1RiOHXF7adO0G8p+vAKeUpTqfShVLpqLUMDmSLi1
         EQ9HfNNyPLSZop4afoNbYFWcjitqlo7fgxaKoCCTWTuiFmdSvBW7XY0iiFNWqgGj7KRs
         TC/MqL75oZY1jUN8E7jzoZ3x0UqfnmePmTE/KV1JCoRkX+RpHBWDUXURu+joTefkXso/
         Zzj2NcqozV3LUz+vL8gbiGipZCgL0mKs7ynTlmNA5D2yFrKQ+OioPOkKCO8FSJo0vylo
         /yNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lL4ozjO7sIu89/0ZdtpZ+grNZO7La5memrjZAz9fUk0=;
        b=lLxttvJ7zdSxPFXAFTeWDaQsX5y8eOepqjaduDl87B78/OYLgWhu+MO6Zyuqw1sUQQ
         cOrcYa9X5N+K43fCH3+2pEK46MwhaCqmIpcBoMvJTS1j18PEzES0DDadW6C/1Kz3wdgb
         r7zDwUKenLWfqdsGLGh22dcnuaQQhePswXBuOPHfnUn1wCMQn4R8gvLvPxmoFzxz9cvG
         1QnCFjYEz4A3r9pZKmUYT/E6BMBolth4UEKwGiFMRScuMlHtbjD2pPQpp0whm873DQSc
         bwM1pjjQLI3MQ8t4krM8JbOw60wju5UmhZ9SuNjwoM5ly3xXjT6nDMSUn1LixrHQUt8O
         ahaA==
X-Gm-Message-State: AOAM530V7z/ZesTtTtt6lT2J9Zm/7PXxjJFFrJYF4LdvBO5p0IQJKbGz
        /bc62GFno8O0FKIOxBDduInIlJiU8/WBh0xg3vawcw==
X-Google-Smtp-Source: ABdhPJzmLJ2VE1XY5jhp3oLT94K798EgEIL11S0+1hP87wWAtRinPfX07mNjAjt65tc4uEKH4OGuafZh3NS7Q2bYA/g=
X-Received: by 2002:a17:906:934d:: with SMTP id p13mr869611ejw.452.1589919522687;
 Tue, 19 May 2020 13:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
 <CAG=TAF5rYmMXBcxno0pPxVZdcyz=ik-enh03E-V8wupjDS0K5g@mail.gmail.com> <CAEf4BzYZ9LkYtmiukToJDw1-V-AFbwfB2jysMU9mM3ie9=qWHw@mail.gmail.com>
In-Reply-To: <CAEf4BzYZ9LkYtmiukToJDw1-V-AFbwfB2jysMU9mM3ie9=qWHw@mail.gmail.com>
From:   Qian Cai <cai@lca.pw>
Date:   Tue, 19 May 2020 16:18:31 -0400
Message-ID: <CAG=TAF45T4pKew6U2kPNBK0qSAjgoECAX81obmKmFnv0cjE-oA@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 3:30 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 19, 2020 at 8:00 AM Qian Cai <cai@lca.pw> wrote:
> >
> > On Mon, May 18, 2020 at 8:25 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
> > > >
> > > > On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> > > > > >
> > > > > > With Clang 9.0.1,
> > > > > >
> > > > > > return array->value + array->elem_size * (index & array->index_mask);
> > > > > >
> > > > > > but array->value is,
> > > > > >
> > > > > > char value[0] __aligned(8);
> > > > >
> > > > > This, and ptrs and pptrs, should be flexible arrays. But they are in a
> > > > > union, and unions don't support flexible arrays. Putting each of them
> > > > > into anonymous struct field also doesn't work:
> > > > >
> > > > > /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> > > > > array member in a struct with no named members
> > > > >    struct { void *ptrs[] __aligned(8); };
> > > > >
> > > > > So it probably has to stay this way. Is there a way to silence UBSAN
> > > > > for this particular case?
> > > >
> > > > I am not aware of any way to disable a particular function in UBSAN
> > > > except for the whole file in kernel/bpf/Makefile,
> > > >
> > > > UBSAN_SANITIZE_arraymap.o := n
> > > >
> > > > If there is no better way to do it, I'll send a patch for it.
> > >
> > >
> > > That's probably going to be too drastic, we still would want to
> > > validate the rest of arraymap.c code, probably. Not sure, maybe
> > > someone else has better ideas.
> >
> > This works although it might makes sense to create a pair of
> > ubsan_disable_current()/ubsan_enable_current() for it.
> >
> > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > index 11584618e861..6415b089725e 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -170,11 +170,16 @@ static void *array_map_lookup_elem(struct
> > bpf_map *map, void *key)
> >  {
> >         struct bpf_array *array = container_of(map, struct bpf_array, map);
> >         u32 index = *(u32 *)key;
> > +       void *elem;
> >
> >         if (unlikely(index >= array->map.max_entries))
> >                 return NULL;
> >
> > -       return array->value + array->elem_size * (index & array->index_mask);
> > +       current->in_ubsan++;
> > +       elem = array->value + array->elem_size * (index & array->index_mask);
> > +       current->in_ubsan--;
>
> This is an unnecessary performance hit for silencing what is clearly a
> false positive. I'm not sure that's the right solution here. It seems
> like something that's lacking on the tooling side instead. C language
> doesn't allow to express the intent here using flexible array
> approach. That doesn't mean that what we are doing here is wrong or
> undefined.

Oh, so you worry about this ++ and -- hurt the performance? If so, how
about this?

ubsan_disable_current();
elem = array->value + array->elem_size * (index & array->index_mask);
ubsan_enable_current();

#ifdef UBSAN
ubsan_disable_current()
{
      current->in_ubsan++;
}
#else
ubsan_disable_current() {}
#endif

etc

Production kernel would normally have UBSAN=n, so it is an noop.

Leaving this false positive unsilenced may also waste many people's
time over and over again, and increase the noisy level. Especially, it
seems this is one-off (not seen other parts of kernel doing like this)
and rather expensive to silence it in the UBSAN or/and compilers.
