Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972D3AC968
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhFRLGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:06:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232990AbhFRLGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624014281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GGf77+z4foP5zgaAzqu7BulkbwGCf2vt7+IfQ/uVejE=;
        b=fG8Il6+QUtrNH8Withtwzd1Z8GR2ucQWz5LDXepiQlu4W1BiC+vYtzrIDYjuNrTyH11bjM
        MC9fSukj+FLd6x6CGRIgnqaNJd2hb7NEnu9dSg5ROGZQT3hf6Zf1e+gWJ4Akqm99J/fOCd
        UNzG0TY9gG7A/Gz86tSq7Iy+elE/vTM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-txzWZ2W8NJWlzzlCrTmnLg-1; Fri, 18 Jun 2021 07:04:40 -0400
X-MC-Unique: txzWZ2W8NJWlzzlCrTmnLg-1
Received: by mail-ej1-f69.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so3766204ejc.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGf77+z4foP5zgaAzqu7BulkbwGCf2vt7+IfQ/uVejE=;
        b=b0uWJXxP+HImOaUwMf0NzewNQDuKBM+DJFNIBnt2zp/F4z9Ivfe4qC04zrpr+63hND
         Gq1FWDSqGrzhSj0dAvM6sNTTw3YPL8dz4CQWh+8md969+ulTHJLy/LZyVzgncKtUkucf
         NfUfSBQOHVxa4zxAf0yKYi6skwPmU6fj0/T1Bx9LlShcrNbv4ZXcl4y0CHsWGzopP4Eo
         0Q/faikQdZgoMrn+Qsm5hemaycvYy3623Zd8Vo+haD6c91lseffEA5/gsCIPwmwSyfth
         9TZvV0NhOlEOp0BuK6/AAko3aK4Wy3DfRvBt0XYgwS2ntaiuyKm/hin1pQL5l/9SENVN
         jNBA==
X-Gm-Message-State: AOAM533e2G4x8qH5Cg5RnCTwjCu6em1y5zF6Ch0vsoTzzn8l4F4dskaC
        8A4ttK3sYRKGXCXMclNyuH3wueChr1WHGG6kbmYpSkJo/2J3p7jrxTD3qTDwpycy5Wao4CJgxTq
        hhrGPNiJgziDXQKMD
X-Received: by 2002:a17:906:b2cb:: with SMTP id cf11mr10417597ejb.448.1624014279696;
        Fri, 18 Jun 2021 04:04:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCO9CiHrcP1613TX3dK+MQcImrL+YMS3eXD90LTrYbyFXyeb39bkLZhjjJh4R3JNAmngenOQ==
X-Received: by 2002:a17:906:b2cb:: with SMTP id cf11mr10417577ejb.448.1624014279500;
        Fri, 18 Jun 2021 04:04:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m17sm878062ejg.96.2021.06.18.04.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 04:04:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F232518071E; Fri, 18 Jun 2021 13:04:37 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
Subject: [PATCH net v2 1/2] icmp: don't send out ICMP messages with a source address of 0.0.0.0
Date:   Fri, 18 Jun 2021 13:04:35 +0200
Message-Id: <20210618110436.91700-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When constructing ICMP response messages, the kernel will try to pick a
suitable source address for the outgoing packet. However, if no IPv4
addresses are configured on the system at all, this will fail and we end up
producing an ICMP message with a source address of 0.0.0.0. This can happen
on a box routing IPv4 traffic via v6 nexthops, for instance.

Since 0.0.0.0 is not generally routable on the internet, there's a good
chance that such ICMP messages will never make it back to the sender of the
original packet that the ICMP message was sent in response to. This, in
turn, can create connectivity and PMTUd problems for senders. Fortunately,
RFC7600 reserves a dummy address to be used as a source for ICMP
messages (192.0.0.8/32), so let's teach the kernel to substitute that
address as a last resort if the regular source address selection procedure
fails.

Below is a quick example reproducing this issue with network namespaces:

ip netns add ns0
ip l add type veth peer netns ns0
ip l set dev veth0 up
ip a add 10.0.0.1/24 dev veth0
ip a add fc00:dead:cafe:42::1/64 dev veth0
ip r add 10.1.0.0/24 via inet6 fc00:dead:cafe:42::2
ip -n ns0 l set dev veth0 up
ip -n ns0 a add fc00:dead:cafe:42::2/64 dev veth0
ip -n ns0 r add 10.0.0.0/24 via inet6 fc00:dead:cafe:42::1
ip netns exec ns0 sysctl -w net.ipv4.icmp_ratelimit=0
ip netns exec ns0 sysctl -w net.ipv4.ip_forward=1
tcpdump -tpni veth0 -c 2 icmp &
ping -w 1 10.1.0.1 > /dev/null
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on veth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 29, seq 1, length 64
IP 0.0.0.0 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92
2 packets captured
2 packets received by filter
0 packets dropped by kernel

With this patch the above capture changes to:
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 31127, seq 1, length 64
IP 192.0.0.8 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Juliusz Chroboczek <jch@irif.fr>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/in.h | 3 +++
 net/ipv4/icmp.c         | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 7d6687618d80..d1b327036ae4 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -289,6 +289,9 @@ struct sockaddr_in {
 /* Address indicating an error return. */
 #define	INADDR_NONE		((unsigned long int) 0xffffffff)
 
+/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
+#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
+
 /* Network number for local host loopback. */
 #define	IN_LOOPBACKNET		127
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 7b6931a4d775..752e392083e6 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -759,6 +759,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		icmp_param.data_len = room;
 	icmp_param.head_len = sizeof(struct icmphdr);
 
+	/* if we don't have a source address at this point, fall back to the
+	 * dummy address instead of sending out a packet with a source address
+	 * of 0.0.0.0
+	 */
+	if (!fl4.saddr)
+		fl4.saddr = htonl(INADDR_DUMMY);
+
 	icmp_push_reply(&icmp_param, &fl4, &ipc, &rt);
 ende:
 	ip_rt_put(rt);
-- 
2.32.0

