Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E4536B8F1
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhDZScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbhDZScy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:32:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5DC061574;
        Mon, 26 Apr 2021 11:32:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y1so13766323plg.11;
        Mon, 26 Apr 2021 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CPwU2BFaNCoDm9dLVLOIvu07zNlOwj++8SuZkOUV1fY=;
        b=RSspds7tXriOKLcR6YL7pkywDURAtW15Hj6zJvmIwJUdX457pJYPK9UEd9+JLOszhD
         jZl9DMdmZLYecjrtDDYzXSkjAxkT1Eq3HVG0kckDaUyrUQzQYFzSAMdnpcvd0pndAvrK
         1p29LawIqmV84wTafoA4FZuS7l+owK6woXhpz2ApoA7aIVo6nNwNvCNgLG4GQpSPI3FJ
         qh7NVeuWiwoXey0VGB72wX6GI+ZnQmovlVdMRWZDmNDPsTLjZZv1c2Z23NDBMa6YyRXx
         m3y8rv45ucYgS8xvyPO7yM6p2a2Fl36jYFB2SxLfIDdbkSkZVUaWcWxP/GEMVf4hl1XY
         uotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CPwU2BFaNCoDm9dLVLOIvu07zNlOwj++8SuZkOUV1fY=;
        b=gfgyfNR8ME5LJc9VcFopzsKY5a0Nl/ra4M3fmvq2aisEmsuDWOu0Fu4NywP60Dkt/+
         3SMUqxiZj1r4aNJXolnstT+69qYX/uah6HUZAucPkq/xxkf/aarP59lR0tTRIWB4O23p
         hGGLQB4DJBIGXi5H7EC64HEL3wSSsPcaTpGsGVBe9+WeF5olGplKTATxFloh8iGJ32UF
         +ByLZtFcYkedeWJ27waNX3iEbLxC6RGeyKlBIlMzQaMZyXn/anCv7JCfr8UMyoJWCaiG
         J9Ht7s16V+vOC6CpNUgU6FtK1f9OAcGrIQ3KOfAYwsfTXoO1Vu3pUt816xiHb4O9c6fW
         L0VQ==
X-Gm-Message-State: AOAM531gx3zabCFlU1ozOiSbWjsSoukGwDfQgl1rGKWDZYerbZb+jnaA
        xZzlrEP4RoXUckVBvv6TG+8=
X-Google-Smtp-Source: ABdhPJy77PdB/C3WnYvBMNUpefQibuaxjm+NjLKhQVhE6WY+Jyb1gEfxVbZBjmmOTduEMHFJu8KeEQ==
X-Received: by 2002:a17:902:8548:b029:ed:5334:40c2 with SMTP id d8-20020a1709028548b02900ed533440c2mr590511plo.36.1619461932383;
        Mon, 26 Apr 2021 11:32:12 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 132sm357173pfu.107.2021.04.26.11.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 11:32:11 -0700 (PDT)
Subject: Re: [PATCH net-next v7 3/9] net: dsa: microchip: ksz8795: move
 register offsets and shifts to separate struct
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
 <20210426131911.25976-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <76e38640-32d1-38a9-6c8f-64769f1ceb6b@gmail.com>
Date:   Mon, 26 Apr 2021 11:32:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426131911.25976-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 6:19 AM, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> In order to get this driver used with other switches the functions need
> to use different offsets and register shifts. This patch changes the
> direct use of the register defines to register description structures,
> which can be set depending on the chips register layout.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

The changes look fine, however ther are 32-bit build errors with this
specific patch:

https://patchwork.kernel.org/project/netdevbpf/patch/20210426131911.25976-4-o.rempel@pengutronix.de/
https://patchwork.hopto.org/static/nipa/473275/12224263/build_32bit/stderr
-- 
Florian
