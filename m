Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D2B369750
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhDWQoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhDWQoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:44:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3233EC06174A;
        Fri, 23 Apr 2021 09:43:26 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e186so1015048iof.7;
        Fri, 23 Apr 2021 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uxcKhMoafVu5pDvZrUJZidliSNtT7SAxuh7MO5dRu3E=;
        b=rqiSva+fvYwUhf+01m6vSpaFdhu2a3BaaZH/YHcrf0TxwHS0iPdJFv5O8SNRLhsjKa
         6Wtn9WudjfsOKY8/t3+oOUzIFHzIgDOsMZRFDnHaqSYcelXW+noTw64XPE95P+XClvWN
         YI2CD+DzIP5OA3NbD9DNaeoy43DyT+SUpNmSGB8+duM+hlsGLm2LNI/Fzj4PtxuXUZrI
         cLNBL0rBuGQzdOMLhRLutcq2+rfUNc3zrSjrjQ6d1uCnCjxQJf8WkJcREAGy7RTKEquM
         /nKYkE3pA/kvfn+MLc/OW7hWL9a0wkTtW1cryQ0glp8uCXwc0eIEdsakUB383OHNYNXE
         OJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uxcKhMoafVu5pDvZrUJZidliSNtT7SAxuh7MO5dRu3E=;
        b=BX8pe/k38wKk6qWgPQ7ZvQKaRM8+j/VSMfkSU2W4zVbFQaK14F1U9SvSg3kp1K8/H/
         NwKrKzSREU5vZqV9qJmKzY6o2f4r1QeXHuW+vDvXB6zZajM0fojfEpn8giF6dz3I/ImI
         vws9qjga3J3Q8BI6xthdFc8kBHKi+riKixUbPrb/l1JWy4oaBs4bIy26Db3eB47lTglh
         puB/bViFUOmSnx2Sp/HHQ5gyE/xUw4I85rjy81fZMn9j2WVp30HUNj4f8bXezOXVL9yf
         /aEA/KqD3FumAi/+yzfuRH8i9MP1C/jxI2YzxPNMxDPBAltipkTlR4sl+nfaOJUgZa7B
         sxeg==
X-Gm-Message-State: AOAM533NlVnuLKWcO4bGqWufuHx7iJO9OAwm7N3N3PtxIQcTHgrKjMqy
        JHW21V+Bbh/6XE5Z87BzgWnf/9BKNASzj0VJWuo=
X-Google-Smtp-Source: ABdhPJy/lilPoyWSzZMog491+865yLWizvyW38l7UoLBYrx3q0pUysd1yApKJMjO7tD5ox6dp7CI/Bt+M+DvuiVlu0M=
X-Received: by 2002:a05:6602:112:: with SMTP id s18mr4075204iot.38.1619196205520;
 Fri, 23 Apr 2021 09:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon> <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
 <YH0pdXXsZ7IELBn3@lore-desk> <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
 <20210421144747.33c5f51f@carbon> <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
 <20210421173921.23fef6a7@carbon> <CAJ8uoz2JpfdjvjJp-vjWuhw5z1=2D32jj-KktFnLN6Zd9ZVmAQ@mail.gmail.com>
 <20210422164223.77870d28@carbon> <20210422170508.22c58226@carbon> <CAJ8uoz1oEa6ZEp3QKZiPx4oUtt9-nuY4Sh6PVrEnZdu-d_PudQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz1oEa6ZEp3QKZiPx4oUtt9-nuY4Sh6PVrEnZdu-d_PudQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 23 Apr 2021 09:43:14 -0700
