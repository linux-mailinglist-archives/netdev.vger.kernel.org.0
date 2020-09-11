Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA223265624
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 02:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgIKAqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 20:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIKAqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 20:46:35 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95414C061573;
        Thu, 10 Sep 2020 17:46:34 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w3so10552033ljo.5;
        Thu, 10 Sep 2020 17:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Bntk5P8WQMO2ngB+gk8CfDkbfILL526E54cdytBuuM=;
        b=Z/Kd2S0bGVJCT2b6d+XnZvx2xXo/R4UV0vIO+6sqvDBt9VrbjYZSLMHUTObiltiggk
         tFhDluhJ25xBPonE+LEhZFiZgxPP9QGabpjtxcA4o6+dTetHBTe8W3zqacC8LOTAuKId
         SYG44SXBxe6q+yM23ujjLjOQtaLPH5hx8Nm7SU31e/CeuWqtDMTm/m72WHjivRWjXq4l
         1zFDUsNwkNX2SkVKuYUOvGV9hmimeXHIX1d+o7rPvj6l4MJmF2lEXYnJy9jf1dw4w4wu
         IH9IHmrLFqTtw03C4Inn6+4YsBF+OZs201VjPs78a8U43X4kLARM0asxp+iSuFQbxduu
         S39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Bntk5P8WQMO2ngB+gk8CfDkbfILL526E54cdytBuuM=;
        b=npCZvnqdv/B9mnkxTwaPfxiaT9bzi5eDKN/5TmvWQX2OO6ONeK/VEKh0M7Dd9g1BxY
         GMjPCVbII2nhB80soRsSMZM2uhxwS2dD2ESSsNtgGk7FKTI0zAUIcN9KqQ8M3gsIuIXZ
         OtXbw11RrbftemkbJpsdiMJS6IZP1T2R/nhHYret4H/p/NOHmdVirMW+QU98+C5RVRtB
         E41MbKD5a9MkUApPLdrb4hYJN8iSo1/fpP+0rF/v2MIgs9QFzltikfAAibkOzDkUvnlU
         tDL1aFgyXhiTJcTMn6HFrP11eoaDSmZNlakpoKA9VdkhZuQUNeAecw/NoPGH/O/83Cxv
         hCzA==
X-Gm-Message-State: AOAM5316YzRheYC6Scj6w68UiEuYY5UeYtz9hFCffxjRPEtNtXZVx7dd
        R5yoHb9C68MeUHu9M26rzDw9sTlDxfMYGPIjtfE=
X-Google-Smtp-Source: ABdhPJw7wsqTm/BvecjsHYjjhqZBVIDUkub9vuA1Pq/Y35F0U3uSqSpHXA+3i91UFn7mtaD8cEKDTac+B3SVo2mZDIE=
X-Received: by 2002:a2e:4554:: with SMTP id s81mr5995747lja.121.1599785192995;
 Thu, 10 Sep 2020 17:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200910122224.1683258-1-jolsa@kernel.org>
In-Reply-To: <20200910122224.1683258-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 17:46:21 -0700
Message-ID: <CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Check trampoline execution in
 d_path test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 5:22 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Some kernels builds might inline vfs_getattr call within
> fstat syscall code path, so fentry/vfs_getattr trampoline
> is not called.
>
> I'm not sure how to handle this in some generic way other
> than use some other function, but that might get inlined at
> some point as well.

It's great that we had the test and it failed.
Doing the test skipping will only hide the problem.
Please don't do it here and in the future.
Instead let's figure out the real solution.
Assuming that vfs_getattr was added to btf_allowlist_d_path
for a reason we have to make this introspection place
reliable regardless of compiler inlining decisions.
We can mark it as 'noinline', but that's undesirable.
I suggest we remove it from the allowlist and replace it with
security_inode_getattr.
I think that is a better long term fix.
While at it I would apply the same critical thinking to other
functions in the allowlist. They might suffer the same issue.
So s/vfs_truncate/security_path_truncate/ and so on?
Things won't work when CONFIG_SECURITY is off, but that is a rare kernel config?
Or add both security_* and vfs_* variants and switch tests to use security_* ?
but it feels fragile to allow inline-able funcs in allowlist.
