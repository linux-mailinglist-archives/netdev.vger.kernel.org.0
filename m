Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBF673F5A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjASQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjASQwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:52:39 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D6E8BABE
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:52:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so6440733pjm.1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJ0Dk3SwkoXVjWSvRClhCOZ4uG0qjTubdpBSn+5UIXE=;
        b=P5DC+k9ELyBfH6Ya24zQ6KI/31S+W9fYpXrcFaAo3k/KFff9zoJ3HWwHFkEkcZSaqT
         U2lrsEX5OKtYZnMNH6U8dHdVMIIEJH5yHLYnfZQB80uwzU2petk1bWQXUDpoDs8mLopB
         0nn030xmdEyncIdKcTQ89slBewmT7igeoQEii3umQNDE8tvPc4ORDC/2hYr0CX26llcE
         +++vrraps+G/XX9bMnRjTM8v27LIzONcaliZzw1vVuZC9pQckK2oiqGfiircp23uAC1u
         o/3tB1jXe7UhABlEn2+pnoJDHDJHDC3O2QVwIHrDNolAEHQG3J83+mqvcAEJwVXPIpaw
         k+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJ0Dk3SwkoXVjWSvRClhCOZ4uG0qjTubdpBSn+5UIXE=;
        b=7VRUdXslRWXD3D6F7yYKua47s23w1NfcwxMNL12gUbIuGpJBavFyvTDO/GgBIohh6N
         lvN4EiMIM4/QNI5y8YkdVuKPiq1G7YH3TMfZAT2tu9j3nVpASkZxQmlsKPlK0STwBlNY
         b2n7xZ51aR0qLapJfcvKiZ5yqcJ+HpuXJKADHPmCRkJoFUWLKPni4r2zoO6JvLyWiE9B
         Q++JC58Ir8zkeJK31PRUzO+mIVxPqxGQ2MN9VdkFPoRjb0SLurvaxGo44K/QOMEJ9mL8
         re1uwgB8cymWP5l/PT+dnHa2YYNDZLqyVb/LGLWE7BELQDrQd8BRvU/9JPgqtMX5KuN0
         ZBMg==
X-Gm-Message-State: AFqh2kq00rkhutWRmgvjtHVzO/AqqKygCFAgJQ4SHaGNVEqjTYox+3cV
        ztT7CLjWkEYoITxsbZUPUAvadlDZ9vzQfTow9U4=
X-Google-Smtp-Source: AMrXdXuzmD1ujFHWYsAG6nR/UzrZJkppChL6GAIo7eqUy0FXK3I+VCEEijRlzAoeaS9BgpN7vCcqYQ==
X-Received: by 2002:a05:6a21:6d92:b0:b0:3e0f:508d with SMTP id wl18-20020a056a216d9200b000b03e0f508dmr14990725pzb.55.1674147144895;
        Thu, 19 Jan 2023 08:52:24 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t21-20020a635355000000b0049f5da82b12sm20436331pgl.93.2023.01.19.08.52.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 08:52:24 -0800 (PST)
Date:   Thu, 19 Jan 2023 08:52:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216952] New: The most recent Raspberry Pi OS 64-bi 5.15.84
 Linux kernel seems not to forward any IPv4 packets even if
 net.ipv4.ip_forward=1 is set properly, NO ROUTER FUNCTIONALITY in kernel
Message-ID: <20230119085223.7cf16c57@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have my doubts that this is a kernel bug.

Begin forwarded message:

Date: Thu, 19 Jan 2023 14:17:16 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216952] New: The most recent Raspberry Pi OS 64-bi 5.15.84 Linux kernel seems not to forward any IPv4 packets even if net.ipv4.ip_forward=1 is set properly, NO ROUTER FUNCTIONALITY in kernel


https://bugzilla.kernel.org/show_bug.cgi?id=216952

            Bug ID: 216952
           Summary: The most recent Raspberry Pi OS 64-bi 5.15.84 Linux
                    kernel seems not to forward any IPv4 packets even if
                    net.ipv4.ip_forward=1 is set properly, NO ROUTER
                    FUNCTIONALITY in kernel
           Product: Networking
           Version: 2.5
    Kernel Version: Linux 5.15.84-v8+ #1613 SMP PREEMPT Thu Jan 5 12:03:08
                    GMT 2023 aarch64
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: tomkori@gmx.net
        Regression: No

I have produced some extensive documentation of my attempts of getting a
Raspberry Pi 4 4GB running the most Raspberry Pi OS 64-bit (Debian bullseye
arm64) and a WaveShare SIM8200EA M2 5G HAT modem working as a residential
gateway combination. I got the modem working and able to connect to the
internet on the Raspberry Pi 4 4 GB locally, but the packet forwarding seems to
not work at all. When tracerouting the packets, their path always ends at my
Raspberry Pi 4 4 GB supposed-to-be residential gateway without being forwarded
to the ISP-provided dynamic IP address and tiny network. I have made a summary
thread on the Raspberry Pi Forum containing firewall configuration,
/etc/sysctl.conf settings, ISC DHCP server configuration and routing tables:

https://forums.raspberrypi.com/viewtopic.php?t=346017

I have the following network configuration:

    1) a private network 192.168.1.0/24

    2) inside 192.168.1.0/24 an OpenWrt operated ethernet PoE+ DSA switch

    3) inside 192.168.1.0/24 an OpenWrt operated Wifi router which is connected
via its WAN interface to the ISP provided modem on 192.168.0.0/24 network. The
ISP modem does not allow anything, it is basically an intransparent bridge. The
Wifi router is running a DHCP server on its LAN interface containing the LAN
ports and it has another DHCP server running for managing the Wifi connections.

    4) my Raspberry Pi 4 4GB / WaveShare SIM8200EA-M2 5G HAT combination
running with a temporary SIM card, till i can replace the ISP provided modem by
it. The RPi/5G HAT has lo, eth0, wlan0, wwan0 (plus usb0 from thethering via
dwc2 and g_ether) interfaces and could be used as DMZ as such. The RPi/5G HAT
eth0 is connected to the Switch and has IP 192.168.1.1, which should be the
residential router/gateway IP. wlan0 is connected to the Wifi router. I have
configured a working nftables firewall filtering ICMP traffic for both IPv4 and
IPv6 that works nicely when i use the internet access locally on my RPi / 5G
HAT. wwan0 is the 5G HAT modem interface, which is configured via
NetworkManager (is it possible also via /etc/network/interfaces?) and
ModemManager and has a small private subnet assigned by DHCP from the ISP (my
ISP also allows for public dynamic IPs which are routable in the internet). I
have configured a static route from the RPI / 5G HAT to the Wifi router, such
that it can have internet access via the ISP modem, even when the 5G HAT is
turned off.

Now how can i get my RPi / 5G HAT to become a residential gateway to serve
internet access to the whole 192.168.1.0/24 home network including the Wifi
devices? When i install an ISC DHCP server on my RPi / 5G HAT, it always messes
up with the DHCP server of the Wifi router and the Wifi devices loose internet
connectivity. As far as i have understood, routing functionality in internal
networks is provided via DHCP and DNS server's as well as activation of ip
forwarding.

(Taken from https://forums.raspberrypi.com/viewtopic.php?t=346014)

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
