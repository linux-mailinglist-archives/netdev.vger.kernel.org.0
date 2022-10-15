Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC135FFBEA
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 22:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiJOUo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 16:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJOUoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 16:44:55 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947F727CE8;
        Sat, 15 Oct 2022 13:44:52 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id j21so4582046qkk.9;
        Sat, 15 Oct 2022 13:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xh6TSzvbNFywc6iwi85Ia3FIfwAjKhdb6xypb+c6K1g=;
        b=Tw4XIMbMEJq0QfU1mVohFCuYu7dCJ0q3q8gUGC8wgbmHd9TDMxpCa8QjZBog8S8HYs
         SXafbyIE3cmw6qu5oku8+Q0COZR+K1RYy5n/jhPfeodWe3UieVvAs7rHzdzKdv1NFrnF
         VxIzyQdlGhClZqh3yqLm8CTvh4UR3+L0vYVi5pO/9VO8BAClR7VoilCf/5r2jkjU8DE6
         LW/2TzrNI2DlfRbgWxxL92S/lqCSZhnJcY6Eqjpo5rr47H52VOAXp08jQbaKIrAk6WHN
         HH0cy3/2z8R4KbQvA4scxmzgIotLyBCpRPbXD33f50zaq0iPM+crroW0NDRijKQXUkAM
         FpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xh6TSzvbNFywc6iwi85Ia3FIfwAjKhdb6xypb+c6K1g=;
        b=p8bX7GSWqUQLGn5geIJvWnGqofUNmU46Vo6rarcnz3rxzPvTysj4Vu7pFSctB4ktj2
         smW6WsWvBiZCj1+3QvVMlC06SqGm3QJwuP7Ob7mlp5dQIuyxhzICV2J9snjtuUa39NBJ
         6JdAH7usQ/Pbg+39cfoAAXBS9WiWWkBHglL+87S3TFjJCegQSAwKT/lH9VqAXd0KW1em
         3V9jvql1LthHAoxG/nZSksLnt98XJTo+9eus4AvVTIl+RyfCWskDOJdQzZM9XMqOmg2K
         Hvh6KOS+WIX9hGZHF1x/Ne++blx3BmiTBULgq1B++Em3F+mBDOgPGw/1uyYdcq8BlPqn
         qdKA==
X-Gm-Message-State: ACrzQf2VIviQWyaKxf8fmSEKuziVGetYC2ceDj6w0or8PyZunYaMrBqu
        6RNQQLi1prAZ23wMk6T5EV4=
X-Google-Smtp-Source: AMsMyM5LV4OMmfMRZm+5KYtXnWDtuXiHxkFXZjBuPwmd2y8+gPU9/ar1dFP180Oe3/D9tUhabgSr5A==
X-Received: by 2002:ae9:ea03:0:b0:6e0:ca9c:e795 with SMTP id f3-20020ae9ea03000000b006e0ca9ce795mr2881444qkg.168.1665866691570;
        Sat, 15 Oct 2022 13:44:51 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:b7d0:ec47:792a:b1d9])
        by smtp.gmail.com with ESMTPSA id w13-20020a05620a424d00b006ce441816e0sm5694840qko.15.2022.10.15.13.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 13:44:51 -0700 (PDT)
Date:   Sat, 15 Oct 2022 13:44:50 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
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
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [syzbot] WARNING in c_start
Message-ID: <Y0sbwpRcipI564yp@yury-laptop>
References: <0000000000007647ec05eb05249c@google.com>
 <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0qfLyhSoTodAdxu@zn.tnic>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add people from other threads discussing this.

On Sat, Oct 15, 2022 at 01:53:19PM +0200, Borislav Petkov wrote:
> On Sat, Oct 15, 2022 at 08:39:19PM +0900, Tetsuo Handa wrote:
> > That's an invalid command line. The correct syntax is:
> > 
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> The fix is not in Linus' tree yet.
> 
> > Andrew Jones proposed a fix for x86 and riscv architectures [2]. But
> > other architectures have the same problem. And fixing all callers will
> > not be in time for this merge window.
> 
> Why won't there be time? That's why the -rcs are for.
> 
> Also, that thing fires only when CONFIG_DEBUG_PER_CPU_MAPS is enabled.
> 
> So no, we will take Andrew's fixes for all arches in time for 6.1.

Summarizing things:

1. cpumask_check() was introduced to make sure that the cpu number
passed into cpumask API belongs to a valid range. But the check is
broken for a very long time. And because of that there are a lot of
places where cpumask API is used wrongly.

2. Underlying bitmap functions handle that correctly - when user
passes out-of-range CPU index, the nr_cpu_ids is returned, and this is
what expected by client code. So if DEBUG_PER_CPU_MAPS config is off,
everything is working smoothly.

3. I fixed all warnings that I was aware at the time of submitting the
patch. 2 follow-up series are on review: "[PATCH v2 0/4] net: drop
netif_attrmask_next*()" and "[PATCH 0/9] lib/cpumask: simplify
cpumask_next_wrap()". Also, Andrew Jones, Alexander Gordeev and Guo Ren
proposed fixes for c_start() in arch code.

4. The code paths mentioned above are all known to me that violate
cpumask_check() rules. (Did I miss something?)

With all that, I agree with Borislav. Unfortunately, syzcall didn't CC
me about this problem with c_start(). But I don't like the idea to revert
cpumask_check() fix. This way we'll never clean that mess. 

If for some reason those warnings are unacceptable for -rcs (and like
Boris, I don't understand why), than instead of reverting commits, I'd
suggest moving cpumask sanity check from DEBUG_PER_CPU_MAPS under a new
config, say CONFIG_CPUMASK_DEBUG, which will be inactive until people will
fix their code. I can send a patch shortly, if we'll decide going this way.

How people would even realize that they're doing something wrong if
they will not get warned about it?

Thanks,
Yury
