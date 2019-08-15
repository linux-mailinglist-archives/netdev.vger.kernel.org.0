Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6978B8F370
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbfHOScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:32:20 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39759 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbfHOScT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:32:19 -0400
Received: by mail-oi1-f195.google.com with SMTP id 16so2950593oiq.6;
        Thu, 15 Aug 2019 11:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zr7m4pwTZtuvjpeiIC/jYJKmr4TJLJV4XhMln9ZPv+4=;
        b=QhoIDVYdejOyWyiUAfCz1XWolONEWbCa4OOpGFtUQnKIGhnLyEC0/WGR5DefUSe1mR
         i3zN3r2Q/fvJSZDwrKzaRdvzv43fsSPU0X21BNHiS2Yqh+NKiqKBv6Ii+RH2I3llRllE
         byC/IWheGYP6LEWHOEThfHTWTKIJJf+uR547l94H3w3AmvHSXHgGTk25MdOCZrvH2vOm
         xHVEnRuf1yAPoEGvBmZTWcabaDcqGkwohIXbc60Uis39tG3aq01SVHfE16g3nGRTQp5j
         fFt/E1AjMR0bRMXf2g86K2ujhMJd+JgLRDunGS64polTLVj9Z+V7jNNFV0rN5tUK+OI4
         jJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zr7m4pwTZtuvjpeiIC/jYJKmr4TJLJV4XhMln9ZPv+4=;
        b=mRk2Py5RXG0x+J5XW4uglBrbSbg6w7YZi9/0oskyu+QClR6NckM6uY+xh2RN9tNWJ4
         DaHoU2lYVR26VuTzaL3knj6gqIip/Xh0/rpMTlLomiNGSAbRQrdl0GndLZrfb/7UJvjt
         6Cy3GdAJnMlFfikMepXq8IQFDANqXU2nL2r/sE5OW/bHhBLLZmRvcfLq/Q1hd//5y9Fy
         0T98Y2UP4Fah1loE5P+WsmiTQzjfrJq8IPrZNP3N4tmWg3IHTaW3gQFlLXEqvBIPnr6n
         jXfeSnyPNYa/VGlxxC/2wzZbQ2V86zsROBQaS4TnCvqq7b/DkVq5UkPGy6iAaKYqAt8Y
         MPVg==
X-Gm-Message-State: APjAAAWM64D/q3FyD9DFamwKmlbXeV5/T+islOhyNL3i9ObIGMKzjwhz
        LQKUOHVK54i4UoyKlXNPT+Jvu0NiI5Q=
X-Google-Smtp-Source: APXvYqyUNRL91dzBCJhtveiCufmLdZI/X5yNhmzj2dzOWTVqlPUlee32crL4pNFIQyUM9g4pdq2Yow==
X-Received: by 2002:a05:6808:49a:: with SMTP id z26mr2630733oid.177.1565893938759;
        Thu, 15 Aug 2019 11:32:18 -0700 (PDT)
Received: from [10.15.211.16] ([74.51.240.241])
        by smtp.gmail.com with ESMTPSA id t81sm686205oie.48.2019.08.15.11.32.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 11:32:18 -0700 (PDT)
Subject: Re: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
To:     Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     SoC Team <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
References: <20190731195713.3150463-1-arnd@arndb.de>
 <20190731225303.GC1330@shell.armlinux.org.uk>
 <CAK8P3a1Lgbz9RwVaOgNq=--gwvEG70tUi67XwsswjgnXAX6EhA@mail.gmail.com>
 <CAK8P3a0=GrjM_HOBgqy5V3pOsA6w1EDOtEQO9dZG2Cw+-2niaw@mail.gmail.com>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Message-ID: <b43c3d60-b675-442c-c549-25530cfbffe3@gmail.com>
Date:   Thu, 15 Aug 2019 14:32:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0=GrjM_HOBgqy5V3pOsA6w1EDOtEQO9dZG2Cw+-2niaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 8/15/19 9:11 AM, Arnd Bergmann wrote:
> On Thu, Aug 1, 2019 at 9:33 AM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Thu, Aug 1, 2019 at 12:53 AM Russell King - ARM Linux admin
>> <linux@armlinux.org.uk> wrote:
>>>
>>> On Wed, Jul 31, 2019 at 09:56:42PM +0200, Arnd Bergmann wrote:
>>>> For dove, the patches are basically what I had proposed back in
>>>> 2015 when all other ARMv6/ARMv7 machines became part of a single
>>>> kernel build. I don't know what the state is mach-dove support is,
>>>> compared to the DT based support in mach-mvebu for the same
>>>> hardware. If they are functionally the same, we could also just
>>>> remove mach-dove rather than applying my patches.
>>>
>>> Well, the good news is that I'm down to a small board support file
>>> for the Dove Cubox now - but the bad news is, that there's still a
>>> board support file necessary to support everything the Dove SoC has
>>> to offer.
>>>
>>> Even for a DT based Dove Cubox, I'm still using mach-dove, but it
>>> may be possible to drop most of mach-dove now.  Without spending a
>>> lot of time digging through it, it's impossible to really know.
>>
>> Ok, so we won't remove it then, but I'd like to merge my patches to
>> at least get away from the special case of requiring a separate kernel
>> image for it.
>>
>> Can you try if applying patches 12 and 14 from my series causes
>> problems for you? (it may be easier to apply the entire set
>> or pull from [1] to avoid rebase conflicts).
> 
> I applied patches 12 and 13 into the soc tree now. There are some
> other pending multiplatform conversions (iop32x, ep93xx, lpc32xx,
> omap1), but it looks like none of those will be complete for 5.4.

I think the patchset (v2) for the LPC32xx is ready for 5.4
([PATCH v2 00/13] v2: ARM: move lpc32xx to multiplatform)
 >
> I now expect that we can get most of the preparation into 5.4,
> and maybe move them all over together in 5.5 after some more
> testing. If someone finds a problem with the one of the
> preparation steps, that we can revert the individual patches
> more easily.
> 
>        Arnd
> 
Sylvain
