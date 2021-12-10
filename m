Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97834707FB
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbhLJSEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhLJSEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:04:08 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10676C061746;
        Fri, 10 Dec 2021 10:00:33 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id t19so14303508oij.1;
        Fri, 10 Dec 2021 10:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gAusYcjMSdi6ENjoyW2rmnebOZmH0DJmsAW1WGU5ejo=;
        b=VXFJE1O848TGo7qIxz8zimyQdPxSmfi0z2tIFy191p8v3r7EiWlIfEfN0V2WropX4s
         xKV0vrR/VLfSetqYDi3CdI7ATqxCt2uNv5ePs+5Ub0nCBVdBLw3ngHcHNLddAfImUHVY
         fMouKQDAqTdb8Rbbg1WI9hNxAaFzNrUahfs+uCtS1bsHWWPfvT5jIS3q2mFGGwMM22Vj
         YgJfPpAVJsa6V1F+QZ/jLVdCjtOBiklJarhBzVPnBD1tCbShz8BFFb8UaaHcNsFuDmG8
         ecsAg6jyhZd30x3tiJhpnLhfWUrP62UZqwbk3vm9vyOdXRP+D6NovP3IEyeYuAvvbPMS
         QLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gAusYcjMSdi6ENjoyW2rmnebOZmH0DJmsAW1WGU5ejo=;
        b=ttigJT0Pp8ORYgEqjrzimbpl+XXav61Uch1P7J9kXtKcDbcmVGzZx5R8jm/SIy8T7e
         iWp7k4eE/1EhmlJKnhWlXMqxu4bkbtp0D+cppYjovZMLVTDFKcsg44O8QWP9w0Ae1kJD
         oGwaa7Esmzt3dtRmDVLo3dy4ITNJbYZ+DJsjginFekK3cClsV0FZlw9/UiZy55vyrK8D
         1DA7wYbVQr3UqwWACHeVgS8f08ilBM8kuUteb92+DCg1vE5LTgWAv5LAT6OwfiFTBOtw
         JEK6TFjc6/RmY9yHBgdDtcnrHG8oFSkKWZLHw19DnS/JfLjeKswxs4MldXsvTf8GmtRI
         3GXA==
X-Gm-Message-State: AOAM533c98ko/XKcag1Z+J4VBRLgiktgSSeh8RlIC8Oz2M/RQUccmlnt
        HY2Jboiav5Fq0ppWnFK9FsQeo7v/RuXErQ==
X-Google-Smtp-Source: ABdhPJww+uZk2RQFNLxjbBx7wHU293+7KnyPm6xqnDALh2RMA3QUCzpAqBD4GbRy42e7bl6h5TRfQw==
X-Received: by 2002:a54:4401:: with SMTP id k1mr14221689oiw.143.1639159232402;
        Fri, 10 Dec 2021 10:00:32 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id bq5sm917562oib.55.2021.12.10.10.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:00:32 -0800 (PST)
Date:   Fri, 10 Dec 2021 10:00:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <61b395ba5cc03_2032520824@john.notmuch>
In-Reply-To: <20211210111918.4904-1-danieltimlee@gmail.com>
References: <20211210111918.4904-1-danieltimlee@gmail.com>
Subject: RE: [PATCH] samples: bpf: fix tracex2 due to empty sys_write count
 argument
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel T. Lee wrote:
> Currently from syscall entry, argument can't be fetched correctly as a
> result of register cleanup.
> 
>     commit 6b8cf5cc9965 ("x86/entry/64/compat: Clear registers for compat syscalls, to reduce speculation attack surface")
> 
> For example in upper commit, registers are cleaned prior to syscall.
> To be more specific, sys_write syscall has count size as a third argument.
> But this can't be fetched from __x64_sys_enter/__s390x_sys_enter due to
> register cleanup. (e.g. [x86] xorl %r8d, %r8d / [s390x] xgr %r7, %r7)
> 
> This commit fix this problem by modifying the trace event to ksys_write
> instead of sys_write syscall entry.
> 
>     # Wrong example of 'write()' syscall argument fetching
>     # ./tracex2
>     ...
>     pid 50909 cmd dd uid 0
>            syscall write() stats
>      byte_size       : count     distribution
>        1 -> 1        : 4968837  |************************************* |
> 
>     # Successful example of 'write()' syscall argument fetching
>     # (dd's write bytes at a time defaults to 512)
>     # ./tracex2
>     ...
>     pid 3095 cmd dd uid 0
>            syscall write() stats
>      byte_size       : count     distribution
>     ...
>      256 -> 511      : 0        |                                      |
>      512 -> 1023     : 4968844  |************************************* |
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/tracex2_kern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> index 5bc696bac27d..96dff3bea227 100644
> --- a/samples/bpf/tracex2_kern.c
> +++ b/samples/bpf/tracex2_kern.c
> @@ -78,7 +78,7 @@ struct {
>  	__uint(max_entries, 1024);
>  } my_hist_map SEC(".maps");
>  
> -SEC("kprobe/" SYSCALL(sys_write))
> +SEC("kprobe/ksys_write")
>  int bpf_prog3(struct pt_regs *ctx)
>  {
>  	long write_size = PT_REGS_PARM3(ctx);
> -- 
> 2.32.0
> 

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
