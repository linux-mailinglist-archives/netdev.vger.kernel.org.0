Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADB53DFAB
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 04:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352134AbiFFC3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 22:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbiFFC3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 22:29:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923E1205CB;
        Sun,  5 Jun 2022 19:29:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id bo5so11639799pfb.4;
        Sun, 05 Jun 2022 19:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5MRSPo2LMU2au8whrm6/ap69ATqtiqPRY+8IYbaTsN4=;
        b=Qbnz6zlcTv8r3+4N/i7vGr87pZSaOpX9C79HwHGWLzyDBus6J7G0Wzuym/1mlynGmr
         rSlJqUU2Xal1+QoOx/dnymJTvQUtEs6hm74OlAb/88XKQiqH2xgrVfLx8FP2b02EHNYX
         QFf5/g62JKNqf7Cct0X+TBGmbPOvJKLXq7590Z2DSHIygcuYKSIh/50xtucoFa2Op4lA
         Nt76fKvhaJlh/ElO692toyfMfwBrTF1BOZhLfuDTPHcfL2zJJFzPbOMHVjprFBzSA/3t
         i3OJhO28a2oryGF1qqbhzkDOlSAl/tn71+Qkr5BFaRQDVSfN+oUAMWuGWEwIgrTMQxR6
         1QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5MRSPo2LMU2au8whrm6/ap69ATqtiqPRY+8IYbaTsN4=;
        b=CuLnER91C/MhJNzmiWMIraG3wcvB65VjUAyEvzlOhxDqcZMk9062ji8+kSvTHvNMbB
         OCv8PIuysb891KYttKKiLipuSRKMYU1jm33je3WsCYsT6ROBBARaGZy3zElyCfNs1b/G
         VsDuk61/U/kP0WkozvvSACIpmCA4lRnsGDBN/tdO3XfTNN9flEc0BXdHQKclBeYWk4pZ
         X6Kj4uJX4Of4tEEZiMBUertlVaCp4bwy2c7Q5yrPeXv6HrnzgwEAk30cJh/kl0+r6YG+
         7Vwk5pMJbQlyW4EAdmFQMk295vpRMy0yknYg0NvmTpwjR6pAyFsdVn6s5OC9B07kK/uQ
         JUbw==
X-Gm-Message-State: AOAM531xqJrqfbB8vWGS58LiteTNHaCml2uZL1eHB8NJlxXyojfD7Gxk
        ZEhQERrN6xTaARElNUjw9e4=
X-Google-Smtp-Source: ABdhPJwYfhsVLjqLklnHuWKFE3wn5J5YchEj2hzgmdxGnnWmtW83W9BsyDUVULlu4RDayDoHwsna0A==
X-Received: by 2002:a65:6b8a:0:b0:3db:7dc5:fec2 with SMTP id d10-20020a656b8a000000b003db7dc5fec2mr18404105pgw.223.1654482560074;
        Sun, 05 Jun 2022 19:29:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.81])
        by smtp.gmail.com with ESMTPSA id ca16-20020a056a00419000b00518d06efbc8sm651656pfb.98.2022.06.05.19.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 19:29:19 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/3] reorganize the code of the enum skb_drop_reason
Date:   Mon,  6 Jun 2022 10:24:33 +0800
Message-Id: <20220606022436.331005-1-imagedong@tencent.com>
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

Changes since v3:
3/3: remove some useless comment (Jakub Kicinski)

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
 include/net/dropreason.h   | 256 +++++++++++++++++++++++++++++++++++++
 include/trace/events/skb.h |  89 +------------
 net/core/.gitignore        |   1 +
 net/core/Makefile          |  23 +++-
 net/core/drop_monitor.c    |  13 --
 net/core/skbuff.c          |   3 +
 7 files changed, 284 insertions(+), 280 deletions(-)
 create mode 100644 include/net/dropreason.h
 create mode 100644 net/core/.gitignore

-- 
2.36.1

