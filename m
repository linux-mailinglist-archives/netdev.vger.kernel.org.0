Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC484BD333
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 02:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245321AbiBUBoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 20:44:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242679AbiBUBoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 20:44:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFE7517D0
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 17:43:38 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id vz16so29179136ejb.0
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 17:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=441C71uaUvnarfJjmTRK0mKY1C7lev4zXzJwo6ce+mg=;
        b=mNAbWy5YOo9xWUD3FgHmK5TJmkkBm8ILvjdR2K/F0X378yNirv6jX1gWVwNvwMDxqd
         nOjOV1KR1/DiMpWW5RnTE3t2mc8r5xYquuExwkuak+vuR7PUok3yC6krLJMfQa8s8J7q
         V+pn7WcJwVv2kvBdN2g0Mk+7jLRSud3ISkeMFy4ODDVQJMpI5aF/SYn80ZwmVWhKdpR7
         wD4z8py2yd+vBbv4D5GCVj11yPo4ady75HrfgdhhV1h8/xzgMtv6JclOIpW7e4R6Gjt9
         tTa/rLCsT4B07Emtma5ufVumsXPDd+6WI7Qm24FhmJegfWI3EvZgoMZDkdXBNgZc9NA2
         Hrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=441C71uaUvnarfJjmTRK0mKY1C7lev4zXzJwo6ce+mg=;
        b=aMmzkdSDmqrq0OOLajjuocCv/wUwf8Q4u/IoppGJICji21PdGuQyFcunZLAbKA4faM
         I8GMkux7vUS/sHDw68lkIqafQuhgWYqFj5DwsSoQzqxRzEiZY5b+HK0exQLcvBRqDQP3
         /5Sia8g9vGQW7rNbFZ2/aXV5XRUYvSR318xW+BMyKjgOAsJ7VxA83S/6C74r1pWW8Crl
         0jXYT9RJEXcMnT6JEeCfXYQK29j/wnlkRMFVMEHUDm4oYFcPb5b8sRFebfwDKzyt7c60
         Vy6CT2rk7gPUHrAX70oyIGjUP2xOQrrUdJbfHUSorzPfLU/ni0YJuQ93uaXr2JblbOe2
         HjnA==
X-Gm-Message-State: AOAM532JxmWvlHXUjgRPXgM64yzQCK68QeUwbgy4mfoVfgIsSa4VWlZE
        7xYgVvxHo6/GWhnr6lO0X4cDTpDRDHGUsBNE8lU=
X-Google-Smtp-Source: ABdhPJzHYyQie4vEu0D6gZNvKM+pbi4Ysk9gCS+c8Uv66Z5J7cfOCfB1Q0BOnww+wwR5VQowHlWenWcrQqAfujCy+Zs=
X-Received: by 2002:a17:906:4b11:b0:6d1:ba2:5bdb with SMTP id
 y17-20020a1709064b1100b006d10ba25bdbmr6282716eju.61.1645407817277; Sun, 20
 Feb 2022 17:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
 <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com>
 <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com> <CAMDZJNXbxstEvFoF=ZRD_PwH6HQc17LEn0tSvFTJvKB9aoW6Aw@mail.gmail.com>
 <7a6b7a74-82f5-53e7-07f4-2a995df9f349@mojatatu.com> <CAMDZJNUB8KwjgGOdn1iuJLHMwL4VfmfKEfvK69WCaoAmubDt3g@mail.gmail.com>
 <bc0affeb-1d2e-3e1f-bc3f-43fc47736674@mojatatu.com>
In-Reply-To: <bc0affeb-1d2e-3e1f-bc3f-43fc47736674@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 21 Feb 2022 09:43:00 +0800
Message-ID: <CAMDZJNW3zV07h3_u1g7rFX+uaB11smjVv1zqZKHj9n4YzctBmA@mail.gmail.com>
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

