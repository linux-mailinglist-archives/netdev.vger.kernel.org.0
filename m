Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A945F353A66
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhDEAoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhDEAoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:44:03 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41478C061756;
        Sun,  4 Apr 2021 17:43:57 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id q127-20020a4a33850000b02901b646aa81b1so2534934ooq.8;
        Sun, 04 Apr 2021 17:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JzhYsG+9twiks5ZAsr193ta04sndTLexylNjWAKj+Cs=;
        b=UNZXPaoA3Ox7ykfGZSVoS56Q4uXYqfHxXBqR+WhOSpSIp2GKjHEGea/xG7a8AcZ2S6
         WbOXjHPtJUOJnUnHrFhIVNdmThfXUjQbHHOqxQSUsGmYr5l5awG3C2bowKMx9LlDqsfh
         rhnI6MrZMK9HQhEQFTKw0QpNBJBcnbVQKF79x+1FWPEvxZQ9x4mQdmhdH4EEkpCHU/xd
         rYKt+eouZPGDTQ3yHF+QvIi05nBBqVA1lcnwttonWILlH7qD0rNmjZPsCjda6Lb+yNzV
         S9t3TVQtwoeTIbCa65V3/5g3j50WK3BGK63Zi7mp+oOf4B5NfD5qiANqjTv4PPemZnTx
         QFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JzhYsG+9twiks5ZAsr193ta04sndTLexylNjWAKj+Cs=;
        b=eznskGqHdWlAS2V/v38dB33AiixuCDKBALodZIPZEukVddrR7EF5fHuage5PBXQUCM
         RMXGEsIroxneBkRK2jbuBMH2Pox25bjken6dTuWnJsDIj3tQDjSLlTNm0/sLAqx88F5O
         z7H6XA+Fzl28wHWjz1MwQKW/ooMoVtNyNYJ4gTa8dkbSrdBCGPncocB3qTdPn/HwzITy
         +OWvD5ONdB3vEsEeMFRSduB6hWZx1myFQbsK3XoYUA8Z8wIAkljxxzHwMMLg0huRtgoi
         D248OzyBToOlFXVwPqLJGkdbZKrZIzDWDqowWnuwfrwG2COii22VFk5F0tZltOLCQ14S
         84fg==
X-Gm-Message-State: AOAM530a0n/CMk/8rBNY0fJhh0H7UDthoa1e70qdGPkL8wexkVytUjIl
        CU/iEgokYK6oxJtEJ/hLtK6u4f7m6Mc5H2X1YZc=
X-Google-Smtp-Source: ABdhPJwzPSlnMlxIkAvgRm9cQ3GiNrONcWgeWyie01ncsqtBQtgP410Tnk2T2ovpdMJRUwSnfsbx2DjeOIf2Be/cU28=
X-Received: by 2002:a05:6820:3c8:: with SMTP id s8mr20392380ooj.49.1617583436702;
 Sun, 04 Apr 2021 17:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
 <20210304152125.1052825-1-paskripkin@gmail.com>
In-Reply-To: <20210304152125.1052825-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 4 Apr 2021 20:43:45 -0400
Message-ID: <CAB_54W6BmSuRo5pwGEH_Xug3Fo5cBMjmMAGjd3aaWJaGZpSsHQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: mac802154: Fix general protection fault
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 4 Mar 2021 at 10:25, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> syzbot found general protection fault in crypto_destroy_tfm()[1].
> It was caused by wrong clean up loop in llsec_key_alloc().
> If one of the tfm array members is in IS_ERR() range it will
> cause general protection fault in clean up function [1].
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
> Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
> Change-Id: I29f7ac641a039096d63d1e6070bb32cb5a3beb07

I am sorry, I don't know the tag "Change-Id", I was doing a whole grep
on Documentation/ without any luck.

Dumb question: What is the meaning of it?

- Alex
