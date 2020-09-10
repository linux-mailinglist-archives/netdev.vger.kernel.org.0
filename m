Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122EB26502C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgIJUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgIJUDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:03:18 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B64C061573;
        Thu, 10 Sep 2020 13:03:15 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id v78so4869082ybv.5;
        Thu, 10 Sep 2020 13:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N2jWB4I7nmsk1+BJexevBsZfunbJb26Z1pd8MeqEp+w=;
        b=No1fgGjYZ0wXuPPNMSFxHucda2V8inLy/TrUnVi5IRO5F2S1fNuY6wE0OpbC+nCw1M
         OfrRYqPbmkLLQO4kFMqo3aL66+lddsKG9nmRyD7l86QFmcn0Im2ZOfpUonajj/acqS4D
         SGUb8Rwk+GOrK7/xx2S9oxOU0BD8c2+8YPvFz1GimvNgbPeC/491M/PL84u5R0YymYWV
         W7BEMyfeb3AXGfqduD+jU717f6Ru4hmLcbOsp8avj36ZZfx5/tMefXwYPtHj+qeBYa26
         7yVh0JEKsBGK+Wuf9UpMVqvkul/yqYQC82U+iW5v1qXSBG0R5Ftrzq/bdoxiU8jc7+1k
         wgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N2jWB4I7nmsk1+BJexevBsZfunbJb26Z1pd8MeqEp+w=;
        b=gFIJvjRvOBXfbYlvJ4JQU/2/vpQiXCDj1BzimxzOHE5AEm56bOfzSwrP5PtN1clFjB
         EroMNDOQaIdNdQrCfOoaNKMpeL/t5K4Joi2CcaTaDz2PKl25tATf9YtaKkUEjacy6TU1
         KnNmpWwV+y13hqbeeeMkonnXtCn3ThweSIuuqdxbre6iA9j0a4eimKNHYiVKqyVMn4l9
         mShNnG27ImdDfwBDWxSOmFd0hOQTOnkkU2LztN0S+INi9lpTdErlztHoPZJYLdHnXC6l
         TR52zGcHkEHscC02ZfRX57LyOY7nKOseeOfbvRqAoppsmhgEalmtkZ6hEXHNYNxxJv6L
         Ld/A==
X-Gm-Message-State: AOAM533RqXrSqRFmnqUa3DGg/XYe7/V/S+A9YV43Mqy0AIffkkSmzcr3
        xIRvbiJgIv+YkIF340m8gnqMS0OnNuV/rEiPEoNImXmM
X-Google-Smtp-Source: ABdhPJyNZ4UwlOnjgQ2LM67nABCkqxQ6F77vUp1VrlJjEcrPskpTTjNoPhLBHe67UzjoPAVyJjpXc3/cQYKx1XCTqmU=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr13887717ybp.510.1599768194218;
 Thu, 10 Sep 2020 13:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <159974338947.129227.5610774877906475683.stgit@toke.dk> <159974339060.129227.10384464703530448748.stgit@toke.dk>
In-Reply-To: <159974339060.129227.10384464703530448748.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 13:03:03 -0700
Message-ID: <CAEf4BzZ-K7Myp7_2a==ic5y+TRCFL4Gf4gGWwqm8yAb0icOi5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/9] bpf: change logging calls from verbose()
 to bpf_log() and use log pointer
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> In preparation for moving code around, change a bunch of references to
> env->log (and the verbose() logging helper) to use bpf_log() and a direct
> pointer to struct bpf_verifier_log. While we're touching the function
> signature, mark the 'prog' argument to bpf_check_type_match() as const.
>
> Also enhance the bpf_verifier_log_needed() check to handle NULL pointers
> for the log struct so we can re-use the code with logging disabled.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Only 4 out of 9 emails arrived, can you please resubmit your entire
patch set again?

>  include/linux/bpf.h          |    2 +-
>  include/linux/bpf_verifier.h |    5 +++-
>  kernel/bpf/btf.c             |    6 +++--
>  kernel/bpf/verifier.c        |   48 +++++++++++++++++++++---------------=
------
>  4 files changed, 31 insertions(+), 30 deletions(-)
>

[...]
