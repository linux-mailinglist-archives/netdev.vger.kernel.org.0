Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612BBE89FA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389048AbfJ2NvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:51:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388802AbfJ2NvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0QBgHuOvRpTy/yL3LM7SM8CMC4Q19dnHgWxMUVqqv8=;
        b=hzqfoOYBCrA+8Lp0bq5OgOq1FhJw2xraui97bSTFGLwdV7OJWeWtboWgqyjmAcUYp9M4/f
        7oqjkhCuqbAvfK297cBpXIfn+My+zDcXmxuMYp3dOe7A3AJ8ElJ9vxQxOl2GvhjWcw0ITB
        YN4J0jc+oHJUtTMgKFQiPoIaoaCGkAQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-OllKlYiONbKn_ovuTqWcBQ-1; Tue, 29 Oct 2019 09:51:14 -0400
Received: by mail-wr1-f69.google.com with SMTP id h4so8433800wrx.15
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pci9O/Y1uGzGl4VbZQrWCqVtKu7mWU+rWUzr+zqpUus=;
        b=fwUIm6RpA1rzYr24j9yHtupvPxxvU1H9tPo+OSEap8ttYIjhBTjTwM0k4iCUVj8yRi
         8Vm5TywaAt1iZHk72PMRTJMYnh0v/Q9ULUsCdzA75jWeZhWIxoQ4G0MMfC+mMePHlD9X
         NrKvevnmK6rWcqAxwj5XGPscyk89WRxm4L3UKeld4Yf1x/O7TcNi13Rxjd5hPf2s0MD5
         YEYlBcCDyp4dd5DmgSmExoZ1TmNKiEuwoKPPo/IbIIxdMX2Rczwlc+YYuPQ2ntdqK7dN
         t4pnrmMSwfWTOyWeBAAvWn2i1GXFXKCixSGCRXiQbFG7uZLerTOV8nsad1XbL6slVBrn
         STNQ==
X-Gm-Message-State: APjAAAWqCMPt5fxJR1HsAyF63oilmSxEU9eoOVbNrfkTxV7rtvABIm6E
        Q47MsPPamZmNpdL1MHgjQwaxeBVgNlyt8ufjvL4J718Xddd5I1BX478yMqJa7VFqKgGUPtKmYEj
        dQFo6L10bGT5hSm6S
X-Received: by 2002:adf:fc10:: with SMTP id i16mr19093180wrr.157.1572357072803;
        Tue, 29 Oct 2019 06:51:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxG5wt0T0t9KCOCTG4DWyEMa2fhof6y77Xio3y/jp2lKJcEoqrdOFiVxJqSgiyOI0edNNmXKA==
X-Received: by 2002:adf:fc10:: with SMTP id i16mr19093157wrr.157.1572357072538;
        Tue, 29 Oct 2019 06:51:12 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 189sm2556920wmc.7.2019.10.29.06.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:51:11 -0700 (PDT)
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
Subject: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4 mode
Date:   Tue, 29 Oct 2019 14:50:53 +0100
Message-Id: <20191029135053.10055-5-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029135053.10055-1-mcroce@redhat.com>
References: <20191029135053.10055-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: OllKlYiONbKn_ovuTqWcBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bonding uses the L4 ports to balance flows between slaves. As the ICMP
protocol has no ports, those packets are sent all to the same device:

    # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
    # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
    # ping -qc1 192.168.0.2
    1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, leng=
th 64
    1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, length=
 64
    # ping -qc1 192.168.0.2
    1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, leng=
th 64
    1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, length=
 64
    # ping -qc1 192.168.0.2
    1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, leng=
th 64
    1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, length=
 64

But some ICMP packets have an Identifier field which is
used to match packets within sessions, let's use this value in the hash
function to balance these packets between bond slaves:

    # ping -qc1 192.168.0.2
    0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, leng=
th 64
    0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, length=
 64
    # ping -qc1 192.168.0.2
    1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, leng=
th 64
    1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, length=
 64

Aso, let's use a flow_dissector_key which defines FLOW_DISSECTOR_KEY_ICMP,
so we can balance pings encapsulated in a tunnel when using mode encap3+4:

    # ping -q 192.168.1.2 -c1
    0: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 19=
2.168.1.2: ICMP echo request, id 585, seq 1, length 64
    0: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 19=
2.168.1.1: ICMP echo reply, id 585, seq 1, length 64
    # ping -q 192.168.1.2 -c1
    1: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 19=
2.168.1.2: ICMP echo request, id 586, seq 1, length 64
    1: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 19=
