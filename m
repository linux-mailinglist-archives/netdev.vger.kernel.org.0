Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE33EDCD4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhHPSIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhHPSIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 14:08:35 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B109C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:08:03 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id u13-20020a9d4d8d0000b02905177c9e0a4aso11400700otk.3
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=teYtrqn7dj/BovsL10kIVHBSad5wlD0happgIhmtv04=;
        b=m1TugD7Dde+hruHQxa4bfShaBu3EBeu/xKTBbg5MJ2myCxEqKyuGUoDS37EIqTpLb3
         wllWzXboutPHNh7vXbwxiiUwavUT/QRpeblWCVTtKfyhAaZ3dIiK9HVhtZqiNk5CmMqV
         fQRA7ywBeSGmKJJpk4BvcDug8EB/9lkjwZkVFzPgQpeoHZM4cQ+oWTJc1KucnNrqtxH9
         Js30g8HXf6ggDcPgOBwZ3F0ALJK3yCG4T1mjKsWi0XLjb62SRtWJQ2rLJn7dK1Os9hcZ
         BesxYl4LUUtcWSP4HfE/aB0p/wyQEvCGxZpgGrzM/l3nrgUD2iQmzZVhgd7FC7fy5j6f
         eccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=teYtrqn7dj/BovsL10kIVHBSad5wlD0happgIhmtv04=;
        b=r0lHlXZedE2rMTLxvT8EQsVXVtTCwAZLi+DW/jFtR5nHQXwSSEWNKdKLqjKc3NDo++
         TBLi/ejXVz2497NPLpFMi1IYlH0p/AXw2DmD/EKzHMpgyblKq4qpc+UNhASLyXkEJqFo
         rQ1O2FZwi6sJVIU8vKONJptOzkHSuvJ7YbCC8VVSys1CZtPtsaeIT0w1NXbrdxUSt7Xo
         WEogWhByfOjwzpKgwUbPrCpar1NLHQde2HIvzyIYU193vrPhHSQ3TX0PSlVKjrpm5IHT
         OlhI0l62JwXig5m3dB1aXHixlvb2+ljEO5v5U5AVcjC3Z2Bnx3QkUaKSfIjy1IyF627F
         lhiA==
X-Gm-Message-State: AOAM531hhATidaE+ZSaQ2Zdq2ZKKWQF+5rCkvk/jSvuzIDL9Ran6KILq
        q/8+sP9sUbkN1msaxUoSU/c=
X-Google-Smtp-Source: ABdhPJyT1lkXaSkRWg0faYC5aw8onhkj/NFQB1Kyn3omyWQrEs+mpocuTFlTDI/IiBT/WNwZpQSwtA==
X-Received: by 2002:a05:6830:1f54:: with SMTP id u20mr10685oth.320.1629137283014;
        Mon, 16 Aug 2021 11:08:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id u185sm25480oig.34.2021.08.16.11.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 11:08:02 -0700 (PDT)
