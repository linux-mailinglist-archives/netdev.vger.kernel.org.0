Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E465F648B41
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLIXIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLIXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:08:01 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72302DAB7;
        Fri,  9 Dec 2022 15:07:59 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m19so990126wms.5;
        Fri, 09 Dec 2022 15:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y9C+RV1SktBoWSDQVptz2iw8+Z5lQmlM7XwW68nvyaI=;
        b=BF3XE7zknn3HwkAcBdevxV/Di1bPacooOwM5kuClNnRVtrHKvlcEjWLICsArI9K2N1
         NVISEY3M79X4sQAp2R3nc3RhNbr0nJqnVN9jLy2FUSG0l4EiWRWVGg0rqvGrXSmct+3/
         xLCIe5h61GKx60fVWiNNPaubOV/x+GwXFj5eh4TQYdIxe4Pj2sAwXgPDnVOBmVB/Kvww
         h58vc7HBKR3/SRfmPsAwVk/0/bdHJTuXsAabA/KHtXo7Df/bI6IBbrZ0OQWukYIjeO+A
         fuVkBAszbb5j7qKyRzztpWT1Q7I/eLrEpQWOpHWeuWrvbqZ3lOpxZCNwA6bd9ZY97iDK
         TuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9C+RV1SktBoWSDQVptz2iw8+Z5lQmlM7XwW68nvyaI=;
        b=OfxwYFTDjeuyt+lsbOBP4xiprmFyxtG27yNpRYccs1im7Tul1HrcP4RePtr0YZQ+z2
         2wbWnDnkRA+HnM3EaGi9TkGo9mdFt8OmYn/uNE9hDwyOOXThdu9XY+2GBkpAdDzFFHH2
         wl4fthBoc+IV3LAxH+54OjspRqPVWNp9ilHNRgU6TXxycL8Esbb3jVxNtA3FmSlPQgH+
         23WJm34AV9SxhppyHg7tnGCOABgnDEVhT5lh57jt4/ZryVCUgWCCtzBS1wXmS+KziL+E
         YozN7acMPmF2fZapAMzH1qRz1Lwb0dJ84uBbO6/3MFuFVoLHOaTaChV/bV29jVNtL3mh
         0Q/Q==
X-Gm-Message-State: ANoB5pnqkS/cYJWIH7RZFSnX2bGQlQ5+Y5DJemoCF7eRsqrKboKhOVys
        BKPLSXejClD4614bOzaPeVB/vlhYt4rtug==
X-Google-Smtp-Source: AA0mqf7iJqu6uquDFmt4R+UtwVsu29Py8gQCFL2NC5kV50OTDYq/oQ+qsdPcJdoBARXKKndO+5pBGA==
X-Received: by 2002:a05:600c:3d8c:b0:3d0:7fd2:4756 with SMTP id bi12-20020a05600c3d8c00b003d07fd24756mr6706991wmb.8.1670627278192;
        Fri, 09 Dec 2022 15:07:58 -0800 (PST)
