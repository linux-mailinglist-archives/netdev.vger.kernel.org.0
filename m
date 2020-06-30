Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF92D20EC00
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgF3Dbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgF3Dbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:31:44 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90570C061755;
        Mon, 29 Jun 2020 20:31:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z2so14593407qts.5;
        Mon, 29 Jun 2020 20:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5v2qbSgvYFYLL4nXDhogeZKd+1461LNxvZOE6jg3PCs=;
        b=QxJ98V3GBzeDpSYq5LUJGDXiN7jCXibwwMESDNYez7oBJkc0Bor+ecU8LeUM1Hs3jJ
         EkZ0oInYqiaQyxnxOUpNsNLMpvb35sD0Ci5ATzYsGaQfuAzzD1d4CVY+qbb/975gmCi1
         3VdsQnn7WmYUDXu40wJUosjFT5h8NSKwpwBhR0IfcHMXo9Itz7/ARxHDCE0Dodqw2wxQ
         pbHJtBW3Ys8dHBKL/DaApzFI9i2NPHlrjC3IA3uHW2YHvhhYudnRe2gV7hLpvSiFUb4c
         g8aVZM62Z32yeLhdefUANZTHzMRuAtE5ULZmHgDoLgK3YvsPAlu6pwY+s1f2gkD5jfoY
         iusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5v2qbSgvYFYLL4nXDhogeZKd+1461LNxvZOE6jg3PCs=;
        b=LDjdRCyZgrpiX94zNq37C+n0f6WUOM4EiG8e8vOVbLIqSoJABR2h/1s9MY8K6x7F5q
         jWgZoJymgaIRWFodcls0akIY8pZphxekwuy7g4gnD5HmZRA6UviLmWdTQ+Yjjiwbm0ga
         wHmnFDl2Pds8JYA4HCTI0JWc3NVTsxpQFkWB2Qeg3gmMSMOOpa716XV6lLCY1ThH4aaN
         P+PdbNQYO0QvIPc/CpzAKfn9GLkVUeAJ02+jrV6CrQ31U4PNsHbhaDxWdNBpOe2dOtQP
         znXg+rfWjhZ1klnFvjS6Rq/WiQXZBSfHjtr+0exIneNDQeK3SKOyhCohg73BQ9PCSj5J
         oHKw==
X-Gm-Message-State: AOAM532Q2PNwDUy4QD7dN+8ZzyMxIRIdzYo9prTLA0vHXAcQrv6sVLvT
        GVbWVdBr69DxFqom8VftxeRlGhmuyYwaiEUKtlU=
X-Google-Smtp-Source: ABdhPJw0KNjTZEZnsb2ejWJxWQi/vGZNRBiFNuvycwFnIjTcXMpEvDwpZ6r+DpoSbEP1ra2Jc1k6MfWKxUw2kFu0NGs=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr14640168qtk.117.1593487903781;
 Mon, 29 Jun 2020 20:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-2-alexei.starovoitov@gmail.com> <CAEf4BzaLJ619mcN9pBQkupkJOcFfXWiuM8oy0Qjezy65Rpd_vA@mail.gmail.com>
 <CAEf4BzZ4oEbONjbW5D5rngeiuT-BzREMKBz9H_=gzfdvBbvMOQ@mail.gmail.com> <20200630025613.scvhmqootlnxp7sx@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200630025613.scvhmqootlnxp7sx@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 20:31:32 -0700
Message-ID: <CAEf4BzYjFUJq9ODZgHx6XpoE7JXGrkKqMpaARs7wshxCrU0daw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 7:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 06:08:48PM -0700, Andrii Nakryiko wrote:
> > On Mon, Jun 29, 2020 at 5:58 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
> > > > bpf_free_used_maps() is called after bpf prog is no longer executing:
> > > > bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
> > > > Hence there is no need to call synchronize_rcu() to protect map elements.
> > > >
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > ---
> > >
> > > Seems correct. And nice that maps don't have to care about this anymore.
> > >
> >
> > Actually, what about the map-in-map case?
> >
> > What if you had an array-of-maps with an inner map element. It is the
> > last reference to that map. Now you have two BPF prog executions in
> > parallel. One looked up that inner map and is updating it at the
> > moment. Another execution at the same time deletes that map. That
> > deletion will call bpf_map_put(), which without synchronize_rcu() will
> > free memory. All the while the former BPF program execution is still
> > working with that map.
>
> The delete of that inner map can only be done via sys_bpf() and there
> we do maybe_wait_bpf_programs() exactly to avoid this kind of problems.
> It's also necessary for user space. When the user is doing map_update/delete
> of inner map as soon as syscall returns the user can process
> old map with guarantees that no bpf prog is touching inner map.

Ah, that's what I missed. I also constantly forget that map-in-map
can't be updated from BPF side. Thanks!
