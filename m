Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5573F3788
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhHUAU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhHUAU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:20:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B5CC061575;
        Fri, 20 Aug 2021 17:20:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id bo18so8491172pjb.0;
        Fri, 20 Aug 2021 17:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bkWcWmTFBhQV9/CAyd9JfTTjSJHtCH0QNQTM/GbGUg=;
        b=KwJpziGyMsGWNs31+st3g5lNsUAoNwH0BHdPOlyGI9MFkw+AcJiECwtWiqKOmQECB0
         sbmHUjRU6DVGkkkrS/X+NToglUvWc7agKtCvYIPwm8/GixQMcZzA17QcCAIm8SkkclOq
         7fqF6dB83J/2MOLMN9idG/WLZkG/ZX47Sa6ASk10odVh0I8HoFkDEvTftkhicmO4kypv
         cyTir9Am1p/9QhCyosRYFio6thVxUn7qxsqrN1HEK3mUEIPkugjLe1Ir60BBOFMn1k2w
         sSL3l4YOstSoFlsLk0FS/U1ntJxUlFXNBkPHe43E9d4duohLisA/j6Za09UX5dRiI2DK
         JMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bkWcWmTFBhQV9/CAyd9JfTTjSJHtCH0QNQTM/GbGUg=;
        b=FUinkktqrzgEuGTWB6BBsOE3UsE0wBcw3YFg6v3eYMrFFYYd5Dr90Ig10o9QObA1tx
         vRFwSD1Px1TBxSBumzKQRZlgzxZKWG4/VRqIm33orjh4qWRJjiBIxg2XQNSBi5ZazhP3
         H7yNhIEIEVrBZ3Po/r2M/4S/6Jrn2H35hrATcQ61RYYZNsWZAUgAyZ+zpNHrMoUm/pVv
         P3AmvwrYBiYvnFnmr7Rh2uTfGMu2DYknxaQmBopdJumJ7ygYl8RRaLfKCTh+F92L/r2q
         FqQHyTudxTO4cCnjQx1WR+y78+7rKfE03H4V+8B5GKH0eCPpVxO7/COUFRYnlmpr53pS
         JrjQ==
X-Gm-Message-State: AOAM530gY3QYHrghWg3watgXuuouyVg/eb3bqqDztp31AnmbANGlUVvC
        6pLmk+12VcvFvm9cwJJkzI4sBhKPQCQ=
X-Google-Smtp-Source: ABdhPJwzJlKHbKuvn3ob/gANa96MOhspEBIOvjjZ1/e/jQf0Z2NWS2jUXiWeWCvrtkX2V0Q+c9b4jQ==
X-Received: by 2002:a17:90a:7141:: with SMTP id g1mr7328616pjs.142.1629505217003;
        Fri, 20 Aug 2021 17:20:17 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id x19sm9491570pgk.37.2021.08.20.17.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:16 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 01/22] samples: bpf: fix a couple of warnings
Date:   Sat, 21 Aug 2021 05:49:49 +0530
Message-Id: <20210821002010.845777-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cookie_uid_helper_example.c: In function ‘main’:
cookie_uid_helper_example.c:178:69: warning: ‘ -j ACCEPT’ directive
	writing 10 bytes into a region of size between 8 and 58
	[-Wformat-overflow=]
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |								       ^~~~~~~~~~
/home/kkd/src/linux/samples/bpf/cookie_uid_helper_example.c:178:9: note:
	‘sprintf’ output between 53 and 103 bytes into a destination of size 100
  178 |  sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  179 |         file);
      |         ~~~~~

Fix by using snprintf and a sufficiently sized buffer.

tracex4_user.c:35:15: warning: ‘write’ reading 12 bytes from a region of
	size 11 [-Wstringop-overread]
   35 |         key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use size as 11.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/cookie_uid_helper_example.c | 11 ++++++++---
 samples/bpf/tracex4_user.c              |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_uid_helper_example.c
index cc3bce8d3aac..54958802c032 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -167,7 +167,7 @@ static void prog_load(void)
 static void prog_attach_iptables(char *file)
 {
 	int ret;
-	char rules[100];
+	char rules[256];
 
 	if (bpf_obj_pin(prog_fd, file))
 		error(1, errno, "bpf_obj_pin");
@@ -175,8 +175,13 @@ static void prog_attach_iptables(char *file)
 		printf("file path too long: %s\n", file);
 		exit(1);
 	}
-	sprintf(rules, "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
-		file);
+	ret = snprintf(rules, sizeof(rules),
+		       "iptables -A OUTPUT -m bpf --object-pinned %s -j ACCEPT",
+		       file);
+	if (ret < 0 || ret >= sizeof(rules)) {
+		printf("error constructing iptables command\n");
+		exit(1);
+	}
 	ret = system(rules);
 	if (ret < 0) {
 		printf("iptables rule update failed: %d/n", WEXITSTATUS(ret));
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index cea399424bca..566e6440e8c2 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -32,7 +32,7 @@ static void print_old_objects(int fd)
 	__u64 key, next_key;
 	struct pair v;
 
-	key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
+	key = write(1, "\e[1;1H\e[2J", 11); /* clear screen */
 
 	key = -1;
 	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
-- 
2.33.0

