Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E493EC8DD
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 14:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbhHOMAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 08:00:52 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:39086 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhHOMAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 08:00:49 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1D27C40026;
        Sun, 15 Aug 2021 12:00:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb+/hjgZtH+APbkvLAiHRS+oj1j8Ik3lCNNcgbEGI1cP15zd02mFCVT2C7jNtYFDdWcAL4Wh+qXGNguxjwfBWuY2dpA5wlmeqnKuqNN2RNAeX1Xq23JhFwIv56xtiV8ArgyXqBZz7sDSPK42hxvpkzIwfi/me+RM4VZODk0QsKdpo4AETpzK0p/n00eZMaKgxsJXWXDzlL4HtCHxnFhjwzupmFfy8arUoD81XY9x7PfHLXRnJc3j2jEZJDi1VqdwOEloOpS8cWwzt/FIv432GTMcTCdB8Qa2/zwaKJ2iJ2nRd41JOddYBSG3aItyzJe1EKrDBulpHH2wCKi7ryZ8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gipR7LggjZJCiCPFWGloOth2qHhVNnw3yuqieB5bm+U=;
 b=QXIrKvsvbuf//zPmSisg/E5xvfau7cL3STa+oZhVSfBuNuyuh3TJ1ghQ4l1LW2LACt8TGDq3tq1Bz3qh301A2iNRvgsn1aV4Yqis3MFaby1LRfrYNLcP1nf0YIuYPNR1yXmBCNYX1AQu8D5Hx7DnFlKc4kKXGfAuZRaTfzzPnqsiJTV3FSlYYFmcydaQJJqn0GoVLj6B4rhzF9nwExFO9mR/VTKjoZ+wFBfTP5bCsfw7Kco0MCnbmVCMs1+0HgaW3Yur3jyhYIvU/dfuqgnZRb7MsTVSa6h5tVvkOa4tA4iZsXQGvm5TzRibCDncDt3uUAlN5/90mBI4TiaqtSfQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gipR7LggjZJCiCPFWGloOth2qHhVNnw3yuqieB5bm+U=;
 b=t+Wnf7Vi1XgDJRTznW5wvBMrOJLG/+yw2Q9a0G/4Rkv7ccvp+So+7M/US9OYO8OJt9guf5qL8ALWYgdJdZD+W4kU/VHYFg23rEZw63Oq7JaJ384m3dkHYzEt/h+7kTAbN/LHi5Vft1eWqwa6rNKSQmQFhm1cfXEeHvBIKwwPfNc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (20.177.58.151) by
 VI1PR0801MB1984.eurprd08.prod.outlook.com (10.173.74.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.17; Sun, 15 Aug 2021 12:00:14 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 12:00:14 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH] vrf: Reset skb conntrack connection on VRF rcv
