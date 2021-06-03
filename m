Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8913997DD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 04:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFCCHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 22:07:20 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:50972 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCCHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 22:07:20 -0400
Received: by mail-pj1-f43.google.com with SMTP id i22so2768789pju.0;
        Wed, 02 Jun 2021 19:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i/BK32Jzp3cqNvlgCq2WAqJU4RvyCZu+/H57kXLblOY=;
        b=ZTT3h/n+q9NvXPA/E/YCXeQN7USNJVdcbtJo8VF9v00y60FczF0OvKQGwaeSg7l5uV
         TnKhDv/DkmKIcz6WgMk0vBfMS7wF9+mDxlriCz7uzzFCNFz0SUHjN87KHYjC8Rp7SmPP
         6Byx240lccEY99EQIDLBGR8BKuETEsti+JSqSm4g046sWyPLPC6SOajt69Gu5ZA59xba
         NVHE7NUTZ4/VqnQTJeo8qFonlo2jSutKtWBVJWuQM6nzyJRq0yNqYl2Ast3SPmg/wwL8
         EoKqXrsheFXfSrArHNBlMM3LZ9UbLV9ixJL/mOfxRAXGuehVVdiL6GiXvm0tLnq59UTx
         E06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i/BK32Jzp3cqNvlgCq2WAqJU4RvyCZu+/H57kXLblOY=;
        b=QJ7JTas//yvN93vKHdZP1y0stzBE+pkVfqfOM7XDMGLiMeW65KnvXaYX21po3X9rT5
         c22/N+imUJOx0H0SRfX8mQJx6OzkZhr0yW0yuUtg6oFEDPQW5qop0O1CVDLZnGSONF/T
         np+ynoUKHToynAEvNR2X9DaD5dSHb/lDRKiLfZijt95Xn+u6mvqo8GzSUBs3qgIg27RG
         rqKwHxKIsfZFvk9oN6bGqDtV9JGWPgO9DjqWKfZmOd6AovuG6ERFcs29zOf+3vN+2MEr
         p7zm9aESs7PZm7QBzgUR5gt/v4b/sTgs1XkA/M53DENNloO5PWccxtiJCFB8nne3oXup
         NKyQ==
X-Gm-Message-State: AOAM531pnyQydhJ/hw+WrcPQkMIqRNY4PUBqoUe7Fii9zx+ZmJmSWElT
        9N5LnpzonnF4mgrfDDHhvBk=
X-Google-Smtp-Source: ABdhPJx0B3/Ggp+NBS94vmugYcVvag7lAAaSfuX1YaOs1IFjt/eT9JXabIJ4Lo2OWw74XqEKLunaEg==
X-Received: by 2002:a17:90b:e04:: with SMTP id ge4mr21320131pjb.230.1622685862090;
        Wed, 02 Jun 2021 19:04:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:27da])
        by smtp.gmail.com with ESMTPSA id n2sm909234pgl.59.2021.06.02.19.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 19:04:21 -0700 (PDT)
Date:   Wed, 2 Jun 2021 19:04:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add verifier checks for bpf_timer.
Message-ID: <20210603020419.mhnueugljj5cs3ie@ast-mbp.dhcp.thefacebook.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-3-alexei.starovoitov@gmail.com>
 <CAEf4BzbPkUdsY8XD5n2yMB8CDvakz4jxshjF8xrzqHXQS0ct9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbPkUdsY8XD5n2yMB8CDvakz4jxshjF8xrzqHXQS0ct9g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:34:29PM -0700, Andrii Nakryiko wrote:
> 
> >  /* copy everything but bpf_spin_lock */
> >  static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
> >  {
> > +       u32 off = 0, size = 0;
> > +
> >         if (unlikely(map_value_has_spin_lock(map))) {
> > -               u32 off = map->spin_lock_off;
> > +               off = map->spin_lock_off;
> > +               size = sizeof(struct bpf_spin_lock);
> > +       } else if (unlikely(map_value_has_timer(map))) {
> > +               off = map->timer_off;
> > +               size = sizeof(struct bpf_timer);
> > +       }
> 
> so the need to handle 0, 1, or 2 gaps seems to be the only reason to
> disallow both bpf_spinlock and bpf_timer in one map element, right?

exactly.

> Isn't it worth addressing it from the very beginning to lift the
> artificial restriction? E.g., for speed, you'd do:
> 
> if (likely(neither spinlock nor timer)) {
>  /* fastest pass */
> } else if (only one of spinlock or timer) {
>   /* do what you do here */
> } else {
>   int off1, off2, sz1, sz2;
> 
>   if (spinlock_off < timer_off) {
>     off1 = spinlock_off;
>     sz1 = spinlock_sz;
>     off2 = timer_off;
>     sz2 = timer_sz;
>   } else {
>     ... you get the idea

Not really :)
Are you suggesting to support one bpf_spin_lock and one
bpf_timer inside single map element, but not two spin_locks
and/or not two bpf_timers?
Two me it's either one or support any.
Anything in-between doesn't seem worth extra code.

> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index f386f85aee5c..0a828dc4968e 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3241,6 +3241,15 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> >                         return -EACCES;
> >                 }
> >         }
> > +       if (map_value_has_timer(map)) {
> > +               u32 t = map->timer_off;
> > +
> > +               if (reg->smin_value + off < t + sizeof(struct bpf_timer) &&
> 
> <= ? Otherwise we allow accessing the first byte, unless I'm mistaken.

I don't think so. See the comment above in if (map_value_has_spin_lock(map))
I didn't copy-paste it, because it's the same logic.

> > -       if (val) {
> > -               /* todo: relax this requirement */
> > -               verbose(env, "bpf_timer field can only be first in the map value element\n");
> 
> ok, this was confusing, but now I see why you did that...

I'll clarify the comment to say that the next patch fixes it.
