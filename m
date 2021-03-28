Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994B534BEB9
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhC1UN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhC1UNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:13:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081BC061756;
        Sun, 28 Mar 2021 13:13:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y2so3396161plg.5;
        Sun, 28 Mar 2021 13:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CgTLBy83XAQ5YGxolLtMAOYutMwr/tnArHMqUuCN68=;
        b=qWT6BfyiVn82t3R06mstmgq5KU2HDaNOtQ8muPU7tmLPzRqD1wcalGfGUpwgg/K6C6
         L1TpC5l23ztXacaNZxYFqgAh3Zw2imSJEjxZ/Yt/EckJM061SSnosy9I96bfj18gktq5
         AeVAkg+3mCbhlDCh7b1xER0ZzgxrqOE3iril1g1FxAxN//vSdq0+5lJolfQogGyJeUGX
         SjWYY0YBG5NJtiTHkCwJ04RWgVHiZNqZSf/WdeD/z9UrUcC6FNnqhXwnYAm72MV1hSJl
         bgfcJQZPHDKcOafgPR7RopnuuIYq3ipbIdnyvQlHUZthyzN9JkqyUcNIzjlSoCo9ntAS
         9uFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CgTLBy83XAQ5YGxolLtMAOYutMwr/tnArHMqUuCN68=;
        b=VpfJ0cBLH40V1ea2ktGRGsoBXa3NbxJwOVCWd4ZHSfQWxKQGroAZBbOYWg+Kos0XmJ
         e9lWaHO3ojMxVFlPQ4ZFvHFmfp79X/zWtfagiDxQRi/Cs0QH3JQlXSetd1XQX8LbsA6X
         qdQMUFvk05JG8ASB9UNg3BQ1U4gB49gosLSNnX69G//1xLevEN1rS3x6rhVDT8v4kZMU
         qQPRRTwzVDlztZCbM8YzN7eXkSMTFMfjhbXO2dbRgzqfoK2zVRcWtgJbmaU2IpXJNEIC
         2N+NayClVwOLHS8v5w2TTfRiEz6zDLDHfADZ5gl5vhrZ8pSxplSLId6YQLVz9R/8qlmi
         5oVA==
X-Gm-Message-State: AOAM532gPeh+lkg5wIWCdV16VcD70vsw/YRfm7YWrI0zy4jw/XCVUGkz
        peSW7FA05pZ1gqQ9fDG0WCRjA/oIt4MvB8SRtIZ7MXrkw3A=
X-Google-Smtp-Source: ABdhPJwLgAPgQuLyNK7LLBX1uRS/TTCYG2e6+21C7FmyQ3KbY2wLphTVmoRC6YD3OK50n9cc90i0mrDdLRfNSXgRhRw=
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr23525928pjz.145.1616962426810;
 Sun, 28 Mar 2021 13:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com> <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
In-Reply-To: <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 28 Mar 2021 13:13:35 -0700
Message-ID: <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 3:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 27, 2021 at 3:08 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >   BTFIDS  vmlinux
> > FAILED unresolved symbol cubictcp_state
> > make: *** [Makefile:1199: vmlinux] Error 255
> >
> > I suspect it is related to the kernel config or linker version.
> >
> > # grep TCP_CONG .config
> > CONFIG_TCP_CONG_ADVANCED=y
> > CONFIG_TCP_CONG_BIC=m
> > CONFIG_TCP_CONG_CUBIC=y
> ..
> >
> > # pahole --version
> > v1.17
>
> That is the most likely reason.
> In lib/Kconfig.debug
> we have pahole >= 1.19 requirement for BTF in modules.
> Though your config has CUBIC=y I suspect something odd goes on.
> Could you please try the latest pahole 1.20 ?

Sure, I will give it a try tomorrow, I am not in control of the CI I ran.

Thanks.
