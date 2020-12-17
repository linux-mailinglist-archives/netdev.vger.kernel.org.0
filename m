Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BDC2DD839
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgLQSX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbgLQSX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:23:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2998C061794;
        Thu, 17 Dec 2020 10:22:46 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g18so20900067pgk.1;
        Thu, 17 Dec 2020 10:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DwQVtco0a81f7jeSJ9GEUy24kqFly/p98wcE+cou4Yo=;
        b=bLEs0x5+Req94tEveB6TqeqMi8pTgngJx/njSs9fZY2GLeswuUr9GdRa1lk8LEk/VB
         WS8lsDQ8bdHUoRfi7nYp5s0p7WFtVX4j6zzacPJkLzUiko8yPvW/RbvBr5YT8mXfRT0C
         nf5+5W8mvpsynwOR5wFhCGCQV880UvMeqUckqHf25i/s+VhCIWHDI+UzcGFrFmoKEDzt
         COqi06kY6GCBmnjQ5WTuMZOlSCa+iMAz5JSNst0WXhGtfq5WT8GKlxGBsl1jqLhlRyxt
         SCsoPI+wAwGOaLgAASKfRxbNzLzcZfi3MVgXLTYjK1HTpJZo8UaW/3b19aoUe5KbB6KN
         Ad9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DwQVtco0a81f7jeSJ9GEUy24kqFly/p98wcE+cou4Yo=;
        b=lROPTTqlRvTXUFpkrP++Ekvfl81CMHrbYs7OFhfPCWAR/CuT9cSnGz86hQ/HEWK8Fl
         RA2ILypzoL7fV7qGGPaoK0+hNPxU1i4vgU7rsoaQnDHuUGVe/6GqJXN34do7vQTpSCA9
         jSnHYNQW3ElkJOFHC+wHlzk6NkjSeJYE/RvGJl9mcYpGLEH/R65X8zgzZ3qmhsbob5Rm
         ZS8XnLbBSY6q+Rc4sY8ZS/RGBft9yPmuBdDgIXem07D9ES/B7TQpzJlB4sfGfhmHBLKS
         zQsF1PfQiUFpCuFhQ3+L4PhIzf5pDXKNzW2lci/3bCr1OHx2dO8acBLbmmjx+EVZEQDJ
         OdMA==
X-Gm-Message-State: AOAM533OFih39oULa3DbRwItaXFaVHDKK1IAOMOrT1OJgkId8rBTBrw9
        /G9mRPz8bbDWqaVRWSJms4U=
X-Google-Smtp-Source: ABdhPJyMBx45zVkA8K79doY/wDfrGgVNp3C7CUW0oh6dJjJ6dSt4FQw0lQ6sKbii0301c1JZ0DWbOQ==
X-Received: by 2002:a63:6e45:: with SMTP id j66mr508676pgc.238.1608229366426;
        Thu, 17 Dec 2020 10:22:46 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:682])
        by smtp.gmail.com with ESMTPSA id js9sm6062451pjb.2.2020.12.17.10.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 10:22:45 -0800 (PST)
Date:   Thu, 17 Dec 2020 10:22:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support
 module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
Message-ID: <20201217182243.vtpzqull76djt2qf@ast-mbp>
References: <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
 <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
 <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp>
 <alpine.LRH.2.23.451.2012092308240.26400@localhost>
 <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
 <alpine.LRH.2.23.451.2012161457030.27611@localhost>
 <CAEf4BzZ0_iGqnzqz3qAEggdTRhXkddtdYRUgs0XxibUyA_KH3w@mail.gmail.com>
 <20201217071620.j3uehcshue3ug7fy@ast-mbp>
 <alpine.LRH.2.23.451.2012171732410.2929@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2012171732410.2929@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 05:46:42PM +0000, Alan Maguire wrote:
> 
> 
> On Wed, 16 Dec 2020, Alexei Starovoitov wrote:
> 
> > > > $ ksnoop "ip_send_skb(skb->sk)"
> > > >
> > > > ...will trace the skb->sk value.  The user-space side of the program
> > > > matches the function/arg name and looks up the referenced type, setting it
> > > > in the function's map.  For field references such as skb->sk, it also
> > > > records offset and whether that offset is a pointer (as is the case for
> > > > skb->sk) - in such cases we need to read the offset value via bpf_probe_read()
> > > > and use it in bpf_snprintf_btf() along with the referenced type.  Only a
> > > > single simple reference like the above is supported currently, but
> > > > multiple levels of reference could be made to work too.
> > 
> > Alan,
> > 
> > I'm not sure why the last example is so different form the first two.
> > I think ksnoop tool will generate the program on the fly, right?
> 
> Nope, the BPF program is hard-coded; it adapts to different functions
> through use of the map entries describing function signatures and their
> BTF ids, and other associated tracing info.  The aim is to provide a
> generic tracing tool which displays kernel function arguments but
> doesn't require LLVM/clang on the target, just a kernel built with BTF 
> and libbpf.  Sorry this wasn't clearer in my explanation; I'm working
> on rewriting the code and will send it out ASAP.
> 
> > So it can generate normal LDX insn with CO-RE relocation (instead of bpf_probe_read)
> > to access skb->sk. It can also add relo for that LDX to point to
> > struct sk_buff's btf_id defined inside prog's BTF.
> > The 'sk' offset inside bpf program and inside BTF can be anything: 0, 4, ...
> > libbpf relocation logic will find the right offset in kernel's sk_buff.
> > If ksnoop doesn't have an ability to parse vmlinux.h file or kernel's BTF
> > it can 'cheat'.
> > If the cmdline looks like:
> > $ ksnoop "ip_send_skb(skb->sk)"
> > It can generate BTF:
> > struct sk_buff {
> >    struct sock *sk;
> > };
> > 
> > If cmdline looks like:
> > $ ksnoop "ip_send_skb(skb->sock)"
> > It can generate BTF:
> > struct sk_buff {
> >    struct sock *sock;
> > };
> > Obviously there is no 'sock' field inside kernel's struct sk_buff, but tool
> > doesn't need to care. It can let libbpf do the checking and match
> > fields properly.
> > 
> > > > into that a bit more if you don't mind because I think some form of
> > > > user-space-specified BTF ids may be the easiest approach for more flexible
> > > > generic tracing that covers more than function arguments.
> > 
> > I think you're trying to figure out kernel's btf_ids in ksnoop tool.
> 
> Yep.
> 
> > I suggest to leave that job to libbpf. Generate local BTFs in ksnoop
> > with CO-RE relocs and let libbpf handle insn patching.
> > No FDs to worry about from ksnoop side either.
> > 
> 
> The current approach doesn't rely on instruction patching outside
> of limited CORE use around struct pt_regs fields (args, IP, etc)
> which shouldn't require LLVM/clang availability on the target system. 

I'm not suggesting to use clang.
Everything I proposed above is for ksnoop to do. Not for the clang.
