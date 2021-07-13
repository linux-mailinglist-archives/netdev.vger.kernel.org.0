Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB303C795E
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 00:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhGMWFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 18:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhGMWFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 18:05:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E07C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 15:02:57 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u14so22734191pga.11
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 15:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRrjTozqvz2NLDgRJwuzrzzXj9t+xSxvdnv7SJITbaA=;
        b=jAjeFwqn2/l+riwKIXHVzA40ZWbsUk7izsHOqE9w8UYtXL79N9ypP0xDLn/Ry5Xmmy
         P68Uo+BFFQ7cXGghS/407TAtbaJduWkqw6KTlTbQGmX/1a41I4wnvd3ne/TCTABgt12f
         qkZCLmLltlUILnwD2K4SCJFoWNNH8vQ/btKNjmeJ2P+sYOkskr6jZ+Fv2njPC299QXXk
         Vx9su0cOZ7KUkG2b0ERNCDf3W5l/CCGl7TvZNmkSSt+vUj1zVnvgmPThGt63dmnXooCQ
         xVIrh+z3jljI7Pejik2QKpLHybz1+Pamrk9LYPK2u13KoKj5Vsx2+Jm8iWpQx8G9g8do
         tMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRrjTozqvz2NLDgRJwuzrzzXj9t+xSxvdnv7SJITbaA=;
        b=iWLMEs9XMeTkQdZSHoGF1+iDbfw7ZCy4dInHCQ6O3S8Z7GqIFtF5KXaZd2jQv1oL8D
         Xa2QF9+bVZprkuPBF5k61S4bfJbkpCtJA1G7GNgtCpK67bNtQxqpnNvj26xXp3J2O5bt
         /yo93RZao9DAsUEHv4BgPpg8ThlYj9qnK5exWs22NejR2E1roZX+X/Z0Pqqx9GFQW51N
         /KMEqyiAHrqs1YItb8ehWxTBJxCCpGCQnOJ5NMIufFNV6qO+ZcEJEJHiA2vN83K/wGNR
         jPR1TsQNPpxEewSl5ZU8C8QsFYeQfXxhUz6DYqXeZWV6mQlI+OsrJ1fbA0SpIQHDCDaz
         4s4w==
X-Gm-Message-State: AOAM533DiJ96FVhnydO79v8TMg8qdzaW2OmWlHMMtenT2SHz6/dT6dP4
        +0j5BZciHYs2Pjl3f3CODmo=
X-Google-Smtp-Source: ABdhPJyLa9VU3vB8r9cFgHab10O+1ATfVXw1ty1+fawFprhjTnb0a55Knvi6RJsjVYXCTFz3956RQQ==
X-Received: by 2002:a62:ed06:0:b029:32c:a800:ba47 with SMTP id u6-20020a62ed060000b029032ca800ba47mr6446466pfh.56.1626213777373;
        Tue, 13 Jul 2021 15:02:57 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d67sm154340pfd.81.2021.07.13.15.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 15:02:56 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: properly check for the bridge_leave methods
 in dsa_switch_bridge_leave()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210713094021.941201-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b3500ae5-c062-c885-1bbe-b0685dd68776@gmail.com>
Date:   Tue, 13 Jul 2021 15:02:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713094021.941201-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/21 2:40 AM, Vladimir Oltean wrote:
> This was not caught because there is no switch driver which implements
> the .port_bridge_join but not .port_bridge_leave method, but it should
> nonetheless be fixed, as in certain conditions (driver development) it
> might lead to NULL pointer dereference.
> 
> Fixes: f66a6a69f97a ("net: dsa: permit cross-chip bridging between all trees in the system")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Too late but yes:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
