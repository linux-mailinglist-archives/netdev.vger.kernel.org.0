Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314A41F6B2
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbhJAVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJAVNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 17:13:07 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F6CC061775;
        Fri,  1 Oct 2021 14:11:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w10so708658ybt.4;
        Fri, 01 Oct 2021 14:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3yfhqZ/Mjyf8OC/wI8DwsxQR5u/fHsK+l/xaemDGgI=;
        b=VsP5KSRLrlYgAzBYu4kiABKXeL2WL16uLDrOUSKRWSsdnYGLbcri3n2QuEPN1edYkN
         PHrAmumjbDzGhvhx2D91/2BWiEQRMFtx5R8oNGrAoATcC0JXUt4mlRtw4GpC4o9UfuLS
         qJq4gmzyAjMHcfFv6TWshPyY9VXD5KkqsHm0UsRXUx/bmlSGwWpwRBRHlv3zhOqaGBQl
         CnaIxO88Vxqpse6E05KLcxZCi8NCEIRMcoQ7LogHbBUao1E2qfaDWhOEQsubeVvocayA
         5O7KVezk7oJQj3mNflZKBOlKP/YU4DoE645yk+OO+L8OeXmOz1OEoH4lEXZ4OiVeC/gR
         Zj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3yfhqZ/Mjyf8OC/wI8DwsxQR5u/fHsK+l/xaemDGgI=;
        b=X3TPW3sJZNbGOX2wrHCllUi9M3ZMpLknhBH2Kf2/7LKnveQIynizPr+cOGu9n258Wl
         0hCLz22BiznTuuqu2o8cVkL+8alA5hIMRZVSe/uzQupqdyFf54W9A961+DHbS2Bhu1G8
         v48CwMLH4qatsM1PlQoT5xZ17Wvj29MeJ4Nm/TY4xDj1IwHRaqg9Ta3ZeaAWg0q2j/oI
         seOYl7ZFgIbXarFyA7XLWnSv70vdYb7hRzIYpyiL2sZQLKcGJFim+0iZdxxVkatefeBJ
         OLTWUSKIWJdkUPX5QMUXx3D3am5fk87S8tskXYK49/56OshtqCYx326SUziRrgkbuRjY
         Wqdg==
X-Gm-Message-State: AOAM5337XWTASceq0NfxsbFlWHBAf9MpDqjfF9TowLgBC+5T/tc8I8YO
        LbuuQVgTUE0U/SWfg1tFGL7RBJLQ1hYvyH9GWoA=
X-Google-Smtp-Source: ABdhPJzH4NUCEqCDhQVR77hGxErEWNi4knNmsFNyEKxKA+P/MTEivb8e0A0BfMEGbm+cnH3Hi1QJsiY0S85eJjr0NwE=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr20911ybc.225.1633122681997;
 Fri, 01 Oct 2021 14:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210930062948.1843919-1-memxor@gmail.com> <20210930062948.1843919-5-memxor@gmail.com>
In-Reply-To: <20210930062948.1843919-5-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 14:11:11 -0700
Message-ID: <CAEf4BzbQ9FrUA1+5-dhg8Qd--XZYiSYXjMVEZAVh6Smj05vX6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 4/9] tools: Allow specifying base BTF file in resolve_btfids
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:30 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commits allows specifying the base BTF for resolving btf id
> lists/sets during link time in the resolve_btfids tool. The base BTF is
> set to NULL if no path is passed. This allows resolving BTF ids for
> module kernel objects.
>
> Also, drop the --no-fail option, as it is only used in case .BTF_ids
> section is not present, instead make no-fail the default mode. The long
> option name is same as that of pahole.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/resolve_btfids/main.c      | 28 +++++++++++++++++++---------
>  tools/testing/selftests/bpf/Makefile |  2 +-
>  2 files changed, 20 insertions(+), 10 deletions(-)
>

[...]
