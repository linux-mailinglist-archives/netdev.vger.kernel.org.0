Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8B250002A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiDMUuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiDMUuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A4350470;
        Wed, 13 Apr 2022 13:47:57 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l7so6387843ejn.2;
        Wed, 13 Apr 2022 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CAAnlEczhzmwiiUomiVlc0ZiocMImLzsGeEoBJQeHzQ=;
        b=c3nT3xD7XU0MWgpY86pi4lDdID4ySVqTE/1C98vzR0kJiHPonHeBH0GU1HuChqUGyE
         UpBag1pr//pEDDgun7N9oygVdwEPe/QHh7AhwZJ7E29hnK02IHlPW3qjiPjdrNMUKjUB
         m/ACRO66qRVpY1HeV58JF45hOWiJua00SMUqpJ3TdWTm2R3vX9oAv1q4WVhqcog0URfB
         3dO3944uavA6O6mgkfhFzXP/09jyvz7VRUJY2qFUdhrFfWkOKsMmWBpNCSgWi2XAcCV/
         VRcgD97YhYV8sK0NlvmIDpaU0JqTMmafIjyi8hrqKy9AYmwgKBe0EYwHVr34YZ/F5Lw8
         YTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CAAnlEczhzmwiiUomiVlc0ZiocMImLzsGeEoBJQeHzQ=;
        b=uGiCN/sm3ZShroWH4ut+uELjpxzs9rDcKkb7XO69VkZyddm/Ms5uMFJc2jidzdOE2B
         YTML8O8ZEaS8/WAi8b4C3u7V2/lm5x5ohkIgyNxYDh4Jk5hJgukXJbr0pIFJljf6S9k2
         LigHBxpwV1myyu/DXC0px/4P+MHJzGo2t9vms7PcC4vlxdUfc5FlnuMWdUb9YAQ0HDot
         tfcebIxADg2hPA5zzopxLXa8e7ELUAWlg6gYgKxUZWALq2jky0PzwjG8J4BCva69efR/
         wPlrYJqPcyWtm3wYxQE/9KVcGIzSGC2n+YcW5DPLCrnM6G+4qKTBon5Q4YfyWo6Tt+4E
         XFAg==
X-Gm-Message-State: AOAM530zC+Hzi3ilYrPo0ijdlhAs03tVWrZIPVQIJ+egYan8FcF70O1H
        GsiTok+tWb9RcOCy+rgxivc=
X-Google-Smtp-Source: ABdhPJz5FFD/9vp0qQEvMaltsIVTNbvBYFnN863Pr155FR4NkEaORH9Jnyt5J40E+ppbX3kTSaW2vw==
X-Received: by 2002:a17:907:7296:b0:6e8:97c1:a7ef with SMTP id dt22-20020a170907729600b006e897c1a7efmr13352185ejc.262.1649882875639;
        Wed, 13 Apr 2022 13:47:55 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:47:54 -0700 (PDT)
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
Subject: [RFC PATCH 0/6] hv_sock: Hardening changes
Date:   Wed, 13 Apr 2022 22:47:36 +0200
Message-Id: <20220413204742.5539-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miscellaneous changes to "harden" the hv_sock driver and enable it
in isolated guests.  The diff in ring_buffer.c, hyperv.h is due to
a consequent refactoring/code elimination (patch #6).

Applies to v5.18-rc2.

Thanks,
  Andrea

Andrea Parri (Microsoft) (6):
  hv_sock: Check hv_pkt_iter_first_raw()'s return value
  hv_sock: Copy packets sent by Hyper-V out of the ring buffer
  hv_sock: Add validation for untrusted Hyper-V values
  hv_sock: Initialize send_buf in hvs_stream_enqueue()
  Drivers: hv: vmbus: Accept hv_sock offers in isolated guests
  Drivers: hv: vmbus: Refactor the ring-buffer iterator functions

 drivers/hv/channel_mgmt.c        |  9 ++++--
 drivers/hv/ring_buffer.c         | 11 ++++----
 include/linux/hyperv.h           | 48 ++++++++++----------------------
 net/vmw_vsock/hyperv_transport.c | 24 ++++++++++++----
 4 files changed, 46 insertions(+), 46 deletions(-)

-- 
2.25.1

