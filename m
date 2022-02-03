Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73724A82F9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbiBCLMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiBCLMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 06:12:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65F8C061714;
        Thu,  3 Feb 2022 03:12:50 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s6so1829820plg.12;
        Thu, 03 Feb 2022 03:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+e2MW7k4qouSFTjGEclNoWlA+kEa+5pUewqDJoHD/cA=;
        b=ZOdqAjBuQ8Pwt6A5stSd0U0/P5mzc0Spt8Ohj6IP1BeKaCAbLKMslqnGpineqZ2LKC
         RlvpWgrLxUvfZXh/IdzG71p432LCMOwRHa4BOv6EIt2B1iXVRTFGPs8fTTE6LF6Ri6gl
         RVRVZ6K2BAaFXJdiRpIUsyLCJ+0xYEZ3Tmnq94Hx2XimM6QLTtIHRCPFE09yU6qBMvZk
         WleglD5Pe5lhovCabJ9QaN1q2iTlP2VcuhKCqiUsGXeRt+L49vpJFi7C4iroQk/ZJOnv
         hO4K0cRlYKqqdpViNynH3e5m/O9afNMMtfK3df9pOal7XzRpatoyN3V4Gl3rP6Zj4N7V
         xQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+e2MW7k4qouSFTjGEclNoWlA+kEa+5pUewqDJoHD/cA=;
        b=obVpensvgEfRoIL9fXKTWp2Lof6SEZot0pJ5h1n87d1DyO8EJZjXGDRws/YcFSKAfO
         nSIszymvPyCMZEcBSzY2k7MYRPmJ2Vfj+cjxYur+UiMEiwvfOulxjAcRGXdBOubaauwe
         6Y563Z7TnG9Ksa21+C17ZkWV+n2/by+ulhhaxdMllzIZ36LWGNvvg+38H0uI50Rjf7i2
         KuDicKt6vV2K4KWdLxPyN92OBIgE/LWRyp1ITGW9iKopgkstX6Gekgq+CegZyrAHShh7
         fblkf2ylGspdQDmwgio7+WwNPks2fJuSik7SK4ZnBUlYsb/ACfz3hO2Lwy6yu+srhyvZ
         OqFA==
X-Gm-Message-State: AOAM533DVJkkRkdM6CX3CPRvCpW7MRxpphVV1cijAgtd/M2wgkK1lNjh
        cXNYZAP4Z9HF7wZKLQXNsJo=
X-Google-Smtp-Source: ABdhPJz2hXSFugNRnvvSdQlK8BJCj3vP05OYhll4dL9MlZY9efZR8vCWnSK8scj5D9cS1HuNGk2Www==
X-Received: by 2002:a17:902:b586:: with SMTP id a6mr11354969pls.150.1643886770406;
        Thu, 03 Feb 2022 03:12:50 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id j12sm26311567pgf.63.2022.02.03.03.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 03:12:49 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hotforest@gmail.com,
        houtao1@huawei.com, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize ring buffer size
Date:   Thu,  3 Feb 2022 19:12:45 +0800
Message-Id: <20220203111245.3495-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzY_BGV_8d8+gUMva6dpnHq=JSo8oU0p3tc_o=7ii2gU4A@mail.gmail.com>
References: <CAEf4BzY_BGV_8d8+gUMva6dpnHq=JSo8oU0p3tc_o=7ii2gU4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On Tue, Feb 1, 2022 at 6:36 PM Hou Tao <hotforest@gmail.com> wrote:
> >
> > Hi,
> >
> > > >
> > > > Hi Andrii,
> > > >
> > > > > >
> > > > > > 4096 is OK for x86-64, but for other archs with greater than 4KB
> > > > > > page size (e.g. 64KB under arm64), test_verifier for test case
> > > > > > "check valid spill/fill, ptr to mem" will fail, so just use
> > > > > > getpagesize() to initialize the ring buffer size. Do this for
> > > > > > test_progs as well.
> > > > > >
> > > > [...]
> > > >
> > > > > > diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> > > > > > index 96060ff4ffc6..e192a9f16aea 100644
> > > > > > --- a/tools/testing/selftests/bpf/progs/ima.c
> > > > > > +++ b/tools/testing/selftests/bpf/progs/ima.c
> > > > > > @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
> > > > > >
> > > > > >  struct {
> > > > > >         __uint(type, BPF_MAP_TYPE_RINGBUF);
> > > > > > -       __uint(max_entries, 1 << 12);
> > > > >
> > > > > Should we just bump it to 64/128/256KB instead? It's quite annoying to
> > > > > do a split open and then load just due to this...
> > > > >
> > > > Agreed.
> > > >
> > > > > I'm also wondering if we should either teach kernel to round up to
> > > > > closes power-of-2 of page_size internally, or teach libbpf to do this
> > > > > for RINGBUF maps. Thoughts?
> > > > >
[...]
> > >
> > > No, if you read BPF ringbuf code carefully you'll see that we map the
> > > entire ringbuf data twice in the memory (see [0] for lame ASCII
> > > diagram), so that records that are wrapped at the end of the ringbuf
> > > and go back to the start are still accessible as a linear array. It's
> > > a very important guarantee, so it has to be page size multiple. But
> > > auto-increasing it to the closest power-of-2 of page size seems like a
> > > pretty low-impact change. Hard to imagine breaking anything except
> > > some carefully crafted tests for ENOSPC behavior.
> > >
> >
> > Yes, i know the double map trick. What i tried to say is that:
> > (1) remove the page-aligned restrain for max_entries
> > (2) still allocate page-aligned memory for ringbuf
> >
> > instead of rounding max_entries up to closest power-of-2 page size
> > directly, so max_entries from userspace is unchanged and double map trick
> > still works.
> 
> I don't see how. Knowing the correct and exact size of the ringbuf
> data area is mandatory for correctly consuming ringbuf data from
> user-space. But if I'm missing something, feel free to give it a try
> and see if it actually works.
> 
You are right. The userspace needs max_entries to do mmap() for data
area, so max_entries must be page-sized aligned.

If we want to do the automatic round-up, i think libbpf would be a better
place, because if the round-up is done in kernel, the userspace program
may use the old max_entries to call mmap(), the consumer side will not
work and leads to confusion for usage. If we do auto-round-up in libbpf,
the setup procedure is hidden from libbpf user. Will add the auto
round-up and its tests in libbpf.

Regards
Tao
> 
> >
> > > [0] https://github.com/torvalds/linux/blob/master/kernel/bpf/ringbuf.c#L73-L89
> >
