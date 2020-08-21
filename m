Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58A824E2B8
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHUVbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHUVbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:31:47 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B19BC061573;
        Fri, 21 Aug 2020 14:31:46 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id t6so3369602ljk.9;
        Fri, 21 Aug 2020 14:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZUr/GkYNW5/6BirLMXHGNGdzUx6hfASz9W4/WE4Qhk=;
        b=vFcLi8xa0U+sQw3m6NlrUAAuwlIiczp2JfAetCnZMqu6uGfKO00FoIgTD3nMM9RoRk
         fCvILlCTEHDZucf8v0FxGYYhWipEOxqBEmOIPSqse3jqSCybymmOXuuKMv1Mg+F33SDW
         WEnUWnY08mYCTg8kwt6wwSyWeXzbkm4kyZ8QMZZtPGzoy39s7U5psUvjYj6kmusEl12Z
         cwRquLCTvbPOlYt6sKSflVWM1mzCbXQ9K6Y8oBFjG5A/qhcL7YLiDqJwBSnGIRWRuNlN
         yoZp9SIclPINHqfbod6bvIh3y64+sNCprB+dbgOw73jrCdddOSSw9Q7fAhwzVYolLS8w
         QlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZUr/GkYNW5/6BirLMXHGNGdzUx6hfASz9W4/WE4Qhk=;
        b=N8nCbSPyXwpOLabyPOUS7U6D9YrG4J1o1a5uep6sVQ3L1Hi5xE0WoP94JZX/261lsk
         lkoW0QE9qA4Xi08MNk77O9k5un17cNPEso6qj0neThU0FtDciFYGih7AC4mrKC0FGnk2
         z+tU5cqJW36J/figVpExL6gHGDNqnGngSRgnPadCP/dhBx4txzziAqWofRbrzKNLQ2r1
         LIlCzmPC103hCNfl7LcjMoBUYGJC+7Ryw15I0CEXOtg5nbbRMN/xOfKeZtFvH1KQLiqY
         LwZ5nu5hrUklEqRP8fwCGX+1+KcziGcz30Sj3QTZLXidNPSQTj8APf2bl82BcF3PmjSD
         nvnQ==
X-Gm-Message-State: AOAM532V/LF9QEPHLolOkTyZfgquiWJfY87vaUCSiKSr/l/N9JSiQy3f
        BeXRzWJz33nY2NGX8gG11IYSlETG5iK8rbfaefE=
X-Google-Smtp-Source: ABdhPJzmFAT/wI2qQgZhH8Fe8pMKOY+MQjgip+6drw95aPi/LP8mFu5als1h8DowR1kfEADV6R4Mr/n+xlyb+l/5y30=
X-Received: by 2002:a05:651c:82:: with SMTP id 2mr2418463ljq.2.1598045504924;
 Fri, 21 Aug 2020 14:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200821165927.849538-1-andriin@fb.com>
In-Reply-To: <20200821165927.849538-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Aug 2020 14:31:33 -0700
Message-ID: <CAADnVQJBcUwMzSm7Bw=EW2cLsOcAu+yXrWqqV7zJBmWMmndNjw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: add perf_buffer APIs for better
 integration with outside epoll loop
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 10:06 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add a set of APIs to perf_buffer manage to allow applications to integrate
> perf buffer polling into existing epoll-based infrastructure. One example is
> applications using libevent already and wanting to plug perf_buffer polling,
> instead of relying on perf_buffer__poll() and waste an extra thread to do it.
> But perf_buffer is still extremely useful to set up and consume perf buffer
> rings even for such use cases.
>
> So to accomodate such new use cases, add three new APIs:
>   - perf_buffer__buffer_cnt() returns number of per-CPU buffers maintained by
>     given instance of perf_buffer manager;
>   - perf_buffer__buffer_fd() returns FD of perf_event corresponding to
>     a specified per-CPU buffer; this FD is then polled independently;
>   - perf_buffer__consume_buffer() consumes data from single per-CPU buffer,
>     identified by its slot index.
>
> To support a simpler, but less efficient, way to integrate perf_buffer into
> external polling logic, also expose underlying epoll FD through
> perf_buffer__epoll_fd() API. It will need to be followed by
> perf_buffer__poll(), wasting extra syscall, or perf_buffer__consume(), wasting
> CPU to iterate buffers with no data. But could be simpler and more convenient
> for some cases.
>
> These APIs allow for great flexiblity, but do not sacrifice general usability
> of perf_buffer.
>
> Also exercise and check new APIs in perf_buffer selftest.
>
> Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
