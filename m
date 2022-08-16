Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B267C596222
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiHPSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbiHPSMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:12:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A8083F19;
        Tue, 16 Aug 2022 11:12:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d71so9906336pgc.13;
        Tue, 16 Aug 2022 11:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Kwg0Gxnft/pxS4kgXDydNW4k2vrq3EyTloWOdq0PXAc=;
        b=d4XRPHcDXJwTFcTDqVpTvjX02HXEH090I2x0YBrTSDu4Th3PTz4K/4BiUaMosTCWuc
         yh/hKxTp99qX7TkkGsLAVHMZ5geUpXom67+mtBW6HXOzvia8Xk//VeMancAqCZz80GoU
         jwoCUGmRE6+kBtMJgLi+tz4qf4XI8HmJEQ4owNs6EYFXAdydkVRUZns5dFqBBypsKgJF
         j6gCaKSwm6JdY/PByP0dshg1pJUpiMEmsJCE3mL6f+T2JTlQiNumFn7/hJF+bSsqhZke
         QqPU53NrKA1YAxYDZ9fYuEWaEZEm23RVoEv4m0b5q57cT18AU5Jc0cl5yLZsiSJ9cxLd
         NQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Kwg0Gxnft/pxS4kgXDydNW4k2vrq3EyTloWOdq0PXAc=;
        b=wFpB1sk7skp1eyTQ65FkRyQa8P/euJ8KXwrwlsql3pD9saEuDnxXcF5BQLHl3D3yE9
         Hc9Wv6q0cOfeKDfVkfqn2UiCkBS1WJCFWcZLJOXLWPYuR+y/HZLA2xUC/KuIMmWFeTkD
         A/Uyo4wVIx+7Tea60Otu8+mS2wmdlofa1s0/bbz3Y0PVbQ6HIyCHpeJaalsgrSunbLHe
         MF+RSq7PdbhuEG1MssSnUDbw9Ygjd3gay7uL0vCTa4+GChAokoIf2Te/YCFjslGp4ocA
         lX3isb2cVDY9OeHQr7dtO7sJGqBu3X+nddC347IRcdt9mF6WgcemnBJnecs1iYU2Uq7B
         enHg==
X-Gm-Message-State: ACgBeo1nu27JYho+TzrZRdYkhNXmbFHVJ8xGicz0dRE6WsYfJBJWMFtl
        5a2xPtJ4ZeRpVQMoZrFOluk=
X-Google-Smtp-Source: AA6agR4b7vY9FRGyzaz5mzZcsmD7HM3hcoQ0Wb8Wlml/Dg8M6UHkpILaOKpfKaplz4PkzvMlu+SMKw==
X-Received: by 2002:a62:3086:0:b0:52b:fd6c:a49d with SMTP id w128-20020a623086000000b0052bfd6ca49dmr21544920pfw.26.1660673527088;
        Tue, 16 Aug 2022 11:12:07 -0700 (PDT)
Received: from localhost (fwdproxy-prn-009.fbsv.net. [2a03:2880:ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id b13-20020a170903228d00b001714fa07b74sm9491956plh.108.2022.08.16.11.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:12:06 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next 2/6] Define QUIC specific constants, control and data plane structures
Date:   Tue, 16 Aug 2022 11:11:46 -0700
Message-Id: <20220816181150.3507444-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816181150.3507444-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220816181150.3507444-1-adel.abushaev@gmail.com>
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

