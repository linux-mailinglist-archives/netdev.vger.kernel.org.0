Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CEA5AFAB7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 05:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiIGDiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 23:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGDiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 23:38:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C00C90823;
        Tue,  6 Sep 2022 20:38:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q3so13241774pjg.3;
        Tue, 06 Sep 2022 20:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aZBY1ytDWkd4w8jVqupdnVQPQRhde1D/W3hmklwt00k=;
        b=UcJVdAfKiABU7wbqiiYMEGf93NQaKn0Q93j6zARb0BtpuiZ8h9K/VQ70KcKo2r4jvB
         CdQGOHWAYlgk+aQdSkyPJgcvauzqn8cTQ5BvxZvkWIoPRFzmmFsvMB/NEyDMk6fS8iwq
         /uzXLJYxx37dQaoxXV3VyFDbYduQMdKFfnbyIbDC1ob/EJjzBr/UOM5q2hmoTdAV7dQg
         2iXFTzW13+dfYAWLJqZmBi7rz8SHjfXnVGEjhXlvxVytXEHse2XHtTrRroKzzHQbvPYD
         JRO3cFL5fY77Z5o3RpoYTjndhZ3+IHwq7AjFjX1LfT+JYQbXWQY0tDLDc9SpqlREKLd4
         UtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aZBY1ytDWkd4w8jVqupdnVQPQRhde1D/W3hmklwt00k=;
        b=m3Wwi3uS0hWU7VdUYHRa/nvf1GQNmXbMvDmvWa77l6aKkrbOLftTIGJUyPE8tkCR97
         7ZMP73PRuRWat4uKiL6GxQqEa9JeVGHd5X2uhvoIYYQ55y24r9vdrjWmQqRzxR1AV6uR
         J72DwIPpe6ts5WD+VvUXR4AHPpL4jS/sga/sm6ddxtCN7eFtbGBWcZz+w6+qoy3rtek+
         HXSXcuoRW5QiPYGw0aLsxzZVtfsluYN9twTI+jwJ+DGwyimD/Q6hdFFK9EM3iYWXeK91
         XFs+jvdrqWtoQhP7JjD9GUvDaIyrQyl6Lvs3AnAS55Bq7wIpKiiajeHK5HpjoD8GEr1/
         DSOg==
X-Gm-Message-State: ACgBeo13YX8tuykiZG4omlAyxl2MZnz3qTEt2O/j/Tu4Lmch+7XYK72I
        J0/POcKQPbjD0pqOzppP5nU=
X-Google-Smtp-Source: AA6agR4nU872ff0af8svryqI1HENnm010hfya/Y3swm7JSGuP6HrUoV5X59o5/RIvI9nAsenWu3VxA==
X-Received: by 2002:a17:90b:4d8c:b0:200:7cd8:333e with SMTP id oj12-20020a17090b4d8c00b002007cd8333emr1695414pjb.95.1662521889463;
        Tue, 06 Sep 2022 20:38:09 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-34.three.co.id. [116.206.12.34])
        by smtp.gmail.com with ESMTPSA id d66-20020a623645000000b0052d33bf14d6sm11058929pfa.63.2022.09.06.20.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 20:38:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 227A9103FC4; Wed,  7 Sep 2022 10:38:04 +0700 (WIB)
Date:   Wed, 7 Sep 2022 10:38:04 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [net-next v3 1/6] net: Documentation on QUIC kernel Tx crypto.
Message-ID: <YxgSHJDAknxqEznd@debian.me>
References: <adel.abushaev@gmail.com>
 <20220907004935.3971173-1-adel.abushaev@gmail.com>
 <20220907004935.3971173-2-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VMxYiAs4WfmYdATp"
