Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329E8311FF5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhBFUhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFUhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 15:37:40 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0AAC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 12:36:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id z9so5738439pjl.5
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 12:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uK0ExnzD817hnfzMoozq09+P6+3Fen0JJ4OpWDxjWR8=;
        b=CCSuFUX2qTTtK3b5af9ulSRk4cOs0PhtHvTiuI/0fcDpJlBpnbuqYsw7XA5xochRW8
         OxbWk6Iw566IK9CETX1HoqnaKFONFL+l67Zxlu5ERq9Fiz7TKWEu+IU9CNTOvENyQY1a
         PUow1JnJOe9NAii5+Bztb5ak+yxHkEkhoonxX1MjAcs+hePZ1AYnqTKoqzitryFpqQJI
         b/ENE3weeicw/h4PIiuJG/3mxgbQ/3F6j3SwrfjcZnXxPXhwC6Rjz4p2lRGA9Wi0nlgV
         7TEkWEubSS8NPFeLDMFGFe3aAijneK/iFeKFx9SpH+EnfXZYHe0XB8qCM6cfJtWEovYp
         0kgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uK0ExnzD817hnfzMoozq09+P6+3Fen0JJ4OpWDxjWR8=;
        b=q9ptWue0ZSBzZzzgqb1+96QdA1sQmt+Y+K1fXiYuIkpv3WyuX3w7CR3wfyJNYZPdGJ
         /l9EkNL9RTy/AVaSs08lD5MM6rbDJ+Vt8VEK0Ovfcuax2G5TjKnkGuHhYggxVnJ4Q3dF
         VwXr/oBNWZCHJOe3tZTfecmNLk0GhHSw0J5xCbxNeaqOHS65/GWMcR9giq7TZVrfYYgW
         5mugXtOnVQb/XFwApdFz8lnwVd39JWxPm1Z7ZQVl4hZeZ5W4VgubuiMAup9KHlYAPkJr
         V3CpAWtQDRhRd9fMvnoYGmiYVEldN724TGOUmgKVxoA9fY/CV19jZkjdHDl7ydOpyc8P
         lD9Q==
X-Gm-Message-State: AOAM5328Dpun7H4xVO/8chIWwcXwW8hZ7TNF9wfkUt4tNUWHvXDJurhK
        PBqddZYR7w1yfMVVaSpqv5Y=
X-Google-Smtp-Source: ABdhPJwEaSdMq6THkhi8Msu13CGPP1pB0tUWQWw7uv78qWIPbMEZlW2NHkDXTUOpkQqPVIUdt6O73w==
X-Received: by 2002:a17:902:cec3:b029:de:901b:d0be with SMTP id d3-20020a170902cec3b02900de901bd0bemr9694724plg.26.1612643819253;
        Sat, 06 Feb 2021 12:36:59 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:857c:83b3:74ac:7efe])
        by smtp.gmail.com with ESMTPSA id v2sm696021pjr.23.2021.02.06.12.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 12:36:58 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next v2] tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
Date:   Sat,  6 Feb 2021 12:36:48 -0800
Message-Id: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Explicitly define reserved field and require it to be 0-valued.

Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: David Ahern <dsahern@gmail.com>
Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/tcp.h | 2 +-
 net/ipv4/tcp.c           | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 42fc5a640df4..8fc09e8638b3 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
 	__u64 msg_control; /* ancillary data */
 	__u64 msg_controllen;
 	__u32 msg_flags;
-	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
+	__u32 reserved; /* set to 0 for now */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e1a17c6b473c..c8469c579ed8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		}
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
+		if (zc.reserved)
+			return -EINVAL;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		release_sock(sk);
-- 
2.30.0.478.g8a0d178c01-goog

