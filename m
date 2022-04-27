Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2561F5119C9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiD0NQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiD0NQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B7E4993B;
        Wed, 27 Apr 2022 06:12:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b24so1877894edu.10;
        Wed, 27 Apr 2022 06:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y1MPivJ71DUTG2ptog6r0HYX3a/d3mDJNSwkKFhB8Qs=;
        b=J9z7Wkh4fQH+gqjh4dmtAu7+WFRRxrFjaU7d33Y/DOgeyuEwb+ExMM4P9rm14PkjKH
         0gjK+bceotqd1JduXB4AwAMTUB6qgWeth1DJgyoMoP3tTIwzZpUvjxflaH2mp1LWUXDP
         wkstiAJxqlvImbXJpwYFe+Qec2wTa3JUGv67YZz9iB5PB/sjJA5NxRR8WetY+YgwGJdq
         IbJY8jRtd61Nw0AdWmq+eh2w0Q5KxNDbpZTM08HQNp8I5X2OT4sQ2dL0bskiqbUMcYnO
         VG/uJw46E2P8L98HB6oWJqkB5Mpu53oBjlxF40aJQ3bxcBdxiEos0QMFPRdPF/5VI8sk
         6xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y1MPivJ71DUTG2ptog6r0HYX3a/d3mDJNSwkKFhB8Qs=;
        b=CD87h55WfyjYg+p3ymi3YkFJUldHvygiGbDWW6f69qt8EuyVHTH8hvZOEhyFgvT/oP
         nu9/P8HjxIcjffC3e4A8ilIObOPP6Myxj5sZql/OB+82BOnzCjCd2UeRsmuK0d+bOjgx
         EqxZMR8+BJX99u0ryuPtmJtLEYzfrCgRbx7Ilcoe5ClUmGGnc39QcNVmkvxsR4a0UyFh
         Y8sZhffBqiyKOPD+LtO4XRQxLIzsgj8JCL3AtDQAN6yAAms2ILsbxPRal/7n5ZyKK8Z/
         ulJ5bCS8NCwa+xyG5lBb70GcJUsS0YC9d3Xdq9smjoFveZt+Z91oGhj4nEhr3x+ZisgS
         nX7A==
X-Gm-Message-State: AOAM532dA62rpXbX4LtzjpsS8WtDTOlKaT7zC0O/L9rndJm/fsQS1+D2
        TpWW6zGYQ1JNNECt2TR932s=
X-Google-Smtp-Source: ABdhPJxfUbhE4AOOIR4P5nh9VWfbfWwj+uLWk4co7udiK3uIOtQhfRvPaoh6MBb7bsrC0f9TTUseXg==
X-Received: by 2002:a05:6402:27d0:b0:41a:68bf:ff26 with SMTP id c16-20020a05640227d000b0041a68bfff26mr30392127ede.102.1651065175014;
        Wed, 27 Apr 2022 06:12:55 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:12:54 -0700 (PDT)
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
Subject: [PATCH v2 0/5] hv_sock: Hardening changes
Date:   Wed, 27 Apr 2022 15:12:20 +0200
Message-Id: <20220427131225.3785-1-parri.andrea@gmail.com>
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

Applies to v5.18-rc4.

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

