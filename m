Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C0B2746A5
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVQ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVQ2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 12:28:55 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5583C061755;
        Tue, 22 Sep 2020 09:28:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j76so7392987ybg.3;
        Tue, 22 Sep 2020 09:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=295WF6+YkOYxS4yaHf3xhBMibi2Nhj/XScYHAEsqXQ8=;
        b=nKszfVnAadOeYZhxlZd4MK/6+0ORc06/miDtdDP2PE9h4LDahwHMlwUTiUoUjqloSN
         Sd8UdqU+OhqXNT03gCkQSWNvQ7l+yQiNKFdANkrVbgjF7aHxVf3qzwBrPFRPCiJoC9pv
         6nGhEwOLMLlOIs2vdy2GFlzeRiHjb7w3NyshzZqVGiH9p+xgTz6LW5qEwetvlSSu+4yy
         PnBELLBGAzym8e7hR/HxZELDWAccZb4IOeZt/sIp07lLjfh2AFPAuDJRa0Ux13gai+n1
         G9xZ09M6xwtYuCXt2boc8h4SaUpzN977IhM49ppwwPx0u6TObEShqdj0YG9w1LqUN9jh
         TIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=295WF6+YkOYxS4yaHf3xhBMibi2Nhj/XScYHAEsqXQ8=;
        b=uhyZD4mMxM6j1YFXgKIRZV0vJSI4mJVO/RVyfjhcABu1ZkIYz32mday8avKfWFq9qU
         +6r352CtVzR5VhG3qTb91CmbvvPYkmNOJoe+zAp6qyy5ED8XR/YNZjM+uLDVxjlRkGDB
         rt8GDXEq8ayaeLwiUavUlt0lxzeKIW5wWtO4tCjFPfUa6JdkDRA1zFOmgPhTxwNE0ClC
         l3Oc+5F6dgGQAS3wUwdfjAL33+xUqEtL3Z9FsDViXvaaUTsYpvupNGKYTwi3/J3NqR3P
         gqNzCHdejPw+j60llJ3DjhI+1hwYRiXKay8T3vF9wFXtrpKJivZ0LuUXWyhmJhcHF9Kh
         geNA==
X-Gm-Message-State: AOAM533Ct3fS0+Y5n7fEoqmKtdJXkdBzDBOQzYsR1CkiJvavgEKNFi8I
        ktPj/KrVtUMJK1yYmk0CKimscpCoJFtoxSonOX0=
X-Google-Smtp-Source: ABdhPJzoO0rc660vnW2mtbI/0K1X5+0P0c933v55KQwMpxz+Yq9yUl8cfgW2VfNu4ipMEsLex+M67yb9J7BpR+F+zI4=
X-Received: by 2002:a25:730a:: with SMTP id o10mr1131512ybc.403.1600792134980;
 Tue, 22 Sep 2020 09:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618622.58048.13304507277053169557.stgit@toke.dk> <CAEf4BzY4UR+KjZ3bY6ykyW5CPNwAzwgKVhYHGdgDuMT2nntmTg@mail.gmail.com>
 <87a6xioydh.fsf@toke.dk>
In-Reply-To: <87a6xioydh.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Sep 2020 09:28:44 -0700
Message-ID: <CAEf4BzYhKybEg_NUYs4ziP3fu3-76ABWjzwTqXuVFeuk1XjwOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 03/10] bpf: verifier: refactor check_attach_btf_id()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 4:16 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> The check_attach_btf_id() function really does three things:
> >>
> >> 1. It performs a bunch of checks on the program to ensure that the
> >>    attachment is valid.
> >>
> >> 2. It stores a bunch of state about the attachment being requested in
> >>    the verifier environment and struct bpf_prog objects.
> >>
> >> 3. It allocates a trampoline for the attachment.
> >>
> >> This patch splits out (1.) and (3.) into separate functions in prepara=
tion
> >> for reusing them when the actual attachment is happening (in the
> >> raw_tracepoint_open syscall operation), which will allow tracing progr=
ams
> >> to have multiple (compatible) attachments.
> >>
> >> No functional change is intended with this patch.
> >>
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > Ok, so bad news: you broke another selftest (test_overhead). Please,
> > do run test_progs and make sure everything succeeds, every time before
> > you post a new version.
>
> Right, so I looked into this, and it seems the only reason it was
> succeeding before were those skipped checks you pointed out that are now
> fixed. I.e., __set_task_comm() is not actually supposed to be
> fmod_ret'able according to check_attach_modify_return(). So I'm not sure
> what the right way to fix this is?

You have to remove the fmod_ret part from test_overhead, it was never
supposed to work.

>
> The fmod_ret bit was added to test_overhead by:
>
> 4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_overhead as=
 part of bench")
>
> so the obvious thing is to just do a (partial) revert of that? WDYT?
>
> -Toke
>
