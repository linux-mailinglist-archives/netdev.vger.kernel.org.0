Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8305949F73D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbiA1KXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiA1KXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:23:12 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AE9C061714;
        Fri, 28 Jan 2022 02:23:11 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u14so10761187lfo.11;
        Fri, 28 Jan 2022 02:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x/9CSXvgs7itWENuvqfwnHsLwy/dW8BRtkhJB5JxTZM=;
        b=aXkn21kttW5XZ4d68NPV9wmASb9mf0RHDdkv6aulozhRSlQW34zPV7+ur53K14vwwh
         IcICBR1PxZQfYDwSPVaTfmQgpL6iPHnjKMg5F0NKkRlJbUWKmCsZJzpI2VduiaENRn7y
         ZF0+eHElCngqXmKKPODJHRTUDw1Cvn+Ljx/2WdORDAK/i8ro3GxZEoJQGLHxvkCkPQT7
         d7tgs/0TYqx5KhulapVwyCqEhatGxB16EzVySjZHiIMAL0sLh5WN+bP3BZ3KjgwowI7I
         V+14HotO3p5eCDVnU9OOzp4dh9Qbx160uk5ijngcQF96omkN3+AdROuYvAun0AAcqSoz
         DcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x/9CSXvgs7itWENuvqfwnHsLwy/dW8BRtkhJB5JxTZM=;
        b=grVT9CrI5A30p3asDk+da9dc5Gj7vz9HKbM/BOK8Wd4eNjzMEUoRhu01ZrIePmku1K
         pHEkUc/Tkc+prb3Oj7r9f3p2cODnlNmeC2584WWTwlfZafZfLadFSwdvHLHBH238YF16
         q16QTRXWvBIU1nNi0wNgqWp1WOThQZPCWdAOCK6z3E2qDy33cpvs2nIopFP67T0ML2M/
         ME/NcKqS8wA6Cj6vN9FJHci+pOMl3KcUfZ4ioHcIXl3suUf5PKCcrdRbbqm4AV3BvWh1
         OMX3ZNwFcfy4LHG9n8+eZZsdwKWNq5Q97Xr03TStCvlwaFHwDPeG0XobrnuTf/6p7dVE
         BMrA==
X-Gm-Message-State: AOAM532B/wI27Ptsi1laaKpl4xS2lQxQsS/0OxL6gLymqiS1YjbgsXAI
        Ivc9WIhmC5T1B6/fxw2ougg=
X-Google-Smtp-Source: ABdhPJwxbAYkS9/zKQirmZw5BCnQdN8trlg3dDjqY6SqJZzRCjj27U6ilBxgsbR6RGVKu/bAlx/kQA==
X-Received: by 2002:a05:6512:39c2:: with SMTP id k2mr5582026lfu.586.1643365390218;
        Fri, 28 Jan 2022 02:23:10 -0800 (PST)
Received: from [192.168.1.103] ([31.173.81.83])
        by smtp.gmail.com with ESMTPSA id u25sm626293ljg.134.2022.01.28.02.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 02:23:09 -0800 (PST)
Subject: Re: [PATCH 4/7] mfd: hi6421-spmi-pmic: Use generic_handle_irq_safe().
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
 <20220127113303.3012207-5-bigeasy@linutronix.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
Date:   Fri, 28 Jan 2022 13:23:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220127113303.3012207-5-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 2:33 PM, Sebastian Andrzej Siewior wrote:

> generic_handle_irq() is invoked from a regular interrupt service
> routing. This handler will become a forced-threaded handler on

   s/routing/routine/?

> PREEMPT_RT and will be invoked with enabled interrupts. The
> generic_handle_irq() must be invoked with disabled interrupts in order
> to avoid deadlocks.
> 
> Instead of manually disabling interrupts before invoking use
> generic_handle_irq() which can be invoked with enabled and disabled
> interrupts.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[...]

MBR, Sergey

