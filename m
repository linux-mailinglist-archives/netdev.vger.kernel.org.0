Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2164A2C9425
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgLAAm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgLAAm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:42:27 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC4C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:41:47 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id q1so7358ilt.6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfRCDG1DfZk0mjNm0yF+dvADx4aswh9w4XOl0WSoS98=;
        b=YNB6LrG4Z5CYoFDYin04fFtDEPl70OJ3GzPFIfG5KhjTqYCTqUYiWj+aDNsa39Nhmq
         d3by2k02FfvxKupn3JJXmkLqtuRCS1b8+U92ecjqr8xJT12zwW1YuFsEbdt0liCd9QDA
         WvTHXNBY9sB/2+7sXNdi0Mnhb0JuBaaLnPMoMGN++1kLWzBwVt3QJ1PZkpD6bmy4eiE+
         60GCM8fcEfwF5Ts7MJKQdsqYzOs85O3qdsW0j5Sf7kds3UBwYHljCDQHDSf+9QEVF67b
         4b4d53ZNFvNTEogc9SHBvK0NAfGPITs9skQm/rTCCPyaJ1m9dbyj1Kf/bzxrWXU4b2ag
         DyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfRCDG1DfZk0mjNm0yF+dvADx4aswh9w4XOl0WSoS98=;
        b=twHC8t9la/NlgBG9vjrK9R3FjGskcFlySzUBD2oCMqJ/Bs1T2UOcU7P0W9XPBvb0Cn
         9o46QQw61NsQEV8joAo9XmDrOVl8tgM3I2VHSCuLM5ers6ERQKfrJE3Tk9ieLe49qgs/
         nF/eJcKDkAxNAGJ8B1uD33Wo/9b0t6ilh4oBSj/76zE1WMh8f8uzkv2t5OXc+Adh9Idc
         6CGj+4OWXysb93ISA2hPn8sBsnfAw4Gcsh/HpxqDUGE248FhdIR61A5GxptT8g2VsiH3
         pOkzGRnfpmCtviWOWg09EufvItspT6X4JsgZx3MGCC+TGWX3rGUKNz5W2pAzJlf5VKJR
         4r8Q==
X-Gm-Message-State: AOAM530aXCLe/137WoQ+WHH6phdeaJXfWYzJOl3C7VPlIjgOy/jiIwWS
        LesS/AYUtvKUFjpESBGKANB2lsHBJrJ2cA==
X-Google-Smtp-Source: ABdhPJzLkOBwf05+96QUNHZdn5UgAMddI329mHbS8VAWuU9vin5os8cyhLbV/SdhIfDO2SbEyraiAg==
X-Received: by 2002:a92:8b12:: with SMTP id i18mr325439ild.278.1606783306662;
        Mon, 30 Nov 2020 16:41:46 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p7sm138561iln.11.2020.11.30.16.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:41:45 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: IPA v4.5 inline checksum offload
Date:   Mon, 30 Nov 2020 18:41:41 -0600
Message-Id: <20201201004143.27569-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes one changed destined for a central header file
and a second (dependent on the first) that applies to the IPA driver.
If these should be posted a different way, please let me know.

The first patch introduces a new data structure defining the format
of a header that's used for "inline" checksum offload.  Changes to
the RMNet driver are required to fully support this feature, and
those will be provided separately.

The second patch implements changes to the IPA driver required to
support inline checksum offload for IPA version 4.5.  It uses only
the *size* of the new data structure.

					-Alex

Alex Elder (2):
  if_rmnet.h: define struct rmnet_map_v5_csum_header
  net: ipa: add support for inline checksum offload

 drivers/net/ipa/ipa_endpoint.c | 50 ++++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h      |  1 +
 include/linux/if_rmnet.h       | 30 ++++++++++++++++++++
 3 files changed, 70 insertions(+), 11 deletions(-)

-- 
2.20.1

