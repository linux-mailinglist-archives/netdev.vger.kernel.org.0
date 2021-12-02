Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C9D466AE8
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhLBUcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:32:50 -0500
Received: from mout.gmx.net ([212.227.15.18]:42781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhLBUct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 15:32:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638476962;
        bh=ZVWw8lnrOIDf4I/NH+xL0MSPheAEx/mApVEL3wsHvW8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=BaaPKMbR2c2itzzFX4TSUrGsRxS06oaqqRL30edb+kSSdL+iOKuLYlIDXjkq11ua1
         9A7FefzW4uo/mX5UVXsXe9ny6UWO6ov/PBnG+2msH074fjwXEqqELkBb7wxcGGCHv6
         eIJOq4qfVtUlnt381flUFn8U4H+dM4GpVNOryXmE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.59] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbzuH-1mIzC23BUt-00dY4M; Thu, 02
 Dec 2021 21:29:21 +0100
Subject: Re: How to avoid getting ndo_open() immediately after probe
To:     Arijit De <arijitde@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <83adf5a5-11a2-e778-e455-c570caca7823@gmx.de>
Date:   Thu, 2 Dec 2021 21:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eF6RgdqLmOiXhpgOho9ulJle7yhp8IiKSTXH+hWRMhGCOvNmZ82
 CdXCrZ1EtBzX/swa5Ehh2wwZPAC31ZLOrSJpooaRg3o75/pgEvzR/WLSD1t2749WzWqM+jf
 6M2SuBduw+dEr2ZeVEKEgkeZ0iatPNaH2Ku0Vgn8TAbOgHMxux+qPdFp8BzeXCtC1NaRfSL
 eAEPKSLEeQNbb0ElBSNwA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5+W9KLE7gQw=:pKyQOwNmbrcnYLaHBTpxU2
 6I9Q0ldcJDXEvJ/rJ9gxIhBBY/iwD4eFleOCtL2VclZ0QsMgatxs5zvyJS3ZJeKMifjSryjSR
 n00Ucikpm2Ld7d89tDrbeyWVeMb4gc43fort3nyF57VTt0EvKGojmjxb5cJlX7kJlq1J6fWyd
 7+M9WGKOw9cCzUrEXDuVfYmUpViNOgb9LFnk+lENGjJPh0SSwhS7zBS7itYQVJMbt53RNTvCk
 Er9jIWF06ZYjbQ7UiSxMiQMRrklpcFZBeH/APLAIddAOIIkbvifdSN3ytvMjNurxSBtBFBaZw
 z4taEYB/CxG/IfOk6nQBwyPPiFhaqlhEO5Zxp/bE0wh4GtycClJJKMUAwP4blfWiBWJfH8+Jy
 f4lYFnUdOCECqYKRNFyevReduVNA3JLDXEv7sIfnHk8evyBQQhnWbnBtjDt+Of+OqQ+f3Ks6n
 kHoNXFd8fDmlXZo7Xh8Jn8/RIPZyRX8TKMQe5W+yG7UPEx79o6gW1iqw65icszRM5YMfQqsZp
 x3LKEDbGGc1DqRgJHj3iQUpsTEPldchj6GEldXYc/MXgta70pbYRUyXUqP+F0q2YulT8Lfw7Z
 iUxqgff2r+kwEq4PHrvJVzZGI/nNEeqE9zsLQFu2YHLRC9PWijWjarl35VhmZ1ltjI/oXpe8f
 L2nDc8ATbVvZ87XMt4JfgduLFDvONSIHwT7vswj2cTFLk7cUVyyQnklvNUsOO2Q2sySjjgyVG
 cBhPBOaT8EGIIxoNhT8qVXnH0VJ8vTVSCB/Nu6ZmRfjsGVf/lh7ZUcAmo7QZdcvbegPf5+fLH
 ReMgfO1TK7cRzFR+uKV6RKaSfrQAiYc0fKUCXMR8wcpDydbIF9tE7yO2dwwyziGZm84mC4IHy
 oSikpmrt+3SYgKtQiJpcLSBY/PPXV9JLmxtEyTEdHmZzlW+ehhx276462NqLSobYcj3MRAyiQ
 pFkINy4Rw+2wXN7dn81ENO1i3R5FO3+5PoB8Vj1YnUoKhWdEA9150KqRK4V5Ql8Yf3cjzsxZT
 mQssR6COCaugxYDfMzRMGQXDZiB6rMTUGLzQsTobId24xIUOXyJv0iOzUp75vENT/EuNtoncx
 8eNdo4JQqFfm8g=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On 02.12.21 at 19:11, Arijit De wrote:
> Hi,
>
> I have handled the probe() and registered the netdev structure using reg=
ister_netdev().
> I have observed in other opensource driver(i.e. Intel e1000e driver) tha=
t ndo_open() gets called only when we try to bring up the interface (i.e. =
ifconfig <ip> ifconfig eth0 <ip-addr> netmask <net-mask> up).
> But in my network driver I am getting ndo_open() call immediately after =
I handle the probe(). It's a wrong behavior, also my network interface is =
getting to UP/RUNNING state(as shown below) even without any valid ip addr=
ess.

There is nothing wrong here. As soon as you register the netdevice with th=
e kernel it is available
for userspace and userspace is free to bring it up. This may happen immedi=
ately after registration,
so your driver has to be prepared for this.
Its absolutely fine to bring up a network device without any ip address as=
signed.

Regards,
Lino


>
> enp1s0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         ether 00:22:55:33:22:28  txqueuelen 1000  (Ethernet)
>         RX packets 0  bytes 0 (0.0 B)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 252  bytes 43066 (43.0 KB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions
>
> What is the change required in the driver such that my network interface=
(enp1s0) should be in down state(BROADCAST & MULTICAST only) after probe()
> and ndo_open() call should happen only when device gets configured?
>
> Thanks
> Arijit
>

