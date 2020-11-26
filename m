Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6C2C5D94
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbgKZVlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387493AbgKZVlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:41:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14729C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 13:41:49 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id d8so4374084lfa.1
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 13:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=RET0sSWUzQU7HUGlc5wt33AMBHnVFTxtqXqzXUhTBmc=;
        b=aE38YuSAwh8u7phGQLPAzLLYWybECRKpxCd7dTGLBcyqwCJ2KB6W63A8Wsl5ArtlHQ
         Xm7Mk5iZxmV98YJVywCDLUIAzFJIbKuQ/nXfye3bv5S/6bsnhuFw7THfKWfywNNQqd6O
         fdiBP38XU9MW6eiKizNzM09LVN7ZoHCDKsVxZaWUs99fXlAwvWAqP88mIW7qWG9rKxp0
         MdhIW/9lr4kEEP6Iok2E7VWgjEsf0orkGDi05886Ket+7R2DAHoC18weD/R6Qcu1HIwJ
         CLUJyULr+CbCYVwYjAamaaD5Kk1dSgK/mEY60DlF6TDXCspcrWYvR2lihIGdCO6Bdpub
         4Dhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RET0sSWUzQU7HUGlc5wt33AMBHnVFTxtqXqzXUhTBmc=;
        b=DYfEhDqnd5sMqiMuhUo2/jMWfyuWaTHnSgYqFCWEiLF6t48Hw67ftpsICda1H0KZC4
         +dmAcRMO+1908FQ2sLjTo1O2FFy0qrbVozAnCMnYycENh9MPYldw/QGILc0HsZg3p6tj
         naBLjPkgEhg+IDjZ7OfyxtqWd7Wi2WRaOPmlSg8A5xVUkH98K0d105DnCph784n7C4xX
         3tLgU84I/DAoA2egRYLPAAXRSMrsorMznztfXQjGclYd2nUfXQGMm/cFO45gA8R5shgD
         dTGCnYJMYGjmLrFuwfp0Ci+VY7dRrdXndeajV3EKjtn9wqQcJ+jZS51llc845O3AJKDw
         8OWg==
X-Gm-Message-State: AOAM5312bcRJpFGRiQRL8lMoIFRhGc4fJcEEAcnJcdVYfF2l1HbZjopq
        ZckGwOTO0A0cZcHze9zlM+qwvdv6g7C9+A==
X-Google-Smtp-Source: ABdhPJzpcr3EfowrOv2Nu0cRMVtjRvsw7zroDu9635uVd/WwWi4oAIXY7ifLiVR/aPh911jEn2x0yA==
X-Received: by 2002:ac2:4ac7:: with SMTP id m7mr2001563lfp.513.1606426905265;
        Thu, 26 Nov 2020 13:41:45 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id h7sm449244lfc.263.2020.11.26.13.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 13:41:44 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Peter Vollmer <peter.vollmer@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
In-Reply-To: <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com> <20200930191956.GV3996795@lunn.ch> <20201001062107.GA2592@fido.de.innominate.com> <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
Date:   Thu, 26 Nov 2020 22:41:44 +0100
Message-ID: <87y2in94o7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 15:09, Peter Vollmer <peter.vollmer@gmail.com> wrote:
> Hi,
> I am still investigating the leaking packets problem we are having
> with a setup of an armada-3720 SOC and a 88E6341 switch ( connected
> via cpu port 5 , SGMII ,C_MODE=0xB, 2500 BASE-x). I now jumped to the
> net-next kernel (5.10.0-rc4) and can now use the nice mv88e6xxx_dump
> tool for switch register dumping.
>
> The described packet leaking still occurs, in a setup of ports
> lan0-lan3 (switch ports 1-4)  joined in a bridge br0.
>
> Here is my setup, ports lan0-3 are DSA ports coming in through eth1,
> eth0 is a single 88E1512 phy connected to RGMII
> root@DUT:~# brctl show
> bridge name     bridge id               STP enabled     interfaces
> br0             8000.fafb2fbbd4c6       no              lan0
>                                                         lan1
>                                                         lan2
>                                                         lan3
> root@DUT:~# ip a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
> group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>        valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> group default qlen 1024
>     link/ether c2:49:bc:0d:a8:57 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.90.100/24 brd 192.168.90.255 scope global eth0
>        valid_lft forever preferred_lft forever
> 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc mq state UP
> group default qlen 1024
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
>     link/sit 0.0.0.0 brd 0.0.0.0
> 5: lan0@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
> master br0 state UP group default qlen 1000
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
> 6: lan1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
> master br0 state UP group default qlen 1000
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
> 7: lan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
> master br0 state UP group default qlen 1000
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
> 8: lan3@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
> noqueue master br0 state LOWERLAYERDOWN group default qlen 1000
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
> 9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
> UP group default qlen 1000
>     link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
>     inet 172.16.4.1/16 brd 172.16.4.255 scope global br0
>        valid_lft forever preferred_lft forever
>
> - pinging from client0 (connected to lan0 ) to the bridge IP, the ping
> requests (only the requests) are also seen on client1 connected to
> lan1

