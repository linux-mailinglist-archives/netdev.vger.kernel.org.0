Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DBA2FC344
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbhASWWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbhASWWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:22:11 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F97C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 14:21:31 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d81so27778393iof.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 14:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uE2hgrxgMNBU9P3ntIU5moEuh76TpvAwMA5GP/s+yfM=;
        b=jCphf/QI6H78a5Bv9W393qT7IYk/sXBSqtUWS3pQrZL/sgxStDn9ICP3KjlfR1q8hH
         nUN2p6GeJQ0A6M+jEAAwkdnyRG2n7sHrwcVUrK8R2i6P+Dqh5aNMyBKF9fcbsXdcI1ki
         TOJs03ys8MDFQTjpwUktEx4OEC9kqkMDW2P8dDD7CKV0GNvrpyh5GXVa5qEsuCfe13Un
         qRPIEyt1OekC7t5R0a8pr3hD5/sCxaSSfjeMCTjeIgrX/zvRzJ2O9r+yvyVY1rT+hPXX
         XKa2s8F/VEAwWs44s2XqErcX+O8Zt3A6XGEtUGs/Pzn1i8lEyb1CKQLKoO2zXIhLhfwh
         DjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uE2hgrxgMNBU9P3ntIU5moEuh76TpvAwMA5GP/s+yfM=;
        b=HJtQoZaFYCbQUuNws7DUrQCqnhO7GxeB70TsrUoMi9858kKUf6AXT5RJIV8L7WwwUl
         G27f2lbFMsay77+9wSwZcQwRpCWf3f1fbXM8tzeHwQfkjb7luBC3D1SlTo71l8aCCqBm
         AJ+dKPqYlCBKdEnwnxaFod5cqOe7XsgShFHr++A/+RSEmeEFXVz7BggJtLWsReLwyXiG
         NhlDBgJ0auTN1J6f2Dyx2keQjECuFuwcfYTPnORU3SoaH071VAOYCU5guP6sE/xLch8e
         s4e+v3LFn4EcFzJmNVKbmhKyA4iBuod6DA4zdInBbxaj1asO2VUDKgkkacVs2HVSQads
         eQ3w==
X-Gm-Message-State: AOAM530awo27tK1EtPKIWlBlB1A52tEUvkksXnAM3tWPh38Pni3+saXo
        WHQXqMdZUQFFnvC1LXUgR7ugcfUHjVOEeRk/qJU=
X-Google-Smtp-Source: ABdhPJxGTZIyFSsYTD/VUSu42LiOg5cEYlXaAdLD8ZyiRyyBqFQr8OxqaSzEfHtxDMOxDx6KpFrvCqkf5TWnEKiy0P8=
X-Received: by 2002:a02:b38f:: with SMTP id p15mr5339353jan.83.1611094890482;
 Tue, 19 Jan 2021 14:21:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610771509.git.lucien.xin@gmail.com> <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
 <ef2fdd7f2f102663461e8630ad1aad74bb1219a0.1610771509.git.lucien.xin@gmail.com>
In-Reply-To: <ef2fdd7f2f102663461e8630ad1aad74bb1219a0.1610771509.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:21:19 -0800
Message-ID: <CAKgT0UcpvC8DJBT=Bi=7jp+Kvb1_XpiFWsNtxDb7ouG1K+8c8Q@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 2/2] Revert "bareudp: Fixed bareudp receive handling"
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

On Fri, Jan 15, 2021 at 8:35 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> As udp_encap_enable() is already called in udp_tunnel_encap_enable()
> since the last patch, and we don't need it any more. So remove it by
> reverting commit 81f954a44567567c7d74a97b1db78fb43afc253d.
>
> v1->v2:
>  - no change.
> v2->v3:
>  - add the missing signoff.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

It might make more sense to just roll this into the first patch since
what this is effectively doing is removing a spot that was invoking
the enable without adding the disable.

> ---
>  drivers/net/bareudp.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 0965d13..57dfaf4 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
>         tunnel_cfg.encap_destroy = NULL;
>         setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
>
> -       /* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
> -        * socket type is v6 an explicit call to udp_encap_enable is needed.
> -        */
> -       if (sock->sk->sk_family == AF_INET6)
> -               udp_encap_enable();
> -
>         rcu_assign_pointer(bareudp->sock, sock);
>         return 0;
>  }
> --
> 2.1.0
>
