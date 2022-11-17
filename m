Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A2562D451
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbiKQHoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiKQHoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:44:08 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA9543AD6;
        Wed, 16 Nov 2022 23:44:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o30so791089wms.2;
        Wed, 16 Nov 2022 23:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MOR1JhYmBEppD4imfnJsKI2Upd7EAK5taerzvHPk9+c=;
        b=AR0KXsHrTXScIsEPXnJ4VaCawyhMDJ/M7RpX5dxwWTYQvTj6hC23XGad4JsalGFs8D
         3CUI151aNsXYL3cLA7Z/tPli96/onkM3frgmBqYffFIdd6gnJb9pmjkAJLG5L0M0ygZc
         a47bfALzjR5rVmP2uQSfqXkbRBe/TDAlVrOoCF22OHkTuruCtYWETKT5HcU3aKRAS6Uh
         rtrClzRLckGk3An0amrWhBSL325+x6osmlqulqs47ztd3jC7HrF+t3PqAyLNGAQ52baa
         ZtlBD72N3ZMh4C1AVsME+ovfL2a66Fasi4uFoojKkxRr24OW4s18Nsu1yr7Xx9RZ5P+F
         6VGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOR1JhYmBEppD4imfnJsKI2Upd7EAK5taerzvHPk9+c=;
        b=SfLfsUWHcj/SQHgZvAP+ppeJ8GrT5rN0cBTr7K34x+Z8khDug8lLvJiq58hYER4xH8
         PltVrz/FCb5q1ZO0DSl2YlSLrnhx114Fz9BuexQTQHNcbqXgttkCUv4AHrOICEOtDBHG
         kL/FHL2HXj9tY/U4KilCYOAsSSEKx4OM+tU67GXGSojxhuWnkV/tjOv8sg9rZ+cQHEzj
         31RiltHiB8BXfZLxuokb1EA8nlnBo55MBnDvEsKbH1ogUWIyDFccSHLkv5KkD5MyIE3/
         x6UdTpG9u08++a44xGzL588wmDNDxbpMEXlEzc3m0nAyjW2ZwM8YGhgTR2MixNEEUSB2
         MqDQ==
X-Gm-Message-State: ANoB5pmOhkD3m0tBusHUBh5rGSVXQz/Uwdubaoh9RXnpMYY9WtXzwYZA
        nD37x1DbpFbosSUe+CoK7Sg=
X-Google-Smtp-Source: AA0mqf6NiEgyNEol/d08iW5yE2UXTFpm/iMHQ8Q//vT9l6FYLl5xikNIxKQc7vsUWjlf9T+QE3pspQ==
X-Received: by 2002:a1c:7214:0:b0:3cf:7b65:76c5 with SMTP id n20-20020a1c7214000000b003cf7b6576c5mr760326wmc.166.1668671045992;
        Wed, 16 Nov 2022 23:44:05 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b003a6125562e1sm267463wmk.46.2022.11.16.23.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 23:44:05 -0800 (PST)
From:   Dan Carpenter <error27@gmail.com>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu, 17 Nov 2022 10:44:02 +0300
To:     David Howells <dhowells@redhat.com>
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] rxrpc: uninitialized variable in
 rxrpc_send_ack_packet()
Message-ID: <Y3XmQsOFwTHUBSLU@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "pkt" was supposed to have been deleted in a previous patch.  It
leads to an uninitialized variable bug.

Fixes: 72f0c6fb0579 ("rxrpc: Allocate ACK records at proposal and queue for transmission")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to net-next.

 net/rxrpc/output.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 46432e70a16b..04f945e042ab 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -202,7 +202,6 @@ static void rxrpc_cancel_rtt_probe(struct rxrpc_call *call,
 static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *txb)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_ack_buffer *pkt;
 	struct rxrpc_call *call = txb->call;
 	struct msghdr msg;
 	struct kvec iov[1];
@@ -270,7 +269,6 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 		rxrpc_set_keepalive(call);
 	}
 
-	kfree(pkt);
 	return ret;
 }
 
-- 
2.35.1

