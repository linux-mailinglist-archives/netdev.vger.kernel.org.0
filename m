Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B006C123C6
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 23:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEBU76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:59:58 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36886 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBU76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:59:58 -0400
Received: by mail-it1-f196.google.com with SMTP id r85so5886143itc.2;
        Thu, 02 May 2019 13:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRhbL5cuEkeQdyIknIrO0b3fJ/vf0E8zx48sg0Cxl8U=;
        b=U3jKZzupr7YFHDHjWLHoqS+eWxDWlp3xXWj8Z5pC+mmOJnsF61+sR51YnhNRhpqqf4
         kOFCatyyKZKQTGoc/XoOwHkBQvyBYp9UK8jpelP57xrPqe3JYs9M7SYm26z+wcHBXy09
         e0f+wQI1/DoFAT/6b3bOTWK3zPrW42HuTFmij0f8ANtjwRNsSOYPMTUXQY/GwO699ASR
         DioCQEKCU95kNHPlwZ+ZkouQ9d8xOdcQoo8gwSvcEwB7utmqs9UCYy7U2mT2ns9dHluz
         8XddbGbNA5H69hZWSUNLyyyjLGqKkP1zHGXEaYOgxMgtIIncitbXLc9KVt3osb+6Kuf8
         poJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRhbL5cuEkeQdyIknIrO0b3fJ/vf0E8zx48sg0Cxl8U=;
        b=Cyfh5cIaZifhiN2YLg9QZpQEJpzRHwGe7/1Ff8hH8nFvVvtCEA+MTWBANeOl8nIFVw
         ufjdc/ByWqjyt7Ajpcd4fcsTjrFxgTjNrJcymxU1GzUhJBWWud1n8B2S4pQyXBJOotxb
         lbOwfgqCYv1GQskBIbooqBCGJhK5z7fCH45C5SLX+vfTDoVrms8H5KsqTwR5J+uf0E2G
         Uws8Ts77/ddL89UDl6dajoK+UwMCV4GbDQH77DWlepXQjVUGKSRjmM+BWWDu7AW2SZEq
         XbO7hhcrTc+RUjArcbyjPDxj5emyhlh6bn3zin7I/5tAkziPkh8QvVkptxRyB7cQVdsq
         G2GQ==
X-Gm-Message-State: APjAAAXhB44uihki4WyH5xRHGa99uqI++AEDEzsGRmugd2UTIcV7m8mi
        5Fwv9NsEgOH0EdWSCqL+6+yx6Hp7pItXmbdpDm0=
X-Google-Smtp-Source: APXvYqxLhrSPaDtNkdTFNC1d3ZAsLyZdGcyVekYpH9xAia0RfeIvgxznK/SATtlo/MkQohnnAvLNOrhfDgiB5K2eoJo=
X-Received: by 2002:a24:ce44:: with SMTP id v65mr4270596itg.146.1556830797128;
 Thu, 02 May 2019 13:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
 <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com>
 <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca> <CAKgT0Uc_OUAcPfRe6yCSwpYXCXomOXKG2Yvy9c1_1RJn-7Cb5g@mail.gmail.com>
 <20190502171636.3yquioe3gcwsxlus@csclub.uwaterloo.ca> <CAKgT0Ufk8LXMb9vVWfvgbjbQFKAuenncf95pfkA0P1t-3+Ni_g@mail.gmail.com>
 <20190502175513.ei7kjug3az6fe753@csclub.uwaterloo.ca> <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
