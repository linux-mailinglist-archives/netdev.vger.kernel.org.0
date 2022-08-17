Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD769597769
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbiHQUJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiHQUJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:09:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB0166A4B;
        Wed, 17 Aug 2022 13:09:49 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u133so12940686pfc.10;
        Wed, 17 Aug 2022 13:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u22jiSFhNbA3v1/UjcAzv8b6+vq2T9VqdxW19p88ScY=;
        b=c6mi7ctjdif6l/zcWZzpuh1/xa2mp36w+XuAcRNlJt92k1FtW73Wt2B5yThmazOItF
         6d55oqi2GnxZDAIJX0tCqICzn66gJvMDA9Dm0XC5hUGrqiyimJlZqMFIT7YSWBKo7wnB
         +bExvEI6MnI/GOKcToZRdmi06HfZN2oY7AQgjDZkTlF/AxI+G9rQfDcOlTrt+71Ydunh
         FxI0N7pagxnn6C96efwfxsR/cz3S7zEtJiE15+vQMss7ColPzujXzzM0pqVyn6wAK/ob
         jRGqw39bttqDhmnGz2uCf1bO3RnIMw4qYS7V/UIX4oPoYEIFU3whY6SmdnK26K32ixwV
         O5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u22jiSFhNbA3v1/UjcAzv8b6+vq2T9VqdxW19p88ScY=;
        b=RCAeIANxYVV4wOLx2Q4E9viTyUUi59obRryEB32uxeqWM/mJKgksvoUbxJwTHrPee6
         zmzVEeFdZwovq/7aUt9fg8Bd2zGAJ1D2t9GkVZ1nq7hNaspgBGXBRQrYbvBh1kPObuDV
         00+qg9vSmX3qWQlT7YGkLp6ZeacBBhg/CRlIugBPGjAvaEdYaiqQQ5mzaBxFPTNrw+R6
         B5OUAtAhwBkW/eKprIjNGf/XliFbybhp/PSBRFcutgyp+aiibDal1XeaJpf9iehntTie
         iCTw3DmwAmXYMNHUkZhCsxdBn85sUS+QKLma5lUnTNzhESdP+PBZLVNMKQKfCrmJaKkB
         XfAA==
X-Gm-Message-State: ACgBeo0b4qcYKbYIGkW6je3eoBQ9KOUBxKHN31GxY3dcNx+g0ekhZkoU
        qKR1gVZwmCzhnmNhhC6Rh314aItt+fm2/Q==
X-Google-Smtp-Source: AA6agR5OOgnUV6Gxwr95HJ5jmoAHznHk1zUZoERe0azzE4I4g9Ay8PIh5fzCPF9VlfV6M9xkTWL73Q==
X-Received: by 2002:a63:ec04:0:b0:41c:1149:4523 with SMTP id j4-20020a63ec04000000b0041c11494523mr22618445pgh.62.1660766988533;
        Wed, 17 Aug 2022 13:09:48 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id x7-20020a628607000000b0053554e0e950sm107630pfd.147.2022.08.17.13.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:09:48 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next v2 2/6] Define QUIC specific constants, control and data plane structures
Date:   Wed, 17 Aug 2022 13:09:36 -0700
Message-Id: <20220817200940.1656747-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817200940.1656747-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
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
 include/uapi/linux/quic.h | 60 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/udp.h  |  3 ++
 2 files changed, 63 insertions(+)
 create mode 100644 include/uapi/linux/quic.h

diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..38c54ff62d37
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,60 @@
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

