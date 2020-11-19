Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33F2B8A57
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKSDJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKSDJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:09:23 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CB3C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:09:23 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id a18so3075452pfl.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogu+5F25AoCpa/O1kI0lFvX27pt3/CLNad6y6eSjfKo=;
        b=M9zazUBiQVgElNxy8axfnY083HgUe/L/gnf9n8G9vnQJ4t8YIYPkQQPvzG1RmUNgg5
         oRIRVtvNS+I03e1svFKeWiI/M0BtPQH/VK2pkB8/36Mwzk/7oyMN72+qcgYh9/yswsRU
         3S5pkoijvqyRb/J/mp1w/UMigGPP9I3V1N+HFhSLEBip/AhcfrTg83hSFzwLQUM5P4sY
         m683Bl7lKjDpliu+QElqtR5pIQFmiTjkth0QJwUfOrcsOhHeI4xWNRrO5Nt44k59uIaa
         NlYLTKvHMdwbI/o1KmcsmtkehDK4CaRojMAu7FwVEOCrSUa0QyMGNzPhkgWg07fK93V/
         afPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogu+5F25AoCpa/O1kI0lFvX27pt3/CLNad6y6eSjfKo=;
        b=udPvHiNavIowR3yeQZfvW6WULGWKvqJKTJHyN451pQq8cK7LtdYmjpLG+AtkXF58fU
         3nS2cuR7pxGCgknLgPO085OON4wx7f7tNjM9KTwQkgFMyh79rChZWivYP2wOgvhCdEou
         H5W6ZVJW98eoQ10KJ2h0PeUdaEiE69uB6pQ59C6D6ivZqKpbze3ZLMlCJkhH6DndPmer
         z150qX5J2SvZL755u7m1qint73tARk9PwHJOaxLhIGV1ux1V5UmsO8zzPVNkz3Voyvwd
         NQa1EDE3arUI1cCrSzJ/NV5Jtxq6ShzpboY8Fn0cdqX7VdZIGmlcRxU26h77n372qzJT
         5VIQ==
X-Gm-Message-State: AOAM532z0d8XNbiFIU9OieGfVSz6UZUAEniwCAC+KcC+cEt9ccg/baPq
        JfuaaOBEJEr8+mTr13qEyKo=
X-Google-Smtp-Source: ABdhPJzGKi+LK0bRcURC03mQqeQnHlEUzRtIXtVDOqeglTNHKT/S/3cPGbb+YrnZQ15Ru+Ycgw5yOQ==
X-Received: by 2002:a62:fc4b:0:b029:18a:aa9d:10cf with SMTP id e72-20020a62fc4b0000b029018aaa9d10cfmr7404105pfh.28.1605755362990;
        Wed, 18 Nov 2020 19:09:22 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5sm29232773pfx.63.2020.11.18.19.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:09:21 -0800 (PST)
Subject: Re: [PATCH 05/11] net: dsa: microchip: ksz8795: use mib_cnt where
 possible
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-6-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8f895c6b-315b-9462-6d76-4f9da74fa25d@gmail.com>
Date:   Wed, 18 Nov 2020 19:09:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-6-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The variable mib_cnt is assigned with TOTAL_SWITCH_COUNTER_NUM. This
> value can also be derived from the array size of mib_names. This patch
> uses this calculated value instead, removes the extra define and uses
> mib_cnt everywhere possible instead of the static define
> TOTAL_SWITCH_COUNTER_NUM.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
