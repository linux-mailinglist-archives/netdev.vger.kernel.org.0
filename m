Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05772B3FF3
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgKPJf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgKPJf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:29 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55420C0613CF;
        Mon, 16 Nov 2020 01:35:27 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id p12so19343525ljc.9;
        Mon, 16 Nov 2020 01:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xAOG2YTYieBXm2sG2XBQpYDkkTHEFtWVxAivRZSh5+4=;
        b=BF6kPRoiWEsCarjzX6qu05+3yRz/euXkOGWNZ+GCEtih36CLPMJgLcX+VaZqz6GyU1
         MXYpmI5pBI66cny7Q7KyiuGcOtig7QLydG58MC91I7PN5W1dNeQPYLf5hb1gytU/DXIz
         dAhukOv8S0Tj52wuzeCLpyGFUyEQ8CTWpBCTHcSR5hrzi3hWV30qzhrgJRalfRtmARS7
         /Yj5WW1CXWmVrkDdyxOr4ogYUPAfEvFVfMf8Y0O2a0T6k+wfxJN+RlG99ClD7dxuN5dK
         nn3eYqaBDc4jw6ohqStJSTRizmkJKSqgzXcixxXxnKNN1/ycZWdIMoVeJecP6Ihuo0aC
         8Sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xAOG2YTYieBXm2sG2XBQpYDkkTHEFtWVxAivRZSh5+4=;
        b=jnZLHsBnwhoutOPtTvSk9ko8wHgmGoI9mSn/l3/f3+gGGJdpXlhtMyUejToPEsSmcg
         vYtH/ltASTxHOdUVnkFc+AbBxevcTBNytgzjfj5AZ/Y62hEK9NbfK17eEiAencl2YId3
         70lIUzjMzM8bENxFmUv5MO4mN4AXUs9+ON2GmcdV1SYMR7EeRIWarfFi5qqsJcwjr3sw
         pejbqVzCCE70F1jOhp3Q/glrf/1YjZYnQzc+nkMmWf7xW5Z2rSRRkvShYvr6w7QWB1S3
         K55UElQtVjEv2paFxbjZYmpNgAJlBUhcrYPHvVOKoHXMgar1hJhwm4kfm/a13+5hRnot
         Nxww==
X-Gm-Message-State: AOAM533AHYTl/vrhBN5aGGDvsmH+QZShwgfiEIlQcxKNh9AaHomkjUWU
        J28cEQG3EHo2XVGqzf1n11A=
X-Google-Smtp-Source: ABdhPJyUWgn/WvrBtKIDpXtZkttYTdLPotBqxAe3e8OLTuto3qC7FmjD65bFqDqMvN1ZDEcZvHKrFQ==
X-Received: by 2002:a05:651c:1105:: with SMTP id d5mr6437413ljo.265.1605519325838;
        Mon, 16 Nov 2020 01:35:25 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:25 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 8/8] samples/bpf/xdp: apply netdev XDP/XSK modes info
Date:   Mon, 16 Nov 2020 10:34:52 +0100
Message-Id: <20201116093452.7541-9-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Update xdpsock sample so that it utilizes netlink ethtool interface
to get available XDP/XSK modes. This allows to automatically choose
the best available mode of operation, if these are not provided explicitly.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 samples/bpf/xdpsock_user.c | 117 ++++++++++++++++++++++++++++++++++---
 1 file changed, 108 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1149e94ca32f..780e5d1d73a0 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -53,6 +53,9 @@
 
 #define DEBUG_HEXDUMP 0
 
+#define XDP_MODES		(XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE)
+#define XSK_MODES		(XDP_COPY | XDP_ZEROCOPY)
+
 typedef __u64 u64;
 typedef __u32 u32;
 typedef __u16 u16;
@@ -86,7 +89,7 @@ static u32 irq_no;
 static int irqs_at_init = -1;
 static int opt_poll;
 static int opt_interval = 1;
-static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static u16 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u32 opt_umem_flags;
 static int opt_unaligned_chunks;
 static int opt_mmap_flags;
@@ -95,6 +98,8 @@ static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
 static u32 prog_id;
