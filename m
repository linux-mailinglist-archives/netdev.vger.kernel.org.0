Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53249691D
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiAVBM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiAVBM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:12:26 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8107EC06173B;
        Fri, 21 Jan 2022 17:12:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so10491193pja.2;
        Fri, 21 Jan 2022 17:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eF7l1EMItic8HXnzow8ikDlVmQVMga9j0gwwj6e0+xM=;
        b=dWpRwR6M3nZvqcY9+bWAl0nwignbdlGztsjsncKa4yrawHasah4JG1vHWpgpc/rfIf
         NMjQLSVdOjy4kb5OcH/y/+OsnyIo0uTAi3lDgS/if7CRQ+zH6OcCcsaiv18e/OD5SutY
         78P1Ta5IwKc9s1RLpiCcCO/UkiEyeKWnJuSPu5Ajzaz5saCA/cYFbfTv6X0HrmHJE3c1
         ZuKO0f4hsbVq9RV7UOrkD6Nr4rS2wISEsNB06o039rzlEJhMcB9tMc3r9A9CFVf4sTeL
         xTqUWse/LJaqp9KHIX8yXSi6geEnbSOkYHeVjZvQxTHHLXdjkXj3OQpGYmzSbvnD7x63
         X1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eF7l1EMItic8HXnzow8ikDlVmQVMga9j0gwwj6e0+xM=;
        b=aVEju8f+yAPnHgbJDEAWuuQSI3sDO8btYSSyFuZcFQNR/OcfO21tlPoiMzHR4/EQvs
         mp3nVnyZv9pj5JkKViaoVHRoTjWmWiZmfyjJpUZ76/zydmPHtGMTJZpL0iBzJFuRmfKp
         IkWyrkNpGXxdjg1PEDQt0OxL5tTWOI3XBWTl51+GD1gS36FrAZTDpOURRqN89wZf0wXm
         rOLczY1zATI1OazGODjsjT0QO1h9UyzaIz57hBMii6hdT1DSIVYgUpTzla6Q6pjuqjHD
         12VscRhbjdBHkdE6+mu2ZEddkYqkCh+htonFNHVnAo58bukEb76LA4YyPV86iVILqdVR
         QMrg==
X-Gm-Message-State: AOAM533M1OGYLoowz+6UbwyF8rFDe1OQVEmjTYnUqzBZGetdqpO/+UDv
        qh7oSSaoqHTSMm70oo87TCS1CyXeoC4AvLzyIXM=
X-Google-Smtp-Source: ABdhPJxBtkUY5VxHayzinqRPe3mhFLFzbt7okZ57+l7dRyZrjrNeGXiUfy7isgaQaCHYw7X9/d0Rlqcu76vMGjYx1kA=
X-Received: by 2002:a17:90a:c78b:: with SMTP id gn11mr3243207pjb.138.1642813945938;
 Fri, 21 Jan 2022 17:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
In-Reply-To: <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 17:12:14 -0800
Message-ID: <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
>
> In this way, we need to allocate rw_image here, and free it in
> bpf_jit_comp.c. This feels a little weird to me, but I guess that
> is still the cleanest solution for now.

You mean inside bpf_jit_binary_alloc?
That won't be arch independent.
It needs to be split into generic piece that stays in core.c
and callbacks like bpf_jit_fill_hole_t
or into multiple helpers with prep in-between.
Don't worry if all archs need to be touched.
