Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EBA1B91DB
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgDZQra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgDZQr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:47:29 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A2C061A0F;
        Sun, 26 Apr 2020 09:47:29 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so15011857lja.13;
        Sun, 26 Apr 2020 09:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XIkuGkmw9unvvxymgGhCNFr2UVR4Jh5aeD7lzIpidEw=;
        b=OM7T5Oc6RcvIDmJ0EmhtESuQbfEIF25wxn9f1W12Bqxo9LRUClCKN+3ac2TZ6J7Ll5
         4IjORngNdQ4LmV3JE9e7YgviJsb+JyZainh9S6pcSIo3/5rufbUD9/I7eZF5zpZW3JTn
         OPiL5U4+gKzeNw7LYJXULFiF1NOoEHjnGWVsDzbvhktbFMsOOvW9AfHNe166wu7VRoar
         AKdz7Bor33GWkksMaLvpnyO26ib0FVcX6dwhWbAZQVb781QAF6DJD/DMjuiC174DoHt0
         ge8V/h53Q0rwTNgSoP0cYOhyQlPHSUKh+6p+fm0AAwY+uAixbckhCOjdMKhSTtSQ7HyD
         OFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XIkuGkmw9unvvxymgGhCNFr2UVR4Jh5aeD7lzIpidEw=;
        b=miRfApw1YqBDUN5Q0hWpckHcV+eq2R9+WJHaJTluHJb5LP4RE445hQMD7uTO7/WHYl
         J+G06JA4F6djftqqgsU9Zsxbq+FFNxa42zDjNvfhb0Qgheqbpj4USUnA5MLw8AmvybPL
         1c1dtzpA0vC0XuSPo2LerQt1UnpZP/slMEVWHBqVxUCnnnIKpGcqiQVWDP/aKRJbuIPz
         d72q8PSL7A8xYLuMxGSiUYVXWMkZ87EIo1pVoD0JJqyGtlY5B6kcuVI/9R5I5KrNHcoQ
         X/iYEVUKL/nsRnbgP6Y7XiUqDTdbmFxhYh045q/j+7EFWaXpkfzdLzv0paAMsB6TyvT4
         axJw==
X-Gm-Message-State: AGi0PuY5CO+erhEWdk2TI+PAKUoM/TdegyUcS2nkmJvp6JbFTdqO/USD
        toQR/69Fxmw6LmCFSCgPQqAdIiXg3nKowDjwjJY=
X-Google-Smtp-Source: APiQypK7ydtH+WbSCc6iA/8pM6MH+ukVgQxtx61oskxMnJyaHkCliwaOwxdh4t/Lob99DzKljAWXWNB8/BA1nHquj1A=
X-Received: by 2002:a2e:7508:: with SMTP id q8mr11718876ljc.234.1587919647737;
 Sun, 26 Apr 2020 09:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200420202643.87198-1-zenczykowski@gmail.com> <20200426163125.rnxwntthcrx5qejf@ast-mbp>
In-Reply-To: <20200426163125.rnxwntthcrx5qejf@ast-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 26 Apr 2020 09:47:16 -0700
Message-ID: <CAADnVQ+FM2Rb2uHPMjXnSGmQo2WMfV7f_sikADHPhnHMq0aK9w@mail.gmail.com>
Subject: Re: [PATCH] net: bpf: add bpf_ktime_get_boot_ns()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 9:31 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 01:26:43PM -0700, Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > On a device like a cellphone which is constantly suspending
> > and resuming CLOCK_MONOTONIC is not particularly useful for
> > keeping track of or reacting to external network events.
> > Instead you want to use CLOCK_BOOTTIME.
> >
> > Hence add bpf_ktime_get_boot_ns() as a mirror of bpf_ktime_get_ns()
> > based around CLOCK_BOOTTIME instead of CLOCK_MONOTONIC.
> >
> > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ...
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 755867867e57..ec567d1e6fb9 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6009,6 +6009,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
> >               return &bpf_tail_call_proto;
> >       case BPF_FUNC_ktime_get_ns:
> >               return &bpf_ktime_get_ns_proto;
> > +     case BPF_FUNC_ktime_get_boot_ns:
> > +             return &bpf_ktime_get_boot_ns_proto;
> >       default:
> >               break;
> >       }
>
> That part got moved into kernel/bpf/helpers.c in the mean time.
> I fixed it up and applied. Thanks
>
> In the future please cc bpf@vger for all bpf related patches.

The order of comments for bpf_ktime_get_boot_ns
was also incorrect.
Most selftests were broken.
I fixed it up as well.
