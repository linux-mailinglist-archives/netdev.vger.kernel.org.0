Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83B2BB55E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbgKTT3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgKTT3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 14:29:02 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDC0C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 11:29:01 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so8128808pgi.8
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 11:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGVz0R/T1Lcs/3vq3F+rCzHA/DxqPpBDBKnQ1sOrw+s=;
        b=PRo5G/hNRJUpU/cc7tjVIhWxFiYmd6cfhTfyxf7rQtbGmUS5NSOxq2EoI/BpaU/lBj
         BaQFSR087JdXzSi6h5sob21c3pEnU4UzmH5JZp+lWQVatLGVZm78/1V7yQfmtZgvmAlf
         sDRBL/CuXwwhDY455kDfYb/xJuFg7z6bbvF8shZvkb6B4gX1fZUNzd3nSOzzUXOVdxzT
         f1ZqsLkivEnlKVocHUySBXPmur4FNhXasRywE5dqva0ROiWzJwLtgSIzSNZKGdGeNLdM
         hFnaGUCYVczfJUXL1ln5ZJb+GWE6AlGac6seKYmURtq4epzlDQ6Q89ha3JRFpOsd34km
         KYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGVz0R/T1Lcs/3vq3F+rCzHA/DxqPpBDBKnQ1sOrw+s=;
        b=i5HZeDfOiMe7THvts1VksUFiJVVcypYzNKX2kaeXUtvHHKg1v5aC9fNg1WU8+dEA7j
         nNQhrB6sF3SH8/tsipNNLZZPDVx3EUBGUUp5MGSZENQbpXqiK+La6yNyf3wcGGLb9kRK
         RWKx+dq4CtAaOkkpV2uTOHc2uEfiT4HaZYtOsLxDV1iulN+xTxnDgmgvi7ly/RX9bSDd
         Nxz8v7w1ZVJp0RXiYJYbTITIvvFE6q6px8lfJfCjAHUXTjdOkq+70uEXBuUKOS+CpyJp
         oGVwX7UgMG0RsFO6fq1r22BVw5RmDTz+dqS2UGEM7BYA9zbMhdXTOl3SLcGjqJIs9b9b
         O36w==
X-Gm-Message-State: AOAM531p2AcRTq9dITl3/Pp8Pm/NiM0Wt0FI3pdST/PgJ9MxGzvH3hQv
        +xJO3l6C6rfAdl8PZZZrvFLaPANakU6VCCPHDB0=
X-Google-Smtp-Source: ABdhPJxiATZjifZsGBrBMLkmwkw1mzK5a3ZUxzEz7krdI5jhp7Xb+DYw3CJ259tDqrJQdxgD7GrIrXLIE6EQDytZUBc=
X-Received: by 2002:a63:348:: with SMTP id 69mr18367532pgd.336.1605900540911;
 Fri, 20 Nov 2020 11:29:00 -0800 (PST)
MIME-Version: 1.0
References: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 20 Nov 2020 11:28:49 -0800
Message-ID: <CAM_iQpV1Lyw4yNUEof1kERA1vWLediDGAsfHf_UVxuS2HMNHYg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: fix over mtu packet of defrag in
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 3:39 PM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
>
> The first patch fix miss init the qdisc_skb_cb->mru
> The send one refactor the hanle of xmit in act_mirred and prepare for the
> third one
> The last one add implict packet fragment support to fix the over mtu for
> defrag in act_ct.

Overall it looks much better to me now, so:

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks!
