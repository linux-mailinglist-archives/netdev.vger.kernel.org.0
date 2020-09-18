Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3083626EA89
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIRBbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgIRBbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:31:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2C2C06174A;
        Thu, 17 Sep 2020 18:31:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so2453070pgo.13;
        Thu, 17 Sep 2020 18:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EtTvg6cSleWV5SlGJcTqH1xpFDB87neekdlHGk+z0iU=;
        b=mak0D6bpX+NTZfddJ8rsyo+26fQvIZvcfzbOp9684dqCEKN0O6Y4K7VIcY/eW0uQbR
         0O3qtkAPkORWxpByZmIMostYUD2W8sBDFIKX6VNYhxcofcAoNYp4xekfZM01NTTaGbEj
         7wwrPBnVenE9qEQBxlIr8GZ8pjj+tPk2+mQ7+79OQtcIZxsJcuyhGDannKZEygiInH8N
         TREG2FNrrKqUG+gPp5fFIIQasUOoQruw104ZAMAgE0/kyRCBZ4CSmEclQHPNoorn0hG8
         G00iPZtLcRKli4BlXJ6luR4f3l7Jt9SNmb2LYhcOHpxHg8LrL96osZjtRsBKf//fg6bL
         7GJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EtTvg6cSleWV5SlGJcTqH1xpFDB87neekdlHGk+z0iU=;
        b=GOebbBRRIArmnV8KnIHHf4Uk/H0iT5Rs8s8sdyqOE6fO/kaOL4ei0qZdO/eXnNVQQP
         CIHLSbFLIa4Pi7mN/w9u9fcp6QhlXLHhEDqsUafgt4ph41F6awjovQeZjX15FTap4/O+
         n/zDuD0I/utTCeGinzKnwRdm0rvTbl2OYBIYIZh91O9vgXNMEo2BBWie46R4P+lwXcLW
         UCtmqin+7JJDDxDU9q3yCLsrUyIem5NOVTub3HRvh8MFCvqsvekLZ3l/DvqQc1ibDvcj
         bIOhTUaqUPX8GufVrC81yT4xnzSyDA4Ti//y1TfNrXv92Bz6gOSFmfiER1fRP7WSohCD
         UmyA==
X-Gm-Message-State: AOAM5321eQ6LKXcaYUhgzBZmgkLIYmGKb9/Zu+fvvb+0Yur490qO6jgm
        NTDWZ9+HTdiYgpFQ4LUZp2AGW3/N0de1SQ==
X-Google-Smtp-Source: ABdhPJz2VvBUISECUOrOIcoguzQN7Qve/qpzixRgVkDUAFfEd3TKD/pKK08wRQVL7t+3X8SDGF9Kkg==
X-Received: by 2002:a63:eb4c:: with SMTP id b12mr24846332pgk.266.1600392690690;
        Thu, 17 Sep 2020 18:31:30 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ms16sm852405pjb.55.2020.09.17.18.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:31:29 -0700 (PDT)
Subject: Re: [PATCH] add virtual PHY for PHY-less devices
To:     Sergej Bauer <sbauer@blackbox.su>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200917214030.646-1-sbauer@blackbox.su>
 <20200917221547.GD3598897@lunn.ch> <1680322.qRJ2Tc3Qy1@metabook>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9ad8b493-f6ba-a249-9654-da2a8c0c2c73@gmail.com>
Date:   Thu, 17 Sep 2020 18:31:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1680322.qRJ2Tc3Qy1@metabook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(please do not top-post)

On 9/17/2020 5:17 PM, Sergej Bauer wrote:
> Hi Andrew
> 
>    To tell the truth, I thought that fixed_phy is only for devices with a Device
> Trees and I never met DTS on x86 machines...

fixed_phy existed long before Device Tree was popular and you can 
register a fixed PHY device from within your Ethernet MAC driver, see 
drivers/net/dsa/dsa_loop.c for an example.

> 
> So it looks like there realy no any significant advantage _except_ of
> ability to use ethtool and ioctl to set speed and rx-all/fcs flags without
> removing module. That was most wanted request from HW designers as they are
> wanted to change registers of virtual PHY on-the-fly with ethtool either custom
> tool (using SIOCSMIIREG ioctl) for controling PHY registers.

NETIF_F_RXALL and NETIF_F_RXFCS are feature flags that are applicable to 
the Ethernet MAC, so I am not really sure where the virtual PHY, or the 
fixed PHY plays a role in those?

The key thing with the fixed PHY is that it is an emulation device, 
therefore from the Ethernet MAC perspective you can tell 
(phy_is_pseudo_fixed_link) whether this is a real PHY device on a MDIO 
bus or the emulated fixed PHY but there is really no need for you to 
make that difference.

> 
> p.s. And that's my bad, the original driver was developed year ago (for
> linux-5.2.15),
> but I had no time before this moment.
> 
> 
> p.p.s. sorry for long time to answer but it's far behind the midnight in my
> region.
> 

-- 
Florian
