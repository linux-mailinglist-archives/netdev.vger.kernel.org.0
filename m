Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D76B7795
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 12:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbfISKjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 06:39:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34709 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfISKjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 06:39:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so1410016plr.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 03:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fkLAjWBRzi87r3meSnelHRykCAhT13Prf8T7lq9bG0=;
        b=p5Sj8d+RxqL0I00n/M1fRdO08Wwqf+TH7OVSty2NgkMDLTeb5V9UwdZ/WK7WRrGkuW
         mynyGNKweJM0bb2+XzkWmVMgS9DF1kzYcyUmAisR07Utd7Z4ElCXpvAlExvYlAGHpoql
         S+U574qW2dbGKiDiMXCK9IZTyPBgi/SkEICI523O0ER8q1r3HBUMptTfpZtYVanYeTQF
         lqdAESqJ+8s3IiOZIEooCiIa8vJf3Zn/9UkzdcBHl7y8GjhhRRaEeH8K1u8RRzxtFsfT
         lF/k+ZxKggD8E+HTYBSFl6eAB5/rQFcVpFNRZpjTQ0nPTWiXRRRNHD6BQSio7AsRUuHP
         6FcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fkLAjWBRzi87r3meSnelHRykCAhT13Prf8T7lq9bG0=;
        b=LzAm82IY9NH+xwyqZ/qThSrEP2stVfn8gAg8cN6mgGYkWgBgBkxchoANYLp3mxRyr9
         nVx0p5periDxduvcRVp7UxegBFSgkbouMpIMRlNOM0EvMpFO/PZ9YV7LqOIXNC5M9SF0
         xuMS/cPOjAx1l+VCjfoZ14F8eEjlBxnbU9DSb8wQrd7PXWnSR5swj4TT6YCZRH4WOcpS
         rsFx8deTB36DHndvQS9CNB+Q3qw5L0e7P3JU0/I/YA0iDMPIaHsUEAUlZAkUsxEhEK48
         wCXe7F8xBfGBo0xqLQMFuPK8h5KV2qxolIxrj97J0hAJukjGCCuf5u4HT4/7PpQ1xan7
         0l7w==
X-Gm-Message-State: APjAAAVzoSXUMrCU1zi9eqXPNoEa0Hco8Gr0cg37dsDAWgzRr98J+L59
        4qxxNkX0JH3r+qtMWZ46uxNVjAfrrG0nEA==
X-Google-Smtp-Source: APXvYqyfrZpUTmekfUswziWKpMkBKjhgoSv5EgdOxuuKEW11wM9q4hn2VV9daAsKlH4Jzk5wWO58TA==
X-Received: by 2002:a17:902:67:: with SMTP id 94mr9452142pla.121.1568889591116;
        Thu, 19 Sep 2019 03:39:51 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id k31sm8606273pjb.14.2019.09.19.03.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 03:39:50 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] net-icmp: remove ping_group_range sysctl
Date:   Thu, 19 Sep 2019 03:39:44 -0700
Message-Id: <20190919103944.129616-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

It is high time to make icmp sockets available to all, and thus allow
utilities like ping, ping6, traceroute and others to not require suid
root nor file system (or otherwise gained) CAP_NET_RAW privs.

While in the past there have been a number of exploits, extensive
syzcaller fuzzing should have made these safe for wide consumption,
and icmp sockets are now safer then having random suid/cap_net_raw
binaries strewn around the file system (and thus you can potentially
mount your root filesystems with nosuid and without file capabilities).

Any remaining issues need to be treated as high priority CVEs anyway,
since for example Fedora 31 is enabling this functionality system wide:
  https://fedoraproject.org/wiki/Changes/EnableSysctlPingGroupRange
(core reason: allow ping from rootless user namespace based containers)

There is at least one other highly used Linux distribution which also
unconditionally enables icmp sockets.  Thus ping sockets must work and
must be safe.

They can still be disabled via seccomp syscall bpf filters or via the
potentially even more convenient BPF_CGROUP_INET_SOCK_CREATE hook.

I did consider simply changing the in kernel defaults from '1 0' (ie.
disabled) to fully open '0 2**31-1', but the current namespace aware
sysctl is problematic for a number of reasons, and it would take
a huge amount of effort to fix the problems.  It's just not worth it.

Another possibility would be to make this sysctl non-namespace aware,
but that seems like a step backward, and besides bpf filters seem
inherently better, and we should be moving forward... icmp sockets
have been around for a long long time now.

In the default configuration, even root/cap_net_raw capable processes
fail to create icmp sockets:

  root@athina:~# id
  uid=0(root) gid=0(root) groups=0(root),125(pkcs11)
  root@athina:~# cat /proc/sys/net/ipv4/ping_group_range
  1       0
  root@athina:~# strace -ff -esocket ping6 -c 1 ::1
  socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6) = -1 EACCES (Permission denied)

