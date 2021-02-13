Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD14531A9AB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBMCyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBMCyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:54:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A82C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:54:01 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k13so660978pfh.13
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oQsFY6Nv3WQS4xdanjlBkGEuwQrOOLyn5uX6TKYwvU0=;
        b=mnqbW/4QYtHczSQc2KFiJNDKMrSd9Twznws3qUjW5UMaJmLhozDJ3H9s/0RZGB784z
         idJFEsvnMZN5FjR9CGSpz1uHpeV9RzkDOMh9UwSjJ1oO1xhjVt9igxJ3MXD+79DxhtlQ
         2vzBv/vJShsBUUZj2DMsyponsC3BqVorthFOAAWrygW4Fw7c+Bz+z8Ta5ac985Q48m+q
         JmYd+9x9gZFOGheplD50bwwSEU705mYRA6Rhe9w8VczM4PQ046Fw4crCTbpSWq6mhp5b
         nMi7thfvJoNlQiyYDpo4suFQ2gQCeXp8bS+d2joIZbuCwccCdPmSLHhwetNYa2NWy9dU
         Popg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQsFY6Nv3WQS4xdanjlBkGEuwQrOOLyn5uX6TKYwvU0=;
        b=C0fOKleFgrbAdH5LuneJlrHsI+VylzYrsLx1qJPTxe6tKIeDRbdhBxtbG6TxcYV5Xd
         zS+0sJyfnrFx4GrK3mjx1SpcI8BrybL8XAxggbOnwx350vJw45F/uRbuZ9rM9go2gpji
         /E2pYyoV/QsU/1HRejUy0nqLj99keETLgG15qLW9CZ1qQZV8ExuZ/RzGVjswz+SybnrC
         V2p8v6qi44iTTt83JsMuZNDLWLDmjQ2RtadPxFNNRhFYp6E3c4NrXTCsfoU98KKmXZPj
         2rISfM03kCG7JK0t7p1f3h24Cu9jrySHBBB4OzrZogulrqIObXU3Q2a3qw/FuTGDE3Cb
         0Lbw==
X-Gm-Message-State: AOAM531XYcLl4/uMh2zhF7qJrF1INuhn0N0REt9nIvPHzBC7Y13xOV1E
        ax0bkPbnoxkTPQxE//o9BqHbVPPS+NY=
X-Google-Smtp-Source: ABdhPJzgCgzeJj4M5xpeT08Hd0F8tN6RzQezQK3Hr36Fe7mfonIW7aYiE7uBW/t6AbuhsnGMWOIDiA==
X-Received: by 2002:a62:e804:0:b029:1dd:cf18:bdee with SMTP id c4-20020a62e8040000b02901ddcf18bdeemr5888155pfi.63.1613184840302;
        Fri, 12 Feb 2021 18:54:00 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e185sm10694287pfe.117.2021.02.12.18.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 18:53:59 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/2] net: phy: broadcom: Set proper
 1000BaseX/SGMII interface mode for BCM54616S
To:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-2-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cd4ef949-72e3-74fe-adf2-122ca60498ce@gmail.com>
Date:   Fri, 12 Feb 2021 18:53:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213021840.2646187-2-robert.hancock@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 6:18 PM, Robert Hancock wrote:
> The default configuration for the BCM54616S PHY may not match the desired
> mode when using 1000BaseX or SGMII interface modes, such as when it is on
> an SFP module. Add code to explicitly set the correct mode using
> programming sequences provided by Bel-Fuse:
> 
> https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-05-series.pdf
> https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-06-series.pdf
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
