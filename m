Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADB609ECE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJXKR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJXKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:17:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22B688AE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b11so1667149pjp.2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qtq0Y7iJLOJt5tEoFMGaufQDTcmOOi4G++ouu0YsoMg=;
        b=AXxMN96wHT7o+i2az/GiY7ys6UycOhZpA2NhJaK9xDF4ocYOxfM24LQxy5duS5THc5
         gOvh2gTVS4LSeeEmjkdwa6DrZQsO1a/7/RXXSI11mUG5aisfik96FNyWcINDAmzNf9my
         O1bTtmVbCGEI8cWxr20pKq9O3Lw0c/HLLVFT5Fu5IFVv88rbH4CtkGujuPV1O3Y5Jx2S
         17wLlXTdbDaihlfj4m75j+v5k/vCZwe0N6XRMzrb8eDQJgfROPNRGMPF6Gbt2+bsJqoI
         DZ825M2ygPTWwK+T7EICjAFUTmKGPPb01A06GSm77+3Rq0rLXdcvNC650G6gXM/OPqXt
         +h6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qtq0Y7iJLOJt5tEoFMGaufQDTcmOOi4G++ouu0YsoMg=;
        b=y4divGJfUqncGA9UxwlnrsuG4la6K2so3PzdVRe8wkyOyk03r7J9DG7mfrznvXCXg7
         1qzLN85lSGHWCPrzyWdWPktWSNDGVx+LAiFxVpFZWqAydnHdyXJIh7n6K5O3gBAOseEQ
         FJp2IzpYTxhGFmNFe3iKnDx9xbrTUKwrBhLbjC+olDrOcLPQeXh1rZ4GAHho/izDa26P
         REzRYazNKS2XVSOqmHlrtkZ77pNjDqBd3I/LhJ3PFn0hVhF2zKG4P0WpIAuuZ8AHb4nh
         XfNRHW9OUNlJ1OWysbJ/VceEI4xM7DbHVmXdtw8LgWcII4jkIcIEtruZ+rxwVFiZukQa
         xxbw==
X-Gm-Message-State: ACrzQf2UYkqm7XsO3n0jKYLY/8+I0eQkgBqSidr/hH2RUqJ9vTFfq4i2
        fSkIKYMNIaAqNN9HpeHb6eB+Xg==
X-Google-Smtp-Source: AMsMyM5ekFDuM3fSthud8xozJNIQ2uyNgc357IbtVwToAwtriEcvxF6BqeVfnvDlbDoJ0EWt9jl1kw==
X-Received: by 2002:a17:90b:4d05:b0:202:ec78:9d73 with SMTP id mw5-20020a17090b4d0500b00202ec789d73mr37621805pjb.103.1666606645972;
        Mon, 24 Oct 2022 03:17:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h197-20020a6283ce000000b0056bf6cd44cdsm586290pfe.91.2022.10.24.03.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 03:17:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/5] ionic: VF attr replay and other updates
Date:   Mon, 24 Oct 2022 03:17:12 -0700
Message-Id: <20221024101717.458-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better VF management when a FW update restart or a FW crash recover is
detected, the PF now will replay any user specified VF attributes to be
sure the FW hasn't lost them in the restart.

Newer FW offers more packet processing offloads, so we now support them in
the driver.

A small refactor of the Rx buffer fill cleans a bit of code and will help
future work on buffer caching.

Neel Patel (2):
  ionic: enable tunnel offloads
  ionic: refactor use of ionic_rx_fill()

Shannon Nelson (3):
  ionic: replay VF attributes after fw crash recovery
  ionic: only save the user set VF attributes
  ionic: new ionic device identity level and VF start control

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  20 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  41 +++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 113 +++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_main.c  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  31 +++--
 6 files changed, 179 insertions(+), 31 deletions(-)

-- 
2.17.1

