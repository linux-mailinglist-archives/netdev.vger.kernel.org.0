Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8174625B8A7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgICCPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICCPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 22:15:17 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D902C061244;
        Wed,  2 Sep 2020 19:15:17 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x10so994799ybj.13;
        Wed, 02 Sep 2020 19:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FkxEKsQG15r7PPqpQBxAtns7+5zX3DzBpFDEatgAqgw=;
        b=sWGhvFRH7+T66bByIIL/DVxV1CPFI9PoHjQeahpPjD3SGOGo/IzIK18KexwSGXI8tc
         UbWveS17/lgZZQSjcM2c3Jug0f9jc/+0DnyuS91XiAJNSLEIV+Mbnzw8vBOA1G6hV2IM
         Ii9VCEeqrrPQf4H6y5txD9FQ3tGyPLTaarua7vY5USpiDl/4D8KVZkqGq2aS98Cuk5xt
         LjuxhjapkYq0LFG+9n7ARmsrm7mXdBxedOONPWLFUQCGoEsawTsWPnm6OoIpUTZ4Iaxy
         /sIqRWRLscekIS9uDLFphcSkAF0SNqgvy823JZ3FYjcOHmu2+fe71aoVrOSaCm9FmjQz
         lLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FkxEKsQG15r7PPqpQBxAtns7+5zX3DzBpFDEatgAqgw=;
        b=dVa0oKQbXGzNKbBA9qETX6VgD7IEY29ceux983bEl9PVeSNNC3tKbYJ6U6k1aFtvH6
         y1gYWSDG9NQsQ0b9l2sek8fJ2y7SXgw4PqG5Ys7oMgbrr4ZPx3gB2lffh274rk2prW8/
         F5/rKQW0tnHSrSYVFNjvqNgFP/FsORz2Je8wPxIPWhM8bHk5KN5z//UY9vjthanSlu9L
         jpkvW/4GT4tHq1DObgUzjpNpNS52hhW5qBl8LPp2xDSOsIBvmdA+GTzuDz2Hi0NpTyPo
         6UduKCkAeNWz2KosCWC6/tS/doLzVU2KMauS3uPNOOyEhCkMj9WRsOeaGkd0yzK2J8Jv
         N8dQ==
X-Gm-Message-State: AOAM530SoeVEK5sosnaklnzC5CJIR/PW+VtU+sK5m4d5OVLK4XpEwNHL
        l4TTQREftKECFsa25O0/ivCDH2PFgJPX8n/Tu/k=
X-Google-Smtp-Source: ABdhPJzw5SncssbpjCgxLo3/YrgVLW101mlUyX7AH+Y926iGtxcsxIwYBTpM9VwiAuV6DYJYUnUyBFHFMmktxB7EQ6I=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr917464ybe.459.1599099316260;
 Wed, 02 Sep 2020 19:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-3-sdf@google.com>
In-Reply-To: <20200828193603.335512-3-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 19:15:05 -0700
Message-ID: <CAEf4BzZ8PURFN+Omu0NMEV5s=3s1jmLTcrNDTkQHzQDPK0KAFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/8] bpf: Add BPF_PROG_BIND_MAP syscall
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

On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> This syscall binds a map to a program. -EEXIST if the map is
> already bound to the program.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/uapi/linux/bpf.h       |  7 ++++
>  kernel/bpf/syscall.c           | 65 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 ++++
>  3 files changed, 79 insertions(+)
>

[...]

> +
> +       mutex_lock(&prog->aux->used_maps_mutex);
> +
> +       used_maps_old = prog->aux->used_maps;
> +
> +       for (i = 0; i < prog->aux->used_map_cnt; i++)
> +               if (used_maps_old[i] == map) {
> +                       ret = -EEXIST;
> +                       goto out_unlock;

Do we need to return any error in this case? The intent of this
command is to make sure the map is bound to the prog, right? If it's
already bound, good, it's a success, just no extra steps were
performed internally. What's the use for this EEXIST if it's always
going to be ignored?

> +               }
> +
> +       used_maps_new = kmalloc_array(prog->aux->used_map_cnt + 1,
> +                                     sizeof(used_maps_new[0]),
> +                                     GFP_KERNEL);
> +       if (!used_maps_new) {
> +               ret = -ENOMEM;
> +               goto out_unlock;
> +       }
> +

[...]
