Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17888290FE0
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 08:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436976AbgJQGCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436899AbgJQGBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 02:01:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACEBC0604DE;
        Fri, 16 Oct 2020 19:44:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h4so2511678pjk.0;
        Fri, 16 Oct 2020 19:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L8ggdEfY4bl2Bnt1VidQjf6CT+zfsSuUzYgjI1vnszg=;
        b=hszp57NUtZAPIvQiya97eWTv/TsnZKHenBOhSnRffAc2zv58vy4VYnbstsyXnWFsjE
         YyKXlii5FoUTJYyukJ8TEqzsNKjJucX5UAH/XDHA0JYesnJlEP4zoo2pNX2mU5QDNgIX
         3zba7STQ6kbrbXLN+oDYY+CP27cccr6Bgqoogld7DjvCjVUXWSUe62+czRtJ2w6cpZtx
         oGRi4bbg3W4W4/8Zicy2KR0PDoT5j6APds+KWSGqQNFh/00hpBU3QFHsYFDqjQpspEmD
         BP+uNWPkU8fzhkEk2he8Ee+j3Z9mhCvkMcDlgyqh6IkUhwiRtnO91jpqR4Rot5N19hHD
         Iq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8ggdEfY4bl2Bnt1VidQjf6CT+zfsSuUzYgjI1vnszg=;
        b=jHE+Y73/0xgIwm3r5x2cLQn/88UPcELV8S16ADdU/zhaAHGZO81Ts8QawzsUwIOfUP
         Pgj6o8Xk1wjCDu98XlCs5pmBXe7w1JuLhX7csXuu7dsUTL7pgm+uooULwd/LGh4xrh9Z
         RJu9xslZ+YLHGanXHflV39ItIJTTa4ROVFsgAiS6/MwPqyy7nnT3m/SDDc0TqYhL/GgK
         RqPL9sjXxNfDMg0gKqTr4wDr3ScsCVGcRUKXNg7MqkBUk3scUz7aWOtcwpg2LjE5c+0r
         +xKt1sMEPrqX2M/tTxv911Lth04SlvrXfHI2fEOLTH4ukGNj7L75JRha+bEtQTRhu1/s
         Owxw==
X-Gm-Message-State: AOAM530FBpjzra1KdQciObssZPd/23bm9vZMMj8ZciWnKSOEPdvfNNoI
        +Sxz9qaHOncUHObrYx/ShfykRRgSDF8=
X-Google-Smtp-Source: ABdhPJxZ7yEW1/6l9gektHcw+CNMQfsWlliI1+TAmr029TvLC1B7MIVE4VoCcNqX8jl3TuPB2d66sA==
X-Received: by 2002:a17:90a:6541:: with SMTP id f1mr7111762pjs.46.1602902679784;
        Fri, 16 Oct 2020 19:44:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e11sm4138039pfm.160.2020.10.16.19.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 19:44:39 -0700 (PDT)
To:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201016200226.23994-1-ceggers@arri.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 0/3] net: dsa: move skb reallocation to dsa_slave_xmit
Message-ID: <9795d523-c296-cc18-4188-9214fb9cc25d@gmail.com>
Date:   Fri, 16 Oct 2020 19:44:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201016200226.23994-1-ceggers@arri.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/2020 1:02 PM, Christian Eggers wrote:

[snip]

> On Friday, 16 October 2020, 20:03:11 CEST, Jakub Kicinski wrote:
>> FWIW if you want to avoid the reallocs you may want to set
>> needed_tailroom on the netdev.
> I haven't looked for this yet. If this can really solve the tagging AND
> padding problem, I would like to do this in a follow up patch.

The comment in netdevice.h says:

    *      @needed_headroom: Extra headroom the hardware may need, but 
not in all
    *                        cases can this be guaranteed
    *      @needed_tailroom: Extra tailroom the hardware may need, but 
not in all
    *                        cases can this be guaranteed. Some cases 
also use
    *                        LL_MAX_HEADER instead to allocate the skb

and while I have never seen a reallocation occur while pushing a 
descriptor status block in front of a frame on transmit after setting 
the correct needed_headroom, it was not exercised in a very complicated 
way either, just TCP or UDP over IPv4 or IPv6. This makes me think that 
the comment is cautionary about more complicated transmit scenarios with 
stacked devices, tunneling etc.

> 
> Wishing a nice weekend for netdev.

Likewise!
-- 
Florian
