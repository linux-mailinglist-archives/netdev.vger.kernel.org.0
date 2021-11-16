Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D727B4538A5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhKPRkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbhKPRkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:40:52 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A6C061570;
        Tue, 16 Nov 2021 09:37:55 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q17so18020789plr.11;
        Tue, 16 Nov 2021 09:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Avnkwo+NdfUbgiME5i/jn1nWRwSrj/TazejVuhgdQUE=;
        b=AUyMZ5ZNcbb3dRSeB/VwdSssBiooyQeFgw8LCEIXTMkDXRWqMMe/1eRYinhMz46rVZ
         SVKTZw1dMJpwPAdOVfKXVDHJImAr4bi1mxtxEHt0QKa26jF1SJ2ngi0rvKUuOdwOL43M
         iYp1yVxl1jmdN3fuY3vMzoY1qIe5e0v+dJd8Ein9R35ossqdbwAyDrqEJiIDh/whKvOQ
         6vqg4RKjF6h1Q/+iscDN3yl0htn66jDTSt00cbmxpSwOAvzhJMlZnQvCftn5AlaKISJQ
         lHK0tKAAy2Q6K96yn9+Es9MmVYS08p4yX+Tt0LPwF0D6vzHDpNrb603Gue5uUCfAckU6
         GlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Avnkwo+NdfUbgiME5i/jn1nWRwSrj/TazejVuhgdQUE=;
        b=JUDXRM+SXZUxHzKh/9PyYCIpg8GkJ3Zdnop7mS1nBwPNeF6BqlhlXyptqwt71mX6jI
         ksVoDlgqlB9VzzflQZv6By3GQ5pifNe2WA/t2sc+Wj18MoH3GDbifoz6XBobCF2snm2x
         4JapURWMQlCaPz7BriIjXCXsl5Y5UBNz+eQCEq8f0WkacU672bGeE6IQcTJG7aGVVc1I
         BeEOJOefY8l2XUSKvsxlAowpPXxbTZIDBbQgHHqiEjylCyaFXYCj8SXpuikSmojCEtiD
         dEPX4epF415RsuRYir5lsOZCoeHuqzbDnmtaSTKHE5aGmaXGw1yUEZHpUrhYWUJV8OQ+
         plWw==
X-Gm-Message-State: AOAM533hD+1Uruyknjt63xnyMTvmgo83BzWlQrCSxYZyxKodCRGorFg1
        rHn74QlMcQbd2FvSpZSwIMI=
X-Google-Smtp-Source: ABdhPJzveQMt5BmvTLAMIzYFZ+VD9CddyxCA3SyXLR0VL0963Lr3WvNRSJr+nMPVS247RLGyewBcCA==
X-Received: by 2002:a17:902:c202:b0:142:2441:aa25 with SMTP id 2-20020a170902c20200b001422441aa25mr46894647pll.68.1637084275105;
        Tue, 16 Nov 2021 09:37:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q89sm3103266pjk.50.2021.11.16.09.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:37:54 -0800 (PST)
Subject: Re: [RFC PATCH v4 net-next 01/23] net: dsa: ocelot: remove
 unnecessary pci_bar variables
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-2-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5a01e036-e6dd-2102-212b-0cc21c91e331@gmail.com>
Date:   Tue, 16 Nov 2021 09:37:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116062328.1949151-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 10:23 PM, Colin Foster wrote:
> The pci_bar variables for the switch and imdio don't make sense for the
> generic felix driver. Moving them to felix_vsc9959 to limit scope and
> simplify the felix_info struct.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
