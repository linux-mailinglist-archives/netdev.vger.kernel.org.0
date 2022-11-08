Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBA8621853
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiKHPdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiKHPdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:33:50 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C8178B6;
        Tue,  8 Nov 2022 07:33:49 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 130so1316562pgc.5;
        Tue, 08 Nov 2022 07:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QjHscvjaYqym/rp7feLqNBmkn133nl4FZ7MGJwuD27E=;
        b=q7S1je/eOaz8T5zmmL5tSbLG6GenMFu3EqQAkqyjMhh2qPqREf5hC7fnOwX67s+jIl
         VIIqF7xlEzs92XbxYEQmiHkPLHo+9FfcWc216G7YaIO9WvkSAKVSqBQCxrgsZY/gfO8k
         bPNuxO4+Qa8PQUTJM7hs7Z7x4jTmXUnxAIM63myyXIqiOYlb9BzdwtVMeXZJmPcH+4gY
         zbnNerYra2nX22IOQtQVTZDsVhgMjaNusbkaaZDdD+TWXCJI8Fvo/wHwkUkckjCuJm27
         rP853g1oUoiLve4SdqmbX+9mmKPo6VAockHpMIMZ4YvgRMwUj+q3B7Zt94mfHql/0s/j
         UcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjHscvjaYqym/rp7feLqNBmkn133nl4FZ7MGJwuD27E=;
        b=5vdbacj+NMJ7qaaQK0idKepN3SSNlHtSjk6Kim01FaVbohRoIoKIp+M8+wQ5mIgcUe
         vht/tATmN59FuWyE+OGXIzsnwy6dm47q/tTRPg88uTKj0mD8gEBSu8Q4Uqh7SAwm7Z9f
         KSzxYMh4EB5LaoudJfs6yxkJfC1AHNNfEPQR2rIqurG0xUXr696HOIbrUawRcOfqYoP+
         1qpwXaU5hGzA1GCbYkY9goJl90yF6lnoCgPjBPlrMkw6HoAdAaYqGiSWfuPVHQ3z1L/H
         ZGfSWPeJjlHnqgPtXIhsQx83A/LOQ6Gbt8388aI2BurLKK0DGuODtDWBRzq57XQc4nKN
         KnuQ==
X-Gm-Message-State: ACrzQf0eAYuu6xXxSgYZoW4WXTNKuXj0DeRrtogxU7tN++B7YrlDXXN2
        1Kn0CRFLNoOapwOyTLhc9kw=
X-Google-Smtp-Source: AMsMyM7pXsQLQ1UMzCRMD+5An8NcwCzVzUpeOqcs9qVEcMspow71O6LkXUu1fRE7aA9QFVWL1qkfMw==
X-Received: by 2002:aa7:88c9:0:b0:56b:e851:5b65 with SMTP id k9-20020aa788c9000000b0056be8515b65mr57093327pff.74.1667921629481;
        Tue, 08 Nov 2022 07:33:49 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:33:49 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 0/5] Update r8152 to version two
Date:   Wed,  9 Nov 2022 02:33:37 +1100
Message-Id: <20221108153342.18979-1-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch integrates the version-two r8152 drivers from Realtek into
the kernel. I am new to kernel development, so apologies if I make
newbie mistakes.

I have tested the updated module in v6.1 on my machine, without any
issues.

A final note, when I removed all the code for earlier kernel versions,
the header r8152_compatibility.h reduced dramatically in size. This
leads me to suspect that some of the headers like <linux/init.h> are no
longer  needed. However, I left them in there just in case.

Albert Zhou (5):
  net: move back netif_set_gso_max helpers
  r8152: update to version two
  r8152: remove backwards compatibility
  r8152: merge header into source
  r8152: remove redundant code

 drivers/net/usb/r8152.c   | 19712 +++++++++++++++++++++++++++---------
 include/linux/netdevice.h |    21 +
 net/core/dev.h            |    21 -
 3 files changed, 15072 insertions(+), 4682 deletions(-)


base-commit: ee6050c8af96bba2f81e8b0793a1fc2f998fcd20
-- 
2.34.1

