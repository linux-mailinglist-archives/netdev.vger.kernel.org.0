Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC5364D6C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbhDSWA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhDSWA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:00:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA20D613AA;
        Mon, 19 Apr 2021 22:00:26 +0000 (UTC)
Date:   Mon, 19 Apr 2021 18:00:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210419180024.02d53b91@gandalf.local.home>
In-Reply-To: <YH3tYorim6orajgT@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <YHh6YeOPh0HIlb3e@krava>
        <20210415141831.7b8fbe72@gandalf.local.home>
        <20210415142120.7427b4bd@gandalf.local.home>
        <YHi09yyqVEkZsn7p@krava>
        <20210415193032.34aec994@oasis.local.home>
        <YH3tYorim6orajgT@krava>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Apr 2021 22:51:46 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> now, it looks like the fgraph_ops entry callback does not have access
> to registers.. once we have that, we could store arguments for the exit
> callback and have all in place.. could this be added? ;-)

Sure. The only problem is that we need to do this carefully to not break
all the architectures that support function graph tracing.

For function tracing, I usually add "CONFIG_HAVE_..." configs that state if
the architecture supports some ftrace feature, and if it does it can use a
different callback prototype. But it does get messy.

Ideally, I would love to go and update all architectures to support all
features, but that requires understanding the assembly of all those
architectures :-p

To test that I don't break other archs, I usually just support x86_64 and
leave x86_32 behind. I mean, who cares about x86_32 anymore ;-)

-- Steve
