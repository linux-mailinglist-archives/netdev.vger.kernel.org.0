Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F1B44EFFC
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 00:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhKLXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 18:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhKLXVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 18:21:04 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FA2C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 15:18:13 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id a129so5927651vkb.8
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 15:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=+YE0TrBkdCf4EZe+j3BveCgvkeZJosSzwCNS1cd/eyI=;
        b=0W/L60VxiHRXO4r7xOkyJecumZ+/eFBtAT63q4n+1hAl/dWdVw185gD9zGu/eCqYaC
         rjmGFWUZkr+qihpm7m8Kyaayk/gW8EfQpPu4cg6S0iRtJ/qL7xj7WYaHd9MHe5EUGvjL
         7ZBhrjSZcDJVRr927myBsLqH2kfspvn5gNwzrDnwwgKEJBYwn47tWxQ9jFtmL88RxQBN
         UDz2EAwbWG4CRO/lKSuJ4ztUpNflEfhq9XIc12ujLw6RkNKr+8SZ4v/banm9aIQvhObk
         BoAdgkPleOZIqQtDWbUoK+M0CcCgFloiVJdPtUry7u8BTIPRfqULk1oFD/0idReY1u8r
         6iGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=+YE0TrBkdCf4EZe+j3BveCgvkeZJosSzwCNS1cd/eyI=;
        b=KM0TjSzl73zljMIggS+eJ28XZtB+3VI9ZprWgtOeHOxKwtjH1h3PFuSiIk68Wm3ZJg
         S9yIXpp2anl2qXQe+3JRcegQFklBHLQvdFD5j3+SNHlxwAdrdK7NBsIxkXonPq0WrYtP
         Fhu944NTEPM6qqclU4N2YkiIeEr60VF9eShKkA+MIGYM0hVol5FX3aQX4Y0P3JlRYUjD
         jhvSJGBZWNesT2G2FdPD/iKQtM4CpLXf0tTNhFpgg+PHF1AbcGg0PHJIn48N+ZMFuglg
         rSf3HI8994lXOuVe/ENB2muufRlrHWQBRwKa7+Jc0Hn0/vKBMjad+t6ClR5WFqtWJBje
         cnOA==
X-Gm-Message-State: AOAM533f0kxVVAwStGV5lK1tWmo8ajGmAkpn4FF+Inc5R49s0GbtMtqD
        NkiA4Gyd+4UrKAtryG7qtBvoI3Jib2ur
X-Google-Smtp-Source: ABdhPJx1VOVJA+qE9T71YUKWFlny/IO5ty631r/bvGyoBCyGO8ZVXWDyhZZP71LcpAwAGmXcfZPAIA==
X-Received: by 2002:a05:6122:2214:: with SMTP id bb20mr28607030vkb.9.1636759092195;
        Fri, 12 Nov 2021 15:18:12 -0800 (PST)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id k1sm5399233uaq.0.2021.11.12.15.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 15:18:11 -0800 (PST)
Subject: [PATCH] net,lsm,selinux: revert the security_sctp_assoc_established()
 hook
From:   Paul Moore <paul@paul-moore.com>
To:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     netdev@vger.kernel.org
Date:   Fri, 12 Nov 2021 18:18:10 -0500
Message-ID: <163675909043.176428.14878151490285663317.stgit@olly>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reverts two prior patches, e7310c94024c
("security: implement sctp_assoc_established hook in selinux") and
7c2ef0240e6a ("security: add sctp_assoc_established hook"), which
create the security_sctp_assoc_established() LSM hook and provide a
SELinux implementation.  Unfortunately these two patches were merged
without proper review (the Reviewed-by and Tested-by tags from
Richard Haines were for previous revisions of these patches that
were significantly different) and there are outstanding objections
from the SELinux maintainers regarding these patches.

Work is currently ongoing to correct the problems identified in the
reverted patches, as well as others that have come up during review,
but it is unclear at this point in time when that work will be ready
for inclusion in the mainline kernel.  In the interest of not keeping
objectionable code in the kernel for multiple weeks, and potentially
a kernel release, we are reverting the two problematic patches.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 Documentation/security/SCTP.rst |   22 ++++++++++++----------
 include/linux/lsm_hook_defs.h   |    2 --
 include/linux/lsm_hooks.h       |    5 -----
 include/linux/security.h        |    7 -------
 net/sctp/sm_statefuns.c         |    2 +-
 security/security.c             |    7 -------
 security/selinux/hooks.c        |   14 +-------------
 7 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index 406cc68b8808..d5fd6ccc3dcb 100644
--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -15,7 +15,10 @@ For security module support, three SCTP specific hooks have been implemented::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-    security_sctp_assoc_established()
+
+Also the following security hook has been utilised::
+
+    security_inet_conn_established()
 
 The usage of these hooks are described below with the SELinux implementation
 described in the `SCTP SELinux Support`_ chapter.
