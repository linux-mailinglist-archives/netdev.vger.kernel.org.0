Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5982A9EA6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgKFUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKFUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:41:15 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21262C0613CF;
        Fri,  6 Nov 2020 12:41:15 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id g15so2266907ybq.6;
        Fri, 06 Nov 2020 12:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXrpuCgbHGPkXrL8EDCTVatq79k2biAMrH6DnCMYtLg=;
        b=imytYR+/gxZRffg9Cg6cnS88WCEJguY/eo7kl+jiw9eXJ3Jag+Zs4/oNRMs5+Rp/q7
         l6RT+REDAL6ujAwTtSEkQlyohkvsLq0NQUFqHg/d9u8KAc22yqq3R8dM+eYCXSELmoo6
         MrLVZyBmYcLpfXV0ppMyM8tnDa61vXK1O4NtMiJDBSCgHG/kszG4Uz2RQ6zj3EDTr95M
         H4ya9dwPhip/LaXw7xjTaxrHxSKDSUvu/ZEOChFT85b5K/TNYNtacV3IkYV3Bdp+HJan
         mf+JuozlI6c7p68MqcG1hlUO3Id5+R/MDQacy9rIiXC7wkixrXoUjs7F4fkrItWFJGMV
         aipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXrpuCgbHGPkXrL8EDCTVatq79k2biAMrH6DnCMYtLg=;
        b=MAe4zIqxS4Kqax0R0OHqjZXDqHg6TFOYtlXBG8xktsdkMPFuhQ44tn71GfgtOGnHLY
         dutMpxY4xItCa9ovd5+44Hnq83+nASEEGpRjimEKMxNte0j92Hxmp9BRklXXqwtvXQn1
         QmyuIGhKT5qTXxAA0ZCoDmr76ruk3D92til3IbCufpf4wMi5xdBqY0ixw092DR/mlC4K
         5eqYF6i2/1tUpYAgyRX1cedvtNWTVMHeFvLzKdS++n9vPcXwP7WoJ8U8mTo31I3BCokn
         v26qVHSKPB6ju9IHKnPElN/zTZRuqVT3CTUyiH170EnSxTD+WD+unFRrrBEhzlqrVXTZ
         K9Lw==
X-Gm-Message-State: AOAM531SLgiY69t5S4WZSIKg6KTkqIY/wRNgF2DJDIGiltKiKUZwhijZ
        /GCWFmUkfA/S9M/7sy/XRwJY/2CHohtsSIag/80=
X-Google-Smtp-Source: ABdhPJxiz1jLUBDjvArd4MaYnBRQLaZQZ+hW8VJTGZK/kukVZ2oN/nwERCD4Q1i5/COsRIdt0it5uBFhID2gQElwZpU=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr5337996ybl.347.1604695274441;
 Fri, 06 Nov 2020 12:41:14 -0800 (PST)
MIME-Version: 1.0
References: <1604652452-11494-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1604652452-11494-1-git-send-email-wangqing@vivo.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 12:41:03 -0800
Message-ID: <CAEf4Bzan81+Go84k9fenKMixCthGzXZ6v27vTyqbkmBC1LLXyw@mail.gmail.com>
Subject: Re: [PATCH] trace: Fix passing zero to 'PTR_ERR' warning
To:     Wang Qing <wangqing@vivo.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 12:49 AM Wang Qing <wangqing@vivo.com> wrote:
>
> Fix smatch warning.
>
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4517c8b..2cb9c45
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1198,7 +1198,7 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
>         *btf = bpf_get_btf_vmlinux();
>
>         if (IS_ERR_OR_NULL(*btf))
> -               return PTR_ERR(*btf);
> +               return PTR_ERR_OR_ZERO(*btf);

Either way returns zero for error? Which is the actual bug, so I think
the proper fix is:

return *btf ? PTR_ERR(*btf) : -EINVAL;

Or something like that.

>
>         if (ptr->type_id > 0)
>                 *btf_id = ptr->type_id;
> --
> 2.7.4
>
