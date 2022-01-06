Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA54868CB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbiAFRkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242114AbiAFRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:40:38 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A9FC061201;
        Thu,  6 Jan 2022 09:40:38 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id t2so5296148ljo.6;
        Thu, 06 Jan 2022 09:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HCf2p678cHDUYNpCAAy0amVE5CY0Bi2914u4pFH9t9U=;
        b=VFkkzSMBJ4kUtnnEdjRaxIVVn8GziFbC2755dqtRZ/tZrPIb8l7gJwiJiLZwzcU4Ox
         ic61iQKDEiEXWMavryVTX8h3rY/YYliGy1Qb9r2W1mgB9SLVwYlOcveVShCzEYf3DR9y
         OwgTdBnJrTvPfrzIeK/Vz6jw/YCXauo9aB5l7UkZZL1+5Ttd1+vtyV+zX+dmcZKZ/H4U
         gKdrZoFbCl3ce5jLfQIysb3vTldT05Ykt0UTXKCrURj80CH/yhfhKFva+XY+5RT3XYOi
         2Lkm2uMbtXoYqsCrY3bc0iKsUIohudMQtxBLg9IZCxkf+SoJ3GL85FBgk6e9hi1CV8P9
         nUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCf2p678cHDUYNpCAAy0amVE5CY0Bi2914u4pFH9t9U=;
        b=kmfhd0j6xgG2+o3qGVkWONiUGGAPwCakzDN6bgCmxo4G7Rwz+mg5NYFVIblYomNm0m
         3qc/ehsFtY1eEXVTOM+yw3sQlWa8s/Ti9+akEEUFBk3zrKXB00337KuZ0uNbzcGf9iCk
         kcuHEfIPCqO8dX5OVBdopRhdXi+w1ZEZk1ny4YtM/Mk2xui7izyEMF29QbmHyKMsKcLu
         C1DHVylGCU4AbwJJFIQP2ZmiWuzMLKzJOGR/ZXRIr4Gp+glg1QPTa3xtgXwMo0ejdwdx
         yf7Z7TtZOKWRyjVZtvKEnUE05hy4kFG+7CGEGI1tHBgRq3XUQoSU4VUBIWcj267qG7lX
         /iRg==
X-Gm-Message-State: AOAM531pHFeigPiKnirL42fFnZBJXK4Af+kp2IWHy0hCC/NmxgxaJi0a
        C3uqO+MuNKHEt+Ho96LZ+rw=
X-Google-Smtp-Source: ABdhPJw/NfhvXS/Itz5PNlO6avbVOXGD8JOkpQrNISW85o73eUyfdrxPX+Gek4uDRbUwdmIDhi37jg==
X-Received: by 2002:a2e:990c:: with SMTP id v12mr26273173lji.335.1641490836381;
        Thu, 06 Jan 2022 09:40:36 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-141.dynamic.spd-mgts.ru. [94.29.46.141])
        by smtp.googlemail.com with ESMTPSA id w12sm237902lfe.256.2022.01.06.09.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 09:40:35 -0800 (PST)
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
 <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com>
 <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <57716712-024d-af7e-394b-72ca9cb008d0@gmail.com>
Date:   Thu, 6 Jan 2022 20:40:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

05.01.2022 16:22, Hector Martin пишет:
> On 05/01/2022 07.09, Dmitry Osipenko wrote:
>> 04.01.2022 11:43, Hector Martin пишет:
>>>>> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
>>>>> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])>  {
>>>>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>>>>  	const char *suffix;
>>>>>  
>>>>> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
>>>>> +					BRCMF_FW_MAX_ALT_PATHS));
>>>> You don't need to use array_size() since size of a fixed array is
>>>> already known.
>>>>
>>>> memset(alt_paths, 0, sizeof(alt_paths));
>>> It's a function argument, so that doesn't work and actually throws a
>>> warning. Array function argument notation is informative only; they
>>> behave strictly equivalent to pointers. Try it:
>>>
>>> $ cat test.c
>>> #include <stdio.h>
>>>
>>> void foo(char x[42])
>>> {
>>> 	printf("%ld\n", sizeof(x));
>>> }
>>>
>>> int main() {
>>> 	char x[42];
>>>
>>> 	foo(x);
>>> }
>>> $ gcc test.c
>>> test.c: In function ‘foo’:
>>> test.c:5:31: warning: ‘sizeof’ on array function parameter ‘x’ will
>>> return size of ‘char *’ [-Wsizeof-array-argument]
>>>     5 |         printf("%ld\n", sizeof(x));
>>>       |                               ^
>>> test.c:3:15: note: declared here
>>>     3 | void foo(char x[42])
>>>       |          ~~~~~^~~~~
>>> $ ./a.out
>>> 8
>>
>> Then please use "const char **alt_paths" for the function argument to
>> make code cleaner and add another argument to pass the number of array
>> elements.
> 
> So you want me to do the ARRAY_SIZE at the caller side then?
> 
>>
>> static int brcm_alt_fw_paths(const char *path, const char *board_type,
>> 			     const char **alt_paths, unsigned int num_paths)
>> {
>> 	size_t alt_paths_size = array_size(sizeof(*alt_paths), num_paths);
>> 	
>> 	memset(alt_paths, 0, alt_paths_size);
>> }
>>
>> ...
>>
>> Maybe even better create a dedicated struct for the alt_paths:
>>
>> struct brcmf_fw_alt_paths {
>> 	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
>> 	unsigned int index;
>> };
>>
>> and then use the ".index" in the brcm_free_alt_fw_paths(). I suppose
>> this will make code a bit nicer and easier to follow.
>>
> 
> I'm confused; the array size is constant. What would index contain and
> why would would brcm_free_alt_fw_paths use it? Just as an iterator
> variable instead of using a local variable? Or do you mean count?

Yes, use index for the count of active entries in the alt_paths[].

for (i = 0; i < alt_paths.index; i++)
	kfree(alt_paths.path[i]);

alt_paths.index = 0;

or

while (alt_paths.index)
	kfree(alt_paths.path[--alt_paths.index]);

> Though, to be honest, at this point I'm considering rethinking the whole
> patch for this mechanism because I'm not terribly happy with the current
> approach and clearly you aren't either :-) Maybe it makes more sense to
> stop trying to compute all the alt_paths ahead of time, and just have
> the function compute a single one to be used just-in-time at firmware
> request time, and just iterate over board_types.
> 

The just-in-time approach sounds like a good idea.
