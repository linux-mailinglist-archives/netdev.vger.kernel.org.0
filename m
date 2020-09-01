Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62D25C4D7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgICPTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgICL2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:28:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3FFC061258
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 04:28:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so2785796wrn.10
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 04:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20150623.gappssmtp.com; s=20150623;
        h=resent-from:resent-date:resent-message-id:resent-to:from:to:cc
         :subject:date:message-id:mime-version:content-transfer-encoding;
        bh=XQkx8fUG8mwQIi4m4nThh8XuyNKND7WiqTo03rOQoiQ=;
        b=qahoLaGmB27qfsHILXv+Zy2LZPWsFF6YqZcUrYON+UWNQQDHOOl1uEI2YjsddD3ao8
         uzlHza4iqbuE1h+sBZC8zRra7UkLn0PiPqKzHtYUAm8pFGa0RpnxrdJf1q472Pj04hst
         ipJeICNSW9N+eLpRx9pKX+e0edk/l6/KiNcVa0B3o8LEkcb6Ldu0mipBSPaku6B5hnLR
         NoX2ZuXU2P+yqNZXumADDrBwIq5YSKePHoodMoJcQvefiYSnH2ttYcUCeLH72PVg1Kz/
         Htzetyv3asZcGMM3ZPAS2SQls3fzdpyTIO3QiM1vNFqLgd1B4gleDEdsU/WODyZHUxm/
         GmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:resent-from:resent-date:resent-message-id
         :resent-to:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XQkx8fUG8mwQIi4m4nThh8XuyNKND7WiqTo03rOQoiQ=;
        b=fKQD+0A0x3mgfR4I3OrMKD421hKS/W7rw6us+rs5WqfFCNjQ2YSaVwqnCLu5GtoAly
         23NrJFG1Rq+uhvk3y/WUC5h7mNgiZvvv2Uv5A3vqr6D4j146gUMTll79BtJPMj3y9IfQ
         JVH9NgEk7qKaNACcJTtVyUgQZSTEhjzuaPLVwuy/dm99bo34EUttPCkjKdw7WlUaihXZ
         d2GY/sEc3ljGq75nP2wtkqEWOdZvvFzeLVSg3ASnLRRvDuCkVCjq3fcJ2bKyEwq+McgN
         ozqYMm38yGUOcW8kAZoNpC5gCRU3tJi40CAQQZ3GIqwgrNjnvqo2zRXya6aZSLINJ5AW
         MLLw==
X-Gm-Message-State: AOAM533Dl7DLL5sGzqYeY9MiIaX7UC52g+iAPVZkBGEhq/2psabLWxId
        osXlq4hZwQXAyw3YBcKUKkPsWt9wxCHOsjgz
X-Google-Smtp-Source: ABdhPJy/r4h5jh0fEbISzl2uMdAqhEvwj4BfbGPgZpXWnrEvi8TKjAimZDlL4NJ9JC/Vvl+/W7dVHQ==
X-Received: by 2002:adf:e54f:: with SMTP id z15mr1895357wrm.136.1599132505773;
        Thu, 03 Sep 2020 04:28:25 -0700 (PDT)
Received: from bordel.klfree.net (bordel.klfree.cz. [81.201.48.42])
        by smtp.gmail.com with ESMTPSA id h185sm4058305wme.25.2020.09.03.04.28.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 04:28:25 -0700 (PDT)
Received: from ntb.petris.klfree.cz (snat2.klfree.cz. [81.201.48.25])
        by smtp.googlemail.com with ESMTPSA id j7sm1337591wrs.11.2020.09.01.02.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:00:25 -0700 (PDT)
From:   Petr Malat <oss@malat.biz>
To:     linux-sctp@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        Petr Malat <oss@malat.biz>
Subject: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under memory pressure
Date:   Tue,  1 Sep 2020 11:00:07 +0200
Message-Id: <20200901090007.31061-1-oss@malat.biz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
the first message it finds without checking if the message is longer than
SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
such a behavior is invalid. Fix it by returning the first message only if
its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 net/sctp/ulpqueue.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 1c6c640607c5..cada0b7f1548 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -610,6 +610,7 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 	struct sctp_ulpevent *cevent;
 	__u32 ctsn, next_tsn;
 	struct sctp_ulpevent *retval;
+	size_t pd_point, pd_len = 0;
 
 	/* The chunks are held in the reasm queue sorted by TSN.
 	 * Walk through the queue sequentially and look for a sequence of
@@ -633,8 +634,9 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 				first_frag = pos;
 				next_tsn = ctsn + 1;
 				last_frag = pos;
+				pd_len = pos->len;
 			} else
-				goto done;
+				goto check;
 			break;
 
 		case SCTP_DATA_MIDDLE_FRAG:
@@ -643,15 +645,19 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 			if (ctsn == next_tsn) {
 				next_tsn++;
 				last_frag = pos;
+				pd_len += pos->len;
 			} else
-				goto done;
+				goto check;
 			break;
 
 		case SCTP_DATA_LAST_FRAG:
 			if (!first_frag)
 				return NULL;
-			else
+			if (ctsn == next_tsn) {
+				last_frag = pos;
 				goto done;
+			} else
+				goto check;
 			break;
 
 		default:
@@ -659,6 +665,11 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 		}
 	}
 
+check:
+	pd_point = sctp_sk(ulpq->asoc->base.sk)->pd_point;
+	if (pd_point && pd_point > pd_len)
+		return NULL;
+
 	/* We have the reassembled event. There is no need to look
 	 * further.
 	 */
-- 
2.20.1

