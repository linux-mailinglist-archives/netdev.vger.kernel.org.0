Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516A04D583F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 03:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiCKCmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 21:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiCKCmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 21:42:13 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5FE187BA9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 18:41:10 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.26])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 813FFA006D;
        Fri, 11 Mar 2022 02:41:09 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3391994008C;
        Fri, 11 Mar 2022 02:41:09 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B29A413C2B1;
        Thu, 10 Mar 2022 18:41:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B29A413C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1646966468;
        bh=yCPJAf3BmXS0MtxVWjj/oJET3B6DJerFxqwhTZXiXCc=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=FRg7vATAqMnMhuCR6ztopFlIAlg82QYw+MnmsV4/vv9zD+tShZleJNNVluciqAW63
         /GaeeneePUGn7ZH8raGEH9fZs3iekPMTXLEGdTK3WHFAZemihv8FqSVhrTNmbt2sMG
         sYSa8l/VNRCmvYy1vG+Vk/F+ba73nJy2tnS5AxCM=
Subject: Re: vrf and multicast problem
From:   Ben Greear <greearb@candelatech.com>
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
 <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
 <50f1a384-c312-d6ec-0f42-2b9ce3a48013@candelatech.com>
 <38ecaaaf-1735-9023-2282-5feead8408b7@gmail.com>
 <08eeb237-5126-98ce-0990-5b7d7f6529f2@candelatech.com>
 <43de8172-0cd4-bf6f-b89b-864fd7bf4dee@candelatech.com>
