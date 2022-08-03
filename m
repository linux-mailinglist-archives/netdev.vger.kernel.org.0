Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FFC5890AE
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiHCQk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHCQk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:40:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D6D3FA2D;
        Wed,  3 Aug 2022 09:40:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w17-20020a17090a8a1100b001f326c73df6so2586216pjn.3;
        Wed, 03 Aug 2022 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6f6UeQgMn+TPm3ZyUUYdEOtR8TNhGAES6KBfFAB1onE=;
        b=IwtCfhxl1pwowIz/mhN75DJWVBGy4ec92iEEEsAjJYkc+pOXxOFyGOl7UThWzMlXo3
         r25qDvAUFA7rcatR0puxdSGYI4dnRv5BrKYH/4p3YAL2g7B+se+xqQHSGuXWLXDNPSV5
         hwj5LPpGY5L+ASvFGWPwKBtk5vHGRf09ESroFS3wBzehVboeqoLBjrBMOQTly/ROYFML
         MrKAi1PTpT2YRs6Pgt1DRrrNf/jV+OaICUoXNPThBSp7KT5Wb9I/jyilH6Xghff2CyjE
         MoCKj50F/noiRwvBLVq5X4jVOfL8Tc+UH2sClqZSfuj1AL+tyruoEbdutOHadcuQkubm
         rizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6f6UeQgMn+TPm3ZyUUYdEOtR8TNhGAES6KBfFAB1onE=;
        b=lWlET9VZoMxfF19KPhgCNRFA7TMpRutX0AOJ8v6HTvP1KsCFv+GCpb5oYf0/9DfnPs
         1rjzl5rEgpl6n68rpTxUbmCpE/3YIKOmEn824zWsQfQLYO/w0tPhXP2QBMMzc1n/kxXu
         +cpdi62aa5xyb17h1l6MsxV3UoIxyBK5B6Fzd1WYuTWK4WgxZVncVkPWqgB8AAKotvnY
         z46zq9UMqIGzQqwWzuchLb52+Tkj2zCGMiLvzalmKwK1vTapFuVxd60afd2WkA1LZK+p
         hhq/09AQiJOHIwZPTpAvUHKCo5NwW6kitpO/gakC/nMluOrZExJoju3LwZM6dqTB6mvB
         loNg==
X-Gm-Message-State: ACgBeo05C7A1PnLc/+UwCW1AXTmIYCovmJxE8yEdl2CZdKVuUzL3DSZv
        vmdJ8sxzx4d2HVK2nVZUSMY=
X-Google-Smtp-Source: AA6agR6mPeQrqI7qEdGL3qjhEipJpcXo89Pf1jRbytOaQZ1THr+8b69FpUz8Ca8P5FL9eOmRJ5C0VQ==
X-Received: by 2002:a17:902:a418:b0:16c:9ee2:8a02 with SMTP id p24-20020a170902a41800b0016c9ee28a02mr27011748plq.46.1659544856240;
        Wed, 03 Aug 2022 09:40:56 -0700 (PDT)
