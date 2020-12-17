Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897EC2DCAE4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQCL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQCL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:11:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3091FC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2so18016673pfq.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZrhHrjBJs7Tm3e2nadprPzf32VbBFA4phNNK3iPgWog=;
        b=G+Sr7kxqDYwzBySNZNJkmz5YX74lhObRoUM1J+f3wizdTjSuwpEOUoAn4Be6KN47BR
         QCFiMhN/YdVw2GtaKUMySdPikcYB2A5hcjaa3fYjqSuU7ACD903JhLsHEXZW/oybaEuV
         kg6jP7Kqu+3lYBCzI44RIiZN5sS22a/07nE5z8fBSImNkzAtcoapAXPaPCMIqd3PiENg
         c8iIoMFlrkH+ef6iVG/B1ABbhiOVp9tgDXH/FpXV0Km6HddR6K5vMpLCxxQbXOjeMQ+q
         ZidFN7hSkc28KPO07UJbs4LNyf1h/HaewfFbhiId9KZvvqWXm5xIQQvk/F7xcudrRqHN
         N9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZrhHrjBJs7Tm3e2nadprPzf32VbBFA4phNNK3iPgWog=;
        b=o4l+Ff2wLEtXM+wLHamxEK8rhAuN6W1x1iHhtUFpsJmNMETg3pUFTK9+mR/rBQLTTZ
         BdX2rEvlSqQ31t/PgwpJoAyYczWmeOzydlYlXCZRecy3tL+Lsm7a7OHaFDmliZjBUA58
         RkdE6ary1ZwXDug5uXtOQ65MW34qhL/tjUGGQBELWv2s8wAIFEQAE6WdsQWe/559sAEA
         +kSvvoXmLJQ4YX+F7sJmJlD74GIQucyb/ROHwN6qzmZ8lhkuLyT+Xxo55lM6MSVIe5zH
         f2NY/VbEicvg3La0mkQcdL/epXLuESLfncyvhlZNC5nfO2K1bWQdspr4R8IRPuY/con0
         nNdg==
X-Gm-Message-State: AOAM5336B0cO+d7wBat5DLRr/VPPah0Uqpj6VqT2IufzMo/xn3aQN/65
        GAzzpWQ9qSQfCI6ObnUdc3c=
X-Google-Smtp-Source: ABdhPJySIn/i+ECw8EcmTC4A5fU/sEO0/nTpP/Bij72YwLAg+1k9hxocT9Zq1cvvnOra2WKTonzGOg==
X-Received: by 2002:a62:184e:0:b029:19e:c636:17f9 with SMTP id 75-20020a62184e0000b029019ec63617f9mr29703571pfy.23.1608171077723;
        Wed, 16 Dec 2020 18:11:17 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l1sm4263044pgg.4.2020.12.16.18.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:11:16 -0800 (PST)
Subject: Re: [RFC PATCH net-next 6/9] net: dsa: remove the transactional logic
 from VLAN objects
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
 <20201217015822.826304-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc37eb2f-0c14-efc0-2d41-a8f6893a61b6@gmail.com>
Date:   Wed, 16 Dec 2020 18:11:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> It should be the driver's business to logically separate its VLAN
> offloading into a preparation and a commit phase, and some drivers don't
> need / can't do this.
> 
> So remove the transactional shim from DSA and let drivers to propagate
> errors directly from the .port_vlan_add callback.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
