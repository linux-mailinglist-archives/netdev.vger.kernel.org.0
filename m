Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D52284213
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 23:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJEVWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 17:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJEVWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 17:22:13 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0DAC0613CE;
        Mon,  5 Oct 2020 14:22:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q1so9160727ilt.6;
        Mon, 05 Oct 2020 14:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0f1CLo503MnuWdm5KqmcasaFJsBdWmxKylqIcnejrWU=;
        b=pfz+mDXp/TJnzAStKn9HxWsjHMXbkD56z/pHWTuuR4Be5dq/OLF/YKs3cl66PODaq/
         Le/u8aIeL4HGdZXt4wVnEvm5vfMr6gVHzffhLX2yfpkeGZKdwPfjMc4qUzlbcdwGCLFc
         8ZxRW3IBDexj5V7kBdw8gftHeeOE3mZqjffG1STiEhKt1sLXffeD3Ulu1iSmNNI2Icyc
         G6/ixKyhxBvMxNQIR7xK1njuAjxpMGuoUGBqcU1HtLN2LZRHg66sE7gPYZL4Sd8q6YE4
         BomPxAwpmp2/fSzXogfeqTfykpfcZ5C2xz5Cvwwxqaf+g16KGqgPGvLxdWbT2TDN/UQk
         ZM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0f1CLo503MnuWdm5KqmcasaFJsBdWmxKylqIcnejrWU=;
        b=WTH04gkOqCZbiL7I+7iZCZyopk9q222HZt3CquXmRHWGPxShZ9QgWb9hlRXUVsNmhc
         eaZcYn+wQPTJV3I1lRwvdoZnlEDnJzWDvYgGzpOceI9zBAVk6P6O89M8j7+JoXvWVk7e
         yEtTe2bCDhsAYB761JXGdHHLLTC4SCzKYorMd2oI+bFBEMjBf81V/M2Ks2hTddCZVXqB
         XkZkSRML2pOOokz1NC+rlNhGgAVh2TJ6/am/kqiEX9gUMDeDplZRwjy6NSVB4X0XJzHo
         MpeBoevkso6jKR8f4YsEHFtVuG4lFcpgToma5g1fC45GQDYeqAes+Fh1NFNcaVCruLN0
         gd1A==
X-Gm-Message-State: AOAM530A6MBD/VasY8AHVPNWSbQ+1nX4zDCgVXbE8o2z6lavIIA4H3sj
        3y41zwfCGYtX+NalXsFSnFI=
X-Google-Smtp-Source: ABdhPJyOc03yXIaYurZOFS8bes5EwWCIfvjza5cSaUFftVQNbpQIlstCxs314tr5qKvg92tvwTsVzA==
X-Received: by 2002:a92:24cf:: with SMTP id k198mr1054036ilk.3.1601932931335;
        Mon, 05 Oct 2020 14:22:11 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z200sm523091iof.47.2020.10.05.14.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:22:10 -0700 (PDT)
Date:   Mon, 05 Oct 2020 14:22:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, echaudro@redhat.com,
        brouer@redhat.com
