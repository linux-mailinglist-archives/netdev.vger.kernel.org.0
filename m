Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330CC3D81A9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhG0VVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhG0VVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:21:03 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B405FC0619E4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:36 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id m13so407211iol.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZgXW2V/OmKKCTONUYggrHApUH/cqcNZ6/eLxchFR40=;
        b=VM7KUz0bF1HEiw7DUvb0cAp/g9JcMdSpkE+1acS68yPoa2/OpWNBkieA2Lu5+ZFgS3
         DabDqKTvy6RQWLCuKi2ELVEbV7Ewa1qHCDtLod11+AjBV2agVt//Iuos+xSVOkR2ZNa1
         x3X+hTbIFAhxJpvNoQmjTiNIqwHxbqNFhIzyzyn5+mNkHZqAnlj/08jiM1est/OLMZoV
         +trp+QyJi1CRgoWPPcbxZ43e1+IoSZ7blHTAVpU5imQQ7CWQdxgE4b0edPDATadNMZxl
         vbOYCHomWvRdiPCp4Aie/kSiIfLxTqaaTKDc/oMY37O7sszm3ZwypAY5bHgrvrFxWEbg
         8ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZgXW2V/OmKKCTONUYggrHApUH/cqcNZ6/eLxchFR40=;
        b=f8uHOJn/WsxhFaWZ1gSUNnF9UUM/nUGB35Zzq5u6JUfSTgemRTHTSBzYkmJ7YOtCOV
         1TsHwECNpH5gV7Ns5brLk8Vl3+OtnUXLSMRx22Zx4MR0nR9ThRydCXYqbD+/jnBkd+NL
         xztk2VSbdfvenQW5koQLnICPPwgHMxs71GOtJt7RnPc0bJJBo48FsqYDeDXKhDW7VwA3
         Lf3UYyatoqk3XKsZ3rorX0T2lHKDbGqnh9SVsRkDgubZUdjQra8rT83TKy2Tnw8lfnxx
         yACqVjFpHCy9+KIRyeBG2RVW3xsfqMj5shq2snwI95R5KGo253g2yOD+ZERKvFuxkMRN
         jO3A==
X-Gm-Message-State: AOAM530MvyjHp3GpI0AMCzY6RAN/sbwKwhSiMeprngssZWEYnlXIfcrU
        jtY7T691ykgPwQmxxSlo0hdPnPOPK91ZqQ==
X-Google-Smtp-Source: ABdhPJyKyHin6AJhtDilAfPr1Ta2tQ2NmkxOXC7J0laG+PMpC0T6eeyG5+wP1CJLyqJVUu4jWSh36Q==
X-Received: by 2002:a6b:b24e:: with SMTP id b75mr20870753iof.94.1627420776131;
        Tue, 27 Jul 2021 14:19:36 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s21sm3136068iot.33.2021.07.27.14.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:19:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: add clock references
Date:   Tue, 27 Jul 2021 16:19:28 -0500
Message-Id: <20210727211933.926593-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series continues preparation for implementing runtime power
management for IPA.  We need to ensure that the IPA core clock and
interconnects are operational whenever IPA hardware is accessed.
And in particular this means that any external entry point that can
lead to accessing IPA hardware must guarantee the hardware is "up"
when it is accessed.

The first four patches in this series take IPA clock references when
needed by such external entry points, dropping those references in
those same functions when they are no longer required.

The last patch is a bit different, though it too prepares for
enabling runtime power management.  It avoids suspending/resuming
endpoints if setup is not complete.

					-Alex

Alex Elder (5):
  net: ipa: get clock in ipa_probe()
  net: ipa: get another clock for ipa_setup()
  net: ipa: add clock reference for remoteproc SSR
  net: ipa: add a clock reference for netdev operations
  net: ipa: don't suspend endpoints if setup not complete

 drivers/net/ipa/ipa_main.c  | 37 ++++++++++++++++++++++++++-----------
 drivers/net/ipa/ipa_modem.c | 14 +++++++++++++-
 drivers/net/ipa/ipa_smp2p.c |  5 +++++
 3 files changed, 44 insertions(+), 12 deletions(-)

-- 
2.27.0

