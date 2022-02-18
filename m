Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D464BB95F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiBRMoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:44:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiBRMoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:44:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0A528BF6E
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:43:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bg10so14795158ejb.4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZN0sjZDVvTVCR/ZyZiF43+LIYMdkQ26kp1e3swUdD4=;
        b=poOBtkvPYoTYaFiiVEXVCNJiiT0TiXjc6bOOecltAuinbxEQ//Nhvqkc28FUcQyXbv
         ZXz+YNMUEpxjadZc5SjjCm12lP/rxsrQ65A29z7RvW17wg2Vh0TH7/fIxfISa39W9kZh
         AKq9EJEPW9sfRlva8lbpg3m+zzoXh6LTOmEqSGEbkib4tkbteC7BeBdKscb87FSemIN3
         DJmMuJSpVoCV8Nh4kCIz5zoIBt4Dj++m2uHJj1yF58pOgD/S++RPn8gB5YlqfJPA4YOP
         DGbbdj6vpZv1JnuUXaF3YAT+ozxscyX1+CwcutmkL6q0pdsEk/MvuMI3UKApjrl61/pR
         nWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZN0sjZDVvTVCR/ZyZiF43+LIYMdkQ26kp1e3swUdD4=;
        b=mhAleNzLEvVkMzYKmYbjkT3/aiVZ7hTkxmDkYDO/GTmIwk7C8fzZFQuUk8CfLAsfk+
         mwV6cHfLs5y2AUVOAJaxMwG0KX6CNy9vnHRsa5IH1SpsD0VJ6kQWRFEymVWvR9RkiXLJ
         nMCWXqsV2uzPXWNa1yE3YVpD/c56y+wkto3ViRyvbRivhUPjeoh/0DsFIfu80LhQG5/0
         iXB06F/mCYYvn9NG8Jt+61JvtKmf608zeDrQaIsjhIHxj7T7JBHX24Ld/6FLZeiqZJWu
         xbd02tmoQZPmB7Zk/bZ3BRGSduPskDhOkviFGoBNgX5wBoEO44obxCMGruPQel0Jl0HY
         ZOVQ==
X-Gm-Message-State: AOAM5311OVonWTA8OGZHhX7a+VgThBTI0fRJMbYYmsAt0F1NP6Vm9dnD
        /Cxf9xvgciGV+ixmYSLrCxrsQmKuyFqNGekbriY=
X-Google-Smtp-Source: ABdhPJxOedMPDqy8yEdGEHbx/uB+tUwzqdx+EZAMymvnv6d6wGGNvZn6KXu2hPpAftK+jzNPGZltASqxD5eDMtwjS6E=
X-Received: by 2002:a17:906:260a:b0:6b3:345d:35d5 with SMTP id
 h10-20020a170906260a00b006b3345d35d5mr6314111ejc.96.1645188221727; Fri, 18
 Feb 2022 04:43:41 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
 <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com>
 <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com> <CAMDZJNXbxstEvFoF=ZRD_PwH6HQc17LEn0tSvFTJvKB9aoW6Aw@mail.gmail.com>
 <7a6b7a74-82f5-53e7-07f4-2a995df9f349@mojatatu.com>
In-Reply-To: <7a6b7a74-82f5-53e7-07f4-2a995df9f349@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 18 Feb 2022 20:43:05 +0800
Message-ID: <CAMDZJNUB8KwjgGOdn1iuJLHMwL4VfmfKEfvK69WCaoAmubDt3g@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 7:39 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-02-16 08:36, Tonghao Zhang wrote:
> > On Wed, Feb 16, 2022 at 8:17 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>
> [...]
> The mapping to hardware made sense. Sorry I missed it earlier.
>
> >> Can you paste a more complete example of a sample setup on some egress
> >> port including what the classifier would be looking at?
> > Hi
> >
> >    +----+      +----+      +----+     +----+
> >    | P1 |      | P2 |      | PN |     | PM |
> >    +----+      +----+      +----+     +----+
> >      |           |           |           |
> >      +-----------+-----------+-----------+
> >                         |
> >                         | clsact/skbedit
> >                         |      MQ
> >                         v
> >      +-----------+-----------+-----------+
> >      | q0        | q1        | qn        | qm
> >      v           v           v           v
> >    HTB/FQ      HTB/FQ  ...  FIFO        FIFO
> >
>
> Below is still missing your MQ setup (If i understood your diagram
> correctly). Can you please post that?
> Are you classids essentially mapping to q0..m?
> tc -s class show after you run some traffic should help
Hi Jamal

The setup commands is shown as below:
NETDEV=eth0
ip li set dev $NETDEV up
tc qdisc del dev $NETDEV clsact 2>/dev/null
tc qdisc add dev $NETDEV clsact

ip link add ipv1 link $NETDEV type ipvlan mode l2
ip netns add n1
ip link set ipv1 netns n1

ip netns exec n1 ip link set ipv1 up
ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up

tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
src_ip 2.2.2.100 action skbedit queue_mapping hash-type skbhash 2 6

tc qdisc add dev $NETDEV handle 1: root mq

tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit

tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
tc qdisc add dev $NETDEV parent 1:3 pfifo
tc qdisc add dev $NETDEV parent 1:4 pfifo
tc qdisc add dev $NETDEV parent 1:5 pfifo
tc qdisc add dev $NETDEV parent 1:6 pfifo
tc qdisc add dev $NETDEV parent 1:7 pfifo


use the perf to generate packets:
ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 10 -P 10

we use the skbedit to select tx queue from 2 - 6
# ethtool -S eth0 | grep -i [tr]x_queue_[0-9]_bytes
     rx_queue_0_bytes: 442
     rx_queue_1_bytes: 60966
     rx_queue_2_bytes: 10440203
     rx_queue_3_bytes: 6083863
     rx_queue_4_bytes: 3809726
     rx_queue_5_bytes: 3581460
     rx_queue_6_bytes: 5772099
     rx_queue_7_bytes: 148
     rx_queue_8_bytes: 368
     rx_queue_9_bytes: 383
     tx_queue_0_bytes: 42
     tx_queue_1_bytes: 0
     tx_queue_2_bytes: 11442586444
     tx_queue_3_bytes: 7383615334
     tx_queue_4_bytes: 3981365579
     tx_queue_5_bytes: 3983235051
     tx_queue_6_bytes: 6706236461
     tx_queue_7_bytes: 42
     tx_queue_8_bytes: 0
     tx_queue_9_bytes: 0

tx queues 2-6 are mapping to classid 1:3 - 1:7
# tc -s class show dev eth0
class mq 1:1 root leaf 2:
 Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:2 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:3 root leaf 8002:
 Sent 11949133672 bytes 7929798 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:4 root leaf 8003:
 Sent 7710449050 bytes 5117279 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:5 root leaf 8004:
 Sent 4157648675 bytes 2758990 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:6 root leaf 8005:
 Sent 4159632195 bytes 2759990 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:7 root leaf 8006:
 Sent 7003169603 bytes 4646912 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:8 root
 Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:9 root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:a root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class tbf 8001:1 parent 8001:

class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 2000000 ctokens: 2000000

class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 1000000 ctokens: 1000000