Message-ID: <CAKgT0UceK7D1R7c_Y=ze4_6pupCfLpfr5QOj-GCeJeMSD=P48g@mail.gmail.com>
Subject: Re: Crash for i40e on net-next (was: [PATCH v8 bpf-next 00/14]
 mvneta: introduce XDP multi-buffer support)
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 10:28 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 5:05 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Thu, 22 Apr 2021 16:42:23 +0200
> > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > > On Thu, 22 Apr 2021 12:24:32 +0200
> > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > >
> > > > On Wed, Apr 21, 2021 at 5:39 PM Jesper Dangaard Brouer
> > > > <brouer@redhat.com> wrote:
> > > > >
> > > > > On Wed, 21 Apr 2021 16:12:32 +0200
> > > > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > >
> > > [...]
> > > > > > more than I get.
> > > > >
> > > > > I clearly have a bug in the i40e driver.  As I wrote later, I don't see
> > > > > any packets transmitted for XDP_TX.  Hmm, I using Mel Gorman's tree,
> > > > > which contains the i40e/ice/ixgbe bug we fixed earlier.
> > >
> > > Something is wrong with i40e, I changed git-tree to net-next (at
> > > commit 5d869070569a) and XDP seems to have stopped working on i40e :-(
>
> Found this out too when switching to the net tree yesterday to work on
> proper packet drop tracing as you spotted/requested yesterday. The
> commit below completely broke XDP support on i40e (if you do not run
> with a zero-copy AF_XDP socket because that path still works). I am
> working on a fix that does not just revert the patch, but fixes the
> original problem without breaking XDP. Will post it and the tracing
> fixes as soon as I can.
>
> commit 12738ac4754ec92a6a45bf3677d8da780a1412b3
> Author: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Date:   Fri Mar 26 19:43:40 2021 +0100
>
>     i40e: Fix sparse errors in i40e_txrx.c
>
>     Remove error handling through pointers. Instead use plain int
>     to return value from i40e_run_xdp(...).
>
>     Previously:
>     - sparse errors were produced during compilation:
>     i40e_txrx.c:2338 i40e_run_xdp() error: (-2147483647) too low for ERR_PTR
>     i40e_txrx.c:2558 i40e_clean_rx_irq() error: 'skb' dereferencing
> possible ERR_PTR()
>
>     - sk_buff* was used to return value, but it has never had valid
>     pointer to sk_buff. Returned value was always int handled as
>     a pointer.
>
>     Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>     Fixes: 2e6893123830 ("i40e: split XDP_TX tail and XDP_REDIRECT map
> flushing")
>     Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>     Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     Tested-by: Dave Switzer <david.switzer@intel.com>
>     Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Yeah, this patch would horribly break things, especially in the
multi-buffer case. The idea behind using the skb pointer to indicate
the error is that it is persistent until we hit the EOP descriptor.
With that removed you end up mangling the entire list of frames since
it will start trying to process the next frame in the middle of a
packet.

>
> > Renamed subj as this is without this patchset applied.
> >
> > > $ uname -a
> > > Linux broadwell 5.12.0-rc7-net-next+ #600 SMP PREEMPT Thu Apr 22 15:13:15 CEST 2021 x86_64 x86_64 x86_64 GNU/Linux
> > >
> > > When I load any XDP prog almost no packets are let through:
> > >
> > >  [kernel-bpf-samples]$ sudo ./xdp1 i40e2
> > >  libbpf: elf: skipping unrecognized data section(16) .eh_frame
> > >  libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
> > >  proto 17:          1 pkt/s
> > >  proto 0:          0 pkt/s
> > >  proto 17:          0 pkt/s
> > >  proto 0:          0 pkt/s
> > >  proto 17:          1 pkt/s
> >
> > Trying out xdp_redirect:
> >
> >  [kernel-bpf-samples]$ sudo ./xdp_redirect i40e2 i40e2
> >  input: 7 output: 7
> >  libbpf: elf: skipping unrecognized data section(20) .eh_frame
> >  libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh_frame
> >  libbpf: Kernel error message: XDP program already attached
> >  WARN: link set xdp fd failed on 7
> >  ifindex 7:       7357 pkt/s
> >  ifindex 7:       7909 pkt/s
> >  ifindex 7:       7909 pkt/s
> >  ifindex 7:       7909 pkt/s
> >  ifindex 7:       7909 pkt/s
> >  ifindex 7:       7909 pkt/s
> >  ifindex 7:       6357 pkt/s
> >
> > And then it crash (see below) at page_frag_free+0x31 which calls
> > virt_to_head_page() with a wrong addr (I guess).  This is called by
> > i40e_clean_tx_irq+0xc9.
>
> Did not see a crash myself, just 4 Kpps. But the rings and DMA
> mappings got completely mangled by the patch above, so could be the
> same cause.

Are you running with jumbo frames enabled? I would think this change
would really blow things up in the jumbo enabled case.
