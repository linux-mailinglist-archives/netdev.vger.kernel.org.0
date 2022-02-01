Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4134A58AF
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiBAIn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiBAInS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:43:18 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B3EC06173D;
        Tue,  1 Feb 2022 00:43:17 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v74so15243758pfc.1;
        Tue, 01 Feb 2022 00:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y2h1hzJ8oosH1T+OVnMREJPCQe4mb+AhZZLP9TvxW6I=;
        b=D5TTCpWgRvCSVrI/Az8MyU59WKp3Sih2WLEYwzyYUwu4la6YVL7muLHCc4cLUdrFTT
         OTQzcw8BWxS0XiP4FGvSh88DI3QRlgCUCRPO7icoq45+TrmLXXUwWP41/q5qRfUwW5rH
         uTpLjkX9IHh4Ghb0FR8w+iCkrNRwlTh/I4wueG/yvyk18HttcdxYa0BRvQmnhUQvkT5Z
         zdxpqRwW8VvblTCIajnJJCIzQUZY9iRifMYCyUCK877s2NpbMlQGsfgJV9+jYAHtWM7h
         UELXeC3I5st7yqxRlEgmB8d/LA0FJxApDSVh6YCw3PywYlV+FzyQQSpBW999qDxN5D+G
         wlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y2h1hzJ8oosH1T+OVnMREJPCQe4mb+AhZZLP9TvxW6I=;
        b=E+P97iurYwwjNnCk61Rpme1n2xXGjG8wmB3WAa0di5nRmxAF7tKm0tpIJL3kUKcmmZ
         XpJHYgp54nG77EUul1h8nxqrioP7k5ST+36WweYcx94pKDGTA4RQaj/vMrEPRHaYBCtO
         2A4f6rq5ZjVr3YkSU33mQ7yZcgH0ZYQCo0XrqqK2FI5vUz6slmdV6nRSorr5tTjsMGj7
         euudTttLpGt/rEGWybJQwiVwYzWJxof9m6eAGeXhbYAG/M5z3Jne/g10rTc0ngqxMmbo
         9bONC9sHRUpcHqMDMHx7b/dImiZVEEO2MJ6kjm85tY/F5pfppzRdIOHBBMK7h5CZcpZq
         ed9g==
X-Gm-Message-State: AOAM530buFpL5ZeOaf0yO99FRsWoK8Nj2zO+fH873GudTplIXDggxXOm
        wLPh3qbOFOgSwSlfMGFDk7w=
X-Google-Smtp-Source: ABdhPJyyOAAr6FPeUq2uGi2FkZMZMPJn4JEVm0V0qP9g//Qd50v93j2k9Jz20gMZejoh5F6i9knKeA==
X-Received: by 2002:a05:6a00:1508:: with SMTP id q8mr23837783pfu.3.1643704997406;
        Tue, 01 Feb 2022 00:43:17 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id i127sm5150608pfg.142.2022.02.01.00.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 00:43:16 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, houtao1@huawei.com,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize ring buffer size
Date:   Tue,  1 Feb 2022 16:43:13 +0800
Message-Id: <20220201084313.23395-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzYHggCfbSGb8autEDcHhZXabK-n36rggyjJeL0uLEr+DQ@mail.gmail.com>
References: <CAEf4BzYHggCfbSGb8autEDcHhZXabK-n36rggyjJeL0uLEr+DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

> >
> > 4096 is OK for x86-64, but for other archs with greater than 4KB
> > page size (e.g. 64KB under arm64), test_verifier for test case
> > "check valid spill/fill, ptr to mem" will fail, so just use
> > getpagesize() to initialize the ring buffer size. Do this for
> > test_progs as well.
> >
[...]

> > diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> > index 96060ff4ffc6..e192a9f16aea 100644
> > --- a/tools/testing/selftests/bpf/progs/ima.c
> > +++ b/tools/testing/selftests/bpf/progs/ima.c
> > @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
> >
> >  struct {
> >         __uint(type, BPF_MAP_TYPE_RINGBUF);
> > -       __uint(max_entries, 1 << 12);
> 
> Should we just bump it to 64/128/256KB instead? It's quite annoying to
> do a split open and then load just due to this...
>
Agreed.

> I'm also wondering if we should either teach kernel to round up to
> closes power-of-2 of page_size internally, or teach libbpf to do this
> for RINGBUF maps. Thoughts?
>
It seems that max_entries doesn't need to be page-aligned. For example
if max_entries is 4096 and page size is 65536, we can allocate a
65536-sized page and set rb->mask 4095 and it will work. The only
downside is 60KB memory is waster, but it is the implementation
details and can be improved if subpage mapping can be supported.

So how about removing the page-aligned restraint in kernel ?

Regards,
Tao
