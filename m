Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01799E7590
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390156AbfJ1PyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:54:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39055 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfJ1PyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:54:20 -0400
Received: by mail-io1-f65.google.com with SMTP id 18so4283462ion.6;
        Mon, 28 Oct 2019 08:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/K4LnDEAV8yJmNpGUurIA8x9iTL6nILqkGCecbIEJ9E=;
        b=I5JlTeIOoe+JV17+CDBqXoRf046iD/y90lrRZgsq//LcSx/m6g1QTSSsdRM3J3kX5m
         C11dWQFVCNULz0OfXuIJMxyLUvjmZHeZO9TpiT+aWRTLs26d6ztTPKiwjTIwD5TgSFOp
         Ro1dABUqHUa7T4iQFRcuF1XrNG9UBxy7tvIu7AzlYpCXOAJ0Pc6AERuSqKBCGtns5D3G
         tQcluzzlDZOR/puhfuXdneNSuVY6hjbeTOBQDdQeE6kcHPLH9zSanys9gXNPAB9WTU7M
         /clKj6m/0J2lUjypG4pTqjtSwVsinOoQGdG/Uh7Iwpqg6bAXUsRRrV2JZD2NtSjAieio
         x8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/K4LnDEAV8yJmNpGUurIA8x9iTL6nILqkGCecbIEJ9E=;
        b=cK+K/P5rWJNI6L+RFoG9MpgDV6Bp7zOYhA8ms4cfw6Uqdk5+tIQ8VOsGdmEcyC+us6
         UFLlURKR45ohTYW5lrnB9qm0nX+wK0M6BRGCxqKB0szMs9D2KNTrcG2VZXGZuV1lbmGR
         nrodo0PptkP6DsbOSmzTaEOcdQkrPzvMioqUTDOBF4OBEFD9AafR1WQ9+Iu6PhUjeKYb
         u+RW5JeRyPgpUatPQ+yOxEyGyRQG/cxuaQAvL/RkHcovk568e0WyxCj40fV0LlZzP/dN
         rWxv93voxvIZmfUaDAXTLAMZ3ByLNxTB+DHWXEczGF9uzpZzIlv9YCgifsvy4iRgek0c
         GhvQ==
X-Gm-Message-State: APjAAAWm+57T8NjlmTx+4VXEnWqhUsTbJLYbVwUDTxvimnDDvZN9hJ+f
        6HL2tIdBkN8loeDMTPFPNM6Yni9zgEWfYWWtQlOuF/u0
X-Google-Smtp-Source: APXvYqwb7kJVSuN6p1MhnedgbvFQU8PPyFPSW7UGdcgrGYnEqToa+7C32rN20O6HUK7+yyPctlfXAgySuJgdmbj8q3Q=
X-Received: by 2002:a02:77c4:: with SMTP id g187mr16511183jac.83.1572278059165;
 Mon, 28 Oct 2019 08:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <YWOrt002RdCqkBeUL04N1MVxcsjRvmCb4iqMW67EmAQIG5erLlSntgQWmSYiHXAT8kgFTceURhTaP8dAp9nPD9q3lquhb0MTIRlP4Vy5k3Y=@protonmail.com>
In-Reply-To: <YWOrt002RdCqkBeUL04N1MVxcsjRvmCb4iqMW67EmAQIG5erLlSntgQWmSYiHXAT8kgFTceURhTaP8dAp9nPD9q3lquhb0MTIRlP4Vy5k3Y=@protonmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Oct 2019 08:54:08 -0700
Message-ID: <CAKgT0Uc5Ba3Vno39KqdBRSXGYpyuGHeyef9=CkthoVkWipLS7g@mail.gmail.com>
Subject: Re: Commit 0ddcf43d5d4a causes the local table to conflict with the
 main table
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     "alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        "lartc@vger.kernel.org" <lartc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 26, 2019 at 12:10 AM Ttttabcd <ttttabcd@protonmail.com> wrote:

I am dropping all of the above. The fact is commit 0ddcf43d5d4a
("ipv4: FIB Local/MAIN table collapse") has been in the kernel for
over 4 and a half years so hopefully by now most of the network
developers are aware that the tables are merged, and become unmerged
when custom rules are added.

<snip>

> Suppose now that a software engineer wants to add 192.168.0.0/16 to the l=
ocal address, so he naturally executed the following command.
>
> ip route add local 192.168.0.0/16 dev lo
>
> But he does not know that there is a trap in the main table, another over=
lapping route!

So the first question I would have is why is the developer
intentionally overlapping the routes and creating duplicate routes?
For most users any address other than the localhost route is always a
/32 when it comes to local routing. Why is there a need to create
another route that is looped back into the system?

> ip route
> 192.168.3.0/24 dev wlan0 proto kernel scope link src 192.168.3.62 metric =
600
>
> ip route get 192.168.1.100
> local 192.168.1.100 dev lo src 192.168.1.100 uid 0
>     cache <local>
>
> ip route get 192.168.3.100
> 192.168.3.100 dev wlan0 src 192.168.3.62 uid 0
>     cache
>
> This will cause the entire network of 192.168.3.0/24 not to be routed to =
the local lo interface as he thought!

I agree this is the behavior. However it muddles the routing tables as
you have overlapping entries in the first place. As it stands doesn't
this effectively render 192.168.0.0/16 a blackhole since what you end
up with is it trying to loop back packets that will be recognized as
something from the local system anyway?

> This will lead to bugs that are very difficult to find! If I am not a pro=
grammer who knows a little about the kernel implementation, I can't find ou=
t what caused the problem (I checked a lot of source code and read a lot of=
 patches and kernel mail to solve this problem).
>
> Of course, you can say that no one will modify the local routing table un=
der normal circumstances. But is the linux system also designed for geeks? =
Is it also designed for programmers who want to exploit the full potential =
of the system?

I would argue that adding routes to the local table is a very "geek"
thing to do. Normally people aren't going to be adding routes there in
the first place. Normally routes are added to main as the assumption
is you are attempting to route traffic out to some external entity.
The local table normally only consists of the localhost route and a
set of /32 addresses as I mentioned earlier.

> If you provide a mechanism to modify the local table, you must ensure tha=
t the mechanism is working correctly.
>
> And it's absolutely impossible to make this mechanism a significant diffe=
rence in the execution process after triggering some incredible conditions =
(custom FIB rules are enabled, even if they are later disabled).
>
> In summary, I don't think this Commit 0ddcf43d5d4a is a good idea.
>
> Welcome to discuss.

I would disagree. There is a significant performance gain to be had
from this commit. What it is basically doing is taking advantage of
the fact that normally your local trie is going to consist of /32
routes and localhost. In the vast majority of cases there will never
be a clash as you have pointed out.

If anything what I would suggest, assuming the priority inversion
issue you have pointed out needs to be addressed, would be to look at
adding a special case for the addition of non /32 non-localhost routes
to local so that we could unmerge the table on such an addition. The
instance of non-/32 routes being added to local has apparently been
low enough that this hasn't been an issue up until now, and if we are
wanting to focus on the correctness of the fib lookup then this would
be the easiest way to sort it out while maintaining both the
performance and correctness.

Thanks.

- Alex
