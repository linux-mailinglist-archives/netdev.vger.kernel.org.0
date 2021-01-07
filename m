Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FAB2ECA25
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 06:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbhAGF21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 00:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGF21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 00:28:27 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE29C0612F3
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 21:27:46 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id h18so2966369vsg.8
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 21:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PCJwX11gyPnuprZjD+B9baQ/pN4ms+t3YfRkrLiAMSc=;
        b=Q6RaVI8N96g3cCIOW0G1tCFUksGhqYBPKK/+zpatZvMjK04IPV7McHTrkOFXTLZLrw
         1CmWe7NbA/B32jeZtXLLmQfO3UuQPcSpJMEclm4rObNDlmUi9faTWveux7rfPuYxSEoC
         JF2VLXhAhs9vHPee8YZYZAk7zYKYePu4wqXDVKEtUMUfhYaSDB8CZluzQOwIQr900Au4
         Q7LkhPwxZx5tedM9+fkkl+YZ5XrKVtPlOxwhV36hm+0uv2KJa3XIDgXrefY6RcPygVvZ
         6UNU3Tb9lYNmkMBf/MgjbkT/NFRAj0A0rJVwd19KqQ2+XQmDOl+FRjmJSsBbvOONSSNk
         vp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PCJwX11gyPnuprZjD+B9baQ/pN4ms+t3YfRkrLiAMSc=;
        b=NTTFnTaA0goH+r9yE7WJN+iVUrqMw4QGylSblhSl7Tssnt6t1Ei4fBZygzaAhIcXNA
         /51KuW5fCEryQjtqtPc615EW2BoHb4EvOs8Povp3nkgciuLCYLaJ0MvtCUleFdEYY6SA
         vK52bXCj6iXp1+SdwEdUOciN3czBtk5D+aUT8N1bDvTqLH3Wjbyg4SmrouvEaCgiK+FY
         crtI8GO/DUutS/2PHqEuTifEl7umRpn7/B6UBSwCZNZYAUbyAlFoASjuNioOTnMcM185
         rFGt9rqtSJXK+7FjeEruqDBD6i8baALp2mGHftEiLC9o7MUshRhGC/+DKV9n+Syw1aGf
         +FNw==
X-Gm-Message-State: AOAM532VM7iGzxLLx5qschRD/IYvAhE+srcxkYKhoyvxx0wKsqK7WFtl
        RY4ErRvYq70GxC76nWiR89b04cF6zDw=
X-Google-Smtp-Source: ABdhPJwW2j+ZiGBofNC0VyIAOskd+f+K1xP78RN8qj31pSYV2pQ1CZqQEqaTzVUPlAds3uo0vb1hbg==
X-Received: by 2002:a05:6102:d1:: with SMTP id u17mr5805154vsp.8.1609997265336;
        Wed, 06 Jan 2021 21:27:45 -0800 (PST)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id j8sm690777uan.20.2021.01.06.21.27.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 21:27:44 -0800 (PST)
Received: by mail-vk1-f180.google.com with SMTP id l187so1354660vki.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 21:27:44 -0800 (PST)
X-Received: by 2002:a1f:ec47:: with SMTP id k68mr6106309vkh.12.1609997264046;
 Wed, 06 Jan 2021 21:27:44 -0800 (PST)
MIME-Version: 1.0
References: <20210107051110.12247-1-baptiste.lepers@gmail.com>
In-Reply-To: <20210107051110.12247-1-baptiste.lepers@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Jan 2021 00:27:07 -0500
X-Gmail-Original-Message-ID: <CA+FuTScp=7nrd5vmAwoAdL-moX37Kx38a-QjqoWh-k1xxyJwMg@mail.gmail.com>
Message-ID: <CA+FuTScp=7nrd5vmAwoAdL-moX37Kx38a-QjqoWh-k1xxyJwMg@mail.gmail.com>
Subject: Re: [PATCH] udp: Prevent reuseport_select_sock from reading
 uninitialized socks
To:     Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 12:11 AM Baptiste Lepers
<baptiste.lepers@gmail.com> wrote:
>
> reuse->socks[] is modified concurrently by reuseport_add_sock. To
> prevent reading values that have not been fully initialized, only read
> the array up until the last known safe index instead of incorrectly
> re-reading the last index of the array.
>
> Fixes: acdcecc61285f ("udp: correct reuseport selection with connected
> sockets")
> Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks. This also matches local variable socks as used to calculate i
and j with reciprocal_scale immediately above.

Please mark fixes [PATCH net] in the future.

> ---
>  net/core/sock_reuseport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index bbdd3c7b6cb5..b065f0a103ed 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -293,7 +293,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
>                         i = j = reciprocal_scale(hash, socks);
>                         while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
>                                 i++;
> -                               if (i >= reuse->num_socks)
> +                               if (i >= socks)
>                                         i = 0;
>                                 if (i == j)
>                                         goto out;
> --
> 2.17.1
>
