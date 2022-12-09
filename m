Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE4647E4C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLIHJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIHJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:09:44 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042BB25C49;
        Thu,  8 Dec 2022 23:09:42 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v7so2904210wmn.0;
        Thu, 08 Dec 2022 23:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l5+rNzDfs1zsypdoRqJxdk+waRpxcBnDQcEOJe8SCHM=;
        b=n11oX8Rz9D6UWbDalnNpX6HxE7SvzadtkFPJa5QD8b90Eee3KsWJD1CSqAnNkV00mD
         h4euS6LoKlURhSoMTCdev/5GEIvQnZCvvCzGWTnGHRzBiOHzAtCXQwAy/hWp6aYKMO1r
         Hy33EvzZe/w7SR+no0EpmkyckFFGdsUXx6aKCqm1U+4ms/W57RhhGgYUf2Ddd+IJ+Azv
         kHopm2CnKlCw+/QArRxbcEN8wPjS0SdMf6exxTkeUzW2AUuK2YVbYClyqeUQJDw579Gh
         nmSn7XPGnywricthZv+HmOC7uiqP38RMdnsIA3BHd7eSA1sL3xOHl3RuApopLwaAyOus
         /Idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5+rNzDfs1zsypdoRqJxdk+waRpxcBnDQcEOJe8SCHM=;
        b=4bclhTZF3IHYHPKwt03ndobZlfw4havKIHTEtMNxB7w8lKzwBiKYWpnr6pdoKKwBNf
         HhCx8sD5M9KIjAXyNWsm+kUYMkI/EZx7CZa6AcWVnMP11/AhnOetb49oUdWx83fn/uSR
         MrwCdZ+LTDTDJUbZTycK7OO/e75IGz0en3rd0Vuiww61qJX8YM+fo5m4SzdGAxqaKX0j
         aXWtPXqws8YCMLL0iu/agZIu2WXFUYKAHFX5MHt39wcPQqz/o2e4U69njMsCyBGSzFT5
         xV01DbFPMGxy8tc8YqbZfwXHlXYOqKxxQ4lJVkPa0Vm4TuFU9yWlja2CknEKJjKWDZZy
         xITw==
X-Gm-Message-State: ANoB5pntDHGuhO4OOnH1SATRxRirwRwkt4E77FyL8u0CWV6GfNcDW9Ly
        UGCFdBaF5WH3uEX2M83Lgj8HicUU2yMeLw==
X-Google-Smtp-Source: AA0mqf7dUf3bFAaGY+YH7LRyCcxgc0zIdK9DsxDMlqPObxjk1ppqZYu3vJAVd9UA6boOjtOMxI0+DA==
X-Received: by 2002:a05:600c:6899:b0:3d1:cf66:3afa with SMTP id fn25-20020a05600c689900b003d1cf663afamr3748540wmb.19.1670569780354;
        Thu, 08 Dec 2022 23:09:40 -0800 (PST)
Received: from krava ([83.240.62.58])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c41c600b003b4935f04a4sm1094320wmh.5.2022.12.08.23.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 23:09:39 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 9 Dec 2022 08:09:36 +0100
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5LfMGbOHpaBfuw4@krava>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5JtACA8ay5QNEi7@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:02:24AM +0100, Jiri Olsa wrote:
> On Thu, Dec 08, 2022 at 11:26:45PM +0100, Jiri Olsa wrote:
> > On Thu, Dec 08, 2022 at 07:06:59PM +0100, Jiri Olsa wrote:
> > > On Thu, Dec 08, 2022 at 09:48:52AM -0800, Alexei Starovoitov wrote:
> > > > On Wed, Dec 7, 2022 at 11:57 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Dec 6, 2022 at 7:18 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> > > > > > > Hao Sun <sunhao.th@gmail.com> 于2022年12月6日周二 11:28写道：
> > > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > The following crash can be triggered with the BPF prog provided.
> > > > > > > > It seems the verifier passed some invalid progs. I will try to simplify
> > > > > > > > the C reproducer, for now, the following can reproduce this:
> > > > > > > >
> > > > > > > > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> > > > > > > > functions in bpf_iter_ksym
> > > > > > > > git tree: bpf-next
> > > > > > > > console log: https://pastebin.com/raw/87RCSnCs
> > > > > > > > kernel config: https://pastebin.com/raw/rZdWLcgK
> > > > > > > > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > > > > > > > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> > > > > > > >
> > > > > > >
> > > > > > > Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> > > > > > >
> > > > > > > Only two syscalls are required to reproduce this, seems it's an issue
> > > > > > > in XDP test run. Essentially, the reproducer just loads a very simple
> > > > > > > prog and tests run repeatedly and concurrently:
> > > > > > >
> > > > > > > r0 = bpf$PROG_LOAD(0x5, &(0x7f0000000640)=@base={0x6, 0xb,
> > > > > > > &(0x7f0000000500)}, 0x80)
> > > > > > > bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)={r0, 0x0, 0x0, 0x0, 0x0,
> > > > > > > 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> > > > > > >
> > > > > > > Loaded prog:
> > > > > > >    0: (18) r0 = 0x0
> > > > > > >    2: (18) r6 = 0x0
> > > > > > >    4: (18) r7 = 0x0
> > > > > > >    6: (18) r8 = 0x0
> > > > > > >    8: (18) r9 = 0x0
> > > > > > >   10: (95) exit
> > > > > >
> > > > > > hi,
> > > > > > I can reproduce with your config.. it seems related to the
> > > > > > recent static call change:
> > > > > >   c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
> > > > > >
> > > > > > I can't reproduce when I revert that commit.. Peter, any idea?
> > > > >
> > > > > Jiri,
> > > > >
> > > > > I see your tested-by tag on Peter's commit c86df29d11df.
> > > > > I assume you're actually tested it, but
> > > > > this syzbot oops shows that even empty bpf prog crashes,
> > > > > so there is something wrong with that commit.
> > > > >
> > > > > What is the difference between this new kconfig and old one that
> > > > > you've tested?
> > 
> > I attached the diff, 'config-issue' is the one that reproduces the issue
> > 
> > > > >
> > > > > I'm trying to understand the severity of the issues and
> > > > > whether we need to revert that commit asap since the merge window
> > > > > is about to start.
> > > > 
> > > > Jiri, Peter,
> > > > 
> > > > ping.
> > > > 
> > > > cc-ing Thorsten, since he's tracking it now.
> > > > 
> > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > Is it related?
> > > 
> > > sorry for late reply.. I still did not find the reason,
> > > but I did not try with IBT yet, will test now
> > 
> > no difference with IBT enabled, can't reproduce the issue
> > 
> 
> ok, scratch that.. the reproducer got stuck on wifi init :-\
> 
> after I fix that I can now reproduce on my local config with
> IBT enabled or disabled.. it's something else

I'm getting the error also when reverting the static call change,
looking for good commit, bisecting

I'm getting fail with:
   f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4

v6.1-rc1 is ok

jirka
