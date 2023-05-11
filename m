Return-Path: <netdev+bounces-1979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 133C06FFD3E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC73F1C210A8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CAB17FF2;
	Thu, 11 May 2023 23:22:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC10BAD50
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:22:15 +0000 (UTC)
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961335BA9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:22:14 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-61b5b4df8baso73058316d6.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683847333; x=1686439333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CbH9HbijhNP4GVBdBM+4GV91e87QtUMW16iGd++R6KY=;
        b=RJcjAfC8dSlXzPIj4hnU9mvBVO61BdAdNi9+qlgzUJJOv0BYauxrlsdWog+2BuOJNI
         KgGT413wLmqU9TpKayukDVRdT/OyNN+wMTMlgnGDNToZV8eigdnx0ijDO0uGYmLcyYUI
         2yBIZCu+xBa62CLBHOWdSsZAPL2lHVeSEFBOTCYI54iZbbzkJrMlD8vsq1GXPtsB3+hd
         P4JjuNGMnKsSRCLX5oUsWpRNFxambBtYbkdMsz8fLah9C34LSQy8VEajwXZO6N/Za/WM
         zaF5nrYgS/iF0yXSE6BujX/dVWqc62oe5yh8DJlCR1Wa59gwSDZt4AszVCPg6LvmweQP
         hHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683847333; x=1686439333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CbH9HbijhNP4GVBdBM+4GV91e87QtUMW16iGd++R6KY=;
        b=IykVXtORrkXNNzIWoFnH9U8sx4ZeUjvYsc0doIkrfOXdR0ZZQ73QVtyujEje8x2XtP
         mXYOpD1E2t4ijjA7br3gvjPnxzraJ77mqSyJCP6BEoOhUEfj8DkUnl61184KIqbisZxS
         P/24r3whpNX+AKDUcq8m01rh2lcpAG2FhQxpYY5JOUANatiFqTTWrbBE839QvoMM58FF
         NO2lkuvzZyypduXar7ToPpQirJMkHGrPnx4j8EJHehTelfAslZRYtU6JtBE1u9DlVd9y
         fhKswrcaqcULCiFlEoU8CoheIik4o8vH2TgCIkEuglSZRbAWQGcsI+/qrfnkusGnPk9D
         8Efg==
X-Gm-Message-State: AC+VfDy3EoRnLP7uhGhPVmxgHJ7vAEoNH4+7qlsQgED4myo/Rlwz6vj0
	PgtKybnzjKot5VLw9Rv3opK0RWRV9Eg=
X-Google-Smtp-Source: ACHHUZ7GBWCGdHhkAVtegWsdeGShQQa2DQpN3Il8twBCH7R9zrJIoBPU76GEK3whzOTTcLGaMjaAiw==
X-Received: by 2002:a05:6214:f06:b0:5ef:d5b0:c327 with SMTP id gw6-20020a0562140f0600b005efd5b0c327mr37880401qvb.11.1683847333482;
        Thu, 11 May 2023 16:22:13 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x18-20020ae9e912000000b0074a0051fcd4sm1977433qkf.88.2023.05.11.16.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 16:22:13 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	William Tu <u9012063@gmail.com>,
	Kevin Traynor <ktraynor@redhat.com>
Subject: [PATCH net] erspan: get the proto with the md version for collect_md
Date: Thu, 11 May 2023 19:22:11 -0400
Message-Id: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In commit 20704bd1633d ("erspan: build the header with the right proto
according to erspan_ver"), it gets the proto with t->parms.erspan_ver,
but t->parms.erspan_ver is not used by collect_md branch, and instead
it should get the proto with md->version for collect_md.

Thanks to Kevin for pointing this out.

Fixes: 94d7d8f29287 ("ip6_gre: add erspan v2 support")
Reported-by: Kevin Traynor <ktraynor@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_gre.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a4ecfc9d2593..da80974ad23a 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1015,12 +1015,14 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 					    ntohl(tun_id),
 					    ntohl(md->u.index), truncate,
 					    false);
+			proto = htons(ETH_P_ERSPAN);
 		} else if (md->version == 2) {
 			erspan_build_header_v2(skb,
 					       ntohl(tun_id),
 					       md->u.md2.dir,
 					       get_hwid(&md->u.md2),
 					       truncate, false);
+			proto = htons(ETH_P_ERSPAN2);
 		} else {
 			goto tx_err;
 		}
@@ -1043,24 +1045,25 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 			break;
 		}
 
-		if (t->parms.erspan_ver == 1)
+		if (t->parms.erspan_ver == 1) {
 			erspan_build_header(skb, ntohl(t->parms.o_key),
 					    t->parms.index,
 					    truncate, false);
-		else if (t->parms.erspan_ver == 2)
+			proto = htons(ETH_P_ERSPAN);
+		} else if (t->parms.erspan_ver == 2) {
 			erspan_build_header_v2(skb, ntohl(t->parms.o_key),
 					       t->parms.dir,
 					       t->parms.hwid,
 					       truncate, false);
-		else
+			proto = htons(ETH_P_ERSPAN2);
+		} else {
 			goto tx_err;
+		}
 
 		fl6.daddr = t->parms.raddr;
 	}
 
 	/* Push GRE header. */
-	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
-					   : htons(ETH_P_ERSPAN2);
 	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
-- 
2.39.1


