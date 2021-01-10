Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A32F0712
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAJMQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJMQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:15 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483FAC0617A2;
        Sun, 10 Jan 2021 04:15:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t6so8056532plq.1;
        Sun, 10 Jan 2021 04:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q8foebQUtGdCypSWJHLEUtXdb+11eXd3D5tTzSpdHi4=;
        b=vNDO9XhNgi/jOXglfVW3ZDrJ5XjA2pAAJAQldBivQ6k/3l0t/ppYVQf1WyZRo7D+Hz
         yTpy3C5ucWyI0VaCiJ3riJ2WkfebApRChkHJjaRXPdU5ke5SpEbHFCeXKy7HNxgQUShj
         Nt+veaMh37f22kyJdF49JHLJSIdg/c4QOnhzLsiuIK+51luEOEtYZoJcXLUJE+K2ZsMC
         o4aeb9hdQB7ROZMI/vD85fp5OQ6nfw8rerbgnKqrEYfxbSiU5CNIUAI75M7vsl9i+EPn
         EdBeXtGNzID7aurrJFumDCc6Jd5xLhxXA5eVtcsbroX69D8EM3BcricRUP+a7ANu7Tvd
         X58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q8foebQUtGdCypSWJHLEUtXdb+11eXd3D5tTzSpdHi4=;
        b=Re4ZqaBEE4LIalq82ox0nRIKlgrHj6YPAYynaof5K1p2kR/i3hPbzzFI9immMQU7qV
         BppnD6Zb88uXooSmHZbi3hoE/5MH4XyX1DxdfghK3k8jF+nnkJST4CcSDTTOgpGieLXi
         CsH9Gc1wOgxz/b0dZfHGRNVZCCY5t/DIDUKvKXCJrOShTI7KFY6w82aD2M98thHFZD6B
         C4zXvrsgoMzxFvhkTOfRNlH9QsbwGeLyvMcMrEgyXfJyspDClA85sDW0vS5wIFsXHzIf
         3EcyjYX6xb7Wd166tMny8K9G/silLES4GEtcDCXJ2rMxmJ/wU3J5/TPflFAcPWE49x9M
         S6YA==
X-Gm-Message-State: AOAM533ZjUOrhr8960PsnwnpJL48tdLlcSq5IPUDM5KCy1jNpkz0xr+X
        HX1BZ5lre2gGClBxyWYM4O8YnhcuURIAq5BP
X-Google-Smtp-Source: ABdhPJy2YzfzC41j6G3vg4QRgtbHlF/H61TP8HB26CIho8E4kTDY1jTU3xlowlN1CWMlCMlTo96GgQ==
X-Received: by 2002:a17:902:228:b029:da:6be8:ee22 with SMTP id 37-20020a1709020228b02900da6be8ee22mr12244804plc.44.1610280934403;
        Sun, 10 Jan 2021 04:15:34 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:33 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 0/5] rtlwifi: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:20 +0530
Message-Id: <20210110121525.2407-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the bool comparison in conditional expressions
for all the drivers in rtlwifi.

There are certain conditional expressions in rtlwifi drivers, where a
boolean variable is compared with true/false, in forms such as
(foo == true) or (false != bar), which does not comply with checkpatch.pl
(CHECK: BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c,
"if (mac->act_scanning == true)" can be replaced with
"if (mac->act_scanning)"

Fix all such expressions with the bool variables appropriately for all
the drivers in rtlwifi

* The changes made are compile tested.
* The patches apply perfectly on next-20210108

Aditya Srivastava (5):
  rtlwifi: rtl_pci: fix bool comparison in expressions
  rtlwifi: rtl8192c-common: fix bool comparison in expressions
  rtlwifi: rtl8188ee: fix bool comparison in expressions
  rtlwifi: rtl8192se: fix bool comparison in expressions
  rtlwifi: rtl8821ae: fix bool comparison in expressions

 drivers/net/wireless/realtek/rtlwifi/ps.c                 | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c       | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c       | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c       | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c      | 8 ++++----
 6 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.17.1