Message-ID: <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
In-Reply-To: <20201005115247.72429157@carbon>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
 <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
 <20201005115247.72429157@carbon>
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 02 Oct 2020 11:06:12 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Lorenzo Bianconi wrote:
> > > > Lorenzo Bianconi wrote:  
> > > > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > > > please focus on how these new types of xdp_{buff,frame} packets
> > > > > traverse the different layers and the layout design. It is on purpose
> > > > > that BPF-helpers are kept simple, as we don't want to expose the
> > > > > internal layout to allow later changes.
> > > > > 
> > > > > For now, to keep the design simple and to maintain performance, the XDP
> > > > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > > > later (another patchset) to add payload access across multiple buffers.
> > > > > This patchset should still allow for these future extensions. The goal
> > > > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > > > same performance as before.
> > > > > 
> > > > > The main idea for the new multi-buffer layout is to reuse the same
> > > > > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > > > > struct at the end of the first buffer to link together subsequent
> > > > > buffers. Keeping the layout compatible with SKBs is also done to ease
> > > > > and speedup creating an SKB from an xdp_{buff,frame}. Converting
> > > > > xdp_frame to SKB and deliver it to the network stack is shown in cpumap
> > > > > code (patch 13/13).  
> > > > 
> > > > Using the end of the buffer for the skb_shared_info struct is going to
> > > > become driver API so unwinding it if it proves to be a performance issue
> > > > is going to be ugly. So same question as before, for the use case where
> > > > we receive packet and do XDP_TX with it how do we avoid cache miss
> > > > overhead? This is not just a hypothetical use case, the Facebook
> > > > load balancer is doing this as well as Cilium and allowing this with
> > > > multi-buffer packets >1500B would be useful.
> > > > 
> > > > Can we write the skb_shared_info lazily? It should only be needed once
> > > > we know the packet is going up the stack to some place that needs the
> > > > info. Which we could learn from the return code of the XDP program.  
> > > 
> > > Hi John,  
> > 
> > Hi, I'll try to join the two threads this one and the one on helpers here
> > so we don't get too fragmented.
> > 
> > > 
> > > I agree, I think for XDP_TX use-case it is not strictly necessary to fill the
> > > skb_hared_info. The driver can just keep this info on the stack and use it
> > > inserting the packet back to the DMA ring.
> > > For mvneta I implemented it in this way to keep the code aligned with ndo_xdp_xmit
> > > path since it is a low-end device. I guess we are not introducing any API constraint
> > > for XDP_TX. A high-end device can implement multi-buff for XDP_TX in a different way
> > > in order to avoid the cache miss.  
> > 
> > Agree it would be an implementation detail for XDP_TX except the two
> > helpers added in this series currently require it to be there.
> 
> That is a good point.  If you look at the details, the helpers use
> xdp_buff->mb bit to guard against accessing the "shared_info"
> cacheline. Thus, for the normal single frame case XDP_TX should not see
> a slowdown.  Do we really need to optimize XDP_TX multi-frame case(?)

Agree it is guarded by xdp_buff->mb which is why I asked for that detail
to be posted in the cover letter so it was easy to understand that bit
of info.

Do we really need to optimize XDP_TX multi-frame case? Yes I think so.
The use case is jumbo frames (or 4kB) LB. XDP_TX is the common case any
many configurations. For our use case these including cloud providers
and bare-metal data centers.

Keeping the implementation out of the helpers allows drivers to optimize
for this case. Also it doesn't seem like the helpers in this series
have a strong use case. Happy to hear what it is, but I can't see how
to use them myself.

> 
> 
> > > 
> > > We need to fill the skb_shared info only when we want to pass the frame to the
> > > network stack (build_skb() can directly reuse skb_shared_info->frags[]) or for
> > > XDP_REDIRECT use-case.  
> > 
> > It might be good to think about the XDP_REDIRECT case as well then. If the
> > frags list fit in the metadata/xdp_frame would we expect better
> > performance?
> 
> I don't like to use space in xdp_frame for this. (1) We (Ahern and I)
> are planning to use the space in xdp_frame for RX-csum + RX-hash +vlan,
> which will be more common (e.g. all packets will have HW RX+csum).  (2)
> I consider XDP multi-buffer the exception case, that will not be used
> in most cases, so why reserve space for that in this cache-line.

Sure.

> 
> IMHO we CANNOT allow any slowdown for existing XDP use-cases, but IMHO
> XDP multi-buffer use-cases are allowed to run "slower".

I agree we cannot slowdown existing use cases. But, disagree that multi
buffer use cases can be slower. If folks enable jumbo-frames and things
slow down thats a problem.

> 
> 
> > Looking at skb_shared_info{} that is a rather large structure with many
> 
> A cache-line detail about skb_shared_info: The first frags[0] member is
> in the first cache-line.  Meaning that it is still fast to have xdp
> frames with 1 extra buffer.

Thats nice in-theory.

