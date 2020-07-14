Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1421E864
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGNGij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgGNGii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 02:38:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B775DC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:38:38 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so1110617pjb.2
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B5fC/VSpjwy0J2AgPE2pfNPefXcs6+XE85WC452HsHQ=;
        b=mr0D21JXps0uIWilptyRM498GqskD06pSEAktZIX2pOOVgpwiLqZkqGdUUs8RK8KHT
         iWovcxQjReqmmoIG8FLb32yyuQSFKYuaHIGnOi9JFaY3Qm0G+Q0OBYJHewifhzZZfsOd
         wTn+LzhUcR1b5PRp5q5J7RdaX6mDMmWF4Pzk1Nhcvn/2X40F4b0EU8RfujfVkD0iu1HU
         qVSJ6Cr4EVUiTHX0duM0QtRE5CFTLVyuwQzW0uVgRQx2mIecIOSnMsUVQ1VqpIMjUDKQ
         Df3YQ63oO0D2bXjzGx3zkTy3iXn805BcCB5gtyzvTkW13NtFyXdGgBHzaZBr9G5EBvtT
         zDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B5fC/VSpjwy0J2AgPE2pfNPefXcs6+XE85WC452HsHQ=;
        b=qFlwWrOrrXCPIIhP5mh14hlUqE/wxIP55twyzeq41AuzhoB1TOsAlqWJMnrbKbN9jJ
         jAbvaqFFMYK5nWKsjxEBQDIQTY1tpvJ9bd65zATeWP5hj0g9HzWnOky7HGbDhkVaaQ6H
         kGG2uBh+s4nsmo0+NHhH6DdJZG2nrmGPdhpk3TyL0sdL01remtFR/lUmIPxh0dZ0rtYm
         cTClXZ7wkbS9MYb+s3canryHj/1+UHNZdW1MFgz7RkOdsqRsPTGANFEs10ATgr0EFcpk
         pHsxMsR88NDZKq9nJCSXR/tO5tYJJRdHevbbAzvaMydPBi/tU5CwKdRM/62/CADV45Mb
         ztIA==
X-Gm-Message-State: AOAM532Wjua+lcrTzDGKr7G89ePj2kTHr1m+ZQDY9yr9qlFkuSRexdAd
        aPi2RbW3Yy1HMPRb0WKUAHc/nu8ZFdyKBQr+
X-Google-Smtp-Source: ABdhPJwQOQlewX+8y1L1doL2NYBhDZxhjSaFVqJbtfMjg7KlfFMN4EjdkjCKFMEX9/wiS8jxLJNu0g==
X-Received: by 2002:a17:90a:f68c:: with SMTP id cl12mr2724603pjb.116.1594708718266;
        Mon, 13 Jul 2020 23:38:38 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id f29sm14620209pga.59.2020.07.13.23.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 23:38:37 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Rakesh Babu <rakeshs.lkm@gmail.com>
Subject: [net-next PATCH 0/2] Interrupt handler support for NPA and NIX in
Date:   Tue, 14 Jul 2020 12:08:23 +0530
Message-Id: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rakeshs.lkm@gmail.com>

Different types of error interrupts are reported by NPA and NIX blocks like
unmapped slot errors, RAS interrupts, memory fault errors etc. This patch
series adds interrupt handler support for NPA and NIX functional blocks in
RVU AF driver to know the source of error interrupts.

Jerin Jacob (2):
  octeontx2-af: add npa error af interrupt handlers
  octeontx2-af: add nix error af interrupt handlers

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  12 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 202 +++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_npa.c   | 230 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  33 +++
 5 files changed, 481 insertions(+)

--
2.17.1
