Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7734BBA5
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 10:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhC1ILh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 04:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhC1ILF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 04:11:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB83C061762;
        Sun, 28 Mar 2021 01:11:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c204so7843990pfc.4;
        Sun, 28 Mar 2021 01:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1XdXQKnDghpTP9/KuIBNLvBqdWivOptTKhhbKCDsWIs=;
        b=BH8FWnR0B3WVQoG8ayN2b+US8Fy2kGqGo/VjmZHcZfM4zwCMsDebfNl6zPlfpDP7aU
         IXdDaYA3y3cFKVRk9TRy+GkRWHtSMnwYpHgKUkhYemneQJZW0TkjMwRVggxatkAw3rSg
         3ZILefa4/GcdSdMQ7mQJ4Ae5s5i8f7Xb2HBw8+PAIFQjsYEjF8+O73m/0L389dj4zHtb
         TfE/1KAFOi+YPMOv2F75Nrgq/h/HWgp7BPTzhvrD7fUmhLE0lcJ8r+zEi6/5jxQEjf4k
         Cj8dsw+4TlLvNVGw2IdXQvEhwxRLNXVqfLpLDzxgP35Kise2WSTuOLRKspB9chz6VTja
         eKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1XdXQKnDghpTP9/KuIBNLvBqdWivOptTKhhbKCDsWIs=;
        b=cFqEHhjDJsnjQXuF6aLYQSJ2WUa30gPKuw2OImG6BnwTSkycwa44WwtPKB9t2elZt1
         IlJTiUHn2GpsiAyKty2GXXyu4cjjXHfANcHP1VFiB0vU39ZmVtWynuEhz/2ULdD6fAJl
         w31Ne0j7dPDFFbsJMojXr3uAsB0qpkl928EhO95iNt9AGfpj6pAIxDhOivl+2t3NnWli
         yjsTzCXLzEsg6FQPAFVCmHgU5i3b8eP78U+EN8gWnjnar7yYz710tg5k67UPsUM/jGnW
         53eX7MUifUcsKfU3ONAsSffQ4D9ctq4cEPvSPKQvSYpsokJfaYGXE1utLFcYNzXJNSxm
         wtIg==
X-Gm-Message-State: AOAM532MDcjeCoidk/SqOrRe8GAI/lNva/jM1hikccC/YwOsdN7+aGNc
        TRru37u2TSjgxxQwy0RZnCc=
X-Google-Smtp-Source: ABdhPJy68PHbCVfGKlMGV3zTiAH7e8wgoAIgOSdv+k4EK0oMeBGyyfP8Kuf7LK1qRBzd5J4gr3IPsQ==
X-Received: by 2002:a63:3189:: with SMTP id x131mr19282394pgx.430.1616919064473;
        Sun, 28 Mar 2021 01:11:04 -0700 (PDT)
Received: from localhost ([112.79.247.28])
        by smtp.gmail.com with ESMTPSA id f20sm13850191pfa.10.2021.03.28.01.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 01:11:03 -0700 (PDT)
Date:   Sun, 28 Mar 2021 13:41:00 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210328080648.oorx2no2j6zslejk@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
> Is there some succinct but complete enough documentation/tutorial/etc
> that I can reasonably read to understand kernel APIs provided by TC
> (w.r.t. BPF, of course). I'm trying to wrap my head around this and
> whether API makes sense or not. Please share links, if you have some.
>

Hi Andrii,

Unfortunately for the kernel API part, I couldn't find any when I was working
on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
act_bpf.c) to grok anything I didn't understand. There's also similar code in
libnl (lib/route/{act,cls}.c).

Other than that, these resources were useful (perhaps you already went through
some/all of them):

https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
tc(8), and tc-bpf(8) man pages

I hope this is helpful!

--
Kartikeya