On Mon, Feb 21, 2022 at 2:30 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-02-18 07:43, Tonghao Zhang wrote:
> > On Thu, Feb 17, 2022 at 7:39 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >>
>
> > Hi Jamal
> >
> > The setup commands is shown as below:
> > NETDEV=eth0
> > ip li set dev $NETDEV up
> > tc qdisc del dev $NETDEV clsact 2>/dev/null
> > tc qdisc add dev $NETDEV clsact
> >
> > ip link add ipv1 link $NETDEV type ipvlan mode l2
> > ip netns add n1
> > ip link set ipv1 netns n1
> >
> > ip netns exec n1 ip link set ipv1 up
> > ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
> >
> > tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
> > src_ip 2.2.2.100 action skbedit queue_mapping hash-type skbhash 2 6
> >
> > tc qdisc add dev $NETDEV handle 1: root mq
> >
> > tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
> > tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
> > tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
> >
> > tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
> > tc qdisc add dev $NETDEV parent 1:3 pfifo
> > tc qdisc add dev $NETDEV parent 1:4 pfifo
> > tc qdisc add dev $NETDEV parent 1:5 pfifo
> > tc qdisc add dev $NETDEV parent 1:6 pfifo
> > tc qdisc add dev $NETDEV parent 1:7 pfifo
> >
> >
> > use the perf to generate packets:
> > ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 10 -P 10
> >
> > we use the skbedit to select tx queue from 2 - 6
> > # ethtool -S eth0 | grep -i [tr]x_queue_[0-9]_bytes
> >       rx_queue_0_bytes: 442
> >       rx_queue_1_bytes: 60966
> >       rx_queue_2_bytes: 10440203
> >       rx_queue_3_bytes: 6083863
> >       rx_queue_4_bytes: 3809726
> >       rx_queue_5_bytes: 3581460
> >       rx_queue_6_bytes: 5772099
> >       rx_queue_7_bytes: 148
> >       rx_queue_8_bytes: 368
> >       rx_queue_9_bytes: 383
> >       tx_queue_0_bytes: 42
> >       tx_queue_1_bytes: 0
> >       tx_queue_2_bytes: 11442586444
> >       tx_queue_3_bytes: 7383615334
> >       tx_queue_4_bytes: 3981365579
> >       tx_queue_5_bytes: 3983235051
> >       tx_queue_6_bytes: 6706236461
> >       tx_queue_7_bytes: 42
> >       tx_queue_8_bytes: 0
> >       tx_queue_9_bytes: 0
> >
> > tx queues 2-6 are mapping to classid 1:3 - 1:7
> > # tc -s class show dev eth0
> > class mq 1:1 root leaf 2:
> >   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:2 root leaf 8001:
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:3 root leaf 8002:
> >   Sent 11949133672 bytes 7929798 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:4 root leaf 8003:
> >   Sent 7710449050 bytes 5117279 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:5 root leaf 8004:
> >   Sent 4157648675 bytes 2758990 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:6 root leaf 8005:
> >   Sent 4159632195 bytes 2759990 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:7 root leaf 8006:
> >   Sent 7003169603 bytes 4646912 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:8 root
> >   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:9 root
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:a root
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class tbf 8001:1 parent 8001:
> >
> > class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> >   lended: 0 borrowed: 0 giants: 0
> >   tokens: 2000000 ctokens: 2000000
> >
> > class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> >   lended: 0 borrowed: 0 giants: 0
> >   tokens: 1000000 ctokens: 1000000
> >
>
> Yes, this is a good example (which should have been in the commit
> message of 0/2 or 2/2 - would have avoided long discussion).
I will add this example to commit 2/2 in next version.
> The byte count doesnt map correctly between the DMA side and the
> qdisc side; you probably had some additional experiments running
> prior to installing the mq qdisc.
Yes, for tx queue index, it start from 0, for mq qdisc class, the
index start from 1
> So not a big deal - it is close enough.
>
> To Cong's comments earlier - I dont think you can correctly have
> picked the queue in user space for this specific policy (hash-type
> skbhash). Reason is you are dependent on the skb hash computation
> which is based on things like ephemeral src port for the netperf
> client - which cannot be determined in user space.
>
> > Good question, for TCP, we set the ixgbe ntuple off.
> > ethtool -K ixgbe-dev ntuple off
> > so in the underlying driver, hw will record this flow, and its tx
> > queue, when it comes back to pod.
> > hw will send to rx queue corresponding to tx queue.
> >
> > the codes:
> > ixgbe_xmit_frame/ixgbe_xmit_frame_ring -->ixgbe_atr() ->
> > ixgbe_fdir_add_signature_filter_82599
> > ixgbe_fdir_add_signature_filter_82599 will install the rule for
> > incoming packets.
> >
> >> ex: who sets the skb->hash (skb->l4_hash, skb->sw_hash etc)
> > for tcp:
> > __tcp_transmit_skb -> skb_set_hash_from_sk
> >
> > for udp
> > udp_sendmsg -> ip_make_skb -> __ip_append_data -> sock_alloc_send_pskb
> > -> skb_set_owner_w
>
> Thats a different use case than what you are presenting here.
> i.e the k8s pod scenario is purely a forwarding use case.
> But it doesnt matter tbh since your data shows reasonable results.
>
> [i didnt dig into the code but it is likely (based on your experimental
> data) that both skb->l4_hash and skb->sw_hash  will _not be set_
> and so skb_get_hash() will compute the skb->hash from scratch.]
No, for example, for tcp, we have set hash in __tcp_transmit_skb which
invokes the skb_set_hash_from_sk
so in skbedit, skb_get_hash only gets skb->hash.
> >> I may be missing something on the cpuid one - seems high likelihood
> >> of having the same flow on multiple queues (based on what
> >> raw_smp_processor_id() returns, which i believe is not guaranteed to be
> >> consistent). IOW, you could be sending packets out of order for the
> >> same 5 tuple flow (because they end up in different queues).
> > Yes, but think about one case, we pin one pod to one cpu, so all the
> > processes of the pod will
> > use the same cpu. then all packets from this pod will use the same tx queue.
>
> To Cong's point - if you already knew the pinned-to cpuid then you could
> just as easily set that queue map from user space?
Yes, we can set it from user space. If we can know the cpu which the
pod uses, and select the one tx queue
automatically in skbedit, that can make the things easy?
> >> As for classid variant - if these packets are already outside th
> >> pod and into the host stack, is that field even valid?
> > Yes, ipvlan, macvlan and other virt netdev don't clean this field.
> >>> Why we want to do the balance, because we don't want pin the packets
> >>> from Pod to one tx queue. (in k8s the pods are created or destroy
> >>> frequently, and the number of Pods > tx queue number).
> >>> sharing the tx queue equally is more important.
> >>>
> >>
> >> As long as the same flow is pinned to the same queue (see my comment
> >> on cpuid).
> >> Over a very long period what you describe maybe true but it also
> >> seems depends on many other variables.
> > NETDEV=eth0
> >
> > ip li set dev $NETDEV up
> >
> > tc qdisc del dev $NETDEV clsact 2>/dev/null
> > tc qdisc add dev $NETDEV clsact
> >
> > ip link add ipv1 link $NETDEV type ipvlan mode l2
> > ip netns add n1
> > ip link set ipv1 netns n1
> >
> > ip netns exec n1 ip link set ipv1 up
> > ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
> >
> > tc filter add dev $NETDEV egress protocol ip prio 1 \
> > flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type cpuid 2 6
> >
> > tc qdisc add dev $NETDEV handle 1: root mq
> >
> > tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
> > tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
> > tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
> >
> > tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latency 1
> > tc qdisc add dev $NETDEV parent 1:3 pfifo
> > tc qdisc add dev $NETDEV parent 1:4 pfifo
> > tc qdisc add dev $NETDEV parent 1:5 pfifo
> > tc qdisc add dev $NETDEV parent 1:6 pfifo
> > tc qdisc add dev $NETDEV parent 1:7 pfifo
> >
> > set the iperf3 to one cpu
> > # mkdir -p /sys/fs/cgroup/cpuset/n0
> > # echo 4 > /sys/fs/cgroup/cpuset/n0/cpuset.cpus
> > # echo 0 > /sys/fs/cgroup/cpuset/n0/cpuset.mems
> > # ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 1000 -P 10 -u -b 10G
> > # echo $(pidof iperf3) > /sys/fs/cgroup/cpuset/n0/tasks
> >
> > # ethtool -S eth0 | grep -i tx_queue_[0-9]_bytes
> >       tx_queue_0_bytes: 7180
> >       tx_queue_1_bytes: 418
> >       tx_queue_2_bytes: 3015
> >       tx_queue_3_bytes: 4824
> >       tx_queue_4_bytes: 3738
> >       tx_queue_5_bytes: 716102781 # before setting iperf3 to cpu 4
> >       tx_queue_6_bytes: 17989642640 # after setting iperf3 to cpu 4,
> > skbedit use this tx queue, and don't use tx queue 5
> >       tx_queue_7_bytes: 4364
> >       tx_queue_8_bytes: 42
> >       tx_queue_9_bytes: 3030
> >
> >
> > # tc -s class show dev eth0
> > class mq 1:1 root leaf 2:
> >   Sent 9874 bytes 63 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:2 root leaf 8001:
> >   Sent 418 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:3 root leaf 8002:
> >   Sent 3015 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:4 root leaf 8003:
> >   Sent 4824 bytes 8 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:5 root leaf 8004:
> >   Sent 4074 bytes 19 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:6 root leaf 8005:
> >   Sent 716102781 bytes 480624 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:7 root leaf 8006:
> >   Sent 18157071781 bytes 12186100 pkt (dropped 0, overlimits 0 requeues 18)
> >   backlog 0b 0p requeues 18
> > class mq 1:8 root
> >   Sent 4364 bytes 26 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:9 root
> >   Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class mq 1:a root
> >   Sent 3030 bytes 13 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> > class tbf 8001:1 parent 8001:
> >
> > class htb 2:1 root prio 0 rate 100Kbit ceil 100Kbit burst 1600b cburst 1600b
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> >   lended: 0 borrowed: 0 giants: 0
> >   tokens: 2000000 ctokens: 2000000
> >
> > class htb 2:2 root prio 0 rate 200Kbit ceil 200Kbit burst 1600b cburst 1600b
> >   Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >   backlog 0b 0p requeues 0
> >   lended: 0 borrowed: 0 giants: 0
> >   tokens: 1000000 ctokens: 1000000
> >
>
> Yes, if you pin a flow/process to a cpu - this is expected. See my
> earlier comment. You could argue that you are automating things but
> it is not as a strong as the hash setup (and will have to be documented
> that it works only if you pin processes doing network i/o to cpus).
Ok, it should be documented in iproute2. and we will doc this in
commit message too.
> Could you also post an example on the cgroups classid?

