Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C43210FEC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbgGAP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgGAP64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:58:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6132C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 08:58:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so7645212pje.0
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 08:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4mb0cd632ZugmYL+Ywa9abZk78fSZA5uCsOw2uZQnc=;
        b=i/Ohed+A0HbscDmVA+O5XxvOB7pCBtiNrD1q5KdJ+HhnR4wxG3LkDWoVzgzPqnMJnC
         wks181/YcGCKnAIzU6M3tqJ8lrWzQArfvPyUONELB72mLZjJ48YTp52BdRO1qmpfsUXe
         ygWO6a71aqzSEzumlgAvDFcBSCM6ehPGebdd2R4DII04CPsEI8E/pN1Rf0Iv+zxzB+n0
         nJhAGhVpb+fW8hWKiri4NxIXPs8SnMHI3yHwi8S+04esl8npx9b7ULPTkyEYKRbHM05F
         WSlLDURL5zIFxshWP53HLAo6heEG0GRUMnkTdOKjGjDmNgQ9bsex9bb3p5Ta6np8TpNy
         fcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4mb0cd632ZugmYL+Ywa9abZk78fSZA5uCsOw2uZQnc=;
        b=U90rAGD9GFvdc0e/pJYqHxgq3GyGbbihnWR4o/Szs7P51133EdntT8uDT4kk7OVolX
         4fm4lA0vX/WMZP/3UcNVkF/2u4nvi2u8coUqSAaAtx2wOd67VyJ/n9NAgma/j6XgFObP
         lrrDMMqTx4WQDnyTjxMrPfaUtYaPV1l3pCgOgSAVwx62OTwfjCl/1qkj8sfxVXqn5PPj
         kGhAVK+c3vkAMAaM0iPfbLYObKLn7v6lsWjar+/ylLq3ykgmebMZlBLeMJrlyTbu7wa9
         UTTl/cZsVQkq+o5YRCnDzUwi6QucxiTzdGj0MewSVzFIuZYIIruZ/E651E3Urkpe+5tr
         HEQA==
X-Gm-Message-State: AOAM530ScVzbyjaggavmCOjLWp+vhkbGfE2rZa/1VIByVCNCyaDc8I17
        9JrJwHvENXUbQ3rEl/DiXjwv8g0/
X-Google-Smtp-Source: ABdhPJycobYt3tAzMNrcpCko4USSGyk1f2t30jJIqypl7jtyZ+vR4/AaDJXpC7yryy1qdDNp39eLQg==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr17674661plp.312.1593619135426;
        Wed, 01 Jul 2020 08:58:55 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:c5f6:2e81:1d8a:b1b1? ([2001:470:67:5b9:c5f6:2e81:1d8a:b1b1])
        by smtp.gmail.com with ESMTPSA id n65sm6315011pfn.17.2020.07.01.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 08:58:54 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: microchip: enable ksz9893 via i2c in the
 ksz9477 driver
To:     Helmut Grohne <helmut.grohne@intenta.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200701112216.GA8098@laureti-dev>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a6029667-0a7b-ada9-c0c0-d50428689db6@gmail.com>
Date:   Wed, 1 Jul 2020 08:58:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701112216.GA8098@laureti-dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/2020 4:22 AM, Helmut Grohne wrote:
> The KSZ9893 3-Port Gigabit Ethernet Switch can be controlled via SPI,
> I²C or MDIO (very limited and not supported by this driver). While there
> is already a compatible entry for the SPI bus, it was missing for I²C.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
