Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D63A3C8C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFKHHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKHHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:07:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F312C061574;
        Fri, 11 Jun 2021 00:05:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h16so5177092pjv.2;
        Fri, 11 Jun 2021 00:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K6EWbdBAOzulK/Dcd8nCsMPpxQ85NMizCbZctaEs360=;
        b=m0s0C02Le100A4PatD5rxYr4dSMjmXE8b/appgTXCoq3XppCO4fgjAR0PGb1JTJtHd
         QJCs1pkWicr9tLBsnDzdFSFKMucW5t0Tqb8i4uIogYnomS0gVG1JvDlZaJccmbz+u5gG
         c6nyH0VnKHFawjzpdBRH4YPODsVKfh4seR8gASzGQRfQBy4Sd61poJ2gnzWl0/a14mMd
         OECua/fVJjotWcgRZWwdBdUj0ea2hdy7eiGhpL+SiOFwq/I8e/FWxQ/xH0/4CvoZLvB4
         LASgAcYIgPm53jkNjvT4zLExwxX5sbkwb/KHlcVEcyrUwKY6Op6Mq/nGwHdUG+X8zt2c
         jqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K6EWbdBAOzulK/Dcd8nCsMPpxQ85NMizCbZctaEs360=;
        b=Oe0M5nPMGeQ3fCzKMWcs5UH4rAhnpYrInWMhnsMjrmgm1Zqx8UhJ7COliV4RtTsh1j
         h6SIvDc+knllkZMY3rskv98QJxlcuYvPNCuODb0K406tWzvKk1whoipAB1q5D0SeSvdt
         vAuCuG7Ost6q98Ddv9USBxpamoWGm6ZpfUXI8DMDIGSGuoLPCOg6fSrH/D70sywIoS2E
         YUbgZf2xXhIE2weILZejkq6vtfCzGRq/oBLU7QXLuEmPKKg6KXNIksGrOYN5sdqed+IO
         CYUXp27mFQF0vqM3fxxEXnKF28P1uGMtxJsCRSRir9TuemT25Dy3xMAUG4+c9ZjdIuS3
         k70w==
X-Gm-Message-State: AOAM530mUm6cWJ4uue9dBfKmWmJc5kuiKAWetSV/jLnbSKzU/dscYGAC
        naZSxbnkPL/n/8Tmeal8Scx7uol/E565ilRXOH8=
X-Google-Smtp-Source: ABdhPJw/7eCgDTVvTRS2YHio28EO/TNuwNLQKnxPt5qhs1EXNAsQpwQHdytMJYxIMggvEz121Uoraxw/VkugZrzdjZ0=
X-Received: by 2002:a17:903:2281:b029:113:1edb:97d0 with SMTP id
 b1-20020a1709032281b02901131edb97d0mr2718643plh.64.1623395138622; Fri, 11 Jun
 2021 00:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com> <20210611042442.65444-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 11 Jun 2021 00:05:27 -0700
Message-ID: <CAM_iQpWh3AHNZ+J0Au7VqkJ9h4kgrLDop4asrofoCpzuBuJPkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 9:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> // Initialize the timer to call 'callback_fn' static function
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags);

Another unpopular point of view:

This init() is not suitable for bpf programs, because unlike kernel modules,
there is no init or exit functions for a bpf program. And timer init
is typically
called during module init.

(bpf spinlock is different, because it can be simply initialized as UNLOCKED.)
