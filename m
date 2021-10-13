Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C8142BBB4
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhJMJhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:37:12 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:56130
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235642AbhJMJhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:37:11 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7FDDA3F077
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634117707;
        bh=IKEbfKOXTTA9Zy1G5D27Bz2whSJ8iNQQGtVLWBGoxFI=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=srlQazY9SaPy3EQSJ/UVskbbwxDcC8R1tV5RPvHgA1lncACtVhohC98OZPjnG6j0g
         6HBeDT0ljbINHICBQuvq7X9XgX24J9MuCrEyndRSgcVuinNOUaLJjreMaTVmB3HYDY
         e+NYEqE2pQfRhVHWdaCUuq/udI7Cc50+Y5H7qryk1aonGSgTT9n3NBaZJsxOk6rwCc
         tzvWnUyA72d6ikA3FF2s5XdtCMLlOxjbg3HB2MGTA8OIX1enyaFiFZ0hv7Vg1BQ9Zw
         3RWiH9og8ujGYYTx/Lkcne6GurLziwm1LpM9Dsypnw5/JgzIzl2mlX0XkJ6VytLNdz
         lUGNM8e23iBpg==
Received: by mail-lf1-f71.google.com with SMTP id bq35-20020a056512152300b003fd45087a72so1541834lfb.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 02:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKEbfKOXTTA9Zy1G5D27Bz2whSJ8iNQQGtVLWBGoxFI=;
        b=p3sak/yqqkH24DJRgUQElc+4Mq2w+lSgsBn70dOjJ8eqf5dIZwsupG61aqHDV7VX3m
         EFry0kvEBkNEsUDZAj3vJvQabTkyWPRYqiyG9pyizsI3NEHBfhJDv/hAL/3YW96N/tK6
         yCm4gdXzmLvRb9eBMkLGMgxC0GevYEj453A8onqQIBBjWJWo5+d1/es14zMBwH/811yo
         E7VZ1KdZSqhjBtuCb5F6PFFHLCcEXWeoFOHbP8mIkxNyxQnJxg0AL+BhNcKHiYgCte8A
         QTDlXxVtEcSWNMGtCPi3kk13ydiwpbt0vd473yfbXJsAW3gtMW0nB4p9W9fApGeyYvgw
         4gdA==
X-Gm-Message-State: AOAM530pYv89KYDffTJ9xAlT0h6zM5aQw55VQ5QPETGczqJbvtuYfwlr
        C4/VCOjN8KEIXUIuOzaxFdvvLmUNtdZeNnHD1sATG1OvM+5RynwdwELxyBW/pHQLXjrtV6xtt2K
        PElObN/q4Uj7fxWNBe1IyVwhNArARspS7uQ==
X-Received: by 2002:a2e:6e0b:: with SMTP id j11mr35072125ljc.527.1634117706756;
        Wed, 13 Oct 2021 02:35:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD7Cw9/JmcSD/tRXz+nbmqjEHDvFkW2uMrpqR/mXiPYT1A4e7fR5duSDP5vyRvha34PORYPw==
X-Received: by 2002:a2e:6e0b:: with SMTP id j11mr35072107ljc.527.1634117706543;
        Wed, 13 Oct 2021 02:35:06 -0700 (PDT)
Received: from [192.168.0.22] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id t3sm1413241ljd.41.2021.10.13.02.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 02:35:05 -0700 (PDT)
Subject: Re: [PATCH net 1/2] NFC: digital: fix possible memory leak in
 digital_tg_listen_mdaa()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634111083.git.william.xuanziyang@huawei.com>
 <4e3578352a4548feb1d3087c7ec38fedab18292d.1634111083.git.william.xuanziyang@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <1013af1d-51f7-9798-e2aa-15c03d269ac1@canonical.com>
Date:   Wed, 13 Oct 2021 11:35:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4e3578352a4548feb1d3087c7ec38fedab18292d.1634111083.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2021 09:50, Ziyang Xuan wrote:
> 'params' is allocated in digital_tg_listen_mdaa(), but not free when
> digital_send_cmd() failed, which will cause memory leak. Fix it by
> freeing 'params' if digital_send_cmd() return failed.
> 
> Fixes: 1c7a4c24fbfd ("NFC Digital: Add target NFC-DEP support")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/nfc/digital_core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

Good catch. Leak is only theoretical as digital_send_cmd() will fail
only on memory allocation failure but your fix makes code correct.


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
