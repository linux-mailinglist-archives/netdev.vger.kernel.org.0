Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F97C2CC327
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbgLBRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgLBRMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:12:52 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA11C0613CF;
        Wed,  2 Dec 2020 09:12:12 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id m9so1471084pgb.4;
        Wed, 02 Dec 2020 09:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZbEoIeyeTlkYBHp4MmdFhJwiumrYisD0E9oge56A+o=;
        b=ZsnJTK9weEJnTRSQB6kXQvyj/MZ8J5Ol1VhaA6Lc0a3kkTXMVMJADc1f9w3wKEVvMq
         obwjv63y8jcLqZZJPUCjKuz8ShN3wtoNfy1ly3gHLGDzIvvONF4KeOi7BOlzoLhkv/ir
         O/7cGLt/yehkWObqor4mEIrgxiA8+r9A+a28AXWEKQLW2WiRej0ABKxkTTuXrLMduEgH
         Ydhmgl8ko/18ro+Hb9NpGdNjppIe58Wit0bfh/2gzwidgP8jCAUz6VIY43PpkbB98iOX
         kKg1NLt6BGnNyBBHyz+sRxl0Ir7UeUyJJQmsElWDzgyCH4iP274p1pbzid/BgL3aGJGm
         bG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZbEoIeyeTlkYBHp4MmdFhJwiumrYisD0E9oge56A+o=;
        b=lUN1U/MfTSLA5IQw3pWsHybFodS8cN4GXdOnMZlkuSxg129mb8ZOxz75SN+v61nDSy
         rgstcAuAhvjGbhpnRWS9G58O3POuGRBiKr5WG9BVu7mQi5CoLUbUVGfkjMFSan1Tv8Zc
         GIPWoePbrzmV2CFyq6SpuLzj89XbhSNECh8MeuAS26poHqu6uJQ3O5UxLZ7mb6zr457g
         agVSB7WfkMWearumy77y6oLqYsuH4dPdJeHQQl4aLoX56OjXvMl13Hmbc2nigCnPCm+j
         LlHqH7Z+0KhJ79dqpI+8deJkjMjX03Gk/iCTfSVJn7OW9Bo8dtZzc3RNfBVz29rhKcRs
         HVQg==
X-Gm-Message-State: AOAM532NGQ/JdE6lwf+l2tykoguwTZDDjUU549HTxRQq8N5ByMQX9skb
        2QPo5uSGK/SAF2crx2jjos7OfllnvS4=
X-Google-Smtp-Source: ABdhPJxnHIDsU4Yd9L9VnzzBhgdfKupbQhV0SN+mBgRGcDKFkMf8fIUfvrwu6oi3TAkfMtkTvxpr7Q==
X-Received: by 2002:a63:f50f:: with SMTP id w15mr705616pgh.403.1606929131046;
        Wed, 02 Dec 2020 09:12:11 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x21sm345923pfn.196.2020.12.02.09.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 09:12:07 -0800 (PST)
Subject: Re: [PATCH v2 1/2] net: dsa: add optional stats64 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f2f1623f-749e-ea97-a32c-61c49b7e0485@gmail.com>
Date:   Wed, 2 Dec 2020 09:12:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202120712.6212-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 4:07 AM, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
