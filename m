Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21027152201
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBDVjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:39:48 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54439 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbgBDVjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 16:39:47 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 68f890a8
        for <netdev@vger.kernel.org>;
        Tue, 4 Feb 2020 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=IA9BgkXO4y1tj4ir/uT+L2i2M1Y=; b=3F+wGa
        XXKEaSC3rxCiikRLwYrLGz2HVfKcRFAtSpmC/EE2tIUCvw6Jt/3VgHlacgfoEgiq
        cdoIEXBCTMOjDumWyO4IG5fkM4tYFhenl8e8hrzl1OVzCeL7vmaM+FvfudV6iCdm
        ZhoJ3Mb6RI1cMLKVQh0AKk0xudQ7CNxwExkn8CHpqQZeYJB0g23WPlqdTTsCaZr9
        25qt/F+VLG1nl1BHWLr7SCtxJhyGMIjONRzBy8UgWeN27ytKsxBtskbqvKO0/5sB
        yponmDA5bfukZiHbKA2Y4z6hmxOsGx4giiy/UXHIp0qK+mRI6vDaK9wYEQGZA10o
        ipjFHW+52k8te/8A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f5dda32d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 4 Feb 2020 21:38:53 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id a15so18679731otf.1
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 13:39:45 -0800 (PST)
X-Gm-Message-State: APjAAAVfzwu9eKLIKH25aVrtCG+anyEQ6zhd8Wlf9qGIGdhaBsIkvG5u
        vz7CfuFXgTlGjtirzsCZ8nGSwAOyrWS1lNI7Blw=
X-Google-Smtp-Source: APXvYqyGam5KOWJSNtBSP5oVex1+DDBSldrjXTPvSbLwRn/WfIFo0yyZdSaxizLyfaNE/aV0+bPOpFVUxYmcYWpcpB4=
X-Received: by 2002:a9d:6745:: with SMTP id w5mr24023954otm.52.1580852384144;
 Tue, 04 Feb 2020 13:39:44 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com> <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
In-Reply-To: <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Feb 2020 22:39:33 +0100
X-Gmail-Original-Message-ID: <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
Message-ID: <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
Subject: syzkaller wireguard key situation [was: Re: [PATCH net-next v2] net:
 WireGuard secure network tunnel]
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dmitry,

I see you got wireguard's netlink stuff hooked up to syzkaller.
Excellent work, and thanks! It's already finding bugs.

Right now it seems to know about 5 different keys you've come up with,
and not much in the way of endpoints. I think we can improve this.

For keys, there are a few cases we care about:

1) Low order keys
2) Negative keys
3) Normal keys
4) Keys that correspond to other keys (private ==> public)

For this last point, if we just have a few with that correspondance
quality in there, syzkaller will eventually wind up configuring two
interfaces that can talk to each other, which is good. Here's a
collection of keys you can use, in base64, that will cover those
cases, if you want to add these instead of the current ones in there:

1)
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
4Ot6fDtBuK4WVuP68Z/EatoJjeucMrH9hmIFFl9JuAA=

2)
2/////////////////////////////////////////8=
TJyVvKNQjCSx0LFVnIPvWwREXMRYHI6G2CJO3dCfEdc=

3,4)
oFyoT2ycjjhT4v16cK4Psg+hUmAMsAhFF08IB2+NeEM=
l1ydgcmDyCCe54ElS4mfjtklrp8JI8I8YvU8V82/aRw=
sIBz6NROkePakiwiQ4JEu4hcaeJpyOnYNbEUKTpN3G4=
0XMomfYRzYmUA01/QT3JV2MOVJPChaykAGXLYxG+aWs=
oMuHmkf1vGRMDmk/ptAxx0oVU7bpAbn/L1GMeAQvtUI=
9E2jZ6iO5lZPAgIRRWcnCC9c6+6LG/Xrczc0G0WbOSI=

That's 10 keys total, which should be a decent collection to replace
your current set of hard coded keys in there. You can unbase64 these
into C format with commands like:

$ echo '2/////////////////////////////////////////8=' | base64 -d | xxd -i
  0xdb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

The second thing is getting two wireguard interfaces to talk to each
other. This probably should happen over localhost. That means the
listen port of one should be the endpoint of the other. So maybe you
can get away fuzzing these with:

Listen ports:
51820
51821
51822
[randomly selected]

and

Endpoints:
127.0.0.1:51820
127.0.0.1:51821
127.0.0.1:51822
[::1]:51820
[::1]:51821
[::1]:51822
[randomly selected]

Finally the "allowed ips" for a peer, the routing table entry that
points to wireguard, and the packet that's being sent, should all
somehow correspond. But probably an allowed ips of 0.0.0.0/0 will
eventually be fuzzed to, which covers everything for the first part,
so let's see if the rest falls into place on its own.

What do you think of all that?

Jason
