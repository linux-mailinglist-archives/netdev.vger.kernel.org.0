Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9D6AF77C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjCGVX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCGVXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:23:55 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC28737F;
        Tue,  7 Mar 2023 13:23:54 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id c19so15992349qtn.13;
        Tue, 07 Mar 2023 13:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KJgQcrpPIIVlWvFmarwfb9A6WS97bSM7vxKuJ6xoBQw=;
        b=lSQPebSvo98ZY+V2Wki+hCJxBqoW6CSV+2xA6qvGG79JPbpy9qVVveto1fPSeKrLUh
         qIFlGOtCDoFxxidUYTBTpkuasRIXbN1/q9aHZtjKBv0ffyNck3edgwnGq4ex2OWcfyGA
         c/PbXSCwN+o5FD6Z43Vrd+Nws7wrWrNwjv/nS0j3R1css2rdGQv/yOZi5UtObn1Lq3Ca
         lnC6YAhlVfDfI2uI1bnhJjBGMWgzXgEg2BaUeOvw2A8OVlp2uV7ggDUx984ZndiSjtB9
         yXZtUckTThwvZU16Wbv5C8/XyU19SgeHn+eaayU9YI11GIljx6zNLTYZr+7EN0fqLgra
         ENaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJgQcrpPIIVlWvFmarwfb9A6WS97bSM7vxKuJ6xoBQw=;
        b=1tpl5RoA0NtgwPwwp1DrKSxBoZyesbIX1U6BJ1rER6bSuwalDn9uLHkDYU82S5KQUK
         u1mmf0D2Sw8/YHCUL4vn2P8ZM1wvxkbo8J3w8xaoZHOO8zdrrkE1DzoMgq0AyblHcfXl
         4B7eh8semPkku+86+dHSE24IzffHW4o+BxqX0ra9J+EStRY9fdHduSDEtXD45KtKgkG+
         KWcO5UX6RGFlDEDAYslOUntp6yP5eXaBe2uhoV3nv4zCyaWtVe5+FHc3YW+PpU4isLjn
         VycrqF5x4pE+iqgpvBoS1ws6Xe/NkPBXk7MvVvQmMQEI6TUEXk4Hp23oOGevSpYnAItE
         IwCA==
X-Gm-Message-State: AO0yUKUihkgCg17HK+TBdJ7vUYvtXeMCBtkP8dQYXe+iLRXInHOmDrRF
        z7guCm/4bmk0jSTYV3OYjJfyqzlqGh4=
X-Google-Smtp-Source: AK7set9TqH8VUi+kjopqFuIBCE1R1HwrQp+win83nBl8R+9Crev7UHJ2ak3q+d3eLwuc2lgogRXVIA==
X-Received: by 2002:ac8:5c83:0:b0:3a8:e35:258f with SMTP id r3-20020ac85c83000000b003a80e35258fmr28512344qta.31.1678224233488;
        Tue, 07 Mar 2023 13:23:53 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b007422fd3009esm10346878qkp.20.2023.03.07.13.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:23:52 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next 0/2] sctp: add another two stream schedulers
Date:   Tue,  7 Mar 2023 16:23:25 -0500
Message-Id: <cover.1678224012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

All SCTP stream schedulers are defined in rfc8260#section-3,
First-Come First-Served, Round-Robin and Priority-Based
Schedulers are already added in kernel.

This patchset adds another two schedulers: Fair Capacity
Scheduler and Weighted Fair Queueing Scheduler.

Note that the left one "Round-Robin Scheduler per Packet"
Scheduler is not implemented by this patch, as it's still
intrusive to be added in the current SCTP kernel code.

Xin Long (2):
  sctp: add fair capacity stream scheduler
  sctp: add weighted fair queueing stream scheduler

 include/net/sctp/stream_sched.h |   2 +
 include/net/sctp/structs.h      |   8 ++
 include/uapi/linux/sctp.h       |   4 +-
 net/sctp/Makefile               |   3 +-
 net/sctp/stream_sched.c         |   2 +
 net/sctp/stream_sched_fc.c      | 225 ++++++++++++++++++++++++++++++++
 6 files changed, 242 insertions(+), 2 deletions(-)
 create mode 100644 net/sctp/stream_sched_fc.c

-- 
2.39.1

