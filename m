Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F35484A7A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiADWJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiADWJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 17:09:52 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC23AC061761;
        Tue,  4 Jan 2022 14:09:51 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k21so84827972lfu.0;
        Tue, 04 Jan 2022 14:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J+tOL9aMBTynfbO5F5IU1d3i5H7vwKI9tttVAfJxxGo=;
        b=aS5gsRuJvKrVBvBjl/Qv/73+UDYrsukVayLyAFFOTjh2wUnczIUFg74tLFKjdTJfwB
         NS/KZDlQDwovNy6XOSuAR78XSWkLRk3REZu0ij+7yHv7svkVMuLBsFLGz6StWpU+mR7u
         1FVMTYxfdUo/w6ayUpQFW49HF/a7RCw3PqL+NIBzx5j+t1GP+WxsvFpzj9K4sRBq2Xvz
         QKsgHULpYQHouP+gyBJgF4n/8UtfD52kL/00MaQzEHSerZ60+9Lnf8+h6lPR6EuFhT3L
         DVjvsXXlM/IZmWKwQvYWQsMg78FPo7ORO+JsfCjUhqPIUN8RHMGS4Q4vawxQ6g7zHwmv
         at5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J+tOL9aMBTynfbO5F5IU1d3i5H7vwKI9tttVAfJxxGo=;
        b=qCKoqU+16a3wuAKcm5XcMmpApH8tLFvTLvXJaY+Xt4L6sTnQSNVEiw/mFrC8gPem4o
         Dpfb7C69f47cyS/QtcDT/yUBdEeNeaWjQb8OE2N9yvHKpMlNBXfdcolpRxIPadlx4cPQ
         FmMHSwh7mUTqUk+dOHRD+aMRQMvV8Mxo8++CjmnRSl4aGv/8nGyT2V6Yc/GwBl0sRfp3
         K1lFe8Ca65xfUrkbtM1vg6ePAwvjD4dc0rDhITkt782EOHSAlisf9NzXuC2gWA2be47X
         bsvlNG8F66TWEiBToAQs+RYsoxYfXp4Z3cJ45LO23J1DhZTPkKDkT7v+f6vgTLtXl0vV
         GM3w==
X-Gm-Message-State: AOAM533hfGnPyqgMHX4lRd3QH/a3KX7AFe/1ofJpixdR1hwX4KR6OQ+l
        +3WTsQ/bU1ZlHOqZ9E7Rahc=
X-Google-Smtp-Source: ABdhPJwJjIwEF+zefQ2eGIPjV+eC1WWmcKPEqDAXegj0HkQephGbAVfsgOqZwbildelu2ACZAt/Yvw==
X-Received: by 2002:a05:6512:3d8b:: with SMTP id k11mr44058704lfv.212.1641334190236;
        Tue, 04 Jan 2022 14:09:50 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id t16sm3593004ljk.28.2022.01.04.14.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 14:09:49 -0800 (PST)
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
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
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
 <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com>
Date:   Wed, 5 Jan 2022 01:09:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

04.01.2022 11:43, Hector Martin пишет:
>>> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
>>> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])>  {
>>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>>  	const char *suffix;
>>>  
>>> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
>>> +					BRCMF_FW_MAX_ALT_PATHS));
>> You don't need to use array_size() since size of a fixed array is
>> already known.
>>
>> memset(alt_paths, 0, sizeof(alt_paths));
> It's a function argument, so that doesn't work and actually throws a
> warning. Array function argument notation is informative only; they
> behave strictly equivalent to pointers. Try it:
> 
> $ cat test.c
> #include <stdio.h>
> 
> void foo(char x[42])
> {
> 	printf("%ld\n", sizeof(x));
> }
> 
> int main() {
> 	char x[42];
> 
> 	foo(x);
> }
> $ gcc test.c
> test.c: In function ‘foo’:
> test.c:5:31: warning: ‘sizeof’ on array function parameter ‘x’ will
> return size of ‘char *’ [-Wsizeof-array-argument]
>     5 |         printf("%ld\n", sizeof(x));
>       |                               ^
> test.c:3:15: note: declared here
>     3 | void foo(char x[42])
>       |          ~~~~~^~~~~
> $ ./a.out
> 8

Then please use "const char **alt_paths" for the function argument to
make code cleaner and add another argument to pass the number of array
elements.

static int brcm_alt_fw_paths(const char *path, const char *board_type,
			     const char **alt_paths, unsigned int num_paths)
{
	size_t alt_paths_size = array_size(sizeof(*alt_paths), num_paths);
	
	memset(alt_paths, 0, alt_paths_size);
}

...

Maybe even better create a dedicated struct for the alt_paths:

struct brcmf_fw_alt_paths {
	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
	unsigned int index;
};

and then use the ".index" in the brcm_free_alt_fw_paths(). I suppose
this will make code a bit nicer and easier to follow.
