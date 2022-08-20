Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6985359AE8E
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbiHTNvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiHTNvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:51:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D420CB491
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:51:07 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u6so3592431eda.12
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=igU0Y/e3LObgehnqCWv2Dqe493YJDWeXb+3v1DG+a5o=;
        b=Zh8za/BGbWGaqDZ2YkqNNhRTpnqZv/+SYfCMnQRWbc5CFhYhibkv8SCAHHzLR+t+wF
         uSXnw8fH7BJJQHHx5PAoIsYCWL8z2kLll19RGd5T4evl+2LACO1cdzaevQXNBpok0hE0
         Zq5Iz9vE9wd/7Jd3ScVIhx7VGLAbXZnRSwbNmK6FuF9fqn60176NCrBd0uR5Ew6/Lgqm
         IBIrU62ZGz4X7wCrC3QzISJmzoIBgwKaCUFJpp3gMqUcLdw0LQaDZYgpH3YGvkAI1ptQ
         yTrMzpDa/sB1S/oHB3lJ8KSGRluPPFTxKNX+giWLhWyxLW2erDlFBm/1CPACMinq9w3r
         JqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=igU0Y/e3LObgehnqCWv2Dqe493YJDWeXb+3v1DG+a5o=;
        b=2PnOUhylLjAhN/OTTZlqStn4Cgn1xd74KU4IriA2jnTYVjpb+wmIqGjMoR+Kdygc13
         XEr+maC3Wf8ToFQ5i6MITd66xfqboMWF79nK/6jLN+YWj7V51dydt4xu4pp6wrrpfp3d
         fBGpDoeIH7URXcQWvpNwNOcKereetUqPfPBk66PdhlVYLUBmAmx8ajpYQLjNgEs4Q9NK
         Y9BhXlqRYMQMn5sxGkFGEWAUGV4jWVdDFl9ooodvr4PVbgL/dwIsfIv+9HMmKwnSOkSQ
         QmOMT71BrZAEv1gB4AV1TuR0MGz82Gyy/nUeyOa/0W9vrJPbHE9E44a0mPlMd6XKvk3U
         Yi1Q==
X-Gm-Message-State: ACgBeo1r/4xN9zxE9cMde1y0gB9WDbpJmxuQwJdD4oJb7oxpzMS4Xi/T
        /ilb1YtgzY1Ig5CDfal/ODQ=
X-Google-Smtp-Source: AA6agR42l9BZ5FFy+5ZCV+sMAIuiYHzBCudtNveKN4KTn7Z0xclJXDUx4bfVIC9IVnPvsRNe98V2lg==
X-Received: by 2002:a05:6402:428c:b0:440:8259:7a2b with SMTP id g12-20020a056402428c00b0044082597a2bmr9367919edc.329.1661003466259;
        Sat, 20 Aug 2022 06:51:06 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id 10-20020a170906210a00b0072ee7b51d9asm3637560ejt.39.2022.08.20.06.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:51:05 -0700 (PDT)
Message-ID: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
Date:   Sat, 20 Aug 2022 15:50:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next 0/5] r8169: remove support for few unused chip
 versions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of chip versions that apparently never made it to the
mass market. Detection of these chip versions has been disabled for
few kernel versions now and nobody complained. Therefore remove
support for these chip versions.

Heiner Kallweit (5):
  r8169: remove support for chip version 41
  r8169: remove support for chip versions 45 and 47
  r8169: remove support for chip version 49
  r8169: remove support for chip version 50
  r8169: remove support for chip version 60

 drivers/net/ethernet/realtek/r8169.h          |  12 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 124 ++---------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 130 ------------------
 3 files changed, 18 insertions(+), 248 deletions(-)

-- 
2.37.2