Content-Disposition: inline
In-Reply-To: <20220907004935.3971173-2-adel.abushaev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VMxYiAs4WfmYdATp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 06, 2022 at 05:49:30PM -0700, Adel Abouchaev wrote:
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +KERNEL QUIC
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +QUIC is a secure general-purpose transport protocol that creates a state=
ful
> +interaction between a client and a server. QUIC provides end-to-end inte=
grity
> +and confidentiality. Refer to RFC 9000 for more information on QUIC.
> +
> +The kernel Tx side offload covers the encryption of the application stre=
ams
> +in the kernel rather than in the application. These packets are 1RTT pac=
kets
> +in QUIC connection. Encryption of every other packets is still done by t=
he
> +QUIC library in user space.
> +
> +The flow match is performed using 5 parameters: source and destination IP
> +addresses, source and destination UDP ports and destination QUIC connect=
ion ID.
> +Not all 5 parameters are always needed. The Tx direction matches the flo=
w on
> +the destination IP, port and destination connection ID, while the Rx par=
t would
> +later match on source IP, port and destination connection ID. This will =
cover
> +multiple scenarios where the server is using SO_REUSEADDR and/or empty
> +destination connection IDs or combination of these.
> +

Both Tx and Rx direction match destination connection ID. Is it right?

> +The Rx direction is not implemented in this set of patches.
> +
> +The connection migration scenario is not handled by the kernel code and =
will
> +be handled by the user space portion of QUIC library. On the Tx directio=
n,
> +the new key would be installed before a packet with an updated destinati=
on is
> +sent. On the Rx direction, the behavior will be to drop a packet if a fl=
ow is
> +missing.
> +
> +For the key rotation, the behavior is to drop packets on Tx when the enc=
ryption
> +key with matching key rotation bit is not present. On Rx direction, the =
packet
> +will be sent to the userspace library with unencrypted header and encryp=
ted
> +payload. A separate indication will be added to the ancillary data to in=
dicate
> +the status of the operation as not matching the current key bit. It is n=
ot
> +possible to use the key rotation bit as part of the key for flow lookup =
as that
> +bit is protected by the header protection. A special provision will need=
 to be
> +done in user mode to still attempt the decryption of the payload to prev=
ent a
> +timing attack.
> +
> +
> +User Interface
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Creating a QUIC connection
> +--------------------------
> +
> +QUIC connection originates and terminates in the application, using one =
of many
> +available QUIC libraries. The code instantiates QUIC client and QUIC ser=
ver in
> +some form and configures them to use certain addresses and ports for the
> +source and destination. The client and server negotiate the set of keys =
to
> +protect the communication during different phases of the connection, mai=
ntain
> +the connection and perform congestion control.
> +
> +Requesting to add QUIC Tx kernel encryption to the connection
> +-------------------------------------------------------------
> +
> +Each flow that should be encrypted by the kernel needs to be registered =
with
> +the kernel using socket API. A setsockopt() call on the socket creates an
> +association between the QUIC connection ID of the flow with the encrypti=
on
> +parameters for the crypto operations:
> +
> +.. code-block:: c
> +
> +	struct quic_connection_info conn_info;
> +	char conn_id[5] =3D {0x01, 0x02, 0x03, 0x04, 0x05};
> +	const size_t conn_id_len =3D sizeof(conn_id);
> +	char conn_key[16] =3D {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +			     0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
> +	char conn_iv[12] =3D {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +			    0x08, 0x09, 0x0a, 0x0b};
> +	char conn_hdr_key[16] =3D {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x=
17,
> +				 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
> +				};
> +
> +        conn_info.conn_payload_key_gen =3D 0;
> +	conn_info.cipher_type =3D TLS_CIPHER_AES_GCM_128;
> +
> +	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
> +	conn_info.key.conn_id_length =3D 5;
> +	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
> +				      - conn_id_len],
> +	       &conn_id, conn_id_len);
> +
> +	memcpy(&conn_info.payload_key, conn_key, sizeof(conn_key));
> +	memcpy(&conn_info.payload_iv, conn_iv, sizeof(conn_iv));
> +	memcpy(&conn_info.header_key, conn_hdr_key, sizeof(conn_hdr_key));
> +
> +	setsockopt(fd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION, &conn_info,
> +		   sizeof(conn_info));
> +
> +
> +Requesting to remove QUIC Tx kernel crypto offload control messages
> +-------------------------------------------------------------------
> +
> +All flows are removed when the socket is closed. To request an explicit =
remove
> +of the offload for the connection during the lifetime of the socket the =
process
> +is similar to adding the flow. Only the connection ID and its length are
> +necessary to supply to remove the connection from the offload:
> +
> +.. code-block:: c
> +
> +	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
> +	conn_info.key.conn_id_length =3D 5;
> +	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
> +				      - conn_id_len],
> +	       &conn_id, conn_id_len);
> +	setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
> +		   sizeof(conn_info));
> +
> +Sending QUIC application data
> +-----------------------------
> +
> +For QUIC Tx encryption offload, the application should use sendmsg() soc=
ket
> +call and provide ancillary data with information on connection ID length=
 and
