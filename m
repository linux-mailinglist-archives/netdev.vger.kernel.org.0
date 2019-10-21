Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B70DE239
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfJUCmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:42:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34279 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfJUCmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:42:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so7454611pfa.1;
        Sun, 20 Oct 2019 19:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2tQE0Idc0z8nXpFe9KaL/kDBigLLE712tN5hRfWCebo=;
        b=MQllSKp/D+0l+JW90t1N7698N9hsT3p0KalxyJayjjMZutqU/EJdVk4v269mzFUHyP
         PyAh81qJFZXhZIrIydlkRIWrwez+8pVIRZpr4a1wM3pOLY1Ih7Wd5XXKBUcHVONffZlI
         Llmw4SUYqw31SafeZYTKVRQw8cLKDdrjPvQRj9C7GrW1sTi+DC/LztCcDjHqAr4BXYX3
         AdwIzgVQzWvJ/jiLunpVmt5lQXw5MvKHC20Fa4Vgpyoy7hPftY+FwrN0yHqURV6roOdO
         I+05pXlHYCDWIykRaIW0OEO7HqRK2MderRmTn64dPecFfxClMQg0Dn3MXzIopBdPykrQ
         D+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2tQE0Idc0z8nXpFe9KaL/kDBigLLE712tN5hRfWCebo=;
        b=ZA4on/euobE+p62bHJk/cpd7zqOsnnnBdivbV/7VMBbeawMPMyMoK4JVTqss2dwbC1
         md1GiV3D7bO42zmch7S8ef+qVlsoaoaTkRFJCxQFq7qVlpHtNkqCEH29Buv80DvEmqJm
         Ds5N/MYipYIERolgaUkHQ/Yf61PCLwXg65X6GxxV3BQlgbMLV8OfJiOhdD70RK5DrryC
         dVRxputaqVgNZfACNw5f84lmgAAs085Opepjl63hu+mLMzH7djwodtfecHg+eUMM36Ff
         F0ihEZxdVimJE2/kfZ3NlftSOiUCBuaAjURMgKwe8tkdr5DJiHXYnTcB/4wG7DYsfNBm
         gFbA==
X-Gm-Message-State: APjAAAW+txBKBUloo8Tdm7CpoxYdtJIf1zQEtdE1cjEFM1oJyrVpZYDI
        rq06lfHcYTAU6uW11HgcB5vF1ink
X-Google-Smtp-Source: APXvYqyBlbT9aZKCzl1lFQODBm4mciuZeeX2brWgynrPmjXTlF4qKv1hv7o16KuHKolyLxAj+BKtag==
X-Received: by 2002:a63:f916:: with SMTP id h22mr12271200pgi.423.1571625737271;
        Sun, 20 Oct 2019 19:42:17 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m26sm14271456pgn.71.2019.10.20.19.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:42:16 -0700 (PDT)
Subject: Re: [PATCH net-next 05/16] net: dsa: use ports list to setup switches
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-6-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21738767-7e98-6c4c-ba1c-bea29142d481@gmail.com>
Date:   Sun, 20 Oct 2019 19:42:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-6-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of iterating over switches and their
> ports when setting up the switches and their ports.
> 
> At the same time, provide setup states and messages for ports and
> switches as it is done for the trees.

Humm, that becomes quite noisy, would it make sense to have those
messages only for non-user ports that are not already visible because
they do not have a net_device?

If you have multiple switches in a fabric, it might be convenient to use
dev_info(dp->ds->dev, ...) to print your message so you can clearly
identify which port belongs to which switch, which becomes even more
important as it is all flattened thanks to lists now. What do you think?
-- 
Florian
