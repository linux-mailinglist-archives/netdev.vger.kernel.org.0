Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F200E49C206
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbiAZDW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiAZDWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:22:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABCBC06161C;
        Tue, 25 Jan 2022 19:22:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n16-20020a17090a091000b001b46196d572so4863078pjn.5;
        Tue, 25 Jan 2022 19:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xWzUyrN0AQfg7IVrbfad7N0sE35bu6ZFef1Mu1uuBPY=;
        b=cI1+UB+46MTZG9VOm9EGxOHVIMXGh3h+OztfulizsLROlIKpZtjIfcZmjEJPYhRCyM
         VLbPm/W2/ItheXCJGwSkOvDbnRhreUSf9t9+PAI49aj49f9zC0z8KW+41sB9CSZYEGQ/
         HF3Mq48c5SFifyXOL4JDnMHsmz2nczfXIqF2a5fBZDruEGKm9SSzTygNF2wJLYfntekX
         YlMM6X0Ps9721wZVoGgiNW9nAdF4x6jplTkOFaMERDdGtiPStUo9dydyST2Q0p9uTo+F
         EaG9UHlHh2zHwrHNM6j9hCpqBZiteJup2Nyw7nICY8KlnMk55UuYVs9+wSQJFJ5vKtSy
         8f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xWzUyrN0AQfg7IVrbfad7N0sE35bu6ZFef1Mu1uuBPY=;
        b=HE0hzo6nas0XQXF/7LppFG4gFqTqDFj194kSOHo0wdrvHGR3AAXYHiXQIb7qjye03U
         sRWpu/CYIXZAPZnBbOlgS07ySYp+n/0MbqdQK+CsfYQt2J4pmn8nIvSTWb3Tp7EuN5tK
         +Wh2Q1Qu7QEe+COX/IP0T+VK7Ecd3e9llxYFeLpVukEvLUtPp4Igp4poEYOKI9/kLVVE
         Ko7U1fhtHggvYQAcoWBWVIYthoxZ2KEldGulBlbtbAkr1c2HxGZYKmDreuAf/E2/CIF+
         X7coWOF04OtdN3Zn5ipXl4RIQ5nwa8u37EVJT51AooTDji4sqeTFYyOuQpwFczTOo07G
         4R4Q==
X-Gm-Message-State: AOAM5325VUWpDJ+T3nAVFPLtxmKieXkTEUKpEAjXlWkM6x3Jp95aTFJz
        fu6uM7r2OV3Su+FDm/RLuLQ=
X-Google-Smtp-Source: ABdhPJwzZmWLdn/iSxMI2E2VGJ+4ueBZdwhhtvUm0T8mPt4YWWSF4u0FyQrVHYCzwYIARNFgF+hjRg==
X-Received: by 2002:a17:903:1210:b0:149:8d21:3e43 with SMTP id l16-20020a170903121000b001498d213e43mr21199964plh.83.1643167374017;
        Tue, 25 Jan 2022 19:22:54 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4804:6add:baaf:69d5? ([2600:8802:b00:4a48:4804:6add:baaf:69d5])
        by smtp.gmail.com with ESMTPSA id q140sm16255303pgq.7.2022.01.25.19.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:22:53 -0800 (PST)
Message-ID: <f1547841-2210-ec68-3111-333bb7468b34@gmail.com>
Date:   Tue, 25 Jan 2022 19:22:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 01/16] net: dsa: provide switch operations for
 tracking the master state
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Certain drivers may need to send management traffic to the switch for
> things like register access, FDB dump, etc, to accelerate what their
> slow bus (SPI, I2C, MDIO) can already do.
> 
> Ethernet is faster (especially in bulk transactions) but is also more
> unreliable, since the user may decide to bring the DSA master down (or
> not bring it up), therefore severing the link between the host and the
> attached switch.
> 
> Drivers needing Ethernet-based register access already should have
> fallback logic to the slow bus if the Ethernet method fails, but that
> fallback may be based on a timeout, and the I/O to the switch may slow
> down to a halt if the master is down, because every Ethernet packet will
> have to time out. The driver also doesn't have the option to turn off
> Ethernet-based I/O momentarily, because it wouldn't know when to turn it
> back on.
> 
> Which is where this change comes in. By tracking NETDEV_CHANGE,
> NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
> the exact interval of time during which this interface is reliably
> available for traffic. Provide this information to switches so they can
> use it as they wish.
> 
> An helper is added dsa_port_master_is_operational() to check if a master
> port is operational.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
