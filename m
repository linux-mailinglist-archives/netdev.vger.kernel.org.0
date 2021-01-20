Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0AB2FC78A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbhATCMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbhATCMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:12:24 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CC3C0613D3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:11:40 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 15so14200618pgx.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dpRoRjmQoC3HuqnTqHBZYWy3Cq8Lq8JquGnezlYCH9g=;
        b=Sb9wz14zjVlOCXAy7OjN0Tbe6P1OmlS4FbI5XohyfEliZR0cBNsDtdqO2N4XeoL4L+
         RCYshzVJuT09Fw4lQUmao0JzQpzEUnJSK7FnWQcVuYdHMuHRnTxTgqZGHjSDixBBQVTv
         9Mh8VyEdEfTyoB/dZ0968Tm6OVCcPNiRcNMGoB9roZZYUOCtTepYIbKvsl10ro0WTry+
         jPORzEtCJ+DFLCf1D3Ubmzcz4EtYYvceLdFPl5Xi1JUINbjX2nHi550h/7fyb5aMq0Nl
         f9aNCaxyemlvvkrS+/hGtdW+KEre1HXkDHsamdNZQviexIXY/ip3ytCswWbFSO0BrFWj
         GXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dpRoRjmQoC3HuqnTqHBZYWy3Cq8Lq8JquGnezlYCH9g=;
        b=QLwhfT0Qiw0MA+JYK7ZVmR7fT0aYWDEzw8bl67IAZL094p8DTX9YYQ4E6FU8GRtLvh
         XtiTqHYO1sDjO2O/sU2/H93Ey7eL91sgD5lQo9HbMUEr292u7iNKjCSXAf1pUs3oR4qs
         3yebccNLULH28O8e1imwyK17cduvRCLKFoccgL68ekg422UCtWvWQjSXQhVfLLM4eR/B
         A8yhEobnVdsE29lZPFpVeBENxhKWCW9tcqhassrqjlKJ+xhDdcv9wpP5+tUeG8Tq+aQ5
         zHWxno5Kxt9EIY7foEbnukXT47cnxaun8lLR0/ERWX/jmFo52rnBezxPmepFqXIlZh3X
         a6LQ==
X-Gm-Message-State: AOAM531i3JKoRnbku2hQZURmlWcV2lYqvOAbqJBmMemu6D8fHEqn4CVY
        5feha6RKzMQjSFXgzeFgg5o=
X-Google-Smtp-Source: ABdhPJy76hcF7Hvp2h/MQcNujr4sH9kpVEh4WJ6h75t+r/FC18NKbkwXcNMeHcxaLyUOuTSk4a66CA==
X-Received: by 2002:a63:db03:: with SMTP id e3mr7115729pgg.225.1611108699698;
        Tue, 19 Jan 2021 18:11:39 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m27sm308063pgn.62.2021.01.19.18.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 18:11:38 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: microchip: Adjust reset release timing
 to match reference reset circuit
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
References: <20210120020116.576669-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a5d7b2b7-a845-360a-64d9-a6331dc83e7c@gmail.com>
Date:   Tue, 19 Jan 2021 18:11:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120020116.576669-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 6:01 PM, Marek Vasut wrote:
> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
> resistor and 10uF capacitor to ground. This circuit takes ~100 mS to
> rise enough to release the reset.
> 
> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>                     VDDIO - VIH
>   t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 S
>                        VDDIO
> so we need ~95 mS for the reset to really de-assert, and then the
> original 100uS for the switch itself to come out of reset. Simply
> msleep() for 100 mS which fits the constraint with a bit of extra
> space.

This is nitpicking but the unit symbol for seconds is 's', not 'S' which
is for Siemens.

With that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
