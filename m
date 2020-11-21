Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846882BBDDD
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 08:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgKUHiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 02:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgKUHiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 02:38:06 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA77C0613CF;
        Fri, 20 Nov 2020 23:38:06 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id g15so10827741ybq.6;
        Fri, 20 Nov 2020 23:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0uMqtuZYyit3rkstjKgdpdIgZ+hwCKX+nB+J4vIPM8=;
        b=FdaQIrPLzHPeHnyS/kXSYoqjT0PKYicSc5gjxbQyk14akh1tVkLPf6nYY8NvyIht37
         CfRUoE5ELPs1JpEA+ZRT3arwi3/oIfe1lFreYv09WE0cNi/062yUNXzPtQVqSSISMu26
         0K4jz9U6UkS/iBFyzmmr/UnzrjkhtLy4IV/17RKc+8hZ6tTRqIbngn//eniYlaS81Je+
         iIR2wh/PjDHX+JRQozK62Uq9U+PnVetgpe1TShQrGYyx6E/hbUhnYY2gEZFCgxaE/ar6
         7phwkeAj4F2lO47Xx4bqz5xzyzlIxWLPyDsjENh9nPLf1Tg7Q8qq6AKlGVQ53hrj1EEc
         wFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0uMqtuZYyit3rkstjKgdpdIgZ+hwCKX+nB+J4vIPM8=;
        b=euIPjoWufOf2T1J+YYaEAKVfV3ClHwzM0L3R58qn+U21cyrJdieu8fyvvm6eYFrFhM
         USMWSnlPDW5FatfLg4vktMwKbNu3s2E7ZOiyACirSDPJaQEc+e5b0nRvievQ+fd6r2dy
         DDfLVBPHo1nClO9ZH+r4hr0PFN3t8Z7muNAVu57JLXnB4+HDPKlU2O3hSrti4X7R5xSY
         pFmBlP/DtWROc2pXVcBG8MAj3CNSCBSeT911aG8IKztIKOEavBvsoOlsH0YiXcdAp1iY
         i5IC/xMjbY+/3868AXymUA2GuZVc3bzHEFayHWMDBJyYbM417tLmhrPyv9J383z6KOrn
         duJg==
X-Gm-Message-State: AOAM530S3VpxdOGX6DQ90PnvLCdPWQuWtFwjEN+ePBkat6ZtlelXf4WE
        dRnWzOP/nP57LBqui6/FOn/Cd2YdPWASTwtvHuesCvaHD7TAUg==
X-Google-Smtp-Source: ABdhPJwZ6CjIPowUxq3oip+ROMaNn/h2brOlLVZlRVexvOQ9kEIeM067fq0dbIhpztB7MrHazoYaAK2/gwVGAzBSWm4=
X-Received: by 2002:a25:df82:: with SMTP id w124mr29190011ybg.347.1605944285647;
 Fri, 20 Nov 2020 23:38:05 -0800 (PST)
MIME-Version: 1.0
References: <20201119085022.3606135-1-davidgow@google.com>
In-Reply-To: <20201119085022.3606135-1-davidgow@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Nov 2020 23:37:54 -0800
Message-ID: <CAEf4BzY4i0fH34eO=-4WOzVpifgPmJ0ER5ipBJWB0_4Zdv0AQg@mail.gmail.com>
Subject: Re: [RFC PATCH] bpf: preload: Fix build error when O= is set
To:     David Gow <davidgow@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:51 AM David Gow <davidgow@google.com> wrote:
>
> If BPF_PRELOAD is enabled, and an out-of-tree build is requested with
> make O=<path>, compilation seems to fail with:
>
> tools/scripts/Makefile.include:4: *** O=.kunit does not exist.  Stop.
> make[4]: *** [../kernel/bpf/preload/Makefile:8: kernel/bpf/preload/libbpf.a] Error 2
> make[3]: *** [../scripts/Makefile.build:500: kernel/bpf/preload] Error 2
> make[2]: *** [../scripts/Makefile.build:500: kernel/bpf] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [.../Makefile:1799: kernel] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:185: __sub-make] Error 2
>
> By the looks of things, this is because the (relative path) O= passed on
> the command line is being passed to the libbpf Makefile, which then
> can't find the directory. Given OUTPUT= is being passed anyway, we can
> work around this by explicitly setting an empty O=, which will be
> ignored in favour of OUTPUT= in tools/scripts/Makefile.include.

Strange, but I can't repro it. I use make O=<absolute path> all the
time with no issues. I just tried specifically with a make O=.build,
where .build is inside Linux repo, and it still worked fine. See also
be40920fbf10 ("tools: Let O= makes handle a relative path with -C
option") which was supposed to address such an issue. So I'm wondering
what exactly is causing this problem.

>
> Signed-off-by: David Gow <davidgow@google.com>
> ---
>
> Hi all,
>
> I'm not 100% sure this is the correct fix here -- it seems to work for
> me, and makes some sense, but let me know if there's a better way.
>
> One other thing worth noting is that I've been hitting this with
> make allyesconfig on ARCH=um, but there's a comment in the Kconfig
> suggesting that, because BPF_PRELOAD depends on !COMPILE_TEST, that
> maybe it shouldn't be being built at all. I figured that it was worth
> trying to fix this anyway.
>
> Cheers,
> -- David
>
>
>  kernel/bpf/preload/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 23ee310b6eb4..39848d296097 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -5,7 +5,7 @@ LIBBPF_A = $(obj)/libbpf.a
>  LIBBPF_OUT = $(abspath $(obj))
>
>  $(LIBBPF_A):
> -       $(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
> +       $(Q)$(MAKE) -C $(LIBBPF_SRCS) O= OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
>
>  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
>         -I $(srctree)/tools/lib/ -Wno-unused-result
> --
> 2.29.2.454.gaff20da3a2-goog
>
