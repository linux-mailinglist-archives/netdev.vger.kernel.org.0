Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3D25DDE9
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgIDPif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIDPid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:38:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9DEC061244;
        Fri,  4 Sep 2020 08:38:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 17so4798453pfw.9;
        Fri, 04 Sep 2020 08:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BJxpqu43WPrjXCG3OBwkVL5agn2A1TalZ/T5szH2Mwo=;
        b=kyVx/t65aYIINnU+muXSJ9k6NjqCLD3Xc+1zNSM+z66ix44xaMlrHKSWBbj1BRXtb3
         k0d/0gAxEBAqUX/3Pk6NWD3iag1eydj0XiDZLzDKB6Bx8X1IdDa8NG317O5VlyEL5pFK
         PiiWh6pbmotZEE0HUMVpBOHp8vIjsFcWNLO/7K2twFmAxKhOLm8sB1vYb5lMSatv3Ore
         i+mg3CZXyQvl9zmLm8RgiUivbjOPLTo4pAP8UWEJhxDrnYKtUFrXo2qz3MpsQLtIkq4F
         4LuoPxR3mDB3QDoy1qksBt6h3x0K5y0SkTgHiYM/z+wWYxFuvjV0VNYvMLySyfxK3yiw
         aOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJxpqu43WPrjXCG3OBwkVL5agn2A1TalZ/T5szH2Mwo=;
        b=nze6N+IHuYZ5Y1hxunDQ1YRW9hEj6mz7V+ODMEEbli5OhxT8m8wVjEatdiek90BbbR
         +yrcck2KAkdGxaszn1OC/Ax7HYDLr/0/4GPxwUfB3Mz8v9U5kTnynmr6uR12Q2iE8JSf
         ivh2bnCbHrQSVF4/qarj8/8S/7AB2I/m5PYEJ599gyUgwBFjCuKmtT0Mf8OKiBP76iY2
         ms3ScEF46fjx4B667eiwrOO7r/A08gYefmJxvSm1n0Dru4QddMZzXfL5I5ddbkIZ8vxQ
         NOJ+J//Wq6pMLnFTjU4LaxE8dXBWSMKlx8HAOOAbnHSUBe2JKCPWuUOvAZuRbIbGLv+h
         sHZQ==
X-Gm-Message-State: AOAM531PJAavdYe1b1BpAN/Qu/F23a+Xd3MU8q0d3X7iXjdu8haCu+Ah
        59oimZDe0xZi6K2zlIeZOKc=
X-Google-Smtp-Source: ABdhPJwHk2XFByv8iEc/a+QpIpJdhgz2fGul/zRl5OWMXu7dq6qp74wy9/hH26SorswgtirXArAV6w==
X-Received: by 2002:a63:4621:: with SMTP id t33mr7823860pga.32.1599233909166;
        Fri, 04 Sep 2020 08:38:29 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e23sm6042489pgm.1.2020.09.04.08.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:38:28 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
 <20200904061821.h67rmeare4n6l4d3@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11e7a470-fabb-d679-e254-2a7acc354fc6@gmail.com>
Date:   Fri, 4 Sep 2020 08:38:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200904061821.h67rmeare4n6l4d3@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 11:18 PM, Marco Felsch wrote:
> On 20-09-02 21:39, Florian Fainelli wrote:
>> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
>> drives its MDIO interface among other things, the driver now requests
>> and manage that clock during .probe() and .remove() accordingly.
> 
> Hi Florian,
> 
> Seems like you added the same support here like I did for the smsc
> driver. So should I go with my proposed patch which can be adapted later
> after you guys figured out who to enable the required resources?

That seems fine to me, on your platform there appears to be an 
assumption that we will be able to probe the SMSC PHY because everything 
we need is already enabled, right? If so, this patch series does not 
change that state.
-- 
Florian
