Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C4375A80
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 20:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhEFS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 14:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhEFS55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 14:57:57 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD33C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 11:56:57 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v39so8743069ybd.4
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XaPLAcVRNqEqamHuFZIY1k4QhH5VahftWpq3AXQSxc=;
        b=VeCBeU9WJ8o4NXf5G5a+wTkaHxwn2q0O3ShPEmor661Qc23Xjus6ggzaeQhwacnEo2
         3FI8F63qDUpfdcGneWBdiK3VRquInZo4iw7Np0n4D+zpvQFNXPTqTJ4RvlKx8b3SN1Gf
         WhyGHuAh7f1rkQJT257Ta0+5NMBp8gL7gXlDbI+JoYqOWqFFx229LbMSnTze20fotIyz
         hsxki1imbFuqeLyZeOcN7CLyrsOVXawAmbeSowj+dBb4IT46StdlTMRKAbcqkIJEms5o
         v8vM1eI6ynraxBmRcIELeTX9gC2BgRBivfJX1GiMHs6Tu8d5MUYUCd5DFfnPqQoFCdgt
         euBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XaPLAcVRNqEqamHuFZIY1k4QhH5VahftWpq3AXQSxc=;
        b=pJ+Wg+KhvPVAEiTVoQHBd09meEtavFICTuqVtlAVuswPs3H6HLXSUIHDtUqSislF11
         BrANyKTRQ8N1VFpAhEFGzHrlMd+zqpbcjvDPawqW6oSi529Rt70pZlrdf16i5LwxrSH1
         9iD6cZKWHX4ZfJ5Zjl3QjiEJe9jwEP30dsZth+Q8BADDg7dDiJqNPceQf6z4rvmSWDJw
         MAStcyp0Uwc0Ycu8WTt40M/BwPbwjcDmr2BWiULEsZWFQdV22qqDZ8gxORcGDx7rKkfY
         tOUm9SRj3blkNWeRSDA/n9G6CwDGC/BtTtWxVrtzupx5ocRn/DlN4E2vMgtYOzWrXXmF
         iHPQ==
X-Gm-Message-State: AOAM530a9DIk/znv6h87WYWWzNhcUPHgcv5cU4RjrfjYDZXNX2JHXKxn
        GICAFf0YdGD/nAf8qABjycXRShylbKV5IER02rCZ7VG11WYPOA==
X-Google-Smtp-Source: ABdhPJzMotCsduHXq+IYvUfZSV9dyyxOkMSIp0KEOAL6uPud3M2tSiSkyj1ekmhPOq7NbKoZtlwYdQ5Tqz6koLtKTNo=
X-Received: by 2002:a25:4641:: with SMTP id t62mr8253311yba.253.1620327416425;
 Thu, 06 May 2021 11:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184300.2241623-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210506184300.2241623-1-arjunroy.kdev@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 May 2021 20:56:45 +0200
Message-ID: <CANn89iJD92njqrpzb+uC5-YL8XaLB5jeDmDAwkdMmKK=fvKRmA@mail.gmail.com>
Subject: Re: [net] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 8:43 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> A prior change introduces separate handling for ->msg_control
> depending on whether the pointer is a kernel or user pointer. However,
> it does not update tcp receive zerocopy (which uses a user pointer),
> which can cause faults when the improper mechanism is used.
>
> This patch simply annotates tcp receive zerocopy's use as explicitly
> being a user pointer.
>
> Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")

This Fixes: tag is wrong.

When this commit was merged, tcp_zc_finalize_rx_tstamp() was not yet there.

> Signed-off-by: Arjun Roy <arjunroy@google.com>
> ---
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
