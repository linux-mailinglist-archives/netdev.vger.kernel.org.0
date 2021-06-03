Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672D939A114
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFCMfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:35:46 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]:44631 "EHLO
        mail-qv1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhFCMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 08:35:46 -0400
Received: by mail-qv1-f52.google.com with SMTP id a7so3047037qvf.11;
        Thu, 03 Jun 2021 05:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgzzzAH8mID5IX+kM+X46gD1kQssopr2KLjMaxfwAfQ=;
        b=pivw5khZunEhLNkShvJxudcY5u34StFUUUuBQ4dT2YRtoGk+ZajKR6j+GJC4EGvAjz
         GAFuhlfNMqLusSqUyju0h8thafVT7d3i/I9E+KmKBU5swJgPoufqlzG0KUset1zUCkHD
         fFlThKEJzjf/01c7z3kYemTUQq6xHkqXdEyIMg7+wGWO+1HbX8jcHdOrUKMmj3nVYO3b
         VswcQIfZ3bGibSi+Ck9fb8LVZF4gREFNaGZedkI6w5m6MCuG9yhnJ41e/Z3AcaulbdXy
         oKU1vlZpULNhX3sbH891/zGeSCGGPouyxdNkzVVXeIKop2MPowv87e+vBJxmdc/eCQjm
         l6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgzzzAH8mID5IX+kM+X46gD1kQssopr2KLjMaxfwAfQ=;
        b=i5oF0/UfpomqMAbnnSkYd+/MS6oBoLO7vcY6YhQfgstPbWnFUfnDlAbUNfe3DLhXr5
         ATtW7PTi6Oat/Z6BAzhUautMXkG9wLjOP39z86DeRixmrDBvM0Q8iI2mgayhwZUPKjtI
         ccxVTRzKFaJNkqHgLj6kSAPxp6S0Z1vt98GoI4enAaB3VNRWHzXhAmigM07a347lMAD3
         st0PkYhPLq6qALEXfkIochFJhhY/q1ADkUUyEBLPJzaqUlHfn9HaHKb5NigVSCC5pvTT
         WMcWr32NWl8pkRNXhPWiPzdI19QKpCY5x6xhRbbnglmFVm/5hYmyhQWnvgYLMHgGDapH
         FFBA==
X-Gm-Message-State: AOAM532MgbiwOQR7d1LTbfuHXoAztG5Q3YjrCvwUAumAqMm6kjG1R3JS
        11s7N6loYFLE6DyHCb6Hn8DwRKi+Jgqv6Ep0eg==
X-Google-Smtp-Source: ABdhPJwNPJrUuNg7AlPQ4HrNyA2pu83VdMWudd/dH0QdVuFb1BEOS/aHVdnAQMIz+r5TiO7abKEezeHlgQGJO327vXw=
X-Received: by 2002:a0c:fe6c:: with SMTP id b12mr33815218qvv.32.1622723566330;
 Thu, 03 Jun 2021 05:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
 <cc58c09e-bbb5-354a-2030-bf8ebb2adc86@iogearbox.net> <7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com>
 <CAHn8xckNt3smeQPi3dgq5i_3vP7KwU45pnP5OCF8nOV_QEdyMA@mail.gmail.com>
 <7c04eeea-22d3-c265-8e1e-b3f173f2179f@iogearbox.net> <705f90c3-b933-8863-2124-3fea7fdbd81a@arm.com>
In-Reply-To: <705f90c3-b933-8863-2124-3fea7fdbd81a@arm.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Thu, 3 Jun 2021 14:32:35 +0200
Message-ID: <CAHn8xc=1g8bzV-uxaJAYpJ114rR7MLzth=4jyDG329ZwEG+kpg@mail.gmail.com>
Subject: Re: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, jroedel@suse.de,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com, hch@lst.de,
        iommu@lists.linux-foundation.org, suravee.suthikulpanit@amd.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 2:49 PM Robin Murphy <robin.murphy@arm.com> wrote:
> >> Thanks for the quick response & patch. I tried it out and indeed it
> >> does solve the issue:
>
> Cool, thanks Jussi. May I infer a Tested-by tag from that?

Of course!

> Given that the race looks to have been pretty theoretical until now, I'm
> not convinced it's worth the bother of digging through the long history
> of default domain and DMA ops movement to figure where it started, much
> less attempt invasive backports. The flush queue change which made it
> apparent only landed in 5.13-rc1, so as long as we can get this in as a
> fix in the current cycle we should be golden - in the meantime, note
> that booting with "iommu.strict=0" should also restore the expected
> behaviour.
>
> FWIW I do still plan to resend the patch "properly" soon (in all honesty
> it wasn't even compile-tested!)

BTW, even with the patch there's quite a bit of spin lock contention
coming from ice_xmit_xdp_ring->dma_map_page_attrs->...->alloc_iova.
CPU load drops from 85% to 20% (~80Mpps, 64b UDP) when iommu is
disabled. Is this type of overhead to be expected?
