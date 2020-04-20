Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519B01B0EEF
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgDTOyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:54:33 -0400
Received: from mout.web.de ([212.227.15.4]:54757 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgDTOyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 10:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587394463;
        bh=UJVHxAmciaJC1WEEAZraT2mAU41uAN7USj3F52poiOU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Mx7wSGW8XLxhahuByFUINKOTH2KmT+ISt6rEUaWYSMDGhBIqCV5u+svqYQX6s0EUw
         yamJ2vJ+11Y1dBMrxUODQdRBXn0wvb9x+Je5AtvvvyGJvLFVQjgKeDgFl6G9KOEzx9
         FZO16e+T0sKYQmEjYtP6HI/c45Gv2ck8iZB6+TtU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.153.203]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LnBD3-1ijDhi1MU9-00hJE8; Mon, 20
 Apr 2020 16:54:23 +0200
Subject: Re: [net-next v2] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
References: <20200420132207.8536-1-zhengdejin5@gmail.com>
 <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de> <20200420141921.GA10880@nuc8i5>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <3fd53b73-87b3-b788-d984-cb1c719f9e7f@web.de>
Date:   Mon, 20 Apr 2020 16:54:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420141921.GA10880@nuc8i5>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:6LjBIEqGWOrI0faVvSxg6RrHcqv7h8eO//Qc2CbE15tFTRHq1g8
 EfBBdvCX4lG5EtKijUHu3G4dm6rE5ZMM3p3oveTT3eAuP35Dn6IhbaTpC2k9cZZGFw5GlRj
 vaa2MBO5pju+J6vlBYthEm9W3vT8+I/3UT8ZGUJHvo0sZY0hHuFCTsVSyGtHGX6mwE6hWA2
 BOo+kkFZ4kUkLPGghe8Ew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Yv+gJNi3LUY=:N3O7zQDLVDXj39ORIcl5Fw
 wCuRc2lRRjvfhZOnAx1uQ6H8yfVvsoKqJCUniriFSt1azi89Gw5WXu6zLoiOlM+M8uRU+UUjo
 UywAjtC4yR04QAthL7N2H4QGjBVLRYIcyY0En0BdE3JLBJrUKZM8PZjs/PDaji0g6Ry6ieEOI
 ILWnu+t8LCxmB6w/BlSH0YprWaevrZhMIe/+jNIg9dehPkyYsnevHIxOHy5ii4UX2eXonzD37
 TN8DFOtj3TUFsKwuwzYZYRXavHoH6hSdOGKn+HB5ZZuk0PtJcWy76JClY1JdHnhfy5lf0XmfA
 ZY9o0ax/7rH6LAqnjvNimOySZaLtJen2582nu908B1APdFd6Olw3PpBgZIdyCUJqAi6O59OOg
 XvyCnRRbR4U/1qEtzU3WHNWP5K248yQEQ9aZsUykKoLTJ+XpBX4xVeYoJiljLRJHxwnO+12PH
 bRD6qOZzaPAPU6sY2BIHw07IXDB919JBiaVozqf0VXNt7V7hSoi1dD4ADXJYQrQUPvLZRkZTW
 L9voI4tfrT7P+W4hd0so68UvgZo7dcAL8geg7/BsvfxllHjP41Dk8ywXGGgsiEzpX3HYDnebK
 HaX3pk4dFCh9ryjoIUsStHbya62FBMwY0b3AQgq7lyGv2YJb8ubu8+dCZeOlU3binQlh1CS/g
 WtM95rt2BmY11mzPwAyS7swcYAYLsBRMhB+OzDwYtowZIvE/VgggnGsYqv5suFooB4BwN6cgl
 /du6IFi0kYKQpuzUqRO9uUkCW5xr0XcCPkCMllk26DQ6GcDafyM0ZD7sPT65ERaXNWi0ESadx
 kti4zVRcvsYb+vK7BOo4At2rd7OuWnEvdXHTgt81NJzX+FdeghPDitxDwY+nUw7i1y7fh/vRT
 zGlcnnPL6YtIulx7ji8o5byQD4T66DS4LqnYSC6HiWSa0qJbftENXrZx2rrj2PK7yJhDOE0kM
 93FpLep1tm+P7Ac6fH+UPlDYF6fZL6laaJM2lhX91froPfr3tegpGDFgXRc8mD+b5sWA64Dho
 IJJqS+sWNqNcD0yQf9862cSR5Q99VjM7jpL6U+fg2VL64ZNXrIhKQWv2ZtUndHM982l4JTqe+
 KnOHfXWLCJPjtLlV9yD9mm8M27HrAm5pN4Gcgt0NQGkDM+YdCgLgvYjwRfkdeH91MibN6IVEB
 8AGRgmSZbIRSxoqg8M0DtMm1AA57W49aJK5ZrND8o7jsuKqOj3RZquZzCpYf5zXwrEYkT63fC
 CjGAO5E1lHkGJRsXE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Example:
>> bgmac_probe()
>> https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/net/ethernet/broadcom/bgmac-platform.c#L201
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bgmac-platform.c?id=ae83d0b416db002fe95601e7f97f64b59514d936#n201
>>
> Markus, Thanks very much for your info, I will do it. Thanks again.

If you would use another script (like for the semantic patch language),
you could find remaining update candidates in a convenient way,
couldn't you?

Regards,
Markus
