Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03F43E4AB5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhHIRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhHIRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:22:57 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D426C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 10:22:37 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id z25-20020a0ca9590000b029033ba243ffa1so13193745qva.0
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 10:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Xcvol7SaEf5nEJ4TIhNgU4+/eKyMOxhUuZoxthy3jEs=;
        b=fYl/S4P1NIh2MYIlfqgl72NRDM0lxRXloBDtiD8Qa+o8CfCffKEeMu8z+6YjTeuFN8
         8D/m2Nq4EXJEZTGw6m+Q4v3riPs2kKn1W49g3pQZ1ySREQ/ej7BwSfwZ/esSbTvAFRjd
         BjMdI7Na4vj4+/eOfGLZ6qnA7o6//dvDRj8Z+4AGm/WpYqXKOh1yS4M1hCrjh39j4oOW
         rgDIMZIhNlh3aW5gdMsVnfXJLp8ElGk7DPwRhbcTGyk+4W1XvvFuMFu7npurnmMQzeUy
         yecTyiRF8c1Ct8aMNXdGSiqCn3h+p6F2aQEEct7TbMLsVU40xyrBKLJnFwIGe4+NFcyS
         vZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Xcvol7SaEf5nEJ4TIhNgU4+/eKyMOxhUuZoxthy3jEs=;
        b=j38pgd2JegUmhZ0EEJ6buZo0ectbuP+dIpuePK861f5a3GUHkCrdwVDsy7lEROtpWV
         zo5lq3R72jeN0O7LLgGpZDCeQmk0tZXNPmBRHS7FbR9JgFRX7yLJakP8ZYhqFFivNmLj
         g7RY/Wavtr5riEY5gzaM6GLFu9N9BUytzpEs41T4dFZyQ9jQS5JpDBP9R94fjdAN7c8A
         P5lXXKxwBOB2eexXWxHOVTtwWLOHFKK5TVscZOvGh67psBy2UabqBiugQi/TitKs06KE
         LAWydEJXu39Ao1ZGZbuw4xp1Rq0kRPkwMpltNXT9/NlTEvBxouJEMq3uuhB3FDK/KSA7
         h3Eg==
X-Gm-Message-State: AOAM5326hy8uqgmkm1WXG4yeFdFoZ7QI4cjVl0oTf95F9MuZdxwk16lX
        Xg2iCw49yA+AeBfwyxF3LPXw7X9O+VhyrUQTgGieVw==
X-Google-Smtp-Source: ABdhPJx4Y6ZEwN5YeJJLko9DVHdYfNRD0QB2UZW2bQjvIauG2uZeJC3L2Tg6y4dLnB919OKLgKb8wKCH7o60FyM+hfqiEQ==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:ad4:498a:: with SMTP id
 t10mr6749325qvx.8.1628529756242; Mon, 09 Aug 2021 10:22:36 -0700 (PDT)
Date:   Mon,  9 Aug 2021 17:22:01 +0000
Message-Id: <20210809172207.3890697-1-richardsonnick@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 0/3] Add IMIX mode
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Di Zhu <zhudi21@huawei.com>, Ye Bin <yebin10@huawei.com>,
        Leesoo Ahn <dev@ooseel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

Adds internet mix (IMIX) mode to pktgen. Internet mix is
included in many user-space network perf testing tools. It allows
for the user to specify a distribution of discrete packet sizes to be
generated. This type of test is common among vendors when perf testing 
their devices.
[RFC link: https://datatracker.ietf.org/doc/html/rfc2544#section-9.1]

This allows users to get a
more complete picture of how their device will perform in the
real-world.

This feature adds a command that allows users to specify an imix
distribution in the following format:
  imix_weights size_1,weight_1 size_2,weight_2 ... size_n,weight_n

The distribution of packets with size_i will be 
(weight_i / total_weights) where
total_weights = weight_1 + weight_2 + ... + weight_n

For example:
  imix_weights 40,7 576,4 1500,1

The pkt_size "40" will account for 7 / (7 + 4 + 1) = ~58% of the total
packets sent.

This patch was tested with the following:
1. imix_weights = 40,7 576,4 1500,1
2. imix_weights = 0,7 576,4 1500,1
  - Packet size of 0 is resized to the minimum, 42
3. imix_weights = 40,7 576,4 1500,1 count = 0
  - Zero count.
  - Runs until user stops pktgen.
Invalid Configurations
1. clone_skb = 200 imix_weights = 40,7 576,4 1500,1
    - Returns error code -524 (-ENOTSUPP) when setting imix_weights
2. len(imix_weights) > MAX_IMIX_ENTRIES
    - Returns -7 (-E2BIG)

This patch is split into three parts, each provide different aspects of
required functionality:
  1. Parse internet mix input.
  2. Add IMIX Distribution representation.
  3. Process and output IMIX results.

Nick Richardson (3):
  pktgen: Parse internet mix (imix) input
  pktgen: Add imix distribution bins
  pktgen: Add output for imix results

 net/core/pktgen.c | 163 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 1 deletion(-)

-- 
2.32.0.605.g8dce9f2422-goog