In-Reply-To: <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 May 2019 13:59:46 -0700
Message-ID: <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 11:52 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Thu, May 02, 2019 at 01:55:13PM -0400, Lennart Sorensen wrote:
> > Here is the same packets as before with the link level header included
> > (I forgot to use -XX rather than -X):
> >
> > 13:43:49.081567 54:ee:75:30:f1:e1 > a4:bf:01:4e:0c:87, ethertype IPv4 (0x0800), length 174: (tos 0x0, ttl 64, id 21783, offset 0, flags [DF], proto UDP (17), length 160)
> >     1.99.99.2.4500 > 1.99.99.1.4500: [no cksum] UDP-encap: ESP(spi=0x8de82290,seq=0x6a56), length 132
> >         0x0000:  a4bf 014e 0c87 54ee 7530 f1e1 0800 4500  ...N..T.u0....E.
> >         0x0010:  00a0 5517 4000 4011 1c6d 0163 6302 0163  ..U.@.@..m.cc..c
> >         0x0020:  6301 1194 1194 008c 0000 8de8 2290 0000  c..........."...
> >         0x0030:  6a56 72da 0734 52f6 406e 9346 f946 c698  jVr..4R.@n.F.F..
> >         0x0040:  a38c 280c 94da 53e1 91e0 35bf 812a 4500  ..(...S...5..*E.
> >         0x0050:  6003 ca7d 6872 a50b d41a 5c4d 7c22 3fb8  `..}hr....\M|"?.
> >         0x0060:  56d8 2a0f bc3f d3a6 5853 682c 914c c1b1  V.*..?..XSh,.L..
> >         0x0070:  c5c3 94e8 4789 d8b4 4ab4 e5f9 d20a e5ef  ....G...J.......
> >         0x0080:  de1d 05dd e98a 996b 5c11 6657 b667 6af1  .......k\.fW.gj.
> >         0x0090:  2a97 694b 16de 74e2 f8fe 13a3 d45e e3e9  *.iK..t......^..
> >         0x00a0:  f0b1 b83b 99e3 55cb b40b 5ba8 9c23       ...;..U...[..#
> > 13:43:49.081658 a4:bf:01:4e:0c:87 > 54:ee:75:30:f1:e1, ethertype IPv4 (0x0800), length 174: (tos 0x0, ttl 64, id 44552, offset 0, flags [none], proto UDP (17), length 160)
> >     1.99.99.1.4500 > 1.99.99.2.4500: [no cksum] UDP-encap: ESP(spi=0x1d4ecfdf,seq=0x6a56), length 132
> >         0x0000:  54ee 7530 f1e1 a4bf 014e 0c87 0800 4500  T.u0.....N....E.
> >         0x0010:  00a0 ae08 0000 4011 037c 0163 6301 0163  ......@..|.cc..c
> >         0x0020:  6302 1194 1194 008c 0000 1d4e cfdf 0000  c..........N....
> >         0x0030:  6a56 28ca 4809 8933 911d f2be 4510 e757  jV(.H..3....E..W
> >         0x0040:  3885 7d26 5238 8c58 38e3 6c07 2f8e 335a  8.}&R8.X8.l./.3Z
> >         0x0050:  6d48 2a72 4619 e8a3 c421 bc54 48b2 6239  mH*rF....!.TH.b9
> >         0x0060:  5e07 7e89 a68e 0161 4e6a 5b6f 8b89 9f53  ^.~....aNj[o...S
> >         0x0070:  4c40 1c6c d159 60f8 68e7 24db 8b21 2ec2  L@.l.Y`.h.$..!..
> >         0x0080:  4b67 9b83 643b b0ac 6e2d bf4f 1ee1 9508  Kg..d;..n-.O....
> >         0x0090:  d1bd dcd4 74ee e4dc 78d0 578a 5905 1f4d  ....t...x.W.Y..M
> >         0x00a0:  74be e643 910b b4d3 f428 8822 e22b       t..C.....(.".+
> >
> > I will try to see what I can do with netperf.
>
> Hmm, maybe UDP isn't doing as well as I thought.
>
> Playing with packit doing this:
>
> packit -t UDP -d 1.99.99.1 -D 32432 -S 4500 -i enp0s25 -h -p "0x 00 11 22 33 44 55 66 77 88 99 00 11 22 33 44 55 66 77 88 99 00 11 22 33 44 55 66 77 88 99" -c 5
>
> I have played with the source and destination port numbers, and so far
> I have only managed to hit queues 0, 1 and 2 (mostly 0 and 2).  No port
> number I have tried has made it hit any other queue.  That is weird.
> Making random changes ought to distribute more than that.  And changing
> the hkey certainly ought to make a difference, and so far it doesn't
> seem to for these packets (I know I saw icmp move around just fine before
> when changing the hkey).
>
> --
> Len Sorensen

If I recall correctly RSS is only using something like the lower 9
bits (indirection table size of 512) of the resultant hash on the
X722, even fewer if you have fewer queues that are a power of 2 and
happen to program the indirection table in a round robin fashion. So
for example on my system setup with 32 queues it is technically only
using the lower 5 bits of the hash.

One issue as a result of that is that you can end up with swaths of
bits that don't really seem to impact the hash all that much since it
will never actually change those bits of the resultant hash. In order
to guarantee that every bit in the input impacts the hash you have to
make certain you have to gaps in the key wider than the bits you
examine in the final hash.

A quick and dirty way to verify that the hash key is part of the issue
would be to use something like a simple repeating value such as AA:55
as your hash key. With something like that every bit you change in the
UDP port number should result in a change in the final RSS hash for
queue counts of 3 or greater. The downside is the upper 16 bits of the
hash are identical to the lower 16 so the actual hash value itself
isn't as useful.
