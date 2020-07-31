Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930D3234DBF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgGaWrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgGaWq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 18:46:59 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70455C06174A;
        Fri, 31 Jul 2020 15:46:59 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x1so6315631ilp.7;
        Fri, 31 Jul 2020 15:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3rs7aAYYRTiLV8ypLkyc0wH5Zugp4PU32ugjXhVLHdk=;
        b=T7fm0SsUuzHyQA6st0/n98ANVo9ur9vu3KXqtq9u7laNjRfuq4usNpllVWVTp6LLar
         UfnodlZTeU/B5sMC1L4SgiB6/pd0N+HcjpZ2MswWA9esBB2YRa2NZvhOeQNJgfOxS58/
         DJ/3gx9RhzlLIUl0/gwwVRBg9sQcKJ/sEtQltsmr6nZn8jylmUMtR8Ev0Wucdf0549w3
         AzxCSiwOeLgNuh/zmsvZQwTYYa4oW582o75g2ZRgZ1yOlNl/bwtac/aIhLte+Lx/ivXH
         eZPQUYwDIRAFdLvAtDj3q7UAB9klyIalxtxF3Y0HPIT77xbFju8Y686Av1YZw1YqsHBj
         1xzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3rs7aAYYRTiLV8ypLkyc0wH5Zugp4PU32ugjXhVLHdk=;
        b=Jvf96MtOL1wpf3jM6xsEIyt2SOPpp2Fr1wIBZPepW3LliNwY820WErw/jHsWuU+vt/
         AyIQMdqG7WJ1PP3y6TRcTDNJVy/AJ/sq8rnQCHRqZcgOVvFHepYioN6w3R0sKhUTJY/a
         +N1swWMOLzdaLA/p8nlkYDnkWQ7CPiFVt2voJihfVpUUqeXWguRCm+cvL4ve7nsswk5o
         HzmCoZXRfme0lKR7Zd8epS4npBCjB1pSMdLgJAD55PpfQTveBTtt0Kxn1E4KFsS2Zhf2
         L8B8gij2LLQ66A4jEhmUADyVcCwGC/hxU2JNWmlQUeqFqmVGtSIl0Po/ua9CgYer2SIH
         2xOA==
X-Gm-Message-State: AOAM530nuSxt5vHXUuxULg/5dd4bwCdonoGYWbhzkIRVGKBbaHrt6GUl
        /BZjFaLqBSSancqUA85W9C0=
X-Google-Smtp-Source: ABdhPJy+tAUlgIxcx/rJ3npVYur2CUKDv7zTaj/6BgDjHiQV/zeVHVtfwTOQbpKArOuLO1qj/bYRsg==
X-Received: by 2002:a92:8e01:: with SMTP id c1mr6014546ild.140.1596235618807;
        Fri, 31 Jul 2020 15:46:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t17sm2838409ilq.69.2020.07.31.15.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 15:46:57 -0700 (PDT)
Date:   Fri, 31 Jul 2020 15:46:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, kafai@fb.com,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5f249f5a74483_54fa2b1d9fe285b4c5@john-XPS-13-9370.notmuch>
In-Reply-To: <546828c9-a6bb-57d3-9a9d-83f4e0131163@iogearbox.net>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
 <159603977489.4454.16012925913901625071.stgit@john-Precision-5820-Tower>
 <546828c9-a6bb-57d3-9a9d-83f4e0131163@iogearbox.net>
