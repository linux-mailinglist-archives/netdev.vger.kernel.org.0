Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6E26E80D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIQWQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQWQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 18:16:34 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2729C06174A;
        Thu, 17 Sep 2020 15:16:34 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f1so1853109plo.13;
        Thu, 17 Sep 2020 15:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywkgIpwld/FMaMli5/HwP3hx315xEIkzM50or8RHF+8=;
        b=VCzGC7gbkVO6YjPDzkTh71liI87nlMg+luII0WdIoxlSOiQKIV523J1rzBTp42htrl
         +oC4XNf6ous2Aj/Q2Bugo4kLh4IKfzLE7sJjfnhIIbLUNdCRkDiKzWv4P6tbshMc7aFV
         sv5ph4X7GOWkZECOQbO2K/+jzFu66WAhfkXhXUswas9WJnJjNhNCy0mqL5UuLpuhlMTL
         8b84VGuRnc+xVDQQm0HCUma+SUOOX/93M5m/vLP2V0V8f2fM5gP9GIS4nHMdDWvJvDC0
         HfLvjYEttmiXAY529sxZLRc0AOprR1LhRMbM0bDnME186wfB7MDcI6K/ig/DM3bkRKLC
         obCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywkgIpwld/FMaMli5/HwP3hx315xEIkzM50or8RHF+8=;
        b=hBuJv08xxdinz0DaMS2IUFe2GSIRxU1Uo/YyLYUuY9SWwB7FrI7pztxyDNSjqhPf4Y
         0beUKwJzKjLTIMVn8skv513quHXUiK6diKd6FFDJoFqhTjrIRkVzhMQUcGcbp4/RO4lF
         use4Xe9zZ1o7QOPIcInlU0sBdEh840hMdQWeDnEaqcfaEE9Ra5xZ5aBg3RHJ8cBUkG0w
         hKL4/g6JWz24wNozDxXIArTkTInK5I1LvBgV4+kb+DQ+ZQL4sPg7HXQrOMhVRYu6zTa+
         GEGN1OsgqO/tkm9PLXYn08W5ErdNMMHdW++Ic1vO08lHfSvi6kmG4/VPX6GpBbcJ4rNj
         /Njw==
X-Gm-Message-State: AOAM533yYI0vnKRBrtDayaWwp8k/WSdAhI+HJT+pMQCbhZDylsoZvthb
        PIrbzJseWl8pRMGxYs8qXKsNbtd4xfd7Hw==
X-Google-Smtp-Source: ABdhPJyhRGF7DX5l1zlxP8sMd39l1T7ioMc/EQ9RaVwBuQmoNBeoPChHeC0FZ857A76hwIqTE7XdCQ==
X-Received: by 2002:a17:90a:55c8:: with SMTP id o8mr10036858pjm.215.1600380993619;
        Thu, 17 Sep 2020 15:16:33 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k4sm661252pfp.189.2020.09.17.15.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 15:16:32 -0700 (PDT)
Subject: Re: [PATCH] add virtual PHY for PHY-less devices
To:     Sergej Bauer <sbauer@blackbox.su>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200917214030.646-1-sbauer@blackbox.su>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b708f713-4840-7521-1d3d-e4aba5b3fc5e@gmail.com>
Date:   Thu, 17 Sep 2020 15:16:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917214030.646-1-sbauer@blackbox.su>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 2:40 PM, Sergej Bauer wrote:
> From: sbauer@blackbox.su
> 
>      Here is a kernel related part of my work which was helps to develop brand
> new PHY device.
> 
>      It is migth be helpful for developers work with PHY-less lan743x
> (7431:0011 in my case). It's just a fake virtual PHY which can change speed of
> network card processing as a loopback device. Baud rate can be tuned with
> ethtool from command line or by means of SIOCSMIIREG ioctl. Duplex mode not
> configurable and it's allways DUPLEX_FULL.
> 
>      It also provides module parameter mii_regs for setting initial values of
> IEEE 802.3 Control Register.

You appear to have re-implemented the fixed PHY driver, please use that 
instead of rolling your own.
-- 
Florian