This is the expected behavior of the current implementation I am
afraid. It stems from the fact that the CPU responds to the echo request
(or to any other request for that matter) with a FROM_CPU. This means
that no learning takes place, and the SA of br0 will thus never reach
the switch's FDB. So while client0 knows the MAC of br0, the switch
(very counter-intuitively) does not.

The result is that the unicast echo request sent by client0 is flooded
as unknown unicast by the switch. This way it reaches the CPU but also,
as you have discovered, all other ports that allow unknown unicast to
egress.

> - the other effect looks more suspicious: when pinging from br0 to the
> IP of client0 connected to port lan0, after ~280 seconds client1
> connected to lan1 will also see the ping replies of client0 (only the
> replies). And after another ~300seconds this stops again. This repeats
> in a cycle .

I can not account for the oscillating effect. In my system I see a
continuous stream of respones from client0 when tcpdumping on
client1. That said, 300s is the default age timeout so I would start by
diffing the ATU when you are seeing replies on client1 and when you are
not.

The echo responses reaches client1 for the same reason as above. It is
just that now that client0 is the pinged host, the responses are
addressed to br0's MAC, which will be classified as unknown unicast.

> I see these problems since at least kernel version 5.4.y, but not with
> the old linux-marvel kernel sources
> (https://github.com/MarvellEmbeddedProcessors/linux-marvell.git)
> Can somebody using this switch in SGMII mode perhaps reproduce this ?

My system is connected to the CPU over RGMII, but I would guess that
that has no impact on this issue. The CPU is not responsible for
flooding the packets to client1, the switch does that autonomously. If
you tcpdump with "-Q out" on your base interface, I bet you will only
see FROM_CPUs to the port that client0 is connected to.

> One thing I noticed is that due to .tag_protocol=DSA_TAG_PROTO_EDSA
> for the 88E6341 switch, EgressMode (port control 0x4 , bit13:12) is
> set to an unsupported value of 0x3 ("reserved for future use" in the
> switch spec). See the value in row 04 Port control for port 5 = 0x373f
> in the following dump:
>
> root@mguard3:~# mv88e6xxx_dump --ports
> Using device <mdio_bus/d0032004.mdio-mii:01>
>                            0    1    2    3    4    5
> 00 Port status            0006 9e4f 9e4f 9e4f 100f 0f0b
> 01 Physical control       0003 0003 0003 0003 0003 20ff
> 02 Jamming control        ff00 0000 0000 0000 0000 0000
> 03 Switch ID              3410 3410 3410 3410 3410 3410
> 04 Port control           007c 043f 043f 043f 043c 373f
> 05 Port control 1         0000 0000 0000 0000 0000 0000
> 06 Port base VLAN map     007e 007c 007a 0076 006e 005f
> 07 Def VLAN ID & Prio     0001 0000 0000 0000 0000 0000
> 08 Port control 2         2080 0080 0080 0080 0080 0080
> 09 Egress rate control    0001 0001 0001 0001 0001 0001
> 0a Egress rate control 2  8000 0000 0000 0000 0000 0000
> 0b Port association vec   0001 0002 0004 0008 0010 0000
> 0c Port ATU control       0000 0000 0000 0000 0000 0000
> 0d Override               0000 0000 0000 0000 0000 0000
> 0e Policy control         0000 0000 0000 0000 0000 0000
> 0f Port ether type        9100 9100 9100 9100 9100 dada
> 10 Reserved               0000 0000 0000 0000 0000 0000
> 11 Reserved               0000 0000 0000 0000 0000 0000
> 12 Reserved               0000 0000 0000 0000 0000 0000
> 13 Reserved               0000 0000 0000 0000 0000 0000
> 14 Reserved               0000 0000 0000 0000 0000 0000
> 15 Reserved               0000 0000 0000 0000 0000 0000
> 16 LED control            0000 10eb 10eb 10eb 10eb 0000
> 17 Reserved               0000 0000 0000 0000 0000 0000
> 18 Tag remap low          3210 3210 3210 3210 3210 3210
> 19 Tag remap high         7654 7654 7654 7654 7654 7654
> 1a Reserved               0000 0000 0000 0000 5ea0 a100
> 1b Queue counters         8000 8000 8000 8000 8000 8000
> 1c Queue control          0000 0000 0000 0000 0000 0000
> 1d queue control 2        0000 0000 0000 0000 0000 0000
> 1e Cut through control    f000 f000 f000 f000 f000 f000
> 1f Debug counters         0000 0014 0015 0012 0000 0010
>
> I tested setting .tag_protocol=DSA_TAG_PROTO_DSA for the 6341 switch
> instead, resulting in a register setting of 04 Port control for port 5
> = 0x053f (i.e. EgressMode=Unmodified mode, frames are transmitted
> unmodified), which looks correct to me. It does not fix the above
> problem, but the change seems to make sense anyhow. Should I send a
> patch ?

This is not up to me, but my guess is that Andrew would like a patch,
yes. On 6390X, I know for a fact that setting the EgressMode to 3 does
indeed produce the behavior that was supported in older devices (like
the 6352), but there is no reason not to change it to regular DSA.

