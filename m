Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9BA23D6E6
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHFGlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgHFGlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:41:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00352C06179F
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 23:41:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id b18so3178077edv.10
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 23:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=PYSsCrOysop+Sh0mOiJ6j1B4kZ/DvpynNkFjKlnFTtk=;
        b=YeOG74L0CWaS4dyv69sqi18DDA3OmbSJyoz5z4Iq4BCQy6J6+W/uFDEvqWXdcSiz71
         PiyO7Y5tjbvPnj+N6Pjgj5S1pO0tFgGm8tbES5Sbqdhc+FnQ2SpGND97Y8aCRgG0Z+Pm
         ikW3m6dkRbpl/6UHdMjBPF0LIkcV56pvKUZKug4Cp8tzUj//ZBPAy+G82GkCDz/ZiWuZ
         51QykkaPw6YE0Cb86WxTqdCg5RJpm8zVY8XY1gBdDt17/pkwhWhY1w4f1VwMzp1spBwZ
         vHezw6durJEeSd72auOjwnRhClKF4yYcxJQ2tIX0aUcYI9qafsEM7TblIX4inpkT2+Cb
         KpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=PYSsCrOysop+Sh0mOiJ6j1B4kZ/DvpynNkFjKlnFTtk=;
        b=Iei2wJ9vuroJjgv69xQsAUTwubHv3ngbeBEz3etfM37KbrfelDL8mpGqU8l8q0Slib
         6BT/hUDP8evvhgAfaXeJ9hv72/qzJDppovLjO+Ni0kb7pAOW6u2iMn9zCdeyaAQwUIvg
         Uu5WzQUWw94ANpYoEt6SQtqLIHrv1gTyTiHpzlUqLaPaTLFLvuoV2S1xBU9+pK6Yooe3
         xIPnadovrS2H/OSpKVIzbGrelARN1cymYhycHKsGlv7cBwavZpdo3uacStc9DWNnYWQ+
         reYcYX8CXYbqluCQTWqTPiOQP87wNzq47HNCDyabOem8TkUevXXx2OMIPewQl+of/y1Z
         Xq8w==
X-Gm-Message-State: AOAM530jwaG5eixpAoN/GXNNDkXAHEIpxY8lfAnuQmLBmSJGBHHzv44X
        LLQpUwHa9fLRbygYnBM+s+uA0wH3q6SIng2hjImQJ8tav1jvLQpEVqT7P2TxCiJZ/f4M2qx56UR
        ewf+UU+iy9g==
X-Google-Smtp-Source: ABdhPJzfIEK9tWe/DKDr6hpoSUG7nnY0T65MTIA6Y1Po5B4MvXNS0VAdmc+Wmxzxpx2gXxEXqHr2gA==
X-Received: by 2002:a05:6402:1f8:: with SMTP id i24mr2580851edy.251.1596696078742;
        Wed, 05 Aug 2020 23:41:18 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id h18sm2880984edw.56.2020.08.05.23.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 23:41:18 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        KOVACS Krisztian <hidden@balabit.hu>,
        Patrick McHardy <kaber@trash.net>
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: initialize fastreuse on inet_inherit_port
Date:   Thu,  6 Aug 2020 08:41:08 +0200
Message-Id: <20200806064109.183059-3-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
References: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
behaviour or in the incorrect reuse of a bind.

the kernel keeps track for each bind_bucket if all sockets in the
bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
These flags allow skipping the costly bind_conflict check when possible
(meaning when all sockets have the proper SO_REUSE option).

For every socket added to a bind_bucket, these flags need to be updated.
As soon as a socket that does not support reuse is added, the flag is
set to false and will never go back to true, unless the bind_bucket is
deleted.

Note that there is no mechanism to re-evaluate these flags when a socket
is removed (this might make sense when removing a socket that would not
allow reuse; this leaves room for a future patch).

For this optimization to work, it is mandatory that these flags are
properly initialized and updated.

When a child socket is created from a listen socket in
__inet_inherit_port, the TPROXY case could create a new bind bucket
without properly initializing these flags, thus preventing the
optimization to work. Alternatively, a socket not allowing reuse could
be added to an existing bind bucket without updating the flags, causing
bind_conflict to never be called as it should.

Call inet_csk_update_fastreuse when __inet_inherit_port decides to create
a new bind_bucket or use a different bind_bucket than the one of the
listen socket.

Fixes: 093d282321da ("tproxy: fix hash locking issue when using port redirection in __inet_inherit_port()")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 net/ipv4/inet_hashtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2bbaaf0c7176..006a34b18537 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -163,6 +163,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 				return -ENOMEM;
 			}
 		}
+		inet_csk_update_fastreuse(tb, child);
 	}
 	inet_bind_hash(child, tb, port);
 	spin_unlock(&head->lock);
-- 
2.25.1


-- 


Disclaimer: https://www.tessares.net/mail-disclaimer/ 
<https://www.tessares.net/mail-disclaimer/>


