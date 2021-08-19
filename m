Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D583F22EC
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhHSWUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbhHSWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:20:07 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A95C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:30 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id u7so7506476ilk.7
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vPUru/TYDi5YjR/bbAhvMjF9OzpGGdZFmOl2rbUnBB4=;
        b=S7vi+fiVH/33qj0cnmQ8BsS//9/RbmQkZAE9NIfUZaQamE0mxS8rlq4pBey3Zg0dXk
         pujrPK9G3j11L02JpYV8TnSbqs3bBljFpwrM7yL96+2cngVEMIA1qYZOJM05SuaDV1Rj
         2ExUNLcA665tlRfnIcJ0NEzD4xPE4RXUMBV//wp3XSBpooHTvvMXtIN9Tisdtkamnfye
         9Q2okibI5n1e1Dgb4ZgBG5q5qsDFPOApxogYjMgzPL+Il4vfTT2+HFUyRdGkiBV7OatM
         0EpWHps/ujczw+cztWpk9fccvhqU7a6RBh1s8k1YhpshhQT8b9i6M5po6B64JoqmZPTf
         ZZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vPUru/TYDi5YjR/bbAhvMjF9OzpGGdZFmOl2rbUnBB4=;
        b=Hvf221PJSb7aSAGNohM/S3JuUHnckb9ajaDUKgry+whYY5VpKYxIVwAAX29O3ch8V4
         z9kY4Vz/F84IjZVU482zBvHvPJq+dE7GpPXcTGNR45zs289U5eK8dUT52q1GgztdltI6
         Bt+v9ACg2b+wDl9o+UW7kg1OlGdIEFRfe6Bc4AuG5m0EfiXAMDxTSMRn309S5dtehmKY
         TmtSDt+n4IiH1JFpLWW2JCT9a7kdkg55Vkq2f7LpVq66klA4RiBMkbhSiIJlDjVG6EK7
         JDfqrJa0ayqUCM3pVr85N45g8L08QOYea4LyhNzOKAfki4NXzNltTT4z8lXCssWY4kdm
         Ndjg==
X-Gm-Message-State: AOAM532qHP4QLULTcR3sY5smb1Fqq9o3WEyaZByZXwDisCnBlzpo6MWx
        qZESrrcDv8+lyvZ1OlFzdFbK7ALh5kIB3cmu
X-Google-Smtp-Source: ABdhPJxDB9EdhwwGVYmZKbE4M6XSdELpdA4qZ1QD+Y/0MjpEsXVuIjVbxFsjKMN29zkfqGLPLEet3Q==
X-Received: by 2002:a92:c601:: with SMTP id p1mr11250320ilm.284.1629411569899;
        Thu, 19 Aug 2021 15:19:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o15sm2245188ilo.73.2021.08.19.15.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:19:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: kill off ipa_clock_get()
Date:   Thu, 19 Aug 2021 17:19:22 -0500
Message-Id: <20210819221927.3286267-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series replaces the remaining uses of ipa_clock_get() with
calls to pm_runtime_get_sync() instead.  It replaces all calls to
ipa_clock_put() with calls to pm_runtime_put().

This completes the preparation for enabling automated suspend under
the control of the power management core code.  The next patch (in
an upcoming series) enables that.  Then the "ipa_clock" files and
symbols will switch to using an "ipa_power" naming convention instead.

Additional info

It is possible for pm_runtime_get_sync() to return an error.  There
are really three cases, identified by return value:
  - 1, meaning power was already active
  - 0, meaning power was not previously active, but is now
  - EACCES, meaning runtime PM is disabled
One additional case is EINVAL, meaning a previous suspend or resume
(or idle) call returned an error.  But we have always assumed this
won't happen (we previously didn't even check for an error).

But because we use pm_runtime_force_suspend() to implement system
suspend, there's a chance we'd get an EACCES error (the first thing
that function does is disable runtime suspend).  Individual patches
explain what happens in that case, but generally we just accept that
it could be an unlikely problem (occurring only at startup time).

Similarly, pm_runtime_put() could return an error.  There too, we
ignore EINVAL, assuming the IPA suspend and resume operations won't
produce an error.  EBUSY and EPERM are not applicable, EAGAIN is not
expected (and harmless).  We should never get EACCES (runtime
suspend disabled), because pm_runtime_put() calls match prior
pm_runtime_get_sync() calls, and a system suspend will not be
started while a runtime suspend or resume is underway.  In summary,
the value returned from pm_runtime_put() is not meaningful, so we
explicitly ignore it.

					-Alex

Alex Elder (5):
  net: ipa: don't use ipa_clock_get() in "ipa_main.c"
  net: ipa: don't use ipa_clock_get() in "ipa_smp2p.c"
  net: ipa: don't use ipa_clock_get() in "ipa_uc.c"
  net: ipa: don't use ipa_clock_get() in "ipa_modem.c"
  net: ipa: kill ipa_clock_get()

 drivers/net/ipa/ipa_clock.c     | 17 --------------
 drivers/net/ipa/ipa_clock.h     | 24 --------------------
 drivers/net/ipa/ipa_interrupt.c | 14 ++++++------
 drivers/net/ipa/ipa_main.c      | 21 ++++++++---------
 drivers/net/ipa/ipa_modem.c     | 40 +++++++++++++++++++--------------
 drivers/net/ipa/ipa_smp2p.c     | 19 +++++++++-------
 drivers/net/ipa/ipa_uc.c        | 22 ++++++++++--------
 7 files changed, 65 insertions(+), 92 deletions(-)

-- 
2.27.0

