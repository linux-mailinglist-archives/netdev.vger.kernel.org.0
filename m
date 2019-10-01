Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7935EC42DD
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfJAVmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:42:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33964 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJAVmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:42:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id q203so12870297qke.1;
        Tue, 01 Oct 2019 14:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4q/41TxGZ/5B1Wg6FL4I+DCjlS5tHb+h5GEKZ9pO0qY=;
        b=uYJwGbJyBk00Ek3CiG6N4o0LsaJNJL1jT+v/MIdFPH8EeiLNXowreeFxZG5aoFs/y5
         1het9RrdCB7m6pThHrDFQwaQANkinQ5X/bpqf5sUUPkEpDX5J67uI6cnkXa+TkMNeZK3
         eLgtCFJldOlKgRqISjC4vgKSkj0e27JGtXmLxEjFWHSf6imEUG817YRF9AycnecFU0T2
         cjdDEaUMb+vho4sp89ERRI7HBmIjxMTL7AyTAFIZvUJG1yqqJxz36W5pkCqBVskDVBnm
         Ypyt1wSyT1P2TkXZsvvQvt4Ib/QhTTtoRQ2IcqBh1qVUJvcJeeFCEl6hCSITUtXJD3yI
         ffKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4q/41TxGZ/5B1Wg6FL4I+DCjlS5tHb+h5GEKZ9pO0qY=;
        b=P+TDAN1EfMzdcmDyLOqzPAf5LcLbbrw4QKQKOYSfx7JiGFgEhGPCwlSV1S5CRHNkk0
         NC3zWWsA1mXnxbPn0B9Hu7Ph/Z9j8T4wyJvwV9iZOoQTnGLDk7aqYlEPrSTRRhqJVoys
         0vCZxXhvqt3QxvHJ7YFTOpIGYMlJNi3uLdkTM64vj/HCTBGK4EEinT/+PFrPlNF9p9xO
         EflHNcVvoOull52EWrUP3M/kHik6RPkwyJQSXbwlel99DD/1WbZLhIV0YNKL46TA3x74
         +7wcaYde3u9YKU3Cgod+wMvfE8VV7ecH89PpsMju7XZM+RHkfCQATFNm7hGgGyQFSnn8
         WWJQ==
X-Gm-Message-State: APjAAAXJ9EToz4PiHZFNheRMMls8+fUAGFHJuVbvs4Jf/VssIaNv6M/E
        txaHSFM2TJ8Gx+7RgmRWj059jRPAh58=
X-Google-Smtp-Source: APXvYqx0k1vKzqiG6jAH8O4ZK+Tqj1TE9v7CNwZsOntvAOK3hM9fZeWMqeR8lzdxOB3xeWhUIq6ELw==
X-Received: by 2002:a37:62d8:: with SMTP id w207mr265870qkb.261.1569966121483;
        Tue, 01 Oct 2019 14:42:01 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id v13sm8559352qtp.61.2019.10.01.14.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:42:00 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V12 3/4] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Tue,  1 Oct 2019 18:41:40 -0300
Message-Id: <20191001214141.6294-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001214141.6294-1-cneirabustos@gmail.com>
References: <20191001214141.6294-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync tools/include/uapi/linux/bpf.h to include new helper.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..ea8145d7f897 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2750,6 +2750,21 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 inum)
+ *	Return
+ *		A 64-bit integer containing the current tgid and pid from current task
+ *              which namespace inode and dev_t matches , and is create as such:
+ *		*current_task*\ **->tgid << 32 \|**
+ *		*current_task*\ **->pid**.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
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