> +offload flags for the kernel to perform the encryption and GSO support if
> +requested.
> +
> +.. code-block:: c
> +
> +	size_t cmsg_tx_len =3D sizeof(struct quic_tx_ancillary_data);
> +	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
> +	struct quic_tx_ancillary_data * anc_data;
> +	size_t quic_data_len =3D 4500;
> +	struct cmsghdr * cmsg_hdr;
> +	char quic_data[9000];
> +	struct iovec iov[2];
> +	int send_len =3D 9000;
> +	struct msghdr msg;
> +	int err;
> +
> +	iov[0].iov_base =3D quic_data;
> +	iov[0].iov_len =3D quic_data_len;
> +	iov[1].iov_base =3D quic_data + 4500;
> +	iov[1].iov_len =3D quic_data_len;
> +
> +	if (client.addr.sin_family =3D=3D AF_INET) {
> +		msg.msg_name =3D &client.addr;
> +		msg.msg_namelen =3D sizeof(client.addr);
> +	} else {
> +		msg.msg_name =3D &client.addr6;
> +		msg.msg_namelen =3D sizeof(client.addr6);
> +	}
> +
> +	msg.msg_iov =3D iov;
> +	msg.msg_iovlen =3D 2;
> +	msg.msg_control =3D cmsg_buf;
> +	msg.msg_controllen =3D sizeof(cmsg_buf);
> +	cmsg_hdr =3D CMSG_FIRSTHDR(&msg);
> +	cmsg_hdr->cmsg_level =3D IPPROTO_UDP;
> +	cmsg_hdr->cmsg_type =3D UDP_QUIC_ENCRYPT;
> +	cmsg_hdr->cmsg_len =3D CMSG_LEN(cmsg_tx_len);
> +	anc_data =3D CMSG_DATA(cmsg_hdr);
> +	anc_data->flags =3D 0;
> +	anc_data->next_pkt_num =3D 0x0d65c9;
> +	anc_data->conn_id_length =3D conn_id_len;
> +	err =3D sendmsg(self->sfd, &msg, 0);
> +
> +QUIC Tx offload in kernel will read the data from userspace, encrypt and
> +copy it to the ciphertext within the same operation.
> +
> +
> +Sending QUIC application data with GSO
> +--------------------------------------
> +When GSO is in use, the kernel will use the GSO fragment size as the tar=
get
> +for ciphertext. The packets from the user space should align on the boun=
dary
> +of GSO fragment size minus the size of the tag for the chosen cipher. Fo=
r the
> +GSO fragment 1200, the plain packets should follow each other at every 1=
184
> +bytes, given the tag size of 16. After the encryption, the rest of the U=
DP
> +and IP stacks will follow the defined value of GSO fragment which will i=
nclude
> +the trailing tag bytes.
> +
> +To set up GSO fragmentation:
> +
> +.. code-block:: c
> +
> +	setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
> +		   sizeof(frag_size));
> +
> +If the GSO fragment size is provided in ancillary data within the sendms=
g()
> +call, the value in ancillary data will take precedence over the segment =
size
> +provided in setsockopt to split the payload into packets. This is consis=
tent
> +with the UDP stack behavior.
> +
> +Integrating to userspace QUIC libraries
> +---------------------------------------
> +
> +Userspace QUIC libraries integration would depend on the implementation =
of the
> +QUIC protocol. For MVFST library, the control plane is integrated into t=
he
> +handshake callbacks to properly configure the flows into the socket; and=
 the
