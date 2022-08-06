Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1687C58B37F
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 05:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbiHFDFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 23:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbiHFDF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 23:05:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4AF64E7;
        Fri,  5 Aug 2022 20:05:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h28so3703097pfq.11;
        Fri, 05 Aug 2022 20:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=n8+NipbWf5CWfrx8TWjHTrF2OSwrvOKYX0gdYlyE18s=;
        b=bwYBu4cJI+oS6w8DfxAZJ+BPnr1rph8YlalgAVpgFmLEEuEjt7QQz+eAuAfslm5d38
         d8s/L4uufpveOI04Nlqvj/MatovUFco/zMIfvQ64nE8SgUnUWfCePeNpmrHfIvFR7IVa
         KxM8DLeL5q7QTbEpZi6ZpEHxQ4nuYfu05teDBTHJ6oRCy9AUoUt8ke53G4Wv4o0InnAk
         fN3ZXDZDXRA39MbOatQ4k/Vzh1mowqpqAAWkIai8CrsSOV+WB6FGlvqUynwuXvGt5O8K
         rP0KUdSEMF6MnJAF4ERReEuUa12KmDkiM+bVT0aEceQnE1ogoqTuAPdbEncTw5u8J7T/
         LONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=n8+NipbWf5CWfrx8TWjHTrF2OSwrvOKYX0gdYlyE18s=;
        b=LlbI00pB7/Y51lnMXimR3W4heB76MCjImJs1cswl1JzCDLAM1ai22SK5dndWJ6RLeP
         yaqNeVunGE+RKgxHHhh2qV7BNP0W8aRFgqFz12A50gwuCvAWDMnxDK2UAvSeqvUcNdtx
         UBJDiGeUPCaRyWyz2AFNu0cmTFRlbJe5+MvmF1Jxs1ogkIpzhzCu59foUIfvyMyaZqx1
         bTg0BqSgiqhAw6+4fW+mBqqRBHvCNF3VGKOXmv7WMa/HhwcUAv4rKWvNkNIqDdi59nn2
         G/fvXxvQat+tI4Vxz61dNIOJ042JcFax0Wuz1G2R4oX+HYpWOg5h/3aEa0Wsq4a+O7Sm
         W6bQ==
X-Gm-Message-State: ACgBeo28TPPm+Yts5A3RpeniVT55CRqbRVgK0oPVuCXSaEpcKps1l4RI
        pGca0DtC7stucpCerH9mdHxyZN+q3DWuIA==
X-Google-Smtp-Source: AA6agR7JM3+A4pqK31PRlWohLglDPElRKVIbnsggDucP6UdSPQVF1qMguMCUZHO5L2rtr0gTi/rcaw==
X-Received: by 2002:a05:6a00:23d0:b0:52e:74be:d52 with SMTP id g16-20020a056a0023d000b0052e74be0d52mr9508368pfc.62.1659755127673;
        Fri, 05 Aug 2022 20:05:27 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-80.three.co.id. [180.214.232.80])
        by smtp.gmail.com with ESMTPSA id o190-20020a6341c7000000b0040c40b022fbsm2102035pga.94.2022.08.05.20.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 20:05:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7FEFC1006CD; Sat,  6 Aug 2022 10:05:21 +0700 (WIB)
Date:   Sat, 6 Aug 2022 10:05:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [RFC net-next v2 1/6] Documentation on QUIC kernel Tx crypto.
Message-ID: <Yu3acQf/xS6g/bdH@debian.me>
References: <adel.abushaev@gmail.com>
 <20220806001153.1461577-1-adel.abushaev@gmail.com>
 <20220806001153.1461577-2-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
        protocol="application/pgp-signature"; boundary="A3X+hUfrymK5EW66"
Content-Disposition: inline
In-Reply-To: <20220806001153.1461577-2-adel.abushaev@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--A3X+hUfrymK5EW66
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2022 at 05:11:48PM -0700, Adel Abouchaev wrote:
> Adding Documentation/networking/quic.rst file to describe kernel QUIC
> code.
>=20

Better say "Add documentation for kernel QUIC code".

> diff --git a/Documentation/networking/index.rst b/Documentation/networkin=
g/index.rst
> index 03b215bddde8..656fa1dac26b 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -90,6 +90,7 @@ Contents:
>     plip
>     ppp_generic
>     proc_net_tcp
> +   quic
>     radiotap-headers
>     rds
>     regulatory
> diff --git a/Documentation/networking/quic.rst b/Documentation/networking=
/quic.rst
> new file mode 100644
> index 000000000000..416099b80e60
> --- /dev/null
> +++ b/Documentation/networking/quic.rst
> @@ -0,0 +1,186 @@
> +.. _kernel_quic:
> +
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
> +

The documentation looks OK (no new warnings).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--A3X+hUfrymK5EW66
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTsebsWCPCpxY9T92n/R0PGQ3AzwAUCYu3aZgAKCRD/R0PGQ3Az
wPHCAXsHJlkoC4SvIiMU7ZdQdMPDxZwiHOCbcuky0UhYBzntVQ1MOsfx1jly/6Fz
7iAwAJEBgK2BgMFiyRoOhzqY3c3rlMCIejvb2x856Zjrg1aM8FyhR2lSx20HLxXW
x3ZXNjiIRw==
=Y0/a
-----END PGP SIGNATURE-----

--A3X+hUfrymK5EW66--
