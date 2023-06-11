Return-Path: <netdev+bounces-9862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4834272AFDF
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 700462813E0
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8D210EA;
	Sun, 11 Jun 2023 00:52:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E857F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:52:25 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC2535A2;
	Sat, 10 Jun 2023 17:52:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 9DA0E60174;
	Sun, 11 Jun 2023 02:52:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686444739; bh=26Hm1PrArtUgy8pf0FP31DOBGDnaAJMLCARSj3m5GnU=;
	h=Date:From:Subject:To:Cc:From;
	b=eA3RNwgxY3JETPg3VtPHGcBNLOm9sKSW/3nL6E1IMv3SxYt1CyiW7nKeO6LpT98lF
	 mZJZpZAgfzQFycGbzPNwm4cECU2ArBvOS+c+Xf2qUHIFrwyT54aD0cBS/rsrGQonvS
	 ABEt7aZPDKaUfc8RZmQEhJgQ7VfKSOFIMzPWDobqokO4PrLJWN0WdPXbohooNBrewX
	 Nmqpz3RbAPeVh8ZsbIG633tkRC+rNFWDtThjlOJygyWot/vvGWS7g3rCV2mtTThPQx
	 s2644q7B64CgxydL4YX6OeNcI5JzXsQ3uYcl5LMPZpklIxy34NnGZ1mPvrMmsPtCKt
	 LsKvgKgOd4iYw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gt7pTgwHqnsk; Sun, 11 Jun 2023 02:52:16 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id A7D9A60173;
	Sun, 11 Jun 2023 02:52:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686444736; bh=26Hm1PrArtUgy8pf0FP31DOBGDnaAJMLCARSj3m5GnU=;
	h=Date:From:Subject:To:Cc:From;
	b=EO0I25M2EQQY3sO/IM/bbOa9nbkwKgTI67r0cZMbPs0PGUwTJ1vNMWIPrIWX+cE8q
	 m7lnXOZq0ujAn/VErltUCIuaPDSiu+Aqa7hkXiADHc460OKExUsb6A3fwqKwnbxswq
	 3SO34/LQjE/T3Km2YqG2cUlzVJFzGXuYZMONG+eGWBW1VZN+A63VQ+lc9kaXiMY/m7
	 NaQzVE9F/VMwNzlVKdMxvnecezv8n1UTx3Yoz2DqJ+A1psbPJOK0Wo2QafDPqHkZ0J
	 lMQo7ZyZDh2npsbxD62MprkkW1BmlqW8AofXRSHRxrEOWq9v5f6FF72vsNvvcb6uyC
	 fwVw9byw3uIUQ==
Message-ID: <6a368db5-2206-f94a-14b3-6bdf11927dc1@alu.unizg.hr>
Date: Sun, 11 Jun 2023 02:52:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [BUG] selftests: drivers/net/bonding:
 bond-arp-interval-causes-panic.sh: Cannot find device "link1_1"
To: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>, Andy Gospodarek
 <andy@greyhouse.net>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

The test failed with the latest torvalds tree kernel 6.4-rc5-00305-g022ce8862dff
on AMD Ryzen 9 and Ubuntu 22.04 Jammy.

The config is a merge of Ubuntu generic config and selftest config files.

Debug output with `set -x` is [edited]:

root@host:selftests/drivers/net/bonding# ./bond-arp-interval-causes-panic.sh
Cannot find device "link1_1"
root@defiant:/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/drivers/net/bonding# vi !$
vi ./bond-arp-interval-causes-panic.sh
root@host:selftests/drivers/net/bonding# ./bond-arp-interval-causes-panic.sh
+ test 0 -ne 0
+ trap finish EXIT
+ client_ip4=192.168.1.198
+ server_ip4=192.168.1.254
+ echo 180
+ ip link add dev link1_1 type veth peer name link1_2
+ ip netns add server
+ ip link set dev link1_2 netns server up name eth0
+ ip netns exec server ip addr add 192.168.1.254/24 dev eth0
+ ip netns add client
+ ip link set dev link1_1 netns client down name eth0
+ ip netns exec client ip link add dev bond0 down type bond mode 1 miimon 100 all_slaves_active 1
+ ip netns exec client ip link set dev eth0 down master bond0
+ ip netns exec client ip link set dev bond0 up
+ ip netns exec client ip addr add 192.168.1.198/24 dev bond0
+ ip netns exec client ping -c 5 192.168.1.254
+ finish
+ ip netns delete server
+ ip netns delete client
+ ip link del link1_1
Cannot find device "link1_1"
+ true
root@host:testing/selftests/drivers/net/bonding# uname -rms
Linux 6.4.0-rc5-kmlk-netdbg-iwlwifi-00305-g022ce8862dff x86_64
root@host:testing/selftests/drivers/net/bonding#

