Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0399F3CC3F8
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 17:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhGQPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 11:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhGQPFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 11:05:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF8C06175F
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 08:02:28 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l17-20020a05600c1d11b029021f84fcaf75so9955603wms.1
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 08:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D+d/SZb2X+alvvbt8eVwgMK84K/3GnsvwbjR85ePzTg=;
        b=DRNFtg/9OLGzMe1kKZ+YQ+TUPbm6BqJD9fzJI+9iV4InYtNFczw0Z0FevuYNdfMkwO
         ss00Y6iv1PGKt10QHQZz8fiZ00mMz+oJCuCsgoPbzeS5v6gawgTQvd6h9phSyxnUaGgB
         SGjrsbYY6hQkat9PmT0s7ee4HL6pjM45FRnRTefoiHn5fGUZTjxhZuK9wlc6j27kyBeL
         /PinS8IEUS34yJWLDKpexm6RQ6T6f+jUsHdGeJZ2InVwe9jO6moYplfjveixdbIJAisl
         sgrJn91QAmxr/5il47I0/w/wPLBcKzF0Cw3Dyw9wkFhQWy77kM/I1ejqiQtic5qr/wTg
         tWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D+d/SZb2X+alvvbt8eVwgMK84K/3GnsvwbjR85ePzTg=;
        b=SOFfvQu5jS7lUe29s3mex1I61eN3gre1m53VWnDsb6+mj4NwRbuFjtYOuvvaZovvma
         0krWpa3b/3Y2xWtCNLLfNe3VDbMdB2SPMwbbTFYwALjzBu6E2sWRV2ZRI6siQAcv6nIO
         bv32kkMdPfy2C+ewiyEVmAS22uHRPCAcDQYOd6Qv+bas3j+zRFOwTDoaa/jNOkr9/oin
         9+7d8LwcC0xfffKGlwZjaBRhOgTmcnFeB8jm7wsfto/eNKzXf2vQxVu93EM01VQJJ/1q
         8LhdGKlvJqS++Du80hV2e1b6O+t//WyjIuPNCi+jRtMb91+Mjpcj1lvta4/d4HNxSvIH
         a68Q==
X-Gm-Message-State: AOAM531yqqfOzk9bTxN2FlApznzj05jH7MizjKSrYUeAVbzQB5G2XG4Q
        3DEMZGO4+wGuX9QsPIxVVpUxwsH0gApaFg==
X-Google-Smtp-Source: ABdhPJx8DB+kk7MMOrUmQFDXuuHoTU55jb/LpS+jzIc3todymD09XHFTZanq6JA7/ZfO4i6V88adWg==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr22730291wme.33.1626534147428;
        Sat, 17 Jul 2021 08:02:27 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id v9sm11372463wml.36.2021.07.17.08.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 08:02:26 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH 1/2] net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
Date:   Sat, 17 Jul 2021 16:02:21 +0100
Message-Id: <20210717150222.416329-2-dima@arista.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717150222.416329-1-dima@arista.com>
References: <20210717150222.416329-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attribute-translator has to take in mind maxtype, that is
xfrm_link::nla_max. When it is set, attributes are not of xfrm_attr_type_t.
Currently, they can be only XFRMA_SPD_MAX (message XFRM_MSG_NEWSPDINFO),
their UABI is the same for 64/32-bit, so just copy them.

Thanks to YueHaibing for reporting this:
In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
array.

KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
[...]
Call Trace:
 xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:702 [inline]

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Cc: <stable@kernel.org>
Reported-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/xfrm/xfrm_compat.c | 49 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a20aec9d7393..2bf269390163 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -298,8 +298,16 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	len = nlmsg_attrlen(nlh_src, xfrm_msg_min[type]);
 
 	nla_for_each_attr(nla, attrs, len, remaining) {
-		int err = xfrm_xlate64_attr(dst, nla);
+		int err;
 
+		switch (type) {
+		case XFRM_MSG_NEWSPDINFO:
+			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
+			break;
+		default:
+			err = xfrm_xlate64_attr(dst, nla);
+			break;
+		}
 		if (err)
 			return err;
 	}
@@ -341,7 +349,8 @@ static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src
 
 /* Calculates len of translated 64-bit message. */
 static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
-					    struct nlattr *attrs[XFRMA_MAX+1])
+					    struct nlattr *attrs[XFRMA_MAX + 1],
+					    int maxtype)
 {
 	size_t len = nlmsg_len(src);
 
@@ -358,10 +367,20 @@ static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
 	case XFRM_MSG_POLEXPIRE:
 		len += 8;
 		break;
+	case XFRM_MSG_NEWSPDINFO:
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		return len;
 	default:
 		break;
 	}
 
+	/* Unexpected for anything, but XFRM_MSG_NEWSPDINFO, please
+	 * correct both 64=>32-bit and 32=>64-bit translators to copy
+	 * new attributes.
+	 */
+	if (WARN_ON_ONCE(maxtype))
+		return len;
+
 	if (attrs[XFRMA_SA])
 		len += 4;
 	if (attrs[XFRMA_POLICY])
@@ -440,7 +459,8 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 
 static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
 			struct nlattr *attrs[XFRMA_MAX+1],
-			size_t size, u8 type, struct netlink_ext_ack *extack)
+			size_t size, u8 type, int maxtype,
+			struct netlink_ext_ack *extack)
 {
 	size_t pos;
 	int i;
@@ -520,6 +540,25 @@ static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
 	}
 	pos = dst->nlmsg_len;
 
+	if (maxtype) {
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		WARN_ON_ONCE(src->nlmsg_type != XFRM_MSG_NEWSPDINFO);
+
+		for (i = 1; i <= maxtype; i++) {
+			int err;
+
+			if (!attrs[i])
+				continue;
+
+			/* just copy - no need for translation */
+			err = xfrm_attr_cpy32(dst, &pos, attrs[i], size,
+					nla_len(attrs[i]), nla_len(attrs[i]));
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
 	for (i = 1; i < XFRMA_MAX + 1; i++) {
 		int err;
 
@@ -564,7 +603,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	len = xfrm_user_rcv_calculate_len64(h32, attrs);
+	len = xfrm_user_rcv_calculate_len64(h32, attrs, maxtype);
 	/* The message doesn't need translation */
 	if (len == nlmsg_len(h32))
 		return NULL;
@@ -574,7 +613,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	if (!h64)
 		return ERR_PTR(-ENOMEM);
 
-	err = xfrm_xlate32(h64, h32, attrs, len, type, extack);
+	err = xfrm_xlate32(h64, h32, attrs, len, type, maxtype, extack);
 	if (err < 0) {
 		kvfree(h64);
 		return ERR_PTR(err);
-- 
2.32.0

