Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6022A762B3
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfGZJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:41:36 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37002 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfGZJlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:41:36 -0400
Received: by mail-vs1-f68.google.com with SMTP id v6so35709294vsq.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zQAETFiPc0aFNIxeDXyiIDZA2xGxTwhcJMiDlxf4BIg=;
        b=gF9HjbvMjl5SVhv7yb2XcM5f/0R83Nt0MPGcMkb3JbW0PVLg8hJ1aDN8/yxAzHRJe8
         h9bXjl+UIP7KZVZAq1hlOgwASM6/xlIuz5VAvWQ9gqSBIcvHOSWWHldRinLfZcpxh5Rr
         VrSzo56C0bQjWOrBiGcfS6/jjvR+Xnuj4oVSbD6ay+tKRmwQUR9Zq63KTw704nCRuR3M
         UpFbHnUlHD8pWZl/Wa2KTRmcV6gw6k48UOvAfQhYPVD3wnFnjv7obhES0C5gXSDvYFjU
         DQh0biEXrF3tyOZ+TJv1zPmIv/gUnZ5njhjYC/kyqTZEJp9caVQKRvrG7Vxf9uhQEWPk
         fzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zQAETFiPc0aFNIxeDXyiIDZA2xGxTwhcJMiDlxf4BIg=;
        b=tlMKiEVhKamalSFER1/33pK3kKVnaJeAL4fbTO5xaOnbrRFkra2DWuAzaI84QJ4UXo
         TuXu4avnP7p7q9JoT7MHc6C8aDdGn09vG89pFr2ZFXFdzcRM8cwN3/w7PkLw9Q1ZRbvo
         EENCNqAPU4F80UlzmgU8AWGSoT0/Ls/r4fYWbPuBmTMibXhpNxHhUtMpR9+YaECjM9ry
         4ldm+OPLmLTGk46K7o3CXgC9Qiq39yzj5u7bpTLjo6OB+rrX18C/IBdfcMFEGqaZXjcE
         NlK0mPIap7gYTJDtcM76caJAwp1qqjpzx4261nXcWMjK18oRyEoBiaHU6XprumMrNIUk
         bQsQ==
X-Gm-Message-State: APjAAAVM4Pu3J/C8Y7ayXpXGyvUqgainhGjgoahTjS0F43W0HgwT2Z9D
        XRwjJMH1duNps9O4FckdAHJvZ3cCCSvAeXVrVR0Iyw==
X-Google-Smtp-Source: APXvYqxvp/2LfFvQ/EjoQDSHcBttZZk1A87AFf9gl9KRUa+fnZYFT1MDihIpFExEm6iD5Y9Rq6s1yOnrhkOaXjfB/uI=
X-Received: by 2002:a67:d990:: with SMTP id u16mr59869159vsj.95.1564134094915;
 Fri, 26 Jul 2019 02:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190725080925.6575-1-jian-hong@endlessm.com> <06d713fff7434dfb9ccab32c2e2112e2@AcuMS.aculab.com>
 <CAPpJ_ecAAw=1X=7+MOw-VVH0ZKBr6rcRub6JnEqgNbZ6Hxt=ag@mail.gmail.com> <c2cdffd30923459e8773379fc2927e1d@AcuMS.aculab.com>
In-Reply-To: <c2cdffd30923459e8773379fc2927e1d@AcuMS.aculab.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Fri, 26 Jul 2019 17:40:58 +0800
Message-ID: <CAPpJ_eey7+KCMFj2YVQD8ziWR_xf-==k9MYb49-32Z5E6vTdHA@mail.gmail.com>
Subject: Re: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX ring
To:     David Laight <David.Laight@aculab.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Laight <David.Laight@aculab.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=8826=
=E6=97=A5 =E9=80=B1=E4=BA=94 =E4=B8=8B=E5=8D=885:23=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> From: Jian-Hong Pan
> > Sent: 26 July 2019 07:18
> ...
> > > While allocating all 512 buffers in one block (just over 4MB)
> > > is probably not a good idea, you may need to allocated (and dma map)
> > > then in groups.
> >
> > Thanks for reviewing.  But got questions here to double confirm the ide=
a.
> > According to original code, it allocates 512 skbs for RX ring and dma
> > mapping one by one.  So, the new code allocates memory buffer 512
> > times to get 512 buffer arrays.  Will the 512 buffers arrays be in one
> > block?  Do you mean aggregate the buffers as a scatterlist and use
> > dma_map_sg?
>
> If you malloc a buffer of size (8192+32) the allocator will either
> round it up to a whole number of (often 4k) pages or to a power of
> 2 of pages - so either 12k of 16k.
> I think the Linux allocator does the latter.
> Some of the allocators also 'steal' a bit from the front of the buffer
> for 'red tape'.
>
> OTOH malloc the space 15 buffers and the allocator will round the
> 15*(8192 + 32) up to 32*4k - and you waste under 8k across all the
> buffers.
>
> You then dma_map the large buffer and split into the actual rx buffers.
> Repeat until you've filled the entire ring.
> The only complication is remembering the base address (and size) for
> the dma_unmap and free.
> Although there is plenty of padding to extend the buffer structure
> significantly without using more memory.
> Allocate in 15's and you (probably) have 512 bytes per buffer.
> Allocate in 31's and you have 256 bytes.
>
> The problem is that larger allocates are more likely to fail
> (especially if the system has been running for some time).
> So you almost certainly want to be able to fall back to smaller
> allocates even though they use more memory.
>
> I also wonder if you actually need 512 8k rx buffers to cover
> interrupt latency?
> I've not done any measurements for 20 years!

Thanks for the explanation.
I am not sure the combination of 512 8k RX buffers.  Maybe Realtek
folks can give us some idea.
Tony Chuang any comment?

Jian-Hong Pan
