Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34C92871F2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgJHJuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:50:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC9C061755;
        Thu,  8 Oct 2020 02:50:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e10so3566607pfj.1;
        Thu, 08 Oct 2020 02:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=eHpfgVHKRbBtzp3y6GtZn9feVuuP00yNLAtwJLjoQHM=;
        b=QrPNjt0RO8DT5b3ueEDCjwQvh4/pPPUm5KptSzNpUva9O9Gz7bXkCdCi6XhqM9HWmY
         Uyd89mkV6WQabi2OOCXTh8bIuMPnuTVqS/nRHike2RVZbIfztY/BIm4GkzrWnk7WZ9wX
         zyPva/0GiObrsWdKNwg+/vqLkfDIU837PsiTyjQsaBjc5Nvg4o4vY1erd5XUJ3k0mwpS
         fqec49mv7PNgC14l+IuYo6grm6B/O1H345qr23+e1Cbc7+U+0SxjfP9Uhe4zOEm3CwqT
         NAVmoFuhg5j24Yd+ia9esoZlQLo+qyv8+ntz+n3TRr11BogKlBX9h7Dgi1bzlNKxsN/5
         bFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=eHpfgVHKRbBtzp3y6GtZn9feVuuP00yNLAtwJLjoQHM=;
        b=CnnoMzGeSfdMIg7/nBD8iAAypMy4dh2sMxVFGnVc9MeVt2t2cERnetaqIKHJ8mepNG
         goeD2HmbhPAhK4bRs8BEddrk869uMUrIdtPso1jnV7C2tVNWwqnfTmGf9faHSA1jZiHJ
         huCzdGM9h5wB0xDl1lXOOkHUjMHO8i2AC111qyIIlh7W5AD0BZ24FCDAekHP7mRfcuIK
         ggv/MjtV8262X381pM6K7HcYacc/3Mx4W7h785S9d1WOn1aYMGd/yYMRbZTRn8tMPjmP
         QTx4jioHhueHa/iqFVY57yZwQN4ArFCmlHShgUPoBAND5SbuxbPIYiSOqKofiN8iuUSD
         xprw==
X-Gm-Message-State: AOAM533s+zJG3iAZqNjB4Riyk2/OWPO/n8PmNUIMy9dAP2MS5yhI4lTq
        2xZK8P2TJNNR2hHGtCps9Aa8O6rtGpY=
X-Google-Smtp-Source: ABdhPJwjjz3XPgKnnUFvCBYB3q0QoS4/vwzxZYzS87QbKM/0wo23sACHz2wVP9sOEcUi4jP/EICGlw==
X-Received: by 2002:a17:90a:d57:: with SMTP id 23mr7201642pju.232.1602150621092;
        Thu, 08 Oct 2020 02:50:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm6428069pgk.73.2020.10.08.02.50.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:50:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 15/17] sctp: add the error cause for new encapsulation port restart
Date:   Thu,  8 Oct 2020 17:48:11 +0800
Message-Id: <8815067eea44ffd7274b0038e48c2618c2e77916.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <5c0e9cf835f54c11f7e3014cab926bf10a47298d.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
 <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
 <1d1b2e92f958add640d5be1e6eaec1ac5e4581ce.1602150362.git.lucien.xin@gmail.com>
 <5c0e9cf835f54c11f7e3014cab926bf10a47298d.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the function to make the abort chunk with
the error cause for new encapsulation port restart, defined
on Section 4.4 in draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     | 20 ++++++++++++++++++++
 include/net/sctp/sm.h    |  3 +++
 net/sctp/sm_make_chunk.c | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 7673123..bb19265 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -482,11 +482,13 @@ enum sctp_error {
 	 *  11  Restart of an association with new addresses
 	 *  12  User Initiated Abort
 	 *  13  Protocol Violation
+	 *  14  Restart of an Association with New Encapsulation Port
 	 */
 
 	SCTP_ERROR_RESTART         = cpu_to_be16(0x0b),
 	SCTP_ERROR_USER_ABORT      = cpu_to_be16(0x0c),
 	SCTP_ERROR_PROTO_VIOLATION = cpu_to_be16(0x0d),
+	SCTP_ERROR_NEW_ENCAP_PORT  = cpu_to_be16(0x0e),
 
 	/* ADDIP Section 3.3  New Error Causes
 	 *
@@ -793,4 +795,22 @@ enum {
 	SCTP_FLOWLABEL_VAL_MASK = 0xfffff
 };
 
+/* UDP Encapsulation
+ * draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html#section-4-4
+ *
+ *   The error cause indicating an "Restart of an Association with
+ *   New Encapsulation Port"
+ *
+ * 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |        Cause Code = 14        |       Cause Length = 8        |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |   Current Encapsulation Port  |     New Encapsulation Port    |
+ * +-------------------------------+-------------------------------+
+ */
+struct sctp_new_encap_port_hdr {
+	__be16 cur_port;
+	__be16 new_port;
+};
+
 #endif /* __LINUX_SCTP_H__ */
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index a499341..fd223c9 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -221,6 +221,9 @@ struct sctp_chunk *sctp_make_violation_paramlen(
 struct sctp_chunk *sctp_make_violation_max_retrans(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk);
+struct sctp_chunk *sctp_make_new_encap_port(
+					const struct sctp_association *asoc,
+					const struct sctp_chunk *chunk);
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport);
 struct sctp_chunk *sctp_make_heartbeat_ack(const struct sctp_association *asoc,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 21d0ff1..3bf1399 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1142,6 +1142,26 @@ struct sctp_chunk *sctp_make_violation_max_retrans(
 	return retval;
 }
 
+struct sctp_chunk *sctp_make_new_encap_port(const struct sctp_association *asoc,
+					    const struct sctp_chunk *chunk)
+{
+	struct sctp_new_encap_port_hdr nep;
+	struct sctp_chunk *retval;
+
+	retval = sctp_make_abort(asoc, chunk,
+				 sizeof(struct sctp_errhdr) + sizeof(nep));
+	if (!retval)
+		goto nodata;
+
+	sctp_init_cause(retval, SCTP_ERROR_NEW_ENCAP_PORT, sizeof(nep));
+	nep.cur_port = htons(SCTP_INPUT_CB(chunk->skb)->encap_port);
+	nep.new_port = htons(chunk->transport->encap_port);
+	sctp_addto_chunk(retval, sizeof(nep), &nep);
+
+nodata:
+	return retval;
+}
+
 /* Make a HEARTBEAT chunk.  */
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport)
-- 
2.1.0

