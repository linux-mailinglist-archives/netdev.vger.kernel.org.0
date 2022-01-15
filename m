Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7F648F6C2
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiAOM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:27:06 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60812
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230445AbiAOM1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:27:02 -0500
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9E5893F17B
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642249615;
        bh=UFY9nLmKMUjd2UvRZj5axFl/Fd7RYltbOVlAdEkhte4=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=LkH7crKZUsCP1XtREfjJg6t5kyNpPqC6YEku8gWKC/XKCtvdWf88T6+2rkgomCNav
         nshayslL1ZEhk4z/ElBZf0EwqgScvTC93H4yQcGmOu/F7RuhQhzCtVNo0cp1Szss9y
         oGe8wizDnJUvnvBJaf4FhxcJlLH4pyxa5D/zy+26rQKPxkkguSslQFfWFjx0QHWq1u
         d2BoipqZwkhhXTQRcs0Xdr80tFXZcB/PM3GIvMjcI9H2dP0oavhMZ2c+AAsa46IIqe
         AKr7S0TTbMHTjGPg0IrCCfWdR41G5u0fattRof0/HKYfrOEfXKRdxq0LNp7LVaf8IN
         MCR1HuRjdrbCw==
Received: by mail-wm1-f70.google.com with SMTP id s190-20020a1ca9c7000000b00347c6c39d9aso7337992wme.5
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 04:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UFY9nLmKMUjd2UvRZj5axFl/Fd7RYltbOVlAdEkhte4=;
        b=Gru+lOQPCJgBSH8VPchC/3AC9HPDBelYSLBrS9m+plPBUlXqOepfaPY7LBzM3a5c5M
         bbkpgHqnUD1UfLkpTJgsVzbrgWY1lpcWAMoxQpcO4qFR7N4k201R8f0bdJWcY1SwoAKi
         JwuRvoPugH4y5gO21jd8lcNS32J7dprnE0M1HR/x+ldSfDHaMiGzuAk1R0r+eoADPLMO
         mVesZW388/AwsGNMjq5Eofig/rLJKnNDwjqPgF7YF8mg9tXswO0MtGgHLJgUHdmycV5C
         Pq1lunnlhkM1bf9e6R0GbTFzOc56pdfj4Ejl3I21bE1mbAFiGKR9focHD2YeIEw0ebGa
         ismw==
X-Gm-Message-State: AOAM530xHhnPmqXkPmUxxgtIJxrJ5cXn55EKmBnPijoJEJ+BbWYE6eqR
        jgeZ3ghutqrVWt+/tHApkc33UDRGx+c6KkxZL2cVoJYbVEaY5e2KSeHrogsAFZ/1Tdu40s8lO6e
        ZZTbjVeOkbPgvKowhf+3m9uHicg7jd2PEEg==
X-Received: by 2002:a5d:4301:: with SMTP id h1mr11658539wrq.511.1642249615336;
        Sat, 15 Jan 2022 04:26:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJJMFuj6liqoHgnsPIf4U94AbLpvbnNxrsqihhJ6QYj/aeAzghUu50bJ5RARQmO3BhD+yWuQ==
X-Received: by 2002:a5d:4301:: with SMTP id h1mr11658524wrq.511.1642249615073;
        Sat, 15 Jan 2022 04:26:55 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id bk17sm7878476wrb.105.2022.01.15.04.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 04:26:54 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] nfc: llcp: fix and improvements
Date:   Sat, 15 Jan 2022 13:26:43 +0100
Message-Id: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Patch #1:
=========
Syzbot reported an easily reproducible NULL pointer dereference which I was
struggling to analyze:
https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39

Although direct fix is obvious, I could not actually find the exact race
condition scenario leading to it.  The patch fixes the issue - at least under
my QEMU - however all this code looks racy, so I have a feeling I am plumbing
one leak without fixing root cause.

Therefore I would appreciate some more thoughts on first commit.

The rest of patches:
====================
These are improvements, rebased on top of #1, although should be independent.
They do not fix any experienced issue, just look correct to me from the code
point of view.

Testing
=======
Under QEMU only. The NFC/LLCP code was not really tested on a device.

Best regards,
Krzysztof

Krzysztof Kozlowski (7):
  nfc: llcp: fix NULL error pointer dereference on sendmsg() after
    failed bind()
  nfc: llcp: nullify llcp_sock->dev on connect() error paths
  nfc: llcp: simplify llcp_sock_connect() error paths
  nfc: llcp: use centralized exiting of bind on errors
  nfc: llcp: use test_bit()
  nfc: llcp: protect nfc_llcp_sock_unlink() calls
  nfc: llcp: Revert "NFC: Keep socket alive until the DISC PDU is
    actually sent"

 net/nfc/llcp.h      |  1 -
 net/nfc/llcp_core.c |  9 +-------
 net/nfc/llcp_sock.c | 54 ++++++++++++++++++++++++---------------------
 3 files changed, 30 insertions(+), 34 deletions(-)

-- 
2.32.0