Date:   Sun, 15 Aug 2021 12:00:02 +0000
Message-Id: <20210815120002.2787653-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0007.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::12) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.166.105.36) by MR1P264CA0007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sun, 15 Aug 2021 12:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f150a2e-8681-4394-c6a2-08d95fe43dbd
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1984:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB19843A1B6EAC7AB32B3F9808CCFC9@VI1PR0801MB1984.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:49;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SsOaVhOyiDBSmCAPRQqV9CsXFVFZewLDiwsdsx7SAMgNek2551tLsV3h9faYSF3ds+6v+gjv5JRjZTrZJoyw1HnQ0H2jHG5Uw/J6rW97zp/Up/iTZERDgXgBgMI9TOMNyHGjLkaBjFqEBi80Ogp0CUkiYtJu32p4wuySVb//qO5l62K8KhgXcLqHB1CqQFKRBGwt/m+4TXnVZxlwJglmoa1PC9QNnJWhlb2zASlCP3awxu2W5arH1HJk3ecWIjZKV4bvS3uGOIxL8J48vGe0quoGC5w2M+NM4cE64xfb24SxnNyU73/+xRTSCdpQSATX4brvmFAEWSEdO9Wmg7BMBclU9JcBA/MajopxSTWc5rIj4Dz0o2sshMNGDKef31BWOiuiCmqm7P6QsbcLDOhokxdaqloT6w76LfWWNJFAlXwtsTWfAWcXxNxZOxAZ2LwLqJIFR8zDnmeR76WmbohgLp+J1yertCb/cHSHhPiCSk8460RFFERdzy2UKzTCgTMZGtB9P0Y2Hak31Kmcyk99E5eN9R2D72zZo9gwUzOadZiAI9hHlAwEj6s1ARJdj1CMzxeXf1/7foEBTxsTv9BT23P4hguYgIi7GOB+PWEgQhhC06+jiT31w+ASJpXd+NGONJ8HJMAh/tHSCFbKwLgdFWKVrI/zy5in5c/6Xob41br9fP3OvdiBLLUVAjAnN4UObaufm5Vr3aLwV+8PVp+uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(366004)(376002)(396003)(478600001)(2616005)(956004)(6916009)(1076003)(6486002)(6512007)(186003)(6506007)(26005)(38100700002)(6666004)(66556008)(8936002)(8676002)(86362001)(52116002)(4326008)(316002)(83380400001)(5660300002)(2906002)(66476007)(38350700002)(36756003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wuRPNdw9lewEqUr1Ceq7Zvf81cQYOwqciVJRU+pmPIULocfkRvR0lgkduY59?=
 =?us-ascii?Q?V/Tr7rD2XkaQQMI0wEGq8UmecwO2iFmAofZqjeu+Lq7Y9mIUK51dRfpw7xpP?=
 =?us-ascii?Q?A3C+e41nAmhagFL1Ae/95KZrLHy6SgtGRpr2ilbMG3Vrh4Nu17cUuQo9VUlh?=
 =?us-ascii?Q?lnnB6Asi4e+psZrj8LFwZf7CmiiWGyWHuHl2B+iH/+Ieu9KH1Qby+B/IyRZj?=
 =?us-ascii?Q?PE35FmNqDBOL8W8UVi/wImmbR3JQkFah9uOIsjFGSGcjqJnjLB40arWOxAl9?=
 =?us-ascii?Q?GzCyIQ5+vYSJkxPExQuSDx/f7119LsU5L2N4wK2kHblqzA4sJFnI9bCi6V3l?=
 =?us-ascii?Q?Lk/ZPtbJcRKV4+5CpE8zKjz8WADKVAq2SDJ4qdnFvVKUCAs+5JxpHwDWh4co?=
 =?us-ascii?Q?Y6fi3m9wzIu/Ou0w9f9Iay9RLBZnXf6XNjVuPHHA0LA9ChY893ozLJIbB7Dr?=
 =?us-ascii?Q?puPGynahJkgDPklY2ZQVJm2CcvbzFxy+b+D6Jog2AeGWs/DKuondvXsjac6H?=
 =?us-ascii?Q?zG0+n1PH/eU63KM22HkVwLB0DHM0xH8+cJ2uwVIdJYwpIwsRKuSV6tjewRm0?=
 =?us-ascii?Q?LXi5NyLubHx7LPt3FaVbUxlFMheGmfgHRl8pSIV18euUmPCKJrqxkBlGMUef?=
 =?us-ascii?Q?yMqjGXKZ/KQztWIf4e5NfQUwu7wQKtBf1PqYhDiOH4xyyRHrAhtB9M7ZguvO?=
 =?us-ascii?Q?zDIClswTN02MULpTNfuYdQ95+QsXfjUGiJKrY4MD34E1zFqDwwaB2ElJ4kve?=
 =?us-ascii?Q?DIk73SYps0SAsE37ypIhRBdw+ejxL0o+jqbrXAmxQT4gFylNr4lx46NNWEC4?=
 =?us-ascii?Q?UTJYAXr5O+PWldIi0Z7CWZnclICClJrSSzwhjDeO5J4544rKHS6Mau1a+xDF?=
 =?us-ascii?Q?zqGNgRhdZ38zwPPedI456mPeAHaLmfteNEYb0CJY1HHCJFC9bLTQQAgEG2Ob?=
 =?us-ascii?Q?1YwJ61X8WvgqebooGe2JslgNO3aEBMBSaLFo1+6+vn9LtmA9U4YgIpYK4J5k?=
 =?us-ascii?Q?vnVWpS/46u1PUWJtDkVM4wukQTXZ60tY+afiJOW5zKyURdtD2+g5buBdmaHb?=
 =?us-ascii?Q?tsN5hhEHuS1V0AYtn8A570j38KakwXmWXBkSIcTF+i5cAP9qzgDDgBUL0ruJ?=
 =?us-ascii?Q?R7AdCIMiGwnIwQitYkGbg8kS1oLR1RTKBnGNVinwYACD4D1T28IwJ9llvZ3k?=
 =?us-ascii?Q?YW3yPztfS5GGFQ28JZdZ1qBvcdCbUpdVHBBmvMXqzisogS9ntHtSuiFcl2eO?=
 =?us-ascii?Q?44ue5jNALDi1GNTS2bqlNHYoBPmw35d5WoUUyRC4fVpymjIuUectAQ+xyeUl?=
 =?us-ascii?Q?MidfYt4+uFldHGcjhBuBSpUf?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f150a2e-8681-4394-c6a2-08d95fe43dbd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 12:00:14.5193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVd8CMkrAyiYhWNmERtXTLRpczfGmV6Fofo8ggb3RBudJrSxP0LoW7cCbWEIJS8U7eotLjpA86IP79z0I1nRcvrNmXK0tLmvhosNTffEpMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1984
