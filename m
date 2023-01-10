Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBA663C7C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjAJJPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjAJJPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:15:00 -0500
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2BD4EC94;
        Tue, 10 Jan 2023 01:14:57 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id CD4821864572;
        Tue, 10 Jan 2023 12:14:54 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id F9XLH-le2lZG; Tue, 10 Jan 2023 12:14:54 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 8241418643D6;
        Tue, 10 Jan 2023 12:14:54 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WcjL9nXLjwvC; Tue, 10 Jan 2023 12:14:54 +0300 (MSK)
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.177.20.58])
        by mail.astralinux.ru (Postfix) with ESMTPSA id AA1A91863E47;
        Tue, 10 Jan 2023 12:14:53 +0300 (MSK)
From:   Anastasia Belova <abelova@astralinux.ru>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Anastasia Belova <abelova@astralinux.ru>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] xfrm: compat: change expression for switch in xfrm_xlate64
Date:   Tue, 10 Jan 2023 12:14:50 +0300
Message-Id: <20230110091450.21696-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compare XFRM_MSG_NEWSPDINFO (value from netlink
configuration messages enum) with nlh_src->nlmsg_type
instead of nlh_src->nlmsg_type - XFRM_MSG_BASE.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4e9505064f58 ("net/xfrm/compat: Copy xfrm_spdattr_type_t atributes=
")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a0f62fa02e06..12405aa5bce8 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -302,7 +302,7 @@ static int xfrm_xlate64(struct sk_buff *dst, const st=
ruct nlmsghdr *nlh_src)
 	nla_for_each_attr(nla, attrs, len, remaining) {
 		int err;
=20
-		switch (type) {
+		switch (nlh_src->nlmsg_type) {
 		case XFRM_MSG_NEWSPDINFO:
 			err =3D xfrm_nla_cpy(dst, nla, nla_len(nla));
 			break;
--=20
2.30.2

