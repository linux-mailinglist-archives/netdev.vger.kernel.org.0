Return-Path: <netdev+bounces-8933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF3572656F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99AD81C20EA0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73683370F5;
	Wed,  7 Jun 2023 16:05:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6775C3732C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:05:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E687199D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686153915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=25VvF+7e396MnJpizUwgli4cW3EIqa5Slr1uscLByKQ=;
	b=eGVXe/Yz38EwHb3tSFe2ZUE1W6Bm1F+3xfjC/limUFlEdnkZvq2QNTnwe9y3G0Y3F732U0
	bFr7ipQaOG0Cm79i/naWTmqdCtqiXw5SFICzxhqL0a//8UJxTRVyNTkVMMvf9KrMFzqqKL
	2db2ABSp0HSqk6JqfIoVjplruQ+5094=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-DFxMksQDONKYj8gEXFM7fw-1; Wed, 07 Jun 2023 12:05:09 -0400
X-MC-Unique: DFxMksQDONKYj8gEXFM7fw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30c2e9541b9so4138401f8f.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686153905; x=1688745905;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=25VvF+7e396MnJpizUwgli4cW3EIqa5Slr1uscLByKQ=;
        b=I3QwW7Me7g+CS67yG4+CC+RytorFLHYVCOeN1wX6h2ovKyya38gphVpPN04NXkXtNd
         8soJZKONRNd7pFaVy93dLKwgaLLbQws3sKlIuJQ7CvdKCNjlMYDk+Tb7GBWaSrLbKHrr
         Ofppqmp3XiW+KMR8Qx+Dqe5bn7cDMNZDlmD4hoU6MxuzsaPbhUB2CwIFwkEYE+ArP0+P
         K3rm5RsZJKeHzakYCxGGcf1xtMdiDWW1Bs8+NykrQ9+GxfmLq4lmU5eNkgn9E5sb43CD
         zeekBHvP57k3c9ooVOe4Q1A5l9aWUkGCfkvTVU287P3pMp+JTXzT1mW6xZ7Y/MpUvHmW
         rW8Q==
X-Gm-Message-State: AC+VfDzbqfewg+mZNEkoZfWuX/9fQOFZAL0yjhOeIo4GFJHnmmc1XZzg
	iXiqn0lLjmNuVO7cfPuYOLmX6iDG09DLN5QKecF6vM0XfB9pkvdhN7NHnwUVhvGxF8LaE1YMQqZ
	GsnvsjQeoVRUJSA+F
X-Received: by 2002:a5d:5543:0:b0:30a:e69d:7219 with SMTP id g3-20020a5d5543000000b0030ae69d7219mr4676906wrw.65.1686153905585;
        Wed, 07 Jun 2023 09:05:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hvqC/7XQkYGKoOzTIyKuY5vZ6TucHm66eeoBdPo1Ydr/PBHQPxfY1crU9JD3qwDyACpBqOw==
X-Received: by 2002:a5d:5543:0:b0:30a:e69d:7219 with SMTP id g3-20020a5d5543000000b0030ae69d7219mr4676884wrw.65.1686153905294;
        Wed, 07 Jun 2023 09:05:05 -0700 (PDT)
Received: from debian (2a01cb058d652b00ba1a24d15502040a.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:ba1a:24d1:5502:40a])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003f427687ba7sm2533209wmg.41.2023.06.07.09.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:05:04 -0700 (PDT)
Date: Wed, 7 Jun 2023 18:05:02 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Lorenzo Colitti <lorenzo@google.com>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH net] ping6: Fix send to link-local addresses with VRF.
Message-ID: <6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Ping sockets can't send packets when they're bound to a VRF master
device and the output interface is set to a slave device.

For example, when net.ipv4.ping_group_range is properly set, so that
ping6 can use ping sockets, the following kind of commands fails:
  $ ip vrf exec red ping6 fe80::854:e7ff:fe88:4bf1%eth1

What happens is that sk->sk_bound_dev_if is set to the VRF master
device, but 'oif' is set to the real output device. Since both are set
but different, ping_v6_sendmsg() sees their value as inconsistent and
fails.

Fix this by allowing 'oif' to be a slave device of ->sk_bound_dev_if.

This fixes the following kselftest failure:
  $ ./fcnal-test.sh -t ipv6_ping
  [...]
  TEST: ping out, vrf device+address bind - ns-B IPv6 LLA        [FAIL]

Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr/
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 5e457896986e ("net: ipv6: Fix ping to link-local addresses.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv6/ping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index c4835dbdfcff..f804c11e2146 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -114,7 +114,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	addr_type = ipv6_addr_type(daddr);
 	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
 	    (addr_type & IPV6_ADDR_MAPPED) ||
-	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
+	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
+	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
 		return -EINVAL;
 
 	ipcm6_init_sk(&ipc6, np);
-- 
2.39.2


