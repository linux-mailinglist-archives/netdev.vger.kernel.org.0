Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34C11CBB53
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgEHXmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgEHXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:42:31 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A09C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 16:42:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ms17so4997641pjb.0
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yvq0ZmxrGJGmnTkKVHrgQ8HIr3Yi89VjjxdI6u6jLNk=;
        b=J8RwbNVeDinU256PIue9Crd+eiqfLpznno9kpJUYFt2o2YoRZ7TIW0kkO1Ju3e+FLd
         2EjXonj78oQ9yGY1zqOT5HgnJrRtXQIqAWeHe/Ba+QkjG4Nt+eAaXOzzAwSgzyo3m2jY
         uDdgX5sWvXS8Wl6vmOKQ/H3fw6lDPpnQ6lipgHOQthmzUQ3GQAaUg1IHU8t9uH8K4z8o
         zZuy3nczVD1JGU5AFmM6qCm9HiAPRxQGXGhTmkMOkTo5orghLR3/HwdDeBn4ut0TekSg
         o/aBRumUNKOfvoqFsyaF5hip2W3uimxRJTgA3pkrkBS+o4rxc+v/9ATB6xqBnjpGsySb
         kjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yvq0ZmxrGJGmnTkKVHrgQ8HIr3Yi89VjjxdI6u6jLNk=;
        b=gAbeWYPt+huRXaTzv4hmkyXACnGzDhTGPEdZ4nxwY/xbhAIlcF49ZOvigF6nSiUoMQ
         k1fDDrgzbxa+Qf9CvfozOJpuAdsawf1LOAXSC6BTlhD+W4gDLzcimxJz8JGZ+iD0SFqi
         lDLbpY4i4IPDvJI3Ti1gev0JwMXg5AKbp8spSA8uBSPwbO+iH8xUYMlJm9zgiDN6Bprk
         8Xt4sWP4sJoOHVLROHlHpqLf93HST3nnXwvfzyUa3dGT0ofgyptd7igMPzGGikcQNSeQ
         DTZ7lk7GUgR1BRAYLjbYsSbjn9zPYgShErMS5QO+9n3ZtTyvvddlYhPx1FjIh8xZTQlj
         Nddg==
X-Gm-Message-State: AGi0PuYhhlwvSlNi+XIaV3k87B8rpA/heQ8M52tClO0OEwzMssXK9I+p
        3StjVcpJuTdntq7yMbTKBDQy7tRd
X-Google-Smtp-Source: APiQypJifrT090vKvz4zriWa5tUWpi1Bo3bPBp5xxsf2RAMkF7LM+07ak4/OvYmvDAoUya7LXC0zEQ==
X-Received: by 2002:a17:90a:e596:: with SMTP id g22mr8594595pjz.201.1588981350555;
        Fri, 08 May 2020 16:42:30 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id j186sm2958908pfb.220.2020.05.08.16.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 16:42:29 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Subject: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all by default
Date:   Fri,  8 May 2020 16:42:23 -0700
Message-Id: <20200508234223.118254-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This makes 'ping' 'ping6' and icmp based traceroute no longer
require any suid or file capabilities.

These sockets have baked long enough that the restriction
to make them unusable by default is no longer necessary.

The concerns were around exploits.  However there are now
major distros that default to enabling this.

This is already the default on Fedora 31:
  [root@f31vm ~]# cat /proc/sys/net/ipv4/ping_group_range
  0       2147483647
  [root@f31vm ~]# cat /usr/lib/sysctl.d/50-default.conf | egrep -B6 ping_group_range
  # ping(8) without CAP_NET_ADMIN and CAP_NET_RAW
  # The upper limit is set to 2^31-1. Values greater than that get rejected by
  # the kernel because of this definition in linux/include/net/ping.h:
  #   #define GID_T_MAX (((gid_t)~0U) >> 1)
  # That's not so bad because values between 2^31 and 2^32-1 are reserved on
  # systemd-based systems anyway: https://systemd.io/UIDS-GIDS.html#summary
  -net.ipv4.ping_group_range = 0 2147483647

And in general is super useful for any network namespace container
based setup.  See for example: https://docs.docker.com/engine/security/rootless/

This is one less thing you need to configure when you creare a new network
namespace.

Before:
  vm:~# unshare -n
  vm:~# cat /proc/sys/net/ipv4/ping_group_range
  1       0

After:
  vm:~# unshare -n
  vm:~# cat /proc/sys/net/ipv4/ping_group_range
  0       2147483647

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv4/af_inet.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index cf58e29cf746..1a8cb6f3ee38 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1819,12 +1819,8 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.ip_local_ports.range[1] =  60999;
 
 	seqlock_init(&net->ipv4.ping_group_range.lock);
-	/*
-	 * Sane defaults - nobody may create ping sockets.
-	 * Boot scripts should set this to distro-specific group.
-	 */
-	net->ipv4.ping_group_range.range[0] = make_kgid(&init_user_ns, 1);
-	net->ipv4.ping_group_range.range[1] = make_kgid(&init_user_ns, 0);
+	net->ipv4.ping_group_range.range[0] = GLOBAL_ROOT_GID;
+	net->ipv4.ping_group_range.range[1] = KGIDT_INIT(0x7FFFFFFF);
 
 	/* Default values for sysctl-controlled parameters.
 	 * We set them here, in case sysctl is not compiled.
-- 
2.26.2.645.ge9eca65c58-goog

