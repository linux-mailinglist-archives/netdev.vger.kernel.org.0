Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E65443DA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiFIGew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbiFIGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D5C3AA42
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g205so20252424pfb.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXHe682qxb99LehCpjB+F9buG2tUtQQhdUB4QoqRzoo=;
        b=FsLxodBjjbi6jYx8bETl7Wi6ja+9KCLgujuxRa+DGWnIO8bUJ477SqdRV/aUNyKIwj
         M0bQdTnWuKx/uR5Jk5W0pG2xPFlsVXBPv/eeAjA/Ost+GqiTKIwMWEGx1yiWzncBmSnS
         W50AqnuKyZkhSEUl9cxVL4ENiuQFbdaO8TV2YL+G6tW3diJW69EOGVj06WTdrZAenh+g
         yQlOkxwPnFcm+SXofd6RM1D2HwCQ79ARXVxwUNFam1MeAJ+RE+DFPQIKxG0d+lk7h54O
         pn+zNlhcH5e/c6CxFC/YYZBK5HIDjF84y1ezh/0/w65PP5e4NT6wmDIelREcdq8bLy3e
         AOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXHe682qxb99LehCpjB+F9buG2tUtQQhdUB4QoqRzoo=;
        b=yAFKeCrzsTKWmwnGbKEOWEWJ1EZRDQowIH2FM29hrF2UlnATAWX1jIRDVCRaFQTFXn
         THMlG8c4GnyFD7GW0GZDcjicD8mV0HedZepU/Hcc84dm53HFVjPtv7jFOHKRayzhQ4St
         KEYYbrPiq/I37wrDR678r45npnN31KptuWPm96u5e2UMN34ha5nQJ+fYHRRf0B/PSuYV
         heV+c1GEIESaBQGqnVL87odx7YxELgPMC3WWgEBnQufAuJDAVhYD/NqMHhf9ERae67Hu
         8ZxP4xRoEwpZR9ZEQnKF8ml+yDx+luoZjOJqhsCv0jXWIro/rs7RvjjJVaVFMOAsUah8
         UZTw==
X-Gm-Message-State: AOAM531tnonfrXFSKpdQrUjDOylpbdHKUywLREPBXvItlSAhUkeqmBZE
        UzXQj7Qu/c8sv3yhYcchiQg=
X-Google-Smtp-Source: ABdhPJyW+DKbWB18MJlsg2SQf9yigWTiX4+LCHGmQKi66LAdwPXZHc0XFRn/N3O8fF5PoLKqpQwSYg==
X-Received: by 2002:a63:c00c:0:b0:3fc:dc35:6192 with SMTP id h12-20020a63c00c000000b003fcdc356192mr32444806pgg.7.1654756468910;
        Wed, 08 Jun 2022 23:34:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 7/7] net: unexport __sk_mem_{raise|reduce}_allocated
Date:   Wed,  8 Jun 2022 23:34:12 -0700
Message-Id: <20220609063412.2205738-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

These two helpers are only used from core networking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3bb406167da93b7526ff85787b89fa65e44dce8b..c911013bbdf7670ac55a559580e68f3d57c20200 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2987,7 +2987,6 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	return 0;
 }
-EXPORT_SYMBOL(__sk_mem_raise_allocated);
 
 /**
  *	__sk_mem_schedule - increase sk_forward_alloc and memory_allocated
@@ -3029,7 +3028,6 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
 }
-EXPORT_SYMBOL(__sk_mem_reduce_allocated);
 
 /**
  *	__sk_mem_reclaim - reclaim sk_forward_alloc and memory_allocated
-- 
2.36.1.255.ge46751e96f-goog

