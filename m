Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E50A2C904F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgK3VyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgK3VyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:54:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26085C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:53:25 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id s13so9559514ejr.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H7iUhNSix7GZpZhonIGILqFYgzHEexAyQxsud+nzpBI=;
        b=l0RtI83hH2d00jqQjA7Clpvh58bN6DfwnHzSkPbCg16RzJkmgSf5/QzvBF9N4YL/HQ
         VL6T6hvTL9G+giXHA7xQoO3sBi+2+5uCLZUOF4JCv9a/5wbNI4tPcj5sdDaM7YpNoQem
         9YVRLkFXVB6CqfeSVsuPGQjVTqTgfYeGYesOV5A0085SmeJbY8lj5oXDLHfwDo+mlyrp
         qUeybEOIW180xZlCnSIcJEyR6JqSMZxciEqA2e1cGcbNAX4HfgXki8arDxsTlAGMf3Jc
         inQIZ2nf0fFvFqOh7bNBW/lEVNveZk9Q+rRcKsSGwosmYWx/mQHSTjcMCJWopRdM06te
         Qnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H7iUhNSix7GZpZhonIGILqFYgzHEexAyQxsud+nzpBI=;
        b=BAQHbVj4ZRdIaNJC/Swml+Atz/FqahFKzwmcxDpMFc/suajkmMg1eMeRUjnEF9BX6i
         Kf/mwlHUnRaWQYajtqQDBZX0IVe983rCB48GcWeA6U/RvjNtm0Z0UqGximpd+chvROqG
         OY6jFQLx9FcZXkKACcmK77IA/2wDk4j2g5mP/O1Fj2Ooa35fzSZUMVHVRD9gkdQFkoWH
         u1f79OnYolJADMzI9Ibh6KuIrVXGj6td22zbhdv2Yra1O6v+PvQI4XVjDeabBXBpDBHa
         x4ZeRqFZkMuDdRKesdcwi4xNzJmQwwrB+zYEcEBj6KojSp5M75HeGRmg4UTskIv4DBWf
         sBmw==
X-Gm-Message-State: AOAM530yAVOGClmsVWTKSEgKdLTyPbSHxldfc5oHiRmkmja3UCdYJ53G
        fFr373RCqfmtejjANA23Tbw=
X-Google-Smtp-Source: ABdhPJwD6g9bDJ/iUH5Ltzyg5JIaEMx+vwZfHIDtzTNfO0tizi9zSp+D7JNwQ46Nk1bP/xBkFNO2sw==
X-Received: by 2002:a17:906:3c04:: with SMTP id h4mr4402002ejg.220.1606773203876;
        Mon, 30 Nov 2020 13:53:23 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id pk19sm6800885ejb.32.2020.11.30.13.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 13:53:23 -0800 (PST)
Date:   Mon, 30 Nov 2020 23:53:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130215322.7arp3scumobdnvtz@skbuf>
References: <20201130194617.kzfltaqccbbfq6jr@skbuf>
 <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf>
 <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf>
 <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf>
 <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
 <20201130211158.37ay2uvdwcnegw45@skbuf>
 <CANn89iJGA8qWBJ97nnNGNOuLNUYF5WPnL+qi722KYCD7kvKyCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJGA8qWBJ97nnNGNOuLNUYF5WPnL+qi722KYCD7kvKyCg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:46:00PM +0100, Eric Dumazet wrote:
> You can not use dev_base_lock() or RCU and call an ndo_get_stats64()
> that could sleep.
>
> You can not for example start changing bonding, since bond_get_stats()
> could be called from non-sleepable context (net/core/net-procfs.c)
>
> I am still referring to your patch adding :
>
> +       if (!rtnl_locked)
> +               rtnl_lock();
>
> This is all I said.

Ah, ok, well I didn't show you all the patches, did I?

-----------------------------[cut here]-----------------------------
From d62c65ef6cb357e1b8c5a4ab189718e157a569ae Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 26 Nov 2020 23:08:57 +0200
Subject: [PATCH] net: procfs: retrieve device statistics under RTNL, not RCU

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.
We still need some protection against an interface registering or
deregistering, and the writer-side lock, the RTNL mutex, is fine for
that, because it offers sleepable context.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-procfs.c                   | 11 ++++++-----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..1429e8c066d8 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/rtnetlink.h>
 #include <linux/seq_file.h>
 #include <net/wext.h>
 
@@ -21,7 +22,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +52,9 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
+	__acquires(rtnl_mutex)
 {
-	rcu_read_lock();
+	rtnl_lock();
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +71,9 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
+	__releases(rtnl_mutex)
 {
-	rcu_read_unlock();
+	rtnl_unlock();
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-----------------------------[cut here]-----------------------------

and:

-----------------------------[cut here]-----------------------------
From 0c51569116b3844d0d99831697a8e4134814d50e Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 30 Nov 2020 02:51:01 +0200
Subject: [PATCH] net: sysfs: retrieve device statistics unlocked

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

I need to preface this by saying that I have no idea why netstat_show
takes the dev_base_lock rwlock. Two things are for certain:
(a) it's not due to dev_isalive requiring it for some mystical reason,
    because broadcast_show() also calls dev_isalive() and has had no
    problem existing since the beginning of git.
(b) the dev_get_stats function definitely does not need dev_base_lock
    protection either. In fact, holding the dev_base_lock is the entire
    problem here, because we want to make dev_get_stats sleepable, and
    holding a rwlock gives us atomic context.

So since no protection seems to be necessary, just run unlocked while
retrieving the /sys/class/net/eth0/statistics/* values.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 999b70c59761..0782a476b424 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -585,14 +585,13 @@ static ssize_t netstat_show(const struct device *d,
 	WARN_ON(offset > sizeof(struct rtnl_link_stats64) ||
 		offset % sizeof(u64) != 0);
 
-	read_lock(&dev_base_lock);
 	if (dev_isalive(dev)) {
 		struct rtnl_link_stats64 temp;
 		const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
 		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
 	}
-	read_unlock(&dev_base_lock);
+
 	return ret;
 }
 
-----------------------------[cut here]-----------------------------

In all fairness, I think there is precedent in the kernel for changing
so much RCU-protected code to use RTNL. I can't recall the exact link
now, except for this one:
https://patchwork.ozlabs.org/project/netdev/patch/1410306738-18036-2-git-send-email-xiyou.wangcong@gmail.com/,
but you and Cong have changed a lot of RCU-protected accesses in IPv6,
because the read-side critical section was taking too much time and was
not sleepable/preemptible.

Now, I do agree that there's only so much we can keep adding to the RTNL
mutex. I guess somebody needs to start the migration towards a different
mutex. I'll prepare some patches then, and rework the ones that I have.
