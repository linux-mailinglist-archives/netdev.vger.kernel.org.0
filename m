Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCF22354F4
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 05:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHBDNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 23:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHBDNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 23:13:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D74C06174A;
        Sat,  1 Aug 2020 20:13:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so18080340pgq.1;
        Sat, 01 Aug 2020 20:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ZHHALmUdIOJLrBF4usMUcoF44uSn8V9xs2LGzK8MKc=;
        b=nLVJo2Dnhj5WVK3GqFsL1lbXhQoMs9kgqHbTliOa7oJYfrzj4LgaOvTXkJXm0dILUw
         n72JDgY/b1r5v/DlYIGt4MDO31cRTcUuOP1tAvrFd7QJpbgwsv8iCbJzlc230GmZ/Ct/
         iolFYFw/gEp1GV0Pj0cS3mzj0GYOBVqihs/SDo/H0Zu8H2Tqs+RfkibTBx51+XT3p/cI
         pP5e9Fnov6+GCEowCPb6jPxCBER2YznBAarZLDCPfrh77mT/nOhF32IWw16FGtvuUqDx
         995VGf7JG6937tQxTpROZPvA8VlBeOur8ympbB3fgt1z0yrNZjOSERjQOZ8QCvg190xo
         6RGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ZHHALmUdIOJLrBF4usMUcoF44uSn8V9xs2LGzK8MKc=;
        b=RT1AcAjk3ZVm91a5knEzbBeDqN2YL5KIOu7hHHyKfvl9u/Z/r20QrJueLP2Mon2GXg
         bctFl2rqwZWBEzalaEbe+hkh70szfnBZlY0ZE2ifdnVrLOJ6ysCmWImVVInbgA2COmFW
         bFtf/lmrzT0qMv+o/j6/HihOcrkK0nzMXwki9QNLJ7L4DGU/gYSFOUwbAeN6vZ+cGYUM
         YtsGxhDDIkWOxp1b5cmfvxOD9rZgmLKuSqPojFhL4gHqhZb4uriFibPBFrzcwJmGY1UM
         SnHQbhyH1lYqYE8eJHq6nYIpkrCBInx1twKfOHtJQikwR0NdSOL8IcZfAe4OpLQ3jCio
         S6SQ==
X-Gm-Message-State: AOAM531FQW0XUxN7ilOTq+N5dsQfWOWgRpx217boWY5ElzaRtMeIUOcj
        NpbpJXk+bcVnX7+MKuVK1zA=
X-Google-Smtp-Source: ABdhPJygrMiHJReiRE6Z3LOL5kMTj88fE9iPEYwOa1RVkwVIZof7IcM+6L9heeA7gtrlcOV3Xhu1yw==
X-Received: by 2002:a62:347:: with SMTP id 68mr9778779pfd.185.1596338025165;
        Sat, 01 Aug 2020 20:13:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:65b5])
        by smtp.gmail.com with ESMTPSA id o23sm16736729pfd.126.2020.08.01.20.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 20:13:44 -0700 (PDT)
Date:   Sat, 1 Aug 2020 20:13:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200802031342.3bfxqo22ezi2zzu4@ast-mbp.dhcp.thefacebook.com>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-11-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801170322.75218-11-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 07:03:18PM +0200, Jiri Olsa wrote:
> Adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
> 
>   bpf_d_path(&file->f_path, buf, size);
> 
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from. Adding just
> very modest set for the start.
> 
> Updating also bpf.h tools uapi header and adding 'path' to
> bpf_helpers_doc.py script.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 13 +++++++++
>  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 13 +++++++++
>  4 files changed, 76 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index eb5e0c38eb2c..a356ea1357bf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3389,6 +3389,18 @@ union bpf_attr {
>   *		A non-negative value equal to or less than *size* on success,
>   *		or a negative error in case of failure.
>   *
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)

Please make it return 'long'. As you well ware the generated code will be better.
