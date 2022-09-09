Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDA55B2ADA
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiIIANF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiIIAM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:12:59 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3544979DD;
        Thu,  8 Sep 2022 17:12:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h188so49252pgc.12;
        Thu, 08 Sep 2022 17:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=ZJT5GYDkVFENsUBhpyoks9L0T+354trIjuNdDh8FcJw=;
        b=c2VSbnYxytlpfiLwPOgg9kG60EA1RMQG4vDxZiuMVfzaY68XAun2WQxIiQ66Phbmit
         f9pcdDWYAUEA6pIWWiTAn8Dd5JiThbxMe3qz1k5nXCBjGb2ny3R4+PuyeIa/TvgW+lLa
         eTpN6aWHuQ1i7I/RydRa9S9hQIsg1JuiF1WoM8tg1FEyAqk7P79O5OkKlxE4TaKwOA89
         XmRBN24laYs/AMIExixx5Sx9b6B+K5h+w5rBieK5+iFARrIeqcMfMLLC9DwY29YO4hkL
         GtUPKZeknmCPIRNmu7qt3dghbEd1CdfCGOcjuToq+3Pcr0iB4I6oo5FaDhvAUHh8+tfG
         nNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZJT5GYDkVFENsUBhpyoks9L0T+354trIjuNdDh8FcJw=;
        b=spqbxIcI6amGXxQNz/4lCFbPh/asuAtrbs0USUWJbb/UtcWJtjp/af/Mb6MQ4vyheR
         HlmQc0uHB/e5XZkzmHr+Dr2aIQkIP4fiIo0RNlpMuuzWLmBOOfpKCHQbSBrL5ckFRD5K
         d13lyt7mVjDUuVF2XynrwulaqEVTmNKv/40mDZ7yMhOc5DF8ux4OSiMlhGYFQca0HTb6
         Ac7fAh5ON/s/KEkgSlWJlfmfK19HVXHhOItxAxwqI9t4VsYi2tnXGA8DBaxJVMHdmspI
         z7NEoXx6vlbKF98ZD5cfIlbk+h+4J8vdPz75QC4kkB8E2zEoD1hPLAtpcxz11L8za3bX
         bFvg==
X-Gm-Message-State: ACgBeo0ZY1jrGa/EoY4IsNRuolmTQ3VPB8oasRFoOPIfkrUmSj/TGNTn
        EezeGM20qJoOtCPrv7J71hw=
X-Google-Smtp-Source: AA6agR6KMU55N2rmv82Ze/wzRZHTGYwzWSP5b+/B4BdL9awEk5shWb7IN34IawwhmglcUQPMMyEbew==
X-Received: by 2002:a05:6a00:9a5:b0:536:29e:c91d with SMTP id u37-20020a056a0009a500b00536029ec91dmr11173365pfg.22.1662682375129;
        Thu, 08 Sep 2022 17:12:55 -0700 (PDT)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b00177f82f0789sm98162plg.198.2022.09.08.17.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 17:12:54 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [net-next v4 2/6] net: Define QUIC specific constants, control and data plane structures
Date:   Thu,  8 Sep 2022 17:12:34 -0700
Message-Id: <20220909001238.3965798-3-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220909001238.3965798-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220909001238.3965798-1-adel.abushaev@gmail.com>
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
v4: added missing linux/in.h and linux/in6.h to the quic.h file.
---
 include/uapi/linux/quic.h | 68 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/udp.h  |  3 ++
 2 files changed, 71 insertions(+)
 create mode 100644 include/uapi/linux/quic.h

diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..3a281a3037f0
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) */
+
+#ifndef _UAPI_LINUX_QUIC_H
+#define _UAPI_LINUX_QUIC_H
+
+#include <linux/in.h>
+#include <linux/in6.h>
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

