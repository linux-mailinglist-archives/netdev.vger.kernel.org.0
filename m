Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4B1484AD4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiADWiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiADWiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 17:38:52 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844C6C061761;
        Tue,  4 Jan 2022 14:38:51 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bp20so84919265lfb.6;
        Tue, 04 Jan 2022 14:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ltp8LALALJteT6noWWok492G/OMAgatm1CDGi/K+eLI=;
        b=h+/IOsru5P7OYh1PfOWHFlhgLEOIzWl+bNQxEPvgggaydWshTCfq5FPyeeI5X6Q14m
         FiGzeAz626D9ZmL4GdW0gH79tNctOCD4vElNcP3ceb8TXhTstP3T9srSmzuiEsTbIpXY
         lbhq5M9j6cgRbgKREN+PQD8c3kEnEPN97S0yPCFWRjNc2T9IUOl8TMVnkNPHbc0BN3bH
         dQXLJegBXhlxjU2kwceyavjWqjK28FDtHB4q5JnrBMW2LfZWAaRjYVvms6y/QM5i4gqS
         Dr/5yyDm0mNTVdIxUkJWTOI9tON4UwAD+931M2ch4E3aBYbnofgfAER2UyMRtabhJl/y
         692g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ltp8LALALJteT6noWWok492G/OMAgatm1CDGi/K+eLI=;
        b=1BWR1yA33OWqiesASkpljX2m8lw4zhx0HPbo3GSlqCVZSMoAuaCxbP32rICwkpAl8r
         b64+hF3pzzaeWIY0Fey52CsmEDqNPpEL0l9pv9Epdkj0X3ry/WjyyzBMImyYgMhuvHx/
         0Ip3ZjpVmenuvPaEeSWMLI/m2Jpp79fCQPDGxNSjPWoX1Kokcmk+b9sXi+zuklXr4wTj
         NloYyKiGOeO9KmVRgelc90Ki3SVS9e8uUdI1VXelDgjM3ZfGJsYdSeDdjBFlHfhXRd4o
         BnmWQSQtHH3NmGlJ1zoi9wsTS1FsEJNNjkUYAFs7KgIHUC0pYdZHl2ux95RJIT1+FkEK
         S0Ew==
X-Gm-Message-State: AOAM5324NHnsC680jHkk3AWMgY2S3/jRXrPDDIRcCKsjnaQQ3Cw461KV
        KOsonFm/Et+yMQ64FdUNcsg=
X-Google-Smtp-Source: ABdhPJwzMivr9lO9qHzC3ODAHRJzhhdx/OjIM55OwP6/sJjhsn9GbAEmtEYlY8MTXz9TyyLP7kEwiQ==
X-Received: by 2002:a05:6512:118b:: with SMTP id g11mr9776235lfr.570.1641335929880;
        Tue, 04 Jan 2022 14:38:49 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id u19sm3138690ljd.94.2022.01.04.14.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 14:38:49 -0800 (PST)
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
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <226a78e1-fa51-1f1b-c547-636797d831e4@gmail.com>
Date:   Wed, 5 Jan 2022 01:38:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104072658.69756-5-marcan@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

04.01.2022 10:26, Hector Martin пишет:
> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
>  {
...
> +static void
> +brcm_free_alt_fw_paths(const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
> +{

I'd rename this funcs to brcm_init/deinit_alt_fw_paths(), for
consistency and clarity.
