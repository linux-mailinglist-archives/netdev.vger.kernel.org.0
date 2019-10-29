Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05D9E89F7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbfJ2NvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:51:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44758 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389007AbfJ2NvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c6Zm4IY7VrUnQ8RKTixaznYCgJL3nPqGqx5Lz+kk3DI=;
        b=Zl/mZjN9ihhNDn01j9ng4MrnuLxHpRdj9D67De0z5g+mh/tgChHyecBCiXcM5ev4PXIDLA
        H+QAJqTANZPGPYzvxZ9IpVzzD1YWar8enON47174efK/GKD+fgVPNSUXtitobIiC+iIx90
        jGgvNeoaLwnKnP0heDHrrEGRgQrTA8k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-KbciWpNZNki-ciBB7y4Opg-1; Tue, 29 Oct 2019 09:51:07 -0400
Received: by mail-wm1-f72.google.com with SMTP id z5so748052wma.5
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FOEIRt2uhE+VjfvSvcsGDHwxP6iiWF3+DKbQW0z4Upk=;
        b=frvqf/A6aW2uRn+3wDE44MCdTYN5QkHwG2x+X1GjPI5bcWi/mENuRtxyTcliNbkZvQ
         KKlhwbAMkVM2X4VnA0H4/i8o8bIN5568Cf4yYYQQZQGb/m0FJRxmUyRRnf4zQtCwGb1Q
         1hEFs5ruGeMog8Mf4wIPr1iDUTql6DuS8jmZbog2Y9WZuBhODTl7MRjHD82t9oy9eS6R
         bEcvGLamEneKTJ05Wur6DdFoaolzaw08ROrATxs7auJME91Q0Iyy6y7pYKBXMFbFb2R+
         diMtHbt5NbqdEWF8sJQYgCnZmjNe9i7tdI4oM/AN38K+4hNKKD8Dt4iCoeC33MrRAe6T
         dXaA==
X-Gm-Message-State: APjAAAVNL4PjoireSpqwD+aMK2pR2CbLqb2X8sJC4NPudMi9TBK6NeNA
        HOI6L5aBJIbeJG0mL/68w7Wpp6dJDuKIcz0gsoGQwufhT0wywHGb9hIF8fLNNpZoOOd9BKQVBEW
        jfz0Fk45NJvm/UL4S
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr18965267wrr.257.1572357066097;
        Tue, 29 Oct 2019 06:51:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxMIycPUBI6kScBBX8AgD5qg5eK3nEhPeqqO6kubTkmz5NyT2QRwAeb8InIxDnf1gzm5aoFpg==
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr18965241wrr.257.1572357065777;
        Tue, 29 Oct 2019 06:51:05 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 189sm2556920wmc.7.2019.10.29.06.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:51:05 -0700 (PDT)
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
Subject: [PATCH net-next v2 2/4] flow_dissector: skip the ICMP dissector for non ICMP packets
Date:   Tue, 29 Oct 2019 14:50:51 +0100
Message-Id: <20191029135053.10055-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029135053.10055-1-mcroce@redhat.com>
References: <20191029135053.10055-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: KbciWpNZNki-ciBB7y4Opg-1
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

