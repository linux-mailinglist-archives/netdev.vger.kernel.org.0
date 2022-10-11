Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBCE5FADF0
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJKIB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJKIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:01:57 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674D821819
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:01:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so9839693wme.5
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4V+gpBjk94nGcRqMEPz2aU1JA9Iq7cbFYTB+B934+8c=;
        b=a4jhloACkZPXLfEWf67R3+ImWh8DFdyIg3I6936z39W7qnFacIqFEXpXujGaJVYGs8
         mNUawZj/y4jHQkL1Z09cgxlbxXRcgj8VBHtuLNP//EQ+dGKGrK0ApiMvuS4cShoMhsHL
         WPEjPBUYgxzwiLtnjLRMWQAa3lXNHyoDX+Zcal2Bhs9lrNx4wlv02WE1+P2SUyEydQSV
         USJY6eSaZxCdpVxwKVLmmrXgxC7CHvKSvu+Wb39ydtIH5pPJxvNjXwYrKhsrOiiqBdWn
         8vA2zWQzzGd5sTUKL5t3s5egbU51XKSyINm1/wjsM8oWbniF/Yq7gtPFaitM0yjxxsm/
         4jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4V+gpBjk94nGcRqMEPz2aU1JA9Iq7cbFYTB+B934+8c=;
        b=vpNafppNR5JPZTHFvrVq3fqkLArI60zIr1zTGaapOBNc3k7g6E+ZD+PSVh8BGiWOOM
         RGSpKb2jR8dgUz0WxwjkmxHZ5qk9YBDsA2AxztmpBveMa5Gei65a3jNzy5Ry87rMmF1Z
         Q0OA+787J4his0os3b5QtDZMQfIIJxqXPTRWUThNku9ITZ7ytgz9BWjbHrI5inkvYHC6
         ohEBUyZeGDPfUY8EgufVoUc5pSLFCt8umVjYYOVnO3uGr9P89YIxjilNVM7DFrRyMkoX
         hlJQL4wFMfwSz1jxabwcL+8gkE72pk8UDKK9Zf6KKJoIT34vzLIZrDZXJTOBl176i2es
         fknA==
X-Gm-Message-State: ACrzQf3tHcDfis8P8x42qSie9n5WgDbTtfYNtIK1jC1wlxPuSLWWR0sY
        zU0jFSsgNYdZqvsEOkEUIzs=
X-Google-Smtp-Source: AMsMyM7NYU3PnHc/5xtY6N9i3JBDnf9Pu4rz9Zs3AgWgFIw93u9L0jFdJULl8jhhotlZ7RRUx2ILBg==
X-Received: by 2002:a05:600c:4789:b0:3c4:dbb7:ab0c with SMTP id k9-20020a05600c478900b003c4dbb7ab0cmr10466356wmo.164.1665475313601;
        Tue, 11 Oct 2022 01:01:53 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c34c500b003c409244bb0sm10284200wmq.6.2022.10.11.01.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 01:01:53 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     idosch@idosch.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec] xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available
Date:   Tue, 11 Oct 2022 11:01:37 +0300
Message-Id: <20221011080137.440419-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido reported that a kernel warning [1] can be triggered from
user space when the kernel is compiled with CONFIG_MODULES=y and
CONFIG_XFRM=n when adding an xfrm encap type route, e.g:

$ ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
Error: lwt encapsulation type not supported.

The reason for the warning is that the LWT infrastructure has an
autoloading feature which is meant only for encap types that don't
use a net device,  which is not the case in xfrm encap.

Mute this warning for xfrm encap as there's no encap module to autoload
in this case.

[1]
 WARNING: CPU: 3 PID: 2746262 at net/core/lwtunnel.c:57 lwtunnel_valid_encap_type+0x4f/0x120
[...]
 Call Trace:
  <TASK>
  rtm_to_fib_config+0x211/0x350
  inet_rtm_newroute+0x3a/0xa0
  rtnetlink_rcv_msg+0x154/0x3c0
  netlink_rcv_skb+0x49/0xf0
  netlink_unicast+0x22f/0x350
  netlink_sendmsg+0x208/0x440
  ____sys_sendmsg+0x21f/0x250
  ___sys_sendmsg+0x83/0xd0
  __sys_sendmsg+0x54/0xa0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: Ido Schimmel <idosch@idosch.org>
Fixes: 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/core/lwtunnel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 6fac2f0ef074..711cd3b4347a 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -48,9 +48,11 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "RPL";
 	case LWTUNNEL_ENCAP_IOAM6:
 		return "IOAM6";
+	case LWTUNNEL_ENCAP_XFRM:
+		/* module autoload not supported for encap type */
+		return NULL;
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
-	case LWTUNNEL_ENCAP_XFRM:
 	case LWTUNNEL_ENCAP_NONE:
 	case __LWTUNNEL_ENCAP_MAX:
 		/* should not have got here */
-- 
2.34.1

