Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F622B7450
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKRCp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKRCp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:45:59 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F0C0613D4;
        Tue, 17 Nov 2020 18:45:57 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o144so256678ybg.7;
        Tue, 17 Nov 2020 18:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctzLO7RF9R+R6bTNF1JmUiOWUerFkh9IT+Pm9FRZnFU=;
        b=Ou5PCzWuq7zFcl0mKhzZT65Spu60KPFd5pxQaDMZ5HUdC7PFd6o3d9ED9BO8NX9zDF
         3Akc5X6QIZVxbgwFjfxmM/jXF4AYS4nwD5bN1GUlkTlSKkj4plEzVPHjWQlSuKdGZauT
         D9aBSTMRGMSYvvMvdZRNp49SOpA3WpqknFdZYfNQK/6gtvCKJeaOY6QT4PtxUn+gJMLN
         fXrnp2W7Y49NGFsPnBMf+oMUVqLpB9alFz5imGVBVrCB6sIsAofQssdpSSo6R2FTjog0
         IK5cAUuj0DSFroLu8Gj6TrBWXg5hbZPh/khVT8oGDeMl4kgnp7uKFFAJyItZYgs988Ho
         KRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctzLO7RF9R+R6bTNF1JmUiOWUerFkh9IT+Pm9FRZnFU=;
        b=SpJV9Af1ffoMYhNPE12e1eqLriPkQqkviC2A0uwAcZLI+fzQ/0NAVoddJNosTVbK6P
         Q56IPbfX+cwPPXO4gmjoedMTqrvDYqvd41tl6OpnONlZuwZPP6D5gVQLfbypNCfi5j3X
         +hHdxGEa14JCRVU8aMHWQb25IBZXcDAnASUNnTviduZcqpfFnl/uIdW1DqrU8EDOwZq5
         vsKjNjczy8ljDbm3CfGbRHnZxpExhMyq9VRCuZT+DIsPx2DDJmonpK35sMzi9xBGxsAL
         r0ygy6Vh/P0lGkbSyP+szFdnEiymH2QDqYWYO2oFpDPIrEM5r/dXAhy0Td4tMSKIsVTc
         U9Dg==
X-Gm-Message-State: AOAM531hFexcWdfcn4AZ8B0rjrBSNwUsWYonfypAyEU2Jhu5tMGB7Bjw
        KlpKvb5EIotsfTaNHymseZQkG4UOwOsd76UfnfI=
X-Google-Smtp-Source: ABdhPJyA/Dq30agoFur2L6zlv7I9lxHuKLHSgy8MIeBAuqLcByBxHFU2LcMyugPk//IrsC6US4cJM+bKjMUD1taZUjo=
X-Received: by 2002:a25:2845:: with SMTP id o66mr4543777ybo.260.1605667556679;
 Tue, 17 Nov 2020 18:45:56 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-7-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-7-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 18:45:45 -0800
Message-ID: <CAEf4BzaF9Uqfq1vQey6wBMjcfbg6aGUQfNk5Yj=vtzsfAb3WsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] samples: bpf: refactor test_overhead program
 with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit refactors the existing program with libbpf bpf loader.
> Since the kprobe, tracepoint and raw_tracepoint bpf program can be
> attached with single bpf_program__attach() interface, so the
> corresponding function of libbpf is used here.
>
> Rather than specifying the number of cpus inside the code, this commit
> uses the number of available cpus with _SC_NPROCESSORS_ONLN.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile             |  2 +-
>  samples/bpf/test_overhead_user.c | 82 +++++++++++++++++++++++---------
>  2 files changed, 60 insertions(+), 24 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]
