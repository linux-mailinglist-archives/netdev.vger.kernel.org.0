Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ED62DC954
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgLPW7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgLPW7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:59:16 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8518C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 14:58:35 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k10so3843291wmi.3
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 14:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7v5AwOVZcj2xn/8FpSsfWcwsdChDLj3h3yTKyI5ZhSs=;
        b=Q6fAZlqb1SPims0Tgl1Be5PcT47GMTfmmV8P7lJwomadI3kj8sDq7BiW4EC+QRHVli
         KwtM5eRWJlMB3SNQyCOnGZ1FCPOeA7rQ/zqP41CvmoZzd3ZPYYQgGoOQsQkabFGu18QJ
         xjRxlzNSiaao/d4CXuxMljS2/4m3E3Wgmmd8k0XzxmiCc9411+cdRtlRgMfIROrdlCGH
         Jk56W373Yfz9zXlT9hEu31lrsl6ou+3u1hKxun62YNE0a2iH5ETPwE79UGzcEr1xv+Jg
         wpMcLsjFiglkiP1c3PeSg6dKeu5SB8D+HZLx13Q3Q2zmehGdg2EW+MyuKfV9wo8uFls7
         CKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7v5AwOVZcj2xn/8FpSsfWcwsdChDLj3h3yTKyI5ZhSs=;
        b=iQ/LrwRlVVbte1/PZZt8tm86NzSISJPh5vVXP+xEPwNEMfRcm4wBjxpzMX1Txgjwhi
         79F4FQeh7KtNcglMjQd1lFujOcMB8Fk6knqZvSQcFgv2I8zwWZUgGj7QKsaXxEeTBKvR
         ELWR8mB65fvXtEkHRQO641mzYKuLdWiJFOIxZyCwNad5ZXs6XnuAGa/eXGSxkMB8vYXn
         e1cTYFmdgYgADLG45C7ewWT+PWbTeVkY3dtq3Mjz6euaMUK9eRlwjalIwTECc395DaJq
         /rczMZDhFwd8AM2EfXpXuqg0llRYm09wAN647vU8t0pXpywSOIgMfyJjozO6RnLP34Cg
         Ttdw==
X-Gm-Message-State: AOAM5322mM1zVGXqF39+dphLMz6s4nCtEa6gpHBgboMmJ2elEA/AYALa
        Ie/tW8UlNSygxWGvgVhhPut9E2L7lmfI7FBznIcFZg==
X-Google-Smtp-Source: ABdhPJyDPlhEVLuDGBArPsVLQhxHlkO3wxnbqJSmPRQRmUFUyUDk4Rrpf8/LONqYv9rkngEjbnZ3PzieC9ZCqF4ySV0=
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr5538251wme.3.1608159514142;
 Wed, 16 Dec 2020 14:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20201216225648.48037-1-v@nametag.social>
In-Reply-To: <20201216225648.48037-1-v@nametag.social>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 16 Dec 2020 17:57:58 -0500
Message-ID: <CACSApvYqn9gWTfFhQUkyTip+jk++Wtg46cwGaV0ViEVC7ZU8GQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 5:56 PM Victor Stewart <v@nametag.social> wrote:
>
> This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.
>
> GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
> throughput gain than io_uring alone (rate of data transit
> considering), thus io_uring is presently the lesser performance choice.
>
> RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
> GSO is about +~63% and GRO +~82%.
>
> this patch closes that loophole.
>
> Signed-off-by: Victor Stewart <v@nametag.social>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks for adding this! I audied the code and couldn't find an
escalation path.  +Jann could you please double check?

> ---
>  net/ipv4/af_inet.c  | 1 +
>  net/ipv6/af_inet6.c | 1 +
>  net/socket.c        | 8 +++++---
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index b7260c8cef2e..c9fd5e7cfd6e 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1052,6 +1052,7 @@ EXPORT_SYMBOL(inet_stream_ops);
>
>  const struct proto_ops inet_dgram_ops = {
>         .family            = PF_INET,
> +       .flags             = PROTO_CMSG_DATA_ONLY,
>         .owner             = THIS_MODULE,
>         .release           = inet_release,
>         .bind              = inet_bind,
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index e648fbebb167..560f45009d06 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {
>
>  const struct proto_ops inet6_dgram_ops = {
>         .family            = PF_INET6,
> +       .flags             = PROTO_CMSG_DATA_ONLY,
>         .owner             = THIS_MODULE,
>         .release           = inet6_release,
>         .bind              = inet6_bind,
> diff --git a/net/socket.c b/net/socket.c
> index 6e6cccc2104f..6995835d6355 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>  long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
>                         unsigned int flags)
>  {
> -       /* disallow ancillary data requests from this path */
> -       if (msg->msg_control || msg->msg_controllen)
> -               return -EINVAL;
> +       if (msg->msg_control || msg->msg_controllen) {
> +               /* disallow ancillary data reqs unless cmsg is plain data */
> +               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
> +                       return -EINVAL;
> +       }
>
>         return ____sys_sendmsg(sock, msg, flags, NULL, 0);
>  }
> --
> 2.26.2
>