X-MDID: 1629028818-DQmVdF0Nk6Eh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix the "reverse-NAT" for replies.

When a packet is sent over a VRF, the POST_ROUTING hooks are called
twice: Once from the VRF interface, and once from the "actual"
interface the packet will be sent from:
1) First SNAT: l3mdev_l3_out() -> vrf_l3_out() -> .. -> vrf_output_direct()
     This causes the POST_ROUTING hooks to run.
2) Second SNAT: 'ip_output()' calls POST_ROUTING hooks again.

Similarly for replies, first ip_rcv() calls PRE_ROUTING hooks, and
second vrf_l3_rcv() calls them again.

As an example, consider the following SNAT rule:
> iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j SNAT --to-source 2.2.2.2 -o vrf_1

In this case sending over a VRF will create 2 conntrack entries.
The first is from the VRF interface, which performs the IP SNAT.
The second will run the SNAT, but since the "expected reply" will remain
the same, conntrack randomizes the source port of the packet:
e..g With a socket bound to 1.1.1.1:10000, sending to 3.3.3.3:53, the conntrack
rules are:
udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=0 bytes=0 mark=0 use=1
udp      17 29 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1

i.e. First SNAT IP from 1.1.1.1 --> 2.2.2.2, and second the src port is
SNAT-ed from 10000 --> 61033.

But when a reply is sent (3.3.3.3:53 -> 2.2.2.2:61033) only the later
conntrack entry is matched:
udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=1 bytes=49 mark=0 use=1
udp      17 28 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1

And a "port 61033 unreachable" ICMP packet is sent back.

The issue is that when PRE_ROUTING hooks are called from vrf_l3_rcv(),
the skb already has a conntrack flow attached to it, which means
nf_conntrack_in() will not resolve the flow again.

This means only the dest port is "reverse-NATed" (61033 -> 10000) but
the dest IP remains 2.2.2.2, and since the socket is bound to 1.1.1.1 it's
not received.
This can be verified by logging the 4-tuple of the packet in '__udp4_lib_rcv()'.

The fix is then to reset the flow when skb is received on a VRF, to let
conntrack resolve the flow again (which now will hit the earlier flow).

