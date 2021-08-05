Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563FD3E0F5B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhHEHhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhHEHhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:37:00 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6D0C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 00:36:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r13-20020a17090a4dcdb0290176dc35536aso4482024pjl.8
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 00:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ovqiLti2qnRHUTcq1QAr4P74jMJoz9hlJhJZRZUVSY0=;
        b=iGOVzpHLlMq14HwujjbzD9uaW9ZRWuZPw6f0d8a8TdYoenA57xNvtwcuQ6eJI2L2QL
         ItGub5v89GDzdaqHgu8zvOsBe22RFZNC+SYnIfh2iWQtHE2JS1fkowaq7/8mt+WPALtW
         PtGmctgSR5lWGGyIvERW9BvBfbQYOrW3JmCrLH8uPDRastVVaQBW4D1Y21NzuR+scRYB
         gte4mohHaCaQ/FINXIbaeI3UzSDuuol85Ph9yPjQnWVXHtJy90bqO2JAak7zWY1go01j
         kAUSRI7BGUueTSk5Z58iCrUAkYNabu4p8ccoPtS4XIt4GKClYf3BKNFYuQ6cACugovhh
         lubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ovqiLti2qnRHUTcq1QAr4P74jMJoz9hlJhJZRZUVSY0=;
        b=pob8PsPIYgQ+GTujeok6a7dpG6FOb1C7W6tnrs3ubx0FU03uEUGhbYFKc8rwPtWqOO
         vA9ssvlYcYHEj0FICIKTT7BpkuGhsz7ZefYTkWVlP0QJIFcbUlMnNJHtIevFunNYNsNh
         v08XO5mZ+XUuhxiRXK9+DAvCxNN5Nc8mTcpyh9b0Sjs93y4ou7DtyUCibYl5fjKtNO5Y
         j9bIoVTZoXBmkuu3oYFNFq2LipYGat+MvzzXJtDWO4lxQXilsLK+HQlb6NELblf7Xrdw
         jdJBHzUn8W0VnIhsczT8RKXb9GHqeDO6gp1pl1GSoXUoqB39dF+LrlO7uVHFNJluzOyN
         s31g==
X-Gm-Message-State: AOAM530Xm+jXMBubNgihUx+OREJfzUeBji8MO6/T469jERfGb6CW5yxI
        Bu3P1zCo3g6S3wev12ynPrVHfAkJOuGeewwYOnPiAHxetDhLHQd4Voj5UmpHwtZI5GBhCFd1xoI
        NvH3dMRf4vHJg5nj7G0PTtW76DweNDsODxvVfWVSit6NyPCKtakssW2NMeE8hkh6fpsfGXw==
X-Google-Smtp-Source: ABdhPJy7MtQLdSi3ZpWR6NgP32x3m83pWidmseTc5xPy0Uj9EyDG04YGK602rWJ1MzkjQJ8T6WO66xWHilL85zo=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a05:6a00:1141:b029:396:d224:160a with
 SMTP id b1-20020a056a001141b0290396d224160amr3564583pfm.34.1628149005962;
 Thu, 05 Aug 2021 00:36:45 -0700 (PDT)
Date:   Thu,  5 Aug 2021 07:36:39 +0000
Message-Id: <20210805073641.3533280-1-lixiaoyan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH net-next 0/2] GRO and Toeplitz hash selftests
From:   Coco Li <lixiaoyan@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains two selftests in net, as well as respective
scripts to run the tests on a single machine in loopback mode.
GRO: tests the Linux kernel GRO behavior
Toeplitz: tests the toeplitz has implementation

Coco Li (2):
  selftests/net: GRO coalesce test
  selftests/net: toeplitz test

 tools/testing/selftests/net/Makefile          |    2 +
 tools/testing/selftests/net/gro.c             | 1095 +++++++++++++++++
 tools/testing/selftests/net/gro.sh            |  128 ++
 tools/testing/selftests/net/setup_loopback.sh |   82 ++
 tools/testing/selftests/net/toeplitz.c        |  585 +++++++++
 tools/testing/selftests/net/toeplitz.sh       |  199 +++
 .../testing/selftests/net/toeplitz_client.sh  |   28 +
 7 files changed, 2119 insertions(+)
 create mode 100644 tools/testing/selftests/net/gro.c
 create mode 100755 tools/testing/selftests/net/gro.sh
 create mode 100755 tools/testing/selftests/net/setup_loopback.sh
 create mode 100644 tools/testing/selftests/net/toeplitz.c
 create mode 100755 tools/testing/selftests/net/toeplitz.sh
 create mode 100755 tools/testing/selftests/net/toeplitz_client.sh

-- 
2.32.0.554.ge1b32706d8-goog

