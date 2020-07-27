Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540BF22FB24
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG0VPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0VPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 17:15:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93377C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 14:15:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u185so9795524pfu.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 14:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xf1mp9v3smicX5AYm19mph//4+F5RfkqEmu5vtEwv60=;
        b=G/zLqIFgP5NaJ0HVptnivLLAblRV/lCJEonhl0WhakemS62QaqtcS1JlNoUaxLM7jg
         ox+0wC1dIU5kB94RWhaKbrMNlauO0hjib7FB0j7VoKcma1kMK0jIZb5+V3OIJHMa/tyT
         UF2JygFUqshi0dfaErY5P0mOkJ1J97jdp9vwtcrGpPwkYLYOzsi03SQVfQ5LBtElMdSa
         qshVOJVlv2C3VSY/ZUzG5FANas6rmERZxrQcQMlOrC39Z0gY3ecpblCcEkaQzM4fWXOx
         9HsUs9IUm0h6S+qErESrKsDaeGsGY9pJsVxLm1jaJAkdGoocouTD8Qb3HX7f/iXMl2vA
         0opA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xf1mp9v3smicX5AYm19mph//4+F5RfkqEmu5vtEwv60=;
        b=nQOTDGScZHiu/789PF29C6E3PnJwdu9bW9UNZ9oa4sPvje/4XVtBxB3VnBgjJ/FG0M
         Xd+jN05wWUIAjzvz0loYZLDNVZ9ADy4ew8K1+8zfh4/tMGGcdP6YJPFRTE/Oyv9cgOBF
         9yjW4fsQD2lSBwu9iaS4S8NJZAzDBq/Apb7h9m8kCkKB8P1UxzmeqXdf3NMLrXaULvao
         CAnJv3mE3b4aFj+JYNrKyzDWDGP6opltifeg8TClUyUhS+K5aKVT5fUPnmnqyHnBg0sx
         yd0z2lK9jm/HISPPAwld+xxJfAOQ7057bPp1tMeN4GActiTqNin5w2L+49obGseJbHm1
         u36g==
X-Gm-Message-State: AOAM530PrfpjfwPOPumdZIDrsNk4GpfxPSXNwr5Cy4KE39qyBrIP0zKJ
        CibdrgXaPB/Q8e9kQdRG0oc=
X-Google-Smtp-Source: ABdhPJxtKav3ob2y7sPMMAQTmBc4kr6VL2TwAvXUCst1igDrmN5We7ETE/YAUsKcx8RzwrZDL39JIg==
X-Received: by 2002:a62:d417:: with SMTP id a23mr22665425pfh.56.1595884508065;
        Mon, 27 Jul 2020 14:15:08 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef8:759])
        by smtp.gmail.com with ESMTPSA id y19sm15420123pgj.35.2020.07.27.14.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 14:15:07 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next] selftests: txtimestamp: add flag for timestamp validation tolerance.
Date:   Mon, 27 Jul 2020 14:14:38 -0700
Message-Id: <20200727211438.2071822-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

The txtimestamp selftest sets a fixed 500us tolerance. This value was
arrived at experimentally. Some platforms have higher variances. Make
this adjustable by adding the following flag:

-t N: tolerance (usec) for timestamp validation.

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/txtimestamp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index 011b0da6b033..490a8cca708a 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -64,6 +64,7 @@ static int cfg_payload_len = 10;
 static int cfg_poll_timeout = 100;
 static int cfg_delay_snd;
 static int cfg_delay_ack;
+static int cfg_delay_tolerance_usec = 500;
 static bool cfg_show_payload;
 static bool cfg_do_pktinfo;
 static bool cfg_busy_poll;
@@ -152,11 +153,12 @@ static void validate_key(int tskey, int tstype)
 
 static void validate_timestamp(struct timespec *cur, int min_delay)
 {
-	int max_delay = min_delay + 500 /* processing time upper bound */;
 	int64_t cur64, start64;
+	int max_delay;
 
 	cur64 = timespec_to_us64(cur);
 	start64 = timespec_to_us64(&ts_usr);
+	max_delay = min_delay + cfg_delay_tolerance_usec;
 
 	if (cur64 < start64 + min_delay || cur64 > start64 + max_delay) {
 		fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
@@ -683,6 +685,7 @@ static void __attribute__((noreturn)) usage(const char *filepath)
 			"  -r:   use raw\n"
 			"  -R:   use raw (IP_HDRINCL)\n"
 			"  -S N: usec to sleep before reading error queue\n"
+			"  -t N: tolerance (usec) for timestamp validation\n"
 			"  -u:   use udp\n"
 			"  -v:   validate SND delay (usec)\n"
 			"  -V:   validate ACK delay (usec)\n"
@@ -697,7 +700,7 @@ static void parse_opt(int argc, char **argv)
 	int c;
 
 	while ((c = getopt(argc, argv,
-				"46bc:CeEFhIl:LnNp:PrRS:uv:V:x")) != -1) {
+				"46bc:CeEFhIl:LnNp:PrRS:t:uv:V:x")) != -1) {
 		switch (c) {
 		case '4':
 			do_ipv6 = 0;
@@ -760,6 +763,9 @@ static void parse_opt(int argc, char **argv)
 		case 'S':
 			cfg_sleep_usec = strtoul(optarg, NULL, 10);
 			break;
+		case 't':
+			cfg_delay_tolerance_usec = strtoul(optarg, NULL, 10);
+			break;
 		case 'u':
 			proto_count++;
 			cfg_proto = SOCK_DGRAM;
-- 
2.28.0.rc0.142.g3c755180ce-goog

