Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B07F217BD6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgGGXnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbgGGXnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 19:43:12 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ABEC08C5DC
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 16:43:12 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id el4so15574555qvb.13
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 16:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cmWkChBOm7uv9Qi/VSd44MmxzAvZM2JfZ31Ol0Qkgio=;
        b=eGZxd2CqNjJdPxW4PKwiFIxZurR/YcgQXqMU8+nB1Fxuuc3jSMGNgEzCS8cyThyoN9
         u11t0mCBT/4fECQw4FgYUj+t8DhVCNQEDPMzi0s3qK6xBRPvDVNFmQHY6xkijPOYyYml
         IXGeyEpaA/IWjdBOy6q6LroMNvaHwpE3az92OP1AkohvyRiO000UEtPsPGBLGAE8kJXp
         ywHUtkpdhQ+bLvDu4pqmvyZiZTZdkQuaigL3ZF4uXyQfoIQputJER668xu87ATYw6VU6
         Bc/iD0Z9/26YjR1v08j/4uIzMMJ16utfeb9x/gazsHt011smfJe1eLyYVmJF8G5ZEPru
         6kTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cmWkChBOm7uv9Qi/VSd44MmxzAvZM2JfZ31Ol0Qkgio=;
        b=r7XP6XGKrEAtMQyIEwliefp5MW7WRH6LnFXS6XjuihcUijBcRJ+x0AyYDGLmar5gFI
         2oWFkcysRkJ94S4ko8r4mMVO50q7bBbxVoZzJHdaMTTBeakNXn7adTEf9ZQB+ZZCdDg1
         uEV10EBuRJpFCM7U0B9j6w+WTb4nfN1bOwP74uPfKF/tl4HhiCsRV9epk7wbTwOzWfd+
         Zf2q/YJ1MB1rAv/DXez205dtu3qwJWkEoj+ngjNai9r8FuyGh1TlJwCaReIWZXULjIlq
         2YJfRtiePOT2CgPfM234x/RivJ9xHHyehqEbHU3lIpv6qhmSajyB/B8mNE7rTQppNGgT
         YPXw==
X-Gm-Message-State: AOAM530ug1csmqrWBVRjTFMgY5E6Mtw8Kccsi7uHPr9i9vsVi3uIGhKe
        uiN8Y9uoo9yACQbVtEJlKcXvkzaYfxtbZp+Y+6hB6Q==
X-Google-Smtp-Source: ABdhPJwm2C8vpGh6FQWP03gIxcACOUzrhGSkRPB+m9AAnbpcIPqptbq1wZpWUf6SPPj39ug7cu+UVVw4KinEggudN8Q=
X-Received: by 2002:a05:6214:a43:: with SMTP id ee3mr52277095qvb.51.1594165391210;
 Tue, 07 Jul 2020 16:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com> <20200706230128.4073544-2-sdf@google.com>
 <CAEf4Bzb=vHUC2dgxNEE2fvCZrk9+crmZAp+6kb5U1wLF293cHQ@mail.gmail.com> <073ac0af-5de7-0a61-4e11-e4ca292f6456@iogearbox.net>
In-Reply-To: <073ac0af-5de7-0a61-4e11-e4ca292f6456@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 7 Jul 2020 16:43:00 -0700
Message-ID: <CAKH8qBujza3yn0+YXTV6zg7csWLUaA7RxEiompE5yz4QJsULoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 2:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/7/20 1:42 AM, Andrii Nakryiko wrote:
> > On Mon, Jul 6, 2020 at 4:02 PM Stanislav Fomichev <sdf@google.com> wrote:
> >>
> >> Implement BPF_CGROUP_INET_SOCK_RELEASE hook that triggers
> >> on inet socket release. It triggers only for userspace
> >> sockets, the same semantics as existing BPF_CGROUP_INET_SOCK_CREATE.
> >>
> >> The only questionable part here is the sock->sk check
> >> in the inet_release. Looking at the places where we
> >> do 'sock->sk = NULL', I don't understand how it can race
> >> with inet_release and why the check is there (it's been
> >> there since the initial git import). Otherwise, the
> >> change itself is pretty simple, we add a BPF hook
> >> to the inet_release and avoid calling it for kernel
> >> sockets.
> >>
> >> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> ---
> >>   include/linux/bpf-cgroup.h | 4 ++++
> >>   include/uapi/linux/bpf.h   | 1 +
> >>   kernel/bpf/syscall.c       | 3 +++
> >>   net/core/filter.c          | 1 +
> >>   net/ipv4/af_inet.c         | 3 +++
> >>   5 files changed, 12 insertions(+)
> >>
> >
> > Looks good overall, but I have no idea about sock->sk NULL case.
>
> +1, looks good & very useful hook. For the sock->sk NULL case here's a related
> discussion on why it's needed [0].
Thanks for the pointer! I'll resend a v5 with s/sock/sock_create/ you
mentioned and will clean up the commit description a bit.
