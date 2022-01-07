Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDFC487115
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbiAGDMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiAGDMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:12:46 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB61C061245;
        Thu,  6 Jan 2022 19:12:46 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k21so10819319lfu.0;
        Thu, 06 Jan 2022 19:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A7Z4QRcMvrmjlPeHV4GkEs76XEk9AgjLCHWeAaK4KqI=;
        b=ElDNw1cPek0Kf7E4LomCE17N63Q6E1qVcxOWExxLE8F3XGOZ0rIx7UdsZg74McZ4tq
         buNog03fKRLlt7iaBaAaNf2fUWtdmdQKegsE5NORsfMhU76iHvvh0bSNioX4hXIXZidG
         aMDcL9ajmwPg7vX8DvR8kZUHHQZ4OZ4J0CONG1exFtIPaalbiPwY4WHRi6G5bIMO8/iy
         9L3DgOHcyZAlOlNCVdVeYSPTjQbqQn5IaFSEW48PdI7FeVvaQrXfB6j7/AzWctQt2SsN
         jz8KfIZLyGS5Lvbo7B3Z40UhgZjwZAUBlFPiBF/N34mqJx1EGKYABJMqrSjZazuLp0ob
         zSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A7Z4QRcMvrmjlPeHV4GkEs76XEk9AgjLCHWeAaK4KqI=;
        b=yPXq8px53ktMxwQIFXS63tbKgHlkDkWTEOcGb5/BMZOA0HSkVwooixsTKkv+uyFYqH
         P9hgwQWxNEJ/jhiW3errm5uCdB4NdrYJoeWwHCXztBULSvgshN8LKePPY1zTKZXCSDQ7
         13yLaLOwKKk4KtRXp6djQjKVitXQ8aFSJqJfAxJrUZt6ryUDPmzGfB0kP6xannG/NhpD
         ZfNKY78JQCy0xLxvtrksoM68jQPwqfzLKVSJGjKTAryxL3jSLdBR4moF5ScGNVKdH5jv
         DlCvRIFveFUivmpMyOiPWSfS7btMdvqe4YsTXnV7UA/vGKAGbxEf0AOYvjwkNlqIwrvd
         CKUA==
X-Gm-Message-State: AOAM533yuNSn2meLsA0XWJdvlVtk5EbMzS97jnF3jpqzuOh1k1dC7Ux2
        GVwnRwdLCdMne7FNApU6aBo=
X-Google-Smtp-Source: ABdhPJxHXV0k57MxWhuqfwmKFIiBmrRHiyLSJvJehH8MQgm0fNUeowax2AmLxwXnW0uI0iduRkbzBg==
X-Received: by 2002:ac2:5f8b:: with SMTP id r11mr54565777lfe.44.1641525164286;
        Thu, 06 Jan 2022 19:12:44 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-141.dynamic.spd-mgts.ru. [94.29.46.141])
        by smtp.googlemail.com with ESMTPSA id p18sm402828ljn.65.2022.01.06.19.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 19:12:43 -0800 (PST)
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
 paths
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
 <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
 <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com>
 <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
 <57716712-024d-af7e-394b-72ca9cb008d0@gmail.com>
 <CAHp75VdXk87x7oDT1O5Q32ZsL4n0HYt-fijeiXw8n9fgypkOgg@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <d608ab82-cffe-0d66-99d2-d0abd214dd0d@gmail.com>
Date:   Fri, 7 Jan 2022 06:12:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VdXk87x7oDT1O5Q32ZsL4n0HYt-fijeiXw8n9fgypkOgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

06.01.2022 20:58, Andy Shevchenko пишет:
> On Thu, Jan 6, 2022 at 7:40 PM Dmitry Osipenko <digetx@gmail.com> wrote:
>> 05.01.2022 16:22, Hector Martin пишет:
>>> On 05/01/2022 07.09, Dmitry Osipenko wrote:
> 
> ...
> 
>>> I'm confused; the array size is constant. What would index contain and
>>> why would would brcm_free_alt_fw_paths use it? Just as an iterator
>>> variable instead of using a local variable? Or do you mean count?
>>
>> Yes, use index for the count of active entries in the alt_paths[].
>>
>> for (i = 0; i < alt_paths.index; i++)
>>         kfree(alt_paths.path[i]);
>>
>> alt_paths.index = 0;
>>
>> or
>>
>> while (alt_paths.index)
>>         kfree(alt_paths.path[--alt_paths.index]);
> 
> Usual pattern is
> 
>   while (x--)
>     kfree(x);
> 
> easier to read, extend (if needed).
> 

That is indeed a usual patter for the driver removal code paths. I
didn't like to have index of struct brcmf_fw underflowed, but I see now
that fwctx is dynamically created and freed during driver probe, so it
should be fine to use that usual pattern here too.
