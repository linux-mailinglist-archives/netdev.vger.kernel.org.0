Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7765E29DAF8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgJ1XmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgJ1XlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:41:22 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2547C0613CF;
        Wed, 28 Oct 2020 16:41:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l24so1259511edj.8;
        Wed, 28 Oct 2020 16:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YhwU+8BLpV9225RTD4hONYgLMtesha5JLBAdjHXbCcQ=;
        b=rHSCGXVCD6q+JxkS3NIuiDdRrHZIawiuivzjtGWeRf2wRCnkPLS/QAecdOZQELnFt6
         mKfK6KXmmCVTJ5RRJCS5az9bBLUZhojSm6Ng+0+tDwkojvYdJh5iDI39OEa8ProOQPeQ
         zKHGAWltHJv0EGKdUzsnwifTUmPXefXZ+UkymX1qAsLH6pfNFSrUSKw26YmKxO1ZRLLg
         DjuD1QRl/4SkKsoBpkPzw7upiYgL3tOdPjOM8ifniM2LXFdlMvxoRHCFtxBEsTKPpCdC
         P6dw9XD6F7nJTcY2Plff3wuBdwWTIhB9zYqBcVo7UPaUwN6CygFsRwP2QVH939b/3M/Q
         ABCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YhwU+8BLpV9225RTD4hONYgLMtesha5JLBAdjHXbCcQ=;
        b=OwFejrKpGtpxDIZXkr4xemy/9Xa4/uFhT8A8fM7BS9UqoGoCO5XYAGPrf5Bj/8Qcnc
         CcqEM8OXuCcTRkNHX5GdQQxOTmvr1bhUW6a/L3CBRiC8n1Hpvy4m3oWC0slTpNSEAv83
         TEMt+CPpHv/MLF+cSvunwVERAzLgHcU0xePO8jtojhXDbEY+h9KKMt8oOgbaTy6wNoOi
         w91KqFdge8D0yO4NcR7mYBI5Z7Xg10GjnqgzUiSuF5OkcUCCQ3myf3OxgmXoys4gIGW6
         OveCWNukCr07PrVoCpStnW3pqEPpk9s69TgpIyyJA+4vlq6wU9AJ6KvsLbViITBGuP0f
         VRhw==
X-Gm-Message-State: AOAM5303mNqy0qgSBvuXI1EaF+oZdV/lABbVoxdU6OcgmQUXxdvqGNt8
        jt4dRSPizgWis5LEBInEVtyBmlFrh/WD9nc0
X-Google-Smtp-Source: ABdhPJye0EMNguEkh0PcXJ7btOefLszJrY8XMh/7mC4zZNhsgK3FseLzVzx5vrNWW2xWJIeprYpd4w==
X-Received: by 2002:a5d:5548:: with SMTP id g8mr8460210wrw.364.1603886037722;
        Wed, 28 Oct 2020 04:53:57 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d7a:200:a915:6596:e9b0:4f60])
        by smtp.gmail.com with ESMTPSA id v123sm6029066wme.7.2020.10.28.04.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 04:53:56 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-safety@lists.elisa.tech,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] ipv6: mcast: make annotations for ip6_mc_msfget() consistent
Date:   Wed, 28 Oct 2020 12:53:49 +0100
Message-Id: <20201028115349.6855-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 931ca7ab7fe8 ("ip*_mc_gsfget(): lift copyout of struct group_filter
into callers") adjusted the type annotations for ip6_mc_msfget() at its
declaration, but missed the type annotations at its definition.

Hence, sparse complains on ./net/ipv6/mcast.c:

  mcast.c:550:5: error: symbol 'ip6_mc_msfget' redeclared with different type \
  (incompatible argument 3 (different address spaces))

Make ip6_mc_msfget() annotations consistent, which also resolves this
warning from sparse:

  mcast.c:607:34: warning: incorrect type in argument 1 (different address spaces)
  mcast.c:607:34:    expected void [noderef] __user *to
  mcast.c:607:34:    got struct __kernel_sockaddr_storage *p

No functional change. No change in object code.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on current master and next-20201028

David, Jakub, please pick this minor non-urgent clean-up patch.

 net/ipv6/mcast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 8cd2782a31e4..6c8604390266 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -548,7 +548,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 }
 
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
-	struct sockaddr_storage *p)
+		  struct sockaddr_storage __user *p)
 {
 	int err, i, count, copycount;
 	const struct in6_addr *group;
-- 
2.17.1