even though they can change the sysctl to allow it:

  root@athina:~# echo '0 0' > /proc/sys/net/ipv4/ping_group_range
  root@athina:~# cat /proc/sys/net/ipv4/ping_group_range
  0       0
  root@athina:~# strace -ff -esocket ping6 -c 1 ::1
  socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6) = 3

It only supports non-negative signed 32-bit gids, even though in general
gids are u32 (although, to be fair, the upper half is full of lions).

It is configured via sysctl on a per netns level, as an inclusive gid range,
and is exposed to userspace mapped to the reader/writer's user ns.

This results in all sorts of craziness:

A viewed from root user ns setting of '1 0' (disabled for all) will show
up as '65534 65534' from within a userns where neither 0 nor 1 are mapped
(this is commonly the case: just run 'unshare -Ur' as normal user).  If
the viewer is in a group which is not mapped, then 'id' will show that
the user is in gid 65534(nobody), and yet icmp sockets won't work...

A viewed from root user ns setting of '0 2**31-1' (enabled for near all)
will still show up as '65534 65534' from within a userns where neither
0, nor 2**31-1 are mapped (the unpriv user common case for unshare -Ur).
If the viewer is not in any group which is not mapped, then 'id' will
show that the user is not in gid 65534, and yet icmp sockets will actually
work...

As such from within the user/net ns you can't actually tell if it is enabled
or not.

In general, any time '65534' shows up in the sysctl's text format from within
a user ns, it is meaningless: ie. a viewed from root user ns setting of '1 2'
(enabled for gids 1 and 2) will show up as '65534 2' if only gid 2 is mapped...
which makes it *seem* like it's fully disabled... and it'll show up as '1 65534'
if only gid 1 is mapped, which is possibly even more confusing.

Furthermore gids may be mapped into a user ns out of order, so even values
besides the special 'nobody (65534)' are subject to this sort of craziness.

This means that even if you see '1 0' it might not actually be disabled,
since that might map into 0 2**31-1 in the root user ns (note: AFAICT this
requires the sysctl write to happen from outside the user ns).

You would naively think writing 'x y', where 0 <= x < y <= 2**31-1 into the
sysctl would enable ping sockets for gids x..y, but not for gids w & z from
outside that range.  But it is fully possible to have w < x < y < z within
the user ns and yet have x < w,z < y within the root user ns, and thus the
sysctl doesn't actually even work, since access is granted to all 4 gids.
This is because all checking happens with compares in the root user ns.

Or x < y within, but x > y outside the user ns, and it'll be fully disabled...

Here's an example of the current state:

  maze@m1:~$ id
  uid=1000(maze) gid=1000(maze) groups=1000(maze),5000(eng)

  maze@m1:~$ unshare -Urn

  m1:~# id
  uid=0(root) gid=0(root) groups=0(root),65534(nobody)

  (we start with the kernel new netns default of 1 0)

  m1:~# cat /proc/sys/net/ipv4/ping_group_range
  65534   65534   <--- means disabled for all

  m1:~# ping6 -c 1 ::1
  ping6: icmpv6 open DGRAM socket: Permission denied

  (we externally change it to wide open 0 2**31-1)

  m1:~# cat /proc/sys/net/ipv4/ping_group_range
  65534   65534   <--- means enabled for all

  m1:~# ping6 -c 1 ::1
  PING ::1(::1) 56 data bytes
  64 bytes from ::1: icmp_seq=1 ttl=64 time=0.015 ms

Another example showing you can't trust reading the sysctl:

  m1:~# cat /proc/sys/net/ipv4/ping_group_range; id; unshare -Un
  0       2147483647
  uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),26(tape)
  nobody@m1:~$ echo $$; id; cat /proc/sys/net/ipv4/ping_group_range
  46444
  uid=65534(nobody) gid=65534(nobody) groups=65534(nobody)
  65534   65534   <--- really means disabled, since default was '1 0'

  (from outside namespace)
  m1:~# echo -en "0 0 1\n" | dd bs=4096 of=/proc/46444/uid_map
  6 bytes (6 B) copied, 3.6845e-05 s, 163 kB/s
  m1:~# echo -en "0 1 1\n$[(1<<31)-1] 0 1\n" | dd bs=4096 of=/proc/46444/gid_map
  21 bytes (21 B) copied, 3.5492e-05 s, 592 kB/s

  nobody@m1:~$ echo $$; id; cat /proc/sys/net/ipv4/ping_group_range
  46444
  uid=0(root) gid=2147483647 groups=2147483647,0(root),65534(nobody)  <-- 2**31-1 shows up only cause we were in 1(bin)
  0       2147483647   <--- still means disabled and not fully enabled like you would expect

