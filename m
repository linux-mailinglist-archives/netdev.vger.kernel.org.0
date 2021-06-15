Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50A3A7CE6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFOLNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:13:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230503AbhFOLNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623755458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yfwZAQGhQdXwfX3oT2mUiJayaEQa98Eh2nRD6ZuGQbA=;
        b=PVnpK4iXawddO//OgeAUEvsmkw4+i7A6b4+rMAJzf+xRZXJFk/lVSf+lXzPNH3lClt+QRV
        TRggUQ3sUc7DGaadaW7BXvXmGP0cPu9TiSc9c6dl5qaRJbLvVMl1jLiXf7+0Sxx+YC/Nci
        w/jRw5WCR7y3EYF0Nf5VejLYbZ/mGiM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-zfGOg3tAMd2K9B98KwXIHg-1; Tue, 15 Jun 2021 07:10:57 -0400
X-MC-Unique: zfGOg3tAMd2K9B98KwXIHg-1
Received: by mail-ej1-f70.google.com with SMTP id n8-20020a1709067b48b02904171dc68f87so4333012ejo.21
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 04:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yfwZAQGhQdXwfX3oT2mUiJayaEQa98Eh2nRD6ZuGQbA=;
        b=pyzjSrQs6UOup5pFKooR2Wg/gc8GTUTl6qKoVDvlUcQ+JmD3eOFlC7xjrwWwebXZNh
         f2K4pGp0OWGf9J5rNd+vhK5MI47jwyRE/cig34yOAF2Zezirf2ptrWpBzPAfQik04nbZ
         jWexxBiDIibj875sOhzG5PM2S0uVYQxVmzismnP5p+N0scEeQts7gbqsq7p0MUM5LkXF
         7JKhZIW+LqpDgzRE++wWTut6SN2WBiojH7UQcWm9vip2AkjUpH4Lyoxj8q9UZg4YcMIm
         NCPTkp+snz9xQ1KeitLEQhXB6DQDMUfJv7/Tk9muZ8JpZ+b/7EhF6NdWYZWdyNtKzWAr
         Cvug==
X-Gm-Message-State: AOAM532ImyLKcZcYlvATH2GOk4PqMXFi8LuxKOG0Mmmx3yHFj54+n6QX
        1idoWGbfM5Vjz49m97PvTqE26EUpEJE3H56H96Wm9NZBPHzBO+yzcr9qe5iKPpzyQMBVbP1x1fW
        FBhSvd6oSyWH4mbY3
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr22633435edu.273.1623755455587;
        Tue, 15 Jun 2021 04:10:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx+GN5UoDMvpBsijA2qLMF16C6A2fBNACgijRUUB64pRziA/m7AfsQutXfG+ylJqZZ2NUvZQ==
X-Received: by 2002:a50:ff0a:: with SMTP id a10mr22633395edu.273.1623755455218;
        Tue, 15 Jun 2021 04:10:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s2sm7775884edt.53.2021.06.15.04.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 04:10:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD0731802FF; Tue, 15 Jun 2021 13:10:52 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
Subject: [PATCH net] icmp: don't send out ICMP messages with a source address of 0.0.0.0
Date:   Tue, 15 Jun 2021 13:07:09 +0200
Message-Id: <20210615110709.541499-1-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
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
2.31.1

