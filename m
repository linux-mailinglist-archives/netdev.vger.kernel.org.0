Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6231E5BD9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgE1J2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgE1J2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 05:28:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E319C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:28:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id s8so27062604wrt.9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=172udTlm8IWHiuigsnIJMwLagLWL5Ooey4uLMzOO7Zo=;
        b=RnskyQ8C1Xeq57i4wEE3ROwD2TxUTVU39RZqFK9L2I+8rMojgwwkqACfxXU/YHpVPN
         mRTpXYhl7mBJy7XAkyUWzgsOvZ8fW+BZrDAa0SnilrcZz/i87bZAi5dBY9qG/QBQYFbi
         JqTjYc80FfyXvyBTRoEhTTtmgLJg9/3xjdRyVS5Og+LxoFwnWlcaM+FaOmWPwYJ0SvvB
         bD+bbn4yfvUG3xm9P1Ry4z9zw+mJKvuFniPegbtcG1UZK9lLw8cyP/4A2ye9Mij2Uwsm
         axnwXsZ0eq6sNi7ScNrp38zZLvH0rnSr6rSFjrFJzQ/xdx5Z/vpuKzQntjOm1lhgPE2T
         Ylbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=172udTlm8IWHiuigsnIJMwLagLWL5Ooey4uLMzOO7Zo=;
        b=QH97UKvoj2e08tK3UuPY2G/HqzNBep5EcdlY0O/ruvyJUx1CbWhLiuQcZkovo1n19v
         5LF0Gwx9O5tW2bwDqtFfs0asEkT/3oC7QJBPJgAA41zqsAwsgFD+ZXEWDAG80GDZWV9k
         SzeNrIwNaQLS6xP6lWKIPMluP+QknWuRXkq+gugPOyr2gWkt0eEvDYqm8suwLxDj1vQc
         QvCBFMOquWLbpv+qgBnAVE4UdUCdAVLI1UZsBWoij+VUGPy1VclCGKIos3XcJ3EQ1iZK
         Rex5az0pl+ZtsKYZ7umkJ043edh+Ap5KLnvefLgJyoixvB/9IQn7A+7903K+NUlryQZ/
         S+yQ==
X-Gm-Message-State: AOAM530gjSTe7wd9DxCRe75LbYC55xNB/AMPevulrt3CLl+ryOcd/PEK
        hVKNNIJgcmgBa5XKzejb8WeldXIs
X-Google-Smtp-Source: ABdhPJwlRKDwGYTPaotm9+fke5ISZFZ/HDkkrqTlijbRlGbAwRJ+RK0E6TYRuvkaPrC5wPTfkti9Nw==
X-Received: by 2002:adf:df91:: with SMTP id z17mr2582035wrl.273.1590658116681;
        Thu, 28 May 2020 02:28:36 -0700 (PDT)
Received: from ?IPv6:2a00:23c5:e10f:4100:bea8:a6ff:fe72:e4df? ([2a00:23c5:e10f:4100:bea8:a6ff:fe72:e4df])
        by smtp.gmail.com with ESMTPSA id u74sm5584676wmu.13.2020.05.28.02.28.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 02:28:36 -0700 (PDT)
From:   Kai Wohlfahrt <kai.wohlfahrt@gmail.com>
Subject: Packets to own IP are sent via IPSec tunnel with IPv6
To:     netdev@vger.kernel.org
Message-ID: <fb957019-d1d7-959b-6366-ef27f7aa8e82@gmail.com>
Date:   Thu, 28 May 2020 10:28:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I noticed strange behaviour with an IPSec tunnel set up with strongswan.
Discussing the issue on IRC, a strongswan developer suggested the issue
is due to a kernel bug and I should ask here.