Organization: Candela Technologies
Message-ID: <1b0e4a8c-76c5-061b-5222-ca4e3b971ec6@candelatech.com>
Date:   Thu, 10 Mar 2022 18:41:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <43de8172-0cd4-bf6f-b89b-864fd7bf4dee@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1646966470-JDHGM7hAII1V
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 5:41 PM, Ben Greear wrote:
> On 3/10/22 3:41 PM, Ben Greear wrote:
>> On 3/10/22 12:03 PM, David Ahern wrote:
>>> On 3/10/22 12:33 PM, Ben Greear wrote:
>>>> On 3/9/22 7:54 PM, David Ahern wrote:
>>>>> On 3/9/22 3:31 PM, Ben Greear wrote:
>>>>>> [resend, sorry...sent to wrong mailing list the first time]
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> We recently found a somewhat weird problem, and before I go digging into
>>>>>> the kernel source, I wanted to see if someone had an answer already...
>>>>>>
>>>>>> I am binding (SO_BINDTODEVICE) a socket to an Ethernet port that is in a
>>>>>> VRF with a second
>>>>>> interface.  When I try to send mcast traffic out that eth port,
>>>>>> nothing is
>>>>>> seen on the wire.
>>>>>>
>>>>>> But, if I set up a similar situation with a single network port in
>>>>>> a vrf and send multicast, then it does appear to work as I expected.
>>>>>>
>>>>>> I am not actually trying to do any mcast routing here, I simply want to
>>>>>> send
>>>>>> out mcast frames from a port that resides inside a vrf.
>>>>>>
>>>>>> Any idea what might be the issue?
>>>>>>
>>>>>
>>>>> multicast with VRF works. I am not aware of any known issues
>>>>
>>>> I set up a more controlled network to do some more testing.  I have eth2
>>>> on 192.168.100.x/24 network, and eth1 on 172.16.0.1/16.
>>>>
>>>> I bind the mcast transmitter to eth1:
>>>>
>>>> 193 setsockopt(28, SOL_SOCKET, SO_BINDTODEVICE,
>>>> "eth1\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
>>>> 194 setsockopt(28, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>>>> 195 bind(28, {sa_family=AF_INET, sin_port=htons(8888),
>>>> sin_addr=inet_addr("0.0.0.0")}, 16) = 0
>>>> 196 fcntl(28, F_GETFL)                      = 0x2 (flags O_RDWR)
>>>> 197 fcntl(28, F_SETFL, O_ACCMODE|O_NONBLOCK) = 0
>>>> 198 setsockopt(28, SOL_SOCKET, SO_BROADCAST, [1], 4) = 0
>>>> 199 setsockopt(28, SOL_SOCKET, SO_SNDBUF, [64000], 4) = 0
>>>> 200 setsockopt(28, SOL_SOCKET, SO_RCVBUF, [128000], 4) = 0
>>>> 201 getsockopt(28, SOL_SOCKET, SO_RCVBUF, [256000], [4]) = 0
>>>> 202 getsockopt(28, SOL_SOCKET, SO_SNDBUF, [128000], [4]) = 0
>>>> 203 write(3, "1646940176442:  BtbitsIpEndpoint"..., 69) = 69
>>>> 204 setsockopt(28, SOL_IP, IP_TOS, [0], 4)  = 0
>>>> 205 getsockopt(28, SOL_IP, IP_TOS, [0], [4]) = 0
>>>> 206 setsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], 4) = 0
>>>> 207 getsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], [4]) = 0
>>>> 208 write(3, "1646940176442:  UdpEndpBase.cc 2"..., 148) = 148
>>>> 209 setsockopt(28, SOL_IP, IP_MULTICAST_IF, [16781484], 4) = 0
>>>> 210 setsockopt(28, SOL_IP, IP_MULTICAST_TTL, " ", 1) = 0
>>>>
>>>> That IP_MULTICAST_IF ioctl should be assigning the IP address of
>>>> eth1.
>>>>
>>>> But when I sniff, I see the mcast packets going out of eth2:
>>>>
>>>> [root@ct522-63e7 lanforge]# tshark -n -i eth2
>>>> Running as user "root" and group "root". This could be dangerous.
>>>> Capturing on 'eth2'
>>>>      1 0.000000000 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 474
>>>>      2 0.060868103 192.168.100.226 → 192.168.100.255 ADwin Config 94
>>>>      3 0.060900503 00:0d:b9:41:6a:90 → ff:ff:ff:ff:ff:ff 0x1111 92
>>>> Ethernet II
>>>>      4 0.209523669 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 475
>>>>
>>>> [root@ct522-63e7 lanforge]# ifconfig eth1
>>>> eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>>>>          inet 172.16.0.1  netmask 255.255.0.0  broadcast 172.16.255.255
>>>>          inet6 fe80::230:18ff:fe01:63e8  prefixlen 64  scopeid 0x20<link>
>>>>          ether 00:30:18:01:63:e8  txqueuelen 1000  (Ethernet)
>>>>          RX packets 1972669  bytes 409744407 (390.7 MiB)
>>>>          RX errors 0  dropped 0  overruns 0  frame 0
>>>>          TX packets 5818525  bytes 7341747933 (6.8 GiB)
>>>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>>>>          device memory 0xdf740000-df75ffff
>>>>
>>>> [root@ct522-63e7 lanforge]# ifconfig eth2
>>>> eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>>>>          inet 192.168.100.28  netmask 255.255.255.0  broadcast
>>>> 192.168.100.255
>>>>          inet6 fe80::230:18ff:fe01:63e9  prefixlen 64  scopeid 0x20<link>
>>>>          ether 00:30:18:01:63:e9  txqueuelen 1000  (Ethernet)
>>>>          RX packets 24638831  bytes 8874820766 (8.2 GiB)
>>>>          RX errors 26712  dropped 6596663  overruns 0  frame 16757
>>>>          TX packets 1753211  bytes 370552564 (353.3 MiB)
>>>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>>>>          device memory 0xdf720000-df73ffff
>>>>
>>>> If I disable VRF and use routing-rules based approach, then it works
>>>> as I expect (mcast frames go out of eth1).
>>>>
>>>> We tested back to quite-old kernels with same symptom, so I think it is not
>>>> a regression.
>>>>
>>>> Any suggestions on where to start poking at this in the kernel?
>>>>
>>>
>>> can you reproduce this using namespaces and veth pairs? if so, send me
>>> the script and I will take a look.
>>
>> I think debugging it will be easier than writing something for you to
>> reproduce it...
>>
>> I have tracked it down to this code in route.c:
>>
>>      if (fl4->flowi4_oif) {
>>          dev_out = dev_get_by_index_rcu(net, fl4->flowi4_oif);
>>          rth = ERR_PTR(-ENODEV);
>>          if (!dev_out)
>>              goto out;
>>
>>          /* RACE: Check return value of inet_select_addr instead. */
>>          if (!(dev_out->flags & IFF_UP) || !__in_dev_get_rcu(dev_out)) {
>>              rth = ERR_PTR(-ENETUNREACH);
>>              goto out;
>>          }
>>          if (ipv4_is_local_multicast(fl4->daddr) ||
>>              ipv4_is_lbcast(fl4->daddr) ||
>>              fl4->flowi4_proto == IPPROTO_IGMP) {
>>              if (!fl4->saddr)
>>                  fl4->saddr = inet_select_addr(dev_out, 0,
>>                                    RT_SCOPE_LINK);
>>              goto make_route;
>>          }
>>          if (!fl4->saddr) {
>>              if (ipv4_is_multicast(fl4->daddr))
>>                  fl4->saddr = inet_select_addr(dev_out, 0,
>>                                    fl4->flowi4_scope);
>>              else if (!fl4->daddr)
>>                  fl4->saddr = inet_select_addr(dev_out, 0,
>>                                    RT_SCOPE_HOST);
>>          }
>>      }
>>
>>      if (!fl4->daddr) {
>>          fl4->daddr = fl4->saddr;
>>          if (!fl4->daddr)
>>              fl4->daddr = fl4->saddr = htonl(INADDR_LOOPBACK);
>>          dev_out = net->loopback_dev;
>>          fl4->flowi4_oif = LOOPBACK_IFINDEX;
>>          res->type = RTN_LOCAL;
>>          flags |= RTCF_LOCAL;
>>          goto make_route;
>>      }
>>
>>      pr_info("ip-route-output-key-hash-rcu before fib_lookup: orig_oif: %d  fl4 oif: %d\n",
>>          orig_oif, fl4->flowi4_oif);
>>
>>      err = fib_lookup(net, fl4, res, 0);
>>
>>      pr_info("ip-route-output-key-hash-rcu after fib_lookup: orig_oif: %d  fl4 oif: %d err: %d\n",
>>          orig_oif, fl4->flowi4_oif, err);
>>
>>
>> dmesg output:
>>
>>
>> [   54.122391] UDP: udp-sendmsg, mcast, oif: 4  saddr: 0x0
>> [   54.122399] UDP: udp-sendmsg, after, mcast, oif: 4  saddr: 0x10010ac
>> [   54.122401] UDP: udp-sendmsg: after flowi4_init_output: oif: 4
>> [   54.122404] UDP: udp-sendmsg: after security-sk-classify: oif: 4
>>
>> [   54.122406] IPv4: ip-route-output-key-hash-rcu before fib_lookup: orig_oif: 4  fl4 oif: 4
>> ### This is the transition from expected to funky.
>> [   54.122413] IPv4: ip-route-output-key-hash-rcu after fib_lookup: orig_oif: 4  fl4 oif: 21
>>
>> [   54.122415] IPv4: ip-route-output-key-hash-rcu before fib_select_path: orig_oif: 4  fl4 oif: 21
>> [   54.122418] IPv4: ip-route-output-key-hash-rcu after fib_select_path: orig_oif: 4  fl4 oif: 21
>> [   54.122420] IPv4: ip-route-output-key-hash-rcu make_route Before, orig_oif: 4  fl4 oif: 21 dev_out: 5
>> [   54.122443] IPv4: ip-route-output-key-hash-rcu make_route After, orig_oif: 4  fl4 oif: 21 dev_out: 5
>> [   54.122446] IPv4: ip_route_output_flow, old-oif: 21  new: 5  new-dev: eth2
>> [   54.122449] UDP: udp-sendmsg: after ip_route_output_flow: oif: 5
>>
>>
>> So, something in the fib_lookup code is selecting the vrf device as output,
>> I guess because oif 4 (eth1) is part of the vrf.  And then the vrf routing table
>> ends up selecting oif 5 (eth2), which holds the default route.  However, there is
>> nothing adding any mcast routing (I am not running any multicast router on this vrf),
>> so once the code forgets that I bound the socket to oif 4, then it ends up choosing
>> the wrong outbound interface.
>>
>> In the paste above, there is special casing for 'local' mcast routing.  If I select
>> a 224.0.0.x local mcast address, then the special case code is used and then things
>> work as I expected (mcast pkts go out of the selected interface).
>>
>> I think that maybe other mcast addresses should also abide by the user's request if user
>> has bound it to a specified oif?
>>
>> Or, maybe there is some special casing needed in the fib_lookup?
> 
> After some more investigation of this code, I am questioning the need for this logic:
> 
>      /* update flow if oif or iif point to device enslaved to l3mdev */
>      l3mdev_update_flow(net, flowi4_to_flowi(flp));
> 
> If I bind a socket to a particular net-dev with SO_BINDTODEVICE, then I really
> do want to force the frame out that interface.
> 
> I understand that with vrf, there is a secondary meaning that when you bind to
> a device that is part of a vrf, then you are also associating with that vrf.
> To me, this should mean that we use the routing table associated with this
> vrf, but just like when using 'normal' routing tables, binding to specify an OIF
> takes precedence over a lot of the routing logic.
> 
> If a user wishes to send frames and have the vrf route the frame out arbitrary interface, then it could
> bind to the vrf device itself.  Or maybe you could let the vrf device be the oif
> if source-addr is not selected, but that is pretty subtle distinction as well.
> 
> And all this said, I am still not understanding how the vrf is supposed to make
> an intelligent decision on mcast routing in this situation.
> 
> Thanks,
> Ben
> 
> 

