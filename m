Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622AE1D5452
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgEOPX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgEOPX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:23:28 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C5C061A0C;
        Fri, 15 May 2020 08:23:27 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 202so2153341lfe.5;
        Fri, 15 May 2020 08:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bff1oR7Blz+W07Q5eRGBsaMGsIsY+jlHF/RCiLOSS0w=;
        b=lVRokC6n8uO0fXOa8zPW46JgGJdFtIsg/pva7hwNdmo5Huui9+RdhbfKLAxVX4FoUo
         O3osYESImZrJxwYyypu0giiT0YM06414agSQed4WGUH7AYuvl6s96CPz+0lRpyTHEvMp
         mKzwYvSnK4x1ofOf/QGS8exDqt+jT7wlPUzb13SK2IIGO1ovj1ZmZdNzXwJj+NwhUaQe
         a94sIBaOp9v0KjvGZpTTAkQVUViOkD1tIdjfbItcymOv2ep97VYsS/Z9eWdxrWcSF9Uy
         bE5DgtGjvd+88XVIwYIJFZax6zV7Z8Lu6E6wKrq7YIy+zpiM0e7au2KjR6GyqRf4cK+6
         r/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bff1oR7Blz+W07Q5eRGBsaMGsIsY+jlHF/RCiLOSS0w=;
        b=qPYgtdPb6sTGaHljvtFJOWHzfSkaP/+T51SpUO/TwiTpk9UqjZfySX6LYzjk+oQeQL
         SD6TPGekSq8dP7aC6lNxHRanWWer7p1rrzxgGxuaAkE4R/CyzS1ILjupdg8KpTbVPBMU
         YeeACgfaRzjOdA0GBVByrDJWYE0M06t0S0PpKqDsqELlH4Gg3CWIbiGjMPaXdKipPLkG
         3HIF64mO0i8dNIcxd5t394bOKUpRDgHG0aFhvwNVQRYWw8ffP8T9qek2jR2ImkJrKu53
         2AVncFDPIYzkZWcaAzT0SgYm9Y8ixmtwYes5E6IqWYHwXpBIXOvBDGRT+jY5MNtpvf5A
         KuNg==
X-Gm-Message-State: AOAM530xDaq44Nz9nFrXL4gTuNg0eOEPGIYmkcGoRFcJ1LgsFfM3LQCv
        IJ1NictMz84pxS19SzXkjyw+DqAA1Cglptvw+rs=
X-Google-Smtp-Source: ABdhPJx5qSEJ89/33PTNCbpv2fCW+qgb+RKQjn+E8SFMrD8SZcg5cWrHCbvtfwhaF8dLr9meuhHTM9FhAQo/2Wqgufo=
X-Received: by 2002:ac2:442f:: with SMTP id w15mr2771584lfl.73.1589556205729;
 Fri, 15 May 2020 08:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200513075849.20868-1-daniel@iogearbox.net> <CAEf4BzYfgXSOPmi6B23=rKgUge77g+tg=jJ9jwgZ48Co1nSViA@mail.gmail.com>
 <20200515121235.GA7407@pc-9.home>
In-Reply-To: <20200515121235.GA7407@pc-9.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 15 May 2020 08:23:14 -0700
Message-ID: <CAADnVQLDfOHg1DT+JrUgiM6-Z2Ocrj8qf90_ViLVZXS5W3D8_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, bpftool: Allow probing for CONFIG_HZ from
 kernel config
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:12 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > libbpf supports kconfig values, so don't have to even probe for that,
> > it will just appear as a constant global variable:
> >
> > extern unsigned long CONFIG_HZ __kconfig;
> >
> > But I assume you want this for iproute2 case, which doesn't support
> > this, right? We really should try to make iproute2 just use libbpf as
>
> It's one but not the only reason. Our golang daemon picks up the json config
> from `bpftool feature -j` and based on that we decide which features our BPF
> datapath will have where the daemons needs to also adapt accordingly. So for
> users running older kernels we need fallback behavior in our daemon, for
> example, in case of missing LPM delete or get_next_key from syscall side the
> LPM map management and/or program regeneration will differ in the agent. In
> case of jiffies, it's also not as trivial from control plane side, e.g.
> existing deployments cannot simply switch from ktime to jiffies during upgrade
> while traffic is live in the datapath given this has upgrade and downgrade
> implications on timeouts. However, we can switch to using it for new deployments
> via helm. In that case, the agent today probes for availability, so it needs
> to know i) whether the underlying kernel supports jiffies64 helper, ii) it needs
> to know the kernel hz value in order to convert timeouts for our CT's GC. This
> is done based on bpftool feature -j from the agent's probe manager. Next, we
> also cannot assume general availability of an existing .config from distro side,
> so in that case we run the probe to determine kernel hz and emit the CONFIG_HZ
> define instead, and if all breaks down we fall back to using ktime in our data
> path. From the macro side, the timeouts all resolve nicely during compilation
> time since everything is passed as a constant here. We have a small helper for
> bpf_jiffies_to_sec() and bpf_sec_to_jiffies() that resolves it whereas `extern
> unsigned long CONFIG_HZ __kconfig` hapens at load time plus relies on the fact
> that config must be available, although the latter could probably be fixed via
> user-callback.

fair enough.
Applied to bpf-next. Thanks
