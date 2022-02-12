Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314694B36C6
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 18:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiBLRO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 12:14:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiBLROz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 12:14:55 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02196240A6
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:14:52 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m22so2533636pfk.6
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=84mi4sLZdI2m5nZb9aKeXn47eOTNcMjjceH3JrENpfA=;
        b=D1fo4FZcekytY1ykZ6KutYWYi4KcPkuDtWLBJuhG9KnuEPMOMP5iMk0V0k7gTGlfm/
         YfXo9kXf3qYGek+2cN2RUK45TiDfzvbiKAuGn2sKhH28qFUUwxUuOSks6wOjqXMcVajy
         hejgEGHo4uYczkQKP1hNC0hmJ6yAoB97pUSs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=84mi4sLZdI2m5nZb9aKeXn47eOTNcMjjceH3JrENpfA=;
        b=CqJXNeXOvtj4sTA1r2Eyop8XBYLVO9zot3dsUJBb7sehzXp9YhQiOfqzXEt/39xH9l
         3Ju2wbMEOdttHHWPl/baGHPEzkxIX3Q1DCnC8AMelWPR7vZA4eVFOjn72HtcbNLfMQhI
         qsMZfR9LT1NC4ZOf5qJEv5AOaj8t7m89mXAH5yVQ83qkTAg5VhhAQzCiRFIIR8lVCpSc
         Zjq1y6rGM8UQYk1nu9misurNc0+jkpaqWDAXRQccBtVnhE+6R1tbudThUcaLk1cYfNqA
         epqz44t0QIkSjVjcFvHTRnneHvQeJwU0brOyZLQrx3jSR9nDa6LS7kJ+kzbQstc0hb3r
         iaHw==
X-Gm-Message-State: AOAM530kAfUxPcFGDQEvGV56frB8z5E6NV/DoKiChx5AglMj0L4TntG9
        FaEP7hTnJkmXs9e/GzC9BegASw==
X-Google-Smtp-Source: ABdhPJzUu40GXOLbD0dD0jWT1NYlbt8YUZ19HsUk/i+9HXc+CU3hO289jMej1GMKD1Amt0ktiMcrAQ==
X-Received: by 2002:a63:6116:: with SMTP id v22mr5486761pgb.474.1644686091427;
        Sat, 12 Feb 2022 09:14:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ls14sm6239286pjb.0.2022.02.12.09.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 09:14:51 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
Date:   Sat, 12 Feb 2022 09:14:49 -0800
Message-Id: <20220212171449.3000885-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2660; h=from:subject; bh=eVRNZb9+/scN9PRdT1Roirs8n4TTSE7XSUI757xJXEg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiB+sIVUHseDW+2l3grw1ne1EWyqjHGcHHhXf+atvk CB/an1KJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYgfrCAAKCRCJcvTf3G3AJhs7D/ 443r8N7ZVCj+oC03dpcpCQpU9ac1ACqyZ9F+kU1vzi/Xba89SWTuaXrLQigr/9sinBhdsw9U4c9izS aErYdxXKko/9gLWHfjefU7EGgD1oyxii6K3YT0dwZnu2jPZ4RCzEqX6S1Y8D3gmWgSOEVLi7w/CA6J AAZ9WaQFEAyRbMyxm7XuT136wmilqpdt4+iH7jDoN4erjeF8FKU//m7GmVdaw/w8cDTz0+AEbZWZMT X5I65NUIHLa+ERT7uJ4qnwpM5OsJlmL/Ihat1ZPJUTx/Pxge3a2L8qOyhVPGfLR/1BkGRtAd3//c/d l5fzHgSW7tzHcHVy8p8v+v83q0wYHVcArkUlH+R8CjC0Knkgfxk+gDMeN3sz7YkR3/a35EZbYAunOb 6IpS8dCrMgiUgFNMyCToj+9TpLFSO29VUqXUuvfVl2/Ksw95IZdDpwCoibGjpQ5OvAz22wYwyH1ku3 HJQ6RlcUbjWbSuGFlyrBPc+PcNsDGm212Kld6//3CK/expJ6WlcO+xIrfMWyVF35bIyOwSQfE3LXVm 1LUW6E8SNahsfuMGkz4sXWwW4vOruDhb0WYccJqyQmOWqwiFscTaYcjYTXWvT/RhnM2DKBldJbpRzJ d68iGuY4StYQpqQnIRKBRmpfIj1bUfGW56ZDNNN8SGhojG/yZzXZJaEmW4Yg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With GCC 12, -Wstringop-overread was warning about an implicit cast from
char[6] to char[8]. However, the extra 2 bytes are always thrown away,
alignment doesn't matter, and the risk of hitting the edge of unallocated
memory has been accepted, so this prototype can just be converted to a
regular char *. Silences:

net/core/dev.c: In function ‘bpf_prog_run_generic_xdp’: net/core/dev.c:4618:21: warning: ‘ether_addr_equal_64bits’ reading 8 bytes from a region of size 6 [-Wstringop-overread]
 4618 |         orig_host = ether_addr_equal_64bits(eth->h_dest, > skb->dev->dev_addr);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/core/dev.c:4618:21: note: referencing argument 1 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
net/core/dev.c:4618:21: note: referencing argument 2 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
In file included from net/core/dev.c:91: include/linux/etherdevice.h:375:20: note: in a call to function ‘ether_addr_equal_64bits’
  375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
      |                    ^~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220212090811.uuzk6d76agw2vv73@pengutronix.de
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/etherdevice.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2ad71cc90b37..92b10e67d5f8 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -134,7 +134,7 @@ static inline bool is_multicast_ether_addr(const u8 *addr)
 #endif
 }
 
-static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
+static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 #ifdef __BIG_ENDIAN
@@ -372,8 +372,7 @@ static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
  */
 
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 fold = (*(const u64 *)addr1) ^ (*(const u64 *)addr2);
-- 
2.30.2

