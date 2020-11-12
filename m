Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6182B02C8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgKLKfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgKLKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:35:11 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2992FC0613D1;
        Thu, 12 Nov 2020 02:35:11 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id w11so2559037pll.8;
        Thu, 12 Nov 2020 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gBKoO0l+krTYZHCpZSloeyBlfr5Et+++JAx3n38Lrro=;
        b=mqVB3HMNViODmnTRpgcEm5Ec3hRXWO7EETfzUGekhn/qSktkQbXMX0olrCSqtFpgRC
         f8VlzVjg/2gXI1nBdg3dnWv/cKIHTLVUpWczXRr3s+z/CX2hlMhzY5lQ+04t67teMODF
         bERmKJnqqhSXcIqACTmbpYEI8Ed48gC2SRtmPWzJlnsAkNr2+l52tiERGB0brT/Ed6vj
         hLUTtlsG8/TrncXB9EQawAyjIBZMjSbpt2mKe8seZ/RZRxwf7moHRTRPR/NlHyDhH71h
         w4U6qM/nkys4hNQrNad/ankvFRFBgCmfO5h6wMLm9KM3413rjv+VRO+ru2DJdkWPDbjF
         1JsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gBKoO0l+krTYZHCpZSloeyBlfr5Et+++JAx3n38Lrro=;
        b=BKn7jOZL94CV6aVYYL6QTDDls/ihsK5pLIkO9xAd7cNNinPg+Hp/FnlHBBv9+bh8lY
         FnaZ7F8vEguuhlxdkJdgtHu9uTGO+WIyWQYl9v3C81Ee3gEPkHUUAzOOl0trlqh7sa/G
         RXqR5zG0ZV/PLWdxtbBJ80zyw+OshJhqfsa84S49wen26rP4SWx+oFa4JWhkXOfNRsSP
         mhUVX+8eiAol4Wnv5KQReqOBXtXizXFV+VzEuE4k44EJ+uTQqlCftLfyF0+h5DVk+HTG
         1I5BjEkdUX7WC1llBmxh4FEuOO1Ocf3zYggPbV2WFRRDvdMofV7+FC9S0yMHlUfSwerH
         oB8Q==
X-Gm-Message-State: AOAM530FPudiYe2v8MCgRySBzw4mkKscqCSFMNm2T+1OpUC49yoV4uFd
        QBv77vCSzIPmIU8jz1kCLd4NNo516eo=
X-Google-Smtp-Source: ABdhPJwTNmx7Osf/AWo/E8V5brGSWpkSVTmxInq33sTns/D22sVqOCy2WRG5XQpWGqLMpcOKViFRqA==
X-Received: by 2002:a17:902:a381:b029:d8:bdca:77dc with SMTP id x1-20020a170902a381b02900d8bdca77dcmr6528791pla.14.1605177310653;
        Thu, 12 Nov 2020 02:35:10 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:50f6:9265:b24d:a776])
        by smtp.gmail.com with ESMTPSA id 35sm2652383pgp.26.2020.11.12.02.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:35:10 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net v2] net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request
Date:   Thu, 12 Nov 2020 02:35:06 -0800
Message-Id: <20201112103506.5875-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x25_disconnect function in x25_subr.c would decrease the refcount of
"x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.

However, the x25_rx_call_request function in af_x25.c, which is called
when we receive a connection request, does not increase the refcount when
it assigns the pointer.

Fix this issue by increasing the refcount of "struct x25_neigh" in
x25_rx_call_request.

This patch fixes frequent kernel crashes when using AF_X25 sockets.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/x25/af_x25.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 046d3fee66a9..a10487e7574c 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1050,6 +1050,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	makex25->lci           = lci;
 	makex25->dest_addr     = dest_addr;
 	makex25->source_addr   = source_addr;
+	x25_neigh_hold(nb);
 	makex25->neighbour     = nb;
 	makex25->facilities    = facilities;
 	makex25->dte_facilities= dte_facilities;
-- 
2.27.0

