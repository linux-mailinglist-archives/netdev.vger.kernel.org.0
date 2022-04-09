Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975FA4FAABA
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 22:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiDIU0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 16:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiDIU0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 16:26:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C7D5F258;
        Sat,  9 Apr 2022 13:24:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z1so17618854wrg.4;
        Sat, 09 Apr 2022 13:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ueaAEaieoV6TCFUSXh5Ey9ZYNc68Ex0m47u4PqQnpMo=;
        b=pbceoNHNbkBt4CX00dQ/kkxqrgKFmmsaDUZs5LNSqRaOyWQGlQKBDk9i8hNuvIMZhI
         Y8zgMjLJJVBzNr3VAZ3hVSIpNPpxuUVYvE/7ZSoRcB2pvie8+5Om0cT3whMGRTAza/zh
         5MiIu6YgGpEkSUDVKSJAuvS8gxAeWB7pA4fQfZj718iB1k0cMtaqOgyQRI4bW3B6HX/4
         w4OS9u3U0nJs+nsOT1ysIMhLTgqli0P/dMqhacOng+AedtUzSLLlnTc1Ab9upByhVBtT
         JM8jRQVirMP7+AsJxjucFk+P6CZgwUnIu+n/Nqr5aaPQnmlqQkl57WaAhPOIiCXPS4Ro
         ekOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ueaAEaieoV6TCFUSXh5Ey9ZYNc68Ex0m47u4PqQnpMo=;
        b=6TTe8f6D8QVgJnkj+W3S1wRcT3QYiIX+/b1NKiQjSyfnJqW6b1cNL1nQ84ETsNqgIK
         Na6p+gFZTIc0X7tvnAYD6VWsnMvivZK26E+ruYyirG6XsbwoWFUVPuYpsnEHV3utLMKu
         884hld8QnBlOWw1m7nVX3tEhzmYVJkqsBsfZTATVZtGCih6Xe+I2bNGweNcExtVlp2Q7
         4bxQl1A36qf25C62K7dgBaEBVrRxN6BrVnkdV8vVl2rAhwHasZXyJOOLYKbfJoW7FSdo
         fwR6XyVoOQOqN9z99S2k42QheAzpb+iYqfD3wpziXX6bAgc+9K+cEBMRl5xhP2qRz9oy
         O79g==
X-Gm-Message-State: AOAM53216RiTC4qixLZYoTNwNFaeAwI8U5PD+0mZNF7D/KtZjYW2c2hC
        dpTZKV9g9GKw+wVoRF721Ac=
X-Google-Smtp-Source: ABdhPJwGj4AfossTyG3KtupQrwpRO8tDxNNuNL7hcGkr/Imu3dvnJ4LkEHgmE7m8A+M8AWf2EIBDsQ==
X-Received: by 2002:adf:82c1:0:b0:207:9d8b:dd6c with SMTP id 59-20020adf82c1000000b002079d8bdd6cmr3658275wrc.4.1649535865471;
        Sat, 09 Apr 2022 13:24:25 -0700 (PDT)
Received: from krava (94.113.247.30.static.b2b.upcbusiness.cz. [94.113.247.30])
        by smtp.gmail.com with ESMTPSA id f66-20020a1c3845000000b0038eb64a52b5sm973257wma.43.2022.04.09.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 13:24:25 -0700 (PDT)
Date:   Sat, 9 Apr 2022 22:24:22 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe
 multi link
Message-ID: <YlHrdhkfz+IuGbZM@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 04:29:22PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> > hi,
> > sending additional fix for symbol resolving in kprobe multi link
> > requested by Alexei and Andrii [1].
> > 
> > This speeds up bpftrace kprobe attachment, when using pure symbols
> > (3344 symbols) to attach:
> > 
> > Before:
> > 
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > 
> > After:
> > 
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > 
> > 
> > There are 2 reasons I'm sending this as RFC though..
> > 
> >   - I added test that meassures attachment speed on all possible functions
> >     from available_filter_functions, which is 48712 functions on my setup.
> >     The attach/detach speed for that is under 2 seconds and the test will
> >     fail if it's bigger than that.. which might fail on different setups
> >     or loaded machine.. I'm not sure what's the best solution yet, separate
> >     bench application perhaps?
> 
> are you saying there is a bug in the code that you're still debugging?
> or just worried about time?

just the time, I can make the test fail (cross the 2 seconds limit)
when the machine is loaded, like with running kernel build

but I couldn't reproduce this with just paralel test_progs run

> 
> I think it's better for it to be a part of selftest.
> CI will take extra 2 seconds to run.
> That's fine. It's a good stress test.

ok, great

thanks,
jirka

> 
> >   - copy_user_syms function potentially allocates lot of memory (~6MB in my
> >     tests with attaching ~48k functions). I haven't seen this to fail yet,
> >     but it might need to be changed to allocate memory gradually if needed,
> >     do we care? ;-)
> 
> replied in the other email.
> 
> Thanks for working on this!
