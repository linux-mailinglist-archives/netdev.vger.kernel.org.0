Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85F5AF91E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIGAty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIGAtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:49:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451EF31236;
        Tue,  6 Sep 2022 17:49:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q63so12092120pga.9;
        Tue, 06 Sep 2022 17:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1sYQWtnh8eAQzN0M1bOHJINlbj63vd9/Caz0yn2dSmk=;
        b=Jbx8npI2yp5WFLMicBtRx+Xfu6kM3ERWW8ljC0ghOnb2d7mxZZ/bmhpW7MjCAheq7S
         T3RMXxf/zZvjWeBntjDgqNiLQKzdxi6mO68jJ8NcjmHPCumjJbmUpORUqyrrl+Im4w63
         x9KgLlJwaaPycX+2TLFdrBmmgUH5dat12cK2KiUkTtHEzxc1sEy1rRLvV8uF309Ba3kT
         igmBsWLPCZBBaooQi72qMTBtMax+k/O0IEw9X/p2OihBYQStNQDCgklIqQ56PPHHZwuj
         O5PiwHlRsxirhook01qS56LJuPxiLYZ6O14+qN2VERb3AjfqXZOkcwpubS3fgvkhUtIw
         RePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1sYQWtnh8eAQzN0M1bOHJINlbj63vd9/Caz0yn2dSmk=;
        b=gYHxM6g1D7VHKlProL9gpPgv7bzPpryivDDVDl2EtzFS46WH8CnKCXm5F41H9kAWLp
         n9i40f9o0hcqzThXFhzyGhSJGbd+H1PnLv+Wtz1H0hD8599sX8GFgR5gwPhzDYjBWQRl
         R5sH1sZ8sn3ufVGdqSxWxsOTi2yGaO4xH5qcobHfX3Zmty4R7wYMFLvS+YKXuUq5Ze1b
         cXazaVzkLUKQV8FAqUgrNT3zTrHkBhYRyb4dkQ+/Z6nuszfzOmXmQmU6Lpf8jrODXqAZ
         e8vSVCXuKU+qDiO5y8L6gjLYH0bXV6DzfYqSp8ytHBUep/uvXAl0OZcRK+fH/EHDkYwd
         4dOQ==
X-Gm-Message-State: ACgBeo3oWN6Zch+LNR1Q+VoEKd5UnZobbEamZMaWVYWmSB5QYnHHbclT
        wp4shMkKErZ8yF1U2m8yYQw=
X-Google-Smtp-Source: AA6agR6y9y7kKQK7v3mDFuEVYNq6vDDCJWFT/o6ORoP1+NyLreBqbgHhmgFPM3hXYMALqfOcwNBx6w==
X-Received: by 2002:a63:554a:0:b0:42b:e4a4:ec86 with SMTP id f10-20020a63554a000000b0042be4a4ec86mr1131666pgm.47.1662511788668;
        Tue, 06 Sep 2022 17:49:48 -0700 (PDT)
