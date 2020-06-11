Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248261F6D38
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgFKSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbgFKSKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 14:10:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17760C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:10:48 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c71so5791083wmd.5
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arctarus.co.uk; s=google;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PxWIg+cu5hCDhII2v9wbQ0ZMb7Qz2pZgUYtSEZ3xfeI=;
        b=erUTbztrj9ykdylcRa5sGr1YOUmpC8Cr8h4iSoqIrV7z9pcWePah/7I5XNvFhS1a2+
         cl/P7q6MNkhP0V2Of9YbozKF+d9cH09cSwAo0uZunW2rHzKLC3pJsX2a/Q7H8/lf2foj
         nuUgA1W3l2XNfpALXppNYs4DFQSHh4jY0P93csFNs512nZ7ZKsgbtnaGT7+fORWAbLeI
         lmqZHXscDYLnhCHbEtYDHVBzKtnJi5J8X7WRBQmp0SqR6EsJX+g0d5f+fdi8w+whq/oo
         suQH+kvedXhYkj+VqXPm9Bs+gc9ZEofE9QOTFiybjEkCtSUSIoBQJUQMiP4ZOsYQtdnw
         KfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PxWIg+cu5hCDhII2v9wbQ0ZMb7Qz2pZgUYtSEZ3xfeI=;
        b=cr7zhz1i/OxKEHhCEAUnEFVEQ0+bjGXhbtCmYQYiVaS+H/yaWCd8VYXO4tZEMHSZMr
         bVE7yE9FeFonw3v1FUK3jcA3mSgifZKYyQx6wPb9J/hzu6fI+e3CcDpA8siDvzyvgRIb
         IC8H6WhaUCOkzqvthZJn9qu8+s6i+dacyYWEN+9LuLB5mNhutdC2C2aESOVpT0NEvw1w
         TlC4YTumYoI6Q3dQkm2Iz7eH51oBNT6OUwsKTBacEk/dVz2wuJFgyA4ZTS+mpyRr3DrF
         aTtlE0/I4M648FFhujqbvtgRk27h7p2SRoiqRRJQLCJg+SCmWtOA3w1hfk2M8bLnbUk3
         RuQQ==
X-Gm-Message-State: AOAM531xhe+Z9WRvu78NMhWSMsMiBuhTKAFKYQE1gmjD3X6pJcrq1/hN
        X1hHBOQyrI8/z9tR21K9ETPztcKcLLb0aw==
X-Google-Smtp-Source: ABdhPJwLTQS74BQyiSamYGfvV4TP2Vqpf8tYLkMVwQOS+DgycSghEYWjRyiylQbeYmKCQjizWfdHcQ==
X-Received: by 2002:a1c:f401:: with SMTP id z1mr8908630wma.44.1591899046738;
        Thu, 11 Jun 2020 11:10:46 -0700 (PDT)
Received: from [10.8.16.15] ([194.75.207.226])
        by smtp.gmail.com with ESMTPSA id o20sm6553286wra.29.2020.06.11.11.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 11:10:46 -0700 (PDT)
Subject: PROBLEM: IPv4 route exception patch breaks BIRD2
From:   Joseph Marsden <joseph@arctarus.co.uk>
To:     davem@davemloft.net
References: <1d797541-3f4a-34fd-669c-0dad6dffd4e0@arctarus.co.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <8da4a321-a676-0464-f5cf-d467840dbfa7@arctarus.co.uk>
Date:   Thu, 11 Jun 2020 19:10:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1d797541-3f4a-34fd-669c-0dad6dffd4e0@arctarus.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

While upgrading my kernel from 5.2 to 5.4.43, I noticed a very sharp
increase in CPU usage - coming from BIRD, the routing daemon on my system.
I ran a Netlink capture and saw that BIRD was attempting to insert
routes twice into the kernel routing table. This was causing routes to
be re-inserted rapidly, and explained the increase of CPU usage.

I'm running IPv4 and IPv6 full tables - about 789,360 v4 routes and
78,185 v6 routes. About 10,000 routes fail to be re-inserted and this
number fluctuated over time as the routing table was updated. The routes
themselves are sourced from BGP peerings with upstreams on the router.

I tried downgrading BIRD itself several times before realising that it
must be a kernel issue, so I performed a bisect, and found this patch to
be the issue:

[PATCH net-next v7 04/11] ipv4: Dump route exceptions if requested
https://lore.kernel.org/netdev/8d3b68cd37fb5fddc470904cdd6793fcf480c6c1.1561131177.git.sbrivio@redhat.com/

When I added some debug logging to BIRD, I could see that before the
patch BIRD was not receiving any FIB exception routes, but after the
patch, it was receiving many.
I suspect this is unrelated to the bigger issue here - even if I patch
BIRD to reject these routes, the problem still occurs and BIRD keeps
trying to re-insert routes into the kernel routing table twice.

- Joseph

Extra information:
Kernel version: Linux version 5.4.43 (nixbld@localhost) (gcc version
9.2.0 (GCC)) #1-NixOS SMP Wed May 27 15:46:53 UTC 2020
Most recent kernel version which did not have the bug: 5.2.0
BIRD version I tested this on: 2.0.7 (also tested on 2.0.2 and other
older versions)

ver_linux output:
Linux bdr1 5.4.43 #1-NixOS SMP Wed May 27 15:46:53 UTC 2020 x86_64 GNU/Linux

Util-linux          	2.33.2
Mount               	2.33.2
Module-init-tools   	26
E2fsprogs           	1.45.5
Linux C Library     	2.30
Dynamic linker (ldd)	2.30
Procps              	3.3.16
Net-tools           	1.60
Kbd                 	2.0.4
Console-tools       	2.0.4
Sh-utils            	8.31
Udev                	243
Modules Loaded      	agpgart ata_generic ata_piix atkbd autofs4
bochs_drm bridge br_netfilter button cdrom crc16 crc32c_generic
crc_ccitt dm_mod drm drm_kms_helper drm_vram_helper dummy ehci_hcd evdev
ext4 failover fb_sys_fops floppy gre hid hid_generic i2c_core i2c_piix4
i8042 input_leds intel_agp intel_gtt ip6_gre ip6table_filter
ip6table_nat ip6table_raw ip6_tables ip6_tunnel iptable_filter
iptable_nat iptable_raw ip_tables ipv6 jbd2 joydev led_class libata
libcrc32c libps2 llc loop mac_hid macvlan mbcache mousedev net_failover
nf_conntrack nf_conntrack_netlink nf_defrag_ipv4 nf_defrag_ipv6
nf_log_common nf_log_ipv4 nf_log_ipv6 nf_nat nfnetlink overlay pata_acpi
psmouse qemu_fw_cfg rng_core rtc_cmos sch_fq_codel scsi_mod serio
serio_raw sr_mod stp syscopyarea sysfillrect sysimgblt tap ttm tun
tunnel6 uhci_hcd usb_common usbcore usbhid veth virtio virtio_balloon
virtio_blk virtio_console virtio_net virtio_pci virtio_ring virtio_rng
xfrm_algo xfrm_user x_tables xt_addrtype xt_conntrack xt_LOG
xt_MASQUERADE xt_multiport xt_nat xt_pkttype xt_tcpudp

