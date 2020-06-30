Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DD20F4EB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbgF3Mou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbgF3Mos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:44:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1697C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so20816887iof.6
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b0Qug6jhcczxjVenUp7X4KAwgvvTxVc+J2oudLK16OE=;
        b=GmuZE7TVcNTtE02ICiPc8MOgbiCVEaUlJaGhANqsATTiNLE3ez86zpcik4vMXOV5il
         KEAq36panVyu7+0GtxhXIaZT+T9BhXketVaTwSmTJRRtSrxKQv/WCUmyrhZ3CSYS29N7
         +qNz6G3XLs0dGwSaXTczUy/33cjgrlKmhEi9c7EipHXlmvRhWmuyUPTkcwDD1/6OGu1i
         Kc3GNFSMd30GYSc1MDNz76L/ufjAGY90K8wh5aUT0hOvJbieJwQLwXiAGdOJtkcm+qGH
         NJqH5AgbvgS6y0CYPJAAT5KRqugLCb+9bU3/Ivz12hW7lI+wnli9/xGAtD4HJYgoV5HZ
         2Svg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b0Qug6jhcczxjVenUp7X4KAwgvvTxVc+J2oudLK16OE=;
        b=YGiumsaBbJke+bHbw+zsD03/BtFrfP9K0SPNkYK+iAtwsSFY99wcE9tKiRU+L2Yk45
         bT1wr54tHo3oMIPONoLwEHsy+XSSflArgJ2aaVvwil/v8OdiP67egPjwGugUvK24kSxy
         f5fy3BTOZ9IJR6NQ2o5VgvR12YIf6DkHmv2xf9Yoz9uMIghOitAPkrKA4ud0uBIhJLVR
         +PiKu6df/D1EMyak/u8kHILZOeltRMG2Iuvqtb2ZLsf+O7IXtjk8PMt7K6Rio4o8atcM
         FL17BgXY703ZZSL20YwbAmRj1OSYKmUpuwlqAwK/qwwbOhmVEbLpmGDv92/cssbQ6xs8
         DMuw==
X-Gm-Message-State: AOAM531Vq3LpKcyK8hmdV6VBvDPAlY0sMr4JiHBDOBU3iE2cgGTtERl9
        lhVP5wW4Rp8c1IClXtOhzmSHXA==
X-Google-Smtp-Source: ABdhPJzbMB6YN2qrnMFfnuWVN3o9Qbc4Z5zSlE8lD2VmkFISTbPUk/aZIGANuOERNVrSUn02WcVhPQ==
X-Received: by 2002:a05:6638:236:: with SMTP id f22mr22745582jaq.18.1593521087853;
        Tue, 30 Jun 2020 05:44:47 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t83sm1697536ilb.47.2020.06.30.05.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:44:47 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/3] net: ipa: three bug fixes
Date:   Tue, 30 Jun 2020 07:44:41 -0500
Message-Id: <20200630124444.1240107-1-elder@linaro.org>
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

Version 2 adds "Fixes" tags to two of the patches and fixes a typo
in one (found by checkpatch.pl).

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

