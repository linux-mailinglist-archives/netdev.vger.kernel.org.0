Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2978E32B383
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352631AbhCCEAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349686AbhCBL33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:29:29 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46815C061756;
        Tue,  2 Mar 2021 03:28:46 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jt13so34620037ejb.0;
        Tue, 02 Mar 2021 03:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ne1jKQEzc+j2RSXx8k9BrFVLTm1aSJu1puRRw+vucrg=;
        b=p62PR86sZ80v2f6kAMBfm4+98DvMiqLXnID5q9XL4LZUf4XxXBCwks+xayAq2q4AWg
         x5O/GkcXicGZZOIHt+dUl6LhULxNjWgKLWq/JfI+dpXQ8tCBVaMkl4DxZLF1aHT3e1uS
         Qkuj8TsuWWwEaiQWLn5906i1XJMJr9HqkCZl1NCiXfiUPBwiT2m5bvHpFqBrKMKuLOLh
         GyhpIMxDli58PhmnyWw6i8SOLzNLkvT+rYhVIEFtSgRjBM2p0WoDpTlhLeaGijG3RmdZ
         C1IAh1W5/jj7kncsDJNj47BB/sRexS/nOIHclpYYFzHAS1HD1CouEBn8Ql8gix3rOUG9
         NQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ne1jKQEzc+j2RSXx8k9BrFVLTm1aSJu1puRRw+vucrg=;
        b=i4Ygd4c+OTLNOwjkPD9qxgkLNSyoGHlGWySOgwX+qHKfAnVDySiMe+4/rnB/Nw7Bi/
         S3lbR2+nUngo2vVVr+NxgHt7i/cYTweJ22Kmt4B+LKzPl9XGNbosm7AQY44L0O3xFAtp
         /rTsN4r5090uIue/I3h7JPZNilaMBEmObTgr3md2v1nX+5owziuYU/+3cw1GYfs2zOdl
         1rgv8P12dQVBxTlcueAeWhE4VIf8EaKnpu3CpCAU311aA7wjTskdH1iAhdH/R8BKlHKq
         ONIuJf6I5fmyRGq7yf5xI86oiFtPldbXAbiG4j4+TBpjvgf5JyIuT51v41yCsbJqBXe3
         YZZA==
X-Gm-Message-State: AOAM530v3yp4+/dD5dmbRhNPyRkWRXIkDWf9PZxxlZdNq1A4gHLsVR9g
        z/xTLbS4IYy5XUpwBAhC2Hw=
X-Google-Smtp-Source: ABdhPJw/jvJAKfJfUwxEWAZIAOYF5bvPWHeEgoHQPeuvjdlm6Vv4nDkbTh3/icJd2TOdqq6z37HOSw==
X-Received: by 2002:a17:906:a51:: with SMTP id x17mr399300ejf.25.1614684524911;
        Tue, 02 Mar 2021 03:28:44 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id w18sm15957552ejn.23.2021.03.02.03.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 03:28:44 -0800 (PST)
Date:   Tue, 2 Mar 2021 13:28:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Birger Koblitz <git@birger-koblitz.de>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Stijn Segers <foss@volatilesystems.org>
Subject: Re: dsa_master_find_slave()'s time complexity and potential
 performance hit
Message-ID: <20210302112842.5t54kgz3j556cm52@skbuf>
References: <CALW65jatBuoE=NDRqccfiMVugPh5eeYSf-9a9qWYhvvszD2Jiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jatBuoE=NDRqccfiMVugPh5eeYSf-9a9qWYhvvszD2Jiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 01:51:42PM +0800, DENG Qingfang wrote:
> Since commit 7b9a2f4bac68 ("net: dsa: use ports list to find slave"),
> dsa_master_find_slave() has been iterating over a linked list instead
> of accessing arrays, making its time complexity O(n).
> The said function is called frequently in DSA RX path, so it may cause
> a performance hit, especially for switches that have many ports (20+)
> such as RTL8380/8390/9300 (There is a downstream DSA driver for it,
> see https://github.com/openwrt/openwrt/tree/openwrt-21.02/target/linux/realtek/files-5.4/drivers/net/dsa/rtl83xx).
> I don't have one of those switches, so I can't test if the performance
> impact is huge or not.

You actually can test that, you could create a tagger in mainline based
on the rtl83xx tagger from downstream, and then you could modify
dsa_loop to use DSA_TAG_PROTO_RTL83XX.

Then you can craft some packets and inject them into the port on which
dsa_loop is attached using tcpreplay.
What I do is:
- I initially send some packets using the xmit function of the tagger,
  just to have an initial template to start with. This assumes that the
  xmit format is more or less similar to the rcv format.
- capture those xmit packets using tcpdump -i eth0 -Q out -w tagger.pcap
- then open tagger-xmit.pcap in wireshark, run Export Specified Packet
  and save it in the K12 text file format
- edit the tagger-xmit.txt file according to my liking, in this case you
  would have to create a receive packet on port 19 (the one where it's
  most expensive to do the linear lookup of the ports list)
- import the tagger.txt file again in Wireshark and save it as a new
  tagger-rcv.pcap
- run tcpreplay on that pcap file in a loop

I would probably go with a very small packet size (64 bytes), and enable
IP routing between two DSA interfaces lan0 and lan1:

ip link set lan0 address de:ad:be:ef:00:00
ip link set lan1 address de:ad:be:ef:00:01
ip addr add 192.168.100.2/24 dev lan0
ip addr add 192.168.101.2/24 dev lan1
echo 1 > /proc/sys/net/ipv4/ip_forward
arp -s 192.168.100.1 00:01:02:03:04:05 dev lan0 # towards spoofed sender
arp -s 192.168.200.1 00:01:02:03:04:06 dev lan1 # towards spoofed receiver

I would make sure the test packet from tagger-rcv.pcap has:
- a source MAC address corresponding to your spoofed sender (in my
  example 00:01:02:03:04:05).
- a source IP address corresponding to your spoofed sender (in my
  example 192.168.100.1)
- a destination MAC address corresponding to the lan0 interface
  (de:ad:be:ef:00:00)
- a destination IP address corresponding to the spoofed receiver
  (192.168.101.2)

Then the network stack should route the received packet on lan0 by
replacing the destination MAC address with that of the spoofed receiver
(00:01:02:03:04:06), decrement the IP TTL to 63 and send it through lan1
according to the routing table.

To make sure your throughput is consistent you can do some things such
as add a static flow steering rule on the DSA master to ensure the
packets from the same flow are affine to the same CPU, and that if you
send bidirectional traffic, it gets load balanced across multiple CPUs:

ethtool --config-nfc eth0 flow-type ether dst de:ad:be:ef:00:00 m ff:ff:ff:ff:ff:ff action 0
ethtool --config-nfc eth0 flow-type ether dst de:ad:be:ef:00:01 m ff:ff:ff:ff:ff:ff action 1

Also, you should probably turn off GRO since it's not useful with IP
forwarding and it takes a lot of time to do the re-segmentation on TX,
to recalculate the checksums and all.

ethtool -K lan0 gro off
ethtool -K lan1 gro off

You could probably adjust things a bit, like for example see if the rcv
throughput on lan19 is higher than the throughput on lan0.

That should give you a baseline. Only then would I start hacking at
dsa_master_find_slave and see what benefit it brings to replace the list
lookup with something of fixed temporal complexity, such as a linear
array or something.

I'm curious what you come up with.
