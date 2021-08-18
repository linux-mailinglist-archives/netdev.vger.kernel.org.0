Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF52B3F0B59
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 20:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhHRS7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 14:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhHRS7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 14:59:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9560C061764;
        Wed, 18 Aug 2021 11:58:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso5076077wmb.2;
        Wed, 18 Aug 2021 11:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aZUKO0xBhPvTHickZ2Ey0cavlsrzj5YNCcpYcKs8Eto=;
        b=HJWHmbzFQ6lKtVT+rc5hWA2YsCw3y0UYee4YNkBqM+icz6fLV0yCqoK441+SNDep0h
         L8LzRCGnoGFE6f03t222PkV9UA9uvMsSuiL6pmOlZvbiV6I1rScjD7HZtIlmOU3tizwz
         YidVNp68Bz0+81/r5rpiqKZuFE2D/eNGgxdXMRh4qGdcQdIdKluqr6PnvhJI9jSskW15
         ON3rUTbfbRg530ibZrYhHn6wUuRJhlMtWOdCk0SJYTWtvH8JNj4qTrO8muY321PQiULR
         cTUk9x579OpLrj+8imbwV5vOeHCYCwwvYJEiLbMtyj9G5/m9zGtAIIgQYRfoFYUJobt4
         L1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aZUKO0xBhPvTHickZ2Ey0cavlsrzj5YNCcpYcKs8Eto=;
        b=csj0hlHMdD65twSNccus8vGhu9k2BpeEhwhqKNLQthCaNVJ9idN4SVe7AQDrWQE+BR
         ciAStw8+jafmc4pgM/0rMxivczyqmd4/KXUY8cVrP9IIvscfMfHURYDZCzx3OPfjTLnX
         hzDzILhbwHCKNT5vXnNkRGZvqIN7sGZu+8LBjQveCStzPiF6dmlKfNNPYOlmLgj88zGE
         rxBKV+/8ZEtgWVjq49Okng8YWIvekzKEmSYc0xtg8YH5gVWKHr7vp9rJs4hOy4q4cU51
         fyj9wWHcmnGxftfLwMASSHM0yJyVbexw3N2Zz+VeGpCd1jj3WjVOHtcz1nipAKR5iPa4
         6AOw==
X-Gm-Message-State: AOAM5305EPclzv0SnWu58I1QVleJ8CWN6bmvdhqBkosZthlFxljzz8PY
        hNtsL4aJioLhrHxgJFyoE1fkNO2BwHr2Ng==
X-Google-Smtp-Source: ABdhPJzVT5FeVueVwvw7TcsDG2jjEvvpyST9/unIZsuMLoEx1n6dXLdHd9AzeZ1NLDm0oV0+b2Vvpg==
X-Received: by 2002:a1c:1f17:: with SMTP id f23mr10102447wmf.136.1629313107088;
        Wed, 18 Aug 2021 11:58:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id o14sm626913wrw.17.2021.08.18.11.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 11:58:26 -0700 (PDT)
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/8] PCI/VPD: Extend PCI VPD API
Message-ID: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Date:   Wed, 18 Aug 2021 20:58:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds three functions to the PCI VPD API that help to
simplify driver code. First users are sfc and tg3 drivers because
I have test hw. The other users of the VPD API will benefit from a
migration as well.
I'd propose to apply this series via the PCI tree.

Added API calls:

pci_vpd_alloc()
Dynamically allocates a properly sized buffer and reads the VPD into it.

pci_vpd_find_ro_info_keyword()
Locates an info field keyword in the VPD RO section.
pci_vpd_find_info_keyword() can be removed once all
users have been migrated.

pci_vpd_check_csum()
Check VPD checksum based on algorithm defined in the PCI specification.

Tested on a SFN6122F and a BCM95719 card.

Heiner Kallweit (8):
  PCI/VPD: Add pci_vpd_alloc
  PCI/VPD: Add pci_vpd_find_ro_info_keyword and pci_vpd_check_csum
  PCI/VPD: Add missing VPD RO field keywords
  sfc: Use new function pci_vpd_alloc
  sfc: Use new VPD API function pci_vpd_find_ro_info_keyword
  tg3: Use new function pci_vpd_alloc
  tg3: Use new function pci_vpd_check_csum
  tg3: Use new function pci_vpd_find_ro_info_keyword

 drivers/net/ethernet/broadcom/tg3.c | 115 +++++++---------------------
 drivers/net/ethernet/broadcom/tg3.h |   1 -
 drivers/net/ethernet/sfc/efx.c      |  78 +++++--------------
 drivers/pci/vpd.c                   |  82 ++++++++++++++++++++
 include/linux/pci.h                 |  32 ++++++++
 5 files changed, 163 insertions(+), 145 deletions(-)

-- 
2.32.0

