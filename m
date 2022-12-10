Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4A0648B87
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLJAGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:06:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11FF747DC;
        Fri,  9 Dec 2022 16:06:20 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w15so6750999wrl.9;
        Fri, 09 Dec 2022 16:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sQFo2vKeSpU6+jocEYDSE/k2q10Q8cwZtsjU6/rnL/k=;
        b=egABX+VZ+RnE6SoIwjEqFoFzUkET4fUCEySh/Pm1qNIKpH7XNztPUzKRnRML2df0K2
         PlmQGnQi9y1i1T9nKv1kmUzQqtBOVTaABpPAF74ig8BJAEIVDkpIWsD4j/VpCuj2fEO+
         ycUYp36Tr/K0K2kn/HPFcjYzZ7tMwHx9bYXXtBV2KSoH2Kqk2bF+EXcqJ8zjd2zBvuoC
         XAacXHJ2uYBWEjSP+G+7cf8d8PptaJFmjGBfWC8buh8CCsc93pLYK5+BmY7U+fFPvQ94
         aFQnn/22rfL8sXJVerlUw+fTRsU5/Ms1gjjlhVA4Kg1HkS3DiXu2+iJjJ8dmTHitcK2t
         ygjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQFo2vKeSpU6+jocEYDSE/k2q10Q8cwZtsjU6/rnL/k=;
        b=LFKDhykzXpLTq5alsQOUvERoBxvNsv96YbT5BWKupQiSIkHwLBiW5g/ZHM6Wrr7WOq
         Y8HsICMRUz4zNpuSfS9gR8Yxwo/p1sFsoHReNDVwEJju8hZf3Lb+aoAQD3opsQ3kxymZ
         LXb7p2KwJK+QCa+9OHEGcfWzyNm+0MzvSsxBa/boZchsC9b6mLmxj3JIYDcFXhoJ/t5P
         qZPYH6Tk84/AaquLP08aI2480FIFRTmQo1UnwBGA9c9TdA6dKmDVIWWdDDgvEu+6TwnL
         SWreXbJkt/un6RHt+F3sUCJHqKUPlSgyb1NREc/vnb/rRoDZWdjzurtOP+8QRnt4QeUY
         rLfQ==
X-Gm-Message-State: ANoB5pmeHW/Q3CCOx8hagfCH6c9qX5mnTZcQfel3i3p94K+J85ENDMVe
        n+Eimlgaejj9q/cGMH+EGyA=
X-Google-Smtp-Source: AA0mqf7LEnm3JqCflD05e5cXhBQh5BI4XUP4N5ldaolsfK9dLZDDmeXoF4t3WM946HByMavZMlv91A==
X-Received: by 2002:a5d:62cb:0:b0:241:fb10:9369 with SMTP id o11-20020a5d62cb000000b00241fb109369mr4321202wrv.21.1670630779035;
        Fri, 09 Dec 2022 16:06:19 -0800 (PST)
Received: from krava ([83.240.62.58])
        by smtp.gmail.com with ESMTPSA id p7-20020adff207000000b002425dc49024sm2484012wro.43.2022.12.09.16.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 16:06:18 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 10 Dec 2022 01:06:16 +0100
To:     Jakub Kicinski <kuba@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>,
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5PNeFYJrC6D4P9p@krava>
References: <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209153445.22182ca5@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > 
> >    [...] One example of non-obvious pairing is the XDP feature in networking,
> >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> >    relies heavily on RCU protection for its data structures, but because the
> >    BPF program invocation happens entirely within a single local_bh_disable()
> >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> >    is safe is that readers can use anything that disables BH when updaters use
> >    call_rcu() or synchronize_rcu(). [...]
> 
> FWIW I sent a link to the thread to Paul and he confirmed 
> the RCU will wait for just the BH.

so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side

Paul,
any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
with bpf_prog_run_xdp callers?

with synchronize_rcu_tasks I'm getting splats like:
  https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f

synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)

thanks,
jirka


---
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index c19719f48ce0..e6126f07e85b 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 	}
 
 	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
+	synchronize_rcu_tasks_rude();
 
 	if (new)
 		d->image_off = noff;
