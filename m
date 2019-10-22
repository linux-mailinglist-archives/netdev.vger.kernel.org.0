Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD39E0C69
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732856AbfJVTSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:11 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33114 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732810AbfJVTSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:11 -0400
Received: by mail-qk1-f194.google.com with SMTP id 71so13509069qkl.0;
        Tue, 22 Oct 2019 12:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S56WLPMIQyH40sEaPP4IlYDbb/ty7fLg8KIWGLpaAaI=;
        b=cSaurt/JFUzQZyQVB6FAVqQLFyRcyH0a0rGsXSH6MQjvXkCY4rNqbUYzFJTjKRa6RI
         7AqKJ402huOzMcSSYPF7hhPWB/RBpz94DzPMEIcJQlF+UgjaytJtqQAPZ3q68oB/wuKo
         HvpVpXLUCkIhHwr5hYoA5P37fyZEImC/LC51a8IIfiHKLUeZag1OGzV+NirlFKtK7PSm
         BAmkmhh7XvZJepns4n2IAmVL4p3yeewV8yRHrWISSZfeP+ufk1IwL9xphsW9xyAf5vfz
         LnkK3Ulz3CKD9MsB5pt3C+CepZJUua6VG/VrMThLrdmEaGsbmt1Zhuyq516Xvl/eUSkg
         JjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S56WLPMIQyH40sEaPP4IlYDbb/ty7fLg8KIWGLpaAaI=;
        b=pmEDGb63nkUp6gGpFc0+R9ti8a7JNT8psA+yXdLqafC7APJTyqzQgFSdnreMxU/uhE
         o5iCnOp3/VpothUXlafVirCYPY6uu/wjp5axAs4VmX2YKpmzJhyUX0MqXnLI3GRBMb/l
         Sqdz4oh1R8rxJWKvSoqD1QEZxoI9v9defcoNX+hmGZdxC/F9puWx8u/9PfC3jz5FR2ww
         WWqZyJ7Yt+qMCM639RYRNDj/NyinO0U1BqgB32IwaiqfdjbPNquHH96Fx8zES1hsLMFZ
         wp7b7XT9JDIBI3/AZmJe+2YCguIeaE27cFdRy+URycMtvSv4uNmiDWMzkSctdHGKaJoI
         nZkw==
X-Gm-Message-State: APjAAAU4lxsqGxTh3ec7H3MSGAqPPYLztDlWd6l8K9C2jLX/Ceph3Yr2
        ajCOmhgHC4LMxpxaKdPTcYvbzbSIfESxMil7
X-Google-Smtp-Source: APXvYqyikDPze1zpmUC2oGKpvrH1b+xjhi5Ll+Z95w69nWNZJwGRjIjol+XWN6nLIjsWIrZmIGzDuw==
X-Received: by 2002:ae9:d8c2:: with SMTP id u185mr4895114qkf.120.1571771889597;
        Tue, 22 Oct 2019 12:18:09 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:09 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Tue, 22 Oct 2019 16:17:49 -0300
Message-Id: <20191022191751.3780-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191022191751.3780-1-cneirabustos@gmail.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
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
index 4af8b0819a32..4c3e0b0952e6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2775,6 +2775,19 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
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
@@ -2888,7 +2901,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3639,4 +3653,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.20.1

