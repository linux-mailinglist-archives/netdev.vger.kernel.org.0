Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128EC54B4A8
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 17:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiFNP3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244380AbiFNP32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 11:29:28 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6230135DF7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 08:29:27 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6B3763FBEC
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655220565;
        bh=JJHb1K3t7X3JlgWSqyOHbKnzDAtFOurS87zwNThTqys=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Fdt8SrcGrifWNcfArs+DXBF0QrAbnayUG9NvhM0WQL8tDQ+MLJEltnS8OPd0NrQ/K
         WGqM5+sAS1jZo3czAytdKviipfj7PbCyG7MqmA5V1PJTQGitsm0kHL1yiKX3qqUF2M
         eesKm8+u8mS0V8bpLQjoGvHWZ2gdD+x+lGOJx7HYF0+Kg3GpzIAbIzLu7WXN96mSV3
         3CB0fqKcIoywphR2Tw5gDK/YUEmMFQ8+IXoWU/bbP3BTLcgQ8vuz0ksDPOHpkEeYPf
         1HsjYTwblUNnZZqoIZkymrnPqKlLjmb3K0WgxGRLQQqn0KmHe0uP3zk5LeDAtyZVnr
         VLmXnX1WobwDw==
Received: by mail-pj1-f70.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so8333700pjb.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 08:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=JJHb1K3t7X3JlgWSqyOHbKnzDAtFOurS87zwNThTqys=;
        b=3hOwDmZ2MGADM2CH3fwkn9aP53VQDuvaqfudyACI3yhbL032/I4mVVf2oEAwQ0/733
         ZORhUmORYsEeBMAXO0QhUc2Mbo+0O8b+uTs9tTit/VFZPdf32NQEQ4jrFzwTXvx0vrlI
         J9ed4dV8TzK6Ws4ejGsGfy8A7asNxZaogYqYIbqfgNwJZ0cBkd55KhDa1AHGHi8RAVax
         HFhdPAGPxClIlD0G3RsZkHQ3AEH6fUv3unea8Zf2n6crllWBnifbZIdKfgPZpZnuHfN2
         6APwMP6v/jBpwyW/PzDeXd8JB1xyKfnoISTuQNM9gHkAhyv+ZULeFKv5qhVGOXXhwEM5
         n1eQ==
X-Gm-Message-State: AJIora9dk9/iWcL9m9WTskEZ375NrBLlvVPtbVmCFupCpgD3ikf+GD9U
        PXNxiluPgXIc9H/4DQnP4xkA7lKczhZiALJpIxlQJB9Man30qJX85h5y21f2HL1uY8GKI4L+YZm
        9Qomkw8DPMSIK9lek5+xFl/7Y29oUWjHtVg==
X-Received: by 2002:a17:90b:4c10:b0:1e8:d377:4998 with SMTP id na16-20020a17090b4c1000b001e8d3774998mr5217992pjb.227.1655220564074;
        Tue, 14 Jun 2022 08:29:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sZdEF+2ngSzsX6yHgG9QvZ6BkO/Axy64M7JP/4rbdl5qON9rBc6x4v5kIoMpqcL2nrMdrG4w==
X-Received: by 2002:a17:90b:4c10:b0:1e8:d377:4998 with SMTP id na16-20020a17090b4c1000b001e8d3774998mr5217973pjb.227.1655220563711;
        Tue, 14 Jun 2022 08:29:23 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b00163f7935772sm7420489plb.46.2022.06.14.08.29.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:29:23 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AE82B6093D; Tue, 14 Jun 2022 08:29:22 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A2403A0B36;
        Tue, 14 Jun 2022 08:29:22 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: Any reason why arp monitor keeps emitting netlink failover events?
In-reply-to: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com>
References: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Mon, 13 Jun 2022 22:59:31 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10583.1655220562.1@famine>
Date:   Tue, 14 Jun 2022 08:29:22 -0700
Message-ID: <10584.1655220562@famine>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On net-next/master from today, I see netlink failover events being emitted
>from an active-backup bond. In the ip monitor dump you can see the bond is
>up (according to the link status) but keeps emitting failover events and I
>am not sure why. This appears to be an issue also on Fedora 35 and CentOS
>8 kernels. The configuration appears to be correct, though I could be
>missing something. Thoughts?

	Anything showing up in the dmesg?  There's only one place that
generates the FAILOVER notifier, and it ought to have a corresponding
message in the kernel log.

	Also, I note that the link1_1 veth has a lot of failures:

>    bond_slave state BACKUP mii_status DOWN link_failure_count 466

	Perhaps the bridge within netns ns1 is disabling the port for
