Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F8820E412
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgF2VUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgF2VUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:20:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99509C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x9so15840453ila.3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9X5dybqaVmMEEJzafl+2Yy/3Ah4viLAbYdipucnxNE=;
        b=xU4SqTJsR5K2nU/Hq/r1oQCau9qdyOcri4idnrHedfFv/IaFTLgLpC9hCKGPZTGehT
         br6vMc31FtZp/PWGgNZLKpykZJCZ78fhrVNsEqVXEITGVmtgDoCoDDgGSbkRLHX9gEH/
         ufD4CjKBvIIOBJfTRxcjiNCKIeDWZlb0ssAuRGNI4BS0onFJIMHoBgBoDmengw5PtUn9
         5fA/QJpqtaTnyvXXKpuxnfRLArEU/HQal5zcuoP42d9t7dDQU/7XVelaBvrssonbGyso
         ak81S933mYQ84GvIAMsEySdnJaUquZdHLm+qI4smCyxe/Qu5N/tTgy+QHnl3MVPEA1Yd
         FgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9X5dybqaVmMEEJzafl+2Yy/3Ah4viLAbYdipucnxNE=;
        b=EHYWXpMFDEzN2dSsAMMJ+OKC1JJZFa/6gaLvpxgDSTnfFMv52MuYdsLSHDcFVScYPh
         7cuyUsN3JlbYGE0CjXar7KxcnChPmvBEpW4liSd4g18ZsDizS4C8KGHdUo4u7r8fc9Rx
         HNogP5EwYFshhPvS7R33Cr9uedgu4RMDSrR9y21yG09so27lHColeKuWshAX3V+Aaeyq
         grKYbiPvO0cy//rfOmjD64X2hp2HR00dKLWqKuf06RhnkdDxO7y2PWKfPHMoymXz+oAv
         PcyI6yzj3uZrOAZIsqmSW/etiICwnIR2UKlrR9xwj6QYkNTfs/cm7TSzBPgEKJ7Wdk/t
         Esog==
X-Gm-Message-State: AOAM532OOb8lk5vXNY6/05gNYFzc8DHvaJ8ppZz01XZXfZVMnWCbuT4C
        eW55fIr9xICqKjQZvTnIZa8+pw==
X-Google-Smtp-Source: ABdhPJzuizx7XBfffMEnD7aMQLwY3iu4C0VXUbe+vkcmBBPe5UAzmK1GVE4kasiCFR9JWaBCL6rUfg==
X-Received: by 2002:a92:cd04:: with SMTP id z4mr18150914iln.165.1593465641962;
        Mon, 29 Jun 2020 14:20:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm564588ilj.15.2020.06.29.14.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:20:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] net: ipa: three bug fixes
Date:   Mon, 29 Jun 2020 16:20:35 -0500
Message-Id: <20200629212038.1153054-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains three bug fixes for the Qualcomm IPA driver.
In practice these bugs are unlikke.y to be harmful, but they do
represent incorrect code.

					-Alex

Alex Elder (3):
  net: ipa: always check for stopped channel
  net: ipa: no checksum offload for SDM845 LAN RX
  net: ipa: introduce ipa_cmd_tag_process()

 drivers/net/ipa/gsi.c             | 16 +++++++---------
 drivers/net/ipa/ipa_cmd.c         | 15 +++++++++++++++
 drivers/net/ipa/ipa_cmd.h         |  8 ++++++++
 drivers/net/ipa/ipa_data-sdm845.c |  1 -
 drivers/net/ipa/ipa_endpoint.c    |  2 ++
 5 files changed, 32 insertions(+), 10 deletions(-)

-- 
2.25.1

