Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC280509117
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382015AbiDTUKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381909AbiDTUK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFC245AD7;
        Wed, 20 Apr 2022 13:07:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u15so5720513ejf.11;
        Wed, 20 Apr 2022 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cccalB/f7dl98H1DWBiuWR8XYUD40T0nXDNgYapNT6Q=;
        b=mReAvsGhWJGmo5vlFsepe6okBMMhYkdttmKKqi6+6iE82RuA0CqCTeJIpUHAx535Ub
         FLfKBECIy+HwDsZ1UTQkIungkf1EZypG088XIvz2/VbDZYBkWb/e5B6GjvStlpCS3Lqg
         W6xaBnZHkNRO56XNZvacULwDaZvaGfA1vgDk8QXg1qHfWHaEX6tGXrdezq92aNETbEi3
         oE3O8FB4e73i+CFXfvIr+I0is7GefKKCZuLvWDnRUrH0fyVrvR1ndFqvK5m9p6f2D2yV
         j93tUjDxaBngw3/gXnMQf63yBvDTIJb3WSBh6xGJodQfYV1jcvk0eYHMs1T74oHzrJGb
         BSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cccalB/f7dl98H1DWBiuWR8XYUD40T0nXDNgYapNT6Q=;
        b=llci3FhfUTn+q+HOGwnga44skNvOCyAz+Wvvkkr4FmujjZaQnimWCrUX947W06Qaaw
         YKq+mdoloNgaZl3kUmjMZ7jqlpzvfxMu2s1Eby8QWjRn9/gZ37Vhpwm8vIlnm+1/L+VN
         fydsY/uyZeOWBlOxrdpllaPR9IlobrXfycly6c5ejwp2JKcape46gBfh26LHcYBml9md
         Zq+CYvGqzMI96gU7hS7yF5x30EPSplq6/La9Pdi5ge2yEfEmwulq4FijaX8Y9zyZvQYB
         lFfrY1bN0RQPOjc2+1cbXFC9bh4bY5NDnm2S6y00ZeLOPSF1ogG5yF1rEPgbHwiRSQhp
         BoKQ==
X-Gm-Message-State: AOAM530G0bZY548P49jrc/GIWHgI9BUkZ0ewTG5Qj5bj28gKLRY9TPL7
        RJ8PDpwY9FKWpX5cM2QaLK0=
X-Google-Smtp-Source: ABdhPJyZfzCx8LHq+K++oK2wId/JfxwpHxd20K3/BkHPNopiYdq5l3FNSMvilCLfPyoLPw1CmeE5Xg==
X-Received: by 2002:a17:907:8687:b0:6e8:d71a:7a51 with SMTP id qa7-20020a170907868700b006e8d71a7a51mr20171221ejc.265.1650485259524;
        Wed, 20 Apr 2022 13:07:39 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:38 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH 0/5] hv_sock: Hardening changes
Date:   Wed, 20 Apr 2022 22:07:15 +0200
Message-Id: <20220420200720.434717-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since RFC[1]:

  - Massage changelogs, fix typo
  - Drop "hv_sock: Initialize send_buf in hvs_stream_enqueue()"
  - Remove style/newline change
  - Remove/"inline" hv_pkt_iter_first_raw()

Applies to v5.18-rc3.

Thanks,
  Andrea

[1] https://lkml.kernel.org/r/20220413204742.5539-1-parri.andrea@gmail.com

Andrea Parri (Microsoft) (5):
  hv_sock: Check hv_pkt_iter_first_raw()'s return value
  hv_sock: Copy packets sent by Hyper-V out of the ring buffer
  hv_sock: Add validation for untrusted Hyper-V values
  Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
  Drivers: hv: vmbus: Refactor the ring-buffer iterator functions

 drivers/hv/channel_mgmt.c        |  8 ++++--
 drivers/hv/ring_buffer.c         | 32 ++++++---------------
 include/linux/hyperv.h           | 48 ++++++++++----------------------
 net/vmw_vsock/hyperv_transport.c | 22 ++++++++++++---
 4 files changed, 48 insertions(+), 62 deletions(-)

-- 
2.25.1

