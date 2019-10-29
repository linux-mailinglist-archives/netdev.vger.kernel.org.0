Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A3BE9121
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfJ2U5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:57:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727545AbfJ2U5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572382642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=I4J5qAB+5RFtqFp6r7FKOzdmQSWWB1YJC490t19dC1w=;
        b=ELb0HtW2h+/iMJrcGuw7vGtGbFMaQvLu/n1KOH14gWqjysDW83kSXtEHjxJOH04cxEcZoQ
        bCKYg/P67hTr40sDz9ID+86/vZOayXstz3YnYdMfcDgNUKiMqhlk8ej9fYfImUnVoO1LTv
        r40Mglk3zAfpOCYRLF7v3zQc+slLeY4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-BwSJvzuMMcSGCgeWEG_klQ-1; Tue, 29 Oct 2019 16:57:14 -0400
Received: by mail-wr1-f69.google.com with SMTP id 7so81073wrl.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 13:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GTlMSkWIOdhQJyhaU9xDqRpYB6UT9098TiEsw62v4l0=;
        b=g8Ra4d1yh4yjE8ipMx58eJ7G36v9khZ5TxvGnJcMb8WenpImF4fX1grlFJrAGPYgVd
         SIZ4fo3AivYyBvJg+s4k4b7PQEF2duezkmgF/sR6k/xj83/31eDRFqv0IZLSWFh00Xy+
         cxn1ECpFE+QKmAkHc9PGtnAYPZWOGu+dHjTKJcdYM9Yt6yrU5O0xjQ5GMuP4BVFRG/NQ
         aL7JgPMLGa3jcms2ej3v6ewaxLl8Ggv1cw90HAI+JhMZAMDeLsHWgZjIK5Ey1rVJ5efR
         X8MKTJSZhLCdHktZhkTgZQ3maRnYQMq46QUPNVCgiBjCXihKZ2Msidr241G8MzuC0Jj7
         KGMQ==
X-Gm-Message-State: APjAAAWdmcaZvaLwTEqkxBKyIBlPgJynlij5J35m7al3P9zkb1uBbgZ/
        tC/Oo77/CK7QNPVJVuRX9jvyzGrV1CisL+xeOpvthS0hgAkYiL/5D6VlrWQrKOs7kJ0kdqzK2Bs
        9uQwHn1AReJfLaaos
X-Received: by 2002:adf:fe10:: with SMTP id n16mr22953572wrr.288.1572382633388;
        Tue, 29 Oct 2019 13:57:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwDAOPbZjoUub7XfKmpminHRgePRpno+56f/wEZdjeqM1v63sfdh00hT6h06Wxqe969EonlTA==
X-Received: by 2002:adf:fe10:: with SMTP id n16mr22953561wrr.288.1572382633189;
        Tue, 29 Oct 2019 13:57:13 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id 62sm135829wre.38.2019.10.29.13.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 13:57:12 -0700 (PDT)
Date:   Tue, 29 Oct 2019 21:57:10 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net-next] vxlan: drop "vxlan" parameter in vxlan_fdb_alloc()
Message-ID: <909fa55ac93fa8727ee1d9ec273011056ad7d61f.1572382598.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: BwSJvzuMMcSGCgeWEG_klQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This parameter has never been used.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/vxlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc957f7d..5ffea8e34771 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -793,8 +793,7 @@ static int vxlan_gro_complete(struct sock *sk, struct s=
k_buff *skb, int nhoff)
 =09return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
 }
=20
-static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
-=09=09=09=09=09 const u8 *mac, __u16 state,
+static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 =09=09=09=09=09 __be32 src_vni, __u16 ndm_flags)
 {
 =09struct vxlan_fdb *f;
@@ -835,7 +834,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 =09=09return -ENOSPC;
=20
 =09netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
-=09f =3D vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
+=09f =3D vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
 =09if (!f)
 =09=09return -ENOMEM;
=20
--=20
2.21.0

