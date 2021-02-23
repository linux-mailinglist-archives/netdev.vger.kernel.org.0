Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E903222F9
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 01:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhBWALM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 19:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhBWALK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 19:11:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E27C061574;
        Mon, 22 Feb 2021 16:10:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id w1so31879277ejf.11;
        Mon, 22 Feb 2021 16:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iqfcQJ00tw5XY2AhO9cKJWatdog4qJNF1NEavBWhI90=;
        b=NZuoMCOV6mjS9+pu5d+7KXYZ/kFQlOH6el9i7QwvS4IippNIuFTBXAZ+pvsHJBPVko
         29g1yRCQl+EV6E8g7dS9GKetWZJ6mkq+7DdDCvekOFgUrgROePMpfX6WzZnq9q7VKvfX
         /Nkf4wFfLiUcromguFCiLKAg1FSHk2WDC63kB0x8wU1o+2AAPNVPro6XX1qYcvc0DvKw
         /AhAShF0+CSKYWDqcj8Ow7rVdPewtblxxm5xu5FqiYNJUQ9wWlFAw3ujtTw41lk6H9Ye
         /eZ8M2yqFquBjCnw0dq+oaGl1NWxdlbMcfGfUlIegUoJRzohx1/MvGT5bJizAZh9wzY6
         CbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iqfcQJ00tw5XY2AhO9cKJWatdog4qJNF1NEavBWhI90=;
        b=Gy4lJ/WY9Mv4wr552BKjV9eClpjbUscw+C74Uj920L269G7IY65H7HbZ30Z300AXlq
         1Fn75G2LydgbbxhwoUu4ZVgy8rWIN+gdl3oGH6m66NMHbjmMicgcxygdeqlUKFt/ZzdE
         gRV0JVLQ0ThNIITJWcaWX4dGbsc28KHgQ1K1yZvlZ6V0Y25Qe1dlFTapZpWOZwWRbmwI
         tKpAjU0ttGg98cTYRSlBSRAoN5lwB1C5TqJbXZTFj9x+ZSBoT24ADn/1+lAWjEOjiylZ
         WxfeKJgq8DG/lObuC+j1UU3Fz9s7mCyYdUzGFt6eu++eJvLjaQcBkfJQvwt+YUDAz8CO
         fhoQ==
X-Gm-Message-State: AOAM532xDywoNZTnS0jp5xVLzPaklULV/khhKj6I4rYEo9bASfLqVZt0
        F9gwaijC+868nh3gM1iq4og=
X-Google-Smtp-Source: ABdhPJxjearfnUMvSmS+H0zjKX7Hc0Bh6XGbAiHYfUaCROCgzwwdJJ7qHYCMcEavARyPYjnv1DrRmg==
X-Received: by 2002:a17:906:1992:: with SMTP id g18mr16220600ejd.44.1614039026936;
        Mon, 22 Feb 2021 16:10:26 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id y5sm10995954ejr.61.2021.02.22.16.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 16:10:26 -0800 (PST)
Date:   Tue, 23 Feb 2021 02:10:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] net: dsa: b53: Support setting learning on
 port
Message-ID: <20210223001024.t4nthmcniikisfnp@skbuf>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
 <20210222223010.2907234-3-f.fainelli@gmail.com>
 <20210222231832.fzrq3y3vbok5byd3@skbuf>
 <3ba2c390-5318-999b-d1bb-097a89486ce1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ba2c390-5318-999b-d1bb-097a89486ce1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 03:44:21PM -0800, Florian Fainelli wrote:
> > In sf2, CORE_DIS_LEARN is at address 0xf0, while in b53, B53_DIS_LEARN
> > is at 0x3c. Are they even configuring the same thing?
> 
> They are the SF2 switch was integrated with a bridge that would flatten
> its address space such that there would be no need to access the
> registers indirectly like what b53_srab does.
> 
> This is the reason why we have the SF2_PAGE_REG_MKADDR() macro to
> convert from a {page, offset} tuple to a memory mapped address and here
> 0x3c << 2 = 0xf0.

Thanks, now I have more context to understand why sf2 uses one kind of
I/O and b53 another, and also how the paged address map managed by the
b53 driver gets linearized before accessing the sf2 registers.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
