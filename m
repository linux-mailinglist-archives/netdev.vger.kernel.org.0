Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A58DF689
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfJUUK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:10:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730069AbfJUUK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571688655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c6Zm4IY7VrUnQ8RKTixaznYCgJL3nPqGqx5Lz+kk3DI=;
        b=OFd3EbEEXhbnQEI415XsMvGbR1rw1WEeWmYgYS+tRN+470O/kh5+bPUDaFLW0wej8Empi4
        G+LcCxcjxfZf6yrlFk19Xul7WyWjrhfy8UE0dkLYnhHC8Iwsl+OPe8BRXz1z1SxlHO8FAt
        3DrvnHTTnqQ0IG4KjfHXHp8aq5ZHwxM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-_-nTbgsYMfy8fsdU9k-agw-1; Mon, 21 Oct 2019 16:10:54 -0400
Received: by mail-wm1-f72.google.com with SMTP id z24so5245848wmk.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 13:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FOEIRt2uhE+VjfvSvcsGDHwxP6iiWF3+DKbQW0z4Upk=;
        b=QvnAVvf3W36P9XMPvjwsYDk5qENeT+/i2T29FL9P8ksdbaNtFtyF+sPPZ43cJ5xTpH
         pDqThzpfaiWPgSA4gm1HEe93Hjo+lXTxA/BLcgxeIE6YGm0snXhgHfotS6lqN8GLtx8H
         oYOzN2ASFc6w1r+Ug9kQCivHNOAjZWyTKVtbmDluzvNW6Z39cpUftWXFAjTCIM9fSwKZ
         OSuUSdSDF14aBDbc/n0Wkc0UTE/xmIAXBn7oweZ9PuLW3nFxzl/GrVBHprAtDd4FmG0Q
         h2DnFC3MOEnQDTU2DnYL51STnzeFptQpG+/5X7FomZYhiaHTKM3GnNlyC5bu8ZRRkU2Z
         Uj6Q==
X-Gm-Message-State: APjAAAVf8QnHhFB2AyAJ/W6O7xOuqoDKgTEMVEl9ILiSEVEl+THjuvdb
        QemJg8Vcvzv4mDPS2O0G+NUaXSQxQKIfwlUFqubfDGBy2ep8di3qEaTOx73xgluo+H7/J0NSR3Z
        xLPB9S2zZQ9BtzVHq
X-Received: by 2002:adf:9001:: with SMTP id h1mr56209wrh.185.1571688652940;
        Mon, 21 Oct 2019 13:10:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyjKq5z+ZvGKweJtbSOvFKPAgD60uXyeSii8F8KpwtDz1LQXgx+Y5uWrPkX1jc35qNA0oxQQg==
X-Received: by 2002:adf:9001:: with SMTP id h1mr56197wrh.185.1571688652744;
        Mon, 21 Oct 2019 13:10:52 -0700 (PDT)
Received: from turbo.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id l18sm20701933wrn.48.2019.10.21.13.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:10:52 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] flow_dissector: skip the ICMP dissector for non ICMP packets
Date:   Mon, 21 Oct 2019 22:09:46 +0200
Message-Id: <20191021200948.23775-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021200948.23775-1-mcroce@redhat.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: _-nTbgsYMfy8fsdU9k-agw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FLOW_DISSECTOR_KEY_ICMP is checked for every packet, not only ICMP ones.
Even if the test overhead is probably negligible, move the
ICMP dissector code under the big 'switch(ip_proto)' so it gets called
only for ICMP packets.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/core/flow_dissector.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index affde70dad47..6443fac65ce8 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -203,6 +203,25 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb,=
 int thoff, u8 ip_proto,
 }
 EXPORT_SYMBOL(__skb_flow_get_ports);
=20
+/* If FLOW_DISSECTOR_KEY_ICMP is set, get the Type and Code from an ICMP p=
acket
+ * using skb_flow_get_be16().
+ */
+static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
+=09=09=09=09    struct flow_dissector *flow_dissector,
+=09=09=09=09    void *target_container,
+=09=09=09=09    void *data, int thoff, int hlen)
+{
+=09struct flow_dissector_key_icmp *key_icmp;
+
+=09if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_ICMP))
+=09=09return;
+
+=09key_icmp =3D skb_flow_dissector_target(flow_dissector,
+=09=09=09=09=09     FLOW_DISSECTOR_KEY_ICMP,
+=09=09=09=09=09     target_container);
+=09key_icmp->icmp =3D skb_flow_get_be16(skb, thoff, data, hlen);
+}
+
 void skb_flow_dissect_meta(const struct sk_buff *skb,
 =09=09=09   struct flow_dissector *flow_dissector,
 =09=09=09   void *target_container)
@@ -853,7 +872,6 @@ bool __skb_flow_dissect(const struct net *net,
 =09struct flow_dissector_key_basic *key_basic;
 =09struct flow_dissector_key_addrs *key_addrs;
 =09struct flow_dissector_key_ports *key_ports;
-=09struct flow_dissector_key_icmp *key_icmp;
 =09struct flow_dissector_key_tags *key_tags;
 =09struct flow_dissector_key_vlan *key_vlan;
 =09struct bpf_prog *attached =3D NULL;
@@ -1295,6 +1313,12 @@ bool __skb_flow_dissect(const struct net *net,
 =09=09=09=09       data, nhoff, hlen);
 =09=09break;
=20
+=09case IPPROTO_ICMP:
+=09case IPPROTO_ICMPV6:
+=09=09__skb_flow_dissect_icmp(skb, flow_dissector, target_container,
+=09=09=09=09=09data, nhoff, hlen);
+=09=09break;
+
 =09default:
 =09=09break;
 =09}
@@ -1308,14 +1332,6 @@ bool __skb_flow_dissect(const struct net *net,
 =09=09=09=09=09=09=09data, hlen);
 =09}
=20
-=09if (dissector_uses_key(flow_dissector,
-=09=09=09       FLOW_DISSECTOR_KEY_ICMP)) {
-=09=09key_icmp =3D skb_flow_dissector_target(flow_dissector,
-=09=09=09=09=09=09     FLOW_DISSECTOR_KEY_ICMP,
-=09=09=09=09=09=09     target_container);
-=09=09key_icmp->icmp =3D skb_flow_get_be16(skb, nhoff, data, hlen);
-=09}
-
 =09/* Process result of IP proto processing */
 =09switch (fdret) {
 =09case FLOW_DISSECT_RET_PROTO_AGAIN:
--=20
2.21.0

