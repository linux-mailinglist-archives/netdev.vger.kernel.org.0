Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16EA185E5B
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgCOQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 12:00:15 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34899 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728310AbgCOQAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 12:00:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D4151210DB;
        Sun, 15 Mar 2020 12:00:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 15 Mar 2020 12:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=9PWyHXhfW3ToJcLRrnJPwdIaXz
        ZIdQFrXcTKiVURnU0=; b=YuTUH1MehIUNSb+JSBcQH5lTnQxCahZztj5xsAQLud
        ISt76QmpLFFlQdTftMA8uT/QArWsaYvtsT8Cj4U8L8X6sRJcGmvHiG/9vZtB6834
        YENbiY8/1xZBPEOIeLZaoeUN8CDqJ06CKm7l3b2BNQzQZ3A3slwTv/4VRW//rkUJ
        JjB2aBVwDVNeArKQjm+ASW+SwGVxCEkANiGDfCUAL4QgPGNdclf9bEYbY/2YSRZA
        MXaFYKICWejy2tAKOk2+o5fyGRn3hfEFtmzM5zkin5W0ERyv7m4jXTf8lxGjwwuh
        qjdAX5g9OxmBVcgPlMtOJiCg5gCAqpYnHRv/ShT2i9xg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9PWyHXhfW3ToJcLRr
        nJPwdIaXzZIdQFrXcTKiVURnU0=; b=CxTO1LsvwCUNzrNSLcHmaFjDIi7UrpbeG
        +VJjTn2sRas1gsokVW42jEtpPUf3N9oBIUwNwpuK3XGb0A34IgXDUUa/CiJeJ7Yx
        2EntQzKqVfaHilIzeBRZnYn5dfzvLyRMrt43nUTQP3jKpWHGDJMMUnH0rVhznnmP
        JxlxVf4IYc5gaRXUaL8tQRAP+xMn39+SPNzgODV74eRcszLZkH7etrWc4vxeFSBD
        qbR4Sd0PSRdV41jfZrolzfcAPMMi/kt9pwJ8fNyVAp4zEN0X36thpZC1o7Eu+MKv
        ccocJ0zk3MYMYUSRSRT0IS0SWt0+3cKZmayZxPYYdy8aRpWzi2Lew==
X-ME-Sender: <xms:DFFuXtSeAigkC9-CmBK8f0OH0wyOG_dasxtHWxIEH1eh_Uu4peyHkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeftddgvddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgghinhgtvghn
    thcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecukfhppeekvd
    druddvgedrvddvfedrkeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsggvrhhnrghtsehluhhffhihrdgtgi
X-ME-Proxy: <xmx:DVFuXiSrUkq9DiA8QFuIRr8aPqycEwuwqs-UrQFdhTIS3i9817U-OA>
    <xmx:DVFuXpRgxm3NUdnpOn2WzvB3_jJsNrpedh4wQNN-EwDlC-_9t_qNhg>
    <xmx:DVFuXv7TwY0-9YqDqyMtwpGFME77T2Cs50GluulEBjvEyMm1ijd7ng>
    <xmx:DVFuXvFAY3iPOm-lV6zyYKXxs6S9u0fH9T_qwxMflcZpn0dafuU6RQ>
Received: from neo.luffy.cx (lfbn-idf1-1-140-83.w82-124.abo.wanadoo.fr [82.124.223.83])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4ADC306218B;
        Sun, 15 Mar 2020 12:00:12 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id A2043576; Sun, 15 Mar 2020 17:00:11 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for non-root users
Date:   Sun, 15 Mar 2020 16:59:11 +0100
Message-Id: <20200315155910.3262015-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
non-root user to bind a socket to an interface if it is not already
bound. This is useful to allow an application to bind itself to a
specific VRF for outgoing or incoming connections. Currently, an
application wanting to manage connections through several VRF need to
be privileged. Moreover, I don't see a reason why an application
couldn't restrict its own scope. Such a privilege is already possible
with UDP through IP_UNICAST_IF.

When an application is restricted to a VRF (with `ip vrf exec`), the
socket is bound to an interface at creation and therefore, a
non-privileged call to SO_BINDTODEVICE to escape the VRF fails.

When an application bound a socket to SO_BINDTODEVICE and transmit it
to a non-privileged process through a Unix socket, a tentative to
change the bound device also fails.

Before:

    >>> import socket
    >>> s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    PermissionError: [Errno 1] Operation not permitted

After:

    >>> import socket
    >>> s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
    >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    PermissionError: [Errno 1] Operation not permitted

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0fc8937a7ff4..e89c6148177b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -574,7 +574,7 @@ static int sock_setbindtodevice_locked(struct sock *sk, int ifindex)
 
 	/* Sorry... */
 	ret = -EPERM;
-	if (!ns_capable(net->user_ns, CAP_NET_RAW))
+	if (sk->sk_bound_dev_if && !ns_capable(net->user_ns, CAP_NET_RAW))
 		goto out;
 
 	ret = -EINVAL;
-- 
2.25.1

