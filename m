Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF91169AB3
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgBWXSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41867 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBWXSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so8237296wrw.8;
        Sun, 23 Feb 2020 15:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WXi0tRYl5HmKRjz98V0jZ+F+bayiPek8dE5Nz6vBIVU=;
        b=MUMjaQgNz202BO5dopV9PRfH5QcbJltxKRYAfAJ4Ls/9Vu0lUJZwY/Ta99BgWyvSCI
         G1hWYn0horqZeGZyMi8T9F97h9iehT+9xxENJwQSg/Ov2PPRO1wSwSKurT00PmVcCf6Z
         wOGpLQKPSaFOTRDlZgKIUEgDr0gLCVgZT9gc85Gj3Gj/vZ98CZkoHevnC1KWVeujip9R
         ksZrgF7WKqtLZf2Jqiq1/mwww17ieDgOWaaZn97pj+Exvt6kfoAnSjgxsN0l/iRAO2Nw
         oTvGEfrunxYKPBngTT/dQ4IgpM/zs7maVxGbi3jmW6sB36ue1XWGyUw0t41ts6coQw65
         pnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WXi0tRYl5HmKRjz98V0jZ+F+bayiPek8dE5Nz6vBIVU=;
        b=Px4NBEpLFbdN+v0xfOQQfLHxHchH7nzeG/o2d0BcKVHmQD5RDEMZ77Es2cHnOXLAWx
         EwI1V+U34s9lVv9NlhX/cyXFKErrqDJKI4oU6AyuQoFyRnPwS0JIi8YjSXscUZ/VPwWj
         Qcofsu6ycEcuk2potYMOrS5gJjgIDPcJMq6Iw28rKHUzejPzgnYI9TQAs6Xu9/5CmliI
         Gi0h60e0VIOzcIC7N7mjSmHbt09wBqO6Vf2RjYrbKahXEKbpWk3q3wFacmW192frJv+H
         PN2ww9SMwvWWZ2HCaPxXKrKxt3QMKymFG45dMVyUHlWSroaIeSTqE+SRnJ6Uw+z+LEBN
         ynHA==
X-Gm-Message-State: APjAAAXoYHr8nImbrKR97jJXiQytWHxxoq+zmr2rzDyb3h/7VU8L1Q05
        x1Qwd9f6Bv7vkq5LMk8Rui+Pnm1p/L18
X-Google-Smtp-Source: APXvYqyUS3PmmexjFzZbkTjBeEjNO7Z+vgHQyPvYUPka50mPSCK3v5pBWbftmEzF4ow8BBHpVjG5gA==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr62130426wrn.245.1582499891874;
        Sun, 23 Feb 2020 15:18:11 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:11 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Qian Cai <cai@lca.pw>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 15/30] af_unix: Add missing annotation for unix_wait_for_peer()
Date:   Sun, 23 Feb 2020 23:16:56 +0000
Message-Id: <20200223231711.157699-16-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning unix_wait_for_peer()

warning: context imbalance in unix_wait_for_peer() - unexpected unlock

The root cause is the missing annotation at unix_wait_for_peer()
Add the missing annotation __releases(&unix_sk(other)->lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/unix/af_unix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 62c12cb5763e..cbd7dc01e147 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1207,6 +1207,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 }
 
 static long unix_wait_for_peer(struct sock *other, long timeo)
+	__releases(&unix_sk(other)->lock)
 {
 	struct unix_sock *u = unix_sk(other);
 	int sched;
-- 
2.24.1

