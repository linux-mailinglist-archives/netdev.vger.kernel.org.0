Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8832CF98
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhCDJYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 04:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbhCDJYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 04:24:06 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A7CC06175F;
        Thu,  4 Mar 2021 01:23:25 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id v9so24223469lfa.1;
        Thu, 04 Mar 2021 01:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pZ19mgNU3Qr30eSsWiilV/pbn6I16lt5wQNtnDOvD5Q=;
        b=BbfCtS1fiicYn5B4uJEnMRK6RcOKMhLTWEHf6kDTf6VnciGKysU0j2/A1IoX4lXu2g
         PKQEcAZ77l1l4iI6XsoMRZiRmkxg1smweK4OI1oqwKeHcobXTUVAXeBSTfLqCeUmYkR9
         6gs/ABsofyKrPej+iXIR2iAhaiBboozIsqIYXvnoHeYVQZ1xee9SbDMTGnYv+tDO4r7j
         TVRZyBmpgA0vMBFi7ydVjhrwoZa5Dc312norseDQ1MnF/TdNxQC2D4PM9kli5/QZeKkF
         FvmoRXAbShjokgXcfU+pJUrGnRKa9CrsLo0xhw0fhPvJlZU5FtjAlRmPBiCORh2GGjyV
         aItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pZ19mgNU3Qr30eSsWiilV/pbn6I16lt5wQNtnDOvD5Q=;
        b=NBzbKC2WWv700dRA+qc0yqiWExKnO/E9V4DFQuMkUbtJ7MPB/juV1gyu94RdYGfJ1j
         P0tCcqTg++MrfgCk083Y8ElA4ht8QSw7zT1g/Ga4OVa5s8CIyUsIyV28wYtj2uLUneTg
         8IL0tZgpZznIY2lDh2NJ7sO+lx1A4CUohry1mPg66fQKlJznBwKV6258S6tBwdU/2PVr
         jj4u1RIjeNp96trMj2aQ7dSrdUI3JpcN0Y/pa7qXvpOHeKpn1eogpU8VwsqT20wRtcgB
         35SG8mcS+4FU/Sr2b/7LxjWsSHySETPp9AraCaHct8UeT0CEa7pHEvFTl84gR/VsyHgi
         TjEw==
X-Gm-Message-State: AOAM533I3rlkXjqBkoqNODWBZ90YTH53Flj+GhnSnXDzVtM4CU4/yvB1
        rQtEQZWBm/vw5kSXeVX3L1MvRdoouGuWJ/T7jlo=
X-Google-Smtp-Source: ABdhPJxVgRGLvTzQezwsszj5YgYcGBwk+WQu9kJRfPjkqxk5RQID6DqXvaJpWRb633OqZuOFpsR7fQ==
X-Received: by 2002:a05:6512:2185:: with SMTP id b5mr1742211lft.489.1614849804226;
        Thu, 04 Mar 2021 01:23:24 -0800 (PST)
Received: from pskrgag-home ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id n13sm3208491lfu.265.2021.03.04.01.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 01:23:23 -0800 (PST)
Message-ID: <e70d7b45638db427be978c620475a330cb9db57c.camel@gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix null pointer dereference
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Date:   Thu, 04 Mar 2021 12:23:22 +0300
In-Reply-To: <CAB_54W6-ONBmLhaQqrDD=efiinRosxe06VEGDqmMM-1-XjYcPw@mail.gmail.com>
References: <20210303162757.763502-1-paskripkin@gmail.com>
         <CAB_54W6-ONBmLhaQqrDD=efiinRosxe06VEGDqmMM-1-XjYcPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, thanks for your reply!

On Wed, 2021-03-03 at 21:40 -0500, Alexander Aring wrote:
> Hi,
> 
> On Wed, 3 Mar 2021 at 11:28, Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> > syzbot found general protection fault in crypto_destroy_tfm()[1].
> > It was caused by wrong clean up loop in llsec_key_alloc().
> > If one of the tfm array members won't be initialized it will cause
> > NULL dereference in crypto_destroy_tfm().
> > 
> > Call Trace:
> >  crypto_free_aead include/crypto/aead.h:191 [inline] [1]
> >  llsec_key_alloc net/mac802154/llsec.c:156 [inline]
> >  mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
> >  ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
> >  rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
> >  nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
> >  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
> >  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> >  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
> >  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
> >  sock_sendmsg_nosec net/socket.c:654 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:674
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
> > ---
> >  net/mac802154/llsec.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
> > index 585d33144c33..6709f186f777 100644
> > --- a/net/mac802154/llsec.c
> > +++ b/net/mac802154/llsec.c
> > @@ -151,7 +151,7 @@ llsec_key_alloc(const struct
> > ieee802154_llsec_key *template)
> >  err_tfm0:
> >         crypto_free_sync_skcipher(key->tfm0);
> >  err_tfm:
> > -       for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
> > +       for (; i >= 0; i--)
> >                 if (key->tfm[i])
> 
> I think this need to be:
> 
> if (!IS_ERR_OR_NULL(key->tfm[i]))
> 
> otherwise we still run into issues for the current iterator when
> key->tfm[i] is in range of IS_ERR().

Oh... I got it completly wrong, I'm sorry. If it's still not fixed,
I'll send rigth patch for that.

> 
> - Alex
-- 
With regards,
Pavel Skripkin

