Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85322C19EC
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgKXAX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgKXAXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 19:23:55 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C679C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 16:23:55 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id 11so518399qvq.11
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 16:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=vZwCDN1zCnakE42em9XgVbqOrUIOClbDJje64A8OO5s=;
        b=garsXjq1t1yHrHo+qBFRPWVF13aR27eoor0A6mOMY3n2CUUerDg/34UE7WHeYRN84B
         09UpA6NE4IXiMlYX3KVBP6sPzvSAwV06SdGSFHrgGe0IG9t+r1J5PDN4gm3ov0Vk3l2r
         N3hivx6fz91WNmGo2Nmnr20TJc08ui0lBLAOeOOSmTXl0ew1XqVWt3HpaOrCfNThBU33
         X6pkhmmowQJ5eMy3b1fR1G+zYVBZZs9xGY1+6FdxyqLRw3toGuw0xLhNXyRr0HcTWj+a
         V0VqdfoBe8CcZhj5X3IA7RHi0rrXrSmtoSU9APwV5BLMSRtS4N8rSp/GwcjVeDPEucoG
         hw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=vZwCDN1zCnakE42em9XgVbqOrUIOClbDJje64A8OO5s=;
        b=ZWsGTkZa1OJO9Z5AEHaWf/kFDy6T8U84GoN4Y6jSg1ItVi9/fAPnbBl+32t3b7Pgqy
         JokkcPN4ESnLAcW4Rv3VDEUji9T3xK94o+PTEavs9OOga1sVcxT9SL+NidtinsIDrp4l
         9hSmzlve6ZvAhnC1IAT+dGzeDkxu+SqBT7ZvvpmdV+zJBZYJkvp5LnM1ippeno4h7pCI
         SVmo4YtZdNEYzLyWs6ro5V1Vibfa6ssIOBOZtz++hODdf5h2BiU7kV9+0d2MrTXAPnGu
         tFe1c4nkcNvH/TNT51odF12/rMjpTNEF//229wbgNi0uc43u4kPgse2LoG/d3Ir6YXlR
         b5Vg==
X-Gm-Message-State: AOAM532CjG5EVPY0eHzL27ihbo7Sy+dagY0AUUBmWJuY6IhEyHPfun1e
        FHrXfqja3O29QPoPIQ+s7B4rC7wvVA==
X-Google-Smtp-Source: ABdhPJx80979Aiwn5MXgX56A7GoIc4QYLrB4Qz2rjeDPnkcU1JBmpc0MatGA3zWtUsZIH03GWaWMsw==
X-Received: by 2002:a0c:b34a:: with SMTP id a10mr2266163qvf.15.1606177433919;
        Mon, 23 Nov 2020 16:23:53 -0800 (PST)
Received: from ubuntu ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id b4sm11051972qtt.52.2020.11.23.16.23.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 16:23:53 -0800 (PST)
Date:   Mon, 23 Nov 2020 19:23:45 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Subject: VRF NS for lladdr sent on the wrong interface
Message-ID: <20201124002345.GA42222@ubuntu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm running into a problem with lladdr pinging all-host mcast all nodes
addr. The ping intially works but after cycling the interface that
receives the ping, the echo request packet causes a neigh solicitation
being sent on a different interface.

To repro, I included the attached namespace scripts. This is the
topology and an output of my test.

# +-------+     +----------+   +-------+
# | h0    |     |    r0    |   |    h1 |
# |    v00+-----+v00    v01+---+v10    |
# |       |     |          |   |       |
# +-------+     +----------+   +-------+

Setup and list of addresses:

$ sudo sh ./setup.sh
$ sudo ip netns exec h0 ip addr show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
28: h0_v00@if27: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b2:72:0a:25:7d:0f brd ff:ff:ff:ff:ff:ff link-netns r0
    inet6 fe80::b072:aff:fe25:7d0f/64 scope link 
       valid_lft forever preferred_lft forever
$ sudo ip netns exec r0 ip addr show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: vrf_r0: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP group default qlen 1000
    link/ether 5a:48:08:1e:e6:38 brd ff:ff:ff:ff:ff:ff
    inet 127.0.0.1/8 scope host vrf_r0
       valid_lft forever preferred_lft forever
27: r0_v00@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vrf_r0 state UP group default qlen 1000
    link/ether aa:9d:a5:cf:ab:75 brd ff:ff:ff:ff:ff:ff link-netns h0
    inet6 fe80::a89d:a5ff:fecf:ab75/64 scope link 
       valid_lft forever preferred_lft forever
30: r0_v01@if29: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vrf_r0 state UP group default qlen 1000
    link/ether 52:0f:70:b5:a8:6a brd ff:ff:ff:ff:ff:ff link-netns h1
    inet6 fe80::500f:70ff:feb5:a86a/64 scope link 
       valid_lft forever preferred_lft forever
$ sudo ip netns exec h1 ip addr show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
29: h1_v10@if30: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:3c:c1:a0:07:7c brd ff:ff:ff:ff:ff:ff link-netns r0
    inet6 fe80::a83c:c1ff:fea0:77c/64 scope link 
       valid_lft forever preferred_lft forever

