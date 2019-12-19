Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F921260F2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfLSLiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:38:17 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39827 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfLSLiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 06:38:17 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 03462d03;
        Thu, 19 Dec 2019 10:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Tgcd43aWDxXZtpWtji0zzfPGJtY=; b=2MOlb0
        fyyxUyHUas9uVDw3nIhy+OOdK5hxgL5H9Uiw3KUlveqEAdSZUQxhKeRnUs8717lA
        XoM96yXyMZ8JjhQ+GsobmsmNX5t3Tj9GCNfUxsHAjZl28FIRAqA0A9Nmctv/k065
        65VIaCeHbFRTA8J0xyP+PVU68f/saptzma6Z8By5q/1JJEX1fmV41wu4vVE8ZzS1
        wIzBlPghAHqSPLs5s3pfGqPe9PsnYwfLsJKRBhffU7kAQOttgMGKrVviR09mnoFj
        68zjaJ2thGkz5NF+q7anw6ZFsEy2zG6bFyY6TQu6jLLvOryY3vZKJbLhd2lCCZt/
        Xhsxxp9kzrPfpdvg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8b6c411a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Dec 2019 10:41:33 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id p67so2500294oib.13;
        Thu, 19 Dec 2019 03:38:14 -0800 (PST)
X-Gm-Message-State: APjAAAWc77uvhHNvjGHC5iaBEaWWq+HLUmGrocykK2bVLFTpT5G62pDN
        KmURJf2zv4w8KTAYxtM3luRc3Y5DRAisbsSuIFs=
X-Google-Smtp-Source: APXvYqyOfRgA2LULJU+futc2BpZr5n2mauTNGPfK4NbUrTbjuRpU36JofFYDe5gGWlSaz/8BPxQdZm6hA9C1Yz+Z9+g=
X-Received: by 2002:aca:815:: with SMTP id 21mr1974457oii.52.1576755493704;
 Thu, 19 Dec 2019 03:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com> <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
In-Reply-To: <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Dec 2019 12:38:02 +0100
X-Gmail-Original-Message-ID: <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
Message-ID: <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
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

On Thu, Dec 19, 2019 at 12:19 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Ahh, cool, okay. Netlink, device creation, and basic packet structure
> > is a good start. What about the crypto, though?
>
> It depends. What exactly we need there?
> syzkaller uses comparison operand interception which allows it e.g. to
> guess signatures/checksums in some cases.

I don't think you'll have too much luck with WireGuard here. Fuzzing
your way to a valid handshake message involves guessing the 4th
preimage of some elliptic curve scalar multiplication, with some
random/changing data mixed in there every time you make a new try.
There's a condensed protocol description here which should be less bad
to glance at than the academic paper:
https://www.wireguard.com/protocol/#first-message-initiator-to-responder
. The fuzzers I've written for the crypto bits of WireGuard always
involve taking a complete handshake implementation and mutating things
from there. So maybe the "outer packet" won't be too fruitful without
a bunch of work. At the very least, we can generate packets that have
the right field sizes and such, and that should test the first level
of error cases I guess.

However, there's still a decent amount of surface on the "inner
packet". For this, we can set up a pair of wireguard interfaces that
are preconfigured to talk to each other (in common_linux.h, right? Or
do you have some Go file that'd be easier to do that initialization
in?), and then syzkaller will figure out itself how to send nasty IP
packets through them with send/recv and such. There's a bit of surface
here because sending packets provokes the aforementioned handshake,
and also moves around the timer state machine. The receiver also needs
to do some minimal parsing of the received packet to check
"allowedips". So, good fodder for fuzzing.
