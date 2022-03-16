Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20C34DAAB6
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351336AbiCPGdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiCPGdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:33:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808835A0AC;
        Tue, 15 Mar 2022 23:32:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q11so993581pln.11;
        Tue, 15 Mar 2022 23:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MYNgZuT9RwosGy33P4OxF/lMtZK6sphhDQVtouX96JU=;
        b=XPtlfzPWrrM++bQMfhGUumNLM3Ba/M1Eb0yT5H9F4OIMLQGo0ZRCmC8x1z0dcBmj0D
         KN1wDaLh/8+96sWfXOtlhZf3C9+fcL+DvT5Aj6kXId935GRs630nh0LbQrn9EVBmkGJM
         w16nLGbdr2czIDwnqfznPf8xQVVAxbzSJuwfeWgJ1Xr9DyCq2wmmgBPPYuKgdQ8LuI7q
         x26Xqeq5IpSbFZJIMx1N+qJyh3OFYo4qS7lIBxWFLWIms0TBw+8acehjdoWDQGUAr41s
         PKEcg5Ha+ZZw+7p27IMuJHTC9B8BYp3ExkvyXqggtxQAdM8isFSv12F1XNu1UYlYgx7D
         Eg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MYNgZuT9RwosGy33P4OxF/lMtZK6sphhDQVtouX96JU=;
        b=osZNC6bmm7WkJl1WE2KP5aCaIwquzxKBGmUiPRv+helvWfy1ZAhKrZS6VzXB31X8pv
         63TiQyPxls5u6svsgj9POx95KYr6jL0qklY4MX7ELryDxSBCTAnbfUzcoGFZ/FMuUq1W
         29DqLvrsV+e6MZEJb/zNwBw+bn2Ei55kdZWpXHthpdaL52xx0mAW67NjGTkDJBa/Q1kA
         ZFXhCjYvT0bHFDCI2+ixyh3PqO/InKk59mUq1xaDxs+jvT4Vsd4IN0Tvp7XT+hkyqaRZ
         vKGqhQ6wXpR4CpKeIi1+toqyNxUJmWx04oEpXttO9kKerB591BzfDasK3MS6Dk8+HieL
         x6KQ==
X-Gm-Message-State: AOAM533ivRRALR8TQcm2EHv/elNw7HDVpCbLsBonEd3Me0yuK18ezYU+
        WugGTtJMQFn20/C6bl1VBOk=
X-Google-Smtp-Source: ABdhPJz2KghKbw9h8XB9jTdEvhauCdmDy7nbhFcVvWkcDXfoWZxf3TnnrYR1H4MbWOAuzU3aLspdVQ==
X-Received: by 2002:a17:90a:1db:b0:1bf:711d:267a with SMTP id 27-20020a17090a01db00b001bf711d267amr8569691pjd.155.1647412352040;
        Tue, 15 Mar 2022 23:32:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm1438314pfc.190.2022.03.15.23.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 23:32:31 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH net-next v3 0/3] net: icmp: add skb drop reasons to icmp
Date:   Wed, 16 Mar 2022 14:31:45 +0800
Message-Id: <20220316063148.700769-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
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

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
we added the support of reporting the reasons of skb drops to kfree_skb
tracepoint. And in this series patches, reasons for skb drops are added
to ICMP protocol.

In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
the function 'sock_queue_rcv_skb_reason()' is introduced in the 1th
patch, which is used in the 2th patch.

In the 2th patch, we introduce the new function __ping_queue_rcv_skb()
to report drop reasons by its return value.

In the 3th patch, we make ICMP message handler functions return drop
reasons, which means we change the return type of 'handler()' in
'struct icmp_control' from 'bool' to 'enum skb_drop_reason'. This
changed its original intention, as 'false' means failure, but
'SKB_NOT_DROPPED_YET', which is 0, means success now. Therefore, we
have to change all usages of these handler. Following "handler" functions
are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following drop reasons are added(what they mean can be see
in the document for them):

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_ICMP_TYPE
SKB_DROP_REASON_ICMP_BROADCAST

Changes since v2:
- fix aliegnment problem in the 2th patch

Changes since v1:
- introduce __ping_queue_rcv_skb() instead of change the return value
  of ping_queue_rcv_skb() in the 2th patch, as Paolo suggested

Menglong Dong (3):
  net: sock: introduce sock_queue_rcv_skb_reason()
  net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
  net: icmp: add reasons of the skb drops to icmp protocol

 include/linux/skbuff.h     |  5 +++
 include/net/ping.h         |  2 +-
 include/net/sock.h         |  9 ++++-
 include/trace/events/skb.h |  3 ++
 net/core/sock.c            | 30 ++++++++++++---
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 32 ++++++++++------
 net/ipv6/icmp.c            | 24 +++++++-----
 8 files changed, 121 insertions(+), 59 deletions(-)

-- 
2.35.1

