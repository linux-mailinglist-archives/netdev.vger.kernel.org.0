Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A253141FC4
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 20:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgASTTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 14:19:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36219 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgASTTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 14:19:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so12585098wma.1
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 11:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EtsvYv2zKRxmWoCeCVSQhvKN1u2d4HxF1HVR3U0qPZo=;
        b=EEm0FGmXgfdsgi1/nH74aFEDXGQdNytIVZ5fLail0iS21zsi/B1cWzW1gkTmogb/7F
         KXl6yHuwRGaGgplOJ6H8mTko14poZgidieuQvxo0vih3urRqPMSjNG/MP3ZBqlU4TEb5
         uZzney8eMBIbOat59wM2IbcLsBXO2qt/MYn3+cYNLei5RxMUCmu0nkP3991IlGu2v7K8
         Ccs9Pctmh9Sl09BCku6PYGJMGB58FW5AbasjPaa8kC1Rnt3SQSjPwgwyT0337osrU0rb
         GmuBKtu0JItb2pfO0E0MvyjebD7znEsBNoM7DM7Bo67m6sFoZLGan5XA7QopoZm4Yvh+
         zHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EtsvYv2zKRxmWoCeCVSQhvKN1u2d4HxF1HVR3U0qPZo=;
        b=p9keJ7B6LBPMpq00aTwpfy0LNVPLGgZ8LlzJZPir2KD0HZx+t0coQ5scB0Z8HJWBtc
         WtI2N9Ix4ND2D7KXEKtRR/hU8ukZsLfolEBvzQV/7pkGZ9r2x4XWuCqV21Nayya53PxQ
         gAbWqiuox7uwdjS1/q1Nu93fH/smvQw0cwZN8lEDLyH0yQ02zu9TjP8FjNfoqjpr/NXB
         cYIxy+l4HzYuvZumh1h3WfbuOTGhhMYWed4cvC7+J29Gp90V6k43m3FXppEHUZBPXHoj
         cKu7XrJMpexaDa9BZB7yQ47AzvDoQERZyabR6PJUZ1kwjy4EdmuKrqCE63wAHr9IR+b3
         7woA==
X-Gm-Message-State: APjAAAUsIWk1LiUkVYnzhYJOLkOQpifWRWi6PyVKIiKJC+ZYuqD/L2N2
        1e3nc5e/dfjkLD3kIIE3xMh9NSEK
X-Google-Smtp-Source: APXvYqzPuPHhz0CquVUmE7U3tVzpWmwhBV8f97wCBVq/b7xQTKhGkAkuItfiJT/1rbhFbkaJ2uBaOA==
X-Received: by 2002:a1c:3dd5:: with SMTP id k204mr15312820wma.92.1579461548731;
        Sun, 19 Jan 2020 11:19:08 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id n14sm19542034wmi.26.2020.01.19.11.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 11:19:08 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
 <20200119175109.GB17720@lunn.ch>
 <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
 <20200119185035.GC17720@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <82737a2f-b6c1-943e-42a2-d42d87212457@gmail.com>
Date:   Sun, 19 Jan 2020 20:19:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119185035.GC17720@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2020 19:50, Andrew Lunn wrote:
>> Also it seems we don't consider situations like runtime PM yet.
>> Then the MDIO bus may not be accessible, but ndev is running
>> and PHY is attached.
> 
> I don't think this can happen. If the device is running, the MDIO bus
> has to work, or phylib is broken.
> 

netif_running() checks flag __LINK_STATE_START. Once the network has
been brought up, this flag is set. Also the comment in the code says:
"Test if the device has been brought up."
A driver has no means to clear this flag when runtime-suspending.
netif_device_detach() however clears flag __LINK_STATE_PRESENT.
I think it's not completely consistent if a device can be running
that is not present. IMO naming of netif_running() is misleading.
It better should be named netif_if_up(), or similar.

So far very few network drivers use runtime PM, this may be the
reason why such questions didn't come up before.

Speaking for r8169:
If interface is up and cable detached, then it runtime-suspends
and goes into PCI D3 (chip and MDIO bus not accessible).
But ndev is "running" and PHY is attached.

> I have had issue with the FEC, runtime PM and MDIO, but that was when
> the interface was not running, but an Ethernet switch was using the
> MDIO bus. MDIO transactions would time out, until i made the MDIO
> operations PM aware.
> 
> But in general, we should keep the running test, just to avoid
> breakage of assumptions we don't know about.
> 
> 	 Andrew
> 

Heiner