@@ -119,12 +122,11 @@ calls **sctp_peeloff**\(3).
     @newsk - pointer to new sock structure.
 
 
-security_sctp_assoc_established()
+security_inet_conn_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Called when a COOKIE ACK is received, and the peer secid will be
-saved into ``@asoc->peer_secid`` for client::
+Called when a COOKIE ACK is received::
 
-    @asoc - pointer to sctp association structure.
+    @sk  - pointer to sock structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
@@ -132,7 +134,7 @@ Security Hooks used for Association Establishment
 -------------------------------------------------
 
 The following diagram shows the use of ``security_sctp_bind_connect()``,
-``security_sctp_assoc_request()``, ``security_sctp_assoc_established()`` when
+``security_sctp_assoc_request()``, ``security_inet_conn_established()`` when
 establishing an association.
 ::
 
@@ -170,7 +172,7 @@ establishing an association.
           <------------------------------------------- COOKIE ACK
           |                                               |
     sctp_sf_do_5_1E_ca                                    |
- Call security_sctp_assoc_established()                   |
+ Call security_inet_conn_established()                    |
  to set the peer label.                                   |
           |                                               |
           |                               If SCTP_SOCKET_TCP or peeled off
@@ -196,7 +198,7 @@ hooks with the SELinux specifics expanded below::
     security_sctp_assoc_request()
     security_sctp_bind_connect()
     security_sctp_sk_clone()
-    security_sctp_assoc_established()
+    security_inet_conn_established()
 
 
 security_sctp_assoc_request()
@@ -269,12 +271,12 @@ sockets sid and peer sid to that contained in the ``@asoc sid`` and
     @newsk - pointer to new sock structure.
 
 
-security_sctp_assoc_established()
+security_inet_conn_established()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Called when a COOKIE ACK is received where it sets the connection's peer sid
 to that in ``@skb``::
 
-    @asoc - pointer to sctp association structure.
+    @sk  - pointer to sock structure.
     @skb - pointer to skbuff of the COOKIE ACK packet.
 
 
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 442a611fa0fb..df8de62f4710 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -335,8 +335,6 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
-LSM_HOOK(void, LSM_RET_VOID, sctp_assoc_established, struct sctp_association *asoc,
-	 struct sk_buff *skb)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index d6823214d5c1..d45b6f6e27fd 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1050,11 +1050,6 @@
  *	@asoc pointer to current sctp association structure.
  *	@sk pointer to current sock structure.
  *	@newsk pointer to new sock structure.
- * @sctp_assoc_established:
- *	Passes the @asoc and @chunk->skb of the association COOKIE_ACK packet
- *	to the security module.
- *	@asoc pointer to sctp association structure.
- *	@skb pointer to skbuff of association packet.
  *
  * Security hooks for Infiniband
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 06eac4e61a13..bbf44a466832 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1430,8 +1430,6 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
-void security_sctp_assoc_established(struct sctp_association *asoc,
-				     struct sk_buff *skb);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1651,11 +1649,6 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
 					  struct sock *newsk)
 {
 }
-
-static inline void security_sctp_assoc_established(struct sctp_association *asoc,
-						   struct sk_buff *skb)
-{
-}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 39ba82ee87ce..354c1c4de19b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -946,7 +946,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
 
 	/* Set peer label for connection. */
-	security_sctp_assoc_established((struct sctp_association *)asoc, chunk->skb);
+	security_inet_conn_established(ep->base.sk, chunk->skb);
 
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
diff --git a/security/security.c b/security/security.c
index 779a9edea0a0..c88167a414b4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2388,13 +2388,6 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
-void security_sctp_assoc_established(struct sctp_association *asoc,
-				     struct sk_buff *skb)
-{
-	call_void_hook(sctp_assoc_established, asoc, skb);
-}
-EXPORT_SYMBOL(security_sctp_assoc_established);
-
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5e5215fe2e83..62d30c0a30c2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5502,8 +5502,7 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
 	if (!selinux_policycap_extsockclass())
 		return selinux_sk_clone_security(sk, newsk);
 
-	if (asoc->secid != SECSID_WILD)
-		newsksec->sid = asoc->secid;
+	newsksec->sid = asoc->secid;
 	newsksec->peer_sid = asoc->peer_secid;
 	newsksec->sclass = sksec->sclass;
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
@@ -5559,16 +5558,6 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
 }
 
-static void selinux_sctp_assoc_established(struct sctp_association *asoc,
-					   struct sk_buff *skb)
-{
-	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
-
-	selinux_inet_conn_established(asoc->base.sk, skb);
-	asoc->peer_secid = sksec->peer_sid;
-	asoc->secid = SECSID_WILD;
-}
-
 static int selinux_secmark_relabel_packet(u32 sid)
 {
 	const struct task_security_struct *__tsec;
@@ -7239,7 +7228,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
 	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
 	LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
-	LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),

