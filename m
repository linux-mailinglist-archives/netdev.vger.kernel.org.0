Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1549E6F5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiA0QDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:03:24 -0500
Received: from mout.gmx.net ([212.227.15.15]:34297 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243305AbiA0QDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 11:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643299359;
        bh=fIkuyrPJ2qcQvVE0/XG6V5LSdSQxnvZjix0Rm8V+sY8=;
        h=X-UI-Sender-Class:Subject:From:In-Reply-To:Date:Cc:References:To;
        b=lCj+k2Fpa/dpNMXseP15pH/6rI+Nub9dOzRCmL2REsuaVaaHB/HIb+6+9+fc38PdU
         EJ0VV6ybOZ5AB+AWO1fWNBHsftYt/+5AAJH1prZaaOEI16uhPcAHubI7x4dVFQzcM3
         T83DvZPUs8k4pal/IYznFduU9/prShxqMF5Xscz4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from smtpclient.apple ([77.8.117.92]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mk0JW-1mXDyZ1YLI-00kKzD; Thu, 27
 Jan 2022 17:02:39 +0100
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [Cake] [PATCH net] sch_cake: diffserv8 CS1 should be bulk
From:   Sebastian Moeller <moeller0@gmx.de>
In-Reply-To: <177DD195-A9B2-4502-8DA8-7CC659EBBF3B@darbyshire-bryant.me.uk>
Date:   Thu, 27 Jan 2022 17:02:36 +0100
Cc:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Cake List <cake@lists.bufferbloat.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        =?utf-8?Q?Dave_T=C3=A4ht?= <dave.taht@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C50A8C7B-4EAE-455B-B27D-B6FAB13B1EA7@gmx.de>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
 <87r18w3wvq.fsf@toke.dk>
 <177DD195-A9B2-4502-8DA8-7CC659EBBF3B@darbyshire-bryant.me.uk>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Provags-ID: V03:K1:EJon41ZiItBVwz7r+GavifV7VehEDPQvoagTtnkoui4gwem1R+d
 1B3XqRzFgP4zW0taCSnapcRksM6EadcuInzheOMrMdsjtFP8gkzT2DjSOAhMuzl6TgQSJS+
 Fi/3QDFGvsqX4xfuY0jfLswsUfTIkcCfjhc8pXTIIoqorBB1OghSKNEpiTCBeqLxPykgJ/s
 v7DuggWT0qBSFxVZX5z7w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:00AESNJ0G9g=:oICfH6h/nABqDy6vLgkMDi
 oz8+n08Gswb/nh38ZvPinLpDFoMhG2EuZzXxkNA2j4lfsFF7ojDdLq5g4HMc9PnCHgl3GUNB2
 Z54Cf+Troz06jZU9fBOVy8U/lLbATVAx6EMrrRYfEnQYFcDJ2VEu0WY9sQIlWKMP0Yn4Dkf0o
 CvwdVMrBIu9F36fJLe0MeTlzrNSD936trIs5W6qL4jwCwFhckP5sbn8Kyns7Fzr/kS/h7y34e
 nB8H79ZG9WazT5GuJFl/Bgvoq+J6ALEM04xVkX//Xj7j9Uj/y8TBMap6gBjpJL3q6ehWOzF1b
 MzVTL9D0wY2vYCf42G5pBiD+PP2k1qSkIpETmxwNxFXAJ03b8d9qwzV8zl1njW/eTQItcYbgo
 M5Cppg2eRx282wn3TpFUPLnrg0L5rkAsL1ls2yC9vlt7lG0/lpSv3c7FGfCFMN7JK/hS5Ohqj
 iZEY7/Yye+b4A7GA/6X7Jb18RgO+YEjOi/J+gDysgepRSByL2EoyZoJO1xuOYXx6PaYlZbg+G
 u5bDBYaNQxB4+5IckpsFwUftWG9iODtxO/3+EbnWOub+5/8R3rfwuJcfXt6riks4jJranknyp
 MKqF4olRUrfRYtVhg+ACTNO4jzkEEvWY9f59X6amO1oVl1+i/cJAlsMBiW8TPWHA2E0jRF0Ul
 TLzvL+vI/L5wxhb/54Qb5eCMdKkKXARVX2mFdClfQL8ORfE8hPydDs7uvTC3mlNXbXJKeJ638
 wyy2B4IxpmUyn8vAs08BUdx6K/FNjEbuOVNtu2IRso08zlzdOpFbFikUbgf+xM+0v0Cm0e4b6
 4Gc1rB397A4Pn8ITv0R76rERvM98WPkhYwamO2rhapyfXC4I8upq47iZwd0SUpk+yGtN8NMhb
 y2eNJs0M0qycoi7ou9FxutcB8mzS/3eYIRKTqPC6qIF7ttrOczRpCkKeRcSneP8LFYJZ+smSh
 kCskVzcsnJn6IFF/ebe2XG0l4UViw7RLScKwFAqlrUQepZeqJ9VG17gRKpnvrcE6Gtdn6aICi
 fTbWmDFrKSaY1Vvo9kJOBXZMfyewMiymOocBn/C47s91WRWR0YZovQY9HWdSLQOzZHN3eht1d
 RUdZUbdp1MHXzU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 27, 2022, at 10:00, Kevin 'ldir' Darbyshire-Bryant via Cake =
<cake@lists.bufferbloat.net> wrote:
>=20
>=20
>=20
>> On 25 Jan 2022, at 10:58, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>=20
>> Matt Johnston <matt@codeconstruct.com.au> writes:
>>=20
>>> The CS1 priority (index 0x08) was changed from 0 to 1 when LE (index
>>> 0x01) was added. This looks unintentional, it doesn't match the
>>> docs and CS1 shouldn't be the same tin as AF1x
>>=20
>> Hmm, Kevin, any comments?
>>=20
>> -Toke
>>=20
>=20
> I=E2=80=99ll have to find my thinking head & time machine :-)
> This would be a lot easier if we had =E2=80=98diffserv9=E2=80=99, LE =
could have simply
> been added as the =E2=80=98if you=E2=80=99ve really nothing better to =
do=E2=80=99 class that it
> is.  And it=E2=80=99s why I=E2=80=99ve personally argued for a =
diffserv5: lowest;low;normal;high;highest
> moving on.
>=20
> I think I screwed up when LE was added to diffserv8 - Matt the CS1 =
change from 0 to 1 IS intentional
> and IIRC I tried to bump everything else up 1 to compensate.. I may =
have missed some things though.

	But that way, introduction of LE does not fix much... I really =
think with LE's existence ,CS1 should be put into the same tin as =
CS0/BE, for the simple reason that currently CS1 is already in use both =
for priority below and priority above CS0/BE, the only course forward =
avoiding priority inversions is to treat CS1 like CS0.
	As a case in point I remember that Dave T=C3=A4ht reported =
seeing oodles of packets marked CS1 in his ingress some time in the =
past, packets that should not be treated as bulk. Sure we can argue that =
anybody using DSCPs for priority steering needs to re-map anyways, but =
that is not the logic behind cake's default mapping.
	And that CS1 to BE mapping should apply to all diffserv modes, =
that offer a lower priority tier, no?


Regards
	Sebastian



>=20
>=20
> Cheers,
>=20
> Kevin D-B
>=20
> gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A
>=20
> _______________________________________________
> Cake mailing list
> Cake@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cake

