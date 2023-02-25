Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6326A2BEB
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBYVnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBYVnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:43:18 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC82EF86
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:43:15 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so1634907wmi.3
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUgv9quQRDLaHRMRl3iDbr75Ee/2zWnO+saAPtC08Ks=;
        b=YVV53bQVUpRZlV1eALRcRttr4/nBjtTPswpl3lxAkDjwZEetGmUIWDaW2OYn9Wa/jQ
         /J1LfLAO4Ccl9Rx8ro92DPUYCuP+YZZvVHMVkYEyc8F7BgULineGC11/aS4qwDbwirr0
         Q2X7ZQy2nkoiwev5qicWvR5ElRcS0EwhRnAtKKdD5CLNQmLhiL7eXMJp/RYLLhoj4sf2
         DcRJTJgGZHByFY2gofk9zIx/OGxhjEJGwaockTkw1UJAY/GhzySkmpdCr8mMAudiVBLn
         epjYOtbrtfu4MaNU6YvJfOSTLRGVULlo7rqzcUTkm/++Sbq35YN73QzAO3n51zpn46BJ
         paiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pUgv9quQRDLaHRMRl3iDbr75Ee/2zWnO+saAPtC08Ks=;
        b=YAU5IbbWjrMuuRoUzKGcnbX3dELbSPW+H9yGyam1t8UFrcY44Ydtj9qTmwcKqN386D
         3kOt4TJ9zF/YfmO8KgBrU2UYAHkg5JsepuAXAwL331BhhSOpMtfpH128SCAljX1gQvEc
         EwUhnoxVs/cPNqbVgGFdDhWEj+b/YQM7XxEzB4U/C5fClqP4vnE4qu8JVG43OdKlARpX
         p1pKySVHslZrpVER/N4PgFyZ2KWiFXw2H+vGkGTRvnIfmvKpYNZ1z/IGvpWU9AJaCMbe
         OYIr7MpMmZYRcG832om4LmDNyJyIIH2lajeRJw9pJJkJifJUo0Dj45CT8z6hAhPY3yyA
         Xp9Q==
X-Gm-Message-State: AO0yUKXiW/ir4keBX6HNVjs+SycGuqsM2PbeosfnHaO2hnDIemBuKLF3
        nT9iH/3i7y2Z1JnoJYYAD6g=
X-Google-Smtp-Source: AK7set+89WXkSpGvgyFp0VmGyJCMBroRMVccHQnX+7IN7F5iA2iBBFEaS6cu3Z7H3fb98WfDXmDgsQ==
X-Received: by 2002:a05:600c:329a:b0:3ea:e4bb:4e9a with SMTP id t26-20020a05600c329a00b003eae4bb4e9amr7293921wmp.2.1677361394001;
        Sat, 25 Feb 2023 13:43:14 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id z23-20020a1c4c17000000b003e2066a6339sm3732530wmf.5.2023.02.25.13.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:43:13 -0800 (PST)
Message-ID: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
Date:   Sat, 25 Feb 2023 22:43:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC 0/6] r8169: disable ASPM during NAPI poll
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a rework of ideas from Kai-Heng on how to avoid the known
ASPM issues whilst still allowing for a maximum of ASPM-related power
savings. As a prerequisite some locking is added first.

This change affects a bigger number of supported chip versions,
therefore this series comes as RFC first for further testing.

Heiner Kallweit (6):
  r8169: use spinlock to protect mac ocp register access
  r8169: use spinlock to protect access to registers Config2 and Config5
  r8169: enable cfg9346 config register access in atomic context
  r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
  r8169: disable ASPM during NAPI poll
  r8169: remove ASPM restrictions now that ASPM is disabled during NAPI
    poll

 drivers/net/ethernet/realtek/r8169_main.c | 145 +++++++++++++++-------
 1 file changed, 100 insertions(+), 45 deletions(-)

-- 
2.39.2

