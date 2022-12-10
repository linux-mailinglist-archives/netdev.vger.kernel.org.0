Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA2648EC0
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLJNGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLJNGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:06:02 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8120717E1C;
        Sat, 10 Dec 2022 05:06:00 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso1710830wmo.1;
        Sat, 10 Dec 2022 05:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=27Eo+slDUN1ZgaSRFRlIPd3Ur3Mbr3htVSAkvMHeGmc=;
        b=Ei8sTWxIUm+gOd2GOlpu/iDW9E7pCZfNWAsKVqSUr/4xJ28CFbXDUHXa9obe1A+pUB
         8pIND6xXgMdLisUWB1+i3u8oGGmFG8gqqvOMNbqP4hiVHqkbHr0QhZyazLCCrFxhzigj
         tQVpnzKKEtX+bHx0MjdGuLgcvlaciG7QeZOMJcwyL9URndcUWTR5MpfPA8D2LCL6IE7Z
         jBP5rhXZXzw6yslZ+4WWfjZWuyJlZIedt7mH6+HSJB4o6MFe+5YNOP0y3AfU0Ahj8czW
         /3ZSr92aPXt7tsgPmdAddRIaSvf8mcfktj++7+IDfIt6rlOebtfiUedIEKhZS4w7cEIO
         7RMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27Eo+slDUN1ZgaSRFRlIPd3Ur3Mbr3htVSAkvMHeGmc=;
        b=3NOhiaAthwXavNBx9ATMAeknJcoWYogLl6oK0b1/VZb7M0w/M3n1LrHr+4nH9lZsbn
         d8tmRBkYgK+KqMYpEW+UYTP3kdoIG7lM32vUDqkn1YR/SrjY4VIUE2jeKy1/Oq24AeKg
         MaT1mfLMQ2CP1AzPhu3YhNjnq7bc5uDIKEJ1kqFKABwGH9Ise0OVuCV0QfcM+y5s5meP
         DFqDe0PglNA7osNoLsiwwwjlmIRwJo7LVwWduNcUb5RXr+B9EH7xgMVB2SCBXk4At98F
         zRq+KGAq2A5pn/QYCa/plitZ3kSRDiDp/hpjlpAAMpxBdscvDkocsBa/is7dpi3UMk0u
         WC/w==
X-Gm-Message-State: ANoB5pm96a3GyVHWKF9lSr0A6I4VQf1MIgUDofLcKez9amlUh1s8BXI9
        1MQxTMqbbZg+C7ev2B5PjBNSxEi7gd++wA==
X-Google-Smtp-Source: AA0mqf4KqRiHTgQo0Pudn8z8toseuC3KLYD58N3Okl2KtjNq3vIXNr/y/Su/uIQpsnL/56jXjI2+qA==
X-Received: by 2002:a05:600c:3c95:b0:3d0:4af1:a36e with SMTP id bg21-20020a05600c3c9500b003d04af1a36emr7494590wmb.26.1670677558833;
        Sat, 10 Dec 2022 05:05:58 -0800 (PST)
Received: from krava ([83.240.60.179])
        by smtp.gmail.com with ESMTPSA id h17-20020a5d4fd1000000b0024246991121sm3725825wrw.116.2022.12.10.05.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 05:05:58 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 10 Dec 2022 14:05:55 +0100
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@meta.com>,
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
Message-ID: <Y5SEM3XgEdN8kAQ8@krava>
References: <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org>
 <Y5PNeFYJrC6D4P9p@krava>
 <20221210003838.GZ4001@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210003838.GZ4001@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 04:38:38PM -0800, Paul E. McKenney wrote:
> On Sat, Dec 10, 2022 at 01:06:16AM +0100, Jiri Olsa wrote:
> > On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> > > On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > > > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > > > 
> > > >    [...] One example of non-obvious pairing is the XDP feature in networking,
> > > >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> > > >    relies heavily on RCU protection for its data structures, but because the
> > > >    BPF program invocation happens entirely within a single local_bh_disable()
> > > >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> > > >    is safe is that readers can use anything that disables BH when updaters use
> > > >    call_rcu() or synchronize_rcu(). [...]
> > > 
> > > FWIW I sent a link to the thread to Paul and he confirmed 
> > > the RCU will wait for just the BH.
> > 
> > so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side
> > 
> > Paul,
> > any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
> > with bpf_prog_run_xdp callers?
> > 
> > with synchronize_rcu_tasks I'm getting splats like:
> >   https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f
> > 
> > synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)
> 
> It sounds like we are all talking past each other, leaving me no
> choice but to supply a wall of text:
> 
> It is quite true that synchronize_rcu_tasks_rude() will wait
> for bh-disabled regions of code, just like synchronize_rcu()
> and synchronize_rcu_tasks() will.  However, please note that
> synchronize_rcu_tasks() never waits on any of the idle tasks.  So the
> usual approach in tracing is to do both a synchronize_rcu_tasks() and
> synchronize_rcu_tasks_rude().  One way of overlapping the resulting
> pair of grace periods is to use synchronize_rcu_mult().
> 
> But none of these permit readers to sleep.  That is what
> synchronize_rcu_tasks_trace() is for, but unlike both
> synchronize_rcu_tasks() and synchronize_rcu_tasks_rude(),
> you must explicitly mark the readers with rcu_read_lock_trace()
> and rcu_read_unlock_trace().  This is used to protect sleepable
> BPF programs.
> 
> Now, synchronize_rcu() will also wait on bh-disabled lines of code, with
> the exception of such code in the exception path, way deep in the idle
> loop, early in the CPU-online process, or late in the CPU-offline process.
> You can recognize the first two categories of code by the noinstr tags
> on the functions.
> 
> And yes, synchronize_rcu_rude() is quite special.  ;-)
> 
> Does this help, or am I simply adding to the confusion?

I see, so as Alexei said to synchronize bpf_prog_run_xdp callers,
we should be able to use just synchronize_rcu, because it's allways
called just in bh-disabled code

thanks,
jirka
