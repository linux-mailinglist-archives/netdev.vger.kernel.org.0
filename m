Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53182581391
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiGZM4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiGZM4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:56:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFF61B7A1;
        Tue, 26 Jul 2022 05:56:12 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e1so7158387ils.13;
        Tue, 26 Jul 2022 05:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gvO+9MRdWfUqybkh7m6xA/hz6OhfRjWoe7R94b8yr1g=;
        b=e4IbVkvNSFlIEAM4R+CXDV7d9DobTktPfZTs3aFVebb2GtYmuDr4GdJNRcDnmIIqCC
         HYuh9UmFOTiEykhePMt0IR62S7a63oDRNMP0oXjTOL7SriFxvCAEuQNlNw1bonAEkrjj
         AdK/DCeUfWyEaJzm/z+stXWVM+y/lMJ4DaDhOYb+hPKkCCiGq3t5HKEGKxpwgvnJfYlP
         pU/8Cq2sIz1s7A1MST3Jo4iZNWoec8v1J2xNrkwIp/552OF5kpzLDLCJWOPoIog034Q+
         wkE09zuVimmqYN5rrj9O52GC0a9S5BbrxkZYZuaq1L7kF+DVuKqNXUS1b0Dl3Vo7Hj+6
         Wiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gvO+9MRdWfUqybkh7m6xA/hz6OhfRjWoe7R94b8yr1g=;
        b=XQGlHtYSXjeDtv56IqnlCNpLgKDaUn9bLQLw8sZ7ZgRyF+rAWNb8mAc9P/97vSg+tY
         hYIhAKL2lppXg/epqDEEFJ/DbUFXP/SwG0Vx8Y/Q8xYdspb3a+x71anVjPpWIC8F2TnZ
         11WT+avs/W2TgyRRSA1rCOUwLGEel2GRDUbOFYNf/nvTSX6lwlHDRCdWKYd3zgF9d8cW
         Gaog9n3hYBVPeyYsQAMHmXz94DFJT8TD8QGLCozVQZjpR0obLUu2sBNYgcYK+5AM49K7
         U2/l0LmKLPPNIgUlu+EP6+vfWBbNp4ThsyMCOGJp80bhIg9zvDjjcE4OQauQm2gpW6vp
         x9Fg==
X-Gm-Message-State: AJIora8B594kv6uTKBYdQ88dDE5rdaVQQ9FreSEZ8aV5wLFHStANKOu9
        C4ku5aSn2uY3vGa3qtSddEfyZnitRVzDvMMIUHI=
X-Google-Smtp-Source: AGRyM1sMciNqzlCbe8AkG7T2fB0QBLcrXGzY6mFBphL47hRbnotc6CbYuG05dMdBEL/qTsXeUYjdqwfgGmHYdA9UqRk=
X-Received: by 2002:a05:6e02:1a6e:b0:2dc:ff0b:3e3e with SMTP id
 w14-20020a056e021a6e00b002dcff0b3e3emr6373577ilv.219.1658840171630; Tue, 26
 Jul 2022 05:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com> <20220721134245.2450-5-memxor@gmail.com>
 <64f5b92546c14b69a20e9007bb31146b@huawei.com> <CAP01T7683DcToXdYPPZ5gQxiksuJRyrf_=k8PvQGtwNXt0+S-w@mail.gmail.com>
 <e612d596b547456797dfee98f23bbd62@huawei.com>
