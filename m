Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6354622D675
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGYJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 05:34:49 -0400
Received: from mout.web.de ([212.227.15.3]:34165 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYJes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 05:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595669655;
        bh=Kj3oZ4EgTHrR+Lvr+Sok+oFMIgscXBSVhrvPe/8tZ8Q=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=W7Q9VAlQ03O1B86BFbq70vBSxE7liF5PNjpfIyWqR1NKWG4FwQj/gSvNk623vvDja
         t+Su4FzG+Mg0aDuj64KUASsfB5W39gwHvL8oTvjDGBJEqcvOLFQnj8cVXkPrQnbwdf
         6DTJ1B8axz0oZcpJTodMyBwfr6R2wtfIkEwr6OwE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.94.55]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LxfMB-1krAsO1x8d-017D27; Sat, 25
 Jul 2020 11:34:15 +0200
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] ipv6: Fix nexthop reference count in
 ip6_route_info_create()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2ac42db4-96e1-298d-4100-beb95d7c91e1@web.de>
Date:   Sat, 25 Jul 2020 11:34:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+h8wOo0FbRr46y1LIu6DKaynMOJ3U/OD1S9iSv+DzBBY1OBgacP
 /0BJpdyF8QFGPdzru7KUSJ9uTlkKjh6CeT7ACWg5YRbx/8uvu60SFZpPdurj4nnSDmL7ANm
 eEPkkYtNqzbOwdkDTfHaHlq9m9+MPi0+AEHpzNH1kcw4tMhrNvFoudY+mja8id8MoRspISL
 a5Kd1c9lrfYC3MSndA3Kw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xjHCEqUK58w=:xGmbkrmfLhu1RyxK2wbfHG
 wj017R0zUIi9PV9FKsokcbimIeT+tTe7IytJVljmsOS68hwWSxEp37GGiE19a/GyBuVwmodo6
 3edj3V4dUazGVY6Kd/GA43ox4t9XCcpT15lHysjoegxO5g9aXTxAz3ULaeAZ4UEFlTdxkQdMI
 kon7N6Z4uXDtAIV1eYKeDGg3XPjqPuwEdqF0S5SO50u/YiU7fLhJ9RvO5Nl2VEV1eowOboRzb
 WLTrCb1wL1QXOlYrLabo/2GooD65OjNISR4TJ5wmFzxa1aqsXeTZuTpm8KP+/DIC7RSywyJLW
 lHreXgICjUdmNVLn2sGfqEKZ4rLYouaSwQlp1TAKaW5tsIFweWAoejONIJPnNO/SV0cawok5v
 RsLQ+uiHWK6BimbmuvxPU+8C7rpRoEMay6gF1Uodi2taG0Nmrb4VDgDWmarV1zcEgEtAAFQ0r
 c/hsnYkoVWMXUkMp/iIuYYj+ukMhx97uwAZtvggSnxKcpejGCY2hmIV8xl189pnd0nJzraBnN
 8lWzoNqBv3o4C7q08Jt4Lte7LOXut0rzZR7XfjDZBMq0Fkm2KR+VxddAnciMgjIXxwECUYVJg
 0eHRTGfMkjJDMuvDu7gQVFiStNE5D4g6rETt9cDXN2BUFZimiJigSwknKJ/jsn3Y4FaqZuDbQ
 gFfMYByrcHWEhhVl6Tn6WzVUv3B7irI5ilqoXDCrycFbKViUThpLqc/D/lIovke1M5DpPa+Zk
 d/OrdLQpJX29QukxSf8yTaJ49dwb72gWvrs19Oh5dbBDjIOmmFugBfHJDcM8CFEesi6itP3oP
 0eNY1ntZDcVWD+w0A9hsVd9/hZVrSZJgBe029RjGhHUUtqGPPzw9zcy5hxjDKo8qGPcFh+VCp
 BkrG0ccLWtr1HwKqbzlAbPZUfb/TCJ38lfT7vzhNwDcpyVjVCSIXOL+kclGBFAGrR5aAmCtMd
 AKVC2mqurAI86fVvbDwTW3vAQGZxiFvOU/CjOSdpexZHODugL7Z6+4jfut+cDo3sqLlTJlCei
 R6xB6fyr+lnEtNsSubbnvybB5DqswGqwGzgliReGXPWmHVJoH7sYjsGg4R/7P78z5TMPK2v0e
 lzvf8IjM0TRKe+TxcCwoEo/kl/t0zoBgYqKOHVM6iv+kvFooA8Unhn2/f7v125HT3CtWwXU9Z
 79XURu5rLeHpfrcw9vXpiYh0P4ssP4/kpO+YE80b9pehynH2l+JYPnOhYDzXwRX2OmSCyNq2D
 VaDtHA9rL6omsFfijIBTZe/tqW6JqqA01QgAi6A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> When ip6_route_info_create() returns, local variable "nh" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.

Can it be helpful to use the term =E2=80=9Creference count=E2=80=9D in con=
sistent ways?


> Fix this issue

How do you think about to replace this wording by the tag =E2=80=9CFixes=
=E2=80=9D?


>                by pulling up the error source routing handling when
> nexthops can not be used with source routing.

Does the movement of an if statement according to the check of the
data structure member =E2=80=9Crt->fib6_src.plen=E2=80=9D in an if branch =
really help here?

Regards,
Markus
