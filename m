Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0E32CA83
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 03:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhCDCmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 21:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCDClf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 21:41:35 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DAFC061756;
        Wed,  3 Mar 2021 18:40:55 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h22so25795390otr.6;
        Wed, 03 Mar 2021 18:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JMOAoKv46pbLWuzklGj9HANrKw8HcT4/68qmxCFcggQ=;
        b=baBwwf92MdQ53FQXgBhJxFq1OjJZWlbSiKo6rKrk81d07WzGPcDJwLXDgfQSge/uaM
         MRaI7S0ddpyzxDc9dccfVOdk4o+SqYcf1zKCSNOBtWZX+QFNtIH9TLErLmMBs1IYJMjd
         CpPngWeSGZ3kfJxkpUimjdJ8DHbrml4Q+9aJyxnRSy9BNcDWW3Uo9lKz0gEhkp7Up4AZ
         jbfDlwCnXLEJ1nTbUwqRYd56XsnVNj8pbxwQCbF6yTOh5gvoVzlPA6n/QEcLNby+7hxl
         M6cdZqOH94Jz9ypSthyIxxOYKAs2ctpxnWoH3C4fnwVhWd4ZO7rIZZuNCLG8TsJEp2bl
         csMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JMOAoKv46pbLWuzklGj9HANrKw8HcT4/68qmxCFcggQ=;
        b=VUmBFxsJCsU9NVsNH8eOa8JgBq1BwSZvANDU0XTz50DXFfJLhueva6PaEnw5+nZwkd
         bzx3FagThWXf+6bCQH7jWHSr1TMylWM50kb6SEPPmNfl1j0/LJhYWzdWTdbHkUjanbNA
         2tnhZ5u4Jpj045U+/CqwFQnC95m/9qf3RyyJWIMFKbThSWnQPEa1UiReTPMAFGuAxT2V
         FWGS2W7j5cCTaj4AIx+6jerhqdUXzfXUNby2Rlu01Rjbr+TjEy8ytcfLQSqqVNUFbdA5
         qBY1IOPkJEpRyj6iyT2kmKUmj0IZT09Z8Td6CL8EP1hOLWVL+rpGNOJnv5XXX6VSsxMW
         IkRw==
X-Gm-Message-State: AOAM533ZdDj9vt/Rvzrd/KeMEtOMU7rEKQ2O5K+JwOOHF1W1xTpqn+X5
        VD/DnxMM54w4ew69Hgqdf1IIc315E/WXVVeQcKutI3dZ7Kk=
X-Google-Smtp-Source: ABdhPJxRXmoWbVy0J88KuNtygJJiFAL7eRYFaw4SkBz0M0+yPRCi7G+jaOz+ByfDfwZrd0RFOoB/TELcNCqd8bBjqmU=
X-Received: by 2002:a05:6830:80b:: with SMTP id r11mr1728934ots.329.1614825654567;
 Wed, 03 Mar 2021 18:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20210303162757.763502-1-paskripkin@gmail.com>
In-Reply-To: <20210303162757.763502-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 3 Mar 2021 21:40:43 -0500
Message-ID: <CAB_54W6-ONBmLhaQqrDD=efiinRosxe06VEGDqmMM-1-XjYcPw@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix null pointer dereference
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 3 Mar 2021 at 11:28, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> syzbot found general protection fault in crypto_destroy_tfm()[1].
> It was caused by wrong clean up loop in llsec_key_alloc().
> If one of the tfm array members won't be initialized it will cause
> NULL dereference in crypto_destroy_tfm().
>
> Call Trace:
>  crypto_free_aead include/crypto/aead.h:191 [inline] [1]
>  llsec_key_alloc net/mac802154/llsec.c:156 [inline]
>  mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
>  ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
>  rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
>  nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
>  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
> ---
>  net/mac802154/llsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
> index 585d33144c33..6709f186f777 100644
> --- a/net/mac802154/llsec.c
> +++ b/net/mac802154/llsec.c
> @@ -151,7 +151,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
>  err_tfm0:
>         crypto_free_sync_skcipher(key->tfm0);
>  err_tfm:
> -       for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
> +       for (; i >= 0; i--)
>                 if (key->tfm[i])

I think this need to be:

if (!IS_ERR_OR_NULL(key->tfm[i]))

otherwise we still run into issues for the current iterator when
key->tfm[i] is in range of IS_ERR().

- Alex
