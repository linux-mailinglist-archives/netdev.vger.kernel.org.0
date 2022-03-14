Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322074D82CD
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbiCNMLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbiCNMIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:08:46 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540824ECC0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:05:25 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso19877742ooi.1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pU9uPGpxANVVIsgcKvz7K/tE4whMaqHpIgoLY54UlzI=;
        b=fFBE2zBqOW+xujSQr8CaSD78WW9sRE+zJEFn/EDFTxjhCNW8VpKV1g41OMj7TiyZAu
         iUBbomn/izP5EZEVMdsumuc+XGcHrI8+CXNdDRIkO/IfB0/qUbYNEEnFtwHIise1Q/vA
         wauwo733B8lvPOUUr/EyBpPbLxW4CdGY2FGT8DD9eMEI2XpqTLLU4UDnKSY7A4ZNgfcW
         czck7SIybF6Vq99KSErtsu6tlPRmIJZ4X8fXMdfTxDQKKi0RplLWE/fkatQ+kuc13vzF
         +1hkviP8Dl/j26McxJW9pXn3pNPfA/SHfFoX8el8wOlQsg/YzI8NJi3rImz7uoTq1EfH
         HREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pU9uPGpxANVVIsgcKvz7K/tE4whMaqHpIgoLY54UlzI=;
        b=RrqFMdHf3fTD+Hn9yufzEdnjGMYF2q9+AuuYzdshHz/6uqsDdhFO2z19ftwd2aOkM5
         XigL7bSj5i3DC0hXlnmaQSB7wZ+hgfwtUoRXOtEJauMaHb7msLfAaWgTOkB184syCVes
         OtcgtTBmzSEGWHwNZtJZIquxWI1so2ixeXHtbyCzxElcxid90/9W/gFsXY83B65Cih3Z
         eIOYdcjmPY3rfm7FFvrRVQ611Fd3Z6T9ZXCLP9SZReIeChjSNdXr/uER2LMclC3hSqsj
         PphNFbbNL1EEFrpLCQjQaSvuLc3HmuFPZMy/3h09Q8aWcP22n52shCbKyMy/AF5II/rj
         2jEg==
X-Gm-Message-State: AOAM533pZbAiNhFae6Yczp8IWTp3L3TC8zfr+Urtc7Kc+bGC18Qs7oaE
        l6XB2YmMr6VmRDvWhuPfTIXpc5ezY32vVIZRtHTObw==
X-Google-Smtp-Source: ABdhPJw1RA8znJT/hN+bAS4MYap2EO+2EYDpBtnfmfEOGkxzFMtWAaxnlgzhcuEKmiInZcwpRIjPFkYbZvZ8lhZbGiI=
X-Received: by 2002:a05:6870:d254:b0:db:12b5:da3 with SMTP id
 h20-20020a056870d25400b000db12b50da3mr2285214oac.211.1647259518800; Mon, 14
 Mar 2022 05:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ec53005da294fe9@google.com> <CACT4Y+YXzBGuj4mn2fnBWw4szbb4MsAvNScbyNXi1S21MXm8ig@mail.gmail.com>
 <CACT4Y+a1AvU4ZA3BXPpQMQ15A2T0CT_mrNTXv0NttJ0B06fH=w@mail.gmail.com> <fb12b19d57c34928895e0faa8067f64c@AcuMS.aculab.com>
In-Reply-To: <fb12b19d57c34928895e0faa8067f64c@AcuMS.aculab.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 14 Mar 2022 13:05:07 +0100
Message-ID: <CACT4Y+ae7WRhnmiTuFg6zrL7z_8rUrmWzopOGMZv6f0ONmd3yg@mail.gmail.com>
Subject: Re: [syzbot] kernel panic: corrupted stack end in rtnl_newlink
To:     David Laight <David.Laight@aculab.com>
Cc:     syzbot <syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 at 11:44, David Laight <David.Laight@aculab.com> wrote:
>
> From: Dmitry Vyukov
> > Sent: 14 March 2022 09:09
> >
> > On Mon, 14 Mar 2022 at 09:22, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Mon, 14 Mar 2022 at 09:17, syzbot
> > > <syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    0966d385830d riscv: Fix auipc+jalr relocation range checks
> > > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17fe80c5700000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=0600986d88e2d4d7ebb8
> > > > compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for
> > Debian) 2.35.2
> > > > userspace arch: riscv64
> > >
> > > +linux-riscv
> > >
> > > Riscv needs to increase stack size under KASAN.
> > > I will send a patch.
>
> With vmalloc()ed stacks is it possible to allocate an extra page
> of KVA that isn't backed by memory as a 'guard page' so that
> stack overflow faults immediately?
>
> Probably worth enforcing for KASAN builds where the compilers
> have a nasty habit of using lot more stack space that might
> be expected.

Yes, this would be useful. At least for x86 we use and rely on this.
