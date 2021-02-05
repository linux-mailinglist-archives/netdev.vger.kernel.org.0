Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E545C3114B5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhBEWMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBEOmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:42:54 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFD6C06178A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:20:18 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id s11so1552515qtq.10
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdNQsrR6L4Zb5IpKYZydONt7isMKUPDajZ0BlWteITU=;
        b=oYNd5PJX6gg7KH71AKjbiEAz9Kz7MzbWaW1yw6K2Rjvnqxlxp4thLhFGUK17yziMxe
         HIbaYfkz/JngwpV7mwg53Uk8LXJCMuTr4OI5pULgOgKSMQYphT3du6BV8mCdO0VPGTPU
         5gvbGjDt5qP2dFvHmgutAmw2bh+jZAdr2usHCEKhOCGAZd+FLUILWyBvIrwcZpR2TE5t
         Ume2RZdK/yvZq2EnDHfURZUFH2h6VCXrLMlMFUSf/ZAwQhCm/NTeeqM8I/NV3N8EA0Ge
         hhN8QquqtoNFVGQUOs93vKRQpbpocI7qZm2fbAzB64k4LmJM+kHdS3/7Q2GK3EITZgeZ
         J8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdNQsrR6L4Zb5IpKYZydONt7isMKUPDajZ0BlWteITU=;
        b=tksgrPqdWfmo2BYPJHeNHgyAPSNvRfIKW4yKcIquLkK3YLrfZUUa+LhrKzvH7CkKDT
         nZcNUGyVcjJEcD0LX5mPWRyfNxjDy+hBLKpHX2jzic5/RQb6DGxoEUoQIA+O6RCuCaZ9
         Ed1fvTcqnq03WU3OGkqDm+K9fXrur9P4kfSc7s5ZhWmCjgvLogV+NJKWPJGnztc1jOn8
         2ks/yqeXp4CZCCUogDwHCSkC3dTe8k20paTRPyDjI5yMFbM/J5NPfqkYdENL6Ov3a50l
         VCE0Jc1HxIv9kadl0esJxLfXib5m89AmY1+aXbEPwdkPI7mhdBmHe8ZWul/UFzcPxDCX
         nnRw==
X-Gm-Message-State: AOAM531oBsRZC5M8zB1PYVsSGH075+z3fEJD9B2COSHRaaNS/OFdRr0+
        5R6Zw4ldOrwhIJvxSn7iT1F2KrRLIsLsfQ==
X-Google-Smtp-Source: ABdhPJwVvxuXEKeZt9qocecQAocBMYJpO8vCxFZkFDkDOLJH45JukiF1jbz9ySQMRStwBF5nCiosvg==
X-Received: by 2002:a05:6638:3f7:: with SMTP id s23mr5291048jaq.80.1612535913255;
        Fri, 05 Feb 2021 06:38:33 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: ipa: a mix of small improvements
Date:   Fri,  5 Feb 2021 08:38:22 -0600
Message-Id: <20210205143829.16271-1-elder@linaro.org>
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

