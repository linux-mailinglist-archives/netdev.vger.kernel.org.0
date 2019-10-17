Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157BEDB09B
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406673AbfJQPAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:00:50 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33614 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbfJQPAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:00:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id x134so2178019qkb.0;
        Thu, 17 Oct 2019 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A4q7JdM3gpKjaJbj8ZRzzKEDY6bhXVBkntTNN2SMjG4=;
        b=jjqw7qVpwvnacqUddjsg9B+TzWdsLV03kLRuUraIRkMykIV1PPDkgVuY53dlpjK8bI
         xXaoJY/LOTStZwN5fsn6QOnptda+ehdPWy16Wg6cxSwTxvuJhO70zkDHgHzAI21QzySM
         C1CImgzplzIMfDTWyLa6KqAEIocgPw8vUJxDMb8Nbi4/LmzQlh1ZqNJyc/9njmaptRjx
         bIrzuc/1MyLbVG/6iSEr/hX45b11n/dGCMV35d4oeq4SnusSY9JrvslUIBuJoEGukXtu
         f+8EG5DuW7jE7mv1vuHD/BoABi6ntk2PaWSMyLX2LlnI8p4IF22B9QTov/cyvD6iYd7M
         nlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A4q7JdM3gpKjaJbj8ZRzzKEDY6bhXVBkntTNN2SMjG4=;
        b=TBm3C3xidrmzgkLjU+dHhVrB41TBvrnVTeko7LpGXrC65rZhH4SardwhK4SziIG/ld
         NNiMlAJW4i4HaYxpeCgF6nfK5r/g1i8SFlBLFIMidITQczHKJ29OrVN2x5vt9yF+O6Ka
         bMzKpvk9ZScBPL0W+IAj/ZzYfhMI8QZXcrnxzmZ43z6ESqD03bf5E/jRdc94q1m6hHAM
         I/44bfW1hfxwuWIQfNhLAABO521vHJSkabmwFE/vsSOuuf1HpryVz2rpNjvIv06XhVhc
         m2A1idwcZxbuVzqKn8AytD5d9d+/3lxnFhEiDDxOq3bdwNj1AdAW1GFExEPf70TV2put
         Zd1A==
X-Gm-Message-State: APjAAAVUK0OgAOmiWVsogdpHqigFS1iDsG+eooY+HgfgkIqpEHhWXYvW
        JYNyfg24rHVDNwAxJRJWP0N9w1LQKr4=
X-Google-Smtp-Source: APXvYqwrIK5gVIr6rabkwnmooPnhfXtiiI/qiJXx19IMpXZwXyKss6er7XK22zMBvNOsuJLyEpQ8eA==
X-Received: by 2002:ae9:ea05:: with SMTP id f5mr2452265qkg.370.1571324448405;
        Thu, 17 Oct 2019 08:00:48 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id z20sm1550859qtu.91.2019.10.17.08.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:00:47 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v14 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Thu, 17 Oct 2019 12:00:30 -0300
Message-Id: <20191017150032.14359-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017150032.14359-1-cneirabustos@gmail.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync tools/include/uapi/linux/bpf.h to include new helper.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a65c3b0c6935..a17583ae9aa3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2750,6 +2750,19 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
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
@@ -2862,7 +2875,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),          \
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3613,4 +3627,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.20.1