Received: from localhost (fwdproxy-prn-011.fbsv.net. [2a03:2880:ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b0016dc6243bb2sm2157644pli.143.2022.08.03.09.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:40:55 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Date:   Wed,  3 Aug 2022 09:40:40 -0700
Message-Id: <20220803164045.3585187-2-adel.abushaev@gmail.com>
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

Adding Documentation/networking/quic.rst file to describe kernel QUIC
code.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
---
 Documentation/networking/quic.rst | 176 ++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)
 create mode 100644 Documentation/networking/quic.rst

diff --git a/Documentation/networking/quic.rst b/Documentation/networking/quic.rst
new file mode 100644
index 000000000000..eaa2d36310be
--- /dev/null
+++ b/Documentation/networking/quic.rst
@@ -0,0 +1,176 @@
+.. _kernel_quic:
+
+===========
+KERNEL QUIC
+===========
+
+Overview
+========
+
+QUIC is a secure general-purpose transport protocol that creates a stateful
+interaction between a client and a server. QUIC provides end-to-end integrity
+and confidentiality. Refer to RFC 9000 for more information on QUIC.
+
+The kernel Tx side offload covers the encryption of the application streams
+in the kernel rather than in the application. These packets are 1RTT packets
+in QUIC connection. Encryption of every other packets is still done by the
+QUIC library in user space.
+
+
+
+User Interface
+==============
+
+Creating a QUIC connection
+--------------------------
+
+QUIC connection originates and terminates in the application, using one of many
+available QUIC libraries. The code instantiates QUIC client and QUIC server in
+some form and configures them to use certain addresses and ports for the
+source and destination. The client and server negotiate the set of keys to
+protect the communication during different phases of the connection, maintain
+the connection and perform congestion control.
+
+Requesting to add QUIC Tx kernel encryption to the connection
+-------------------------------------------------------------
+
+Each flow that should be encrypted by the kernel needs to be registered with
+the kernel using socket API. A setsockopt() call on the socket creates an
+association between the QUIC connection ID of the flow with the encryption
+parameters for the crypto operations:
+
+.. code_block:: c
+  struct quic_connection_info conn_info;
+  char conn_id[5] = {0x01, 0x02, 0x03, 0x04, 0x05};
+  const size_t conn_id_len = sizeof(conn_id);
+  char conn_key[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+                       0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
+  char conn_iv[12] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+                      0x08, 0x09, 0x0a, 0x0b};
+  char conn_hdr_key[16] = {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+                       0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f};
+
+  conn_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+
+  memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+  conn_info.key.conn_id_length = 5;
+  memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE - conn_id_len],
+         &conn_id, conn_id_len);
+
+  memcpy(&conn_info.payload_key, conn_key, sizeof(conn_key));
+  memcpy(&conn_info.payload_iv, conn_iv, sizeof(conn_iv));
+  memcpy(&conn_info.header_key, conn_hdr_key, sizeof(conn_hdr_key));
+
+  setsockopt(fd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION, &conn_info,
+             sizeof(conn_info));
+
+
+Requesting to remove QUIC Tx kernel crypto offload control messages
+-------------------------------------------------------------------
+
+All flows are removed when the socket is closed. To request an explicit remove
+of the offload for the connection during the lifetime of the socket the process
+is similar to adding the flow. Only the connection ID and its length are 
+necessary to supply to remove the connection from the offload:
+
+.. code_block:: c
+
+  memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+  conn_info.key.conn_id_length = 5;
+  memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE - conn_id_len],
+         &conn_id, conn_id_len);
+  setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
+             sizeof(conn_info));
+
+Sending QUIC application data
+-----------------------------
+
+For QUIC Tx encryption offload, the application should use sendmsg() socket
+call and provide ancillary data with information on connection ID length and
+offload flags for the kernel to perform the encryption and GSO support if
+requested.
+
+.. code_block:: c
+
+  size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
+  uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
+  struct quic_tx_ancillary_data * anc_data;
+  size_t quic_data_len = 4500;
+  struct cmsghdr * cmsg_hdr;
+  char quic_data[9000];
+  struct iovec iov[2];
+  int send_len = 9000;
+  struct msghdr msg;
+  int err;
+
+  iov[0].iov_base = quic_data;
+  iov[0].iov_len = quic_data_len;
+  iov[1].iov_base = quic_data + 4500;
+  iov[1].iov_len = quic_data_len;
+
+  if (client.addr.sin_family == AF_INET) {
+    msg.msg_name = &client.addr;
+    msg.msg_namelen = sizeof(client.addr);
+  } else {
+    msg.msg_name = &client.addr6;
+    msg.msg_namelen = sizeof(client.addr6);
+  }
+
+  msg.msg_iov = iov;
+  msg.msg_iovlen = 2;
+  msg.msg_control = cmsg_buf;
+  msg.msg_controllen = sizeof(cmsg_buf);
+  cmsg_hdr = CMSG_FIRSTHDR(&msg);
+  cmsg_hdr->cmsg_level = IPPROTO_UDP;
+  cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+  cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
+  anc_data = CMSG_DATA(cmsg_hdr);
+  anc_data->flags = 0;
+  anc_data->next_pkt_num = 0x0d65c9;
+  anc_data->conn_id_length = conn_id_len;
+  err = sendmsg(self->sfd, &msg, 0);
+
+QUIC Tx offload in kernel will read the data from userspace, encrypt and
+copy it to the ciphertext within the same operation.
+
+
+Sending QUIC application data with GSO
+--------------------------------------
+When GSO is in use, the kernel will use the GSO fragment size as the target
+for ciphertext. The packets from the user space should align on the boundary
+of GSO fragment size minus the size of the tag for the chosen cipher. For the
+GSO fragment 1200, the plain packets should follow each other at every 1184
+bytes, given the tag size of 16. After the encryption, the rest of the UDP
+and IP stacks will follow the defined value of GSO fragment which will include
+the trailing tag bytes.
+
+To set up GSO fragmentation:
+
+.. code_block:: c
+  setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size, sizeof(frag_size));
+
+If the GSO fragment size is provided in ancillary data within the sendmsg()
+call, the value in ancillary data will take precedence over the segment size
+provided in setsockopt to split the payload into packets. This is consistent
+with the UDP stack behavior.
+
+Integrating to userspace QUIC libraries
+---------------------------------------
+
+Userspace QUIC libraries integration would depend on the implementation of the
+QUIC protocol. For MVFST library, the control plane is integrated into the
+handshake callbacks to properly configure the flows into the socket; and the
+data plane is integrated into the methods that perform encryption and send
+the packets to the batch scheduler for transmissions to the socket.
+
+MVFST library can be found at https://github.com/facebookincubator/mvfst.
+
+Statistics
+==========
+
+QUIC Tx offload to the kernel has counters reflected in /proc/net/quic_stat:
+
+  QuicCurrTxSw  - number of currently active kernel offloaded QUIC connections
+  QuicTxSw      - accumulative total number of offloaded QUIC connections
+  QuicTxSwError - accumulative total number of errors during QUIC Tx offload to
+                  kernel
-- 
2.30.2

