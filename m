Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C399FCF820
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbfJHL2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:28:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41704 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfJHL2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:28:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so10588551pfh.8;
        Tue, 08 Oct 2019 04:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=kf/Px6s2t0RUsnf0+LrOQt4ai/o6jJP5XVEZXXGpeWk=;
        b=jhOdGLgenEazeo/+KdQng3HbOcObhaG9EZzvt9csC18VTe8GPaKmGWlg0HO1/PBV+K
         V7yvkJd9DIxy9WudDvuLLgjM8DBzup8Yo2y0flGDTavW9+bkyKLkGUJgHpFAlQCcDwpC
         ixbfJgjL1MIxhCWmGLMLHJhSIEVmthSgUpEERaqSIJk4R7vTyylvKW5JWJydgtyRlcpl
         aCIq6+mEoz/tr6IHQ5QGNyRedBVGJjoWiL01bolsZU2urTwdeVs2sPKRTTqrtK6BvcAM
         ZIZ40AxMRfj3CFPrEcB69OQTXMkVxOlN38iIyE0USmkbFjV+7foVKm8wO6xur7sp2GPo
         bH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=kf/Px6s2t0RUsnf0+LrOQt4ai/o6jJP5XVEZXXGpeWk=;
        b=po5nfM3ZszRHhJDDIi03jVam515EtE20RQjTRR3/5LbSnUMiJOprd8x63JKe9vXA4V
         xCEiddlaj3mM5exfCDoS3BCvXgEc9deZSfInXgaf/doINCCJxEFXmjKDzmAh/KSK4cA5
         4aPn80jkgoS6msp5B+7f84NH9/UQG8wH3UyiMVKUnXzle0Rd+PvSeSoytwZGvfN6sN7Y
         i3YHJfhuKQPpNWEzup6xnPqReqWPBztjBn9QEySyEJlbPKcSN7A4Ltf4Ybh8pl1o9w2K
         UnPKKtDU7C3EwDI7jn5gBsn3tz4k2fc8VuGV4cN3JDsFqPUGQtTerBLG1TfP61Mg7wGF
         El5w==
X-Gm-Message-State: APjAAAXQGYiM10cRDZoquiv1z4fRJFvrvR41b933DHKJzn9bogcc1/D5
        lYycBeZsfHDN7KdqMTZHzpMu9ink
X-Google-Smtp-Source: APXvYqxKxq9+P2huqx9CWMFLsscsmCqQG/QNtv6vhbP1up+oty1C9caKHdny3LYD3ytYLmaHgegNTQ==
X-Received: by 2002:a65:514c:: with SMTP id g12mr36434195pgq.76.1570534081496;
        Tue, 08 Oct 2019 04:28:01 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w134sm18374858pfd.4.2019.10.08.04.28.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:28:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 2/4] sctp: add SCTP_ADDR_REMOVED event
Date:   Tue,  8 Oct 2019 19:27:34 +0800
Message-Id: <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_ulpevent_nofity_peer_addr_change() is called in
sctp_assoc_rm_peer() to send SCTP_ADDR_REMOVED event
when this transport is removed from the asoc.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_REMOVED:  The address is no longer part of the
     association.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 55aad70..0d3d7ce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -569,6 +569,7 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 
 	asoc->peer.transport_count--;
 
+	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
 	sctp_transport_free(peer);
 }
 
-- 
2.1.0