> 
> > fields that look unnecessary for XDP_REDIRECT case and only needed when
> > passing to the stack. 
> 
> Yes, I think we can use first cache-line of skb_shared_info more
> optimally (via defining a xdp_shared_info struct). But I still want us
> to use this specific cache-line.  Let me explain why below. (Avoiding
> cache-line misses is all about the details, so I hope you can follow).
> 
> Hopefully most driver developers understand/knows this.  In the RX-loop
> the current RX-descriptor have a status that indicate there are more
> frame, usually expressed as non-EOP (End-Of-Packet).  Thus, a driver
> can start a prefetchw of this shared_info cache-line, prior to
> processing the RX-desc that describe the multi-buffer.
>  (Remember this shared_info is constructed prior to calling XDP and any
> XDP_TX action, thus the XDP prog should not see a cache-line miss when
> using the BPF-helper to read shared_info area).

In general I see no reason to populate these fields before the XDP
program runs. Someone needs to convince me why having frags info before
program runs is useful. In general headers should be preserved and first
frag already included in the data pointers. If users start parsing further
they might need it, but this series doesn't provide a way to do that
so IMO without those helpers its a bit difficult to debate.

Specifically for XDP_TX case we can just flip the descriptors from RX
ring to TX ring and keep moving along. This is going to be ideal on
40/100Gbps nics.

I'm not arguing that its likely possible to put some prefetch logic
in there and keep the pipe full, but I would need to see that on
a 100gbps nic to be convinced the details here are going to work. Or
at minimum a 40gbps nic.

> 
> 
> > Fundamentally, a frag just needs
> > 
> >  struct bio_vec {
> >      struct page *bv_page;     // 8B
> >      unsigned int bv_len;      // 4B
> >      unsigned int bv_offset;   // 4B
> >  } // 16B
> > 
> > With header split + data we only need a single frag so we could use just
> > 16B. And worse case jumbo frame + header split seems 3 entries would be
> > enough giving 48B (header plus 3 4k pages). 
> 
> For jumbo-frame 9000 MTU 2 entries might be enough, as we also have
> room in the first buffer (((9000-(4096-256-320))/4096 = 1.33789).

Sure. I was just counting the fist buffer a frag understanding it
wouldn't actually be in the frag list.

> 
> The problem is that we need to support TSO (TCP Segmentation Offload)
> use-case, which can have more frames. Thus, 3 entries will not be
> enough.

Sorry not following, TSO? Explain how TSO is going to work for XDP_TX
and XDP_REDIRECT? I guess in theory you can header split and coalesce,
but we are a ways off from that and this series certainly doesn't
talk about TSO unless I missed something.

> 
> > Could we just stick this in the metadata and make it read only? Then
> > programs that care can read it and get all the info they need without
> > helpers.
> 
> I don't see how that is possible. (1) the metadata area is only 32
> bytes, (2) when freeing an xdp_frame the kernel need to know the layout
> as these points will be free'ed.

Agree its tight, probably too tight to be useful.

> 
> > I would expect performance to be better in the XDP_TX and
> > XDP_REDIRECT cases. And copying an extra worse case 48B in passing to
> > the stack I guess is not measurable given all the work needed in that
> > path.
> 
> I do agree, that when passing to netstack we can do a transformation
> from xdp_shared_info to skb_shared_info with a fairly small cost.  (The
> TSO case would require more copying).

I'm lost on the TSO case. Explain how TSO is related here? 

> 
> Notice that allocating an SKB, will always clear the first 32 bytes of
> skb_shared_info.  If the XDP driver-code path have done the prefetch
> as described above, then we should see a speedup for netstack delivery.

Not against it, but these things are a bit tricky. Couple things I still
want to see/understand

 - Lets see a 40gbps use a prefetch and verify it works in practice
 - Explain why we can't just do this after XDP program runs
 - How will we read data in the frag list if we need to parse headers
   inside the frags[].

The above would be best to answer now rather than later IMO.

Thanks,
John