Initially ping is replied by r0_v00:

$ sudo ip netns exec h0 ping -c 1 ff02::1%h0_v00
PING ff02::1%h0_v00(ff02::1%h0_v00) 56 data bytes
64 bytes from fe80::a89d:a5ff:fecf:ab75%h0_v00: icmp_seq=1 ttl=64 time=4.44 ms

--- ff02::1%h0_v00 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 4.443/4.443/4.443/0.000 ms

Cycle r0_v00. Ping isn't replied and the tcpdump shows that the NS for h0_v00 lladdr
is sent over r0_v01:

$ sudo ip netns exec r0 ip link set r0_v00 down
$ sudo ip netns exec r0 ip link set r0_v00 up
$ sudo ip netns exec r0 ip addr show dev r0_v00
27: r0_v00@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vrf_r0 state UP group default qlen 1000
    link/ether aa:9d:a5:cf:ab:75 brd ff:ff:ff:ff:ff:ff link-netns h0
    inet6 fe80::a89d:a5ff:fecf:ab75/64 scope link 
       valid_lft forever preferred_lft forever

$ sudo ip netns exec h0 ping -c 1 ff02::1%h0_v00
PING ff02::1%h0_v00(ff02::1%h0_v00) 56 data bytes

--- ff02::1%h0_v00 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

$ sudo ip netns exec h1 tcpdump -i h1_v10
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on h1_v10, link-type EN10MB (Ethernet), capture size 262144 bytes
^C12:36:12.210524 IP6 fe80::a83c:c1ff:fea0:77c > ip6-allrouters: ICMP6, router solicitation, length 16
12:36:34.456650 IP6 fe80::500f:70ff:feb5:a86a > ff02::1:ff25:7d0f: ICMP6, neighbor solicitation, who has fe80::b072:aff:fe25:7d0f, length 32
12:36:35.474519 IP6 fe80::500f:70ff:feb5:a86a > ff02::1:ff25:7d0f: ICMP6, neighbor solicitation, who has fe80::b072:aff:fe25:7d0f, length 32
12:36:36.498455 IP6 fe80::500f:70ff:feb5:a86a > ff02::1:ff25:7d0f: ICMP6, neighbor solicitation, who has fe80::b072:aff:fe25:7d0f, length 32

4 packets captured
4 packets received by filter
0 packets dropped by kernel

I'm thinking that the following patch is needed:

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f2793ffde191..30f4e867fe5b 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1315,11 +1315,14 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	int orig_iif = skb->skb_iif;
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
+	bool is_ll_src;
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
+	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
+	if (skb->pkt_type == PACKET_LOOPBACK ||
+	    (need_strict && !is_ndisc && !is_ll_src)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;

But wanting to probe first to see if I could have missed something. Or
is there a better patch. I would be happy to follow up with a formal patch.

Thank you,

Stephen.

--9zSXsLTf0vkW971A
Content-Type: application/x-sh
Content-Disposition: attachment; filename="setup.sh"
Content-Transfer-Encoding: quoted-printable

# +-------+     +----------+   +-------+=0A# | h0    |     |    r0    |   |=
    h1 |=0A# |    v00+-----+v00    v01+---+v10    |=0A# |       |     |    =
      |   |       |=0A# +-------+     +----------+   +-------+=0A=0Aip netn=
s add h0=0Aip netns add r0=0Aip netns add h1=0A=0Aip link add h0_v00 type v=
eth peer name r0_v00=0Aip link set h0_v00 netns h0=0Aip link set r0_v00 net=
ns r0=0Aip link add r0_v01 type veth peer name h1_v10=0Aip link set r0_v01 =
netns r0=0Aip link set h1_v10 netns h1=0A=0Aip netns exec r0 ip link add vr=
f_r0 type vrf table 10=0Aip netns exec r0 ip addr add 127.0.0.1/8 dev vrf_r=
0=0Aip netns exec r0 ip link set vrf_r0 up=0A=0Aip netns exec r0 ip link se=
t dev r0_v00 master vrf_r0=0Aip netns exec r0 ip link set dev r0_v01 master=
 vrf_r0=0A=0Aip netns exec h0 ip link set dev h0_v00 up=0Aip netns exec r0 =
ip link set dev r0_v00 up=0Aip netns exec r0 ip link set dev r0_v01 up=0Aip=
 netns exec h1 ip link set dev h1_v10 up=0A
--9zSXsLTf0vkW971A
Content-Type: application/x-sh
Content-Disposition: attachment; filename="teardown.sh"
Content-Transfer-Encoding: quoted-printable

ip netns exec h0 ip link delete h0_v00=0Aip netns exec h1 ip link delete h1=
_v10=0A=0Aip netns exec r0 ip link delete vrf_r0=0A=0Aip netns delete h0=0A=
ip netns delete r0=0Aip netns delete h1=0A
--9zSXsLTf0vkW971A--
