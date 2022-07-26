Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3690C580FEB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbiGZJbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiGZJbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:31:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F32408B;
        Tue, 26 Jul 2022 02:30:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r70so10766705iod.10;
        Tue, 26 Jul 2022 02:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kqawzU8YqYeREn9Zamqwq5uu/0p4HW8DmKCCGP/2nw=;
        b=DOa65H1KvvzI06fMBXMB3HHSnhNT0nzew/WcuW5EkQARbH6504UJcitigreZDZkRnP
         5On4VGZoEw/LL2Sv5pkdrxo65v/P/3ez7/qS95zpeNsSZQktkmuVMKQT03io3ZMmV3Ld
         fpbQadga3H3vArSB5h2hn2lRI41cZZGoTcrN3hVtx6YHsab0vWSHEO/3uxBK8RggnHym
         6+pgsxeXT7TmUY07RnhrJTt4EIQbSrAMTw+XuQ0hZs1uHcZiRPJQM5iBzaq+v/fHG2ZV
         c5vz8qg3yet+RwkR2njziwcipAyPTiJpppASOCuMla/8w9EltvcVe0BjWwAmGIrWdS8+
         /guA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kqawzU8YqYeREn9Zamqwq5uu/0p4HW8DmKCCGP/2nw=;
        b=2TFgjiM4boMwKNvwxnSp5KhbGxU0c+lS1b0g1dnz9GrHq+ekQHhm64ULArmPEzf+lg
         KSXBuQy8U++uMF5LqVsVCxw4/wkY7+nUmHV/cqFtnt4mxPU0awI5V0KH4a6YC6UOMZGR
         lvCVrkDa74a99TCHR5pOIlPRdjPLYP9XYcCy4IxFXMhPS0/ufk+n1FRnre6EbRJ0ojEp
         4mL1pL5YbpyLgOeoqikOBKJdgWrp1rD+4UxDv7nkKKsd8Aw1Ra0rBPK/wg8ovtOIQ63C
         rqH2UdFwVO40VIyfV0BJPjivZL8BVWJ67ItsO4Rtw9xHkABUK1iVkcu9tqn7p3dDXfPg
         IG3g==
X-Gm-Message-State: AJIora+ykNxxtqodLHrn44dNsz4UJzJHcDNcS0zwhNL83bbyhcxTzFTe
        /+iWVhoGSmFRKNEOED4O4RQ9Y3L3cxzOLGxxMRE=
X-Google-Smtp-Source: AGRyM1uTVRRrkS/Dnp+01c3OBOmM022cneGzDFzCOwWy95+NxHWeKEdvrIAdxrCFPalJ7KLaWqOTKB1OBgm06Dbhe0k=
X-Received: by 2002:a05:6638:210b:b0:33f:5635:4c4b with SMTP id
 n11-20020a056638210b00b0033f56354c4bmr6836090jaj.116.1658827859051; Tue, 26
 Jul 2022 02:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com> <20220721134245.2450-5-memxor@gmail.com>
 <64f5b92546c14b69a20e9007bb31146b@huawei.com>
In-Reply-To: <64f5b92546c14b69a20e9007bb31146b@huawei.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 26 Jul 2022 11:30:21 +0200
Message-ID: <CAP01T7683DcToXdYPPZ5gQxiksuJRyrf_=k8PvQGtwNXt0+S-w@mail.gmail.com>
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

On Mon, 25 Jul 2022 at 11:52, Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Kumar Kartikeya Dwivedi [mailto:memxor@gmail.com]
> > Sent: Thursday, July 21, 2022 3:43 PM
> > Teach the verifier to detect a new KF_TRUSTED_ARGS kfunc flag, which
> > means each pointer argument must be trusted, which we define as a
> > pointer that is referenced (has non-zero ref_obj_id) and also needs to
> > have its offset unchanged, similar to how release functions expect their
> > argument. This allows a kfunc to receive pointer arguments unchanged
> > from the result of the acquire kfunc.
> >
> > This is required to ensure that kfunc that operate on some object only
> > work on acquired pointers and not normal PTR_TO_BTF_ID with same type
> > which can be obtained by pointer walking. The restrictions applied to
> > release arguments also apply to trusted arguments. This implies that
> > strict type matching (not deducing type by recursively following members
> > at offset) and OBJ_RELEASE offset checks (ensuring they are zero) are
> > used for trusted pointer arguments.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/btf.h | 32 ++++++++++++++++++++++++++++++++
> >  kernel/bpf/btf.c    | 17 ++++++++++++++---
> >  net/bpf/test_run.c  |  5 +++++
> >  3 files changed, 51 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 6dfc6eaf7f8c..cb63aa71e82f 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -17,6 +17,38 @@
> >  #define KF_RELEASE   (1 << 1) /* kfunc is a release function */
> >  #define KF_RET_NULL  (1 << 2) /* kfunc returns a pointer that may be NULL */
> >  #define KF_KPTR_GET  (1 << 3) /* kfunc returns reference to a kptr */
> > +/* Trusted arguments are those which are meant to be referenced arguments
> > with
> > + * unchanged offset. It is used to enforce that pointers obtained from acquire
> > + * kfuncs remain unmodified when being passed to helpers taking trusted args.
> > + *
> > + * Consider
> > + *   struct foo {
> > + *           int data;
> > + *           struct foo *next;
> > + *   };
> > + *
> > + *   struct bar {
> > + *           int data;
> > + *           struct foo f;
> > + *   };
> > + *
> > + *   struct foo *f = alloc_foo(); // Acquire kfunc
> > + *   struct bar *b = alloc_bar(); // Acquire kfunc
> > + *
> > + * If a kfunc set_foo_data() wants to operate only on the allocated object, it
> > + * will set the KF_TRUSTED_ARGS flag, which will prevent unsafe usage like:
> > + *
> > + *   set_foo_data(f, 42);       // Allowed
> > + *   set_foo_data(f->next, 42); // Rejected, non-referenced pointer
> > + *   set_foo_data(&f->next, 42);// Rejected, referenced, but bad offset
> > + *   set_foo_data(&b->f, 42);   // Rejected, referenced, but wrong type
> > + *
> > + * In the final case, usually for the purposes of type matching, it is deduced
> > + * by looking at the type of the member at the offset, but due to the
> > + * requirement of trusted argument, this deduction will be strict and not done
> > + * for this case.
> > + */
> > +#define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer
> > arguments */
>
> Hi Kumar
>
> would it make sense to introduce per-parameter flags? I have a function
> that has several parameters, but only one is referenced.
>

I have a patch for that in my local branch, I can fix it up and post
it. But first, can you give an example of where you think you need it?

> Thanks
>
> Roberto
