Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021DC1DD6A6
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgEUTIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgEUTIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:08:41 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21006C061A0E;
        Thu, 21 May 2020 12:08:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d7so6354765qtn.11;
        Thu, 21 May 2020 12:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xADZjI/N2EtkaruXQTMj1x8tGiT26fVV1QiEq2ceDQ=;
        b=CYB5wxb7oT680vCxqOcZwIE5kb2n+EVfmYqV7aas+t0PEOLNr/VyzxFaBkmHBTlSfU
         XV5R+VbanFqOGVrQUTjG1JaLB+thnczimBrJCPStyy94PF3eGkkUvt4R4uw5A0azolWk
         35W7bfV8XnDPMcDScZb0AINfrULcMweBEMGdwXUve27WDnecvU7sCU9SwlnCpiQk41v1
         w0e75OGRhAJOzdT99pEbKr9vzf4rJHwW84JO3GSnCV1pe0Q7IAVFO0g7c8zHqiX6q1Tb
         46uqqNeZFbnWrlipX1+mc4dcPpYY5ki0PzVyjrL1fDHNBJ/U/yoBInYJus/dp1yXWPxS
         kAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xADZjI/N2EtkaruXQTMj1x8tGiT26fVV1QiEq2ceDQ=;
        b=AwED3jj1Z5HXniZGqjSqJmsMzoiE9YYul0ecH1K2f8M3LHOzPWoavF1d/lADJCxsfh
         cOlFneAvpsttUdeb3S5p6bkOE1ZbUrvlU2D5/Xs4pNk2E4WzsXtZU2fZCZEyUFPyKSZP
         HTjUG6rM31GOY8ukcJy4Yl+o5ZsIyNxAJ/Y3fwtQ/wxDIsPVwESkxogJux2v++dliAL5
         /x87VtGkPQH/3fx32eDO6iy6+wwB/Bl/rp31QBKXtGsXFgEbjS5mpfUZLXK5vgOnSYVI
         X8k16X0ycMJyHpvubXlcpWqYvfGfYAzGNGVChAlZryBQIHX3FXSxxCRm3dsYfmmhEceD
         oicQ==
X-Gm-Message-State: AOAM531q9IdQh9v9Bt1AsayxiDnen7ZUj74raUnJEODcK2Xhwm5diepy
        BmLnbH4QboNMAcaYwzuGCeK4TZ+76FDLNUadsZA=
X-Google-Smtp-Source: ABdhPJyqb6hU4FvuItXvWCs2Teb01dXQduZPvNngtXUpAqnBEeplx3BVXQiCZV5N2FwXEeL/LRBtDu5oEDnDSU5fVPE=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr12164850qtm.171.1590088120365;
 Thu, 21 May 2020 12:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200520172258.551075-1-jakub@cloudflare.com>
In-Reply-To: <20200520172258.551075-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 12:08:29 -0700
Message-ID: <CAEf4BzbpMp9D0TsC5dhRJ-AeKqsXJ5EyEcCx2-kkZg+ZBnHYqg@mail.gmail.com>
Subject: Re: [PATCH bpf] flow_dissector: Drop BPF flow dissector prog ref on
 netns cleanup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 10:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> When attaching a flow dissector program to a network namespace with
> bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.
>
> If netns gets destroyed while a flow dissector is still attached, and there
> are no other references to the prog, we leak the reference and the program
> remains loaded.
>
> Leak can be reproduced by running flow dissector tests from selftests/bpf:
>
>   # bpftool prog list
>   # ./test_flow_dissector.sh
>   ...
>   selftests: test_flow_dissector [PASS]
>   # bpftool prog list
>   4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
>           loaded_at 2020-05-20T18:50:53+0200  uid 0
>           xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
>           btf_id 4
>   #
>
> Fix it by detaching the flow dissector program when netns is going away.
>
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>
> Discovered while working on bpf_link support for netns-attached progs.
> Looks like bpf tree material so pushing it out separately.
>
> -jkbs
>

[...]

>  /**
>   * __skb_flow_get_ports - extract the upper layer ports and return them
>   * @skb: sk_buff to extract the ports from
> @@ -1827,6 +1848,8 @@ EXPORT_SYMBOL(flow_keys_basic_dissector);
>
>  static int __init init_default_flow_dissectors(void)
>  {
> +       int err;
> +
>         skb_flow_dissector_init(&flow_keys_dissector,
>                                 flow_keys_dissector_keys,
>                                 ARRAY_SIZE(flow_keys_dissector_keys));
> @@ -1836,7 +1859,11 @@ static int __init init_default_flow_dissectors(void)
>         skb_flow_dissector_init(&flow_keys_basic_dissector,
>                                 flow_keys_basic_dissector_keys,
>                                 ARRAY_SIZE(flow_keys_basic_dissector_keys));
> -       return 0;
> +
> +       err = register_pernet_subsys(&flow_dissector_pernet_ops);
> +
> +       WARN_ON(err);

syzbot simulates memory allocation failures, which can bubble up here,
so this WARN_ON will probably trigger. I wonder if this could be
rewritten so that init fails, when registration fails? What are the
consequences?

> +       return err;
>  }
>
>  core_initcall(init_default_flow_dissectors);
> --
> 2.25.4
>
