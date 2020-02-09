Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648B5156BC4
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 18:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgBIRSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 12:18:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38828 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgBIRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 12:18:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so4466391ljh.5
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iX/Cwymqqdc137iwGo9GrIAl1+HtFCOAKUHk7azo7/w=;
        b=sFUKdPO93vKYZEw/Ug0TorBuaULTB+Uw596VwGq84N61fjEmKVVtqeA1xgrFozmuU2
         t4Hr906mncO3lEM4knNauRFkz7lxi9OkRW8vMUA4xKmPmMqg8PIDYE8orwi/XEA5P0pz
         D70H67FMgivq0pq5Ra9CyBfYUfA4+HgOx8L1xi34ipbW+pkORxq4FAx6XUj4YwPmnfb5
         oDm4Fm8O9SmqRSwPTzoQQaYEMA3heSsqggV3Nnu63ZDv/SoBa13svFvS8d1MflbOg4ix
         5ff4rLLjpD3YlA5SkDC2t1QNgDcP3yNuOu3K8nq47bF2tsUKf6Il/Dka4R0t3M9kPHKd
         zRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iX/Cwymqqdc137iwGo9GrIAl1+HtFCOAKUHk7azo7/w=;
        b=SxN4uEgIRqarNzd683XNjDSn6vR9JKFNy75kXPrL3W3p7lNKu/odd/XDlkg1xFpqQ1
         AF/2Lwj11kLEeEfZchOJ+GdKC4J5SX09L1iq56RaO2NVnKu2H/Jg+eCsLO91+n8kc6/O
         d5V8Yuh0xWk2XwZ9+qoPncCtZExy0BcftoJ4/it/tLfdGC/uhX5M3Rg6mzdFFkOHYUWI
         Qh3w7254YTWidNgintVUOshq7DgDkg//57iSmS5t6GNdMi2xERND7rlAY03XGGqyDgu3
         mcZsoXPW0IACvvWbOuK/E7KbRiF8sR8t1qGMTLWYej4WLOnRPxJ0f3CanMFY+8tIyNzu
         HZWg==
X-Gm-Message-State: APjAAAX8GXio0jnzIUEoTVg3RW+rOs5n6jJpXgY+UV3YYxN1MrUcZuEb
        fTmspE4U8RPvlgTcWUyGZ3J+A8Zmdm1BxfKsiSP9gg==
X-Google-Smtp-Source: APXvYqyERfzIRnh/UXfObLOmFk7HYzVxiDdS8MmtBaFvyP0yHM3y5rLzZkIaO0+sLLsBQtyMm6TQpLy5ZjyByBduyOA=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr5307683lja.165.1581268708042;
 Sun, 09 Feb 2020 09:18:28 -0800 (PST)
MIME-Version: 1.0
References: <20191212013521.1689228-1-andriin@fb.com>
In-Reply-To: <20191212013521.1689228-1-andriin@fb.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 9 Feb 2020 22:48:16 +0530
Message-ID: <CA+G9fYtAQGwf=OoEvHwbJpitcfhpfhy-ar+6FRrWC_-ti7sUTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
To:     Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        ast@fb.com, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Leo Yan <leo.yan@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 at 07:05, Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set fixes perf_buffer__new() behavior on systems which have some of
> the CPUs offline/missing (due to difference between "possible" and "online"
> sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> perf_event only on CPUs present and online at the moment of perf_buffer
> creation. Without this logic, perf_buffer creation has no chances of
> succeeding on such systems, preventing valid and correct BPF applications from
> starting.
>
> Andrii Nakryiko (4):
>   libbpf: extract and generalize CPU mask parsing logic
>   selftests/bpf: add CPU mask parsing tests
>   libbpf: don't attach perf_buffer to offline/missing CPUs

perf build failed on stable-rc 5.5 branch.

libbpf.c: In function '__perf_buffer__new':
libbpf.c:6159:8: error: implicit declaration of function
'parse_cpu_mask_file'; did you mean 'parse_uint_from_file'?
[-Werror=implicit-function-declaration]
  err = parse_cpu_mask_file(online_cpus_file, &online, &n);
        ^~~~~~~~~~~~~~~~~~~
        parse_uint_from_file
libbpf.c:6159:8: error: nested extern declaration of
'parse_cpu_mask_file' [-Werror=nested-externs]

build log,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/11/console

-- 
Linaro LKFT
https://lkft.linaro.org
