Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86383B3A28
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 02:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhFYA3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhFYA3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 20:29:53 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179A9C061756;
        Thu, 24 Jun 2021 17:27:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id k10so13315761lfv.13;
        Thu, 24 Jun 2021 17:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QkGCFslBFVEm4J7DpBVdsnseTugB0cOwDNm7cV2zBW0=;
        b=rJuTb2Bj4MaSE0spXSNP6lUBaC4itatlnuLFjKVcH6w7feh1vwKaEvzssnbkKxQYh/
         /dK2+nhp/wXoWHPTlgwUj+/nmIdwq1NQrJs8YJPECGNT/6PtpCyq/usEKcVX96n/liDP
         KmxleMYl/+GXPZNKc4qHBWN3QYNnp0W3sFrOV7/uONgbjvqySwtt3Yia7hmrYQdKITHl
         HJN3YOUQXIgnvw5Kfxev9gNHflCGOZCMoxEUm2UgIIo0c7zaXuattH1vr5hSjX5JYQup
         OKHRyy8lJB7wV2l83ud8q0od1gxaVGGmyyOJI0Q+O14Wsrn8eMUX8RJhJGNVvUJiQE3u
         1uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QkGCFslBFVEm4J7DpBVdsnseTugB0cOwDNm7cV2zBW0=;
        b=uod2S2vMhVFcnVz2qBIVI/IxNDgzux/vvn0VT/TeuVW0eTCPCoRCMgsYpioc90wA+u
         Q3rZJnf/dLXz0ghBL30ctc1ROfdRfYcO46PVz4uLxp251RVbSJNtoVfNhz4PnB0hQ//k
         MAAft0afK0QZK2jwO2qWItwlJyUP/s5KDwV7pF7F9KiuraJv4yUQTzf+60XbLYt4R/8L
         FN87NntDm+8O8ul5nCpGGiW+GneS340TPY3b3WAS5XiuvjEA3sEjiNkmnLPYXLRE0HB+
         bCG81m+n8BhtCkz+BLv3QVuSr5SsD0iwIucv8CC6ci2O8Ja0aYUg7F71tjsfq+mNyQdy
         SiYA==
X-Gm-Message-State: AOAM531TXcCUJhqjWSuwz8v8DigvNgglShq6EjrAPGRKe73IpVd+A0xK
        mGs9kaIdBD/sDl5YbTdLjFKv2Sn/ylqUb1r42lg=
X-Google-Smtp-Source: ABdhPJyviSFlWFHqasv17UScTMsfxi7ZruZxtI0tWDeJte1oxuzJA8SXIU2JpFZePfNXJdMAsyVw7ZEERdlWdFvqPic=
X-Received: by 2002:a05:6512:3e02:: with SMTP id i2mr5674462lfv.409.1624580851373;
 Thu, 24 Jun 2021 17:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com>
 <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
 <CANP3RGdrpb+KiD+a29zTSU3LKR8Qo6aFdo4QseRvPdNhZ_AOJw@mail.gmail.com>
 <CACAyw9948drqRE=0tC=5OrdX=nOVR3JSPScXrkdAv+kGD_P3ZA@mail.gmail.com>
 <CAHo-Oozra2ygb4qW6s8rsgZFmdr-gaQuGzREtXuZLwzzESCYNw@mail.gmail.com>
 <CACAyw98B=uCnDY1tTw5STLUgNKvJeksJjaKiGqasJEEVv99GqA@mail.gmail.com> <a703516a-1566-d5fe-cf4c-f2bb004a4f4e@iogearbox.net>
In-Reply-To: <a703516a-1566-d5fe-cf4c-f2bb004a4f4e@iogearbox.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 24 Jun 2021 17:27:20 -0700
Message-ID: <CAHo-OoxM25VzpHTQsY6sAoiAGDooROqaHrTX+n=PFO-TEA8mCw@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You're barking up the wrong tree. I don't object to reverting the
> > patch, you asked me for context and I gave it to you.
>
> +1, this kind of barking was unnecessary and inappropriate.
>
> I revamped the commit message a bit to have some more context for future
> reference when we need to get back on this.
>
> Anyway, applied.

Thank you for applying the change.

Sorry for the tone, but work has been particularly hectic these past
few quarters, with a constant onslaught of neverending deadlines...

The current kernel patch management system provides virtually no
feedback about (rejected) patches.
There is no email when a patch is rejected (and often even when
applied) and there is no notification of who did it or why.
It's very much like dealing with a faceless robot.

I'm stuck periodically refreshing a browser tab with
https://patchwork.kernel.org/project/netdevbpf/list/ and waiting on
patch state to change from new to accepted or 'changes requested'.  In
this particular case, there was no email feedback
from any maintainer, except for the patch going into 'changes
requested' state on patchworks, and the email thread (which only had
me and Lorenz participating) also didn't appear to have any reason in
it either....

As such, it was extremely unclear what was being asked of me.
It felt like I was simply being ignored.

- Maciej
