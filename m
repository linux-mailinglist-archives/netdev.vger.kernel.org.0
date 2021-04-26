Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C998436B8EF
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhDZSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhDZSbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:31:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D10BC061574;
        Mon, 26 Apr 2021 11:30:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d124so39530868pfa.13;
        Mon, 26 Apr 2021 11:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=re9YXlu1RW0PHkSO9vPUc+GgDDJ/6gCTGSThLHewrYc=;
        b=hkn7oPvEBGN1LttLbeUy8M9Q6IgqEXbbWy2j/trewBlTlTGGHoIf6COKcsY/LsMkzL
         HIAW/PmVtoec1o8UPQyGjI3DufkW68j3fcSJrqFvF2uqmnCCBep4MtiKX42DuBKGuDUQ
         SDC4QkUbPk8oS9FSfFfQxPoykpeNczGFP9YcSV7RG1H+yxeA19U6j/5Ajn9rJdwuEe5W
         qq5YkWbm+sDEPDKr5/jDTUz0lbm8bV6lqZgweh50SOTYG9cPDZQqo3Apyjn1EVfQKi5y
         1DQdD4fXlHsXsALeFNsI7kiUVgp5/qxi5mhhsnR5uDRbtq8IUCzFMHLbwWdz1wgb36IP
         cGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=re9YXlu1RW0PHkSO9vPUc+GgDDJ/6gCTGSThLHewrYc=;
        b=Op9ucUW8M43gk++puxHAdW3BqLzPlyo7jJ6Gi9nUnLzTzjFIQM7sWj1FUfgX8Aseg/
         H53zfjfSaIUcYYEZxTKGlJD8yRxq1nSdGaMiwkAH/9nnBThBlb7b30wB86vmnw47LXFz
         7tKg/4Qo2faYH5toGIuOthP9Vk/rGMsYRhhSl50er90gvLv14ugryvr9IUF8u29Di0S7
         JbPS6yrRdPOI22pC59U9Ou9CXx0hKAk4RJJ87g8ycRe5AvUoE3e2FUJQjUe7/2FagaCF
         4KdhK4a0m+q3lNnzd4bg+ze1VoNhIqB2ik2VNocPRif5Cvhx/zb+sFgIe8bymkRBjSDV
         4DeQ==
X-Gm-Message-State: AOAM5337/EEvU6J8sTHKb9MIpe2ZgOT1byc7pEhnKOlQFmaULUwgxlrx
        XKkWGBkeDQH+PfyAdC5IrY6RevmOeOg=
X-Google-Smtp-Source: ABdhPJzT6w89betG1dY9r0wgFmsINekBrwmLCr+WTIO2/Kn4V3pLm9pJbD8v3aSRO55YR5H2PYhvrA==
X-Received: by 2002:a63:fe12:: with SMTP id p18mr18059965pgh.425.1619461839037;
        Mon, 26 Apr 2021 11:30:39 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c9sm353890pfl.169.2021.04.26.11.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 11:30:38 -0700 (PDT)
Subject: Re: [PATCH net-next v7 2/9] net: dsa: microchip: ksz8795: move
 cpu_select_interface to extra function
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
 <20210426131911.25976-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <404beec9-9d59-5a22-0aa6-ebd5273f9570@gmail.com>
Date:   Mon, 26 Apr 2021 11:30:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426131911.25976-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 6:19 AM, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> This patch moves the cpu interface selection code to a individual
> function specific for ksz8795. It will make it simpler to customize the
> code path for different switches supported by this driver.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
