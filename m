Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DF157DFF7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiGVK2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiGVK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:27:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0F7B5C9C;
        Fri, 22 Jul 2022 03:26:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q14so3324215iod.3;
        Fri, 22 Jul 2022 03:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++ZOFlOZxMjrOsr2efl/yr+NEpCsW/HIcT4Q3CtS1EA=;
        b=h0FeYf4usPtRPDWKkAXmKGyuKsyZDBNxj65yEkSBH87oEq5m9ADC2r8UZyeo8robS0
         PqT684mRn+fJb8PpiOxsBCTODXQ3VU+owR7jj1ELG4QSmRs4OiDX7lOlMwION71AciVq
         h2842VtVKSGlN8nq9nPkWsvZQk9G8GmLfH5ekuaUFt4aqhRCfYKEZR63A1ep8akYJSVS
         yQ0Q4ssZzvL+gGyCLigwIgp+L0inHimgwrLJnMqy2v+iiQzk6dFCwV1PMN7D6CRoynqf
         m8Dpc3TTQ1F3lQ9MpvxS+recTxDue27hx9BkQuZ35sLhyDLC+29oN3e2Ub6Jke3d3dlC
         iWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++ZOFlOZxMjrOsr2efl/yr+NEpCsW/HIcT4Q3CtS1EA=;
        b=Lxk4Ey6bnV1RetpWZCT90KtbHaTWxzd/Pvik1AjziS3QjPnkvRM0afbwO2LyA6J5Mt
         nmG1KJD6Occ4c00pewwamXP05vh2Ote0UlmVr6MI3jAQ03CbyALCCILjRLWKIja2Inyi
         NjH1Vyybr561tHvqiPmNOZT6CofjSxoXI9GZ5fz5YTIQCcH0Ty4MeavaOW770cgrM43V
         xIBhCnYLFkNvH/dIKEFImREPDNdzReQal6kSgxhAHsDuLzcSSlMdebZR8d+PIcSZFYzk
         lp58xGuNq8jWKBAQ6jHybDRlTw6EhyVWsoU1/SEa77GloIJo+cN/Ze39FZXCCJlAF2PQ
         y+Sg==
X-Gm-Message-State: AJIora+bzzSa4OL9/9RtM2LC9bMMin5GIcESnVCt1Qtqj2BFINoiiaa1
        lbt6VJ1aKJS2U3Cf2MW4fE50okzBvA1ZCC0Kc04=
X-Google-Smtp-Source: AGRyM1uE3dnjcjkHa9ZDYr6Pi2e/HLy1hn85fMSmA7vDXmZ6J9uPot1KYZ4SLW+O+JKzWO69H3e53X5SlrQsChafoEU=
X-Received: by 2002:a02:c4c3:0:b0:33f:4fb4:834b with SMTP id
 h3-20020a02c4c3000000b0033f4fb4834bmr1237811jaj.231.1658485608235; Fri, 22
 Jul 2022 03:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com> <20220721134245.2450-5-memxor@gmail.com>
 <20220722041056.r2ozhs4p3s7mt7go@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220722041056.r2ozhs4p3s7mt7go@macbook-pro-3.dhcp.thefacebook.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 22 Jul 2022 12:26:11 +0200
Message-ID: <CAP01T77M27ZxZ-_oMujCCpCkSYJ9iMnm4EHTNgTe2odbCfPt2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args
 to be trusted
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
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

On Fri, 22 Jul 2022 at 06:11, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 21, 2022 at 03:42:36PM +0200, Kumar Kartikeya Dwivedi wrote:
> > +/* Trusted arguments are those which are meant to be referenced arguments with
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
>
> I think you meant to swap above two comments ?
> That's what I did while applying.
>
> Also fixed typo in Fixes tag in patch 13. It was missing a letter in sha.
>
> Since there are 3 other pending patchsets in patchwork that add new kfuncs
> this cleanup of kfunc registration couldn't have come at better time.
>
> Thank you for doing this work.

Thank you for doing the fixups!
