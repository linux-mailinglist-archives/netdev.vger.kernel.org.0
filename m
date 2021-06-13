Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1F83A5A04
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhFMSfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 14:35:48 -0400
Received: from mout.gmx.net ([212.227.15.19]:47127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhFMSfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 14:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623609211;
        bh=MQseig5tFaIs7XyP57Ofm/Ey7EBnz8UVR3sISIhinaY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=c+FL3PQqlRXDWv1VRW3uMAQhFEvhVGubgOMCW+c6w/r7WSCbQ1zBnFI3sVg8Dysjz
         Tqu7gLa5e8F4WxZvc2zBQJQWyOLBYPL8rQaqFUpq5kGIP4pQAIZl+MejWHBtgmRuJg
         UkRRy8MKgBCMzkOA0STJaqQHDT0Sx9WPrk6jcEO8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [88.130.61.210] ([88.130.61.210]) by web-mail.gmx.net
 (3c-app-gmx-bs04.server.lan [172.19.170.53]) (via HTTP); Sun, 13 Jun 2021
 20:33:31 +0200
MIME-Version: 1.0
Message-ID: <trinity-87eaea25-2a7d-4aa9-92a5-269b822e5d95-1623609211076@3c-app-gmx-bs04>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Jun 2021 20:33:31 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <a44df2a0-a403-40ba-3312-c6eb53ddf291@posteo.de>
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
 <f9d008bc-2416-8032-0005-35d7c6d87fc1@hartkopp.net>
 <34cc6b6a-6eb0-f3ce-1864-9057b80fab9e@posteo.de>
 <trinity-0d8be729-1e3c-452c-8171-962963abed0d-1623591348277@3c-app-gmx-bap71>
 <a44df2a0-a403-40ba-3312-c6eb53ddf291@posteo.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:72QZUHTqgv0X1VMAKMyxCIB0dcV//n1OARefLbxDgahS72wpWxd+xqpmGKZr1bTmVJyPK
 NjaIvZtuzp4U4Iq6rUYufunN6GWvgw2KYg36N8LRUOjERKGZCFN/iXXPSKAy+Nym3dPcPK9UJi+0
 2RSrEusYx0AX4NGmljiwwnu66XQ/9eRDST7DJN38qA4AflqRsB64tANnBaSZQqc2wa2To8oeByGf
 01rgvSXFKtCXR7IOM9WpJ7gKIHOWTHIuAk7goDQIPGSP8vlWKmqm8FprcjSz9MNrH23N5IZXCn8M
 R8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l6TsaChUdpk=:6r2pATKbEVjXhO7QU9KAs5
 j1c1tCo1HcLhEarn6lyj7Rxv5bSbOC+QUzL2U7BgfCuyXvZzyPn9TigCAM+t5D9z69TN12smz
 vMAnnS+E+CiC3+YDr8BDO831n3vN0ZVgBHDRLPFgqgf3sPff0CDGXtEFdPXD80if0A4WND1tu
 xKmL+9D6kV3teWSApmHV/Y4iBWg1antHuhasKEeorTy3a3Rc1wwUUb0yjrEw7DRbEcEGxgaQU
 8uYkT+BhIn4GQUkaqXjIdZhkzQVJsBWxutdkpCL1dnyisNdqYtX7fxBl+oy0iDhVO5ZNIanEx
 IuFvJzhCSjr3aiUxYvoKACDxwneVnZmHjE7TyQHfsv6eRnSrspDWR7618XOiyP/Qc6PYVops3
 WhU/5jhL1NnMluknrlRd+LYeOFVktEWgpK2rdhsKLFmFk3VhzkxpI+1vfCBp89jMMmbfwtL0j
 iJNJFrpthG617oYedFprwmq3xn6C4KXOHSY4pJ67I1aIw0dk8TQG+ka8K337uN39V0yrrAP52
 0JGTiBLDcZ3roFXPYNnEK5P7wgsRxIm1oFubbK3RVPf+DIy9qpiMPSZrq6gko6JqV3yAsQ1fJ
 j42SupWKg4KqTfteJa6zMI3jCkF4aJxValgISAm4XxArKqL+bpHfRhjhh4AYZXzPFBe/LLw/O
 9oRfURzSaI+n7dmVRqDQ3n6+5zRQ4KMe8psp3HQsejiVLuKB4nRYGbn2zSsavnvaRsNlD8Eh8
 Ida/PQVyfmK8EDy7OaDx3O/BIu7bHxvjimfUDiC4eO/FGmOHd9fU5cTtiPfjgdHD8bH+CUwGf
 KsvUQOrwCyvGDUe4cMLIdNjH09JkQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Ouch,
>
>I should not skip lines while reading.
>We're talking about different gaps as it seems. I didn't realize the gap
>in front of ival1 before.
>
>There is also a gap in between nframes and frames[0].
>That one is caused by align(8) of data in struct can_frame.
>It propagates upwards into that gap on 32bit arch.
>You can find it if you actually fill frames[] with a frame.
>
>I found it while concatenating bcm_msg_head and a can frame into a
>python bytearray which was too short for the raspberry pi as I forgot
>the alignment.
>
>I came up with a format string "IIIllllII0q" for bcm_msg_head.
>
>Kind Regards,
>Patrick

I confirm that there is a similar 4-byte leak happening on 32-bit systems.
It's possible to retrieve kernel addresses etc. which allows for a KASLR
bypass. I will request a CVE and publish a notice regarding
this on oss-security where I will mention Patrick too.

Anyways, this patch seems to be working for the leak on 32-bit systems as well.

Norbert
