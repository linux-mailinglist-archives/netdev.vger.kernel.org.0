Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FFC3A5607
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhFMCI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 22:08:27 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40449 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhFMCI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 22:08:26 -0400
Received: by mail-pl1-f174.google.com with SMTP id e7so4758687plj.7;
        Sat, 12 Jun 2021 19:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HK9QkMsSHMCH9F1POXVVodHF5zTfkcy2ylP+LXUUESY=;
        b=MHAOANyD29AhE2dTY/Y8agJk6DREkCcgLEkU7L8kQ9jfLSbehNtQQu3YzfpnYY+xfn
         jOb4wIAnV9G3MrkhA7ZQkBywbl4Xu428c/ERSojAOkFcYXrFA9pQjWYT5eEYSc48HGVl
         s4IHiS2j5LtXFOQGm4hUxAdSCtT7JkLdVELStRj3RU+GXVlKpMvIWFUR9Gklg4DOfRRv
         w5APMtCWHy6UqxBu3tnMMWu5HYczC4Iu4d4lcVvannjxb2UbE/yPRkSZyrNkC586YCQL
         +kZu9TpvngT/Q7aZJ5+CXMmllGm8c8zhb8uFbVzco6sV+com4K3e0icTq77LzJTHGuha
         +iFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HK9QkMsSHMCH9F1POXVVodHF5zTfkcy2ylP+LXUUESY=;
        b=sPe/11sVqj2SZbjGpLrrIy+p/EvjGfkUVzyczJCchq+XomP4eYz8Awn5uQEm6OzV2r
         6KvjKY2PdBTGgGuTUUsNWvDW1Q3l0Ufs1aAIpcNd29IalIbDLCBnfvqD2KF85zyLLRCd
         3VPGHzQSSs8kiII69u+LhZhQkFwELS/I7pkQni6zzCQsBNabDYU0uQCBGcx9QKS4mBxd
         9GHxYirbNiMsZqqza9hNCjNQUYROyVsHgVaVqlz2h73YR6c3hGNeGpiJYEsIzyY6Jscw
         nTPRht7thaBpKlOQYE0LdlZTrbmxpb5wwwLcPlQ9Rf6W6eRhw9ta8x6XZbMFTzHDQ3O4
         PKMg==
X-Gm-Message-State: AOAM530j2vf5sC6G32uQS8tN3v9aiolDwKqKZcZkBNh6zwJDbghXINZM
        nNxD1II4anvBpBCYs+D3VQo=
X-Google-Smtp-Source: ABdhPJx950iON4FYls/eYzbZkGwMuAgOyttY8yePbaRfAKAfExxwiaWI0BHWJiOkL/NMsS+FYfLsrg==
X-Received: by 2002:a17:903:31d3:b029:ee:bccd:e686 with SMTP id v19-20020a17090331d3b02900eebccde686mr10850437ple.1.1623549913212;
        Sat, 12 Jun 2021 19:05:13 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm5079835pgr.46.2021.06.12.19.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 19:05:12 -0700 (PDT)
Subject: Re: [PATCH net-next v4 5/9] net: phy/dsa micrel/ksz886x add MDI-X
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
 <20210611071527.9333-6-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9cb4d9fa-d817-dda9-35b6-1bf58bba78b4@gmail.com>
Date:   Sat, 12 Jun 2021 19:05:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-6-o.rempel@pengutronix.de>
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
