Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D811DBF83
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgETT4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgETT4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:56:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA2C08C5C2;
        Wed, 20 May 2020 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RS3LTvliBGxyGsnnvxZgDr4L9B5S1/4iYu+vJVezXGg=; b=IA1nCq5387FDZyPHwQSHibUr1/
        CT/pQ8Y8GNTneQCNiXZ9KBQ4yjdLFbYZFxIB6Tfyb7D4QTdFOK/o4kw4gwVgy5S/ZkREyErzJAnOR
        i01FLml+PjMqNs8nDgbcDYUf/SSA/WCWP7F4U/AsS3vqGHB8MwZyfqWZbHp2OLMwLVNuRLdi++WUu
        a7+3MH7Xpz/v+9TTm/NiAVRL+fpr5wPbDv88+1MRVSMVdD6PMFgky6/E1SICQf9+MnSmH+cd7RR30
        FKS2Xm1gzdYW7d8wR9H7+rveKj4+Z6ni4falzXtAE3UpwenhCou7XXCvS1uVMo/w/U/aEpo29VtXD
        wOuEI/gQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUo8-0001ss-Fg; Wed, 20 May 2020 19:55:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH 02/33] net: remove kernel_getsockopt
Date:   Wed, 20 May 2020 21:54:38 +0200
Message-Id: <20200520195509.2215098-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h |  2 --
 net/socket.c        | 34 ----------------------------------
 2 files changed, 36 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 6451425e828f5..74ef5d7315f70 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -303,8 +303,6 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags);
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
-int kernel_getsockopt(struct socket *sock, int level, int optname, char *optval,
-		      int *optlen);
 int kernel_setsockopt(struct socket *sock, int level, int optname, char *optval,
 		      unsigned int optlen);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
diff --git a/net/socket.c b/net/socket.c
index 80422fc3c836e..81a98b6cbd087 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3624,40 +3624,6 @@ int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(kernel_getpeername);
 
-/**
- *	kernel_getsockopt - get a socket option (kernel space)
- *	@sock: socket
- *	@level: API level (SOL_SOCKET, ...)
- *	@optname: option tag
- *	@optval: option value
- *	@optlen: option length
- *
- *	Assigns the option length to @optlen.
- *	Returns 0 or an error.
- */
-
-int kernel_getsockopt(struct socket *sock, int level, int optname,
-			char *optval, int *optlen)
-{
-	mm_segment_t oldfs = get_fs();
-	char __user *uoptval;
-	int __user *uoptlen;
-	int err;
-
-	uoptval = (char __user __force *) optval;
-	uoptlen = (int __user __force *) optlen;
-
-	set_fs(KERNEL_DS);
-	if (level == SOL_SOCKET)
-		err = sock_getsockopt(sock, level, optname, uoptval, uoptlen);
-	else
-		err = sock->ops->getsockopt(sock, level, optname, uoptval,
-					    uoptlen);
-	set_fs(oldfs);
-	return err;
-}
-EXPORT_SYMBOL(kernel_getsockopt);
-
 /**
  *	kernel_setsockopt - set a socket option (kernel space)
  *	@sock: socket
-- 
2.26.2

