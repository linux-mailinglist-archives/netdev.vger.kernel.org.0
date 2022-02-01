Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0914A5468
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 02:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiBABCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 20:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiBABCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 20:02:41 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9DDC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 17:02:41 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id l14so14171057vsm.3
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 17:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SgW67zLdI+ArFbkc+Dwq2CSegtmiEhFDa0GImr29m0I=;
        b=JDv/q1z0VEzJwOkdlichCviK6YPB/k7fVYNeuUieTx73Ug9ovi6Zpj99Ki3y6tFbjC
         5uRyvCtMY1FrdsI+GpzIKHHvuRhf+wifQMW/Jyhnhxh3Of+kTBvDC4sroD31nG91MJ8V
         VFjOvuiv4Aa5sn6USeLfEOz+QCnX94CjKv4+nV+b4U9cdYoCYjqAQrvnp60tbLQTJWSw
         bGQrEahROaAQ0BYO/Uf4N0e1yIHAZodNL70Vz3uDyRDdB6wD5XuylvLL6hS56GAryhvS
         7mxNqSfAiXLP0BAYwSuufauzvMMt/R/CrIWDeDFpcsqDdcCWoOTBgT0zTVsnqhG931wS
         DXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SgW67zLdI+ArFbkc+Dwq2CSegtmiEhFDa0GImr29m0I=;
        b=UMICOs4OIhDpklz7LHgv+XEkHnzSYR+kwnwY9Lt0dbjL9pPjOGRewWcTFt1Ih1a7zm
         2cvfT0liYdQgA5rsK3xHK/Itb73M+evoXx97Go1af1wuYWb99ijPcu5TNyuC2+/2JW6+
         zXIcoJFeI/tfhPPcpAlRxYSAn8Z+qPrHHa2cOGg/w4PStHd3IbT3dUdyZuL2m3MqG111
         sLZOFNgV0RaTDaZ5HcwH1qM6chSomCN4LQRI9k9V38nQgGFzG7fQsBez9VnEnI/gGVy4
         R4glE9SdO4oEFCHQW+xzedynQkdOVqdKMr/O3BP0dnbXxUKxs0UyW8fUEUZC97iguizp
         Zk3A==
X-Gm-Message-State: AOAM530zrMarrc75FPlCr2PbLBub/dOL9HKkpFiPVGSqfetq1qQDLve9
        Yd3h26JR3Ti4sCr518Hki3Ij95LCJ8ey8minbAY7125qiC4=
X-Google-Smtp-Source: ABdhPJx476IeV1wvouRIkN1hKx6Xr8k1imapPQdw4vPvOydBt+ZPMSxaIUqokVdy2gks36qrRlETRnXuRLIMsiZYwAQ=
X-Received: by 2002:a67:d58b:: with SMTP id m11mr9480412vsj.46.1643677359892;
 Mon, 31 Jan 2022 17:02:39 -0800 (PST)
MIME-Version: 1.0
References: <20220131233357.52964-1-kuba@kernel.org>
In-Reply-To: <20220131233357.52964-1-kuba@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 31 Jan 2022 17:02:28 -0800
Message-ID: <CANP3RGccBMhWo_P2c802TWZBAW-+cjrMLho2LzUjXwOdMs8FXg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: allow SO_MARK with CAP_NET_RAW via cmsg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> There's not reason SO_MARK would be allowed via setsockopt()
> and not via cmsg, let's keep the two consistent. See
> commit 079925cce1d0 ("net: allow SO_MARK with CAP_NET_RAW")
> for justification why NET_RAW -> SO_MARK is safe.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: maze@google.com
> ---
>  net/core/sock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index d6804685f17f..09d31a7dc68f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2625,7 +2625,8 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr=
 *msg, struct cmsghdr *cmsg,
>
>         switch (cmsg->cmsg_type) {
>         case SO_MARK:
> -               if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +               if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
> +                   !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>                         return -EPERM;
>                 if (cmsg->cmsg_len !=3D CMSG_LEN(sizeof(u32)))
>                         return -EINVAL;
> --
> 2.34.1

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>

I thought I'd sent this out already... interesting must have forgotten.
