Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A3658CDA
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiL2MtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiL2MtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:49:14 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D47313DC8;
        Thu, 29 Dec 2022 04:49:13 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u28so21716320edd.10;
        Thu, 29 Dec 2022 04:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fVKNfEXwGcxUKChJbDDSuR/UJQgliUdMKqkK7jJXH+U=;
        b=Tui/pCQHLBIRvY6EKMjcdGmm+8e/ZQPCcv7UOnO3rq1RXUyflHudQUG1QUbdmuxIOB
         ysNrXtZb4qNtnIpjgRBiLaFItKcoRm5B/DfWbeTyc0o/WLHTcpD658WvB2ErecE/iNfN
         I1RWEmS+Q2QD5mv7YR72CTh9OKWIPJOYkF+uq7xA/8RmEUcPcTnNC1ayPsH5Xsl4YWK2
         LIXmPBw7F0LkpQrLVrKVAOwxJxt9h8pRP2iMaUzahiEmbqh8EgHxSEFIyKigRznBu/Ms
         RbmvtHaY1Gy4SPzwF4nj2AMmmrbW9cP/pBHGgww8enrcQNWSrOLLjHJxJDLPw6ETecIJ
         wdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fVKNfEXwGcxUKChJbDDSuR/UJQgliUdMKqkK7jJXH+U=;
        b=bvosCkNeSCOGZ4IWdMgYfbVz/KbmB+vTETPPuEi8sXxv10ILjUUhKw6HDsvAyLVrKd
         3X2PWypep0qZdALIqGgJS92O2lfRGoVJZJO1xwPdTDe7LEFbf6O6bruEQtGn8Ex6UKan
         sITHg+bTntOVcZ/sNd5pfxN8qiEXF/TXK+WFiNACbPc9P8sg86qaDDJK8kWwuYBT88BF
         9dIyfsYqWv900uikrt6ALHPiZi9vv5rSG3QuHXPlvklOpSw3i0HxHM2VLLMoBZx8dsbL
         8LkyaV5ax8eIDWHpG2f/W4Lfca/nscQnZQAOPbYzz+muV+GAQdtGMFiORaMd+n5OJkJW
         YLRQ==
X-Gm-Message-State: AFqh2kpaSDI7ELAjzl+nlWrov26UzGZlsrmFhK7YPQ0Afy9lVEwQ/eAC
        sHjyvhK33EvNKiJUkxGRYVziF7+wRPs=
X-Google-Smtp-Source: AMrXdXsOFzoYcoHgQefRpDGL1hr4iSqOxwasH4kU3qYw0tTs5PAzy5oSj2nr16yUXfpV6woxtVN2Qg==
X-Received: by 2002:a05:6402:1759:b0:46c:f631:c0dc with SMTP id v25-20020a056402175900b0046cf631c0dcmr20929443edx.12.1672318150928;
        Thu, 29 Dec 2022 04:49:10 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7789-6e00-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7789:6e00::e63])
        by smtp.googlemail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm8166299edu.26.2022.12.29.04.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:49:10 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Date:   Thu, 29 Dec 2022 13:48:41 +0100
Message-Id: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consists of three patches which are fixing existing
behavior (meaning: it either affects PCIe or USB or both) in the rtw88
driver.

The first change adds the packed attribute to the eFuse structs. This
was spotted by Ping-Ke while reviewing the SDIO support patches from
[0].

The remaining three changes relate to locking (barrier hold) problems.
We previously had discussed patches for this for SDIO support, but the
problem never ocurred while testing USB cards. It turns out that these
are still needed and I think that they also fix the same problems for
USB users (it's not clear how often it happens there though).

The issue fixed by the second and third patches have been spotted by a
user who tested rtw88 SDIO support. Everything is working fine for him
but there are warnings [1] and [2] in the kernel log stating "Voluntary
context switch within RCU read-side critical section!".

The solution in the third and fourth patch was actually suggested by
Ping-Ke in [3]. Thanks again!

These fixes are indepdent of my other series adding SDIO support to the
rtw88 driver, meaning they can be added to the wireless driver tree on
top of Linux 6.2-rc1 or linux-next.


Changes since v1 at [4]:
- Keep the u8 bitfields in patch 1 but split the res2 field into res2_1
  and res2_2 as suggested by Ping-Ke
- Added Ping-Ke's reviewed-by to patches 2-4 - thank you!
- Added a paragraph in the cover-letter to avoid confusion whether
  these patches depend on the rtw88 SDIO support series


[0] https://lore.kernel.org/linux-wireless/695c976e02ed44a2b2345a3ceb226fc4@realtek.com/
[1] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366421445
[2] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366610249
[3] https://lore.kernel.org/lkml/e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com/


Martin Blumenstingl (4):
  rtw88: Add packed attribute to the eFuse structs
  rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
    lock
  rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
  rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()

 drivers/net/wireless/realtek/rtw88/bf.c       | 13 +++++++------
 drivers/net/wireless/realtek/rtw88/mac80211.c |  4 +++-
 drivers/net/wireless/realtek/rtw88/main.c     |  6 ++++--
 drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |  9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822b.h |  9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  9 +++++----
 8 files changed, 35 insertions(+), 27 deletions(-)

-- 
2.39.0

