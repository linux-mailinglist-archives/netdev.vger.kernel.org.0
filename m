Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BD2484ACB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiADWhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiADWhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 17:37:00 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941EEC061761;
        Tue,  4 Jan 2022 14:36:59 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id j11so83130597lfg.3;
        Tue, 04 Jan 2022 14:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SWHLs1+8AGixFefgPwIBMLydHGeV8v/ZsUKViQpOe0k=;
        b=fp08NDVwBLUGh/tTWFkzbHYwHcvO3Em/Uo+0CEYx7y02tQ61mmn5ZIgnU5yVJCNb3h
         N/fW6sXdeG4L4OYJLjTEkWmYU8qsvp12gNH6RvACmLhtpnADYOkx/OQBitWjKPebQhIU
         tJHk8vJEvO/W4IuaGhJujM7jdCM4E8M+gnk23wjKNvULatcg7lh9lJ6WzO8DCAyre9Z+
         t59N1LeffI4Py1MUL50Ctb6pTLRUcrGnAvJAlhrRrTAYXnstNJLoPn/cyHPSqc5yn4Lo
         MV7k/OhfUPXDT9PB2GjbRXxt9GQmulBy7pRZAJlFaeEHPzzantkqTVNaDKcQG16DUKXf
         QMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SWHLs1+8AGixFefgPwIBMLydHGeV8v/ZsUKViQpOe0k=;
        b=FkQusJrPKhbnS62orerLG5hWiW9UTq6xsHYSNmMF7VZzxvxL8hh8T8qfRyl9k0S/RK
         9GVtnCFxE8rDLJmHS9v5ZenIPkpjpqXnQievA1z9SB69NFmLm3WhNzppdmQ4Jv0JUc7q
         f80glahOKUspUziALRAcEb0ZQ/3XB/cWHmbVCROrIOZz+g9BiTQDozD2Njgq6Sz9MqQb
         rnHrl+rbhn1WAsbGJv0o+sUFC4CK3rXRJ8+/yzXTAIP/pmqRWjK7oqKIjG+aNwWj+8ao
         4Aa0+242Z3UwOJOd6tXjesHiobmqvRSX43YQQpdTEl6OExUpnECKiN4OOqgUVXqH1wHF
         CwOA==
X-Gm-Message-State: AOAM532QrNueufbdIzQ+VTg65IWVjVowg6v9/Z5Tg7opyobQsioo4nWR
        jYyTatfi2pDaDxewRW5YzyY=
X-Google-Smtp-Source: ABdhPJxx7opaGXu++2IUwz15ROp0urc/sjDfTDL2SUbki0cQbhAv0CuIMwM1BgLpbLWLIqnKSDsYlw==
X-Received: by 2002:a05:6512:2294:: with SMTP id f20mr41539763lfu.546.1641335817926;
        Tue, 04 Jan 2022 14:36:57 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id k8sm4014966lfv.71.2022.01.04.14.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 14:36:57 -0800 (PST)
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
Message-ID: <d03c0125-0252-d6f0-2db1-7fccd1394dca@gmail.com>
Date:   Wed, 5 Jan 2022 01:36:55 +0300
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
>>> @@ -427,6 +427,8 @@ void brcmf_fw_nvram_free(void *nvram)
>>>  struct brcmf_fw {
>>>  	struct device *dev;
>>>  	struct brcmf_fw_request *req;
>>> +	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
>>> +	int alt_index;
>> unsigned int
> Ack.
> 

The same applies to the rest of the patches. If value can't be negative,
then please use unsigned type. This makes code more consistent.
