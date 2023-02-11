Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3256C6932ED
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBKRzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 12:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBKRzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 12:55:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E21B3;
        Sat, 11 Feb 2023 09:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43403B80966;
        Sat, 11 Feb 2023 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC92C433EF;
        Sat, 11 Feb 2023 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676138116;
        bh=Cimg2dplNjIVjTVkvDDsDJ8LuO9N1uHdmJusLzhU7z8=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=SB8VKgJ7x06WR/kTHhb1EVQZRzuNIWs3f3IpE4j3fUYVpvpfODIfP/nyYK3n2utRZ
         xvxNqtreM5BDIW2MhK+qIoCCODNyA+4GFBhAOvXSWzRA2hmWfeOxa4LD0bY7CW5cnN
         /fGH5zbSMA2WFBDJ4nrY3+J04TCQHh3YBqho6Z8sCYHArqjGBTWrLEK8OVI5HyvXSe
         qdhGjoMbaHuKI8ZBz6a/Bl6kPjUwVefxsyHAtZEOdj03XUbvvqg6NB5zZ92IqK8bXS
         Tz6ZOglY12j65Nyyhq5WHRcGbzpf3+GKf+l/R62CUdaYKNGhye23TfhHDWDi89fJ8L
         TvXoMM6f0FhtA==
Date:   Sat, 11 Feb 2023 09:55:09 -0800
From:   Kees Cook <kees@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
User-Agent: K-9 Mail for Android
In-Reply-To: <CAADnVQJed84rqugpNDY2u1r89QEOyAMMKZHLHefX=GRWZ3haoQ@mail.gmail.com>
References: <20230209192337.never.690-kees@kernel.org> <CAEf4BzZXrf48wsTP=2H2gkX6T+MM0B45o0WNswi50DQ_B-WG4Q@mail.gmail.com> <63e5521a.170a0220.297d7.3a80@mx.google.com> <CAADnVQKsB2n0=hShYpYnTr5yFYRt5MX2QMWo3V9SB9JrM6GhTg@mail.gmail.com> <63e561d8.a70a0220.250aa.3eb9@mx.google.com> <CAADnVQJed84rqugpNDY2u1r89QEOyAMMKZHLHefX=GRWZ3haoQ@mail.gmail.com>
Message-ID: <E8CE1CDC-27F2-4F14-9AFF-3AE409B82F6C@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On February 9, 2023 2:01:15 PM PST, Alexei Starovoitov <alexei=2Estarovoito=
v@gmail=2Ecom> wrote:
>On Thu, Feb 9, 2023 at 1:12 PM Kees Cook <keescook@chromium=2Eorg> wrote:
>>
>> On Thu, Feb 09, 2023 at 12:50:28PM -0800, Alexei Starovoitov wrote:
>> > On Thu, Feb 9, 2023 at 12:05 PM Kees Cook <keescook@chromium=2Eorg> w=
rote:
>> > >
>> > > On Thu, Feb 09, 2023 at 11:52:10AM -0800, Andrii Nakryiko wrote:
>> > > > Do we need to add a new type to UAPI at all here? We can make thi=
s new
>> > > > struct internal to kernel code (e=2Eg=2E struct bpf_lpm_trie_key_=
kern) and
>> > > > point out that it should match the layout of struct bpf_lpm_trie_=
key=2E
>> > > > User-space can decide whether to use bpf_lpm_trie_key as-is, or i=
f
>> > > > just to ensure their custom struct has the same layout (I see som=
e
>> > > > internal users at Meta do just this, just make sure that they hav=
e
>> > > > __u32 prefixlen as first member)=2E
>> > >
>> > > The uses outside the kernel seemed numerous enough to justify a new=
 UAPI
>> > > struct (samples, selftests, etc)=2E It also paves a single way forw=
ard
>> > > when the userspace projects start using modern compiler options (e=
=2Eg=2E
>> > > systemd is usually pretty quick to adopt new features)=2E
>> >
>> > I don't understand how the new uapi struct bpf_lpm_trie_key_u8 helps=
=2E
>> > cilium progs and progs/map_ptr_kern=2Ec
>> > cannot do s/bpf_lpm_trie_key/bpf_lpm_trie_key_u8/=2E
>> > They will fail to build, so they're stuck with bpf_lpm_trie_key=2E
>>
>> Right -- I'm proposing not changing bpf_lpm_trie_key=2E I'm proposing
>> _adding_ bpf_lpm_trie_key_u8 for new users who will be using modern
>> compiler options (i=2Ee=2E where "data[0]" is nonsense)=2E
>>
>> > Can we do just
>> > struct bpf_lpm_trie_key_kern {
>> >   __u32   prefixlen;
>> >   __u8    data[];
>> > };
>> > and use it in the kernel?
>>
>> Yeah, I can do that if that's preferred, but it leaves userspace hangin=
g
>> when they eventually trip over this in their code when they enable
>> -fstrict-flex-arrays=3D3 too=2E
>>
>> > What is the disadvantage?
>>
>> It seemed better to give a working example of how to migrate this code=
=2E
>
>I understand and agree with intent, but I'm still missing
>how you're going to achieve this migration=2E
>bpf_lpm_trie_key_u8 doesn't provide a migration path to cilium progs
>and pretty much all bpf progs that use LPM map=2E
>Sure, one can change the user space part, like you did in test_lpm_map=2E=
c,
>but it doesn't address the full scope=2E
>imo half way is worse than not doing it=2E

Maybe I'm missing something, but if a program isn't building with -fstrict=
-flex-arrays=3D3, it can keep on using struct bpf_lpm_trie_key as before=2E=
 If/when it starts using -fsfa, if can use struct bpf_lpm_trie_key in compo=
site structs as a header just like before, but if it has places using the "=
data" member as an array of u8, it can switch to something using struct bpf=
_lpm_trie_key_u8, either directly or as a union with whatever ever struct t=
hey have=2E (And this replacement is what I did for all the samples/selftes=
ts=2E)



--=20
Kees Cook
