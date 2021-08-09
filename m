Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31E3E4DDB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhHIUdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbhHIUdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:33:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31D0C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 13:32:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso833981pjb.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 13:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNVydc3Y0hKoPvNGSPfx5xYezPDk2CodGWpsBJ8FCOY=;
        b=oc6hbEtHf4Yn6PfpvaM8Q+kDvDRMQt77diLf/hrVoA+wJJ81HtMlT1PTpb5i9XgPdJ
         1Bt626kR90YTGFTeVEizciAv6L8pV5RVMguRBX1E4nTVzm37uN7OdMb1f7hDjVkpdVzO
         PMbp01t3ASDIMtTRPxp6kRwyjCZr1x2T9Xfp7ocjWfUfnxY5Xaujj8XLh23/VGMKg+XA
         jmHsTnAL5to2yWG45alcmUyLUCeCBGUvok5e+UPwahBVtbliwH271DbuTgGlL3GsqEjg
         twQDMne6UCwrsvC/pWnj3Ag5UjT2rjmFlXvfI/KSsaV5mfF1KzYlzshu0SvL6cDDH5xw
         Tv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNVydc3Y0hKoPvNGSPfx5xYezPDk2CodGWpsBJ8FCOY=;
        b=PZhl1K0hNzZVfthLnQVrJ/FMOE2nHQrJ8As75Ke9kIQnykvKCQl2UheGFD0qc1tT2m
         1mHN6oLKr//kV751LCzNN5cwJ1+LFpP3/yhqNtAevOWaEzngeN3Nib0qobZ6NwSX9EpC
         dmOFMINVb9dWFyv2aVZ7Gg9qiD0CQm3vWeFqyFfiRmMcEIvApug2M5L+EFbp5TgkYO6F
         fHIvadQH/MJRly2XbqBd4cWnSR13h47I6QuN9C8sZQgs9aD/k1xnVJh9n8UT+Iduo0Z9
         dRSIF86h3Wa1nv0kKtv+D5a4jOme5nPc0oiRtO23uxdT8WfKbh92Ec7yxVq1k6eqve6J
         pVUQ==
X-Gm-Message-State: AOAM530IKfk0fYuxvzQOMYtzhHsc86/I70XxdOZ6jp4/XRnXgM2uKnQO
        IbqPUUX78bXG36SPgOD1OPa8fw0UV1dy4x8744w=
X-Google-Smtp-Source: ABdhPJzBR5PDWuSZd8sVdYzxNSHzEKSjN7vifdq6ix3bbi2ORbJj9wXzBdOmbvLdULpl+W6BAQRQLL0PrS8xUqPUqro=
X-Received: by 2002:a17:90a:b10f:: with SMTP id z15mr27620043pjq.56.1628541173196;
 Mon, 09 Aug 2021 13:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com> <5c565b2c-85a5-9141-112f-be854cccc558@gmail.com>
In-Reply-To: <5c565b2c-85a5-9141-112f-be854cccc558@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 9 Aug 2021 13:32:41 -0700
Message-ID: <CAM_iQpV8c=mUW=jXi4AS6p+tF2qVKmSfGqWrX5iAHDS62brdXg@mail.gmail.com>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint trace_ip_queue_xmit()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 3:09 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> While it is useful to have stuff like this,
> ddding so many trace points has a certain cost.
>
> I fear that you have not determined this cost
> on workloads where we enter these functions with cold caches.
>
> For instance, before this patch, compiler gives us :
>
> 2e10 <ip_queue_xmit>:
>     2e10:       e8 00 00 00 00          callq  2e15 <ip_queue_xmit+0x5> (__fentry__-0x4)
>     2e15:       0f b6 8f 1c 03 00 00    movzbl 0x31c(%rdi),%ecx
>     2e1c:       e9 ef fb ff ff          jmpq   2a10 <__ip_queue_xmit>
>
>
> After patch, we see the compiler had to save/restore registers, and no longer
> jumps to __ip_queue_xmit. Code is bigger, even when tracepoint is not enabled.

Interesting, I didn't pay attention to the binary code generated
by compilers. Let me check it, as I have moved the trace function
before __ip_queue_xmit() (otherwise the order is reversed).

Thanks!
