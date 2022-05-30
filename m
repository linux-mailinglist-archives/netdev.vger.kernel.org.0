Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5B537668
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiE3INt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiE3INs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:13:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E7E36E3E;
        Mon, 30 May 2022 01:13:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id i1so9668494plg.7;
        Mon, 30 May 2022 01:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h1svbaEqV8PRZTtVntF3k35V3laaDlhsR/nOYh3xAJI=;
        b=TIGbzMnvZ2J5Lx0XAcEYivrymkNsQ3bP+EG2Sa5U2lMbHVHpG5nmU8fGtmRzR3xxHF
         gabr2doQiy6JlQHdg3mr+/IbWLDa+fCW+3hdUA3jY7z5JfvWPuuOhPtWr73Y2y1C/rB/
         fTUtGsCZiRTYqB8nymz/9hfYjmTtW1Up83ZjRDX6XwhRADEJFdTvUX9iXn8HRRvt8Mbi
         sTT3NPy16IwiFodn5VpxbkJKtqSBiXBwEhb5sBP9VOvzx4EDvvoGoj1gCyo1lC648yWX
         554ueQ+irjnzL5pnEwTWGYw0gW2qHMyu5nKTE+xAZxDomgFUuserQSGAFuJ0Mqi4Lh+M
         6SVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h1svbaEqV8PRZTtVntF3k35V3laaDlhsR/nOYh3xAJI=;
        b=sjmkv5DX+yBIQFbI6xJPK020tGDDADMTq19YNl21Q4+M+p84E4hon4A1G2oNMiZp4I
         uyOiUz7JU8G1nvLDGc9sMx+BSC47rFE4sf14PL+bLjkJzxuZ5t/6xsWWYVpbEwJtrEAF
         fxN1WYlz6VGuzHRSuuNmurTlmvLr+gZH8oNyWRABrXwaOnSirmpSKkN6eNr0GsVODKhx
         kPP29aSo9Ec/T+8CGvCM5jXDh3IJ/lnV4KTVX1bzsPf4AqHzFrkJWtmq89Vh9+DvIZfN
         otZ1w7AsFB0BZEABXag01kXcHx3KYF8VqNxCtzbZuMy4ko/Gt5BReAKD51TXebkAHjmX
         ZQsg==
X-Gm-Message-State: AOAM532/8TnvTZSoAVKZFn6rH5bplwidg8WX1Kmc3NQdDG9zE9rmJkfh
        quMbv1BqpuU59iGyxmiQDSE=
X-Google-Smtp-Source: ABdhPJwiQwXBYR1rmG7AGx+a5s6GujdyX9/JrIfODha/NvNUs49ewsNFQfCGOaOU2fj+0Usa9BC1NA==
X-Received: by 2002:a17:90b:1b01:b0:1e3:1014:6abe with SMTP id nu1-20020a17090b1b0100b001e310146abemr2119079pjb.113.1653898426055;
        Mon, 30 May 2022 01:13:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090332ca00b0016156e0c3cbsm8624331plr.156.2022.05.30.01.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 01:13:45 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 0/3] reorganize the code of the enum skb_drop_reason
Date:   Mon, 30 May 2022 16:11:58 +0800
Message-Id: <20220530081201.10151-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
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

From: Menglong Dong <imagedong@tencent.com>

The code of skb_drop_reason is a little wild, let's reorganize them.
Three things and three patches:

1) Move the enum 'skb_drop_reason' and related function to the standalone
   header 'dropreason.h', as Jakub Kicinski suggested, as the skb drop
   reasons are getting more and more.

2) use auto-generation to generate the source file that convert enum
   skb_drop_reason to string.

3) make the comment of skb drop reasons kernel-doc style.

Changes since v1:
1/3: move dropreason.h from include/linux/ to include/net/ (Jakub Kicinski)
2/3: generate source file instead of header file for drop reasons string
     array (Jakub Kicinski)
3/3: use inline comment (Jakub Kicinski)

Menglong Dong (3):
  net: skb: move enum skb_drop_reason to standalone header file
  net: skb: use auto-generation to convert skb drop reason to string
  net: dropreason: reformat the comment fo skb drop reasons

 include/linux/skbuff.h     | 179 +------------------------
 include/net/dropreason.h   | 259 +++++++++++++++++++++++++++++++++++++
 include/trace/events/skb.h |  89 +------------
 net/core/.gitignore        |   1 +
 net/core/Makefile          |  23 +++-
 net/core/drop_monitor.c    |  13 --
 6 files changed, 284 insertions(+), 280 deletions(-)
 create mode 100644 include/net/dropreason.h
 create mode 100644 net/core/.gitignore

-- 
2.36.1

