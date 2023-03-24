Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10C6C882B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjCXWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjCXWMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:12:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6D31EFE5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:11:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l27so3165698wrb.2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679695916;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApuYhHltL3P4kJCak3V2beJhMKfcbgvUnwHon+V0FyM=;
        b=hkH4x8ib/xgdrl1AVgBld8wM3Hby/9KZNZNxmCUpA90/EWHspZUGewV90ytK9Ow4Zn
         oykRr3MPgOQC6EwBKbDyWBs4HyqNFaWEjKrYl4JjGE0krigu0t0qYzL1/AR6DU9g79lH
         e/T8kb9QSmHrLY72nChyYLkQ0Z1lKgffjXNjaGt5lBWIkoYLKxPUVHOlCpTz8iPrJrHr
         OqSUfN1JCt0V1KWzWTSkJ5+9KfOQXStGLkqTiKGtnNUhTQzt1Yr5b4pWdJfqYtp1j1IT
         mGaOXY4oyLVeU16sYSsROxanRERzFpla3drtvbcecLaipRXrIwP8N+kjJKLVFkuy9zzO
         zKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695916;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ApuYhHltL3P4kJCak3V2beJhMKfcbgvUnwHon+V0FyM=;
        b=W9GYl1hrg2pD9Jk2swOsK1peldShmckpq/XFJTmCZye+h9tw7r8YWA0Sy7mlOrrNwp
         528kjROjQvSBnqRSo36ABAMOzoIw9QWELcgy5oI5CYzVpCbXpPRGmnqwaQbJRLUR+KTb
         fWKOaasHxxKtOA6PAv6nz2n6yEyG58c7OiZxau95O6xcTYNnbTwyhtVuGywhQ4IWlT9c
         kyMlIFHplcTbgsIc/S7n5bjww3aKrny9wJ7yImLkhlOowKnB0myeAYhbX6QrSz6xhQ1S
         thvqq/XJuiy6poYVlA2Jc+ShZPoA7XvO/D2E7n6i4yvvNVJoaGT1aty6YKVfLcjtcuRV
         GcZQ==
X-Gm-Message-State: AAQBX9fV0ywXpZSADzvPYzFWKTMBAeA/a4LBma4By1Ij0p87VO2WOrJl
        yeGybV1fCA30+eoP98NiwK4=
X-Google-Smtp-Source: AKy350b1oy4T5jGXZ92yE4mAirscoHJDz/sHGxWB69bRpRpYThp1QnTyIkpKWG9AZA2WZnxP3AIlLw==
X-Received: by 2002:adf:e40d:0:b0:2cf:e6de:c6ab with SMTP id g13-20020adfe40d000000b002cfe6dec6abmr3311136wrm.11.1679695916039;
        Fri, 24 Mar 2023 15:11:56 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id m9-20020adffa09000000b002c70d97af78sm19347028wrr.85.2023.03.24.15.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:11:55 -0700 (PDT)
Message-ID: <d4a549bc-062c-e6cb-fb2f-75f32f8b3964@gmail.com>
Date:   Fri, 24 Mar 2023 23:11:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] dev_ioctl: fix a W=1 warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following warning when compiled with GCC 12.2.0 and W=1.

net/core/dev_ioctl.c:475: warning: Function parameter or member 'data'
not described in 'dev_ioctl'

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 5cdbfbf9a..846669426 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -462,6 +462,7 @@ EXPORT_SYMBOL(dev_load);
  *	@net: the applicable net namespace
  *	@cmd: command to issue
  *	@ifr: pointer to a struct ifreq in user space
+ *	@data: data exchanged with userspace
  *	@need_copyout: whether or not copy_to_user() should be called
  *
  *	Issue ioctl functions to devices. This is normally called by the
-- 
2.40.0

