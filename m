Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7021C0A2B
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 00:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD3WNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 18:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgD3WNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 18:13:30 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B3BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:30 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 23so7571036qkf.0
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttGbMYEidP9RHX/uRxBhRpBjy6W2hzcyfjV0O4d9WKE=;
        b=OYotSsTtHP+CBwwxAdzanXjajY7QgCa6QOqGYZPriul6ZVPJK5U5/E0VwCnhG7cQdH
         SdalMlBPs9omH4/Tor3sCeR1u2sR/KHFz/Holj3bcb4FXKawcwa/YjB+DAQeth022G52
         BuXNuqecz43dY+ArXWMoswU9u6rR0liAkTlsKwyzVA3TGJxRPxiO4XvcpfNCx6J//iVu
         ydG1il5bpb5dVme8BoROP1AULIJqOrj/e911s4L0RsyaRJDCG9YXoM7mKv2JaIW9INrd
         lk/H4sSjvK8nvpiVIwospoSac8TFUbNPNoLFqfRsolnxOJOFbBh01oh5Ow0QVZFXQGDd
         pzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttGbMYEidP9RHX/uRxBhRpBjy6W2hzcyfjV0O4d9WKE=;
        b=Diw7NoSsgg9gy11Ajk/CtzJhayzJmNtS6jc+sslYM3yZNkKw2w+T5B5QxEs4wnZTZb
         2C6zqZNuASS/vw74Gv9c8SVJgLEF3nO9Rqgai/hXv+Wf0ihavhv1YmvFbeAxcHfzQPiG
         vCBGAyPKd+d9SCsFzaFQfPTVF9f5fK5WYd2XDzwIQrKPVamZrNtx0QGwcS+quX0lnqgW
         7tro+XF9nNFLc+j/EhyuHn6vWrPnOwpo8Qj1KUupvxBgpXX2XE4jMUUuJjd5CcyPlRcI
         1beLvdQAcJ4VqoZbZfZjThOQZO/AW1PxRZ92RBwvqSZQmxJZw7+6706TioHSdzOV2sdb
         EZrw==
X-Gm-Message-State: AGi0PuZOozaHDVWWEnoVqIR34Nhx6vmsinH5RuwVMRHtkTA0P0IlfRXC
        vLVrogemf43qb6x8rrrP/BI3pFnuMVg=
X-Google-Smtp-Source: APiQypLS3j9JDzaf4aBXWYPqgZVhNCxPiqrapIFT2F2Ddh6UfXilZ4yDsHgp3H2ARYLBhTiKWS7ISg==
X-Received: by 2002:a05:620a:13b9:: with SMTP id m25mr741199qki.456.1588284809197;
        Thu, 30 Apr 2020 15:13:29 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w42sm957028qtj.63.2020.04.30.15.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:13:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: don't cache channel state
Date:   Thu, 30 Apr 2020 17:13:21 -0500
Message-Id: <20200430221323.5449-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes a field that holds a copy of a channel's state
at the time it was last fetched.  In principle the state can change
at any time, so it's better to just fetch it whenever needed.  The
first patch is just preparatory, simplifying the arguments to 
gsi_channel_state().

					-Alex

Alex Elder (2):
  net: ipa: pass channel pointer to gsi_channel_state()
  net: ipa: do not cache channel state

 drivers/net/ipa/gsi.c | 94 ++++++++++++++++++++++++++-----------------
 drivers/net/ipa/gsi.h |  3 +-
 2 files changed, 59 insertions(+), 38 deletions(-)

-- 
2.20.1