Subject: Re: [bpf PATCH v2 1/5] bpf: sock_ops ctx access may stomp registers
 in corner case
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 7/29/20 6:22 PM, John Fastabend wrote:
> > I had a sockmap program that after doing some refactoring started spewing
> > this splat at me:
> > 
> > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > [...]
> > [18610.807359] Call Trace:
> > [18610.807370]  ? 0xffffffffc114d0d5
> > [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> > [18610.807391]  tcp_connect+0x895/0xd50
> > [18610.807400]  tcp_v4_connect+0x465/0x4e0
> > [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> > [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> > [18610.807417]  inet_stream_connect+0x3b/0x60
> > [18610.807425]  __sys_connect+0xed/0x120
> > 
> > After some debugging I was able to build this simple reproducer,
> > 
> >   __section("sockops/reproducer_bad")
> >   int bpf_reproducer_bad(struct bpf_sock_ops *skops)
> >   {
> >          volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >          return 0;
> >   }
> > 
> > And along the way noticed that below program ran without splat,
> > 
> > __section("sockops/reproducer_good")
> > int bpf_reproducer_good(struct bpf_sock_ops *skops)
> > {
> >          volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >          volatile __maybe_unused __u32 family;
> > 
> >          compiler_barrier();
> > 
> >          family = skops->family;
> >          return 0;
> > }
> > 
> > So I decided to check out the code we generate for the above two
> > programs and noticed each generates the BPF code you would expect,
> > 
> > 0000000000000000 <bpf_reproducer_bad>:
> > ;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >         0:       r1 = *(u32 *)(r1 + 96)
> >         1:       *(u32 *)(r10 - 4) = r1
> > ;       return 0;
> >         2:       r0 = 0
> >         3:       exit
> > 
> > 0000000000000000 <bpf_reproducer_good>:
> > ;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >         0:       r2 = *(u32 *)(r1 + 96)
> >         1:       *(u32 *)(r10 - 4) = r2
> > ;       family = skops->family;
> >         2:       r1 = *(u32 *)(r1 + 20)
> >         3:       *(u32 *)(r10 - 8) = r1
> > ;       return 0;
> >         4:       r0 = 0
> >         5:       exit
> > 
> > So we get reasonable assembly, but still something was causing the null
> > pointer dereference. So, we load the programs and dump the xlated version
> > observing that line 0 above 'r* = *(u32 *)(r1 +96)' is going to be
> > translated by the skops access helpers.
> > 
> > int bpf_reproducer_bad(struct bpf_sock_ops * skops):
> > ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >     0: (61) r1 = *(u32 *)(r1 +28)
> >     1: (15) if r1 == 0x0 goto pc+2
> >     2: (79) r1 = *(u64 *)(r1 +0)
> >     3: (61) r1 = *(u32 *)(r1 +2340)
> > ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >     4: (63) *(u32 *)(r10 -4) = r1
> > ; return 0;
> >     5: (b7) r0 = 0
> >     6: (95) exit
> > 
> > int bpf_reproducer_good(struct bpf_sock_ops * skops):
> > ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >     0: (61) r2 = *(u32 *)(r1 +28)
> >     1: (15) if r2 == 0x0 goto pc+2
> >     2: (79) r2 = *(u64 *)(r1 +0)
> >     3: (61) r2 = *(u32 *)(r2 +2340)
> > ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
> >     4: (63) *(u32 *)(r10 -4) = r2
> > ; family = skops->family;
> >     5: (79) r1 = *(u64 *)(r1 +0)
> >     6: (69) r1 = *(u16 *)(r1 +16)
> > ; family = skops->family;
> >     7: (63) *(u32 *)(r10 -8) = r1
> > ; return 0;
> >     8: (b7) r0 = 0
> >     9: (95) exit
> > 
> > Then we look at lines 0 and 2 above. In the good case we do the zero
> > check in r2 and then load 'r1 + 0' at line 2. Do a quick cross-check
> > into the bpf_sock_ops check and we can confirm that is the 'struct
> > sock *sk' pointer field. But, in the bad case,
> > 
> >     0: (61) r1 = *(u32 *)(r1 +28)
> >     1: (15) if r1 == 0x0 goto pc+2
> >     2: (79) r1 = *(u64 *)(r1 +0)
> > 
> > Oh no, we read 'r1 +28' into r1, this is skops->fullsock and then in
> > line 2 we read the 'r1 +0' as a pointer. Now jumping back to our spat,
> > 
> > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > 
> > The 0x01 makes sense because that is exactly the fullsock value. And
> > its not a valid dereference so we splat.
> > 
> > To fix we need to guard the case when a program is doing a sock_ops field
> > access with src_reg == dst_reg. This is already handled in the load case
> > where the ctx_access handler uses a tmp register being careful to
> > store the old value and restore it. To fix the get case test if
> > src_reg == dst_reg and in this case do the is_fullsock test in the
> > temporary register. Remembering to restore the temporary register before
> > writing to either dst_reg or src_reg to avoid smashing the pointer into
> > the struct holding the tmp variable.
> > 
> > Adding this inline code to test_tcpbpf_kern will now be generated
> > correctly from,
> > 
> >    9: r2 = *(u32 *)(r2 + 96)
> > 
> > to xlated code,

I have this in my logs at line 12,

                *(u64 *)(r2 +32) = r9
> >    13: (61) r9 = *(u32 *)(r2 +28)
> >    14: (15) if r9 == 0x0 goto pc+4
> >    15: (79) r9 = *(u64 *)(r2 +32)
> >    16: (79) r2 = *(u64 *)(r2 +0)
> >    17: (61) r2 = *(u32 *)(r2 +2348)
> >    18: (05) goto pc+1
> >    19: (79) r9 = *(u64 *)(r2 +32)
> 
> The diff below looks good to me, but I'm confused on this one above. I'm probably
> missing something, but given this is the dst == src case with the r2 register, where
> in the dump do we first saves the content of r9 into the scratch tmp store?
> Line 19 seems to restore it, but the save is missing, no?
> 
> Please double check whether this was just omitted, but I would really like to have
> the commit message 100% correct as it otherwise causes confusion when we stare at it
> again a month later wrt what was the original intention.

off-by-one on the cut'n'paste into the commit message. Let me send a v3
with a correction to the commit. I do want this to be correct.
