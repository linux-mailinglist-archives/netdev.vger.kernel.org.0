Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8C39B025
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 04:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFDCGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 22:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDCGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 22:06:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E6BC06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 19:04:28 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z26so6333487pfj.5
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 19:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DjobgYc8Gn1H+xatZJjC1lSdgZ/Q4F/AHpRxsltjyWM=;
        b=TcMLlZgvkJVubJcg/VtIYdZ/mCYE18lowXyQyIaL7T9J4oxE5p9dcdvUDXxTw666oj
         5uORaJwfNpSkRsmIGmfkpeOfHqbL40VrdzN1iPA6t/iXSyzLreOwCr3AuKaSva/fAXvX
         8H3ychLClT+bbvy2E0mWWQoOb3y2u4/zEe5rz84ezcbBpwQ/1m91ArfbfOnfDBQEsm7V
         uW0uyZQ+re9XBr+BIxiAM2bgsDTFsBgzxm201Dl1iYCqTnMaBaEk0IKvALPGrf/iahnG
         IQ66gAAOOOxJOeKHkzezM7zGYVP+BTXPsrdAYwW7QMR8cHkJA5E8tu47pFeF6bWqU+uk
         3nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DjobgYc8Gn1H+xatZJjC1lSdgZ/Q4F/AHpRxsltjyWM=;
        b=mix8ZuTClk0GhjILolaEUhSQSl5bttHgeBcRD5VU/iRjau9Wuoyq6fQdAlXa8IHIvY
         CtGe+cvvJxeyHCser+t2owyA1iN/LCw89lEPvv4O6C++F3pr4aWBX4p5syAolxYFL0Pa
         uSQzNxZOvs1mMdqHzkICNN78J8scPyH7sJPY/Qrvn36OOf/sWH1lzj4wMaryQfdvzEMd
         NgsjbrPiovtR74PFhEVczD0W9FvRqtntqf7wdxz/XVCP/ceVTRYvs8C1F7c/y+btssXB
         3KMYgApMfuIS0j65kqDd0OdmLqchicdOvmo4Fd8tHwJE2O1wBb3nQnrHEj+CimSU8Utt
         lyrA==
X-Gm-Message-State: AOAM530jDWgKZWq+vvmDG6dZUatyqlmfHOIMxx5Vu+Im0mE8U1vll2wM
        rnE85qLR8x8iD2FLrZvWhqY=
X-Google-Smtp-Source: ABdhPJwMnkpCgO53/RraOc8WsiKm7apf0AxI7XjKFsXdVj6PJ4rjAB/XOAoSqNuj7Z7hIpvSpibMAg==
X-Received: by 2002:a63:1324:: with SMTP id i36mr2455838pgl.44.1622772267713;
        Thu, 03 Jun 2021 19:04:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:82fb])
        by smtp.gmail.com with ESMTPSA id 141sm312385pgf.92.2021.06.03.19.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 19:04:27 -0700 (PDT)
Date:   Thu, 3 Jun 2021 19:04:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
Message-ID: <20210604020423.kfagqwwwf4k4t663@ast-mbp.dhcp.thefacebook.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
 <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
 <20210603235612.kwoirxd2tixk7do4@ast-mbp.dhcp.thefacebook.com>
 <CA+FuTSfXXQWi5GZQYN=E+qpaa7jPii1jgvJPeTSYuXOzZkQFog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfXXQWi5GZQYN=E+qpaa7jPii1jgvJPeTSYuXOzZkQFog@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 08:44:51PM -0400, Willem de Bruijn wrote:
> On Thu, Jun 3, 2021 at 7:56 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jun 01, 2021 at 06:18:39PM -0400, Tanner Love wrote:
> > > From: Tanner Love <tannerlove@google.com>
> > >
> > > Syzkaller bugs have resulted from loose specification of
> > > virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
> > > in virtio_net_hdr_to_skb to validate the vnet header and drop bad
> > > input.
> > >
> > > The existing behavior of accepting these vnet headers is part of the
> > > ABI.
> >
> > So ?
> > It's ok to fix ABI when it's broken.
> > The whole feature is a way to workaround broken ABI with additional
> > BPF based validation.
> > It's certainly a novel idea.
> > I've never seen BPF being used to fix the kernel bugs.
> > But I think the better way forward is to admit that vnet ABI is broken
> > and fix it in the kernel with proper validation.
> > BPF-based validation is a band-aid. The out of the box kernel will
> > stay broken and syzbot will continue to crash it.
> 
> The intention is not to use this to avoid kernel fixes.
> 
> There are three parts:
> 
> 1. is the ABI broken and can we simply drop certain weird packets?
> 2. will we accept an extra packet parsing stage in
> virtio_net_hdr_to_skb to find all the culprits?
> 3. do we want to add yet another parser in C when this is exactly what
> the BPF flow dissector does well?
> 
> The virtio_net_hdr interface is more permissive than I think it was
> intended. But weird edge cases like protocol 0 do occur. So I believe
> it is simply too late to drop everything that is not obviously
> correct.
> 
> More problematic is that some of the gray area cases are non-trivial
> and require protocol parsing. Do the packet headers match the gso
> type? Are subtle variants like IPv6/TCP with extension headers
> supported or not?
> 
> We have previously tried to add unconditional protocol parsing in
> virtio_net_hdr_to_skb, but received pushback because this will cause
> performance regressions, e.g., for vm-to-vm forwarding.
> 
> Combined, that's why I think BPF flow dissection is the right approach
> here. It is optional, can be as pedantic as the admin wants / workload
> allows (e.g., dropping UFO altogether) and ensures protocol parsing
> itself is robust. Even if not enabled continuously, offers a quick way
> to patch a vulnerability when it is discovered. This is the same
> reasoning of the existing BPF flow dissector.
> 
> It is not intended as an alternative to subsequently fixing a bug in
> the kernel path.

Thanks for these details. They need to be part of commit log.

As far as patches the overhead of copying extra fields can be avoided.
How about copying single pointer to struct virtio_net_hdr into bpf_flow_keys instead?
See struct bpf_sockopt and _bpf_md_ptr(struct bpf_sock *, sk).
The overhead will much lower and bpf prog will access all virtio_net_hdr directly.
