Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9094E3119FF
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhBFD0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBFCbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:31:32 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE45C0611BD
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:07 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n201so8724025iod.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdNQsrR6L4Zb5IpKYZydONt7isMKUPDajZ0BlWteITU=;
        b=GJef85PVibNB32cjYhF6sjtPaoih2XjB+VLDpYmn0I0+42AAj0kuRQ7CSqlsAcMlyT
         vaODY3I56ik030rqwqW2HZDgEpC7shYpMVNhor41GRtpZWRS1oiHivgEfnu/hzuYbb8h
         Oq4voH7IXpE0YiGfsrXH+9smDa9U8Jr/LhR/2sKb0oUNbZxVqrHzJAFjytg8Cl36l9/O
         kA5MTxeyfxVjOZD6X0VZ/n2ffz9Jc9EbZAZxMp8ksWQiEO8H2VUnmsdQrVCz8/W3Y8DV
         DNYaHoW74RzmiHGnOsTfOlFWnuOUDQHImSnZst1WOcEIzzJfs8I3X7bq2dG0DGB7wWtV
         XREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdNQsrR6L4Zb5IpKYZydONt7isMKUPDajZ0BlWteITU=;
        b=OOEpM4qRnl3jSd2w2chYLoW7ScV8n2SXdVKV4YalwxZL8SXYLnKFGE3O1OWV2FgLB3
         MMQjiUGVwbzfe3zh1A/JQdJM9lPxlz2wtGeJAwiJPWQT7Ozlq2pwzjYmC3T82j+8+Llt
         8ylHU7EvQMAfhVtQjXq07zX7HKyKHg9++sJHBKoeEYjQhEmKiAxrY/xk52qdqvReRHc4
         nuHOT3411NUHIWiPrR/Ctx7ybrLCoBpCeSgV3i5meGNBP2L19MA1ZZCb7pEJSzbMTE9F
         29Mx/mbVv41RK4qoxrtjd+VDfEY3iZe5KahxmcRH0cssoGaODNbjCfjTEg1/5IbEt85R
         zD4Q==
X-Gm-Message-State: AOAM530rKj9JXirpaCvd39yd0Mrl0EYjGnZRxRIrXq5ov1rqLGP+wq3d
        1qIFmeR+hQ4BQi0TSv6uPJ46hA==
X-Google-Smtp-Source: ABdhPJxerHpEay6NlWEwO5TQ9neasKrO20VZimkAH87y5dIuzHoFViU5NymJo1bu29WrzWzxj/5fzA==
X-Received: by 2002:a5d:9552:: with SMTP id a18mr6136048ios.154.1612563066961;
        Fri, 05 Feb 2021 14:11:06 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: ipa: a mix of small improvements
Date:   Fri,  5 Feb 2021 16:10:53 -0600
Message-Id: <20210205221100.1738-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 of this series restructures a couple of the changed
functions (in patches 1 and 2) to avoid blocks of indented code
by returning early when possible, as suggested by Jakub.  The
description of the first patch was changed as a result, to better
reflect what the updated patch does.  It also fixes one spot I
identified when updating the code, where gsi_channel_stop() was
doing the wrong thing on error.

The original description for this series is below.

					-Alex

This series contains a sort of unrelated set of code cleanups.

The first two are things I wanted to do in a series that updated
some NAPI code recently.  I didn't want to change things in a way
that affected existing testing so I set these aside for later
(i.e., now).

The third makes a change to event ring handling that's similar to
what was done a while back for channels.  There's little benefit to
cacheing the current state of an event ring, so with this we'll just
fetch the state from hardware whenever we need it.

The fourth patch removes the definitions of two unused symbols.

The fifth replaces a count that is always 0 or 1 with a Boolean.

The sixth removes a build-time validation check that doesn't really
provide benefit.

And the last one fixes a problem (in two spots) that could cause a
build-time check to fail "bogusly".

					-Alex

Alex Elder (7):
  net: ipa: move mutex calls into __gsi_channel_stop()
  net: ipa: synchronize NAPI only for suspend
  net: ipa: do not cache event ring state
  net: ipa: remove two unused register definitions
  net: ipa: use a Boolean rather than count when replenishing
  net: ipa: get rid of status size constraint
  net: ipa: avoid field overflow

 drivers/net/ipa/gsi.c          | 69 ++++++++++++++++++++--------------
 drivers/net/ipa/gsi.h          |  1 -
 drivers/net/ipa/gsi_reg.h      | 10 -----
 drivers/net/ipa/ipa_endpoint.c | 38 +++++++++----------
 drivers/net/ipa/ipa_reg.h      | 22 +++++++----
 5 files changed, 73 insertions(+), 67 deletions(-)

-- 
2.20.1

