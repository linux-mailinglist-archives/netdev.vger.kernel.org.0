Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1183D1D95E6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgESMIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 08:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgESMIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 08:08:16 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A3FC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 05:08:16 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id x26so14917429qvd.20
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 05:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=kWezCtzq0O0uVCqfdC9/X6n91CgK/OQqvubuuUjJ1/Q=;
        b=AXmjMopp67fJCgCpQ+O9qC+JKnk6Mb9rePxzoDz1afo3/rZOUkUL+9p7NGI6u2Jrtk
         Z7SpCRJ1xHJKvPTHrFSgk3dMwB6aFGsY2s+J35wiq2EjTCX7uLCYc3KPYwszA8m5S153
         tJ/rs8lCsoEXtI6UaKYy6swQqn9MAJMrunInyUKLXpXMfwTlLLdN+hOV6ZzdnPLe1wpE
         x5kVSFKSpeNaQHWjnAOncRtfEfRaN3WUDGDgzvjbr3qpwuD3CQ8XlUS9+DL7XvivoQXq
         uFcQVrdZDtzIef26EFBg08Q4/wvOK7/f+Uj6lDxEZHhQU80t9PRDDqe4XG3bxs48d9be
         sOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=kWezCtzq0O0uVCqfdC9/X6n91CgK/OQqvubuuUjJ1/Q=;
        b=VmZoMVZeQcWUloS9Sc/zWL33nzYWA+bk1espTSpUBGnZNheQBpo6szvOBsgDuaDIal
         AaQkvmTFFSEtx3KtOWbExu8An09Z4hxHA4d1mhnMF0cvVi3NfGQFZ/U6awQX/W1bUr7H
         Vus4oxYT0FPn/dpVPbk/vqnfhDce+ZB5TM75woSggHs561Q66fCi2PK6iHnSLvZCGzaR
         8Hg6UaybNw1/it5ATd8/nKmpyhnNalsp/s6Qu3nh+YWF8wxYtrc8e45UiFSmlRduxDq4
         zpdVGwCohETc7fqjlHPNqXCMV3s3ZhxnH2Ouzrpaa0uGH2b7IGdNla039NdHQfRKFtgH
         uF4A==
X-Gm-Message-State: AOAM531b+cp4VfaFW4+mf7uBGfRYVczSbxqiUtROCta5Daqq+PUqhCrl
        3Ssg7B5r4H5fo6GfTYcf4eB7N3jhYc24DGk=
X-Google-Smtp-Source: ABdhPJzdkkmSUsHG4JKhglcwr+I+sRLNiE4xVyFTKrJmw0wgRIxuW/7KvHYiI5/NwaesjO5nKVUvs58Fk+HYWGA=
X-Received: by 2002:a25:d7c1:: with SMTP id o184mr35727924ybg.94.1589890095543;
 Tue, 19 May 2020 05:08:15 -0700 (PDT)
Date:   Tue, 19 May 2020 14:07:48 +0200
Message-Id: <20200519120748.115833-1-brambonne@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
From:   "=?UTF-8?q?Bram=20Bonn=C3=A9?=" <brambonne@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     netdev@vger.kernel.org, Jeffrey Vander Stoep <jeffv@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        "=?UTF-8?q?Bram=20Bonn=C3=A9?=" <brambonne@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC behaves like the existing
IN6_ADDR_GEN_MODE_STABLE_PRIVACY mode, but uses the software-defined MAC
address (dev_addr) instead of the permanent, hardware-defined MAC
address (perm_addr) when generating IPv6 link-local addresses.

This mode allows the IPv6 link-local address to change in line with the
MAC address when per-network MAC address randomization is used. In this
case, the MAC address fulfills the role of both the Net_Iface and the
Network_ID parameters in RFC7217.

Signed-off-by: Bram Bonn=C3=A9 <brambonne@google.com>
---
 include/uapi/linux/if_link.h |  1 +
 net/ipv6/addrconf.c          | 29 ++++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a009365ad67b..0de71cfdcd84 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -240,6 +240,7 @@ enum in6_addr_gen_mode {
 	IN6_ADDR_GEN_MODE_NONE,
 	IN6_ADDR_GEN_MODE_STABLE_PRIVACY,
 	IN6_ADDR_GEN_MODE_RANDOM,
+	IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC,
 };
=20
 /* Bridge section */
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ab7e839753ae..02d999ca332c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -142,6 +142,7 @@ static int ipv6_count_addresses(const struct inet6_dev =
*idev);
 static int ipv6_generate_stable_address(struct in6_addr *addr,
 					u8 dad_count,
 					const struct inet6_dev *idev);
+static bool ipv6_addr_gen_use_softmac(const struct inet6_dev *idev);
=20
 #define IN6_ADDR_HSIZE_SHIFT	8
 #define IN6_ADDR_HSIZE		(1 << IN6_ADDR_HSIZE_SHIFT)
