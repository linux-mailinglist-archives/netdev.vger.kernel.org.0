Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D221E6D9
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEOC1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:27:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41200 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEOC1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 22:27:44 -0400
Received: by mail-lj1-f196.google.com with SMTP id k8so1032386lja.8;
        Tue, 14 May 2019 19:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGWPE+Lzqg4+ue7Lyy7055pcyP5wWvksfTD3aW7p4mc=;
        b=c+v75i9f59bBymPmSbsYhbuQI7JVimRSoQ8LhZttkHFAuUc3wiKtSB+0ZWkHVFDBvM
         njwDY4aTcjmLDbLBuFUdNf47C9XrWHoFEXDVqECwY/OVniS8eJGkKNiF4b8cMqHPPq3X
         YA5cuP0gJXQuSm7qrYCl7zcK7LOWhUlOTkPzYATcr/NIcJ9g+HisHdlexoPSBBpUiHI2
         bZWNIc02PZbqm+XKSmNtB1uYZ/Meiu5plKtHjFdmfAJut95DVHhQPZ9+ZxHhlfscOD8i
         EF6LAKt80zhczBgp1pINQa6EH4Xw5V55IUrrWFoIlCWMfN7+d82JtRrJh/hVjbJ3wdh2
         TQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGWPE+Lzqg4+ue7Lyy7055pcyP5wWvksfTD3aW7p4mc=;
        b=dcvfoO+a5yVJBleElLpjY9gPfBDYjDhB520s8PTHV11HZ7SIRO7bi/mLyaQZcF9/8H
         2DOmFoftlbtdNd6jbTf5uh8mZpvuTemr0YjEFLdsWOVUWl4bHR6efxmjCFWjEt4F+n9Q
         CDr4IwTbMyHjGKZCf+EV+txSmr6DIzEUcirI7t/tC3T6j3akjiJ/J2mUuBRgf5F90jBZ
         5Xfaq9YoFdomsn9Dm/0Yi3Q0r59Xk17i2TKk6+e7/QScLVvg8oBSdHRXiqEgyDyEyrK0
         UEI+oPPxN5YWc2WYKg7tWIS3c6beVrBdsq0QvSmFF4p9wqzjEBPWaWym2K+1WhFzGvnC
         Ni+A==
X-Gm-Message-State: APjAAAW9tazbKjUt90vwtyGBcq6XrBjecnddMxndZYdV5NbXdyl8egGb
        yp8KeiGbAfYe9+FmueCIpq2Ewwh2iiI22CnnmBE=
X-Google-Smtp-Source: APXvYqwakEoqgL//0PalK738zMWr8egwygJpTJfXyFzi2xy3pXb2Mef2521Xp9kXv9cHCFYzAjcPlQ3XdOyR3zxUqnw=
X-Received: by 2002:a2e:8988:: with SMTP id c8mr13457632lji.99.1557887261403;
 Tue, 14 May 2019 19:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com> <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch> <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch> <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch>
In-Reply-To: <20190515021144.GD10244@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 May 2019 19:27:29 -0700
Message-ID: <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 7:11 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/14, Alexei Starovoitov wrote:
> > On Tue, May 14, 2019 at 10:53 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > Existing __rcu annotations don't add anything to the safety.
> >
> > what do you mean?
> > BPF_PROG_RUN_ARRAY derefs these pointers under rcu.
> And I'm not removing them from the struct definitions, I'm removing __rcu
> from the helpers' arguments only. Because those helpers are always called
> with the mutex and don't need it. To reiterate: rcu_dereference_protected
> is enough to get a pointer (from __rcu annotated) for the duration
> of the mutex, helpers can operate on the non-annotated (dereferenced) prog
> array.
>
> Read section still does the following (BPF_PROG_RUN_ARRAY):
>
>         rcu_read_lock();
>         p = rcu_dereference(__rcu'd progs);
>         while (p) {}
>         rcu_read_unlock();
>
> And write sections do:
>
>         mutex_lock(&mtx);
>         p = rcu_dereference_protected(__rcu'd progs, lockdep_is_held(&mtx);
>         // ^^^ does rcu_dereference in the mutex protected section
>         bpf_prog_array_length(p);
>         bpf_prog_array_copy_to_user(p, ...);
>         bpf_prog_array_delete_safe(p);
>         bpf_prog_array_copy_info(p);
>         bpf_prog_array_copy(p, ...);
>         bpf_prog_array_free(p);

what about activate_effective_progs() ?
I wouldn't want to lose the annotation there.
but then array_free will lose it?
in some cases it's called without mutex in a destruction path.
also how do you propose to solve different 'mtx' in
lockdep_is_held(&mtx)); ?
passing it through the call chain is imo not clean.

I wonder what others think about this whole discussion.

>         // ^^^ all these helpers are consistent already with or
>         // without __rcu annotation because we hold a mutex and
>         // guarantee no concurrent updates, so __rcu annotations
>         // for their input arguments is not needed.
>         mutex_unlock(&mtx);
