Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239CA54A747
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbiFNDB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 23:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355401AbiFNDBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 23:01:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F5626D6
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 19:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655175575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fqDH5+bqkC6MVDWQgEjnIxbATk0KnyuimZo0Hqi+gto=;
        b=Ag7Um5WTu2992B5+4q7X9pOLT9xi+WxQHVpoHmqyByGWYhy7gsEGGTnc3gOQfyfdKLZdNN
        D5WKYN1nigrjChehs7bwRYBUiBSZnHtQWDfDEyXijmok2rVAUayvw1hZsCdIobhjQILoc+
        KX/5Czx4dpE/hlxMWbxOo58KpsKPsTo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-RRW8lEnXP9m48uCPzaQImw-1; Mon, 13 Jun 2022 22:59:33 -0400
X-MC-Unique: RRW8lEnXP9m48uCPzaQImw-1
Received: by mail-qt1-f197.google.com with SMTP id m6-20020ac866c6000000b002f52f9fb4edso5654405qtp.19
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 19:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=fqDH5+bqkC6MVDWQgEjnIxbATk0KnyuimZo0Hqi+gto=;
        b=Jf0scXB9/7i/dGCwBiPsFXxiCZoOv+dHOClzipfU3o3BwOJO9i5UJwMncabMsvYhS4
         zLvu+UgzmrelBU9a21gpr/4HsXa07FF5E5tKemZEPF57Ieyq+JVCWkcjuanZHuVFN0DS
         Asmz3SiR82E4HuT0SVlNZQzQRGpcqYgMSVJY4smkck1oUhIvAUBLDPrE2wrn19R9qan0
         oHpT5DXPyDWD+oE1dSL0uGsgbSCWbP8Zh8qPBcwkYXVrLPyzVg0xup9j7oFjVK7XuXE8
         afLkwXJIdEgKQ5cqeVCaq/8sMuR4Rd+tPoZ9JKK0ELbH8v5qdTjEp/RwVXMUiWJqkj/Z
         tzWw==
X-Gm-Message-State: AOAM533BhTXKFgL7dBqksw+OHxNJPpJCds8BNrbxRzblmYT/xecRCY8Y
        qti+ES3+Ls535eUDGPktNtG6cuykHad5uPthB2LroKn8mbvOUYQGtUpc9+EtYqGtnuN4hOakRtk
        0h1u01AG/bozbvWBZet0wASXppx225q7L3a/Jt/g2/7tikcFWrct49xlDx+MWuEGae8sP
X-Received: by 2002:a05:622a:1ba7:b0:304:c8f9:63aa with SMTP id bp39-20020a05622a1ba700b00304c8f963aamr2560204qtb.98.1655175573062;
        Mon, 13 Jun 2022 19:59:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+pujV+PFE7xwi9R3NZEKN0IuCHol7Rhx8a1qpLnxjsgizqG7k2/UyB1TL576xpnfgcaHMJg==
X-Received: by 2002:a05:622a:1ba7:b0:304:c8f9:63aa with SMTP id bp39-20020a05622a1ba700b00304c8f963aamr2560186qtb.98.1655175572778;
        Mon, 13 Jun 2022 19:59:32 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id z10-20020a05622a124a00b00304fe5247bfsm6362398qtx.36.2022.06.13.19.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 19:59:32 -0700 (PDT)
Message-ID: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com>
Date:   Mon, 13 Jun 2022 22:59:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Subject: Any reason why arp monitor keeps emitting netlink failover events?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On net-next/master from today, I see netlink failover events being 
emitted from an active-backup bond. In the ip monitor dump you can see 
the bond is up (according to the link status) but keeps emitting 
failover events and I am not sure why. This appears to be an issue also 
on Fedora 35 and CentOS 8 kernels. The configuration appears to be 
correct, though I could be missing something. Thoughts?

-Jon


Upstream Commit:
   c04245328dd7 net: make __sys_accept4_file() static

Console Log:
[root@fedora ~]# cat ./bond-bz2094911.sh
#!/bin/sh

set -e
set -x

dmesg -C
ip -all netns delete || true
ip link del link1_1 || true
ip link del link2_1 || true
modprobe -r bonding