@@ -381,7 +382,8 @@ static struct inet6_dev *ipv6_add_dev(struct net_device=
 *dev)
 	timer_setup(&ndev->rs_timer, addrconf_rs_timer, 0);
 	memcpy(&ndev->cnf, dev_net(dev)->ipv6.devconf_dflt, sizeof(ndev->cnf));
=20
-	if (ndev->cnf.stable_secret.initialized)
+	if (ndev->cnf.stable_secret.initialized &&
+	    !ipv6_addr_gen_use_softmac(ndev))
 		ndev->cnf.addr_gen_mode =3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
=20
 	ndev->cnf.mtu6 =3D dev->mtu;
@@ -2540,6 +2542,8 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
 {
 	return idev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY ||
+	       idev->cnf.addr_gen_mode =3D=3D
+		       IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC ||
 	       idev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GEN_MODE_RANDOM;
 }
=20
@@ -3191,6 +3195,12 @@ static bool ipv6_reserved_interfaceid(struct in6_add=
r address)
 	return false;
 }
=20
+static inline bool ipv6_addr_gen_use_softmac(const struct inet6_dev *idev)
+{
+	return idev->cnf.addr_gen_mode =3D=3D
+	    IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC;
+}
+
 static int ipv6_generate_stable_address(struct in6_addr *address,
 					u8 dad_count,
 					const struct inet6_dev *idev)
@@ -3212,6 +3222,7 @@ static int ipv6_generate_stable_address(struct in6_ad=
dr *address,
 	struct in6_addr secret;
 	struct in6_addr temp;
 	struct net *net =3D dev_net(idev->dev);
+	unsigned char *hwaddr;
=20
 	BUILD_BUG_ON(sizeof(data.__data) !=3D sizeof(data));
=20
@@ -3222,13 +3233,16 @@ static int ipv6_generate_stable_address(struct in6_=
addr *address,
 	else
 		return -1;
=20
+	hwaddr =3D ipv6_addr_gen_use_softmac(idev) ?
+			idev->dev->dev_addr : idev->dev->perm_addr;
+
 retry:
 	spin_lock_bh(&lock);
=20
 	sha_init(digest);
 	memset(&data, 0, sizeof(data));
 	memset(workspace, 0, sizeof(workspace));
-	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
+	memcpy(data.hwaddr, hwaddr, idev->dev->addr_len);
 	data.prefix[0] =3D address->s6_addr32[0];
 	data.prefix[1] =3D address->s6_addr32[1];
 	data.secret =3D secret;
@@ -3283,6 +3297,7 @@ static void addrconf_addr_gen(struct inet6_dev *idev,=
 bool prefix_route)
 		ipv6_gen_mode_random_init(idev);
 		fallthrough;
 	case IN6_ADDR_GEN_MODE_STABLE_PRIVACY:
+	case IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC:
 		if (!ipv6_generate_stable_address(&addr, 0, idev))
 			addrconf_add_linklocal(idev, &addr,
 					       IFA_F_STABLE_PRIVACY);
@@ -5726,6 +5741,7 @@ static int check_addr_gen_mode(int mode)
 	if (mode !=3D IN6_ADDR_GEN_MODE_EUI64 &&
 	    mode !=3D IN6_ADDR_GEN_MODE_NONE &&
 	    mode !=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
+	    mode !=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC &&
 	    mode !=3D IN6_ADDR_GEN_MODE_RANDOM)
 		return -EINVAL;
 	return 1;
@@ -5734,7 +5750,8 @@ static int check_addr_gen_mode(int mode)
 static int check_stable_privacy(struct inet6_dev *idev, struct net *net,
 				int mode)
 {
-	if (mode =3D=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
+	if ((mode =3D=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY ||
+	     mode =3D=3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY) &&
 	    !idev->cnf.stable_secret.initialized &&
 	    !net->ipv6.devconf_dflt->stable_secret.initialized)
 		return -EINVAL;
@@ -6355,7 +6372,7 @@ static int addrconf_sysctl_stable_secret(struct ctl_t=
able *ctl, int write,
 		for_each_netdev(net, dev) {
 			struct inet6_dev *idev =3D __in6_dev_get(dev);
=20
-			if (idev) {
+			if (idev && !ipv6_addr_gen_use_softmac(idev)) {
 				idev->cnf.addr_gen_mode =3D
 					IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 			}
@@ -6363,7 +6380,9 @@ static int addrconf_sysctl_stable_secret(struct ctl_t=
able *ctl, int write,
 	} else {
 		struct inet6_dev *idev =3D ctl->extra1;
=20
-		idev->cnf.addr_gen_mode =3D IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
+		if (idev && !ipv6_addr_gen_use_softmac(idev))
+			idev->cnf.addr_gen_mode =3D
+				IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 	}
=20
 out:
--=20
2.26.2.761.g0e0b3e54be-goog

