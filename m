Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A321615FB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgBQPTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:19:22 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38594 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727533AbgBQPTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:19:22 -0500
Received: by mail-qv1-f68.google.com with SMTP id g6so7728723qvy.5
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 07:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YM0odjGl8U3GcBGpw5GZV0Acwp28LkTIz+4MS3NiOI=;
        b=REhI8W3pkPtEn4gDLUJNQzzFMWgYM2fAO/VezaDubVC8li8vhFgRm9Q6mA75CzMCdm
         D7xlSTzzSLCimAvMcyu6Cr2hrb3q0sWvfvMxNRO64ur6i+H7LjL4J9rP5kK0+LFkkKvr
         u1OWkISE6g1kmB6MX0Rz/wqsYO5Q/O+9q6q10BjTbtfvFVz6qzUm6X6n1OWp3bRJyena
         ma5eTLteiP0XapelHUjn0DBwtDBL2RHjX/G7nWKz/NYuqzrqm6zbWD75bGFuHrnh7RUo
         bQGpDDhZABCedR9l0T8RK31tLWN3Gtfw6xLetq0AldEe0r954q1pd/iCmpP0U+t0XewC
         A4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YM0odjGl8U3GcBGpw5GZV0Acwp28LkTIz+4MS3NiOI=;
        b=NaneG3BYWir7mqRqGb7h+eTUF3P+COzRKtb+XR7l0bwpPJOh6stLLat/h9FKbZTJRC
         2Dhk11y/Ff+hlYxSCi0p/Ado66qTaQMCoV+Gh/0VMzueLmMSWoyBE33u8Px9VNWpC+tE
         PWRZZb3yPe/Rad2aJxCjLTmR7QubOOt3A7dXrjaSh9SwRDUXQUm6mKwTWdeajNT4Od50
         0rQ2YmFDQx2ObbVWZdx2Pax0VzKmIQ0OSQA72zYqGFvAdiHQdW2j/lYAstvC1CZJMZS5
         nXVcWT/Y0HJROdFx/LtUS7VVIaBMXCcIo8U+mxvDrSPcIiPaJNDW/tKCYj31Q9zX+BHC
         UQHg==
X-Gm-Message-State: APjAAAUoouvxA4Jy2KX8inJ9Y84e+Cgy4NXASLN9WHD2EIAiJ14TQ8t3
        YCGGeZJUgGj/Ry1lEXlTFJvJNtUtVqnMLpRfar2lSA==
X-Google-Smtp-Source: APXvYqwE7/00LaJ4qib/XNoqXuTzN5OtJffyQDf4Cp286Ut3VWkae83YdClEOKdxaj9OT2syBPcME7FcVAplbjUtQaU=
X-Received: by 2002:a0c:ee91:: with SMTP id u17mr12489562qvr.22.1581952760881;
 Mon, 17 Feb 2020 07:19:20 -0800 (PST)
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
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com> <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
In-Reply-To: <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 Feb 2020 16:19:09 +0100
Message-ID: <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 12:44 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Observation:
>
> It seems to be starting to synthesize packets sent to the wireguard
> socket. These aren't the proper handshake packets generated internally
> by that triangle commit, but rather ones that syzkaller creates
> itself. That's why we have coverage on wg_receive, which otherwise
> wouldn't be called from a userspace process, since syzbot is sending
> its own packets to that function.
>
> However, the packets it generates aren't getting very far, failing all
> of the tests in validate_header_len. None of those checks are at all
> cryptographic, which means it should be able to hit those eventually.
> Anything we should be doing to help it out? After it gets past that
> check, it'll wind up in the handshake queue or the data queue, and
> then (in theory) it should be rejected on a cryptographic basis. But
> maybe syzbot will figure out how to crash it instead :-P.

Looking into this.

Found the program that gives wg_receive coverage:

r0 = openat$tun(0xffffffffffffff9c,
&(0x7f0000000080)='/dev/net/tun\x00', 0x88002, 0x0)
ioctl$TUNSETIFF(r0, 0x400454ca, &(0x7f00000000c0)={'syzkaller1\x00',
0x420000015001})
r1 = socket$netlink(0x10, 0x3, 0x0)
ioctl$sock_inet_SIOCSIFADDR(r1, 0x8914,
&(0x7f0000000140)={'syzkaller1\x00', {0x7, 0x0, @empty}})
write$tun(r0, &(0x7f00000002c0)={@void, @val, @ipv4=@udp={{0x5, 0x4,
0x0, 0x0, 0x1c, 0x0, 0x0, 0x0, 0x11, 0x0, @remote, @broadcast}, {0x0,
0x4e21, 0x8}}}, 0x26)

Checked that doing SIOCSIFADDR is also required, otherwise the packet
does not reach wg_receive.
