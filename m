Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE4647550
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLHSHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHSHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:07:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBAC2FBCE;
        Thu,  8 Dec 2022 10:07:04 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so2876382edb.9;
        Thu, 08 Dec 2022 10:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zlZ5JYrfoxlWWhYLoRlXAX2lb7aDsHfABVN0GPpBHNM=;
        b=lruSRpX2iU7Qy3Bybc+bFJcYPzpZBUHVHjfOKiYhVqC9kGN7RQfw/4mQ26JOMqEjdU
         gfY+acMolufoIoWyhLrYmzpzzNRx+B6o7rsP9hBsHfMyfTI4g71ZEiGSWASeGtr3FR9g
         AuF3W5S3rXfqbBHme3vWhMwKoiDPGaAPY1M0GsEPxqmORDknDR9YMWDRGsc78SLblTPB
         HrviXQ/jWJdPMqerf/ZNft1pgViT2wWbhAh7QYcDGJDDijO2JzlnFDuVDc8utzEPw+Zq
         PU1Ze8C5lLNq6gAsUoOlqxFZxf9NMXOzv1bKx3JxFWRjviEeWoKiufovPrvV/JaNut1k
         yZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zlZ5JYrfoxlWWhYLoRlXAX2lb7aDsHfABVN0GPpBHNM=;
        b=u1/v1H+tyYMqdz/J0V4tgHWAN8CGYqTECu4RlGNXvjoMLFpw+b8m+0Csxijuk98UDJ
         TT+cfVPOAXfW/eMxCb6HCUVulk3lIkR1hmESrk/4Qd+pM6q0knxfVexartviUwg0HuKa
         8p8fvzxUFTHwQkTGSu0+eB8IeHoNtb2SKmINrpDySnJw0D1psk0Mxz6Fx+uHmnE0W2zL
         Fq70wp6Sb1xMXfgvacgY00i0rvukRN4/RCPfRNQT5seYWuC9SjNaWCZIK3eDTXxmAmGC
         846vl5Mq+47jFiADWpYrxc+m7ejsYnpwJN7DP/xLg0dx5dkVNmb8gJmatakbgmGbLVtr
         vXQQ==
X-Gm-Message-State: ANoB5pklgLJhyZoxCCUz1mooR/Zke+qezTmDLbZmlWEEufV2pCcga/n+
        fu5WABu0tnJ7JnVoOXteMOs=
X-Google-Smtp-Source: AA0mqf7DiOruFzawmpbEDX8sSceVWIPq+u8dLVRJ5tc0JilGkZFIMKpo9H0anA7MpyB5lchyygmvBg==
X-Received: by 2002:a05:6402:370e:b0:463:398a:9fe7 with SMTP id ek14-20020a056402370e00b00463398a9fe7mr2413340edb.34.1670522822943;
        Thu, 08 Dec 2022 10:07:02 -0800 (PST)
Received: from krava (ip-78-102-146-30.bb.vodafone.cz. [78.102.146.30])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7cd8e000000b0046b00a9eeb5sm3634944edv.49.2022.12.08.10.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:07:02 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 8 Dec 2022 19:06:59 +0100
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Hao Sun <sunhao.th@gmail.com>,
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
Message-ID: <Y5Inw4HtkA2ql8GF@krava>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 09:48:52AM -0800, Alexei Starovoitov wrote:
> On Wed, Dec 7, 2022 at 11:57 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Dec 6, 2022 at 7:18 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> > > > Hao Sun <sunhao.th@gmail.com> 于2022年12月6日周二 11:28写道：
> > > > >
> > > > > Hi,
> > > > >
> > > > > The following crash can be triggered with the BPF prog provided.
> > > > > It seems the verifier passed some invalid progs. I will try to simplify
> > > > > the C reproducer, for now, the following can reproduce this:
> > > > >
> > > > > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> > > > > functions in bpf_iter_ksym
> > > > > git tree: bpf-next
> > > > > console log: https://pastebin.com/raw/87RCSnCs
> > > > > kernel config: https://pastebin.com/raw/rZdWLcgK
> > > > > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > > > > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> > > > >
> > > >
> > > > Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> > > >
> > > > Only two syscalls are required to reproduce this, seems it's an issue
> > > > in XDP test run. Essentially, the reproducer just loads a very simple
> > > > prog and tests run repeatedly and concurrently:
> > > >
> > > > r0 = bpf$PROG_LOAD(0x5, &(0x7f0000000640)=@base={0x6, 0xb,
> > > > &(0x7f0000000500)}, 0x80)
> > > > bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)={r0, 0x0, 0x0, 0x0, 0x0,
> > > > 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> > > >
> > > > Loaded prog:
> > > >    0: (18) r0 = 0x0
> > > >    2: (18) r6 = 0x0
> > > >    4: (18) r7 = 0x0
> > > >    6: (18) r8 = 0x0
> > > >    8: (18) r9 = 0x0
> > > >   10: (95) exit
> > >
> > > hi,
> > > I can reproduce with your config.. it seems related to the
> > > recent static call change:
> > >   c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
> > >
> > > I can't reproduce when I revert that commit.. Peter, any idea?
> >
> > Jiri,
> >
> > I see your tested-by tag on Peter's commit c86df29d11df.
> > I assume you're actually tested it, but
> > this syzbot oops shows that even empty bpf prog crashes,
> > so there is something wrong with that commit.
> >
> > What is the difference between this new kconfig and old one that
> > you've tested?
> >
> > I'm trying to understand the severity of the issues and
> > whether we need to revert that commit asap since the merge window
> > is about to start.
> 
> Jiri, Peter,
> 
> ping.
> 
> cc-ing Thorsten, since he's tracking it now.
> 
> The config has CONFIG_X86_KERNEL_IBT=y.
> Is it related?

sorry for late reply.. I still did not find the reason,
but I did not try with IBT yet, will test now

jirka
