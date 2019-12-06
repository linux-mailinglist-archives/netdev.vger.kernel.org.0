Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE59B114FDB
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfLFLio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:38:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbfLFLin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575632322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5IMkm+HUoknIVL/UW0ICZxx7ImFNY+fefJkNCUdrWyo=;
        b=B7ldxObarTsVSb3aCblto1FEN72Y5geMO+ESOFGGXVLld+BAbKH7JnaU31KqIQo+Aay6N/
        yYhqn2jjlusmrEwbQ5mnLq5AGaVs+RtL9qSfxQuCYrOu7X32ZXkFXlA4VNme1kkZYWCv/Y
        DaqG48YoGIWQInP2KRr5GT95GjqLM7I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-qm16vDAAOV-QvH0Pi2xegQ-1; Fri, 06 Dec 2019 06:38:40 -0500
Received: by mail-wm1-f72.google.com with SMTP id i17so2014516wmd.1
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gBcwPU9bO6oTSY7oe6RiZLWarWl1wKUfW/XkLDncnVM=;
        b=I6v7tVpkohDpsFS8XZ6zOH8C62NnUeW1FTvIGDfTy9iTWYqvnSAu3mLuwb2mc1GuFy
         e8N2IuwMN8CA/4+RMa3UaQAw+qQQ6dijKRVpA9Ye/nNa9GbCz+NQWR3zzixvRnHrSz5A
         mWV/ohv3VAcM7lPt82xKv9Q3D3n+3N3uOdvyWWnvd/REqVD00B1XY3LnngfytnEqSl40
         50tL+DlE4FZ8szY4hK6FBHmZXmPVoQMZPJX7g8mkEKuOifjloiexT2pG41qgOdqcIwGy
         EXgf6QtPtNmJV5Pcl7Lox4Ik8wATV5xvgWj122hFnN6L5N9OI+tNwjM3x6S+sH3zLbAC
         BBYg==
X-Gm-Message-State: APjAAAXGUIdrqBi3uU+nxrpHXxVrW3uNR6CS42w2hmKPgDvhscGjOnsj
        uH4VwQQOIlOkRlUsKGcPW4LA086VmUSU6xnOKyVB5++1KqCCX0h8R8G0sNrwNf4gOMY5l40yH10
        Fbc5ghBongdqXqCu6
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr16188106wrs.224.1575632319133;
        Fri, 06 Dec 2019 03:38:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKA/6Vez7hDBpMdGn/0p4Qe3oBO/b+cN6QfZODZCsddzm+zA0gJxjZhE0d+4UJyVOyDeFYSA==
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr16188071wrs.224.1575632318798;
        Fri, 06 Dec 2019 03:38:38 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id l6sm3054984wme.42.2019.12.06.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:38:38 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:38:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net v4 1/3] tcp: fix rejected syncookies due to stale
 timestamps
Message-ID: <b1e80e43ba300a37ac5ea70088769fbe8ac5bf01.1575631229.git.gnault@redhat.com>
References: <cover.1575631229.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575631229.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: qm16vDAAOV-QvH0Pi2xegQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If no synflood happens for a long enough period of time, then the
synflood timestamp isn't refreshed and jiffies can advance so much
that time_after32() can't accurately compare them any more.

Therefore, we can end up in a situation where time_after32(now,
last_overflow + HZ) returns false, just because these two values are
too far apart. In that case, the synflood timestamp isn't updated as
it should be, which can trick tcp_synq_no_recent_overflow() into
rejecting valid syncookies.

For example, let's consider the following scenario on a system
with HZ=3D1000:

  * The synflood timestamp is 0, either because that's the timestamp
    of the last synflood or, more commonly, because we're working with
    a freshly created socket.

  * We receive a new SYN, which triggers synflood protection. Let's say
    that this happens when jiffies =3D=3D 2147484649 (that is,
    'synflood timestamp' + HZ + 2^31 + 1).

  * Then tcp_synq_overflow() doesn't update the synflood timestamp,
    because time_after32(2147484649, 1000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 1000: the value of 'last_overflow' + HZ.

  * A bit later, we receive the ACK completing the 3WHS. But
    cookie_v[46]_check() rejects it because tcp_synq_no_recent_overflow()
    says that we're not under synflood. That's because
    time_after32(2147484649, 120000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 120000: the value of 'last_overflow' + TCP_SYNCOOKIE_VALID.

    Of course, in reality jiffies would have increased a bit, but this
    condition will last for the next 119 seconds, which is far enough
    to accommodate for jiffie's growth.

Fix this by updating the overflow timestamp whenever jiffies isn't
within the [last_overflow, last_overflow + HZ] range. That shouldn't
have any performance impact since the update still happens at most once
per second.

Now we're guaranteed to have fresh timestamps while under synflood, so
tcp_synq_no_recent_overflow() can safely use it with time_after32() in
such situations.

Stale timestamps can still make tcp_synq_no_recent_overflow() return
the wrong verdict when not under synflood. This will be handled in the
next patch.

For 64 bits architectures, the problem was introduced with the
conversion of ->tw_ts_recent_stamp to 32 bits integer by commit
cca9bab1b72c ("tcp: use monotonic timestamps for PAWS").
The problem has always been there on 32 bits architectures.

Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/linux/time.h | 13 +++++++++++++
 include/net/tcp.h    |  5 +++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 0760a4f5a15c..8e10b9dbd8c2 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -97,4 +97,17 @@ static inline bool itimerspec64_valid(const struct itime=
rspec64 *its)
  */
 #define time_after32(a, b)=09((s32)((u32)(b) - (u32)(a)) < 0)
 #define time_before32(b, a)=09time_after32(a, b)
+
+/**
+ * time_between32 - check if a 32-bit timestamp is within a given time ran=
ge
+ * @t:=09the time which may be within [l,h]
+ * @l:=09the lower bound of the range
+ * @h:=09the higher bound of the range
+ *
+ * time_before32(t, l, h) returns true if @l <=3D @t <=3D @h. All operands=
 are
+ * treated as 32-bit integers.
+ *
+ * Equivalent to !(time_before32(@t, @l) || time_after32(@t, @h)).
+ */
+#define time_between32(t, l, h) ((u32)(h) - (u32)(l) >=3D (u32)(t) - (u32)=
(l))
 #endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 36f195fb576a..7d734ba391fc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -494,14 +494,15 @@ static inline void tcp_synq_overflow(const struct soc=
k *sk)
 =09=09reuse =3D rcu_dereference(sk->sk_reuseport_cb);
 =09=09if (likely(reuse)) {
 =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
-=09=09=09if (time_after32(now, last_overflow + HZ))
+=09=09=09if (!time_between32(now, last_overflow,
+=09=09=09=09=09    last_overflow + HZ))
 =09=09=09=09WRITE_ONCE(reuse->synq_overflow_ts, now);
 =09=09=09return;
 =09=09}
 =09}
=20
 =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
-=09if (time_after32(now, last_overflow + HZ))
+=09if (!time_between32(now, last_overflow, last_overflow + HZ))
 =09=09tcp_sk(sk)->rx_opt.ts_recent_stamp =3D now;
 }
=20
--=20
2.21.0

