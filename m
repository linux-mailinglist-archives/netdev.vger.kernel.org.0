Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B4836A4AB
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 06:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDYEqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 00:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhDYEql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 00:46:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD8AC061574;
        Sat, 24 Apr 2021 21:46:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so3299415pjj.3;
        Sat, 24 Apr 2021 21:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Bb3hrAQ3mgjurnRTzIUULlD1BFEVkHRxwl8M8mItjrQ=;
        b=oggnFFV9idkpRCt7FcNhGKC9RnybocZ8P0kLXikG783AsU8AE8TmTdQWFyaxO+VybR
         Go3FC0YorNRk9QeluQfEDHYxUKkucpE5SydU3MB9O6WpstqsAP7rtnTZ19LQ9IxSJZCk
         2EhE9T5Ows8/bIWzhc/a8orCdKRK9Nrd5WIKTFBwQx/4Yog9LFsmchNOkosG2ct6oy8c
         e8nevdrQzRKOepbkVM1h7a0/hE8H4uJA4LcjrvQVs7qL1QbHl90QXhkApFpQxY+fTYG4
         FmYIYwaq/ALyWuYRqvra4d3DFdMU2JS1H/HTCssPycKTZVa181sfuDDvWUn3xdBwZz69
         o9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Bb3hrAQ3mgjurnRTzIUULlD1BFEVkHRxwl8M8mItjrQ=;
        b=XSms4yGjcti1fkzqV+vOL1jRGYIHDj2dP8c+G3TnyqbvH2J6Z0qZ6xBZgZSM4hFMGK
         XsgzKi1kVyt47KoXiWxAquY1Lp7fotchSYEUaiJOIbthAWLUaykncOtlmdS1e19hiv/7
         G70zG+zBlf3WsJKfEzmmK8lwpd8xbPfYe7rHMZIsxgeMMLh8TcSasZRW3R3etAaBWtfj
         cVqGNUdeQ6WZhNtyTtZwQOpjJbggx975z8u+Z7UG41EcWTar60YeOFvoJGZfvsnD1Qkd
         JWpxNjMaRWb7WJzvWFpPOvxcpHkLPjoO9Js8BBwKcX9YjkRXUnrMijyKWtke4JGGwIrb
         k57Q==
X-Gm-Message-State: AOAM530/UP7NoE9+FUD3gSmlXu+vAEb7ZuBTMYJwAIdeMl/gdOJxEkzj
        J0mgy/rEkq3bxEw+/wcNOX0=
X-Google-Smtp-Source: ABdhPJztkKk9E5CJDI97OzcJopV28qazE7KxUgNv0ShAp0I6nMXRojyy25BEka7KMOwyzVnW50KE2Q==
X-Received: by 2002:a17:90a:8816:: with SMTP id s22mr14283810pjn.25.1619325962000;
        Sat, 24 Apr 2021 21:46:02 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u13sm1980209pgm.41.2021.04.24.21.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 21:46:01 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Date:   Sun, 25 Apr 2021 12:45:54 +0800
Message-Id: <20210425044554.194770-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com> <20210423014741.11858-12-ansuelsmth@gmail.com> <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com> <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ansuel,

On Sat, Apr 24, 2021 at 11:18:20PM +0200, Ansuel Smith wrote:
> 
> I'm starting to do some work with this and a problem arised. Since these
> value are based on the switch revision, how can I access these kind of
> data from the phy driver? It's allowed to declare a phy driver in the
> dsa directory? (The idea would be to create a qca8k dir with the dsa
> driver and the dedicated internal phy driver.) This would facilitate the
> use of normal qca8k_read/write (to access the switch revision from the
> phy driver) using common function?

In case of different switch revision, the PHY ID should also be different.
I think you can reuse the current at803x.c PHY driver, as they seem to
share similar registers.

> 
> > -- 
> > Florian
