Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5FE626D
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 13:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJ0MPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 08:15:09 -0400
Received: from mout.gmx.net ([212.227.15.15]:57777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfJ0MPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 08:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572178483;
        bh=hzFiu0s1u36lbFL+Sm9oiww/ZbzJI1xnUJXEm4icdTo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BW1zpR5Ta7ncnQqOvekklsntEhirIr3KAOSW4A1k6viRfqDhznCRywCckhtCrsSRY
         yXOszMhui/P0zQDkJPYy9lHJtQItD6tMmZd59UjROu5MBh3M2RKwGSYA5j5CGNAGK2
         iWNz9V4NmjVHq+J6MlbLmHFLdp5QzAwXS5kUL7DY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4zAs-1hxAjH1PAS-010qGa; Sun, 27
 Oct 2019 13:14:43 +0100
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
To:     Daniel Wagner <dwagner@suse.de>, netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
References: <20191025080413.22665-1-dwagner@suse.de>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <46b35c32-4383-c630-3c52-b59bf7908c36@gmx.net>
Date:   Sun, 27 Oct 2019 13:14:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025080413.22665-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:v5mliJ6wThw2tCSLVO1SujmRbc7WST509PmL6NPAFGOCl91mn0g
 jNStYQ+eGPj6wJxQjHQ5LtN/PPobbST2tTkBAusWDg7ybb4EqFqEm4a1pyQaCXQOQHd11ey
 qIXVnd41DoYn6wQS0J8cKkYnEYkpHLiB/ep1+7NjtY6HtHzoXk4VHsHgSUsUzmzkU9DsdZC
 826JCv8X1iACsy65Cf+Rg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yATG3UeRTho=:pzoxsdOfAetcRZpiMmoqvp
 Wwn5rj6pv4xPdBlSUOZ0fLxCkfwRX3dYFyNd0NESSPLANMWoEe2kXXdq6skOEBf5ZFgreaJBL
 D0qxWhf70A2hOnfE2V6u28uOAcpU5OYmSySUogUnil6Z0OkA8IquWQ4rBTfcyDUv0KaGyAge9
 GVtqDzMpP13dTOL4THucv1kBNAReon4w2aqFHAWF3vuVgWUUzczWtBhxg7Xb6F4wlXg4i1MC0
 0Fjn5DCZcmj+uH/XwGfRwU1Yapogm6upnslUEcnXCP2OnyiE/Jr7m+MFBUFcBeVzdhy6/cjCj
 Od3czv8t9YMwBZMlbsCV+aqbNt9m31yloWjebnpZuWt6k6OkfIgdvxRriTAGt239jaAKRAp3Q
 h2Z3FhHIhZctAItslVRY2IfckA/fk8DchXZq02gtV95uTrgmQMDdobKdeEzgMKRsdGXCNlIlZ
 iaq2x7TaDDfe6i4Wc2bP3qiukBpqEVWATav4bpm1Wt0gf6SWRFGxwGtjioyUstKFirhrVJ4U9
 lhIVfKmvrIR4PRH66ARDXr2+oQ52S4Z/0OdOletgMWwfV80+L8cA5aHwjQYotP1mbL4UBsvpE
 cuyOUlngv9cGiiHkPg03c+Vtl0lEG+VhX9c3B+JE2dixgfPAXYUkUuOrzxp1vC2cn5NMJxLNZ
 SMgEubzRwPB/1Cr877RzY+FoHs5Iz6gfvbKzdOnNbjfk93SYYtYIC+la+XjvqulCWtjC24thQ
 o8GJfQ81xKCSh/ziusBFOSVoFxBLnVi3KmM8Ltn2BP4HPKf//fe93AvR6KZVqgGqCiDRBQe4O
 V76j+vnJTgAK0X6l/JDTcB1ckIPI78sQkqV2Et2sQZsqoYA/Lp/CPZfRwYUcCaRIkZkAz38GY
 lJXHhpIbzF4adaVI1U3E9ncy0/VnpOlzruhlK7gDb4HzQN3q4x8azJFHzMdNgamGBNrhmh3SH
 /kYvqPeNt2YHB/l9ieBu8DX73o5WENIxV+oFoH+a/URhsQrzzRGcwFw5snpuhZG4Npsyeq5dK
 dduKqWBHCjNCYy60rEVu5vOz6kOJVvJexkowK2iLwH5tLXwT8ZS5Irx1J6y9pQT/56zlzIriC
 QHGCaKBqVGhiUx0DQLGuxrvqKsJkjAeN7TklEgapHh1OEICKsFIsS+k85EHJ4lQsf0K6YQutB
 yTL4oCmJsyU6tmzWksmq5FQjf4puKKhO6ZWTJ0j/kjCMDCW6FuH4VCdXA6gq3KfKV6r9VaDYA
 ohon6T6zQ9PWvQzf6ql4PZLXOY3an4ARZGQ734QCvJWjb2/Z9rZmhZe1q4QI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Am 25.10.19 um 10:04 schrieb Daniel Wagner:
> ...
>
> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Stefan Wahren <wahrenst@gmx.net>
> Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>
> Hi,
>
> This patch just fixes the warning. There are still problems left (the
> unstable NFS report from me) but I suggest to look at this
> separately. The initial patch to revert all the irqdomain code might
> just hide the problem. At this point I don't know what's going on so I
> rather go baby steps. The revert is still possible if nothing else
> works.

did you ever see this pseudo lan78xx-irqs fire? I examined
/proc/interrupts on RPi 3B+ and always saw a 0.

FWIW you can have:

Tested-by: Stefan Wahren <wahrenst@gmx.net>

for this patch.

Regards
Stefan

