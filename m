Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159626484E4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiLIPUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLIPUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:20:47 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B286D86F69;
        Fri,  9 Dec 2022 07:20:46 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n21so12224466ejb.9;
        Fri, 09 Dec 2022 07:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKeZ4tYHRTY5Y692xNjYg1a08hzNMUIopr7AUdLi5M4=;
        b=PNBXApaESWpfGef9izBo29+Y5AnTu56H5yKCAcWs6WDFoLy3/XYpV+ELlq+HI4oEP7
         czoq8uAjUybzA9JXkXLm3a2UozAKaYC4Bg6hzErN/yJEPG/ptNyaDIHDNp4lsFId7lCq
         QKfAQNaE2XdK5bhUK0AgLoqC39AFlC1v4qHjX+nxljxPb1Y8D1Q8GgSfZMsSfurFrS+j
         30QhV30swD4ZvyBhGdsGcY6/DIFez54YwBx379kmn4vXTGntK/ztnfDh0cxVD35lhNAe
         gh+KHrNmTqrkFuCZS/wnsPfYGW8XuMfrlsxZTdJLQYWQMHFWueC21UG5ZtCNZ+8hYfTW
         S9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKeZ4tYHRTY5Y692xNjYg1a08hzNMUIopr7AUdLi5M4=;
        b=iPiXBstnmFqcmHvuYfDiOl0XkzzOp+XRUlheC2Jb6dlzLPkZe+DYAGr4c/NCsi2PmC
         zKe2gGS0BBm5GweCDcRBgXK8Xw2NtSmS5A23tGhvR2onDysAs36ELf2CT3gj/dN5lPky
         oD5D7vGatzoZC3omI3HuIiTt8TW6h8WgYNzX3h5grLOKNormfBWHM0TSl3nCh2NkXG8C
         KKvQP/fQMI+9ruKNQFOSqqcwHgivvIy/QTBL/fpql55WQ7OE7PbORtVTRLLsgdp1fyTL
         0eNO7BzI84WvNuYFax96YFKmHHRkxTc5Dv8zmVQS3i67+WAhR9EXYd4CeMG9xdqr0vPQ
         OSLw==
X-Gm-Message-State: ANoB5pnrqeifzojA0MkkCib9dETmYm08aWM2BfaoprQGwOSk9JVcp0H0
        OHAtQjFRWW7usyARdYZbjG0=
X-Google-Smtp-Source: AA0mqf5pkWVFeQAqJ3SqwghDSS6FDSl+wzcpBiWvaMsTrudXR7RjxnRvElvwQmTw4QRXtDddlbdZ3Q==
X-Received: by 2002:a17:906:6ad7:b0:78d:f455:3105 with SMTP id q23-20020a1709066ad700b0078df4553105mr4410582ejs.45.1670599245111;
        Fri, 09 Dec 2022 07:20:45 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id k17-20020a170906055100b007806c1474e1sm16983eja.127.2022.12.09.07.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:20:44 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 9 Dec 2022 16:20:42 +0100
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Message-ID: <Y5NSStSi7h9Vdo/j@krava>
References: <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5M9P95l85oMHki9@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 02:50:55PM +0100, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:
> 
> SBIP
> 
> > > > > > > >
> > > > > > > > I'm trying to understand the severity of the issues and
> > > > > > > > whether we need to revert that commit asap since the merge window
> > > > > > > > is about to start.
> > > > > > > 
> > > > > > > Jiri, Peter,
> > > > > > > 
> > > > > > > ping.
> > > > > > > 
> > > > > > > cc-ing Thorsten, since he's tracking it now.
> > > > > > > 
> > > > > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > > > > Is it related?
> > > > > > 
> > > > > > sorry for late reply.. I still did not find the reason,
> > > > > > but I did not try with IBT yet, will test now
> > > > > 
> > > > > no difference with IBT enabled, can't reproduce the issue
> > > > > 
> > > > 
> > > > ok, scratch that.. the reproducer got stuck on wifi init :-\
> > > > 
> > > > after I fix that I can now reproduce on my local config with
> > > > IBT enabled or disabled.. it's something else
> > > 
> > > I'm getting the error also when reverting the static call change,
> > > looking for good commit, bisecting
> > > 
> > > I'm getting fail with:
> > >    f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
> > > 
> > > v6.1-rc1 is ok
> > 
> > so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
> > 
> > attaching some more logs
> 
> looking at the code.. how do we ensure that code running through
> bpf_prog_run_xdp will not get dispatcher image changed while
> it's being exetuted
> 
> we use 'the other half' of the image when we add/remove programs,
> but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
> 
> 
> cpu 0:                                  cpu 1:
> 
> bpf_prog_run_xdp
>    ...
>    bpf_dispatcher_xdp_func
>       start exec image at offset 0x0
> 
>                                         bpf_dispatcher_update
>                                                 update image at offset 0x800
>                                         bpf_dispatcher_update
>                                                 update image at offset 0x0
> 
>       still in image at offset 0x0
> 
> 
> that might explain why I wasn't able to trigger that on
> bare metal just in qemu

I tried patch below and it fixes the issue for me and seems
to confirm the race above.. but not sure it's the best fix

jirka


---
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
