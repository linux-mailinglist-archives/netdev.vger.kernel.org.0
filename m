Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE1442532
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhKBBju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhKBBju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:50 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA83C061764;
        Mon,  1 Nov 2021 18:37:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r5so13529244pls.1;
        Mon, 01 Nov 2021 18:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6qQ3h1Ch302HJfYHQZAmeh/lV7bJkSJ8DTpxUDtbRQ=;
        b=SJaDpOCewOOjGg/r8lShV9rtFcKbN2ng4rqtZtUVCnOrLZQjlmH79l1ew4hKFz9vYb
         DsnXhz5ISu2x6LgJVtVl1jrfIIOK687firrmhUsyw7WOr24Dk4dE8JL3aWZODoG1cOLg
         TJxohpgH0fVXkcA9pmD3ni6WreeTiysGy6vtXamNfhkpoiNlxYUMcf/09C7iBD04OBCN
         h/XusuvW0IEg1En9RxWDi7ysY0dPwOukxejb1XFGfGYfITGjwUy+gtVH4WVCoWp3dnmJ
         q4EUlheyg2PbU1XA9jTKsJDkTS0a9GljDvA5FIygEpDfe50Zqxz0PtJVdNL1Azvi4lxO
         huGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6qQ3h1Ch302HJfYHQZAmeh/lV7bJkSJ8DTpxUDtbRQ=;
        b=6iokPTiY906KjI3+3erDvSYwhiinrMLErECr9V8SKyT39zsBSd8L9F+fd9BbFHkur3
         ynI2s1XK3/V/YdTGAjx8Q/uk1mlD37/n+45beGgA7Jr9CCV4MsvJ6CugnAUhUFaEzrGY
         X+WVx1bwlnCYNn+ffQbZiaXud61711f2dJNi5Ipt9v10oYGeQN2Uc8xMWNOK8RETuowR
         J2bOl/fr/82yan4/HbgBHLEq+f2PrsOaEiQrWhP40pYs5rg/71Lya5RPBfWL62N0BYux
         sYVge2KarfKBuXFk+2gUZYfjgwKbHIpfDkCWeTlQV/amKEmiLU7rfAxWZgz+D1uhrPF9
         aiog==
X-Gm-Message-State: AOAM533kBNjmtUGhmDVAG1pqhqv0DCBUuK8kL9sjoWHGHJJoRx5FmZHD
        lSuZRXNp47dE2U0c9/CO3X3wy7HIQtM=
X-Google-Smtp-Source: ABdhPJywnvT3F0io2V647GR5Daz42BUH7K08OC9Bl0qJazYleaDmZXudY2vBZzhmy7/0W1tNpbnfmw==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr2923835pjp.167.1635817035769;
        Mon, 01 Nov 2021 18:37:15 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:37:15 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/5] kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
Date:   Tue,  2 Nov 2021 09:36:33 +0800
Message-Id: <20211102013636.177411-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the include file
setup_loopback.sh/setup_veth.sh for gro.sh/gre_gro.sh are missing as
they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Fixes: 9af771d2ec04 ("selftests/net: allow GRO coalesce test on veth")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9b1c2dfe1253..63ee01c1437b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,7 +28,7 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
-TEST_PROGS_EXTENDED := in_netns.sh
+TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