Some debugging:

I have added some "ip link show" commands in the finish() function:

finish()
{
         ip link show
         ip netns delete server || true
         ip netns delete client || true
         ip link show
         ip link del link1_1 || true
}

Now the debug output is like this:

root@host:selftests/drivers/net/bonding# ./bond-arp-interval-causes-panic.sh
+ test 0 -ne 0
+ trap finish EXIT
+ client_ip4=192.168.1.198
+ server_ip4=192.168.1.254
+ echo 180
+ ip link add dev link1_1 type veth peer name link1_2
+ ip netns add server
+ ip link set dev link1_2 netns server up name eth0
+ ip netns exec server ip addr add 192.168.1.254/24 dev eth0
+ ip netns add client
+ ip link set dev link1_1 netns client down name eth0
+ ip netns exec client ip link add dev bond0 down type bond mode 1 miimon 100 all_slaves_active 1
+ ip netns exec client ip link set dev eth0 down master bond0
+ ip netns exec client ip link set dev bond0 up
+ ip netns exec client ip addr add 192.168.1.198/24 dev bond0
+ ip netns exec client ping -c 5 192.168.1.254
+ finish
+ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 02:fc:ca:49:e2:d4 brd ff:ff:ff:ff:ff:ff
3: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
4: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre 0.0.0.0 brd 0.0.0.0
5: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
6: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
7: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
8: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 325b:a7df:c8db::
9: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
10: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 76d3:be76:4187::
11: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre6 :: brd :: permaddr 569b:65fd:b94b::
12: enp16s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
     link/ether 9c:6b:00:01:fb:80 brd ff:ff:ff:ff:ff:ff
+ ip netns delete server
+ ip netns delete client
+ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 02:fc:ca:49:e2:d4 brd ff:ff:ff:ff:ff:ff
3: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
4: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre 0.0.0.0 brd 0.0.0.0
5: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
6: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
7: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
8: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 325b:a7df:c8db::
9: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
10: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 76d3:be76:4187::
11: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre6 :: brd :: permaddr 569b:65fd:b94b::
12: enp16s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
     link/ether 9c:6b:00:01:fb:80 brd ff:ff:ff:ff:ff:ff
+ ip link del link1_1
Cannot find device "link1_1"
+ true
root@host:selftests/drivers/net/bonding#

Adding more `ip link show` before and after operations with link_1
had shown that `ip link set dev link1_1 netns client down name eth0` command
shuts down the link, so the `ip link del link1_1` doesn't succeed, as seen
here:

+ ip netns exec server ip addr add 192.168.1.254/24 dev eth0
+ ip netns add client
+ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 02:fc:ca:49:e2:d4 brd ff:ff:ff:ff:ff:ff
3: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
4: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre 0.0.0.0 brd 0.0.0.0
5: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
6: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
7: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
8: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 325b:a7df:c8db::
9: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
10: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 76d3:be76:4187::
11: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre6 :: brd :: permaddr 569b:65fd:b94b::
12: enp16s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
     link/ether 9c:6b:00:01:fb:80 brd ff:ff:ff:ff:ff:ff
64: link1_1@if63: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 32:d6:de:9f:5d:e2 brd ff:ff:ff:ff:ff:ff link-netns server
+ ip link set dev link1_1 netns client down name eth0
+ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 02:fc:ca:49:e2:d4 brd ff:ff:ff:ff:ff:ff
3: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
4: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre 0.0.0.0 brd 0.0.0.0
5: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
6: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
7: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ipip 0.0.0.0 brd 0.0.0.0
8: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 325b:a7df:c8db::
9: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
10: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/tunnel6 :: brd :: permaddr 76d3:be76:4187::
11: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/gre6 :: brd :: permaddr 569b:65fd:b94b::
12: enp16s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
     link/ether 9c:6b:00:01:fb:80 brd ff:ff:ff:ff:ff:ff
+ ip netns exec client ip link add dev bond0 down type bond mode 1 miimon 100 all_slaves_active 1

Hope this helps.

I am not sure what is the right thing to do with this test, and whether it is
the expected behaviour of the kernel.

Best regards,
Mirsad

