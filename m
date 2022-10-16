Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C472E5FFCD3
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 03:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJPBMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 21:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJPBMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 21:12:33 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529BDF5F;
        Sat, 15 Oct 2022 18:12:30 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t25so4805167qkm.2;
        Sat, 15 Oct 2022 18:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M6jFIGhx+nOyZ6rzu58iWqKDcyExepoMoxIJXMpw6gs=;
        b=ncYIUmGK7C113vowuHgFK5UKcdec2QuRPLEhTS7UszkE8BWy5pQ0NGWuuSdADawR72
         m62n10HNf9Zv+1WBTch3uDIdQoXfntdAkTmHBvOhy+pb7Aig4Du3YoT7Egl9os4TKf1s
         4sKUI93kVGDtVEADo+jKvTyfOXBYr2UsaoXOXqzkTunclRbNYmaQDY+ZDHa3Zr1Jw/cw
         EWdKruSDSOvKKUy3NvKSu3jdAacctB/thouLF4IkfD0pNZ0vecGEa4vYBemHK7+m/cdu
         ZVtHcubCyH5yvsH43sPS9jTcPtpnL+As9aJH76j827ON6eGSZy4oSqxNgrRaH4klMKs+
         QN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6jFIGhx+nOyZ6rzu58iWqKDcyExepoMoxIJXMpw6gs=;
        b=a8OUBX98ljmg1X1payWq1Y9VohEy2CIxXrXy4rALj1bUYrosGveAbybVIJaDG231Ze
         tkqcyCAr1wjQ1qpb43j1vqk2rB+qFkpG7d3/aVl9CSaAPn0+0+iUfPQcKCL1sxuxOY7b
         DSB3iLf3aY/J5PY0O/+PaNbrOPqHpiAdn3UQvNSjKvxNZFgysgldjQh+U/QX0wWx0DMD
         LiVuamrJ1u9zEvHA+5XQHN7YAj6JJaNvrZjBNjJDpyCt3gkoaR7IZt1cSLuKSy6VDG64
         Vo0UeYLgdNy1ZoCKXv5WQcIfnHC3Iwy7tvfMg4/dY9gItl8AG1ef1ed2P7TXvXTlhD3P
         cJjA==
X-Gm-Message-State: ACrzQf3/XuNaEWyKRYf8Acc4/ARJF1MwYEGFFNiE2WdSoo+yCkkfktqB
        oxXaA8GWIUqLsGVHupDFDLE=
X-Google-Smtp-Source: AMsMyM7/UjqcuM+PFkGWSXN5J8StM+QgIGSheY4X7K1tiWZVy0/GwT9iB933kahz3utjUzVMWNaLRQ==
X-Received: by 2002:a05:620a:21cf:b0:6ed:82e:8a5b with SMTP id h15-20020a05620a21cf00b006ed082e8a5bmr3515687qka.657.1665882749901;
        Sat, 15 Oct 2022 18:12:29 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:b7d0:ec47:792a:b1d9])
        by smtp.gmail.com with ESMTPSA id r187-20020a37a8c4000000b006d1d8fdea8asm5745301qke.85.2022.10.15.18.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 18:12:29 -0700 (PDT)
Date:   Sat, 15 Oct 2022 18:12:28 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+d0fd2bf0dd6da72496dd@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Andrew Jones <ajones@ventanamicro.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [syzbot] WARNING in c_start
Message-ID: <Y0tafD7qI2x5xzTc@yury-laptop>
References: <0000000000007647ec05eb05249c@google.com>
 <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic>
 <Y0sbwpRcipI564yp@yury-laptop>
 <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 16, 2022 at 09:24:57AM +0900, Tetsuo Handa wrote:
> On 2022/10/16 5:44, Yury Norov wrote:
> > Add people from other threads discussing this.
> > 
> > On Sat, Oct 15, 2022 at 01:53:19PM +0200, Borislav Petkov wrote:
> >> On Sat, Oct 15, 2022 at 08:39:19PM +0900, Tetsuo Handa wrote:
> >>> That's an invalid command line. The correct syntax is:
> >>>
> >>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> >>
> >> The fix is not in Linus' tree yet.
> >>
> >>> Andrew Jones proposed a fix for x86 and riscv architectures [2]. But
> >>> other architectures have the same problem. And fixing all callers will
> >>> not be in time for this merge window.
> >>
> >> Why won't there be time? That's why the -rcs are for.
> >>
> >> Also, that thing fires only when CONFIG_DEBUG_PER_CPU_MAPS is enabled.
> >>
> >> So no, we will take Andrew's fixes for all arches in time for 6.1.
> > 
> > Summarizing things:
> > 
> > 1. cpumask_check() was introduced to make sure that the cpu number
> > passed into cpumask API belongs to a valid range. But the check is
> > broken for a very long time. And because of that there are a lot of
> > places where cpumask API is used wrongly.
> > 
> > 2. Underlying bitmap functions handle that correctly - when user
> > passes out-of-range CPU index, the nr_cpu_ids is returned, and this is
> > what expected by client code. So if DEBUG_PER_CPU_MAPS config is off,
> > everything is working smoothly.
> > 
> > 3. I fixed all warnings that I was aware at the time of submitting the
> > patch. 2 follow-up series are on review: "[PATCH v2 0/4] net: drop
> > netif_attrmask_next*()" and "[PATCH 0/9] lib/cpumask: simplify
> > cpumask_next_wrap()". Also, Andrew Jones, Alexander Gordeev and Guo Ren
> > proposed fixes for c_start() in arch code.
> > 
> > 4. The code paths mentioned above are all known to me that violate
> > cpumask_check() rules. (Did I miss something?)
> > 
> > With all that, I agree with Borislav. Unfortunately, syzcall didn't CC
> > me about this problem with c_start(). But I don't like the idea to revert
> > cpumask_check() fix. This way we'll never clean that mess. 
> > 
> > If for some reason those warnings are unacceptable for -rcs (and like
> > Boris, I don't understand why), than instead of reverting commits, I'd
> > suggest moving cpumask sanity check from DEBUG_PER_CPU_MAPS under a new
> > config, say CONFIG_CPUMASK_DEBUG, which will be inactive until people will
> > fix their code. I can send a patch shortly, if we'll decide going this way.
> > 
> > How people would even realize that they're doing something wrong if
> > they will not get warned about it?
> 
> I'm asking you not to use BUG_ON()/WARN_ON() etc. which breaks syzkaller.

It's not me who added WARN_ON() in the cpumask_check(). You're asking
a wrong person. 

What for do we have WARN_ON(), if we can't use it?

> Just printing messages (without "BUG:"/"WARNING:" string which also breaks
> syzkaller) like below diff is sufficient for people to realize that they're
> doing something wrong.
> 
> Again, please do revert "cpumask: fix checking valid cpu range" immediately.

The revert is already in Jakub's batch for -rc2, AFAIK.

Thanks,
Yury