> +data plane is integrated into the methods that perform encryption and se=
nd
> +the packets to the batch scheduler for transmissions to the socket.
> +
> +MVFST library can be found at https://github.com/facebookincubator/mvfst.
> +
> +Statistics
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +QUIC Tx offload to the kernel has counters
> +(``/proc/net/quic_stat``):
> +
> +- ``QuicCurrTxSw`` -
> +  number of currently active kernel offloaded QUIC connections
> +- ``QuicTxSw`` -
> +  accumulative total number of offloaded QUIC connections
> +- ``QuicTxSwError`` -
> +  accumulative total number of errors during QUIC Tx offload to kernel

The rest of documentation can be improved, like:

---- >8 ----

diff --git a/Documentation/networking/quic.rst b/Documentation/networking/q=
uic.rst
index 2e6ec72f4eea3a..3f3d05b901da3f 100644
--- a/Documentation/networking/quic.rst
+++ b/Documentation/networking/quic.rst
@@ -9,22 +9,22 @@ Overview
=20
 QUIC is a secure general-purpose transport protocol that creates a stateful
 interaction between a client and a server. QUIC provides end-to-end integr=
ity
-and confidentiality. Refer to RFC 9000 for more information on QUIC.
+and confidentiality. Refer to RFC 9000 [#rfc9000]_ for the standard docume=
nt.
=20
 The kernel Tx side offload covers the encryption of the application streams
 in the kernel rather than in the application. These packets are 1RTT packe=
ts
 in QUIC connection. Encryption of every other packets is still done by the
-QUIC library in user space.
+QUIC library in userspace.
=20
 The flow match is performed using 5 parameters: source and destination IP
 addresses, source and destination UDP ports and destination QUIC connectio=
n ID.
-Not all 5 parameters are always needed. The Tx direction matches the flow =
on
-the destination IP, port and destination connection ID, while the Rx part =
would
-later match on source IP, port and destination connection ID. This will co=
ver
-multiple scenarios where the server is using SO_REUSEADDR and/or empty
-destination connection IDs or combination of these.
+Not all these parameters are always needed. The Tx direction matches the f=
low
+on the destination IP, port and destination connection ID; while the Rx
+direction would later match on source IP, port and destination connection =
ID.
+This will cover multiple scenarios where the server is using ``SO_REUSEADD=
R``
+and/or empty destination connection IDs or combination of these.
=20
-The Rx direction is not implemented in this set of patches.
+The Rx direction is not implemented yet.
=20
 The connection migration scenario is not handled by the kernel code and wi=
ll
 be handled by the user space portion of QUIC library. On the Tx direction,
@@ -39,8 +39,8 @@ payload. A separate indication will be added to the ancil=
lary data to indicate
 the status of the operation as not matching the current key bit. It is not
 possible to use the key rotation bit as part of the key for flow lookup as=
 that
 bit is protected by the header protection. A special provision will need t=
o be
-done in user mode to still attempt the decryption of the payload to preven=
t a
-timing attack.
+done in user mode to keep attempting the payload decription to prevent tim=
ing
+attacks.
=20
=20
 User Interface
@@ -50,7 +50,7 @@ Creating a QUIC connection
 --------------------------
=20
 QUIC connection originates and terminates in the application, using one of=
 many
-available QUIC libraries. The code instantiates QUIC client and QUIC serve=
r in
+available QUIC libraries. The code instantiates the client and server in
 some form and configures them to use certain addresses and ports for the
 source and destination. The client and server negotiate the set of keys to
 protect the communication during different phases of the connection, maint=
ain
@@ -60,7 +60,7 @@ Requesting to add QUIC Tx kernel encryption to the connec=
tion
 -------------------------------------------------------------
=20
 Each flow that should be encrypted by the kernel needs to be registered wi=
th
-the kernel using socket API. A setsockopt() call on the socket creates an
+the kernel using socket API. A ``setsockopt()`` call on the socket creates=
 an
 association between the QUIC connection ID of the flow with the encryption
 parameters for the crypto operations:
=20
@@ -112,10 +112,10 @@ necessary to supply to remove the connection from the=
 offload:
 	setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
 		   sizeof(conn_info));