2.168.1.1: ICMP echo reply, id 586, seq 1, length 64

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/bonding/bond_main.c | 77 ++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 21d8fcc83c9c..3e496e746cc6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -200,6 +200,51 @@ atomic_t netpoll_block_tx =3D ATOMIC_INIT(0);
=20
 unsigned int bond_net_id __read_mostly;
=20
+static const struct flow_dissector_key flow_keys_bonding_keys[] =3D {
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_CONTROL,
+=09=09.offset =3D offsetof(struct flow_keys, control),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_BASIC,
+=09=09.offset =3D offsetof(struct flow_keys, basic),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_IPV4_ADDRS,
+=09=09.offset =3D offsetof(struct flow_keys, addrs.v4addrs),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_IPV6_ADDRS,
+=09=09.offset =3D offsetof(struct flow_keys, addrs.v6addrs),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_TIPC,
+=09=09.offset =3D offsetof(struct flow_keys, addrs.tipckey),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_PORTS,
+=09=09.offset =3D offsetof(struct flow_keys, ports),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_ICMP,
+=09=09.offset =3D offsetof(struct flow_keys, icmp),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_VLAN,
+=09=09.offset =3D offsetof(struct flow_keys, vlan),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_FLOW_LABEL,
+=09=09.offset =3D offsetof(struct flow_keys, tags),
+=09},
+=09{
+=09=09.key_id =3D FLOW_DISSECTOR_KEY_GRE_KEYID,
+=09=09.offset =3D offsetof(struct flow_keys, keyid),
+=09},
+};
+
+static struct flow_dissector flow_keys_bonding __read_mostly;
+
 /*-------------------------- Forward declarations ------------------------=
---*/
=20
 static int bond_init(struct net_device *bond_dev);
@@ -3263,10 +3308,14 @@ static bool bond_flow_dissect(struct bonding *bond,=
 struct sk_buff *skb,
 =09const struct iphdr *iph;
 =09int noff, proto =3D -1;
=20
-=09if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23)
-=09=09return skb_flow_dissect_flow_keys(skb, fk, 0);
+=09if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23) {
+=09=09memset(fk, 0, sizeof(*fk));
+=09=09return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
+=09=09=09=09=09  fk, NULL, 0, 0, 0, 0);
+=09}
=20
 =09fk->ports.ports =3D 0;
+=09memset(&fk->icmp, 0, sizeof(fk->icmp));
 =09noff =3D skb_network_offset(skb);
 =09if (skb->protocol =3D=3D htons(ETH_P_IP)) {
 =09=09if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
@@ -3286,8 +3335,14 @@ static bool bond_flow_dissect(struct bonding *bond, =
struct sk_buff *skb,
 =09} else {
 =09=09return false;
 =09}
-=09if (bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_LAYER34 && proto >=
=3D 0)
-=09=09fk->ports.ports =3D skb_flow_get_ports(skb, noff, proto);
+=09if (bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_LAYER34 && proto >=
=3D 0) {
+=09=09if (proto =3D=3D IPPROTO_ICMP || proto =3D=3D IPPROTO_ICMPV6)
+=09=09=09skb_flow_get_icmp_tci(skb, &fk->icmp, skb->data,
+=09=09=09=09=09      skb_transport_offset(skb),
+=09=09=09=09=09      skb_headlen(skb));
+=09=09else
+=09=09=09fk->ports.ports =3D skb_flow_get_ports(skb, noff, proto);
+=09}
=20
 =09return true;
 }
@@ -3314,10 +3369,14 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_=
buff *skb)
 =09=09return bond_eth_hash(skb);
=20
 =09if (bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_LAYER23 ||
-=09    bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_ENCAP23)
+=09    bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_ENCAP23) {
 =09=09hash =3D bond_eth_hash(skb);
-=09else
-=09=09hash =3D (__force u32)flow.ports.ports;
+=09} else {
+=09=09if (flow.icmp.id)
+=09=09=09memcpy(&hash, &flow.icmp, sizeof(hash));
+=09=09else
+=09=09=09memcpy(&hash, &flow.ports.ports, sizeof(hash));
+=09}
 =09hash ^=3D (__force u32)flow_get_u32_dst(&flow) ^
 =09=09(__force u32)flow_get_u32_src(&flow);
 =09hash ^=3D (hash >> 16);
@@ -4901,6 +4960,10 @@ static int __init bonding_init(void)
 =09=09=09goto err;
 =09}
=20
+=09skb_flow_dissector_init(&flow_keys_bonding,
+=09=09=09=09flow_keys_bonding_keys,
+=09=09=09=09ARRAY_SIZE(flow_keys_bonding_keys));
+
 =09register_netdevice_notifier(&bond_netdev_notifier);
 out:
 =09return res;
--=20
2.21.0

