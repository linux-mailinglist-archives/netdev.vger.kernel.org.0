Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC3BAE123
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389206AbfIIWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:37:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43058 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIIWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:37:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id u72so8643928pgb.10
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o+0aLYFxsxsbeiG9ciU0Wjlqzy207eMb7ufdO3OkQes=;
        b=kiWJZZw2x/gNNOTQur4Y7wrM8IO2N2eRZ5mBTaXyw8qpzlKNSAHHbPAmPH8ZqQt2v4
         3pgPsW1y28p/f9yh94uCbnoLUkSRKUFLXamTMH/kcltpqEcWp9Cozl14uBwBtTfc0r+5
         xvvCP5sQMh2MPRQTAOSyT/N0UO+32wu37kMHZI+S6eENnaSYW1QjJVWm/oeVO1plYxef
         F+9R3rU26w1vS0ot0Lgqpljk9mGZliLpXtztkzav+DuqMf/Nb3g3As6740qyzs5PXyrQ
         uvL9/mcup69+OkD2kJpZIqg2glY8b6mx40+b5vLvrSsCf3Hur8iPWTCKPuRVCZU8faDQ
         o2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o+0aLYFxsxsbeiG9ciU0Wjlqzy207eMb7ufdO3OkQes=;
        b=k3vJXLlessLnAL2VUE2nx0XAS3V3fr42I3h94rSqVJTkuOf2Z8HoEZECztVuz+dpkd
         RfDZKf1oj1s9a1QmKKfeYJCv9YFrlf5VsTyhuWXXEU3GxOg08DCrKBx0YdkRc6za4Krg
         0WfRmCu2SUUmBIk+dU4owVwXBEKDdVx7ycb0Ik1ZaR/iJ4wpJWPO7kYdAk9nvNDdjvc6
         Xj27NW6j3B5Wo24gGdU9Vt3g2gSwaYc2snn2xDfFL4rVrx8HPwsadRG0C9zuqso65aOC
         H+vLKX/wdscak51ztqTfoMXlVXg+LclCn8IYTA8RLVQkdhDVi3GvFfF0epmIaw2hqOKT
         0Tyw==
X-Gm-Message-State: APjAAAVnCY/6MKuqh/FAbi4P53tP8rkElkggkcHilnnJyYctME27EmjT
        fhCszht30jAfYvHVZ9Ikz0vSzYmofQWo1w==
X-Google-Smtp-Source: APXvYqxZCZjI+IwQssgjNC3uYm/wXVGpVDm6uiMqHDL2opKplT0X6dkk+6wlwXaOpxDryWpc8MJUFw==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr24199395pgp.368.1568068648999;
        Mon, 09 Sep 2019 15:37:28 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id q204sm16186732pfq.176.2019.09.09.15.37.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 09 Sep 2019 15:37:27 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [RFC PATCH net-next 1/2] Allow 225/8-231/8 as unicast
Date:   Mon,  9 Sep 2019 15:37:18 -0700
Message-Id: <1568068639-6511-2-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568068639-6511-1-git-send-email-dave.taht@gmail.com>
References: <1568068639-6511-1-git-send-email-dave.taht@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the long "reserved for future use" multicast
address space, 225/8-231/8 - 120m addresses - for use as unicast
addresses instead.

In a comprehensive survey of all the open source code on the planet
we found no users of this range. We found some official and unofficial
usage of addresses in 224/8 and in 239/8 - both spaces at well under
50% allocation in the first place, so we anticipate no additional growth
for any reason, into the 225-231 spaces.

There will be some short term incompatabilities induced.

The principal flaw of converting this space to unicast involves
a non-uniext box, sending a packet to the formerly multicast address, 
and the reply coming back from that "formerly multicast" address
as unicast.

The return packet will be dropped because the source of the reply is unicast
(L2) with what the non-uniext box considers to be multicast (L3).

and, like all multicast packets sent anywhere, the attempt will still
flood all ports on the local switch.

A tcp attempt fails immediately due to the inherent IN_MULTICAST
check in the existing kernel. Some stacks (not linux) MAY do more 
of the wrong thing here.

As for userspace exposure...

We were only able to find 89 packages in fedora that used the IN_MULTICAST
macro. Currently the plan is not to kill IN_MULTICAST, (as doing it right
requires access to the big endian macros) but retire its usages in
the kernel (already done) and then the very few programs that use it userspace.

All the routing daemons we've inspected and modified don't use IN_MULTICAST.
The patches to them are trivial.

New users of multicast, seem to always pick something out of the 224/8
or 239/8 ranges, which are untouched by this patch.

Additional potential problems include: 

* hardware offloads that explicitly check for multicast
* binary firmware that explicitly checks for multicast
* a tiny cpu hit

Whether or not these problems are worth addressing to regain 120m
useful unicast addresses in the next decade is up for debate.

---
 include/linux/in.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/in.h b/include/linux/in.h
index 1873ef642605..8665842a3589 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -42,7 +42,10 @@ static inline bool ipv4_is_loopback(__be32 addr)
 
 static inline bool ipv4_is_multicast(__be32 addr)
 {
-	return (addr & htonl(0xf0000000)) == htonl(0xe0000000);
+	if((addr & htonl(0xf0000000)) == htonl(0xe0000000))
+		return !((htonl(addr) >= 0xe1000000) &&
+			 (htonl(addr) < 0xe8000000));
+	return 0;
 }
 
 static inline bool ipv4_is_local_multicast(__be32 addr)
-- 
2.17.1

