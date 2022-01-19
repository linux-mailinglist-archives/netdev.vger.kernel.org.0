Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF16493185
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350317AbiASAAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238129AbiASAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:00:20 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94595C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k4-20020a252404000000b00613504b364fso1448314ybk.3
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yQj1ycbixjn9+SpeK6sJaBYZgUxlssD6EgL93wWSDDg=;
        b=sdKiIqbsSG9HVO67K4xF/FAYxj2rzaBP0OowNObBg14BYpgSVt3tJUJTT7BiCmYija
         UugdX1GHyxh6D1Pg/JAEjnC2j3xqQchFsdD26W7PGHVt7LziskH2Y917c/JOkJn6QD1i
         yQRMMIS0qVqGuOPg81+A74vK72jE3idM12g9ADb8w8wxnH3aSe+UHqua48jKWGHbQNG9
         noH+Vh2YOhxwsUezMf155r6yDgzp6anncA8LhRsmNR5AhE/mVUo6rA8466XcYvGzPe3w
         6waG/KdH+w4qnoQtfcRpKW9UL/a0KEHRE/i9TaPnobIXsbMeuaLAbiAv74h1OIztTPpP
         66ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yQj1ycbixjn9+SpeK6sJaBYZgUxlssD6EgL93wWSDDg=;
        b=gm9IyaE/KI7U6RtcYbtBa40tfP+kfY5zo+MjRczyDWGAIc9bP1DSuonWZlBRDOIs/U
         E1JGzX+JBsxf4AQig0HFEMXpzz0xiEWQBTLOJ/J+iiNleWKdngjPSB+y4cBhpEkjUnZp
         49JK2ry+4dOcqLy8HhFCFGuTznJtxgT/pLXbaaLm533t9ssYBq8HY+UelLMyHm/LSqJN
         Iw0XtDLCMT7YQe5KzhKWeVcZQXmJ4yPnTz21xA6EIy875qP0HyDCWxEgeq6L4Gy6GqnW
         BZXtfsrCXLi6dOS38A1ynvnMwEFwmBmHOyOLmQmmB3bf/a5HCOmmKbuEPjZaedZgNV35
         oQbA==
X-Gm-Message-State: AOAM532ybH2QdS3tEGHccYA34ViWfclh0YCuM6By1rakD30yi18OQW/w
        K3IJGsFS4wVAxPk5hJRdG61zpJLO586vvQ==
X-Google-Smtp-Source: ABdhPJyQhAxTKVmxG0dTmSdwSOIWH/ego2xiqaFa2/vRTepxiN+ondMJJpJhPj/RJrh/viJdSsSwqoftOlyRhg==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:543f:65f4:6992:2c5a])
 (user=evitayan job=sendgmr) by 2002:a25:1388:: with SMTP id
 130mr36942078ybt.321.1642550419506; Tue, 18 Jan 2022 16:00:19 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:00:12 -0800
Message-Id: <20220119000014.1745223-1-evitayan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 0/2] Fix issues in xfrm_migrate
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@google.com, benedictwong@google.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include two patches to fix two issues in xfrm_migrate.

PATCH 1/2 enables distinguishing SAs and SPs based on if_id during the
xfrm_migrate flow. It fixes the problem that when there are multiple
existing SPs with the same direction, the same xfrm_selector and
different endpoint addresses, xfrm_migrate might fail.

PATCH 2/2 enables xfrm_migrate to handle address family change by
breaking the original xfrm_state_clone method into two steps so as to
update the props.family before running xfrm_init_state.

V1 -> V2:
- Move xfrm_init_state() out of xfrm_state_clone()
and called it after updating the address family

Yan Yan (2):
  xfrm: Check if_id in xfrm_migrate
  xfrm: Fix xfrm migrate issues when address family changes

 include/net/xfrm.h     |  5 +++--
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  | 15 +++++++++++----
 net/xfrm/xfrm_user.c   |  6 +++++-
 5 files changed, 28 insertions(+), 14 deletions(-)


base-commit: fe8152b38d3a994c4c6fdbc0cd6551d569a5715a
-- 
2.34.1.703.g22d0c6ccf7-goog

