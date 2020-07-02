Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1221280A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgGBPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgGBPhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:37:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CFCC08C5C1;
        Thu,  2 Jul 2020 08:37:42 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g17so11449974plq.12;
        Thu, 02 Jul 2020 08:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NG6nRg89R1RTOY/FF9lOS8GN5LVk4HsmPxWUfy7XLmI=;
        b=g7VsKvp8FXum8US9gHHaSOSGexp+ckPF6Bwl+qHQeCal8wKWrrsVFwl4hLerBHqB6L
         /JT/+17SiHskJCLmhLLAJcZXL7BdhKzRJ1/UvrSyBEHoSNDpN+XfXQS1SC73SeWTDnTK
         8sEoBXFje6urCtG0ZXS5iwh3xrsNOYK5YJXflEm6v3zLWXgIHzCvRLza1jZCbRLQXUkJ
         9gEFcNqFFxyrH+pPYg41f1t8gwZ0YI13cEfDzPlkIMHNBqnDiQaN1xK1FzTAsQoMF3ij
         KRtAVrkFU6V55aHYtTQS6rNiJjs5S0cR260c5GQ8vXovHQ8FQqEzyHnnbU71STZPk/oq
         iq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NG6nRg89R1RTOY/FF9lOS8GN5LVk4HsmPxWUfy7XLmI=;
        b=b+4ePUVMIeeQletyDK1hJIYffKMyVR8AXJt4f+m0vVNpeeR9iOljTSdeSot1aEi+E2
         8I3/qIc+j8qo+kPzOl+qJZn9ccQ6H3hPNbeMCf2VlcgU3vrHY4EJYIv2vlvVZ2UmJWiD
         5Kfa4ggtMWEj5958v/BMDsvfozcb4LSZfGhNYXYWhCngIEJLWT5TRtVIh03ysGGVh5lk
         SbGgU0tnm1v2HWjzeaZ5yBhXvSGKftHDQwNtKSl4/x3UOwkBoz4w+JFH9owNxMNBzi/q
         uB0XkdZE/D7PHGs9eARAGGDbNI5EEgfQRjArQmfPaPH6HW+EERNmW1QGv+b1oGFzd4p7
         H/mA==
X-Gm-Message-State: AOAM532+vgcp6Fjgvy7kn5KP879qTJSguctfUWiZ7aPM2IKIfKY0AdJN
        URAXNgst0+O76oVl0U9WTSztL08nr9U=
X-Google-Smtp-Source: ABdhPJzBHPhl5MaEB9Orc8RqilFIVY+AZGsroL6+k3iiHySgZlKJBYtexJtojY+2/MQyRaON0w5jSQ==
X-Received: by 2002:a17:902:c391:: with SMTP id g17mr27343301plg.330.1593704261634;
        Thu, 02 Jul 2020 08:37:41 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id r6sm552651pgn.65.2020.07.02.08.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 08:37:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 0/4] i40e driver performance tweaks for AF_XDP
Date:   Thu,  2 Jul 2020 17:37:26 +0200
Message-Id: <20200702153730.575738-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains four patches worth of driver tweaks for the i40e
AF_XDP Rx path, that in total improves the Rx performance (rx_drop 64B
packets-per-second) with 17%.

Please refer to the individual commits for more details.


Cheers,
Björn


Björn Töpel (4):
  i40e, xsk: remove HW descriptor prefetch in AF_XDP path
  i40e: use 16B HW descriptors instead of 32B
  i40e, xsk: increase budget for AF_XDP path
  i40e, xsk: move buffer allocation out of the Rx processing loop

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 10 +++----
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 +--
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 19 +++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    | 13 ---------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  5 +++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 28 +++++++++++++------
 9 files changed, 50 insertions(+), 39 deletions(-)


base-commit: 23212a70077311396cda2823d627317c25e6e5d1
-- 
2.25.1

