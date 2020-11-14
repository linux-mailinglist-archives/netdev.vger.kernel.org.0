Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4985C2B2E5C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 17:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgKNQHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 11:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgKNQHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 11:07:42 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CE5C0613D1;
        Sat, 14 Nov 2020 08:07:41 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so14645154ljk.1;
        Sat, 14 Nov 2020 08:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hePRxHDakR/FcZyNIlFOEo3Qbzz67PaHshF+EOjWLkA=;
        b=XXs7p+h1mogL2MliSrvN22602c6BFIY9gc8y8MWvJNn65MKIUaQdPcaqhg/Mzpmbkz
         z8VC9Rt1jDw4uIXxX03C8plIhpo6FXuK/fKB8CkwrhB1afyOM7Cu18npXrmOx9omImGa
         bxvv9QishP68DnAd3+oL4nNSC04Pbgq4p6WoYfJLaaQqR4l5tKdOheuW4lTuee1x3fUg
         LzSHWgW4dXu8pTWoZWcpjUdoRNeHIojC4KfeJKJJCIV0HqjR/FShSUvJV30zXS8QtPXS
         AroEsn/84teC1yzU477BkNEcbUshfeo1GNlYBiWcyhcPKlZiGzGx9czLGj+QGjG5Lx0p
         oXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hePRxHDakR/FcZyNIlFOEo3Qbzz67PaHshF+EOjWLkA=;
        b=SBML/JwTZpwKUPJzz0+kFLELQGeZaxM3dsH846XWeuvbOHFGxh/mfd/NF2lwaRk+OU
         U1tAbL6OyYC8d+/0szo93pp4y8aT7XsxYC0ogQHk2Nhm0yAOvVfqdbOOik1CsM1wjjhQ
         76e4trWk59PGwCRf/GcGu2hZpfXHfP6f5KWFDJCKif9AuVHZitpMpfAMURZKhYbQaLtO
         dLD+WKgYZkr8iAXbvclB8L9p2f3DJp0L+ciZ27UZApExU33N1z7nMNXVmhCm6wrxQUwp
         zpdaqHcPqS1XPVjUF+0L2B53468yPDJgyXDWVpV7HJw+06YIYPyQ3E/zp4M/GdzGSSwD
         SJrA==
X-Gm-Message-State: AOAM533vb2YSsuqAupRp3QW/ajF3LAwRWFzWiWp5nMhhmk4w4C1TVnme
        nogazvDDWgNJnF+iEpCmkCJ958uJWMHi1OjgtVI=
X-Google-Smtp-Source: ABdhPJzOHGxXwjEZqemBP3a+UVSh0Vab4/4cUDv/2CNW8VKwOJp8IhUlYjy+JRu1p/Bz41h96gfWfAyTlIcaUEhAgvo=
X-Received: by 2002:a05:651c:1205:: with SMTP id i5mr3254426lja.283.1605370060517;
 Sat, 14 Nov 2020 08:07:40 -0800 (PST)
MIME-Version: 1.0
References: <20201114135126.29462-1-dev@der-flo.net>
In-Reply-To: <20201114135126.29462-1-dev@der-flo.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 14 Nov 2020 08:07:29 -0800
Message-ID: <CAADnVQL4zBmS5Yo3skoA32YjFXz5qu0q9LuJ5Z-61EGwZzgD6Q@mail.gmail.com>
Subject: Re: [PATCH bpf,perf]] bpf,perf: return EOPNOTSUPP for attaching bpf
 handler on PERF_COUNT_SW_DUMMY
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 5:53 AM Florian Lehner <dev@der-flo.net> wrote:
>
> At the moment it is not possible to attach a bpf handler to a perf event
> of type PERF_TYPE_SOFTWARE with a configuration of PERF_COUNT_SW_DUMMY.

It is possible or it is not possible?

Such "commit log as an abstract statement" patches are a mystery to a reader.
Please explain what problem you're trying to solve and how it's being addressed.

> Signed-off-by: Florian Lehner <dev@der-flo.net>
> ---
>  kernel/events/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index da467e1dd49a..4e8846b7ceda 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -9668,6 +9668,10 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
>         if (event->prog)
>                 return -EEXIST;
>
> +       if (event->attr.type == PERF_TYPE_SOFTWARE &&
> +           event->attr.config == PERF_COUNT_SW_DUMMY)
> +               return -EOPNOTSUPP;

Is it a fix or a feature?
If it is a fix please add 'Fixes:' tag.
