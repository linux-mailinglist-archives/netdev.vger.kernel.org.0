Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7309C1B8922
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 21:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgDYTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 15:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgDYTtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 15:49:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D302C09B04D
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:49:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p25so6574054pfn.11
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgQBYHxpB5C2Gqqqxd5hIxOS8nTA6NXra5DezFPK+qo=;
        b=WXjtTExLY50dMr5el+pEOixrWDjsLE1vKzMrD+JqE/r5mDS8mdhckQa5oThh6yFwDw
         do1QbJdqz1pdAzdh7VfbvhwwWqJVlLLZddhadl2Z9tV258LOplXGhzssFB65PpFEdYPy
         dlUHp81IijSxFJliuHlGq9vm1N1CHFF8DBCahB6cxL7IjMoSGCFBGqTlSP4/w3e3Tp0l
         qAi0fYVAMbU3vLaiLAUPc1d/2ZCaJDQoMhe+1qNTNdFBK6Zm2Tz6eVPv39NBG8yPnd9B
         A8wARRh0v9+8Uo08ZwwDS0XEcwoME5EB0fB9b3nTRF1Ra0mip9oP0YTsbKjeYsWG2g1S
         bbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgQBYHxpB5C2Gqqqxd5hIxOS8nTA6NXra5DezFPK+qo=;
        b=Jhvl3krpUerdt/CQFMPMh8n07cdjJLKpdOzUvLj2u4ZC1YYxdpi5/29QjLSC9MENOl
         8lp2Hdt08dVunaCahFi0lne4HUALU3TTeJMhHulqf8o4kumjXjDIMqWYGxTJa4dRg+ew
         VYa3Gz+OQwQxyLyho/Tpal0gxN0hat/iXTHL0w76uIQ0AurFiY99SZ2J0KNSjto4R/qg
         6WgN38MRNXOGeBD7Ye1vQo8KJGPpVqMLNnHna6VscSiq/Ygg6vp8qdshoUPxypfSeuBy
         bLnrm6boeVLmstneux6cjryS4iXW3wwngiBLbVxQwPGYOmfhSJcAOr3dIpnD+XL+vOvZ
         8d1Q==
X-Gm-Message-State: AGi0PuZStvEsS4c/tiFSTDe/zF4/6CJiqbqtL2XVVhA1L+ytr9JCnBSG
        eeQwFlEP83JCUVPHz/U4hLn78g/H
X-Google-Smtp-Source: APiQypJkcqTBeqE/Yw/i2QsiOqEO202k/Y3Ir55to/CQs3IB6VBCzavE0HPzWTcQRcsSN7n3PDH6Jg==
X-Received: by 2002:aa7:943c:: with SMTP id y28mr16133205pfo.171.1587844188534;
        Sat, 25 Apr 2020 12:49:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x25sm8755589pfm.203.2020.04.25.12.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 12:49:47 -0700 (PDT)
Subject: Re: [PATCH net-next v1 2/9] net: phy: Add support for polling cable
 test
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7557316a-fc27-ac05-6f6d-b9bac81afd82@gmail.com>
Date:   Sat, 25 Apr 2020 12:49:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425180621.1140452-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 4/25/2020 11:06 AM, Andrew Lunn wrote:
> Some PHYs are not capable of generating interrupts when a cable test
> finished. They do however support interrupts for normal operations,
> like link up/down. As such, the PHY state machine would normally not
> poll the PHY.
> 
> Add support for indicating the PHY state machine must poll the PHY
> when performing a cable test.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

If you started a cable test and killed the ethtool process before the
cable diagnostics are available, the state machine gets stuck in that
state, so we should find a way to propagate the signal all the way to
the PHY library somehow.
-- 
Florian
