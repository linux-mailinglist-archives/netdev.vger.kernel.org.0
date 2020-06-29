Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894DC20D75E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbgF2T3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732709AbgF2T1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:27:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01409C030F3E;
        Mon, 29 Jun 2020 09:57:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a6so14140026wmm.0;
        Mon, 29 Jun 2020 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BQzFhhy4PPK+wORzA0eq8X7nCm3stS5K4TwJi9mD/OU=;
        b=UU3gMqGQIDDI4aV0Xe5aM83CVRlvInAiCH7amNVA9uDmhXzVxpFuk1FmMYKZM7OCPq
         a4tPy0pbznEdYQw55lRvmJjvgWSsIc7aOxVebt9kZHI03PxoJP4moiQaIKd2tsdTOA/U
         JnNxFFUR43OLdXU4VvUpzlUX8gBrFgskl8tYwFfefmN/6EVob1pxAVGGSjb+l0vDpJoE
         1a0DQSEFESYn08TPLpotPXvSKci9hmgYmBodhIaYks6pt7ykXGzVHeNT2li7jOYsBXKz
         48agFyMb16F0QjcuV8o6yQ9F0zbAjdFAwxQPL1C9mdfV583zS7X0Ou6E3pbFcUKXGDOC
         eQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BQzFhhy4PPK+wORzA0eq8X7nCm3stS5K4TwJi9mD/OU=;
        b=rEHiRwp8EeSh0IpAo7vSqLiC4bEN6Ttqd6oyd6HAQNsSLPLN40h7a8spc1s5UQ0uek
         cEdd6kTt0uY8L0NgT0XNCztS2yGhHk+MHdiYhLmzNlek5pUUT7a9CuVVjBzs5kOwwbru
         RqEK1fsB9YvC7zWID7yhkhbwU9ZX87Dq5xX0IM8bn7Gt28Hk9bfshAIrvdDJZTkpBoRc
         s5PaoaAJNtAcRr+mcGAJfG8LAWkhm0SgiYuHJGGFDoxY2+22g8FCRtmywhAnxyzxRQMw
         dhNnhuEcoV5zBuqmgm/YUShdCM59GeH8kb73W8VrfCIAsg7Ea9qQLmKlK4kGJbV2LrM+
         z3cw==
X-Gm-Message-State: AOAM533q0ehb269wRMVeNRodwDu4vCBgO6Dk80D2VoxAkTMw1CpE46WI
        UDkF1xUzXMUHyonm9kFhI7M=
X-Google-Smtp-Source: ABdhPJwfZU06pq3cZr3NXQLT/Ki5iwUmKfY9cklbAHtcV0HoBVmGm8eeONMeuclh5OLF4878sWZCdQ==
X-Received: by 2002:a1c:19c5:: with SMTP id 188mr3212232wmz.124.1593449869667;
        Mon, 29 Jun 2020 09:57:49 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t4sm510754wmf.4.2020.06.29.09.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:57:49 -0700 (PDT)
Subject: Re: [PATCH v2 01/10] net: ethernet: ixgbe: check the return value of
 ixgbe_mii_bus_init()
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-2-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7e30d5fc-b6db-1c09-3515-e309da1eb0f5@gmail.com>
Date:   Mon, 29 Jun 2020 09:57:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-2-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 5:03 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This function may fail. Check its return value and propagate the error
> code.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
