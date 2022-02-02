Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B34A699F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbiBBB3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiBBB3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:29:21 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E51C061714;
        Tue,  1 Feb 2022 17:29:20 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w7so23574220ioj.5;
        Tue, 01 Feb 2022 17:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LpeiXbtStszlUlv9PfE1iD7pZJaP2pphB+B2YiHk+8A=;
        b=VyDbk6/OyKgXr2on1BBuIDZdV7RxFuMVH7HXqmra4fEtIKgzJ0A6+IymShEqjOa23Z
         N0NUx+gkDZ9fpVqGR60BU6NIIurY1IrzjIi3C8/zCHhDMZ7nBgNu+akn4NPuynds2rzI
         42MP6tYsWBSwunJo1O1mzTuyRIu7wCUp1Smm5yW6fyZ9Z0Tsf/oFdnlHmW4X2WQ+EnTk
         eBPPbTC0iD9Nrb9Q47RkdgR/OOCO6a838lL6hNWIdcUeSxB7d9GoweKG6BNHtq0jUMBv
         jiwLE+nKi6CL20oK/JAmZ58R0X3A/sv+jgQTNvMbjFS/QNoSunTuPOpW5gkhaneCtN79
         1PaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LpeiXbtStszlUlv9PfE1iD7pZJaP2pphB+B2YiHk+8A=;
        b=11e+PQjZMM5jVyTYCuKMFq01LvTIF25T47x6/5y3Uy6ZbiWmKUMqMnRyMaQ9CXamer
         Da+aXZqX0e/Yf1vAbhg6e9faxQgFzKty8AtTBYP3sp8pR2R4XzanNdPHpw9OAHxSxQkk
         V4ONVI4rghJi47zfmIpHRrU//eXL8vWg5ZktFJ9NQLc89Hj1L28Hl9RNh1xK/LBPIOu5
         UZqzcci5idCf8RlOBpr7heWVz/Ax4iuQpPQfjQb4/BJO2uX0f0fEVHUORuaTWRXvR1p1
         l4zlkCID39ZpD5njTXxru0RVRR/ybTIeNBpQa5C/ojWF8hvsXh0ZtXc6GZMovPPP5h9v
         cNVg==
X-Gm-Message-State: AOAM531vsgvKFfIwVlzPSrvpLyuYBB09FKxc4NvlyKiEUPl0Qe29OV5f
        vlLostjSRPQ7xPfZ9lMSNhEkXbNSfwnEgp9yTyA=
X-Google-Smtp-Source: ABdhPJwdFzhYjRmocaHGvZ5mx0aODIiOkfhekMa6WQzB5sVDo+DZA0kaxQyrUlSknp+9r8osjt6IR9zUEJa+RYqzavM=
X-Received: by 2002:a02:1181:: with SMTP id 123mr14339614jaf.93.1643765360309;
 Tue, 01 Feb 2022 17:29:20 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzYHggCfbSGb8autEDcHhZXabK-n36rggyjJeL0uLEr+DQ@mail.gmail.com>
 <20220201084313.23395-1-houtao1@huawei.com>
In-Reply-To: <20220201084313.23395-1-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 17:29:09 -0800
Message-ID: <CAEf4BzYbbPT_og-_GGQYpsRmpBGRC-c1Xe8=QDybK243DhiKAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize
 ring buffer size
To:     Hou Tao <hotforest@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hou Tao <houtao1@huawei.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 12:43 AM Hou Tao <hotforest@gmail.com> wrote:
>
> Hi Andrii,
>
> > >
> > > 4096 is OK for x86-64, but for other archs with greater than 4KB
> > > page size (e.g. 64KB under arm64), test_verifier for test case
> > > "check valid spill/fill, ptr to mem" will fail, so just use
> > > getpagesize() to initialize the ring buffer size. Do this for
> > > test_progs as well.
> > >
> [...]
>
> > > diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> > > index 96060ff4ffc6..e192a9f16aea 100644
> > > --- a/tools/testing/selftests/bpf/progs/ima.c
> > > +++ b/tools/testing/selftests/bpf/progs/ima.c
> > > @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
> > >
> > >  struct {
> > >         __uint(type, BPF_MAP_TYPE_RINGBUF);
> > > -       __uint(max_entries, 1 << 12);
> >
> > Should we just bump it to 64/128/256KB instead? It's quite annoying to
> > do a split open and then load just due to this...
> >
> Agreed.
>
> > I'm also wondering if we should either teach kernel to round up to
> > closes power-of-2 of page_size internally, or teach libbpf to do this
> > for RINGBUF maps. Thoughts?
> >
> It seems that max_entries doesn't need to be page-aligned. For example
> if max_entries is 4096 and page size is 65536, we can allocate a
> 65536-sized page and set rb->mask 4095 and it will work. The only
> downside is 60KB memory is waster, but it is the implementation
> details and can be improved if subpage mapping can be supported.
>
> So how about removing the page-aligned restraint in kernel ?
>

No, if you read BPF ringbuf code carefully you'll see that we map the
entire ringbuf data twice in the memory (see [0] for lame ASCII
diagram), so that records that are wrapped at the end of the ringbuf
and go back to the start are still accessible as a linear array. It's
a very important guarantee, so it has to be page size multiple. But
auto-increasing it to the closest power-of-2 of page size seems like a
pretty low-impact change. Hard to imagine breaking anything except
some carefully crafted tests for ENOSPC behavior.

  [0] https://github.com/torvalds/linux/blob/master/kernel/bpf/ringbuf.c#L73-L89

> Regards,
> Tao
