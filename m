Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E4375B90
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 21:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhEFTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 15:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbhEFTSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 15:18:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB7CC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 12:17:45 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v39so8824489ybd.4
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 12:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QclDf77LIiW0upUXkpsT86hXbxWCopYW5TwaC6su47Y=;
        b=GOb9kZs73uaPsp33dduSI8yYEhhAtY7k25WlDCzCv0BQjSh3Howvq/dBH7Ue/FibeT
         JkSYdNbOmcSNz49iGQa8zL9HQ8nfJUnWEOUDEei32EgzjaUP45Lik9aoMs1Mm8n9B1sQ
         XS6+QjhkJit8tTKc5ZsYwa6wymdrZgPN4wqLd9F1Z1u8yjoN3m0INYMMUjGfQ4J1eOqM
         nULe8I2+icxxQhZ/IRP40mA6GXpKixujg1efqUgqal2r4GOgkebPn2Cqkkixsh0RgXR7
         lsiHGqSeB9ZEiG2H5htPdQ8UCuB+lFRTsg2nCP3iq0NDHOtKEHqU96ftjz5OwfADzjlF
         hdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QclDf77LIiW0upUXkpsT86hXbxWCopYW5TwaC6su47Y=;
        b=Qjlu2mT/TroJEbEZlqY8/jtC2N1OMqCsFmbZS4lU4oFmbmQ3YV4X58tfW98kPpNA8S
         1GW/a/xP97bW/xDjCeOsciQ1u2SyItVOpuCdPpbUi4/XLzZWidgVa1+BAqMYW1EOeWmQ
         kzjrZFqDi0F0I0ElSvlX/zORfG5n5VZgkVeVSafq2iMmTCnqM7GWZvEJKkN5sQoSzLVV
         LGoLlkRuNNNdRDGdpg/fBVhE7i3eU1ux6NHjL3muqOpvFWV/AK/Xxmv/imKzBDvUOGpU
         nsVMohAuKIsYhFtm8DkdFOabyxOOV4v8vf1Vq/bFn+071tZB3y3til6c13y8zIJuxQ3I
         dzDg==
X-Gm-Message-State: AOAM532bVFgm2I79flACK35/jY1yW2D5TbsS/ohcbRb34TQMRUov96Nd
        WenPPi7FJfi7JrmzssJCfRuNnqrJ++/SM5nPOFIemQp+IMc=
X-Google-Smtp-Source: ABdhPJwgRjnkSawzCUC8Vbp72YYeApLRPYNhomRMCiQv+tKKqqwKIpeC2mIIsX91hcMF+1GEktUSJZLPE0jLTi1WnIc=
X-Received: by 2002:a05:6902:1001:: with SMTP id w1mr2947193ybt.234.1620328664341;
 Thu, 06 May 2021 12:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210506190617.2252059-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210506190617.2252059-1-arjunroy.kdev@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 May 2021 21:17:32 +0200
Message-ID: <CANn89iJeEKGDeOSz2OuZ4feZBFWf5A20Ab3gQ9q5VshRzSzZnA@mail.gmail.com>
Subject: Re: [net v2] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 9:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> A prior change (1f466e1f15cf) introduces separate handling for
> ->msg_control depending on whether the pointer is a kernel or user
> pointer. However, while tcp receive zerocopy is using this field, it
> is not properly annotating that the buffer in this case is a user
> pointer. This can cause faults when the improper mechanism is used
> within put_cmsg().
>
> This patch simply annotates tcp receive zerocopy's use as explicitly
> being a user pointer.
>
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>


> ---
>
> Changelog since v1:
> - Updated "Fixes" tag and commit message to properly account for which
>   commit introduced buggy behaviour.
>
>  net/ipv4/tcp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e14fd0c50c10..f1c1f9e3de72 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2039,6 +2039,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
>                 (__kernel_size_t)zc->msg_controllen;
>         cmsg_dummy.msg_flags = in_compat_syscall()
>                 ? MSG_CMSG_COMPAT : 0;
> +       cmsg_dummy.msg_control_is_user = true;
>         zc->msg_flags = 0;
>         if (zc->msg_control == msg_control_addr &&
>             zc->msg_controllen == cmsg_dummy.msg_controllen) {
> --
> 2.31.1.607.g51e8a6a459-goog
>
