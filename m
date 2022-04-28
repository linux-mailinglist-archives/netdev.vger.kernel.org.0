Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A145E513753
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiD1Oyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiD1Oyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DDD5C674;
        Thu, 28 Apr 2022 07:51:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r13so10082133ejd.5;
        Thu, 28 Apr 2022 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVqv1nArzAzVc8zxOGZIT2rhz30z3e3wncOXfywh06A=;
        b=grMGatkZPU9cecRmAL2bmQjtV3MsxNM47/nT5ujKA758D+/kLmD3YjwebPl/TYkhLV
         nCyrYWlz4FwxAwRiLTl9SBYnxT2NsIAORNpoSYGhT+045B66agvSo9bNp7dKGa/Lhn3r
         IAN2db6Q6DeuHSrKfnzOkV4idOJKbq2+ac3S60WqC6wXC4DwdDlL/lkAeeaJiDzPRRGN
         a6mQ3SogNvVYQGOVOhoiK6mANxflvkr+9DlYnoDXHXZEjrWw00V84qYU7e5LwDVNiPe2
         BI3pI2sPezzIntciUe/lxU0Lmk2gXqjYBX2A0h/xv629Nzd4BYR2iWGZx3UtiUhIF84L
         ptJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVqv1nArzAzVc8zxOGZIT2rhz30z3e3wncOXfywh06A=;
        b=1JH33lomhN2csHjxXtQB/x9wad0rRcKqGOOJ6DBCSJVdSUxUAoCve/ujqKtD7tpEcF
         KYHiYNzOuLhvoJhe/fH9m9Asf4sC3e0TREaY1NCqETEydD2ayxAheJ9/VPImDe/3U7Ml
         0IHjOkcRwyUvPmoaGYO5X7RaxlqZTsTQM3iYGb8Ajxp3FTNNnmWjONvUhw6pY+qGGmxo
         OGgaI8K8H7vI9QGt1MGlElIHAFHClPhG5TjP4XkJpnbioXQY1/o4kPEZ/27pKt+8dnyq
         bJbXcSYLAdfRVVgy0d+bXPpxybitu6VR9jmp59YsDm8e986qXj8uNh0y9u7NdBhgjd0/
         ecqw==
X-Gm-Message-State: AOAM532S4I2A/bGioxC3/9ngV3kVSNRVCxNxlEh0BQsAQpyc7WPCXK34
        qcy9UzLj8ZHw969B75UTr/w=
X-Google-Smtp-Source: ABdhPJy4l/9jNooGlFjFsgEitllXjr3Lxmnsgis1Ib+2EMdMyOkEm55gtg92b/26Tg6WJFerfOKQog==
X-Received: by 2002:a17:907:62a1:b0:6da:7952:d4d2 with SMTP id nd33-20020a17090762a100b006da7952d4d2mr31715210ejc.260.1651157482409;
        Thu, 28 Apr 2022 07:51:22 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:21 -0700 (PDT)
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
Subject: [PATCH hyperv-next v2 0/5] hv_sock: Hardening changes
Date:   Thu, 28 Apr 2022 16:51:02 +0200
Message-Id: <20220428145107.7878-1-parri.andrea@gmail.com>
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

Changes since v1[1]:
  - Expand commit message of patch #2
  - Coding style changes

Changes since RFC[2]:
  - Massage changelogs, fix typo
  - Drop "hv_sock: Initialize send_buf in hvs_stream_enqueue()"
  - Remove style/newline change
  - Remove/"inline" hv_pkt_iter_first_raw()

Thanks,
  Andrea

[1] https://lkml.kernel.org/r/20220420200720.434717-1-parri.andrea@gmail.com
[2] https://lkml.kernel.org/r/20220413204742.5539-1-parri.andrea@gmail.com

Andrea Parri (Microsoft) (5):
  hv_sock: Check hv_pkt_iter_first_raw()'s return value
  hv_sock: Copy packets sent by Hyper-V out of the ring buffer
  hv_sock: Add validation for untrusted Hyper-V values
  Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
  Drivers: hv: vmbus: Refactor the ring-buffer iterator functions

 drivers/hv/channel_mgmt.c        |  8 ++++--
 drivers/hv/ring_buffer.c         | 32 ++++++---------------
 include/linux/hyperv.h           | 48 ++++++++++----------------------
 net/vmw_vsock/hyperv_transport.c | 21 +++++++++++---
 4 files changed, 47 insertions(+), 62 deletions(-)

-- 
2.25.1

