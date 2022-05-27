Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3AC535A2C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345200AbiE0HRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345573AbiE0HRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:17:35 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3537113D3F;
        Fri, 27 May 2022 00:17:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p8so3636920pfh.8;
        Fri, 27 May 2022 00:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NviM8YCLlg4DLE40qfgZoF5jztBopf1R1io4p6exy/k=;
        b=Y144HOXVIkomyQ45cz7z/XsKIC2bYEIvqqrO6SDnFxcGZMFcHVqLMFsOnOfPzlAsl3
         uvi7AQbOFsD7ep1S1fBcLMbKYW18jgvK0oN8RUpGks5RjOAb9SScnt2jL0jymAsejv5D
         I+r407kkGvCYivG3iXt7kU82h4m0xe/sziATw1h8EObfDQnT+XneYaFJDk9ogl5HAoH3
         YQpOh4Up4NqtTqMNEwuMRoqyE4bitDf59XIcCPQmnfpoWdnxGAhHbShoGVFcw6C+fxqx
         Ehc+aOKaEq6zg0MX7KizIu8Pg6CokqCTeLtsBvEbcom/e/3/OFC4a43W3pn8x5xe0NnI
         udWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NviM8YCLlg4DLE40qfgZoF5jztBopf1R1io4p6exy/k=;
        b=Fc/TLoy5HF5eIslr70OgP/eaViJxta7NmJoZGk1pwzAoVa9+pxd8rsYridIHXpjXCP
         PxU89VQFXSVAjIN/N7tTSZ518MXpzUmmcIRug08sNSYWOshm2fGopxugTExW7XGDcJ3q
         /e3QzHtRSFkw3ww2/k8XAvcYW7Ur5iy7MKMc/DkIPAFjiYkuiMq/22UwNgK2PuTzgIdx
         vZ4ehV5wNFwHY2cc7Fm5D9eI75vtbEZ1kteegKuTY0FccBrhArLbVTXa++PX8kq8l8pp
         FGvpT9EFLaBrINDNKma7zXvzQcKLWysh/TURASBthksg2L/POgSnhHmMh2rZZbvgRybr
         JKvA==
X-Gm-Message-State: AOAM532LUb/DZJ4tfi65lNH8TmqOrN+uv0fNdtrouql4VP2hOOsmzQZQ
        Spz8PoMszP6l3Wxd4gqKX4w=
X-Google-Smtp-Source: ABdhPJzSsPpWp33M6JEVHJFs9PCoC0ND8Lham6rSx+MvvTMg2mD0cWU+9ABJLDc/cSBmGVBris1jpQ==
X-Received: by 2002:a63:d054:0:b0:3f2:50df:e008 with SMTP id s20-20020a63d054000000b003f250dfe008mr35984784pgi.317.1653635853734;
        Fri, 27 May 2022 00:17:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.15])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709028a8b00b00163247b64bfsm2805577plo.115.2022.05.27.00.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 00:17:32 -0700 (PDT)
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
Subject: [PATCH net-next 0/3] reorganize the code of the enum skb_drop_reason
Date:   Fri, 27 May 2022 15:15:19 +0800
Message-Id: <20220527071522.116422-1-imagedong@tencent.com>
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

2) use auto-generation to generate the header that convert enum
   skb_drop_reason to string.

3) make the comment of skb drop reasons kernel-doc style.

Menglong Dong (3):
  net: skb: move enum skb_drop_reason to standalone header file
  net: skb: use auto-generation to convert skb drop reason to string
  net: dropreason: reformat the comment fo skb drop reasons

 include/linux/dropreason.h | 195 +++++++++++++++++++++++++++++++++++++
 include/linux/skbuff.h     | 179 +---------------------------------
 include/trace/events/skb.h |  89 +----------------
 net/core/.gitignore        |   1 +
 net/core/Makefile          |  14 +++
 net/core/drop_monitor.c    |  13 ---
 net/core/skbuff.c          |  12 +++
 7 files changed, 224 insertions(+), 279 deletions(-)
 create mode 100644 include/linux/dropreason.h
 create mode 100644 net/core/.gitignore

-- 
2.36.1