This hack upon a hack makes my multicast test work for me (tm).
My real diff is full of debugging, so just assume you see the code where I pass in the
original netdev.  I'll post a cleaned up patch tomorrow:

in __mkroute_output from ipv4/route.c:

My stuff starts with the logic related to orig_dev_out:

...
	} else if (type == RTN_MULTICAST) {
		flags |= RTCF_MULTICAST | RTCF_LOCAL;
		if (!ip_check_mc_rcu(in_dev, fl4->daddr, fl4->saddr,
				     fl4->flowi4_proto)) {
			flags &= ~RTCF_LOCAL;
			pr_info("removing RTCF_LOCAL flag\n");
		}
		else {
			do_cache = false;
			pr_info("not removing RTCF_LOCAL flag, do_cache to false\n");
		}

		pr_info("res->prefixlen: %d  fi: %p\n",
			res->prefixlen, fi);
		/* If multicast route do not exist use
		 * default one, but do not gateway in this case.
		 * Yes, it is hack.
		 */
		if (fi && res->prefixlen < 4) {
			struct net *net = dev_net(dev_out);

			fi = NULL;

			if (orig_oif && orig_dev_out &&
			    dev_out->ifindex != orig_oif &&
			    netif_index_is_l3_master(net, fl4->flowi4_oif)) {
				/* vrf overwrites the original flowi4_oif for
				 * member network devices.  In that case,
				 * lets use the user-specified oif instead of
				 * a default route.
				 */
				dev_out = orig_dev_out;
			}
		}

It does not solve all of my concerns about binding unicast sockets, but I've been dealing with
that mostly successfully already, so maybe this hack will be good enough...

Thanks,
Ben