One more example which shows the craziness caused by this OR:
  if (urange[1] < urange[0] || gid_lt(high, low)) {
    low = make_kgid(&init_user_ns, 1);
    high = make_kgid(&init_user_ns, 0);
on sysctl write.

  m1:~# cat /proc/sys/net/ipv4/ping_group_range; id; unshare -Un
  0       2147483647
  uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),26(tape)
  nobody@m1:~$ echo $$; id; cat /proc/sys/net/ipv4/ping_group_range
  49077
  uid=65534(nobody) gid=65534(nobody) groups=65534(nobody)
  65534   65534   <--- really means '1 0' disabled.

  (from outside namespace)
  m1:~# echo -en "0 0 1\n" | dd bs=4096 of=/proc/49077/uid_map
  6 bytes (6 B) copied, 4.7958e-05 s, 125 kB/s
  m1:~# echo -en "0 1 1\n1 0 1\n" | dd bs=4096 of=/proc/49077/gid_map
  12 bytes (12 B) copied, 3.358e-05 s, 357 kB/s

  nobody@m1:~$ id; cat /proc/sys/net/ipv4/ping_group_range
  uid=0(root) gid=1(bin) groups=1(bin),0(root),65534(nobody)
  0       1   <--- still really means disabled - we haven't changed the sysctl.

  nobody@m1:~$ echo '0 1' > /proc/sys/net/ipv4/ping_group_range
  nobody@m1:~$ cat /proc/sys/net/ipv4/ping_group_range
  0       1   <--- you'd think this means 0..1, but it still means disabled,
                   this is because the kernel encoding of '0 1' is '1 0'
                   which is out of order and triggers the OR.

  nobody@m1:~$ echo '1 0' > /proc/sys/net/ipv4/ping_group_range
  nobody@m1:~$ cat /proc/sys/net/ipv4/ping_group_range
  0       1   <--- huh? and it *still* means disabled because the user
                   encoding of '1 0' is out of order and triggers the OR...

  nobody@m1:~$ echo '0 0' > /proc/sys/net/ipv4/ping_group_range
  nobody@m1:~$ cat /proc/sys/net/ipv4/ping_group_range
  0       0   <--- correct root user ns gid(1) which is gid(0) here is allowed

  nobody@m1:~$ echo '1 1' > /proc/sys/net/ipv4/ping_group_range
  nobody@m1:~$ cat /proc/sys/net/ipv4/ping_group_range
  1       1   <--- correct root user ns gid(0) which is gid(1) here is allowed

  nobody@m1:~$ echo '2 0' > /proc/sys/net/ipv4/ping_group_range
  -bash: echo: write error: Invalid argument

  nobody@m1:~$ echo '0 2' > /proc/sys/net/ipv4/ping_group_range
  -bash: echo: write error: Invalid argument

Additionally if you only have 1 gid 'X' mapped into a user ns, then there
isn't even a way to set the sysctl to disabled (from within), because you
can only write valid gids, and thus you'll always end up with anything
besides 'X X' being invalid, and thus you can only open access up to gid X
as opposed to denying it.  (to be fair, it starts disabled, so this is only
a problem if you first enable it)

Cc: Kees Cook <keescook@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/netns/ipv4.h   |  7 ----
 net/ipv4/af_inet.c         |  8 -----
 net/ipv4/ping.c            | 39 +--------------------
 net/ipv4/sysctl_net_ipv4.c | 72 --------------------------------------
 4 files changed, 1 insertion(+), 125 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index bc24a8ec1ce5..b65ea5457694 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -24,11 +24,6 @@ struct local_ports {
 	bool		warned;
 };
 
