Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB748F32A
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiANXsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiANXsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:48:54 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45F9C061574;
        Fri, 14 Jan 2022 15:48:53 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so8466959wme.0;
        Fri, 14 Jan 2022 15:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySZL7RoYaL29XosJreK0Gzamm/2aPB7hvnnCs2NFPcU=;
        b=FUH7o3wjCqJ/PC6aR8HO4iTtGuCuMVDs3n9dhuZR5fdcly8iMQXLzhjpdo1ws2l72f
         +e5HbaKHZBcCKj/Sf9GEx+Q8BHmM0V4LmTo0StOS7xjPI1XTSrxnH85uJ1YS+yJGHSgX
         ToAzrdC7IljLfmujYdWh5UE4qZrCjglQvDLaH6grSSKgiFhYNTCgaKYwPp0u0bX7LX8y
         lFAzKSmVxlEmFcDaaiCsy0G51A6j9fKF+48Ao9GxR33E1nedBx7kcA09oPH0dZeAYQNZ
         XRREP3BsktzZsQH1FLicu3IG5V9KvVYiN7OtlRAPlAwyJ+yDltv179WRdrj0ZrlUZCyu
         uC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySZL7RoYaL29XosJreK0Gzamm/2aPB7hvnnCs2NFPcU=;
        b=4NlDKF6U970ie6DsiJ2Ztygq/spwWO4VIeNVapD96lBhka4+R+MsSqEavz/CeW5U9W
         toQ5eP3OhptpG/otmQt+kGpI71LWZQqZcI30n7JIhIoxUkLL+nVpGG/j+dc8A7fzW0lC
         HTlX+vF21WeM4NEOaIjAmRnmVhhsFvAdYWoeGFyJ9/SIVh6fEOc25CkGskn/lSOpAlZV
         SW1Upbj8cAVHov76VJMcNuwXSJ1swpIxCJ6mCKguVaO5flOlBfpL+Y+YkVocnWIqPstJ
         AR43aXPpTB6goSAC8kj8Hw0t7ejNyUBADNgPH8V7pAl3dW8uVwHkjwzS1QDeFT5JuGwC
         AtzA==
X-Gm-Message-State: AOAM53370B7/p8IEFYJdpnFDQG3mZu1rIAboLwta7j194DOz3WYohWgb
        81tOosD4xM/xipcnzWBtlYD3HNtFBxg=
X-Google-Smtp-Source: ABdhPJz0xmxj6j7iS5TecpFNyAuScZGxk31roquob9EYy8aC4AuLMydSXt38D7rgnBrPy+sBoUwatg==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr17641286wmi.165.1642204131880;
        Fri, 14 Jan 2022 15:48:51 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7684-7400-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7684:7400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id i3sm5788533wmq.21.2022.01.14.15.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:48:51 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/4] rtw88: four small code-cleanups and refactorings
Date:   Sat, 15 Jan 2022 00:48:21 +0100
Message-Id: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series consists of four small patches which clean up and refactor
existing code in preparation for SDIO support. Functionality is
supposed to stay the same with these changes.

The goal of the first two patches is to make it easier to understand
the allowed values in the queue by using enum rtw_tx_queue_type instead
of u8.

The third patch in this series moves the rtw_tx_queue_type code out of
pci.c so it can be re-used by SDIO (and also USB) HCIs.

The last patch is another small cleanup to improve readability of the
code by using (already existing) macros instead of magic BIT(n).

This series is built on top of v3 of my other series called "rtw88:
prepare locking for SDIO support" [0].


[0] https://lore.kernel.org/linux-wireless/20220108005533.947787-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (4):
  rtw88: pci: Change type of rtw_hw_queue_mapping() and ac_to_hwq to
    enum
  rtw88: pci: Change queue datatype from u8 to enum rtw_tx_queue_type
  rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
  rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()

 drivers/net/wireless/realtek/rtw88/mac.c |  4 +-
 drivers/net/wireless/realtek/rtw88/pci.c | 47 ++++++------------------
 drivers/net/wireless/realtek/rtw88/tx.c  | 35 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h  |  3 ++
 4 files changed, 51 insertions(+), 38 deletions(-)

-- 
2.34.1