The client connects to the server and is assigned an IPv6 address
from a pool. The remote traffic selector of the tunnel includes this
virtual IP so that multiple clients can communicate. However, when the
client tries to ping its own virtual IP, traffic goes over the tunnel
instead of via the loopback adapter (this shows in the TTL of the
packet, latency > 1ms and strongswan's traffic counters). If the virtual
IP addresses are IPv4, this issue does not occur. I'm running kernel
5.4.41 and strongswan 5.8.1. The output of relevant commands is included
below (IPs snipped), with more information including strongswan and
kernel config at [1].

On suggestion of strongswan developers, I tried to set
`net.ipv6.conf.lo.disable_policy=1`, this made no visible difference. Is
this a kernel bug, or other issue? I'm happy to help debug or test other
configurations.

Many thanks,
Kai

[1]: https://gist.github.com/kwohlfahrt/6db96db25e44ae208178335b2cdb9523/0d14b393d659c9adce6a8c925656dd6b90dc65e0

$ ip -6 addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN qlen 1000
     inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
     inet6 fd01::3/128 scope global nodad
        valid_lft forever preferred_lft forever
     inet6 2a00::e4df/64 scope global dynamic mngtmpaddr noprefixroute
        valid_lft 315359984sec preferred_lft 315359984sec
     inet6 fdaa::e4df/64 scope global mngtmpaddr noprefixroute
        valid_lft forever preferred_lft forever
     inet6 fe80::e4df/64 scope link
        valid_lft forever preferred_lft forever

$ ping -c3 fd01::3
PING fd01::3(fd01::3) 56 data bytes
64 bytes from fd01:: icmp_seq=1 ttl=63 time=306 ms
64 bytes from fd01:: icmp_seq=2 ttl=63 time=6.64 ms
64 bytes from fd01:: icmp_seq=3 ttl=63 time=8.02 ms

--- fd01::3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 6.636/106.842/305.875/140.738 ms

$ ip -6 route show table all
fd01::/64 via 2a00::280e dev wlp3s0 table 220 proto static src fd01::3 metric 1024 pref medium
fdaa:::/64 via 2a00::280e dev wlp3s0 table 220 proto static src fd01::3 metric 1024 pref medium
::1 dev lo proto kernel metric 256 pref medium
2a00:::/64 dev wlp3s0 proto ra metric 303 mtu 1488 pref medium
fd01::3 dev wlp3s0 proto kernel metric 256 pref medium
fdaa:::/64 dev wlp3s0 proto ra metric 303 mtu 1488 pref medium
fe80::/64 dev wlp3s0 proto kernel metric 256 pref medium
default via fe80::44af dev wlp3s0 proto ra metric 303 mtu 1488 pref medium
local ::1 dev lo table local proto kernel metric 0 pref medium
local 2a00::e4df dev wlp3s0 table local proto kernel metric 0 pref medium
local fd01::3 dev wlp3s0 table local proto kernel metric 0 pref medium
local fdaa::e4df dev wlp3s0 table local proto kernel metric 0 pref medium
local fe80::e4df dev wlp3s0 table local proto kernel metric 0 pref medium
ff00::/8 dev wlp3s0 table local metric 256 pref medium
ff00::/8 dev enp4s0 table local metric 256 linkdown pref medium

$ ip -6 xfrm policy
src fd01::3/128 dst fdaa:::/64
	dir out priority 301695
	tmpl src 2a00::e4df dst 2a00::280e
		proto esp spi 0xc0a4e6ee reqid 3 mode tunnel
src fd01::3/128 dst fd01::/64
	dir out priority 301695
	tmpl src 2a00::e4df dst 2a00::280e
		proto esp spi 0xc0a4e6ee reqid 3 mode tunnel
src fdaa:::/64 dst fd01::3/128
	dir fwd priority 301695
	tmpl src 2a00::280e dst 2a00::e4df
		proto esp reqid 3 mode tunnel
src fdaa:::/64 dst fd01::3/128
	dir in priority 301695
	tmpl src 2a00::280e dst 2a00::e4df
		proto esp reqid 3 mode tunnel
src fd01::/64 dst fd01::3/128
	dir fwd priority 301695
	tmpl src 2a00::280e dst 2a00::e4df
		proto esp reqid 3 mode tunnel
src fd01::/64 dst fd01::3/128
	dir in priority 301695
	tmpl src 2a00::280e dst 2a00::e4df
		proto esp reqid 3 mode tunnel
src ::/0 dst ::/0
	socket in priority 0
src ::/0 dst ::/0
	socket out priority 0
src ::/0 dst ::/0
	socket in priority 0
src ::/0 dst ::/0
	socket out priority 0
