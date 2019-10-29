Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3979EE89FD
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbfJ2Nv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:51:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29781 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388802AbfJ2NvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tDNUWkKpQnw1yHaB0W3iJg2EXkt52WFEwMuPDE5I/Vc=;
        b=Tr6CBIl2n3oCRIRR4O9eNloS43uLvRziSOjS9dY/qzjtZHdMB8P3piR8Wj0YlrhZfn+oQU
        GWNDrcIWqJY61k1m4FXO4PLllXECie2374J7/VcDUh2BwQaEf2VKGcb6dmmgSgW5Gv6+6R
        MdMObfJbF7JEI9xkVQuvB21Hnv0Ve1w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-aN6DRYU8MAqrZImbK9BdHg-1; Tue, 29 Oct 2019 09:51:12 -0400
Received: by mail-wr1-f72.google.com with SMTP id 4so8411120wrf.19
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgCGxqUSVZkkV529W9PQ2OLPt6lHiQPIyC5Y4Q9bYuA=;
        b=cUJa9pBQsfSA/6cquVMkRvx7LKWMgBMS1l1VMELAoXEPpJPOn9+wEvgdi0sG59tZ3k
         nT5Bi273IBI5ABqBg8Cx+TEA0EhVi6C/imS4TMmFtWgNH5VhPu9MY/lrmn1Fmhe4+Q0T
         HnEwaKmhvjrVElVPJ99HYUbH4tUnA9rBlNzOlxGgZRFUXKxUeHsZXXY8pkzdHLV6kl/2
         +IauyV6+GfxpZ8gAL5QtBn88hnHHgCWJvAewZUUPpVG29DgJ7zaXIqMGCAW6GQfyoJar
         S920y945KrmfFNQshudZRErXvnRp889961NwCs1Zi3gdelLpJNRZLzQIZ8IGE9ZCSA77
         rZBg==
X-Gm-Message-State: APjAAAWowZmSHvk8uylPWRvSla3CEGwVStacIN3Y2ewAZJomUrOE9IxI
        bXlbH0Pnw6M7lL8bgJh7tUivPu9btBHekcoCOfV83IwalpJ2OKz7q0VTTo8dJaYeyIwU0fID8zQ
        387Rdjd9zgFnFaNAZ
X-Received: by 2002:a1c:5459:: with SMTP id p25mr4009082wmi.109.1572357070414;
        Tue, 29 Oct 2019 06:51:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzzBABeXGWvah4RWCBM8DqkxgMA5OepJvzaZk5Rv2Cr/nCiIuL4/tk/KZxjcx57+oPv9S+yrA==
X-Received: by 2002:a1c:5459:: with SMTP id p25mr4009050wmi.109.1572357070109;
        Tue, 29 Oct 2019 06:51:10 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 189sm2556920wmc.7.2019.10.29.06.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:51:09 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/4] flow_dissector: extract more ICMP information
Date:   Tue, 29 Oct 2019 14:50:52 +0100
Message-Id: <20191029135053.10055-4-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029135053.10055-1-mcroce@redhat.com>
References: <20191029135053.10055-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: aN6DRYU8MAqrZImbK9BdHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ICMP flow dissector currently parses only the Type and Code fields.
Some ICMP packets (echo, timestamp) have a 16 bit Identifier field which
is used to correlate packets.
Add such field in flow_dissector_key_icmp and replace skb_flow_get_be16()
with a more complex function which populate this field.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/net/flow_dissector.h | 19 +++++----
 net/core/flow_dissector.c    | 74 ++++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 7747af3cc500..f8541d018848 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -6,6 +6,8 @@
 #include <linux/in6.h>
 #include <uapi/linux/if_ether.h>
=20
+struct sk_buff;
+
 /**
  * struct flow_dissector_key_control:
  * @thoff: Transport header offset
@@ -156,19 +158,16 @@ struct flow_dissector_key_ports {
=20
 /**
  * flow_dissector_key_icmp:
- *=09@ports: type and code of ICMP header
- *=09=09icmp: ICMP type (high) and code (low)
  *=09=09type: ICMP type
  *=09=09code: ICMP code
+ *=09=09id:   session identifier
  */
 struct flow_dissector_key_icmp {
-=09union {
-=09=09__be16 icmp;
-=09=09struct {
-=09=09=09u8 type;
-=09=09=09u8 code;
-=09=09};
+=09struct {
+=09=09u8 type;
+=09=09u8 code;
 =09};
+=09u16 id;
 };
=20
 /**
@@ -282,6 +281,7 @@ struct flow_keys {
 =09struct flow_dissector_key_vlan cvlan;
 =09struct flow_dissector_key_keyid keyid;
 =09struct flow_dissector_key_ports ports;
+=09struct flow_dissector_key_icmp icmp;
 =09/* 'addrs' must be the last member */
 =09struct flow_dissector_key_addrs addrs;
 };
