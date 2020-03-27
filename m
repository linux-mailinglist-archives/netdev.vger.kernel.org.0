Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62218194FB8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0DkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:40:13 -0400
Received: from us-smtp-delivery-172.mimecast.com ([63.128.21.172]:51366 "EHLO
        us-smtp-delivery-172.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgC0DkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:40:12 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 23:40:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valvesoftware.com;
        s=mc20150811; t=1585280411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=93NrP1J5ob0+Gg1hAqxUnhANzJSLqVrWUmGujX9AQ0k=;
        b=hDbBLCr8dERDRzS3uE/SrG50N4EVigu3g8dW39rT5zaPO3aK7jmLR19PDzh9lPJYnWW24b
        ZmG9nva6GmdKMPKb+2fXtvng5nEV182VotMqxaaeHtszpoFgO2ABCj738SQ3wlcVG60eYN
        wIsdTaI2fLGDp++obJp55UbxXQ5ok0I=
Received: from smtp01.valvesoftware.com (smtp01.valvesoftware.com
 [208.64.203.181]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-MzPpUS9uMYGspFvS-Rd3sw-1; Thu, 26 Mar 2020 23:24:08 -0400
X-MC-Unique: MzPpUS9uMYGspFvS-Rd3sw-1
Received: from [172.16.1.107] (helo=antispam.valve.org)
        by smtp01.valvesoftware.com with esmtp (Exim 4.86_2)
        (envelope-from <fletcherd@valvesoftware.com>)
        id 1jHfbL-0001Ck-HI; Thu, 26 Mar 2020 20:24:07 -0700
Received: from antispam.valve.org (127.0.0.1) id hflote0171sr; Thu, 26 Mar 2020 20:24:07 -0700 (envelope-from <fletcherd@valvesoftware.com>)
Received: from mail1.valvemail.org ([172.16.144.22])
        by antispam.valve.org ([172.16.1.107]) (SonicWALL 9.0.5.2081 )
        with ESMTP id o202003270324070010485-5; Thu, 26 Mar 2020 20:24:07 -0700
Received: from mail1.valvemail.org (172.16.144.22) by mail1.valvemail.org
 (172.16.144.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 26 Mar
 2020 20:24:07 -0700
Received: from mail1.valvemail.org ([fe80::3155:e19a:4b5e:b8f7]) by
 mail1.valvemail.org ([fe80::3155:e19a:4b5e:b8f7%8]) with mapi id
 15.01.1913.007; Thu, 26 Mar 2020 20:24:07 -0700
From:   Fletcher Dunn <fletcherd@valvesoftware.com>
To:     'Alexei Starovoitov' <ast@kernel.org>,
        'Daniel Borkmann' <daniel@iogearbox.net>
CC:     'Martin KaFai Lau' <kafai@fb.com>,
        'Song Liu' <songliubraving@fb.com>,
        'Yonghong Song' <yhs@fb.com>,
        'Andrii Nakryiko' <andriin@fb.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'bpf@vger.kernel.org'" <bpf@vger.kernel.org>,
        Brandon Gilmore <bgilmore@valvesoftware.com>,
        "Steven Noonan" <steven@valvesoftware.com>
Subject: [PATCH bpf-next] xsk: Init all ring members in xsk_umem__create and
 xsk_socket__create
Thread-Topic: [PATCH bpf-next] xsk: Init all ring members in xsk_umem__create
 and xsk_socket__create
Thread-Index: AdYD5ybf0ykyxQWeQrqqAmtRPVTlSw==
Date:   Fri, 27 Mar 2020 03:24:07 +0000
Message-ID: <85f12913cde94b19bfcb598344701c38@valvesoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.18.42.19]
x-exclaimer-md-config: fe5cb8ea-1338-4c54-81e0-ad323678e037
x-c2processedorg: d7674bc1-f4dc-4fad-9e9e-e896f8a3f31b
MIME-Version: 1.0
X-Mlf-CnxnMgmt-Allow: 172.16.144.22
X-Mlf-Version: 9.0.5.2081
X-Mlf-License: BSVKCAP__
X-Mlf-UniqueId: o202003270324070010485
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: valvesoftware.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a sharp edge in xsk_umem__create and xsk_socket__create.  Almost all of
the members of the ring buffer structs are initialized, but the "cached_xxx=
"
variables are not all initialized.  The caller is required to zero them.
This is needlessly dangerous.  The results if you don't do it can be very b=
ad.
For example, they can cause xsk_prod_nb_free and xsk_cons_nb_avail to retur=
n
values greater than the size of the queue.  xsk_ring_cons__peek can return =
an
index that does not refer to an item that has been queued.

I have confirmed that without this change, my program misbehaves unless I
memset the ring buffers to zero before calling the function.  Afterwards,
my program works without (or with) the memset.

Signed-off-by: Fletcher Dunn <fletcherd@valvesoftware.com>

---

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 9807903f121e..f7f4efb70a4c 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -280,7 +280,11 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr=
, void *umem_area,
 =09fill->consumer =3D map + off.fr.consumer;
 =09fill->flags =3D map + off.fr.flags;
 =09fill->ring =3D map + off.fr.desc;
-=09fill->cached_cons =3D umem->config.fill_size;
+=09fill->cached_prod =3D *fill->producer;
+=09/* cached_cons is "size" bigger than the real consumer pointer
+=09 * See xsk_prod_nb_free
+=09 */
+=09fill->cached_cons =3D *fill->consumer + umem->config.fill_size;
=20
 =09map =3D mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64)=
,
 =09=09   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
@@ -297,6 +301,8 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr,=
 void *umem_area,
 =09comp->consumer =3D map + off.cr.consumer;
 =09comp->flags =3D map + off.cr.flags;
 =09comp->ring =3D map + off.cr.desc;
+=09comp->cached_prod =3D *comp->producer;
+=09comp->cached_cons =3D *comp->consumer;
=20
 =09*umem_ptr =3D umem;
 =09return 0;
@@ -672,6 +678,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, con=
st char *ifname,
 =09=09rx->consumer =3D rx_map + off.rx.consumer;
 =09=09rx->flags =3D rx_map + off.rx.flags;
 =09=09rx->ring =3D rx_map + off.rx.desc;
+=09=09rx->cached_prod =3D *rx->producer;
+=09=09rx->cached_cons =3D *rx->consumer;
 =09}
 =09xsk->rx =3D rx;
=20
@@ -691,7 +699,11 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, co=
nst char *ifname,
 =09=09tx->consumer =3D tx_map + off.tx.consumer;
 =09=09tx->flags =3D tx_map + off.tx.flags;
 =09=09tx->ring =3D tx_map + off.tx.desc;
-=09=09tx->cached_cons =3D xsk->config.tx_size;
+=09=09tx->cached_prod =3D *tx->producer;
+=09=09/* cached_cons is r->size bigger than the real consumer pointer
+=09=09 * See xsk_prod_nb_free
+=09=09 */
+=09=09tx->cached_cons =3D *tx->consumer + xsk->config.tx_size;
 =09}
 =09xsk->tx =3D tx;

