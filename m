Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786F121E1F4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgGMVQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:16:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39849 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbgGMVQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594674963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=+OFwdj95gIpnqCakGQYV2udXlDEQ7e+ZxOQGMvtuBlM=;
        b=gCby5NGYbt62tMYXqkQ6oNdCrWGtG99el3Qr1cnmkBddeKDnNzvvVx3X2JwNrDbXITh4g+
        QUeS7iUSzkMFcsWgWGhL/ok+PIpGlSFCxtyVLdNcgdb3nME8aDCIHpCqs0U1nqQzUheTEm
        qS0jNWyHmPLT3U2wvzAFkW7c7drpH0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-sd7lfqrmMw2XaudOwg1U3g-1; Mon, 13 Jul 2020 17:15:58 -0400
X-MC-Unique: sd7lfqrmMw2XaudOwg1U3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EEBD1088;
        Mon, 13 Jul 2020 21:15:57 +0000 (UTC)
Received: from loberhel7laptop.redhat.com (ovpn-113-229.phx2.redhat.com [10.3.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B99A6FEDF;
        Mon, 13 Jul 2020 21:15:56 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     loberman@redhat.com, linux-scsi@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com, netdev@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com
Subject: [PATCH] iscsi: qedi (qed_int.c) disable "MFW indication via attention" SPAM every 5 minutes
Date:   Mon, 13 Jul 2020 17:15:41 -0400
Message-Id: <1594674941-32092-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b7b974f..d853eb9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1193,7 +1193,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			"MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
1.8.3.1

