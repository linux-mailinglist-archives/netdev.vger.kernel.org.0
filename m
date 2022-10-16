Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFD9600287
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJPRwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 13:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPRwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 13:52:41 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4082D2C64B
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:52:41 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1364357a691so11209538fac.7
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QztUo4N/kTk5bDBhUjBzfNp1RuCgwau01vLbd3JmZqg=;
        b=NNPZIxOGwq7wDPFMGpcVXO7NTLgI9ICQPKuf2caldzrebIRVDNJ2ml38mL0vXNkBNY
         gMxRxqI+/kwvRl/seXDI+pVjBXVnMrAdNrvpSroNLhLwnMTVj7k1fGgGE4LQF/9YT6FR
         BFpp95mR9EXyYU2xUfDb+p3E+g08Te95dtggA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QztUo4N/kTk5bDBhUjBzfNp1RuCgwau01vLbd3JmZqg=;
        b=IaMsw2JDYLQvglD3GD4RyOU5grwARfXQRxQ4R4l0PXu9PX+MdHJ+jHHlpL+nBH0NPS
         vq+FU87OMr4RUZHvCF4kvjVlmavBw5q+kk61e4UdHe5Ti7ONWeoqRZHOYAQ0NTAW4TNR
         a3tUIjLndwsNwHImza0vjA2TEJPe/n2QY07J97z3g0aV3NHaGNfVLH+OfHSr5yZYI6S1
         7/q7l6OYM6Z8gG0jG+/bLrpzQHzbEDA+x8vsCG2u6K4K28lTrAu6aTj1kCYvcWF2nWi4
         YkoAfzvfuvr55ooNKB+nsZ663vmB9oiDQ/OgO9oDrRzi0vg9fEDuiv8DKNwXbArhQRhc
         DeIw==
X-Gm-Message-State: ACrzQf0Dqb++8ipsBX8cnW4QDOlVaOeONoR3eKd8Zm3ahmbCp1DVmjy0
        xcWQ+xJsryt7BFHROrC6qc0GHz23PUKQNw==
X-Google-Smtp-Source: AMsMyM6+aq7ajABlWFFTWqN/v3VO9VCv/YQKC6uXN7ubsWGqoz9D7pYf/UXgiZ+9nH7f39dm/qtlhw==
X-Received: by 2002:a05:6870:3485:b0:12b:df60:622d with SMTP id n5-20020a056870348500b0012bdf60622dmr3861905oah.25.1665942759521;
        Sun, 16 Oct 2022 10:52:39 -0700 (PDT)
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com. [209.85.160.46])
        by smtp.gmail.com with ESMTPSA id x27-20020a056870a79b00b001372c1902afsm3983859oao.52.2022.10.16.10.52.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Oct 2022 10:52:38 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1322d768ba7so11227615fac.5
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:52:38 -0700 (PDT)
X-Received: by 2002:a05:6870:c0c9:b0:127:c4df:5b50 with SMTP id
 e9-20020a056870c0c900b00127c4df5b50mr3901741oad.126.1665942757701; Sun, 16
 Oct 2022 10:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007647ec05eb05249c@google.com> <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic> <Y0sbwpRcipI564yp@yury-laptop> <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
 <Y0tafD7qI2x5xzTc@yury-laptop>
In-Reply-To: <Y0tafD7qI2x5xzTc@yury-laptop>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 16 Oct 2022 10:52:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihz-GXx66MmEyaADgS1fQE_LDcB9wrHAmkvXkd8nx9tA@mail.gmail.com>
Message-ID: <CAHk-=wihz-GXx66MmEyaADgS1fQE_LDcB9wrHAmkvXkd8nx9tA@mail.gmail.com>
Subject: Re: [syzbot] WARNING in c_start
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Borislav Petkov <bp@alien8.de>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 6:12 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> On Sun, Oct 16, 2022 at 09:24:57AM +0900, Tetsuo Handa wrote:
> >
> > Again, please do revert "cpumask: fix checking valid cpu range" immediately.
>
> The revert is already in Jakub's batch for -rc2, AFAIK.

Hmm.

I've looked at this, and at the discussion, and the various reports,
and my gut feel is that the problem is that the whole
"cpumask_check()" is completely bogus for all the "starting at bit X"
cases.

And I think it was wrong even before, and yes, I think the "+1"
simplification just made things worse.

I think that where it makes sense is in contexts where we actually
*use* the bit value as a bit, so cpumask_clear_cpu() doing

        clear_bit(cpumask_check(cpu), cpumask_bits(dstp));

makes 100% sense and is unequivocally something that merits a warning.
An out-of-range cpu number is a serious bug in that context.

But all the cases where the function fundamentally already limits
things to the number of CPU's (with comments like "Returns >=
nr_cpu_ids if no further cpus unset.") should simply not have the
cpumask_check() at all.

All it results in just moving the onus of testing things into the
callers, or just makes for odd complications ("-1 is valid, because it
acts as the previous cpu for the beginning because we add one to get
the next CPU").

Anyway, since rc1 is fairly imminent, I will just revert it for now -
I don't want to have a pending revert wait until -rc2.

But I actually suspect that the thing we should really do is to just
remove the check entirely for these functions that are already defined
in terms of "if no more bits, return nr_cpu_ids". They already
basically return an error case, having them *warn* about the error
they are going to return is just obnoxious.

                     Linus