To reproduce: (Without the fix "Got pkt_to_nat_port" will not be printed by
  running 'bash ./repro'):
  $ cat run_in_A1.py
  import logging
  logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
  from scapy.all import *
  import argparse

  def get_packet_to_send(udp_dst_port, msg_name):
      return Ether(src='11:22:33:44:55:66', dst=iface_mac)/ \
          IP(src='3.3.3.3', dst='2.2.2.2')/ \
          UDP(sport=53, dport=udp_dst_port)/ \
          Raw(f'{msg_name}\x0012345678901234567890')

  parser = argparse.ArgumentParser()
  parser.add_argument('-iface_mac', dest="iface_mac", type=str, required=True,
                      help="From run_in_A3.py")
  parser.add_argument('-socket_port', dest="socket_port", type=str,
                      required=True, help="From run_in_A3.py")
  parser.add_argument('-v1_mac', dest="v1_mac", type=str, required=True,
                      help="From script")

  args, _ = parser.parse_known_args()
  iface_mac = args.iface_mac
  socket_port = int(args.socket_port)
  v1_mac = args.v1_mac

  print(f'Source port before NAT: {socket_port}')

  while True:
      pkts = sniff(iface='_v0', store=True, count=1, timeout=10)
      if 0 == len(pkts):
          print('Something failed, rerun the script :(', flush=True)
          break
      pkt = pkts[0]
      if not pkt.haslayer('UDP'):
          continue

      pkt_sport = pkt.getlayer('UDP').sport
      print(f'Source port after NAT: {pkt_sport}', flush=True)

      pkt_to_send = get_packet_to_send(pkt_sport, 'pkt_to_nat_port')
      sendp(pkt_to_send, '_v0', verbose=False) # Will not be received

      pkt_to_send = get_packet_to_send(socket_port, 'pkt_to_socket_port')
      sendp(pkt_to_send, '_v0', verbose=False)
      break

  $ cat run_in_A2.py
  import socket
  import netifaces

  print(f"{netifaces.ifaddresses('e00000')[netifaces.AF_LINK][0]['addr']}",
        flush=True)
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE,
               str('vrf_1' + '\0').encode('utf-8'))
  s.connect(('3.3.3.3', 53))
  print(f'{s. getsockname()[1]}', flush=True)
  s.settimeout(5)

  while True:
      try:
          # Periodically send in order to keep the conntrack entry alive.
          s.send(b'a'*40)
          resp = s.recvfrom(1024)
          msg_name = resp[0].decode('utf-8').split('\0')[0]
          print(f"Got {msg_name}", flush=True)
      except Exception as e:
          pass

  $ cat repro.sh
  ip netns del A1 2> /dev/null
  ip netns del A2 2> /dev/null
  ip netns add A1
  ip netns add A2

  ip -n A1 link add _v0 type veth peer name _v1 netns A2
  ip -n A1 link set _v0 up

  ip -n A2 link add e00000 type bond
  ip -n A2 link add lo0 type dummy
  ip -n A2 link add vrf_1 type vrf table 10001
  ip -n A2 link set vrf_1 up
  ip -n A2 link set e00000 master vrf_1

  ip -n A2 addr add 1.1.1.1/24 dev e00000
  ip -n A2 link set e00000 up
  ip -n A2 link set _v1 master e00000
  ip -n A2 link set _v1 up
  ip -n A2 link set lo0 up
  ip -n A2 addr add 2.2.2.2/32 dev lo0

  ip -n A2 neigh add 1.1.1.10 lladdr 77:77:77:77:77:77 dev e00000
  ip -n A2 route add 3.3.3.3/32 via 1.1.1.10 dev e00000 table 10001

  ip netns exec A2 iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j \
	SNAT --to-source 2.2.2.2 -o vrf_1

  sleep 5
  ip netns exec A2 python3 run_in_A2.py > x &
  XPID=$!
  sleep 5

  IFACE_MAC=`sed -n 1p x`
  SOCKET_PORT=`sed -n 2p x`
  V1_MAC=`ip -n A2 link show _v1 | sed -n 2p | awk '{print $2'}`
  ip netns exec A1 python3 run_in_A1.py -iface_mac ${IFACE_MAC} -socket_port \
          ${SOCKET_PORT} -v1_mac ${SOCKET_PORT}
  sleep 5

  kill -9 $XPID
  wait $XPID 2> /dev/null
  ip netns del A1
  ip netns del A2
  tail x -n 2
  rm x
  set +x

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
 drivers/net/vrf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 2b1b944d4b28..8bbe2a7bb141 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1367,6 +1367,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
+	nf_reset_ct(skb);
+
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1429,6 +1431,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
+	nf_reset_ct(skb);
+
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 
-- 
2.25.1

