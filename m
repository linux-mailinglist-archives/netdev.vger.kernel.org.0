Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D885648188
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLILWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLILWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:22:48 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD0664FF;
        Fri,  9 Dec 2022 03:22:43 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v7so3354946wmn.0;
        Fri, 09 Dec 2022 03:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eqRJB6eXA6zXxLo+5LhkhroEcZdvK7UHP+gfUJrPtck=;
        b=j8Az0vTXEdISilu4+502RvZpKTvAXERA0yIe9AGFlrIub7sp6snHxwwSGecL3TBtXQ
         3dSH92q2HfWGGuT+9X3UaBGHe76Wy4zHW5KKX39AVYHRqMD1lKKFalhBk6x1bPMYIDha
         fiLnhQPjL3GzmhF30BxzTau00wCF9TliMH14SXkQ5XzE1mlL3LLPoCg89lcGH/attEYl
         j7nLZGaysVb/l7ohx9Vih9br7X+x76ecmWHdsQIf3pbzeADm/KTgkr9pc7FLa6mIZlVD
         4u8MpP2WltLZ+yziiBVdzdAJVanOCQ1nSN4EYG03R+gf3/DFN7UnZkCO+pH2niVMqZJo
         4vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqRJB6eXA6zXxLo+5LhkhroEcZdvK7UHP+gfUJrPtck=;
        b=G5rXpNoE5xwr5e7N+Xj2pJy2qhzLn73FjAyACx7rdpHXvf9bjLoi/V+HfVCzTGiCXL
         /AuZdrTI6PI/AI1xDFuhlZPwxelqUIf4yTcp8ePaHNN7j2+WgBybALx36amiGBAwaQuO
         JBp8yEQHNZmkCV7Pmg6MLy0OdaSu4K4gLJBI0lOGxIR2OJ9r1Uvq5x6KH5LAdxR+QICk
         XUsOuYfZkfrT8quRgroUI+72XUxYZ5ANns2MtTqrgLWtOP3Vr2UsIKLZc5oPhgHyhw86
         svJ24Jm7sPjbspkD5+6iWKwee+V9DiYCIEDfhrZ5SmYqadFDEfsnS+O1c3nXBduNepSS
         6yUA==
X-Gm-Message-State: ANoB5pkQV58onlexOYLCQ1csYCtHZ/Q+YH4HiCMaTh9sZeB6KXHI7Pqx
        ki11fTanjC1MjXw/JaxYuxw=
X-Google-Smtp-Source: AA0mqf6IKinQBvAi0q78YJoCgH5nS3oCzf2hoeb2rJCOHO7xzgVIoelsElSRsuURu4TyE2pOGg6JAg==
X-Received: by 2002:a05:600c:34ca:b0:3cf:7624:5f98 with SMTP id d10-20020a05600c34ca00b003cf76245f98mr4626359wmq.18.1670584960760;
        Fri, 09 Dec 2022 03:22:40 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c434700b003d1e34bcbb2sm1459860wme.13.2022.12.09.03.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:22:40 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 9 Dec 2022 12:22:37 +0100
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
Message-ID: <Y5MaffJOe1QtumSN@krava>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5LfMGbOHpaBfuw4@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 08:09:36AM +0100, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 12:02:24AM +0100, Jiri Olsa wrote:
> > On Thu, Dec 08, 2022 at 11:26:45PM +0100, Jiri Olsa wrote:
> > > On Thu, Dec 08, 2022 at 07:06:59PM +0100, Jiri Olsa wrote:
> > > > On Thu, Dec 08, 2022 at 09:48:52AM -0800, Alexei Starovoitov wrote:
> > > > > On Wed, Dec 7, 2022 at 11:57 AM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Dec 6, 2022 at 7:18 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> > > > > > > > Hao Sun <sunhao.th@gmail.com> 于2022年12月6日周二 11:28写道：
> > > > > > > > >
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > The following crash can be triggered with the BPF prog provided.
> > > > > > > > > It seems the verifier passed some invalid progs. I will try to simplify
> > > > > > > > > the C reproducer, for now, the following can reproduce this:
> > > > > > > > >
> > > > > > > > > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> > > > > > > > > functions in bpf_iter_ksym
> > > > > > > > > git tree: bpf-next
> > > > > > > > > console log: https://pastebin.com/raw/87RCSnCs
> > > > > > > > > kernel config: https://pastebin.com/raw/rZdWLcgK
> > > > > > > > > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > > > > > > > > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> > > > > > > > >
> > > > > > > >
> > > > > > > > Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> > > > > > > >
> > > > > > > > Only two syscalls are required to reproduce this, seems it's an issue
> > > > > > > > in XDP test run. Essentially, the reproducer just loads a very simple
> > > > > > > > prog and tests run repeatedly and concurrently:
> > > > > > > >
> > > > > > > > r0 = bpf$PROG_LOAD(0x5, &(0x7f0000000640)=@base={0x6, 0xb,
> > > > > > > > &(0x7f0000000500)}, 0x80)
> > > > > > > > bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)={r0, 0x0, 0x0, 0x0, 0x0,
> > > > > > > > 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> > > > > > > >
> > > > > > > > Loaded prog:
> > > > > > > >    0: (18) r0 = 0x0
> > > > > > > >    2: (18) r6 = 0x0
> > > > > > > >    4: (18) r7 = 0x0
> > > > > > > >    6: (18) r8 = 0x0
> > > > > > > >    8: (18) r9 = 0x0
> > > > > > > >   10: (95) exit
> > > > > > >
> > > > > > > hi,
> > > > > > > I can reproduce with your config.. it seems related to the
> > > > > > > recent static call change:
> > > > > > >   c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
> > > > > > >
> > > > > > > I can't reproduce when I revert that commit.. Peter, any idea?
> > > > > >
> > > > > > Jiri,
> > > > > >
> > > > > > I see your tested-by tag on Peter's commit c86df29d11df.
> > > > > > I assume you're actually tested it, but
> > > > > > this syzbot oops shows that even empty bpf prog crashes,
> > > > > > so there is something wrong with that commit.
> > > > > >
> > > > > > What is the difference between this new kconfig and old one that
> > > > > > you've tested?
> > > 
> > > I attached the diff, 'config-issue' is the one that reproduces the issue
> > > 
> > > > > >
> > > > > > I'm trying to understand the severity of the issues and
> > > > > > whether we need to revert that commit asap since the merge window
> > > > > > is about to start.
> > > > > 
> > > > > Jiri, Peter,
> > > > > 
> > > > > ping.
> > > > > 
> > > > > cc-ing Thorsten, since he's tracking it now.
> > > > > 
> > > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > > Is it related?
> > > > 
> > > > sorry for late reply.. I still did not find the reason,
> > > > but I did not try with IBT yet, will test now
> > > 
> > > no difference with IBT enabled, can't reproduce the issue
> > > 
> > 
> > ok, scratch that.. the reproducer got stuck on wifi init :-\
> > 
> > after I fix that I can now reproduce on my local config with
> > IBT enabled or disabled.. it's something else
> 
> I'm getting the error also when reverting the static call change,
> looking for good commit, bisecting
> 
> I'm getting fail with:
>    f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
> 
> v6.1-rc1 is ok

so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far

attaching some more logs

jirka


---
qemu login: [   11.636290][  T426] systemd-journald[426]: File /var/log/journal/40bbad8a787448f29481225a589f919e/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
[   12.821205][   T39] kauditd_printk_skb: 115 callbacks suppressed
[   12.821208][   T39] audit: type=1100 audit(1670583961.042:197): pid=608 uid=0 auid=4294967295 ses=4294967295 msg='op=pubkey_auth grantors=auth-key acct="jolsa" exe="/usr/sbin/sshd" hostname=? addr=192.168.122.1 terminal=? res=success'
[   12.823533][   T39] audit: type=2404 audit(1670583961.044:198): pid=608 uid=0 auid=4294967295 ses=4294967295 msg='op=negotiate kind=auth-key fp=SHA256:71:b3:96:a4:91:24:79:28:d8:ce:72:79:e0:53:7a:ca:4e:77:6c:29:10:90:30:68:4e:3c:5e:eb:94:51:63:9b exe="/usr/sbin/sshd" hostname=? addr=192.168.122.1 terminal=? res=success'
[   12.828051][   T39] audit: type=1101 audit(1670583961.048:199): pid=608 uid=0 auid=4294967295 ses=4294967295 msg='op=PAM:accounting grantors=pam_unix acct="jolsa" exe="/usr/sbin/sshd" hostname=192.168.122.1 addr=192.168.122.1 terminal=ssh res=success'
[   12.830786][   T39] audit: type=2404 audit(1670583961.049:200): pid=608 uid=0 auid=4294967295 ses=4294967295 msg='op=destroy kind=session fp=? direction=both spid=609 suid=74 rport=52964 laddr=192.168.122.122 lport=22  exe="/usr/sbin/sshd" hostname=? addr=192.168.122.1 terminal=? res=success'
[   12.832878][   T39] audit: type=1103 audit(1670583961.051:201): pid=608 uid=0 auid=4294967295 ses=4294967295 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="jolsa" exe="/usr/sbin/sshd" hostname=192.168.122.1 addr=192.168.122.1 terminal=ssh res=success'
[   12.834687][   T39] audit: type=1006 audit(1670583961.051:202): pid=608 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=3 res=1
[   12.835858][   T39] audit: type=1300 audit(1670583961.051:202): arch=c000003e syscall=1 success=yes exit=4 a0=3 a1=7ffc4dad9730 a2=4 a3=7ffc4dad9444 items=0 ppid=529 pid=608 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=3 comm="sshd" exe="/usr/sbin/sshd" key=(null)
[   12.837980][   T39] audit: type=1327 audit(1670583961.051:202): proctitle=737368643A206A6F6C7361205B707269765D
[   12.845568][   T39] audit: type=1105 audit(1670583961.066:203): pid=608 uid=0 auid=1000 ses=3 msg='op=PAM:session_open grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_umask,pam_lastlog acct="jolsa" exe="/usr/sbin/sshd" hostname=192.168.122.1 addr=192.168.122.1 terminal=ssh res=success'
[   12.849131][   T39] audit: type=2404 audit(1670583961.070:204): pid=610 uid=0 auid=1000 ses=3 msg='op=destroy kind=server fp=SHA256:32:64:30:00:6f:e5:c8:de:ac:93:9f:16:44:54:ca:e5:b0:81:b7:5d:98:ca:2a:b7:82:2c:4c:1d:d6:b3:df:77 direction=? spid=610 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
[   19.620886][   T39] kauditd_printk_skb: 8 callbacks suppressed
[   19.620892][   T39] audit: type=1131 audit(1670583967.896:213): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=NetworkManager-dispatcher comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   20.490153][   T39] audit: type=1100 audit(1670583968.765:214): pid=649 uid=1000 auid=1000 ses=1 msg='op=PAM:authentication grantors=pam_unix acct="root" exe="/usr/bin/su" hostname=? addr=? terminal=/dev/pts/0 res=success'
[   20.491943][   T39] audit: type=1101 audit(1670583968.766:215): pid=649 uid=1000 auid=1000 ses=1 msg='op=PAM:accounting grantors=pam_unix acct="root" exe="/usr/bin/su" hostname=? addr=? terminal=/dev/pts/0 res=success'
[   20.493315][   T39] audit: type=1103 audit(1670583968.766:216): pid=649 uid=1000 auid=1000 ses=1 msg='op=PAM:setcred grantors=pam_unix acct="root" exe="/usr/bin/su" hostname=? addr=? terminal=/dev/pts/0 res=success'
[   20.495303][   T39] audit: type=1105 audit(1670583968.770:217): pid=649 uid=1000 auid=1000 ses=1 msg='op=PAM:session_open grantors=pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_umask,pam_xauth acct="root" exe="/usr/bin/su" hostname=? addr=? terminal=/dev/pts/0 res=success'
[   21.231586][   T39] audit: type=1334 audit(1670583969.501:218): prog-id=62 op=LOAD
[   21.232374][   T39] audit: type=1300 audit(1670583969.501:218): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=671 pid=695 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   21.234509][   T39] audit: type=1327 audit(1670583969.501:218): proctitle="./ex"
[   21.235263][   T39] audit: type=1334 audit(1670583969.508:219): prog-id=63 op=LOAD
[   21.236083][   T39] audit: type=1300 audit(1670583969.508:219): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=689 pid=701 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   24.631397][   T39] kauditd_printk_skb: 1016 callbacks suppressed
[   24.631401][   T39] audit: type=1334 audit(1670583972.906:713): prog-id=325 op=LOAD
[   24.635026][   T39] audit: type=1300 audit(1670583972.906:713): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=914 pid=1258 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=3 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   24.637319][   T39] audit: type=1327 audit(1670583972.906:713): proctitle="./ex"
[   24.658246][   T39] audit: type=1334 audit(1670583972.933:714): prog-id=0 op=UNLOAD
[   24.668807][   T39] audit: type=1334 audit(1670583972.940:715): prog-id=326 op=LOAD
[   24.670751][   T39] audit: type=1300 audit(1670583972.940:715): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=887 pid=1260 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=3 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   24.673003][   T39] audit: type=1327 audit(1670583972.940:715): proctitle="./ex"
[   24.673694][   T39] audit: type=1334 audit(1670583972.948:716): prog-id=0 op=UNLOAD
[   24.689115][   T39] audit: type=1334 audit(1670583972.964:717): prog-id=0 op=UNLOAD
[   24.689878][   T39] audit: type=1334 audit(1670583972.957:718): prog-id=327 op=LOAD

