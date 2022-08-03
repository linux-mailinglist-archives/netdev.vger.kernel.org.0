Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E45890B0
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiHCQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiHCQk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:40:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DD0BE0D;
        Wed,  3 Aug 2022 09:40:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a8so3614011pjg.5;
        Wed, 03 Aug 2022 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Kwg0Gxnft/pxS4kgXDydNW4k2vrq3EyTloWOdq0PXAc=;
        b=J6ry0juC/cS1/keXoOwFK+MuEMj4DPNdUiiPrRADSM1Ai+nh2WJjSsFxPPwOLXZi0E
         OQFLgeKjWL//VpC/a7o4RQIChsxIKMpJiHC3LVZu6+hjIksbnXFCwMVBnZVEccTnT0ys
         vFkwXozeovy3Adau/hq0kJAQGYVZzS2gRBdwxtIFRIqkNCDqV3q+OxlSu9HYEJU6Pa4T
         r7Ul+D6d2ijz/bg3/qyOs6vngWUTXsKdCZQzTI4M7OZrARHLX1v1wnD8Vppum8HT5S0w
         4vam+bqP4rurSh0WGNicpfHVVp8+2yynTB+dsrIjuIyrk45tJp3ku3OG970300TI8hMs
         zDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Kwg0Gxnft/pxS4kgXDydNW4k2vrq3EyTloWOdq0PXAc=;
        b=u6lnZthpU7G6OqxH01HU9bLGAscsauIBo5H6G+SNjC8RmwpZ2Vrsx0u/3tuIguIocl
         GOQ8Ib84VnOumKrroEtBi7OGZMaj6zz55HInLRrpWtPFpKTyaYTCQq3mK+WXz+njFJWZ
         tNQwtmgpMRreb6kXyo4BatNqgx9wJ6S6tXoomEZ3zi7w3qp2QUWYWSyL8heA6TMwFLEH
         a5ulQcfrZoHH82Tr5wMNDSi0CscfdUzbSj3XamlZFzMi/u4gUWG7lH2p1n7MycINniSb
         oyX69JL5nh+UzK1P4AluCzcVtW+N2bmOJ38IOhFN+aKYvtclOKeLQv/vL5JUM0QrEvO8
         1JMA==
X-Gm-Message-State: ACgBeo2cJvLTVKyfbFyj94g7uFl/4v+FhPJPn25NZL9d94WGAWEmSGVW
        aaWzdTe2iL2BSzMxCjkbliMtIrh3PkA3kzVT
X-Google-Smtp-Source: AA6agR5MfZwpSsjBltY1tEBSjei9IMpegZCHDn7zPRI8i1VSTvy8b5cdgUNXmy0WqfgjUUtKIU1QnQ==
X-Received: by 2002:a17:902:f80f:b0:16d:c4af:88aa with SMTP id ix15-20020a170902f80f00b0016dc4af88aamr27144961plb.6.1659544857267;
        Wed, 03 Aug 2022 09:40:57 -0700 (PDT)
Received: from localhost (fwdproxy-prn-117.fbsv.net. [2a03:2880:ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903244900b0016cdbb22c28sm2306177pls.0.2022.08.03.09.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:40:56 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 2/6] net: Define QUIC specific constants, control and data plane structures
Date:   Wed,  3 Aug 2022 09:40:41 -0700
Message-Id: <20220803164045.3585187-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803164045.3585187-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