Subject: Re: [PATCH] vrf: Reset skb conntrack connection on VRF rcv
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210815120002.2787653-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d38916e3-c6d7-d5f4-4815-8877efc50a2a@gmail.com>
Date:   Mon, 16 Aug 2021 12:08:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210815120002.2787653-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/21 6:00 AM, Lahav Schlesinger wrote:
> To fix the "reverse-NAT" for replies.
> 
> When a packet is sent over a VRF, the POST_ROUTING hooks are called
> twice: Once from the VRF interface, and once from the "actual"
> interface the packet will be sent from:
> 1) First SNAT: l3mdev_l3_out() -> vrf_l3_out() -> .. -> vrf_output_direct()
>      This causes the POST_ROUTING hooks to run.
> 2) Second SNAT: 'ip_output()' calls POST_ROUTING hooks again.
> 
> Similarly for replies, first ip_rcv() calls PRE_ROUTING hooks, and
> second vrf_l3_rcv() calls them again.
> 
> As an example, consider the following SNAT rule:
>> iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j SNAT --to-source 2.2.2.2 -o vrf_1
> 
> In this case sending over a VRF will create 2 conntrack entries.
> The first is from the VRF interface, which performs the IP SNAT.
> The second will run the SNAT, but since the "expected reply" will remain
> the same, conntrack randomizes the source port of the packet:
> e..g With a socket bound to 1.1.1.1:10000, sending to 3.3.3.3:53, the conntrack
> rules are:
> udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=0 bytes=0 mark=0 use=1
> udp      17 29 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1
> 
> i.e. First SNAT IP from 1.1.1.1 --> 2.2.2.2, and second the src port is
> SNAT-ed from 10000 --> 61033.
> 
> But when a reply is sent (3.3.3.3:53 -> 2.2.2.2:61033) only the later
> conntrack entry is matched:
> udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=1 bytes=49 mark=0 use=1
> udp      17 28 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1
> 
> And a "port 61033 unreachable" ICMP packet is sent back.
> 
> The issue is that when PRE_ROUTING hooks are called from vrf_l3_rcv(),
> the skb already has a conntrack flow attached to it, which means
> nf_conntrack_in() will not resolve the flow again.
> 
> This means only the dest port is "reverse-NATed" (61033 -> 10000) but
> the dest IP remains 2.2.2.2, and since the socket is bound to 1.1.1.1 it's
> not received.
> This can be verified by logging the 4-tuple of the packet in '__udp4_lib_rcv()'.
> 
> The fix is then to reset the flow when skb is received on a VRF, to let
> conntrack resolve the flow again (which now will hit the earlier flow).
> 
> To reproduce: (Without the fix "Got pkt_to_nat_port" will not be printed by
>   running 'bash ./repro'):
>   $ cat run_in_A1.py
>   import logging
>   logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
>   from scapy.all import *
>   import argparse
> 
>   def get_packet_to_send(udp_dst_port, msg_name):
>       return Ether(src='11:22:33:44:55:66', dst=iface_mac)/ \
>           IP(src='3.3.3.3', dst='2.2.2.2')/ \
>           UDP(sport=53, dport=udp_dst_port)/ \
>           Raw(f'{msg_name}\x0012345678901234567890')
> 
>   parser = argparse.ArgumentParser()
>   parser.add_argument('-iface_mac', dest="iface_mac", type=str, required=True,
>                       help="From run_in_A3.py")
>   parser.add_argument('-socket_port', dest="socket_port", type=str,
>                       required=True, help="From run_in_A3.py")
>   parser.add_argument('-v1_mac', dest="v1_mac", type=str, required=True,
>                       help="From script")
> 
>   args, _ = parser.parse_known_args()
>   iface_mac = args.iface_mac
>   socket_port = int(args.socket_port)
>   v1_mac = args.v1_mac
> 
>   print(f'Source port before NAT: {socket_port}')
> 
>   while True:
>       pkts = sniff(iface='_v0', store=True, count=1, timeout=10)
>       if 0 == len(pkts):
>           print('Something failed, rerun the script :(', flush=True)
>           break
>       pkt = pkts[0]
>       if not pkt.haslayer('UDP'):
>           continue
> 
>       pkt_sport = pkt.getlayer('UDP').sport
>       print(f'Source port after NAT: {pkt_sport}', flush=True)
> 
>       pkt_to_send = get_packet_to_send(pkt_sport, 'pkt_to_nat_port')
>       sendp(pkt_to_send, '_v0', verbose=False) # Will not be received
> 
>       pkt_to_send = get_packet_to_send(socket_port, 'pkt_to_socket_port')
>       sendp(pkt_to_send, '_v0', verbose=False)
>       break
> 
>   $ cat run_in_A2.py
>   import socket
>   import netifaces
> 
>   print(f"{netifaces.ifaddresses('e00000')[netifaces.AF_LINK][0]['addr']}",
>         flush=True)
>   s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
>   s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE,
>                str('vrf_1' + '\0').encode('utf-8'))
>   s.connect(('3.3.3.3', 53))
>   print(f'{s. getsockname()[1]}', flush=True)
>   s.settimeout(5)
> 
>   while True:
>       try:
>           # Periodically send in order to keep the conntrack entry alive.
>           s.send(b'a'*40)
>           resp = s.recvfrom(1024)
>           msg_name = resp[0].decode('utf-8').split('\0')[0]
>           print(f"Got {msg_name}", flush=True)
>       except Exception as e:
>           pass
> 
>   $ cat repro.sh
>   ip netns del A1 2> /dev/null
>   ip netns del A2 2> /dev/null
>   ip netns add A1
>   ip netns add A2
> 
>   ip -n A1 link add _v0 type veth peer name _v1 netns A2
>   ip -n A1 link set _v0 up
> 
>   ip -n A2 link add e00000 type bond
>   ip -n A2 link add lo0 type dummy
>   ip -n A2 link add vrf_1 type vrf table 10001
>   ip -n A2 link set vrf_1 up
>   ip -n A2 link set e00000 master vrf_1
> 
>   ip -n A2 addr add 1.1.1.1/24 dev e00000
>   ip -n A2 link set e00000 up
>   ip -n A2 link set _v1 master e00000
>   ip -n A2 link set _v1 up
>   ip -n A2 link set lo0 up
>   ip -n A2 addr add 2.2.2.2/32 dev lo0
> 
>   ip -n A2 neigh add 1.1.1.10 lladdr 77:77:77:77:77:77 dev e00000
>   ip -n A2 route add 3.3.3.3/32 via 1.1.1.10 dev e00000 table 10001
> 
>   ip netns exec A2 iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j \
> 	SNAT --to-source 2.2.2.2 -o vrf_1
> 
>   sleep 5
>   ip netns exec A2 python3 run_in_A2.py > x &
>   XPID=$!
>   sleep 5
> 
>   IFACE_MAC=`sed -n 1p x`
>   SOCKET_PORT=`sed -n 2p x`
>   V1_MAC=`ip -n A2 link show _v1 | sed -n 2p | awk '{print $2'}`
>   ip netns exec A1 python3 run_in_A1.py -iface_mac ${IFACE_MAC} -socket_port \
>           ${SOCKET_PORT} -v1_mac ${SOCKET_PORT}
>   sleep 5
> 
>   kill -9 $XPID
>   wait $XPID 2> /dev/null
>   ip netns del A1
>   ip netns del A2
>   tail x -n 2
>   rm x
>   set +x
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
>  drivers/net/vrf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Thanks for the detailed explanation and use case.

Looks correct to me.
Reviewed-by: David Ahern <dsahern@kernel.org>