ip link add name link1_1 type veth peer name link1_2
ip link add name link2_1 type veth peer name link2_2
ip netns add ns1
ip netns exec ns1 ip link add name br0 type bridge vlan_filtering 1
ip link set link1_2 up netns ns1
ip link set link2_2 up netns ns1
ip netns exec ns1 ip link set link1_2 master br0
ip netns exec ns1 ip link set link2_2 master br0
ip netns exec ns1 ip addr add 192.168.30.5/24 dev br0
ip netns exec ns1 ip addr add 192.168.30.7/24 dev br0
ip netns exec ns1 ip link set br0 up
ip link add name bond0 type bond mode active-backup arp_all_targets any \
	arp_ip_target "192.168.30.7,192.168.30.5" arp_interval 1000 \
	fail_over_mac follow arp_validate active primary_reselect always \
	primary link1_1
ip link set bond0 up
ip addr add 192.168.30.10/24 dev bond0
ifenslave bond0 link1_1 link2_1
#ip -ts -o monitor link


[root@fedora ~]# ip -ts -o monitor link dev bond0
[2022-06-13T22:20:35.289034] [2022-06-13T22:20:35.289846] 
[2022-06-13T22:20:35.289978] [2022-06-13T22:20:35.290089] 
[2022-06-13T22:20:35.290200] [2022-06-13T22:20:35.290311] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 
brd ff:ff:ff:ff:ff:ff
[2022-06-13T22:20:35.291055] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd 
ff:ff:ff:ff:ff:ff
[2022-06-13T22:20:35.324494] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd 
ff:ff:ff:ff:ff:ff
[2022-06-13T22:20:36.312078] [2022-06-13T22:20:36.312296] 
[2022-06-13T22:20:36.312549] [2022-06-13T22:20:36.312670] 
[2022-06-13T22:20:36.312782] [2022-06-13T22:20:36.312893] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event BONDING FAILOVER \    link/ether fe:5b:52:88:61:68 
brd ff:ff:ff:ff:ff:ff
[2022-06-13T22:20:36.313134] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether fe:5b:52:88:61:68 brd 
ff:ff:ff:ff:ff:ff
[2022-06-13T22:20:36.346157] 14: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event RESEND IGMP \    link/ether fe:5b:52:88:61:68 brd 
ff:ff:ff:ff:ff:ff

[root@fedora tests]# ip -d link show dev bond0
14: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc 
noqueue state UP mode DEFAULT group default qlen 1000
     link/ether fe:5b:52:88:61:68 brd ff:ff:ff:ff:ff:ff promiscuity 0 
minmtu 68 maxmtu 65535
     bond mode active-backup active_slave link1_1 miimon 0 updelay 0 
downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 1000 
arp_missed_max 2 arp_ip_target 192.168.30.7,192.168.30.5 arp_validate 
active arp_all_targets any primary link1_1 primary_reselect always 
fail_over_mac follow xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 
1 all_slaves_active 0 min_links 0 lp_interval 1 packets_per_slave 1 
lacp_active on lacp_rate slow ad_select stable tlb_dynamic_lb 1 
addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 
gso_max_segs 65535 gro_max_size 65536
[root@fedora tests]#

[root@fedora tests]# ip -d -s link show dev link1_1
11: link1_1@if10: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc 
noqueue master bond0 state UP mode DEFAULT group default qlen 1000
     link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1 
promiscuity 0 minmtu 68 maxmtu 65535
     veth
     bond_slave state BACKUP mii_status DOWN link_failure_count 466 
perm_hwaddr b6:19:b6:e3:29:c5 queue_id 0 addrgenmode eui64 numtxqueues 1 
numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
     RX:  bytes packets errors dropped  missed   mcast
         295004    5622      0       0       0       0
     TX:  bytes packets errors dropped carrier collsns
         254824    4678      0       0       0       0

[root@fedora tests]# ip -d -s link show dev link2_1
13: link2_1@if12: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc 
noqueue master bond0 state UP mode DEFAULT group default qlen 1000
     link/ether aa:48:a3:a3:2b:2b brd ff:ff:ff:ff:ff:ff link-netns ns1 
promiscuity 0 minmtu 68 maxmtu 65535
     veth
     bond_slave state BACKUP mii_status UP link_failure_count 0 
perm_hwaddr aa:48:a3:a3:2b:2b queue_id 0 addrgenmode eui64 numtxqueues 1 
numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536
     RX:  bytes packets errors dropped  missed   mcast
         303452    5776      0       0       0       0
     TX:  bytes packets errors dropped carrier collsns
         179592    2866      0       0       0       0

