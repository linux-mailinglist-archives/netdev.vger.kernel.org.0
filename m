Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A75124F86
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLRRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34847 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so1606468pfo.2;
        Wed, 18 Dec 2019 09:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KjPwmFi9va1zvHRTrGSZQ7PTAqFjJMFz3DanPqDlHqM=;
        b=KiMaLC7+bfy6i8PEDSFOGGSF94BvefX+O8j6QzOkrXB+yJNXZ/onasYyaRW7zDdh8z
         f8zc5sWfT0XONQuKEo8GLStD1Qsg95JawAO5XVcXtgSDk4xJMmx3SI7PXJ0uoi7ooFFd
         cxWNDycqNHX7NvqWuLAZnmz6UxGPEuxi9m8W/mDUarKN1ui6eJIdnqtWdnkodfQYrbqf
         UnZdmZZ1DAuMS+a8YPUduZSbnQRBpkaQE5Yc2+xTAg5qLV7K7vzErzJCCjHlOV0Vq8pv
         cy9WTskh2m88axELcKl56y9jV1Lo10U6DBWw6NhCdhyHXn7NAnv8c3fU4zFRyp4lx7fq
         ItNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KjPwmFi9va1zvHRTrGSZQ7PTAqFjJMFz3DanPqDlHqM=;
        b=S4945AvLF+1xirfGTPrB1QAXm4eSzEWDkW8XcILf/e05r+2qmbxCzf8HC7635HOgQ/
         BfvtOu+AYSHMXQ2XwbS4m7GPgn/VfIVIFEBTKZyVJ8ROcKclKmvcrh9CkEYzZ8iXJaBd
         UIycp5LPaHJHu2OgP+M58jb8pDe4rIGSxil9eu0iSKlaO8OlUS046zpMCdoRS3hM0ZgB
         zlhS3mDa3e02luKngia6QfOetA2T2QFwShIYIUln7KtFrcySOQrll3XFyFuYjgqzfHZh
         jOqTw6sixkndpnHVpesxA5HXRZeXXn7VgSz1GE3fhgC362DiIVJQFdY/iWGSCEPhTKC5
         Vbwg==
X-Gm-Message-State: APjAAAVB56bJl0jnw20Tsn5edc12Efmeq6Huyhvku7JLGfLcgVKhfZys
        SBXUs8tDTyCuJcYa66JK3AAjF3HDYLA=
X-Google-Smtp-Source: APXvYqw3ERb4uqmSAyMuf7Qyskh0MdLo15P9bvmqQeecnGFr33Km6jfkVLXh3wb7/M32OR4PnhZ2ew==
X-Received: by 2002:aa7:9556:: with SMTP id w22mr4364082pfq.198.1576690725874;
        Wed, 18 Dec 2019 09:38:45 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:45 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Wed, 18 Dec 2019 14:38:25 -0300
Message-Id: <20191218173827.20584-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync tools/include/uapi/linux/bpf.h to include new helper.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..75864cd91b50 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2821,6 +2821,18 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if pidns does not exists for the current task.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2950,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3689,4 +3702,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.20.1

