Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2E5AF923
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIGAt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIGAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:49:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2840BF8;
        Tue,  6 Sep 2022 17:49:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 9so9711684plj.11;
        Tue, 06 Sep 2022 17:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=zKHLtlJnFLmV+2bVGZ+NL3Hc0unpEzfOZEcdnJuJu7A=;
        b=Z3tjrToGNhKhp27814rT8Qy2PjwR69odBta3zjAkDpGaBuSZ9L/tW2L5hBLC6ebdpH
         vHur1ZSGWyxc7L+oSylyYfM64GKmP8IH6cDdkMyXgkDvxjw21tiNmOUnx7L6SYYGEixG
         7OzrB8JKJHSkRuMJ1heLy2PYY3MheVIu/JtHGzfXtZn+T+Ypg5B8t4sdLyf9mo5p2kzr
         VDfRV35X9+ofy3oHUCGOm/OhKbF2BAPdlhSbdQtdlUzw4kLoM0YZ7yvECE4iTnfXtiXB
         coBejlsohTdnCNpegZM++/vPwb27hk6XPQIzMXUkttmb4lZylPPiW8Gcr/IpsubW7AZ/
         tLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zKHLtlJnFLmV+2bVGZ+NL3Hc0unpEzfOZEcdnJuJu7A=;
        b=K16klq6CaLzGWl4st9+vZWSPjc9qhs5AtSWaHtQQSIIorGEkd+MEK9bRUrq1roeeNz
         VBcVFMfV+9ziEexLXSfcaO5Z3HdVLejyfMEJ6xTioqunYb6fH0DPJrZxu/qe7LGjKnDp
         uTVA/qEApuZF+JIsXTp24fUW14xEdlzMUo9AOiIgS3+q8t9bNuaq/Sjv7bIzyCNVp9JO
         nu3oXELkq//1L5OpqyIw271ufNyoG1IEhFQ0fO16uPgXG0oLf//3hLvO6syr3yUqDs21
         3hleMnPnjsmymrnJQBYPK+G8gLiZY09fD6Ad9IrBlOJPs/qYnvIDrnTnp3+FihNFNuAg
         3xEQ==
X-Gm-Message-State: ACgBeo1jY8OWCKs07KOB9ca9kQMUi7LZnmqr4MseOL8kqNtuvRGTWp58
        u52BIvHmmJBH3oqjYtb11IE=
X-Google-Smtp-Source: AA6agR60RiD3D+XYft2xkmAsWmmgp6F+zhqARBKq8FMC0xP73t+qyOWyg11tS1hWA74J/1n6SylzAQ==
X-Received: by 2002:a17:902:c189:b0:176:b871:8a1 with SMTP id d9-20020a170902c18900b00176b87108a1mr1353832pld.30.1662511790573;
        Tue, 06 Sep 2022 17:49:50 -0700 (PDT)
Received: from localhost (fwdproxy-prn-117.fbsv.net. [2a03:2880:ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id 18-20020a630312000000b00434e1d3b2ecsm334510pgd.79.2022.09.06.17.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 17:49:50 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next v3 2/6] net: Define QUIC specific constants, control and data plane structures
Date:   Tue,  6 Sep 2022 17:49:31 -0700
Message-Id: <20220907004935.3971173-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907004935.3971173-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220907004935.3971173-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define control and data plane structures to pass in control plane for
flow add/remove and during packet send within ancillary data. Define
constants to use within SOL_UDP to program QUIC sockets.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>

---

v3: added a 3-tuple to map a flow to a key, added key generation to
include into flow context.
---
 include/uapi/linux/quic.h | 66 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/udp.h  |  3 ++
 2 files changed, 69 insertions(+)
 create mode 100644 include/uapi/linux/quic.h

diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..1fd9d2ed8683
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) */
+
+#ifndef _UAPI_LINUX_QUIC_H
+#define _UAPI_LINUX_QUIC_H
+
+#include <linux/types.h>
+#include <linux/tls.h>
+
+#define QUIC_MAX_CONNECTION_ID_SIZE	20
+
+/* Side by side data for QUIC egress operations */
+#define QUIC_BYPASS_ENCRYPTION	0x01
+
+struct quic_tx_ancillary_data {
+	__aligned_u64	next_pkt_num;
+	__u8	flags;
+	__u8	dst_conn_id_length;
+};
+
+struct quic_connection_info_key {
+	__u8	dst_conn_id[QUIC_MAX_CONNECTION_ID_SIZE];
+	__u8	dst_conn_id_length;
+	union {
+		struct in6_addr ipv6_addr;
+		struct in_addr  ipv4_addr;
+	} addr;
+	__be16  udp_port;
+};
+
+struct quic_aes_gcm_128 {
+	__u8	header_key[TLS_CIPHER_AES_GCM_128_KEY_SIZE];
+	__u8	payload_key[TLS_CIPHER_AES_GCM_128_KEY_SIZE];
+	__u8	payload_iv[TLS_CIPHER_AES_GCM_128_IV_SIZE];
+};
+
+struct quic_aes_gcm_256 {
+	__u8	header_key[TLS_CIPHER_AES_GCM_256_KEY_SIZE];
+	__u8	payload_key[TLS_CIPHER_AES_GCM_256_KEY_SIZE];
+	__u8	payload_iv[TLS_CIPHER_AES_GCM_256_IV_SIZE];
+};
+
+struct quic_aes_ccm_128 {
+	__u8	header_key[TLS_CIPHER_AES_CCM_128_KEY_SIZE];
+	__u8	payload_key[TLS_CIPHER_AES_CCM_128_KEY_SIZE];
+	__u8	payload_iv[TLS_CIPHER_AES_CCM_128_IV_SIZE];
+};
+
+struct quic_chacha20_poly1305 {
+	__u8	header_key[TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE];
+	__u8	payload_key[TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE];
+	__u8	payload_iv[TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE];
+};
+
+struct quic_connection_info {
+	__u16	cipher_type;
+	struct quic_connection_info_key		key;
+	__u8	conn_payload_key_gen;
+	union {
+		struct quic_aes_gcm_128 aes_gcm_128;
+		struct quic_aes_gcm_256 aes_gcm_256;
+		struct quic_aes_ccm_128 aes_ccm_128;
+		struct quic_chacha20_poly1305 chacha20_poly1305;
+	};
+};
+
+#endif
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 4828794efcf8..0ee4c598e70b 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -34,6 +34,9 @@ struct udphdr {
 #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
 #define UDP_SEGMENT	103	/* Set GSO segmentation size */
 #define UDP_GRO		104	/* This socket can receive UDP GRO packets */
+#define UDP_QUIC_ADD_TX_CONNECTION	106 /* Add QUIC Tx crypto offload */
+#define UDP_QUIC_DEL_TX_CONNECTION	107 /* Del QUIC Tx crypto offload */
+#define UDP_QUIC_ENCRYPT		108 /* QUIC encryption parameters */
 
 /* UDP encapsulation types */
 #define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
-- 
2.30.2

