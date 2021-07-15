Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547CC3C96A3
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 05:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhGODvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 23:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhGODvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 23:51:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78407C06175F;
        Wed, 14 Jul 2021 20:48:51 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y4so3851187pfi.9;
        Wed, 14 Jul 2021 20:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x7mKC/lKfardBNYxSwnq2vv33vPUAvQA2chA6+76XEQ=;
        b=O4/OqJzy1bq370gDmTetx4n+OvioXMR3KvJdiHtDUh++/NN3p+IwDlyrIHNfG260K3
         YRGxCx6qHEB/hCeh6UVi6n2dI/BzN6/T87QcG5l44QH0UHYkwkovt8UpFZl2lIKHf/fX
         UcDws10V9EDZTHpa7psppoCjmPnsx7RxIMh8uM/0kq9wzgXDQ34oLIlc263x3ceuYAjL
         SQnlbzTJ4EGeT/nqSfVIW25ZtQbT7zPShZpYsu7uTV2A4Tv3ECxlqdfDA/F+dCws1ilj
         3IIjvJ4M5UkczqRANyvLp8M6H7Te6+NjupQ0jNr+Hyr5P4nCRHqsU5wlY9SAhYquFESh
         J4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x7mKC/lKfardBNYxSwnq2vv33vPUAvQA2chA6+76XEQ=;
        b=bNGAj7yzVID7e+Ct9eAwM1U1nEJbb0rWE0JRbzZE7E6NiWoMflTSgL7pkA3SFJYYCq
         ldwLFGPn4g1cvS9n8gFxSuCcMVdo6/s33XofY45H0HTwJxSVq5kjUz7dCCK2xp/AJH3O
         BLblUImeugCTIauyvrjStrfYD8ia2r6GXNxhjWSoDR3YviBtuwip/lf6eYWltr9DTbjk
         wGGICI7FMV/dmYrIZ80HyvCtcWbA81QAnIE+AzC7Zb7nyI0sVs4Nhl0fU1h0jY3/TRr9
         Ha1vQaoj8P5tuV+o7HMS1ldq22PvvSg8LiGwXhDWUJnX01fglLhTqEND2NIoapsYcLO4
         fpMg==
X-Gm-Message-State: AOAM531TjujqmJAUwI9/INbEds/iVw8BYdmcR13z31c/WF956bfbHGCp
        LNv2gHBkE8Cf4tKI5092DxJjM4FNibCBrGMHm8k=
X-Google-Smtp-Source: ABdhPJwr03NG2N6gqvpdOCjDsSFo9+V/VZgdVCKT5j4B3U5o+aKk62eKtlYIgQnTSAG0sIKby3tCfTi4/ux4f0F6UJE=
X-Received: by 2002:a05:6a00:26e5:b029:330:be3:cacd with SMTP id
 p37-20020a056a0026e5b02903300be3cacdmr2027563pfw.78.1626320930947; Wed, 14
 Jul 2021 20:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210714154750.528206-1-jakub@cloudflare.com>
In-Reply-To: <20210714154750.528206-1-jakub@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Jul 2021 20:48:40 -0700
Message-ID: <CAM_iQpWuFMyukcjkQ8aJ8mhCnCq45Kr9JC05dHD014QnFNxRTQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf, sockmap, udp: sk_prot needs inuse_idx set for
 proc stats
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 8:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> To get the correct inuse_idx value move the core_initcall that initializes
> the udp proto handlers to late_initcall. This way it is initialized after
> UDP has the chance to assign the inuse_idx value from the register protocol
> handler.
>
> Fixes: edc6741cc660 ("bpf: Add sockmap hooks for UDP sockets")
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks for the update!
