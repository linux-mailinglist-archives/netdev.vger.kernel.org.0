Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC247F90B
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 22:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhLZVm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 16:42:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234560AbhLZVm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 16:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640554977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaxzzVWGUvCL9/6wljcFZN+2qLHHZNjfVRnsMFPEf2w=;
        b=FlBnMIGDWizyxuPVQjKXN7Sg5Oeygu89BbxCdkLo+ZqXQxtiHGTinEBE5APs6eubwRpoSu
        whPfImMGfYwhs/gBlJprhaKKp+6TOZNSBNZJR+7aqw7gUqwDfnSon4LXQ8vlYUN0dXeh+r
        VWnc2WdUpkIvi8ON23z9IlKzfn5iem4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-zpvbvFQSNn6ZuoPm_yMTFw-1; Sun, 26 Dec 2021 16:42:56 -0500
X-MC-Unique: zpvbvFQSNn6ZuoPm_yMTFw-1
Received: by mail-ed1-f72.google.com with SMTP id v18-20020a056402349200b003f8d3b7ee8dso6241411edc.23
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 13:42:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HaxzzVWGUvCL9/6wljcFZN+2qLHHZNjfVRnsMFPEf2w=;
        b=KogcW2XdQraoSxJXIljPzjhnOJszeTjNRqdf7+gETC6N0+gBkWGGeh5GpoPeMIJzpA
         +6mwYjGEERtdR+Dzi6ezgeyo9CK5LhS9mm+KRFyWQQq0PrF+eGKhEZk/xk1Nao8ZVVFt
         +p7X2C8AnGSuj5TAEm1tNAb1wl5ihONnZOD8Z3sOVE2mHzZvWiawuYpQqdpi+ViQM/Sc
         EBIJ97nrBFhG3fRTpqu0cSN/mIcxxqW0/OFb8rDgCFFL0Nd+2BspncTwRdplrpRqt8W5
         yOkViB8Cib/05TYUqqZWKnrrh31aZq/Byaiq12vrNrKSangeGuKdeMo+cu7CYOlGNl4h
         LQDg==
X-Gm-Message-State: AOAM532KYCkwk4GVeUOshWgSJajb2CYBHJioW7RB34uvofv/FyVgIIGY
        jwURwOjWR6+Cn2+lvfXS4+c6kE+SbS6aNtdbL8B2sDL1KiEgGpJj5+2JJDiXT4oL2iExRXn9pLs
        uySSLzBhufkCVRN5A
X-Received: by 2002:a17:906:3e83:: with SMTP id a3mr12438961ejj.383.1640554975017;
        Sun, 26 Dec 2021 13:42:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjjTGm1vc4Yn3O3DoRSHsb9BLPUWpMfqNUiH7T2GdpeZg31LF6xTyu8YjWEeOsH0itDvgnsg==
X-Received: by 2002:a17:906:3e83:: with SMTP id a3mr12438947ejj.383.1640554974846;
        Sun, 26 Dec 2021 13:42:54 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id y21sm5369799eds.97.2021.12.26.13.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 13:42:54 -0800 (PST)
Message-ID: <06e801a0-7580-48ed-cac2-227c32a74ec2@redhat.com>
Date:   Sun, 26 Dec 2021 22:42:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH 00/34] brcmfmac: Support Apple T2 and M1 platforms
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226191728.GA687@wunner.de>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211226191728.GA687@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/26/21 20:17, Lukas Wunner wrote:
> On Mon, Dec 27, 2021 at 12:35:50AM +0900, Hector Martin wrote:
>> # On firmware
>>
>> As you might expect, the firmware for these machines is not available
>> under a redistributable license; however, every owner of one of these
>> machines *is* implicitly licensed to posess the firmware, and the OS
>> packages containing it are available under well-known URLs on Apple's
>> CDN with no authentication.
> 
> Apple's EFI firmware contains a full-fledged network stack for
> downloading macOS images from osrecovery.apple.com.  I suspect
> that it also contains wifi firmware.
> 
> You may want to check if it's passed to the OS as an EFI property.
> Using that would sidestep license issues.  There's EDID data,
> Thunderbolt DROM data and whatnot in those properties, so I
> wouldn't be surprised if it contained wifi stuff as well.
> 
> Enable CONFIG_APPLE_PROPERTIES and pass "dump_apple_properties"
> on the command line to see all EFI properties in dmesg.
> Alternatively, check "ioreg -l" on macOS.  Generally, what's
> available in the I/O registry should also be available on Linux
> either as an ACPI or EFI property.

Interesting, note that even if the files are not available as
a property we also have CONFIG_EFI_EMBEDDED_FIRMWARE, see:

drivers/firmware/efi/embedded-firmware.c
Documentation/driver-api/firmware/fallback-mechanisms.rst

I wrote this to pry/dig out some touchscreen firmwares (where
we have been unable to get permission to redistribute) out of
EFI boot_services_code mem regions on tablets where
the touchsceen is supported under the EFI environment.

This may need some tweaks, but if there is an embedded copy
of the firmware files in the EFI mem regions somewhere it
should be possible to adjust this code to grab it and present
it to the firmware-loader mechanism as a fallback option.

Refards,

Hans

