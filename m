Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F423E46E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHFXio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgHFXil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:38:41 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0BCC061574;
        Thu,  6 Aug 2020 16:38:40 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id i19so52335lfj.8;
        Thu, 06 Aug 2020 16:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OnX+S8e9CtdqQb27O1/ShAEDqRpxp8eT6nDYtjPBYJ0=;
        b=UwlCZ12Aa2r9XN5ht1C70xfMzC9+zIKKNjT6UEp3BDjvGflNg8QFqMq/5MKRFWetCb
         X8N+07RaSQpl1UE/C4xmU9c7lIQQ48gSQUpwhqCCJRGruEOvS5K4DP8HNFxl07PxzGW4
         CWW/zKnb+kj9a/iTC8wqdcVk3IYWwW2aKdRdyj0YqQIf5NwF8BueMOKqqATkD67EPcBW
         /rWxq9ti84BHmmZDKdPl+IKri+ropK0tX1T2f6e7H8CrRDHauaz73g4rWC0Lxei5tXKI
         m1jdTho6UdmjS2GM+k3z9YnQwLjWzv2kx+9HNxUxNTOXT0Kx9vj8SqUmrJ4Kp1+m7Wk/
         OdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OnX+S8e9CtdqQb27O1/ShAEDqRpxp8eT6nDYtjPBYJ0=;
        b=gf+qk2lfxFFtT42E9EwDnWQfwW41QIkvm+kVi4D9U8ovydEJ/zgoi4BqyUelHcGd4Z
         msJBQGlllRJqQ0HlHLEU1bvFl2sTypBSIa8mFBkZH2WSKr5J13r6DwbLPuCMC6nzlETH
         S8IgwBIvr+jlxTsj75xaeGAS4xA+nXdeNbZpgN6RGEPV7mV4KPFTj7QbT4ELmU9jxeUL
         CF2H0WzK4cEpubFpcuTM+Z9kxd7OuwGU7u5Y6pnPHgQvij3XSxqPE/OUpymliK970XDe
         P06739xEhPcEhpHuWfOthUzE5AFvHPP2bU0irz9RB1ggFrwfjTxZ0A3XxrdMkEeIoG0N
         tH7g==
X-Gm-Message-State: AOAM533cJhfPdEWB0W8ixFvxNep5XE1O/KpVCl1NjdRyc/CbNAtxezEG
        hHgYM59Atck9QaZH/XgFMIcRODNHvrgFAnOdAK0lqw==
X-Google-Smtp-Source: ABdhPJztYgRuihWNNi695LwHa2l3I/+05hzEwy2xOAE6XX0MnBzm7wpOPmT4Kmy9soq6OYH0RDJxiArnFE4nnsWBrZY=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr4977239lfs.8.1596757119303;
 Thu, 06 Aug 2020 16:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200805004757.2960750-1-andriin@fb.com> <5f2ba2b6a22ac_291f2b27e574e5b885@john-XPS-13-9370.notmuch>
In-Reply-To: <5f2ba2b6a22ac_291f2b27e574e5b885@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 16:38:27 -0700
Message-ID: <CAADnVQJPqWKS7-4f2G=-h2D1OwLZg1C1SRggXuYXg0rEg9JCBg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: prevent runqslower from racing on
 building bpftool
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 11:27 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > runqslower's Makefile is building/installing bpftool into
> > $(OUTPUT)/sbin/bpftool, which coincides with $(DEFAULT_BPFTOOL). In practice
> > this means that often when building selftests from scratch (after `make
> > clean`), selftests are racing with runqslower to simultaneously build bpftool
> > and one of the two processes fail due to file being busy. Prevent this race by
> > explicitly order-depending on $(BPFTOOL_DEFAULT).
> >
> > Fixes: a2c9652f751e ("selftests: Refactor build to remove tools/lib/bpf from include path")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
