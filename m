Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD75B479F27
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhLSEdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLSEdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:33:52 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5801C061574;
        Sat, 18 Dec 2021 20:33:52 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so7068611pjj.2;
        Sat, 18 Dec 2021 20:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gV+SP9IsKwI1EWbSZA0vVnhGc8OQJxBzHdP1bhDrue4=;
        b=Xz4ANqa7INEp3RnQj6qVWfjhfPP8QqQdi1ACdCiXE4QcsllkpMMGrgVxo/j5X8rPzU
         4JwubKe7nd0z36V0KPWWvAK6I1A2ODzk+EZd8bjScSLmmVFRaoUhrBHugFZLsJwTCEZr
         z5Z7CKGwD32BNLPjqAZ7uAPKuxRhRffYPHTpwnPRvJS6sohxFUUwzhSsoGNUvHmxomyp
         KC2/YqyjPumcX0TMLIa4SzqHmScnL8WdEnEbAZJeLEso/P5lc/37CY7UkrfAl3riVnkd
         2WcPwLk+ysfBVm2+REKDYf9+nOZx1GPoKMCA7pamEJtk11lZo5GEmjiMCBxLdIfEz8Jg
         TKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gV+SP9IsKwI1EWbSZA0vVnhGc8OQJxBzHdP1bhDrue4=;
        b=LtX/gIfN42yVVe6wTjXDypJlRHxEEHWpo8E3/V5TjPJNnmfYi5zyaNdz24O18QMP+r
         GHMo5wZuXg84zAUEpFz3I7XEhXugaDmL1SGrm8i/dn4PfZJ/f/unU9cA/TB8ba+JIc+N
         Vk8ELKQ7ZugZ463BUIg5uEDx5PJxQVdS3kx7QkHR+fJ4K+/A0tUpLlW0iIiUJJDMVWze
         dqNQF3xamHzkAs0nV1igPOCDo2zfWp2LqcQMbxO/pErrK90OnpNHjI3kvXdLjmTI8FbM
         5vU2QqpFAGKEW36GRip2yLvmFdNIEpeG3o+vNUNJ5iALtm56j/iyP8ixo+YahpcKsZCI
         268A==
X-Gm-Message-State: AOAM532zV/cRmHIL0kWPvTJGphaZlR22ARV3qMaXnUceM2V9QgaXoLnj
        wezwfZ1GlrI8F/R+/IyoVUQ=
X-Google-Smtp-Source: ABdhPJzFUlb8DDbHx6EMuSXNidqFpoc7C8R8LJjla/fdP5/zuUd1wM/OLDiIKm6hccR3542EMeXK5g==
X-Received: by 2002:a17:90b:33c6:: with SMTP id lk6mr1246726pjb.70.1639888431964;
        Sat, 18 Dec 2021 20:33:51 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id w8sm881025pfu.162.2021.12.18.20.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:33:51 -0800 (PST)
Date:   Sun, 19 Dec 2021 10:03:49 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
Message-ID: <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 09:30:32AM IST, Alexei Starovoitov wrote:
> On Sat, Dec 18, 2021 at 7:18 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sun, Dec 19, 2021 at 07:58:39AM IST, Alexei Starovoitov wrote:
> > > On Fri, Dec 17, 2021 at 07:20:27AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > > index b80fe5bf2a02..a6ef11db6823 100644
> > > > --- a/include/linux/bpf_verifier.h
> > > > +++ b/include/linux/bpf_verifier.h
> > > > @@ -128,6 +128,16 @@ struct bpf_reg_state {
> > > >      * allowed and has the same effect as bpf_sk_release(sk).
> > > >      */
> > > >     u32 ref_obj_id;
> > > > +   /* This is set for pointers which are derived from referenced
> > > > +    * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
> > > > +    * pointers obtained by walking referenced PTR_TO_BTF_ID
> > > > +    * are appropriately invalidated when the lifetime of their
> > > > +    * parent object ends.
> > > > +    *
> > > > +    * Only one of ref_obj_id and parent_ref_obj_id can be set,
> > > > +    * never both at once.
> > > > +    */
> > > > +   u32 parent_ref_obj_id;
> > >
> > > How would it handle parent of parent?
> >
> > When you do:
> >
> > r1 = acquire();
> >
> > it gets ref_obj_id as N, then when you load r1->next, it does mark_btf_ld_reg
> > with reg->ref_obj_id ?: reg->parent_ref_obj_id, the latter is zero so it copies
> > ref, but into parent_ref_obj_id.
> >
> > r2 = r1->next;
> >
> > From here on, parent_ref_obj_id is propagated into all further mark_btf_ld_reg,
> > so if we do since ref_obj_id will be zero from previous mark_btf_ld_reg:
> >
> > r3 = r2->next; // it will copy parent_ref_obj_id
> >
> > I think it even works fine when you reach it indirectly, like foo->bar->foo,
> > if first foo is referenced.
> >
> > ... but maybe I missed some detail, do you see a problem in this approach?
> >
> > > Did you consider map_uid approach ?
> > > Similar uid can be added for PTR_TO_BTF_ID.
> > > Then every such pointer will be unique. Each deref will get its own uid.
> >
> > I'll look into it, I didn't consider it before. My idea was to invalidate
> > pointers obtained from a referenced ptr_to_btf_id so I copied the same
> > ref_obj_id into parent_ref_obj_id, so that it can be matched during release. How
> > would that work in the btf_uid approach if they are unique? Do we copy the same
> > ref_obj_id into btf_uid? Then it's not very different except being btf_id ptr
> > specific state, right?
> >
> > Or we can copy ref_obj_id and also set uid to disallow it from being released,
> > but still allow invalidation.
>
> The goal is to disallow:
> struct foo { struct foo *next; };
>
> r1 = acquire(...); // BTF ID of struct foo
> if (r1) {
>         r2 = r1->next;
>         release(r2);
> }
>
> right?

Yes, but not just that, we also want to prevent use of r2 after release(r1).
Then snippet above is problematic if we get same BTF ID ptr in r2 and try to
solve that in the naive way (just copy ref_obj_id in dst_reg), because
verifier will not be able to distinguish between r1 and r2 for purposes of
release kfunc call.

> With btf_uid approach each deref gets its own uid.
> r2 = r1->next
> and
> r3 = r1->next
> will get different uids.
> When type == PTR_TO_BTF_ID its reg->ref_obj_id will be considered
> together with btf_uid.
> Both ref_obj_id and btf_uid need to be the same.
>

That will indeed work, I can rework it this way. After acquire_reference_state
we can set btf_uid = ref_obj_id, then simply assign fresh btf_uid on
mark_btf_ld_reg.

Not pushing back, but I am trying to understand why you think this is better
than simply doing it the way in this patch? What additional cases is btf_uid
approach considering that I am missing? I don't understand what we get if each
deref gets its own unique btf_uid.

There are only two objectives: prevent use of r2 after r1 is gone, and prevent
r2 being passed into release kfunc (discovered when I simply copied ref_obj_id).

> But let's go back a bit.
> Why ref_obj_id is copied on deref?

It is, but into parent_ref_obj_id, to match during release_reference.

> Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?

It's ref_obj_id is still 0.

Thinking about this more, we actually only need 1 extra bit of information in
reg_state, not even a new member. We can simply copy ref_obj_id and set this
bit, then we can reject this register during release but consider it during
release_reference.

--
Kartikeya
