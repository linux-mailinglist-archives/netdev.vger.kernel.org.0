Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BE42FC33B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbhASWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbhASWSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:18:38 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C998C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 14:17:58 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p72so18185177iod.12
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 14:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvx1Iqewl7I6+usGz3fNKExxH5ZznQm049noR3pWrk0=;
        b=jRyXrwkwtn9/E5omgEKt1dOUAPxvaxuHITCN72zGi/j8pSzqSlPnbNjBwS7aMk/iiu
         S3fF/t8tGwcBai9gudrO8KNvVdlwXj3FeRGsd2rhYaWPXyUNNLtYGajg+IRvkaYKgdcF
         MWznCRCJw/sMh5f50kTcIRilpoLl++6LE1w2BWEuUU831Yzyhei9Blb50+BXkdLkca39
         ufcsWU7a3N/ploNUsWeTxJhnN8w7g22WQaK2lSCzX/VAco0DaUgZz5Ndpi5Pq1xyX2wG
         qcw94lXYYaSw3Sb29G8a4zXddqKioiOIbdvrQP3G0ofqrC0Sv97L6jK1p31KzoLdEeBO
         jjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvx1Iqewl7I6+usGz3fNKExxH5ZznQm049noR3pWrk0=;
        b=CbjCIqUeNgUlNaO0CQEsdGp3Nm1l9t8vSLeKD8lwHWsj8ssNoa83S72I3VzOHDAqfw
         OPfUbWD6qi+c3kCiXxBvBWBkQ0UC/yuUE61P/BvLkHMYxJ9SLGRV/lQcM+XIxlz9evBY
         PZSPFq8ZvuIXlZsaLPszUjKvnIaxMgFXidpXHSuP2bnL+flq+7kUrXebgIdcFDAVpg47
         pI8Ba443aeU/eorPfJFci3PjYHn/Qg6DiSbwsMJYvU3i2C35Hph7UpubpCLWgmWuHapt
         6FzNTrZnGugEyID94VYFvfRWcaQtB35WDJAvqgNm1akdmHSK1Qtowju0aizHSyZD0wZQ
         GbEQ==
X-Gm-Message-State: AOAM533SGnml4hVUfR1rFCsg3WgtkpS+Zs0QEa08IJAhmDFpk0Fjtezl
        8vqgEleQyi/mZYr1rqQVoII6ojggZL4i4OgSZ+A=
X-Google-Smtp-Source: ABdhPJxJNuuS13H0qCHRq/cMDHCnKlMsRGl+ebRA8MLwAWDg2xhJfavK0E06j3f3m7AW5XuU/iYXxE9R9NAj+H0QysQ=
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr5221517jaj.87.1611094677740;
 Tue, 19 Jan 2021 14:17:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610771509.git.lucien.xin@gmail.com> <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
In-Reply-To: <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:17:46 -0800
Message-ID: <CAKgT0Ud+mjksk1HWpLUSWziGUq9ZQLO33GiVHQtJhoCOpM0zUQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 8:34 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> When enabling encap for a ipv6 socket without udp_encap_needed_key
> increased, UDP GRO won't work for v4 mapped v6 address packets as
> sk will be NULL in udp4_gro_receive().
>
> This patch is to enable it by increasing udp_encap_needed_key for
> v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> decrease udp_encap_needed_key in udpv6_destroy_sock().
>
> v1->v2:
>   - add udp_encap_disable() and export it.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/udp.h        | 1 +
>  include/net/udp_tunnel.h | 3 +--
>  net/ipv4/udp.c           | 6 ++++++
>  net/ipv6/udp.c           | 4 +++-
>  4 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 877832b..1e7b6cd 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -467,6 +467,7 @@ void udp_init(void);
>
>  DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
>  void udp_encap_enable(void);
> +void udp_encap_disable(void);
>  #if IS_ENABLED(CONFIG_IPV6)
>  DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
>  void udpv6_encap_enable(void);
> diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
> index 282d10e..afc7ce7 100644
> --- a/include/net/udp_tunnel.h
> +++ b/include/net/udp_tunnel.h
> @@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
>  #if IS_ENABLED(CONFIG_IPV6)
>         if (sock->sk->sk_family == PF_INET6)
>                 ipv6_stub->udpv6_encap_enable();
> -       else
>  #endif
> -               udp_encap_enable();
> +       udp_encap_enable();
>  }
>
>  #define UDP_TUNNEL_NIC_MAX_TABLES      4
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 7103b0a..28bfe60 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -596,6 +596,12 @@ void udp_encap_enable(void)
>  }
>  EXPORT_SYMBOL(udp_encap_enable);
>
> +void udp_encap_disable(void)
> +{
> +       static_branch_dec(&udp_encap_needed_key);
> +}
> +EXPORT_SYMBOL(udp_encap_disable);
> +
>  /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
>   * through error handlers in encapsulations looking for a match.
>   */

So this seems unbalanced to me. We are adding/modifying one spot where
we are calling the enable function, but the other callers don't call
the disable function? Specifically I am curious about how to deal with
the rxrpc_open_socket usage.

If we don't balance out all the callers I am not sure adding the
udp_encap_disable makes much sense.

> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index b9f3dfd..d754292 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
>                         if (encap_destroy)
>                                 encap_destroy(sk);
>                 }
> -               if (up->encap_enabled)
> +               if (up->encap_enabled) {
>                         static_branch_dec(&udpv6_encap_needed_key);
> +                       udp_encap_disable();
> +               }
>         }
>
>         inet6_destroy_sock(sk);
> --
> 2.1.0
>
