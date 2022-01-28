Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9749F71E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346015AbiA1KSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347703AbiA1KSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:18:20 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832ACC061748;
        Fri, 28 Jan 2022 02:18:20 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id q22so8319252ljh.7;
        Fri, 28 Jan 2022 02:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ix2P1Qb5ofQ32QsYkBPXKMooy+IhErtwFmSskoxD7SE=;
        b=HeDUP1mJe5Wh7L3Q7OGU3bD0vrHT35bY3RPQL27RrmknbAcnZRL5iJpoWD+mFG2SV2
         qh0YRbrARJJ+Qlu3XnBT6QX8t+1gBDwL6iyvf6B9E+4T8F+PH4dKJvdiJWG4ILQTdBFe
         WMqyYiiSSKliFToRWugPWsxurGNdumszzo2nbc73NZRzcG9E8wj2bohO8yQKy+FwDFVN
         eLW+xh6jHZCMB2dGEz7dsTfL/PX5Ckx7r27LBzA3/upqJrcE0BHt2zfGIqrd6PDx2sGS
         1Mmpox9pvKYsUotNxW6VPOKYv03J3WHh2cViaiSQTjzDEyNOybPo+1gOWUf4iwgXJmaa
         zZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ix2P1Qb5ofQ32QsYkBPXKMooy+IhErtwFmSskoxD7SE=;
        b=umT7Tx/4cEMUv8aAsrL6uD0nIaaoAHLWxLYGigqPPZRCcC7UAsr1o05REQXBh85mfL
         GHKIkLsnfIFYE9ZJ+RRuRktOqYjY/he07KyactgmuSGZwMWYqZyJYgVsoZW+IVdfbDax
         oWFN5gwRaXvu7Uwu8jqtP5asdC1pq+4KKf1DAwz6cNX4sFzsxmb2+D3WaoCP5sAf06ur
         2Wo0yn11PB+vwhr6kmt6+jYt7yTBKs/rxxBn5srBopVGAPRmtOjJ1ge2Weu5pOf+KHRB
         984sjNwLfjLxM58vQiJg3UKs4rVNCioZWit5h1zITMsLtZjZKCpI+nZLM5BJWMHL3pxE
         GI5w==
X-Gm-Message-State: AOAM531MpJv+vbLzSN5BG+383TBRWhMQ+G+djmafnJBGdar+KO1wwEY1
        qZSXS0KPT5VPPDCnBA99KF4=
X-Google-Smtp-Source: ABdhPJyB16VsXVJnNjJMJADy3aApl/JsRwD6PTo2A73BfnawYgkLg1UmTv6X0o3ez3H1uCaT+ZH+Ew==
X-Received: by 2002:a2e:9f4a:: with SMTP id v10mr5239509ljk.233.1643365098684;
        Fri, 28 Jan 2022 02:18:18 -0800 (PST)
Received: from [192.168.1.103] ([31.173.81.83])
        by smtp.gmail.com with ESMTPSA id j15sm1005692lfr.203.2022.01.28.02.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 02:18:17 -0800 (PST)
Subject: Re: [PATCH 1/7] genirq: Provide generic_handle_irq_safe().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-2-bigeasy@linutronix.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <c26a4348-fa0c-6eb6-a571-7dbc454c05d0@gmail.com>
Date:   Fri, 28 Jan 2022 13:18:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220127113303.3012207-2-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 2:32 PM, Sebastian Andrzej Siewior wrote:

> Provide generic_handle_irq_safe() which can be used can used from any
                                          ^^^^^^^^^^^^^^^^^^^^
   You're repeating yourself. :-)

> context.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[...]

MBR, Sergey