=20
-Sending QUIC application data
------------------------------
+Sending application data
+------------------------
=20
-For QUIC Tx encryption offload, the application should use sendmsg() socket
+For Tx encryption offload, the application should use ``sendmsg()`` socket
 call and provide ancillary data with information on connection ID length a=
nd
 offload flags for the kernel to perform the encryption and GSO support if
 requested.
@@ -168,11 +168,11 @@ Sending QUIC application data with GSO
 --------------------------------------
 When GSO is in use, the kernel will use the GSO fragment size as the target
 for ciphertext. The packets from the user space should align on the bounda=
ry
-of GSO fragment size minus the size of the tag for the chosen cipher. For =
the
-GSO fragment 1200, the plain packets should follow each other at every 1184
-bytes, given the tag size of 16. After the encryption, the rest of the UDP
-and IP stacks will follow the defined value of GSO fragment which will inc=
lude
-the trailing tag bytes.
+of the fragment size minus the tag size for the chosen cipher. For example,
+if the fragment size is 1200 bytes and the tag size is 16 bytes, the plain
+packets should follow each other at every 1184 bytes. After the encryption,
+the rest of UDP and IP stacks will follow the defined value of the fragmen=
t,
+which includes the trailing tag bytes.
=20
 To set up GSO fragmentation:
=20
@@ -181,7 +181,7 @@ To set up GSO fragmentation:
 	setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
 		   sizeof(frag_size));
=20
-If the GSO fragment size is provided in ancillary data within the sendmsg()
+If the fragment size is provided in ancillary data within the ``sendmsg()``
 call, the value in ancillary data will take precedence over the segment si=
ze
 provided in setsockopt to split the payload into packets. This is consiste=
nt
 with the UDP stack behavior.
@@ -190,12 +190,10 @@ Integrating to userspace QUIC libraries
 ---------------------------------------
=20
 Userspace QUIC libraries integration would depend on the implementation of=
 the
-QUIC protocol. For MVFST library, the control plane is integrated into the
-handshake callbacks to properly configure the flows into the socket; and t=
he
-data plane is integrated into the methods that perform encryption and send
-the packets to the batch scheduler for transmissions to the socket.
-
-MVFST library can be found at https://github.com/facebookincubator/mvfst.
+QUIC protocol. For MVFST library [#mvfst]_, the control plane is integrated
+into the handshake callbacks to properly configure the flows into the sock=
et;
+and the data plane is integrated into the methods that perform encryption
+and send the packets to the batch scheduler for transmissions to the socke=
t.
=20
 Statistics
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -209,3 +207,9 @@ QUIC Tx offload to the kernel has counters
   accumulative total number of offloaded QUIC connections
 - ``QuicTxSwError`` -
   accumulative total number of errors during QUIC Tx offload to kernel
+
+References
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. [#rfc9000] https://datatracker.ietf.org/doc/html/rfc9000
+.. [#mvfst] https://github.com/facebookincubator/mvfst

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--VMxYiAs4WfmYdATp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxgSEgAKCRD2uYlJVVFO
ozzfAQCHLoap/Svhj4PBFxGxVQ55yhJdcxkwFTlEnAU5ppoP9AEAj+PPrUhZ88vY
13QQGtX+vzVAelzd6rcX/5/fVMGLewM=
=Us4K
-----END PGP SIGNATURE-----

--VMxYiAs4WfmYdATp--
