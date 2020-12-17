Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645912DCADA
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgLQCJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgLQCJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:09:28 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5BDC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:08:48 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t6so14257011plq.1
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A4+FzcbcwJRZytxJDlKtjCsziKZBFBeTFiNSiM+M/uc=;
        b=icIfwfPnUBiETMNKgx00NDR3paFi0rqGdkGSX7Ay73KBH4V+JIDXkN0EktlcXApxdT
         EtnC/V8sgpFo3HgLkmxy37Ve/T4Wu2UX/NHRWfTAVKBwFPb5LU9y+RHhfO4mhsWQpmxG
         MN+XkOKhGKJc9mEp0PfwY9EHbl08DPqQL/oV8W8/b0GgrQO83NABLEwGJYZ+7QyYt3Cz
         BmKSzdWFT4dgz1BmWM1GN351ZIqUlKHbJhGdObrl5q/I/BdY6GGG0zt6T+mGKbKL48cz
         dO8voBQGmW3xK2NR6b7+8htWHt9CEos4a8E1Nb/97eyMB9DxaPxcbIIE3kXBLzdTz5C2
         fvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A4+FzcbcwJRZytxJDlKtjCsziKZBFBeTFiNSiM+M/uc=;
        b=NmP4EZyQkfHovEJWKXtM1ndDft1IL0kgWVMxL1lxk6LzBdjwu2LbpyTO0ecX//fFjk
         2Ftl/pK97wiyrEKXEaRYWg3hRZKrZyOChvN4ZSbQ+yBNYVYE58lU42qfrVDINhGAfXbN
         Aa8OxgHR1EVtIVnx/p1zkido+tU9PPpFPvFfcV3BqjfN6t8BTSj7Ln3WXKpaNpj5NuiS
         3uCXyoxL8K5Ys7b6M63MFi6mYKrBAle4FPuZnqRQM9eDEPINi5KC4pcPr4A+I8pkW/nu
         Eh694xRLOAMnyEKjyoDMXFIvGL6/njdmzX8O6a7/i3ducClw9F5IyX75iIrOlvNwb+9L
         KTfQ==
X-Gm-Message-State: AOAM531wQHYUMcB0TcXOKy4oqdt2yRQgK7ejslZSjW+SgQ/IQMYEPmZu
        pPkcpEbtllULCPXjRpLRSEI=
X-Google-Smtp-Source: ABdhPJwo2pi9L/u/wvNE0DPcB9PAans3E6KJLdZS9qwVZ0Nmevloy7DivoV9TMp1NDfH+/+5NH0SsQ==
X-Received: by 2002:a17:90a:c82:: with SMTP id v2mr5577865pja.171.1608170928263;
        Wed, 16 Dec 2020 18:08:48 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cl23sm3229790pjb.23.2020.12.16.18.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:08:47 -0800 (PST)
Subject: Re: [RFC PATCH net-next 5/9] net: dsa: remove the transactional logic
 from MDB entries
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
 <20201217015822.826304-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <73b1ac8b-11fd-0494-310b-cea4ef476647@gmail.com>
Date:   Wed, 16 Dec 2020 18:08:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> For many drivers, the .port_mdb_prepare callback was not a good opportunity
> to avoid any error condition, and they would suppress errors found during
> the actual commit phase.
> 
> Where a logical separation between the prepare and the commit phase
> existed, the function that used to implement the .port_mdb_prepare
> callback still exists, but now it is called directly from .port_mdb_add,
> which was modified to return an int code.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
