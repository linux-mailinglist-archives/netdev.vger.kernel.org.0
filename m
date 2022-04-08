Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A08F4FA023
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbiDHXbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiDHXbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:31:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578633879C;
        Fri,  8 Apr 2022 16:29:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n6-20020a17090a670600b001caa71a9c4aso11124648pjj.1;
        Fri, 08 Apr 2022 16:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QjU7P6Mje68Dj8uHrxYsbMa00fkak543WtGtCY9I5yk=;
        b=MFg6klzdiMzHMVA/wMhHGqy/HUZ0tEhEkI3CuNubU4ClC7YecQ68gjtICtNMJNndOA
         FnYBF2J7sf/4k7+H33UUAle5PRpnn8fwk6D94OV4hrJBIdNNAB8Gx0oHQVfqxi+gpbxY
         55IPYDkJmPI/YuJff5SQAwjGIobl8kWyf49W+/EkKD4IjzO1eQ/kQ0SkBLB6HomfwNqZ
         IkPowjS7YZsULYdubQvVQuHysAB3rGd3qky7TBdGyIwruV0jTofPWXcmrEWZ6PjfZeCg
         qt4O9gqQy+9G9dp38JSjskJGD/pwwTGtmPUO2Jt8gIR7NonqkcL2k8maCZhlvuYlDW9P
         AGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QjU7P6Mje68Dj8uHrxYsbMa00fkak543WtGtCY9I5yk=;
        b=b2JNrGnAv+rV8kOH6ga9X841PBBQkXU6dNVoYatq8UPUZ9BVlz92qFrDN79erVY4Pr
         ZfXjsR6q3Vz7fTWrWb0PBAS8K3465QNFhXbnSoKOzKqrrt25CpWAl4tD0cDl9r11sa0k
         hYIqZGMLhznoFPjo5SbhZcv7+pa4DFtItlaFI+6kJ3WKIEkeu1o6KvDaaY4bMILv+qXh
         K/6sfNRL3dRfFhNDEVUlPI4J/q4HgfXWcOeYe6pnlCdHIQBVkpi0HR7WNM5fyc9ED7ps
         OYKhL46OjdIYzwaalKO1QC4XfaVAnOI5cnKD/0oTTIa5p0EiBUxH2njrkTd8R1vYKyen
         aiew==
X-Gm-Message-State: AOAM531ZZZp7o0+aLpkai0jyw6K2PITcW6qWn61BIuov7g/NA50EeGuI
        gZgp1cHpp0EZQNLKWZUjkLA=
X-Google-Smtp-Source: ABdhPJxywNGIcILRm3j6auY7vKWWm3Eyja/V65Pg3HhattSWDjAVpf/i+std2+6SQZMdUITcqAxNtw==
X-Received: by 2002:a17:90a:fe12:b0:1ca:b7e8:1086 with SMTP id ck18-20020a17090afe1200b001cab7e81086mr24508046pjb.213.1649460565800;
        Fri, 08 Apr 2022 16:29:25 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:4c4c])
        by smtp.gmail.com with ESMTPSA id f2-20020a17090a120200b001cb5101afbasm2310119pja.4.2022.04.08.16.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:29:25 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:29:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407125224.310255-1-jolsa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> hi,
> sending additional fix for symbol resolving in kprobe multi link
> requested by Alexei and Andrii [1].
> 
> This speeds up bpftrace kprobe attachment, when using pure symbols
> (3344 symbols) to attach:
> 
> Before:
> 
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> 
> After:
> 
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> 
> 
> There are 2 reasons I'm sending this as RFC though..
> 
>   - I added test that meassures attachment speed on all possible functions
>     from available_filter_functions, which is 48712 functions on my setup.
>     The attach/detach speed for that is under 2 seconds and the test will
>     fail if it's bigger than that.. which might fail on different setups
>     or loaded machine.. I'm not sure what's the best solution yet, separate
>     bench application perhaps?

are you saying there is a bug in the code that you're still debugging?
or just worried about time?

I think it's better for it to be a part of selftest.
CI will take extra 2 seconds to run.
That's fine. It's a good stress test.

>   - copy_user_syms function potentially allocates lot of memory (~6MB in my
>     tests with attaching ~48k functions). I haven't seen this to fail yet,
>     but it might need to be changed to allocate memory gradually if needed,
>     do we care? ;-)

replied in the other email.

Thanks for working on this!