The setup commands:
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
flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping hash-type
classid 2 6

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

setup classid
# mkdir -p /sys/fs/cgroup/net_cls/n0
# echo 0x100001 > /sys/fs/cgroup/net_cls/n0/net_cls.classid
# echo $(pidof iperf3) > /sys/fs/cgroup/net_cls/n0/tasks

# ethtool -S eth0 | grep -i tx_queue_[0-9]_bytes
     tx_queue_0_bytes: 9660
     tx_queue_1_bytes: 0
     tx_queue_2_bytes: 102434986698 #  don't set the iperf to cgroup n0
     tx_queue_3_bytes: 2964
     tx_queue_4_bytes: 75041373396 # after we set the iperf to cgroup n0
     tx_queue_5_bytes: 13458
     tx_queue_6_bytes: 1252
     tx_queue_7_bytes: 522
     tx_queue_8_bytes: 48000
     tx_queue_9_bytes: 0

# tc -s class show dev eth0
class mq 1:1 root leaf 2:
 Sent 11106 bytes 65 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:2 root leaf 8001:
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:3 root leaf 8002:
 Sent 106986143484 bytes 70783214 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:4 root leaf 8003:
 Sent 2964 bytes 12 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:5 root leaf 8004:
 Sent 78364514238 bytes 51985575 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:6 root leaf 8005:
 Sent 13458 bytes 101 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:7 root leaf 8006:
 Sent 1252 bytes 6 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:8 root
 Sent 522 bytes 5 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class mq 1:9 root
 Sent 48000 bytes 222 pkt (dropped 0, overlimits 0 requeues 0)
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

> cheers,
> jamal



-- 
Best regards, Tonghao
