Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4E14A69F2
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 03:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243811AbiBBCgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 21:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiBBCgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 21:36:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A54C061714;
        Tue,  1 Feb 2022 18:36:21 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a8so17549393pfa.6;
        Tue, 01 Feb 2022 18:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ZLPo0nlJ5OLb78RiOW/2Pc242N/LxLnGhGMQatS21Y=;
        b=YNBySn61t/1JAYchGjEbmwoGrVBU6aAWK/Fx1bZfoaPtnyPd9SB4qx6lNGJ5Gg9qli
         OfTcxytKc/gmgXxl3KDIxXdmo9xgYD1X3QKtNF9MuhzWQFQs3fSIj1byb3nkKzq3jbnL
         wvxNylwFqIHGihSbaY71tZTI5im4qLd/oc2yzAM+TOIsJ0fuzMiY2mNDEZpsDfZQVvO0
         onnhtbeGe2Qhra4LDDBU3C3Vn/lG92SMBvB7xkM56ItTN0Zd4EoZ6npy67XcTbcJj4XQ
         toD9EVDfzw+nwGmUFm3fl99SblgYUU6GHEe6sZ84StksbfVQQbFcIkfqbZRwEUPrBFlK
         EwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ZLPo0nlJ5OLb78RiOW/2Pc242N/LxLnGhGMQatS21Y=;
        b=YJ/RLLkkvAdZWqMsTIy2RwCiXGSJkyEuf+nYJZQroDE6UezZHMoxi+muxigLeyuAjx
         HiIkBA5OpIaVuXHlSlZzrf0nmFkxYuNt9i9/aDIifOxjSOmbMypeGJ1oy9eGq8MVjshj
         zJR7erSb+yfRfu0bp2QxLsYLYXr9KFdxAGF3PgAmL7Xu/0HhZ3PE5gcKkfoz2qvRTks/
         xSJov2VryrBQI8PBi3O6kCxCaNrYWi0zJcvq+edVYSEhxmieauZ2UwnRliwzMDEZX1h+
         3pR7KNE92TAqSYqROKCD3gfgSlwqwYQsFDz7DJLPHpBZKuJhHgA65WQfBIxaghouVbJm
         vbtg==
X-Gm-Message-State: AOAM532uLSmd3a3K2S++B4LvhoPhbfReuF15cD14UcJAaGxUm4Y4RF+8
        saTijdNPtqSo4dICq463dBM=
X-Google-Smtp-Source: ABdhPJzkhl9S/s7YYrro5597oUF2U5SnUCF78PhYlHGzl9AcxNwezM52CwG6g2vjjD1mlxskpKa8nw==
X-Received: by 2002:aa7:8e89:: with SMTP id a9mr28441564pfr.64.1643769380813;
        Tue, 01 Feb 2022 18:36:20 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id u17sm32376740pgi.14.2022.02.01.18.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 18:36:20 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hotforest@gmail.com,
        houtao1@huawei.com, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize ring buffer size
Date:   Wed,  2 Feb 2022 10:36:16 +0800
Message-Id: <20220202023616.4687-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzYbbPT_og-_GGQYpsRmpBGRC-c1Xe8=QDybK243DhiKAQ@mail.gmail.com>
References: <CAEf4BzYbbPT_og-_GGQYpsRmpBGRC-c1Xe8=QDybK243DhiKAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> >
> > Hi Andrii,
> >
> > > >
> > > > 4096 is OK for x86-64, but for other archs with greater than 4KB
> > > > page size (e.g. 64KB under arm64), test_verifier for test case
> > > > "check valid spill/fill, ptr to mem" will fail, so just use
> > > > getpagesize() to initialize the ring buffer size. Do this for
> > > > test_progs as well.
> > > >
> > [...]
> >
> > > > diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> > > > index 96060ff4ffc6..e192a9f16aea 100644
> > > > --- a/tools/testing/selftests/bpf/progs/ima.c
> > > > +++ b/tools/testing/selftests/bpf/progs/ima.c
> > > > @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
> > > >
> > > >  struct {
> > > >         __uint(type, BPF_MAP_TYPE_RINGBUF);
> > > > -       __uint(max_entries, 1 << 12);
> > >
> > > Should we just bump it to 64/128/256KB instead? It's quite annoying to
> > > do a split open and then load just due to this...
> > >
> > Agreed.
> >
> > > I'm also wondering if we should either teach kernel to round up to
> > > closes power-of-2 of page_size internally, or teach libbpf to do this
> > > for RINGBUF maps. Thoughts?
> > >
> > It seems that max_entries doesn't need to be page-aligned. For example
> > if max_entries is 4096 and page size is 65536, we can allocate a
> > 65536-sized page and set rb->mask 4095 and it will work. The only
> > downside is 60KB memory is waster, but it is the implementation
> > details and can be improved if subpage mapping can be supported.
> >
> > So how about removing the page-aligned restraint in kernel ?
> >
> 
> No, if you read BPF ringbuf code carefully you'll see that we map the
> entire ringbuf data twice in the memory (see [0] for lame ASCII
> diagram), so that records that are wrapped at the end of the ringbuf
> and go back to the start are still accessible as a linear array. It's
> a very important guarantee, so it has to be page size multiple. But
> auto-increasing it to the closest power-of-2 of page size seems like a
> pretty low-impact change. Hard to imagine breaking anything except
> some carefully crafted tests for ENOSPC behavior.
>

Yes, i know the double map trick. What i tried to say is that:
(1) remove the page-aligned restrain for max_entries
(2) still allocate page-aligned memory for ringbuf

instead of rounding max_entries up to closest power-of-2 page size
directly, so max_entries from userspace is unchanged and double map trick
still works.

> [0] https://github.com/torvalds/linux/blob/master/kernel/bpf/ringbuf.c#L73-L89

> > Regards,
> > Tao

