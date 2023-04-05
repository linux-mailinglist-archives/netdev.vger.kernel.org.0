Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9CC6D7127
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbjDEAQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjDEAQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:16:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7754209;
        Tue,  4 Apr 2023 17:16:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id fi11so13477385edb.10;
        Tue, 04 Apr 2023 17:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680653799; x=1683245799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7fXs3FlG3Mz43u8eWvIesvm6nNlU2tC9ksVB79vy0U=;
        b=qjIv0J9bJo6FOZrBHkyAz7LvDM92IoEUR+aQx0TsC8Gz9Mqh5x93iuY846rOkdNpFC
         kVV5LE4WGexONlDum5SwSiBpDpsFqkMfI32mK3YP0hA3rMD6AdJ7MivuQFLXWJACW6mS
         mXVI1BprhB7rRSS7hEWkfgwag1kp02BD23zZzp4yU44WEs620BhsiI8zi/6OoFU7LSi1
         TsDKcfXxgyvshOl29Nz88uQSOprU3ctJxU5phvMivSjAci7oNKbnJewKqFsRd5QwND0L
         cCuy2TEh6R4Gx3E80UPx2fgu/rdJUQ2a91dnbQxgy9uVsefJ6/pvYBVRylWwHc+Bgn5u
         wT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653799; x=1683245799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7fXs3FlG3Mz43u8eWvIesvm6nNlU2tC9ksVB79vy0U=;
        b=pqZOiKByPujimymyIt8NCGwlEtzTAI0YlQpMUB+dgca4GpnpCTq++QjMbLraZtrNag
         PM1uvv5Y+9dB9S3G7iLnezGp2MlySxXzGAE3Hb4IU2UFC5IPvAU4nwH/msRg+5dXtSnn
         4NaABmgg9nwd4nKPbL0FLAnSbCUCyrGo7f1kFPXTfpSW3dXUNebP0fgfNJDdXvRbvgUt
         MPmkwhpf2k57lV7JGchFTIwyS4sxNmzHaWIWw7uc5ypMb+/o1Usvx+1gw1jN8+D5c8HC
         JVBTt5qKMGRfX8GeP/27lX+9RvLlSETauvFYh1H8q5N20EGswvXNT0M9UB1+Q3TdxtNO
         Z8mA==
X-Gm-Message-State: AAQBX9cGpa4uo1hCRbtWzmiqc59Wkcmz64yABkUDpkeOR/X9JoSUsYzG
        AA/A8zxcDDkAeb5Rdw0Iv29sc4GBk0puSZBvIy/AYYHdZX8=
X-Google-Smtp-Source: AKy350aeMG9Aaq70gF4bXComydSk/scIaH8iJJEsCO1e5i82djy7Zq+Ia9ULAcGu2igiZyOhoKkQ/rl4nuBsalTJI+U=
X-Received: by 2002:a17:906:1c0e:b0:90a:33e4:5a69 with SMTP id
 k14-20020a1709061c0e00b0090a33e45a69mr622000ejg.3.1680653799092; Tue, 04 Apr
 2023 17:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
In-Reply-To: <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Apr 2023 17:16:27 -0700
Message-ID: <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 5:02=E2=80=AFPM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Apr 4, 2023 at 7:51=E2=80=AFAM David Vernet <void@manifault.com> =
wrote:
> >
> > On Mon, Apr 03, 2023 at 09:50:21PM -0700, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > The patch set is addressing a fallout from
> > > commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier."=
)
> > > It was too aggressive with PTR_UNTRUSTED marks.
> > > Patches 1-6 are cleanup and adding verifier smartness to address real
> > > use cases in bpf programs that broke with too aggressive PTR_UNTRUSTE=
D.
> > > The partial revert is done in patch 7 anyway.
> > >
> > > Alexei Starovoitov (8):
> > >   bpf: Invoke btf_struct_access() callback only for writes.
> > >   bpf: Remove unused arguments from btf_struct_access().
> > >   bpf: Refactor btf_nested_type_is_trusted().
> > >   bpf: Teach verifier that certain helpers accept NULL pointer.
> > >   bpf: Refactor NULL-ness check in check_reg_type().
> > >   bpf: Allowlist few fields similar to __rcu tag.
> > >   bpf: Undo strict enforcement for walking untagged fields.
> > >   selftests/bpf: Add tracing tests for walking skb and req.
> >
> > For whole series:
> >
> > Acked-by: David Vernet <void@manifault.com>
>
> Added David's acks manually (we really need to teach pw-apply to do
> this automatically...) and applied.

+1
I was hoping that patchwork will add this feature eventually,
but it seems faster to hack the pw-apply script instead.

> I've added a single sentence to
> patch #1 with why (I think) btf_struct_access() callback
> simplification was done, I didn't want to hold the patch set just due
> to that, as the rest looked good. But please do consider renaming the
> callback to more write-access implying name as a follow up, as current
> situation with the same name but different semantics is confusing.
>
> Applied to bpf-next, thanks.

Thanks.
Renaming either the btf_struct_access() function or (*btf_struct_access) fi=
eld
was on the todo list as a potential workaround,
since this name caused a weird issue with clang in LTO build.
For some reason two global symbols were generated.
Yonghong is investigating.

fwiw btf_struct_write_access sounds fine as a new name.
