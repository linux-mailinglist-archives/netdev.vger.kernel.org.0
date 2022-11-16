Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3562C964
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiKPUBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiKPUBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:34 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B5B6315D;
        Wed, 16 Nov 2022 12:01:32 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id o8so12655943qvw.5;
        Wed, 16 Nov 2022 12:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tAh+Of9caxaRUw4XnH2iGsda0b31xsN0rQHDbAXeik=;
        b=iWXi/ikoYRM3N2jOulGNTMLOdZ2lZGJAEdRyIm7DaX2Kil/IHYrgGZ6RqM+Grz7yjj
         1fG/pGZ6ovMbhcxtXzEz4Ws9RFy6R5REMU8lrRpgOBPqRy3xqNfAPYRSlk24+Rx3EDsh
         NEL4nSBaWtmYB6PRghw/0LkjOn6JrLiboYioaUjdTjVCnFOg/rHJ5fiPfr/slc06B8aE
         jOmLjd1KuWX7NSEs0aQw63/VFSbD+YRdp+TZn1JogocUeOzSUxivDI/ATkA0lvg5R0p1
         R4CV+JzCQiVsAbUBnAkcwvJN+ea5zmF4UIJbC1jpLLZeQg/nI8w4HL4PzKH2t8BcLHaa
         KQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tAh+Of9caxaRUw4XnH2iGsda0b31xsN0rQHDbAXeik=;
        b=wPsKHuys0xw+hZhCTM2iSqkAKl0GAH7J7ec7tapIbSjUizJgrkz9Nwz5X5pJHalfZR
         kKbqW5FByeWp3aLF71MXV+ZW8AT2eMslSnaoMfXTqDbU6uYMiP0dSKIE58StPl5FEj3x
         ZgnX2VGipAL47NeTdAQUa/wVRvDvUrs68K+BmlPb8/oOy68CI/8UsHbPDJB54RKtoKwD
         5qeRUUMDQwnpseYciRQcd+nvGBQd9Q0qh2M3opNJVrhKvUH2NsXEncBYYuObUlQJ9EIz
         3yG7JkjGS8FOP5oumGknuxM9qyDZsr0p2jk2afYhEX7kaYFaMNAfhJSKYjATEK4JrGGv
         9Z6w==
X-Gm-Message-State: ANoB5pmYMKLs6yguMZS+jFc2sBnGB1qZHGh/lTu1CtzLBtLcwv2fP2MD
        cFP/yejLn50Cik1ZfU/Z1x3ByNKm8dRebQ==
X-Google-Smtp-Source: AA0mqf4GbWUXR3r+amGYQntl7fo76OuyUeM5uOYsAGtaLPc5Ipeb04Y4tTLBaNJdHQ0a6KkrHGsB8Q==
X-Received: by 2002:a0c:80e2:0:b0:4b1:be55:d235 with SMTP id 89-20020a0c80e2000000b004b1be55d235mr22169797qvb.103.1668628891418;
        Wed, 16 Nov 2022 12:01:31 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 3/7] sctp: check sk_bound_dev_if when matching ep in get_port
Date:   Wed, 16 Nov 2022 15:01:18 -0500
Message-Id: <e621dbb3322ab482fec055ed22ab385d598f9ebc.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
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

In sctp_get_port_local(), when binding to IP and PORT, it should
also check sk_bound_dev_if to match listening sk if it's set by
SO_BINDTOIFINDEX, so that multiple sockets with the same IP and
PORT, but different sk_bound_dev_if can be listened at the same
time.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3e83963d1b8a..4306164238ef 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8398,6 +8398,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * in an endpoint.
 		 */
 		sk_for_each_bound(sk2, &pp->owner) {
+			int bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
 			struct sctp_sock *sp2 = sctp_sk(sk2);
 			struct sctp_endpoint *ep2 = sp2->ep;
 
@@ -8408,7 +8409,9 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 			     uid_eq(uid, sock_i_uid(sk2))))
 				continue;
 
-			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
+			if ((!sk->sk_bound_dev_if || !bound_dev_if2 ||
+			     sk->sk_bound_dev_if == bound_dev_if2) &&
+			    sctp_bind_addr_conflict(&ep2->base.bind_addr,
 						    addr, sp2, sp)) {
 				ret = 1;
 				goto fail_unlock;
-- 
2.31.1

