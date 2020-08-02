Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F6F235A78
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHBUXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgHBUXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:23:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C08C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:23:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so18770213pgb.6
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=ouFy3xST0DOgqc732Tyy3Gvn4wJQRq5rlFeZ+HduavGATQBfAAZZrQROMKeE+1d80/
         Po2fBiwk8sSM9mIqLG8HoDHZLTTB1r48fHIT9F4HoP52akp2fv5IOxiZ/fpJTapDIxav
         OfI5Dp6tIWHFr7LCuCFz6ftEaV8edG75ZwTgx7bhl4DwZAsIv8RDcggdFxY0AIq7uYqc
         vZ0vkc3dxZ28OmBfe8bEceY4NNoI3gQnjDkOJ8c2ovF2snr5ekLqGSVfsChwTVLB6rnF
         WRYTP/7kKizXKC5WAGqFF0qGwZJ2V7LBfJp7qVlT9ZaBaRN6VbWhvB0mn6QS4yEHEtVP
         av+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=KhjgPDjYni1GEJr1TS/iy4x9rH1cWonkUW6LSymH/wrEHqpMcJ0+WTCjz6XlgWVWJC
         Prh2gUNmcdDEIkPs/iHgF/NSieUWeemEi6AZP3zq6PNI6WCHHXACfmHsYBqfviIH7sSB
         PcVNLQdrin1SiP2IM0Wq8+QyVBbWKVDqpz9wyDxMLULcLs/7w0F1DorrrC0/YVOFIeTB
         dGaLH7fdRBYIzOeZWLYu4BWy/sZrtrZ3LxCq4yN9ub10JPH5zGnAmUZkIerWKzyKqDEF
         SNNInJnE5El97JYqDc+aIClOHoW0STR/2NH0WkPicvxpgl38eJ/uzw0DUoetRxxX4l37
         /oww==
X-Gm-Message-State: AOAM531FqjDHFyPnUk23XU13P7vkc7HiVyM8oJeFY8AoroFLB+zFXLJS
        EW8dOpBoHTmPYcyxlbHCNsI=
X-Google-Smtp-Source: ABdhPJxVP84Mn0XdEieStI3S5fV2euhgLrYpCezp8Cv3jYh3cq5c8EsToL5bVpI1/5R5Q2ZdQeQZ9g==
X-Received: by 2002:a65:5c4d:: with SMTP id v13mr1965745pgr.6.1596399787615;
        Sun, 02 Aug 2020 13:23:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a19sm3353723pfn.10.2020.08.02.13.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:23:06 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] net: phy: dp83640: Use generic helper function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-8-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e909abb0-d73f-4bc1-b667-37973d6dc708@gmail.com>
Date:   Sun, 2 Aug 2020 13:23:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-8-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
