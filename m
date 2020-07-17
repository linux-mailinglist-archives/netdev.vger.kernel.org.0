Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235FA22328D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgGQEof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgGQEoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:44:34 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DD0C08C5C0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 21:44:33 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so15316576wmh.2
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 21:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S9S68y6b2mPbKuzgaCo1jN4A32wueiis4gs7MPkym/M=;
        b=YBTRlAxQNCrp0VWtdAoz7HX1TcMxgP8c+pztXkm9DckROsrCs8s1wiHI5Ty0T6SgrK
         x1LT/2APXM2vMzv8oPhbWLw0GHTyp4WhkivO6gKr6Fyodd1U8eGi9prToTvyCdvhjwuu
         D/2FUpr4dbooLhpYGT4dm3UwB8hQ0iuvNDR5WtKOUPmAO1XOPM9iqBTmOIE3rIhpejZD
         UuV0PnY40TbCaLn4R1LYeLSHKHkJ1uEJRN1YQ2eDSc8zlbJWvqUCqi2RbB/AK2Bmot/z
         bai/MmFwyt17VnEi9eZU4lF9z9MMd+wSlLUM9q4lUfSN/7KO5Q5X5N7DH8omfftLoyew
         HClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S9S68y6b2mPbKuzgaCo1jN4A32wueiis4gs7MPkym/M=;
        b=i2I7fFRRVf1jmOCwNZX43viug4wGJlYCpdILUoR4RZ+y20z6mXGnyn0zA398uykSJU
         7/PCe0vU53Q4D6dYe3oycE6YxF5QIZ7qbVutlNwxu6Vz1gTn3sj3kkGgvTey+rgPCuwj
         efdOpyU2g3yFKbRXvR1X9ideMSy0cz8sqOm+yroKnK1bsVuWi+pbubTb9wnRvZasAV2M
         qisboRaNZ9Sn5Ut2fQXL57Hc8cfkqT/yXvFMb9a84L6ZVmNgiAEAPJWHrfSTKly/R9FH
         fuE6NW2cHQleGQVYEk+95lp/YcPp0RiamsmR1Um1xYK1zql5rQqjWZ9MCETM8l+SB6U2
         zMPA==
X-Gm-Message-State: AOAM530lJzqEL8fBr3MMD3N4XlbOzMzEo8NDWv+gQYGSdf4Evg+jPBd7
        YW0f2KokfM4v8/Pt3Txh1mJ6wOf0F/aU/A==
X-Google-Smtp-Source: ABdhPJyEBG67fJXokeAElVWPCoMwiGiAI/9HSCWG+w7OI40KZczqAmqnOUUNQcrS+TOsyYDFflbNaQ==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr7184668wmj.5.1594961072462;
        Thu, 16 Jul 2020 21:44:32 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:9880:a643:3e69:6393? ([2a01:e34:ed2f:f020:9880:a643:3e69:6393])
        by smtp.googlemail.com with ESMTPSA id o21sm11356388wmh.18.2020.07.16.21.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 21:44:31 -0700 (PDT)
Subject: Re: [PATCH 03/20] thermal: rcar_gen3_thermal: Add r8a774e1 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>
Cc:     Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <bcda3aae-a276-173f-71e2-381736481ab2@linaro.org>
Date:   Fri, 17 Jul 2020 06:44:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594811350-14066-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2020 13:08, Lad Prabhakar wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> 
> Add r8a774e1 specific compatible string.
> 
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> ---

Applied, thanks



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
