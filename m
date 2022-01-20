Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C446D494EDB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiATNYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiATNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 08:24:33 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B84C061574;
        Thu, 20 Jan 2022 05:24:32 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x11so21633261lfa.2;
        Thu, 20 Jan 2022 05:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=sLCTXFod4YiVtOaP3oATeJegpkT5YMzqgH0M5IgooEE=;
        b=p29p5t6CsRhekULOtVhHf342Xzxo7YOb30SZzJVGNcEgEmOEyAciU5vsBXfMv13CeV
         h8fvEL5nl9HO1blx9o+60Vuv/vkR+ChVnOVGLHkNHPbcTTlG2Cl9gm5WbOVevrrPPSm/
         AkLFyFGiSXxp9lk/rLWxf6N2br6cEHyQJ6+KJNAF8No7t1Ymh7DvPQb+VsM6YOTYpItj
         +Q+meyrlgQzHVGJgL6Vb7cTSbWtyQ0IgZ0IY+myJggAy5UgpEfM156fwgBFjdAjanCiZ
         svmvInFnLdi5z6TuGcIknQCFMUnJ6erNiVqiB0AfTr/Q5gIfRDBoR83fhusPzIkkVG2V
         OIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=sLCTXFod4YiVtOaP3oATeJegpkT5YMzqgH0M5IgooEE=;
        b=ftkLfh5+/KA5zBxJxYXYX0OHmMG509xKuz3W6CBqNlTvEvEd2Yk0NoR9Gk4uvPhOto
         GGJIhmkJN9hpIFwe3lxjN9O1pzPUfs2z+XQfrxmXhv3U4ZyO+m+l4Vnmc4+eCHh4kNlD
         nJe2A4QFgTpBSvcV+y0uJfMNfBkbVPkL2Ak0ftzJynUYH3KgvdQXdbAMOMp9ULw0GZbD
         LvL9DqZ0TxhUxubemJBny8gwRXUteRQQWB8pdnmmCVFp3nBNz8iS/pfgmG17C9N3bvDX
         I/ceKAFTd4t2D8haIAMCZkLIUD0cJqr6kA/0uk86hGikrXA4fSrl3cbICW8CzpSEwQ/E
         K+pg==
X-Gm-Message-State: AOAM530wsCqUmktf+2W3vBuxNTnXY1J5rwS7u/1bRZOEZ9+nrUhfbhWI
        Eh+IB4YvTPkL793+wKpbOB8=
X-Google-Smtp-Source: ABdhPJx8VKZbn0tbtLHugd0xtt3nrimGFsLn0YKdj5apSHuf/ReCQAwHNlexGTrDpN6xkHEyPQ55Lw==
X-Received: by 2002:a2e:22c3:: with SMTP id i186mr29646169lji.383.1642685070738;
        Thu, 20 Jan 2022 05:24:30 -0800 (PST)
Received: from [192.168.2.145] (109-252-139-36.dynamic.spd-mgts.ru. [109.252.139.36])
        by smtp.googlemail.com with ESMTPSA id u25sm339637lfd.180.2022.01.20.05.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 05:24:30 -0800 (PST)
Message-ID: <9b81d7f4-7332-6314-bdc3-2fcb76f17208@gmail.com>
Date:   Thu, 20 Jan 2022 16:24:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL
 board_type
Content-Language: en-US
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
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
References: <20220117142919.207370-1-marcan@marcan.st>
 <20220117142919.207370-4-marcan@marcan.st>
 <be66ea27-c98a-68d3-40b1-f79ab62460d5@gmail.com>
 <9db96f20-38fb-46e0-5f33-e5cd36501bf0@broadcom.com>
 <5dca45ba-a8a9-7091-365b-7a73fdd3be26@gmail.com>
In-Reply-To: <5dca45ba-a8a9-7091-365b-7a73fdd3be26@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20.01.2022 16:23, Dmitry Osipenko пишет:
> 20.01.2022 11:29, Arend van Spriel пишет:
>> On 1/19/2022 11:02 PM, Dmitry Osipenko wrote:
>>> 17.01.2022 17:29, Hector Martin пишет:
>>>> This unbreaks support for USB devices, which do not have a board_type
>>>> to create an alt_path out of and thus were running into a NULL
>>>> dereference.
>>>>
>>>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware
>>>> binaries")
>>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>>
>>> Technically, all patches that are intended to be included into next
>>> stable kernel update require the "Cc: stable@vger.kernel.org" tag.
>>
>> Being the nit picker that I am I would say it is recommended to safe
>> yourself extra work, not required, for the reason you give below.
> 
> Will be nice if stable tag could officially become a recommendation,
> implying the stable tag. It's a requirement today, at least Greg KH
> always demands to add it :)

*implying the stable tag if "fixes" tag presents.
