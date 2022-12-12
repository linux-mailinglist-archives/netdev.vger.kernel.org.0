Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2246964A3E8
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiLLPEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiLLPEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:04:40 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D34213EBB;
        Mon, 12 Dec 2022 07:04:39 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id t17so28795612eju.1;
        Mon, 12 Dec 2022 07:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mVXG215IpHTW14bOAFnr20SAKbuAjq8u9fkZJEk1hwY=;
        b=FHwgxelBmmdRgokgPpc4gmxoAZ3IpTSVsP6vnf0dQUazSvawIEErpPf7fTWBIZEvfA
         BsKcxu74qftaRuXC8JFIlg48z2Xz6FrNtBkIA5PbSXQ5hauKu2uW3Hw58cfeKbP5j1ST
         cU7wPJDeTLNfDpI0GAZALDnhWKju5UsXRrqP/IZcRYHQG7LeYw/L+UEt3Uf2gFixAkJ0
         wo9a7V9XYBaIQ1P7nroLrBIZ+ujH5j19Hh4kvNpU46+fX1Iib8LAWGL++kwMNsV0/qOe
         yBA5vb71L4EczH9aaVhCyoDA9uTipdSuxeZwZ9oqm8uCycKCor3bFvYglgx2ViG9tnMj
         nTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVXG215IpHTW14bOAFnr20SAKbuAjq8u9fkZJEk1hwY=;
        b=TAdP+WtY3i9Xe0UWVQJMaZ8nyXmeNJttfi7ZqnTvWR+L1pnc0NsseDT9u2zeW09+Dp
         ueDEZ8bAz1CP8ToUReKG1aYHkqwIwJUleNqbkrPXI/V/q6rgLtO2bMfykK66dIGmdPNN
         W6w8jKKJrlh8r7LKOdqRWBZywiI5UFVmUD/+b4u/QTa8PkrtGHp6AzYj0gm9lblC8Vz6
         ciUooBP93em1dl/F5jtL31gMjd42VY8vhOWBLRXMnbFKzJoemYLNQ74qKgOFrT8UrM77
         xmTFsPp0tWHGylveGJIdiRKOWcuToNjnijP6P1hyu6epvffrl081pIn0PVsdmCQyw4QX
         6gEw==
X-Gm-Message-State: ANoB5pkpqft6iFPiiclaLJAIFPLlqYrYt1IBnnXcnKCvhPBSqIaK5ABx
        ayq1Yy0xzi7DBrnVCnAggk0=
X-Google-Smtp-Source: AA0mqf4ND9ypoyeLYGLYNLwpeReOg2ntsTWphQ/JhMUF4gSdQzKgqp3EFtkaw2z4vUgrf91tMw51GA==
X-Received: by 2002:a17:906:2209:b0:7c1:1b89:1fe0 with SMTP id s9-20020a170906220900b007c11b891fe0mr15045466ejs.65.1670857477499;
        Mon, 12 Dec 2022 07:04:37 -0800 (PST)
Received: from krava ([83.240.63.35])
        by smtp.gmail.com with ESMTPSA id e8-20020a170906314800b0073ae9ba9ba8sm3418860eje.3.2022.12.12.07.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 07:04:36 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 12 Dec 2022 16:04:34 +0100
To:     Jiri Olsa <olsajiri@gmail.com>, Hao Sun <sunhao.th@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>,
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
Message-ID: <Y5dDArARol3gfVNf@krava>
References: <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org>
 <Y5PNeFYJrC6D4P9p@krava>
 <CAADnVQKr9NYektHFq2sUKMxxXJVFHcMPWh=pKa08b-yM9cgAAQ@mail.gmail.com>
 <Y5SFho7ZYXr9ifRn@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5SFho7ZYXr9ifRn@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 02:11:34PM +0100, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 05:12:03PM -0800, Alexei Starovoitov wrote:
> > On Fri, Dec 9, 2022 at 4:06 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> > > > On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > > > > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > > > >
> > > > >    [...] One example of non-obvious pairing is the XDP feature in networking,
> > > > >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> > > > >    relies heavily on RCU protection for its data structures, but because the
> > > > >    BPF program invocation happens entirely within a single local_bh_disable()
> > > > >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> > > > >    is safe is that readers can use anything that disables BH when updaters use
> > > > >    call_rcu() or synchronize_rcu(). [...]
> > > >
> > > > FWIW I sent a link to the thread to Paul and he confirmed
> > > > the RCU will wait for just the BH.
> > >
> > > so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side
> > >
> > > Paul,
> > > any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
> > > with bpf_prog_run_xdp callers?
> > >
> > > with synchronize_rcu_tasks I'm getting splats like:
> > >   https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f
> > >
> > > synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)
> > 
> > Jiri,
> > 
> > I haven't tried to repro this yet, but I feel you're on
> > the wrong path here. The splat has this:
> > ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
> > ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
> > that test_run logic takes rcu_read_lock.
> > See bpf_test_timer_enter.
> > I suspect the addition of synchronize_rcu_tasks_rude
> > only slows down the race.
> > The synchronize_rcu_tasks_trace also behaves like synchronize_rcu.
> > See our new and fancy rcu_trace_implies_rcu_gp(),
> > but I'm not sure it applies to synchronize_rcu_tasks_rude.
> > Have you tried with just synchronize_rcu() ?
> > If your theory about the race is correct then
> > the vanila sync_rcu should help.
> > If not, the issue is some place else.
> 
> synchronize_rcu seems to work as well, I'll keep the test
> running for some time

looks good, Hao Sun, could you please test change below?

thanks,
jirka


---
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index c19719f48ce0..4b0fa5b98137 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 	}
 
 	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
+	synchronize_rcu();
 
 	if (new)
 		d->image_off = noff;