> > NETDEV=eth0
> > tc qdisc add dev $NETDEV clsact
> > tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> > src_ip 192.168.122.100 action skbedit queue_mapping hash-type skbhash
> > n m
> >
>
> Have you observed a nice distribution here?
Yes, as shown above
> for s/w side tc -s class show after you run some traffic should help
> for h/w side ethtool -s
>
> IIUC, the hash of the ip header with src_ip 192.168.122.100
> (and dst ip,
> is being distributed across queues n..m
> [because either 192.168.122.100 is talking to many destination
> IPs and/or ports?]
yes, we use the iperf3 -P options to send out multi flows.
> Is this correct if packets are being forwarded as opposed to
> being sourced from the host?
Good question, for TCP, we set the ixgbe ntuple off.
ethtool -K ixgbe-dev ntuple off
so in the underlying driver, hw will record this flow, and its tx
queue, when it comes back to pod.
hw will send to rx queue corresponding to tx queue.

the codes:
ixgbe_xmit_frame/ixgbe_xmit_frame_ring -->ixgbe_atr() ->
ixgbe_fdir_add_signature_filter_82599
ixgbe_fdir_add_signature_filter_82599 will install the rule for
incoming packets.

> ex: who sets the skb->hash (skb->l4_hash, skb->sw_hash etc)
for tcp:
__tcp_transmit_skb -> skb_set_hash_from_sk

for udp
udp_sendmsg -> ip_make_skb -> __ip_append_data -> sock_alloc_send_pskb
-> skb_set_owner_w

> > The packets from pod(P1) which ip is 192.168.122.100, will use the txqueue n ~m.
> > P1 is the pod of latency sensitive traffic. so P1 use the fifo qdisc.
> >
> > tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> > src_ip 192.168.122.200 action skbedit queue_mapping hash-type skbhash
> > 0 1
> >
> > The packets from pod(P2) which ip is 192.168.122.200, will use the txqueue 0 ~1.
> > P2 is the pod of bulk sensitive traffic. so P2 use the htb qdisc to
> > limit its network rate, because we don't hope P2 use all bandwidth to
> > affect P1.
> >
>
> Understood.
>
> >> Your diagram was unclear how the load balancing was going to be
> >> achieved using the qdiscs (or was it the hardware?).
> > Firstly, in clsact hook, we select one tx queue from qn to qm for P1,
> > and use the qdisc of this tx queue, for example FIFO.
> > in underlay driver, because the we set the skb->queue_mapping in
> > skbedit, so the hw tx queue from qn to qm will be select too.
> > any way, in clsact hook, we can use the skbedit queue_mapping to
> > select software tx queue and hw tx queue.
> >
>
> ethtool -s and tc -s class if you have this running somewhere..
>
> > For doing balance, we can use the skbhash/cpuid/cgroup classid to
> > select tx queue from qn to qm for P1.
> > tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> > src_ip 192.168.122.100 action skbedit queue_mapping hash-type cpuid n
> > m
> > tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> > src_ip 192.168.122.100 action skbedit queue_mapping hash-type classid
> > n m
> >
>
> The skbhash should work fine if you have good entropy (varying dst ip
> and dst port mostly, the srcip/srcport/protocol dont offer much  entropy
> unless you have a lot of pods on your system).
> i.e if it works correctly (forwarding vs host - see my question above)
> then you should be able to pin a 5tuple flow to a tx queue.
> If you have a large number of flows/pods then you could potentially
> get a nice distribution.
>
> I may be missing something on the cpuid one - seems high likelihood
> of having the same flow on multiple queues (based on what
> raw_smp_processor_id() returns, which i believe is not guaranteed to be
> consistent). IOW, you could be sending packets out of order for the
> same 5 tuple flow (because they end up in different queues).
Yes, but think about one case, we pin one pod to one cpu, so all the
processes of the pod will
use the same cpu. then all packets from this pod will use the same tx queue.
> As for classid variant - if these packets are already outside the
> pod and into the host stack, is that field even valid?
Yes, ipvlan, macvlan and other virt netdev don't clean this field.
> > Why we want to do the balance, because we don't want pin the packets
> > from Pod to one tx queue. (in k8s the pods are created or destroy
> > frequently, and the number of Pods > tx queue number).
> > sharing the tx queue equally is more important.
> >
>
> As long as the same flow is pinned to the same queue (see my comment
> on cpuid).
> Over a very long period what you describe maybe true but it also
> seems depends on many other variables.
NETDEV=eth0

ip li set dev $NETDEV up

tc qdisc del dev $NETDEV clsact 2>/dev/null
tc qdisc add dev $NETDEV clsact

ip link add ipv1 link $NETDEV type ipvlan mode l2
ip netns add n1
ip link set ipv1 netns n1

ip netns exec n1 ip link set ipv1 up
ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up

tc filter add dev $NETDEV egress protocol ip prio 1 \
flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type cpuid 2 6

tc qdisc add dev $NETDEV handle 1: root mq

tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit

tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
tc qdisc add dev $NETDEV parent 1:3 pfifo
tc qdisc add dev $NETDEV parent 1:4 pfifo
tc qdisc add dev $NETDEV parent 1:5 pfifo
tc qdisc add dev $NETDEV parent 1:6 pfifo
tc qdisc add dev $NETDEV parent 1:7 pfifo

set the iperf3 to one cpu
# mkdir -p /sys/fs/cgroup/cpuset/n0
# echo 4 > /sys/fs/cgroup/cpuset/n0/cpuset.cpus
# echo 0 > /sys/fs/cgroup/cpuset/n0/cpuset.mems
# ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 1000 -P 10 -u -b 10G
# echo $(pidof iperf3) > /sys/fs/cgroup/cpuset/n0/tasks

# ethtool -S eth0 | grep -i tx_queue_[0-9]_bytes
     tx_queue_0_bytes: 7180
     tx_queue_1_bytes: 418
     tx_queue_2_bytes: 3015
     tx_queue_3_bytes: 4824
     tx_queue_4_bytes: 3738
     tx_queue_5_bytes: 716102781 # before setting iperf3 to cpu 4
     tx_queue_6_bytes: 17989642640 # after setting iperf3 to cpu 4,
skbedit use this tx queue, and don't use tx queue 5
     tx_queue_7_bytes: 4364
     tx_queue_8_bytes: 42
     tx_queue_9_bytes: 3030


# tc -s class show dev eth0
class mq 1:1 root leaf 2:
 Sent 9874 bytes 63 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:2 root leaf 8001:
 Sent 418 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:3 root leaf 8002:
 Sent 3015 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:4 root leaf 8003:
 Sent 4824 bytes 8 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:5 root leaf 8004:
 Sent 4074 bytes 19 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:6 root leaf 8005:
 Sent 716102781 bytes 480624 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:7 root leaf 8006:
 Sent 18157071781 bytes 12186100 pkt (dropped 0, overlimits 0 requeues 18)
 backlog 0b 0p requeues 18
class mq 1:8 root
 Sent 4364 bytes 26 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:9 root
 Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:a root
 Sent 3030 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class tbf 8001:1 parent 8001:

class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 2000000 ctokens: 2000000

class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 lended: 0 borrowed: 0 giants: 0
 tokens: 1000000 ctokens: 1000000

> I think it would help to actually show some data on how true above
> statement is (example the creation/destruction rate of the pods).
> Or collect data over a very long period.
>
> cheers,
> jamal



-- 
Best regards, Tonghao
