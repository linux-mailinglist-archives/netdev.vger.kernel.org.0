Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C802039FB10
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFHPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhFHPox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:44:53 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE48C061574;
        Tue,  8 Jun 2021 08:42:46 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j20so3475305lfe.8;
        Tue, 08 Jun 2021 08:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eW7GIA410dvb9VGfgYzY3deYI5SVjwkRlVr8V/8j8VY=;
        b=H2PQ/HSWNcqYwwBN41hPBoncXvZyj2M1tGvG+fYBCHHhZErSL2vXbDyONO8BHzCZLP
         65/ZYqCY2dC984Ei1qmZ4kHEx+9g8yHoHZbylOWoDd+ixgycvlRdnVSO8Ba1GpAjEBur
         0hIjErUJwKFoCBm2TfuFV5nFAchvfOZcsnY4UHPbzJ+eFG5FaFLX8mYStf9xcB0H9lzJ
         JnqCd5NUAfuYxcCrovYlK5kg3A0tussKJlrp5LjSIJBmcj1aHbRH6/uX4JsGV9n58pAy
         6Lu156aTlmcpUyyPTolJPTtxNbDfaQmjw6I2JgfwJquVRIOC9KkHKea9I2TvAm5IlRom
         BciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eW7GIA410dvb9VGfgYzY3deYI5SVjwkRlVr8V/8j8VY=;
        b=ipmhBs4ZdVp80MNv8CwGTSIhq9qRdSUyqvE8DKavhtkcWRDE23IZZxK++qyutAKVYj
         Xp2Dpq1Mnj4Y2QIZnYcGR026CZRnjK4d/ImIOdBf5ydTfeAET073nMKqsnyHLCtBm8vk
         HqjQ67o1Nivq2yUpj+aNc09lNmvVCav/C0Ukl7ERHh8OIYzOVwdoG/IB1rn34Czp3/1d
         yTxwl9UHUWiHlUYzjof5nOB0ABdGTcWKyGe8Yhu99pXbEutNjyFvSzMzRHnW+fLHhxKu
         W3uVhff9BPcuzoDuDcJ3DptXlD4ZTGbg5cLnQxlkvFT6G3hDvABbu6VWKxL8tKneFBAf
         2OIA==
X-Gm-Message-State: AOAM531VS8NEnX2g04q6C7/GZnoV+E7kpHUwaRP0IFFsKF6bV/oZyPdt
        2p+vh+ES67i8MwN2mmJl90IajL4ouCS86PIssrc=
X-Google-Smtp-Source: ABdhPJxso7UHau01k1Ql2fwRgRR60HACufqnhqXsT/Fo5aqd6aP4uZYPrrkO8ZDwhuDkhguyj/VPFYtpE3f0QeKv0KQ=
X-Received: by 2002:a05:6512:3c91:: with SMTP id h17mr16282576lfv.214.1623166964418;
 Tue, 08 Jun 2021 08:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-14-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-14-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Jun 2021 08:42:32 -0700
Message-ID: <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to attach multiple functions to tracing program
> by using the link_create/link_update interface.
>
> Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> API, that define array of functions btf ids that will be attached
> to prog_fd.
>
> The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
>
> The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> link type, which creates separate bpf_trampoline and registers it
> as direct function for all specified btf ids.
>
> The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> standard trampolines, so all registered functions need to be free
> of direct functions, otherwise the link fails.

Overall the api makes sense to me.
The restriction of multi vs non-multi is too severe though.
The multi trampoline can serve normal fentry/fexit too.
If ip is moved to the end (instead of start) the trampoline
will be able to call into multi and normal fentry/fexit progs. Right?
