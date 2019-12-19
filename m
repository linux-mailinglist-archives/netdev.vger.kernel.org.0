Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43023125FFD
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLSKxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:53:24 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:40307 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfLSKxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 05:53:24 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bb3776ae;
        Thu, 19 Dec 2019 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=52wRWpsffBeasMC8RSpjNk06uTI=; b=v3G0K+
        NYUVIM8e1/FXyi7JkyPgyMLc4qsXLDKqFztkc9+T6rleU39wrFEseiJOY1TJoQ0s
        XNwF5rUOv9RcpbJOzeNk76oBNFmsmhnKXcgXvXjSZQMlYp6pqsSznYblxNP1+UXY
        iZPNTOL8Qo9SRc62HZzYIWZE7suXExbaNjv8toALOfCdTMfMtKLyB5kjVkk8ggGE
        D5j+BlghWdb8flRs7yiMFaWf2QSV6hx9RRgl36kTtbEfQiMLuQMfIkWm9sLnGCo4
        73xlkHWbrxedfVMdRmUYL7KEMSk1t7MlV3JtfgfMB2Omt2o8n0OQOJU8dRq4PbAb
        WAS4iBOeTW2b8QiQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 928a936d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Dec 2019 09:56:41 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id a67so2465792oib.6;
        Thu, 19 Dec 2019 02:53:22 -0800 (PST)
X-Gm-Message-State: APjAAAUrlkvnw2UvEEEAlS33fSie8XO57N214fuylnX688HONewOGzGq
        JUvfwBxUmELw9BUMFJxnkfxryVd2gx4jJgcV0T8=
X-Google-Smtp-Source: APXvYqzXNB9TOVozSiixjEhYFbGpVg8PPRAKr91Iku4NK9R6Hm0+Cm3RtF7N+wgCzvMUrkD1yBxh96o24g3uUL9uEhY=
X-Received: by 2002:aca:2109:: with SMTP id 9mr1741139oiz.119.1576752801206;
 Thu, 19 Dec 2019 02:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com> <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
In-Reply-To: <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Dec 2019 11:53:10 +0100
X-Gmail-Original-Message-ID: <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
Message-ID: <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:49 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, Dec 19, 2019 at 11:11 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Thu, Dec 19, 2019 at 11:07 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Thu, Dec 19, 2019 at 10:35 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > That's exciting about syzcaller having at it with WireGuard. Is there
> > > some place where I can "see" it fuzzing WireGuard, or do I just wait
> > > for the bug reports to come rolling in?
> >
> > Ahh, found it: https://storage.googleapis.com/syzkaller/cover/ci-upstream-net-kasan-gce.html
> > Looks like we're at 1% and counting. :)
>
> Yes, that's it. But that's mostly stray coverage.
> wg_netdevice_notification I guess mostly because it tested _other_ device types.
> And a bit of netlink because it sends random garbage into netlink.
>
> For netlink part it would require something along these lines:
> https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_generic_devlink.txt
> https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_crypto.txt
> https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_generic_fou.txt
> https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink_generic_seg6.txt
>
> And for device setup, harder to say. Either pre-create one here:
> https://github.com/google/syzkaller/blob/79b211f74b08737aeb4934c6ff69a263b3c38013/executor/common_linux.h#L668
> or teach it how to create them on the fly or both or something else.
>
> Probably some wire packet formats here:
> https://github.com/google/syzkaller/blob/79b211f74b08737aeb4934c6ff69a263b3c38013/sys/linux/vnet.txt

Ahh, cool, okay. Netlink, device creation, and basic packet structure
is a good start. What about the crypto, though?
