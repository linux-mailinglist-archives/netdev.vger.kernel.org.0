Return-Path: <netdev+bounces-1026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32396FBD8D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC0451C20AE4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A34C17F8;
	Tue,  9 May 2023 03:12:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C19120F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:12:28 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC5183E7
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:12:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1aaed87d8bdso37472985ad.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601933; x=1686193933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4GgPuMvOtgtHE50nx3nV3rRoZO6RT1RIo2g9Oqwf7Q=;
        b=bgmAIX2R0setgTaRXMJc5M9uinv3GbYBn1yWtinkYOlDmrmwBSTfYVUlaabMlcXrSm
         575pJTIXIsWTelr52iN6Pxd+OPdQ6Q6+OebD7ou0NE9nO6j0RgecbC3QE5Gcf9tH3bdE
         heFGNJjZLUL5dRS/c/uMFLdC1FShXK+vjJs3I+oQfY//Lc6R1e1F0+nWca5S8pThizRH
         Pmph2+QtQs9aoieotVJ8VqIXtmEVzlsOkfw+V+76z2IzXixnVneeOKwvg6WTmK1RAxBu
         lu5EkDpMSzQGxYEHlukg0sCaGL+jvKbPZm1YRGUIIGDODPj7ilACAc3vMISmChg9olL9
         G/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601933; x=1686193933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u4GgPuMvOtgtHE50nx3nV3rRoZO6RT1RIo2g9Oqwf7Q=;
        b=VpZ3wr95Ch9ie7Usu1sLJX9BJUKgwitGCEOGt2eWY9tMZJeB6kCljskB+lI/opbvW/
         alIail1UzgGxh4QobD5aTwQ386w6a2SmctFoJeSUHVSeFeYyfgYwqztEaFApQ+DVH3lu
         VVYTVyceOvTYOMqFadHTj3m6WERYuZaIGpueyv8LWFIeyNhDHeTdlL7NopWcImwq4naB
         ozdc9t3gLqf18OvfZvOHWgFjrzn3aJ5FMUEYwRjhIjtcYUbT/EN0po7aDlQPGma1rfll
         RAeKqNa9tVXVjDKXgXh8tehudtrV9hHL0P06JjkfRJg5BvGAbl7P47L99uS3uKuap8hN
         STuA==
X-Gm-Message-State: AC+VfDz9qQQ3wZ9WMsRNdS+fNM5+r86qS0a5Wi2xSA684vrBg1vii98h
	qrvA1HKqCuAlysSHywizXNH121Fxzvx3602J
X-Google-Smtp-Source: ACHHUZ6BBQ7gpP05KGPWcWQERKXguepKiuIBxIhE4PaH6FrW/H3BT21ziIokT9tsMYwGPKNyXJlAWw==
X-Received: by 2002:a17:902:e846:b0:1ac:85e9:3cab with SMTP id t6-20020a170902e84600b001ac85e93cabmr4229557plg.56.1683601933003;
        Mon, 08 May 2023 20:12:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001ab19724f64sm250768plx.38.2023.05.08.20.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:12:12 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Liang Li <liali@redhat.com>,
	Vincent Bernat <vincent@bernat.ch>,
	Simon Horman <simon.horman@corigine.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 2/4] Documentation: bonding: fix the doc of peer_notif_delay
Date: Tue,  9 May 2023 11:11:58 +0800
Message-Id: <20230509031200.2152236-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509031200.2152236-1-liuhangbin@gmail.com>
References: <20230509031200.2152236-1-liuhangbin@gmail.com>
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

Bonding only supports setting peer_notif_delay with miimon set.

Fixes: 0307d589c4d6 ("bonding: add documentation for peer_notif_delay")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index adc4bf4f3c50..28925e19622d 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -776,10 +776,11 @@ peer_notif_delay
 	Specify the delay, in milliseconds, between each peer
 	notification (gratuitous ARP and unsolicited IPv6 Neighbor
 	Advertisement) when they are issued after a failover event.
-	This delay should be a multiple of the link monitor interval
-	(arp_interval or miimon, whichever is active). The default
-	value is 0 which means to match the value of the link monitor
-	interval.
+	This delay should be a multiple of the MII link monitor interval
+	(miimon).
+
+	The valid range is 0 - 300000. The default value is 0, which means
+	to match the value of the MII link monitor interval.
 
 prio
 	Slave priority. A higher number means higher priority.
-- 
2.38.1