Received: from localhost (fwdproxy-prn-111.fbsv.net. [2a03:2880:ff:6f::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4-20020a620504000000b00537b1aa9191sm11137033pff.178.2022.09.06.17.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 17:49:47 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [net-next v3 1/6] net: Documentation on QUIC kernel Tx crypto.
Date:   Tue,  6 Sep 2022 17:49:30 -0700
Message-Id: <20220907004935.3971173-2-adel.abushaev@gmail.com>
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

Add documentation for kernel QUIC code.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>

---

Added quic.rst reference to the index.rst file; identation in
quic.rst file.
Reported-by: kernel test robot <lkp@intel.com>

Added SPDX license GPL 2.0.
v2: Removed whitespace at EOF.
v3: Added explanation of features.
---
 Documentation/networking/index.rst |   1 +
 Documentation/networking/quic.rst  | 211 +++++++++++++++++++++++++++++
 2 files changed, 212 insertions(+)
 create mode 100644 Documentation/networking/quic.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index bacadd09e570..0dacd8c8a3ff 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -89,6 +89,7 @@ Contents:
    plip
    ppp_generic
    proc_net_tcp
+   quic
    radiotap-headers
    rds
    regulatory
diff --git a/Documentation/networking/quic.rst b/Documentation/networking/quic.rst
new file mode 100644
index 000000000000..2e6ec72f4eea
--- /dev/null
+++ b/Documentation/networking/quic.rst
@@ -0,0 +1,211 @@
+.. SPDX-License-Identifier: GPL-2.0
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
+The flow match is performed using 5 parameters: source and destination IP
+addresses, source and destination UDP ports and destination QUIC connection ID.
+Not all 5 parameters are always needed. The Tx direction matches the flow on
+the destination IP, port and destination connection ID, while the Rx part would
+later match on source IP, port and destination connection ID. This will cover
+multiple scenarios where the server is using SO_REUSEADDR and/or empty
+destination connection IDs or combination of these.
+
+The Rx direction is not implemented in this set of patches.
+
+The connection migration scenario is not handled by the kernel code and will
+be handled by the user space portion of QUIC library. On the Tx direction,
+the new key would be installed before a packet with an updated destination is
+sent. On the Rx direction, the behavior will be to drop a packet if a flow is
+missing.
+
+For the key rotation, the behavior is to drop packets on Tx when the encryption
+key with matching key rotation bit is not present. On Rx direction, the packet
+will be sent to the userspace library with unencrypted header and encrypted
+payload. A separate indication will be added to the ancillary data to indicate
+the status of the operation as not matching the current key bit. It is not
+possible to use the key rotation bit as part of the key for flow lookup as that
+bit is protected by the header protection. A special provision will need to be
+done in user mode to still attempt the decryption of the payload to prevent a
+timing attack.
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
+.. code-block:: c
+
+	struct quic_connection_info conn_info;
+	char conn_id[5] = {0x01, 0x02, 0x03, 0x04, 0x05};
+	const size_t conn_id_len = sizeof(conn_id);
+	char conn_key[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+			     0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
+	char conn_iv[12] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+			    0x08, 0x09, 0x0a, 0x0b};
+	char conn_hdr_key[16] = {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+				 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
+				};
+
+        conn_info.conn_payload_key_gen = 0;
+	conn_info.cipher_type = TLS_CIPHER_AES_GCM_128;
+
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = 5;
+	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
+				      - conn_id_len],
+	       &conn_id, conn_id_len);
+
+	memcpy(&conn_info.payload_key, conn_key, sizeof(conn_key));
+	memcpy(&conn_info.payload_iv, conn_iv, sizeof(conn_iv));
+	memcpy(&conn_info.header_key, conn_hdr_key, sizeof(conn_hdr_key));
+
+	setsockopt(fd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION, &conn_info,
+		   sizeof(conn_info));
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
+.. code-block:: c
+
+	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
+	conn_info.key.conn_id_length = 5;
+	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
+				      - conn_id_len],
+	       &conn_id, conn_id_len);
+	setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
+		   sizeof(conn_info));
+
+Sending QUIC application data
+-----------------------------
+
+For QUIC Tx encryption offload, the application should use sendmsg() socket
+call and provide ancillary data with information on connection ID length and
+offload flags for the kernel to perform the encryption and GSO support if
+requested.
+
+.. code-block:: c
+
+	size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
+	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
+	struct quic_tx_ancillary_data * anc_data;
+	size_t quic_data_len = 4500;
+	struct cmsghdr * cmsg_hdr;
+	char quic_data[9000];
+	struct iovec iov[2];
+	int send_len = 9000;
+	struct msghdr msg;
+	int err;
+
+	iov[0].iov_base = quic_data;
+	iov[0].iov_len = quic_data_len;
+	iov[1].iov_base = quic_data + 4500;
+	iov[1].iov_len = quic_data_len;
+
+	if (client.addr.sin_family == AF_INET) {
+		msg.msg_name = &client.addr;
+		msg.msg_namelen = sizeof(client.addr);
+	} else {
+		msg.msg_name = &client.addr6;
+		msg.msg_namelen = sizeof(client.addr6);
+	}
+
+	msg.msg_iov = iov;
+	msg.msg_iovlen = 2;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+	cmsg_hdr = CMSG_FIRSTHDR(&msg);
+	cmsg_hdr->cmsg_level = IPPROTO_UDP;
+	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
+	cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
+	anc_data = CMSG_DATA(cmsg_hdr);
+	anc_data->flags = 0;
+	anc_data->next_pkt_num = 0x0d65c9;
+	anc_data->conn_id_length = conn_id_len;
+	err = sendmsg(self->sfd, &msg, 0);
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
+.. code-block:: c
+
+	setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
+		   sizeof(frag_size));
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
+QUIC Tx offload to the kernel has counters
+(``/proc/net/quic_stat``):
+
+- ``QuicCurrTxSw`` -
+  number of currently active kernel offloaded QUIC connections
+- ``QuicTxSw`` -
+  accumulative total number of offloaded QUIC connections
+- ``QuicTxSwError`` -
+  accumulative total number of errors during QUIC Tx offload to kernel
-- 
2.30.2

