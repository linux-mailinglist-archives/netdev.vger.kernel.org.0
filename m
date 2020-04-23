Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46EE1B5CC9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgDWNoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728133AbgDWNoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:44:02 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E39C08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:44:01 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s63so6382735qke.4
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwWrxMzgDrpqUZdYZb5+ZHEhV15ZfAbMzYb+WqtFeWE=;
        b=L6k5CsfjSe3pHsa/+SXmm67z581HMD+UsdbDkVb/v1Q6tAPFika1mgG38g9e9cJWiq
         3XnPRgR0+Qz1eJNuepKX6nMR0DMI7s7WnKjQBML8CFpLWAt/xihJ7JaSuIM7MAbTUlb8
         IedgTohiNauXnRjLQq+NVQgSm+byEOMgmfSGthVDgcpiU7QddcoFury/biHJmVr0t/zS
         B2l/AZXwl+PSEtyFNxnZBVPozQDVogpYol5XdSC+W7Y3JW7Wb/DqfwnWAg7Hi3CUQJqh
         3bFXtvTFj5SLM9RzOgOcDOK3YN18bpItLIdmHYMLy3BGuCNcMlY/RSZrOyD1cbJdWJqn
         1vdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwWrxMzgDrpqUZdYZb5+ZHEhV15ZfAbMzYb+WqtFeWE=;
        b=jVW3KZ1pz2t0n9U4JagcLrtaGWNYkO3vzTluAgkfPrQoZ7fP72bArnvzuqQFSAafOt
         1+w7Rl5ukoZ/qkeYm7RmebImJd/BDzkKjYf0SOMptE/PZkML4cIzw0p/CNmJkoY4ccJj
         khjEkifMXHmexC9o/Lyv0YT9YV7HpZiWE6p8vhivVTwAAm94yVMXS/X9VN6oy+BCVaNu
         pCvAQaTFPaF3TkT2hhc4Tc0hS/1m09UTg3QANKpIFtKVwGzQI8FwrTf1y9Gs1BCFnOHs
         d96xJvqeLBtOn0QptfcBzVyLa9WDaDhV2bx3bhsA2dVPkyviWxPsurVzSPQuALL3mGSN
         DdIg==
X-Gm-Message-State: AGi0PuYrJ3uEb8A8VsQsM87+QG1MX4DuyVMQ2Q2dJ/Nd3wg7VFjlWHtw
        e3YmbCWxdmnnVqJ5UyfFPFljrxdQ
X-Google-Smtp-Source: APiQypLmYHub6eHW+QXsKcRtjQzG4AH20tsrVY10JnsFO6vlDl2ZLxwAVMTTp14XF7bdYVFUSvN0LQ==
X-Received: by 2002:a37:a312:: with SMTP id m18mr1951374qke.251.1587649440670;
        Thu, 23 Apr 2020 06:44:00 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id w10sm1644913qka.19.2020.04.23.06.43.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 06:43:59 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id i16so3154583ybq.9
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:43:59 -0700 (PDT)
X-Received: by 2002:a05:6902:52e:: with SMTP id y14mr6921520ybs.213.1587649438895;
 Thu, 23 Apr 2020 06:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com> <20200423073529.92152-1-cambda@linux.alibaba.com>
In-Reply-To: <20200423073529.92152-1-cambda@linux.alibaba.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 Apr 2020 09:43:21 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf3udp_d13Y8wg-vFsF2vttZ_A5_tE-EDj9z+pfZVCf5g@mail.gmail.com>
Message-ID: <CA+FuTSf3udp_d13Y8wg-vFsF2vttZ_A5_tE-EDj9z+pfZVCf5g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
To:     Cambda Zhu <cambda@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 3:36 AM Cambda Zhu <cambda@linux.alibaba.com> wrote:
>
> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
> option has same behavior as TCP_LINGER2, except the tp->linger2 value
> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
> with CAP_NET_ADMIN.
>
> As a server, different sockets may need different FIN-WAIT timeout and
> in most cases the system default value will be used. The timeout can
> be adjusted by setting TCP_LINGER2 but cannot be greater than the
> system default value. If one socket needs a timeout greater than the
> default, we have to adjust the sysctl which affects all sockets using
> the system default value. And if we want to adjust it for just one
> socket and keep the original value for others, all the other sockets
> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
> set greater tp->linger2 than the default for one socket and keep
> the sysctl_tcp_fin_timeout unchanged.
>
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
>  Changes in v2:
>    - Add int overflow check.
>
>  include/uapi/linux/capability.h |  1 +
>  include/uapi/linux/tcp.h        |  1 +
>  net/ipv4/tcp.c                  | 11 +++++++++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index 272dc69fa080..0e30c9756a04 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
>  /* Allow multicasting */
>  /* Allow read/write of device-specific registers */
>  /* Allow activation of ATM control sockets */
> +/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>
>  #define CAP_NET_ADMIN        12
>
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index f2acb2566333..e21e0ce98ca1 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -128,6 +128,7 @@ enum {
>  #define TCP_CM_INQ             TCP_INQ
>
>  #define TCP_TX_DELAY           37      /* delay outgoing packets by XX usec */
> +#define TCP_FORCE_LINGER2      38      /* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>
>
>  #define TCP_REPAIR_ON          1
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6d87de434377..d8cd1fd66bc1 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>                         tcp_enable_tx_delay();
>                 tp->tcp_tx_delay = val;
>                 break;
> +       case TCP_FORCE_LINGER2:
> +               if (val < 0)
> +                       tp->linger2 = -1;
> +               else if (val > INT_MAX / HZ)
> +                       err = -EINVAL;
> +               else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
> +                        !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +                       tp->linger2 = 0;

Instead of silently falling back to LINGER2 behavior for unprivileged
users, I would fail without privileges, similar to
SO_(SND|RCV)BUFFORCE.

Also, those have capable instead of ns_capable. If there is risk to
system integrity, that is the right choice.

Slight aside, if the original setsockopt had checked optval ==
sizeof(int), we could have added a variant of different size (say,
with an additional flags field), instead of having to create a new
socket option.

> +               else
> +                       tp->linger2 = val * HZ;
> +               break;
>         default:
>                 err = -ENOPROTOOPT;
>                 break;
> --
> 2.16.6
>
