Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05BF4D8F30
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiCNWCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245425AbiCNWCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:02:22 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C63C48F;
        Mon, 14 Mar 2022 15:01:11 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id o5so4745858ybe.2;
        Mon, 14 Mar 2022 15:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDQp0elUbEb3l2ztp8B9W0hhZAwxOZgBnkRa+RhHUnU=;
        b=WvHe4lvu9eMeiGDQrTW+QFd0atSq6h7tPADdOTemrhvtyF8fR44hONCUmP0BXcMICq
         JD3TdX9CequRTw9vJXkuES8i5Gko+9m6uEF/P0SfS+6vGijN1MQDhGVutZ81RLJAQS2S
         uTSibi6jnSh+A8VH9wDeT9A4EtrE+iqiTaHdH9mEXKFPyMQ7B8N6QQLS4hz8Egcl9AO+
         U46H8gbP8konmPKMj6reDwTQbs50B8ykWJEDaT/WLGDYDVzZhJRxl9mZp+zDSapC/lZZ
         cJhnrPLQEUA0wJhh3vfgUOYJaP3mJ3T/KUZmlR+tni99BAty+93dOAESeaaejKEbG6KE
         UU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDQp0elUbEb3l2ztp8B9W0hhZAwxOZgBnkRa+RhHUnU=;
        b=HicE5R3XrpaO6TncjgeGxicCpgGIxZtAvj1Iwg9ePt0fzbCpTckId38OTwevc256rA
         pE5KU/ujewY4Nf4smBwOrUpVCE8RYiZOo1HovOXu9j1NRQDOFnsunD/j69v/oxRLU7Ii
         clNCQGao454S7Sh/CpAhYov7HWtJzted8zk0mzMmJ6viZlsmzdnZu5+hlitXyzQdddLk
         jduDMrJhh2UkgadNZYOhnA2xerzmiZSajPGU2dw30NC6fAc6C2+sVNEF6+UxwiOlMGdb
         uyWiRCfF/OYGysWW4LhJ1JLNBBS+x0T8ycy4NtfoUUNdmSkuNwZkSwDS2uyFoV1qvo8i
         STQQ==
X-Gm-Message-State: AOAM533BrIHoFH/U2HCH9dtqR8Hm2CXfclg0TFIQx3tZXjAfpoLbzCsi
        gGAji7LqJNo+znrqX26e8mXuZ0vuQN0Z2ULYvhOITELI
X-Google-Smtp-Source: ABdhPJyje4eQsiO8dt4q7jDAtFimCxHJPbizI7qD7bwtkI9WgWPNi408Kg2S6oHIMFc3vrtLGm9QkspOr98knrLIUO0=
X-Received: by 2002:a25:a467:0:b0:61e:1b4a:7700 with SMTP id
 f94-20020a25a467000000b0061e1b4a7700mr19985076ybi.390.1647295270388; Mon, 14
 Mar 2022 15:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <e2c2fe36c226529c99595370003d3cb1b7133c47.1646252285.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e2c2fe36c226529c99595370003d3cb1b7133c47.1646252285.git.christophe.jaillet@wanadoo.fr>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 14 Mar 2022 15:00:59 -0700
Message-ID: <CABBYNZ+uNjszAf9jYL4iu+HxjrktnQL2FeQfdDRnFfNNnmw07g@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Don't assign twice the same value
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Wed, Mar 2, 2022 at 12:18 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> data.pid is set twice with the same value. Remove one of these redundant
> calls.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/bluetooth/l2cap_core.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index e817ff0607a0..0d460cb7f965 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1443,7 +1443,6 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
>         data.pdu.scid[0]     = cpu_to_le16(chan->scid);
>
>         chan->ident = l2cap_get_ident(conn);
> -       data.pid = chan->ops->get_peer_pid(chan);
>
>         data.count = 1;
>         data.chan = chan;
> --
> 2.32.0
>
Applied, thanks.

-- 
Luiz Augusto von Dentz
