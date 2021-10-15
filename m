Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1681A42FA31
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbhJORZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242263AbhJORZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:25:30 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9DBC06176A
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:22:32 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so13729745otl.11
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8GXf6iIkeLSmbnCwp/TnDsH3fwbQUD1XiOH8muSbIdM=;
        b=AzlT/VF3vNrvaXMA6yupvoTzvJVIPoxbKtPfW8YnVJaJ6TvF75GPEm8I4v8TBAuHwD
         xXYMe3/F5qzdc2toQmMpBJSi9ufh/kCygFWvbceu3OB5hvfjZenyOaoDv/DaCxg8Pr5b
         b3A+1O8vmB3bA6FY9c4XPjwoTNYLEvt4DEKLfLyVisJRLl/sj4+qjBYAS4JL+Aje633l
         UJ6BvkSmhvdUJYWiRgjmsebeqbbwUFMELtCNLmRyjheSv8M6Sq2bsWw1onXUQEIWWN++
         693DPX65oIdROYAMmDNG8DTq/cOg5xD9+/IHzoeqmtl72bYa+FJHBSrFOwpyxe+bKkmY
         g5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8GXf6iIkeLSmbnCwp/TnDsH3fwbQUD1XiOH8muSbIdM=;
        b=ADINrqEL2+WOsyvPtQV0A8Iibqhd4OV6PP+2zTf1MrvR9cf494ygOjk1mySPYaVBaV
         /KeoDNbwf7ob0Q1xvPy+XrYh8FZfsplrGW/9o4v3nUJeiSQXz/WvTMCj4wn7ToRt7Sxm
         CCIaVWM4MtupK59M7/SOsUS79dqT3vzSBOsN/EpAhed5fM5I71av91dzXC8pVVn3giou
         TEBaTk4ByJ4STn8FR5AEcR/nqACdjF+XOYFWeqyLYJTeHv4/HO2WzG6Vh2GWOxxE5fjy
         VYU1Rg1lX1A/S+YM3Ur0dDjCG6AAvtXj+PW7AkysGr6zsIvS2QznF2nNbOdXhKeJKudU
         d5Bg==
X-Gm-Message-State: AOAM533Tuegmdh8zJYvNFL/99O2gXoVYRWfekfwEm+/lMVziDOVBJCIe
        N0Xb8eFjhRAdoNALel5l8glmMQ==
X-Google-Smtp-Source: ABdhPJw43C2jPHke2r6UygEFoXfBVXJc2rkJUM25RFmbv18wSheOEBVNo3sZzMCBhf8p+nKZSpfNiQ==
X-Received: by 2002:a05:6830:2805:: with SMTP id w5mr9028837otu.248.1634318549944;
        Fri, 15 Oct 2021 10:22:29 -0700 (PDT)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id s206sm1289635oia.33.2021.10.15.10.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:22:29 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Cc:     dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, freedreno@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/9] treewide: simplify getting .driver_data
Date:   Fri, 15 Oct 2021 12:22:20 -0500
Message-Id: <163431847249.251657.9669509178222541492.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
References: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 11:05:12 +0200, Wolfram Sang wrote:
> I got tired of fixing this in Renesas drivers manually, so I took the big
> hammer. Remove this cumbersome code pattern which got copy-pasted too much
> already:
> 
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
> +	struct ep93xx_keypad *keypad = dev_get_drvdata(dev);
> 
> [...]

Applied, thanks!

[1/9] dmaengine: stm32-dmamux: simplify getting .driver_data
      (no commit info)
[2/9] firmware: meson: simplify getting .driver_data
      (no commit info)
[3/9] gpio: xilinx: simplify getting .driver_data
      (no commit info)
[4/9] drm/msm: simplify getting .driver_data
      (no commit info)
[5/9] drm/panfrost: simplify getting .driver_data
      (no commit info)
[6/9] iio: common: cros_ec_sensors: simplify getting .driver_data
      (no commit info)
[7/9] net: mdio: mdio-bcm-iproc: simplify getting .driver_data
      (no commit info)
[8/9] platform: chrome: cros_ec_sensorhub: simplify getting .driver_data
      (no commit info)
[9/9] remoteproc: omap_remoteproc: simplify getting .driver_data
      commit: c34bfafd7c6ce8bdb5205aa990973b6ec7a6557c

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
