Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447935EAC5A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiIZQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiIZQU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:20:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB015F8593;
        Mon, 26 Sep 2022 08:09:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a80so7001082pfa.4;
        Mon, 26 Sep 2022 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=eWFU6eAPtlxOi+MtboPOo9H3JxiX/XlJ6GW9CbAvjgo=;
        b=jEmp1M4byhfqGcUfraVdUnvy/5wD9gvOg+IwIx1GNirEVr2IeRMoWHo2T/FlDdrXt0
         +2JqFLi7CobaY3+Z9Y7tTeS7/3N3KOX7zld/uaLMjjsKTyPv/cQuYnwHowX77zDFCFZw
         I7ipjfvoN7PNigy6acM11Iv/FfFqzNJIdmz0RYWLHzIS1TUGkAO25Wa+SycZ/lDzMiMp
         CcZrfp+mhQLJ1bYnkeF2jpuuXetJPtk/+uZghzX4tnN4+12Hl43NjbqN8afikxIIqZj5
         KT6OK/jfk415LJrTtjZgLg/RIrwdNd/tuP6Xtldhkgjb0y6Tu4WIn5KwOLUXFWvnApR2
         /yfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=eWFU6eAPtlxOi+MtboPOo9H3JxiX/XlJ6GW9CbAvjgo=;
        b=yJgdxDYv+o5sxKEmplOa0O5ZAAgbuEzFNImqJFTGvxuYhCNu6dnbGMZUb8vEMW3opG
         RqbjXRr/ZilV8oaZRjw4WzzYjvwoxD/GW8Y/EDVjOUNUsCXMZxjCkCdn9wI6Muy99Zgk
         YhW89vdbt6rz1avJf0k/Ykhn5hP8B0V4rnUy/bCig7BakB9CkoOCfnN3xBCem2Dr3Mxh
         3Vw7Ej7OT5bD7zHaMplyOiuWMEuS1Fp0DZ/pt72jib+unNcEmB8hbvM+k7UpQOU1VTsv
         4g8/D4x+fJQq+z7LE6QPuJJr4U3E1tBUIc9fZ0+Yc4mBfcrneSN+KVSw5E3xArZiSY/2
         Pm3g==
X-Gm-Message-State: ACrzQf0cftiE6xY9tN/G6p0OA09pk94iPCuLmK6o21mG9ta+WpSb9yPt
        R2h9gCoHzN8+S3iu30Y8bfo=
X-Google-Smtp-Source: AMsMyM5U3e5OioWTKbob8b0CuJRUM8TOHm/boiCJE7bQMIiaalfnduQo5NVE4mE+ayR6ppNhv+FQAQ==
X-Received: by 2002:a05:6a00:1c72:b0:543:239c:b602 with SMTP id s50-20020a056a001c7200b00543239cb602mr24376121pfw.75.1664204953585;
        Mon, 26 Sep 2022 08:09:13 -0700 (PDT)
Received: from localhost ([223.104.3.28])
        by smtp.gmail.com with ESMTPSA id y136-20020a62648e000000b00540f96b7936sm12302173pfb.30.2022.09.26.08.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:09:13 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        18801353760@163.com, yin31149@gmail.com,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] wext: use flex array destination for memcpy()
Date:   Mon, 26 Sep 2022 23:09:06 +0800
Message-Id: <20220926150907.8551-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <00000000000070db2005e95a5984@google.com>
References: <00000000000070db2005e95a5984@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports refcount bug as follows:
------------[ cut here ]------------
memcpy: detected field-spanning write (size 8) of single field
	"&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623
	wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
Modules linked in:
CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted
	6.0.0-rc6-next-20220921-syzkaller #0
[...]
Call Trace:
 <TASK>
 ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
 wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
 sock_ioctl+0x285/0x640 net/socket.c:1220
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>

Wireless events will be sent on the appropriate channels in
wireless_send_event(). Different wireless events may have different
payload structure and size, so kernel uses **len** and **cmd** field
in struct __compat_iw_event as wireless event common LCP part, uses
**pointer** as a label to mark the position of remaining different part.

Yet the problem is that, **pointer** is a compat_caddr_t type, which may
be smaller than the relative structure at the same position. So during
wireless_send_event() tries to parse the wireless events payload, it may
trigger the memcpy() run-time destination buffer bounds checking when the
relative structure's data is copied to the position marked by **pointer**.

This patch solves it by introducing flexible-array field **ptr_bytes**,
to mark the position of the wireless events remaining part next to
LCP part. What's more, this patch also adds **ptr_len** variable in
wireless_send_event() to improve its maintainability.

Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
 include/linux/wireless.h | 10 +++++++++-
 net/wireless/wext-core.c | 17 ++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 2d1b54556eff..e6e34d74dda0 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -26,7 +26,15 @@ struct compat_iw_point {
 struct __compat_iw_event {
 	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
-	compat_caddr_t	pointer;
+
+	union {
+		compat_caddr_t	pointer;
+
+		/* we need ptr_bytes to make memcpy() run-time destination
+		 * buffer bounds checking happy, nothing special
+		 */
+		DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
+	};
 };
 #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
 #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 76a80a41615b..fe8765c4075d 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -468,6 +468,7 @@ void wireless_send_event(struct net_device *	dev,
 	struct __compat_iw_event *compat_event;
 	struct compat_iw_point compat_wrqu;
 	struct sk_buff *compskb;
+	int ptr_len;
 #endif
 
 	/*
@@ -582,6 +583,9 @@ void wireless_send_event(struct net_device *	dev,
 	nlmsg_end(skb, nlh);
 #ifdef CONFIG_COMPAT
 	hdr_len = compat_event_type_size[descr->header_type];
+
+	/* ptr_len is remaining size in event header apart from LCP */
+	ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
 	event_len = hdr_len + extra_len;
 
 	compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
@@ -612,16 +616,15 @@ void wireless_send_event(struct net_device *	dev,
 	if (descr->header_type == IW_HEADER_TYPE_POINT) {
 		compat_wrqu.length = wrqu->data.length;
 		compat_wrqu.flags = wrqu->data.flags;
-		memcpy(&compat_event->pointer,
-			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes,
+		       ((char *)&compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
+			ptr_len);
 		if (extra_len)
-			memcpy(((char *) compat_event) + hdr_len,
-				extra, extra_len);
+			memcpy(&compat_event->ptr_bytes[ptr_len],
+			       extra, extra_len);
 	} else {
 		/* extra_len must be zero, so no if (extra) needed */
-		memcpy(&compat_event->pointer, wrqu,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
 	}
 
 	nlmsg_end(compskb, nlh);
-- 
2.25.1

