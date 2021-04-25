Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5667236A652
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhDYJqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDYJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:46:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D649C061574;
        Sun, 25 Apr 2021 02:45:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o16so13778001plg.5;
        Sun, 25 Apr 2021 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T1lYoSyJXwqRNFkOwskLBS8m5G2V6R0rZBRK97ae8hM=;
        b=Z80W45UKKLz+X9/n65cHifc7KUqdTWYZJtlbIzBMOTkNYjfEATFfS8ABbkgzB1TBeX
         TDj380QJ3v/xt45RUzGCVOoBvoC5wEB7WRQaPL0EwVqO/6DA7SFjbEnMRAPhs8+Kq5i3
         hmGVl2T0lp7llnZoXnXJXPuCUoRKuBASzoPtqMUTmLQnpJSTWOeVYHjoxgE7trVBOi9m
         jIxKuXGBl1Uc2/DT0K+1hIsTOuHn/nTcGAhlSDbgR6cc21bQmf5U5BOHvFoF2ErFCWmV
         I7gpZ9t4ZMVBOkG7kKbWCwyNryghFiVM/eQt53sAsR7UR9qRXK14TanLPOqR0JH3tKFV
         WEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T1lYoSyJXwqRNFkOwskLBS8m5G2V6R0rZBRK97ae8hM=;
        b=EcW/h8xGciHKAQ5qU4aigQgTrGVV7eEewq8MyKq3TWEUfx5NZ0YMCfJdzKPjip6KB2
         38i8LHKOrZO+d203BIP9lxjd7PTgK86XhLctbvRb8dxKV9pEGxDXffpaLpNE/B46Jb1B
         Uh1q2LojQOBhxsZaC4thVDDs/suLUniX+Lfa+uXwELP0KxjOH+y07Q0NQ0einAIt/Jat
         foDkQ+KHzdE42oeY0yqnQKMHi3GE3jzCNxUxTdx8Hq/wCCYfqmiyfVn4Z9TRIHAOMx5M
         T1bE6OHO95qBGqhVW8DGkH3XuJZou9NM9ZBi/4skMgBgkOOszbUnGXi9hMdagD04fW1N
         hslg==
X-Gm-Message-State: AOAM531/MhZJSy35HsA2zXWEbOccMkqEsslbqfLTfpO0Piwr8ksqKpvi
        2lDiteX75de65arS4nlewBmiAzyOC6y+f5o/nIs=
X-Google-Smtp-Source: ABdhPJxzvgBuaiGB5HpleLnZlj05OywDZQTBuYaivuKjz/vONpnUlVgGSA2YmMBjNI7CmHt0XEfv8nySGLxalxMEogY=
X-Received: by 2002:a17:902:b494:b029:e7:36be:9ce7 with SMTP id
 y20-20020a170902b494b02900e736be9ce7mr12915494plr.43.1619343927649; Sun, 25
 Apr 2021 02:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon> <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
 <YH0pdXXsZ7IELBn3@lore-desk> <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
 <20210421144747.33c5f51f@carbon> <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
 <20210421173921.23fef6a7@carbon> <CAJ8uoz2JpfdjvjJp-vjWuhw5z1=2D32jj-KktFnLN6Zd9ZVmAQ@mail.gmail.com>
 <20210422164223.77870d28@carbon> <20210422170508.22c58226@carbon>
 <CAJ8uoz1oEa6ZEp3QKZiPx4oUtt9-nuY4Sh6PVrEnZdu-d_PudQ@mail.gmail.com> <CAKgT0UceK7D1R7c_Y=ze4_6pupCfLpfr5QOj-GCeJeMSD=P48g@mail.gmail.com>
In-Reply-To: <CAKgT0UceK7D1R7c_Y=ze4_6pupCfLpfr5QOj-GCeJeMSD=P48g@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sun, 25 Apr 2021 11:45:16 +0200
Message-ID: <CAJ8uoz2_nvDd+n_YfZZyd1m6xByQ6wo_D2HKSPRVi061+2M1RQ@mail.gmail.com>
Subject: Re: Crash for i40e on net-next (was: [PATCH v8 bpf-next 00/14]
 mvneta: introduce XDP multi-buffer support)
To:     Alexander Duyck <alexander.duyck@gmail.com>
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

