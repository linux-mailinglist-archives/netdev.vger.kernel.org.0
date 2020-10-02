Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7007E281A7A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388397AbgJBSGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgJBSGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 14:06:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7DC0613D0;
        Fri,  2 Oct 2020 11:06:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e5so2045045ils.10;
        Fri, 02 Oct 2020 11:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xQHdD9FYvaSVDKe3FGt16IcuIG+7ix3939R7cUq5vHw=;
        b=uEtRAiinQabjTTjsVo4InS/Uby38Yc8HB2T+DH5ohJORdEX4PQKgyEYltUbsxCs8Eu
         eR8WW2sEruObE8FyAHV97E2X03luqJIygIecBwV3ySZaGz+MkJOO6jYhMwjObrWX20ic
         HES/25+/0A0KCf5kRfLxEhYY9r2UmB913GFS5WmNhaeuhmVZdJpS0l/fozfwW6nSzJKL
         AIKez1ZJp/1cEtXljrnnIsX2Pm5t8wJ7iQny7ACxKW5vT/OkJ/YgGET6Tcd4Xb/KhdHg
         TKjH2B2eRotK5G/bKxzM5TNLDg1GMzHYIb0fdSAjRnD5W5k3rQNLICuqbridtqbxH4N0
         A5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xQHdD9FYvaSVDKe3FGt16IcuIG+7ix3939R7cUq5vHw=;
        b=pRreAZDDLPGPr7+O73tp9iqW7ZMH8TZxRCaqMWnNnDSsXvYmppfIIdAqBhYhFtSGZN
         sooT+y6baBoDzZQC022EyyAcmvrh+C70FvEArYTvtjjUlskt1acErGDY0WiLtdulFWz8
         iNnftrNNNqDzx9BHmCpRbKgnsDGT8Vf9yeW0GKhvjx20spjMCiD8slKuw3/GeE6BbLBa
         3dAmOMqlE/CY5OKZwKm7/9lhfxJxZIZgV4dLPVYIcsYEBX0YuG3LxyblyT8Qml559SVh
         uyMu5SpGu7DLwesckvFVCKxX/6iZbsHFUwi8b7WAHU40GrfoXPrEu+3wwwKRMy6dIdrX
         pD2A==
X-Gm-Message-State: AOAM532H2yeYn+ALjrIjVQPjKRnuEf1OKRRujNge7yjzNkylmtFVTXgM
        5Q/YeMZj2xQnBkGxL2MZFcA=
X-Google-Smtp-Source: ABdhPJweUhBuEB99WaFi6EQ0t/qRJdVFTH23M2hMah+XMKg+rI8BBG8p64T2eIcyhOGT+jbSn9BJKQ==
X-Received: by 2002:a92:ccc5:: with SMTP id u5mr2845241ilq.178.1601661981275;
        Fri, 02 Oct 2020 11:06:21 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f21sm1004316ioh.1.2020.10.02.11.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 11:06:20 -0700 (PDT)
Date:   Fri, 02 Oct 2020 11:06:12 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com
Message-ID: <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
In-Reply-To: <20201002160623.GA40027@lore-desk>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > please focus on how these new types of xdp_{buff,frame} packets
> > > traverse the different layers and the layout design. It is on purpose
> > > that BPF-helpers are kept simple, as we don't want to expose the
> > > internal layout to allow later changes.
> > > 
> > > For now, to keep the design simple and to maintain performance, the XDP
> > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > later (another patchset) to add payload access across multiple buffers.
> > > This patchset should still allow for these future extensions. The goal
> > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > same performance as before.
> > > 
> > > The main idea for the new multi-buffer layout is to reuse the same
> > > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > > struct at the end of the first buffer to link together subsequent
> > > buffers. Keeping the layout compatible with SKBs is also done to ease
> > > and speedup creating an SKB from an xdp_{buff,frame}. Converting
> > > xdp_frame to SKB and deliver it to the network stack is shown in cpumap
> > > code (patch 13/13).
> > 
> > Using the end of the buffer for the skb_shared_info struct is going to
> > become driver API so unwinding it if it proves to be a performance issue
> > is going to be ugly. So same question as before, for the use case where
> > we receive packet and do XDP_TX with it how do we avoid cache miss
> > overhead? This is not just a hypothetical use case, the Facebook
> > load balancer is doing this as well as Cilium and allowing this with
> > multi-buffer packets >1500B would be useful.
> > 
> > Can we write the skb_shared_info lazily? It should only be needed once
> > we know the packet is going up the stack to some place that needs the
> > info. Which we could learn from the return code of the XDP program.
> 
> Hi John,