-struct ping_group_range {
-	seqlock_t	lock;
-	kgid_t		range[2];
-};
-
 struct inet_hashinfo;
 
 struct inet_timewait_death_row {
@@ -190,8 +185,6 @@ struct netns_ipv4 {
 	int sysctl_igmp_llm_reports;
 	int sysctl_igmp_qrv;
 
-	struct ping_group_range ping_group_range;
-
 	atomic_t dev_addr_genid;
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ed2301ef872e..7e053c2bfef3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1814,14 +1814,6 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.ip_local_ports.range[0] =  32768;
 	net->ipv4.ip_local_ports.range[1] =  60999;
 
-	seqlock_init(&net->ipv4.ping_group_range.lock);
-	/*
-	 * Sane defaults - nobody may create ping sockets.
-	 * Boot scripts should set this to distro-specific group.
-	 */
-	net->ipv4.ping_group_range.range[0] = make_kgid(&init_user_ns, 1);
-	net->ipv4.ping_group_range.range[1] = make_kgid(&init_user_ns, 0);
-
 	/* Default values for sysctl-controlled parameters.
 	 * We set them here, in case sysctl is not compiled.
 	 */
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 9d24ef5c5d8f..5e1456161e14 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -234,50 +234,13 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 	return sk;
 }
 
-static void inet_get_ping_group_range_net(struct net *net, kgid_t *low,
-					  kgid_t *high)
-{
-	kgid_t *data = net->ipv4.ping_group_range.range;
-	unsigned int seq;
-
-	do {
-		seq = read_seqbegin(&net->ipv4.ping_group_range.lock);
-
-		*low = data[0];
-		*high = data[1];
-	} while (read_seqretry(&net->ipv4.ping_group_range.lock, seq));
-}
-
 
 int ping_init_sock(struct sock *sk)
 {
-	struct net *net = sock_net(sk);
-	kgid_t group = current_egid();
-	struct group_info *group_info;
-	int i;
-	kgid_t low, high;
-	int ret = 0;
-
 	if (sk->sk_family == AF_INET6)
 		sk->sk_ipv6only = 1;
 
-	inet_get_ping_group_range_net(net, &low, &high);
-	if (gid_lte(low, group) && gid_lte(group, high))
-		return 0;
-
-	group_info = get_current_groups();
-	for (i = 0; i < group_info->ngroups; i++) {
-		kgid_t gid = group_info->gid[i];
-
-		if (gid_lte(low, gid) && gid_lte(gid, high))
-			goto out_release_group;
-	}
-
-	ret = -EACCES;
-
-out_release_group:
-	put_group_info(group_info);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ping_init_sock);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0b980e841927..3aa9724e943b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -45,8 +45,6 @@ static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
 static int tcp_syn_retries_min = 1;
 static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
-static int ip_ping_group_range_min[] = { 0, 0 };
-static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
@@ -140,69 +138,6 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 	return ret;
 }
 
-static void inet_get_ping_group_range_table(struct ctl_table *table, kgid_t *low, kgid_t *high)
-{
-	kgid_t *data = table->data;
-	struct net *net =
-		container_of(table->data, struct net, ipv4.ping_group_range.range);
-	unsigned int seq;
-	do {
-		seq = read_seqbegin(&net->ipv4.ping_group_range.lock);
-
-		*low = data[0];
-		*high = data[1];
-	} while (read_seqretry(&net->ipv4.ping_group_range.lock, seq));
-}
-
-/* Update system visible IP port range */
-static void set_ping_group_range(struct ctl_table *table, kgid_t low, kgid_t high)
-{
-	kgid_t *data = table->data;
-	struct net *net =
-		container_of(table->data, struct net, ipv4.ping_group_range.range);
-	write_seqlock(&net->ipv4.ping_group_range.lock);
-	data[0] = low;
-	data[1] = high;
-	write_sequnlock(&net->ipv4.ping_group_range.lock);
-}
-
-/* Validate changes from /proc interface. */
-static int ipv4_ping_group_range(struct ctl_table *table, int write,
-				 void __user *buffer,
-				 size_t *lenp, loff_t *ppos)
-{
-	struct user_namespace *user_ns = current_user_ns();
-	int ret;
-	gid_t urange[2];
-	kgid_t low, high;
-	struct ctl_table tmp = {
-		.data = &urange,
-		.maxlen = sizeof(urange),
-		.mode = table->mode,
-		.extra1 = &ip_ping_group_range_min,
-		.extra2 = &ip_ping_group_range_max,
-	};
-
-	inet_get_ping_group_range_table(table, &low, &high);
-	urange[0] = from_kgid_munged(user_ns, low);
-	urange[1] = from_kgid_munged(user_ns, high);
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
-
-	if (write && ret == 0) {
-		low = make_kgid(user_ns, urange[0]);
-		high = make_kgid(user_ns, urange[1]);
-		if (!gid_valid(low) || !gid_valid(high))
-			return -EINVAL;
-		if (urange[1] < urange[0] || gid_lt(high, low)) {
-			low = make_kgid(&init_user_ns, 1);
-			high = make_kgid(&init_user_ns, 0);
-		}
-		set_ping_group_range(table, low, high);
-	}
-
-	return ret;
-}
-
 static int ipv4_fwd_update_priority(struct ctl_table *table, int write,
 				    void __user *buffer,
 				    size_t *lenp, loff_t *ppos)
@@ -658,13 +593,6 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-	{
-		.procname	= "ping_group_range",
-		.data		= &init_net.ipv4.ping_group_range.range,
-		.maxlen		= sizeof(gid_t)*2,
-		.mode		= 0644,
-		.proc_handler	= ipv4_ping_group_range,
-	},
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	{
 		.procname	= "raw_l3mdev_accept",
-- 
2.23.0.351.gc4317032e6-goog