@@ -316,6 +316,9 @@ static inline bool flow_keys_have_l4(const struct flow_=
keys *keys)
 }
=20
 u32 flow_hash_from_keys(struct flow_keys *keys);
+void skb_flow_get_icmp_tci(const struct sk_buff *skb,
+=09=09=09   struct flow_dissector_key_icmp *key_icmp,
+=09=09=09   void *data, int thoff, int hlen);
=20
 static inline bool dissector_uses_key(const struct flow_dissector *flow_di=
ssector,
 =09=09=09=09      enum flow_dissector_key_id key_id)
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6443fac65ce8..0d014b81b269 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -147,27 +147,6 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf=
_attr *attr)
 =09mutex_unlock(&flow_dissector_mutex);
 =09return 0;
 }
-/**
- * skb_flow_get_be16 - extract be16 entity
- * @skb: sk_buff to extract from
- * @poff: offset to extract at
- * @data: raw buffer pointer to the packet
- * @hlen: packet header length
- *
- * The function will try to retrieve a be32 entity at
- * offset poff
- */
-static __be16 skb_flow_get_be16(const struct sk_buff *skb, int poff,
-=09=09=09=09void *data, int hlen)
-{
-=09__be16 *u, _u;
-
-=09u =3D __skb_header_pointer(skb, poff, sizeof(_u), data, hlen, &_u);
-=09if (u)
-=09=09return *u;
-
-=09return 0;
-}
=20
 /**
  * __skb_flow_get_ports - extract the upper layer ports and return them
@@ -203,8 +182,54 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb,=
 int thoff, u8 ip_proto,
 }
 EXPORT_SYMBOL(__skb_flow_get_ports);
=20
-/* If FLOW_DISSECTOR_KEY_ICMP is set, get the Type and Code from an ICMP p=
acket
- * using skb_flow_get_be16().
+static bool icmp_has_id(u8 type)
+{
+=09switch (type) {
+=09case ICMP_ECHO:
+=09case ICMP_ECHOREPLY:
+=09case ICMP_TIMESTAMP:
+=09case ICMP_TIMESTAMPREPLY:
+=09case ICMPV6_ECHO_REQUEST:
+=09case ICMPV6_ECHO_REPLY:
+=09=09return true;
+=09}
+
+=09return false;
+}
+
+/**
+ * skb_flow_get_icmp_tci - extract ICMP(6) Type, Code and Identifier field=
s
+ * @skb: sk_buff to extract from
+ * @key_icmp: struct flow_dissector_key_icmp to fill
+ * @data: raw buffer pointer to the packet
+ * @toff: offset to extract at
+ * @hlen: packet header length
+ */
+void skb_flow_get_icmp_tci(const struct sk_buff *skb,
+=09=09=09   struct flow_dissector_key_icmp *key_icmp,
+=09=09=09   void *data, int thoff, int hlen)
+{
+=09struct icmphdr *ih, _ih;
+
+=09ih =3D __skb_header_pointer(skb, thoff, sizeof(_ih), data, hlen, &_ih);
+=09if (!ih)
+=09=09return;
+
+=09key_icmp->type =3D ih->type;
+=09key_icmp->code =3D ih->code;
+
+=09/* As we use 0 to signal that the Id field is not present,
+=09 * avoid confusion with packets without such field
+=09 */
+=09if (icmp_has_id(ih->type))
+=09=09key_icmp->id =3D ih->un.echo.id ? : 1;
+=09else
+=09=09key_icmp->id =3D 0;
+}
+EXPORT_SYMBOL(skb_flow_get_icmp_tci);
+
+/* If FLOW_DISSECTOR_KEY_ICMP is set, dissect an ICMP packet
+ * using skb_flow_get_icmp_tci().
  */
 static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
 =09=09=09=09    struct flow_dissector *flow_dissector,
@@ -219,7 +244,8 @@ static void __skb_flow_dissect_icmp(const struct sk_buf=
f *skb,
 =09key_icmp =3D skb_flow_dissector_target(flow_dissector,
 =09=09=09=09=09     FLOW_DISSECTOR_KEY_ICMP,
 =09=09=09=09=09     target_container);
-=09key_icmp->icmp =3D skb_flow_get_be16(skb, thoff, data, hlen);
+
+=09skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
 }
=20
 void skb_flow_dissect_meta(const struct sk_buff *skb,
--=20
2.21.0

