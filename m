Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB33020E5D2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgF2VmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgF2Sh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55871C031414;
        Mon, 29 Jun 2020 10:19:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so7703338pgc.8;
        Mon, 29 Jun 2020 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kyRzeVuvIOnKhsJ+5uonKu8f8yeOpAny5n1VdDosRFk=;
        b=Nt/jc4Xm3mvn5WqweNAwuOw5XVFPe3sw7g1bxrnFrB14aW4N+u8tzFVgRTc90SHXRB
         ZiXp58toYoc0ODij/6SbIdGrnrSdEZo7/jEOUGj0GahDzCeX/xMZNKq2+bK/otDzj4cz
         9NsaMQbXza8P6bwQW3R7MhLu/ahcGjau2xeGrfvMhoIIviu7q/uSvncMPj4rd4I8V58E
         G2z0UuGPGV55wArpeJlarXOVZfwvYi8EM6ltHIpaAoMlUzAi1xe9MmrQkStUPNzjyJa1
         DYBGvYHBHW56EC5ACRP0KFpMU3rjMPnfG5B26lphNu2nqAxgbskxmS4SFidlzo5ff7l4
         QSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kyRzeVuvIOnKhsJ+5uonKu8f8yeOpAny5n1VdDosRFk=;
        b=k6TEzmiboAZOZ9a+3Viah9V4Lso+MjXejSBIw6/f4GZiZtvr0rDQEaRSosOLEdWNna
         FIgwAJTPgioti2BrrFZiuEJn+08murrR5shPzZ0/5XNTqGXrJk3xpeskocg0noKQynfh
         OvM3eVK5+pfB7dwI58B2eD0M/MIlVU+TIik0U5IW2KyQ5oIs8vw+mz5iCnPfsDfIg8ZH
         4C0RTHcePtAevheHhqB+iIzLokrcUk6XHXhP6uKOxUXp5r+p9stwJGIwiDivO9Z+LEje
         DAkRUKoFi+TVr2XnX8bDvR/eRyq0Os3Dwyp6OaC4V20PBVyVX5bVGB7i0pUYU9BLz20w
         0aGA==
X-Gm-Message-State: AOAM532Agf8e2ktFA87JIkmEeqBT0rbjXiA32Vxtsy4g44xs+28FALJN
        7IlU4HL+Wc6CKqBqgMVdolU=
X-Google-Smtp-Source: ABdhPJwBz4zO1nux6YEsGIypPIa2qPGaoUx75nn3Ar1oull1wcbktACCA97kxB2CT7b9kqFFkD3b1w==
X-Received: by 2002:a63:8c5d:: with SMTP id q29mr10983595pgn.249.1593451177944;
        Mon, 29 Jun 2020 10:19:37 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g12sm257852pfb.190.2020.06.29.10.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 10:19:37 -0700 (PDT)
Subject: Re: [PATCH v2 05/10] phy: un-inline devm_mdiobus_register()
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
 <20200629120346.4382-6-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a88026d5-8a4e-52be-93fd-e683fb2ff05d@gmail.com>
Date:   Mon, 29 Jun 2020 10:19:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-6-brgl@bgdev.pl>
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
> Functions should only be static inline if they're very short. This
> devres helper is already over 10 lines and it will grow soon as we'll
> be improving upon its approach. Pull it into mdio_devres.c.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