Received: from krava ([83.240.62.58])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003d1e1f421bfsm1158174wmq.10.2022.12.09.15.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 15:07:57 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 10 Dec 2022 00:07:55 +0100
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5O/yxcjQLq5oDAv@krava>
References: <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 11:41:11PM +0100, Daniel Borkmann wrote:
> On 12/9/22 10:53 PM, Jiri Olsa wrote:
> > On Fri, Dec 09, 2022 at 12:31:06PM -0800, Yonghong Song wrote:
> > > 
> > > 
> > > On 12/9/22 7:20 AM, Jiri Olsa wrote:
> > > > On Fri, Dec 09, 2022 at 02:50:55PM +0100, Jiri Olsa wrote:
> > > > > On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:
> > > > > 
> > > > > SBIP
> > > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > > I'm trying to understand the severity of the issues and
> > > > > > > > > > > > whether we need to revert that commit asap since the merge window
> > > > > > > > > > > > is about to start.
> > > > > > > > > > > 
> > > > > > > > > > > Jiri, Peter,
> > > > > > > > > > > 
> > > > > > > > > > > ping.
> > > > > > > > > > > 
> > > > > > > > > > > cc-ing Thorsten, since he's tracking it now.
> > > > > > > > > > > 
> > > > > > > > > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > > > > > > > > Is it related?
> > > > > > > > > > 
> > > > > > > > > > sorry for late reply.. I still did not find the reason,
> > > > > > > > > > but I did not try with IBT yet, will test now
> > > > > > > > > 
> > > > > > > > > no difference with IBT enabled, can't reproduce the issue
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > ok, scratch that.. the reproducer got stuck on wifi init :-\
> > > > > > > > 
> > > > > > > > after I fix that I can now reproduce on my local config with
> > > > > > > > IBT enabled or disabled.. it's something else
> > > > > > > 
> > > > > > > I'm getting the error also when reverting the static call change,
> > > > > > > looking for good commit, bisecting
> > > > > > > 
> > > > > > > I'm getting fail with:
> > > > > > >      f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
> > > > > > > 
> > > > > > > v6.1-rc1 is ok
> > > > > > 
> > > > > > so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
> > > > > > 
> > > > > > attaching some more logs
> > > > > 
> > > > > looking at the code.. how do we ensure that code running through
> > > > > bpf_prog_run_xdp will not get dispatcher image changed while
> > > > > it's being exetuted
> > > > > 
> > > > > we use 'the other half' of the image when we add/remove programs,
> > > > > but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
> > > > > 
> > > > > 
> > > > > cpu 0:                                  cpu 1:
> > > > > 
> > > > > bpf_prog_run_xdp
> > > > >      ...
> > > > >      bpf_dispatcher_xdp_func
> > > > >         start exec image at offset 0x0
> > > > > 
> > > > >                                           bpf_dispatcher_update
> > > > >                                                   update image at offset 0x800
> > > > >                                           bpf_dispatcher_update
> > > > >                                                   update image at offset 0x0
> > > > > 
> > > > >         still in image at offset 0x0
> > > > > 
> > > > > 
> > > > > that might explain why I wasn't able to trigger that on
> > > > > bare metal just in qemu
> > > > 
> > > > I tried patch below and it fixes the issue for me and seems
> > > > to confirm the race above.. but not sure it's the best fix
> > > > 
> > > > jirka
> > > > 
> > > > 
> > > > ---
> > > > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > > > index c19719f48ce0..6a2ced102fc7 100644
> > > > --- a/kernel/bpf/dispatcher.c
> > > > +++ b/kernel/bpf/dispatcher.c
> > > > @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
> > > >    	}
> > > >    	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> > > > +	synchronize_rcu_tasks();
> > > >    	if (new)
> > > >    		d->image_off = noff;
> > > 
> > > This might work. In arch/x86/kernel/alternative.c, we have following
> > > code and comments. For text_poke, synchronize_rcu_tasks() might be able
> > > to avoid concurrent execution and update.
> > 
> > so my idea was that we need to ensure all the current callers of
> > bpf_dispatcher_xdp_func (which should have rcu read lock, based
> > on the comment in bpf_prog_run_xdp) are gone before and new ones
> > execute the new image, so the next call to the bpf_dispatcher_update
> > will be safe to overwrite the other half of the image
> 
> If v6.1-rc1 was indeed okay, then it looks like this may be related to
> the trampoline patching for the static_call? Did it repro on v6.1-rc1
> just with dbe69b299884 ("bpf: Fix dispatcher patchable function entry
> to 5 bytes nop") cherry-picked?

I'll try that.. it looks to me like the problem was always there,
maybe harder to trigger.. also to reproduce it you need to call
bpf_dispatcher_update heavily, which is not probably the common
use case

one other thing is that I think the fix might need rcu locking
on the bpf_dispatcher_xdp_func side, because local_bh_disable
seems not to be enough to make synchronize_rcu_tasks work

I'm now testing patch below

jirka


---
diff --git a/include/linux/filter.h b/include/linux/filter.h
index efc42a6e3aed..a27245b96d6b 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -772,7 +772,13 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * under local_bh_disable(), which provides the needed RCU protection
 	 * for accessing map entries.
 	 */
-	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	u32 act;
+
+	rcu_read_lock();
+
+	act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+
+	rcu_read_unlock();
 
 	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
 		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index c19719f48ce0..6a2ced102fc7 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 	}
 
 	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
+	synchronize_rcu_tasks();
 
 	if (new)
 		d->image_off = noff;
