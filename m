Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CCC40726B
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 22:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhIJUWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 16:22:18 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:40585 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhIJUWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 16:22:10 -0400
Received: by mail-oi1-f179.google.com with SMTP id h133so4602205oib.7;
        Fri, 10 Sep 2021 13:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4IPxaQoHLBsI4TsWZBSz429Jh2IPs4Tsu9wpBitBgng=;
        b=RHaoRE+qDgYZPicCywIjXi43sTcHVLztXKuRhBqTKG/BC3AcU3T1OrRbsbchDZDH42
         qQDkjh6NdFxcOPdOkhKUyztQ7LAqL5c4wAeychuNyh7BIphBf6Uh7sdgOi6vp/32XXGb
         7XiEUztdTPfVfdZxT6e+BGsuwZ4vLBRUsFXtzKfFjnj/xiJK2WdT3QIJq7NSo/Cfn08l
         B6R0zrZCw+1G3nZRT9RcFkxXwuEsE2qI7pv8dasNw8D+q0EA+xN7BMiCZvTl+0MkdVF0
         h63WP8ufp5jj/Vvpq5MhXPhWhx3Jqd598XNIr0ufIKJo6hzZugdYA8IS1BwiF2rrSuyx
         EVDA==
X-Gm-Message-State: AOAM530MuR9lBAdZ75GkAgdwnu8Cu+xtRwYXoMF3cJWo/boXmyAt4kel
        nl+98UZs1SecqQhNZwgqsA==
X-Google-Smtp-Source: ABdhPJz5SQZueBteIwX5jHufIZZ/JozLZUCT7O2iJGriI7vlauYxJk6NPj/twUv+QLH5Q4gVPTAZyQ==
X-Received: by 2002:a05:6808:aa8:: with SMTP id r8mr5746125oij.171.1631305258063;
        Fri, 10 Sep 2021 13:20:58 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s24sm1483439otp.37.2021.09.10.13.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 13:20:57 -0700 (PDT)
Received: (nullmailer pid 3226408 invoked by uid 1000);
        Fri, 10 Sep 2021 20:20:55 -0000
Date:   Fri, 10 Sep 2021 15:20:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Keith Packard <keithpac@amazon.com>
Cc:     linux-kernel@vger.kernel.org, Abbott Liu <liuwenliang@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        bpf@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>, devicetree@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>, kvm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Manivannan Sadhasivam <mani@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Song Liu <songliubraving@fb.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        virtualization@lists.linux-foundation.org,
        "Wolfram Sang (Renesas)" <wsa+renesas@sang-engineering.com>,
        YiFei Zhu <yifeifz2@illinois.edu>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 4/7] Make sure task_struct is available for
 raw_smp_processor_id
Message-ID: <YTu+JyNyQH7v+1Yx@robh.at.kernel.org>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
 <20210908190605.419064-5-keithpac@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908190605.419064-5-keithpac@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 12:06:02PM -0700, Keith Packard wrote:
> To allow architectures to use the 'cpu' field in task_struct for cpu
> identification, the task_struct must be visible whereever the
> raw_smp_processor_id macro is used. It would be simplest to include
> linux/sched.h from the relevant asm/smp.h file, but that file is
> included from linux/sched.h, and the recursive include ends up with
> several declarations in the wrong order.
> 
> To avoid this, the PowerPC architecture code has this ugly hack:
> 
> 	#define raw_smp_processor_id() \
> 		(*(unsigned int *)((void *)current + _TASK_CPU))
> 
> As an alternative, placing includes of linux/sched.h in a few files
> that are used along with asm/smp.h means we can use the task_struct
> field directly.
> 
> Signed-off-by: Keith Packard <keithpac@amazon.com>
> ---
>  arch/arm/mm/proc-v7-bugs.c     | 1 +
>  drivers/vhost/vhost.c          | 1 +
>  drivers/vhost/vhost.h          | 1 +
>  include/asm-generic/irq_regs.h | 1 +
>  include/linux/of_address.h     | 1 +

Where does the DT code use raw_smp_processor_id()? The header itself 
certainly doesn't and the headers should only include what the headers 
use directly.

In general this seems pretty terrible pulling in all of sched.h (and 
then everything else it includes) for just raw_smp_processor_id().

>  include/linux/random.h         | 1 +
>  include/linux/topology.h       | 1 +
>  init/calibrate.c               | 1 +
>  kernel/bpf/bpf_lru_list.h      | 1 +
>  kernel/bpf/percpu_freelist.h   | 1 +
>  kernel/sched/cpuacct.c         | 2 +-
>  lib/irq_regs.c                 | 1 +
>  12 files changed, 12 insertions(+), 1 deletion(-)
