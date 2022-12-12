Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5340F64A52A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiLLQjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiLLQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:39:08 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E964165BC
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 08:37:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i9so804791edj.4
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 08:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvYON1Uq6UT3Qph7OPPr0NH47G6rUYR8O1BO9MFwJow=;
        b=lIFXcScE+1mmzH1SBNLfPzmU2yyZ22FDa7zo6/O0Bw9aIOxDeXxYkEVfus52JWuhda
         4ouELocZnEhmnwFppolEYq4c3c7RHYAqD4pax4M3unQDLONiM/9+ejXSM9E2FE+Z0v02
         plxbNMhSLCExfq6g58BwEJLatQLzpt/xLWOhKWfMwSgaHbhPuPfGnoShEU2Q/8V0GhBe
         I8mO/6POKEHTvHhiQrSmT3i/DlcfyH1o4pAMtSuNXvNoHj+mOy3GKKCsRTSQGVPFd3Z7
         AQYI0FN6wamo3RnZf0VXDCwVvMRjPWjYDkKYXDeP5o/vQIFIn9FanCQzU/XNFNQHrfWF
         2geA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvYON1Uq6UT3Qph7OPPr0NH47G6rUYR8O1BO9MFwJow=;
        b=Rz2hGQdF0M/5BOG64lFSM4+8W96cqkKtoWYcn8LZrEvPn5HCuCcxlH/OWQkxAtWg/7
         IN//JPrTW+vonYv+70Jw5faP1Ff+xz/tZYriPCSeiICPhwzrTSshtJ/ea0dGQPA1nYEE
         wr1T9DvWM2XBmkhW49E9eeQhsjvdDXH7LltYHXBk5iuATcm62FS6+/NotyZdSt5HB3T4
         kmtO/e9AnX29XgnPA8IASLQpfuVxlN9Eijj25LcAWYqWaaI19gGGbZkLm5kGrlcDH0sK
         vcy1qHAxPjqMqZu6B1F84aC/tHc3qPKkASqeX26JuXt32X4EfWJQeWu56YP05wf6W++3
         OD4g==
X-Gm-Message-State: ANoB5pm660AI+PNH1/TAUr5p5+9mbCDk1gLIJaD7RXQln0Txgn0+oSOG
        pGGjwUZ2ykmNcSWLApIovt819NLZhTjG6bmV
X-Google-Smtp-Source: AA0mqf5ppTTyM6N0bPOAfBX//eKXVRPakyRimeYdkY/8NocUbAvjnOSiYLmQOcD2W7tmhBu2XO410g==
X-Received: by 2002:a05:6402:702:b0:46f:68d0:76 with SMTP id w2-20020a056402070200b0046f68d00076mr10093614edx.34.1670863020790;
        Mon, 12 Dec 2022 08:37:00 -0800 (PST)
Received: from prec5560.. ([2001:bf7:830:a7a8:ff97:7d8d:1f2e:ffaa])
        by smtp.gmail.com with ESMTPSA id m15-20020a50930f000000b00463597d2c25sm4051979eda.74.2022.12.12.08.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 08:37:00 -0800 (PST)
From:   Robert Foss <robert.foss@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Angel Iglesias <ang.iglesiasg@gmail.com>,
        Wolfram Sang <wsa@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc:     Robert Foss <robert.foss@linaro.org>,
        linuxppc-dev@lists.ozlabs.org, linux-actions@lists.infradead.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org, chrome-platform@lists.linux.dev,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-input@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-serial@vger.kernel.org, Purism Kernel Team <kernel@puri.sm>,
        linux-staging@lists.linux.dev, alsa-devel@alsa-project.org,
        linux-watchdog@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, patches@opensource.cirrus.com,
        linux-mtd@lists.infradead.org, linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux-fbdev@vger.kernel.org
Subject: Re: (subset) [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
Date:   Mon, 12 Dec 2022 17:36:51 +0100
Message-Id: <167086288411.3041259.17824406556561546642.b4-ty@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118224540.619276-1-uwe@kleine-koenig.org>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 23:35:34 +0100, Uwe Kleine-König wrote:
> since commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type") from 2016 there is a "temporary" alternative probe
> callback for i2c drivers.
> 
> This series completes all drivers to this new callback (unless I missed
> something). It's based on current next/master.
> A part of the patches depend on commit 662233731d66 ("i2c: core:
> Introduce i2c_client_get_device_id helper function"), there is a branch that
> you can pull into your tree to get it:
> 
> [...]

Applied, thanks!

Repo: https://cgit.freedesktop.org/drm/drm-misc/


[014/606] drm/bridge: adv7511: Convert to i2c's .probe_new()
          commit: 1c546894ff82f8b7c070998c03f9b15a3499f326
[028/606] drm/bridge: parade-ps8622: Convert to i2c's .probe_new()
          commit: d6b522e9bbb0cca1aeae4ef6188800534794836f
[035/606] drm/bridge: ti-sn65dsi83: Convert to i2c's .probe_new()
          commit: 0f6548807fa77e87bbc37964c6b1ed9ba6e1155d



rob

