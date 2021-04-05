Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3233B353BD3
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhDEFp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDEFp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 01:45:27 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A7FC061756;
        Sun,  4 Apr 2021 22:45:21 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w28so15882787lfn.2;
        Sun, 04 Apr 2021 22:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Zg/v1PYpBC50qyCilHLmL7q/u5BgzrV8R/Tup/aLIyI=;
        b=VDYCDZda4midle4gmadPnH/5vWGFCP4wIum+hXhcr6+G5hn5ytYYv0gy+iGyjlG4V1
         HBpZPWPZ3kgyXkFFP2ZFpNH08Hr+aDrUMsTgEUFrIT3+qrvC/Z765gIm/ZGsJGj/0+X2
         mvEobVtrBR9BwYuxM2+3QaPpugiV95r8ayIisHuawhA0SfGcLMh7cBLKGhqritJ7PBsY
         gtkg0bxcYyuTL245+YxZGX2/peYTdYzqUD6mQXECLIx1LxDdiS7v5vYQHYOF6nl/FL+X
         I8SE9S4nIc7kocF/NqA6i7RE2oY+bbCcV1yC6HygCZgPpKwxXUAczHjg0VqLUYgUomXM
         dsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Zg/v1PYpBC50qyCilHLmL7q/u5BgzrV8R/Tup/aLIyI=;
        b=Po+lAk/d7a/V9uupmMs6G27KSkKrFgHuBTkB5+ajH2O0vepvh9w5vrLZZPXmllq2nh
         mIDuOcYTEWFK9ITE8s0xYOkdK/hIHoHJ44Wsuni28EgxlUP+6jdhhiV5cBz8YxV0Lzaq
         DpbULDFltpl3Dnm5TZRkVE/haZJ3xCNYAG4P5hbXjP1LhXmS7BOeKXd3lT+xCpJaKQur
         0AnXHbJ/v+1fLlGkDJRpvMyKP/0M4cjDOD1ZKpADKiG/CQqmpH4F77qRJbRGVQUItrRs
         bNMtngIOqb4MGe7pe4itI2Up/ErxWS1xd21fRFJyMxfClBRPRVoYz+VnVxKDWJZ8ex9i
         XyBQ==
X-Gm-Message-State: AOAM532Dbnxrp3V/Kj6GNZ+6WQ+I64JCRPM81rUCwLpnRmucsceRoYFz
        +V/gjEbLgEBdPJct2k01lMg=
X-Google-Smtp-Source: ABdhPJyN0Go8dde3uVawRFhFXq5zuyIv+voUYe2XIkI0RtzuQuk+k8CE/F5AlQCLwrkqmZIcqasILA==
X-Received: by 2002:a05:6512:3a83:: with SMTP id q3mr16642180lfu.460.1617601519935;
        Sun, 04 Apr 2021 22:45:19 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id e24sm1658200lfn.62.2021.04.04.22.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 22:45:19 -0700 (PDT)
Message-ID: <9435f1052a2c785b49757a1d3713733c7e9cee0e.camel@gmail.com>
Subject: Re: [PATCH v2] net: mac802154: Fix general protection fault
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Date:   Mon, 05 Apr 2021 08:45:18 +0300
In-Reply-To: <CAB_54W6BmSuRo5pwGEH_Xug3Fo5cBMjmMAGjd3aaWJaGZpSsHQ@mail.gmail.com>
References: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
         <20210304152125.1052825-1-paskripkin@gmail.com>
         <CAB_54W6BmSuRo5pwGEH_Xug3Fo5cBMjmMAGjd3aaWJaGZpSsHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sun, 2021-04-04 at 20:43 -0400, Alexander Aring wrote:
> Hi,
> 
> On Thu, 4 Mar 2021 at 10:25, Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> > 
> > syzbot found general protection fault in crypto_destroy_tfm()[1].
> > It was caused by wrong clean up loop in llsec_key_alloc().
> > If one of the tfm array members is in IS_ERR() range it will
> > cause general protection fault in clean up function [1].
> > 
> > Call Trace:
> >  crypto_free_aead include/crypto/aead.h:191 [inline] [1]
> >  llsec_key_alloc net/mac802154/llsec.c:156 [inline]
> >  mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
> >  ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
> >  rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
> >  nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
> >  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
> >  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> >  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
> >  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
> >  sock_sendmsg_nosec net/socket.c:654 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:674
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
> > Change-Id: I29f7ac641a039096d63d1e6070bb32cb5a3beb07
> 
> I am sorry, I don't know the tag "Change-Id", I was doing a whole
> grep
> on Documentation/ without any luck.
> 

I forgot to check the patch with ./scripts/checkpatch.pl :(

> Dumb question: What is the meaning of it?

This is for gerrit code review. This is required to push changes to
gerrit public mirror. I'm using it to check patches with syzbot. Change
ids are useless outside gerrit, so it shouldn't be here.

Btw, should I sent v2 or this is already fixed? 

> 
> - Alex

With regards,
Pavel Skripkin


