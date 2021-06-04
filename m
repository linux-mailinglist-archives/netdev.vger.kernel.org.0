Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB46E39AF2E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 02:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFDArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 20:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDArb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 20:47:31 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD576C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 17:45:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t3so9155995edc.7
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 17:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3vjjDLlIJqGvVNPtCSVB+L9uu4EO5ioC0XeKkc2DZG8=;
        b=m/Bc0v4a3vx31SXIPLQY+/der2UgHk1qj1mRmPJ2JDutUeuSdrY57xD6JQ/J4Pat+A
         Uk73AtKtPcCep4qEwgnYCJx9BCOZ7gVsG7ocSZP+w34Tiql0p7K6DOHNe+mXb2HhTVo5
         hoVwEtjKTrwnmqug1my0TiTIxfIx07h8nVpI/wYeISqMUBwiGUFxNXypAM6g0hqvx8kw
         NgfLn09274WBKnd6zIJIKLklmXUbpABxWNg2ER6CTEcKMptkijNM3QFOlKL+XmdK//3M
         LvgPWJzF9umyNWBD9y79X8ooITx4xh/REkETYqNkCSJFPV6oYN3+NwJHuuGcFBBAze5x
         lA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vjjDLlIJqGvVNPtCSVB+L9uu4EO5ioC0XeKkc2DZG8=;
        b=tDOqAAZmruh5YSeQV/cBd8H9hq8mrwBJqNk4SC5wwdAwlMB/2uAppkwik/AFaIN9tQ
         9E0P1ebLuUTwRiphVq76giQgQuSMRY32mAkp/7ERRDHZD6/6PaMXegr0r9W/EvdvPCCG
         q6bElNcT7ZWyZPVktXcuwUBt2qPan9ujhny2r3yQmK3mnublSJjiNwMSyg19CNfrPe6r
         NTF7MY3lBZ6fx6o8sIq8CjFaeyMfTGWYhP6C/rbNrendLr7YMhpMMaOcaD1OEZtT/aLL
         ZCgHm0g1jDEkx//zNj8sMbzp0J2y4nnL8uIxInv0MWMhzhi49FeytvSYntKoY1eMkrOB
         p7Qw==
X-Gm-Message-State: AOAM533OK5p0Z0NDJyg5UdnLnUjdGRHZIjofSt/PNOwcimXCYwAAN7OU
        UAuD1zYXmsCuYjqu/0VOnfS2l6e01JA=
X-Google-Smtp-Source: ABdhPJxqgN4vZ/RIFQwR61sb+z5r2vA3PGr93gQC80moFl1fnbzFRBWzjwmCqjse031tAWHMCzjU+g==
X-Received: by 2002:aa7:cc9a:: with SMTP id p26mr2017929edt.74.1622767531385;
        Thu, 03 Jun 2021 17:45:31 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id n4sm2074334eja.121.2021.06.03.17.45.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 17:45:30 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id h8so7537518wrz.8
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 17:45:30 -0700 (PDT)
X-Received: by 2002:a5d:6209:: with SMTP id y9mr1046523wru.50.1622767529807;
 Thu, 03 Jun 2021 17:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
 <20210601221841.1251830-3-tannerlove.kernel@gmail.com> <20210603235612.kwoirxd2tixk7do4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210603235612.kwoirxd2tixk7do4@ast-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Jun 2021 20:44:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfXXQWi5GZQYN=E+qpaa7jPii1jgvJPeTSYuXOzZkQFog@mail.gmail.com>
Message-ID: <CA+FuTSfXXQWi5GZQYN=E+qpaa7jPii1jgvJPeTSYuXOzZkQFog@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 7:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 01, 2021 at 06:18:39PM -0400, Tanner Love wrote:
> > From: Tanner Love <tannerlove@google.com>
> >
> > Syzkaller bugs have resulted from loose specification of
> > virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
> > in virtio_net_hdr_to_skb to validate the vnet header and drop bad
> > input.
> >
> > The existing behavior of accepting these vnet headers is part of the
> > ABI.
>
> So ?
> It's ok to fix ABI when it's broken.
> The whole feature is a way to workaround broken ABI with additional
> BPF based validation.
> It's certainly a novel idea.
> I've never seen BPF being used to fix the kernel bugs.
> But I think the better way forward is to admit that vnet ABI is broken
> and fix it in the kernel with proper validation.
> BPF-based validation is a band-aid. The out of the box kernel will
> stay broken and syzbot will continue to crash it.

The intention is not to use this to avoid kernel fixes.

There are three parts:

1. is the ABI broken and can we simply drop certain weird packets?
2. will we accept an extra packet parsing stage in
virtio_net_hdr_to_skb to find all the culprits?
3. do we want to add yet another parser in C when this is exactly what
the BPF flow dissector does well?

The virtio_net_hdr interface is more permissive than I think it was
intended. But weird edge cases like protocol 0 do occur. So I believe
it is simply too late to drop everything that is not obviously
correct.

More problematic is that some of the gray area cases are non-trivial
and require protocol parsing. Do the packet headers match the gso
type? Are subtle variants like IPv6/TCP with extension headers
supported or not?

We have previously tried to add unconditional protocol parsing in
virtio_net_hdr_to_skb, but received pushback because this will cause
performance regressions, e.g., for vm-to-vm forwarding.

Combined, that's why I think BPF flow dissection is the right approach
here. It is optional, can be as pedantic as the admin wants / workload
allows (e.g., dropping UFO altogether) and ensures protocol parsing
itself is robust. Even if not enabled continuously, offers a quick way
to patch a vulnerability when it is discovered. This is the same
reasoning of the existing BPF flow dissector.

It is not intended as an alternative to subsequently fixing a bug in
the kernel path.