qemu login: [   28.814608][ T1929] general protection fault, maybe for address 0xffff88816c028040: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   28.815875][ T1929] CPU: 3 PID: 1929 Comm: ex Not tainted 6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   28.817009][ T1929] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   28.818012][ T1929] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   28.818646][ T1929] Code: ff ff e2 90 48 81 fa d4 54 01 a0 7f 17 48 81 fa d4 54 01 a0 0f 84 ae 39 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 10 55 01 <a0> 0f 84 d3 39 e1 ff ff e2 90 48 81 fa 48 56 01 a0 7f 37 48 81 fa
[   28.820640][ T1929] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   28.821325][ T1929] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   28.822190][ T1929] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   28.825712][ T1929] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   28.826759][ T1929] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   28.827616][ T1929] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   28.828453][ T1929] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   28.829369][ T1929] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.830059][ T1929] CR2: 00007ffc40078d88 CR3: 000000016c1b0001 CR4: 0000000000770ee0
[   28.830870][ T1929] PKRU: 55555554
[   28.831284][ T1929] Call Trace:
[   28.831662][ T1929]  <TASK>
[   28.832012][ T1929]  ? bpf_test_run+0x104/0x2e0
[   28.832531][ T1929]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   28.833155][ T1929]  ? bpf_prog_test_run_xdp+0x463/0x600
[   28.833718][ T1929]  ? __sys_bpf+0xf52/0x29e0
[   28.834223][ T1929]  ? rcu_read_lock_sched_held+0x10/0x90
[   28.834810][ T1929]  ? rcu_read_lock_sched_held+0x10/0x90
[   28.835409][ T1929]  ? rcu_read_lock_sched_held+0x10/0x90
[   28.836001][ T1929]  ? lock_release+0x25e/0x4e0
[   28.836510][ T1929]  ? rcu_read_lock_sched_held+0x10/0x90
[   28.837096][ T1929]  ? rcu_read_lock_sched_held+0x10/0x90
[   28.837688][ T1929]  ? __x64_sys_bpf+0x1a/0x30
[   28.838209][ T1929]  ? do_syscall_64+0x37/0x90
[   28.838708][ T1929]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   28.839315][ T1929]  </TASK>
[   28.839668][ T1929] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   28.841792][ T1929] ---[ end trace 0000000000000000 ]---
[   28.842370][ T1929] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   28.843023][ T1929] Code: ff ff e2 90 48 81 fa d4 54 01 a0 7f 17 48 81 fa d4 54 01 a0 0f 84 ae 39 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 10 55 01 <a0> 0f 84 d3 39 e1 ff ff e2 90 48 81 fa 48 56 01 a0 7f 37 48 81 fa
[   28.844901][ T1929] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   28.845519][ T1929] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   28.846356][ T1929] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   28.847203][ T1929] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   28.848039][ T1929] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   28.848883][ T1929] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   28.849713][ T1929] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   28.850615][ T1929] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.851294][ T1929] CR2: 00007ffc40078d88 CR3: 000000016c1b0001 CR4: 0000000000770ee0
[   28.852097][ T1929] PKRU: 55555554
[   29.111770][ T1929] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   29.120530][ T1929] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1929, name: ex
[   29.128048][ T1929] preempt_count: 0, expected: 0
[   29.128673][ T1929] RCU nest depth: 1, expected: 0
[   29.149471][ T1929] INFO: lockdep is turned off.
[   29.149957][ T1929] CPU: 3 PID: 1929 Comm: ex Tainted: G      D            6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   29.151124][ T1929] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   29.152087][ T1929] Call Trace:
[   29.152474][ T1929]  <TASK>
[   29.152815][ T1929]  dump_stack_lvl+0xa4/0xee
[   29.153322][ T1929]  __might_resched.cold+0x117/0x152
[   29.153883][ T1929]  exit_signals+0x1a/0x330
[   29.154349][ T1929]  do_exit+0x15b/0xca0
[   29.154772][ T1929]  make_task_dead+0x51/0x60
[   29.155256][ T1929]  rewind_stack_and_make_dead+0x17/0x20
[   29.157415][ T1929] RIP: 0033:0x7f54fad0af3d
[   29.158008][ T1929] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   29.159869][ T1929] RSP: 002b:00007f54fafbcdf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   29.161047][ T1929] RAX: ffffffffffffffda RBX: 00007f54fafbd640 RCX: 00007f54fad0af3d
[   29.162194][ T1929] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   29.163076][ T1929] RBP: 00007f54fafbce20 R08: 0000000000000000 R09: 0000000000000000
[   29.163970][ T1929] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   29.172103][ T1929] R13: 0000000000000011 R14: 00007ffce4ffe480 R15: 00007f54faf9d000
[   29.173070][ T1929]  </TASK>
[   29.640510][   T39] kauditd_printk_skb: 1464 callbacks suppressed
[   29.640514][   T39] audit: type=1334 audit(1670583977.914:1449): prog-id=0 op=UNLOAD
[   29.641896][   T39] audit: type=1334 audit(1670583977.915:1450): prog-id=0 op=UNLOAD
[   29.643133][   T39] audit: type=1334 audit(1670583977.917:1451): prog-id=0 op=UNLOAD
[   29.648355][   T39] audit: type=1334 audit(1670583977.922:1452): prog-id=0 op=UNLOAD
[   29.651264][   T39] audit: type=1334 audit(1670583977.925:1453): prog-id=694 op=LOAD
[   29.652328][   T39] audit: type=1300 audit(1670583977.925:1453): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=697 pid=2053 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   29.655143][   T39] audit: type=1327 audit(1670583977.925:1453): proctitle="./ex"
[   29.663730][   T39] audit: type=1334 audit(1670583977.930:1454): prog-id=695 op=LOAD
[   29.664744][   T39] audit: type=1300 audit(1670583977.930:1454): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=7ffc40078ccf items=0 ppid=696 pid=2051 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   29.667542][   T39] audit: type=1327 audit(1670583977.930:1454): proctitle="./ex"
[   32.276514][ T2422] invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   32.277323][ T2422] CPU: 0 PID: 2422 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   32.278294][ T2422] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   32.279082][ T2422] RIP: 0010:bpf_dispatcher_xdp+0x45/0x1000
[   32.279560][ T2422] Code: 81 fa 94 39 01 a0 0f 8f 69 00 00 00 48 81 fa d0 38 01 a0 7f 30 48 81 fa 94 36 01 a0 7f 17 48 81 fa 94 36 01 a0 0f 84 4e 26 e1 <ff> ff e2 0f 1f 84 00 00 00 00 00 48 81 fa d0 38 01 a0 0f 84 73 28
[   32.281053][ T2422] RSP: 0018:ffffc90004dbfc38 EFLAGS: 00010246
[   32.281559][ T2422] RAX: ffff88816ba93640 RBX: ffffc900058a1000 RCX: ffffc90004dbfc6b
[   32.283036][ T2422] RDX: ffffffffa0013694 RSI: ffffc900058a1048 RDI: ffffc90004dbfd38
[   32.283692][ T2422] RBP: ffffc90004dbfd38 R08: ffffc90004dbfd34 R09: 0000000000000000
[   32.284334][ T2422] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900058a1048
[   32.284970][ T2422] R13: ffffc90004dbfd30 R14: 0000000000000001 R15: ffffc90004dbfc98
[   32.285636][ T2422] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   32.286342][ T2422] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.286853][ T2422] CR2: 00007f54faca0cb0 CR3: 000000016b744001 CR4: 0000000000770ef0
[   32.287504][ T2422] PKRU: 55555554
[   32.287814][ T2422] Call Trace:
[   32.288119][ T2422]  <TASK>
[   32.288388][ T2422]  ? bpf_test_run+0x104/0x2e0
[   32.288780][ T2422]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   32.289323][ T2422]  ? bpf_prog_test_run_xdp+0x463/0x600
[   32.289801][ T2422]  ? __sys_bpf+0xf52/0x29e0
[   32.290175][ T2422]  ? rcu_read_lock_sched_held+0x10/0x90
[   32.290605][ T2422]  ? rcu_read_lock_sched_held+0x10/0x90
[   32.291038][ T2422]  ? rcu_read_lock_sched_held+0x10/0x90
[   32.291479][ T2422]  ? lock_release+0x25e/0x4e0
[   32.291858][ T2422]  ? rcu_read_lock_sched_held+0x10/0x90
[   32.292294][ T2422]  ? rcu_read_lock_sched_held+0x10/0x90
[   32.292726][ T2422]  ? __x64_sys_bpf+0x1a/0x30
[   32.293160][ T2422]  ? do_syscall_64+0x37/0x90
[   32.293589][ T2422]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   32.294140][ T2422]  </TASK>
[   32.294446][ T2422] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   32.437961][ T2422] ---[ end trace 0000000000000000 ]---
[   32.438604][ T2422] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   32.445554][ T2422] Code: ff ff e2 90 48 81 fa 4c 57 01 a0 7f 17 48 81 fa 4c 57 01 a0 0f 84 26 3c e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 0c 58 01 <a0> 0f 84 cf 3c e1 ff ff e2 90 48 81 fa 14 59 01 a0 7f 37 48 81 fa
[   32.461341][ T2422] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   32.462010][ T2422] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   32.480561][ T2422] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   32.481411][ T2422] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   32.489628][ T2422] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   32.490518][ T2422] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   32.500730][ T2422] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   32.501583][ T2422] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.513784][ T2422] CR2: 00007fbae8ca0cb0 CR3: 000000016b744006 CR4: 0000000000770ef0
[   32.514617][ T2422] PKRU: 55555554
[   32.523500][ T2422] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   32.533568][ T2422] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 2422, name: ex
[   32.534312][ T2422] preempt_count: 0, expected: 0
[   32.543228][ T2422] RCU nest depth: 1, expected: 0
[   32.543765][ T2422] INFO: lockdep is turned off.
[   32.544255][ T2422] CPU: 0 PID: 2422 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   32.545401][ T2422] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   32.546314][ T2422] Call Trace:
[   32.546675][ T2422]  <TASK>
[   32.547012][ T2422]  dump_stack_lvl+0xa4/0xee
[   32.547481][ T2422]  __might_resched.cold+0x117/0x152
[   32.548013][ T2422]  exit_signals+0x1a/0x330
[   32.548464][ T2422]  do_exit+0x15b/0xca0
[   32.548889][ T2422]  make_task_dead+0x51/0x60
[   32.549352][ T2422]  rewind_stack_and_make_dead+0x17/0x20
[   32.549899][ T2422] RIP: 0033:0x7fbae8d0af3d
[   32.550375][ T2422] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   32.552204][ T2422] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   32.553055][ T2422] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   32.554663][ T2422] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   32.555385][ T2422] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   32.556085][ T2422] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   32.556887][ T2422] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   32.557896][ T2422]  </TASK>
[   33.868052][ T2675] invalid opcode: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   33.868761][ T2675] CPU: 3 PID: 2675 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   33.869733][ T2675] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   33.870511][ T2675] RIP: 0010:bpf_dispatcher_xdp+0x9dc/0x1000
[   33.871012][ T2675] Code: fa 10 55 01 a0 7f 17 48 81 fa 10 55 01 a0 0f 84 4a 3b e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 48 55 01 a0 0f 84 6b 3b e1 <ff> ff e2 90 48 81 fa 8c 59 01 a0 0f 8f e3 00 00 00 48 81 fa 88 56
[   33.872504][ T2675] RSP: 0018:ffffc90005c2bc38 EFLAGS: 00010297
[   33.872996][ T2675] RAX: ffff88816b713640 RBX: ffffc90005d3f000 RCX: ffffc90005c2bc6c
[   33.873645][ T2675] RDX: ffffffffa00155d4 RSI: ffffc90005d3f048 RDI: ffffc90005c2bd38
[   33.874303][ T2675] RBP: ffffc90005c2bd38 R08: ffffc90005c2bd34 R09: 0000000000000000
[   33.875710][ T2675] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90005d3f048
[   33.876375][ T2675] R13: ffffc90005c2bd30 R14: 0000000000000001 R15: ffffc90005c2bc98
[   33.877034][ T2675] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   33.877751][ T2675] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   33.878282][ T2675] CR2: 00007f54fafbf0e8 CR3: 000000016b920002 CR4: 0000000000770ee0
[   33.878945][ T2675] PKRU: 55555554
[   33.879261][ T2675] Call Trace:
[   33.879603][ T2675]  <TASK>
[   33.879926][ T2675]  ? bpf_test_run+0x104/0x2e0
[   33.880392][ T2675]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   33.881029][ T2675]  ? bpf_prog_test_run_xdp+0x463/0x600
[   33.881565][ T2675]  ? __sys_bpf+0xf52/0x29e0
[   33.882006][ T2675]  ? rcu_read_lock_sched_held+0x10/0x90
[   33.882518][ T2675]  ? rcu_read_lock_sched_held+0x10/0x90
[   33.883027][ T2675]  ? rcu_read_lock_sched_held+0x10/0x90
[   33.883462][ T2675]  ? lock_release+0x25e/0x4e0
[   33.883846][ T2675]  ? rcu_read_lock_sched_held+0x10/0x90
[   33.884295][ T2675]  ? rcu_read_lock_sched_held+0x10/0x90
[   33.884734][ T2675]  ? __x64_sys_bpf+0x1a/0x30
[   33.885117][ T2675]  ? do_syscall_64+0x37/0x90
[   33.885499][ T2675]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   33.885988][ T2675]  </TASK>
[   33.886265][ T2675] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   34.010718][ T2677] general protection fault, maybe for address 0xffff88816d8d0040: 0000 [#4] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   34.012030][ T2677] CPU: 0 PID: 2677 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   34.013249][ T2677] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   34.014231][ T2677] RIP: 0010:bpf_dispatcher_xdp+0x1e0/0x1000
[   34.014906][ T2677] Code: a0 7f 17 48 81 fa 10 55 01 a0 0f 84 4a 43 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 48 55 01 a0 0f 84 6b 43 e1 ff ff e2 90 <48> 81 fa 94 5d 01 a0 0f 8f e3 00 00 00 48 81 fa 0c 57 01 a0 0f 8f
[   34.016968][ T2677] RSP: 0018:ffffc90004da7c38 EFLAGS: 00010202
[   34.017644][ T2677] RAX: ffff88816d8d0040 RBX: ffffc90005d45000 RCX: ffffc90004da7c6c
[   34.018562][ T2677] RDX: ffffffffa001560c RSI: ffffc90005d45048 RDI: ffffc90004da7d38
[   34.019483][ T2677] RBP: ffffc90004da7d38 R08: ffffc90004da7d34 R09: 0000000000000000
[   34.020400][ T2677] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90005d45048
[   34.021323][ T2677] R13: ffffc90004da7d30 R14: 0000000000000001 R15: ffffc90004da7c98
[   34.022249][ T2677] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   34.023266][ T2677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.024003][ T2677] CR2: 00007f54fafbf0e8 CR3: 000000016b886002 CR4: 0000000000770ef0
[   34.024899][ T2677] PKRU: 55555554
[   34.025352][ T2677] Call Trace:
[   34.026858][ T2677]  <TASK>
[   34.027253][ T2677]  ? bpf_test_run+0x104/0x2e0
[   34.027792][ T2677]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   34.028452][ T2677]  ? bpf_prog_test_run_xdp+0x463/0x600
[   34.029059][ T2677]  ? __sys_bpf+0xf52/0x29e0
[   34.029574][ T2677]  ? rcu_read_lock_sched_held+0x10/0x90
[   34.030189][ T2677]  ? rcu_read_lock_sched_held+0x10/0x90
[   34.030805][ T2677]  ? rcu_read_lock_sched_held+0x10/0x90
[   34.031407][ T2677]  ? lock_release+0x25e/0x4e0
[   34.031950][ T2677]  ? rcu_read_lock_sched_held+0x10/0x90
[   34.032563][ T2677]  ? rcu_read_lock_sched_held+0x10/0x90
[   34.033184][ T2677]  ? __x64_sys_bpf+0x1a/0x30
[   34.033712][ T2677]  ? do_syscall_64+0x37/0x90
[   34.034232][ T2677]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   34.034899][ T2677]  </TASK>
[   34.035292][ T2677] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   34.040645][ T2675] ---[ end trace 0000000000000000 ]---
[   34.041155][ T2675] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   34.047020][ T2675] Code: 00 00 00 00 48 81 fa 8c 5e 01 a0 0f 84 6f 43 e1 ff ff e2 90 48 81 fa 10 5f 01 a0 7f 37 48 81 fa c8 5e 01 a0 7f 1e 48 81 fa c8 <5e> 01 a0 0f 84 89 43 e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80
[   34.056131][ T2675] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   34.056665][ T2675] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   34.066719][ T2675] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   34.067351][ T2675] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   34.073297][ T2675] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   34.073962][ T2675] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   34.082487][ T2675] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   34.085318][ T2675] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.085802][ T2675] CR2: 00007f54fafc87c4 CR3: 000000016b920003 CR4: 0000000000770ee0
[   34.091924][ T2675] PKRU: 55555554
[   34.092252][ T2675] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   34.100508][ T2675] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 2675, name: ex
[   34.101179][ T2675] preempt_count: 0, expected: 0
[   34.106485][ T2675] RCU nest depth: 1, expected: 0
[   34.109046][ T2675] INFO: lockdep is turned off.
[   34.109420][ T2675] CPU: 3 PID: 2675 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   34.110271][ T2675] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   34.110993][ T2675] Call Trace:
[   34.111326][ T2675]  <TASK>
[   34.111618][ T2675]  dump_stack_lvl+0xa4/0xee
[   34.111974][ T2675]  __might_resched.cold+0x117/0x152
[   34.112361][ T2675]  exit_signals+0x1a/0x330
[   34.112702][ T2675]  do_exit+0x15b/0xca0
[   34.113024][ T2675]  make_task_dead+0x51/0x60
[   34.113365][ T2675]  rewind_stack_and_make_dead+0x17/0x20
[   34.113811][ T2675] RIP: 0033:0x7f54fad0af3d
[   34.114196][ T2675] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   34.115549][ T2675] RSP: 002b:00007f54fafbcdf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   34.116175][ T2675] RAX: ffffffffffffffda RBX: 00007f54fafbd640 RCX: 00007f54fad0af3d
[   34.116777][ T2675] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   34.117386][ T2675] RBP: 00007f54fafbce20 R08: 0000000000000000 R09: 0000000000000000
[   34.118793][ T2675] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   34.119454][ T2675] R13: 0000000000000011 R14: 00007ffce4ffe480 R15: 00007f54faf9d000
[   34.120067][ T2675]  </TASK>
[   34.186138][ T2677] ---[ end trace 0000000000000000 ]---
[   34.186678][ T2677] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   34.192847][ T2677] Code: 00 00 00 00 48 81 fa 10 5f 01 a0 0f 84 f3 43 e1 ff ff e2 90 48 81 fa 48 5f 01 a0 0f 84 1b 44 e1 ff ff e2 a0 7f 1e 48 81 fa c8 <5e> 01 a0 0f 84 89 43 e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80
[   34.272320][ T2677] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   34.273055][ T2677] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   34.273994][ T2677] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   34.274914][ T2677] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   34.275835][ T2677] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   34.306476][ T2677] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   34.307503][ T2677] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   34.308549][ T2677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.309313][ T2677] CR2: 00007f54faca0cb0 CR3: 000000016b886005 CR4: 0000000000770ef0
[   34.310272][ T2677] PKRU: 55555554
[   34.645273][   T39] kauditd_printk_skb: 1544 callbacks suppressed
[   34.645276][   T39] audit: type=1334 audit(1670583982.915:2225): prog-id=1083 op=LOAD
[   34.646916][   T39] audit: type=1300 audit(1670583982.915:2225): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=674 pid=2833 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   34.652629][   T39] audit: type=1327 audit(1670583982.915:2225): proctitle="./ex"
[   34.687255][   T39] audit: type=1334 audit(1670583982.961:2226): prog-id=0 op=UNLOAD
[   34.690015][   T39] audit: type=1334 audit(1670583982.964:2227): prog-id=0 op=UNLOAD
[   34.700638][   T39] audit: type=1334 audit(1670583982.971:2228): prog-id=1084 op=LOAD
[   34.701762][   T39] audit: type=1300 audit(1670583982.971:2228): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=916 pid=2836 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=3 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   34.703962][   T39] audit: type=1327 audit(1670583982.971:2228): proctitle="./ex"
[   34.706978][   T39] audit: type=1334 audit(1670583982.981:2229): prog-id=0 op=UNLOAD
[   34.708026][   T39] audit: type=1334 audit(1670583982.974:2230): prog-id=1085 op=LOAD
[   36.268570][ T2982] invalid opcode: 0000 [#5] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   36.269752][ T2982] CPU: 2 PID: 2982 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   36.271420][ T2982] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   36.272734][ T2982] RIP: 0010:bpf_dispatcher_xdp+0x289/0x1000
[   36.273658][ T2982] Code: a0 0f 84 a2 39 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 54 50 01 a0 0f 84 d7 3d e1 ff ff e2 90 48 81 fa 10 55 01 a0 7f 37 <48> 81 fa 88 54 01 a0 7f 1e 48 81 fa 88 54 01 a0 0f 84 e9 41 e1 ff
[   36.276566][ T2982] RSP: 0018:ffffc900061d7c38 EFLAGS: 00010246
[   36.277519][ T2982] RAX: ffff88816b333640 RBX: ffffc90006369000 RCX: ffffc900061d7c6c
[   36.278777][ T2982] RDX: ffffffffa0015648 RSI: ffffc90006369048 RDI: ffffc900061d7d38
[   36.280053][ T2982] RBP: ffffc900061d7d38 R08: ffffc900061d7d34 R09: 0000000000000000
[   36.281319][ T2982] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006369048
[   36.282592][ T2982] R13: ffffc900061d7d30 R14: 0000000000000001 R15: ffffc900061d7c98
[   36.283848][ T2982] FS:  00007f54fafbd640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   36.285264][ T2982] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.288251][ T2982] CR2: 00007f54fafbf0e8 CR3: 000000016b30a005 CR4: 0000000000770ee0
[   36.289876][ T2982] PKRU: 55555554
[   36.290526][ T2982] Call Trace:
[   36.301923][ T2982]  <TASK>
[   36.302662][ T2982]  ? bpf_test_run+0x104/0x2e0
[   36.304593][ T2982]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   36.305910][ T2982]  ? bpf_prog_test_run_xdp+0x463/0x600
[   36.307075][ T2982]  ? __sys_bpf+0xf52/0x29e0
[   36.308019][ T2982]  ? rcu_read_lock_sched_held+0x10/0x90
[   36.309178][ T2982]  ? rcu_read_lock_sched_held+0x10/0x90
[   36.310379][ T2982]  ? rcu_read_lock_sched_held+0x10/0x90
[   36.311958][ T2982]  ? lock_release+0x25e/0x4e0
[   36.312658][ T2982]  ? rcu_read_lock_sched_held+0x10/0x90
[   36.313501][ T2982]  ? rcu_read_lock_sched_held+0x10/0x90
[   36.314290][ T2982]  ? __x64_sys_bpf+0x1a/0x30
[   36.315065][ T2982]  ? do_syscall_64+0x37/0x90
[   36.316004][ T2982]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   36.317256][ T2982]  </TASK>
[   36.319366][ T2982] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   36.689960][ T2982] ---[ end trace 0000000000000000 ]---
[   36.734063][ T2982] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   36.748599][ T2982] Code: ff ff e2 90 48 81 fa 88 5a 01 a0 7f 17 48 81 fa 88 5a 01 a0 0f 84 62 3f e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 8c 5d 01 <a0> 0f 84 4f 42 e1 ff ff e2 90 48 81 fa 94 5e 01 a0 7f 37 48 81 fa
[   36.779760][ T2982] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   36.784900][ T2982] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   36.791209][ T2982] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   36.799262][ T2982] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   36.805360][ T2982] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   36.812419][ T2982] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   36.818836][ T2982] FS:  00007f54fafbd640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   36.828321][ T2982] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.834507][ T2982] CR2: 00007fa1a4ebe130 CR3: 000000016b30a006 CR4: 0000000000770ee0
[   36.840156][ T2982] PKRU: 55555554
[   36.842810][ T2982] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   36.848438][ T2982] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 2982, name: ex
[   36.853085][ T2982] preempt_count: 0, expected: 0
[   36.855260][ T2982] RCU nest depth: 1, expected: 0
[   36.858509][ T2982] INFO: lockdep is turned off.
[   36.860600][ T2982] CPU: 2 PID: 2982 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   36.863985][ T2982] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   36.865881][ T2982] Call Trace:
[   36.866605][ T2982]  <TASK>
[   36.867271][ T2982]  dump_stack_lvl+0xa4/0xee
[   36.868197][ T2982]  __might_resched.cold+0x117/0x152
[   36.869235][ T2982]  exit_signals+0x1a/0x330
[   36.870196][ T2982]  do_exit+0x15b/0xca0
[   36.871125][ T2982]  make_task_dead+0x51/0x60
[   36.872109][ T2982]  rewind_stack_and_make_dead+0x17/0x20
[   36.873212][ T2982] RIP: 0033:0x7f54fad0af3d
[   36.874135][ T2982] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   36.877941][ T2982] RSP: 002b:00007f54fafbcdf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   36.882779][ T2982] RAX: ffffffffffffffda RBX: 00007f54fafbd640 RCX: 00007f54fad0af3d
[   36.884447][ T2982] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   36.886013][ T2982] RBP: 00007f54fafbce20 R08: 0000000000000000 R09: 0000000000000000
[   36.887569][ T2982] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   36.889119][ T2982] R13: 0000000000000011 R14: 00007ffce4ffe480 R15: 00007f54faf9d000
[   36.891940][ T2982]  </TASK>
[   37.141945][ T3173] invalid opcode: 0000 [#6] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   37.143774][ T3173] CPU: 0 PID: 3173 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   37.146361][ T3173] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   37.148357][ T3173] RIP: 0010:bpf_dispatcher_xdp+0x253/0x1000
[   37.149641][ T3173] Code: a0 7f 14 48 81 fa cc 45 01 a0 0f 84 93 33 e1 ff ff e2 0f 1f 44 00 00 48 81 fa 8c 46 01 a0 0f 84 3f 34 e1 ff ff e2 90 48 81 fa <d4> 46 01 a0 7f 17 48 81 fa d4 46 01 a0 0f 84 6e 34 e1 ff ff e2 0f
[   37.153589][ T3173] RSP: 0018:ffffc9000674fc38 EFLAGS: 00010293
[   37.154909][ T3173] RAX: ffff88816b5b3640 RBX: ffffc90006753000 RCX: ffffc9000674fc6c
[   37.161963][ T3173] RDX: ffffffffa0014550 RSI: ffffc90006753048 RDI: ffffc9000674fd38
[   37.163727][ T3173] RBP: ffffc9000674fd38 R08: ffffc9000674fd34 R09: 0000000000000000
[   37.165971][ T3173] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006753048
[   37.167758][ T3173] R13: ffffc9000674fd30 R14: 0000000000000001 R15: ffffc9000674fc98
[   37.169591][ T3173] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   37.171601][ T3173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.173035][ T3173] CR2: 00007fbae8e1a7c4 CR3: 000000016b486004 CR4: 0000000000770ef0
[   37.174750][ T3173] PKRU: 55555554
[   37.175510][ T3173] Call Trace:
[   37.176200][ T3173]  <TASK>
[   37.176850][ T3173]  ? bpf_test_run+0x104/0x2e0
[   37.177801][ T3173]  ? wake_up_q+0x4a/0x90
[   37.178705][ T3173]  ? bpf_prog_test_run_xdp+0x463/0x600
[   37.179766][ T3173]  ? __sys_bpf+0xf52/0x29e0
[   37.180688][ T3173]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.181752][ T3173]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.182856][ T3173]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.183945][ T3173]  ? lock_release+0x25e/0x4e0
[   37.184914][ T3173]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.185975][ T3173]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.192657][ T3173]  ? __x64_sys_bpf+0x1a/0x30
[   37.193534][ T3173]  ? do_syscall_64+0x37/0x90
[   37.203763][ T3173]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   37.205048][ T3173]  </TASK>
[   37.205762][ T3173] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   37.213518][ T3153] general protection fault, maybe for address 0xffff88816ef90040: 0000 [#7] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   37.216107][ T3153] CPU: 0 PID: 3153 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   37.223428][ T3153] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   37.225459][ T3153] RIP: 0010:bpf_dispatcher_xdp+0x936/0x1000
[   37.226698][ T3153] Code: 00 48 81 fa 08 43 01 a0 7f 2a 48 81 fa d0 42 01 a0 7f 11 48 81 fa d0 42 01 a0 0f 84 a4 29 e1 ff ff e2 66 90 48 81 fa 08 43 01 <a0> 0f 84 cb 29 e1 ff ff e2 90 48 81 fa 48 43 01 a0 7f 17 48 81 fa
[   37.232267][ T3153] RSP: 0018:ffffc90005eb7c38 EFLAGS: 00010287
[   37.234253][ T3153] RAX: ffff88816ef90040 RBX: ffffc900066c9000 RCX: ffffc90005eb7c6c
[   37.235938][ T3153] RDX: ffffffffa0014214 RSI: ffffc900066c9048 RDI: ffffc90005eb7d38
[   37.237644][ T3153] RBP: ffffc90005eb7d38 R08: ffffc90005eb7d34 R09: 0000000000000000
[   37.239329][ T3153] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900066c9048
[   37.240977][ T3153] R13: ffffc90005eb7d30 R14: 0000000000000001 R15: ffffc90005eb7c98
[   37.242632][ T3153] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   37.246711][ T3153] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.248101][ T3153] CR2: 00007fbae8e1a7c4 CR3: 000000016f5c2004 CR4: 0000000000770ef0
[   37.255821][ T3153] PKRU: 55555554
[   37.256636][ T3153] Call Trace:
[   37.257388][ T3153]  <TASK>
[   37.258072][ T3153]  ? bpf_test_run+0x104/0x2e0
[   37.259124][ T3153]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   37.260428][ T3153]  ? bpf_prog_test_run_xdp+0x463/0x600
[   37.261936][ T3153]  ? __sys_bpf+0xf52/0x29e0
[   37.262911][ T3153]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.264138][ T3153]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.266883][ T3153]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.268028][ T3153]  ? lock_release+0x25e/0x4e0
[   37.269012][ T3153]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.270145][ T3153]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.271291][ T3153]  ? __x64_sys_bpf+0x1a/0x30
[   37.272275][ T3153]  ? do_syscall_64+0x37/0x90
[   37.273252][ T3153]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   37.274497][ T3153]  </TASK>
[   37.275217][ T3153] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   37.662069][ T3153] ---[ end trace 0000000000000000 ]---
[   37.675765][ T3153] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   37.684664][ T3153] Code: c8 48 01 a0 0f 84 b2 2d e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 10 49 01 a0 0f 84 e3 2d e1 ff ff e2 90 48 81 fa 08 4b 01 <a0> 0f 8f 83 00 00 00 48 81 fa 90 4a 01 a0 7f 4a 48 81 fa 48 4a 01
[   37.719751][ T3153] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   37.729728][ T3153] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   37.754677][ T3153] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   37.828629][ T3173] ---[ end trace 0000000000000000 ]---
[   37.842854][ T3173] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   37.851837][ T3173] Code: ff ff e2 90 48 81 fa 8c 4e 01 a0 0f 8f 63 00 00 00 48 81 fa 54 4d 01 a0 7f 2a 48 81 fa 14 4d 01 a0 7f 11 48 81 fa 14 4d 01 a0 <0f> 84 d8 31 e1 ff ff e2 66 90 48 81 fa 54 4d 01 a0 0f 84 07 32 e1
[   37.864644][ T3219] BUG: unable to handle page fault for address: ffff88819653ba4f
[   37.869299][ T3219] #PF: supervisor write access in kernel mode
[   37.870496][ T3219] #PF: error_code(0x0002) - not-present page
[   37.871655][ T3219] PGD 5801067 P4D 5801067 PUD 47f6ff067 PMD 47f64c067 PTE 800ffffe69ac4060
[   37.873371][ T3219] Oops: 0002 [#8] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   37.873580][ T3153] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   37.874293][ T3219] CPU: 1 PID: 3219 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   37.880515][ T3219] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   37.882288][ T3219] RIP: 0010:bpf_dispatcher_xdp+0x914/0x1000
[   37.883364][ T3219] Code: 25 e1 ff ff e2 90 48 81 fa cc 3f 01 a0 7f 17 48 81 fa cc 3f 01 a0 0f 84 c6 26 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa 50 <40> 01 a0 0f 84 33 27 e1 ff ff e2 90 48 81 fa 54 42 01 a0 0f 8f 63
[   37.890584][ T3153] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   37.893925][ T3219] RSP: 0018:ffffc90006673c30 EFLAGS: 00010006
[   37.893933][ T3219] RAX: ffff88816f203640 RBX: ffffc900067fd000 RCX: ffffc90006673c6c
[   37.893935][ T3219] RDX: ffffffffa001414c RSI: ffffc900067fd048 RDI: ffffc90006673d38
[   37.893937][ T3219] RBP: ffffc90006673d38 R08: ffffc90006673d34 R09: 0000000000000000
[   37.893939][ T3219] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900067fd048
[   37.893941][ T3219] R13: ffffc90006673d30 R14: 0000000000000001 R15: ffffc90006673c98
[   37.893944][ T3219] FS:  00007fbae8bff640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   37.893946][ T3219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.893948][ T3219] CR2: ffff88819653ba4f CR3: 000000016baba005 CR4: 0000000000770ee0
[   37.893955][ T3219] PKRU: 55555554
[   37.893957][ T3219] Call Trace:
[   37.893960][ T3219]  <TASK>
[   37.893964][ T3219]  ? bpf_test_run+0x104/0x2e0
[   37.893978][ T3219]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   37.893987][ T3219]  ? bpf_prog_test_run_xdp+0x463/0x600
[   37.893997][ T3219]  ? __sys_bpf+0xf52/0x29e0
[   37.894003][ T3219]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.894009][ T3219]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.894012][ T3219]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.894016][ T3219]  ? lock_release+0x25e/0x4e0
[   37.894020][ T3219]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.894023][ T3219]  ? rcu_read_lock_sched_held+0x10/0x90
[   37.894031][ T3219]  ? __x64_sys_bpf+0x1a/0x30
[   37.894035][ T3219]  ? do_syscall_64+0x37/0x90
[   37.894040][ T3219]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   37.894050][ T3219]  </TASK>
[   37.894051][ T3219] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   37.894073][ T3219] CR2: ffff88819653ba4f
[   37.894077][ T3219] ---[ end trace 0000000000000000 ]---
[   37.894079][ T3219] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   37.894084][ T3219] Code: ff ff e2 90 48 81 fa d4 4e 01 a0 0f 8f 63 00 00 00 48 81 fa 4c 4e 01 a0 7f 2a 48 81 fa 54 4d 01 a0 7f 11 48 81 fa 54 4d 01 a0 <0f> 84 18 32 e1 ff ff e2 66 90 48 81 fa 4c 4e 01 a0 0f 84 ff 32 e1
[   37.894087][ T3219] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   37.894104][ T3219] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   37.894106][ T3219] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   37.894107][ T3219] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   37.894109][ T3219] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   37.894111][ T3219] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   37.894113][ T3219] FS:  00007fbae8bff640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   37.894115][ T3219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.894117][ T3219] CR2: ffff88819653ba4f CR3: 000000016baba005 CR4: 0000000000770ee0
[   37.894122][ T3219] PKRU: 55555554
[   37.982471][ T3173] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   37.991063][ T3173] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   38.006830][ T3173] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   38.037188][ T3231] general protection fault, maybe for address 0xffff88816b5d3640: 0000 [#9] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   38.044273][ T3231] CPU: 0 PID: 3231 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   38.046453][ T3231] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   38.048206][ T3231] RIP: 0010:bpf_dispatcher_xdp+0x240/0x1000
[   38.049324][ T3231] Code: a0 0f 84 2b 38 e1 ff ff e2 90 48 81 fa d4 4e 01 a0 0f 8f 03 01 00 00 48 81 fa cc 4c 01 a0 0f 8f 86 00 00 00 48 81 fa 08 4b 01 <a0> 7f 4d 48 81 fa cc 4a 01 a0 7f 34 48 81 fa 90 4a 01 a0 7f 1b 48
[   38.055217][ T3231] RSP: 0018:ffffc90005e4bc38 EFLAGS: 00010202
[   38.056358][ T3231] RAX: ffff88816b5d3640 RBX: ffffc90006843000 RCX: ffffc90005e4bc6c
[   38.058965][ T3231] RDX: ffffffffa0014a48 RSI: ffffc90006843048 RDI: ffffc90005e4bd38
[   38.060439][ T3231] RBP: ffffc90005e4bd38 R08: ffffc90005e4bd34 R09: 0000000000000000
[   38.064573][ T3231] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006843048
[   38.066099][ T3231] R13: ffffc90005e4bd30 R14: 0000000000000001 R15: ffffc90005e4bc98
[   38.067429][ T3231] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   38.069160][ T3231] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.072614][ T3231] CR2: 00007fbae8ca0cb0 CR3: 000000016bafa006 CR4: 0000000000770ef0
[   38.074126][ T3231] PKRU: 55555554
[   38.074845][ T3231] Call Trace:
[   38.075517][ T3231]  <TASK>
[   38.076183][ T3231]  ? bpf_test_run+0x104/0x2e0
[   38.078749][ T3231]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   38.079881][ T3231]  ? bpf_prog_test_run_xdp+0x463/0x600
[   38.080939][ T3231]  ? __sys_bpf+0xf52/0x29e0
[   38.081817][ T3231]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.085860][ T3231]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.086917][ T3231]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.089215][ T3231]  ? lock_release+0x25e/0x4e0
[   38.090147][ T3231]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.091752][ T3231]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.096031][ T3231]  ? __x64_sys_bpf+0x1a/0x30
[   38.096976][ T3231]  ? do_syscall_64+0x37/0x90
[   38.097913][ T3231]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   38.099077][ T3231]  </TASK>
[   38.099761][ T3231] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   38.124943][ T3219] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   38.132456][ T3173] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   38.134334][ T3173] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   38.147292][ T3219] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3219, name: ex
[   38.156457][ T3173] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   38.168940][ T3219] preempt_count: 0, expected: 0
[   38.169873][ T3219] RCU nest depth: 1, expected: 0
[   38.179454][ T3173] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   38.182747][ T3219] INFO: lockdep is turned off.
[   38.182995][ T3173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.182999][ T3173] CR2: 00007fbae8ca0cb0 CR3: 000000016b486005 CR4: 0000000000770ef0
[   38.183005][ T3173] PKRU: 55555554
[   38.211338][ T3219] CPU: 1 PID: 3219 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   38.213570][ T3219] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   38.215294][ T3219] Call Trace:
[   38.215984][ T3219]  <TASK>
[   38.216600][ T3219]  dump_stack_lvl+0xa4/0xee
[   38.217479][ T3219]  __might_resched.cold+0x117/0x152
[   38.218479][ T3219]  exit_signals+0x1a/0x330
[   38.219356][ T3219]  do_exit+0x15b/0xca0
[   38.220179][ T3219]  make_task_dead+0x51/0x60
[   38.221058][ T3219]  rewind_stack_and_make_dead+0x17/0x20
[   38.223431][ T3219] RIP: 0033:0x7fbae8d0af3d
[   38.224320][ T3219] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   38.230168][ T3219] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   38.231531][ T3219] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   38.233068][ T3219] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   38.234687][ T3219] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   38.242858][ T3231] ---[ end trace 0000000000000000 ]---
[   38.245914][ T3219] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   38.245917][ T3219] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   38.245928][ T3219]  </TASK>
[   38.252030][ T3231] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   38.254805][ T3153] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   38.256393][ T3153] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   38.258078][ T3153] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.260931][ T3153] CR2: 00007fbae8ca0cb0 CR3: 000000016f5c2002 CR4: 0000000000770ef0
[   38.262577][ T3153] PKRU: 55555554
[   38.264565][ T3231] Code: ff ff e2 90 48 81 fa c8 50 01 a0 0f 8f 63 00 00 00 48 81 fa 08 50 01 a0 7f 2a 48 81 fa 10 4f 01 a0 7f 11 48 81 fa 10 4f 01 a0 <0f> 84 d4 33 e1 ff ff e2 66 90 48 81 fa 08 50 01 a0 0f 84 bb 34 e1
[   38.268027][ T3231] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   38.269180][ T3231] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   38.270683][ T3231] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   38.272139][ T3231] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   38.273708][ T3231] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   38.275245][ T3231] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   38.276759][ T3231] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   38.278483][ T3231] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.279724][ T3231] CR2: 00007fbae8ca0cb0 CR3: 000000016bafa001 CR4: 0000000000770ef0
[   38.328465][ T3231] PKRU: 55555554
[   38.932873][ T3343] invalid opcode: 0000 [#10] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   38.934390][ T3343] CPU: 2 PID: 3343 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   38.936510][ T3343] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   38.938333][ T3343] RIP: 0010:bpf_dispatcher_xdp+0xaa9/0x1000
[   38.939424][ T3343] Code: 90 48 81 fa d0 53 01 a0 0f 84 43 39 e1 ff ff e2 90 48 81 fa 48 54 01 a0 7f 17 48 81 fa 48 54 01 a0 0f 84 a2 39 e1 ff ff e2 0f <1f> 84 00 00 00 00 00 48 81 fa 8c 54 01 a0 0f 84 cf 39 e1 ff ff e2
[   38.942435][ T3343] RSP: 0018:ffffc9000682fc38 EFLAGS: 00010246
[   38.943394][ T3343] RAX: ffff88816b45b640 RBX: ffffc90006aad000 RCX: ffffc9000682fc6c
[   38.944683][ T3343] RDX: ffffffffa001548c RSI: ffffc90006aad048 RDI: ffffc9000682fd38
[   38.946008][ T3343] RBP: ffffc9000682fd38 R08: ffffc9000682fd34 R09: 0000000000000000
[   38.947307][ T3343] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006aad048
[   38.948619][ T3343] R13: ffffc9000682fd30 R14: 0000000000000001 R15: ffffc9000682fc98
[   38.949901][ T3343] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   38.951323][ T3343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.952346][ T3343] CR2: 00007fa1a686f180 CR3: 000000016b970001 CR4: 0000000000770ee0
[   38.953779][ T3343] PKRU: 55555554
[   38.954480][ T3343] Call Trace:
[   38.955076][ T3343]  <TASK>
[   38.955624][ T3343]  ? bpf_test_run+0x104/0x2e0
[   38.956434][ T3343]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   38.957427][ T3343]  ? bpf_prog_test_run_xdp+0x463/0x600
[   38.963332][ T3343]  ? __sys_bpf+0xf52/0x29e0
[   38.964511][ T3343]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.965526][ T3343]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.967850][ T3343]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.969560][ T3343]  ? lock_release+0x25e/0x4e0
[   38.970422][ T3343]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.971404][ T3343]  ? rcu_read_lock_sched_held+0x10/0x90
[   38.974023][ T3343]  ? __x64_sys_bpf+0x1a/0x30
[   38.974866][ T3343]  ? do_syscall_64+0x37/0x90
[   38.975856][ T3343]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   38.976969][ T3343]  </TASK>
[   38.977586][ T3343] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   39.329478][ T3343] ---[ end trace 0000000000000000 ]---
[   39.379215][ T3343] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   39.391223][ T3343] Code: ff ff e2 90 48 81 fa 8c 54 01 a0 0f 84 6f 39 e1 ff ff e2 90 48 81 fa d0 54 01 a0 7f 17 48 81 fa d0 54 01 a0 0f 84 9a 39 e1 ff <ff> e2 0f 1f 84 00 00 00 00 00 48 81 fa 10 55 01 a0 0f 84 c3 39 e1
[   39.429267][ T3343] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   39.444475][ T3343] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   39.469427][ T3343] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   39.484897][ T3343] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   39.506967][ T3343] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   39.518727][ T3343] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   39.534151][ T3343] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   39.543840][ T3343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.573815][ T3343] CR2: 00007fa1a694d660 CR3: 000000016b970003 CR4: 0000000000770ee0
[   39.583135][ T3343] PKRU: 55555554
[   39.585304][ T3343] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   39.599540][ T3343] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3343, name: ex
[   39.609696][ T3343] preempt_count: 0, expected: 0
[   39.613933][ T3343] RCU nest depth: 1, expected: 0
[   39.637812][ T3343] INFO: lockdep is turned off.
[   39.658833][   T39] kauditd_printk_skb: 1256 callbacks suppressed
[   39.658850][   T39] audit: type=1334 audit(1670583987.932:2857): prog-id=1400 op=LOAD
[   39.661955][   T39] audit: type=1334 audit(1670583987.935:2858): prog-id=1401 op=LOAD
[   39.663546][   T39] audit: type=1300 audit(1670583987.935:2858): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=691 pid=3498 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   39.668044][   T39] audit: type=1327 audit(1670583987.935:2858): proctitle="./ex"
[   39.674212][ T3343] CPU: 2 PID: 3343 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   39.676205][ T3343] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   39.677790][ T3343] Call Trace:
[   39.678418][ T3343]  <TASK>
[   39.678996][ T3343]  dump_stack_lvl+0xa4/0xee
[   39.679808][ T3343]  __might_resched.cold+0x117/0x152
[   39.680701][ T3343]  exit_signals+0x1a/0x330
[   39.681486][ T3343]  do_exit+0x15b/0xca0
[   39.682236][ T3343]  make_task_dead+0x51/0x60
[   39.688352][ T3343]  rewind_stack_and_make_dead+0x17/0x20
[   39.689313][ T3343] RIP: 0033:0x7fbae8d0af3d
[   39.690132][ T3343] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   39.693270][ T3343] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   39.694708][ T3343] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   39.696136][ T3343] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   39.697596][ T3343] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   39.699010][ T3343] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   39.700511][ T3343] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   39.702002][ T3343]  </TASK>
[   39.708444][   T39] audit: type=1334 audit(1670583987.946:2859): prog-id=0 op=UNLOAD
[   39.710126][   T39] audit: type=1300 audit(1670583987.932:2857): arch=c000003e syscall=321 success=yes exit=3 a0=5 a1=20000640 a2=80 a3=0 items=0 ppid=693 pid=3494 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="ex" exe="/home/jolsa/ex/ex" key=(null)
[   39.770897][   T39] audit: type=1327 audit(1670583987.932:2857): proctitle="./ex"
[   39.817049][   T39] audit: type=1334 audit(1670583987.979:2860): prog-id=1402 op=LOAD
[   39.818678][   T39] audit: type=1334 audit(1670583988.090:2861): prog-id=0 op=UNLOAD
[   39.820286][   T39] audit: type=1334 audit(1670583987.985:2862): prog-id=1403 op=LOAD
[   39.901232][ T3462] invalid opcode: 0000 [#11] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   39.902700][ T3462] CPU: 0 PID: 3462 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   39.904788][ T3462] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   39.912486][ T3462] RIP: 0010:bpf_dispatcher_xdp+0xa2c/0x1000
[   39.913727][ T3462] Code: 2d 48 81 fa 48 56 01 a0 7f 14 48 81 fa 48 56 01 a0 0f 84 2f 3c e1 ff ff e2 0f 1f 44 00 00 48 81 fa 8c 56 01 a0 0f 84 5f 3c e1 <ff> ff e2 90 48 81 fa 14 5b 01 a0 7f 17 48 81 fa 14 5b 01 a0 0f 84
[   39.919400][ T3462] RSP: 0018:ffffc9000633fc38 EFLAGS: 00010246
[   39.920645][ T3462] RAX: ffff88816adb8040 RBX: ffffc90006ccf000 RCX: ffffc9000633fc6a
[   39.922391][ T3462] RDX: ffffffffa0015c10 RSI: ffffc90006ccf048 RDI: ffffc9000633fd38
[   39.944216][ T3462] RBP: ffffc9000633fd38 R08: ffffc9000633fd34 R09: 0000000000000000
[   39.947774][ T3462] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006ccf048
[   39.949555][ T3462] R13: ffffc9000633fd30 R14: 0000000000000001 R15: ffffc9000633fc98
[   39.951284][ T3462] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   39.953131][ T3462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.954471][ T3462] CR2: 00007fbae8bddef8 CR3: 000000016b91e002 CR4: 0000000000770ef0
[   39.956225][ T3462] PKRU: 55555554
[   39.957045][ T3462] Call Trace:
[   39.957838][ T3462]  <TASK>
[   39.958564][ T3462]  ? bpf_test_run+0x104/0x2e0
[   39.959571][ T3462]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   39.960891][ T3462]  ? bpf_prog_test_run_xdp+0x463/0x600
[   39.962071][ T3462]  ? __sys_bpf+0xf52/0x29e0
[   39.963034][ T3462]  ? rcu_read_lock_sched_held+0x10/0x90
[   39.964197][ T3462]  ? rcu_read_lock_sched_held+0x10/0x90
[   39.967261][ T3462]  ? rcu_read_lock_sched_held+0x10/0x90
[   39.968410][ T3462]  ? lock_release+0x25e/0x4e0
[   39.969438][ T3462]  ? rcu_read_lock_sched_held+0x10/0x90
[   39.975773][ T3462]  ? rcu_read_lock_sched_held+0x10/0x90
[   39.976942][ T3462]  ? __x64_sys_bpf+0x1a/0x30
[   39.979756][ T3462]  ? do_syscall_64+0x37/0x90
[   39.980735][ T3462]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   39.982002][ T3462]  </TASK>
[   39.982685][ T3462] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   40.248623][ T3582] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   40.250525][ T3582] BUG: unable to handle page fault for address: ffffc900061d7c38
[   40.252250][ T3582] #PF: supervisor instruction fetch in kernel mode
[   40.253663][ T3582] #PF: error_code(0x0011) - permissions violation
[   40.255007][ T3582] PGD 100000067 P4D 100000067 PUD 100a4f067 PMD 10dc7a067 PTE 800000016b0ba163
[   40.256924][ T3582] Oops: 0011 [#12] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   40.258393][ T3582] CPU: 1 PID: 3582 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   40.260854][ T3582] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   40.262868][ T3582] RIP: 0010:0xffffc900061d7c38
[   40.263968][ T3582] Code: ff ff 10 00 00 00 00 00 00 00 46 00 01 00 00 00 00 00 38 7c 1d 06 00 c9 ff ff 18 00 00 00 00 00 00 00 38 7c 1d 06 00 c9 ff ff <a4> a9 e0 81 ff ff ff ff 34 7d 1d 06 00 c9 ff ff 10 ba 4e 83 ff ff
[   40.267997][ T3582] RSP: 0018:ffffc900061d7c38 EFLAGS: 00010046
[   40.269341][ T3582] RAX: 0000000000000000 RBX: ffffc90006f45000 RCX: ffffc900061d7c6c
[   40.271098][ T3582] RDX: ffffffffa0014688 RSI: ffffc90006f45048 RDI: ffffc900061d7d38
[   40.274565][ T3582] RBP: ffffc900061d7d38 R08: ffffc900061d7d34 R09: 0000000000000000
[   40.276361][ T3582] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006f45048
[   40.278105][ T3582] R13: ffffc900061d7d30 R14: 0000000000000001 R15: ffffc900061d7c98
[   40.279932][ T3582] FS:  00007f54fafbd640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   40.281935][ T3582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.283472][ T3582] CR2: ffffc900061d7c38 CR3: 000000016aee8003 CR4: 0000000000770ee0
[   40.285332][ T3582] PKRU: 55555554
[   40.286166][ T3582] Call Trace:
[   40.286953][ T3582]  <TASK>
[   40.287681][ T3582]  ? bpf_test_run+0x104/0x2e0
[   40.288770][ T3582]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   40.290124][ T3582]  ? bpf_prog_test_run_xdp+0x463/0x600
[   40.291396][ T3582]  ? __sys_bpf+0xf52/0x29e0
[   40.292404][ T3582]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.293626][ T3582]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.294925][ T3582]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.296134][ T3582]  ? lock_release+0x25e/0x4e0
[   40.297077][ T3582]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.298102][ T3582]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.299164][ T3582]  ? __x64_sys_bpf+0x1a/0x30
[   40.300071][ T3582]  ? do_syscall_64+0x37/0x90
[   40.300967][ T3582]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   40.302102][ T3582]  </TASK>
[   40.304471][ T3582] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   40.308379][ T3582] CR2: ffffc900061d7c38
[   40.309220][ T3582] ---[ end trace 0000000000000000 ]---
[   40.310293][ T3582] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   40.311459][ T3582] Code: ff ff e2 90 48 81 fa c8 49 01 a0 0f 84 ab 2e e1 ff ff e2 90 48 81 fa 48 4a 01 a0 7f 17 48 81 fa 48 4a 01 a0 0f 84 12 2f e1 ff <ff> e2 0f 1f 84 00 00 00 00 00 48 81 fa 90 4a 01 a0 0f 84 43 2f e1
[   40.314859][ T3582] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   40.316020][ T3582] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   40.317526][ T3582] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   40.319066][ T3582] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   40.320932][ T3582] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   40.324425][ T3582] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   40.326181][ T3582] FS:  00007f54fafbd640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   40.328141][ T3582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.329503][ T3582] CR2: ffffc900061d7c38 CR3: 000000016aee8003 CR4: 0000000000770ee0
[   40.331268][ T3582] PKRU: 55555554
[   40.500715][ T3462] ---[ end trace 0000000000000000 ]---
[   40.511676][ T3462] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   40.518678][ T3462] Code: ff ff e2 90 48 81 fa 90 4a 01 a0 0f 84 73 2f e1 ff ff e2 90 48 81 fa 08 4e 01 a0 7f 17 48 81 fa 08 4e 01 a0 0f 84 d2 32 e1 ff <ff> e2 0f 1f 84 00 00 00 00 00 48 81 fa 08 4f 01 a0 0f 84 bb 33 e1
[   40.548793][ T3462] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   40.561721][ T3462] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   40.575451][ T3462] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   40.595778][ T3462] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   40.610994][ T3462] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   40.623605][ T3462] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   40.638456][ T3462] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   40.655533][ T3462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.677883][ T3462] CR2: 00007fbae8e1a7c4 CR3: 000000016b91e003 CR4: 0000000000770ef0
[   40.690952][ T3462] PKRU: 55555554
[   40.697508][ T3462] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   40.708936][ T3462] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3462, name: ex
[   40.722521][ T3462] preempt_count: 0, expected: 0
[   40.731779][ T3462] RCU nest depth: 1, expected: 0
[   40.732805][ T3462] INFO: lockdep is turned off.
[   40.749461][ T3462] CPU: 0 PID: 3462 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   40.751650][ T3462] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   40.753404][ T3462] Call Trace:
[   40.754072][ T3462]  <TASK>
[   40.754957][ T3462]  dump_stack_lvl+0xa4/0xee
[   40.759394][ T3462]  __might_resched.cold+0x117/0x152
[   40.760538][ T3462]  exit_signals+0x1a/0x330
[   40.761538][ T3462]  do_exit+0x15b/0xca0
[   40.762457][ T3462]  make_task_dead+0x51/0x60
[   40.763495][ T3462]  rewind_stack_and_make_dead+0x17/0x20
[   40.764690][ T3462] RIP: 0033:0x7f54fad0af3d
[   40.765708][ T3462] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   40.769690][ T3462] RSP: 002b:00007f54fafbcdf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   40.778125][ T3462] RAX: ffffffffffffffda RBX: 00007f54fafbd640 RCX: 00007f54fad0af3d
[   40.779532][ T3462] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   40.780935][ T3462] RBP: 00007f54fafbce20 R08: 0000000000000000 R09: 0000000000000000
[   40.782707][ T3462] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   40.784466][ T3462] R13: 0000000000000011 R14: 00007ffce4ffe480 R15: 00007f54faf9d000
[   40.789573][ T3462]  </TASK>
[   40.881484][ T3619] general protection fault, maybe for address 0xffff88816be3b640: 0000 [#13] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   40.884033][ T3619] CPU: 3 PID: 3619 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   40.885732][ T3619] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   40.887134][ T3619] RIP: 0010:bpf_dispatcher_xdp+0xae6/0x1000
[   40.888051][ T3619] Code: 3b e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa 0c 56 01 a0 0f 84 2f 3b e1 ff ff e2 90 48 81 fa 48 56 01 <a0> 7f 17 48 81 fa 48 56 01 a0 0f 84 52 3b e1 ff ff e2 0f 1f 84 00
[   40.891253][ T3619] RSP: 0018:ffffc90006fb3c38 EFLAGS: 00010246
[   40.892435][ T3619] RAX: ffff88816be3b640 RBX: ffffc90006fe1000 RCX: ffffc90006fb3c6c
[   40.907102][ T3619] RDX: ffffffffa0015710 RSI: ffffc90006fe1048 RDI: ffffc90006fb3d38
[   40.908673][ T3619] RBP: ffffc90006fb3d38 R08: ffffc90006fb3d34 R09: 0000000000000000
[   40.910219][ T3619] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006fe1048
[   40.913621][ T3619] R13: ffffc90006fb3d30 R14: 0000000000000001 R15: ffffc90006fb3c98
[   40.914985][ T3619] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   40.916485][ T3619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.917582][ T3619] CR2: 00007f54faca0cb0 CR3: 000000016af7c003 CR4: 0000000000770ee0
[   40.919041][ T3619] PKRU: 55555554
[   40.919733][ T3619] Call Trace:
[   40.920364][ T3619]  <TASK>
[   40.920937][ T3619]  ? bpf_test_run+0x104/0x2e0
[   40.921770][ T3619]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   40.922819][ T3619]  ? bpf_prog_test_run_xdp+0x463/0x600
[   40.923765][ T3619]  ? __sys_bpf+0xf52/0x29e0
[   40.924681][ T3619]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.925751][ T3619]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.928328][ T3619]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.929533][ T3619]  ? lock_release+0x25e/0x4e0
[   40.933778][ T3619]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.934802][ T3619]  ? rcu_read_lock_sched_held+0x10/0x90
[   40.936250][ T3619]  ? __x64_sys_bpf+0x1a/0x30
[   40.937472][ T3619]  ? do_syscall_64+0x37/0x90
[   40.938619][ T3619]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   40.945383][ T3619]  </TASK>
[   40.946065][ T3619] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   41.021507][ T3644] general protection fault, maybe for address 0xffff88816bed8040: 0000 [#14] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   41.023659][ T3644] CPU: 3 PID: 3644 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   41.035237][ T3644] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   41.036700][ T3644] RIP: 0010:bpf_dispatcher_xdp+0xa20/0x1000
[   41.037650][ T3644] Code: a0 0f 84 cf 37 e1 ff ff e2 90 48 81 fa d4 5e 01 a0 0f 8f 03 01 00 00 48 81 fa 48 56 01 a0 0f 8f 86 00 00 00 48 81 fa d4 55 01 <a0> 7f 4d 48 81 fa 10 55 01 a0 7f 34 48 81 fa 8c 54 01 a0 7f 1b 48
[   41.040559][ T3644] RSP: 0018:ffffc9000703fc38 EFLAGS: 00010216
[   41.041524][ T3644] RAX: ffff88816bed8040 RBX: ffffc90007041000 RCX: ffffc9000703fc6c
[   41.042808][ T3644] RDX: ffffffffa0016508 RSI: ffffc90007041048 RDI: ffffc9000703fd38
[   41.046569][ T3644] RBP: ffffc9000703fd38 R08: ffffc9000703fd34 R09: 0000000000000000
[   41.048049][ T3644] R10: 0000000000000000 R11: 00000000e0ccdeeb R12: ffffc90007041048
[   41.049628][ T3644] R13: ffffc9000703fd30 R14: 0000000000000001 R15: ffffc9000703fc98
[   41.052910][ T3644] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   41.054513][ T3644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.057109][ T3644] CR2: 00007f54fafc87c4 CR3: 000000016a826006 CR4: 0000000000770ee0
[   41.058553][ T3644] PKRU: 55555554
[   41.059237][ T3644] Call Trace:
[   41.059890][ T3644]  <TASK>
[   41.060788][ T3644]  ? bpf_test_run+0x104/0x2e0
[   41.067251][ T3644]  ? wake_up_q+0x4a/0x90
[   41.068001][ T3644]  ? bpf_prog_test_run_xdp+0x463/0x600
[   41.068879][ T3644]  ? __sys_bpf+0xf52/0x29e0
[   41.069633][ T3644]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.070523][ T3644]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.071407][ T3644]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.072293][ T3644]  ? lock_release+0x25e/0x4e0
[   41.073068][ T3644]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.073987][ T3644]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.075020][ T3644]  ? __x64_sys_bpf+0x1a/0x30
[   41.075882][ T3644]  ? do_syscall_64+0x37/0x90
[   41.076738][ T3644]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   41.078023][ T3644]  </TASK>
[   41.078681][ T3644] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   41.089276][ T3614] BUG: unable to handle page fault for address: ffff8880ec484dbf
[   41.090777][ T3614] #PF: supervisor write access in kernel mode
[   41.091805][ T3614] #PF: error_code(0x0002) - not-present page
[   41.102051][ T3614] PGD 5801067 P4D 5801067 PUD 0 
[   41.102928][ T3614] Oops: 0002 [#15] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   41.104204][ T3614] CPU: 0 PID: 3614 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   41.106191][ T3614] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   41.107879][ T3614] RIP: 0010:bpf_dispatcher_xdp+0x255/0x1000
[   41.110283][ T3614] Code: 14 48 81 fa 10 55 01 a0 0f 84 d7 42 e1 ff ff e2 0f 1f 44 00 00 48 81 fa d4 55 01 a0 0f 84 87 43 e1 ff ff e2 90 48 81 fa 0c 56 <01> a0 7f 17 48 81 fa 0c 56 01 a0 0f 84 a6 43 e1 ff ff e2 0f 1f 84
[   41.114582][ T3614] RSP: 0018:ffffc90006fcfc38 EFLAGS: 00010246
[   41.115638][ T3614] RAX: ffff88816b003640 RBX: ffffc90006fc9000 RCX: ffffc90006fcfc6c
[   41.117056][ T3614] RDX: ffffffffa00151cc RSI: ffffc90006fc9048 RDI: ffffc90006fcfd38
[   41.118544][ T3614] RBP: ffffc90006fcfd38 R08: ffffc90006fcfd34 R09: 0000000000000000
[   41.119963][ T3614] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90006fc9048
[   41.121362][ T3614] R13: ffffc90006fcfd30 R14: 0000000000000001 R15: ffffc90006fcfc98
[   41.122769][ T3614] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   41.129347][ T3614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.130422][ T3614] CR2: ffff8880ec484dbf CR3: 000000016ac18006 CR4: 0000000000770ef0
[   41.131826][ T3614] PKRU: 55555554
[   41.132554][ T3614] Call Trace:
[   41.133280][ T3614]  <TASK>
[   41.133976][ T3614]  ? bpf_test_run+0x104/0x2e0
[   41.134971][ T3614]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   41.136251][ T3614]  ? bpf_prog_test_run_xdp+0x463/0x600
[   41.137300][ T3614]  ? __sys_bpf+0xf52/0x29e0
[   41.138227][ T3614]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.139381][ T3614]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.140505][ T3614]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.141589][ T3614]  ? lock_release+0x25e/0x4e0
[   41.142542][ T3614]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.143607][ T3614]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.144758][ T3614]  ? __x64_sys_bpf+0x1a/0x30
[   41.145715][ T3614]  ? do_syscall_64+0x37/0x90
[   41.146635][ T3614]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   41.147824][ T3614]  </TASK>
[   41.148471][ T3614] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   41.152453][ T3614] CR2: ffff8880ec484dbf
[   41.153293][ T3614] ---[ end trace 0000000000000000 ]---
[   41.154334][ T3614] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   41.159862][ T3614] Code: ff ff e2 90 48 81 fa cc 64 01 a0 0f 8f 63 00 00 00 48 81 fa 0c 64 01 a0 7f 2a 48 81 fa 54 63 01 a0 7f 11 48 81 fa 54 63 01 a0 <0f> 84 18 48 e1 ff ff e2 66 90 48 81 fa 0c 64 01 a0 0f 84 bf 48 e1
[   41.163599][ T3614] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   41.164895][ T3614] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   41.166568][ T3614] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   41.168115][ T3614] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   41.169697][ T3614] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   41.171259][ T3614] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   41.172847][ T3614] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   41.174333][ T3614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.175419][ T3614] CR2: ffff8880ec484dbf CR3: 000000016ac18006 CR4: 0000000000770ef0
[   41.176787][ T3614] PKRU: 55555554
[   41.295316][ T3619] ---[ end trace 0000000000000000 ]---
[   41.304495][ T3619] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   41.312289][ T3619] Code: ff ff e2 90 48 81 fa cc 51 01 a0 0f 84 af 36 e1 ff ff e2 90 48 81 fa d4 55 01 a0 7f 47 48 81 fa 10 55 01 a0 7f 2e 48 81 fa 8c <54> 01 a0 7f 15 48 81 fa 8c 54 01 a0 0f 84 44 39 e1 ff ff e2 66 0f
[   41.344275][ T3619] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   41.352004][ T3619] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   41.365693][ T3619] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   41.391746][ T3619] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   41.416085][ T3619] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   41.431243][ T3619] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   41.445726][ T3644] ---[ end trace 0000000000000000 ]---
[   41.463403][ T3644] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   41.469318][ T3619] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   41.477105][ T3644] Code: ff ff e2 90 48 81 fa 10 55 01 a0 0f 84 f3 39 e1 ff ff e2 90 48 81 fa d4 55 01 a0 7f 17 48 81 fa d4 55 01 a0 0f 84 9e 3a e1 ff <ff> e2 0f 1f 84 00 00 00 00 00 48 81 fa 0c 56 01 a0 0f 84 bf 3a e1
[   41.489971][ T3619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.502370][ T3619] CR2: 00007fbae8e110e8 CR3: 000000016af7c006 CR4: 0000000000770ee0
[   41.522718][ T3644] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   41.541586][ T3644] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   41.555326][ T3644] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   41.570952][ T3644] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   41.585806][ T3644] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   41.623331][ T3644] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   41.640758][ T3644] FS:  00007f54fafbd640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   41.644849][ T3619] PKRU: 55555554
[   41.656691][ T3644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.663510][ T3644] CR2: 00007f54fafbf0e8 CR3: 000000016a826002 CR4: 0000000000770ee0
[   41.676993][ T3644] PKRU: 55555554
[   41.749063][ T3718] general protection fault, maybe for address 0xffff88816b5e3640: 0000 [#16] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   41.771100][ T3718] CPU: 1 PID: 3718 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   41.773254][ T3718] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   41.774976][ T3718] RIP: 0010:bpf_dispatcher_xdp+0xa80/0x1000
[   41.776074][ T3718] Code: a0 0f 84 6f 36 e1 ff ff e2 90 48 81 fa 0c 56 01 a0 0f 8f 33 01 00 00 48 81 fa 08 53 01 a0 0f 8f a6 00 00 00 48 81 fa cc 51 01 <a0> 7f 4d 48 81 fa 88 51 01 a0 7f 34 48 81 fa 0c 51 01 a0 7f 1b 48
[   41.781620][ T3718] RSP: 0018:ffffc90006ebfc38 EFLAGS: 00010206
[   41.782802][ T3718] RAX: ffff88816b5e3640 RBX: ffffc900071eb000 RCX: ffffc90006ebfc6c
[   41.792064][ T3718] RDX: ffffffffa001524c RSI: ffffc900071eb048 RDI: ffffc90006ebfd38
[   41.793583][ T3718] RBP: ffffc90006ebfd38 R08: ffffc90006ebfd34 R09: 0000000000000000
[   41.801096][ T3718] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900071eb048
[   41.802401][ T3718] R13: ffffc90006ebfd30 R14: 0000000000000001 R15: ffffc90006ebfc98
[   41.803670][ T3718] FS:  00007fbae8bff640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   41.812486][ T3718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.813525][ T3718] CR2: 00007f54fafc87c4 CR3: 000000016a860003 CR4: 0000000000770ee0
[   41.817785][ T3718] PKRU: 55555554
[   41.818407][ T3718] Call Trace:
[   41.818993][ T3718]  <TASK>
[   41.819520][ T3718]  ? bpf_test_run+0x104/0x2e0
[   41.820306][ T3718]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   41.822449][ T3718]  ? bpf_prog_test_run_xdp+0x463/0x600
[   41.823336][ T3718]  ? __sys_bpf+0xf52/0x29e0
[   41.824092][ T3718]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.824976][ T3718]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.825874][ T3718]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.826924][ T3718]  ? lock_release+0x25e/0x4e0
[   41.827784][ T3718]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.836318][ T3718]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.837232][ T3718]  ? __x64_sys_bpf+0x1a/0x30
[   41.838000][ T3718]  ? do_syscall_64+0x37/0x90
[   41.838762][ T3718]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   41.839724][ T3718]  </TASK>
[   41.840271][ T3718] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   41.903780][ T3667] BUG: unable to handle page fault for address: ffff8881a52b3a4f
[   41.905281][ T3667] #PF: supervisor write access in kernel mode
[   41.906326][ T3667] #PF: error_code(0x0002) - not-present page
[   41.907392][ T3667] PGD 5801067 P4D 5801067 PUD 47f6ff067 PMD 47f5d5067 PTE 800ffffe5ad4c060
[   41.908881][ T3667] Oops: 0002 [#17] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   41.911504][ T3667] CPU: 0 PID: 3667 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   41.913545][ T3667] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   41.915143][ T3667] RIP: 0010:bpf_dispatcher_xdp+0xa20/0x1000
[   41.916175][ T3667] Code: a0 0f 84 93 34 e1 ff ff e2 90 48 81 fa cc 50 01 a0 7f 47 48 81 fa 88 50 01 a0 7f 2e 48 81 fa 08 50 01 a0 7f 15 48 81 fa 08 50 <01> a0 0f 84 e0 35 e1 ff ff e2 66 0f 1f 44 00 00 48 81 fa 88 50 01
[   41.919336][ T3667] RSP: 0018:ffffc900070cbc38 EFLAGS: 00010202
[   41.920387][ T3667] RAX: ffff88816f4ab640 RBX: ffffc900070c5000 RCX: ffffc900070cbc6c
[   41.932258][ T3667] RDX: ffffffffa0015088 RSI: ffffc900070c5048 RDI: ffffc900070cbd38
[   41.933667][ T3667] RBP: ffffc900070cbd38 R08: ffffc900070cbd34 R09: 0000000000000000
[   41.935000][ T3667] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900070c5048
[   41.936354][ T3667] R13: ffffc900070cbd30 R14: 0000000000000001 R15: ffffc900070cbc98
[   41.937697][ T3667] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   41.939244][ T3667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.940416][ T3667] CR2: ffff8881a52b3a4f CR3: 000000016af06003 CR4: 0000000000770ef0
[   41.941843][ T3667] PKRU: 55555554
[   41.942522][ T3667] Call Trace:
[   41.943146][ T3667]  <TASK>
[   41.943718][ T3667]  ? bpf_test_run+0x104/0x2e0
[   41.944560][ T3667]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   41.945600][ T3667]  ? bpf_prog_test_run_xdp+0x463/0x600
[   41.946549][ T3667]  ? __sys_bpf+0xf52/0x29e0
[   41.947351][ T3667]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.948295][ T3667]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.949300][ T3667]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.950292][ T3667]  ? lock_release+0x25e/0x4e0
[   41.951134][ T3667]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.952085][ T3667]  ? rcu_read_lock_sched_held+0x10/0x90
[   41.957824][ T3667]  ? __x64_sys_bpf+0x1a/0x30
[   41.958770][ T3667]  ? do_syscall_64+0x37/0x90
[   41.959777][ T3667]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   41.961019][ T3667]  </TASK>
[   41.963294][ T3667] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   41.967687][ T3667] CR2: ffff8881a52b3a4f
[   41.970022][ T3667] ---[ end trace 0000000000000000 ]---
[   41.971102][ T3667] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   41.972275][ T3667] Code: 38 e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa 8c 54 01 a0 0f 84 5f 39 e1 ff ff e2 90 48 81 fa 10 55 01 <a0> 0f 84 d3 39 e1 ff ff e2 90 48 81 fa 48 56 01 a0 7f 47 48 81 fa
[   41.975967][ T3667] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   41.977165][ T3667] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   41.978814][ T3667] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   41.980475][ T3667] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   41.982021][ T3667] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   41.983579][ T3667] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   41.989477][ T3667] FS:  00007fbae8bff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   41.990808][ T3667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.994115][ T3667] CR2: ffff8881a52b3a4f CR3: 000000016af06003 CR4: 0000000000770ef0
[   41.995623][ T3667] PKRU: 55555554
[   42.018931][ T3718] ---[ end trace 0000000000000000 ]---
[   42.019913][ T3718] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   42.021976][ T3718] Code: 38 e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa 8c 54 01 a0 0f 84 5f 39 e1 ff ff e2 90 48 81 fa 10 55 01 <a0> 0f 84 d3 39 e1 ff ff e2 90 48 81 fa 48 56 01 a0 7f 47 48 81 fa
[   42.028213][ T3718] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   42.035340][ T3614] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   42.040932][ T3718] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   42.044438][ T3718] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   42.045837][ T3718] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   42.047271][ T3718] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   42.048705][ T3614] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3614, name: ex
[   42.049991][ T3718] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   42.053675][ T3614] preempt_count: 0, expected: 0
[   42.055839][ T3718] FS:  00007fbae8bff640(0000) GS:ffff88846d200000(0000) knlGS:0000000000000000
[   42.057155][ T3614] RCU nest depth: 1, expected: 0
[   42.058119][ T3718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.060525][ T3614] INFO: lockdep is turned off.
[   42.060637][ T3718] CR2: 00007fbae8e1a7c4 CR3: 000000016a860006 CR4: 0000000000770ee0
[   42.061130][ T3614] CPU: 0 PID: 3614 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   42.061136][ T3614] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   42.061138][ T3614] Call Trace:
[   42.061141][ T3614]  <TASK>
[   42.061143][ T3614]  dump_stack_lvl+0xa4/0xee
[   42.061151][ T3614]  __might_resched.cold+0x117/0x152
[   42.061158][ T3614]  exit_signals+0x1a/0x330
[   42.062189][ T3718] PKRU: 55555554
[   42.063440][ T3614]  do_exit+0x15b/0xca0
[   42.063450][ T3614]  make_task_dead+0x51/0x60
[   42.063454][ T3614]  rewind_stack_and_make_dead+0x17/0x20
[   42.063459][ T3614] RIP: 0033:0x7fbae8d0af3d
[   42.063470][ T3614] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   42.093388][ T3614] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   42.094933][ T3614] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   42.096359][ T3614] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   42.099032][ T3614] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   42.100433][ T3614] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   42.101825][ T3614] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   42.103261][ T3614]  </TASK>
[   42.234388][ T3788] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   42.237553][ T3788] BUG: unable to handle page fault for address: ffffc90007329048
[   42.240427][ T3788] #PF: supervisor instruction fetch in kernel mode
[   42.241563][ T3788] #PF: error_code(0x0011) - permissions violation
[   42.242662][ T3788] PGD 100000067 P4D 100000067 PUD 100a4f067 PMD 16a935067 PTE 800000010c3a7163
[   42.244222][ T3788] Oops: 0011 [#18] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   42.245392][ T3788] CPU: 2 PID: 3788 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   42.247379][ T3788] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   42.249000][ T3788] RIP: 0010:0xffffc90007329048
[   42.249859][ T3788] Code: 00 00 90 eb 07 92 7b 60 00 00 48 eb 07 92 7b 60 00 00 48 69 01 a0 ff ff ff ff 00 9c ea 6b 81 88 ff ff 00 00 00 00 00 00 00 00 <18> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 06 00 00 00 00
[   42.253113][ T3788] RSP: 0018:ffffc90006f67c38 EFLAGS: 00010046
[   42.254341][ T3788] RAX: 0000000000000000 RBX: ffffc90007329000 RCX: ffffc90006f67c6b
[   42.255892][ T3788] RDX: ffffffffa0016948 RSI: ffffc90007329048 RDI: ffffc90006f67d38
[   42.257430][ T3788] RBP: ffffc90006f67d38 R08: ffffc90006f67d34 R09: 0000000000000000
[   42.258800][ T3788] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90007329048
[   42.264974][ T3788] R13: ffffc90006f67d30 R14: 0000000000000001 R15: ffffc90006f67c98
[   42.266405][ T3788] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   42.268002][ T3788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.269105][ T3788] CR2: ffffc90007329048 CR3: 000000016aa80002 CR4: 0000000000770ee0
[   42.271934][ T3788] PKRU: 55555554
[   42.272640][ T3788] Call Trace:
[   42.273656][ T3788]  <TASK>
[   42.274303][ T3788]  ? bpf_test_run+0x104/0x2e0
[   42.275196][ T3788]  ? wake_up_q+0x4a/0x90
[   42.276304][ T3788]  ? bpf_prog_test_run_xdp+0x463/0x600
[   42.277314][ T3788]  ? __sys_bpf+0xf52/0x29e0
[   42.278166][ T3788]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.279686][ T3788]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.287485][ T3788]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.288497][ T3788]  ? lock_release+0x25e/0x4e0
[   42.289329][ T3788]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.290283][ T3788]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.291250][ T3788]  ? __x64_sys_bpf+0x1a/0x30
[   42.292246][ T3788]  ? do_syscall_64+0x37/0x90
[   42.293285][ T3788]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   42.294641][ T3788]  </TASK>
[   42.295242][ T3788] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   42.300741][ T3788] CR2: ffffc90007329048
[   42.301511][ T3788] ---[ end trace 0000000000000000 ]---
[   42.308128][ T3788] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   42.310960][ T3788] Code: ff ff e2 90 48 81 fa d0 69 01 a0 7f 37 48 81 fa 94 69 01 a0 7f 1e 48 81 fa 94 69 01 a0 0f 84 65 4e e1 ff ff e2 0f 1f 84 00 00 <00> 00 00 0f 1f 80 00 00 00 00 48 81 fa d0 69 01 a0 0f 84 83 4e e1
[   42.314232][ T3788] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   42.315293][ T3788] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   42.316719][ T3788] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   42.319946][ T3788] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   42.321365][ T3788] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   42.322784][ T3788] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   42.327428][ T3788] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   42.328998][ T3788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.330165][ T3788] CR2: ffffc90007329048 CR3: 000000016aa80002 CR4: 0000000000770ee0
[   42.331569][ T3788] PKRU: 55555554
[   42.337612][ T3813] invalid opcode: 0000 [#19] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   42.343325][ T3813] CPU: 2 PID: 3813 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   42.345430][ T3813] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   42.347250][ T3813] RIP: 0010:bpf_dispatcher_xdp+0x462/0x1000
[   42.348349][ T3813] Code: 84 17 58 e1 ff ff e2 90 48 81 fa c8 6c 01 a0 7f 37 48 81 fa 88 6c 01 a0 7f 1e 48 81 fa 88 6c 01 a0 0f 84 29 58 e1 ff ff e2 0f <1f> 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa c8 6c 01 a0 0f
[   42.355157][ T3813] RSP: 0018:ffffc900073d7c38 EFLAGS: 00010246
[   42.356260][ T3813] RAX: ffff88816b453640 RBX: ffffc900073d1000 RCX: ffffc900073d7c6c
[   42.357731][ T3813] RDX: ffffffffa0016cc8 RSI: ffffc900073d1048 RDI: ffffc900073d7d38
[   42.359216][ T3813] RBP: ffffc900073d7d38 R08: ffffc900073d7d34 R09: 0000000000000000
[   42.360678][ T3813] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900073d1048
[   42.362185][ T3813] R13: ffffc900073d7d30 R14: 0000000000000001 R15: ffffc900073d7c98
[   42.370055][ T3813] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   42.371719][ T3813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.372923][ T3813] CR2: ffffc90007329048 CR3: 000000016aaf4001 CR4: 0000000000770ee0
[   42.374404][ T3813] PKRU: 55555554
[   42.375049][ T3813] Call Trace:
[   42.375598][ T3813]  <TASK>
[   42.376194][ T3813]  ? bpf_test_run+0x104/0x2e0
[   42.377032][ T3813]  ? sk_lookup_convert_ctx_access+0x290/0x290
[   42.378023][ T3813]  ? bpf_prog_test_run_xdp+0x463/0x600
[   42.378898][ T3813]  ? __sys_bpf+0xf52/0x29e0
[   42.379661][ T3813]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.380578][ T3813]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.381490][ T3813]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.382401][ T3813]  ? lock_release+0x25e/0x4e0
[   42.383198][ T3813]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.385591][ T3813]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.386576][ T3813]  ? __x64_sys_bpf+0x1a/0x30
[   42.387403][ T3813]  ? do_syscall_64+0x37/0x90
[   42.388214][ T3813]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   42.389396][ T3813]  </TASK>
[   42.389967][ T3813] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   42.516817][ T3813] ---[ end trace 0000000000000000 ]---
[   42.518184][ T3813] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   42.519265][ T3813] Code: ff ff e2 90 48 81 fa d0 69 01 a0 7f 37 48 81 fa 94 69 01 a0 7f 1e 48 81 fa 94 69 01 a0 0f 84 65 4e e1 ff ff e2 0f 1f 84 00 00 <00> 00 00 0f 1f 80 00 00 00 00 48 81 fa d0 69 01 a0 0f 84 83 4e e1
[   42.523188][ T3813] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   42.524320][ T3813] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   42.525717][ T3813] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   42.527134][ T3813] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   42.528528][ T3813] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   42.529930][ T3813] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   42.531320][ T3813] FS:  00007fbae8bff640(0000) GS:ffff88846d600000(0000) knlGS:0000000000000000
[   42.534399][ T3813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.535516][ T3813] CR2: 00007fbae8e110e8 CR3: 000000016aaf4004 CR4: 0000000000770ee0
[   42.536920][ T3813] PKRU: 55555554
[   42.781335][ T3785] invalid opcode: 0000 [#20] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   42.783111][ T3785] CPU: 3 PID: 3785 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   42.785590][ T3785] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   42.787566][ T3785] RIP: 0010:bpf_dispatcher_xdp+0xccc/0x1000
[   42.788829][ T3785] Code: 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa 10 57 01 a0 0f 84 53 3a e1 ff ff e2 90 48 81 fa 10 5c 01 a0 0f 84 43 3f e1 <ff> ff e2 90 48 81 fa 48 69 01 a0 7f 47 48 81 fa 10 69 01 a0 7f 2e
[   42.792591][ T3785] RSP: 0018:ffffc90007173c38 EFLAGS: 00010246
[   42.793849][ T3785] RAX: ffff88816b813640 RBX: ffffc90007311000 RCX: ffffc90007173c6b
[   42.798553][ T3785] RDX: ffffffffa0016910 RSI: ffffc90007311048 RDI: ffffc90007173d38
[   42.811451][ T3785] RBP: ffffc90007173d38 R08: ffffc90007173d34 R09: 0000000000000000
[   42.813479][ T3785] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90007311048
[   42.815258][ T3785] R13: ffffc90007173d30 R14: 0000000000000001 R15: ffffc90007173c98
[   42.817332][ T3785] FS:  00007fbae8bff640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   42.819378][ T3785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.821166][ T3785] CR2: 00007f54fafbf0e8 CR3: 000000016a8c8005 CR4: 0000000000770ee0
[   42.822908][ T3785] PKRU: 55555554
[   42.823736][ T3785] Call Trace:
[   42.824579][ T3785]  <TASK>
[   42.825333][ T3785]  ? bpf_test_run+0x104/0x2e0
[   42.826413][ T3785]  ? wake_up_q+0x4a/0x90
[   42.827386][ T3785]  ? bpf_prog_test_run_xdp+0x463/0x600
[   42.830239][ T3785]  ? __sys_bpf+0xf52/0x29e0
[   42.831288][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.832511][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.833748][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.834965][ T3785]  ? lock_release+0x25e/0x4e0
[   42.835996][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.837201][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   42.838386][ T3785]  ? __x64_sys_bpf+0x1a/0x30
[   42.839442][ T3785]  ? do_syscall_64+0x37/0x90
[   42.840518][ T3785]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   42.841799][ T3785]  </TASK>
[   42.842657][ T3785] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   43.217335][ T3785] ---[ end trace 0000000000000000 ]---
[   43.231500][ T3785] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   43.240583][ T3785] Code: ff ff e2 90 48 81 fa 50 59 01 a0 7f 37 48 81 fa 0c 59 01 a0 7f 1e 48 81 fa 0c 59 01 a0 0f 84 dd 3d e1 ff ff e2 0f 1f 84 00 00 <00> 00 00 0f 1f 80 00 00 00 00 48 81 fa 50 59 01 a0 0f 84 03 3e e1
[   43.281565][ T3785] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   43.287444][ T3785] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   43.311849][ T3785] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   43.327059][ T3785] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   43.340990][ T3785] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   43.365735][ T3785] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   43.373921][ T3785] FS:  00007fbae8bff640(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   43.386459][ T3785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.403348][ T3785] CR2: 00007f54fafc87c4 CR3: 000000016a8c8002 CR4: 0000000000770ee0
[   43.420195][ T3785] PKRU: 55555554
[   43.421118][ T3785] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   43.436944][ T3785] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3785, name: ex
[   43.450351][ T3785] preempt_count: 0, expected: 0
[   43.456831][ T3785] RCU nest depth: 1, expected: 0
[   43.464403][ T3785] INFO: lockdep is turned off.
[   43.472014][ T3785] CPU: 3 PID: 3785 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   43.474202][ T3785] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   43.475912][ T3785] Call Trace:
[   43.476593][ T3785]  <TASK>
[   43.477232][ T3785]  dump_stack_lvl+0xa4/0xee
[   43.478228][ T3785]  __might_resched.cold+0x117/0x152
[   43.483422][ T3785]  exit_signals+0x1a/0x330
[   43.484269][ T3785]  do_exit+0x15b/0xca0
[   43.485053][ T3785]  make_task_dead+0x51/0x60
[   43.486012][ T3785]  rewind_stack_and_make_dead+0x17/0x20
[   43.487195][ T3785] RIP: 0033:0x7fbae8d0af3d
[   43.488186][ T3785] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[   43.493922][ T3785] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[   43.495815][ T3785] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   43.497889][ T3785] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   43.499609][ T3785] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   43.501885][ T3785] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   43.505446][ T3785] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   43.506968][ T3785]  </TASK>
[   43.667766][ T3944] BUG: unable to handle page fault for address: ffff8881bc1c044f
[   43.669272][ T3944] #PF: supervisor write access in kernel mode
[   43.670402][ T3944] #PF: error_code(0x0002) - not-present page
[   43.671500][ T3944] PGD 5801067 P4D 5801067 PUD 47f6ff067 PMD 47f51e067 PTE 800ffffe43e3f060
[   43.673103][ T3944] Oops: 0002 [#21] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   43.674502][ T3944] CPU: 0 PID: 3944 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   43.676347][ T3785] ------------[ cut here ]------------
[   43.676956][ T3944] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   43.676959][ T3944] RIP: 0010:bpf_dispatcher_xdp+0x360/0x1000
[   43.677649][ T3785] Voluntary context switch within RCU read-side critical section!
[   43.679085][ T3944] Code: a0 0f 84 8b 49 e1 ff ff e2 90 48 81 fa c8 60 01 a0 7f 47 48 81 fa 94 60 01 a0 7f 2e 48 81 fa 88 5f 01 a0 7f 15 48 81 fa 88 5f <01> a0 0f 84 20 4c e1 ff ff e2 66 0f 1f 44 00 00 48 81 fa 94 60 01
[   43.679878][ T3785] WARNING: CPU: 3 PID: 3785 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x4e6/0x6f0
[   43.680986][ T3944] RSP: 0018:ffffc900076b7c38 EFLAGS: 00010212
[   43.683344][ T3785] Modules linked in: intel_rapl_msr
[   43.684922][ T3944] 
[   43.685649][ T3785]  intel_rapl_common
[   43.686425][ T3944] RAX: ffff88816ffb8040 RBX: ffffc900076b9000 RCX: ffffc900076b7c6c
[   43.686722][ T3785]  crct10dif_pclmul
[   43.687325][ T3944] RDX: ffffffffa0015b88 RSI: ffffc900076b9048 RDI: ffffc900076b7d38
[   43.688298][ T3785]  crc32_pclmul crc32c_intel
[   43.688892][ T3944] RBP: ffffc900076b7d38 R08: ffffc900076b7d34 R09: 0000000000000000
[   43.689855][ T3785]  ghash_clmulni_intel kvm_intel
[   43.690597][ T3944] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc900076b9048
[   43.691543][ T3785]  iTCO_wdt
[   43.692315][ T3944] R13: ffffc900076b7d30 R14: 0000000000000001 R15: ffffc900076b7c98
[   43.698455][ T3785]  iTCO_vendor_support
[   43.698940][ T3944] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   43.699934][ T3785]  rapl
[   43.700563][ T3944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.701695][ T3785]  i2c_i801 i2c_smbus
[   43.702126][ T3944] CR2: ffff8881bc1c044f CR3: 000000016b010004 CR4: 0000000000770ef0
[   43.702916][ T3785]  lpc_ich
[   43.703524][ T3944] PKRU: 55555554
[   43.704523][ T3785]  drm
[   43.704999][ T3944] Call Trace:
[   43.705437][ T3785]  drm_panel_orientation_quirks
[   43.705838][ T3944]  <TASK>
[   43.706264][ T3785]  zram
[   43.706994][ T3944]  ? bpf_test_run+0x104/0x2e0
[   43.707374][ T3785] CPU: 3 PID: 3785 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   43.707788][ T3944]  ? bpf_prog_test_run_xdp+0x463/0x600
[   43.708363][ T3785] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   43.708366][ T3785] RIP: 0010:rcu_note_context_switch+0x4e6/0x6f0
[   43.710208][ T3944]  ? __sys_bpf+0xf52/0x29e0
[   43.710872][ T3785] Code: 65 ff 0d 7d 59 e0 7e 0f 85 fa fc ff ff e8 f2 8b de ff e9 f0 fc ff ff 48 c7 c7 d8 ae a6 82 c6 05 0e 9f 30 02 01 e8 a8 e1 e3 00 <0f> 0b e9 92 fb ff ff a9 ff ff ff 7f 0f 84 0a fc ff ff 65 48 8b 3c
[   43.712264][ T3944]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.713028][ T3785] RSP: 0018:ffffc90007173bf0 EFLAGS: 00010086
[   43.713687][ T3944]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.716134][ T3785] 
[   43.716136][ T3785] RAX: 0000000000000000 RBX: ffff88846dc044c0 RCX: 0000000000000001
[   43.716984][ T3944]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.716992][ T3944]  ? lock_release+0x25e/0x4e0
[   43.716997][ T3944]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.717726][ T3785] RDX: 0000000000000027 RSI: ffffffff82abc56d RDI: 00000000ffffffff
[   43.718572][ T3944]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.718869][ T3785] RBP: ffffc90007173c98 R08: 0000000000000001 R09: 0000000000000000
[   43.718871][ T3785] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   43.718873][ T3785] R13: ffff88816b813640 R14: 0000000000000000 R15: 0000000000000000
[   43.718875][ T3785] FS:  0000000000000000(0000) GS:ffff88846da00000(0000) knlGS:0000000000000000
[   43.720101][ T3944]  ? __x64_sys_bpf+0x1a/0x30
[   43.720807][ T3785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.721569][ T3944]  ? do_syscall_64+0x37/0x90
[   43.722279][ T3785] CR2: 00007fbae8e1a7c4 CR3: 000000010d85c002 CR4: 0000000000770ee0
[   43.723506][ T3944]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   43.724333][ T3785] PKRU: 55555554
[   43.725583][ T3944]  </TASK>
[   43.726574][ T3785] Call Trace:
[   43.727691][ T3944] Modules linked in: intel_rapl_msr
[   43.728812][ T3785]  <TASK>
[   43.729508][ T3944]  intel_rapl_common crct10dif_pclmul
[   43.730296][ T3785]  __schedule+0x112/0xe30
[   43.730852][ T3944]  crc32_pclmul
[   43.731824][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.732558][ T3944]  crc32c_intel
[   43.732992][ T3785]  ? lock_release+0x25e/0x4e0
[   43.733354][ T3944]  ghash_clmulni_intel
[   43.733756][ T3785]  ? lock_acquired+0x201/0x460
[   43.734387][ T3944]  kvm_intel
[   43.734751][ T3785]  schedule+0x5d/0xe0
[   43.735428][ T3944]  iTCO_wdt
[   43.735974][ T3785]  rwsem_down_write_slowpath+0x375/0x730
[   43.736391][ T3944]  iTCO_vendor_support rapl
[   43.737076][ T3785]  ? rcu_read_lock_sched_held+0x10/0x90
[   43.737533][ T3944]  i2c_i801
[   43.738114][ T3785]  ? lock_contended+0x1d0/0x510
[   43.738631][ T3944]  i2c_smbus
[   43.739217][ T3785]  down_write+0xad/0x110
[   43.739600][ T3944]  lpc_ich
[   43.740086][ T3785]  unlink_anon_vmas+0xb1/0x200
[   43.740484][ T3944]  drm
[   43.741157][ T3785]  free_pgtables+0x98/0xe0
[   43.741692][ T3944]  drm_panel_orientation_quirks zram
[   43.742337][ T3785]  exit_mmap+0xc3/0x210
[   43.742721][ T3944] 
[   43.743337][ T3785]  __mmput+0x49/0x130
[   43.743734][ T3944] CR2: ffff8881bc1c044f
[   43.744254][ T3785]  do_exit+0x355/0xca0
[   43.744641][ T3944] ---[ end trace 0000000000000000 ]---
[   43.745230][ T3785]  make_task_dead+0x51/0x60
[   43.745569][ T3944] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   43.746109][ T3785]  rewind_stack_and_make_dead+0x17/0x20
[   43.746912][ T3944] Code: ff ff e2 90 48 81 fa c8 5c 01 a0 0f 84 ab 41 e1 ff ff e2 90 48 81 fa c8 60 01 a0 7f 47 48 81 fa 94 60 01 a0 7f 2e 48 81 fa 88 <5f> 01 a0 7f 15 48 81 fa 88 5f 01 a0 0f 84 40 44 e1 ff ff e2 66 0f
[   43.747422][ T3785] RIP: 0033:0x7fbae8d0af3d
[   43.747770][ T3944] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   43.748266][ T3785] Code: Unable to access opcode bytes at RIP 0x7fbae8d0af13.
[   43.748906][ T3944] 
[   43.749409][ T3785] RSP: 002b:00007fbae8bfedf8 EFLAGS: 00000246
[   43.750244][ T3944] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   43.750794][ T3785]  ORIG_RAX: 0000000000000141
[   43.751729][ T3944] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   43.752444][ T3785] RAX: ffffffffffffffda RBX: 00007fbae8bff640 RCX: 00007fbae8d0af3d
[   43.755008][ T3944] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   43.755013][ T3944] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   43.755015][ T3944] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   43.755017][ T3944] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   43.755020][ T3944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.755022][ T3944] CR2: ffff8881bc1c044f CR3: 000000016b010004 CR4: 0000000000770ef0
[   43.755028][ T3944] PKRU: 55555554
[   43.829192][ T3785] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[   43.831106][ T3785] RBP: 00007fbae8bfee20 R08: 0000000000000000 R09: 0000000000000000
[   43.837695][ T3785] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[   43.839223][ T3785] R13: 0000000000000011 R14: 00007ffc40078bd0 R15: 00007fbae8bdf000
[   43.840751][ T3785]  </TASK>
[   43.841408][ T3785] irq event stamp: 0
[   43.854904][ T3785] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   43.856217][ T3785] hardirqs last disabled at (0): [<ffffffff81153fd2>] copy_process+0xae2/0x2070
[   43.857910][ T3785] softirqs last  enabled at (0): [<ffffffff81153fd2>] copy_process+0xae2/0x2070
[   43.860769][ T3785] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   43.865965][ T3785] ---[ end trace 0000000000000000 ]---
[   44.173757][    C0] int3: 0000 [#22] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   44.173764][    C0] CPU: 0 PID: 4037 Comm: ex Tainted: G      D W          6.0.0-rc1+ #824 21a018c85c1ae4a46b8de4e02b8902f514469e39
[   44.173770][    C0] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
[   44.173771][    C0] RIP: 0010:bpf_dispatcher_xdp+0xa74/0x1000
[   44.173778][    C0] Code: 52 e1 ff ff e2 90 48 81 fa 94 72 01 a0 7f 17 48 81 fa 94 72 01 a0 0f 84 2e 58 e1 ff ff e2 0f 1f 84 00 00 00 00 00 48 81 fa cc <72> 01 a0 0f 84 4f 58 e1 ff ff e2 90 48 81 fa 50 77 01 a0 0f 8f 33
[   44.173781][    C0] RSP: 0018:ffffc9000788fc38 EFLAGS: 00000896
[   44.173784][    C0] RAX: ffff88816a4d8040 RBX: ffffc90007893000 RCX: ffffc9000788fc6c
[   44.173785][    C0] RDX: ffffffffa0017510 RSI: ffffc90007893048 RDI: ffffc9000788fd38
[   44.173786][    C0] RBP: ffffc9000788fd38 R08: ffffc9000788fd34 R09: 0000000000000000
[   44.173788][    C0] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90007893048
[   44.173789][    C0] R13: ffffc9000788fd30 R14: 0000000000000001 R15: ffffc9000788fc98
[   44.173791][    C0] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   44.173793][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   44.173794][    C0] CR2: 00007ffce4ffe638 CR3: 000000016a078003 CR4: 0000000000770ef0
[   44.173800][    C0] PKRU: 55555554
[   44.173801][    C0] Call Trace:
[   44.173802][    C0]  <TASK>
[   44.173803][    C0]  ? bpf_test_run+0x104/0x2e0
[   44.173813][    C0]  ? wake_up_q+0x4a/0x90
[   44.173822][    C0]  ? bpf_prog_test_run_xdp+0x463/0x600
[   44.173830][    C0]  ? __sys_bpf+0xf52/0x29e0
[   44.173836][    C0]  ? rcu_read_lock_sched_held+0x10/0x90
[   44.173841][    C0]  ? rcu_read_lock_sched_held+0x10/0x90
[   44.173844][    C0]  ? rcu_read_lock_sched_held+0x10/0x90
[   44.173846][    C0]  ? lock_release+0x25e/0x4e0
[   44.173850][    C0]  ? rcu_read_lock_sched_held+0x10/0x90
[   44.173852][    C0]  ? rcu_read_lock_sched_held+0x10/0x90
[   44.173870][    C0]  ? __x64_sys_bpf+0x1a/0x30
[   44.173874][    C0]  ? do_syscall_64+0x37/0x90
[   44.173877][    C0]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   44.173886][    C0]  </TASK>
[   44.173887][    C0] Modules linked in: intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel kvm_intel iTCO_wdt iTCO_vendor_support rapl i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram
[   44.236183][    C0] ---[ end trace 0000000000000000 ]---
[   44.236186][    C0] RIP: 0010:bpf_dispatcher_xdp+0xb36/0x1000
[   44.236198][    C0] Code: 59 e1 ff ff e2 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 81 fa 90 74 01 a0 0f 84 63 59 e1 ff ff e2 90 48 81 fa c8 74 01 <a0> 0f 84 8b 59 e1 ff ff e2 90 48 81 fa 90 75 01 a0 7f 47 48 81 fa
[   44.236201][    C0] RSP: 0018:ffffc9000500bc38 EFLAGS: 00010086
[   44.236204][    C0] RAX: ffff88816c028040 RBX: ffffc9000500d000 RCX: ffffc9000500bc6c
[   44.236206][    C0] RDX: ffffffffa0015510 RSI: ffffc9000500d048 RDI: ffffc9000500bd38
[   44.236208][    C0] RBP: ffffc9000500bd38 R08: ffffc9000500bd34 R09: 0000000000000000
[   44.236222][    C0] R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000500d048
[   44.236224][    C0] R13: ffffc9000500bd30 R14: 0000000000000001 R15: ffffc9000500bc98
[   44.236226][    C0] FS:  00007f54fafbd640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[   44.236228][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   44.236230][    C0] CR2: 00007ffce4ffe638 CR3: 000000016a078003 CR4: 0000000000770ef0
[   44.236235][    C0] PKRU: 55555554
[   44.236236][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[   44.239185][    C0] Kernel Offset: disabled
[   44.260093][    C0] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
