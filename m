Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B04653FD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351907AbhLARgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351884AbhLARgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:36:03 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740D0C06174A
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:32:42 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nn15-20020a17090b38cf00b001ac7dd5d40cso2230724pjb.3
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tajQG2IXpUHOG7d+miPPm5Ju3aS6NAnj/QtfwuMOwXg=;
        b=GEL1WBg4yORHo7VkJOAeMBB68Lc3oYTCpp7roLVtCyZazxTQ5exS58YJMD+3XHstP6
         dyxhIbalDDAC3n2NLc+UptdNFwQnPXWs3I1Rb67dIOwgSocvl63YMcdwMzivL6q5YbdH
         ueNoGNlUIsnf7qyM5ONAc0fTmX4dcj//t3y+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tajQG2IXpUHOG7d+miPPm5Ju3aS6NAnj/QtfwuMOwXg=;
        b=MMF+YpYKLCsH1jsqUxVxvNxDDX/d7UWmg76Vr2t3eTyw2qx34OCnzOhaiKOrIM1BLJ
         xQDdC1GysGZFwq9rHXpwwwkVpjonZUf+MtYWt+HXLee/t5sFqig3UpqMxCZkr4Kz9JWT
         49djEqsXzGBuZsn54URVUS2nSUk2C9w3u0dWA8Rh9ziHkevyLqdBAxblg2bEar8xmI3g
         RUdcZ9BijYpumX6+1pgYCCweZlWqQymRKgUhpFpd07MZrjyaiiq2WhKHpgRaYHrFPhhB
         YLygLzHW6sS6jWdxkWKgmEK6djqPIgQQ1117Im0aY3VpTscLRyOvaJyV6JUMGT4/Tgt5
         Hp9A==
X-Gm-Message-State: AOAM530PEYovQYKCOAGdxqx8QAX2uCiUNTC3Y/qGu1YTu5dc/ONdhsQ1
        lhphCN52PXOL42u7q/TVORdOKg==
X-Google-Smtp-Source: ABdhPJw377FYs7Bam0Ge86fDRJS0060N6Ojrxv+gWS71vLLMRkZQUD+oAORaFCnKrokjw9+mXK1qLA==
X-Received: by 2002:a17:90a:7e10:: with SMTP id i16mr9129659pjl.185.1638379961966;
        Wed, 01 Dec 2021 09:32:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 11sm421586pfl.41.2021.12.01.09.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:32:41 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Carlos Cobo <luisca@cozybit.com>,
        linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/2] libertas: Add missing __packed annotations
Date:   Wed,  1 Dec 2021 09:32:32 -0800
Message-Id: <20211201173234.578124-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=518; h=from:subject; bh=+kcRJJV1GaFXSrqsIlMFvUEF240ydaxafS7OunQQo9g=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhp7Gxc8kO30ddGOKhJj3+ChMvNemOr3iGJfWUrQ39 FGOcDQKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYaexsQAKCRCJcvTf3G3AJoRND/ 9z9BEZhmtixAwSO2m5O0kiScfiEPDQCeZ2RdC9s9F1cwnMedyQ7s3oeOxMqidTCYmiNhhqwL7DjImG 1JzZN2ZQlawe3lZQP/hcbEMTuWatbW0DtHTX+hs/pqz3YWrQJeX1ZIZnMq+Oeb9GKv2JHME9AFcB7D /ti6vP+H08K7t039k0jkL52vhipzi3kvbhmetbtfJS/nx0cKB/rNpAIHai4MRxT+SdVXbB7+cye3wd j/mEXg4cyElDDB4srOXRFqk9E391MTL4RDlgGtgqpnXA516uaIng3zrY9e/VnwEfIozwGtVcRlnuEv c4/Ap+xghhcCc8dj81mcc4jr/JPjC7Edkb09x34kvKqQomR1fvbsTjGydlqXSV3DBWFASTo5SxG9Ak 03gmuoZTRC5uWhATuV3A2yMQ9Rkk8FVzoG70iHyIoZw7IYooIdfe+Vk6ZotnJLbZ2GNzQmUHHvozOA v81upMXs6oHPOJAcTl+TeGCzzhZ/OjEIhdBDwEcUOT3X7zQdlrZlXpvtq+WQmMJdz0HSsxiDpZgVsz 544/LqsMTlIITiwIN7nMuPDpbZHOAj26AE9z6EDKiinMxLh8ltInulYs7GNSzdES/Xc5V6aLNLv6TW kS1M0itYLY1VckSbw+LlzmoW3ORGzrDWxSMoPZKw4le0ZgZzJqqN923LgaRQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This fixes the missing __packed annotations in libertas and libertas_af
noticed by lkp:
https://lore.kernel.org/linux-mm/202111302102.apaePz2J-lkp@intel.com

Thanks!

-Kees

Kees Cook (2):
  libertas: Add missing __packed annotation with struct_group()
  libertas_tf: Add missing __packed annotations

 drivers/net/wireless/marvell/libertas/host.h  |  2 +-
 .../marvell/libertas_tf/libertas_tf.h         | 28 +++++++++----------
 2 files changed, 15 insertions(+), 15 deletions(-)

-- 
2.30.2

