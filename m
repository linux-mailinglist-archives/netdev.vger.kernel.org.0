Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BAD6912EA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjBIWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjBIWBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:01:36 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E43C66EF6;
        Thu,  9 Feb 2023 14:01:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hx15so10686181ejc.11;
        Thu, 09 Feb 2023 14:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=12EmLmXNPxVlBwqhOstyYyPyvkcnUa7HgYnHDTPPtNE=;
        b=VlJ35ScMfjK5cUQAGBmGVcnTAuHtfwb/ke2H1l8NFfViNicrUGiQh7hbu/EqVgOJ/5
         VLgvb9npmAszqdK3H8E4DdfhEQNHVxHGbCdUO+63RdFECF3TBh7o/6pOOvhxj8EjoQkC
         6zZwCQgwSB9LMqPOgywPSKeefXjNV2A6bwgojpyZ/3k9gBRL870oaTNprn/WE0dwkxKv
         539yOjP8uezXZe8sTutqBHz2ASYxJzRVQ70Ma53irQRAjyW9oS3U3u8orouGlgHFORSi
         iZhfr5++lvrlYhacDuhkF/oVvFyZbilzrTFJGx/SeSvRJUvdh9sdEbv0msMn5/gUsOtP
         IPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12EmLmXNPxVlBwqhOstyYyPyvkcnUa7HgYnHDTPPtNE=;
        b=OkoCU7+ycY3jo/Cb2AuCOb+xvNjuS9Z6YK8CstegsLn59JXrDfHoFsd4zC6Trq8lrN
         w0p1B1gDgILAZJVmdaiQ06Kvul+KYPeN08ZCka/q+6DfHPG1LVBy4o8TWhhS58CcWtaj
         coR+K6v18RPhXe8XZmj9AKhj6Gl/eoEm/EJfgQOmizQ0TLJ3wrcMGmck7TEgDRoZwTf7
         DlC7QT7N9xUn9UhYe75CMGdUVnrmcBuNvCV24zkafXphxc/ebSNPbtuYqxb3vxMrpQ+t
         ZAtszslnMWvTDbQ23tnS8iedQwp06SnBC9HnmSLV5VpVrWg/WaJQmKLZDU35wiUkRT+S
         A8Qg==
X-Gm-Message-State: AO0yUKXWKxSsaQy6UB/BIaxXkQiJZ+aQghiJSlVF3k562Awp6FldFDUX
        Admu8fo3R+81LhpkYzfcp2R+gb4J8tsf26MKff8=
X-Google-Smtp-Source: AK7set+ng9pmkzKqIxaS7qA6X4EwNgcgxsLiahOVc2y/+PRfgUFnkEXjaeRFkczOkKCB8xLLHVP05GF+ZrJsP4YTQ1o=
X-Received: by 2002:a17:906:eb8f:b0:878:786e:8c39 with SMTP id
 mh15-20020a170906eb8f00b00878786e8c39mr2945087ejb.105.1675980086713; Thu, 09
 Feb 2023 14:01:26 -0800 (PST)
MIME-Version: 1.0
References: <20230209192337.never.690-kees@kernel.org> <CAEf4BzZXrf48wsTP=2H2gkX6T+MM0B45o0WNswi50DQ_B-WG4Q@mail.gmail.com>
 <63e5521a.170a0220.297d7.3a80@mx.google.com> <CAADnVQKsB2n0=hShYpYnTr5yFYRt5MX2QMWo3V9SB9JrM6GhTg@mail.gmail.com>
 <63e561d8.a70a0220.250aa.3eb9@mx.google.com>
In-Reply-To: <63e561d8.a70a0220.250aa.3eb9@mx.google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Feb 2023 14:01:15 -0800
Message-ID: <CAADnVQJed84rqugpNDY2u1r89QEOyAMMKZHLHefX=GRWZ3haoQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Haowen Bai <baihaowen@meizu.com>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        linux-hardening@vger.kernel.org
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

On Thu, Feb 9, 2023 at 1:12 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Feb 09, 2023 at 12:50:28PM -0800, Alexei Starovoitov wrote:
> > On Thu, Feb 9, 2023 at 12:05 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Thu, Feb 09, 2023 at 11:52:10AM -0800, Andrii Nakryiko wrote:
> > > > Do we need to add a new type to UAPI at all here? We can make this new
> > > > struct internal to kernel code (e.g. struct bpf_lpm_trie_key_kern) and
> > > > point out that it should match the layout of struct bpf_lpm_trie_key.
> > > > User-space can decide whether to use bpf_lpm_trie_key as-is, or if
> > > > just to ensure their custom struct has the same layout (I see some
> > > > internal users at Meta do just this, just make sure that they have
> > > > __u32 prefixlen as first member).
> > >
> > > The uses outside the kernel seemed numerous enough to justify a new UAPI
> > > struct (samples, selftests, etc). It also paves a single way forward
> > > when the userspace projects start using modern compiler options (e.g.
> > > systemd is usually pretty quick to adopt new features).
> >
> > I don't understand how the new uapi struct bpf_lpm_trie_key_u8 helps.
> > cilium progs and progs/map_ptr_kern.c
> > cannot do s/bpf_lpm_trie_key/bpf_lpm_trie_key_u8/.
> > They will fail to build, so they're stuck with bpf_lpm_trie_key.
>
> Right -- I'm proposing not changing bpf_lpm_trie_key. I'm proposing
> _adding_ bpf_lpm_trie_key_u8 for new users who will be using modern
> compiler options (i.e. where "data[0]" is nonsense).
>
> > Can we do just
> > struct bpf_lpm_trie_key_kern {
> >   __u32   prefixlen;
> >   __u8    data[];
> > };
> > and use it in the kernel?
>
> Yeah, I can do that if that's preferred, but it leaves userspace hanging
> when they eventually trip over this in their code when they enable
> -fstrict-flex-arrays=3 too.
>
> > What is the disadvantage?
>
> It seemed better to give a working example of how to migrate this code.

I understand and agree with intent, but I'm still missing
how you're going to achieve this migration.
bpf_lpm_trie_key_u8 doesn't provide a migration path to cilium progs
and pretty much all bpf progs that use LPM map.
Sure, one can change the user space part, like you did in test_lpm_map.c,
but it doesn't address the full scope.
imo half way is worse than not doing it.
