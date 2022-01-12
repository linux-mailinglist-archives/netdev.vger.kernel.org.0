Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9CD48C6D6
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 16:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354459AbiALPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 10:14:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354456AbiALPN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 10:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642000439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Bh7ctsPUcuF3d9C05pOY2/eeubhRbwCqaFcDL5uFWI=;
        b=c6Q+lfAWcWlnTq/C5oj6KN47DReOJ8rtQseaUSl/qU15ThqTU4EoryssTXC19BXpTqiQaf
        sesmHoepvTz+o83FNde3SvZwAtIu7TCAU60Ic8+AvciHv8iUr/J1PJHGtTVd+rkkPDhv75
        R5csPqqGzTFe+rXhZG/2OnuOavNkKkM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-LJDKxe2EOvyeH2XlXGaqug-1; Wed, 12 Jan 2022 10:13:57 -0500
X-MC-Unique: LJDKxe2EOvyeH2XlXGaqug-1
Received: by mail-ed1-f72.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso2495015edt.20
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 07:13:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Bh7ctsPUcuF3d9C05pOY2/eeubhRbwCqaFcDL5uFWI=;
        b=qvB65jUvFDNaooaojLm7t/LtzacxNq50mXVOEBNdvTwYhgeITfGqZcTDlmdvzU/VYQ
         BTkkp312sZV9CuoqoL0G/xSdwVYLYDOKWaD8x0C3vBqJ7lEHEUtZOdYK8taHaANG+5uC
         Q5H18SDqm6Smt3hW/0hz+bD7QBPt37Py9JxDhCR6XNIQYlNtn/G98Zbg7Ds4CbVRyAsi
         HwWmiAZlhnrG+5LPe7kLL5Yd2gFlzDYt52AQLD1769psO0Yhp5Bx1ioQ78aHbBmOq8T0
         h0RHKvbhOFTcUjhOIgpge3B+zDluM3YbSn1oMYgOvmh0qjPZmdeELWDXyZqvn8JroKQn
         QL4g==
X-Gm-Message-State: AOAM533Q4NLoI6bo1SRPNDyunnEU/HMeRR+ZDspmiMEUWbj9unjuQQEe
        KPAM5TgjAoCsjp2prBUlmE1nvCre/lzEad93QE0zogLTbhm1P0xXDwbI755vkPD5B6SyPqW3sMX
        9dA/1/7brC3F44ZzF
X-Received: by 2002:a05:6402:4301:: with SMTP id m1mr91610edc.125.1642000436603;
        Wed, 12 Jan 2022 07:13:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHCfLIBizaWXXYa2iLmLrtn7fgNZy0TD2UORPcAGGaEg/oxddwYAXs40mqRBDL6oAsbgh8ZQ==
X-Received: by 2002:a05:6402:4301:: with SMTP id m1mr91537edc.125.1642000436370;
        Wed, 12 Jan 2022 07:13:56 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id o25sm40807edr.20.2022.01.12.07.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 07:13:55 -0800 (PST)
Message-ID: <e6487826-7683-2f29-c057-e5d7b913800c@redhat.com>
Date:   Wed, 12 Jan 2022 16:13:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 1/2] platform: make platform_get_irq_optional() optional
Content-Language: en-US
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Auger <eric.auger@redhat.com>,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        openipmi-developer@lists.sourceforge.net,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <20220110195449.12448-1-s.shtylyov@omp.ru>
 <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <Yd7Z3Qwevb/lEwQZ@lunn.ch>
 <CAMuHMdV2cGvqMppwt9xhpze=pcnHfTozDZMjwT1DkivLD+_nbQ@mail.gmail.com>
 <CAJZ5v0iyAHtDe1kFObQorXOX0Xraxac0j29Dh+8sq7zxzbsmcQ@mail.gmail.com>
 <78a17bae-435b-e35e-b2dc-1166777725a0@omp.ru>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <78a17bae-435b-e35e-b2dc-1166777725a0@omp.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/12/22 16:05, Sergey Shtylyov wrote:
