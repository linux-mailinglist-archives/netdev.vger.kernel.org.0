Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75B41AB60
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbhI1JEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239811AbhI1JEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:04:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE5C061575
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 02:02:45 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g41so89432788lfv.1
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 02:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7U3IsLEhAc3NNtaNLa10p/PtnKwn/xh1zEIhY+LzfEA=;
        b=dNzmP4NyMAfWxCGEhizylDiPzAIzCTmhqiShkiKXJgrZ3q/H9iTJ0/pUBKJqL0YT6d
         N0HcZorSfa/mJNVynggLRO3SUvx2NavkpNErN1bGatyNjKkYOKrfeQu32iMcntTR46C2
         FCZBWQRKLAIh9iuigapYqphe6M2atqm14pKrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7U3IsLEhAc3NNtaNLa10p/PtnKwn/xh1zEIhY+LzfEA=;
        b=d3HEWtxSm8SFwY7NIQlXseYozjthMGsZQDehlwx6DBE2zobsID+XN9jatJw+5vS7a8
         AJb5FvpRImtLT3l9e9G57HJAvn1MhSGi00v0SM6JXAeze/o9LkRg8Vo841/oNUIa5RZy
         Be8visPEWsMh8ny9nEONS5w/xjACdd/5JpuObg24yZ7SwYJklQMysCc/8gpOywnfpCed
         ZzYmRWJLsAAZUHh/ibGizbDfnF7fCtC3k21TbvDAEkUE9lI3GkglgnoKx8Vax/8adm3A
         B+BGzRxHPytpAHCrhXf1mGmCQod6GYp7+ZJKSJY/YdKrMg6hyhSAsdU9nKDLqqbOWuq9
         Mfjg==
X-Gm-Message-State: AOAM5338LaF9DJHKDKXY56q789iRo/sIj+5Og9Gq0hRHDLbe1lrBuUX5
        jPsp83pESXl2/5MfI6lBcHoFHWkpuByVl0hq+RXBBA==
X-Google-Smtp-Source: ABdhPJx5RkqJDOvtlGGV9JWMT/j9vLa1fIA/m1rWaiEYqhbYBlW0S9sKbPqrl63MfTYo9lSubHtmPfGT0idO7fjqsGo=
X-Received: by 2002:a05:6512:76:: with SMTP id i22mr4455442lfo.39.1632819763475;
 Tue, 28 Sep 2021 02:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210924095542.33697-1-lmb@cloudflare.com> <20210924095542.33697-5-lmb@cloudflare.com>
 <a076398b-f1da-c939-3c71-ac157ad96939@iogearbox.net> <871r5aglsh.fsf@cloudflare.com>
In-Reply-To: <871r5aglsh.fsf@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 28 Sep 2021 10:02:32 +0100
Message-ID: <CACAyw99LePDKKaL4wqYdU7tqj0S5VSGyR_iiu++MhcX3CuQynw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] bpf: export bpf_jit_current
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Sept 2021 at 15:01, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> I find exposing stats via system configuration variables a bit
> unexpected. Not sure if there is any example today that we're following.
>
> Maybe an entry under /sys/kernel/debug would be a better fit?
>
> That way we don't have to commit to a sysctl that might go away if we
> start charging JIT allocs against memory cgroup quota.

I had a look around, there are no other obvious places in debugfs or
proc where we already have bpf info exposed. It currently all goes via
sysctl.

There are examples of readonly sysctls:
$ sudo find /proc/sys -perm 0444 | wc -l
90

There are no examples of sysctls with mode 0400 however:
$ sudo find /proc/sys -perm 0400 | wc -l
0

I find it kind of weird that the bpf sysctls are so tightly locked
down (CAP_SYS_ADMIN && root) even for reading. Maybe something I can
change?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
