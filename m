Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4ED20E61F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391455AbgF2Vof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgF2Shq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287E0C031413;
        Mon, 29 Jun 2020 10:18:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so1732698pgm.11;
        Mon, 29 Jun 2020 10:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s8XhE/yeiReS0OBvf4zDHqlAiG3UaGBgMUzuoNaO1KE=;
        b=gTduClYOv3wkN8/Ems3erM2NjqG+IiEFnHEF+DYl1V3rbPISmjz8B7FpBrrvpDUZrG
         M1J1mLnoS6uCKgjfJe03t1F8d/Lg2kp3DTuQSut6DXI284WMKgClD4OZcJVGi0jqf6eJ
         WAUfLBNnfQS+R9PmloXTpINYo7G/DwJ8+URWVF9M/lcxgV8YlaYBPOE+3exkD2yx6A3w
         zzbBvMwa8C8CRClbtBumT2L/FgJ1dsUHROG5SdrfHHCgQN7DXQfce2WqxOQ2SyMkbAjT
         rBMOa0m6hL9mcSmp5vJQpoCvcSEn+Hq5RMK5gDTuP3R8JQ9ef99O49k0L6W6lQ/YDWvx
         QVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s8XhE/yeiReS0OBvf4zDHqlAiG3UaGBgMUzuoNaO1KE=;
        b=g+nUSHwNec98On3NEGPRcxeKVPWEbEvlu31scyUr6BQ5jnK3Tmrkkkd/NWReH2tC+2
         WGrcj+/6t01X+/EWvawxlS3S9yDeiKYY4RRja9mPb7oGaEd/q1KPP01pZU9p/d26//5+
         b4Cmut6ZDJ02kRR+PNGtU1EcoT+lYzR54ST26FrVoGdDhPEAXDnikV8VpuDsvso2DAne
         Kd+6xrdGCOADNgjIW80t+hZ78xjHs7/DXFvb25gkZaor1UYXOPH35Fg8kjJOCUtc7sla
         3zUVeuJTTRGc9x4/Xz5KEQXEoxFdn4uK8Pi10fi5aamxJ1j06n/nw90WmJHiyABe6U1x
         lwLA==
X-Gm-Message-State: AOAM533oW4adhtIqyyY5gwGcVgcC0pKO5rT6GjmRnk98BVaW3q6NMP1R
        f2IIgmLuNu9+Q8DXGh8A54k=
X-Google-Smtp-Source: ABdhPJyUXxKy09lWItf88ToMo5k+WiBGp+UfOAXoak95PYU4T6yrCI1AHmQzoFZDsEJL5LvJKRPfGQ==
X-Received: by 2002:a63:ab0d:: with SMTP id p13mr11147237pgf.327.1593451082661;
        Mon, 29 Jun 2020 10:18:02 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s30sm342589pgn.34.2020.06.29.10.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 10:18:01 -0700 (PDT)
Subject: Re: [PATCH v2 03/10] net: devres: rename the release callback of
 devm_register_netdev()
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
 <20200629120346.4382-4-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <91a59f41-6e82-6fc8-e35c-8be948dca158@gmail.com>
Date:   Mon, 29 Jun 2020 10:17:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-4-brgl@bgdev.pl>
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
> Make it an explicit counterpart to devm_register_netdev() just like we
> do with devm_free_netdev() for better clarity.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
