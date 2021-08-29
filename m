Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD503FAD60
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbhH2RFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 13:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhH2RFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 13:05:20 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5248CC061575;
        Sun, 29 Aug 2021 10:04:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fz10so7936771pjb.0;
        Sun, 29 Aug 2021 10:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=55IMWtSa+Z7mHHOE+8rmvrIaongEWfOtNnZCXik1094=;
        b=EqflWSXhbLRRTMqRIOAiV+S8S4KqVjIG7czsYoQttB7CTiV2SAEObKXY7L7gem/4AT
         6I2oFh1lKven7gR/mLmI6N0dWkpOjFDrqiH77KYnhIOvbDSein+G8SVOd9oBikZeubmC
         F3Z8+Kk5rFsAIv6UKyN1gnKtzGx+BPXGCkVHXWsdsn/Tju1a3+UoUrhIbm6i7c9szzJt
         gKAVx1ow6Rq0txZ0o1/hV3VyMTLbcCT3pod8PfyeZN51yYZ/XdDvKBg1/SAIBQ5FT1yW
         3jQ/N4mOlmPJxGDVFrY62VrDjpfWZ0ye9XxINYMmnjoRZ2E4EvgZsRvaJh1M7Sdblu6d
         +TaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=55IMWtSa+Z7mHHOE+8rmvrIaongEWfOtNnZCXik1094=;
        b=eAAD5nBw7F1MZ6APp5kVMG/5+7tGhd2QGZTOxUaWnh65fEzQt0ILOvCefIpw6IjCLX
         ZabrO9IKJeALWzrrcm0EuHQgJhivWMHRAqiDolG5m1pNB3Y6koqUgr3+M4BIqb/e3tXx
         qx76BpP2kUPMvLuwnB9EhEWzIFjG/mKDOEQEP+sTOIOgfRy0ftlEYK0vn6QYRgJdWbSy
         7hvSysFEPN9n89DcCxFcpKyGt+PQv+czO+euk1qMYWk4gHAP9sm6S/JCbzdhQvNAYhfz
         C3erH8uMnWLgemmfgWbHqVrHuymcgZp39Cv3GZSbZZOA4qlQ8mbvAQ1n5M3pau/5Xaab
         E7Ig==
X-Gm-Message-State: AOAM531flG2NEs6Dc4/LNZ+9vaPz4w+J8dTeE9XW5/k6cU+gOUsf75oz
        /tdFQSD2tERcpN8/izTMuPQ=
X-Google-Smtp-Source: ABdhPJypV76d1nREWPuGhIZMLnXklYpK4H7JAJDvvSIDdfh6+56Q+20mSoFR7zA2W3jHjxaRWKVUyA==
X-Received: by 2002:a17:902:a40c:b029:12c:17cf:ab6f with SMTP id p12-20020a170902a40cb029012c17cfab6fmr18274359plq.71.1630256667705;
        Sun, 29 Aug 2021 10:04:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d606])
        by smtp.gmail.com with ESMTPSA id k4sm12109108pff.12.2021.08.29.10.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 10:04:27 -0700 (PDT)
Date:   Sun, 29 Aug 2021 10:04:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 00/27] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
Message-ID: <20210829170425.hd7zx2y774ykaedt@ast-mbp.dhcp.thefacebook.com>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 09:38:55PM +0200, Jiri Olsa wrote:
> hi,
> sending new version of batch attach support, previous post
> is in here [1].
> 
> The previous post could not assign multi trampoline on top
> of regular trampolines. This patchset is trying to address
> that, plus it has other fixes from last post.
> 
> This patchset contains:
>   1) patches (1-4) that fix the ftrace graph tracing over the function
>      with direct trampolines attached
>   2) patches (5-8) that add batch interface for ftrace direct function
>      register/unregister/modify
>   3) patches (9-27) that add support to attach BPF program to multiple
>      functions

I did a quick look and it looks ok, but probably will require another respin.
In the mean would be great to land the first 8 patches for the upcoming merge
window.
Jiri,
can you respin them quickly addressing build bot issues and maybe
Steven can apply them into his tracing tree for the merge window?
Then during the next release cycle we will only iterate on bpf bits in the
later patches.
Thoughts?