On Fri, Apr 23, 2021 at 6:43 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Apr 22, 2021 at 10:28 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 5:05 PM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Thu, 22 Apr 2021 16:42:23 +0200
> > > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > >
> > > > On Thu, 22 Apr 2021 12:24:32 +0200
> > > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > >
> > > > > On Wed, Apr 21, 2021 at 5:39 PM Jesper Dangaard Brouer
> > > > > <brouer@redhat.com> wrote:
> > > > > >
> > > > > > On Wed, 21 Apr 2021 16:12:32 +0200
> > > > > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > > >
> > > > [...]
> > > > > > > more than I get.
> > > > > >
> > > > > > I clearly have a bug in the i40e driver.  As I wrote later, I don't see
> > > > > > any packets transmitted for XDP_TX.  Hmm, I using Mel Gorman's tree,
> > > > > > which contains the i40e/ice/ixgbe bug we fixed earlier.
> > > >
> > > > Something is wrong with i40e, I changed git-tree to net-next (at
> > > > commit 5d869070569a) and XDP seems to have stopped working on i40e :-(
> >
> > Found this out too when switching to the net tree yesterday to work on
> > proper packet drop tracing as you spotted/requested yesterday. The
> > commit below completely broke XDP support on i40e (if you do not run
> > with a zero-copy AF_XDP socket because that path still works). I am
> > working on a fix that does not just revert the patch, but fixes the
> > original problem without breaking XDP. Will post it and the tracing
> > fixes as soon as I can.
> >
> > commit 12738ac4754ec92a6a45bf3677d8da780a1412b3
> > Author: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> > Date:   Fri Mar 26 19:43:40 2021 +0100
> >
> >     i40e: Fix sparse errors in i40e_txrx.c
> >
> >     Remove error handling through pointers. Instead use plain int
> >     to return value from i40e_run_xdp(...).
> >
> >     Previously:
> >     - sparse errors were produced during compilation:
> >     i40e_txrx.c:2338 i40e_run_xdp() error: (-2147483647) too low for ERR_PTR
> >     i40e_txrx.c:2558 i40e_clean_rx_irq() error: 'skb' dereferencing
> > possible ERR_PTR()
> >
> >     - sk_buff* was used to return value, but it has never had valid
> >     pointer to sk_buff. Returned value was always int handled as
> >     a pointer.
> >
> >     Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> >     Fixes: 2e6893123830 ("i40e: split XDP_TX tail and XDP_REDIRECT map
> > flushing")
> >     Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> >     Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> >     Tested-by: Dave Switzer <david.switzer@intel.com>
> >     Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>
> Yeah, this patch would horribly break things, especially in the
> multi-buffer case. The idea behind using the skb pointer to indicate
> the error is that it is persistent until we hit the EOP descriptor.
> With that removed you end up mangling the entire list of frames since
> it will start trying to process the next frame in the middle of a
> packet.
>
> >
> > > Renamed subj as this is without this patchset applied.
> > >
> > > > $ uname -a
> > > > Linux broadwell 5.12.0-rc7-net-next+ #600 SMP PREEMPT Thu Apr 22 15:13:15 CEST 2021 x86_64 x86_64 x86_64 GNU/Linux
> > > >
> > > > When I load any XDP prog almost no packets are let through:
> > > >
> > > >  [kernel-bpf-samples]$ sudo ./xdp1 i40e2
> > > >  libbpf: elf: skipping unrecognized data section(16) .eh_frame
> > > >  libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
> > > >  proto 17:          1 pkt/s
> > > >  proto 0:          0 pkt/s
> > > >  proto 17:          0 pkt/s
> > > >  proto 0:          0 pkt/s
> > > >  proto 17:          1 pkt/s
> > >
> > > Trying out xdp_redirect:
> > >
> > >  [kernel-bpf-samples]$ sudo ./xdp_redirect i40e2 i40e2
> > >  input: 7 output: 7
> > >  libbpf: elf: skipping unrecognized data section(20) .eh_frame
> > >  libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh_frame
> > >  libbpf: Kernel error message: XDP program already attached
> > >  WARN: link set xdp fd failed on 7
> > >  ifindex 7:       7357 pkt/s
> > >  ifindex 7:       7909 pkt/s
> > >  ifindex 7:       7909 pkt/s
> > >  ifindex 7:       7909 pkt/s
> > >  ifindex 7:       7909 pkt/s
> > >  ifindex 7:       7909 pkt/s
> > >  ifindex 7:       6357 pkt/s
> > >
> > > And then it crash (see below) at page_frag_free+0x31 which calls
> > > virt_to_head_page() with a wrong addr (I guess).  This is called by
> > > i40e_clean_tx_irq+0xc9.
> >
> > Did not see a crash myself, just 4 Kpps. But the rings and DMA
> > mappings got completely mangled by the patch above, so could be the
> > same cause.
>
> Are you running with jumbo frames enabled? I would think this change
> would really blow things up in the jumbo enabled case.

I did not. Just using XDP_DROP or XDP_TX would crash the system just fine.
