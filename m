Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F802114A9D
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 02:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfLFBt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 20:49:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbfLFBt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 20:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575596997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZCiVqYRY+eG8J7MrvEt4Cs9aLNyQGP8s7wXP5WpvI8=;
        b=hny2Zxabf5l4WbB5OxEWx6Nww5hZnll4S8FDCk8NVGX+TQ8BOVyLbTBz7HoaQLUJH/YtGK
        OQdOnbXd5v4AUHv5V6z6uZBum+T7Vrihurvd8yAhBftI2nVLN6nGAVy0fGM4RB5rHzIz/g
        MpiDbAFTf1Q6nxq5B2dJzZB3l1Ur1HI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-w4OZcK1bPvefLeMxaNr8ZA-1; Thu, 05 Dec 2019 20:49:52 -0500
Received: by mail-wm1-f71.google.com with SMTP id i17so1624184wmd.1
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 17:49:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3k1Hpq9prdTlDU48jPuPK68VBMBl8ln+cpxz4DBOOJ0=;
        b=hyZSLrPL9wHgRpb2El3B2LM7/ALR7Rxj7DgKUw6S0ayKr4nIpWeSO3fyEmJMeIlazy
         HXnWg8aE+7iCcDuOnBkppVin/Bs2ZT9NRqHgzGpd7tVB+I9TYeNw7dAGs2A8rF1ECD7M
         zCZq/SM5QurDkDI3zt6/jcHzJTx7yqplBOT0PHr2Ge/sutwlR5VioK0fCQ4bCVo36+9A
         tb91nNEPvq7FMpCWbvbJRbB4WJcLcvfAoxdlVXjCO5ArXYoUs/Kb3mSGFFNvv58fIZ5h
         XsHHXp0QE3wYBLJAiRgZXy6Ac9nW1NUCEy0U3Jp0rcRnM0aLMBWQl5tEo9uJa/kwibAt
         dvMQ==
X-Gm-Message-State: APjAAAWmazRiotFzzgXY54JDOruDga08PjoA7JVZV+8GOx4beTLaEz+D
        j4f5Y3WNdZr2C9oTGKArl8WpYdxyR87TZ5zBcH/cKe7CmnUV1qsKy6SLy0QHqw7BIIJa5MD01eH
        ZfQGsv+wqDGY1AvZ4
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr8331657wmh.101.1575596991020;
        Thu, 05 Dec 2019 17:49:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxPVp659Z0/5KU+5FwYt8eNviowE4vqAoWDU6SNbez8Sg0x1GXKDTpphdirGFEsLC04S6sow==
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr8331643wmh.101.1575596990746;
        Thu, 05 Dec 2019 17:49:50 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id e16sm1687529wme.35.2019.12.05.17.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:49:50 -0800 (PST)
Date:   Fri, 6 Dec 2019 02:49:48 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net v3 1/3] tcp: fix rejected syncookies due to stale
 timestamps
Message-ID: <3f38a305b3a07fe7b1c275d299f003f290009e13.1575595670.git.gnault@redhat.com>
References: <cover.1575595670.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1575595670.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: w4OZcK1bPvefLeMxaNr8ZA-1
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
index 0760a4f5a15c..30efc1f0f67d 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -97,4 +97,17 @@ static inline bool itimerspec64_valid(const struct itime=
rspec64 *its)
  */
 #define time_after32(a, b)=09((s32)((u32)(b) - (u32)(a)) < 0)
 #define time_before32(b, a)=09time_after32(a, b)
+
+/**
+ * time_before32 - check if a 32-bit timestamp is within a given time rang=
e
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

