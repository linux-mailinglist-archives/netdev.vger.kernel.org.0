Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C801C4A54
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgEDXaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgEDXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:30:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4E0C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:30:15 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id t3so590629qkg.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZBc+PcefEfR4/vKXm3LERVOyhVmQ3WDeB0fuysL9Yg8=;
        b=tDXanxAudaCjvCTkpg/BK6/fix93BEE/+gnqN29tge5PNAJgwX3rrfcZX2o1TDtEpL
         5q3C8VjsFMSkOZt6qxTlZg0Z8gS6jdqvTrYFceAmqyaEP4zGacyqhMkU6wAjHl+wsb0Q
         07MloAwFlkW0zarJyPx8bxIqCC/E5rniRaSCoKHv00FjgKF92T09xmojwVUSXlo/WGJI
         PfvA7A3pBeZkXN28BvOBNlSPhAZYHOMmitau8Tm2GhHybMlQihBU8/V2Yf2Ame7RZz6c
         tGCxKLZhYFtkLIsxHIwyRn6BxQr/+SteGgo/GtXQ8eGibHclStiHQAUpCEXE4NBLvC92
         8hzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZBc+PcefEfR4/vKXm3LERVOyhVmQ3WDeB0fuysL9Yg8=;
        b=GvFmXwKBZFSicKoF/C5cV8KCtwioD7D8u7SZRRdHbqqo8qI569IvmgVhqabg0vXnlu
         jFXgNZib2U4uvIu8K1risupiCL4lsahigX0BgxeMmhu1WpPTdB2bWy+owR2OpDGEN8rP
         mk5cGlsEkG+/g/6S47YJZUl0h366q1x0wPofDV8F+t2SdPyEUQg5LuAMQVGS7zxkXLfL
         fg2BWavkYGpwHlBb4Q0NM/3Thjs1cNHn85tUFXMzo1wV1lZ+a5PC9jEiWgOxubI2YU/l
         pyj18gUZes5TmPdq/5323GTGEav6GowoPh09tJPWNNJXluzGPpdY04RY9h4WUfLHm2N4
         M+mQ==
X-Gm-Message-State: AGi0PuYrNhQCNDhsXUMMUGv8JielLGCwl2JrOKELy6nVTNwBY/05ydgd
        pVCqrP3/6KvQIvciHFwZEVrkPQ==
X-Google-Smtp-Source: APiQypKkOFL6XLk3UlAyGUKU5tlTZOJIL57K9M6UeUc/14P66LocB7Chg+CxagnIfeA1KcajoS/HkA==
X-Received: by 2002:a05:620a:490:: with SMTP id 16mr826721qkr.203.1588635014981;
        Mon, 04 May 2020 16:30:14 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c41sm253033qta.96.2020.05.04.16.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:30:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: limit special reset handling
Date:   Mon,  4 May 2020 18:30:01 -0500
Message-Id: <20200504233003.16670-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some special handling done during channel reset should only be done
for IPA hardare version 3.5.1.  This series generalizes the meaning
of a flag passed to indicate special behavior, then has the special
handling be used only when appropriate.

					-Alex

Alex Elder (2):
  net: ipa: rename db_enable flag
  net: ipa: only reset channel twice for IPA v3.5.1

 drivers/net/ipa/gsi.c          | 20 ++++++++++----------
 drivers/net/ipa/gsi.h          | 12 ++++++------
 drivers/net/ipa/ipa_endpoint.c | 12 ++++++------
 drivers/net/ipa/ipa_main.c     |  2 +-
 4 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.20.1

