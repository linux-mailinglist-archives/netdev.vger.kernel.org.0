Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1632A30B381
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhBAX04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBAX0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 18:26:53 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5C3C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 15:26:13 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id y5so17351101ilg.4
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 15:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mK3TDg3+3vFIWxik5WfCnoYuIApFBk1bCtdKkSPB3OA=;
        b=ibaFMyl0Z1jRyn8PIjc0eT2xGC1SQw/PaMoATtMNx8/RhlizsA7W1YpAVHB+1UcCSq
         CwfIUthQpDFBX4z/reKqyf9o8lrRjRlBXihyj6GfjVXDT1ZpRRI2ZKOBOlxkfoyUvTrK
         A2vGhs8sCe2Y+MRmqCQo+5KttZoHg0HJI2zdfygMH2cANvxf8G+29XyQFTsh7Gt7ChtB
         qWw5KITCZcEbvN9a/62wF4/YDvfom/UIcjSSef0bjQLzLf/1Sm3OdwPW6GCFhogFGfau
         z9nAH7pnDkXAhtebo4+Rnu8FjVn6JGOI1qGaNJX+ltmwHYKcYk9crQNiJEhCphc6TeAb
         xLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mK3TDg3+3vFIWxik5WfCnoYuIApFBk1bCtdKkSPB3OA=;
        b=mD/2njvbVhEHzVLTgSWrJDi55sxiJH0HfI15owEzd7Zh1FAt9yNqiRAzm+05kR45x7
         hQyEGXop9ZyvKTyBTZ00hKpAeKj5pHmkAMaD/qOPMtSSYNQz7aQOP9qQfFw0SoRgOdAs
         uHPMctSMjfrNXmzjOoQPTGcwpYFKOrw1J2zak58vptS35TVAjjuM7K/Gnp6EoZyu1N5Z
         dJErMpltroz600dGViVNJfIbnKrG2HfwFbJdpsDdx5NbOoie58qGuGDp3O2ZDvPa8nJh
         OtTuj5pGjQfYjfECXm3PeQvfUd23Sbym09YOVeHMzYB073of0akEY2yw4ji9P2y1S4Tv
         BumA==
X-Gm-Message-State: AOAM531+AhQx3rpPIa8EoQmzg2dfp5rpvPyIxavQvSVk6S+z3pYYLtQG
        XnQp+OTaT4x9YVsFKZB223oIyQ==
X-Google-Smtp-Source: ABdhPJxeLBYfrlc3Wc5dWsiZR3n9vO5cuyXhziwVNdVZ+6bQ8hw/oCrrYfTl9Or1LDm53uPDAB4NzA==
X-Received: by 2002:a05:6e02:1d8a:: with SMTP id h10mr3440520ila.224.1612221973211;
        Mon, 01 Feb 2021 15:26:13 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v18sm10359588ila.29.2021.02.01.15.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:26:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/4] net: ipa: a few bug fixes
Date:   Mon,  1 Feb 2021 17:26:05 -0600
Message-Id: <20210201232609.3524451-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes four minor bugs.  The first two are things that
sparse points out.  All four are very simple and each patch should
explain itself pretty well.

					-Alex

Alex Elder (4):
  net: ipa: add a missing __iomem attribute
  net: ipa: be explicit about endianness
  net: ipa: use the right accessor in ipa_endpoint_status_skip()
  net: ipa: fix two format specifier errors

 drivers/net/ipa/gsi.c          | 2 +-
 drivers/net/ipa/ipa_endpoint.c | 6 +++---
 drivers/net/ipa/ipa_mem.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.27.0