+static u32 xdp_caps;
+static u16 bind_caps;
 
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
@@ -957,6 +962,26 @@ static void usage(const char *prog)
 	exit(EXIT_FAILURE);
 }
 
+static inline void set_drv_mode(void)
+{
+	opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
+}
+
+static inline void set_skb_mode(void)
+{
+	opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
+}
+
+static inline void set_zc_mode(void)
+{
+	opt_xdp_bind_flags |= XDP_ZEROCOPY;
+}
+
+static inline void set_copy_mode(void)
+{
+	opt_xdp_bind_flags |= XDP_COPY;
+}
+
 static void parse_command_line(int argc, char **argv)
 {
 	int option_index, c;
@@ -989,20 +1014,19 @@ static void parse_command_line(int argc, char **argv)
 			opt_poll = 1;
 			break;
 		case 'S':
-			opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
-			opt_xdp_bind_flags |= XDP_COPY;
+			set_skb_mode();
 			break;
 		case 'N':
-			/* default, set below */
+			set_drv_mode();
 			break;
 		case 'n':
 			opt_interval = atoi(optarg);
 			break;
 		case 'z':
-			opt_xdp_bind_flags |= XDP_ZEROCOPY;
+			set_zc_mode();
 			break;
 		case 'c':
-			opt_xdp_bind_flags |= XDP_COPY;
+			set_copy_mode();
 			break;
 		case 'u':
 			opt_umem_flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
@@ -1069,9 +1093,6 @@ static void parse_command_line(int argc, char **argv)
 		}
 	}
 
-	if (!(opt_xdp_flags & XDP_FLAGS_SKB_MODE))
-		opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
-
 	opt_ifindex = if_nametoindex(opt_if);
 	if (!opt_ifindex) {
 		fprintf(stderr, "ERROR: interface \"%s\" does not exist\n",
@@ -1461,6 +1482,76 @@ static void enter_xsks_into_map(struct bpf_object *obj)
 	}
 }
 
+static inline u32 xdp_mode_not_set(void)
+{
+	return (opt_xdp_flags & XDP_MODES) == 0;
+}
+
+static inline u16 bind_mode_not_set(void)
+{
+	return (opt_xdp_bind_flags & XSK_MODES) == 0;
+}
+
+static inline u16 zc_mode_set(void)
+{
+	return opt_xdp_bind_flags & XDP_ZEROCOPY;
+}
+
+static inline u32 drv_mode_set(void)
+{
+	return opt_xdp_flags & XDP_FLAGS_DRV_MODE;
+}
+
+static inline u16 zc_mode_available(void)
+{
+	return bind_caps & XDP_ZEROCOPY;
+}
+
+static inline u32 drv_mode_available(void)
+{
+	return xdp_caps & XDP_FLAGS_DRV_MODE;
+}
+
+static void set_xsk_default_flags(void)
+{
+	if (drv_mode_available()) {
+		set_drv_mode();
+
+		if (zc_mode_available())
+			set_zc_mode();
+		else
+			set_copy_mode();
+	} else {
+		set_skb_mode();
+		set_copy_mode();
+	}
+}
+
+static void adjust_missing_flags(void)
+{
+	if (xdp_mode_not_set()) {
+		if (bind_mode_not_set()) {
+			set_xsk_default_flags();
+		} else {
+			if (zc_mode_set()) {
+				set_drv_mode();
+			} else {
+				if (drv_mode_available())
+					set_drv_mode();
+				else
+					set_skb_mode();
+			}
+		}
+	} else {
+		if (bind_mode_not_set()) {
+			if (drv_mode_set() && zc_mode_available())
+				set_zc_mode();
+			else
+				set_copy_mode();
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
@@ -1473,6 +1564,14 @@ int main(int argc, char **argv)
 
 	parse_command_line(argc, argv);
 
+	ret = xsk_socket__get_caps(opt_if, &xdp_caps, &bind_caps);
+	if (ret) {
+		fprintf(stderr, "ERROR: xsk_socket__get_caps\n");
+		exit(EXIT_FAILURE);
+	}
+
+	adjust_missing_flags();
+
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
 			strerror(errno));
-- 
2.20.1

