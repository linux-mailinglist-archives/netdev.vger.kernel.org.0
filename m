Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC40F29E46B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgJ2HYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgJ2HYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826F5C08EA78;
        Thu, 29 Oct 2020 00:07:09 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w11so854286pll.8;
        Thu, 29 Oct 2020 00:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=wT/TsOhKuL5HL67D4xz7aT44ptac/zTxHCX64c9ov/Y=;
        b=ajHUrcVUPOJndnqEYQWipVwrWEgWJsDqQcECX4j/cJxB/2yFtTxw6+1SMEs/dEYXf5
         xSo/ztYO7x+UXOqE/VaoI/d4Sd6YbtzbUcqqSz2bfu/+7CX3XBUFBh90DlwdNGYJShXZ
         TZ7l9O6c3JOWlLApKZVwWqUEGNUdpBk7/LaFVS/ku0Mf0eWTDj77moaOBjbUzqTfM+Ox
         B3+pjLzwAqeIVXl6+mI8/kha/Eqljrs0O1oXaLOSSDQT3PlxuxSsNBZKLx7tXzmceyTx
         52igKrSI19hiZt1h+gKuj2vt4zqRNqtEjvUMZce+emNnpqyKAzDPArhKwK2aldAAyzQA
         S8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=wT/TsOhKuL5HL67D4xz7aT44ptac/zTxHCX64c9ov/Y=;
        b=T+3msblh9tZ88TgBrH6yJQi8dnqReBjVfl22oxc20qDJtZqS+pQq+I513OrmBoKn/4
         xlluvtRJ3a+H43ZMUcW82hIJwPweZG5/pdB1ywSdV5xhhd8qL9+b1pTghhvQD6t1EteQ
         /zGfksQp7TcY+/68NlpzKWP+sKPki+kRlnUdYRVHTsoWJjAbVVDSErroCa02uMPfjr8A
         fQS7LZbnBnWGNwxnMiEVVIuqcZNvtZrrXQTRcSGYthWsi8quMxqfskqfzkZWhstuzJgB
         5r7qUPb3vX+7lsAa331AZo5l0pYfiIRnGYRgk8VGJ63/HTBbsqsezTWTFZTnutJ3Lhk5
         mXKg==
X-Gm-Message-State: AOAM532L+q3Ev4aGa7otsyrUMYVRTwkrIeLS4CnNi/AFtdQQjX/3aMpY
        zTbd8wRxoIP5MdYWeTn7dhzLAMLvCAA=
X-Google-Smtp-Source: ABdhPJx0XEvLJJGORBDIrCrmk1BC212D3taQQNbWY+onQAZ7zkXnBAS76KlUDvaa1XWrqurxPFXqNg==
X-Received: by 2002:a17:902:e993:b029:d6:41d8:9ca3 with SMTP id f19-20020a170902e993b02900d641d89ca3mr3031711plb.57.1603955228748;
        Thu, 29 Oct 2020 00:07:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k10sm1655324pji.54.2020.10.29.00.07.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:07:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 14/16] sctp: add the error cause for new encapsulation port restart
Date:   Thu, 29 Oct 2020 15:05:08 +0800
Message-Id: <566c52da624a35533e0d0403f6218dbe9d39589c.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <dcea42706709242930ae2d019355f27e7ca745d3.1603955041.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
 <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
 <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
 <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
 <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
 <dcea42706709242930ae2d019355f27e7ca745d3.1603955041.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the function to make the abort chunk with
the error cause for new encapsulation port restart, defined
on Section 4.4 in draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.

v1->v2:
  - no change.
v2->v3:
  - no need to call htons() when setting nep.cur_port/new_port.

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
index 21d0ff1..f77484d 100644
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
+	nep.cur_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
+	nep.new_port = chunk->transport->encap_port;
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

