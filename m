Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11336B88D3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCNDFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNDFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:05:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761845243;
        Mon, 13 Mar 2023 20:05:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cn6so1432821pjb.2;
        Mon, 13 Mar 2023 20:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678763151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=lHyAtG1U0QIEA4r96uplpAmlJ6rP8bkyM/ELA/B+gsrPbkmUxKlGPzN3T/Lj/HHxOX
         JvkBuQ4KcRd0Ps+aVCFtYimQprL2/HdpgUpKf08mkPUQ6feo+Jp7ewRmiJndah80hzRe
         U1ZfY/zHftYDaRh/hiedqvqBcLtRdY1JsXz3S/Hpez8spvZchCmdPYQ5Z8M9V83CJufa
         0Jc+Bma7ZeGqJvSP67FgJsC0gXdTLVU5W5LvZvP0j8eS+xbhjoVrIAFxnbc1f9CA1t0Q
         HdXEAUYxCHX+G16rtLhvOrUMFBjLAXYYV9iP6NDB1pYvHujFumv6e+4I3ooXdo9c0og/
         V3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678763151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=PmtaQX8huBqYrb2U7/iFaFHe/Rhv6f7lb4ZnziBVprJRxLJzlXivCauII7w4ob+KkJ
         1nhS0kIcpSdd1Ha8nvWV2dSRwmT7GHjy7qb5bbOLg92FBfnQvCpdrt37ntbg3n5oIzYy
         OSLJsS/5k4mRXqcEo9YTVtiS9T2YvfWZGA+47VIZB7EylsGyHlCgFBEJ8f2YpTzk9NHW
         P1XITG1e4EnIuMbfk14dCv4AaH3CmD1vULt5IFdY71/DH7HOn8XXWLilkSzdFL6vw3ot
         4ZiJd+cljCCgVeSIMkpRLKb2ORSZ1/oLkjxIZvPjdvck/3AXcO3rOFQw9ZfkFUUHLGyv
         OM5w==
X-Gm-Message-State: AO0yUKU48kG1K65+ZTCeuDIsu7V9ksE7qOynoDHzob+XsApS5FbS/kj3
        rMgfwqBjBGmKi4Wx4XmqtFc=
X-Google-Smtp-Source: AK7set+VLh7XVS14/QNGIhDfYiOTHwpwWzrWEGITqmXGIjv0KPJNQtg4ovjsPbKF77bv1OJjnfLGLA==
X-Received: by 2002:a05:6a20:690e:b0:c7:651c:1bae with SMTP id q14-20020a056a20690e00b000c7651c1baemr28536529pzj.32.1678763150594;
        Mon, 13 Mar 2023 20:05:50 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id i17-20020aa787d1000000b005897f5436c0sm395433pfo.118.2023.03.13.20.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 20:05:50 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net-next 0/2] add some detailed data when reading softnet_stat
Date:   Tue, 14 Mar 2023 11:05:30 +0800
Message-Id: <20230314030532.9238-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

Adding more detailed display of softnet_data when cating
/proc/net/softnet_stat, which could help users understand more about
which can be the bottlneck and then tune.

Based on what we've dicussed in the previous mails, we could implement it
in different ways, like put those display into separate sysfs file or add
some tracepoints. Still I chose to touch the legacy file to print more
useful data without changing some old data, say, length of backlog queues
and time_squeeze.

After this, we wouldn't alter the behavior some user-space tools get used
to meanwhile we could show more data.

Jason Xing (2):
  net-sysfs: display two backlog queue len separately
  net: introduce budget_squeeze to help us tune rx behavior

 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 12 ++++++++----
 net/core/net-procfs.c     | 25 ++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
2.37.3

