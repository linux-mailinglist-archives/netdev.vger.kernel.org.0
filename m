Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAC539D7B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349947AbiFAGy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiFAGy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:54:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C1A49253;
        Tue, 31 May 2022 23:54:26 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so5282699pju.1;
        Tue, 31 May 2022 23:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vr5c2xUPPCzrWHyA1+m2wz+QOmZ7J+gQxTkYWDKocB4=;
        b=pia0/JspGKwQoJCV1pBp/WXTXpCKH71LKwf0Q0YWoly2V42dcqvhXrwhsb8NbXtQ9j
         869+MgNYaMMZu/eerbDusEiEOJp48EAQ2SvafYSOJF3PEOZZCHdgkkylw1lGfcyxxBfX
         4ztQu2/KjB8hnsT7wLsLwmSSpmR9Vf1RK1v+0uaQc0rdzf8W2ABkQc0/UlWCIkqFahK8
         X7pfxyoxYxVcYxYJUwnTzGAE1QJIrFzGbPn9U2iLZbxvJFRkp0LT2cKHN1hrdzuIrCf5
         Pxhaw8iHC/duR3Omiz33jnChruU/hw2WVDdFGsrgR3acsxyNnxK1CNgyz6sHgPwg10eO
         TJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vr5c2xUPPCzrWHyA1+m2wz+QOmZ7J+gQxTkYWDKocB4=;
        b=XXpHqhemXLuZHM6D7mewSzVd7t+RrqzXQQDOL7xegr2J0iZWMK+PJeozURrjAVxgPZ
         T4ZYixgkSvPjlSYYdnEqr/OtOElsTXlY2b5Rhl4HtFmznVVkneeMkcf1PfyYEK3yP9Kg
         tnuSQkzoUCNqYDHLbH0ztcrlgb457uwrX+nHhYkG6pKWDSqVv7XCxmdBqUqCE3ZuxiaJ
         ZwpWY4kv05Mo5RkpLSDmYUzlshzhkZS99SVGSKGMoxATZvLWu0TOSY7Cyl1LvW5kdPtd
         UG8tsvNdk8oXOCFWFYDo2Oufui5RNlCq+K6l+iRo+i2ADjpRs7z9F2MpyLOYH8g+OukU
         i2aw==
X-Gm-Message-State: AOAM530R4aIVDGesAnaTYb7GESpOq41m9FtnUIkpjecSimOpsm0qFpFQ
        YpD8EIxgAWuzruh+hohtytI=
X-Google-Smtp-Source: ABdhPJy6Rlb+wvYRaHxSk4DE+e3ykIzInQapeRgnxaEtQB7kWqQBNMzrdigvD6n/9GImBr8Mq1Ffuw==
X-Received: by 2002:a17:902:e881:b0:161:bfc2:c52 with SMTP id w1-20020a170902e88100b00161bfc20c52mr63401807plg.75.1654066466351;
        Tue, 31 May 2022 23:54:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b0015e8d4eb276sm671460plg.192.2022.05.31.23.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 23:54:25 -0700 (PDT)
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
Subject: [PATCH net-next v3 0/3] reorganize the code of the enum skb_drop_reason
Date:   Wed,  1 Jun 2022 14:52:35 +0800
Message-Id: <20220601065238.1357624-1-imagedong@tencent.com>
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

Changes since v2:
2/3: - add new line in the end of .gitignore
     - fix awk warning by make '\;' to ';', as ';' is not need to be
       escaped
     - export 'drop_reasons' in skbuff.c

Changes since v1:
1/3: move dropreason.h from include/linux/ to include/net/ (Jakub Kicinski)
2/3: generate source file instead of header file for drop reasons string
     array (Jakub Kicinski)
3/3: use inline comment (Jakub Kicinski)

Menglong Dong (3):
  net: skb: move enum skb_drop_reason to standalone header file
  net: skb: use auto-generation to convert skb drop reason to string
  net: dropreason: reformat the comment fo skb drop reasons

 include/linux/skbuff.h     | 179 +-------------------------
 include/net/dropreason.h   | 257 +++++++++++++++++++++++++++++++++++++
 include/trace/events/skb.h |  89 +------------
 net/core/.gitignore        |   1 +
 net/core/Makefile          |  23 +++-
 net/core/drop_monitor.c    |  13 --
 net/core/skbuff.c          |   3 +
 7 files changed, 285 insertions(+), 280 deletions(-)
 create mode 100644 include/net/dropreason.h
 create mode 100644 net/core/.gitignore

-- 
2.36.1

