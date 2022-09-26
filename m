Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA45EB5D4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiIZXfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiIZXfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:35:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C28F58504;
        Mon, 26 Sep 2022 16:35:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso8486897pjd.1;
        Mon, 26 Sep 2022 16:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2ItO39U2OM4CL4ng+GyphEVXRyIIIkkmb1bTIMUwMtA=;
        b=hoyiQKqy9fyXYjkkaHMxqK2P9WA27uDuciLJENvjxy/5LYNkNZhKC4A49ohSnYCJtd
         Dj9WDqTOhgEbk031gogH5c/Tv8t8gWMCLtsCPIyPZFfO7sifW2U4HvvOy6y+VIsVtQXB
         ajRm+CPz4nHsPACC99iZG3a2edyfalqvbyvriiBvNGtr7k/cqy262+qfc6vx6Zzvtu4E
         ItVJ6zA/4CoRIwJhtJg0rHprZDHq4hn6DwzZ9k8hOK2F2UahuUhPrlE5bPWUm2iHWrdH
         PyqlHj0e5kvIYXV169lJcovSRVt7PTtxnY30wpPhzxHaHy7stOgeiuJjp3L5BWGOiTJB
         Py8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2ItO39U2OM4CL4ng+GyphEVXRyIIIkkmb1bTIMUwMtA=;
        b=34TDk9eUOEtZyannkixvUs+Hl5GCHGhW0gVCHdMW54KGkLXpWGFYkBEohTD0yDvbwt
         qPy1WIVyyXSNp47znC43MvcmENOlMsxCEcx1+CoTogiNr10D9F4dKIA9juNbdxYUh72t
         5QGtayrXCSoxlbH5fD+xpMECSsLM/Gwtr7xfHE79FuwylhWfMgmkRTjRWNSDTxw5wDoV
         R49eNQApF/T+95kV8ri/LyRQkSs2Alpmxe6+FJERaVfdOZ8BchPyv9FuFO2pvSdea/t9
         C4LEhyeoyRz3EkbCMSGnCPmL/g1MWqScOQfjN/fPZiIvq+MW3ARno6tydm4dVLuvzFR3
         XXJw==
X-Gm-Message-State: ACrzQf00qG4z8kKnd3rO/VVMsR+DPc4GuYrRf9kcLZO/6Ts3UJogwETZ
        8V3dRHtmWm6RQWzODLMW/FM=
X-Google-Smtp-Source: AMsMyM4uwj6I45F3GF8fSK0RoR+3LPnbhqCeoKSvJBKpSfLyPdhVtpjT+ig2ebzmtAb4LkcPnb1kNg==
X-Received: by 2002:a17:902:d2cc:b0:178:1742:c182 with SMTP id n12-20020a170902d2cc00b001781742c182mr24015123plc.98.1664235310798;
        Mon, 26 Sep 2022 16:35:10 -0700 (PDT)
Received: from localhost ([223.104.3.28])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709026b8300b0016d773aae60sm18538plk.19.2022.09.26.16.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:35:10 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        edumazet@google.com, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yin31149@gmail.com
Subject: [PATCH wireless-next v2] wext: use flex array destination for memcpy()
Date:   Tue, 27 Sep 2022 07:34:59 +0800
Message-Id: <20220926233458.5316-1-yin31149@gmail.com>
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

Syzkaller reports buffer overflow false positive as follows:
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
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v2: correct the typo error pointed out by Eric Dumazet and
    Kees Cook

v1: https://lore.kernel.org/all/20220926150907.8551-1-yin31149@gmail.com/

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

