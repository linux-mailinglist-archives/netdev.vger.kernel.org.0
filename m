Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623AE5EA789
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiIZNnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 09:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiIZNms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 09:42:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407CE8D799;
        Mon, 26 Sep 2022 05:00:32 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e129so269941pgc.9;
        Mon, 26 Sep 2022 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yaZsqph06GntR+D15TzunhyhKnzThingfXRbQEEFIyk=;
        b=mzX9UUgOmbpU7ze9RtcM0DK0bskvbK3KRziTIu+NV7Dzlj0f8hGKJwH+4xVUYSG4KX
         XOdiv2CkJBDiufQ52T0ZuA/JDxn830giuYzdCIjSNu2iW6Dkr8kZ3H38MyO5CzkGdFMX
         0eyeHrH2KD7BwthEJ7jni4DAp5JcZsEm8x43eC2vMznOWIyH9dX06D/fW60vlBK2Uqjx
         SkuJkA3SUZJ6ady/0rFymiQMcbL3SvgK4dc958V5N0csNff2FGNVmrWfj9LMcU3EJpYw
         hnlITCWEfHViJCmJiefwNdOvzAKo3q0XpiPci4rcDNux/85Bsl7z81SXNmD85qBXV2Nh
         6c7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yaZsqph06GntR+D15TzunhyhKnzThingfXRbQEEFIyk=;
        b=wB3ZZFH7pA92L9SObkqrBXunUmH3mffvJfVMHNoDg+tWoJC0jzEZTc9V3bFwdrYP80
         mUZLL4DyFkGiIzeWJsl+4u6e30CTq7pQ6KIOginwtsd6bTdRX2CvXErD3teNbJhTF6vC
         eEtBdg4ZtcAddRA6jqe1qy1G/ZbWIJjLMXSJ3b25MN1CmPlNKJUFssuUPjf7SKr1iRLg
         YCum7M8Q20X1Ccdev1mn90A46dNQKci3dsRMazwvo4Ljrj4DRaB43Ab22kOcFFpyRpuR
         LU4fXte5z/5//rJvWK1mHYoe9hDx6EPG1ebrNitJvEm/tUZYYStPPNv0DjJyNUTsRnjX
         urXA==
X-Gm-Message-State: ACrzQf0H6z2LR5jzPf1w1YA41gle41MC3WRxkiNvTgi6hBmAmU93g14p
        1w21qqtTpaqZlzipS91vENk=
X-Google-Smtp-Source: AMsMyM4J7TNPJFef7B8KSkY+qFAjumwpawFZvba1r01PJGHpbX4eNGm/c/q31tzlNJHsZAvEQm2dGg==
X-Received: by 2002:a63:154b:0:b0:42c:60ce:8bd3 with SMTP id 11-20020a63154b000000b0042c60ce8bd3mr19766143pgv.372.1664193582357;
        Mon, 26 Sep 2022 04:59:42 -0700 (PDT)
Received: from localhost ([223.104.44.30])
        by smtp.gmail.com with ESMTPSA id c37-20020a631c65000000b0043949b480a8sm10447035pgm.29.2022.09.26.04.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:59:41 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [syzbot] WARNING in wireless_send_event
Date:   Mon, 26 Sep 2022 19:59:02 +0800
Message-Id: <20220926115901.4941-1-yin31149@gmail.com>
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

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
aaa11ce2ffc84166d11c4d2ac88c3fcf75425fbd

Syzkaller reports refcount bug as follows:
------------[ cut here ]------------
memcpy: detected field-spanning write (size 8) of single field "&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623 wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
Modules linked in:
CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted 6.0.0-rc6-next-20220921-syzkaller #0
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

Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
 include/linux/wireless.h | 10 +++++++++-
 net/wireless/wext-core.c | 13 ++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

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
index 76a80a41615b..2ca009aca865 100644
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
+		memcpy(compat_event->ptr_bytes,
 			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+			ptr_len);
 		if (extra_len)
-			memcpy(((char *) compat_event) + hdr_len,
+			memcpy(&compat_event->ptr_bytes[ptr_len],
 				extra, extra_len);
 	} else {
 		/* extra_len must be zero, so no if (extra) needed */
-		memcpy(&compat_event->pointer, wrqu,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
 	}
 
 	nlmsg_end(compskb, nlh);
-- 
2.25.1

