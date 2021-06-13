Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9199C3A5604
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 04:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhFMCH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 22:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhFMCH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 22:07:57 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6C8C061574;
        Sat, 12 Jun 2021 19:05:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e1so4754127plh.8;
        Sat, 12 Jun 2021 19:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HK9QkMsSHMCH9F1POXVVodHF5zTfkcy2ylP+LXUUESY=;
        b=Zo/7U2HGGF/LclKXExjbJ0Pxo1EKJY4m57Tgqp08olqW3Z6OkqS5VSZLb8+v9SZxf5
         KLEe9En5ePjtLZ6dW8BKLwnTk7JgDey/l7KgQ5FtXWb43riqaz2sSFf84xlSqvXXky7J
         LWyQ8pe1EyzoD7CtlNAbQmmuPi7QbpjC8URZqJEWfepje80n+1PgdUKNPgEjgoE/qAUD
         5N3JgfUV3ks7r/M1jIkzTLSDd6eovpGMskdCIoAV2XnhywETi1FIg20QBOrxZC86Hp1i
         vmuRQNpQdwuY09x9TKRbYx59KYuZIi+6Xy3h1oQSodoEAONcKxkrazlGRZ2i2IDqMW+i
         4S0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HK9QkMsSHMCH9F1POXVVodHF5zTfkcy2ylP+LXUUESY=;
        b=YWXHUHOcF0iAYePSAhv78ynKqXYv3cjOvPNmtOig6UUBu3A+mcsDxb7K5Gd4FMx2Zm
         9Srp7FcnV8mE6oBVUALUSfhcsH2wuVgLr9vrdRajkIJ64rEUOjyQ/jpxRx2rJTtPrWb+
         BndE6z7O5IgsbecHnzBmEMR2oI97wcFmcuUXiAGafrlGL5C36Z5jCC8m0pI62E/bLrs2
         VCcZ3mYrqOfpzYjjhBqVqmFF7+n1/nk8cClBRh6lp/DSPogRX4XnCYlv9JGJ0CPM1k+C
         ek8ngnKxoLW2cyyrH7KyHa0+7RBdfbe3n1G/SiR7RwJ6xMUi0pm/XDSSPWU+XJxJX+xI
         F5bw==
X-Gm-Message-State: AOAM532a5VQd8lqx5+gh2XhEPGWHjsPdteObnr1QtLaqMl0Qxsaj7+2G
        8Cr6xF+FiHyIVT5bv/WUc6o=
X-Google-Smtp-Source: ABdhPJwVGGM3rOB5faaggN7Vd1V1bZ2QBEkWZ8KqhpetpPJq0mSpnMN7zx5GS/PSKX7cAHYT3ePm1g==
X-Received: by 2002:a17:90a:fa04:: with SMTP id cm4mr5791025pjb.111.1623549944407;
        Sat, 12 Jun 2021 19:05:44 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u7sm9116070pgl.39.2021.06.12.19.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 19:05:43 -0700 (PDT)
Subject: Re: [PATCH net-next v4 6/9] net: phy: micrel: ksz8081 add MDI-X
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-7-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fff4ba6c-73c8-57c8-293f-ba13247c251d@gmail.com>
Date:   Sat, 12 Jun 2021 19:05:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-7-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:15 AM, Oleksij Rempel wrote:
> Add support for MDI-X status and configuration
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
