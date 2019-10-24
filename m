Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8747DE39EB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503794AbfJXR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:26:04 -0400
Received: from mout.gmx.net ([212.227.17.21]:55403 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389384AbfJXR0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 13:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571937941;
        bh=KY68C9Yu5htKWu3Gi59bYPna7hMIfwfzLjRCUgSfA84=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ba87kEAdPGHzcF9yZLUldTeAelIG+B6EH41VfPWNJBP5pjil2oyErGHZPmPojmMdZ
         AeGv281bxMW4mAWNkaxutopdZuI7l5mubwgYKvZuzTfgyp7HQz1PF3ll9efTC45W0Y
         5i0JHhTDJ7lTDTJbsmkhhJ0e2HIjvcnzINtvFWk0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MK3Rm-1ij3VL0mVC-00LVdz; Thu, 24
 Oct 2019 19:25:41 +0200
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
To:     Daniel Wagner <dwagner@suse.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
 <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
 <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
 <20191024104317.32bp32krrjmfb36p@linutronix.de>
 <20191024110610.lwwy75dkgwjdxml6@beryllium.lan>
 <20191024141216.wz2dcdxy4mrl2q5a@beryllium.lan>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <78ab19da-2f30-86e0-fad1-667f5e6ba8b1@gmx.net>
Date:   Thu, 24 Oct 2019 19:25:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024141216.wz2dcdxy4mrl2q5a@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:hjlWqLnBbTZvsRMVvhS9+KeBYXyxE0wxS2hKJr3tZpXeXnUQWSG
 52b4hCqDmBhPy53d+ftQ4wk08A/dNzBCP033Q4y1jRMHjsqc2r+tz1caYLeZ+vaLzy4tkbF
 x2+hULAO513/i8B4DU/fRSUQ7Az4vHZQ3WJekcgrWjiQ2qzFT18+El14i15TEg9v+wZlOz2
 OCdt/JHCzN6CW2RMawymA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eG/2jn090SA=:jlq9kslPHqyYUttM5c5zip
 oDhA/ZDnF2wu7OMPeFDpb+FTPw7jnSTTGeemYZxbmLM9BonU8Vo1k2d6vZWfur6trpuD7MvGt
 Y7Qr+j82KYiLB0POZo6NbRr19Kzl05xk5s9WJvTBElPX1VFaC/ty1VEBdcBnUCav2eBK0Pm1e
 X1inHueW9v+alntHNx2M5SEqfgbZ/XQUGYJfEBw5VbY4OkUxe+FE4NG/B5dRG9ewT/o00rSUj
 zX+wTbPRg5O+loHXcnKYDSjBWKwzYmObrv0aDfFvVSz4leSq0gYFJNF2YrtVGVMrWVLbzma1u
 h/52lkoGhyUWVS8B1dmjNsLLtE2Eh9qB2nPnY4QhTZm1zkeGpO5o38IMLeRf/xTteClBdr5eV
 9CFSHdDLq7Q84TANLjw+Pxto1n0PkQoj7fI+04FZGA1vcK63/A5KK29Cj4FJfzRb9tiA3hars
 etmOP844lFdsMTOEwF0479spzMfn07fASbdSLZ6U7kdw6HIKAoiVSLfjXUeWJqG0Sp286WLuI
 fwK8Vj9qltIrJwZzd1PvD+JeaN3DEW8bexq5SQpksvMMiL0uspIKDQ1UFdbt4xqMx09THzqKf
 b6JWU2+5rRand2yaWFAS5bj9VVSLs0SQOsl1S6B4f0GgOqc2gh2Oy9goOGQgmj7l+Joviyddy
 FfgzL5nuEoftl8PgaEjOM5G5KSGj1nbOnlUk/vjopLSOo5VwaZ7PIfm+ReYUUyVlf2pPqp/EQ
 DSIkttdQlBqIjYxvI2YUPgRQhyydSpcuv0BCMzEgAKRQekC7UoTJyN8eF8kxwblf5ZJu95QgE
 E/Mie8G1Vq/ohm1+rvkJEdEpXjjGbDktnFs0USTpRiYZiBzbVBOEiEEx5GMApfTBtBjmd0R76
 qKWQFcD/0aG3P2bkHcz9rvWDYT5NeyC5c8fHvomlCExrMkn+WhBFlTmy2hwSVSRsoFJIoAynf
 SSBs66wHHuConiLYJrJ4zjIPugIuEp7WUA8Xk1Ty253HGbhIhwxBeRicoY0w4/eEohnW5HxkQ
 OM9h2oepH46A7Sal0ca29e7AmOcqQNfMKb5TvGC5Vxm7WBcLgabiyuZf5/u7taioa3jBktZ5y
 x9Kf6Iq6rK30bpfqJ/4D+n3jFjn6rpi0l/5SXYEUlLdWU93GvR7KTusoL//0qdI24jqZSTr1+
 FXj3p5wB2OKGcdqH3LFtNoDb3JWvtxJS6xTY2sb81Ek/udv+irkDaUtzQsbgWqV7et9ptNy5b
 gioi/Fd8uFqLXxkIE3CbVf3u+oYRqvcI9EGJts7FgYCsMorohrHLgTzYV1m0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Am 24.10.19 um 16:12 schrieb Daniel Wagner:
> On Thu, Oct 24, 2019 at 01:06:10PM +0200, Daniel Wagner wrote:
>
> Sebastians suggested to try the RPi kernel. The rpi-5.2.y kernel
> behaves exactly the same. That is one PHY interrupt and later on NFS
> timeouts.
>
> According their website the current shipped RPi kernel is in version
> 4.18. Here is what happends with rpi-4.18.y:

No, it's 4.19. It's always a LTS kernel.

I'm curious, what's the motivation behind this? The rpi tree contains
additional hacks, so i'm not sure the results are comparable. Also the
USB host driver is a different one.

> There are no NFS timeouts and commands like 'apt update' work reasoble
> fast. So no long delays or hangs. Time to burn this hardware.

Since enabling lan78xx for Raspberry Pi 3B+, we found a lot of driver
issues. So i'm not really surprised, that there are still more of them.

Thanks Stefan