some reason?

	-J

>-Jon
>
>
>Upstream Commit:
>  c04245328dd7 net: make __sys_accept4_file() static
>
>Console Log:
>[root@fedora ~]# cat ./bond-bz2094911.sh
>#!/bin/sh
>
>set -e
>set -x
>
>dmesg -C
>ip -all netns delete || true
>ip link del link1_1 || true
>ip link del link2_1 || true
>modprobe -r bonding
>
>ip link add name link1_1 type veth peer name link1_2
>ip link add name link2_1 type veth peer name link2_2
>ip netns add ns1
>ip netns exec ns1 ip link add name br0 type bridge vlan_filtering 1
>ip link set link1_2 up netns ns1
>ip link set link2_2 up netns ns1
>ip netns exec ns1 ip link set link1_2 master br0
>ip netns exec ns1 ip link set link2_2 master br0
>ip netns exec ns1 ip addr add 192.168.30.5/24 dev br0
>ip netns exec ns1 ip addr add 192.168.30.7/24 dev br0
>ip netns exec ns1 ip link set br0 up
>ip link add name bond0 type bond mode active-backup arp_all_targets any \
>	arp_ip_target "192.168.30.7,192.168.30.5" arp_interval 1000 \
>	fail_over_mac follow arp_validate active primary_reselect always \
>	primary link1_1
>ip link set bond0 up
>ip addr add 192.168.30.10/24 dev bond0
>ifenslave bond0 link1_1 link2_1
>#ip -ts -o monitor link
>
>
>[root@fedora ~]# ip -ts -o monitor link dev bond0
>[2022-06-13T22:20:35.289034] [2022-06-13T22:20:35.289846]
>[2022-06-13T22:20:35.289978] [2022-06-13T22:20:35.290089]
>[2022-06-13T22:20:35.290200] [2022-06-13T22:20:35.290311] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-13T22:20:35.291055] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-13T22:20:35.324494] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-13T22:20:36.312078] [2022-06-13T22:20:36.312296]
>[2022-06-13T22:20:36.312549] [2022-06-13T22:20:36.312670]
>[2022-06-13T22:20:36.312782] [2022-06-13T22:20:36.312893] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-13T22:20:36.313134] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>[2022-06-13T22:20:36.346157] 14: bond0:
><BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd
>ff:ff:ff:ff:ff:ff
>
>[root@fedora tests]# ip -d link show dev bond0
>14: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>state UP mode DEFAULT group default qlen 1000
>    link/ether fe:5b:52:88:61:68 brd ff:ff:ff:ff:ff:ff promiscuity 0
>minmtu 68 maxmtu 65535
>    bond mode active-backup active_slave link1_1 miimon 0 updelay 0
>downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 1000
>arp_missed_max 2 arp_ip_target 192.168.30.7,192.168.30.5 arp_validate
>active arp_all_targets any primary link1_1 primary_reselect always
>fail_over_mac follow xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1
>all_slaves_active 0 min_links 0 lp_interval 1 packets_per_slave 1
>lacp_active on lacp_rate slow ad_select stable tlb_dynamic_lb 1
>addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536
>gso_max_segs 65535 gro_max_size 65536
>[root@fedora tests]#
>
>[root@fedora tests]# ip -d -s link show dev link1_1
>11: link1_1@if10: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>noqueue master bond0 state UP mode DEFAULT group default qlen 1000
>    link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1
>promiscuity 0 minmtu 68 maxmtu 65535
>    veth
>    bond_slave state BACKUP mii_status DOWN link_failure_count 466
>perm_hwaddr b6:19:b6:e3:29:c5 queue_id 0 addrgenmode eui64 numtxqueues 1
>numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
>    RX:  bytes packets errors dropped  missed   mcast
>        295004    5622      0       0       0       0
>    TX:  bytes packets errors dropped carrier collsns
>        254824    4678      0       0       0       0
>
>[root@fedora tests]# ip -d -s link show dev link2_1
>13: link2_1@if12: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>noqueue master bond0 state UP mode DEFAULT group default qlen 1000
>    link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1
>promiscuity 0 minmtu 68 maxmtu 65535
>    veth
>    bond_slave state BACKUP mii_status UP link_failure_count 0 perm_hwaddr
>aa:48:a3:a3:2b:2b queue_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1
>gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
>    RX:  bytes packets errors dropped  missed   mcast
>        303452    5776      0       0       0       0
>    TX:  bytes packets errors dropped carrier collsns
>        179592    2866      0       0       0       0
>
