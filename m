Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9422022F504
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgG0QZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgG0QZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3F3C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:35 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id u64so15747221qka.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m5DzJ04b+qhQahsqmfTaxAY0iHnSOC2jYlCiJV6WF3c=;
        b=JpcSObJEljSz2WXAgdps3mzMKyFADKPCxhJbQxzYys5/9IAAwzWeYlKulmowFPMM8i
         AytDK3L9jODH5NkhDefy3gvAcAigeP/xTBBITON3fQtlFS8J1NgxwnfRirpMj2XlVaBZ
         8ASP85hG77xgQiAYT5bR22xWPk4xsVOTb53NOQUOGGJxlhu0FVqdGwsJAhLIup9eU6w9
         hH58U60HRz4bDqCC8VstJsi08+2BCQUL27vNxRE3cPt3JQyjV4wYnnheicBXfAZxh8Cv
         Mpd77w+HGJVlaZASeVb9KYYcPbyZz2UHsDda35FtQmA39zyyxFRVm3/h3y+0Iq7ktCSK
         88Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5DzJ04b+qhQahsqmfTaxAY0iHnSOC2jYlCiJV6WF3c=;
        b=JEYDh8Eg7OWyPoec4A07vDq2slv0/6SEDXSfBaZk7QjUyHpx0exJDfqUVXQwrpIaLA
         WQMjBPTaVlc5VZpnsyt3xieLHrT7AGnx6nd3Se0gIiv8OSc1lJwH4jdWmhAdYZD5eGzH
         H+/W+PJ9i28DazPUYc7jJnVOjpvimCW1dSVQHTqSuabFZ/YIobQsawnRPhF1MHqFTYo1
         iOJRVwm7UTiBaThQhlAQnE+Pagvlu8EnkENAbNsRDgRKJXw3gUnMdGsP45JqOQ87pJLH
         uH2Tez1sf9UGXxSzT8JPweKOaKFlLBcZzPhphmK376pNl8GwhQr9jwlH+S2PvKQtu/1U
         6qdg==
X-Gm-Message-State: AOAM532brglmxdBv1vSY1hF9bIpSf1DdlmO/l6N5a6IZnVnRErOepVS2
        ulQmMdbojaE2jb28sskf4gnYeMxn
X-Google-Smtp-Source: ABdhPJwOZKUPq93Wr3w6v62NYG6pl+oHcTeUiEjJmDYoHDkJ4vdjqcY4YS5pjemg0oTdJBBw7Ju9vA==
X-Received: by 2002:a05:620a:2298:: with SMTP id o24mr23310181qkh.73.1595867134888;
        Mon, 27 Jul 2020 09:25:34 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id o37sm16764529qte.9.2020.07.27.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:25:34 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 2/4] selftests/net: psock_fanout: fix clang issues for target arch PowerPC
Date:   Mon, 27 Jul 2020 12:25:29 -0400
Message-Id: <20200727162531.4089654-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
References: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Clang 9 threw:
warning: format specifies type 'unsigned short' but the argument has \
type 'int' [-Wformat]
                typeflags, PORT_BASE, PORT_BASE + port_off);

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 77f65ebdca50 ("packet: packet fanout rollover during socket overload")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/psock_fanout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 8c8c7d79c38d..2c522f7a0aec 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -350,7 +350,8 @@ static int test_datapath(uint16_t typeflags, int port_off,
 	int fds[2], fds_udp[2][2], ret;
 
 	fprintf(stderr, "\ntest: datapath 0x%hx ports %hu,%hu\n",
-		typeflags, PORT_BASE, PORT_BASE + port_off);
+		typeflags, (uint16_t)PORT_BASE,
+		(uint16_t)(PORT_BASE + port_off));
 
 	fds[0] = sock_fanout_open(typeflags, 0);
 	fds[1] = sock_fanout_open(typeflags, 0);
-- 
2.28.0.rc0.142.g3c755180ce-goog