> On 1/12/22 5:41 PM, Rafael J. Wysocki wrote:
> 
> [...]
>>>>> If an optional IRQ is not present, drivers either just ignore it (e.g.
>>>>> for devices that can have multiple interrupts or a single muxed IRQ),
>>>>> or they have to resort to polling. For the latter, fall-back handling
>>>>> is needed elsewhere in the driver.
>>>>> To me it sounds much more logical for the driver to check if an
>>>>> optional irq is non-zero (available) or zero (not available), than to
>>>>> sprinkle around checks for -ENXIO. In addition, you have to remember
>>>>> that this one returns -ENXIO, while other APIs use -ENOENT or -ENOSYS
>>>>> (or some other error code) to indicate absence. I thought not having
>>>>> to care about the actual error code was the main reason behind the
>>>>> introduction of the *_optional() APIs.
>>>>Hi,
>>>> The *_optional() functions return an error code if there has been a
>>>> real error which should be reported up the call stack. This excludes
>>>> whatever error code indicates the requested resource does not exist,
>>>> which can be -ENODEV etc. If the device does not exist, a magic cookie
>>>> is returned which appears to be a valid resources but in fact is
>>>> not. So the users of these functions just need to check for an error
>>>> code, and fail the probe if present.
>>>
>>> Agreed.
>>>
>>> Note that in most (all?) other cases, the return type is a pointer
>>> (e.g. to struct clk), and NULL is the magic cookie.
>>>
>>>> You seems to be suggesting in binary return value: non-zero
>>>> (available) or zero (not available)
>>>
>>> Only in case of success. In case of a real failure, an error code
>>> must be returned.
>>>
>>>> This discards the error code when something goes wrong. That is useful
>>>> information to have, so we should not be discarding it.
>>>
>>> No, the error code must be retained in case of failure.
>>>
>>>> IRQ don't currently have a magic cookie value. One option would be to
>>>> add such a magic cookie to the subsystem. Otherwise, since 0 is
>>>> invalid, return 0 to indicate the IRQ does not exist.
>>>
>>> Exactly. And using 0 means the similar code can be used as for other
>>> subsystems, where NULL would be returned.
>>>
>>> The only remaining difference is the "dummy cookie can be passed
>>> to other functions" behavior.  Which is IMHO a valid difference,
>>> as unlike with e.g. clk_prepare_enable(), you do pass extra data to
>>> request_irq(), and sometimes you do need to handle the absence of
>>> the interrupt using e.g. polling.
>>>
>>>> The request for a script checking this then makes sense. However, i
>>>> don't know how well coccinelle/sparse can track values across function
>>>> calls. They probably can check for:
>>>>
>>>>    ret = irq_get_optional()
>>>>    if (ret < 0)
>>>>       return ret;
>>>>
>>>> A missing if < 0 statement somewhere later is very likely to be an
>>>> error. A comparison of <= 0 is also likely to be an error. A check for
>>>>> 0 before calling any other IRQ functions would be good. I'm
>>>> surprised such a check does not already existing in the IRQ API, but
>>>> there are probably historical reasons for that.
>>>
>>> There are still a few platforms where IRQ 0 does exist.
>>
>> Not just a few even.  This happens on a reasonably recent x86 PC:
>>
>> rafael@gratch:~/work/linux-pm> head -2 /proc/interrupts
>>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>>   0:         10          0          0          0          0          0
>>  IR-IO-APIC    2-edge
>> timer
> 
>    IIRC Linus has proclaimed that IRQ0 was valid for the i8253 driver (living in
> arch/x86/); IRQ0 only was frowned upon when returned by platform_get_irq() and its
> ilk.
> 
> MBR, Sergey

Right, platform_get_irq() has this:

        WARN(ret == 0, "0 is an invalid IRQ number\n");

So given that platform_get_irq() returning 0 is not expected, it seems
reasonable for platform_get_irq_optional() to use 0 as a special
"no irq available" return value, matching the NULL returned by
gpiod_get_optional().

Regards,

Hans

