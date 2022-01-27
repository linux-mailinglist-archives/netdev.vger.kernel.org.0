Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1285949EDFC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiA0WNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiA0WNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 17:13:38 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A9C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:13:38 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id s13so9356687ejy.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=douOaaMonIIbHz1c4NHht9J6UfeQHbTJLt8li6hXv/0=;
        b=S+az6aOFwxPSdQ8H/3X8jw4UFlfD0QYMIHgIpoK9Jk3L1P3ZxQSLRbJ+ttbS1hKl5M
         uyEje0YKSpx2BMMQsuzCbDIMacnABpPHJwzsG4g3hWNVGQi3JK0fNsZNsuII+Kx5V5jO
         Pb2btKCxZYbsLJbRIVtYrtpQWbj7YgPmx9jUzMv3zXc8BDPAOG2bxzQnyHjuavKjOw2J
         6L4Kg5U5xzS2vdi6bsw/cYIzm7FodPoA/ZfPhfIFmLNnjDeDjD7wDnVIaPbNNcGXY4WP
         54zSGZXI+cdOaAHfgWcQWe9sngYacG9igawh3+ruXhMpJmWCe/AOAAUi4jIWt3BcqqCc
         AdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=douOaaMonIIbHz1c4NHht9J6UfeQHbTJLt8li6hXv/0=;
        b=yizV6aBgtqawbdA/DVKUHLfuVoxqTq9ttkOqYBlyEy6/BztFtgdoTvbsf15rw0hCTf
         hSuOwyklvGeKYwHAk6UMt475T2yQSTrMQ/409DSDK3VEBeUTgI3F+WxenmJABbRIePep
         JaGsHXNKOmasSLCisbDmvWaQIOYoi0PqMsRVaTLWvXriNHMkxye8IrEeyOrEZrEjAZH+
         BBX1SFBy456onTCM6sxp1R8NgG4wV0PAFxrOCKRQ9OedIG8UapnScS7316T5U85btY07
         ejHxMoMDfNA3T/7qd+5gJvq39KIArq9aSIWANn932mPrGD0igAKmLpgZTQw6SuHmIhEG
         uXBA==
X-Gm-Message-State: AOAM533Uq1u1Px3/2gVzfHA7+zE7YCK4KbgN8zQqgiy6Ao9W5/xCXqvp
        ZTkWZnghD9BpruLzLUtn1gdyt8VrmKCZO5lVqdYX9LTpsbxP5w==
X-Google-Smtp-Source: ABdhPJzf0lgZwa1ZKo/FPbC27ZXsA+QA7vxl7Kwfzhc/N/ngcEInWGcy7AHZv3FtGgtxlYALo2jgVnL4vodFTNPCldc=
X-Received: by 2002:a17:907:3ea9:: with SMTP id hs41mr4672800ejc.727.1643321616897;
 Thu, 27 Jan 2022 14:13:36 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:86aa:0:0:0:0 with HTTP; Thu, 27 Jan 2022 14:13:36
 -0800 (PST)
From:   Vadim Priluzkiy <oxyd76@gmail.com>
Date:   Fri, 28 Jan 2022 01:13:36 +0300
Message-ID: <CAO-kc_UnKm2+bwe_Ran5cyJ15jQ17mdgev=q4a8PuGtBFNrGcA@mail.gmail.com>
Subject: Iproute2 v5.16.0 "ip address" issue
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ppl!

RFC 6943 (https://datatracker.ietf.org/doc/html/rfc6943#section-3.1.1) say:

"In specifying the inet_addr() API, the Portable Operating System
   Interface (POSIX) standard [IEEE-1003.1] defines "IPv4 dotted decimal
   notation" as allowing not only strings of the form "10.0.1.2" but
   also allowing octal and hexadecimal, and addresses with less than
   four parts.  For example, "10.0.258", "0xA000102", and "012.0x102"
   all represent the same IPv4 address in standard "IPv4 dotted decimal"
   notation.  We will refer to this as the "loose" syntax of an IPv4
   address literal."

Also "man 3 inet" say:

"inet_aton()  converts  the  Internet host address cp from the IPv4
numbers-and-dots notation into binary form (in network byte order) and
stores it in the structure that inp points to.  inet_aton() returns
nonzero if the address is valid, zero if not.  The address supplied in
cp can have one  of  the following forms:

       a.b.c.d   Each of the four numeric parts specifies a byte of
the address; the bytes are assigned in left-to-right order to produce
the binary address.

       a.b.c     Parts  a  and  b  specify the first two bytes of the
binary address.  Part c is interpreted as a 16-bit value that defines
the rightmost two bytes of the binary address.  This notation is
suitable for specifying (outmoded) Class B network addresses.

       a.b       Part a specifies the first byte of the binary
address.  Part b is interpreted as a 24-bit value that defines the
rightmost  three  bytes  of the binary address.  This notation is
suitable for specifying (outmoded) Class A network addresses.

       a         The value a is interpreted as a 32-bit value that is
stored directly into the binary address without any byte
rearrangement.

     In all of the above forms, components of the dotted address can
be specified in decimal, octal (with a leading 0), or hexadecimal,
with a leading 0X).
    Addresses in any of these forms are collectively termed IPV4
numbers-and-dots notation.  The form that uses exactly four decimal
numbers  is  referred to as IPv4 dotted-decimal notation (or
sometimes: IPv4 dotted-quad notation)."


Okay! I know that many utilities (ping, curl, tracepath, browsers etc)
support int, octal, hexadecimal notations very well.
I tried assigning an address to an interface using "ip address" using
various notations and that's what happened (test address: 10.8.0.5,
removed after every test):

Octal dotted notation:
# ip a add 012.010.000.005/24 dev dummy0
# ip a show dev dummy0
6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group
default qlen 1000
    inet 10.8.0.5/24 scope global dummy0

Hexadecimal dotted notation:
# ip a add 0xA.0x8.0x0.0x5/24 dev dummy0
                                                               # ip -4
a show dev dummy0

6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group
default qlen 1000
    inet 10.8.0.5/24 scope global dummy0

Hexadecimal notation:
# ip a add 0xA080005/24 dev dummy0

 Error: any valid prefix is expected rather than "0xA080005/24".

Int notation:
# ip a add 168296453/24 dev dummy0

Error: any valid prefix is expected rather than "168296453/24".

Hmm... Okay, let's try something simple. For example address 0.0.0.1:
# ip a add 0x1/24 dev dummy0

 # ip -4 a show dev dummy0
                                                              6:
dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    inet 1.0.0.0/24 scope global dummy0

(similar effect on "ip a add 1/24 dev dummy0")

WTF?
ip, instead of counting values from the last octet, counts them from the first!
Perhaps somewhere mixed up little/big endian?

Testcase: Manjaro Linux, kernel version 5.15.16, iproute2 version 5.16.0

PS: Legacy ifconfig works fine with any notation and assigns the
address correctly.

-- 
Vadim (Oxyd) Priluzkiy
