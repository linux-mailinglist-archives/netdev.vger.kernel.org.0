Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E721AABBD9
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfIFPK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:10:28 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43785 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFPK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:10:27 -0400
Received: by mail-vs1-f68.google.com with SMTP id u21so4257008vsl.10;
        Fri, 06 Sep 2019 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gmvl5Peybo+fqx0T9NAhNXdtHozg73IhzrDtWDlyMss=;
        b=mm0pSIMUYKrAlu9sJ6a829/6Q3tqpk1RdBams6qxgypTtR95+dstZXcC2RETU9z4Ih
         3U7Sb7TK1ehcOgqLdjK3KWfyFlKFEPzk+MvbRjsfRjI1yWCcphqs2WfKw3cpwIt8PxIB
         kGhjuvoqXOXlR2yKEqupe3PKTmj1pgHRFhzFZVscPXZEs4BoaodahtuE/aFjl358YmVz
         rsACigT4VCHePuHp4GHXDBMw7yPi0oH+PbSA3yhX0SJWT8MbIAWa4zfaS/5CKgb0keCH
         r5DtYADYtGO7k2YKxPRxKPWufQKfR2Gk7HaImg/a9THo1f32zIDCUmx6313shIR4jy00
         T6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gmvl5Peybo+fqx0T9NAhNXdtHozg73IhzrDtWDlyMss=;
        b=DtRe9poHQcviSmO8Ydh4wntL7Kb75ji6pWBicnQdd+BD0N/ZYaWGwWl3RROFKZExeB
         5agJ1rMVLKcdqsLNN+XzQNuI30Y6Uwjgg+gpVrOLL58s843CoahI4Ozi9w1B6kMqpvgk
         Fk7SDXJ9wuoiw597NI6BNEb8gj0mGdaCdTFUAoxm14NYzZg/gfXUJDE3nAVV3byHTPyF
         LvWcOoxwoG+h2KXt5faaI488FdmX7Bb6FZrf8BKCHzKb+9FdEGl+HRpJctWcRcYll+d6
         Reg6r1KcZIYbCFJAuCV0kd1JnRPclpiM/L97VRgfyyTPA40j7U3a6BOqcw+y+UQgikCT
         vY2A==
X-Gm-Message-State: APjAAAWbwYLfX/UGZ6CqIs7yJN0ZG0rF0Wq4rYIVlY2SQXtTvmySl6De
        nNOjPuhTltRgc/3EN7KmW40pb1biqGE=
X-Google-Smtp-Source: APXvYqysj/dAfDlmIWMHuD2J+9ioIaV4Y5iKbj9UM93abMSevD0UnIdza3aZX87dLb3TiIx2nK0PjQ==
X-Received: by 2002:a67:f584:: with SMTP id i4mr5180833vso.134.1567782625959;
        Fri, 06 Sep 2019 08:10:25 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id o15sm4833822vkc.38.2019.09.06.08.10.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:10:25 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 3/4] tools: Added bpf_get_current_pidns_info  helper.
Date:   Fri,  6 Sep 2019 11:09:51 -0400
Message-Id: <20190906150952.23066-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906150952.23066-1-cneirabustos@gmail.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b5889257cc33..3ec9aa1438b7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2747,6 +2747,32 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Get tgid, pid and namespace id as seen by the current namespace,
+ *		and device major/minor numbers from /proc/self/ns/pid. Such
+ *		information is stored in *pidns* of size *size*.
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper always returns the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
+ *		or tgid of the current task.
+ *
+ *		**-ENOENT** if /proc/self/ns/pid does not exists.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
+ *		**-ENOMEM** if helper internal allocation fails.
+ *
+ *		**-EPERM** if not able to call helper.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2859,7 +2885,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3610,4 +3637,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;	/* dev_t from /proc/self/ns/pid inode */
+	__u32 nsid;
+	__u32 tgid;
+	__u32 pid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.11.0

