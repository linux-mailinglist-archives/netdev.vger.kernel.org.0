Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A246CE45
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbhLHHYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244493AbhLHHYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:15 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACBC061574;
        Tue,  7 Dec 2021 23:20:43 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so5109509edd.9;
        Tue, 07 Dec 2021 23:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiQZUZ4Jp9rh3Rck4fCei07yCzSzqa5hdHX2zLrQJwY=;
        b=kCEcjy+tbsyg22IbRbPqIl1LwBtIa1X3q+YMPu/jhnYMqakPqvm+mm6b3pld52mJkX
         qKsJm4TDfh1a9BFl+zcBYuxPs9bcozWh3BKtrKsOi94t7PHFeVhitzk2hNsbZlQbWEr+
         4nF54YOOiQanFiNnVgscU9dGEIZW/wZolos0iBE+wW9hn5fNreNgdcdj/oYlHHVYv83P
         /ihu7kg5Uo60rWClETe3MkNJxGlc/CTu4oCrkqdCyQZLwJlJX9nfwkBq57+/RWUv3L4P
         DVCwQLvIcEF5PjZhDoWKQ3xwZBHnuh1KUN6mdo6yvqpjMTbeiM8HY9M5/lIQFrlXYg5V
         RJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiQZUZ4Jp9rh3Rck4fCei07yCzSzqa5hdHX2zLrQJwY=;
        b=wO1PiSBqfuTxF0EJ9JrWu+qG2ua8WI0MkNpPik/jQ0XitDB0k9nBMxnNkHHjpyCSDU
         ta4J3dZb6tWKk18aHf9l3hXXqFa5aGTvmGBI/j7SNzg3hQjRJV6/B6igGpBBKaHisdFb
         6EjQfd01vIWGAwmk/8NMfY97AzXdpheTylApmE3BZxo9yjokfVErth+zn8V772+WqTRb
         /1BL7W9Ki0mxFkb3hJwLaiahbsH/ujvlD6IdypLruzZiLrZ/ieGvTdRosTPwMOl/9dQu
         4zHiBuvYQIsvpyxHF19o0rnDAHdbPzl7VVU1vOntOobnnAVhF9OqkKsD0Eli1CIwKheI
         Ddqw==
X-Gm-Message-State: AOAM531QJw0QA1fPqZziHjw2Nt/Plfrt55i0NsbClM7uIsdlqeoi/MDu
        Ger3CUoQQGw1JbwYueao2SvK+xZLwJKYMQ==
X-Google-Smtp-Source: ABdhPJxpyHAt6KP4n1940eTrjggh4myqcf6FdPfXNmSYSCvNa+tANrPtaaEcuF2LoOH5pZdlwmgvZg==
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr5313796ejc.490.1638948042155;
        Tue, 07 Dec 2021 23:20:42 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id a68sm1297305edf.41.2021.12.07.23.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:41 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: bluetooth: clean up harmless false expression
Date:   Wed,  8 Dec 2021 00:20:24 -0700
Message-Id: <20211208024732.142541-4-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

scid is u16 with a range from 0x0000 to 0xffff.  L2CAP_CID_DYN_END is
0xffff.  We should drop the false check of (scid > L2CAP_CID_DYN_END).

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4f8f37599962..fe5f455646f6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4118,7 +4118,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 	result = L2CAP_CR_NO_MEM;
 
 	/* Check for valid dynamic CID range (as per Erratum 3253) */
-	if (scid < L2CAP_CID_DYN_START || scid > L2CAP_CID_DYN_END) {
+	if (scid < L2CAP_CID_DYN_START) {
 		result = L2CAP_CR_INVALID_SCID;
 		goto response;
 	}
