Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6458B2F6
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbiHFAMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbiHFAML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:12:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FF41CF;
        Fri,  5 Aug 2022 17:12:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso4288580pjd.3;
        Fri, 05 Aug 2022 17:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4V/ipJQ6DCVsRMtLCepTHzBHMgzxXZ7RbHCafjsv+gQ=;
        b=Hg8P0sn+8uS8qbIfMBURO5ms/0lRSlkOxZBagjuH8lePhEac6G4qh6JohzaOWawH2E
         8dFbdREmAR7Fi/uAQEEbpkfZG4eE4pVwo1ajz+rvcgCMgB9b+jhzw/lDZrY9+X4KCbbF
         Ypnr3DoudRfAzDZ6JVftU12OliC1ZsNpLIfrV2WIoeCA5Nf5zP4JQv8iLPkZjWaH3mZS
         aU7L5ccWtcQ8NBUAsgq4AZ54SdTh729azlavXvD7gf56mqPLkMv1lSNZlnkeaDoHK4Gu
         ot+zxmo1FPLgmdMVes0vqgYao3A+NggSCQ66HbWUA/91pght3DOamU3ikfekEd8Rkvj9
         knWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4V/ipJQ6DCVsRMtLCepTHzBHMgzxXZ7RbHCafjsv+gQ=;
        b=WyIObadYhUJPLhEL9K5ebMfawsc1bX3MygqdbIGuklk3pWNXMdNxYIMl1pTdt3AgmD
         jsOMeefEUa+NqOYcoAGR4npQFpNy9CY6Yw3WbktF1d7xrk9HZa7/V53kDXsW1mmxR6+Q
         JpZJGokQpk8ErUx9fFm2VdWWgWuUANLvAMNHj8m1g7Jjsl4/7tLU2tSoZHGkHhpiG+w5
         yuoWEJhaKSoVH3+MRDTepTV2C75A8g2waLyexhKAq83E3whX2/GEhoh15SD4HkNHmmPm
         VVYUhU6jtRUS4XiyK83JSqOW9ogvweBfG3heHV+Kg8+e2wMCPDpqQE/XLiuOq2z8FoBf
         oBQw==
X-Gm-Message-State: ACgBeo3/kXgbIyrmM49V5pm2xnvfZzsuQf7aFVuh9z3KMrsnBfBoRuQM
        s8ou3AWrnoFCZk2UObysz4c=
X-Google-Smtp-Source: AA6agR5bI5DSZjmgCrDyYYhcxru0eVEkHjVRXrm2SjrGESnav8UaDtLFgsAkejdZjF3Yzw0oSeSP2w==
X-Received: by 2002:a17:90b:4c0f:b0:1f5:179a:28df with SMTP id na15-20020a17090b4c0f00b001f5179a28dfmr9942245pjb.42.1659744729448;
        Fri, 05 Aug 2022 17:12:09 -0700 (PDT)
Received: from localhost (fwdproxy-prn-009.fbsv.net. [2a03:2880:ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id 135-20020a62198d000000b0052c92329115sm3527450pfz.218.2022.08.05.17.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 17:12:08 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next v2 2/6] Define QUIC specific constants, control and data plane structures
Date:   Fri,  5 Aug 2022 17:11:49 -0700
Message-Id: <20220806001153.1461577-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220806001153.1461577-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220806001153.1461577-1-adel.abushaev@gmail.com>
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

Signed-off-by: Adel Abouchaev <adelab@fb.com>
---
 include/uapi/linux/quic.h | 61 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/udp.h  |  3 ++
 2 files changed, 64 insertions(+)
 create mode 100644 include/uapi/linux/quic.h

diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..79680b8b18a6
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) */
+
+#ifndef _UAPI_LINUX_QUIC_H
+#define _UAPI_LINUX_QUIC_H
+
+#include <linux/types.h>
+#include <linux/tls.h>
+
+#define QUIC_MAX_CONNECTION_ID_SIZE 20
+
+/* Side by side data for QUIC egress operations */
+#define QUIC_BYPASS_ENCRYPTION 0x01
+
+struct quic_tx_ancillary_data {
+	__aligned_u64	next_pkt_num;
+	__u8	flags;
+	__u8	conn_id_length;
+};
+
+struct quic_connection_info_key {
+	__u8	conn_id[QUIC_MAX_CONNECTION_ID_SIZE];
+	__u8	conn_id_length;
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
+	union {
+		struct quic_aes_gcm_128 aes_gcm_128;
+		struct quic_aes_gcm_256 aes_gcm_256;
+		struct quic_aes_ccm_128 aes_ccm_128;
+		struct quic_chacha20_poly1305 chacha20_poly1305;
+	};
+};
+
+#endif
+
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

