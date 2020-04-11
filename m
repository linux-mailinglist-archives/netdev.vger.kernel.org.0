Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305C11A5697
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgDKXRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:17:25 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36349 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgDKXRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 19:17:24 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so2261380pjb.1;
        Sat, 11 Apr 2020 16:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qpPTz4h01PybJ/ueRBwH9cE11K5rgvJCwJGJJ5phT3w=;
        b=ANRd4eU/qzz1x/Irdd8z7efz0Nd2R8JfCwrV0MHxCgrWsw3N+MtJQLKoqUcgbQbptI
         r9y5U7GDCf4e+tLEUbW8quTo+Wnp4cl3OMeNz2wHC8A6MelNf7GZqDGsnhqFxRdbFPly
         sya70Lo7riwC8DDFIpNH0pIIWHpwO7pN3K7a6uOFIJ32RIKHFFiD2LxQK0rLY5SEyWOc
         7QQeD0MtjdI2rl42sfKR22P01bx+bO4XBcXLQhm0ZxjQvF0de14x730LfqDhcTWPcAiD
         xAvoIaPNj8SAnjsCeDJP/CkGfpa31R7ul5sewI6ON/Aw4j+qiZ3a5i//wlg+nj3mEI2z
         YvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qpPTz4h01PybJ/ueRBwH9cE11K5rgvJCwJGJJ5phT3w=;
        b=nBX1V5Nvsz3I1iQp5as6sR1g1k50QFW3iVXsNzwELjHSMRMivEPnuK7eKUCyz7Jl2G
         lj24jaLyWsiC+tp93ge2pnc8IYs1fnArnNByjbogah3ggqiEHQADqCR0NpsZQCOo5y6+
         nshYZOaPvkOTKh6YyZqNvXQQJ9KnKrVgD5ZZjocWl4LZhfC22diV0NHxWz8nrngFxzqR
         hqA7WLwfNQwOO+kjhQMOb+P+BW/R8JvXQmQQGAe5LBdm1bgjLObH87+tI29N5FVoYUVY
         xHrjcCdu/vbyUEtDCq835T4lV9xwq1q3mfB8Mh+SnnP/MGWwNqY0U8HQkohJxvVBT46p
         NXfQ==
X-Gm-Message-State: AGi0PubeJk4MB2UpxyPUNkMcPJOQQ7spDPAQrUw5BOuj+C5AHN1SSSP8
        nQgdV+JFeOGRdbERDi5+TJqDXeaj
X-Google-Smtp-Source: APiQypKXIrpRI/ANL+FAQvbIW21VaebCgrEzE2vjI+pRerScQS68X1NiabZv7KgCGhiegl0qVjrVOA==
X-Received: by 2002:a17:90a:1f0b:: with SMTP id u11mr13319998pja.18.1586647042482;
        Sat, 11 Apr 2020 16:17:22 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:507f])
        by smtp.gmail.com with ESMTPSA id k12sm4945809pfk.46.2020.04.11.16.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:17:21 -0700 (PDT)
Date:   Sat, 11 Apr 2020 16:17:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200411231719.4nybod6ku524eawv@ast-mbp>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com>
 <334a91d2-1567-bf3d-4ae6-305646738132@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <334a91d2-1567-bf3d-4ae6-305646738132@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:23:30PM -0700, Yonghong Song wrote:
> > 
> > So it seems like few things would be useful:
> > 
> > 1. end flag for post-aggregation and/or footer printing (seq_num == 0
> > is providing similar means for start flag).
> 
> the end flag is a problem. We could say hijack next or stop so we
> can detect the end, but passing a NULL pointer as the object
> to the bpf program may be problematic without verifier enforcement
> as it may cause a lot of exceptions... Although all these exception
> will be silenced by bpf infra, but still not sure whether this
> is acceptable or not.

I don't like passing NULL there just to indicate something to a program.
It's not too horrible to support from verifier side, but NULL is only
one such flag. What does it suppose to indicate? That dumper prog
is just starting? or ending? Let's pass (void*)1, and (void *)2 ?
I'm not a fan of such inband signaling.
imo it's cleaner and simpler when that object pointer is always valid.

> > 2. Some sort of "session id", so that bpfdumper can maintain
> > per-session intermediate state. Plus with this it would be possible to
> > detect restarts (if there is some state for the same session and
> > seq_num == 0, this is restart).
> 
> I guess we can do this.

beyond seq_num passing session_id is a good idea. Though I don't quite see
the use case where you'd need bpfdumper prog to be stateful, but doesn't hurt.
