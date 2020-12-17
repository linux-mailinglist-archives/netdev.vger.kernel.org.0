Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B734B2DCAD3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgLQCHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgLQCHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:07:42 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248A8C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:07:02 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e2so19226987pgi.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3lJp5hP3qImK0dLlNOW5DkSYRwLOLRZKzNPDhKGTSY8=;
        b=Dnb/7NhQso7fLhXXZN/AsuYsPIs9kxihpVZ1mJVox0k/rBthA/hsyd1OCS5pq4wJ/T
         hQK/Q6tT3uls+8LCSmH64mDahp1bHo1C0zhJ601GpH0bBr/xubZ0SSoVR0kQ8UocVUB1
         c+SUM/OoAep7Aq2n4NO5clPRgPaEGxA+XG+MylUz9f2F0tUawFOM0IKlK1jmrZadfDmg
         uPqP+MGGbJtijMLI3GTBYOPbSgh0Ggqw8/J0RfULre1rtZoC/C0mWdOHRAgVlaalV8xx
         aTk+dmIJenW3ojOzU+3n58QLhV6r/grcxM1Flgy5P11LxmGGZo99CxQZmb8hqBWkrpSo
         Ej8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3lJp5hP3qImK0dLlNOW5DkSYRwLOLRZKzNPDhKGTSY8=;
        b=RWF+5vmUZxY2x7C3yOxw2jxhViTwNv4vRoXHeHK0rAbkgMAmSiUpO2V7UxaiJlcjAn
         JU4DkZFshZ1v1ClD+xecwtGXrV7YNA2ubbnw2iTOqPoXE84AHanF8+S6bB4etlVsIODX
         ONRhjjBQPNG5BA/weajZN2OkbgfB99o4n6ARlds1NKFrGa8/nnEvPTEGaytohJ2XfHtE
         Uva9PMx5qN+jdOPxzIqnuqSso4RWR/NFep33IVoKdiEfDOo+oi3v270YWtWfYl9TbQir
         wWcaW5tP3IyF7JWQXrRN8KcH1pXazOA+CsRuyUxs4nFJ0K38NsDgZoRJqIK4WZym5jpS
         /IVQ==
X-Gm-Message-State: AOAM533eeNtR1CVwMV0a8zBPXOK3uF/E1zvFGWUDitSbZe/LxMffY2gt
        ztzPZJwqmb0HNC+PRqBhOCo=
X-Google-Smtp-Source: ABdhPJyP0ZGhZWlJpWhFNcsCb5wCsVnQJn5N+0UodipIsuuQU+488Rs92m+/b8xQ7dIENDskz1I5jA==
X-Received: by 2002:a62:764a:0:b029:19d:9fa8:5bc6 with SMTP id r71-20020a62764a0000b029019d9fa85bc6mr6027858pfc.76.1608170821578;
        Wed, 16 Dec 2020 18:07:01 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm3971810pfg.18.2020.12.16.18.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:07:00 -0800 (PST)
Subject: Re: [RFC PATCH net-next 4/9] net: dsa: remove the transactional logic
 from ageing time notifiers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <db465610-01da-97c0-3bbe-3f9f55f0e6d2@gmail.com>
Date:   Wed, 16 Dec 2020 18:06:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> Remove the shim introduced in DSA for offloading the bridge ageing time
> from switchdev, by first checking whether the ageing time is within the
> range limits requested by the driver.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
