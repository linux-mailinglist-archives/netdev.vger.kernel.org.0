Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93524315E02
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhBJEEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhBJEEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:04:47 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672A3C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 20:04:02 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t25so392236pga.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 20:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=13htU43l4iXdwWGjKhK+Mq7lwY4rAEAn4rIxx4Bzw64=;
        b=cV/p65Y1ubYQU/mRvJJ2ttkOJdOko3eFqoyU2afeygOc+qyzvTm7SYGR2cUQLatWVw
         U3a75yIwpZ3p7aVcXMWec2Ph1nP2NjjFZ/jto9zacjtjIJsQAZR84GhYylMLyK8bZ0GL
         B3Xhpn7Ao//EdpE2hGwzkNu8Eeq0mmdGDEkcTmv6PV0ywe6xrZmHQbmhjlXMaNiYOtDy
         Rlxm+jvlrVC2kculn1ODfkDpgR4jt2EG/It9L+mc1TKTIO+WwwbBQigO8x77tgZRmvJs
         a6tQd/39Afw6svyY7JbFGgwS2N6BzofBnQlzC/ZY9RCXfEBN7bP8XdJj5Uc2KZvgzTsu
         soRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=13htU43l4iXdwWGjKhK+Mq7lwY4rAEAn4rIxx4Bzw64=;
        b=Gj+Hzp0beI5BdjlOg67I1thW35k2SWXDb5Uz+aTT2O64jCfLWsSNtsTiHLfmYjt49m
         2vB7uPxxvOyziah7GuWcxzO8fqLFPg78KXPVGwMZ3pHjkzaLuLCUx5u8xLze5vfd0xwa
         FdYHLP6Q6Ivdd9RkGGqPHMFnIy8iUW/K5FLH5i31rg4LltiLiGC6lY/0+vTGLQuTdB7L
         H2dFQ/Sdrj5/hRcxlWY2FEk4cXJopKIQqhbDRrJKMGfZU3bMQWrmxwYhhfMrcaoS9/FO
         kH5TttxhTYa04uQ9MeQz6I8UhWp5JlRuqkPBeSTZ4mtU4smnAUdPfb7hNItBHFd97DCL
         Sh+g==
X-Gm-Message-State: AOAM531SjYVsJkd8RwVxYjcfuYp/Lbc1ukR3EmpaywcqSENpL5o1FIVD
        /3fbCLmHj54mHwxAjfyb/kPQTm89Bdk=
X-Google-Smtp-Source: ABdhPJz2+YqhibocoadpuwnCQqloGLL0OAjc7p9BXSzuaDZMScxa9+GGMlNILyKgY4eAbyDspALpLw==
X-Received: by 2002:a63:f614:: with SMTP id m20mr1260234pgh.200.1612929841441;
        Tue, 09 Feb 2021 20:04:01 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s23sm374337pfc.211.2021.02.09.20.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 20:04:00 -0800 (PST)
Subject: Re: [PATCH net-next v3 3/4] net: dsa: add support for offloading HSR
To:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-4-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2d067c4a-103d-997a-8a8a-fac3ae16e586@gmail.com>
Date:   Tue, 9 Feb 2021 20:04:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210010213.27553-4-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/2021 5:02 PM, George McCollister wrote:
> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> tag removal, duplicate generation and forwarding on DSA switches.
> 
> Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
> to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.
> 
> The DSA switch driver should then set netdev feature flags for the
> HSR/PRP operation that it offloads.
>     NETIF_F_HW_HSR_TAG_INS
>     NETIF_F_HW_HSR_TAG_RM
>     NETIF_F_HW_HSR_FWD
>     NETIF_F_HW_HSR_DUP
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
