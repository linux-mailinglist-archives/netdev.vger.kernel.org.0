Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27F2D126F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfJIP0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:26:53 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40661 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIP0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:26:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id m61so3975158qte.7;
        Wed, 09 Oct 2019 08:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLlmsJf3ShLtGT0uefsGsqKyq1wDjDG1ATRu3k+5ehM=;
        b=GymUyy+uyrs6IokUbSZ9lSqhiUT6NLjqevsaEoHoACjj0NAjmJT/5oPHhbUAMIGazS
         8BQ7c02FRNwp5k+PUvWlRLmsQt5yd9+89s7if5X2WNUyCL21ugw8lOPQZDffXB6EXUhj
         JmFjsJyBppCgAQv4p6TsJQu/RbJZMJy/3gnGgs8nyHdZqon58odCNjJxg9ZIlfiYCnK/
         m0hzQLufv4JzcEUEoVL7IZARxjpMbYF8lZnJjIFFXpbIV47tOF72ZBJq8Q75XG5ldHfO
         UY6pT+Uj1IfZCvN5H7I1CGaDcfuVXnniiG//ZA4OR8jrY4ommLMD7GBEdkHwrGKaEQKo
         gUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLlmsJf3ShLtGT0uefsGsqKyq1wDjDG1ATRu3k+5ehM=;
        b=YcsvReI78ToTu18DaS4rTtUdqmNrEYR6YXjD3jteuEGfpEfOjjyQAdgMqk8UCrp7xa
         DmQz/wRPwpN4pQrmyWf9oCar8LkmJixCZMdwKL6c/Kf9ZJbdnAAyV3v1WbdTn3sUeUi9
         zu6YIToDuLa2NGgH0fPjfcTkO2C2oeWt5nMk5ey5um1XxeiMfj9wBnaQF2sQS6I/zBrW
         5pM9wbL+UnHtKGmOIQWMK6CFhmzwNFAqzJ5UVHrI0qQtDxRzAfFN70OY+i10QNxjsKTt
         v6J57dt18DH+k9V/pLMEZ2b1MesSLfuR2MS+c3l+kyJD5pyEt9sHBOkeMzehp2ZYredp
         WpIw==
X-Gm-Message-State: APjAAAX8R9+fMdI2JDwH9gvNtwET8MXKHLnLlVqQDNoYDzlr4IJbr9C2
        AQtTBxOxhiN5y0p6bOzF5DV8E9LZ740=
X-Google-Smtp-Source: APXvYqyv6+LY6ht60gQh7/CmqS05Q2eW8+mc1z1lfGIJNMoYbqsKilZb1ji255d9Bhioysb7Uj421g==
X-Received: by 2002:ac8:750d:: with SMTP id u13mr4286544qtq.129.1570634809338;
        Wed, 09 Oct 2019 08:26:49 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id l189sm1049895qke.69.2019.10.09.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:26:48 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v13 3/4] tools: Added bpf_get_ns_current_pid_tgid helper
Date:   Wed,  9 Oct 2019 12:26:31 -0300
Message-Id: <20191009152632.14218-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009152632.14218-1-cneirabustos@gmail.com>
References: <20191009152632.14218-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync tools/include/uapi/linux/bpf.h to include new helper.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..6ad3f2abf00d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2750,6 +2750,19 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(struct *bpf_pidns_info, u32 size)
+ *	Return
+ *		0 on success, values for pid and tgid from nsinfo will be as seen
+ *		from the namespace that matches dev and inum from nsinfo.
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
@@ -3613,4 +3627,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u64 dev;
+	__u64 inum;
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.20.1

