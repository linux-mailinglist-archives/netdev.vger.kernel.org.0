Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF63B58CC44
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 18:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbiHHQlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiHHQlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 12:41:09 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2B81115A;
        Mon,  8 Aug 2022 09:41:05 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u14so2832134oie.2;
        Mon, 08 Aug 2022 09:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fLnheameMTeEL0CE77MMCkg1If0aNMzopn0WMXOJTKk=;
        b=qOJKou/ClLwTQLP4NNnUxSQa6KbdAPdN0mUjvDRIOhKCgcX0DCi4Fc3l3cTaGTeanB
         6X1xlputAEYCKUowsG8f6hACY+bgsiVHi8U65759+pnIgp3hIaB3Hsl3OZm3riTrsENz
         tB0pm4ezHPBKQEq1/Ftb4Z8FTByzZbJmmdO4gXh1nS1+gI5AO9lCCfBSjbUJTGpDpLjk
         e5wD7Dm7U0+UT4d+ZPHKj6eXmPQUrRmMulH1EjVa2Ia9jGbokP+GEpJNi9CBU5LWscIN
         Ndd9QcERICcThuNytvwSoXhb/7qHWB9xF2KIffs9vIQtAqz77DoiNLA4puVFdNbqLGbj
         j+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fLnheameMTeEL0CE77MMCkg1If0aNMzopn0WMXOJTKk=;
        b=zRanVqk6QOm9+BBoTYmW4H/JXjoFof7ltm1jmRpWX3JsFT3cJlXywzCbltzcgkHMnK
         wzZp7D5C0Y7GoQtAC8VyzHdOLZO3zjgg7FtvV/ZR92dU9u+53v/dOZyxf6T1Zd0nKedW
         AAwQlZHactIosQjua+m41bYGsavqlyBQlDCTSgfN6G3ubMD2CvS9T/gNQl9imkefJWJK
         8nibCwfJSfpoVl5gaF8nevB1nxNUl1WovEaxAd0myyxeZeiDaN4U6XDjEv7qp/9Qms7J
         3Wiqs3F2IrHl56XbPEFlMsvxfn1fwCfyyZR1Wht1Ie/l6ykJbzJj8fnWvsxttUdgyok1
         Iucw==
X-Gm-Message-State: ACgBeo2g7bdonL04f5s2oMBQ+wXinrKEdm1tXLzGhdl9NugDtE5CuY94
        typk2F4qrWJrrl6omyOf/JY=
X-Google-Smtp-Source: AA6agR7luNFvpCWE/t9/r8m8eopNqkdTdHSdd4rwc3gBkgtq2Df4OJnYf9DNr1arbqvv7Lck6GCiKA==
X-Received: by 2002:a05:6808:138f:b0:33a:9bb6:80b5 with SMTP id c15-20020a056808138f00b0033a9bb680b5mr11130215oiw.243.1659976865158;
        Mon, 08 Aug 2022 09:41:05 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id a32-20020a056870a1a000b0010d997ffe7asm2444787oaf.37.2022.08.08.09.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 09:41:04 -0700 (PDT)
Date:   Mon, 8 Aug 2022 09:38:52 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 11/16] time: optimize tick_check_preferred()
Message-ID: <YvE8HGXFDicr/zI5@yury-laptop>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-12-yury.norov@gmail.com>
 <87fsi9rcxu.ffs@tglx>
 <87czdbq7up.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czdbq7up.ffs@tglx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 01:42:54PM +0200, Thomas Gleixner wrote:
> On Sat, Aug 06 2022 at 10:30, Thomas Gleixner wrote:
> > On Mon, Jul 18 2022 at 12:28, Yury Norov wrote:
> >
> >> tick_check_preferred() calls cpumask_equal() even if
> >> curdev->cpumask == newdev->cpumask. Fix it.
> >
> > What's to fix here? It's a pointless operation in a slow path and all
> > your "fix' is doing is to make the code larger.

Pointless operation in a slow path is still pointless.
 
> In fact cpumask_equal() should have the ptr1 == ptr2 check, so you don't
> have to add it all over the place.

This adds to the image size:
add/remove: 1/1 grow/shrink: 24/3 up/down: 507/-46 (461)

The more important, cpumask shouldn't check parameters because this is
an internal function. This whole series point is about adding such checks
under DEBUG_BITMAP config, and not affecting general case.

What about adding cpumask_equal__addr? (Any better name is welcome.)

Thanks,
Yury
