Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41693D4281
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhGWVSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 17:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhGWVSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 17:18:13 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37433C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 14:58:46 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653] (unknown [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 38DC8206E1;
        Fri, 23 Jul 2021 14:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627077525;
        bh=JiVZYVSIs7VW5GEltuRelGgRJ851JHBxiYeY+w41yK0=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=rtFkyJ5wdFQVOEnV/oVzcmaW/9vQwxVOa1PupILAsEgAbEjCDVLVRPimaefcLbPVI
         UMFrrADG8M2gn7aAp9fg/8G1lVDE1ReShl04Itt7L9TT9SyQmo76rR7EO3md3bBjvk
         QkvnnSex954jrq0BwREacz3ajDj9ABt38x9m6L8M=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch> <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
Message-ID: <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
Date:   Fri, 23 Jul 2021 14:58:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 11:36 AM, Dario Alcocer wrote:
> On 7/23/21 11:25 AM, Andrew Lunn wrote:
>>>> You probably don't want both ends of the link in rgmii-id mode. That
>>>> will give you twice the delay.
>>>
>>> Ok, I'll change phy-mode to "rgmii" for both ends. It's a little 
>>> confusing
>>> that there's a reference to phy-mode at all, though, given the actual
>>> connection is SERDES. My understanding is SERDES is a digital, PHY-less
>>> connection.
>>
>> Is it even RGMII? You say SERDES, so 1000BaseX seems more likely.
>>
>>     Andrew
>>
>
> Ah, I see, good point. I'll use "1000base-x" instead.

Using the updated device tree fragment produced no change. The port 
still reports no link:

root@dali:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode 
DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group 
default qlen 10
     link/can
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP 
mode DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group 
default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff

The DSA kernel options used with the 5.4.114-altera kernel are below. 
I've applied the DSA DEBUG_FS patch from Vivien Didelot (rebased for 
5.4.114), just in case it might help.

root@dali:~# zcat /proc/config.gz | grep DSA
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_DEBUGFS=y
# CONFIG_NET_DSA_TAG_8021Q is not set
# CONFIG_NET_DSA_TAG_BRCM is not set
# CONFIG_NET_DSA_TAG_BRCM_PREPEND is not set
# CONFIG_NET_DSA_TAG_GSWIP is not set
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_MTK is not set
# CONFIG_NET_DSA_TAG_KSZ is not set
# CONFIG_NET_DSA_TAG_QCA is not set
# CONFIG_NET_DSA_TAG_LAN9303 is not set
# CONFIG_NET_DSA_TAG_SJA1105 is not set
# CONFIG_NET_DSA_TAG_TRAILER is not set
# CONFIG_NET_DSA_BCM_SF2 is not set
# CONFIG_NET_DSA_LOOP is not set
# CONFIG_NET_DSA_LANTIQ_GSWIP is not set
# CONFIG_NET_DSA_MT7530 is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MICROCHIP_KSZ9477 is not set
# CONFIG_NET_DSA_MICROCHIP_KSZ8795 is not set
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=y
# CONFIG_NET_DSA_MV88E6XXX_PTP is not set
# CONFIG_NET_DSA_SJA1105 is not set
# CONFIG_NET_DSA_QCA8K is not set
# CONFIG_NET_DSA_REALTEK_SMI is not set
# CONFIG_NET_DSA_SMSC_LAN9303_I2C is not set
# CONFIG_NET_DSA_SMSC_LAN9303_MDIO is not set
# CONFIG_NET_DSA_VITESSE_VSC73XX_SPI is not set
# CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM is not set
# CONFIG_HNS_DSAF is not set
# CONFIG_CRYPTO_ECRDSA is not set

Here are the PHY lines from the log:

[    2.781894] libphy: Fixed MDIO Bus: probed
[    2.885923] libphy: stmmac: probed
[    3.094333] libphy: mv88e6xxx SMI: probed
[    3.464755] libphy: mv88e6xxx SMI: probed
[    3.875276] can: netlink gateway (rev 20190810) max_hops=1
[    4.117463] libphy: mv88e6xxx SMI: probed
[    5.609731] mv88e6085 stmmac-0:1a lan1 (uninitialized): PHY 
[mv88e6xxx-0:00] driver [Marvell 88E1540]
[    5.663118] mv88e6085 stmmac-0:1a lan2 (uninitialized): PHY 
[mv88e6xxx-0:01] driver [Marvell 88E1540]
[    5.711747] mv88e6085 stmmac-0:1a lan3 (uninitialized): PHY 
[mv88e6xxx-0:02] driver [Marvell 88E1540]
[    5.786248] mv88e6085 stmmac-0:1a: configuring for fixed/1000base-x 
link mode
[    5.853905] mv88e6085 stmmac-0:1a: Link is Up - 1Gbps/Full - flow 
control off
[    7.083450] mv88e6085 stmmac-0:1e lan4 (uninitialized): PHY 
[mv88e6xxx-2:00] driver [Marvell 88E1540]
[    7.132094] mv88e6085 stmmac-0:1e dmz (uninitialized): PHY 
[mv88e6xxx-2:01] driver [Marvell 88E1540]
[    7.224337] mv88e6085 stmmac-0:1e: configuring for fixed/1000base-x 
link mode
[    7.314012] mv88e6085 stmmac-0:1e: Link is Up - 1Gbps/Full - flow 
control off
[   11.026419] socfpga-dwmac ff700000.ethernet eth0: configuring for 
fixed/gmii link mode
[   11.035304] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 
1Gbps/Full - flow control rx/tx
[   11.043993] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

The DSA debugfs shows the following:

root@dali:~# ls /sys/kernel/debug/dsa/
switch0
root@dali:~# ls /sys/kernel/debug/dsa/switch0
port0  port1  port2  port3  port4  port5  port6  tag_protocol tree
root@dali:~# cat /sys/kernel/debug/dsa/switch0/tree
0
root@dali:~# ls /sys/kernel/debug/dsa/switch0/port0
fdb  mdb  regs  stats  vlan
root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/vlan
root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/vlan | hexdump -C
root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/stats
in_good_octets      : 0
in_bad_octets       : 0
in_unicast          : 0
in_broadcasts       : 0
in_multicasts       : 0
in_pause            : 0
in_undersize        : 0
in_fragments        : 0
in_oversize         : 0
in_jabber           : 0
in_rx_error         : 0
in_fcs_error        : 0
out_octets          : 0
out_unicast         : 0
out_broadcasts      : 0
out_multicasts      : 0
out_pause           : 0
excessive           : 0
collisions          : 0
deferred            : 0
single              : 0
multiple            : 0
out_fcs_error       : 0
late                : 0
hist_64bytes        : 0
hist_65_127bytes    : 0
hist_128_255bytes   : 0
hist_256_511bytes   : 0
hist_512_1023bytes  : 0
hist_1024_max_bytes : 0
sw_in_discards      : 0
sw_in_filtered      : 0
sw_out_filtered     : 0
atu_member_violation: 0
atu_miss_violation  : 0
atu_full_violation  : 0
vtu_member_violation: 0
vtu_miss_violation  : 0
root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/regs
  0: 100f
  1: 0003
  2: 0000
  3: 1761
  4: 0433
  5: 0000
  6: 0010
  7: 0000
  8: 2080
  9: 0001
10: 0000
11: 0001
12: 0000
13: 0000
14: 0000
15: 9100
16: 0000
17: 0000
18: 0000
19: 0000
20: 0000
21: 0000
22: 0033
23: 0000
24: 3210
25: 7654
26: 0000
27: 8000
28: 0000
29: 0000
30: 0000
31: 0000
root@dali:~#

Finally, here's the device tree fragment used to configure DSA. I added 
phy-handle resources for each of the switch port, taken from the example 
in Documentation/devicetree/bindings/net/dsa/dsa.txt. I did this to see 
if it would fix the port link issue:

&gmac0 {
     status = "okay";
     phy-mode = "gmii";

     txc-skew-ps = <3000>;
     rxc-skew-ps = <3000>;

     txen-skew-ps = <0>;
     rxdv-skew-ps = <0>;

     rxd0-skew-ps = <0>;
     rxd1-skew-ps = <0>;
     rxd2-skew-ps = <0>;
     rxd3-skew-ps = <0>;
     rxd4-skew-ps = <0>;
     rxd5-skew-ps = <0>;
     rxd6-skew-ps = <0>;
     rxd7-skew-ps = <0>;

     txd0-skew-ps = <0>;
     txd1-skew-ps = <0>;
     txd2-skew-ps = <0>;
     txd3-skew-ps = <0>;
     txd4-skew-ps = <0>;
     txd5-skew-ps = <0>;
     txd6-skew-ps = <0>;
     txd7-skew-ps = <0>;

     max-frame-size = <3800>;

     fixed-link {
         speed = <1000>;
         full-duplex;
         pause;
     };

     mdio {
         compatible = "snps,dwmac-mdio";
         #address-cells = <0x1>;
         #size-cells = <0x0>;

         switch0: switch0@1a {
             compatible = "marvell,mv88e6085";
             reg = <0x1a>;

             dsa,member = <0 0>;

             ports {
                 #address-cells = <1>;
                 #size-cells = <0>;

                 port@0 {
                     reg = <0>;
                     label = "lan1";
                     phy-handle = <&switch0phy0>;
                 };

                 port@1 {
                     reg = <1>;
                     label = "lan2";
                     phy-handle = <&switch0phy1>;
                 };

                 port@2 {
                     reg = <2>;
                     label = "lan3";
                     phy-handle = <&switch0phy2>;
                 };

                 switch0port4: port@4 {
                     reg = <4>;
                     phy-mode = "1000base-x";
                     link = <&switch1port4>;
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
                     };
                 };
             };

             mdio-bus {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 switch0phy0: switch0phy@0 {
                     reg = <0>;
                 };
                 switch0phy1: switch0phy@1 {
                     reg = <1>;
                 };
                 switch0phy2: switch0phy@2 {
                     reg = <2>;
                 };
             };
         };

         switch1: switch1@1e {
             compatible = "marvell,mv88e6085";
             reg = <0x1e>;

             dsa,member = <0 1>;

             ports {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 port@0 {
                     reg = <0>;
                     label = "lan4";
                 };

                 port@1 {
                     reg = <1>;
                     label = "dmz";
                 };

                 switch1port4: port@4 {
                     reg = <4>;
                     link = <&switch0port4>;
                     phy-mode = "1000base-x";
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
                     };
                 };

                 port@6 {
                     reg = <6>;
                     ethernet = <&gmac0>;
                     label = "cpu";
                 };
             };

             mdio-bus {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 switch1phy0: switch1phy@0 {
                     reg = <0>;
                 };
                 switch1phy1: switch1phy@1 {
                     reg = <1>;
                 };
             };
         };
     };
};

