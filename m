Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0121776D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgGGTBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGGTBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:01:24 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E316AC061755;
        Tue,  7 Jul 2020 12:01:23 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id a14so19327064qvq.6;
        Tue, 07 Jul 2020 12:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6MlKFZsb65XMk2FLiCoPqp4gBUptFzxLdjsvpN/u+Vk=;
        b=nzKY6J57O92oJYl79Kdvn7qhi9AhJWkhY+JZRi531jPTmHmRHaEdmZ4rQeSjWM0KQ4
         04CrgUD7FT6noHnW9KqnIApqRco9s4OGhvWaHatLMoNPo7mYgtA2Sp0MXo75Wnl6TIMh
         vuRVhMokQ+iUIBujlJmB9Po27v8+90xJynucfHlN/+g95xjV6K9jHWRv919SBu2lhEBn
         qc2FHyJaCa3jIT32cosjY3fo4DQud/2MsnZO2jxWLHdDnB+KEzh5BGLEgLh3uGLOhSTb
         KeSlcT1IkZ7DuxnvSJ/SIKLvwfUFBH8KOUtVsyYL292Ts+9AP8gNEE5HQ5BRmLzCT9xn
         ftWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MlKFZsb65XMk2FLiCoPqp4gBUptFzxLdjsvpN/u+Vk=;
        b=jPjmBdoY05ZDJINIq1U5AW7jaYpSAfyNFQmp2bGTlH+GAlBB81KAQKjecROGFi0yAZ
         yRFimjTRBClzEo1JiuzAEfHxTYv+0+0oXXZDOUUpxfxqfDf31t4zNc5RuTFn+zaEX9Q/
         d7FbeQqnmTNH1G3eZqrPENZ09tgXy8QwVsbLZAqr8313e63AxTa7r+vnF5IzFxjqn3fJ
         Gd0BRQ3uCwzUF+L4xFKYW2X9Z0Jp9ubhwSlAC1eKyntemFAITi1LXkmoKr/h++sSUHH6
         id+gNir36AmZmL8lYe2A05uF0TEqkkDj6v5LR2evSAtK2DI35euu1uLae9VFn2ECYXsR
         QuBQ==
X-Gm-Message-State: AOAM532ej2wxexejnuNJzhesLjqc2ONuF+BqwThh4A/MIyQdCfFe81JL
        +ADmiN1qC+YM/76L6m/w+4Zr+8+e9lwGvpvyCeg=
X-Google-Smtp-Source: ABdhPJwRkH2kVW1XXOL6S+lCsM2wXTLA0kUHZiHJZ6AQELbqcV22n6QQ+1vtluS6HtP8lIETbTcT00Rgeymhq0MvitQ=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr52879615qvb.196.1594148483169;
 Tue, 07 Jul 2020 12:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200707184855.30968-1-danieltimlee@gmail.com>
In-Reply-To: <20200707184855.30968-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 12:01:11 -0700
Message-ID: <CAEf4BzY1JQcq6LBpwjSi8XwK_7+ktwz53ZR4vk=imLQkZn1xXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/4] samples: bpf: refactor BPF map test with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 11:49 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> There have been many changes in how the current bpf program defines
> map. The development of libbbpf has led to the new method called
> BTF-defined map, which is a new way of defining BPF maps, and thus has
> a lot of differences from the existing MAP definition method.
>
> Although bpf_load was also internally using libbbpf, fragmentation in
> its implementation began to occur, such as using its own structure,
> bpf_load_map_def, to define the map.
>
> Therefore, in this patch set, map test programs, which are closely
> related to changes in the definition method of BPF map, were refactored
> with libbbpf.
>
> ---

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Changes in V2:
>  - instead of changing event from __x64_sys_connect to __sys_connect,
>  fetch and set register values directly
>  - fix wrong error check logic with bpf_program
>  - set numa_node 0 declaratively at map definition instead of setting it
>  from user-space
>  - static initialization of ARRAY_OF_MAPS element with '.values'
>
> Daniel T. Lee (4):
>   samples: bpf: fix bpf programs with kprobe/sys_connect event
>   samples: bpf: refactor BPF map in map test with libbpf
>   samples: bpf: refactor BPF map performance test with libbpf
>   selftests: bpf: remove unused bpf_map_def_legacy struct
>
>  samples/bpf/Makefile                     |   2 +-
>  samples/bpf/map_perf_test_kern.c         | 188 ++++++++++++-----------
>  samples/bpf/map_perf_test_user.c         | 164 +++++++++++++-------
>  samples/bpf/test_map_in_map_kern.c       |  94 ++++++------
>  samples/bpf/test_map_in_map_user.c       |  53 ++++++-
>  samples/bpf/test_probe_write_user_kern.c |   9 +-
>  tools/testing/selftests/bpf/bpf_legacy.h |  14 --
>  7 files changed, 305 insertions(+), 219 deletions(-)
>
> --
> 2.25.1
>
