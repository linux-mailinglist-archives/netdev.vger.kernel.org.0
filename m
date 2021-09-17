Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B416B410121
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 00:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243690AbhIQWJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbhIQWJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 18:09:30 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89595C061574;
        Fri, 17 Sep 2021 15:08:07 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id s20so5404411ioa.4;
        Fri, 17 Sep 2021 15:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=hHNA+ZVHahorxX08neiIMjZ3hODgLZ2sH2//vaCpU+w=;
        b=Ajz857d51NQdcTNRD2xupp0COfxe8sf46xOP0dJ8dnEaSjd+4WUmLEt9DAfy6VJKDO
         /Q95sghCCPfQB6PRGlxSN4O67vwj8fCjRz7xBUDjuzdSwn1N+IibwWB92M2ebOZY/jFZ
         EY/5fTrZPHYzEkA7yr2a/ui1sreg1s5XfNVi3eWA9gGh5/PxwoMQrclihgmzdmbvE9Kj
         IJM/OOiTbUVXhD5aWHPBwqWbHlgylyOf+bPY9//7PfS+hgSGK/SPhJb0fZUrhRbUM5BD
         rg+PxeXg5M1ZhySg7rKfK+BRdEvHGJVI5zvEaG43ubfc2uDkY0MdIQEOGlvFvxohJemw
         PRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=hHNA+ZVHahorxX08neiIMjZ3hODgLZ2sH2//vaCpU+w=;
        b=cPKqampJlxu/BlqtEB+Opiy3kVeFPsri76atrYBbkuj+hW25d1GA9ni1XaUtaVZUHC
         9him63i/tXqylSNvNdcQrKBZ6e/IgEHX14lMVayawjL97FYj1VBAXNlG+zp2dBvMjKRY
         E6GnSxbt8Zofg9V0BRYNv47egBIU2OQGV6LPOM4QRJMFfGvOciQNdbyw3MYIHEt03MLi
         pVMBkC/r86Ls9ZIpCR88r3HJdVCfosjyg9Fvwlsdy9R/Bp/SWHq1nx/b0MzY4wQ2W5lx
         BDrF3foYn2sLdy84sesRz6k0zFVQH5A+rXdMsxHKVXcgYacFU18WbLCG3GZbrWrbIs37
         0dhw==
X-Gm-Message-State: AOAM532JxdfY7pH8tyCsr73JEY3z2iEZ675cC8ll6mikcfQWJymz29is
        rKSvqNwkrefrJwrz66Q8ut8=
X-Google-Smtp-Source: ABdhPJy6C+EcpVxHCUrZ0SWf5PUGt/WeaDw1j/ti4gcPX9YWu1UFZ6iz62dpz5oVRkDQ12CW8mWfBQ==
X-Received: by 2002:a5d:8505:: with SMTP id q5mr10165989ion.53.1631916486897;
        Fri, 17 Sep 2021 15:08:06 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h9sm4113116ioz.30.2021.09.17.15.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:08:06 -0700 (PDT)
Date:   Fri, 17 Sep 2021 15:07:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk>
 <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Fri, Sep 17, 2021 at 12:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 17 Sep 2021 11:43:07 -0700 Alexei Starovoitov wrote:
> > > > If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
> > > > can start with that. In all honesty I don't know what the exact
> > > > use cases for looking at data are, either. I'm primarily worried
> > > > about exposing the kernel internals too early.
> > >
> > > I don't mind the xdp equivalent of skb_load_bytes,
> > > but skb_header_pointer() idea is superior.
> > > When we did xdp with data/data_end there was no refine_retval_range
> > > concept in the verifier (iirc or we just missed that opportunity).
> > > We'd need something more advanced: a pointer with valid range
> > > refined by input argument 'len' or NULL.
> > > The verifier doesn't have such thing yet, but it fits as a combination of
> > > value_or_null plus refine_retval_range.
> > > The bpf_xdp_header_pointer() and bpf_skb_header_pointer()
> > > would probably simplify bpf programs as well.
> > > There would be no need to deal with data/data_end.
> >
> > What are your thoughts on inlining? Can we inline the common case
> > of the header being in the "head"? Otherwise data/end comparisons
> > would be faster.
> 
> Yeah. It can be inlined by the verifier.
> It would still look like a call from bpf prog pov with llvm doing spill/fill
> of scratched regs, but it's minor.
> 
> Also we can use the same bpf_header_pointer(ctx, ...)
> helper for both xdp and skb program types. They will have different
> implementation underneath, but this might make possible writing bpf
> programs that could work in both xdp and skb context.
> I believe cilium has fancy macros to achieve that.

Hi,

First a header_pointer() logic that works across skb and xdp seems like
a great idea to me. I wonder though if instead of doing the copy
into a new buffer for offset past the initial frag like what is done in
skb_header_pointer could we just walk the frags and point at the new offset.
This is what we do on the socket side with bpf_msg_pull-data() for example.
For XDP it should also work. The skb case would depend on clone state
and things so might be a bit more tricky there.

This has the advantage of only doing the copy when its necessary. This
can be useful for example when reading the tail of an IPsec packet. With
blind copy most packets will get hit with a copy. By just writing the
pkt->data and pkt->data_end we can avoid this case.

Lorenz originally implemented something similar earlier and we had the
refine retval logic. It failed on no-alu32 for some reason we could
revisit. I didn't mind the current help returning with data pointer set
to the start of the frag so we stopped following up on it.

I agree though the current implementation puts a lot on the BPF writer.
So getting both cases covered, I want to take pains in my BPF prog
to avoid copies and I just want these bytes handled behind a single
helper seems good to me.

Thanks,
John