In-Reply-To: <e612d596b547456797dfee98f23bbd62@huawei.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 26 Jul 2022 14:55:34 +0200
Message-ID: <CAP01T74s8E0-60ZtviLcTDR8sY3hUsAiTc2oTii_i4XeW3J2xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args
 to be trusted
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 at 12:02, Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Kumar Kartikeya Dwivedi [mailto:memxor@gmail.com]
> > Sent: Tuesday, July 26, 2022 11:30 AM
> > On Mon, 25 Jul 2022 at 11:52, Roberto Sassu <roberto.sassu@huawei.com>
> > wrote:
> > >
> > > > From: Kumar Kartikeya Dwivedi [mailto:memxor@gmail.com]
> > > > Sent: Thursday, July 21, 2022 3:43 PM
> > > > Teach the verifier to detect a new KF_TRUSTED_ARGS kfunc flag, which
> > > > means each pointer argument must be trusted, which we define as a
> > > > pointer that is referenced (has non-zero ref_obj_id) and also needs to
> > > > have its offset unchanged, similar to how release functions expect their
> > > > argument. This allows a kfunc to receive pointer arguments unchanged
> > > > from the result of the acquire kfunc.
> > > >
> > > > This is required to ensure that kfunc that operate on some object only
> > > > work on acquired pointers and not normal PTR_TO_BTF_ID with same type
> > > > which can be obtained by pointer walking. The restrictions applied to
> > > > release arguments also apply to trusted arguments. This implies that
> > > > strict type matching (not deducing type by recursively following members
> > > > at offset) and OBJ_RELEASE offset checks (ensuring they are zero) are
> > > > used for trusted pointer arguments.
> > > >
> > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > ---
> > > >  include/linux/btf.h | 32 ++++++++++++++++++++++++++++++++
> > > >  kernel/bpf/btf.c    | 17 ++++++++++++++---
> > > >  net/bpf/test_run.c  |  5 +++++
> > > >  3 files changed, 51 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > > > index 6dfc6eaf7f8c..cb63aa71e82f 100644
> > > > --- a/include/linux/btf.h
> > > > +++ b/include/linux/btf.h
> > > > @@ -17,6 +17,38 @@
> > > >  #define KF_RELEASE   (1 << 1) /* kfunc is a release function */
> > > >  #define KF_RET_NULL  (1 << 2) /* kfunc returns a pointer that may be NULL
> > */
> > > >  #define KF_KPTR_GET  (1 << 3) /* kfunc returns reference to a kptr */
> > > > +/* Trusted arguments are those which are meant to be referenced
> > arguments
> > > > with
> > > > + * unchanged offset. It is used to enforce that pointers obtained from
> > acquire
> > > > + * kfuncs remain unmodified when being passed to helpers taking trusted
> > args.
> > > > + *
> > > > + * Consider
> > > > + *   struct foo {
> > > > + *           int data;
> > > > + *           struct foo *next;
> > > > + *   };
> > > > + *
> > > > + *   struct bar {
> > > > + *           int data;
> > > > + *           struct foo f;
> > > > + *   };
> > > > + *
> > > > + *   struct foo *f = alloc_foo(); // Acquire kfunc
> > > > + *   struct bar *b = alloc_bar(); // Acquire kfunc
> > > > + *
> > > > + * If a kfunc set_foo_data() wants to operate only on the allocated object,
> > it
> > > > + * will set the KF_TRUSTED_ARGS flag, which will prevent unsafe usage like:
> > > > + *
> > > > + *   set_foo_data(f, 42);       // Allowed
> > > > + *   set_foo_data(f->next, 42); // Rejected, non-referenced pointer
> > > > + *   set_foo_data(&f->next, 42);// Rejected, referenced, but bad offset
> > > > + *   set_foo_data(&b->f, 42);   // Rejected, referenced, but wrong type
> > > > + *
> > > > + * In the final case, usually for the purposes of type matching, it is deduced
> > > > + * by looking at the type of the member at the offset, but due to the
> > > > + * requirement of trusted argument, this deduction will be strict and not
> > done
> > > > + * for this case.
> > > > + */
> > > > +#define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer
> > > > arguments */
> > >
> > > Hi Kumar
> > >
> > > would it make sense to introduce per-parameter flags? I have a function
> > > that has several parameters, but only one is referenced.
> > >
> >
> > I have a patch for that in my local branch, I can fix it up and post
> > it. But first, can you give an example of where you think you need it?
>
> I have pushed the complete patch set here, for testing:
>
> https://github.com/robertosassu/vmtest/tree/bpf-verify-sig-v9/travis-ci/diffs
>
> I rebased to bpf-next/master, and introduced KF_SLEEPABLE (similar
> functionality of " btf: Add a new kfunc set which allows to mark
> a function to be sleepable" from Benjamin Tissoires).
>
> The patch where I would use per-parameter KF_TRUSTED_ARGS is
> number 8. I also used your new API in patch 7 and it works well.
>

Ok, looks like you'll need it for the struct key * argument as there
are multiple pointers in the argument list and not all of them need to
be trusted. I will clean up and post the patch with a test later today
to the list.

> I didn't repost, as I'm waiting for comments on v8.
>
> Thanks
>
> Roberto
