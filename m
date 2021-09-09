Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D6404432
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 06:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbhIIEJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 00:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhIIEJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 00:09:49 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF559C061575;
        Wed,  8 Sep 2021 21:08:40 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id s16so1297008ybe.0;
        Wed, 08 Sep 2021 21:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LFpjdis30CrfV6CYD7+C3Vk9MnStwLqPIjH/k832Ps=;
        b=S74kTLRxpR+9692FZwYYXdNZGmNR3+dMbL3WIaBTZQJHMXZZcGXN6CYgNKBOoN4Vhy
         IsLHn71QbuYy2fzes528hvnpqkbwBOSX2YEeqpZm4BSQbxWBMzvzHPes8BMio/Gk1J6I
         uIe1F2j187uJJpn+avn7K3m66y64ISG4AsLWgePInjb7JamYuiQ58AX+y+rlhR2f4SAG
         poBpC6dF6npmmCduMpaIRU67N/HyelDAy59ypzMmgkcUz9lF8Yb4aWhKARAlx72CXTnX
         vBw6eGKXb4jYrE9Aoy5yILnKPvvSvf/yb1lK51YTUxNxQRbEKuuwzwFsmwZrqJvO6dEa
         hY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LFpjdis30CrfV6CYD7+C3Vk9MnStwLqPIjH/k832Ps=;
        b=0KLQFIE77pN6k/+v4/i0wojWew7D2bIbGA31wB4moR1UadYfH4SpoOBP4701fwedNq
         9kb03NMMfrxXuH6n5H0qey2oHiUEydEjPBX+9lCKDQYvZiYVBh0z1KhxiZ/OTl8dGTVQ
         W/X6DZb44cDmRLloRWgdvDAUksb96ZGuBZIMJlbH1ElOH6xDQkHUPECQtMHSrtIfthnB
         CbqEvp67aEvjeIZSFPsjc8haXPeSjaPIMTtGBPoGmhGGCnHwQueqBJTOl4WGzyjZUwmP
         N1zbWIywm3YUqlTBb2hthU4eqE1VUHNEfU7g/8a6w5AtPFktvc539CgfF1rO2Z6OtvJi
         poJA==
X-Gm-Message-State: AOAM533/9IJqFZWlMFSe/6DvISArFY1Vgjc44by/14jdBEPdV4r1hSia
        chU6yJW3Qu1/mEcDyk2nakLWVFDYTwUeYWt4ku4=
X-Google-Smtp-Source: ABdhPJycV1CQmjqroiBkj34HYdxRgWWHXI+QyNSewZLMyoKuioYXNk728hNJBA4+pTeLCuaXOov84FVSIL6SLN4Mvzc=
X-Received: by 2002:a25:824e:: with SMTP id d14mr1182740ybn.179.1631160520020;
 Wed, 08 Sep 2021 21:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210904001901.16771-1-vfedorenko@novek.ru> <20210907190952.o5xenqjdz3pspq74@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210907190952.o5xenqjdz3pspq74@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Sep 2021 21:08:28 -0700
Message-ID: <CAEf4Bzb-4KsA8Z7k8O+UNRerxO-phw_nGK-gyd2909Yw0ETrMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] add hwtstamp to __sk_buff
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Sep 04, 2021 at 03:18:59AM +0300, Vadim Fedorenko wrote:
> > This patch set adds hardware timestamps to __sk_buff. The first patch
> > implements feature, the second one adds a selftest.
> >
> > v1 -> v2:
> >
> > * Fixed bpf_skb_is_valid_access() to provide correct access to field
> > * Added explicit test to deny access to padding area
> > * Added verifier selftest to check for denied access to padding area
> Acked-by: Martin KaFai Lau <kafai@fb.com>

This patch set doesn't apply cleanly anymore ([0]). Please collect
Acks, rebase, and resubmit. Thanks!

  [0] https://github.com/kernel-patches/bpf/pull/1718#issuecomment-914717959
