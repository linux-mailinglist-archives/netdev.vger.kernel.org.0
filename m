Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156A6264F09
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgIJTb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgIJT31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:29:27 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7BFC061573;
        Thu, 10 Sep 2020 12:29:21 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 195so4790726ybl.9;
        Thu, 10 Sep 2020 12:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Kkmd5i71e5SXs+HrB0Q4cmO1EDQUaQYsDFxwl9JHV0=;
        b=cHZAs4Fw/wHSju+Ss2xMq53wAHCrg/V/cDeecUvCpVztJqUdgitWSXkjGU8Cn2jLK9
         w7JZhk3CyGMrb1tKgipHXBP3KKlADoFiF+3nHUhubcWfJfEEsnEPLPzoRbqXdqEJm9PO
         FF9zw4p8Qx1TEYJQtuul/HHVu72zHzp70FCnJyFUcIfCt7RE0/nBaUKpPQZpFf/gaPBf
         pJvAeSA8SyRcg240FPthor96MKKHt3tPDBCNJu+2TGfTxJ1d7CWz0LYW/gBqNl18tag0
         Ca57pnJ0tP6uPXqAwNBdzVaZGig8tB5Any5uMcqpBaH1Pf0y+BlEvl2ODS5s8yBhRw4p
         p68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Kkmd5i71e5SXs+HrB0Q4cmO1EDQUaQYsDFxwl9JHV0=;
        b=CLJ+3Ylqq2G/5z3JxT9Ah6ZTL3MoerNkEX2AiyV+f5ML6n4bcJ1asXU3mpmNH5h6F6
         DG0ckU6AZs9doI+lI6GQkEf+0L34DS52QIuO0xkslaPqmPBBO3gKrCN95Skoq1AxjPba
         8acSjgIAxO7O74dvEMo/FqZRouVvIR+1JarNqAE1ibm4JFzGXhKLEVvuRXvumTbMQa2V
         BfJs4vLBhpK95ZMVmrWWujixxtxjYnJknD89iGkao/NLKCNt7DOzjtFAfdHwA2d0Bo9U
         IThiuC2L5oG3vvO0oKwweVEt7Srg+VWiJ449C6y4YV9EpyL9Rko4h00YFc7vfPPjYkwY
         lX0w==
X-Gm-Message-State: AOAM530mPojKA6JQ6WmYRUVngWA91v56SKoFZe3p4NmhRc6fZR8SwkIq
        TEwuRTZOeqTL5fDI/8eQHntdm/VPBhf75IkoZDLGjE4u76w=
X-Google-Smtp-Source: ABdhPJxuOfryDcXTNGnLYAQEIkAuewS9mL6VcudURnfzjoia1cfLeTs2pZUXGK70sNkKE1y4RWXYsjM0lyqf0VhVJYY=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr13689119ybp.510.1599766161070;
 Thu, 10 Sep 2020 12:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-3-sdf@google.com>
In-Reply-To: <20200909182406.3147878-3-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 12:29:10 -0700
Message-ID: <CAEf4BzYS5HCtb+gTV_BHk2=K5UcPuzvo6ku2Er7a6vR3FKwGcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/5] bpf: Add BPF_PROG_BIND_MAP syscall
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> This syscall binds a map to a program. Returns success if the map is
> already bound to the program.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/uapi/linux/bpf.h       |  7 ++++
>  kernel/bpf/syscall.c           | 63 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 ++++
>  3 files changed, 77 insertions(+)
>

[...]