Hi, I'll try to join the two threads this one and the one on helpers here
so we don't get too fragmented.

> 
> I agree, I think for XDP_TX use-case it is not strictly necessary to fill the
> skb_hared_info. The driver can just keep this info on the stack and use it
> inserting the packet back to the DMA ring.
> For mvneta I implemented it in this way to keep the code aligned with ndo_xdp_xmit
> path since it is a low-end device. I guess we are not introducing any API constraint
> for XDP_TX. A high-end device can implement multi-buff for XDP_TX in a different way
> in order to avoid the cache miss.

Agree it would be an implementation detail for XDP_TX except the two helpers added
in this series currently require it to be there.

> 
> We need to fill the skb_shared info only when we want to pass the frame to the
> network stack (build_skb() can directly reuse skb_shared_info->frags[]) or for
> XDP_REDIRECT use-case.

It might be good to think about the XDP_REDIRECT case as well then. If the
frags list fit in the metadata/xdp_frame would we expect better
performance?

Looking at skb_shared_info{} that is a rather large structure with many
fields that look unnecessary for XDP_REDIRECT case and only needed when
passing to the stack. Fundamentally, a frag just needs

 struct bio_vec {
     struct page *bv_page;     // 8B
     unsigned int bv_len;      // 4B
     unsigned int bv_offset;   // 4B
 } // 16B

With header split + data we only need a single frag so we could use just
16B. And worse case jumbo frame + header split seems 3 entries would be
enough giving 48B (header plus 3 4k pages). Could we just stick this in
the metadata and make it read only? Then programs that care can read it
and get all the info they need without helpers. I would expect performance
to be better in the XDP_TX and XDP_REDIRECT cases. And copying an extra
worse case 48B in passing to the stack I guess is not measurable given
all the work needed in that path.

> 
> > 
> > > 
> > > A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
> > > to notify the bpf/network layer if this is a xdp multi-buffer frame (mb = 1)
> > > or not (mb = 0).
> > > The mb bit will be set by a xdp multi-buffer capable driver only for
> > > non-linear frames maintaining the capability to receive linear frames
> > > without any extra cost since the skb_shared_info structure at the end
> > > of the first buffer will be initialized only if mb is set.
> > 
> > Thanks above is clearer.
> > 
> > > 
> > > In order to provide to userspace some metdata about the non-linear
> > > xdp_{buff,frame}, we introduced 2 bpf helpers:
> > > - bpf_xdp_get_frags_count:
> > >   get the number of fragments for a given xdp multi-buffer.
> > > - bpf_xdp_get_frags_total_size:
> > >   get the total size of fragments for a given xdp multi-buffer.
> > 
> > Whats the use case for these? Do you have an example where knowing
> > the frags count is going to be something a BPF program will use?
> > Having total size seems interesting but perhaps we should push that
> > into the metadata so its pulled into the cache if users are going to
> > be reading it on every packet or something.
> 
> At the moment we do not have any use-case for these helpers (not considering
> the sample in the series :)). We introduced them to provide some basic metadata
> about the non-linear xdp_frame.
> IIRC we decided to introduce some helpers instead of adding this info in xdp_frame
> in order to save space on it (for xdp it is essential xdp_frame to fit in a single
> cache-line).

Sure, how about in the metadata then? (From other thread I was suggesting putting
the total length in metadata) We could even allow programs to overwrite it if
they wanted if its not used by the stack for anything other than packet length
visibility. Of course users would then need to be a bit careful not to overwrite
it and then read it again expecting the length to be correct. I think from a
users perspective though that would be expected.

> 
> Regards,
> Lorenzo
> 
