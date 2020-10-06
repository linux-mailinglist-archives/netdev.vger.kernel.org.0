Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF02853E1
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgJFVbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbgJFVa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:30:58 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6ACC0613D2
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:30:56 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q1so267838ilt.6
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 14:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BMsqqfJIL4fFlYLnqY+a4r1RHb+1tAuL+qe7bBh9m1M=;
        b=GHikp9gtOR5vwaEIdrJYP8nqy1dsU9d/Cfnb7FBFdOkO8ErSafqVoyW3eL+RLzLRVF
         ZjL+PmoFMPDgYZ8sbfv4Yln/o/cZIdOfaeFe460PRYOqE3BXAGUY5G2hFWcgXsG1Ixjw
         W43exqEsQUqWI92cKx3sD0ENDtEJQIuFqiVnmY5rAj1rDvY5DI4ijMz1fiK5aQ6C9i+a
         BFufl0KfiDrV2ehw5mTNyk9K4sGXI7j3mJqPtEWeYZZs2ewgfFmjUAPvRygmrYHrD4jr
         GZziTAGfAuTmE1dqH1gS+ISfpihRQXNeEYtq67xMuRggliDa3axZ89bSkqzAx6McOV86
         4ZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BMsqqfJIL4fFlYLnqY+a4r1RHb+1tAuL+qe7bBh9m1M=;
        b=lacOsl+CfqTZKfN2DzltHN1cDRTq+B1S76jTcY8XWAG8yigIIaAxUhb0ZseX16iLrX
         LK9bSalui+J10wr9q6JRdQazQosu3L2pVB6qKTEvQ7fKjoGPoKBjSPHN9bOMOEgLK1gU
         F2SyfxhkCoTVBa7QFCn48pEihgGe4EWOyw2soo8pAZrZE51Kw5zbCzZ2m8pLPeKGDDPR
         awd+8GVn7PLYqZvof4nFZkbkKlodI3iVIRSKcvnWzaxijh5STu+iff/Su9jUBbhgy5ba
         DRMh45Xds4EOze9zmhLZs9e+ZXOTLpxurvhUrpSvweWUEOGuX8PU52FVmeyt5hG6mYsI
         ASsA==
X-Gm-Message-State: AOAM532U07+6nkhlcFJky1BDxOBzwvXclos0kyF/N+hlFto1GxxvjMu+
        pYycQAX0fGY+5nKvkXSD+JMJKQ==
X-Google-Smtp-Source: ABdhPJzNCel9QtHRenLw+gBXDP0q6l89iGgOsoQvr06aIYEdp0XfwA60DryeLCijTiPRRPkz4djr5Q==
X-Received: by 2002:a92:2602:: with SMTP id n2mr194390ile.82.1602019855646;
        Tue, 06 Oct 2020 14:30:55 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z20sm2043215ior.2.2020.10.06.14.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 14:30:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: ipa: non-setup bug fixes
Date:   Tue,  6 Oct 2020 16:30:45 -0500
Message-Id: <20201006213047.31308-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes two bugs that occur if the IPA driver has not
completed its setup phase of initialization when an event occurs.

One event is the crash of the modem.  If the modem crashes,
ipa_modem_crashed() is called, and it performs various activities
intended to put the IPA hardware into a good state before the modem
reboots.  But if the IPA setup has not completed, resources used
for this cleanup will not be properly initialized.  So we must
skip doing this activity if we have not completed setup.

Similarly, if a system suspend is initiated but IPA setup has not
completed, the processing done in ipa_endpoint_suspend() should be
avoided.  And a subsequent system resume should also avoid resuming
endpoints that have not been initialized by IPA setup.

					-Alex

Alex Elder (2):
  net: ipa: only clear hardware state if setup has completed
  net: ipa: skip suspend/resume activities if not set up

 drivers/net/ipa/ipa_endpoint.c | 6 ++++++
 drivers/net/ipa/ipa_modem.c    | 3 +++
 2 files changed, 9 insertions(+)

-- 
2.20.1

