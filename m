Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803DA33FB3C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCQWaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhCQW3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:29:51 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE3DC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:51 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b10so238253iot.4
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlPLbsteYQ546XPJd0ZKu7bGdTiD6IsGwA9GxCJDXFA=;
        b=stSj5RRz9zbueNxXn5jZdxPmF6jF1qr93Dxuc2iFJmafR9bP5MgWXpeZI18ySGWjji
         XYwF5hZdjQUXcskcXtPm0FW50UWGBK0/WsBfe+2y9mjoEIsGgYyTSzpi5/vGcdK41CHM
         p0aJulR04XcHEDccZQsX+TNkKUILiChfZE3m8TYvgcvPsO/sOTyqyKdmD84zmQozbiSo
         2+mtv1GZP3Q0Q1mpHAP/RIHTkZD67bxwmhei5tkGNBgBV+WT7UwC5UE28sY8w8+YYQvd
         zrlV8Sx9+jjghjitXZ3DkVmHO3eb/BG4i+nleXX6ZGXq758gqCtGVLq+5G0yxVY94t94
         SD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlPLbsteYQ546XPJd0ZKu7bGdTiD6IsGwA9GxCJDXFA=;
        b=G0+IR482NJWdakIVfXLostlad51CyEFX2HL1wgBbPDFOHPXijeAJzboHCxxEzeDzh0
         +/hbulT5OTIreviELzsEgpbkzJHSVLfgXhv/p2nGJQq5W1qPipJAN2x3zDRplgZkOzSK
         OpEIhAvXMQXAnak5vnHko/IuCUx0KPyeClcpSMoGb410QrNL4aPcNbxeG1TKWxG2xiJA
         sOWLHS+Fq7Dtya5h4oO/Pqx3/Wgk9bJklQyAhRX7XXGExpIB7hAn+5nQUnxlc/irOn+L
         1G1O3ZfgcX8iAHlhZQ0xJ66MZtAjMP9hZ3udHmWW9XhWRXpAQ1MkeGXz2zUvdH9lSkir
         uJ6g==
X-Gm-Message-State: AOAM533gWRmWCHxKbuiYgpM1raDLFJnNPmXf7IqP811BJMpFHxxil35Y
        81X2cr9HdFAy+8PfpNd5Obxszg==
X-Google-Smtp-Source: ABdhPJxOMHcHOacHU+9TOgcsW0ME2IKvddaFruMUGe5IvNFFZiOcacqW39YgJK/Md9rueGXQzAi/jA==
X-Received: by 2002:a05:6602:228f:: with SMTP id d15mr7804723iod.141.1616020190565;
        Wed, 17 Mar 2021 15:29:50 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f3sm176405ilk.74.2021.03.17.15.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:29:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: ipa: support 32-bit targets
Date:   Wed, 17 Mar 2021 17:29:42 -0500
Message-Id: <20210317222946.118125-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently a configuration dependency that restricts IPA to
be supported only on 64-bit machines.  There are only a few things
that really require that, and those are fixed in this series.  The
last patch in the series removes the CONFIG_64BIT build dependency
for IPA.

					-Alex

Alex Elder (4):
  net: ipa: fix assumptions about DMA address size
  net: ipa: introduce dma_addr_high32()
  net: ipa: fix table alignment requirement
  net: ipa: relax 64-bit build requirement

 drivers/net/ipa/Kconfig     |  2 +-
 drivers/net/ipa/gsi.c       | 14 ++++++++++++--
 drivers/net/ipa/ipa_main.c  | 10 ++++++++--
 drivers/net/ipa/ipa_table.c | 34 ++++++++++++++++++++--------------
 4 files changed, 41 insertions(+), 19 deletions(-)

-- 
2.27.0

