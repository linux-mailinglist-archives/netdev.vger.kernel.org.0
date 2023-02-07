Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B69B68E293
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjBGVCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBGVBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:01:45 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEBC3EFC3
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:01:16 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-527ba5d5459so68841677b3.5
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 13:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7EV3T3uhVvFbggwj3Hyub37yJt3D0v+Cs4KUPH5FVSw=;
        b=JoiUfdC70YgYR19RMPt7GFnG6vTfNMyVANobJExJFRkeWC6TmvxGQmc59SwHZrmXjd
         M8si5FHFeMoh/482baOa8vILkB64j52boQat8tkvPAUpFOnZ4bWKzccIawv9WJOvS10H
         oPlll5i0xub+mRqIGxfv6d/F6nGqWU2CCipH0A4XNc2HNec5Ju4LI/Ty27OdTrN4DVd3
         wu76eZGP/qrFlC2NB8G4VXm9A1Jv8LaY/wloyoC562B+Pm/8fZ2vmJBcr9aIhsBQDgp8
         cq9a1mOWjnPQSiVrMkJhJpuZWH6IyhXiianEVqeuZA5B3j2IKQXgEx8Jjckl2yCp7ONM
         ew+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7EV3T3uhVvFbggwj3Hyub37yJt3D0v+Cs4KUPH5FVSw=;
        b=vTLF3U+IDphI0LR7X2c764lckp3HUp/R4p+Z0si5JghREPqNy+s5BEc48HGomACvLE
         X4QoaZSiOB7eRx4nJlGrXBLi/ED+dIODrSddEDFd56ddyhmP8rBeNI8gMuGvVtZ+8GIR
         a3URQ9CqevCleVw6FB+juCnQGLd5jueh5LgKpvYHOVaL0YwTxlRbDLyqGTA1/mAQfc31
         3xAgx4CkCNMwuLZJbyDSHW6wkIEshBgcnuuThHfMPTn/yOxW+TmD4/to3pUTjMHqJm5H
         UCA/1bNDb7DceO2Z1blwfGFi3NGUlUMdNHTqVUchIlmATOlByAYHkL75NIHCrz7LiSgW
         xp+Q==
X-Gm-Message-State: AO0yUKVTS3hOEPVqyGVXDI8ykS1QFZvDOUw5kzZ12TSMYD0L9cjayLJK
        5MWVNXtM42r+U4KonOfxom7g/ixmu6zIt7MvbHIwPVfxOSMfh68KPvQxu9QWxNlNPIYB33sBZxh
        SndRlummMZv0yRgI2yGIOlGXu4eNviGVidN9zKXAjd7i+cLIvdUkKKsR5QOO/ZaIiTGxRueJVoC
        q90Q==
X-Google-Smtp-Source: AK7set8yDZmyuyLwTdY1NWlGv+llM+/5BSrGoVTR6Oc2nK3TMWVSCUuFZiM62wjzWEVZwrN4wVJsMlA7cIoa/gBud+4=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:966c:8be6:6e77:92b1])
 (user=pkaligineedi job=sendgmr) by 2002:a05:690c:388:b0:521:db02:1013 with
 SMTP id bh8-20020a05690c038800b00521db021013mr5ywb.3.1675803670850; Tue, 07
 Feb 2023 13:01:10 -0800 (PST)
Date:   Tue,  7 Feb 2023 13:00:54 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230207210058.2257219-1-pkaligineedi@google.com>
Subject: [PATCH net-next 0/4] gve: Add XDP support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Praveen Kaligineedi <pkaligineedi@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for XDP DROP, PASS, TX, REDIRECT for GQI QPL format.
Add AF_XDP zero-copy support.

When an XDP program is installed, dedicated TX queues are created to
handle XDP traffic. The user needs to ensure that the number of 
configured TX queues is equal to the number of configured RX queues; and
the number of TX/RX queues is less than or equal to half the maximum
number of TX/RX queues.

The XDP traffic from AF_XDP sockets and from other NICs (arriving via
XDP_REDIRECT) will also egress through the dedicated XDP TX queues.

Although these changes support AF_XDP socket in zero-copy mode, there is
still a copy happening within the driver between XSK buffer pool and QPL
bounce buffers in GQI-QPL format.

The following example demonstrates how the XDP packets are mapped to
TX queues:

Example configuration:
Max RX queues : 2N, Max TX queues : 2N
Configured RX queues : N, Configured TX queues : N

TX queue mapping:
TX queues with queue id 0,...,N-1 will handle traffic from the stack.
TX queues with queue id N,...,2N-1 will handle XDP traffic.

For the XDP packets transmitted using XDP_TX action:
<Egress TX queue id> = N + <Ingress RX queue id>

For the XDP packets that arrive from other NICs via XDP_REDIRECT action:
<Egress TX queue id> = N + ( smp_processor_id % N )

For AF_XDP zero-copy mode:
<Egress TX queue id> = N + <AF_XDP TX queue id>

Praveen Kaligineedi (4):
  gve: XDP support GQI-QPL: helper function changes
  gve: Add XDP DROP and TX support for GQI-QPL format
  gve: Add XDP REDIRECT support for GQI-QPL format
  gve: Add AF_XDP zero-copy support for GQI-QPL format

 drivers/net/ethernet/google/gve/gve.h         |  50 ++-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  91 +++--
 drivers/net/ethernet/google/gve/gve_main.c    | 325 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      | 143 +++++++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   2 +-
 drivers/net/ethernet/google/gve/gve_tx.c      | 272 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_utils.c   |   6 +-
 drivers/net/ethernet/google/gve/gve_utils.h   |   3 +-
 8 files changed, 823 insertions(+), 69 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

