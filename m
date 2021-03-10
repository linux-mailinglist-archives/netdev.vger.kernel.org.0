Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838BE3348D2
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhCJUWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhCJUW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:22:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59923C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:22:27 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so11523605wmj.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=o4wK78F5Uu36P41G0nlcc0Jx5jWD+6gKqgIzSvQj4wE=;
        b=S8a/NnTbgE2k/MRq5tZ4SWn6A2u+tK9IrLHA82RpIvAF2FWDpUQWrOOEXNMR/VZBfL
         LoL/3mgdwMzg1SNd2Sz/BMljezeWSNzqc28auHNVvqlqVybqnABTj0/u26NsZA3ci7yt
         Ug0mgXrlo15GuzcBK7MJAGRHbeMsKfNP2yRii4tWKnpp9WxcTQ+uddKIFObWNrxU+pIc
         87ZSE2VLtic9+0DMgr4bvmRVAHg5H6amoz09R+SVa8YVAwIH6ahrl9N7+9t0nqR9kiat
         lSFyyKZO/MuWVrTWTu35P9ayov1Cj43ozHhqb8EDecGfjztnN3CpiXjaPupoPWM1x1yS
         Kk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=o4wK78F5Uu36P41G0nlcc0Jx5jWD+6gKqgIzSvQj4wE=;
        b=qaLhxL2pIoiVcM9gG4fnm2XncVzaqvPQKtG1M8nJ9NKAdsxOOPnxxMmm4fUq9GfZdP
         NvhwHSEZR7gHYWUp/zuQVSF59UqXDffjAYBaVs8KE2biA2zrCkbaUOJcG4vYISFpG4aa
         7Ko8+5k74bQYQd1KWoPz/q7S0sG0ZEtRvhLxvpje6LSogwUtwAAbo695hf+QNfF9T+wK
         dDNckupANqiJ2KYRUJflQy3gT06PdZVYimP6YjdgYaQMVlAWdn+IZgCj6nGI1W4tCqDe
         YqvpSORBss+Y6OB2Gai/N0B3aOCfKLepCmdfgytK7JKLRezl9LUGC9UcD0phpCuCgPEK
         1kVQ==
X-Gm-Message-State: AOAM533BcU2uXYUOi1tliBXzuS71kLIK7canGOUku+jKfvf6aYRQhbB/
        pjQ/gr5FRxvMLfipWaT7mLPKr/QBvXSZiQ==
X-Google-Smtp-Source: ABdhPJwSZHrmSDFaNhI8UNhNz6xSrBRmL9jluEAzoBOBRZlxO/aRt1ToPziMcklMiead7yEF/O+tWA==
X-Received: by 2002:a7b:c007:: with SMTP id c7mr4922585wmb.59.1615407745615;
        Wed, 10 Mar 2021 12:22:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:1d99:917d:ce16:eefa? (p200300ea8f1fbb001d99917dce16eefa.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:1d99:917d:ce16:eefa])
        by smtp.googlemail.com with ESMTPSA id r26sm537602wmn.28.2021.03.10.12.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 12:22:25 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Enabling gro_flush_timeout/napi_defer_hard_irqs per default in a
 driver?
Message-ID: <39fe64b4-84bd-a40c-2638-c61652642302@gmail.com>
Date:   Wed, 10 Mar 2021 21:22:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In r8169 standard irq coalescing is disabled per default, and setting
gro_flush_timeout = 20000 and napi_defer_hard_irqs = 1 reduces interrupt
number significantly, e.g. in iperf.
Therefore I wonder whether it would make sense to set reasonable defaults
for both parameters in the driver, similar to drivers enabling irq
coalescing per default. This way users could benefit who are not
experienced enough to tweak sysfs parameters.
Now to the actual question:
Are you aware of any use cases where setting these parameters could
have a negative impact, what would speak for leaving them disabled
per default?
