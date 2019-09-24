Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4FBCB0F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbfIXPUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:20:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39820 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732277AbfIXPUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:20:31 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so2165034qki.6;
        Tue, 24 Sep 2019 08:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6isa7u+Ujr1ueMUpo8eCINPWXfwol52ywCtO8hQl9tg=;
        b=S+wgdPrLyHrm/MmKiGYshhE0f/hjtoYVUg/3NfIemWa5eGM3rbea8o1Q25H/elEoM6
         5Z2wnPbeITWcngOPRqh9D0rrMkg+cbAlWEXbS3BOfj4kuzppbHThIbW6R9ZPxGv0BKcK
         v0v0G/SlBQoLU7ZPONLDwUBWSPdqIkRqUnRndHkHR0uU/ksXHF3JYcsirDs0XpAB6omd
         nkczLG9I7+iQ5hauwd9LVfQqhd2/Y1vTqXSYzHnnrLN6CP42CeA8RCTeXbN+bhcJvvq3
         jwM/DnfSR6RC2ZlvIN0Io6DTW7yQVYg2VMjJ0LuIdFAf5vQLAZPZgOvo7cB8VmdPUxni
         vR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6isa7u+Ujr1ueMUpo8eCINPWXfwol52ywCtO8hQl9tg=;
        b=lGy9UTSM48VH6k14q1f4vhQQ1algjsu9oFKm0dvBlXvI1eF7qmr6tSOmWKiIcgk6Xc
         BGQMi4NjPnHTx2HKfa86j9Yst/4tOgBljtwxOvKAYJb8QBEB8rmQebTq1URSAE2UQ8n8
         ovhRepEvnIxIaWCdOcvnsSfMOUdRTsaLj6ZYkIkj8Lzi2tZA384DIfdfC/fvx86zU+Sn
         9ql2g27k2U+QMV+MF1iA51RoMCDySgqFDQ063vCVR8ypSvkoj/TASy9Fbr29FzPCPNHk
         z2JG5oT8pyKXgb6g41C6MqjIUZ1rgTjalQK7cDGb9y0lkP3Tma73VL1mZioGy/TzlECn
         FvGg==
X-Gm-Message-State: APjAAAXQbZ9clhA2GfjhwOIoDeacF2M+fh8Jxy8WFBUTdGVl1nvVJxbd
        P/JiH2k9wp/nenupYqCwC3JZNF5v1tk=
X-Google-Smtp-Source: APXvYqy+w9U5G0Nu3h0TbjbAs7l5PeGJ/bycRExWT6gcPHwMcW381xiF+bcb+k7W1+Nxu+Ez9UFOOQ==
X-Received: by 2002:a37:af81:: with SMTP id y123mr2973871qke.145.1569338430087;
        Tue, 24 Sep 2019 08:20:30 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id h68sm1073533qkd.35.2019.09.24.08.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:20:29 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH bpf-next v11 3/4] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Tue, 24 Sep 2019 12:20:04 -0300
Message-Id: <20190924152005.4659-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..9272dc8fb08c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2750,6 +2750,21 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_ns_current_pid_tgid(u32 dev, u64 inum)
+ *	Return
+ *		A 64-bit integer containing the current tgid and pid from current task
+ *              which namespace inode and dev_t matches , and is create as such:
+ *		*current_task*\ **->tgid << 32 \|**
+ *		*current_task*\ **->pid**.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2877,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),          \
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

