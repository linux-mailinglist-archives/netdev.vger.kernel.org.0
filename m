Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E6A199745
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgCaNUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:20:43 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48087 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730770AbgCaNUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 09:20:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D05AF865;
        Tue, 31 Mar 2020 09:20:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 31 Mar 2020 09:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=+m9kLwvcfTu3aKY4OxGv4fbaUm
        RKsZVZamUC1QyjImc=; b=mRvtU2+r7UF4ttEs9vGbN01+1XmHl6q0Z8Vu3j3wv+
        yrYLPyQyNLFeCZ1SWQC9TpUaCA1luUvzapGxJK7v/8u2xdRcYqjSmsdSeAflCBgw
        u/Bdw7TqrttYCv0vRaV4yT8U4GANIbiiXh3nCMpTu6Oj8LcZLeutZ6HBcTFqhQi2
        o3MwDyDSrPxLrYKZGJ0Cg0BBRYUujRENnyfBHYTWtZrdgtnCe5PIL8O4MWNUPZ9Q
        BJZuAqb/5h0IcxyQ5AuzIXCOqmeH2IhqVTUZI6B0i4DBl8NPUoKItzjsXBddEVQb
        MVZKjLY50vRXSLwKJ6FJEzHyPeW8GsOOAUOsieYeAOGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+m9kLwvcfTu3aKY4O
        xGv4fbaUmRKsZVZamUC1QyjImc=; b=PS4mqnpNZyAOPuZicmf3bdK8l749d8Qg/
        imKr2JXa1QqT1x4VZytevpQt3xaY/UF9hJ+DgzQ5OF0CFsTaaTvnxIwS4g5lO+kX
        kd9q31rnfHMUGO7ekGwDQBkGN9pHGquFJCjj2rOyJ3SIHKBmV9ow18IC8rr1qKIS
        Eokqof3Ze9ONj2n3ZK+q644KOwDOupoKT8WpCQ2cMTIRrPbp8FkscTZbXMZtuEIM
        SXzkvGReis08czl3pU3vQbUduWO2S8MRg/VUM6PK1DadD28wAYq6mb8KFJjaXcee
        ZDLQejHHq5MJWywZwcAh+LPyjlf1gRcX/4cFYSYZWXWXuLeklCyaw==
X-ME-Sender: <xms:qEODXlj4dG3upsjk6kgHTdSrdrxc2lFRgtQcU9mHze2Ih8sEhTUARg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtddtgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgghinhgtvghnthcu
    uegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecukfhppeekiedrvd
    egvddrgedruddtgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:qEODXlPBJ4OyYihuPy8nKNr1nQoOQlvLgp0ozknO97Vlw7b_N5xptw>
    <xmx:qEODXkM9ONZbY31kohaPAyz55XMs5LgPgkLqcnG0gIceuUvX2IUg5Q>
    <xmx:qEODXqgFWB4jFJdoMy1x71Jic8-xpY6mXSZFc_AIN4LXT9UYsMdFFA>
    <xmx:qUODXuqHRs-QudVc1QDP1k62ODiWCVRFw10IJJDy7Zvm9hT1JwAWzg>
Received: from neo.luffy.cx (lfbn-idf1-1-575-104.w86-242.abo.wanadoo.fr [86.242.4.104])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6BC20306CB54;
        Tue, 31 Mar 2020 09:20:40 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 0E5189B3; Tue, 31 Mar 2020 15:20:39 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for non-root users
Date:   Tue, 31 Mar 2020 15:20:10 +0200
Message-Id: <20200331132009.1306283-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.26.0
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
be privileged.

Previously, IP_UNICAST_IF and IPV6_UNICAST_IF were added for
Wine (76e21053b5bf3 and c4062dfc425e9) specifically for use by
non-root processes. However, they are restricted to sendmsg() and not
usable with TCP. Allowing SO_BINDTODEVICE would allow TCP clients to
get the same privilege. As for TCP servers, outside the VRF use case,
SO_BINDTODEVICE would only further restrict connections a server could
accept.

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
index da32d9b6d09f..ce1d8dce9b7a 100644
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
2.26.0

