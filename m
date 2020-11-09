Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2172AC2FF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgKIR6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbgKIR6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:58:42 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC26C0613CF;
        Mon,  9 Nov 2020 09:58:40 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id i186so9020645ybc.11;
        Mon, 09 Nov 2020 09:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ypr4Kuc9X8rFEI2EWRdGGaNl783YbOoeeQfMY7jHtgI=;
        b=SOA1Rhwu0dXIyRSvIu5iU3wrgAmvwrXvs3Bfx9DFGRjQOYi+m7nsiMy3s064GwOoPf
         rKrhT1sCYoFfMbpSEpdhNeBu57E4ckYqVeoMucHWhYigUsDKPOZDZEgjzHgRHUjIR/d+
         FV2CBdMwN4pMGbQ/prR05wR5rYrdGPm9O7PANyVX6xk7sKEEQTPDTPJe4u5f3m+IL3qE
         3NQCJZ5GaUOUEccU1hsUxuHZSggEmhTU/I9vQw3UE6HlHpD4h0446bdbVcHrP1hbeJFT
         uHl2RGa4GLtui214v0Rxz1l0F9Tgk5a+mKyhGkgzUS407d3IXkc4/X3bcyVmMXVvcYWC
         kp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ypr4Kuc9X8rFEI2EWRdGGaNl783YbOoeeQfMY7jHtgI=;
        b=MV4fwkJSyRRnzTtPvnebll4/xu+jL/8jQc0IEV4fTXXBraFWbNTDzT9IoRzOZTPWDK
         WpnEkRaQo+9EhNEui7qg3SnJwNWhfl8eviPkmm6qlJfe4+ymU3PH0Z6cPeEvibXRjUCn
         LKgfsor4gERFMLF+X/Wtl5HrnpjWTs6dQWtfQBW8BzBR0wz7jK9Q/FTxhFlv1izyY3/R
         i+OS5FLRIVqhGsLwcmHE7OQeNQkM78YyTa2lRFoqzz5Yd8iV5rUdHb4vTrdeXyhZLZNM
         /VYlUAl1nc9O12HuUi57iXGSgU6yKVelrquRwwcA1RiFeQAt1HQVjk6or9Ll/BdhcuxT
         Fchw==
X-Gm-Message-State: AOAM531Gvshffsmk0tjvxXWkA1ZP3d2XCoYxze5tu42m4/SCzlfhLZKo
        ceESh3FMz5thSjGpnsLakNBC9R29av9bgMRLv4MPChQKPIkctw==
X-Google-Smtp-Source: ABdhPJyA2HctkWbIVQauz5gXSOTiVM5JMnbtl4J1OlEsiI4u5mbTqDrcAeuRtHGnrqItJBz+XfqSC8n9zvzvTs/o3XY=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr21695549ybk.260.1604944719969;
 Mon, 09 Nov 2020 09:58:39 -0800 (PST)
MIME-Version: 1.0
References: <20201106055111.3972047-1-andrii@kernel.org> <20201106055111.3972047-6-andrii@kernel.org>
 <alpine.LRH.2.21.2011091633450.4154@localhost>
In-Reply-To: <alpine.LRH.2.21.2011091633450.4154@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 Nov 2020 09:58:28 -0800
Message-ID: <CAEf4BzaTyaD4Mz_tVc9WbP9Qv+oAmQNsG--OPwJCJf51xrFK7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] tools/bpftool: add support for in-kernel and
 named BTF in `btf show`
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 8:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Thu, 5 Nov 2020, Andrii Nakryiko wrote:
>
> > Display vmlinux BTF name and kernel module names when listing available BTFs
> > on the system.
> >
> > In human-readable output mode, module BTFs are reported with "name
> > [module-name]", while vmlinux BTF will be reported as "name [vmlinux]".
> > Square brackets are added by bpftool and follow kernel convention when
> > displaying modules in human-readable text outputs.
> >
>
> I had a go at testing this and all looks good, but I was curious
> if  "bpftool btf dump" is expected to work with module BTF? I see
> the various modules in /sys/kernel/btf, but if I run:
>
> # bpftool btf dump file /sys/kernel/btf/ixgbe

You need to specify vmlinux as a base BTF. There is a -B flag for
that, added in [0]. So just add -B /sys/kernel/btf/vmlinux. I think we
might want to teach bpftool to do this automatically if we see that
file points at module BTF in /sys/kernel/btf, as a convenience
feature.

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201105043402.2530976-12-andrii@kernel.org/


> Error: failed to load BTF from /sys/kernel/btf/ixgbe: Invalid argument
>
> ...while it still works for vmlinux:
>
> # bpftool btf dump file /sys/kernel/btf/vmlinux
> [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64
> encoding=(none)
> ...
>
> "bpftool btf show" works for ixgbe:
>
> # bpftool btf show|grep ixgbe
> 19: name [ixgbe]  size 182074B
>
> Is this perhaps not expected to work yet? (I updated pahole
> to the latest changes etc and BTF generation seemed to work
> fine for modules during kernel build).
>
> For the "bpftool btf show" functionality, feel free to add
>
> Tested-by: Alan Maguire <alan.maguire@oracle.com>

Ok, thanks.

>
> Thanks!
>
> Alan
